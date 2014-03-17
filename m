Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4565 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951AbaCQMyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:54:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH for v3.15 1/5] v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
Date: Mon, 17 Mar 2014 13:54:19 +0100
Message-Id: <1395060863-42211-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
References: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The notify function is a void function, yet the v4l2_subdev_notify
define uses it in a ? : construction, which causes sparse warnings.

Replace the define by a static inline function and move it to
v4l2-device.h, which is where it belongs since it needs to know the
v4l2_device struct. This wasn't a problem when it was a define, but
as a static inline function this no longer compiles in v4l2-subdev.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-device.h | 8 ++++++++
 include/media/v4l2-subdev.h | 5 -----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index c9b1593..ffb69da 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -120,6 +120,14 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 int __must_check
 v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 
+/* Send a notification to v4l2_device. */
+static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
+				      unsigned int notification, void *arg)
+{
+	if (sd && sd->v4l2_dev && sd->v4l2_dev->notify)
+		sd->v4l2_dev->notify(sd, notification, arg);
+}
+
 /* Iterate over all subdevs. */
 #define v4l2_device_for_each_subdev(sd, v4l2_dev)			\
 	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 28f4d8c..ee1cb2d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -691,11 +691,6 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 	(!(sd) ? -ENODEV : (((sd)->ops->o && (sd)->ops->o->f) ?	\
 		(sd)->ops->o->f((sd) , ##args) : -ENOIOCTLCMD))
 
-/* Send a notification to v4l2_device. */
-#define v4l2_subdev_notify(sd, notification, arg)			   \
-	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
-	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
-
 #define v4l2_subdev_has_op(sd, o, f) \
 	((sd)->ops->o && (sd)->ops->o->f)
 
-- 
1.9.0

