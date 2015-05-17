Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbbEQLfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 07:35:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: SDR cap add 'CU08' Complex U8 format
Date: Sun, 17 May 2015 14:34:37 +0300
Message-Id: <1431862477-3967-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add complex unsigned 8-bit sample format for SDR capture.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/platform/vivid/vivid-core.c    |  7 +-
 drivers/media/platform/vivid/vivid-core.h    |  2 +
 drivers/media/platform/vivid/vivid-sdr-cap.c | 96 ++++++++++++++++++++++++----
 drivers/media/platform/vivid/vivid-sdr-cap.h |  2 +
 4 files changed, 94 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index d6caeeb..a047b47 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -559,8 +559,8 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 
 	.vidioc_enum_fmt_sdr_cap	= vidioc_enum_fmt_sdr_cap,
 	.vidioc_g_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
-	.vidioc_try_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
-	.vidioc_s_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap		= vidioc_try_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap		= vidioc_s_fmt_sdr_cap,
 
 	.vidioc_overlay			= vidioc_overlay,
 	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
@@ -977,6 +977,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	dev->radio_tx_subchans = V4L2_TUNER_SUB_STEREO | V4L2_TUNER_SUB_RDS;
 	dev->sdr_adc_freq = 300000;
 	dev->sdr_fm_freq = 50000000;
+	dev->sdr_pixelformat = V4L2_SDR_FMT_CU8;
+	dev->sdr_buffersize = SDR_CAP_SAMPLES_PER_BUF * 2;
+
 	dev->edid_max_blocks = dev->edid_blocks = 2;
 	memcpy(dev->edid, vivid_hdmi_edid, sizeof(vivid_hdmi_edid));
 	ktime_get_ts(&dev->radio_rds_init_ts);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index bf26173..aa1b523 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -446,6 +446,8 @@ struct vivid_dev {
 	/* SDR capture */
 	struct vb2_queue		vb_sdr_cap_q;
 	struct list_head		sdr_cap_active;
+	u32				sdr_pixelformat; /* v4l2 format id */
+	unsigned			sdr_buffersize;
 	unsigned			sdr_adc_freq;
 	unsigned			sdr_fm_freq;
 	int				sdr_fixp_src_phase;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index caf1316..d2f2188 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -33,6 +33,25 @@
 #include "vivid-ctrls.h"
 #include "vivid-sdr-cap.h"
 
+/* stream formats */
+struct vivid_format {
+	u32	pixelformat;
+	u32	buffersize;
+};
+
+/* format descriptions for capture and preview */
+static struct vivid_format formats[] = {
+	{
+		.pixelformat	= V4L2_SDR_FMT_CU8,
+		.buffersize	= SDR_CAP_SAMPLES_PER_BUF * 2,
+	}, {
+		.pixelformat	= V4L2_SDR_FMT_CS8,
+		.buffersize	= SDR_CAP_SAMPLES_PER_BUF * 2,
+	},
+};
+
+static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
+
 static const struct v4l2_frequency_band bands_adc[] = {
 	{
 		.tuner = 0,
@@ -409,21 +428,63 @@ int vivid_sdr_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
 
 int vidioc_enum_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
-	if (f->index)
+	if (f->index >= ARRAY_SIZE(formats))
 		return -EINVAL;
-	f->pixelformat = V4L2_SDR_FMT_CU8;
-	strlcpy(f->description, "IQ U8", sizeof(f->description));
+	f->pixelformat = formats[f->index].pixelformat;
 	return 0;
 }
 
 int vidioc_g_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 {
-	f->fmt.sdr.pixelformat = V4L2_SDR_FMT_CU8;
-	f->fmt.sdr.buffersize = SDR_CAP_SAMPLES_PER_BUF * 2;
+	struct vivid_dev *dev = video_drvdata(file);
+
+	f->fmt.sdr.pixelformat = dev->sdr_pixelformat;
+	f->fmt.sdr.buffersize = dev->sdr_buffersize;
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	return 0;
 }
 
+int vidioc_s_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct vb2_queue *q = &dev->vb_sdr_cap_q;
+	int i;
+
+	if (vb2_is_busy(q))
+		return -EBUSY;
+
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			dev->sdr_pixelformat = formats[i].pixelformat;
+			dev->sdr_buffersize = formats[i].buffersize;
+			f->fmt.sdr.buffersize = formats[i].buffersize;
+			return 0;
+		}
+	}
+	dev->sdr_pixelformat = formats[0].pixelformat;
+	dev->sdr_buffersize = formats[0].buffersize;
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.buffersize = formats[0].buffersize;
+	return 0;
+}
+
+int vidioc_try_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
+{
+	int i;
+
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			f->fmt.sdr.buffersize = formats[i].buffersize;
+			return 0;
+		}
+	}
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.buffersize = formats[0].buffersize;
+	return 0;
+}
+
 #define FIXP_N    (15)
 #define FIXP_FRAC (1 << FIXP_N)
 #define FIXP_2PI  ((int)(2 * 3.141592653589 * FIXP_FRAC))
@@ -477,11 +538,24 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		fixp_i >>= (31 - FIXP_N);
 		fixp_q >>= (31 - FIXP_N);
 
-		/* convert 'fixp float' to u8 */
-		/* u8 = X * 127.5f + 127.5f; where X is float [-1.0 / +1.0] */
-		fixp_i = fixp_i * 1275 + FIXP_FRAC * 1275;
-		fixp_q = fixp_q * 1275 + FIXP_FRAC * 1275;
-		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
-		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
+		switch (dev->sdr_pixelformat) {
+		case V4L2_SDR_FMT_CU8:
+			/* convert 'fixp float' to u8 */
+			/* u8 = X * 127.5 + 127.5; X is float [-1.0, +1.0] */
+			fixp_i = fixp_i * 1275 + FIXP_FRAC * 1275;
+			fixp_q = fixp_q * 1275 + FIXP_FRAC * 1275;
+			*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
+			*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
+			break;
+		case V4L2_SDR_FMT_CS8:
+			/* convert 'fixp float' to s8 */
+			fixp_i = fixp_i * 1275;
+			fixp_q = fixp_q * 1275;
+			*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
+			*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
+			break;
+		default:
+			break;
+		}
 	}
 }
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.h b/drivers/media/platform/vivid/vivid-sdr-cap.h
index 79c1890..43014b2 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.h
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.h
@@ -27,6 +27,8 @@ int vivid_sdr_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt);
 int vivid_sdr_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt);
 int vidioc_enum_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_fmtdesc *f);
 int vidioc_g_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f);
+int vidioc_s_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f);
+int vidioc_try_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f);
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf);
 
 extern const struct vb2_ops vivid_sdr_cap_qops;
-- 
http://palosaari.fi/

