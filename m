Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbH1Ltg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 5/8] saa7164: fix format ioctls
Date: Fri, 28 Aug 2015 13:48:30 +0200
Message-Id: <1440762513-30457-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix various v4l2-compliance issues in the formatting ioctls:

- the vbi device implemented video format ioctls which make no senses
  for a vbi device, remove them.
- remove the unused ts_packet_size and ts_packet_count fields.
- fill in colorspace and field.
- fill in sizeimage with a default value.
- for the video node the get, set and try format functions all do the
  same thing, so combine into a single function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 68 ++++++++------------------
 drivers/media/pci/saa7164/saa7164-vbi.c     | 75 +----------------------------
 drivers/media/pci/saa7164/saa7164.h         |  2 -
 3 files changed, 20 insertions(+), 125 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 3bd76c4..10f4d77 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -25,6 +25,18 @@
 #define ENCODER_MIN_BITRATE 1000000
 #define ENCODER_DEF_BITRATE 5000000
 
+/*
+ * This is a dummy non-zero value for the sizeimage field of v4l2_pix_format.
+ * It is not actually used for anything since this driver does not support
+ * stream I/O, only read(), and because this driver produces an MPEG stream
+ * and not discrete frames. But the V4L2 spec doesn't allow for this value
+ * to be 0, so set it to 0x10000 instead.
+ *
+ * If we ever change this driver to support stream I/O, then this field
+ * will be the size of the streaming buffers.
+ */
+#define SAA7164_SIZEIMAGE (0x10000)
+
 static struct saa7164_tvnorm saa7164_tvnorms[] = {
 	{
 		.name      = "NTSC-M",
@@ -489,60 +501,19 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+static int vidioc_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
 	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
+	f->fmt.pix.sizeimage    = SAA7164_SIZEIMAGE;
+	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.width        = port->width;
 	f->fmt.pix.height       = port->height;
-
-	dprintk(DBGLVL_ENC, "VIDIOC_G_FMT: w: %d, h: %d\n",
-		port->width, port->height);
-
-	return 0;
-}
-
-static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-	dprintk(DBGLVL_ENC, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
-		port->width, port->height);
-	return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-
-	dprintk(DBGLVL_ENC, "VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
-		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
-
 	return 0;
 }
 
@@ -973,10 +944,9 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_frequency	 = vidioc_s_frequency,
 	.vidioc_querycap	 = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	 = vidioc_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	 = vidioc_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	 = vidioc_fmt_vid_cap,
 	.vidioc_log_status	 = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event  = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 2f9c87d..0d8052d 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -388,75 +388,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
-	struct v4l2_fmtdesc *f)
-{
-	if (f->index != 0)
-		return -EINVAL;
-
-	strlcpy(f->description, "VBI", sizeof(f->description));
-	f->pixelformat = V4L2_PIX_FMT_MPEG;
-
-	return 0;
-}
-
-static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-	f->fmt.pix.width        = port->width;
-	f->fmt.pix.height       = port->height;
-
-	dprintk(DBGLVL_VBI, "VIDIOC_G_FMT: w: %d, h: %d\n",
-		port->width, port->height);
-
-	return 0;
-}
-
-static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-	dprintk(DBGLVL_VBI, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
-		port->width, port->height);
-	return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
-	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    =
-		port->ts_packet_size * port->ts_packet_count;
-	f->fmt.pix.colorspace   = 0;
-
-	dprintk(DBGLVL_VBI, "VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
-		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
-
-	return 0;
-}
-
 static int saa7164_vbi_stop_port(struct saa7164_port *port)
 {
 	struct saa7164_dev *dev = port->dev;
@@ -646,7 +577,6 @@ static int saa7164_vbi_fmt(struct file *file, void *priv,
 			   struct v4l2_format *f)
 {
 	/* ntsc */
-	f->fmt.vbi.samples_per_line = 1600;
 	f->fmt.vbi.samples_per_line = 1440;
 	f->fmt.vbi.sampling_rate = 27000000;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -656,6 +586,7 @@ static int saa7164_vbi_fmt(struct file *file, void *priv,
 	f->fmt.vbi.count[0] = 18;
 	f->fmt.vbi.start[1] = 263 + 10 + 1;
 	f->fmt.vbi.count[1] = 18;
+	memset(f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 	return 0;
 }
 
@@ -906,10 +837,6 @@ static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
 	.vidioc_querycap	 = vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_try_fmt_vbi_cap	 = saa7164_vbi_fmt,
 	.vidioc_s_fmt_vbi_cap	 = saa7164_vbi_fmt,
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 1d8e95d..f8e54d5 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -390,8 +390,6 @@ struct saa7164_port {
 	u32 height;
 	u32 width;
 	u32 freq;
-	u32 ts_packet_size;
-	u32 ts_packet_count;
 	u8 mux_input;
 	u8 encoder_profile;
 	u8 video_format;
-- 
2.1.4

