Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48057 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbbEaNMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:12:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/9] cobalt: support transfer function
Date: Sun, 31 May 2015 15:11:37 +0200
Message-Id: <1433077899-18516-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the transfer function to the cobalt driver: make sure it is
passed on to/retrieved from the sub-device correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-driver.h | 1 +
 drivers/media/pci/cobalt/cobalt-v4l2.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index f63ce19..c206df9 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -231,6 +231,7 @@ struct cobalt_stream {
 	u32 pixfmt;
 	u32 sequence;
 	u32 colorspace;
+	u32 xfer_func;
 	u32 ycbcr_enc;
 	u32 quantization;
 
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 8b14bec..72b081f 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -170,6 +170,7 @@ static void cobalt_enable_output(struct cobalt_stream *s)
 	}
 
 	sd_fmt.format.colorspace = s->colorspace;
+	sd_fmt.format.xfer_func = s->xfer_func;
 	sd_fmt.format.ycbcr_enc = s->ycbcr_enc;
 	sd_fmt.format.quantization = s->quantization;
 	sd_fmt.format.width = bt->width;
@@ -737,6 +738,7 @@ static int cobalt_g_fmt_vid_cap(struct file *file, void *priv_fh,
 		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
 		v4l2_fill_pix_format(pix, &sd_fmt.format);
 		pix->colorspace = sd_fmt.format.colorspace;
+		pix->xfer_func = sd_fmt.format.xfer_func;
 		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
 		pix->quantization = sd_fmt.format.quantization;
 	}
@@ -782,6 +784,7 @@ static int cobalt_try_fmt_vid_cap(struct file *file, void *priv_fh,
 		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
 		v4l2_fill_pix_format(pix, &sd_fmt.format);
 		pix->colorspace = sd_fmt.format.colorspace;
+		pix->xfer_func = sd_fmt.format.xfer_func;
 		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
 		pix->quantization = sd_fmt.format.quantization;
 	}
@@ -897,6 +900,7 @@ static int cobalt_g_fmt_vid_out(struct file *file, void *priv_fh,
 	pix->field = V4L2_FIELD_NONE;
 	pix->pixelformat = s->pixfmt;
 	pix->colorspace = s->colorspace;
+	pix->xfer_func = s->xfer_func;
 	pix->ycbcr_enc = s->ycbcr_enc;
 	pix->quantization = s->quantization;
 	pix->sizeimage = pix->bytesperline * pix->height;
@@ -953,11 +957,13 @@ static int cobalt_s_fmt_vid_out(struct file *file, void *priv_fh,
 	s->stride = pix->bytesperline;
 	s->pixfmt = pix->pixelformat;
 	s->colorspace = pix->colorspace;
+	s->xfer_func = pix->xfer_func;
 	s->ycbcr_enc = pix->ycbcr_enc;
 	s->quantization = pix->quantization;
 	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
 	sd_fmt.format.colorspace = pix->colorspace;
+	sd_fmt.format.xfer_func = pix->xfer_func;
 	sd_fmt.format.ycbcr_enc = pix->ycbcr_enc;
 	sd_fmt.format.quantization = pix->quantization;
 	v4l2_subdev_call(s->sd, pad, set_fmt, NULL, &sd_fmt);
-- 
2.1.4

