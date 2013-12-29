Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57552 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3L2EwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:52:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/6] rtl2832_sdr: convert to SDR API
Date: Sun, 29 Dec 2013 06:51:35 +0200
Message-Id: <1388292700-18369-2-git-send-email-crope@iki.fi>
In-Reply-To: <1388292700-18369-1-git-send-email-crope@iki.fi>
References: <1388292700-18369-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was abusing video device API. Use SDR API instead.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 387 +++++++++++++----------
 1 file changed, 223 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 4b8c016..a26125c 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -20,12 +20,6 @@
  * GNU Radio plugin "gr-kernel" for device usage will be on:
  * http://git.linuxtv.org/anttip/gr-kernel.git
  *
- * TODO:
- * Help is very highly welcome for these + all the others you could imagine:
- * - move controls to V4L2 API
- * - use libv4l2 for stream format conversions
- * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
- * - SDRSharp support
  */
 
 #include "dvb_frontend.h"
@@ -38,22 +32,75 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
+#include <linux/jiffies.h>
 #include <linux/math64.h>
 
 /* TODO: These should be moved to V4L2 API */
-#define RTL2832_SDR_CID_SAMPLING_MODE       ((V4L2_CID_USER_BASE | 0xf000) +  0)
-#define RTL2832_SDR_CID_SAMPLING_RATE       ((V4L2_CID_USER_BASE | 0xf000) +  1)
-#define RTL2832_SDR_CID_SAMPLING_RESOLUTION ((V4L2_CID_USER_BASE | 0xf000) +  2)
-#define RTL2832_SDR_CID_TUNER_RF            ((V4L2_CID_USER_BASE | 0xf000) + 10)
 #define RTL2832_SDR_CID_TUNER_BW            ((V4L2_CID_USER_BASE | 0xf000) + 11)
-#define RTL2832_SDR_CID_TUNER_IF            ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define RTL2832_SDR_CID_TUNER_GAIN          ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
-#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+#define V4L2_PIX_FMT_SDR_U8    v4l2_fourcc('D', 'U', '0', '8')
+#define V4L2_PIX_FMT_SDR_U16LE v4l2_fourcc('D', 'U', '1', '6')
 
 #define MAX_BULK_BUFS            (10)
 #define BULK_BUFFER_SIZE         (128 * 512)
 
+static const struct v4l2_frequency_band bands_adc[] = {
+	{
+		.tuner = 0,
+		.type = V4L2_TUNER_ADC,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  300000,
+		.rangehigh  =  300000,
+	},
+	{
+		.tuner = 0,
+		.type = V4L2_TUNER_ADC,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  900001,
+		.rangehigh  = 2800000,
+	},
+	{
+		.tuner = 0,
+		.type = V4L2_TUNER_ADC,
+		.index = 2,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   = 3200000,
+		.rangehigh  = 3200000,
+	},
+};
+
+static const struct v4l2_frequency_band bands_fm[] = {
+	{
+		.tuner = 1,
+		.type = V4L2_TUNER_RF,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =    50000000,
+		.rangehigh  =  2000000000,
+	},
+};
+
+/* stream formats */
+struct rtl2832_sdr_format {
+	char	*name;
+	u32	pixelformat;
+};
+
+static struct rtl2832_sdr_format formats[] = {
+	{
+		.name		= "8-bit unsigned",
+		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
+	}, {
+		.name		= "16-bit unsigned little endian",
+		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
+	},
+};
+
+static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
+
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
@@ -96,18 +143,18 @@ struct rtl2832_sdr_state {
 	int urbs_initialized;
 	int urbs_submitted;
 
+	unsigned int f_adc, f_tuner;
+	u32 pixelformat;
+
 	/* Controls */
 	struct v4l2_ctrl_handler ctrl_handler;
-	struct v4l2_ctrl *ctrl_sampling_rate;
-	struct v4l2_ctrl *ctrl_tuner_rf;
 	struct v4l2_ctrl *ctrl_tuner_bw;
-	struct v4l2_ctrl *ctrl_tuner_if;
 	struct v4l2_ctrl *ctrl_tuner_gain;
 
 	/* for sample rate calc */
 	unsigned int sample;
 	unsigned int sample_measured;
-	unsigned long jiffies;
+	unsigned long jiffies_next;
 };
 
 /* write multiple hardware registers */
@@ -292,27 +339,41 @@ leave:
 }
 
 static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
-		u8 *dst, const u8 *src, unsigned int src_len)
+		void *dst, const u8 *src, unsigned int src_len)
 {
-	memcpy(dst, src, src_len);
+	unsigned int dst_len;
+
+	if (s->pixelformat == V4L2_PIX_FMT_SDR_U8) {
+		/* native stream, no need to convert */
+		memcpy(dst, src, src_len);
+		dst_len = src_len;
+	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_U16LE) {
+		/* convert u8 to u16 */
+		unsigned int i;
+		u16 *u16dst = dst;
+		for (i = 0; i < src_len; i++)
+			*u16dst++ = (src[i] << 8) | (src[i] >> 0);
+		dst_len = 2 * src_len;
+	} else {
+		dst_len = 0;
+	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
-		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
+#define MSECS 10000UL
 		unsigned int samples = s->sample - s->sample_measured;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample_measured = s->sample;
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+				src_len, samples, MSECS,
+				samples * 1000UL / MSECS);
 	}
 
 	/* total number of I+Q pairs */
 	s->sample += src_len / 2;
 
-	return src_len;
+	return dst_len;
 }
 
 /*
@@ -343,12 +404,12 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		break;
 	}
 
-	if (urb->actual_length > 0) {
+	if (likely(urb->actual_length > 0)) {
 		void *ptr;
 		unsigned int len;
 		/* get free framebuffer */
 		fbuf = rtl2832_sdr_get_next_fill_buf(s);
-		if (fbuf == NULL) {
+		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
 			dev_notice_ratelimited(&s->udev->dev,
 					"videobuf is full, %d packets dropped\n",
@@ -544,7 +605,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE;
+			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -560,7 +621,8 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 	/* Absolute min and max number of buffers available for mmap() */
 	*nbuffers = 32;
 	*nplanes = 1;
-	sizes[0] = PAGE_ALIGN(BULK_BUFFER_SIZE * 4); /* 8 * 512 * 4 = 16384 */
+	/* 2 = max 16-bit sample returned */
+	sizes[0] = PAGE_ALIGN(BULK_BUFFER_SIZE * 2);
 	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
 			__func__, *nbuffers, sizes[0]);
 	return 0;
@@ -609,7 +671,10 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
 
-	f_sr = s->ctrl_sampling_rate->val64;
+	if (s->f_adc == 0)
+		return 0;
+
+	f_sr = s->f_adc;
 
 	ret = rtl2832_sdr_wr_regs(s, 0x13e, "\x00\x00", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x00", 1);
@@ -788,17 +853,15 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	unsigned int f_rf = s->ctrl_tuner_rf->val64;
-
 	/*
-	 * bandwidth (Hz)
+	 * tuner RF (Hz)
 	 */
-	unsigned int bandwidth = s->ctrl_tuner_bw->val;
+	unsigned int f_rf = s->f_tuner;
 
 	/*
-	 * intermediate frequency (Hz)
+	 * bandwidth (Hz)
 	 */
-	unsigned int f_if = s->ctrl_tuner_if->val;
+	unsigned int bandwidth = s->ctrl_tuner_bw->val;
 
 	/*
 	 * gain (dB)
@@ -806,8 +869,11 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	int gain = s->ctrl_tuner_gain->val;
 
 	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%u bandwidth=%d f_if=%u gain=%d\n",
-			__func__, f_rf, bandwidth, f_if, gain);
+			"%s: f_rf=%u bandwidth=%d gain=%d\n",
+			__func__, f_rf, bandwidth, gain);
+
+	if (f_rf == 0)
+		return 0;
 
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
@@ -913,123 +979,182 @@ static struct vb2_ops rtl2832_sdr_vb2_ops = {
 	.wait_finish            = vb2_ops_wait_finish,
 };
 
-static int rtl2832_sdr_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
+		struct v4l2_tuner *v)
 {
-	if (i->index != 0)
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s: index=%d type=%d\n",
+			__func__, v->index, v->type);
+
+	if (v->index == 0) {
+		strlcpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
+		v->type = V4L2_TUNER_ADC;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =   300000;
+		v->rangehigh = 3200000;
+	} else if (v->index == 1) {
+		strlcpy(v->name, "RF: <unknown>", sizeof(v->name));
+		v->type = V4L2_TUNER_RF;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =    50000000;
+		v->rangehigh = 2000000000;
+	} else {
 		return -EINVAL;
-
-	strlcpy(i->name, "SDR data", sizeof(i->name));
-	i->type = V4L2_INPUT_TYPE_CAMERA;
+	}
 
 	return 0;
 }
 
-static int rtl2832_sdr_g_input(struct file *file, void *fh, unsigned int *i)
+static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
+		const struct v4l2_tuner *v)
 {
-	*i = 0;
+	struct rtl2832_sdr_state *s = video_drvdata(file);
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	return 0;
 }
 
-static int rtl2832_sdr_s_input(struct file *file, void *fh, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-		const struct v4l2_tuner *v)
+static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
+		struct v4l2_frequency_band *band)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
+			__func__, band->tuner, band->type, band->index);
+
+	if (band->tuner == 0) {
+		if (band->index >= ARRAY_SIZE(bands_adc))
+			return -EINVAL;
+
+		*band = bands_adc[band->index];
+	} else if (band->tuner == 1) {
+		if (band->index >= ARRAY_SIZE(bands_fm))
+			return -EINVAL;
+
+		*band = bands_fm[band->index];
+	} else {
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
+static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
+		struct v4l2_frequency *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
-
-	strcpy(v->name, "SDR RX");
-	v->capability = V4L2_TUNER_CAP_LOW;
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
 
-	return 0;
+	return ret;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
+static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s: frequency=%lu Hz (%u)\n",
-			__func__, f->frequency * 625UL / 10UL, f->frequency);
+	int ret;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
+			__func__, f->tuner, f->type, f->frequency);
 
-	return v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
-			f->frequency * 625UL / 10UL);
+	if (f->tuner == 0) {
+		s->f_adc = f->frequency;
+		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
+				__func__, s->f_adc);
+		ret = rtl2832_sdr_set_adc(s);
+	} else if (f->tuner == 1) {
+		s->f_tuner = f->frequency;
+		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
+				__func__, f->frequency);
+		ret = rtl2832_sdr_set_tuner(s);
+	} else {
+		return -EINVAL;
+	}
+
+	return ret;
 }
 
-static int rtl2832_sdr_enum_fmt_vid_cap(struct file *file, void *priv,
+static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->index > 0)
+	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	f->flags = 0;
-	strcpy(f->description, "I/Q 8-bit unsigned");
-	f->pixelformat = V4L2_PIX_FMT_SDR_U8;
+	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
 }
 
-static int rtl2832_sdr_g_fmt_vid_cap(struct file *file, void *priv,
+static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
-	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
-	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
 }
 
-static int rtl2832_sdr_s_fmt_vid_cap(struct file *file, void *priv,
+static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	struct vb2_queue *q = &s->vb_queue;
+	int i;
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.pix.pixelformat);
+			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
-	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
-	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
+			s->pixelformat = f->fmt.sdr.pixelformat;
+			return 0;
+		}
+	}
+
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
+	s->pixelformat = formats[0].pixelformat;
 
 	return 0;
 }
 
-static int rtl2832_sdr_try_fmt_vid_cap(struct file *file, void *priv,
+static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
+	int i;
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.pix.pixelformat);
+			(char *)&f->fmt.sdr.pixelformat);
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->type != V4L2_BUF_TYPE_SDR_CAPTURE)
 		return -EINVAL;
 
-	memset(&f->fmt.pix, 0, sizeof(f->fmt.pix));
-	f->fmt.pix.pixelformat = V4L2_PIX_FMT_SDR_U8;
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
+			return 0;
+	}
+
+	f->fmt.sdr.pixelformat = formats[0].pixelformat;
 
 	return 0;
 }
@@ -1037,14 +1162,10 @@ static int rtl2832_sdr_try_fmt_vid_cap(struct file *file, void *priv,
 static const struct v4l2_ioctl_ops rtl2832_sdr_ioctl_ops = {
 	.vidioc_querycap          = rtl2832_sdr_querycap,
 
-	.vidioc_enum_fmt_vid_cap  = rtl2832_sdr_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap     = rtl2832_sdr_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap     = rtl2832_sdr_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap   = rtl2832_sdr_try_fmt_vid_cap,
-
-	.vidioc_enum_input        = rtl2832_sdr_enum_input,
-	.vidioc_g_input           = rtl2832_sdr_g_input,
-	.vidioc_s_input           = rtl2832_sdr_s_input,
+	.vidioc_enum_fmt_sdr_cap  = rtl2832_sdr_enum_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_cap     = rtl2832_sdr_g_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap     = rtl2832_sdr_s_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap   = rtl2832_sdr_try_fmt_sdr_cap,
 
 	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
@@ -1056,9 +1177,12 @@ static const struct v4l2_ioctl_ops rtl2832_sdr_ioctl_ops = {
 	.vidioc_streamon          = vb2_ioctl_streamon,
 	.vidioc_streamoff         = vb2_ioctl_streamoff,
 
-	.vidioc_g_tuner           = vidioc_g_tuner,
-	.vidioc_s_tuner           = vidioc_s_tuner,
-	.vidioc_s_frequency       = vidioc_s_frequency,
+	.vidioc_g_tuner           = rtl2832_sdr_g_tuner,
+	.vidioc_s_tuner           = rtl2832_sdr_s_tuner,
+
+	.vidioc_enum_freq_bands   = rtl2832_sdr_enum_freq_bands,
+	.vidioc_g_frequency       = rtl2832_sdr_g_frequency,
+	.vidioc_s_frequency       = rtl2832_sdr_s_frequency,
 
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -1076,7 +1200,7 @@ static const struct v4l2_file_operations rtl2832_sdr_fops = {
 };
 
 static struct video_device rtl2832_sdr_template = {
-	.name                     = "Realtek RTL2832U SDR",
+	.name                     = "Realtek RTL2832 SDR",
 	.release                  = video_device_release_empty,
 	.fops                     = &rtl2832_sdr_fops,
 	.ioctl_ops                = &rtl2832_sdr_ioctl_ops,
@@ -1094,14 +1218,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-	case RTL2832_SDR_CID_SAMPLING_MODE:
-	case RTL2832_SDR_CID_SAMPLING_RATE:
-	case RTL2832_SDR_CID_SAMPLING_RESOLUTION:
-		ret = rtl2832_sdr_set_adc(s);
-		break;
-	case RTL2832_SDR_CID_TUNER_RF:
 	case RTL2832_SDR_CID_TUNER_BW:
-	case RTL2832_SDR_CID_TUNER_IF:
 	case RTL2832_SDR_CID_TUNER_GAIN:
 		ret = rtl2832_sdr_set_tuner(s);
 		break;
@@ -1132,49 +1249,6 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	int ret;
 	struct rtl2832_sdr_state *s;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
-	static const char * const ctrl_sampling_mode_qmenu_strings[] = {
-		"Quadrature Sampling",
-		NULL,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_mode = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_SAMPLING_MODE,
-		.type   = V4L2_CTRL_TYPE_MENU,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Mode",
-		.qmenu  = ctrl_sampling_mode_qmenu_strings,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_rate = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_SAMPLING_RATE,
-		.type	= V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Sampling Rate",
-		.min	=  900001,
-		.max	= 2800000,
-		.def    = 2048000,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_resolution = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_SAMPLING_RESOLUTION,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Resolution",
-		.min	= 8,
-		.max	= 8,
-		.def    = 8,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_rf = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_TUNER_RF,
-		.type   = V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Tuner RF",
-		.min	=   40000000,
-		.max	= 2000000000,
-		.def    =  100000000,
-		.step	= 1,
-	};
 	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
 		.ops	= &rtl2832_sdr_ctrl_ops,
 		.id	= RTL2832_SDR_CID_TUNER_BW,
@@ -1185,17 +1259,6 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		.def    =  600000,
 		.step	= 1,
 	};
-	static const struct v4l2_ctrl_config ctrl_tuner_if = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_TUNER_IF,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Tuner IF",
-		.min	= 0,
-		.max	= 10,
-		.def    = 0,
-		.step	= 1,
-	};
 	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
 		.ops	= &rtl2832_sdr_ctrl_ops,
 		.id	= RTL2832_SDR_CID_TUNER_GAIN,
@@ -1227,7 +1290,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	INIT_LIST_HEAD(&s->queued_bufs);
 
 	/* Init videobuf2 queue structure */
-	s->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
 	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	s->vb_queue.drv_priv = s;
 	s->vb_queue.buf_struct_size = sizeof(struct rtl2832_sdr_frame_buf);
@@ -1248,13 +1311,8 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->ctrl_handler, 7);
-	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_mode, NULL);
-	s->ctrl_sampling_rate = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_rate, NULL);
-	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_resolution, NULL);
-	s->ctrl_tuner_rf = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_rf, NULL);
+	v4l2_ctrl_handler_init(&s->ctrl_handler, 2);
 	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
-	s->ctrl_tuner_if = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_if, NULL);
 	s->ctrl_tuner_gain = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_gain, NULL);
 	if (s->ctrl_handler.error) {
 		ret = s->ctrl_handler.error;
@@ -1274,8 +1332,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->v4l2_dev.ctrl_handler = &s->ctrl_handler;
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
+	s->vdev.vfl_dir = VFL_DIR_RX;
 
-	ret = video_register_device(&s->vdev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
 	if (ret < 0) {
 		dev_err(&s->udev->dev,
 				"Failed to register as video device (%d)\n",
-- 
1.8.4.2

