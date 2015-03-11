Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43990 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbbCKILM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 04:11:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 21/21] marvell-ccic: drop support for PIX_FMT_422P
Date: Wed, 11 Mar 2015 09:10:28 +0100
Message-Id: <1426061428-47019-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I cannot get this format to work, the colors keep coming out wrong.
Since this has never worked I just drop support for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index c522c75..d588445 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -124,13 +124,6 @@ static struct mcam_format_struct {
 		.planar		= false,
 	},
 	{
-		.desc		= "YUV 4:2:2 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YUV422P,
-		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
-		.bpp		= 1,
-		.planar		= true,
-	},
-	{
 		.desc		= "YUV 4:2:0 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YUV420,
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
@@ -352,10 +345,6 @@ static void mcam_write_yuv_bases(struct mcam_camera *cam,
 	y = base;
 
 	switch (fmt->pixelformat) {
-	case V4L2_PIX_FMT_YUV422P:
-		u = y + pixel_count;
-		v = u + pixel_count / 2;
-		break;
 	case V4L2_PIX_FMT_YUV420:
 		u = y + pixel_count;
 		v = u + pixel_count / 4;
@@ -755,7 +744,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 		widthy = fmt->width * 2;
 		widthuv = 0;
 		break;
-	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 		widthy = fmt->width;
@@ -776,10 +764,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	 * Tell the controller about the image format we are using.
 	 */
 	switch (fmt->pixelformat) {
-	case V4L2_PIX_FMT_YUV422P:
-		mcam_reg_write_mask(cam, REG_CTRL0,
-			C0_DF_YUV | C0_YUV_PLANAR | C0_YUVE_YVYU, C0_DF_MASK);
-		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 		mcam_reg_write_mask(cam, REG_CTRL0,
@@ -1374,9 +1358,6 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	v4l2_fill_pix_format(pix, &mbus_fmt);
 	pix->bytesperline = pix->width * f->bpp;
 	switch (f->pixelformat) {
-	case V4L2_PIX_FMT_YUV422P:
-		pix->sizeimage = pix->height * pix->bytesperline * 2;
-		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 		pix->sizeimage = pix->height * pix->bytesperline * 3 / 2;
-- 
2.1.4

