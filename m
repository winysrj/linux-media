Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47508 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaAYRLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:03 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/52] rtl2832_sdr: implement FMT IOCTLs
Date: Sat, 25 Jan 2014 19:10:07 +0200
Message-Id: <1390669846-8131-14-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_ENUM_FMT, VIDIOC_G_FMT, VIDIOC_S_FMT and VIDIOC_TRY_FMT.
Return stream according to FMT.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 125 ++++++++++++++---------
 1 file changed, 75 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index d3db859..348df05 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -291,56 +291,10 @@ leave:
 	return buf;
 }
 
-/*
- * Integer to 32-bit IEEE floating point representation routine is taken
- * from Radeon R600 driver (drivers/gpu/drm/radeon/r600_blit_kms.c).
- *
- * TODO: Currently we do conversion here in Kernel, but in future that will
- * be moved to the libv4l2 library as video format conversions are.
- */
-#define I2F_FRAC_BITS  23
-#define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
-
-/*
- * Converts signed 8-bit integer into 32-bit IEEE floating point
- * representation.
- */
-static u32 rtl2832_sdr_convert_sample(struct rtl2832_sdr_state *s, u16 x)
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
 static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
-		u32 *dst, const u8 *src, unsigned int src_len)
+		u8 *dst, const u8 *src, unsigned int src_len)
 {
-	unsigned int i, dst_len = 0;
-
-	for (i = 0; i < src_len; i++)
-		*dst++ = rtl2832_sdr_convert_sample(s, src[i]);
-
-	/* 8-bit to 32-bit IEEE floating point */
-	dst_len = src_len * 4;
+	memcpy(dst, src, src_len);
 
 	/* calculate samping rate and output it in 10 seconds intervals */
 	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
@@ -358,7 +312,7 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
 	/* total number of I+Q pairs */
 	s->sample += src_len / 2;
 
-	return dst_len;
+	return src_len;
 }
 
 /*
@@ -591,7 +545,6 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE;
-	cap->device_caps = V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -1014,9 +967,81 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 			f->frequency * 625UL / 10UL);
 }
 
+static int rtl2832_sdr_enum_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_fmtdesc *f)
+{
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (f->index > 0)
+		return -EINVAL;
+
+	f->flags = 0;
+	strcpy(f->description, "I/Q 8-bit unsigned");
+	f->pixelformat = V4L2_PIX_FMT_SDR_U8;
+
+	return 0;
+}
+
+static int rtl2832_sdr_g_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+
+	return 0;
+}
+
+static int rtl2832_sdr_s_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	struct vb2_queue *q = &s->vb_queue;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.pix.pixelformat);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+
+	return 0;
+}
+
+static int rtl2832_sdr_try_fmt_vid_cap(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+			(char *)&f->fmt.pix.pixelformat);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+
+	return 0;
+}
+
 static const struct v4l2_ioctl_ops rtl2832_sdr_ioctl_ops = {
 	.vidioc_querycap          = rtl2832_sdr_querycap,
 
+	.vidioc_enum_fmt_vid_cap  = rtl2832_sdr_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap     = rtl2832_sdr_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap     = rtl2832_sdr_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap   = rtl2832_sdr_try_fmt_vid_cap,
+
 	.vidioc_enum_input        = rtl2832_sdr_enum_input,
 	.vidioc_g_input           = rtl2832_sdr_g_input,
 	.vidioc_s_input           = rtl2832_sdr_s_input,
-- 
1.8.5.3

