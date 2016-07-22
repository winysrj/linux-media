Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/11] [media] v4l2-event.rst: add cross-references and markups
Date: Fri, 22 Jul 2016 12:03:00 -0300
Message-Id: <958bb7c5c6447bd5e6f299643c6901e2e94f959f.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve events documentation by adding cross references,
sub-titles and other markup elements.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-event.rst | 137 +++++++++++++++++++-------------
 1 file changed, 81 insertions(+), 56 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 567ff7b1a3c2..0aed99459732 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -3,7 +3,7 @@ V4L2 events
 -----------
 
 The V4L2 events provide a generic way to pass events to user space.
-The driver must use v4l2_fh to be able to support V4L2 events.
+The driver must use :c:type:`v4l2_fh` to be able to support V4L2 events.
 
 Events are defined by a type and an optional ID. The ID may refer to a V4L2
 object such as a control ID. If unused, then the ID is 0.
@@ -17,93 +17,118 @@ events of another type.
 But if you get more events of one type than the number of kevents that were
 reserved, then the oldest event will be dropped and the new one added.
 
-Furthermore, the internal struct v4l2_subscribed_event has merge() and
-replace() callbacks which drivers can set. These callbacks are called when
-a new event is raised and there is no more room. The replace() callback
-allows you to replace the payload of the old event with that of the new event,
-merging any relevant data from the old payload into the new payload that
-replaces it. It is called when this event type has only one kevent struct
-allocated. The merge() callback allows you to merge the oldest event payload
-into that of the second-oldest event payload. It is called when there are two
-or more kevent structs allocated.
+Furthermore, the internal struct :c:type:`v4l2_subscribed_event` has
+``merge()`` and ``replace()`` callbacks which drivers can set. These
+callbacks are called when a new event is raised and there is no more room.
+The ``replace()`` callback allows you to replace the payload of the old event
+with that of the new event, merging any relevant data from the old payload
+into the new payload that replaces it. It is called when this event type has
+only one kevent struct allocated. The ``merge()`` callback allows you to merge
+the oldest event payload into that of the second-oldest event payload. It is
+called when there are two or more kevent structs allocated.
 
 This way no status information is lost, just the intermediate steps leading
 up to that state.
 
-A good example of these replace/merge callbacks is in v4l2-event.c:
-ctrls_replace() and ctrls_merge() callbacks for the control event.
+A good example of these ``replace``/``merge`` callbacks is in v4l2-event.c:
+``ctrls_replace()`` and ``ctrls_merge()`` callbacks for the control event.
 
-Note: these callbacks can be called from interrupt context, so they must be
-fast.
+.. note::
+	these callbacks can be called from interrupt context, so they must
+	be fast.
 
-Useful functions:
+In order to queue events to video device, drivers should call:
 
-.. code-block:: none
+	:cpp:func:`v4l2_event_queue <v4l2_event_queue>`
+	(:c:type:`vdev <video_device>`, :ref:`ev <v4l2-event>`)
 
-	void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
+The driver's only responsibility is to fill in the type and the data fields.
+The other fields will be filled in by V4L2.
 
-  Queue events to video device. The driver's only responsibility is to fill
-  in the type and the data fields. The other fields will be filled in by
-  V4L2.
+Event subscription
+~~~~~~~~~~~~~~~~~~
 
-.. code-block:: none
+Subscribing to an event is via:
 
-	int v4l2_event_subscribe(struct v4l2_fh *fh,
-				 struct v4l2_event_subscription *sub, unsigned elems,
-				 const struct v4l2_subscribed_event_ops *ops)
+	:cpp:func:`v4l2_event_subscribe <v4l2_event_subscribe>`
+	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>` ,
+	elems, :c:type:`ops <v4l2_subscribed_event_ops>`)
 
-  The video_device->ioctl_ops->vidioc_subscribe_event must check the driver
-  is able to produce events with specified event id. Then it calls
-  v4l2_event_subscribe() to subscribe the event.
 
-  The elems argument is the size of the event queue for this event. If it is 0,
-  then the framework will fill in a default value (this depends on the event
-  type).
+This function is used to implement :c:type:`video_device`->
+:c:type:`ioctl_ops <v4l2_ioctl_ops>`-> ``vidioc_subscribe_event``,
+but the driver must check first if the driver is able to produce events
+with specified event id, and then should call
+:cpp:func:`v4l2_event_subscribe` to subscribe the event.
 
-  The ops argument allows the driver to specify a number of callbacks:
-  * add:     called when a new listener gets added (subscribing to the same
-             event twice will only cause this callback to get called once)
-  * del:     called when a listener stops listening
-  * replace: replace event 'old' with event 'new'.
-  * merge:   merge event 'old' into event 'new'.
-  All 4 callbacks are optional, if you don't want to specify any callbacks
-  the ops argument itself maybe NULL.
+The elems argument is the size of the event queue for this event. If it is 0,
+then the framework will fill in a default value (this depends on the event
+type).
 
-.. code-block:: none
+The ops argument allows the driver to specify a number of callbacks:
 
-	int v4l2_event_unsubscribe(struct v4l2_fh *fh,
-				   struct v4l2_event_subscription *sub)
+======== ==============================================================
+Callback Description
+======== ==============================================================
+add      called when a new listener gets added (subscribing to the same
+         event twice will only cause this callback to get called once)
+del      called when a listener stops listening
+replace  replace event 'old' with event 'new'.
+merge    merge event 'old' into event 'new'.
+======== ==============================================================
 
-  vidioc_unsubscribe_event in struct v4l2_ioctl_ops. A driver may use
-  v4l2_event_unsubscribe() directly unless it wants to be involved in
-  unsubscription process.
+All 4 callbacks are optional, if you don't want to specify any callbacks
+the ops argument itself maybe ``NULL``.
 
-  The special type V4L2_EVENT_ALL may be used to unsubscribe all events. The
-  drivers may want to handle this in a special way.
+Unsubscribing an event
+~~~~~~~~~~~~~~~~~~~~~~
 
-.. code-block:: none
+Unsubscribing to an event is via:
 
-	int v4l2_event_pending(struct v4l2_fh *fh)
+	:cpp:func:`v4l2_event_unsubscribe <v4l2_event_unsubscribe>`
+	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>`)
 
-  Returns the number of pending events. Useful when implementing poll.
+This function is used to implement :c:type:`video_device`->
+:c:type:`ioctl_ops <v4l2_ioctl_ops>`-> ``vidioc_unsubscribe_event``.
+A driver may call :cpp:func:`v4l2_event_unsubscribe` directly unless it
+wants to be involved in unsubscription process.
+
+The special type ``V4L2_EVENT_ALL`` may be used to unsubscribe all events. The
+drivers may want to handle this in a special way.
+
+Check if there's a pending event
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Checking if there's a pending event is via:
+
+	:cpp:func:`v4l2_event_pending <v4l2_event_pending>`
+	(:c:type:`fh <v4l2_fh>`)
+
+
+This function returns the number of pending events. Useful when implementing
+poll.
+
+How events work
+~~~~~~~~~~~~~~~
 
 Events are delivered to user space through the poll system call. The driver
-can use v4l2_fh->wait (a wait_queue_head_t) as the argument for poll_wait().
+can use :c:type:`v4l2_fh`->wait (a wait_queue_head_t) as the argument for
+``poll_wait()``.
 
 There are standard and private events. New standard events must use the
 smallest available event type. The drivers must allocate their events from
 their own class starting from class base. Class base is
-V4L2_EVENT_PRIVATE_START + n * 1000 where n is the lowest available number.
+``V4L2_EVENT_PRIVATE_START`` + n * 1000 where n is the lowest available number.
 The first event type in the class is reserved for future use, so the first
 available event type is 'class base + 1'.
 
 An example on how the V4L2 events may be used can be found in the OMAP
-3 ISP driver (drivers/media/platform/omap3isp).
+3 ISP driver (``drivers/media/platform/omap3isp``).
 
-A subdev can directly send an event to the v4l2_device notify function with
-V4L2_DEVICE_NOTIFY_EVENT. This allows the bridge to map the subdev that sends
-the event to the video node(s) associated with the subdev that need to be
-informed about such an event.
+A subdev can directly send an event to the :c:type:`v4l2_device` notify
+function with ``V4L2_DEVICE_NOTIFY_EVENT``. This allows the bridge to map
+the subdev that sends the event to the video node(s) associated with the
+subdev that need to be informed about such an event.
 
 V4L2 event kAPI
 ^^^^^^^^^^^^^^^
-- 
2.7.4

