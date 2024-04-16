@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Entity View for Student'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_STUDENT_002 as select from zsk_rap_002
composition [0..*] of ZI_AR_002 as _academires
 association to ZI_GENDER_002   as _gender   on $projection.Gender = _gender.Value
 association to ZI_COURSE_002   as _course   on $projection.Course = _course.Value
{
    key id as Id,
    firstname as Firstname,
    lastname as Lastname,
    age as Age,
    course as Course,
    courseduration as Courseduration,
    status as Status,
    gender as Gender,
    dob as Dob,
    lastchangedat as Lastchangedat,
    locallastchagedat as Locallastchagedat,
    _gender,
    //_course.Description   as Course,
    _gender.Description as Genderdesc, 
    _academires,
    _course 
}
