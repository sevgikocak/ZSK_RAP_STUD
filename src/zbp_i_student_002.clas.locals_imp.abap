CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Student RESULT result.
    METHODS setadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setadmitted RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR student RESULT result.
    METHODS validateage FOR VALIDATE ON SAVE
      IMPORTING keys FOR student~validateage.
    METHODS updatecourseduration FOR DETERMINE ON SAVE
      IMPORTING keys FOR student~updatecourseduration.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE student.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR student RESULT result.
    METHODS is_update_allowed
      RETURNING VALUE(update_allowed) TYPE abap_bool.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA: update_requested TYPE abap_bool,
          update_grtanted  TYPE abap_bool.

    READ ENTITIES OF zi_student_002 IN LOCAL MODE
      ENTITY Student
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(studentadmitted)
      FAILED failed.
    CHECK studentadmitted IS NOT INITIAL.
    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
                                    requested_authorizations-%action-Edit = if_abap_behv=>mk-on THEN
                                    abap_true ELSE abap_false ).

    LOOP AT studentadmitted ASSIGNING FIELD-SYMBOL(<lfs_studentadmitted>).
      IF <lfs_studentadmitted>-Status = abap_false.
        IF update_requested = abap_true.
          update_grtanted = is_update_allowed(  ).
          IF update_grtanted = abap_false.
            APPEND VALUE #(  %tky = <lfs_studentadmitted>-%tky ) TO failed-student.
            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text = 'Durum güncelleme için yetkiniz yok!!!'
                            )
            ) TO reported-student.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setadmitted.
    MODIFY ENTITIES OF zi_student_002 IN LOCAL MODE
      ENTITY Student
      UPDATE
      FIELDS ( Status )
      WITH  VALUE #( FOR key IN keys ( %tky = key-%tky Status = abap_true ) )

      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zi_student_002 IN LOCAL MODE
    ENTITY Student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).
    result = VALUE #( FOR studentrec IN studentdata
                      ( %tky = studentrec-%tky %param = studentrec )
                    ).
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_student_002 IN LOCAL MODE
    ENTITY Student
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(studentadmitted)
    FAILED failed.
    result =
    VALUE #( FOR stud IN studentadmitted
    LET statusval = COND #( WHEN stud-Status = abap_true
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )

                            IN ( %tky = stud-%tky
                                 %action-setAdmitted = statusval )
                            ).

  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zi_student_002 IN LOCAL MODE
      ENTITY Student
      FIELDS ( Age ) WITH CORRESPONDING #( keys )
      RESULT DATA(studentsAge).

    LOOP AT studentsAge INTO DATA(studentAge).
      IF studentage-Age < 21 .
        APPEND VALUE #( %tky = studentage-%tky ) TO failed-student.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = '21 yaşından küçük yaş girilemez.' ) ) TO reported-student.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD updateCourseDuration.
    READ ENTITIES OF zi_student_002 IN LOCAL MODE
        ENTITY Student
        FIELDS ( Course ) WITH CORRESPONDING #( keys )
        RESULT DATA(studentsCourse).


    LOOP AT studentsCourse INTO DATA(studentCourse).
      IF studentcourse-Course = 'Computers'.
        MODIFY ENTITIES OF zi_student_002 IN LOCAL MODE
        ENTITY Student
        UPDATE
        FIELDS ( Courseduration ) WITH VALUE #( (  %tky = studentCourse-%tky Courseduration = 5 ) ).
      ENDIF.
      IF studentcourse-Course = 'Electronics'.
        MODIFY ENTITIES OF zi_student_002 IN LOCAL MODE
        ENTITY Student
        UPDATE
        FIELDS ( Courseduration ) WITH VALUE #( (  %tky = studentCourse-%tky Courseduration = 3 ) ).
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD precheck_update.

*  "Kullanıcı arayüzünden mevcut değerleri almak için entities üzerinde döngü yapın, güncellenen tüm değiştirilmiş değerler <lfs_entity>'de mevcut olacak
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
*
*   "Hangi değerlerin kullanıcı tarafından değiştirildiğini kontrol edin
*   "01 = değer güncellendi / değiştirildi / changed , 00 = değer değişmedi
*
*    "Course veya Courseduration değerlerinin Kullanıcı tarafından değiştirilip değiştirilmediğini kontrol edin
*      CHECK  <lfs_entity>-%control-Course EQ '01' OR <lfs_entity>-%control-Courseduration EQ '01'.
*
*      "Entity kaydını okuyun ve Internal table da toplayın
*      READ ENTITIES OF zi_student_002 IN LOCAL MODE
*         ENTITY Student
*         FIELDS ( Course Courseduration ) WITH VALUE #(  (  %key = <lfs_entity>-%key ) )
*         RESULT DATA(lt_studentsCourse).
*
*      IF sy-subrc IS INITIAL.
*        READ TABLE lt_studentsCourse ASSIGNING FIELD-SYMBOL(<lfs_db_course>) INDEX 1.
*        IF sy-subrc IS INITIAL.
*
*        "Güncellenen değeri Frontend'den toplayın. Kullanıcı Frontend te değeri güncellediyse güncellenmiş değeri alın
*        "Aksi halde değeri Veritabanından alın
*          <lfs_db_course>-Course = COND #(  WHEN <lfs_entity>-%control-Course EQ '01' THEN
*                                          <lfs_entity>-Course ELSE <lfs_db_course>-Course
*          ).
*
*          <lfs_db_course>-Courseduration = COND #(  WHEN <lfs_entity>-%control-Courseduration EQ '01' THEN
*                                          <lfs_entity>-Courseduration ELSE <lfs_db_course>-Courseduration
*          ).
*
*         "Gereksinimlere göre iş mantığı, Computers için Kurs Süresinin 5 Yıldan az olamayacağını doğruluyoruz
*          IF <lfs_db_course>-Courseduration < 5.
*            IF <lfs_db_course>-Course = 'Computers'.
*
*              "Frontend'e Hata Mesajını Döndür.
*              APPEND VALUE #(  %tky =  <lfs_entity>-%tky ) TO failed-student.
*              APPEND VALUE #(  %tky =  <lfs_entity>-%tky
*                               %msg = new_message_with_text(
*                                  severity = if_abap_behv_message=>severity-error
*                                  text = 'geçersiz kurs süresi...'
*                                )  ) TO reported-student.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
*   EDIT işleminin tetiklenip tetiklenmediğini kontrol edin
    IF requested_authorizations-%update = if_abap_behv=>mk-on OR
        requested_authorizations-%action-Edit   = if_abap_behv=>mk-on.

*     Kontrol metodu IS_UPDATE_ALLOWED (yetkilendirme kontrolünü test etmek için true/false gönderiyorum)
      IF is_update_allowed( ) = abap_false.

*       sonucu EDIT'e izin verildi olarak güncelleme
        result-%update = if_abap_behv=>auth-allowed.
        result-%action-Edit = if_abap_behv=>auth-allowed.

      ELSE.

*       sonucu EDIT'e izin verilmedi olarak güncelleme
        result-%update = if_abap_behv=>auth-unauthorized.
        result-%action-Edit = if_abap_behv=>auth-unauthorized.

      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD is_update_allowed.
    update_allowed = abap_false.

  ENDMETHOD.

ENDCLASS.
