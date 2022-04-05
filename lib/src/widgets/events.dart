import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../handlers/calendar_utils.dart';
import '../handlers/event_calendar.dart';
import '../handlers/event_selector.dart';
import '../handlers/translator.dart';
import '../models/calendar_options.dart';
import '../models/style/event_style.dart';
import 'event_card.dart';

class Events extends StatelessWidget {
  Function onEventsChanged;
  late EventStyle eventStyle;

  Events({required this.onEventsChanged});

  @override
  Widget build(BuildContext context) {
    eventStyle = EventStyle.of(context);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onPanEnd: ((details) {
            Velocity vc = details.velocity;
            String clearVc;
            clearVc = vc.toString().replaceAll('(', '');
            clearVc = clearVc.toString().replaceAll(')', '');
            clearVc = clearVc.toString().replaceAll('Velocity', '');
            if (double.parse(clearVc.toString().split(',')[0]) > 0) {
              // left
              switch (EventCalendar.calendarProvider.isRTL()) {
                case true:
                  CalendarUtils.nextDay();
                  break;
                case false:
                  CalendarUtils.previousDay();
                  break;
              }
              onEventsChanged.call();
            } else {
              // right
              switch (EventCalendar.calendarProvider.isRTL()) {
                case true:
                  CalendarUtils.previousDay();
                  break;
                case false:
                  CalendarUtils.nextDay();
                  break;
              }
              onEventsChanged.call();
            }
          }),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: eventCardsMaker(context),
          ),
        ),
      ),
    );
  }

  List<Widget> eventCardsMaker(BuildContext context) {
    var selectedEvents = EventSelector().updateEvents();
    List<Widget> eventCards = [];
    for (var item in selectedEvents)
      eventCards.add(
        EventCard(
          fullCalendarEvent: item,
        ),
      );

    
    return eventCards;
  }
}
