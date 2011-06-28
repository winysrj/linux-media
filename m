Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1344 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1F1L0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/13] v4l2-framework.txt: update v4l2_event section.
Date: Tue, 28 Jun 2011 13:26:02 +0200
Message-Id: <c79ff9ee3d2c5043015a74bc2ae634f5467d8d8e.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt |   51 ++++++++++++++++++--------
 1 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 312a0e2..f8dcabf 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -897,14 +897,38 @@ V4L2 events
 The V4L2 events provide a generic way to pass events to user space.
 The driver must use v4l2_fh to be able to support V4L2 events.
 
-Useful functions:
+Events are defined by a type and an optional ID. The ID may refer to a V4L2
+object such as a control ID. If unused, then the ID is 0.
+
+When the user subscribes to an event the driver will allocate a number of
+kevent structs for that event. So every (type, ID) event tuple will have
+its own set of kevent structs. This guarantees that if a driver is generating
+lots of events of one type in a short time, then that will not overwrite
+events of another type.
+
+But if you get more events of one type than the number of kevents that were
+reserved, then the oldest event will be dropped and the new one added.
+
+Furthermore, the internal struct v4l2_subscribed_event has merge() and
+replace() callbacks which drivers can set. These callbacks are called when
+a new event is raised and there is no more room. The replace() callback
+allows you to replace the payload of the old event with that of the new event,
+merging any relevant data from the old payload into the new payload that
+replaces it. It is called when this event type has only one kevent struct
+allocated. The merge() callback allows you to merge the oldest event payload
+into that of the second-oldest event payload. It is called when there are two
+or more kevent structs allocated.
 
-- v4l2_event_alloc()
+This way no status information is lost, just the intermediate steps leading
+up to that state.
 
-  To use events, the driver must allocate events for the file handle. By
-  calling the function more than once, the driver may assure that at least n
-  events in total have been allocated. The function may not be called in
-  atomic context.
+A good example of these replace/merge callbacks is in v4l2-event.c:
+ctrls_replace() and ctrls_merge() callbacks for the control event.
+
+Note: these callbacks can be called from interrupt context, so they must be
+fast.
+
+Useful functions:
 
 - v4l2_event_queue()
 
@@ -916,7 +940,9 @@ Useful functions:
 
   The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
   is able to produce events with specified event id. Then it calls
-  v4l2_event_subscribe() to subscribe the event.
+  v4l2_event_subscribe() to subscribe the event. The last argument is the
+  size of the event queue for this event. If it is 0, then the framework
+  will fill in a default value (this depends on the event type).
 
 - v4l2_event_unsubscribe()
 
@@ -931,14 +957,8 @@ Useful functions:
 
   Returns the number of pending events. Useful when implementing poll.
 
-Drivers do not initialise events directly. The events are initialised
-through v4l2_fh_init() if video_device->ioctl_ops->vidioc_subscribe_event is
-non-NULL. This *MUST* be performed in the driver's
-v4l2_file_operations->open() handler.
-
 Events are delivered to user space through the poll system call. The driver
-can use v4l2_fh->events->wait wait_queue_head_t as the argument for
-poll_wait().
+can use v4l2_fh->wait (a wait_queue_head_t) as the argument for poll_wait().
 
 There are standard and private events. New standard events must use the
 smallest available event type. The drivers must allocate their events from
@@ -948,5 +968,4 @@ The first event type in the class is reserved for future use, so the first
 available event type is 'class base + 1'.
 
 An example on how the V4L2 events may be used can be found in the OMAP
-3 ISP driver available at <URL:http://gitorious.org/omap3camera> as of
-writing this.
+3 ISP driver (drivers/media/video/omap3isp).
-- 
1.7.1

