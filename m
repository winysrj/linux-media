Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2558 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1AHLCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 06:02:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFCv2 PATCH 2/5] v4l2-subdev: add (un)register internal ops
Date: Sat,  8 Jan 2011 12:01:45 +0100
Message-Id: <f4f5844dc17caf2f056cfe4a56f9aa48e4b61420.1294484338.git.hverkuil@xs4all.nl>
In-Reply-To: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c17e89942fa7c2a1928f0dadc676f39a7e34e54c.1294484338.git.hverkuil@xs4all.nl>
References: <c17e89942fa7c2a1928f0dadc676f39a7e34e54c.1294484338.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some subdevs need to call into the board code after they are registered
and have a valid struct v4l2_device pointer. The s_config op was abused
for this, but now that it is removed we need a cleaner way of solving this.

So this patch adds a struct with internal ops that the v4l2 core can call.

Currently only two ops exist: register and unregister. Subdevs can implement
these to call the board code and pass it the v4l2_device pointer, which the
board code can then use to get access to the struct that embeds the
v4l2_device.

It is expected that in the future open and close ops will also be added.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-device.c |   14 ++++++++++++--
 include/media/v4l2-subdev.h       |   17 +++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 7fe6f92..b24f002 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -126,11 +126,19 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	WARN_ON(sd->v4l2_dev != NULL);
 	if (!try_module_get(sd->owner))
 		return -ENODEV;
+	sd->v4l2_dev = v4l2_dev;
+	if (sd->internal_ops && sd->internal_ops->registered) {
+		err = sd->internal_ops->registered(sd);
+		if (err)
+			return err;
+	}
 	/* This just returns 0 if either of the two args is NULL */
 	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
-	if (err)
+	if (err) {
+		if (sd->internal_ops && sd->internal_ops->unregistered)
+			sd->internal_ops->unregistered(sd);
 		return err;
-	sd->v4l2_dev = v4l2_dev;
+	}
 	spin_lock(&v4l2_dev->lock);
 	list_add_tail(&sd->list, &v4l2_dev->subdevs);
 	spin_unlock(&v4l2_dev->lock);
@@ -146,6 +154,8 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 	spin_lock(&sd->v4l2_dev->lock);
 	list_del(&sd->list);
 	spin_unlock(&sd->v4l2_dev->lock);
+	if (sd->internal_ops && sd->internal_ops->unregistered)
+		sd->internal_ops->unregistered(sd);
 	sd->v4l2_dev = NULL;
 	module_put(sd->owner);
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 42fbe46..daf1e57 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -411,6 +411,21 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_sensor_ops	*sensor;
 };
 
+/*
+ * Internal ops. Never call this from drivers, only the v4l2 framework can call
+ * these ops.
+ *
+ * registered: called when this subdev is registered. When called the v4l2_dev
+ *	field is set to the correct v4l2_device.
+ *
+ * unregistered: called when this subdev is unregistered. When called the
+ *	v4l2_dev field is still set to the correct v4l2_device.
+ */
+struct v4l2_subdev_internal_ops {
+	int (*registered)(struct v4l2_subdev *sd);
+	void (*unregistered)(struct v4l2_subdev *sd);
+};
+
 #define V4L2_SUBDEV_NAME_SIZE 32
 
 /* Set this flag if this subdev is a i2c device. */
@@ -427,6 +442,8 @@ struct v4l2_subdev {
 	u32 flags;
 	struct v4l2_device *v4l2_dev;
 	const struct v4l2_subdev_ops *ops;
+	/* Never call these internal ops from within a driver! */
+	const struct v4l2_subdev_internal_ops *internal_ops;
 	/* The control handler of this subdev. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 	/* name must be unique */
-- 
1.7.0.4

