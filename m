Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:27579 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2GYPsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 11:48:54 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q6PFmrnZ026725
	for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 15:48:53 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.6] vivi: fix a few format-related compliance issues
Date: Wed, 25 Jul 2012 17:48:53 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207251748.53095.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will always set the field to INTERLACED (this fixes a bug were a driver should
never return FIELD_ANY), and will default to YUYV pixelformat if an unknown pixelformat
was specified.

This way S/TRY_FMT will always return a valid format struct.

Regards,

	Hans

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 1e8c4f3..7402561 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -230,7 +230,6 @@ struct vivi_dev {
 	struct vivi_fmt            *fmt;
 	unsigned int               width, height;
 	struct vb2_queue	   vb_vidq;
-	enum v4l2_field		   field;
 	unsigned int		   field_count;
 
 	u8			   bars[9][3];
@@ -623,7 +622,7 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 
 	dev->mv_count += 2;
 
-	buf->vb.v4l2_buf.field = dev->field;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 	dev->field_count++;
 	buf->vb.v4l2_buf.sequence = dev->field_count >> 1;
 	do_gettimeofday(&ts);
@@ -925,7 +924,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
-	f->fmt.pix.field        = dev->field;
+	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;
 	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
@@ -944,25 +943,16 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vivi_dev *dev = video_drvdata(file);
 	struct vivi_fmt *fmt;
-	enum v4l2_field field;
 
 	fmt = get_format(f);
 	if (!fmt) {
-		dprintk(dev, 1, "Fourcc format (0x%08x) invalid.\n",
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
 			f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
-
-	field = f->fmt.pix.field;
-
-	if (field == V4L2_FIELD_ANY) {
-		field = V4L2_FIELD_INTERLACED;
-	} else if (V4L2_FIELD_INTERLACED != field) {
-		dprintk(dev, 1, "Field type invalid.\n");
-		return -EINVAL;
+		f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
+		fmt = get_format(f);
 	}
 
-	f->fmt.pix.field = field;
+	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	v4l_bound_align_image(&f->fmt.pix.width, 48, MAX_WIDTH, 2,
 			      &f->fmt.pix.height, 32, MAX_HEIGHT, 0, 0);
 	f->fmt.pix.bytesperline =
@@ -996,7 +986,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->pixelsize = dev->fmt->depth / 8;
 	dev->width = f->fmt.pix.width;
 	dev->height = f->fmt.pix.height;
-	dev->field = f->fmt.pix.field;
 
 	return 0;
 }
