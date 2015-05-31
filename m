Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59999 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758140AbbEaNMC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:12:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 8/9] cobalt: simplify colorspace code
Date: Sun, 31 May 2015 15:11:38 +0200
Message-Id: <1433077899-18516-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify cobalt_g/try_fmt_vid_cap by not setting the colorspace fields in
pix again (since v4l2_fill_pix_format does that already), and by using
v4l2_fill_mbus_format in cobalt_s_fmt_vid_out which allows the get_fmt
call to be dropped as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 72b081f..6fb8812 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -737,10 +737,6 @@ static int cobalt_g_fmt_vid_cap(struct file *file, void *priv_fh,
 		sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
 		v4l2_fill_pix_format(pix, &sd_fmt.format);
-		pix->colorspace = sd_fmt.format.colorspace;
-		pix->xfer_func = sd_fmt.format.xfer_func;
-		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
-		pix->quantization = sd_fmt.format.quantization;
 	}
 
 	pix->pixelformat = s->pixfmt;
@@ -783,10 +779,6 @@ static int cobalt_try_fmt_vid_cap(struct file *file, void *priv_fh,
 		sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
 		v4l2_fill_pix_format(pix, &sd_fmt.format);
-		pix->colorspace = sd_fmt.format.colorspace;
-		pix->xfer_func = sd_fmt.format.xfer_func;
-		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
-		pix->quantization = sd_fmt.format.quantization;
 	}
 
 	switch (pix->pixelformat) {
@@ -933,6 +925,7 @@ static int cobalt_s_fmt_vid_out(struct file *file, void *priv_fh,
 	struct cobalt_stream *s = video_drvdata(file);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_format sd_fmt = { 0 };
+	u32 code;
 
 	if (cobalt_try_fmt_vid_out(file, priv_fh, f))
 		return -EINVAL;
@@ -945,9 +938,11 @@ static int cobalt_s_fmt_vid_out(struct file *file, void *priv_fh,
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
 		s->bpp = COBALT_BYTES_PER_PIXEL_YUYV;
+		code = MEDIA_BUS_FMT_UYVY8_1X16;
 		break;
 	case V4L2_PIX_FMT_BGR32:
 		s->bpp = COBALT_BYTES_PER_PIXEL_RGB32;
+		code = MEDIA_BUS_FMT_RGB888_1X24;
 		break;
 	default:
 		return -EINVAL;
@@ -961,11 +956,7 @@ static int cobalt_s_fmt_vid_out(struct file *file, void *priv_fh,
 	s->ycbcr_enc = pix->ycbcr_enc;
 	s->quantization = pix->quantization;
 	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
-	sd_fmt.format.colorspace = pix->colorspace;
-	sd_fmt.format.xfer_func = pix->xfer_func;
-	sd_fmt.format.ycbcr_enc = pix->ycbcr_enc;
-	sd_fmt.format.quantization = pix->quantization;
+	v4l2_fill_mbus_format(&sd_fmt.format, pix, code);
 	v4l2_subdev_call(s->sd, pad, set_fmt, NULL, &sd_fmt);
 	return 0;
 }
-- 
2.1.4

