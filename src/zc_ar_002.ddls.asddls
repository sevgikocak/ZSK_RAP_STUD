@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for Academic Result'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_AR_002 as projection on ZI_AR_002
{  @EndUserText.label: 'Id'
    key Id,
    @EndUserText.label: 'Course'
     Course,
    @EndUserText.label: 'Semester'
     Semester,
     @EndUserText.label: 'Course Desc'
    course_desc,
     @EndUserText.label: 'Semester Desc'
    semester_desc,
     @EndUserText.label: 'Result'
    Semresult,
     @EndUserText.label: 'Result Desc'
    semres_desc,
    /* Associations */
   _student : redirected to parent ZC_STUDENT_002
    
}
