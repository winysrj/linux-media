Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44382 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbbFEK75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:59:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/10] sh-vou: fix bytesperline
Date: Fri,  5 Jun 2015 12:59:25 +0200
Message-Id: <1433501966-30176-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
References: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
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
index 489d045..d431cb1 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -135,6 +135,7 @@ struct sh_vou_fmt {
 	u32		pfmt;
 	char		*desc;
 	unsigned char	bpp;
+	unsigned char	bpl;
 	unsigned char	rgb;
 	unsigned char	yf;
 	unsigned char	pkf;
@@ -145,6 +146,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_NV12,
 		.bpp	= 12,
+		.bpl	= 1,
 		.desc	= "YVU420 planar",
 		.yf	= 0,
 		.rgb	= 0,
@@ -152,6 +154,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_NV16,
 		.bpp	= 16,
+		.bpl	= 1,
 		.desc	= "YVYU planar",
 		.yf	= 1,
 		.rgb	= 0,
@@ -159,6 +162,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB24,
 		.bpp	= 24,
+		.bpl	= 3,
 		.desc	= "RGB24",
 		.pkf	= 2,
 		.rgb	= 1,
@@ -166,6 +170,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB565,
 		.bpp	= 16,
+		.bpl	= 2,
 		.desc	= "RGB565",
 		.pkf	= 3,
 		.rgb	= 1,
@@ -173,6 +178,7 @@ static struct sh_vou_fmt vou_fmt[] = {
 	{
 		.pfmt	= V4L2_PIX_FMT_RGB565X,
 		.bpp	= 16,
+		.bpl	= 2,
 		.desc	= "RGB565 byteswapped",
 		.pkf	= 3,
 		.rgb	= 1,
@@ -703,7 +709,8 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
 
 	v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 2,
 			      &pix->height, 0, img_height_max, 1, 0);
-	pix->bytesperline = pix->width * 2;
+	pix->bytesperline = pix->width * vou_fmt[pix_idx].bpl;
+	pix->sizeimage = pix->height * ((pix->width * vou_fmt[pix_idx].bpp) >> 3);
 
 	return 0;
 }
@@ -1380,7 +1387,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	pix->height		= 480;
 	pix->pixelformat	= V4L2_PIX_FMT_NV16;
 	pix->field		= V4L2_FIELD_NONE;
-	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH * 2;
+	pix->bytesperline	= VOU_MAX_IMAGE_WIDTH;
 	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
 	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
 
-- 
2.1.4

