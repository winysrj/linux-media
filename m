Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37051 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbcGDIcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH 6/9] vpfe_capture: convert g/s_crop to g/s_selection.
Date: Mon,  4 Jul 2016 10:32:19 +0200
Message-Id: <1467621142-8064-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part of a final push to convert all drivers to g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 52 +++++++++++++++++----------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 7767e07..6efb2f1 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1610,38 +1610,53 @@ static int vpfe_cropcap(struct file *file, void *priv,
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
 
-	if (vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
+	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
+	/* If std_index is invalid, then just return (== 1:1 aspect) */
+	if (vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
+		return 0;
 
-	memset(crop, 0, sizeof(struct v4l2_cropcap));
-	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	crop->bounds.width = crop->defrect.width =
-		vpfe_standards[vpfe_dev->std_index].width;
-	crop->bounds.height = crop->defrect.height =
-		vpfe_standards[vpfe_dev->std_index].height;
 	crop->pixelaspect = vpfe_standards[vpfe_dev->std_index].pixelaspect;
 	return 0;
 }
 
-static int vpfe_g_crop(struct file *file, void *priv,
-			     struct v4l2_crop *crop)
+static int vpfe_g_selection(struct file *file, void *priv,
+			    struct v4l2_selection *sel)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_crop\n");
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_selection\n");
 
-	crop->c = vpfe_dev->crop;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		sel->r = vpfe_dev->crop;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.width = vpfe_standards[vpfe_dev->std_index].width;
+		sel->r.height = vpfe_standards[vpfe_dev->std_index].height;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static int vpfe_s_crop(struct file *file, void *priv,
-			     const struct v4l2_crop *crop)
+static int vpfe_s_selection(struct file *file, void *priv,
+			    struct v4l2_selection *sel)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	struct v4l2_rect rect = crop->c;
+	struct v4l2_rect rect = sel->r;
 	int ret = 0;
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_crop\n");
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_selection\n");
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
 
 	if (vpfe_dev->started) {
 		/* make sure streaming is not started */
@@ -1669,7 +1684,7 @@ static int vpfe_s_crop(struct file *file, void *priv,
 		vpfe_dev->std_info.active_pixels) ||
 	    (rect.top + rect.height >
 		vpfe_dev->std_info.active_lines)) {
-		v4l2_err(&vpfe_dev->v4l2_dev, "Error in S_CROP params\n");
+		v4l2_err(&vpfe_dev->v4l2_dev, "Error in S_SELECTION params\n");
 		ret = -EINVAL;
 		goto unlock_out;
 	}
@@ -1682,6 +1697,7 @@ static int vpfe_s_crop(struct file *file, void *priv,
 		vpfe_dev->fmt.fmt.pix.bytesperline *
 		vpfe_dev->fmt.fmt.pix.height;
 	vpfe_dev->crop = rect;
+	sel->r = rect;
 unlock_out:
 	mutex_unlock(&vpfe_dev->lock);
 	return ret;
@@ -1760,8 +1776,8 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_streamon	 = vpfe_streamon,
 	.vidioc_streamoff	 = vpfe_streamoff,
 	.vidioc_cropcap		 = vpfe_cropcap,
-	.vidioc_g_crop		 = vpfe_g_crop,
-	.vidioc_s_crop		 = vpfe_s_crop,
+	.vidioc_g_selection	 = vpfe_g_selection,
+	.vidioc_s_selection	 = vpfe_s_selection,
 	.vidioc_default		 = vpfe_param_handler,
 };
 
-- 
2.8.1

