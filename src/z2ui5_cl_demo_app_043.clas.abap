CLASS Z2UI5_CL_DEMO_APP_043 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

*    TYPES:
*      BEGIN OF t_flight,
*        carrid TYPE string,
*        connid TYPE string,
*        fldate TYPE string,
*        price  TYPE string,
*      END OF t_flight.
*    DATA: mt_flight TYPE STANDARD TABLE OF t_flight.

protected section.
private section.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_043 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

*    SELECT carrid connid fldate price FROM sflight INTO TABLE mt_flight.
*
*    DATA(page) = Z2UI5_cl_xml_view=>factory( )->page(
*            )->scroll_container( height = '70%' vertical = abap_true
*                )->table( items = client->_bind_one( mt_flight )
*                )->columns(
*                    )->column( )->text( 'Carrid' )->get_parent(
*                    )->column( )->text( 'Connid' )->get_parent(
*                    )->column( )->text( 'Fldate' )->get_parent(
*                    )->column( )->text( 'Price'  )->get_parent(
*                )->get_parent(
*                )->items( )->column_list_item( )->cells(
*                    )->text( '{CARRID}'
*                    )->text( '{CONNID}'
*                    )->text( '{FLDATE}'
*                    )->text( '{PRICE}' ).
*
*    client->set_next( VALUE #( xml_main = page->get_root( )->xml_get( ) )  ).

  ENDMETHOD.
ENDCLASS.