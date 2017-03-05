CLASS zcl_ags_db_objects DEFINITION
  PUBLIC
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_ags_db .

  PUBLIC SECTION.

    METHODS single
      IMPORTING
        !iv_sha1       TYPE zags_objects-sha1
      RETURNING
        VALUE(rs_data) TYPE zags_objects
      RAISING
        zcx_ags_error .
    METHODS modify
      IMPORTING
        !is_data TYPE zags_objects .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mt_objects TYPE zags_objects_tt .
    DATA mv_fake TYPE abap_bool .

    METHODS set_fake .
ENDCLASS.



CLASS ZCL_AGS_DB_OBJECTS IMPLEMENTATION.


  METHOD modify.

    IF mv_fake = abap_true.
      DELETE mt_objects WHERE sha1 = is_data-sha1.
      INSERT is_data INTO TABLE mt_objects.
    ELSE.
      MODIFY zags_objects FROM is_data.                   "#EC CI_SUBRC
    ENDIF.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD set_fake.

    mv_fake = abap_true.

  ENDMETHOD.


  METHOD single.

    IF mv_fake = abap_true.
      READ TABLE mt_objects INTO rs_data
        WITH KEY sha1 = iv_sha1.                          "#EC CI_SUBRC
    ELSE.
      SELECT SINGLE * FROM zags_objects
        INTO rs_data
        WHERE sha1 = iv_sha1.
    ENDIF.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_ags_error
        EXPORTING
          textid = zcx_ags_error=>m005
          sha1   = iv_sha1.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
