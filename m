Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:42715 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbbCIVbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:31:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/18] marvell-ccic: fix the bytesperline and sizeimage calculations
Date: Mon,  9 Mar 2015 22:22:22 +0100
Message-Id: <1425936143-5658-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These were calculated incorrectly for the planar formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 1a32610..9343051 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -127,21 +127,21 @@ static struct mcam_format_struct {
 		.desc		= "YUV 4:2:2 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YUV422P,
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
+		.bpp		= 1,
 		.planar		= true,
 	},
 	{
 		.desc		= "YUV 4:2:0 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YUV420,
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
+		.bpp		= 1,
 		.planar		= true,
 	},
 	{
 		.desc		= "YVU 4:2:0 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YVU420,
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
+		.bpp		= 1,
 		.planar		= true,
 	},
 	{
@@ -764,6 +764,7 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	default:
 		widthy = fmt->bytesperline;
 		widthuv = 0;
+		break;
 	}
 
 	mcam_reg_write_mask(cam, REG_IMGPITCH, widthuv << 16 | widthy,
@@ -1370,16 +1371,19 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
 	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(pix, &mbus_fmt);
+	pix->bytesperline = pix->width * f->bpp;
 	switch (f->pixelformat) {
+	case V4L2_PIX_FMT_YUV422P:
+		pix->sizeimage = pix->height * pix->bytesperline * 2;
+		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
-		pix->bytesperline = pix->width * 3 / 2;
+		pix->sizeimage = pix->height * pix->bytesperline * 3 / 2;
 		break;
 	default:
-		pix->bytesperline = pix->width * f->bpp;
+		pix->sizeimage = pix->height * pix->bytesperline;
 		break;
 	}
-	pix->sizeimage = pix->height * pix->bytesperline;
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
 	return ret;
 }
-- 
2.1.4

