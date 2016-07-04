Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbcGDIfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/14] omap_vout: use control framework
Date: Mon,  4 Jul 2016 10:34:57 +0200
Message-Id: <1467621310-8203-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the old control code with the control framework.

This is one of the few remaining drivers that was not using this
framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/omap/omap_vout.c    | 109 +++++++----------------------
 drivers/media/platform/omap/omap_voutdef.h |   5 +-
 2 files changed, 29 insertions(+), 85 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 70c28d1..4afc999 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1318,71 +1318,16 @@ s_crop_err:
 	return ret;
 }
 
-static int vidioc_queryctrl(struct file *file, void *fh,
-		struct v4l2_queryctrl *ctrl)
+static int omap_vout_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct omap_vout_device *vout =
+		container_of(ctrl->handler, struct omap_vout_device, ctrl_handler);
 	int ret = 0;
 
 	switch (ctrl->id) {
-	case V4L2_CID_ROTATE:
-		ret = v4l2_ctrl_query_fill(ctrl, 0, 270, 90, 0);
-		break;
-	case V4L2_CID_BG_COLOR:
-		ret = v4l2_ctrl_query_fill(ctrl, 0, 0xFFFFFF, 1, 0);
-		break;
-	case V4L2_CID_VFLIP:
-		ret = v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
-		break;
-	default:
-		ctrl->name[0] = '\0';
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *ctrl)
-{
-	int ret = 0;
-	struct omap_vout_device *vout = fh;
-
-	switch (ctrl->id) {
-	case V4L2_CID_ROTATE:
-		ctrl->value = vout->control[0].value;
-		break;
-	case V4L2_CID_BG_COLOR:
-	{
-		struct omap_overlay_manager_info info;
-		struct omap_overlay *ovl;
-
-		ovl = vout->vid_info.overlays[0];
-		if (!ovl->manager || !ovl->manager->get_manager_info) {
-			ret = -EINVAL;
-			break;
-		}
-
-		ovl->manager->get_manager_info(ovl->manager, &info);
-		ctrl->value = info.default_color;
-		break;
-	}
-	case V4L2_CID_VFLIP:
-		ctrl->value = vout->control[2].value;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
-{
-	int ret = 0;
-	struct omap_vout_device *vout = fh;
-
-	switch (a->id) {
-	case V4L2_CID_ROTATE:
-	{
+	case V4L2_CID_ROTATE: {
 		struct omapvideo_info *ovid;
-		int rotation = a->value;
+		int rotation = ctrl->val;
 
 		ovid = &vout->vid_info;
 
@@ -1405,15 +1350,13 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 			ret = -EINVAL;
 			break;
 		}
-
-		vout->control[0].value = rotation;
 		mutex_unlock(&vout->lock);
 		break;
 	}
 	case V4L2_CID_BG_COLOR:
 	{
 		struct omap_overlay *ovl;
-		unsigned int  color = a->value;
+		unsigned int color = ctrl->val;
 		struct omap_overlay_manager_info info;
 
 		ovl = vout->vid_info.overlays[0];
@@ -1432,15 +1375,13 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 			ret = -EINVAL;
 			break;
 		}
-
-		vout->control[1].value = color;
 		mutex_unlock(&vout->lock);
 		break;
 	}
 	case V4L2_CID_VFLIP:
 	{
 		struct omapvideo_info *ovid;
-		unsigned int  mirror = a->value;
+		unsigned int mirror = ctrl->val;
 
 		ovid = &vout->vid_info;
 
@@ -1457,16 +1398,19 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 			break;
 		}
 		vout->mirror = mirror;
-		vout->control[2].value = mirror;
 		mutex_unlock(&vout->lock);
 		break;
 	}
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	return ret;
 }
 
+static const struct v4l2_ctrl_ops omap_vout_ctrl_ops = {
+	.s_ctrl = omap_vout_s_ctrl,
+};
+
 static int vidioc_reqbufs(struct file *file, void *fh,
 			struct v4l2_requestbuffers *req)
 {
@@ -1831,11 +1775,8 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops = {
 	.vidioc_g_fmt_vid_out			= vidioc_g_fmt_vid_out,
 	.vidioc_try_fmt_vid_out			= vidioc_try_fmt_vid_out,
 	.vidioc_s_fmt_vid_out			= vidioc_s_fmt_vid_out,
-	.vidioc_queryctrl    			= vidioc_queryctrl,
-	.vidioc_g_ctrl       			= vidioc_g_ctrl,
 	.vidioc_s_fbuf				= vidioc_s_fbuf,
 	.vidioc_g_fbuf				= vidioc_g_fbuf,
-	.vidioc_s_ctrl       			= vidioc_s_ctrl,
 	.vidioc_try_fmt_vid_out_overlay		= vidioc_try_fmt_vid_overlay,
 	.vidioc_s_fmt_vid_out_overlay		= vidioc_s_fmt_vid_overlay,
 	.vidioc_g_fmt_vid_out_overlay		= vidioc_g_fmt_vid_overlay,
@@ -1865,9 +1806,9 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 {
 	struct video_device *vfd;
 	struct v4l2_pix_format *pix;
-	struct v4l2_control *control;
 	struct omap_overlay *ovl = vout->vid_info.overlays[0];
 	struct omap_dss_device *display = ovl->get_device(ovl);
+	struct v4l2_ctrl_handler *hdl;
 
 	/* set the default pix */
 	pix = &vout->pix;
@@ -1896,29 +1837,32 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 
 	omap_vout_new_format(pix, &vout->fbuf, &vout->crop, &vout->win);
 
-	/*Initialize the control variables for
-	  rotation, flipping and background color. */
-	control = vout->control;
-	control[0].id = V4L2_CID_ROTATE;
-	control[0].value = 0;
+	hdl = &vout->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 3);
+	v4l2_ctrl_new_std(hdl, &omap_vout_ctrl_ops,
+			  V4L2_CID_ROTATE, 0, 270, 90, 0);
+	v4l2_ctrl_new_std(hdl, &omap_vout_ctrl_ops,
+			  V4L2_CID_BG_COLOR, 0, 0xffffff, 1, 0);
+	v4l2_ctrl_new_std(hdl, &omap_vout_ctrl_ops,
+			  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	if (hdl->error)
+		return hdl->error;
+
 	vout->rotation = 0;
 	vout->mirror = false;
-	vout->control[2].id = V4L2_CID_HFLIP;
-	vout->control[2].value = 0;
 	if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
 		vout->vrfb_bpp = 2;
 
-	control[1].id = V4L2_CID_BG_COLOR;
-	control[1].value = 0;
-
 	/* initialize the video_device struct */
 	vfd = vout->vfd = video_device_alloc();
 
 	if (!vfd) {
 		printk(KERN_ERR VOUT_NAME ": could not allocate"
 				" video device struct\n");
+		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
 	}
+	vfd->ctrl_handler = hdl;
 	vfd->release = video_device_release;
 	vfd->ioctl_ops = &vout_ioctl_ops;
 
@@ -2092,6 +2036,7 @@ static void omap_vout_cleanup_device(struct omap_vout_device *vout)
 			video_unregister_device(vfd);
 		}
 	}
+	v4l2_ctrl_handler_free(&vout->ctrl_handler);
 	if (ovid->rotation_type == VOUT_ROT_VRFB) {
 		omap_vout_release_vrfb(vout);
 		/* Free the VRFB buffer if allocated
diff --git a/drivers/media/platform/omap/omap_voutdef.h b/drivers/media/platform/omap/omap_voutdef.h
index 9ccfe1f..49de147 100644
--- a/drivers/media/platform/omap/omap_voutdef.h
+++ b/drivers/media/platform/omap/omap_voutdef.h
@@ -11,6 +11,7 @@
 #ifndef OMAP_VOUTDEF_H
 #define OMAP_VOUTDEF_H
 
+#include <media/v4l2-ctrls.h>
 #include <video/omapdss.h>
 #include <video/omapvrfb.h>
 
@@ -116,6 +117,7 @@ struct omap_vout_device {
 	struct omapvideo_info vid_info;
 	struct video_device *vfd;
 	struct omap2video_device *vid_dev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	int vid;
 	int opened;
 
@@ -149,12 +151,9 @@ struct omap_vout_device {
 	/* Lock to protect the shared data structures in ioctl */
 	struct mutex lock;
 
-	/* V4L2 control structure for different control id */
-	struct v4l2_control control[MAX_CID];
 	enum dss_rotation rotation;
 	bool mirror;
 	int flicker_filter;
-	/* V4L2 control structure for different control id */
 
 	int bpp; /* bytes per pixel */
 	int vrfb_bpp; /* bytes per pixel with respect to VRFB */
-- 
2.8.1

