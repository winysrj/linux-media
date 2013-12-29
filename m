Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44900 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3L2EwO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:52:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/6] msi3101: tons of small changes
Date: Sun, 29 Dec 2013 06:51:39 +0200
Message-Id: <1388292700-18369-6-git-send-email-crope@iki.fi>
In-Reply-To: <1388292700-18369-1-git-send-email-crope@iki.fi>
References: <1388292700-18369-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* remove unneeded controls
* rename things
* remove unneeded callbacks
* use likely/unlikely on hot paths
* use 1Hz resolution for tuner RF frequency

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 214 +++++++---------------------
 1 file changed, 55 insertions(+), 159 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 41894c1..24dfd79 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -21,20 +21,6 @@
  *  (C) 1999-2004 Nemosoft Unv.
  *  (C) 2004-2006 Luc Saillard (luc@saillard.org)
  *  (C) 2011 Hans de Goede <hdegoede@redhat.com>
- *
- * Development tree of that driver will be on:
- * http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/mirics
- *
- * GNU Radio plugin "gr-kernel" for device usage will be on:
- * http://git.linuxtv.org/anttip/gr-kernel.git
- *
- * TODO:
- * Help is very highly welcome for these + all the others you could imagine:
- * - split USB ADC interface and RF tuner to own drivers (msi2500 and msi001)
- * - move controls to V4L2 API
- * - use libv4l2 for stream format conversions
- * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
- * - SDRSharp support
  */
 
 #include <linux/module.h>
@@ -377,12 +363,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MAX_ISOC_ERRORS         20
 
 /* TODO: These should be moved to V4L2 API */
-#define MSI3101_CID_SAMPLING_MODE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
-#define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 1)
-#define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 2)
-#define MSI3101_CID_TUNER_RF              ((V4L2_CID_USER_BASE | 0xf000) + 10)
 #define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
-#define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
@@ -408,16 +389,16 @@ static const struct v4l2_frequency_band bands_rf[] = {
 		.tuner = 1,
 		.type = V4L2_TUNER_RF,
 		.index = 0,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =   49000000 / 62.5,
-		.rangehigh  =  263000000 / 62.5,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =   49000000,
+		.rangehigh  =  263000000,
 	}, {
 		.tuner = 1,
 		.type = V4L2_TUNER_RF,
 		.index = 1,
-		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =  390000000 / 62.5,
-		.rangehigh  =  960000000 / 62.5,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  390000000,
+		.rangehigh  =  960000000,
 	},
 };
 
@@ -430,27 +411,27 @@ struct msi3101_format {
 /* format descriptions for capture and preview */
 static struct msi3101_format formats[] = {
 	{
-		.name		= "I/Q 8-bit unsigned",
+		.name		= "8-bit unsigned",
 		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
 	}, {
-		.name		= "I/Q 16-bit unsigned little endian",
+		.name		= "16-bit unsigned little endian",
 		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
 	}, {
-		.name		= "I/Q 8-bit signed",
+		.name		= "8-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
 	}, {
-		.name		= "I/Q 10+2-bit signed",
+		.name		= "10+2-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
 	}, {
-		.name		= "I/Q 12-bit signed",
+		.name		= "12-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
 	}, {
-		.name		= "I/Q 14-bit signed",
+		.name		= "14-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S14,
 	},
 };
 
-static const int NUM_FORMATS = sizeof(formats) / sizeof(struct msi3101_format);
+static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
 struct msi3101_frame_buf {
@@ -486,15 +467,11 @@ struct msi3101_state {
 
 	/* Controls */
 	struct v4l2_ctrl_handler ctrl_handler;
-	struct v4l2_ctrl *ctrl_sampling_rate;
-	struct v4l2_ctrl *ctrl_tuner_rf;
 	struct v4l2_ctrl *ctrl_tuner_bw;
-	struct v4l2_ctrl *ctrl_tuner_if;
 	struct v4l2_ctrl *ctrl_tuner_gain;
 
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
-	unsigned long jiffies;
 	unsigned long jiffies_next;
 	unsigned int sample_ctrl_bit[4];
 };
@@ -563,11 +540,11 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
@@ -715,11 +692,11 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu bits=%d.%d.%d.%d\n",
@@ -780,11 +757,11 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
@@ -843,11 +820,11 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
-		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies);
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-		s->jiffies = jiffies_now;
+		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
 				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
@@ -944,14 +921,14 @@ static void msi3101_isoc_handler(struct urb *urb)
 	unsigned char *iso_buf = NULL;
 	struct msi3101_frame_buf *fbuf;
 
-	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
-			urb->status == -ESHUTDOWN) {
+	if (unlikely(urb->status == -ENOENT || urb->status == -ECONNRESET ||
+			urb->status == -ESHUTDOWN)) {
 		dev_dbg(&s->udev->dev, "URB (%p) unlinked %ssynchronuously\n",
 				urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
 
-	if (urb->status != 0) {
+	if (unlikely(urb->status != 0)) {
 		dev_dbg(&s->udev->dev,
 				"msi3101_isoc_handler() called with status %d\n",
 				urb->status);
@@ -971,28 +948,28 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
-		if (fstatus) {
+		if (unlikely(fstatus)) {
 			dev_dbg_ratelimited(&s->udev->dev,
 					"frame=%d/%d has error %d skipping\n",
 					i, urb->number_of_packets, fstatus);
-			goto skip;
+			continue;
 		}
 
 		/* Check if that frame contains data */
 		flen = urb->iso_frame_desc[i].actual_length;
-		if (flen == 0)
-			goto skip;
+		if (unlikely(flen == 0))
+			continue;
 
 		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 
 		/* Get free framebuffer */
 		fbuf = msi3101_get_next_fill_buf(s);
-		if (fbuf == NULL) {
+		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
 			dev_dbg_ratelimited(&s->udev->dev,
 					"videobuf is full, %d packets dropped\n",
 					s->vb_full);
-			goto skip;
+			continue;
 		}
 
 		/* fill framebuffer */
@@ -1000,13 +977,11 @@ static void msi3101_isoc_handler(struct urb *urb)
 		flen = s->convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
-skip:
-		;
 	}
 
 handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
-	if (i != 0)
+	if (unlikely(i != 0))
 		dev_dbg(&s->udev->dev,
 				"Error (%d) re-submitting urb in msi3101_isoc_handler\n",
 				i);
@@ -1069,7 +1044,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 	udev = s->udev;
 
 	ret = usb_set_interface(s->udev, 0, 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/* Allocate and init Isochronuous urbs */
@@ -1202,17 +1177,6 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int msi3101_buf_prepare(struct vb2_buffer *vb)
-{
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-
-	/* Don't allow queing new buffers after device disconnection */
-	if (!s->udev)
-		return -ENODEV;
-
-	return 0;
-}
-
 static void msi3101_buf_queue(struct vb2_buffer *vb)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
@@ -1221,7 +1185,7 @@ static void msi3101_buf_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
-	if (!s->udev) {
+	if (unlikely(!s->udev)) {
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		return;
 	}
@@ -1280,7 +1244,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
 	u32 reg3, reg4, reg7;
 
-	f_sr = s->ctrl_sampling_rate->val64;
+	f_sr = s->f_adc;
 
 	/* select stream format */
 	if (f_sr < 6000000) {
@@ -1455,7 +1419,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		{8000000, 0x07}, /* 8 MHz */
 	};
 
-	unsigned int f_rf = s->ctrl_tuner_rf->val64;
+	unsigned int f_rf = s->f_tuner;
 
 	/*
 	 * bandwidth (Hz)
@@ -1467,7 +1431,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	 * intermediate frequency (Hz)
 	 * 0, 450000, 1620000, 2048000
 	 */
-	unsigned int f_if = s->ctrl_tuner_if->val;
+	unsigned int f_if = 0;
 
 	/*
 	 * gain reduction (dB)
@@ -1680,7 +1644,6 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops msi3101_vb2_ops = {
 	.queue_setup            = msi3101_queue_setup,
-	.buf_prepare            = msi3101_buf_prepare,
 	.buf_queue              = msi3101_buf_queue,
 	.start_streaming        = msi3101_start_streaming,
 	.stop_streaming         = msi3101_stop_streaming,
@@ -1811,9 +1774,9 @@ static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	} else if (v->index == 1) {
 		strlcpy(v->name, "RF: Mirics MSi001", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
-		v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS;
-		v->rangelow =    49000000 / 62.5;
-		v->rangehigh =  960000000 / 62.5;
+		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+		v->rangelow =    49000000;
+		v->rangehigh =  960000000;
 	} else {
 		return -EINVAL;
 	}
@@ -1848,17 +1811,15 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 			__func__, f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
-		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
-				__func__, f->frequency);
 		s->f_adc = f->frequency;
-		ret = v4l2_ctrl_s_ctrl_int64(s->ctrl_sampling_rate,
-				f->frequency);
+		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
+				__func__, s->f_adc);
+		ret = msi3101_set_usb_adc(s);
 	} else if (f->tuner == 1) {
-		dev_dbg(&s->udev->dev, "%s: RF frequency=%lu Hz\n",
-				__func__, f->frequency * 625UL / 10UL);
 		s->f_tuner = f->frequency;
-		ret = v4l2_ctrl_s_ctrl_int64(s->ctrl_tuner_rf,
-				f->frequency * 625UL / 10UL);
+		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
+				__func__, f->frequency);
+		ret = msi3101_set_tuner(s);
 	} else {
 		return -EINVAL;
 	}
@@ -1939,6 +1900,7 @@ static struct video_device msi3101_template = {
 	.release                  = video_device_release_empty,
 	.fops                     = &msi3101_fops,
 	.ioctl_ops                = &msi3101_ioctl_ops,
+	.debug                    = 0,
 };
 
 static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -1953,14 +1915,7 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-	case MSI3101_CID_SAMPLING_MODE:
-	case MSI3101_CID_SAMPLING_RATE:
-	case MSI3101_CID_SAMPLING_RESOLUTION:
-		ret = 0;
-		break;
-	case MSI3101_CID_TUNER_RF:
 	case MSI3101_CID_TUNER_BW:
-	case MSI3101_CID_TUNER_IF:
 	case MSI3101_CID_TUNER_GAIN:
 		ret = msi3101_set_tuner(s);
 		break;
@@ -1991,70 +1946,16 @@ static int msi3101_probe(struct usb_interface *intf,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct msi3101_state *s = NULL;
 	int ret;
-	static const char * const ctrl_sampling_mode_qmenu_strings[] = {
-		"Quadrature Sampling",
-		NULL,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_mode = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_MODE,
-		.type   = V4L2_CTRL_TYPE_MENU,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Mode",
-		.qmenu  = ctrl_sampling_mode_qmenu_strings,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_rate = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_RATE,
-		.type	= V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Sampling Rate",
-		.min	= 500000,
-		.max	= 12000000,
-		.def    = 2048000,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_sampling_resolution = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_SAMPLING_RESOLUTION,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Sampling Resolution",
-		.min	= 10,
-		.max	= 10,
-		.def    = 10,
-		.step	= 1,
-	};
-	static const struct v4l2_ctrl_config ctrl_tuner_rf = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_RF,
-		.type   = V4L2_CTRL_TYPE_INTEGER64,
-		.name	= "Tuner RF",
-		.min	= 40000000,
-		.max	= 2000000000,
-		.def    = 100000000,
-		.step	= 1,
-	};
 	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
 		.ops	= &msi3101_ctrl_ops,
 		.id	= MSI3101_CID_TUNER_BW,
 		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner BW",
+		.name	= "Tuner Bandwidth",
 		.min	= 200000,
 		.max	= 8000000,
 		.def    = 600000,
 		.step	= 1,
 	};
-	static const struct v4l2_ctrl_config ctrl_tuner_if = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_IF,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.flags  = V4L2_CTRL_FLAG_INACTIVE,
-		.name	= "Tuner IF",
-		.min	= 0,
-		.max	= 2048000,
-		.def    = 0,
-		.step	= 1,
-	};
 	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
 		.ops	= &msi3101_ctrl_ops,
 		.id	= MSI3101_CID_TUNER_GAIN,
@@ -2062,7 +1963,7 @@ static int msi3101_probe(struct usb_interface *intf,
 		.name	= "Tuner Gain",
 		.min	= 0,
 		.max	= 102,
-		.def    = 0,
+		.def    = 50,
 		.step	= 1,
 	};
 
@@ -2088,7 +1989,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	s->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
@@ -2101,13 +2002,8 @@ static int msi3101_probe(struct usb_interface *intf,
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
@@ -2129,7 +2025,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->vdev.lock = &s->v4l2_lock;
 
 	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&s->udev->dev,
 				"Failed to register as video device (%d)\n",
 				ret);
-- 
1.8.4.2

