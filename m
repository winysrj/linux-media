Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2857 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaFLLyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 06/34] v4l2: integrate support for VIDIOC_QUERY_EXT_CTRL.
Date: Thu, 12 Jun 2014 13:52:38 +0200
Message-Id: <a1228618bd297ecee6ecaf2471648149422772b3.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the v4l2 core plumbing for the new VIDIOC_QUERY_EXT_CTRL ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c    |  2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c  | 33 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |  3 +++
 include/media/v4l2-ioctl.h            |  2 ++
 4 files changed, 40 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 634d863..aba277c 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -577,6 +577,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	   be valid if the filehandle passed the control handler. */
 	if (vdev->ctrl_handler || ops->vidioc_queryctrl)
 		set_bit(_IOC_NR(VIDIOC_QUERYCTRL), valid_ioctls);
+	if (vdev->ctrl_handler || ops->vidioc_query_ext_ctrl)
+		set_bit(_IOC_NR(VIDIOC_QUERY_EXT_CTRL), valid_ioctls);
 	if (vdev->ctrl_handler || ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls)
 		set_bit(_IOC_NR(VIDIOC_G_CTRL), valid_ioctls);
 	if (vdev->ctrl_handler || ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 16bffd8..b82ea79 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -525,6 +525,21 @@ static void v4l_print_queryctrl(const void *arg, bool write_only)
 			p->step, p->default_value, p->flags);
 }
 
+static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
+{
+	const struct v4l2_query_ext_ctrl *p = arg;
+
+	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, "
+		"step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, "
+		"nr_of_dims=%u, dims=%u,%u,%u,%u,%u,%u,%u,%u\n",
+			p->id, p->type, (int)sizeof(p->name), p->name,
+			p->minimum, p->maximum,
+			p->step, p->default_value, p->flags,
+			p->elem_size, p->elems, p->nr_of_dims,
+			p->dims[0], p->dims[1], p->dims[2], p->dims[3],
+			p->dims[4], p->dims[5], p->dims[6], p->dims[7]);
+}
+
 static void v4l_print_querymenu(const void *arg, bool write_only)
 {
 	const struct v4l2_querymenu *p = arg;
@@ -1561,6 +1576,23 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
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
@@ -2121,6 +2153,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
+	IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 058c1a6..b984f33 100644
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
index 50cf7c1..53605f0 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -158,6 +158,8 @@ struct v4l2_ioctl_ops {
 		/* Control handling */
 	int (*vidioc_queryctrl)        (struct file *file, void *fh,
 					struct v4l2_queryctrl *a);
+	int (*vidioc_query_ext_ctrl)   (struct file *file, void *fh,
+					struct v4l2_query_ext_ctrl *a);
 	int (*vidioc_g_ctrl)           (struct file *file, void *fh,
 					struct v4l2_control *a);
 	int (*vidioc_s_ctrl)           (struct file *file, void *fh,
-- 
2.0.0.rc0

