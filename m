Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59264 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbbFGI6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 10/11] sh-vou: fix bytesperline
Date: Sun,  7 Jun 2015 10:58:04 +0200
Message-Id: <1433667485-35711-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The bytesperline values were wrong for planar formats where bytesperline is
the line length for the first plane.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 872da9a..22b32ec 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -133,6 +133,7 @@ struct sh_vou_fmt {
 	u32		pfmt;
 	char		*desc;
 	unsigned char	bpp;
+	unsigned char	bpl;
 	unsigned char	rgb;
 	unsigned char	yf;
 	unsigned char	pkf;
@@ -143,6 +144,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_NV12,
 		.bpp	= 12,
+		.bpl	= 1,
 		.desc	= "YVU420 planar",
 		.yf	= 0,
 		.rgb	= 0,
@@ -150,6 +152,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_NV16,
 		.bpp	= 16,
+		.bpl	= 1,
 		.desc	= "YVYU planar",
 		.yf	= 1,
 		.rgb	= 0,
@@ -157,6 +160,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB24,
 		.bpp	= 24,
+		.bpl	= 3,
 		.desc	= "RGB24",
 		.pkf	= 2,
 		.rgb	= 1,
@@ -164,6 +168,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB565,
 		.bpp	= 16,
+		.bpl	= 2,
 		.desc	= "RGB565",
 		.pkf	= 3,
 		.rgb	= 1,
@@ -171,6 +176,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB565X,
 		.bpp	= 16,
+		.bpl	= 2,
 		.desc	= "RGB565 byteswapped",
 		.pkf	= 3,
 		.rgb	= 1,
@@ -701,7 +707,8 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 2,
 			      &pix->height, 0, img_height_max, 1, 0);
-	pix->bytesperline = pix->width * 2;
+	pix->bytesperline = pix->width * vou_fmt[pix_idx].bpl;
+	pix->sizeimage = pix->height * ((pix->width * vou_fmt[pix_idx].bpp) >> 3);
 
 	return 0;
 }
@@ -1372,7 +1379,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	pix->height		= 480;
 	pix->pixelformat	= V4L2_PIX_FMT_NV16;
 	pix->field		= V4L2_FIELD_NONE;
-	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH * 2;
+	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH;
 	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
 	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
 
-- 
2.1.4

