global class LOG3084Outer {
  global class MyParser implements pharos.IErrorParser {
    private String body; private String subject;
    global void init(String errorBody, String emailSubject, String emailSentFrom) { body = errorBody; subject = emailSubject; }
    global Boolean canProcess() { return subject != null && subject.contains('[LOG3084]'); }
    global void process() {}
    global String getError() { return 'LOG3084 test error'; }
    global String getErrorSummary() { return 'Parsed by LOG3084Outer.MyParser | ' + subject; }
    global String getErrorDetails() { return body; }
    global String getVisualforcePage() { return null; }
    global String getRelatedId() { return null; }
    global String getRelatedObjectType() { return null; }
    global String getAsyncJobName() { return null; }
    global String getAsyncJobId() { return null; }
    global String getErrorType() { return 'LOG3084'; }
    global String getArea() { return 'Apex'; }
    global String getUserId() { return UserInfo.getUserId(); }
    global String getOrganizationId() { return UserInfo.getOrganizationId(); }
    global String getStackTrace() { return null; }
    global String parseStackTrace() { return null; }
    global String getMethodName() { return null; }
    global String getHash1() { return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf('LOG3084Outer.MyParser' + subject))); }
    global String getHash2() { return getHash1(); }
    global String getHash3() { return getHash1(); }
    global String getPendingJobsInfo() { return null; }
    global Decimal getTotalActiveSessions() { return null; }
    global String getAuditTrail() { return null; }
    global String getInstalledPackagesInfo() { return null; }
    global String getNamespace() { return null; }
    global String getDeploymentsInfo() { return null; }
    global String getFlowVersion() { return null; }
    global String getSalesforceErrorId() { return null; }
    global List<pharos.ICustomErrorInfo> getCustomInfo() { return new List<pharos.ICustomErrorInfo>(); }
    global List<System.Queueable> getAsyncMethods(Id logId) { return new List<System.Queueable>(); }
  }
  global class NotAParser {}
}