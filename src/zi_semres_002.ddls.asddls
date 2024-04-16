@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain read semester result'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SEMRES_002 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZSK_SEMRES' )
{
    key domain_name,
    key value_position,
    @Semantics.language: true
    key language,
    value_low as Value,
    @Semantics.text: true
    text as Description
}
