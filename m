Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37142 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaBJT3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:29:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 3/5] msi3101: use msi001 tuner driver
Date: Mon, 10 Feb 2014 21:29:01 +0200
Message-Id: <1392060543-3972-4-git-send-email-crope@iki.fi>
In-Reply-To: <1392060543-3972-1-git-send-email-crope@iki.fi>
References: <1392060543-3972-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove MSi001 RF tuner related code as MSi001 functionality is moved
to own driver.

Implement SPI master adapter.

Attach MSi001 driver via SPI / V4L subdev framework.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/Kconfig       |   3 +-
 drivers/staging/media/msi3101/sdr-msi3101.c | 484 ++++++++--------------------
 2 files changed, 136 insertions(+), 351 deletions(-)

diff --git a/drivers/staging/media/msi3101/Kconfig b/drivers/staging/media/msi3101/Kconfig
index 97d5210..de0b3bb 100644
--- a/drivers/staging/media/msi3101/Kconfig
+++ b/drivers/staging/media/msi3101/Kconfig
@@ -1,8 +1,9 @@
 config USB_MSI3101
 	tristate "Mirics MSi3101 SDR Dongle"
-	depends on USB && VIDEO_DEV && VIDEO_V4L2
+	depends on USB && VIDEO_DEV && VIDEO_V4L2 && SPI
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_VMALLOC
+	select MEDIA_TUNER_MSI001
 
 config MEDIA_TUNER_MSI001
 	tristate "Mirics MSi001"
diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index d076d10..158cbe0 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/gcd.h>
 #include <asm/div64.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -33,6 +32,7 @@
 #include <media/v4l2-event.h>
 #include <linux/usb.h>
 #include <media/videobuf2-vmalloc.h>
+#include <linux/spi/spi.h>
 
 /*
  *   iConfiguration          0
@@ -57,7 +57,7 @@
 #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
-static const struct v4l2_frequency_band bands_adc[] = {
+static const struct v4l2_frequency_band bands[] = {
 	{
 		.tuner = 0,
 		.type = V4L2_TUNER_ADC,
@@ -68,24 +68,6 @@ static const struct v4l2_frequency_band bands_adc[] = {
 	},
 };
 
-static const struct v4l2_frequency_band bands_rf[] = {
-	{
-		.tuner = 1,
-		.type = V4L2_TUNER_RF,
-		.index = 0,
-		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =   49000000,
-		.rangehigh  =  263000000,
-	}, {
-		.tuner = 1,
-		.type = V4L2_TUNER_RF,
-		.index = 1,
-		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =  390000000,
-		.rangehigh  =  960000000,
-	},
-};
-
 /* stream formats */
 struct msi3101_format {
 	char	*name;
@@ -128,6 +110,8 @@ struct msi3101_frame_buf {
 struct msi3101_state {
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
+	struct v4l2_subdev *v4l2_subdev;
+	struct spi_master *master;
 
 	/* videobuf2 queue and queued buffers list */
 	struct vb2_queue vb_queue;
@@ -141,7 +125,7 @@ struct msi3101_state {
 	/* Pointer to our usb_device, will be NULL after unplug */
 	struct usb_device *udev; /* Both mutexes most be hold when setting! */
 
-	unsigned int f_adc, f_tuner;
+	unsigned int f_adc;
 	u32 pixelformat;
 
 	unsigned int isoc_errors; /* number of contiguous ISOC errors */
@@ -153,14 +137,6 @@ struct msi3101_state {
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
-	struct v4l2_ctrl *bandwidth_auto;
-	struct v4l2_ctrl *bandwidth;
-	struct v4l2_ctrl *lna_gain_auto;
-	struct v4l2_ctrl *lna_gain;
-	struct v4l2_ctrl *mixer_gain_auto;
-	struct v4l2_ctrl *mixer_gain;
-	struct v4l2_ctrl *if_gain_auto;
-	struct v4l2_ctrl *if_gain;
 
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
@@ -822,9 +798,9 @@ static void msi3101_disconnect(struct usb_interface *intf)
 	mutex_lock(&s->v4l2_lock);
 	/* No need to keep the urbs around after disconnection */
 	s->udev = NULL;
-
 	v4l2_device_disconnect(&s->v4l2_dev);
 	video_unregister_device(&s->vdev);
+	spi_unregister_master(s->master);
 	mutex_unlock(&s->v4l2_lock);
 	mutex_unlock(&s->vb_queue_lock);
 
@@ -924,20 +900,25 @@ static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
 	return ret;
 };
 
-static int msi3101_tuner_write(struct msi3101_state *s, u32 data)
-{
-	return msi3101_ctrl_msg(s, CMD_WREG, data << 8 | 0x09);
-};
-
 #define F_REF 24000000
 #define DIV_R_IN 2
 static int msi3101_set_usb_adc(struct msi3101_state *s)
 {
 	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
 	u32 reg3, reg4, reg7;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
 
 	f_sr = s->f_adc;
 
+	/* set tuner, subdev, filters according to sampling rate */
+	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_BANDWIDTH_AUTO);
+	bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_BANDWIDTH);
+	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
+		bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_BANDWIDTH);
+		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
+	}
+
 	/* select stream format */
 	switch (s->pixelformat) {
 	case V4L2_SDR_FMT_CU8:
@@ -1066,222 +1047,6 @@ err:
 	return ret;
 };
 
-static int msi3101_set_gain(struct msi3101_state *s)
-{
-	int ret;
-	u32 reg;
-	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
-			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
-
-	reg = 1 << 0;
-	reg |= (59 - s->if_gain->val) << 4;
-	reg |= 0 << 10;
-	reg |= (1 - s->mixer_gain->val) << 12;
-	reg |= (1 - s->lna_gain->val) << 13;
-	reg |= 4 << 14;
-	reg |= 0 << 17;
-	ret = msi3101_tuner_write(s, reg);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
-	return ret;
-};
-
-static int msi3101_set_tuner(struct msi3101_state *s)
-{
-	int ret, i;
-	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
-	u32 reg;
-	u64 f_vco, tmp64;
-	u8 mode, filter_mode, lo_div;
-	static const struct {
-		u32 rf;
-		u8 mode;
-		u8 lo_div;
-	} band_lut[] = {
-		{ 50000000, 0xe1, 16}, /* AM_MODE2, antenna 2 */
-		{108000000, 0x42, 32}, /* VHF_MODE */
-		{330000000, 0x44, 16}, /* B3_MODE */
-		{960000000, 0x48,  4}, /* B45_MODE */
-		{      ~0U, 0x50,  2}, /* BL_MODE */
-	};
-	static const struct {
-		u32 freq;
-		u8 filter_mode;
-	} if_freq_lut[] = {
-		{      0, 0x03}, /* Zero IF */
-		{ 450000, 0x02}, /* 450 kHz IF */
-		{1620000, 0x01}, /* 1.62 MHz IF */
-		{2048000, 0x00}, /* 2.048 MHz IF */
-	};
-	static const struct {
-		u32 freq;
-		u8 val;
-	} bandwidth_lut[] = {
-		{ 200000, 0x00}, /* 200 kHz */
-		{ 300000, 0x01}, /* 300 kHz */
-		{ 600000, 0x02}, /* 600 kHz */
-		{1536000, 0x03}, /* 1.536 MHz */
-		{5000000, 0x04}, /* 5 MHz */
-		{6000000, 0x05}, /* 6 MHz */
-		{7000000, 0x06}, /* 7 MHz */
-		{8000000, 0x07}, /* 8 MHz */
-	};
-
-	unsigned int f_rf = s->f_tuner;
-
-	/*
-	 * bandwidth (Hz)
-	 * 200000, 300000, 600000, 1536000, 5000000, 6000000, 7000000, 8000000
-	 */
-	unsigned int bandwidth;
-
-	/*
-	 * intermediate frequency (Hz)
-	 * 0, 450000, 1620000, 2048000
-	 */
-	unsigned int f_if = 0;
-
-	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%d f_if=%d\n",
-			__func__, f_rf, f_if);
-
-	ret = -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
-		if (f_rf <= band_lut[i].rf) {
-			mode = band_lut[i].mode;
-			lo_div = band_lut[i].lo_div;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(band_lut))
-		goto err;
-
-	/* AM_MODE is upconverted */
-	if ((mode >> 0) & 0x1)
-		f_if1 =  5 * F_REF;
-	else
-		f_if1 =  0;
-
-	for (i = 0; i < ARRAY_SIZE(if_freq_lut); i++) {
-		if (f_if == if_freq_lut[i].freq) {
-			filter_mode = if_freq_lut[i].filter_mode;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(if_freq_lut))
-		goto err;
-
-	/* filters */
-	if (s->bandwidth_auto->val)
-		bandwidth = s->f_adc;
-	else
-		bandwidth = s->bandwidth->val;
-
-	bandwidth = clamp(bandwidth, 200000U, 8000000U);
-
-	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
-		if (bandwidth <= bandwidth_lut[i].freq) {
-			bandwidth = bandwidth_lut[i].val;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(bandwidth_lut))
-		goto err;
-
-	s->bandwidth->val = bandwidth_lut[i].freq;
-
-	dev_dbg(&s->udev->dev, "%s: bandwidth selected=%d\n",
-			__func__, bandwidth_lut[i].freq);
-
-#define F_OUT_STEP 1
-#define R_REF 4
-	f_vco = (f_rf + f_if + f_if1) * lo_div;
-
-	tmp64 = f_vco;
-	m = do_div(tmp64, F_REF * R_REF);
-	n = (unsigned int) tmp64;
-
-	vco_step = F_OUT_STEP * lo_div;
-	thresh = (F_REF * R_REF) / vco_step;
-	frac = 1ul * thresh * m / (F_REF * R_REF);
-
-	/* Find out greatest common divisor and divide to smaller. */
-	tmp = gcd(thresh, frac);
-	thresh /= tmp;
-	frac /= tmp;
-
-	/* Force divide to reg max. Resolution will be reduced. */
-	tmp = DIV_ROUND_UP(thresh, 4095);
-	thresh = DIV_ROUND_CLOSEST(thresh, tmp);
-	frac = DIV_ROUND_CLOSEST(frac, tmp);
-
-	/* calc real RF set */
-	tmp = 1ul * F_REF * R_REF * n;
-	tmp += 1ul * F_REF * R_REF * frac / thresh;
-	tmp /= lo_div;
-
-	dev_dbg(&s->udev->dev,
-			"%s: rf=%u:%u n=%d thresh=%d frac=%d\n",
-				__func__, f_rf, tmp, n, thresh, frac);
-
-	ret = msi3101_tuner_write(s, 0x00000e);
-	if (ret)
-		goto err;
-
-	ret = msi3101_tuner_write(s, 0x000003);
-	if (ret)
-		goto err;
-
-	reg = 0 << 0;
-	reg |= mode << 4;
-	reg |= filter_mode << 12;
-	reg |= bandwidth << 14;
-	reg |= 0x02 << 17;
-	reg |= 0x00 << 20;
-	ret = msi3101_tuner_write(s, reg);
-	if (ret)
-		goto err;
-
-	reg = 5 << 0;
-	reg |= thresh << 4;
-	reg |= 1 << 19;
-	reg |= 1 << 21;
-	ret = msi3101_tuner_write(s, reg);
-	if (ret)
-		goto err;
-
-	reg = 2 << 0;
-	reg |= frac << 4;
-	reg |= n << 16;
-	ret = msi3101_tuner_write(s, reg);
-	if (ret)
-		goto err;
-
-	ret = msi3101_set_gain(s);
-	if (ret)
-		goto err;
-
-	reg = 6 << 0;
-	reg |= 63 << 4;
-	reg |= 4095 << 10;
-	ret = msi3101_tuner_write(s, reg);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
-	return ret;
-};
-
 static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vq);
@@ -1294,6 +1059,9 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (mutex_lock_interruptible(&s->v4l2_lock))
 		return -ERESTARTSYS;
 
+	/* wake-up tuner */
+	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 1);
+
 	ret = msi3101_set_usb_adc(s);
 
 	ret = msi3101_isoc_init(s);
@@ -1328,7 +1096,7 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 	msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
 
 	/* sleep tuner */
-	msi3101_tuner_write(s, 0x000000);
+	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
 
 	mutex_unlock(&s->v4l2_lock);
 
@@ -1418,33 +1186,39 @@ static int msi3101_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	int ret;
+	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
 
-	return 0;
+	if (v->index == 0)
+		ret = 0;
+	else if (v->index == 1)
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_tuner, v);
+	else
+		ret = -EINVAL;
+
+	return ret;
 }
 
 static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	int ret;
+	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
 
 	if (v->index == 0) {
-		strlcpy(v->name, "ADC: Mirics MSi2500", sizeof(v->name));
+		strlcpy(v->name, "Mirics MSi2500", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =   1200000;
 		v->rangehigh = 15000000;
+		ret = 0;
 	} else if (v->index == 1) {
-		strlcpy(v->name, "RF: Mirics MSi001", sizeof(v->name));
-		v->type = V4L2_TUNER_RF;
-		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
-		v->rangelow =    49000000;
-		v->rangehigh =  960000000;
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, g_tuner, v);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int msi3101_g_frequency(struct file *file, void *priv,
@@ -1455,12 +1229,14 @@ static int msi3101_g_frequency(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
 			__func__, f->tuner, f->type);
 
-	if (f->tuner == 0)
+	if (f->tuner == 0) {
 		f->frequency = s->f_adc;
-	else if (f->tuner == 1)
-		f->frequency = s->f_tuner;
-	else
-		return -EINVAL;
+		ret = 0;
+	} else if (f->tuner == 1) {
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, g_frequency, f);
+	} else {
+		ret = -EINVAL;
+	}
 
 	return ret;
 }
@@ -1469,31 +1245,21 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
-	int ret, band;
+	int ret;
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
 			__func__, f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
 		s->f_adc = clamp_t(unsigned int, f->frequency,
-				bands_adc[0].rangelow,
-				bands_adc[0].rangehigh);
+				bands[0].rangelow,
+				bands[0].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
 				__func__, s->f_adc);
 		ret = msi3101_set_usb_adc(s);
 	} else if (f->tuner == 1) {
-		#define BAND_RF_0 ((bands_rf[0].rangehigh + bands_rf[1].rangelow) / 2)
-		if (f->frequency < BAND_RF_0)
-			band = 0;
-		else
-			band = 1;
-		s->f_tuner = clamp_t(unsigned int, f->frequency,
-				bands_rf[band].rangelow,
-				bands_rf[band].rangehigh);
-		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
-				__func__, f->frequency);
-		ret = msi3101_set_tuner(s);
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_frequency, f);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
 	return ret;
@@ -1503,24 +1269,25 @@ static int msi3101_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
 	struct msi3101_state *s = video_drvdata(file);
+	int ret;
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
 			__func__, band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
-		if (band->index >= ARRAY_SIZE(bands_adc))
-			return -EINVAL;
-
-		*band = bands_adc[band->index];
+		if (band->index >= ARRAY_SIZE(bands)) {
+			ret = -EINVAL;
+		} else {
+			*band = bands[band->index];
+			ret = 0;
+		}
 	} else if (band->tuner == 1) {
-		if (band->index >= ARRAY_SIZE(bands_rf))
-			return -EINVAL;
-
-		*band = bands_rf[band->index];
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner,
+				enum_freq_bands, band);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
@@ -1568,40 +1335,6 @@ static struct video_device msi3101_template = {
 	.release                  = video_device_release_empty,
 	.fops                     = &msi3101_fops,
 	.ioctl_ops                = &msi3101_ioctl_ops,
-	.debug                    = 0,
-};
-
-static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct msi3101_state *s =
-			container_of(ctrl->handler, struct msi3101_state,
-					hdl);
-	int ret;
-	dev_dbg(&s->udev->dev,
-			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
-			__func__, ctrl->id, ctrl->name, ctrl->val,
-			ctrl->minimum, ctrl->maximum, ctrl->step);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BANDWIDTH_AUTO:
-	case V4L2_CID_BANDWIDTH:
-		ret = msi3101_set_tuner(s);
-		break;
-	case  V4L2_CID_LNA_GAIN:
-	case  V4L2_CID_MIXER_GAIN:
-	case  V4L2_CID_IF_GAIN:
-		ret = msi3101_set_gain(s);
-		break;
-	default:
-		dev_dbg(&s->udev->dev, "%s: EINVAL\n", __func__);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static const struct v4l2_ctrl_ops msi3101_ctrl_ops = {
-	.s_ctrl = msi3101_s_ctrl,
 };
 
 static void msi3101_video_release(struct v4l2_device *v)
@@ -1614,13 +1347,43 @@ static void msi3101_video_release(struct v4l2_device *v)
 	kfree(s);
 }
 
+static int msi3101_transfer_one_message(struct spi_master *master,
+		struct spi_message *m)
+{
+	struct msi3101_state *s = spi_master_get_devdata(master);
+	struct spi_transfer *t;
+	int ret = 0;
+	u32 data;
+
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		dev_dbg(&s->udev->dev, "%s: msg=%*ph\n",
+				__func__, t->len, t->tx_buf);
+		data = 0x09; /* reg 9 is SPI adapter */
+		data |= ((u8 *)t->tx_buf)[0] << 8;
+		data |= ((u8 *)t->tx_buf)[1] << 16;
+		data |= ((u8 *)t->tx_buf)[2] << 24;
+		ret = msi3101_ctrl_msg(s, CMD_WREG, data);
+	}
+
+	m->status = ret;
+	spi_finalize_current_message(master);
+	return ret;
+}
+
 static int msi3101_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct msi3101_state *s = NULL;
-	const struct v4l2_ctrl_ops *ops = &msi3101_ctrl_ops;
+	struct v4l2_subdev *sd;
+	struct spi_master *master;
 	int ret;
+	static struct spi_board_info board_info = {
+		.modalias		= "msi001",
+		.bus_num		= 0,
+		.chip_select		= 0,
+		.max_speed_hz		= 12000000,
+	};
 
 	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1633,7 +1396,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
 	s->udev = udev;
-	s->f_adc = bands_adc[0].rangelow;
+	s->f_adc = bands[0].rangelow;
 	s->pixelformat = V4L2_SDR_FMT_CU8;
 
 	/* Init videobuf2 queue structure */
@@ -1657,34 +1420,53 @@ static int msi3101_probe(struct usb_interface *intf,
 	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
 	video_set_drvdata(&s->vdev, s);
 
-	/* Register controls */
-	v4l2_ctrl_handler_init(&s->hdl, 5);
-	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
-			V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
-			V4L2_CID_BANDWIDTH, 0, 8000000, 1, 0);
-	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
-	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops,
-			V4L2_CID_LNA_GAIN, 0, 1, 1, 1);
-	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops,
-			V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
-	s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops,
-			V4L2_CID_IF_GAIN, 0, 59, 1, 0);
-	if (s->hdl.error) {
-		ret = s->hdl.error;
-		dev_err(&s->udev->dev, "Could not initialize controls\n");
-		goto err_free_controls;
-	}
-
 	/* Register the v4l2_device structure */
 	s->v4l2_dev.release = msi3101_video_release;
 	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
 	if (ret) {
 		dev_err(&s->udev->dev,
 				"Failed to register v4l2-device (%d)\n", ret);
+		goto err_free_mem;
+	}
+
+	/* SPI master adapter */
+	master = spi_alloc_master(&s->udev->dev, 0);
+	if (master == NULL) {
+		ret = -ENOMEM;
+		goto err_unregister_v4l2_dev;
+	}
+
+	s->master = master;
+	master->bus_num = 0;
+	master->num_chipselect = 1;
+	master->transfer_one_message = msi3101_transfer_one_message;
+	spi_master_set_devdata(master, s);
+	ret = spi_register_master(master);
+	if (ret) {
+		spi_master_put(master);
+		goto err_unregister_v4l2_dev;
+	}
+
+	/* load v4l2 subdevice */
+	sd = v4l2_spi_new_subdev(&s->v4l2_dev, master, &board_info);
+	s->v4l2_subdev = sd;
+	if (sd == NULL) {
+		dev_err(&s->udev->dev, "cannot get v4l2 subdevice\n");
+		ret = -ENODEV;
+		goto err_unregister_master;
+	}
+
+	/* Register controls */
+	v4l2_ctrl_handler_init(&s->hdl, 0);
+	if (s->hdl.error) {
+		ret = s->hdl.error;
+		dev_err(&s->udev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
 
+	/* currently all controls are from subdev */
+	v4l2_ctrl_add_handler(&s->hdl, sd->ctrl_handler, NULL);
+
 	s->v4l2_dev.ctrl_handler = &s->hdl;
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
@@ -1701,10 +1483,12 @@ static int msi3101_probe(struct usb_interface *intf,
 
 	return 0;
 
-err_unregister_v4l2_dev:
-	v4l2_device_unregister(&s->v4l2_dev);
 err_free_controls:
 	v4l2_ctrl_handler_free(&s->hdl);
+err_unregister_master:
+	spi_unregister_master(s->master);
+err_unregister_v4l2_dev:
+	v4l2_device_unregister(&s->v4l2_dev);
 err_free_mem:
 	kfree(s);
 	return ret;
-- 
1.8.5.3

