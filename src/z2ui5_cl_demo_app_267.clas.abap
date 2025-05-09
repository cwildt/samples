CLASS z2ui5_cl_demo_app_267 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.


  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_267 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: MultiInput - Value States'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputValueStates' ).

    page->vertical_layout(
           class = `sapUiContentPadding`
           width = `100%`
           )->label( text     = `MultiInput with value state 'Warning'`
                     labelfor = `multiInput`
           )->multi_input( id             = `multiInput`
                           valuestate     = `Warning`
                           showsuggestion = abap_false
                           showvaluehelp  = abap_false
                           width          = `70%` )->get_parent(
           )->label( text     = `MultiInput with value state 'Error'`
                     labelfor = `multiInput1`
           )->multi_input( id             = `multiInput1`
                           valuestate     = `Error`
                           showsuggestion = `false`
                           showvaluehelp  = abap_false
                           width          = `70%` )->get_parent(
           )->label( text     = `MultiInput with value state 'Success'`
                     labelfor = `multiInput2`
           )->multi_input( id             = `multiInput2`
                           valuestate     = `Success`
                           showsuggestion = abap_false
                           showvaluehelp  = abap_false
                           width          = `70%` )->get_parent(
           )->label( text     = `MultiInput with value state 'Information'`
                     labelfor = `multiInput3`
           )->multi_input( id             = `multiInput3`
                           valuestate     = `Information`
                           showsuggestion = `false`
                           showvaluehelp  = abap_false
                           width          = `70%` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample illustrates the different value states of the sap.m.MultiInput control.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
