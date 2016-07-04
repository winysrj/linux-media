Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44400 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbcGDIci (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/9] zoran: convert g/s_crop to g/s_selection.
Date: Mon,  4 Jul 2016 10:32:18 +0200
Message-Id: <1467621142-8064-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is part of a final push to convert all drivers to g/s_selection.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 113 ++++++++++++++-------------------
 1 file changed, 49 insertions(+), 64 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 80caa70..d6b631a 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -2365,94 +2365,80 @@ static int zoran_s_output(struct file *file, void *__fh, unsigned int output)
 }
 
 /* cropping (sub-frame capture) */
-static int zoran_cropcap(struct file *file, void *__fh,
-					struct v4l2_cropcap *cropcap)
+static int zoran_g_selection(struct file *file, void *__fh, struct v4l2_selection *sel)
 {
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
-	int type = cropcap->type, res = 0;
 
-	memset(cropcap, 0, sizeof(*cropcap));
-	cropcap->type = type;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
 
-	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	     fh->map_mode == ZORAN_MAP_MODE_RAW)) {
+	if (fh->map_mode == ZORAN_MAP_MODE_RAW) {
 		dprintk(1, KERN_ERR
-			"%s: VIDIOC_CROPCAP - subcapture only supported for compressed capture\n",
+			"%s: VIDIOC_G_SELECTION - subcapture only supported for compressed capture\n",
 			ZR_DEVNAME(zr));
-		res = -EINVAL;
-		return res;
+		return -EINVAL;
 	}
 
-	cropcap->bounds.top = cropcap->bounds.left = 0;
-	cropcap->bounds.width = BUZ_MAX_WIDTH;
-	cropcap->bounds.height = BUZ_MAX_HEIGHT;
-	cropcap->defrect.top = cropcap->defrect.left = 0;
-	cropcap->defrect.width = BUZ_MIN_WIDTH;
-	cropcap->defrect.height = BUZ_MIN_HEIGHT;
-	return res;
-}
-
-static int zoran_g_crop(struct file *file, void *__fh, struct v4l2_crop *crop)
-{
-	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
-	int type = crop->type, res = 0;
-
-	memset(crop, 0, sizeof(*crop));
-	crop->type = type;
-
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	     fh->map_mode == ZORAN_MAP_MODE_RAW)) {
-		dprintk(1,
-			KERN_ERR
-			"%s: VIDIOC_G_CROP - subcapture only supported for compressed capture\n",
-			ZR_DEVNAME(zr));
-		res = -EINVAL;
-		return res;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		sel->r.top = fh->jpg_settings.img_y;
+		sel->r.left = fh->jpg_settings.img_x;
+		sel->r.width = fh->jpg_settings.img_width;
+		sel->r.height = fh->jpg_settings.img_height;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.top = sel->r.left = 0;
+		sel->r.width = BUZ_MIN_WIDTH;
+		sel->r.height = BUZ_MIN_HEIGHT;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.top = sel->r.left = 0;
+		sel->r.width = BUZ_MAX_WIDTH;
+		sel->r.height = BUZ_MAX_HEIGHT;
+		break;
+	default:
+		return -EINVAL;
 	}
-
-	crop->c.top = fh->jpg_settings.img_y;
-	crop->c.left = fh->jpg_settings.img_x;
-	crop->c.width = fh->jpg_settings.img_width;
-	crop->c.height = fh->jpg_settings.img_height;
-	return res;
+	return 0;
 }
 
-static int zoran_s_crop(struct file *file, void *__fh, const struct v4l2_crop *crop)
+static int zoran_s_selection(struct file *file, void *__fh, struct v4l2_selection *sel)
 {
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
-	int res = 0;
 	struct zoran_jpg_settings settings;
+	int res;
 
-	settings = fh->jpg_settings;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
 
-	if (fh->buffers.allocated) {
+	if (sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	if (fh->map_mode == ZORAN_MAP_MODE_RAW) {
 		dprintk(1, KERN_ERR
-			"%s: VIDIOC_S_CROP - cannot change settings while active\n",
+			"%s: VIDIOC_S_SELECTION - subcapture only supported for compressed capture\n",
 			ZR_DEVNAME(zr));
-		res = -EBUSY;
-		return res;
+		return -EINVAL;
 	}
 
-	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	     fh->map_mode == ZORAN_MAP_MODE_RAW)) {
+	settings = fh->jpg_settings;
+
+	if (fh->buffers.allocated) {
 		dprintk(1, KERN_ERR
-			"%s: VIDIOC_G_CROP - subcapture only supported for compressed capture\n",
+			"%s: VIDIOC_S_SELECTION - cannot change settings while active\n",
 			ZR_DEVNAME(zr));
-		res = -EINVAL;
-		return res;
+		return -EBUSY;
 	}
 
 	/* move into a form that we understand */
-	settings.img_x = crop->c.left;
-	settings.img_y = crop->c.top;
-	settings.img_width = crop->c.width;
-	settings.img_height = crop->c.height;
+	settings.img_x = sel->r.left;
+	settings.img_y = sel->r.top;
+	settings.img_width = sel->r.width;
+	settings.img_height = sel->r.height;
 
 	/* check validity */
 	res = zoran_check_jpg_settings(zr, &settings, 0);
@@ -2808,9 +2794,8 @@ zoran_mmap (struct file           *file,
 
 static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 	.vidioc_querycap    		    = zoran_querycap,
-	.vidioc_cropcap       		    = zoran_cropcap,
-	.vidioc_s_crop       		    = zoran_s_crop,
-	.vidioc_g_crop       		    = zoran_g_crop,
+	.vidioc_s_selection		    = zoran_s_selection,
+	.vidioc_g_selection		    = zoran_g_selection,
 	.vidioc_enum_input     		    = zoran_enum_input,
 	.vidioc_g_input      		    = zoran_g_input,
 	.vidioc_s_input      		    = zoran_s_input,
-- 
2.8.1

