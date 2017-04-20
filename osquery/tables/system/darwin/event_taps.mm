/*
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#include <ApplicationServices/ApplicationServices.h>
#include <CoreGraphics/CoreGraphics.h>

#include <osquery/system.h>
#include <osquery/tables.h>

namespace osquery {
namespace tables {
  
const std::map <CGEventType, std::string> kEventMap =
{
  {kCGEventNull, "EventNull"},
  {kCGEventLeftMouseDown, "LeftMouseDown"},
  {kCGEventLeftMouseUp, "EventLeftMouseUp"},
  {kCGEventRightMouseDown, "EventRightMouseDown"},
  {kCGEventRightMouseUp, "EventRightMouseUp"},
  {kCGEventMouseMoved, "EventMouseMoved"},
  {kCGEventLeftMouseDragged, "EventLeftMouseDragged"},
  {kCGEventKeyDown, "EventKeyDown"},
  {kCGEventKeyUp, "EventKeyUp"},
  {kCGEventFlagsChanged, "EventFlagsChanged"},
  {kCGEventScrollWheel, "EventScrollWheel"},
  {kCGEventTabletPointer, "EventTabletPointer"},
  {kCGEventTabletPointer, "EventTabletPointer"},
  {kCGEventOtherMouseDown, "EventOtherMouseDown"},
  {kCGEventOtherMouseUp, "EventOtherMouseUp"},
  {kCGEventOtherMouseDragged, "EventOtherMouseDragged"},
};

  QueryData genEventTaps(QueryContext &context) {
    QueryData results;
    uint32_t tapCount = 0;
    CGError err;
    err = CGGetEventTapList(NULL, NULL, &tapCount);
    if(err != 0) {
      return results;
    }
    CGEventTapInformation taps[tapCount];
    err = CGGetEventTapList(tapCount, taps, &tapCount);
    if(err != 0) {
      return results;
    }
    for (size_t i = 0; i < tapCount; ++i) {
      for (const auto &type: kEventMap) {
        if ((taps[i].eventsOfInterest & CGEventMaskBit(type.first)) == 0) {
          continue;
        }
        Row r;
        r["enabled"] = std::to_string(taps[i].enabled);
        r["event_tap_id"] = std::to_string(taps[i].eventTapID);
        r["event_tapped"] = type.second;
        r["process_being_tapped"] = std::to_string(taps[i].processBeingTapped);
        r["tapping_process"] = std::to_string(taps[i].tappingProcess);
        results.push_back(r);
      }
    }
    return results;
  }

 }
}