@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Entity View for Student'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_STUDENT_002
  provider contract transactional_query as projection on ZI_STUDENT_002 as Student
{
   @EndUserText.label: 'Student Id'
    key Id,
    @EndUserText.label: 'Firstname'
    Firstname,
    @EndUserText.label: 'Lastname'
    Lastname,
    @EndUserText.label: 'Age'
    Age,
    @EndUserText.label: 'Course'
    Course,
    @EndUserText.label: 'Course Duration'
    Courseduration,
    @EndUserText.label: 'Status'
    Status,
    @EndUserText.label: 'Gender'
    Gender,
    Genderdesc,
    @EndUserText.label: 'DOB'
    Dob,
    Lastchangedat,
    Locallastchagedat,
    _gender,
    _academires : redirected to composition child ZC_AR_002
}
