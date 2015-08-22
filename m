Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 23/39] [media] v4l2-event.h: fix comments and add to DocBook
Date: Sat, 22 Aug 2015 14:28:08 -0300
Message-Id: <a5c83477a291a12d8412c1cf3dadb34fee98a757.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments there are good enough for DocBook, however they're
using a wrong format. Fix and add to device-drivers.xml.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 5f01f7ad15dc..46e6818b95ce 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -232,9 +232,9 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
 !Iinclude/media/v4l2-ctrls.h
+!Iinclude/media/v4l2-event.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-dv-timings.h
-X!Iinclude/media/v4l2-event.h
 X!Iinclude/media/v4l2-mediabus.h
 X!Iinclude/media/videobuf2-memops.h
 X!Iinclude/media/videobuf2-core.h
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 1ab9045e52e3..9792f906423b 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -68,10 +68,11 @@ struct v4l2_subdev;
 struct v4l2_subscribed_event;
 struct video_device;
 
-/** struct v4l2_kevent - Internal kernel event struct.
-  * @list:	List node for the v4l2_fh->available list.
-  * @sev:	Pointer to parent v4l2_subscribed_event.
-  * @event:	The event itself.
+/**
+ * struct v4l2_kevent - Internal kernel event struct.
+ * @list:	List node for the v4l2_fh->available list.
+ * @sev:	Pointer to parent v4l2_subscribed_event.
+ * @event:	The event itself.
   */
 struct v4l2_kevent {
 	struct list_head	list;
@@ -80,11 +81,12 @@ struct v4l2_kevent {
 };
 
 /** struct v4l2_subscribed_event_ops - Subscribed event operations.
-  * @add:	Optional callback, called when a new listener is added
-  * @del:	Optional callback, called when a listener stops listening
-  * @replace:	Optional callback that can replace event 'old' with event 'new'.
-  * @merge:	Optional callback that can merge event 'old' into event 'new'.
-  */
+ *
+ * @add:	Optional callback, called when a new listener is added
+ * @del:	Optional callback, called when a listener stops listening
+ * @replace:	Optional callback that can replace event 'old' with event 'new'.
+ * @merge:	Optional callback that can merge event 'old' into event 'new'.
+ */
 struct v4l2_subscribed_event_ops {
 	int  (*add)(struct v4l2_subscribed_event *sev, unsigned elems);
 	void (*del)(struct v4l2_subscribed_event *sev);
@@ -92,19 +94,20 @@ struct v4l2_subscribed_event_ops {
 	void (*merge)(const struct v4l2_event *old, struct v4l2_event *new);
 };
 
-/** struct v4l2_subscribed_event - Internal struct representing a subscribed event.
-  * @list:	List node for the v4l2_fh->subscribed list.
-  * @type:	Event type.
-  * @id:	Associated object ID (e.g. control ID). 0 if there isn't any.
-  * @flags:	Copy of v4l2_event_subscription->flags.
-  * @fh:	Filehandle that subscribed to this event.
-  * @node:	List node that hooks into the object's event list (if there is one).
-  * @ops:	v4l2_subscribed_event_ops
-  * @elems:	The number of elements in the events array.
-  * @first:	The index of the events containing the oldest available event.
-  * @in_use:	The number of queued events.
-  * @events:	An array of @elems events.
-  */
+/**
+ * struct v4l2_subscribed_event - Internal struct representing a subscribed event.
+ * @list:	List node for the v4l2_fh->subscribed list.
+ * @type:	Event type.
+ * @id:	Associated object ID (e.g. control ID). 0 if there isn't any.
+ * @flags:	Copy of v4l2_event_subscription->flags.
+ * @fh:	Filehandle that subscribed to this event.
+ * @node:	List node that hooks into the object's event list (if there is one).
+ * @ops:	v4l2_subscribed_event_ops
+ * @elems:	The number of elements in the events array.
+ * @first:	The index of the events containing the oldest available event.
+ * @in_use:	The number of queued events.
+ * @events:	An array of @elems events.
+ */
 struct v4l2_subscribed_event {
 	struct list_head	list;
 	u32			type;
-- 
2.4.3

