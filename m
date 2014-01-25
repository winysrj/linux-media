Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49977 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaAYRLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:07 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 36/52] msi3101: convert to SDR API
Date: Sat, 25 Jan 2014 19:10:30 +0200
Message-Id: <1390669846-8131-37-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert to SDR API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 218 ++++++++++++++++++----------
 1 file changed, 142 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 16ce417..502d35d 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -386,10 +386,39 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
-#define V4L2_PIX_FMT_SDR_S12     v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
-#define V4L2_PIX_FMT_SDR_S14     v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
+#define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
+#define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
+static const struct v4l2_frequency_band bands_adc[] = {
+	{
+		.tuner = 0,
+		.type = V4L2_TUNER_ADC,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  1200000,
+		.rangehigh  = 15000000,
+	},
+};
+
+static const struct v4l2_frequency_band bands_rf[] = {
+	{
+		.tuner = 1,
+		.type = V4L2_TUNER_RF,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =   49000000 / 62.5,
+		.rangehigh  =  263000000 / 62.5,
+	}, {
+		.tuner = 1,
+		.type = V4L2_TUNER_RF,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  390000000 / 62.5,
+		.rangehigh  =  960000000 / 62.5,
+	},
+};
+
 /* stream formats */
 struct msi3101_format {
 	char	*name;
@@ -437,6 +466,7 @@ struct msi3101_state {
 	/* Pointer to our usb_device, will be NULL after unplug */
 	struct usb_device *udev; /* Both mutexes most be hold when setting! */
 
+	unsigned int f_adc, f_tuner;
 	u32 pixelformat;
 
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
@@ -479,16 +509,6 @@ leave:
 }
 
 /*
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
  * +===========================================================================
  * |   00-1023 | USB packet type '504'
  * +===========================================================================
@@ -1016,12 +1036,11 @@ static int msi3101_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE;
+			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-
 /* Videobuf2 operations */
 static int msi3101_queue_setup(struct vb2_queue *vq,
 		const struct v4l2_format *fmt, unsigned int *nbuffers,
@@ -1037,9 +1056,9 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	 *   3, wMaxPacketSize 3x 1024 bytes
 	 * 504, max IQ sample pairs per 1024 frame
 	 *   2, two samples, I and Q
-	 *   4, 32-bit float
+	 *   2, 16-bit is enough for single sample
 	 */
-	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 4); /* = 12096 */
+	sizes[0] = PAGE_ALIGN(3 * 504 * 2 * 2);
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
 	return 0;
@@ -1525,30 +1544,7 @@ static struct vb2_ops msi3101_vb2_ops = {
 	.wait_finish            = vb2_ops_wait_finish,
 };
 
-static int msi3101_enum_input(struct file *file, void *fh, struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	strlcpy(i->name, "SDR data", sizeof(i->name));
-	i->type = V4L2_INPUT_TYPE_CAMERA;
-
-	return 0;
-}
-
-static int msi3101_g_input(struct file *file, void *fh, unsigned int *i)
-{
-	*i = 0;
-
-	return 0;
-}
-
-static int msi3101_s_input(struct file *file, void *fh, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int msi3101_enum_fmt_vid_cap(struct file *file, void *priv,
+static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
@@ -1563,70 +1559,70 @@ static int msi3101_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int msi3101_g_fmt_vid_cap(struct file *file, void *priv,
+static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
-	f->fmt.pix.pixelformat = s->pixelformat;
+	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
 }
 
-static int msi3101_s_fmt_vid_cap(struct file *file, void *priv,
+static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.pix.pixelformat);
+			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
 	for (i = 0; i < NUM_FORMATS; i++) {
-		if (formats[i].pixelformat == f->fmt.pix.pixelformat) {
-			s->pixelformat = f->fmt.pix.pixelformat;
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			s->pixelformat = f->fmt.sdr.pixelformat;
 			return 0;
 		}
 	}
 
-	f->fmt.pix.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 	s->pixelformat = formats[0].pixelformat;
 
 	return 0;
 }
 
-static int msi3101_try_fmt_vid_cap(struct file *file, void *priv,
+static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int i;
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.pix.pixelformat);
+			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
 	for (i = 0; i < NUM_FORMATS; i++) {
-		if (formats[i].pixelformat == f->fmt.pix.pixelformat)
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
 	}
 
-	f->fmt.pix.pixelformat = formats[0].pixelformat;
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 
 	return 0;
 }
 
-static int vidioc_s_tuner(struct file *file, void *priv,
+static int msi3101_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
@@ -1635,39 +1631,106 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
+static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	strcpy(v->name, "SDR RX");
-	v->capability = V4L2_TUNER_CAP_LOW;
+	if (v->index == 0) {
+		strlcpy(v->name, "ADC: Mirics MSi2500", sizeof(v->name));
+		v->type = V4L2_TUNER_ADC;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =   1200000;
+		v->rangehigh = 15000000;
+	} else if (v->index == 1) {
+		strlcpy(v->name, "RF: Mirics MSi001", sizeof(v->name));
+		v->type = V4L2_TUNER_RF;
+		v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =    49000000 / 62.5;
+		v->rangehigh =  960000000 / 62.5;
+	} else {
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
+static int msi3101_g_frequency(struct file *file, void *priv,
+		struct v4l2_frequency *f)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	int ret  = 0;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
+			__func__, f->tuner, f->type);
+
+	if (f->tuner == 0)
+		f->frequency = s->f_adc;
+	else if (f->tuner == 1)
+		f->frequency = s->f_tuner;
+	else
+		return -EINVAL;
+
+	return ret;
+}
+
+static int msi3101_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s: frequency=%lu Hz (%u)\n",
-			__func__, f->frequency * 625UL / 10UL, f->frequency);
+	int ret;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
+			__func__, f->tuner, f->type, f->frequency);
+
+	if (f->tuner == 0) {
+		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
+				__func__, f->frequency);
+		s->f_adc = f->frequency;
+		ret = v4l2_ctrl_s_ctrl_int64(s->ctrl_sampling_rate,
+				f->frequency);
+	} else if (f->tuner == 1) {
+		dev_dbg(&s->udev->dev, "%s: RF frequency=%lu Hz\n",
+				__func__, f->frequency * 625UL / 10UL);
+		s->f_tuner = f->frequency;
+		ret = v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
+				f->frequency * 625UL / 10UL);
+	} else {
+		return -EINVAL;
+	}
 
-	return v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
-			f->frequency * 625UL / 10UL);
+	return ret;
+}
+
+static int msi3101_enum_freq_bands(struct file *file, void *priv,
+		struct v4l2_frequency_band *band)
+{
+	struct msi3101_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
+			__func__, band->tuner, band->type, band->index);
+
+	if (band->tuner == 0) {
+		if (band->index >= ARRAY_SIZE(bands_adc))
+			return -EINVAL;
+
+		*band = bands_adc[band->index];
+	} else if (band->tuner == 1) {
+		if (band->index >= ARRAY_SIZE(bands_rf))
+			return -EINVAL;
+
+		*band = bands_rf[band->index];
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_querycap          = msi3101_querycap,
 
-	.vidioc_enum_fmt_vid_cap  = msi3101_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap     = msi3101_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap     = msi3101_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap   = msi3101_try_fmt_vid_cap,
-
-	.vidioc_enum_input        = msi3101_enum_input,
-	.vidioc_g_input           = msi3101_g_input,
-	.vidioc_s_input           = msi3101_s_input,
+	.vidioc_enum_fmt_sdr_cap  = msi3101_enum_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_cap     = msi3101_g_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap     = msi3101_s_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap   = msi3101_try_fmt_sdr_cap,
 
 	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
@@ -1679,9 +1742,12 @@ static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_streamon          = vb2_ioctl_streamon,
 	.vidioc_streamoff         = vb2_ioctl_streamoff,
 
-	.vidioc_g_tuner           = vidioc_g_tuner,
-	.vidioc_s_tuner           = vidioc_s_tuner,
-	.vidioc_s_frequency       = vidioc_s_frequency,
+	.vidioc_g_tuner           = msi3101_g_tuner,
+	.vidioc_s_tuner           = msi3101_s_tuner,
+
+	.vidioc_g_frequency       = msi3101_g_frequency,
+	.vidioc_s_frequency       = msi3101_s_frequency,
+	.vidioc_enum_freq_bands   = msi3101_enum_freq_bands,
 
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -1844,7 +1910,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->udev = udev;
 
 	/* Init videobuf2 queue structure */
-	s->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
 	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	s->vb_queue.drv_priv = s;
 	s->vb_queue.buf_struct_size = sizeof(struct msi3101_frame_buf);
@@ -1892,7 +1958,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
 
-	ret = video_register_device(&s->vdev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
 	if (ret < 0) {
 		dev_err(&s->udev->dev,
 				"Failed to register as video device (%d)\n",
-- 
1.8.5.3

