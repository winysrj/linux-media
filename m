Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:39897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1FGOr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 10:47:57 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57Elus3002453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:56 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep34.itg.ti.com (8.13.7/8.13.8) with ESMTP id p57Elur9024066
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:56 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>,
	Amber Jain <amber@ti.com>, Samreen <samreen@ti.com>
Subject: [PATCH 4/6] V4L2: OMAP: VOUT: Modifications to support 1-plane Multiplanar for RGB/YUYV formats
Date: Tue, 7 Jun 2011 20:17:36 +0530
Message-ID: <1307458058-29030-5-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The changes involved are to utilise the various structures of Multiplanar
framework.

Signed-off-by: Amber Jain <amber@ti.com>
Signed-off-by: Samreen <samreen@ti.com>
---
 drivers/media/video/omap/omap_vout.c    |  126 ++++++++++++++++---------------
 drivers/media/video/omap/omap_voutdef.h |    1 +
 drivers/media/video/omap/omap_voutlib.c |   36 +++++-----
 drivers/media/video/omap/omap_voutlib.h |    6 +-
 4 files changed, 88 insertions(+), 81 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 70fb45e..f0946ea 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -145,50 +145,53 @@ const static struct v4l2_fmtdesc omap_formats[] = {
 /*
  * Try format
  */
-static int omap_vout_try_format(struct v4l2_pix_format *pix)
+static int omap_vout_try_format(struct v4l2_pix_format_mplane *pix_mp)
 {
-	int ifmt, bpp = 0;
+	int ifmt, bpp = 0, i = 0;
 
-	pix->height = clamp(pix->height, (u32)VID_MIN_HEIGHT,
+	pix_mp->height = clamp(pix_mp->height, (u32)VID_MIN_HEIGHT,
 						(u32)VID_MAX_HEIGHT);
-	pix->width = clamp(pix->width, (u32)VID_MIN_WIDTH, (u32)VID_MAX_WIDTH);
+	pix_mp->width = clamp(pix_mp->width, (u32)VID_MIN_WIDTH, (u32)VID_MAX_WIDTH);
 
 	for (ifmt = 0; ifmt < NUM_OUTPUT_FORMATS; ifmt++) {
-		if (pix->pixelformat == omap_formats[ifmt].pixelformat)
+		if (pix_mp->pixelformat == omap_formats[ifmt].pixelformat)
 			break;
 	}
 
 	if (ifmt == NUM_OUTPUT_FORMATS)
 		ifmt = 0;
 
-	pix->pixelformat = omap_formats[ifmt].pixelformat;
-	pix->field = V4L2_FIELD_ANY;
-	pix->priv = 0;
+	pix_mp->pixelformat = omap_formats[ifmt].pixelformat;
+	pix_mp->field = V4L2_FIELD_ANY;
 
-	switch (pix->pixelformat) {
+	switch (pix_mp->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_UYVY:
 	default:
-		pix->colorspace = V4L2_COLORSPACE_JPEG;
+		pix_mp->colorspace = V4L2_COLORSPACE_JPEG;
 		bpp = YUYV_BPP;
 		break;
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB565X:
-		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
 		bpp = RGB565_BPP;
 		break;
 	case V4L2_PIX_FMT_RGB24:
-		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
 		bpp = RGB24_BPP;
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_BGR32:
-		pix->colorspace = V4L2_COLORSPACE_SRGB;
+		pix_mp->colorspace = V4L2_COLORSPACE_SRGB;
 		bpp = RGB32_BPP;
 		break;
 	}
-	pix->bytesperline = pix->width * bpp;
-	pix->sizeimage = pix->bytesperline * pix->height;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = pix_mp->width * bpp;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+	}
 
 	return bpp;
 }
@@ -286,7 +289,7 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 {
 	struct omapvideo_info *ovid;
 	struct v4l2_rect *crop = &vout->crop;
-	struct v4l2_pix_format *pix = &vout->pix;
+	struct v4l2_pix_format_mplane *pix_mp = &vout->pix_mp;
 	int *cropped_offset = &vout->cropped_offset;
 	int ps = 2, line_length = 0;
 
@@ -295,14 +298,14 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 	if (ovid->rotation_type == VOUT_ROT_VRFB) {
 		omap_vout_calculate_vrfb_offset(vout);
 	} else {
-		vout->line_length = line_length = pix->width;
+		vout->line_length = line_length = pix_mp->width;
 
-		if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
-			V4L2_PIX_FMT_UYVY == pix->pixelformat)
+		if (V4L2_PIX_FMT_YUYV == pix_mp->pixelformat ||
+			V4L2_PIX_FMT_UYVY == pix_mp->pixelformat)
 			ps = 2;
-		else if (V4L2_PIX_FMT_RGB32 == pix->pixelformat)
+		else if (V4L2_PIX_FMT_RGB32 == pix_mp->pixelformat)
 			ps = 4;
-		else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat)
+		else if (V4L2_PIX_FMT_RGB24 == pix_mp->pixelformat)
 			ps = 3;
 
 		vout->ps = ps;
@@ -324,13 +327,13 @@ static int video_mode_to_dss_mode(struct omap_vout_device *vout)
 {
 	struct omap_overlay *ovl;
 	struct omapvideo_info *ovid;
-	struct v4l2_pix_format *pix = &vout->pix;
+	struct v4l2_pix_format_mplane *pix_mp = &vout->pix_mp;
 	enum omap_color_mode mode;
 
 	ovid = &vout->vid_info;
 	ovl = ovid->overlays[0];
 
-	switch (pix->pixelformat) {
+	switch (pix_mp->pixelformat) {
 	case 0:
 		break;
 	case V4L2_PIX_FMT_YUYV:
@@ -370,7 +373,7 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 	int cropheight, cropwidth, pixheight, pixwidth;
 
 	if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
-			(outw != vout->pix.width || outh != vout->pix.height)) {
+			(outw != vout->pix_mp.width || outh != vout->pix_mp.height)) {
 		ret = -EINVAL;
 		goto setup_ovl_err;
 	}
@@ -387,13 +390,13 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 	if (rotate_90_or_270(vout)) {
 		cropheight = vout->crop.width;
 		cropwidth = vout->crop.height;
-		pixheight = vout->pix.width;
-		pixwidth = vout->pix.height;
+		pixheight = vout->pix_mp.width;
+		pixwidth = vout->pix_mp.height;
 	} else {
 		cropheight = vout->crop.height;
 		cropwidth = vout->crop.width;
-		pixheight = vout->pix.height;
-		pixwidth = vout->pix.width;
+		pixheight = vout->pix_mp.height;
+		pixwidth = vout->pix_mp.width;
 	}
 
 	ovl->get_overlay_info(ovl, &info);
@@ -683,7 +686,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		return 0;
 
 	/* Now allocated the V4L2 buffers */
-	*size = PAGE_ALIGN(vout->pix.width * vout->pix.height * vout->bpp);
+	*size = PAGE_ALIGN(vout->pix_mp.width * vout->pix_mp.height * vout->bpp);
 	startindex = (vout->vid == OMAP_VIDEO1) ?
 		video1_numbuffers : video2_numbuffers;
 
@@ -753,8 +756,8 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 	struct omapvideo_info *ovid = &vout->vid_info;
 
 	if (VIDEOBUF_NEEDS_INIT == vb->state) {
-		vb->width = vout->pix.width;
-		vb->height = vout->pix.height;
+		vb->width = vout->pix_mp.width;
+		vb->height = vout->pix_mp.height;
 		vb->size = vb->width * vb->height * vout->bpp;
 		vb->field = field;
 	}
@@ -1044,7 +1047,7 @@ static int vidioc_g_fmt_vid_out_mplane(struct file *file, void *fh,
 {
 	struct omap_vout_device *vout = fh;
 
-	f->fmt.pix = vout->pix;
+	f->fmt.pix_mp = vout->pix_mp;
 	return 0;
 
 }
@@ -1068,14 +1071,14 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *fh,
 	vout->fbuf.fmt.height = timing->y_res;
 	vout->fbuf.fmt.width = timing->x_res;
 
-	omap_vout_try_format(&f->fmt.pix);
+	omap_vout_try_format(&f->fmt.pix_mp);
 	return 0;
 }
 
 static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_format *f)
 {
-	int ret, bpp;
+	int ret, bpp, i;
 	struct omap_overlay *ovl;
 	struct omapvideo_info *ovid;
 	struct omap_video_timings *timing;
@@ -1099,7 +1102,7 @@ static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 	/* We dont support RGB24-packed mode if vrfb rotation
 	 * is enabled*/
 	if ((rotation_enabled(vout)) &&
-			f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+			f->fmt.pix_mp.pixelformat == V4L2_PIX_FMT_RGB24) {
 		ret = -EINVAL;
 		goto s_fmt_vid_out_exit;
 	}
@@ -1116,21 +1119,23 @@ static int vidioc_s_fmt_vid_out_mplane(struct file *file, void *fh,
 
 	/* change to samller size is OK */
 
-	bpp = omap_vout_try_format(&f->fmt.pix);
-	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height * bpp;
+	bpp = omap_vout_try_format(&f->fmt.pix_mp);
 
+	for (i = 0; i < f->fmt.pix_mp.num_planes; ++i)
+		f->fmt.pix_mp.plane_fmt[i].sizeimage = f->fmt.pix_mp.width *
+						f->fmt.pix_mp.height * bpp;
 	/* try & set the new output format */
 	vout->bpp = bpp;
-	vout->pix = f->fmt.pix;
+	vout->pix_mp = f->fmt.pix_mp;
 	vout->vrfb_bpp = 1;
 
 	/* If YUYV then vrfb bpp is 2, for  others its 1 */
-	if (V4L2_PIX_FMT_YUYV == vout->pix.pixelformat ||
-			V4L2_PIX_FMT_UYVY == vout->pix.pixelformat)
+	if (V4L2_PIX_FMT_YUYV == vout->pix_mp.pixelformat ||
+			V4L2_PIX_FMT_UYVY == vout->pix_mp.pixelformat)
 		vout->vrfb_bpp = 2;
 
 	/* set default crop and win */
-	omap_vout_new_format(&vout->pix, &vout->fbuf, &vout->crop, &vout->win);
+	omap_vout_new_format(&vout->pix_mp, &vout->fbuf, &vout->crop, &vout->win);
 
 	/* Save the changes in the overlay strcuture */
 	ret = omapvid_init(vout, 0);
@@ -1239,16 +1244,16 @@ static int vidioc_cropcap(struct file *file, void *fh,
 		struct v4l2_cropcap *cropcap)
 {
 	struct omap_vout_device *vout = fh;
-	struct v4l2_pix_format *pix = &vout->pix;
+	struct v4l2_pix_format_mplane *pix_mp = &vout->pix_mp;
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	/* Width and height are always even */
-	cropcap->bounds.width = pix->width & ~1;
-	cropcap->bounds.height = pix->height & ~1;
+	cropcap->bounds.width = pix_mp->width & ~1;
+	cropcap->bounds.height = pix_mp->height & ~1;
 
-	omap_vout_default_crop(&vout->pix, &vout->fbuf, &cropcap->defrect);
+	omap_vout_default_crop(&vout->pix_mp, &vout->fbuf, &cropcap->defrect);
 	cropcap->pixelaspect.numerator = 1;
 	cropcap->pixelaspect.denominator = 1;
 	return 0;
@@ -1295,7 +1300,7 @@ static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	}
 
 	if (crop->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		ret = omap_vout_new_crop(&vout->pix, &vout->crop, &vout->win,
+		ret = omap_vout_new_crop(&vout->pix_mp, &vout->crop, &vout->win,
 				&vout->fbuf, &crop->c);
 
 s_crop_err:
@@ -1378,7 +1383,7 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 			break;
 		}
 
-		if (rotation && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+		if (rotation && vout->pix_mp.pixelformat == V4L2_PIX_FMT_RGB24) {
 			mutex_unlock(&vout->lock);
 			ret = -EINVAL;
 			break;
@@ -1438,7 +1443,7 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 			break;
 		}
 
-		if (mirror  && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
+		if (mirror  && vout->pix_mp.pixelformat == V4L2_PIX_FMT_RGB24) {
 			mutex_unlock(&vout->lock);
 			ret = -EINVAL;
 			break;
@@ -1541,7 +1546,7 @@ static int vidioc_qbuf(struct file *file, void *fh,
 		return -EINVAL;
 	}
 	if (V4L2_MEMORY_USERPTR == buffer->memory) {
-		if ((buffer->length < vout->pix.sizeimage) ||
+		if ((buffer->length < vout->pix_mp.plane_fmt[0].sizeimage) ||
 				(0 == buffer->m.userptr)) {
 			return -EINVAL;
 		}
@@ -1855,25 +1860,26 @@ static const struct v4l2_file_operations omap_vout_fops = {
 static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 {
 	struct video_device *vfd;
-	struct v4l2_pix_format *pix;
+	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_control *control;
 	struct omap_dss_device *display =
 		vout->vid_info.overlays[0]->manager->device;
 
 	/* set the default pix */
-	pix = &vout->pix;
+	pix_mp = &vout->pix_mp;
 
 	/* Set the default picture of QVGA  */
-	pix->width = QQVGA_WIDTH;
-	pix->height = QQVGA_HEIGHT;
+	pix_mp->width = QQVGA_WIDTH;
+	pix_mp->height = QQVGA_HEIGHT;
 
 	/* Default pixel format is RGB 5-6-5 */
-	pix->pixelformat = V4L2_PIX_FMT_RGB565;
-	pix->field = V4L2_FIELD_ANY;
-	pix->bytesperline = pix->width * 2;
-	pix->sizeimage = pix->bytesperline * pix->height;
-	pix->priv = 0;
-	pix->colorspace = V4L2_COLORSPACE_JPEG;
+	pix_mp->pixelformat = V4L2_PIX_FMT_RGB565;
+	pix_mp->field = V4L2_FIELD_ANY;
+	/* Single plane as RGB is defualt */
+	pix_mp->plane_fmt[0].bytesperline = pix_mp->width * 2;
+	pix_mp->plane_fmt[0].sizeimage = pix_mp->plane_fmt[0].bytesperline
+					* pix_mp->height;
+	pix_mp->colorspace = V4L2_COLORSPACE_JPEG;
 
 	vout->bpp = RGB565_BPP;
 	vout->fbuf.fmt.width  =  display->panel.timings.x_res;
@@ -1886,7 +1892,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 		V4L2_FBUF_CAP_SRC_CHROMAKEY | V4L2_FBUF_CAP_CHROMAKEY;
 	vout->win.chromakey = 0;
 
-	omap_vout_new_format(pix, &vout->fbuf, &vout->crop, &vout->win);
+	omap_vout_new_format(pix_mp, &vout->fbuf, &vout->crop, &vout->win);
 
 	/*Initialize the control variables for
 	  rotation, flipping and background color. */
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 26e2b63..6f94ea1 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -142,6 +142,7 @@ struct omap_vout_device {
 	bool streaming;
 
 	struct v4l2_pix_format pix;
+	struct v4l2_pix_format_mplane pix_mp;
 	struct v4l2_rect crop;
 	struct v4l2_window win;
 	struct v4l2_framebuffer fbuf;
diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
index c28ef05..e3a712e 100644
--- a/drivers/media/video/omap/omap_voutlib.c
+++ b/drivers/media/video/omap/omap_voutlib.c
@@ -38,17 +38,17 @@ MODULE_LICENSE("GPL");
  * that will fit on the display.  The default cropping rectangle is centered in
  * the image.  All dimensions and offsets are rounded down to even numbers.
  */
-void omap_vout_default_crop(struct v4l2_pix_format *pix,
+void omap_vout_default_crop(struct v4l2_pix_format_mplane *pix_mp,
 		  struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop)
 {
-	crop->width = (pix->width < fbuf->fmt.width) ?
-		pix->width : fbuf->fmt.width;
-	crop->height = (pix->height < fbuf->fmt.height) ?
-		pix->height : fbuf->fmt.height;
+	crop->width = (pix_mp->width < fbuf->fmt.width) ?
+		pix_mp->width : fbuf->fmt.width;
+	crop->height = (pix_mp->height < fbuf->fmt.height) ?
+		pix_mp->height : fbuf->fmt.height;
 	crop->width &= ~1;
 	crop->height &= ~1;
-	crop->left = ((pix->width - crop->width) >> 1) & ~1;
-	crop->top = ((pix->height - crop->height) >> 1) & ~1;
+	crop->left = ((pix_mp->width - crop->width) >> 1) & ~1;
+	crop->top = ((pix_mp->height - crop->height) >> 1) & ~1;
 }
 EXPORT_SYMBOL_GPL(omap_vout_default_crop);
 
@@ -160,7 +160,7 @@ EXPORT_SYMBOL_GPL(omap_vout_new_window);
  * Returns zero if successful, or -EINVAL if the requested cropping rectangle is
  * impossible and cannot reasonably be adjusted.
  */
-int omap_vout_new_crop(struct v4l2_pix_format *pix,
+int omap_vout_new_crop(struct v4l2_pix_format_mplane *pix_mp,
 	      struct v4l2_rect *crop, struct v4l2_window *win,
 	      struct v4l2_framebuffer *fbuf, const struct v4l2_rect *new_crop)
 {
@@ -179,14 +179,14 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 		try_crop.height += try_crop.top;
 		try_crop.top = 0;
 	}
-	try_crop.width = (try_crop.width < pix->width) ?
-		try_crop.width : pix->width;
-	try_crop.height = (try_crop.height < pix->height) ?
-		try_crop.height : pix->height;
-	if (try_crop.left + try_crop.width > pix->width)
-		try_crop.width = pix->width - try_crop.left;
-	if (try_crop.top + try_crop.height > pix->height)
-		try_crop.height = pix->height - try_crop.top;
+	try_crop.width = (try_crop.width < pix_mp->width) ?
+		try_crop.width : pix_mp->width;
+	try_crop.height = (try_crop.height < pix_mp->height) ?
+		try_crop.height : pix_mp->height;
+	if (try_crop.left + try_crop.width > pix_mp->width)
+		try_crop.width = pix_mp->width - try_crop.left;
+	if (try_crop.top + try_crop.height > pix_mp->height)
+		try_crop.height = pix_mp->height - try_crop.top;
 
 	try_crop.width &= ~1;
 	try_crop.height &= ~1;
@@ -276,14 +276,14 @@ EXPORT_SYMBOL_GPL(omap_vout_new_crop);
  * the same size as crop and is centered on the display.
  * All sizes and offsets are constrained to be even numbers.
  */
-void omap_vout_new_format(struct v4l2_pix_format *pix,
+void omap_vout_new_format(struct v4l2_pix_format_mplane *pix_mp,
 		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
 		struct v4l2_window *win)
 {
 	/* crop defines the preview source window in the image capture
 	 * buffer
 	 */
-	omap_vout_default_crop(pix, fbuf, crop);
+	omap_vout_default_crop(pix_mp, fbuf, crop);
 
 	/* win defines the preview target window on the display */
 	win->w.width = crop->width;
diff --git a/drivers/media/video/omap/omap_voutlib.h b/drivers/media/video/omap/omap_voutlib.h
index 1d722be..2a6d501 100644
--- a/drivers/media/video/omap/omap_voutlib.h
+++ b/drivers/media/video/omap/omap_voutlib.h
@@ -12,10 +12,10 @@
 #ifndef OMAP_VOUTLIB_H
 #define OMAP_VOUTLIB_H
 
-extern void omap_vout_default_crop(struct v4l2_pix_format *pix,
+extern void omap_vout_default_crop(struct v4l2_pix_format_mplane *pix_mp,
 		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop);
 
-extern int omap_vout_new_crop(struct v4l2_pix_format *pix,
+extern int omap_vout_new_crop(struct v4l2_pix_format_mplane *pix_mp,
 		struct v4l2_rect *crop, struct v4l2_window *win,
 		struct v4l2_framebuffer *fbuf,
 		const struct v4l2_rect *new_crop);
@@ -27,7 +27,7 @@ extern int omap_vout_new_window(struct v4l2_rect *crop,
 		struct v4l2_window *win, struct v4l2_framebuffer *fbuf,
 		struct v4l2_window *new_win);
 
-extern void omap_vout_new_format(struct v4l2_pix_format *pix,
+extern void omap_vout_new_format(struct v4l2_pix_format_mplane *pix_mp,
 		struct v4l2_framebuffer *fbuf, struct v4l2_rect *crop,
 		struct v4l2_window *win);
 extern unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr);
-- 
1.7.1

