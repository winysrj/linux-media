Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/11] [media] v4l2-event.rst: add text from v4l2-framework.rst
Date: Fri, 22 Jul 2016 12:02:58 -0300
Message-Id: <337451765ff6aec42b10954cef8847f980143ba0.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the v4l2 event-specific text from v4l2-framework.rst
to v4l2-event.rst. That helps to keep the text together with
the functions it describes, and makes easier to identify
documentation gaps.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-event.rst     | 107 ++++++++++++++++++++++++++++
 Documentation/media/kapi/v4l2-framework.rst | 107 ----------------------------
 2 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 6ac94efc07bf..567ff7b1a3c2 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -1,3 +1,110 @@
+
+V4L2 events
+-----------
+
+The V4L2 events provide a generic way to pass events to user space.
+The driver must use v4l2_fh to be able to support V4L2 events.
+
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
+
+This way no status information is lost, just the intermediate steps leading
+up to that state.
+
+A good example of these replace/merge callbacks is in v4l2-event.c:
+ctrls_replace() and ctrls_merge() callbacks for the control event.
+
+Note: these callbacks can be called from interrupt context, so they must be
+fast.
+
+Useful functions:
+
+.. code-block:: none
+
+	void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
+
+  Queue events to video device. The driver's only responsibility is to fill
+  in the type and the data fields. The other fields will be filled in by
+  V4L2.
+
+.. code-block:: none
+
+	int v4l2_event_subscribe(struct v4l2_fh *fh,
+				 struct v4l2_event_subscription *sub, unsigned elems,
+				 const struct v4l2_subscribed_event_ops *ops)
+
+  The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
+  is able to produce events with specified event id. Then it calls
+  v4l2_event_subscribe() to subscribe the event.
+
+  The elems argument is the size of the event queue for this event. If it is 0,
+  then the framework will fill in a default value (this depends on the event
+  type).
+
+  The ops argument allows the driver to specify a number of callbacks:
+  * add:     called when a new listener gets added (subscribing to the same
+             event twice will only cause this callback to get called once)
+  * del:     called when a listener stops listening
+  * replace: replace event 'old' with event 'new'.
+  * merge:   merge event 'old' into event 'new'.
+  All 4 callbacks are optional, if you don't want to specify any callbacks
+  the ops argument itself maybe NULL.
+
+.. code-block:: none
+
+	int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+				   struct v4l2_event_subscription *sub)
+
+  vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
+  v4l2_event_unsubscribe() directly unless it wants to be involved in
+  unsubscription process.
+
+  The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
+  drivers may want to handle this in a special way.
+
+.. code-block:: none
+
+	int v4l2_event_pending(struct v4l2_fh *fh)
+
+  Returns the number of pending events. Useful when implementing poll.
+
+Events are delivered to user space through the poll system call. The driver
+can use v4l2_fh->wait (a wait_queue_head_t) as the argument for poll_wait().
+
+There are standard and private events. New standard events must use the
+smallest available event type. The drivers must allocate their events from
+their own class starting from class base. Class base is
+V4L2_EVENT_PRIVATE_START + n * 1000 where n is the lowest available number.
+The first event type in the class is reserved for future use, so the first
+available event type is 'class base + 1'.
+
+An example on how the V4L2 events may be used can be found in the OMAP
+3 ISP driver (drivers/media/platform/omap3isp).
+
+A subdev can directly send an event to the v4l2_device notify function with
+V4L2_DEVICE_NOTIFY_EVENT. This allows the bridge to map the subdev that sends
+the event to the video node(s) associated with the subdev that need to be
+informed about such an event.
+
 V4L2 event kAPI
 ^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-framework.rst
index 9204d9329124..d46380ac7c1d 100644
--- a/Documentation/media/kapi/v4l2-framework.rst
+++ b/Documentation/media/kapi/v4l2-framework.rst
@@ -213,113 +213,6 @@ device node:
 
   Same, but it calls v4l2_fh_is_singular with filp->private_data.
 
-
-V4L2 events
------------
-
-The V4L2 events provide a generic way to pass events to user space.
-The driver must use v4l2_fh to be able to support V4L2 events.
-
-Events are defined by a type and an optional ID. The ID may refer to a V4L2
-object such as a control ID. If unused, then the ID is 0.
-
-When the user subscribes to an event the driver will allocate a number of
-kevent structs for that event. So every (type, ID) event tuple will have
-its own set of kevent structs. This guarantees that if a driver is generating
-lots of events of one type in a short time, then that will not overwrite
-events of another type.
-
-But if you get more events of one type than the number of kevents that were
-reserved, then the oldest event will be dropped and the new one added.
-
-Furthermore, the internal struct v4l2_subscribed_event has merge() and
-replace() callbacks which drivers can set. These callbacks are called when
-a new event is raised and there is no more room. The replace() callback
-allows you to replace the payload of the old event with that of the new event,
-merging any relevant data from the old payload into the new payload that
-replaces it. It is called when this event type has only one kevent struct
-allocated. The merge() callback allows you to merge the oldest event payload
-into that of the second-oldest event payload. It is called when there are two
-or more kevent structs allocated.
-
-This way no status information is lost, just the intermediate steps leading
-up to that state.
-
-A good example of these replace/merge callbacks is in v4l2-event.c:
-ctrls_replace() and ctrls_merge() callbacks for the control event.
-
-Note: these callbacks can be called from interrupt context, so they must be
-fast.
-
-Useful functions:
-
-.. code-block:: none
-
-	void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
-
-  Queue events to video device. The driver's only responsibility is to fill
-  in the type and the data fields. The other fields will be filled in by
-  V4L2.
-
-.. code-block:: none
-
-	int v4l2_event_subscribe(struct v4l2_fh *fh,
-				 struct v4l2_event_subscription *sub, unsigned elems,
-				 const struct v4l2_subscribed_event_ops *ops)
-
-  The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
-  is able to produce events with specified event id. Then it calls
-  v4l2_event_subscribe() to subscribe the event.
-
-  The elems argument is the size of the event queue for this event. If it is 0,
-  then the framework will fill in a default value (this depends on the event
-  type).
-
-  The ops argument allows the driver to specify a number of callbacks:
-  * add:     called when a new listener gets added (subscribing to the same
-             event twice will only cause this callback to get called once)
-  * del:     called when a listener stops listening
-  * replace: replace event 'old' with event 'new'.
-  * merge:   merge event 'old' into event 'new'.
-  All 4 callbacks are optional, if you don't want to specify any callbacks
-  the ops argument itself maybe NULL.
-
-.. code-block:: none
-
-	int v4l2_event_unsubscribe(struct v4l2_fh *fh,
-				   struct v4l2_event_subscription *sub)
-
-  vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
-  v4l2_event_unsubscribe() directly unless it wants to be involved in
-  unsubscription process.
-
-  The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
-  drivers may want to handle this in a special way.
-
-.. code-block:: none
-
-	int v4l2_event_pending(struct v4l2_fh *fh)
-
-  Returns the number of pending events. Useful when implementing poll.
-
-Events are delivered to user space through the poll system call. The driver
-can use v4l2_fh->wait (a wait_queue_head_t) as the argument for poll_wait().
-
-There are standard and private events. New standard events must use the
-smallest available event type. The drivers must allocate their events from
-their own class starting from class base. Class base is
-V4L2_EVENT_PRIVATE_START + n * 1000 where n is the lowest available number.
-The first event type in the class is reserved for future use, so the first
-available event type is 'class base + 1'.
-
-An example on how the V4L2 events may be used can be found in the OMAP
-3 ISP driver (drivers/media/platform/omap3isp).
-
-A subdev can directly send an event to the v4l2_device notify function with
-V4L2_DEVICE_NOTIFY_EVENT. This allows the bridge to map the subdev that sends
-the event to the video node(s) associated with the subdev that need to be
-informed about such an event.
-
 V4L2 clocks
 -----------
 
-- 
2.7.4

