Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-240.synserver.de ([212.40.185.240]:1063 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbFXQui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 12:50:38 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/5] [media] Add helper function for subdev event notifications
Date: Wed, 24 Jun 2015 18:50:29 +0200
Message-Id: <1435164631-19924-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1435164631-19924-1-git-send-email-lars@metafoo.de>
References: <1435164631-19924-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new helper function called v4l2_subdev_notify_event() which will
deliver the specified event to both the v4l2 subdev event queue as well as
to the notify callback. The former is typically used by userspace
applications to listen to notification events while the later is used by
bridge drivers. Combining both into the same function avoids boilerplate
code in subdev drivers.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 18 ++++++++++++++++++
 include/media/v4l2-subdev.h           |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 6359606..83615b8 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -588,3 +588,21 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 #endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
+
+/**
+ * v4l2_subdev_notify_event() - Delivers event notification for subdevice
+ * @sd: The subdev for which to deliver the event
+ * @ev: The event to deliver
+ *
+ * Will deliver the specified event to all userspace event listeners which are
+ * subscribed to the v42l subdev event queue as well as to the bridge driver
+ * using the notify callback. The notification type for the notify callback
+ * will be V4L2_DEVICE_NOTIFY_EVENT.
+ */
+void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
+			      const struct v4l2_event *ev)
+{
+	v4l2_event_queue(sd->devnode, ev);
+	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT, (void *)ev);
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_notify_event);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index dc20102..65d4a5f 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -44,6 +44,7 @@
 
 struct v4l2_device;
 struct v4l2_ctrl_handler;
+struct v4l2_event;
 struct v4l2_event_subscription;
 struct v4l2_fh;
 struct v4l2_subdev;
@@ -693,4 +694,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
 
+void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
+			      const struct v4l2_event *ev);
+
 #endif
-- 
2.1.4

