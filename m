Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46806 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933508AbbDYPnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/12] dt3155v4l: fix format handling
Date: Sat, 25 Apr 2015 17:42:49 +0200
Message-Id: <1429976571-34872-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix various v4l2-compliance issues regarding format handling.

Main problem was a missing colorspace value and incorrect format
checks. This driver supports a single format only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 52 +++++------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index f026ab6..450728f 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -29,18 +29,6 @@
 
 #define DT3155_DEVICE_ID 0x1223
 
-static const struct v4l2_fmtdesc frame_std[] = {
-	{
-	.index = 0,
-	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-	.flags = 0,
-	.description = "8-bit Greyscale",
-	.pixelformat = V4L2_PIX_FMT_GREY,
-	},
-};
-
-#define NUM_OF_FORMATS ARRAY_SIZE(frame_std)
-
 /**
  * read_i2c_reg - reads an internal i2c register
  *
@@ -330,51 +318,27 @@ static int dt3155_querycap(struct file *filp, void *p, struct v4l2_capability *c
 
 static int dt3155_enum_fmt_vid_cap(struct file *filp, void *p, struct v4l2_fmtdesc *f)
 {
-	if (f->index >= NUM_OF_FORMATS)
+	if (f->index)
 		return -EINVAL;
-	*f = frame_std[f->index];
+	f->pixelformat = V4L2_PIX_FMT_GREY;
+	strcpy(f->description, "8-bit Greyscale");
 	return 0;
 }
 
-static int dt3155_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
+static int dt3155_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
 	f->fmt.pix.width = pd->width;
 	f->fmt.pix.height = pd->height;
 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.bytesperline = f->fmt.pix.width;
 	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height;
-	f->fmt.pix.colorspace = 0;
-	f->fmt.pix.priv = 0;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	return 0;
 }
 
-static int dt3155_try_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
-{
-	struct dt3155_priv *pd = video_drvdata(filp);
-
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (f->fmt.pix.width == pd->width &&
-		f->fmt.pix.height == pd->height &&
-		f->fmt.pix.pixelformat == V4L2_PIX_FMT_GREY &&
-		f->fmt.pix.field == V4L2_FIELD_NONE &&
-		f->fmt.pix.bytesperline == f->fmt.pix.width &&
-		f->fmt.pix.sizeimage == f->fmt.pix.width * f->fmt.pix.height)
-			return 0;
-	else
-		return -EINVAL;
-}
-
-static int dt3155_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
-{
-	return dt3155_g_fmt_vid_cap(filp, p, f);
-}
-
 static int dt3155_g_std(struct file *filp, void *p, v4l2_std_id *norm)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
@@ -431,9 +395,9 @@ static int dt3155_s_input(struct file *filp, void *p, unsigned int i)
 static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
 	.vidioc_querycap = dt3155_querycap,
 	.vidioc_enum_fmt_vid_cap = dt3155_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap = dt3155_try_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap = dt3155_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = dt3155_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = dt3155_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = dt3155_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = dt3155_fmt_vid_cap,
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs = vb2_ioctl_create_bufs,
 	.vidioc_querybuf = vb2_ioctl_querybuf,
-- 
2.1.4

