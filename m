Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2867 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaAFOVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/27] v4l2: integrate support for VIDIOC_QUERY_EXT_CTRL.
Date: Mon,  6 Jan 2014 15:21:06 +0100
Message-Id: <1389018086-15903-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  1 +
 drivers/media/v4l2-core/v4l2-dev.c            |  2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c          | 31 +++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c         |  3 +++
 include/media/v4l2-ioctl.h                    |  2 ++
 5 files changed, 39 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..0d9b97e 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1089,6 +1089,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_ENUM_FREQ_BANDS:
 	case VIDIOC_SUBDEV_G_EDID32:
 	case VIDIOC_SUBDEV_S_EDID32:
+	case VIDIOC_QUERY_EXT_CTRL:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1cc1749..0418871 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -585,6 +585,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	   be valid if the filehandle passed the control handler. */
 	if (vdev->ctrl_handler || ops->vidioc_queryctrl)
 		set_bit(_IOC_NR(VIDIOC_QUERYCTRL), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_query_ext_ctrl)
+		set_bit(_IOC_NR(VIDIOC_QUERY_EXT_CTRL), valid_ioctls);
 	if (vdev->ctrl_handler || ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls)
 		set_bit(_IOC_NR(VIDIOC_G_CTRL), valid_ioctls);
 	if (vdev->ctrl_handler || ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..8d3b2d3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -512,6 +512,19 @@ static void v4l_print_queryctrl(const void *arg, bool write_only)
 			p->step, p->default_value, p->flags);
 }
 
+static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
+{
+	const struct v4l2_query_ext_ctrl *p = arg;
+
+	pr_cont("config_store=%d, id=0x%x, type=%d, name=%.*s, unit=%.*s, min/max=%lld/%lld, "
+		"step=%lld, default=%lld, flags=0x%08x, cols=%u, rows=%u\n",
+			p->config_store, p->id, p->type, (int)sizeof(p->name), p->name,
+			(int)sizeof(p->unit), p->unit,
+			p->min.val, p->max.val,
+			p->step.val, p->def.val, p->flags,
+			p->cols, p->rows);
+}
+
 static void v4l_print_querymenu(const void *arg, bool write_only)
 {
 	const struct v4l2_querymenu *p = arg;
@@ -1502,6 +1515,23 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
 	return -ENOTTY;
 }
 
+static int v4l_query_ext_ctrl(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_query_ext_ctrl *p = arg;
+	struct v4l2_fh *vfh =
+		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
+
+	if (vfh && vfh->ctrl_handler)
+		return v4l2_query_ext_ctrl(vfh->ctrl_handler, p);
+	if (vfd->ctrl_handler)
+		return v4l2_query_ext_ctrl(vfd->ctrl_handler, p);
+	if (ops->vidioc_query_ext_ctrl)
+		return ops->vidioc_query_ext_ctrl(file, fh, p);
+	return -ENOTTY;
+}
+
 static int v4l_querymenu(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2055,6 +2085,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
+	IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..9242daa 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -139,6 +139,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_QUERYCTRL:
 		return v4l2_queryctrl(vfh->ctrl_handler, arg);
 
+	case VIDIOC_QUERY_EXT_CTRL:
+		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);
+
 	case VIDIOC_QUERYMENU:
 		return v4l2_querymenu(vfh->ctrl_handler, arg);
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e0b74a4..ac2b8b9 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -150,6 +150,8 @@ struct v4l2_ioctl_ops {
 		/* Control handling */
 	int (*vidioc_queryctrl)        (struct file *file, void *fh,
 					struct v4l2_queryctrl *a);
+	int (*vidioc_query_ext_ctrl)   (struct file *file, void *fh,
+					struct v4l2_query_ext_ctrl *a);
 	int (*vidioc_g_ctrl)           (struct file *file, void *fh,
 					struct v4l2_control *a);
 	int (*vidioc_s_ctrl)           (struct file *file, void *fh,
-- 
1.8.5.2

