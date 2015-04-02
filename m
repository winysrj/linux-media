Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33568 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbbDBLfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 07:35:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 3/3] cx18: replace cropping ioctls by selection ioctls.
Date: Thu,  2 Apr 2015 13:34:31 +0200
Message-Id: <1427974471-24804-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
References: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-ioctl.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 35d75311..79aee30 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -451,34 +451,29 @@ static int cx18_cropcap(struct file *file, void *fh,
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	cropcap->bounds.top = cropcap->bounds.left = 0;
-	cropcap->bounds.width = 720;
-	cropcap->bounds.height = cx->is_50hz ? 576 : 480;
 	cropcap->pixelaspect.numerator = cx->is_50hz ? 59 : 10;
 	cropcap->pixelaspect.denominator = cx->is_50hz ? 54 : 11;
-	cropcap->defrect = cropcap->bounds;
 	return 0;
 }
 
-static int cx18_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
-{
-	struct cx18_open_id *id = fh2id(fh);
-	struct cx18 *cx = id->cx;
-
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	CX18_DEBUG_WARN("VIDIOC_S_CROP not implemented\n");
-	return -EINVAL;
-}
-
-static int cx18_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+static int cx18_g_selection(struct file *file, void *fh,
+			    struct v4l2_selection *sel)
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.top = sel->r.left = 0;
+		sel->r.width = 720;
+		sel->r.height = cx->is_50hz ? 576 : 480;
+		break;
+	default:
 		return -EINVAL;
-	CX18_DEBUG_WARN("VIDIOC_G_CROP not implemented\n");
-	return -EINVAL;
+	}
+	return 0;
 }
 
 static int cx18_enum_fmt_vid_cap(struct file *file, void *fh,
@@ -1090,8 +1085,7 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_enumaudio               = cx18_enumaudio,
 	.vidioc_enum_input              = cx18_enum_input,
 	.vidioc_cropcap                 = cx18_cropcap,
-	.vidioc_s_crop                  = cx18_s_crop,
-	.vidioc_g_crop                  = cx18_g_crop,
+	.vidioc_g_selection             = cx18_g_selection,
 	.vidioc_g_input                 = cx18_g_input,
 	.vidioc_s_input                 = cx18_s_input,
 	.vidioc_g_frequency             = cx18_g_frequency,
-- 
2.1.4

