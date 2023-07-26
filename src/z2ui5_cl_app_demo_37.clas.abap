CLASS z2ui5_cl_app_demo_37 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_value TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    DATA mv_load_cc    TYPE abap_bool.
    DATA mv_display_cc TYPE abap_bool.

    METHODS get_js_custom_control
      RETURNING
        VALUE(result) TYPE string.

    METHODS z2ui5_load_cc.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_37 IMPLEMENTATION.


  METHOD get_js_custom_control.

    result = `<html:script>jQuery.sap.declare("z2ui5.MyCC");` && |\n|  &&
                             `    sap.ui.define( [` && |\n|  &&
                             `        "sap/ui/core/Control",` && |\n|  &&
                             `    ], function (Control) {` && |\n|  &&
                             `        "use strict";` && |\n|  &&
                             `        return Control.extend("z2ui5.MyCC", {` && |\n|  &&
                             `            metadata: {` && |\n|  &&
                             `                properties: {` && |\n|  &&
                             `                    value: { type: "string" }` && |\n|  &&
                             `                },` && |\n|  &&
                             `                events: {` && |\n|  &&
                             `                    "change": {` && |\n|  &&
                             `                        allowPreventDefault: true,` && |\n|  &&
                             `                        parameters: {}` && |\n|  &&
                             `                    }` && |\n|  &&
                             `                }` && |\n|  &&
                             `            },` && |\n|  &&
                             `            renderer: function (oRm, oControl) {` && |\n|  &&
                             `                oControl.oInput = new sap.m.Input({` && |\n|  &&
                             `                    value: oControl.getProperty("value")` && |\n|  &&
                             `                });` && |\n|  &&
                             `                oControl.oButton = new sap.m.Button({` && |\n|  &&
                             `                    text: 'button text',` && |\n|  &&
                             `                    press: function (oEvent) {` && |\n|  &&
                             `                        debugger;` && |\n|  &&
*                            `                        this.setProperty("value",  this.oInput._sTypedInValue )` && |\n|  &&
                             `                        this.setProperty("value",  this.oInput.getProperty( 'value')  )` && |\n|  &&
                             `                        this.fireChange();` && |\n|  &&
                             `                    }.bind(oControl)` && |\n|  &&
                             `                });` && |\n|  &&
                            `                oRm.renderControl(oControl.oInput);` && |\n|  &&
                             `                oRm.renderControl(oControl.oButton);` && |\n|  &&
                             `            }` && |\n|  &&
                             `    });` && |\n|  &&
                             `}); </html:script>`.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_render( ).
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_load_cc.

    client->view_display( z2ui5_cl_xml_view=>factory( client
         )->zz_plain( get_js_custom_control( )
         )->stringify( ) ).

    client->timer_set(
      interval_ms    = '0'
      event_finished = client->_event( 'DISPLAY_VIEW' )
    ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN `DISPLAY_VIEW`.
        z2ui5_on_render( ).

      WHEN 'POST'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        client->message_toast_display( lt_arg[ 1 ] ).

      WHEN 'LOAD_CC'.
        mv_load_cc = abap_true.
        z2ui5_load_cc( ).
        client->message_box_display( 'Custom Control loaded ' ).

      WHEN 'DISPLAY_CC'.
        mv_display_cc = abap_true.
        z2ui5_on_render( ).
        client->message_box_display( 'Custom Control displayed ' ).

      WHEN 'MYCC'.
        client->message_toast_display( `Custom Control input: ` && mv_value ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    DATA(lv_xml) = `<mvc:View controllerName="project1.controller.View1"` && |\n|  &&
                          `    xmlns:mvc="sap.ui.core.mvc" displayBlock="true"` && |\n|  &&
                          `  xmlns:z2ui5="z2ui5"  xmlns:m="sap.m" xmlns="http://www.w3.org/1999/xhtml"` && |\n|  &&
                          `    ><m:Button ` && |\n|  &&
                          `  text="back" ` && |\n|  &&
                          `  press="` && client->_event( 'BACK' ) && `" ` && |\n|  &&
                          `  class="sapUiContentPadding sapUiResponsivePadding--content"/> ` && |\n|  &&
                   `       <m:Link target="_blank" text="Source_Code" href="` && view->hlp_get_source_code_url( ) && `"/>` && |\n|  &&
                          `<m:Button text="Load Custom Control"    press="` && client->_event( 'LOAD_CC' )    && `" />` && |\n|  &&
                          `<m:Button text="Display Custom Control" press="` && client->_event( 'DISPLAY_CC' ) && `" />` && |\n|  &&
                          `<html><head> ` &&
                          `</head>` && |\n|  &&
                          `<body>`.

    IF mv_display_cc = abap_true.
      lv_xml = lv_xml && ` <z2ui5:MyCC change=" ` && client->_event( 'MYCC' ) && `"  value="` && client->_bind_edit( mv_value ) && `"/>`.
    ENDIF.

    lv_xml = lv_xml && `</body>` && |\n|  &&
      `</html> ` && |\n|  &&
        `</mvc:View>`.

    client->view_display( view->hlp_replace_controller_name( lv_xml ) ).

  ENDMETHOD.
ENDCLASS.
