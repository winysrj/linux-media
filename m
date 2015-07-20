Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34179 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbbGTNKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] fsl-viu: drop format names
Date: Mon, 20 Jul 2015 15:09:33 +0200
Message-Id: <1437397773-5752-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The names of the pixelformats is set by the core. So there no longer
is any need for drivers to fill it in.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 69ee2b6..ae8c6b3 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -55,7 +55,6 @@ static int info_level;
  * Basic structures
  */
 struct viu_fmt {
-	char  name[32];
 	u32   fourcc;		/* v4l2 format id */
 	u32   pixelformat;
 	int   depth;
@@ -63,12 +62,10 @@ struct viu_fmt {
 
 static struct viu_fmt formats[] = {
 	{
-		.name		= "RGB-16 (5/B-6/G-5/R)",
 		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.pixelformat	= V4L2_PIX_FMT_RGB565,
 		.depth		= 16,
 	}, {
-		.name		= "RGB-32 (A-R-G-B)",
 		.fourcc		= V4L2_PIX_FMT_RGB32,
 		.pixelformat	= V4L2_PIX_FMT_RGB32,
 		.depth		= 32,
@@ -584,7 +581,6 @@ static int vidioc_enum_fmt(struct file *file, void  *priv,
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[index].name, sizeof(f->description));
 	f->pixelformat = formats[index].fourcc;
 	return 0;
 }
@@ -655,7 +651,6 @@ static int vidioc_s_fmt_cap(struct file *file, void *priv,
 	fh->sizeimage     = f->fmt.pix.sizeimage;
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type          = f->type;
-	dprintk(1, "set to pixelformat '%4.6s'\n", (char *)&fh->fmt->name);
 	return 0;
 }
 
@@ -721,8 +716,8 @@ static int viu_setup_preview(struct viu_dev *dev, struct viu_fh *fh)
 {
 	int bpp;
 
-	dprintk(1, "%s %dx%d %s\n", __func__,
-		fh->win.w.width, fh->win.w.height, dev->ovfmt->name);
+	dprintk(1, "%s %dx%d\n", __func__,
+		fh->win.w.width, fh->win.w.height);
 
 	reg_val.status_cfg = 0;
 
-- 
2.1.4

