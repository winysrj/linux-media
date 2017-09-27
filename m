Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33419
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752363AbdI0VrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 07/17] media: v4l2-event.rst: improve events description
Date: Wed, 27 Sep 2017 18:46:50 -0300
Message-Id: <e0620524270feddab6e72e98be8666265c372e1b.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both v4l2-event.rst and v4l2-event.h have an overview of
events, but there are some inconsistencies there:

- at v4l2-event, the event's ringbuffer is called kevent. Its
  name is, instead, v4l2_kevent;

- Some things are mentioned on both places (with different words),
  others are either on one of the files.

In order to cleanup this mess, put everything at v4l2-event.rst
and improve it to be a little more coherent and to have cross
references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-event.rst | 64 ++++++++++++++++++++++++++-------
 include/media/v4l2-event.h              | 34 ------------------
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index 9938d21ef4d1..7831a503e2aa 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -5,27 +5,67 @@ V4L2 events
 The V4L2 events provide a generic way to pass events to user space.
 The driver must use :c:type:`v4l2_fh` to be able to support V4L2 events.
 
-Events are defined by a type and an optional ID. The ID may refer to a V4L2
-object such as a control ID. If unused, then the ID is 0.
+Events are subscribed per-filehandle. An event specification consists of a
+``type`` and is optionally associated with an object identified through the
+``id`` field. If unused, then the ``id`` is 0. So an event is uniquely
+identified by the ``(type, id)`` tuple.
 
-When the user subscribes to an event the driver will allocate a number of
-kevent structs for that event. So every (type, ID) event tuple will have
-its own set of kevent structs. This guarantees that if a driver is generating
-lots of events of one type in a short time, then that will not overwrite
-events of another type.
+The :c:type:`v4l2_fh` struct has a list of subscribed events on its
+``subscribed`` field.
 
-But if you get more events of one type than the number of kevents that were
-reserved, then the oldest event will be dropped and the new one added.
+When the user subscribes to an event, a :c:type:`v4l2_subscribed_event`
+struct is added to :c:type:`v4l2_fh`\ ``.subscribed``, one for every
+subscribed event.
+
+Each :c:type:`v4l2_subscribed_event` struct ends with a
+:c:type:`v4l2_kevent` ringbuffer, with the size given by the caller
+of :c:func:`v4l2_event_subscribe`. Such ringbuffer is used to store any events
+raised by the driver.
+
+So every ``(type, ID)`` event tuple will have its own set of
+:c:type:`v4l2_kevent` ringbuffer. This guarantees that if a driver is
+generating lots of events of one type in a short time, then that will
+not overwrite events of another type.
+
+But if you get more events of one type than the size of the
+:c:type:`v4l2_kevent` ringbuffer, then the oldest event will be dropped
+and the new one added.
+
+The :c:type:`v4l2_kevent` struct links into the ``available``
+list of the :c:type:`v4l2_fh` struct so :ref:`VIDIOC_DQEVENT` will
+know which event to dequeue first.
+
+Finally, if the event subscription is associated with a particular object
+such as a V4L2 control, then that object needs to know about that as well
+so that an event can be raised by that object. So the ``node`` field can
+be used to link the :c:type:`v4l2_subscribed_event` struct into a list of
+such object.
+
+So to summarize:
+
+- struct :c:type:`v4l2_fh` has two lists: one of the ``subscribed`` events,
+  and one of the ``available`` events.
+
+- struct :c:type:`v4l2_subscribed_event` has a ringbuffer of raised
+  (pending) events of that particular type.
+
+- If struct :c:type:`v4l2_subscribed_event` is associated with a specific
+  object, then that object will have an internal list of
+  struct :c:type:`v4l2_subscribed_event` so it knows who subscribed an
+  event to that object.
 
 Furthermore, the internal struct :c:type:`v4l2_subscribed_event` has
 ``merge()`` and ``replace()`` callbacks which drivers can set. These
 callbacks are called when a new event is raised and there is no more room.
+
 The ``replace()`` callback allows you to replace the payload of the old event
 with that of the new event, merging any relevant data from the old payload
 into the new payload that replaces it. It is called when this event type has
-only one kevent struct allocated. The ``merge()`` callback allows you to merge
-the oldest event payload into that of the second-oldest event payload. It is
-called when there are two or more kevent structs allocated.
+only one :c:type:`v4l2_kevent` struct allocated.
+
+The ``merge()`` callback allows you to merge the oldest event payload into
+that of the second-oldest event payload. It is called when there are two
+or more :c:type:`v4l2_kevent` structs allocated.
 
 This way no status information is lost, just the intermediate steps leading
 up to that state.
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 6741910c3a18..4e83529117f7 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -24,40 +24,6 @@
 #include <linux/videodev2.h>
 #include <linux/wait.h>
 
-/*
- * Overview:
- *
- * Events are subscribed per-filehandle. An event specification consists of a
- * type and is optionally associated with an object identified through the
- * 'id' field. So an event is uniquely identified by the (type, id) tuple.
- *
- * The v4l2-fh struct has a list of subscribed events. The v4l2_subscribed_event
- * struct is added to that list, one for every subscribed event.
- *
- * Each v4l2_subscribed_event struct ends with an array of v4l2_kevent structs.
- * This array (ringbuffer, really) is used to store any events raised by the
- * driver. The v4l2_kevent struct links into the 'available' list of the
- * v4l2_fh struct so VIDIOC_DQEVENT will know which event to dequeue first.
- *
- * Finally, if the event subscription is associated with a particular object
- * such as a V4L2 control, then that object needs to know about that as well
- * so that an event can be raised by that object. So the 'node' field can
- * be used to link the v4l2_subscribed_event struct into a list of that
- * object.
- *
- * So to summarize:
- *
- * struct v4l2_fh has two lists: one of the subscribed events, and one of the
- * pending events.
- *
- * struct v4l2_subscribed_event has a ringbuffer of raised (pending) events of
- * that particular type.
- *
- * If struct v4l2_subscribed_event is associated with a specific object, then
- * that object will have an internal list of struct v4l2_subscribed_event so
- * it knows who subscribed an event to that object.
- */
-
 struct v4l2_fh;
 struct v4l2_subdev;
 struct v4l2_subscribed_event;
-- 
2.13.5
