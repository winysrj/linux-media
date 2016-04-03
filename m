Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57555 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbcDCUoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 16:44:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: awalls@md.metrocast.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-device.h: add v4l2_device_mask_ variants
Date: Sun,  3 Apr 2016 13:44:16 -0700
Message-Id: <1459716257-1542-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1459716257-1542-1-git-send-email-hverkuil@xs4all.nl>
References: <1459716257-1542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_device_call_* defines filter subdevs based on the grp_id value.
But some drivers use a bitmask, so instead of filtering by grp_id == value,
you want to filter by grp_id & value.

Make variants of these defines to do this.

The 'has_op' define has been extended to have a grp_id argument as well, and
a mask variant has been added.

This extra argument required a change to go7007.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/go7007/go7007-v4l2.c |  2 +-
 include/media/v4l2-device.h            | 55 +++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 358c1c1..ea01ee5 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -1125,7 +1125,7 @@ int go7007_v4l2_init(struct go7007 *go)
 	vdev->queue = &go->vidq;
 	video_set_drvdata(vdev, go);
 	vdev->v4l2_dev = &go->v4l2_dev;
-	if (!v4l2_device_has_op(&go->v4l2_dev, video, querystd))
+	if (!v4l2_device_has_op(&go->v4l2_dev, 0, video, querystd))
 		v4l2_disable_ioctl(vdev, VIDIOC_QUERYSTD);
 	if (!(go->board_info->flags & GO7007_BOARD_HAS_TUNER)) {
 		v4l2_disable_ioctl(vdev, VIDIOC_S_FREQUENCY);
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9c58157..d5d45a8 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -196,11 +196,64 @@ static inline void v4l2_subdev_notify(struct v4l2_subdev *sd,
 			##args);					\
 })
 
-#define v4l2_device_has_op(v4l2_dev, o, f)				\
+/*
+ * Call the specified callback for all subdevs where grp_id & grpmsk != 0
+ * (if grpmsk == `0, then match them all). Ignore any errors. Note that you
+ * cannot add or delete a subdev while walking the subdevs list.
+ */
+#define v4l2_device_mask_call_all(v4l2_dev, grpmsk, o, f, args...)	\
+	do {								\
+		struct v4l2_subdev *__sd;				\
+									\
+		__v4l2_device_call_subdevs_p(v4l2_dev, __sd,		\
+			!(grpmsk) || (__sd->grp_id & (grpmsk)), o, f ,	\
+			##args);					\
+	} while (0)
+
+/*
+ * Call the specified callback for all subdevs where grp_id & grpmsk != 0
+ * (if grpmsk == `0, then match them all). If the callback returns an error
+ * other than 0 or -ENOIOCTLCMD, then return with that error code. Note that
+ * you cannot add or delete a subdev while walking the subdevs list.
+ */
+#define v4l2_device_mask_call_until_err(v4l2_dev, grpmsk, o, f, args...) \
+({									\
+	struct v4l2_subdev *__sd;					\
+	__v4l2_device_call_subdevs_until_err_p(v4l2_dev, __sd,		\
+			!(grpmsk) || (__sd->grp_id & (grpmsk)), o, f ,	\
+			##args);					\
+})
+
+/*
+ * Does any subdev with matching grpid (or all if grpid == 0) has the given
+ * op?
+ */
+#define v4l2_device_has_op(v4l2_dev, grpid, o, f)			\
+({									\
+	struct v4l2_subdev *__sd;					\
+	bool __result = false;						\
+	list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list) {		\
+		if ((grpid) && __sd->grp_id != (grpid))			\
+			continue;					\
+		if (v4l2_subdev_has_op(__sd, o, f)) {			\
+			__result = true;				\
+			break;						\
+		}							\
+	}								\
+	__result;							\
+})
+
+/*
+ * Does any subdev with matching grpmsk (or all if grpmsk == 0) has the given
+ * op?
+ */
+#define v4l2_device_mask_has_op(v4l2_dev, grpmsk, o, f)			\
 ({									\
 	struct v4l2_subdev *__sd;					\
 	bool __result = false;						\
 	list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list) {		\
+		if ((grpmsk) && !(__sd->grp_id & (grpmsk)))		\
+			continue;					\
 		if (v4l2_subdev_has_op(__sd, o, f)) {			\
 			__result = true;				\
 			break;						\
-- 
2.8.0.rc3

