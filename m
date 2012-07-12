Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab2GLUzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:18 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, halli manjunatha <hallimanju@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/5] radio-si470x: Add support for the new band APIs
Date: Thu, 12 Jul 2012 22:55:48 +0200
Message-Id: <1342126548-19349-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
References: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |  215 +++++++++++++---------
 drivers/media/radio/si470x/radio-si470x-i2c.c    |    1 +
 drivers/media/radio/si470x/radio-si470x-usb.c    |    1 +
 drivers/media/radio/si470x/radio-si470x.h        |    1 +
 4 files changed, 126 insertions(+), 92 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 84ab3d57..9e38132 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -4,6 +4,7 @@
  *  Driver for radios with Silicon Labs Si470x FM Radio Receivers
  *
  *  Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+ *  Copyright (c) 2012 Hans de Goede <hdegoede@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -127,14 +128,6 @@ static unsigned short space = 2;
 module_param(space, ushort, 0444);
 MODULE_PARM_DESC(space, "Spacing: 0=200kHz 1=100kHz *2=50kHz*");
 
-/* Bottom of Band (MHz) */
-/* 0: 87.5 - 108 MHz (USA, Europe)*/
-/* 1: 76   - 108 MHz (Japan wide band) */
-/* 2: 76   -  90 MHz (Japan) */
-static unsigned short band = 1;
-module_param(band, ushort, 0444);
-MODULE_PARM_DESC(band, "Band: 0=87.5..108MHz *1=76..108MHz* 2=76..90MHz");
-
 /* De-emphasis */
 /* 0: 75 us (USA) */
 /* 1: 50 us (Europe, Australia, Japan) */
@@ -152,13 +145,61 @@ static unsigned int seek_timeout = 5000;
 module_param(seek_timeout, uint, 0644);
 MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
 
-
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
+			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
+			    V4L2_TUNER_CAP_HWSEEK_WRAP,
+		.rangelow   =  87500 * 16,
+		.rangehigh  = 108000 * 16,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
+			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
+			    V4L2_TUNER_CAP_HWSEEK_WRAP,
+		.rangelow   =  76000 * 16,
+		.rangehigh  = 108000 * 16,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 2,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
+			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
+			    V4L2_TUNER_CAP_HWSEEK_WRAP,
+		.rangelow   =  76000 * 16,
+		.rangehigh  =  90000 * 16,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+};
 
 /**************************************************************************
  * Generic Functions
  **************************************************************************/
 
 /*
+ * si470x_set_band - set the band
+ */
+static int si470x_set_band(struct si470x_device *radio, int band)
+{
+	if (radio->band == band)
+		return 0;
+
+	radio->band = band;
+	radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_BAND;
+	radio->registers[SYSCONFIG2] |= radio->band << 6;
+	return si470x_set_register(radio, SYSCONFIG2);
+}
+
+/*
  * si470x_set_chan - set the channel
  */
 static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
@@ -194,48 +235,39 @@ done:
 	return retval;
 }
 
-
 /*
- * si470x_get_freq - get the frequency
+ * si470x_get_step - get channel spacing
  */
-static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
+static unsigned int si470x_get_step(struct si470x_device *radio)
 {
-	unsigned int spacing, band_bottom;
-	unsigned short chan;
-	int retval;
-
 	/* Spacing (kHz) */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
 	case 0:
-		spacing = 0.200 * FREQ_MUL; break;
+		return 200 * 16;
 	/* 1: 100 kHz (Europe, Japan) */
 	case 1:
-		spacing = 0.100 * FREQ_MUL; break;
+		return 100 * 16;
 	/* 2:  50 kHz */
 	default:
-		spacing = 0.050 * FREQ_MUL; break;
+		return 50 * 16;
 	};
+}
 
-	/* Bottom of Band (MHz) */
-	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
-	/* 0: 87.5 - 108 MHz (USA, Europe) */
-	case 0:
-		band_bottom = 87.5 * FREQ_MUL; break;
-	/* 1: 76   - 108 MHz (Japan wide band) */
-	default:
-		band_bottom = 76   * FREQ_MUL; break;
-	/* 2: 76   -  90 MHz (Japan) */
-	case 2:
-		band_bottom = 76   * FREQ_MUL; break;
-	};
+
+/*
+ * si470x_get_freq - get the frequency
+ */
+static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
+{
+	int chan, retval;
 
 	/* read channel */
 	retval = si470x_get_register(radio, READCHAN);
 	chan = radio->registers[READCHAN] & READCHAN_READCHAN;
 
 	/* Frequency (MHz) = Spacing (kHz) x Channel + Bottom of Band (MHz) */
-	*freq = chan * spacing + band_bottom;
+	*freq = chan * si470x_get_step(radio) + bands[radio->band].rangelow;
 
 	return retval;
 }
@@ -246,44 +278,12 @@ static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
  */
 int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
 {
-	unsigned int spacing, band_bottom, band_top;
 	unsigned short chan;
 
-	/* Spacing (kHz) */
-	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
-	/* 0: 200 kHz (USA, Australia) */
-	case 0:
-		spacing = 0.200 * FREQ_MUL; break;
-	/* 1: 100 kHz (Europe, Japan) */
-	case 1:
-		spacing = 0.100 * FREQ_MUL; break;
-	/* 2:  50 kHz */
-	default:
-		spacing = 0.050 * FREQ_MUL; break;
-	};
-
-	/* Bottom/Top of Band (MHz) */
-	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
-	/* 0: 87.5 - 108 MHz (USA, Europe) */
-	case 0:
-		band_bottom = 87.5 * FREQ_MUL;
-		band_top = 108 * FREQ_MUL;
-		break;
-	/* 1: 76   - 108 MHz (Japan wide band) */
-	default:
-		band_bottom = 76 * FREQ_MUL;
-		band_top = 108 * FREQ_MUL;
-		break;
-	/* 2: 76   -  90 MHz (Japan) */
-	case 2:
-		band_bottom = 76 * FREQ_MUL;
-		band_top = 90 * FREQ_MUL;
-		break;
-	};
-
-	freq = clamp(freq, band_bottom, band_top);
+	freq = clamp(freq, bands[radio->band].rangelow,
+			   bands[radio->band].rangehigh);
 	/* Chan = [ Freq (Mhz) - Bottom of Band (MHz) ] / Spacing (kHz) */
-	chan = (freq - band_bottom) / spacing;
+	chan = (freq - bands[radio->band].rangelow) / si470x_get_step(radio);
 
 	return si470x_set_chan(radio, chan);
 }
@@ -293,18 +293,43 @@ int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
  * si470x_set_seek - set seek
  */
 static int si470x_set_seek(struct si470x_device *radio,
-		unsigned int wrap_around, unsigned int seek_upward)
+			   struct v4l2_hw_freq_seek *seek)
 {
-	int retval = 0;
+	int band, retval;
+	unsigned int freq;
 	bool timed_out = 0;
 
+	/* set band */
+	if (seek->rangelow || seek->rangehigh) {
+		for (band = 0; band < ARRAY_SIZE(bands); band++) {
+			if (bands[band].rangelow  == seek->rangelow &&
+			    bands[band].rangehigh == seek->rangehigh)
+				break;
+		}
+		if (band == ARRAY_SIZE(bands))
+			return -EINVAL; /* No matching band found */
+	} else
+		band = 1; /* If nothing is specified seek 76 - 108 Mhz */
+
+	if (radio->band != band) {
+		retval = si470x_get_freq(radio, &freq);
+		if (retval)
+			return retval;
+		retval = si470x_set_band(radio, band);
+		if (retval)
+			return retval;
+		retval = si470x_set_freq(radio, freq);
+		if (retval)
+			return retval;
+	}
+
 	/* start seeking */
 	radio->registers[POWERCFG] |= POWERCFG_SEEK;
-	if (wrap_around == 1)
+	if (seek->wrap_around)
 		radio->registers[POWERCFG] &= ~POWERCFG_SKMODE;
 	else
 		radio->registers[POWERCFG] |= POWERCFG_SKMODE;
-	if (seek_upward == 1)
+	if (seek->seek_upward)
 		radio->registers[POWERCFG] |= POWERCFG_SEEKUP;
 	else
 		radio->registers[POWERCFG] &= ~POWERCFG_SEEKUP;
@@ -360,7 +385,7 @@ int si470x_start(struct si470x_device *radio)
 	/* sysconfig 2 */
 	radio->registers[SYSCONFIG2] =
 		(0x1f  << 8) |				/* SEEKTH */
-		((band  << 6) & SYSCONFIG2_BAND)  |	/* BAND */
+		((radio->band << 6) & SYSCONFIG2_BAND) |/* BAND */
 		((space << 4) & SYSCONFIG2_SPACE) |	/* SPACE */
 		15;					/* VOLUME (max) */
 	retval = si470x_set_register(radio, SYSCONFIG2);
@@ -569,25 +594,8 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
 			    V4L2_TUNER_CAP_HWSEEK_BOUNDED |
 			    V4L2_TUNER_CAP_HWSEEK_WRAP;
-
-	/* range limits */
-	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
-	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
-	default:
-		tuner->rangelow  =  87.5 * FREQ_MUL;
-		tuner->rangehigh = 108   * FREQ_MUL;
-		break;
-	/* 1: 76   - 108 MHz (Japan wide band) */
-	case 1:
-		tuner->rangelow  =  76   * FREQ_MUL;
-		tuner->rangehigh = 108   * FREQ_MUL;
-		break;
-	/* 2: 76   -  90 MHz (Japan) */
-	case 2:
-		tuner->rangelow  =  76   * FREQ_MUL;
-		tuner->rangehigh =  90   * FREQ_MUL;
-		break;
-	};
+	tuner->rangelow  =  76 * FREQ_MUL;
+	tuner->rangehigh = 108 * FREQ_MUL;
 
 	/* stereo indicator == stereo (instead of mono) */
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_ST) == 0)
@@ -670,10 +678,18 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_drvdata(file);
+	int retval;
 
 	if (freq->tuner != 0)
 		return -EINVAL;
 
+	if (freq->frequency < bands[radio->band].rangelow ||
+	    freq->frequency > bands[radio->band].rangehigh) {
+		/* Switch to band 1 which covers everything we support */
+		retval = si470x_set_band(radio, 1);
+		if (retval)
+			return retval;
+	}
 	return si470x_set_freq(radio, freq->frequency);
 }
 
@@ -689,7 +705,21 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 	if (seek->tuner != 0)
 		return -EINVAL;
 
-	return si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
+	return si470x_set_seek(radio, seek);
+}
+
+/*
+ * si470x_vidioc_enum_freq_bands - enumerate supported bands
+ */
+static int si470x_vidioc_enum_freq_bands(struct file *file, void *priv,
+					 struct v4l2_frequency_band *band)
+{
+	if (band->tuner != 0)
+		return -EINVAL;
+	if (band->index >= ARRAY_SIZE(bands))
+		return -EINVAL;
+	*band = bands[band->index];
+	return 0;
 }
 
 const struct v4l2_ctrl_ops si470x_ctrl_ops = {
@@ -706,6 +736,7 @@ static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
 	.vidioc_g_frequency	= si470x_vidioc_g_frequency,
 	.vidioc_s_frequency	= si470x_vidioc_s_frequency,
 	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
+	.vidioc_enum_freq_bands = si470x_vidioc_enum_freq_bands,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index fb401a2..643a6ff 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -350,6 +350,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	}
 
 	radio->client = client;
+	radio->band = 1; /* Default to 76 - 108 MHz */
 	mutex_init(&radio->lock);
 	init_completion(&radio->completion);
 
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 0204cf4..146be42 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -597,6 +597,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	}
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
+	radio->band = 1; /* Default to 76 - 108 MHz */
 	mutex_init(&radio->lock);
 	init_completion(&radio->completion);
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 11f14b6..8e3a62f 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -147,6 +147,7 @@ struct si470x_device {
 	struct v4l2_device v4l2_dev;
 	struct video_device videodev;
 	struct v4l2_ctrl_handler hdl;
+	int band;
 
 	/* Silabs internal registers (0..15) */
 	unsigned short registers[RADIO_REGISTER_NUM];
-- 
1.7.10.4

