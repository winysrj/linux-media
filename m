Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55929 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 20/21] rtl2832_sdr: add support for fc2580 tuner
Date: Wed,  6 May 2015 00:58:41 +0300
Message-Id: <1430863122-9888-20-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for fc2580 tuner based devices.
Tuner is controlled via V4L2 subdevice API.
Passes v4l2-compliance tests.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 110 ++++++++++++++++++++++++------
 drivers/media/dvb-frontends/rtl2832_sdr.h |   1 +
 2 files changed, 92 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 3ff8806..c501bcd 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -39,6 +39,10 @@ static bool rtl2832_sdr_emulated_fmt;
 module_param_named(emulated_formats, rtl2832_sdr_emulated_fmt, bool, 0644);
 MODULE_PARM_DESC(emulated_formats, "enable emulated formats (disappears in future)");
 
+/* Original macro does not contain enough null pointer checks for our need */
+#define V4L2_SUBDEV_HAS_OP(sd, o, f) \
+	((sd) && (sd)->ops && (sd)->ops->o && (sd)->ops->o->f)
+
 #define MAX_BULK_BUFS            (10)
 #define BULK_BUFFER_SIZE         (128 * 512)
 
@@ -116,6 +120,7 @@ struct rtl2832_sdr_dev {
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
+	struct v4l2_subdev *v4l2_subdev;
 
 	/* videobuf2 queue and queued buffers list */
 	struct vb2_queue vb_queue;
@@ -742,6 +747,29 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
 		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xf4", 1);
 		break;
+	case RTL2832_SDR_TUNER_FC2580:
+		ret = rtl2832_sdr_wr_regs(dev, 0x112, "\x39", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c7, "\x2c", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c8, "\x16", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10a, "\x9c", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xe9\xf4", 2);
+		break;
 	default:
 		dev_notice(&pdev->dev, "Unsupported tuner\n");
 	}
@@ -832,8 +860,10 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 	if (!test_bit(POWER_ON, &dev->flags))
 		return 0;
 
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe);
+	if (!V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, s_frequency)) {
+		if (fe->ops.tuner_ops.set_params)
+			fe->ops.tuner_ops.set_params(fe);
+	}
 
 	return 0;
 };
@@ -891,7 +921,11 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	set_bit(POWER_ON, &dev->flags);
 
-	ret = rtl2832_sdr_set_tuner(dev);
+	/* wake-up tuner */
+	if (V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, core, s_power))
+		ret = v4l2_subdev_call(dev->v4l2_subdev, core, s_power, 1);
+	else
+		ret = rtl2832_sdr_set_tuner(dev);
 	if (ret)
 		goto err;
 
@@ -939,7 +973,12 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 	rtl2832_sdr_free_stream_bufs(dev);
 	rtl2832_sdr_cleanup_queued_bufs(dev);
 	rtl2832_sdr_unset_adc(dev);
-	rtl2832_sdr_unset_tuner(dev);
+
+	/* sleep tuner */
+	if (V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, core, s_power))
+		v4l2_subdev_call(dev->v4l2_subdev, core, s_power, 0);
+	else
+		rtl2832_sdr_unset_tuner(dev);
 
 	clear_bit(POWER_ON, &dev->flags);
 
@@ -968,6 +1007,7 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	struct platform_device *pdev = dev->pdev;
+	int ret;
 
 	dev_dbg(&pdev->dev, "index=%d type=%d\n", v->index, v->type);
 
@@ -977,17 +1017,21 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =   300000;
 		v->rangehigh = 3200000;
+		ret = 0;
+	} else if (v->index == 1 &&
+		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, g_tuner)) {
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, g_tuner, v);
 	} else if (v->index == 1) {
 		strlcpy(v->name, "RF: <unknown>", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =    50000000;
 		v->rangehigh = 2000000000;
+		ret = 0;
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-
-	return 0;
+	return ret;
 }
 
 static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
@@ -995,12 +1039,21 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	struct platform_device *pdev = dev->pdev;
+	int ret;
 
 	dev_dbg(&pdev->dev, "\n");
 
-	if (v->index > 1)
-		return -EINVAL;
-	return 0;
+	if (v->index == 0) {
+		ret = 0;
+	} else if (v->index == 1 &&
+		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, s_tuner)) {
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, s_tuner, v);
+	} else if (v->index == 1) {
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
@@ -1008,6 +1061,7 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	struct platform_device *pdev = dev->pdev;
+	int ret;
 
 	dev_dbg(&pdev->dev, "tuner=%d type=%d index=%d\n",
 		band->tuner, band->type, band->index);
@@ -1017,16 +1071,20 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 			return -EINVAL;
 
 		*band = bands_adc[band->index];
+		ret = 0;
+	} else if (band->tuner == 1 &&
+		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, enum_freq_bands)) {
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, enum_freq_bands, band);
 	} else if (band->tuner == 1) {
 		if (band->index >= ARRAY_SIZE(bands_fm))
 			return -EINVAL;
 
 		*band = bands_fm[band->index];
+		ret = 0;
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-
-	return 0;
+	return ret;
 }
 
 static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
@@ -1034,20 +1092,25 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
 	struct platform_device *pdev = dev->pdev;
-	int ret  = 0;
+	int ret;
 
 	dev_dbg(&pdev->dev, "tuner=%d type=%d\n", f->tuner, f->type);
 
 	if (f->tuner == 0) {
 		f->frequency = dev->f_adc;
 		f->type = V4L2_TUNER_ADC;
+		ret = 0;
+	} else if (f->tuner == 1 &&
+		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, g_frequency)) {
+		f->type = V4L2_TUNER_RF;
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, g_frequency, f);
 	} else if (f->tuner == 1) {
 		f->frequency = dev->f_tuner;
 		f->type = V4L2_TUNER_RF;
+		ret = 0;
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-
 	return ret;
 }
 
@@ -1074,11 +1137,14 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 			band = 2;
 
 		dev->f_adc = clamp_t(unsigned int, f->frequency,
-				bands_adc[band].rangelow,
-				bands_adc[band].rangehigh);
+				     bands_adc[band].rangelow,
+				     bands_adc[band].rangehigh);
 
 		dev_dbg(&pdev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
 		ret = rtl2832_sdr_set_adc(dev);
+	} else if (f->tuner == 1 &&
+		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, s_frequency)) {
+		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, s_frequency, f);
 	} else if (f->tuner == 1) {
 		dev->f_tuner = clamp_t(unsigned int, f->frequency,
 				bands_fm[0].rangelow,
@@ -1089,7 +1155,6 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 	} else {
 		ret = -EINVAL;
 	}
-
 	return ret;
 }
 
@@ -1329,6 +1394,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 
 	/* setup the state */
 	subdev = pdata->v4l2_subdev;
+	dev->v4l2_subdev = pdata->v4l2_subdev;
 	dev->pdev = pdev;
 	dev->udev = pdata->dvb_usb_device->udev;
 	dev->f_adc = bands_adc[0].rangelow;
@@ -1388,6 +1454,12 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 						   6000000);
 		v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 		break;
+	case RTL2832_SDR_TUNER_FC2580:
+		v4l2_ctrl_handler_init(&dev->hdl, 2);
+		if (subdev)
+			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler,
+					      NULL);
+		break;
 	default:
 		v4l2_ctrl_handler_init(&dev->hdl, 0);
 		dev_err(&pdev->dev, "Unsupported tuner\n");
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index d259476..342ea84 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -47,6 +47,7 @@ struct rtl2832_sdr_platform_data {
 	/*
 	 * XXX: This list must be kept sync with dvb_usb_rtl28xxu USB IF driver.
 	 */
+#define RTL2832_SDR_TUNER_FC2580    0x21
 #define RTL2832_SDR_TUNER_TUA9001   0x24
 #define RTL2832_SDR_TUNER_FC0012    0x26
 #define RTL2832_SDR_TUNER_E4000     0x27
-- 
http://palosaari.fi/

