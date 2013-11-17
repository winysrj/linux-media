Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58548 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3KQUW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:22:26 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 4/7] msi3101: implement FMT IOCTLs
Date: Sun, 17 Nov 2013 22:22:08 +0200
Message-Id: <1384719731-21887-4-git-send-email-crope@iki.fi>
In-Reply-To: <1384719731-21887-1-git-send-email-crope@iki.fi>
References: <1384719731-21887-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_ENUM_FMT, VIDIOC_G_FMT, VIDIOC_S_FMT and VIDIOC_TRY_FMT.

Implement 8-bit signed stream (type '504' samples per USB packet)
using FMT.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 165 +++++++++++++++++++++-------
 1 file changed, 123 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 7715c85..82386a8 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -385,6 +385,22 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
+/* stream formats */
+struct msi3101_format {
+	char	*name;
+	u32	pixelformat;
+};
+
+/* format descriptions for capture and preview */
+static struct msi3101_format formats[] = {
+	{
+		.name		= "I/Q 8-bit signed",
+		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
+	},
+};
+
+static const int NUM_FORMATS = sizeof(formats) / sizeof(struct msi3101_format);
+
 /* intermediate buffers with raw data from the USB device */
 struct msi3101_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
@@ -407,6 +423,8 @@ struct msi3101_state {
 	/* Pointer to our usb_device, will be NULL after unplug */
 	struct usb_device *udev; /* Both mutexes most be hold when setting! */
 
+	u32 pixelformat;
+
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
 	unsigned int vb_full; /* vb is full and packets dropped */
 
@@ -445,7 +463,6 @@ leave:
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 	return buf;
 }
-
 /*
  * +===========================================================================
  * |   00-1023 | USB packet type '384'
@@ -502,40 +519,22 @@ leave:
 #define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
 
 /*
- * Converts signed 8-bit integer into 32-bit IEEE floating point
- * representation.
+ * +===========================================================================
+ * |   00-1023 | USB packet type '504'
+ * +===========================================================================
+ * |   00-  03 | sequence number of first sample in that USB packet
+ * +---------------------------------------------------------------------------
+ * |   04-  15 | garbage
+ * +---------------------------------------------------------------------------
+ * |   16-1023 | samples
+ * +---------------------------------------------------------------------------
+ * signed 8-bit sample
+ * 504 * 2 = 1008 samples
  */
-static u32 msi3101_convert_sample_504(struct msi3101_state *s, u16 x)
-{
-	u32 msb, exponent, fraction, sign;
-
-	/* Zero is special */
-	if (!x)
-		return 0;
-
-	/* Negative / positive value */
-	if (x & (1 << 7)) {
-		x = -x;
-		x &= 0x7f; /* result is 7 bit ... + sign */
-		sign = 1 << 31;
-	} else {
-		sign = 0 << 31;
-	}
-
-	/* Get location of the most significant bit */
-	msb = __fls(x);
-
-	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
-	exponent = (127 + msb) << I2F_FRAC_BITS;
-
-	return (fraction + exponent) | sign;
-}
-
-static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
+static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 		u8 *src, unsigned int src_len)
 {
-	int i, j, i_max, dst_len = 0;
-	u16 sample[2];
+	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
 
 	/* There could be 1-3 1024 bytes URB frames */
@@ -556,17 +555,12 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
 
+		/* 504 x I+Q samples */
 		src += 16;
-		for (j = 0; j < 1008; j += 2) {
-			sample[0] = src[j + 0];
-			sample[1] = src[j + 1];
-
-			*dst++ = msi3101_convert_sample_504(s, sample[0]);
-			*dst++ = msi3101_convert_sample_504(s, sample[1]);
-		}
-		/* 504 x I+Q 32bit float samples */
-		dst_len += 504 * 2 * 4;
+		memcpy(dst, src, 1008);
 		src += 1008;
+		dst += 1008;
+		dst_len += 1008;
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
@@ -1114,7 +1108,6 @@ static int msi3101_querycap(struct file *file, void *fh,
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE;
-	cap->device_caps = V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -1232,6 +1225,11 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 		reg7 = 0x000c9407;
 	}
 
+	if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
+		s->convert_stream = msi3101_convert_stream_504;
+		reg7 = 0x000c9407;
+	}
+
 	/*
 	 * Synthesizer config is just a educated guess...
 	 *
@@ -1626,6 +1624,84 @@ static int msi3101_s_input(struct file *file, void *fh, unsigned int i)
 	return i ? -EINVAL : 0;
 }
 
+static int msi3101_enum_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_fmtdesc *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	f->pixelformat = formats[f->index].pixelformat;
+
+	return 0;
+}
+
+static int msi3101_g_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	f->fmt.pix.pixelformat = s->pixelformat;
+
+	return 0;
+}
+
+static int msi3101_s_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	struct vb2_queue *q = &s->vb_queue;
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.pix.pixelformat);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.pix.pixelformat) {
+			s->pixelformat = f->fmt.pix.pixelformat;
+			return 0;
+		}
+	}
+
+	f->fmt.pix.pixelformat = formats[0].pixelformat;
+	s->pixelformat = formats[0].pixelformat;
+
+	return 0;
+}
+
+static int msi3101_try_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.pix.pixelformat);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.pix.pixelformat)
+			return 0;
+	}
+
+	f->fmt.pix.pixelformat = formats[0].pixelformat;
+
+	return 0;
+}
+
 static int vidioc_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
@@ -1660,6 +1736,11 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_querycap          = msi3101_querycap,
 
+	.vidioc_enum_fmt_vid_cap  = msi3101_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = msi3101_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = msi3101_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = msi3101_try_fmt_vid_cap,
+
 	.vidioc_enum_input        = msi3101_enum_input,
 	.vidioc_g_input           = msi3101_g_input,
 	.vidioc_s_input           = msi3101_s_input,
-- 
1.8.4.2

