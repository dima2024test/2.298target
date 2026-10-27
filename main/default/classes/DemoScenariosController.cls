public with sharing class DemoScenariosController {

    private static final String SIMPLE_APEX_TRIGGER_SCENARIO = 'Simple Apex Trigger',
            APEX_BATCH_JOB_SCENARIO = 'Apex Batch Job',
            APEX_BATCH_JOB_WITH_CACHE_SCENARIO = 'Apex Batch Job withCache()',
            APEX_TRIGGER_AUTOLAUNCHED_FLOW_SCENARIO = 'Apex Trigger + Autolaunched Flow',
            LWC_AND_APEX_WITH_CACHE_SCENARIO = 'LWC and Apex withCache()',
            INTEGRATION_ERROR_LOGGING_SCENARIO = 'Integration Error Logging',
            DML_RESULT_LOGGING_SCENARIO = 'DML Result Logging',
            EXCEPTION_HANDLING_WITH_RELATED_RECORDS_SCENARIO = 'Exception Handling with Related Records',
            QUEUEABLE_ASYNC_APEX_SCENARIO = 'Queueable/Async Apex',
            LWC_PERFORMANCE_TRACKING_SCENARIO = 'LWC Performance Tracking',
            FLOW_INTEGRATION_SCENARIO = 'Flow Integration',
            COMPLEX_SCENARIO = 'Complex';

    public static final String SIMPLE_APEX_TRIGGER_SCENARIO_ID = 'simple-apex-trigger',
            APEX_BATCH_JOB_SCENARIO_ID = 'apex-batch-job',
            APEX_BATCH_JOB_WITH_CACHE_SCENARIO_ID = 'apex-batch-job-with-cache',
            APEX_TRIGGER_AUTOLAUNCHED_FLOW_SCENARIO_ID = 'apex-trigger-autolaunched-flow',
            LWC_AND_APEX_WITH_CACHE_SCENARIO_ID = 'lwc-and-apex-with-cache',
            INTEGRATION_ERROR_LOGGING_SCENARIO_ID = 'integration-error-logging',
            DML_RESULT_LOGGING_SCENARIO_ID = 'dml-result-logging',
            EXCEPTION_HANDLING_WITH_RELATED_RECORDS_SCENARIO_ID = 'exception-handling-with-related-records',
            QUEUEABLE_ASYNC_APEX_SCENARIO_ID = 'queueable-async-apex',
            LWC_PERFORMANCE_TRACKING_SCENARIO_ID = 'lwc-performance-tracking',
            FLOW_INTEGRATION_SCENARIO_ID = 'flow-integration',
            COMPLEX_SCENARIO_ID = 'complex';


    public static String TRITON_DEMO_SCENARIO_TRIGGER = 'Triton Demo Scenario (Trigger)';
    public static String TRITON_DEMO_SCENARIO_BATCH = 'Triton Demo Scenario (Batch)';
    public static String TRITON_DEMO_SCENARIO_STATEFUL_BATCH = 'Triton Demo Scenario (Stateful Batch)';
    public static String TRITON_DEMO_SCENARIO_TRIGGER_FLOW = 'Triton Demo Scenario (Trigger + Flow)';
    public static String TRITON_DEMO_SCENARIO_LWC_AND_APEX = 'Triton Demo Scenario (LWC + Apex)';
    public static String TRITON_DEMO_SCENARIO_INTEGRATION = 'Triton Demo Scenario (Integration)';
    public static String TRITON_DEMO_SCENARIO_DML_RESULT = 'Triton Demo Scenario (DML Result)';
    public static String TRITON_DEMO_SCENARIO_RELATED_RECORDS = 'Triton Demo Scenario (Related Records)';
    public static String TRITON_DEMO_SCENARIO_FLOW_INTEGRATION = 'Triton Demo Scenario (Flow Integration)';
    public static String TRITON_DEMO_SCENARIO_QUEUEABLE = 'Triton Demo Scenario (Queueable)';
    public static String TRITON_DEMO_SCENARIO_COMPLEX = 'Triton Demo Scenario (Complex)';

    private static final String BASE_URL = System.Url.getOrgDomainUrl().toExternalForm();
    private static final String TOOLING_API_ENDPOINT = BASE_URL + '/services/data/v53.0/tooling/query?q=';
    private static final String METHOD_GET = 'GET';

    private static Map<String, String> AUTHORIZATION_HEADERS = new Map<String, String>{
            'Authorization' => 'Bearer ' + UserInfo.getSessionId()
    };

    @AuraEnabled
    public static pharos__Log__c getLog(String scenarioId, String strDatetime) {
        List<pharos__Log__c> logs = [
                SELECT Id, Name
                FROM pharos__Log__c
                WHERE pharos__Type__c = :scenarioId
                AND CreatedDate >= :Datetime.valueOfGmt(strDatetime)
                AND pharos__Is_Parent__c = TRUE
                ORDER BY CreatedDate DESC
                LIMIT 1
        ];
        if (!logs.isEmpty()) {
            return logs[0];
        }
        return null;
    }

    @AuraEnabled
    public static String getTransactionId() {
        return Triton.startTransaction();
    }

    @AuraEnabled
    public static String generateScenario(String scenarioId) {
        String result = String.valueOfGmt(System.now());
        if (scenarioId.equals(SIMPLE_APEX_TRIGGER_SCENARIO_ID)) {
            scenarioTriggerError();
        } else if (scenarioId.equals(APEX_BATCH_JOB_SCENARIO_ID)) {
            scenarioApexJobError();
        } else if (scenarioId.equals(APEX_BATCH_JOB_WITH_CACHE_SCENARIO_ID)) {
            scenarioApexJobWithCacheError();
        } else if (scenarioId.equals(APEX_TRIGGER_AUTOLAUNCHED_FLOW_SCENARIO_ID)) {
            scenarioApexTriggerAutolaunchedFlow();
        } else if (scenarioId.equals(LWC_AND_APEX_WITH_CACHE_SCENARIO_ID)) {
            scenarioLwcAndApexWithCache();
        } else if (scenarioId.equals(INTEGRATION_ERROR_LOGGING_SCENARIO_ID)) {
            scenarioIntegrationErrorLogging();
        } else if (scenarioId.equals(DML_RESULT_LOGGING_SCENARIO_ID)) {
            scenarioDMLResult();
        } else if (scenarioId.equals(EXCEPTION_HANDLING_WITH_RELATED_RECORDS_SCENARIO_ID)) {
            scenarioExceptionHandlingWithRelatedRecords();
        } else if (scenarioId.equals(QUEUEABLE_ASYNC_APEX_SCENARIO_ID)) {
            scenarioQueueableError();
        } else if (scenarioId.equals(LWC_PERFORMANCE_TRACKING_SCENARIO_ID)) {
            scenarioLwcPerformanceTracking();
        } else if (scenarioId.equals(FLOW_INTEGRATION_SCENARIO_ID)) {
            scenarioFlowIntegration();
        } else if (scenarioId.equals(COMPLEX_SCENARIO_ID)) {
            scenarioComplex();
        }
        return result;
    }

    public static void scenarioTriggerError() {
        Triton.startTransaction();
        TritonBuilder template = Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(SIMPLE_APEX_TRIGGER_SCENARIO_ID)
                .area(TritonTypes.Area.Community);
        Triton.setTemplate(template);

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_TRIGGER + ' - Controller')
                        .debug()
        );

        try {
            Triton_Error_Data__c tritonErrorData = new Triton_Error_Data__c();
            tritonErrorData.Description__c = TRITON_DEMO_SCENARIO_TRIGGER;
            insert tritonErrorData;
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
    }

    public static void scenarioApexJobError() {
        String transactionId = Triton.startTransaction();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(APEX_BATCH_JOB_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_STATEFUL_BATCH + ' - Controller')
                        .debug()
        );

        Database.executeBatch(new DemoScenariosStatefulBatch(transactionId), 1);
    }

    public static void scenarioApexJobWithCacheError() {
        Triton.withCache();
        Triton.startTransaction();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(APEX_BATCH_JOB_WITH_CACHE_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_BATCH + ' - Controller')
                        .debug()
        );

        Database.executeBatch(new DemoScenariosBatch(), 1);
    }

    public static void scenarioApexTriggerAutolaunchedFlow() {
        Triton.withCache();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(APEX_TRIGGER_AUTOLAUNCHED_FLOW_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_TRIGGER_FLOW + ' - Controller')
                        .debug()
        );

        try {
            Triton_Error_Data__c tritonErrorData = new Triton_Error_Data__c();
            tritonErrorData.Description__c = TRITON_DEMO_SCENARIO_TRIGGER_FLOW;
            insert tritonErrorData;
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
        Triton.stopTransaction();
    }

    public static void scenarioLwcAndApexWithCache() {
        Triton.withCache();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(LWC_AND_APEX_WITH_CACHE_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_LWC_AND_APEX + ' - Controller')
                        .debug()
        );
        Triton.stopTransaction();
    }

    public static void scenarioIntegrationErrorLogging() {
        Triton.withCache();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(INTEGRATION_ERROR_LOGGING_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_INTEGRATION + ' - Controller')
                        .debug()
        );

        try {
            List<Triton_Error_Data__c> tritonErrorDataRecords = [SELECT Id FROM Triton_Error_Data__c LIMIT 1];
            if (!tritonErrorDataRecords.isEmpty()) {
                update tritonErrorDataRecords;
            }
            String query = 'SELECT Id FROM AsyncApexJob LIMIT 5';
            AUTHORIZATION_HEADERS.putAll(getHeadersContentTypeJSON());
            httpRequest(
                    TOOLING_API_ENDPOINT + EncodingUtil.urlEncode(query, 'UTF-8'),
                    METHOD_GET,
                    AUTHORIZATION_HEADERS,
                    null
            );
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
        Triton.stopTransaction();
    }

    public static void scenarioDMLResult() {
        Triton.startTransaction();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(DML_RESULT_LOGGING_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_DML_RESULT + ' - Controller')
                        .debug()
        );

        try {
            Triton_Error_Data__c tritonErrorData = new Triton_Error_Data__c();
            tritonErrorData.Description__c = TRITON_DEMO_SCENARIO_TRIGGER;
            List<Database.SaveResult> saveResults = Database.insert(new List<Triton_Error_Data__c>{tritonErrorData}, false);
            Triton.logNow(Triton.fromTemplate()
                    .type(TritonTypes.Type.DMLResult)
                    .dmlResults(saveResults));
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
    }

    public static void scenarioExceptionHandlingWithRelatedRecords() {
        Triton.withCache();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(EXCEPTION_HANDLING_WITH_RELATED_RECORDS_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_RELATED_RECORDS + ' - Controller')
                        .debug()
        );

        Triton_Error_Data__c tritonErrorData = new Triton_Error_Data__c();
        tritonErrorData.Description__c = TRITON_DEMO_SCENARIO_RELATED_RECORDS;
        insert tritonErrorData;
        Set<String> relatedIds = new Set<String>{tritonErrorData.Id};
        try {
            Integer result = 10 / 0;
        } catch (Exception e) {
            Triton.log(Triton.fromTemplate()
                    .exception(e)
                    .relatedObjects(relatedIds));
            Triton.flush();
        }
    }

    public static void scenarioQueueableError() {
        String transactionId = Triton.startTransaction();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(QUEUEABLE_ASYNC_APEX_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_QUEUEABLE + ' - Controller')
                        .debug()
        );

        System.enqueueJob(new DemoScenariosQueueable(transactionId));
    }

    public static void scenarioLwcPerformanceTracking() {
        // Frontend-only scenario: all logging (debug + performance marks) is
        // produced by the LWC Triton library within the browser transaction.
        // No backend log is created here to avoid an orphaned Apex/Community
        // log in a separate transaction from the frontend chain.
    }

    public static void scenarioFlowIntegration() {
        Triton.withCache();
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(FLOW_INTEGRATION_SCENARIO_ID)
                .area(TritonTypes.Area.Community));

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_FLOW_INTEGRATION + ' - Controller')
                        .debug()
        );

        Flow.Interview.Flow_4_Error flowInterview = new Flow.Interview.Flow_4_Error(new Map<String, Object>());
        flowInterview.start();
        Triton.stopTransaction();
    }

    public static void scenarioComplex() {
        Triton.withCache();
        TritonBuilder template = Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(COMPLEX_SCENARIO_ID)
                .area(TritonTypes.Area.Community);
        Triton.setTemplate(template);

        Triton.logNow(
                Triton.fromTemplate()
                        .summary(TRITON_DEMO_SCENARIO_COMPLEX + ' - Controller')
                        .debug()
        );

        try {
            Triton_Error_Data__c tritonErrorData = new Triton_Error_Data__c();
            tritonErrorData.Description__c = TRITON_DEMO_SCENARIO_COMPLEX;
            insert tritonErrorData;
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
        Triton.stopTransaction();
    }

    @InvocableMethod(Category='TritonDemo' Label='Flow Integration')
    public static void scenarioFlowIntegrationInvocable() {
        Triton.setTemplate(Triton.makeBuilder()
                .category(TritonTypes.Category.Apex)
                .type(TritonTypes.Type.Backend)
                .area(TritonTypes.Area.Community));
        try {
            List<Triton_Error_Data__c> tritonErrorDataRecords = [SELECT Id FROM Triton_Error_Data__c LIMIT 1];
            if (!tritonErrorDataRecords.isEmpty()) {
                update tritonErrorDataRecords;
            }
            String query = 'SELECT Id FROM AsyncApexJob LIMIT 5';
            AUTHORIZATION_HEADERS.putAll(getHeadersContentTypeJSON());
            httpRequest(
                    TOOLING_API_ENDPOINT + EncodingUtil.urlEncode(query, 'UTF-8'),
                    METHOD_GET,
                    AUTHORIZATION_HEADERS,
                    null
            );
        } catch (Exception e) {
            Triton.logNow(
                    Triton.fromTemplate()
                            .exception(e)
            );
        }
    }

    private static Map<String, String> getHeadersContentTypeJSON() {
        return new Map<String, String>{
                'Content-Type' => 'application/json'
        };
    }

    private static String httpRequest(String endpoint, String method, Map<String, String> headers, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        if (headers != null) {
            for (String key : headers.keySet()) {
                req.setHeader(key, headers.get(key));
            }
        }
        if (String.isNotBlank(body)) req.setBody(body);
        req.setTimeout(120000);
        Http h = new Http();
        HttpResponse res;
        try {
            res = h.send(req);
        } catch (Exception e) {
            Triton.logNow(Triton.makeBuilder()
                    .category(TritonTypes.Category.Integration)
                    .area(TritonTypes.Area.Community)
                    .exception(e)
                    .integrationPayload(req, res));
        }
        if (res != null && res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            Triton.logNow(Triton.makeBuilder()
                    .category(TritonTypes.Category.Integration)
                    .type(TritonTypes.Type.Backend)
                    .area(TritonTypes.Area.Community)
                    .summary(res.getStatus())
                    .details(res.getStatus())
                    .integrationPayload(req, res)
                    .error());
        }
        return res != null ? res.getBody() : null;
    }

}