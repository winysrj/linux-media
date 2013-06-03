Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4544 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3FCJhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 13/13] v4l2: remove deprecated current_norm support completely.
Date: Mon,  3 Jun 2013 11:36:50 +0200
Message-Id: <1370252210-4994-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of current_norm to keep track of the current standard has been
deprecated for quite some time. Now that all drivers that were using it
have been converted to use g_std we can drop it from the core.

It was a bad idea to introduce this at the time: since it is a per-device
node field it didn't work for drivers that create multiple nodes, all sharing
the same tuner (e.g. video and vbi nodes, or a raw video node and a compressed
video node). In addition it was very surprising behavior that g_std was
implemented in the core. Often drivers implemented both g_std and current_norm,
because they didn't understand how it should be used.

Since the benefits were very limited (if they were there at all), it is better
to just drop it and require that drivers just implement g_std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |    5 ++---
 drivers/media/v4l2-core/v4l2-ioctl.c |   34 ++++------------------------------
 include/media/v4l2-dev.h             |    1 -
 3 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 5923c5d..2f3fac5 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -675,9 +675,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
-		if (ops->vidioc_g_std || vdev->current_norm)
-			set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
+		SET_VALID_IOCTL(ops, VIDIOC_G_STD, vidioc_g_std);
 		if (is_rx) {
 			SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
 			SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
@@ -705,7 +704,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
 			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
 		if (ops->vidioc_g_parm || (vdev->vfl_type == VFL_TYPE_GRABBER &&
-					(ops->vidioc_g_std || vdev->current_norm)))
+					ops->vidioc_g_std))
 			set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
 		SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..fd0f112 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1364,40 +1364,18 @@ static int v4l_enumstd(const struct v4l2_ioctl_ops *ops,
 	return 0;
 }
 
-static int v4l_g_std(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
-{
-	struct video_device *vfd = video_devdata(file);
-	v4l2_std_id *id = arg;
-
-	/* Calls the specific handler */
-	if (ops->vidioc_g_std)
-		return ops->vidioc_g_std(file, fh, arg);
-	if (vfd->current_norm) {
-		*id = vfd->current_norm;
-		return 0;
-	}
-	return -ENOTTY;
-}
-
 static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
-	int ret;
 
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
 
 	/* Calls the specific handler */
-	ret = ops->vidioc_s_std(file, fh, norm);
-
-	/* Updates standard information */
-	if (ret >= 0)
-		vfd->current_norm = norm;
-	return ret;
+	return ops->vidioc_s_std(file, fh, norm);
 }
 
 static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
@@ -1500,7 +1478,6 @@ static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
-	struct video_device *vfd = video_devdata(file);
 	struct v4l2_streamparm *p = arg;
 	v4l2_std_id std;
 	int ret = check_fmt(file, p->type);
@@ -1509,16 +1486,13 @@ static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 		return ret;
 	if (ops->vidioc_g_parm)
 		return ops->vidioc_g_parm(file, fh, p);
-	std = vfd->current_norm;
 	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 	p->parm.capture.readbuffers = 2;
-	if (is_valid_ioctl(vfd, VIDIOC_G_STD) && ops->vidioc_g_std)
-		ret = ops->vidioc_g_std(file, fh, &std);
+	ret = ops->vidioc_g_std(file, fh, &std);
 	if (ret == 0)
-		v4l2_video_std_frame_period(std,
-			    &p->parm.capture.timeperframe);
+		v4l2_video_std_frame_period(std, &p->parm.capture.timeperframe);
 	return ret;
 }
 
@@ -2053,7 +2027,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
-	IOCTL_INFO_FNC(VIDIOC_G_STD, v4l_g_std, v4l_print_std, 0),
+	IOCTL_INFO_STD(VIDIOC_G_STD, vidioc_g_std, v4l_print_std, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
 	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 95d1c91..b2c3776 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -129,7 +129,6 @@ struct video_device
 
 	/* Video standard vars */
 	v4l2_std_id tvnorms;		/* Supported tv norms */
-	v4l2_std_id current_norm;	/* Current tvnorm */
 
 	/* callbacks */
 	void (*release)(struct video_device *vdev);
-- 
1.7.10.4

