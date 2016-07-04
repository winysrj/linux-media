Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42412 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbcGDIcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Mike Isely <isely@pobox.com>
Subject: [PATCH 8/9] pvrusb2: convert g/s_crop to g/s_selection.
Date: Mon,  4 Jul 2016 10:32:21 +0200
Message-Id: <1467621142-8064-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part of a final push to convert all drivers to g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mike Isely <isely@pobox.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 81 ++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 81f788b..2cc4d2b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -719,64 +719,85 @@ static int pvr2_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cap)
 	return ret;
 }
 
-static int pvr2_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
+static int pvr2_g_selection(struct file *file, void *priv,
+			    struct v4l2_selection *sel)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
+	struct v4l2_cropcap cap;
 	int val = 0;
 	int ret;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	ret = pvr2_ctrl_get_value(
-			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL), &val);
-	if (ret != 0)
-		return -EINVAL;
-	crop->c.left = val;
-	ret = pvr2_ctrl_get_value(
-			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPT), &val);
-	if (ret != 0)
-		return -EINVAL;
-	crop->c.top = val;
-	ret = pvr2_ctrl_get_value(
-			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPW), &val);
-	if (ret != 0)
-		return -EINVAL;
-	crop->c.width = val;
-	ret = pvr2_ctrl_get_value(
-			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPH), &val);
-	if (ret != 0)
+
+	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		ret = pvr2_ctrl_get_value(
+			  pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL), &val);
+		if (ret != 0)
+			return -EINVAL;
+		sel->r.left = val;
+		ret = pvr2_ctrl_get_value(
+			  pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPT), &val);
+		if (ret != 0)
+			return -EINVAL;
+		sel->r.top = val;
+		ret = pvr2_ctrl_get_value(
+			  pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPW), &val);
+		if (ret != 0)
+			return -EINVAL;
+		sel->r.width = val;
+		ret = pvr2_ctrl_get_value(
+			  pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPH), &val);
+		if (ret != 0)
+			return -EINVAL;
+		sel->r.height = val;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		ret = pvr2_hdw_get_cropcap(hdw, &cap);
+		sel->r = cap.defrect;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		ret = pvr2_hdw_get_cropcap(hdw, &cap);
+		sel->r = cap.bounds;
+		break;
+	default:
 		return -EINVAL;
-	crop->c.height = val;
-	return 0;
+	}
+	return ret;
 }
 
-static int pvr2_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
+static int pvr2_s_selection(struct file *file, void *priv,
+			    struct v4l2_selection *sel)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	int ret;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL),
-			crop->c.left);
+			sel->r.left);
 	if (ret != 0)
 		return -EINVAL;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPT),
-			crop->c.top);
+			sel->r.top);
 	if (ret != 0)
 		return -EINVAL;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPW),
-			crop->c.width);
+			sel->r.width);
 	if (ret != 0)
 		return -EINVAL;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPH),
-			crop->c.height);
+			sel->r.height);
 	if (ret != 0)
 		return -EINVAL;
 	return 0;
@@ -798,8 +819,8 @@ static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
 	.vidioc_enumaudio		    = pvr2_enumaudio,
 	.vidioc_enum_input		    = pvr2_enum_input,
 	.vidioc_cropcap			    = pvr2_cropcap,
-	.vidioc_s_crop			    = pvr2_s_crop,
-	.vidioc_g_crop			    = pvr2_g_crop,
+	.vidioc_s_selection		    = pvr2_s_selection,
+	.vidioc_g_selection		    = pvr2_g_selection,
 	.vidioc_g_input			    = pvr2_g_input,
 	.vidioc_s_input			    = pvr2_s_input,
 	.vidioc_g_frequency		    = pvr2_g_frequency,
-- 
2.8.1

