Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36776 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbbEEVmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:42:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] msi001: cleanups / renames
Date: Wed,  6 May 2015 00:42:00 +0300
Message-Id: <1430862122-9326-2-git-send-email-crope@iki.fi>
In-Reply-To: <1430862122-9326-1-git-send-email-crope@iki.fi>
References: <1430862122-9326-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename state from s to dev. Rename some other things. Fix indentations.
Disable driver unbind via sysfs.

Signed-off-by: Antti Palosaari <crope@iki.fi>

indentation prevent unload

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/msi001.c | 195 ++++++++++++++++++++++--------------------
 1 file changed, 101 insertions(+), 94 deletions(-)

diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index d0ec4e3..b533240 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -36,7 +36,7 @@ static const struct v4l2_frequency_band bands[] = {
 	},
 };
 
-struct msi001 {
+struct msi001_dev {
 	struct spi_device *spi;
 	struct v4l2_subdev sd;
 
@@ -51,25 +51,26 @@ struct msi001 {
 	unsigned int f_tuner;
 };
 
-static inline struct msi001 *sd_to_msi001(struct v4l2_subdev *sd)
+static inline struct msi001_dev *sd_to_msi001_dev(struct v4l2_subdev *sd)
 {
-	return container_of(sd, struct msi001, sd);
+	return container_of(sd, struct msi001_dev, sd);
 }
 
-static int msi001_wreg(struct msi001 *s, u32 data)
+static int msi001_wreg(struct msi001_dev *dev, u32 data)
 {
 	/* Register format: 4 bits addr + 20 bits value */
-	return spi_write(s->spi, &data, 3);
+	return spi_write(dev->spi, &data, 3);
 };
 
-static int msi001_set_gain(struct msi001 *s, int lna_gain, int mixer_gain,
-		int if_gain)
+static int msi001_set_gain(struct msi001_dev *dev, int lna_gain, int mixer_gain,
+			   int if_gain)
 {
+	struct spi_device *spi = dev->spi;
 	int ret;
 	u32 reg;
 
-	dev_dbg(&s->spi->dev, "lna=%d mixer=%d if=%d\n",
-			lna_gain, mixer_gain, if_gain);
+	dev_dbg(&spi->dev, "lna=%d mixer=%d if=%d\n",
+		lna_gain, mixer_gain, if_gain);
 
 	reg = 1 << 0;
 	reg |= (59 - if_gain) << 4;
@@ -78,18 +79,19 @@ static int msi001_set_gain(struct msi001 *s, int lna_gain, int mixer_gain,
 	reg |= (1 - lna_gain) << 13;
 	reg |= 4 << 14;
 	reg |= 0 << 17;
-	ret = msi001_wreg(s, reg);
+	ret = msi001_wreg(dev, reg);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->spi->dev, "failed %d\n", ret);
+	dev_dbg(&spi->dev, "failed %d\n", ret);
 	return ret;
 };
 
-static int msi001_set_tuner(struct msi001 *s)
+static int msi001_set_tuner(struct msi001_dev *dev)
 {
+	struct spi_device *spi = dev->spi;
 	int ret, i;
 	unsigned int uitmp, div_n, k, k_thresh, k_frac, div_lo, f_if1;
 	u32 reg;
@@ -130,7 +132,7 @@ static int msi001_set_tuner(struct msi001 *s)
 		{8000000, 0x07}, /* 8 MHz */
 	};
 
-	unsigned int f_rf = s->f_tuner;
+	unsigned int f_rf = dev->f_tuner;
 
 	/*
 	 * bandwidth (Hz)
@@ -147,7 +149,7 @@ static int msi001_set_tuner(struct msi001 *s)
 	#define DIV_PRE_N 4
 	#define	F_VCO_STEP div_lo
 
-	dev_dbg(&s->spi->dev, "f_rf=%d f_if=%d\n", f_rf, f_if);
+	dev_dbg(&spi->dev, "f_rf=%d f_if=%d\n", f_rf, f_if);
 
 	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
 		if (f_rf <= band_lut[i].rf) {
@@ -156,7 +158,6 @@ static int msi001_set_tuner(struct msi001 *s)
 			break;
 		}
 	}
-
 	if (i == ARRAY_SIZE(band_lut)) {
 		ret = -EINVAL;
 		goto err;
@@ -174,14 +175,13 @@ static int msi001_set_tuner(struct msi001 *s)
 			break;
 		}
 	}
-
 	if (i == ARRAY_SIZE(if_freq_lut)) {
 		ret = -EINVAL;
 		goto err;
 	}
 
 	/* filters */
-	bandwidth = s->bandwidth->val;
+	bandwidth = dev->bandwidth->val;
 	bandwidth = clamp(bandwidth, 200000U, 8000000U);
 
 	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
@@ -190,15 +190,14 @@ static int msi001_set_tuner(struct msi001 *s)
 			break;
 		}
 	}
-
 	if (i == ARRAY_SIZE(bandwidth_lut)) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	s->bandwidth->val = bandwidth_lut[i].freq;
+	dev->bandwidth->val = bandwidth_lut[i].freq;
 
-	dev_dbg(&s->spi->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
+	dev_dbg(&spi->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
 
 	/*
 	 * Fractional-N synthesizer
@@ -237,15 +236,15 @@ static int msi001_set_tuner(struct msi001 *s)
 	uitmp += (unsigned int) F_REF * DIV_PRE_N * k_frac / k_thresh;
 	uitmp /= div_lo;
 
-	dev_dbg(&s->spi->dev,
+	dev_dbg(&spi->dev,
 		"f_rf=%u:%u f_vco=%llu div_n=%u k_thresh=%u k_frac=%u div_lo=%u\n",
 		f_rf, uitmp, f_vco, div_n, k_thresh, k_frac, div_lo);
 
-	ret = msi001_wreg(s, 0x00000e);
+	ret = msi001_wreg(dev, 0x00000e);
 	if (ret)
 		goto err;
 
-	ret = msi001_wreg(s, 0x000003);
+	ret = msi001_wreg(dev, 0x000003);
 	if (ret)
 		goto err;
 
@@ -255,7 +254,7 @@ static int msi001_set_tuner(struct msi001 *s)
 	reg |= bandwidth << 14;
 	reg |= 0x02 << 17;
 	reg |= 0x00 << 20;
-	ret = msi001_wreg(s, reg);
+	ret = msi001_wreg(dev, reg);
 	if (ret)
 		goto err;
 
@@ -263,46 +262,47 @@ static int msi001_set_tuner(struct msi001 *s)
 	reg |= k_thresh << 4;
 	reg |= 1 << 19;
 	reg |= 1 << 21;
-	ret = msi001_wreg(s, reg);
+	ret = msi001_wreg(dev, reg);
 	if (ret)
 		goto err;
 
 	reg = 2 << 0;
 	reg |= k_frac << 4;
 	reg |= div_n << 16;
-	ret = msi001_wreg(s, reg);
+	ret = msi001_wreg(dev, reg);
 	if (ret)
 		goto err;
 
-	ret = msi001_set_gain(s, s->lna_gain->cur.val, s->mixer_gain->cur.val,
-			s->if_gain->cur.val);
+	ret = msi001_set_gain(dev, dev->lna_gain->cur.val,
+			      dev->mixer_gain->cur.val, dev->if_gain->cur.val);
 	if (ret)
 		goto err;
 
 	reg = 6 << 0;
 	reg |= 63 << 4;
 	reg |= 4095 << 10;
-	ret = msi001_wreg(s, reg);
+	ret = msi001_wreg(dev, reg);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->spi->dev, "failed %d\n", ret);
+	dev_dbg(&spi->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int msi001_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 	int ret;
 
-	dev_dbg(&s->spi->dev, "on=%d\n", on);
+	dev_dbg(&spi->dev, "on=%d\n", on);
 
 	if (on)
 		ret = 0;
 	else
-		ret = msi001_wreg(s, 0x000000);
+		ret = msi001_wreg(dev, 0x000000);
 
 	return ret;
 }
@@ -313,9 +313,10 @@ static const struct v4l2_subdev_core_ops msi001_core_ops = {
 
 static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 
-	dev_dbg(&s->spi->dev, "index=%d\n", v->index);
+	dev_dbg(&spi->dev, "index=%d\n", v->index);
 
 	strlcpy(v->name, "Mirics MSi001", sizeof(v->name));
 	v->type = V4L2_TUNER_RF;
@@ -328,47 +329,51 @@ static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 
 static int msi001_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *v)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 
-	dev_dbg(&s->spi->dev, "index=%d\n", v->index);
+	dev_dbg(&spi->dev, "index=%d\n", v->index);
 	return 0;
 }
 
 static int msi001_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 
-	dev_dbg(&s->spi->dev, "tuner=%d\n", f->tuner);
-	f->frequency = s->f_tuner;
+	dev_dbg(&spi->dev, "tuner=%d\n", f->tuner);
+	f->frequency = dev->f_tuner;
 	return 0;
 }
 
 static int msi001_s_frequency(struct v4l2_subdev *sd,
-		const struct v4l2_frequency *f)
+			      const struct v4l2_frequency *f)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 	unsigned int band;
 
-	dev_dbg(&s->spi->dev, "tuner=%d type=%d frequency=%u\n",
-			f->tuner, f->type, f->frequency);
+	dev_dbg(&spi->dev, "tuner=%d type=%d frequency=%u\n",
+		f->tuner, f->type, f->frequency);
 
 	if (f->frequency < ((bands[0].rangehigh + bands[1].rangelow) / 2))
 		band = 0;
 	else
 		band = 1;
-	s->f_tuner = clamp_t(unsigned int, f->frequency,
-			bands[band].rangelow, bands[band].rangehigh);
+	dev->f_tuner = clamp_t(unsigned int, f->frequency,
+			       bands[band].rangelow, bands[band].rangehigh);
 
-	return msi001_set_tuner(s);
+	return msi001_set_tuner(dev);
 }
 
 static int msi001_enum_freq_bands(struct v4l2_subdev *sd,
-		struct v4l2_frequency_band *band)
+				  struct v4l2_frequency_band *band)
 {
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
+	struct spi_device *spi = dev->spi;
 
-	dev_dbg(&s->spi->dev, "tuner=%d type=%d index=%d\n",
-			band->tuner, band->type, band->index);
+	dev_dbg(&spi->dev, "tuner=%d type=%d index=%d\n",
+		band->tuner, band->type, band->index);
 
 	if (band->index >= ARRAY_SIZE(bands))
 		return -EINVAL;
@@ -395,34 +400,37 @@ static const struct v4l2_subdev_ops msi001_ops = {
 
 static int msi001_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct msi001 *s = container_of(ctrl->handler, struct msi001, hdl);
+	struct msi001_dev *dev = container_of(ctrl->handler, struct msi001_dev, hdl);
+	struct spi_device *spi = dev->spi;
 
 	int ret;
 
-	dev_dbg(&s->spi->dev,
-			"id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
-			ctrl->id, ctrl->name, ctrl->val,
-			ctrl->minimum, ctrl->maximum, ctrl->step);
+	dev_dbg(&spi->dev, "id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
+		ctrl->id, ctrl->name, ctrl->val, ctrl->minimum, ctrl->maximum,
+		ctrl->step);
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		ret = msi001_set_tuner(s);
+		ret = msi001_set_tuner(dev);
 		break;
 	case  V4L2_CID_RF_TUNER_LNA_GAIN:
-		ret = msi001_set_gain(s, s->lna_gain->val,
-				s->mixer_gain->cur.val, s->if_gain->cur.val);
+		ret = msi001_set_gain(dev, dev->lna_gain->val,
+				      dev->mixer_gain->cur.val,
+				      dev->if_gain->cur.val);
 		break;
 	case  V4L2_CID_RF_TUNER_MIXER_GAIN:
-		ret = msi001_set_gain(s, s->lna_gain->cur.val,
-				s->mixer_gain->val, s->if_gain->cur.val);
+		ret = msi001_set_gain(dev, dev->lna_gain->cur.val,
+				      dev->mixer_gain->val,
+				      dev->if_gain->cur.val);
 		break;
 	case  V4L2_CID_RF_TUNER_IF_GAIN:
-		ret = msi001_set_gain(s, s->lna_gain->cur.val,
-				s->mixer_gain->cur.val, s->if_gain->val);
+		ret = msi001_set_gain(dev, dev->lna_gain->cur.val,
+				      dev->mixer_gain->cur.val,
+				      dev->if_gain->val);
 		break;
 	default:
-		dev_dbg(&s->spi->dev, "unknown control %d\n", ctrl->id);
+		dev_dbg(&spi->dev, "unknown control %d\n", ctrl->id);
 		ret = -EINVAL;
 	}
 
@@ -435,56 +443,54 @@ static const struct v4l2_ctrl_ops msi001_ctrl_ops = {
 
 static int msi001_probe(struct spi_device *spi)
 {
-	struct msi001 *s;
+	struct msi001_dev *dev;
 	int ret;
 
 	dev_dbg(&spi->dev, "\n");
 
-	s = kzalloc(sizeof(struct msi001), GFP_KERNEL);
-	if (s == NULL) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
-		dev_dbg(&spi->dev, "Could not allocate memory for msi001\n");
-		goto err_kfree;
+		goto err;
 	}
 
-	s->spi = spi;
-	s->f_tuner = bands[0].rangelow;
-	v4l2_spi_subdev_init(&s->sd, spi, &msi001_ops);
+	dev->spi = spi;
+	dev->f_tuner = bands[0].rangelow;
+	v4l2_spi_subdev_init(&dev->sd, spi, &msi001_ops);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->hdl, 5);
-	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, &msi001_ctrl_ops,
+	v4l2_ctrl_handler_init(&dev->hdl, 5);
+	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
-	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, &msi001_ctrl_ops,
+	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH, 200000, 8000000, 1, 200000);
-	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
-	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, &msi001_ctrl_ops,
+	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
+	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 1, 1, 1);
-	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, &msi001_ctrl_ops,
+	dev->mixer_gain = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_MIXER_GAIN, 0, 1, 1, 1);
-	s->if_gain = v4l2_ctrl_new_std(&s->hdl, &msi001_ctrl_ops,
+	dev->if_gain = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_IF_GAIN, 0, 59, 1, 0);
-	if (s->hdl.error) {
-		ret = s->hdl.error;
-		dev_err(&s->spi->dev, "Could not initialize controls\n");
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&spi->dev, "Could not initialize controls\n");
 		/* control init failed, free handler */
 		goto err_ctrl_handler_free;
 	}
 
-	s->sd.ctrl_handler = &s->hdl;
+	dev->sd.ctrl_handler = &dev->hdl;
 	return 0;
-
 err_ctrl_handler_free:
-	v4l2_ctrl_handler_free(&s->hdl);
-err_kfree:
-	kfree(s);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	kfree(dev);
+err:
 	return ret;
 }
 
 static int msi001_remove(struct spi_device *spi)
 {
 	struct v4l2_subdev *sd = spi_get_drvdata(spi);
-	struct msi001 *s = sd_to_msi001(sd);
+	struct msi001_dev *dev = sd_to_msi001_dev(sd);
 
 	dev_dbg(&spi->dev, "\n");
 
@@ -492,26 +498,27 @@ static int msi001_remove(struct spi_device *spi)
 	 * Registered by v4l2_spi_new_subdev() from master driver, but we must
 	 * unregister it from here. Weird.
 	 */
-	v4l2_device_unregister_subdev(&s->sd);
-	v4l2_ctrl_handler_free(&s->hdl);
-	kfree(s);
+	v4l2_device_unregister_subdev(&dev->sd);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	kfree(dev);
 	return 0;
 }
 
-static const struct spi_device_id msi001_id[] = {
+static const struct spi_device_id msi001_id_table[] = {
 	{"msi001", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(spi, msi001_id);
+MODULE_DEVICE_TABLE(spi, msi001_id_table);
 
 static struct spi_driver msi001_driver = {
 	.driver = {
 		.name	= "msi001",
 		.owner	= THIS_MODULE,
+		.suppress_bind_attrs = true,
 	},
 	.probe		= msi001_probe,
 	.remove		= msi001_remove,
-	.id_table	= msi001_id,
+	.id_table	= msi001_id_table,
 };
 module_spi_driver(msi001_driver);
 
-- 
http://palosaari.fi/

