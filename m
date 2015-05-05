Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59304 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbbEEV7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:59:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 19/21] fc2580: implement V4L2 subdevice for SDR control
Date: Wed,  6 May 2015 00:58:40 +0300
Message-Id: <1430863122-9888-19-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement V4L2 subdevice for bandwidth and frequency controls of
SDR usage. That driver now implements both DVB frontend and V4L2
subdevice. Driver itself is I2C driver. Lets see how it works.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 262 +++++++++++++++++++++++++++++++++----
 drivers/media/tuners/fc2580.h      |   5 +
 drivers/media/tuners/fc2580_priv.h |  11 ++
 3 files changed, 249 insertions(+), 29 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 30cee76..db21902 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -38,20 +38,19 @@ static int fc2580_wr_reg_ff(struct fc2580_dev *dev, u8 reg, u8 val)
 		return regmap_write(dev->regmap, reg, val);
 }
 
-static int fc2580_set_params(struct dvb_frontend *fe)
+static int fc2580_set_params(struct fc2580_dev *dev)
 {
-	struct fc2580_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int uitmp, div_ref, div_ref_val, div_n, k, k_cw, div_out;
 	u64 f_vco;
 	u8 synth_config;
 	unsigned long timeout;
 
-	dev_dbg(&client->dev,
-		"delivery_system=%u frequency=%u bandwidth_hz=%u\n",
-		c->delivery_system, c->frequency, c->bandwidth_hz);
+	if (!dev->active) {
+		dev_dbg(&client->dev, "tuner is sleeping\n");
+		return 0;
+	}
 
 	/*
 	 * Fractional-N synthesizer
@@ -69,7 +68,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	 *                               +-------+
 	 */
 	for (i = 0; i < ARRAY_SIZE(fc2580_pll_lut); i++) {
-		if (c->frequency <= fc2580_pll_lut[i].freq)
+		if (dev->f_frequency <= fc2580_pll_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(fc2580_pll_lut)) {
@@ -80,7 +79,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	#define DIV_PRE_N 2
 	#define F_REF dev->clk
 	div_out = fc2580_pll_lut[i].div_out;
-	f_vco = (u64) c->frequency * div_out;
+	f_vco = (u64) dev->f_frequency * div_out;
 	synth_config = fc2580_pll_lut[i].band;
 	if (f_vco < 2600000000ULL)
 		synth_config |= 0x06;
@@ -106,8 +105,9 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	k_cw = div_u64((u64) k * 0x100000, uitmp);
 
 	dev_dbg(&client->dev,
-		"frequency=%u f_vco=%llu F_REF=%u div_ref=%u div_n=%u k=%u div_out=%u k_cw=%0x\n",
-		c->frequency, f_vco, F_REF, div_ref, div_n, k, div_out, k_cw);
+		"frequency=%u bandwidth=%u f_vco=%llu F_REF=%u div_ref=%u div_n=%u k=%u div_out=%u k_cw=%0x\n",
+		dev->f_frequency, dev->f_bandwidth, f_vco, F_REF, div_ref,
+		div_n, k, div_out, k_cw);
 
 	ret = regmap_write(dev->regmap, 0x02, synth_config);
 	if (ret)
@@ -131,7 +131,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 
 	/* registers */
 	for (i = 0; i < ARRAY_SIZE(fc2580_freq_regs_lut); i++) {
-		if (c->frequency <= fc2580_freq_regs_lut[i].freq)
+		if (dev->f_frequency <= fc2580_freq_regs_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(fc2580_freq_regs_lut)) {
@@ -237,7 +237,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 
 	/* IF filters */
 	for (i = 0; i < ARRAY_SIZE(fc2580_if_filter_lut); i++) {
-		if (c->bandwidth_hz <= fc2580_if_filter_lut[i].freq)
+		if (dev->f_bandwidth <= fc2580_if_filter_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(fc2580_if_filter_lut)) {
@@ -249,7 +249,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	uitmp = (unsigned int) 8058000 - (c->bandwidth_hz * 122 / 100 / 2);
+	uitmp = (unsigned int) 8058000 - (dev->f_bandwidth * 122 / 100 / 2);
 	uitmp = div64_u64((u64) dev->clk * uitmp, 1000000000000ULL);
 	ret = regmap_write(dev->regmap, 0x37, uitmp);
 	if (ret)
@@ -285,9 +285,8 @@ err:
 	return ret;
 }
 
-static int fc2580_init(struct dvb_frontend *fe)
+static int fc2580_init(struct fc2580_dev *dev)
 {
-	struct fc2580_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
 	int ret, i;
 
@@ -300,56 +299,236 @@ static int fc2580_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	dev->active = true;
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-static int fc2580_sleep(struct dvb_frontend *fe)
+static int fc2580_sleep(struct fc2580_dev *dev)
 {
-	struct fc2580_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
 
 	dev_dbg(&client->dev, "\n");
 
+	dev->active = false;
+
 	ret = regmap_write(dev->regmap, 0x02, 0x0a);
 	if (ret)
 		goto err;
-
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-static int fc2580_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+/*
+ * DVB API
+ */
+static int fc2580_dvb_set_params(struct dvb_frontend *fe)
 {
 	struct fc2580_dev *dev = fe->tuner_priv;
-	struct i2c_client *client = dev->client;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	dev_dbg(&client->dev, "\n");
+	dev->f_frequency = c->frequency;
+	dev->f_bandwidth = c->bandwidth_hz;
+	return fc2580_set_params(dev);
+}
 
-	*frequency = 0; /* Zero-IF */
+static int fc2580_dvb_init(struct dvb_frontend *fe)
+{
+	return fc2580_init(fe->tuner_priv);
+}
 
+static int fc2580_dvb_sleep(struct dvb_frontend *fe)
+{
+	return fc2580_sleep(fe->tuner_priv);
+}
+
+static int fc2580_dvb_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency = 0; /* Zero-IF */
 	return 0;
 }
 
-static const struct dvb_tuner_ops fc2580_tuner_ops = {
+static const struct dvb_tuner_ops fc2580_dvb_tuner_ops = {
 	.info = {
 		.name           = "FCI FC2580",
 		.frequency_min  = 174000000,
 		.frequency_max  = 862000000,
 	},
 
-	.init = fc2580_init,
-	.sleep = fc2580_sleep,
-	.set_params = fc2580_set_params,
+	.init = fc2580_dvb_init,
+	.sleep = fc2580_dvb_sleep,
+	.set_params = fc2580_dvb_set_params,
 
-	.get_if_frequency = fc2580_get_if_frequency,
+	.get_if_frequency = fc2580_dvb_get_if_frequency,
 };
 
+/*
+ * V4L2 API
+ */
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.type = V4L2_TUNER_RF,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =   130000000,
+		.rangehigh  =  2000000000,
+	},
+};
+
+static inline struct fc2580_dev *fc2580_subdev_to_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct fc2580_dev, subdev);
+}
+
+static int fc2580_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+	int ret;
+
+	dev_dbg(&client->dev, "on=%d\n", on);
+
+	if (on)
+		ret = fc2580_init(dev);
+	else
+		ret = fc2580_sleep(dev);
+	if (ret)
+		return ret;
+
+	return fc2580_set_params(dev);
+}
+
+static const struct v4l2_subdev_core_ops fc2580_subdev_core_ops = {
+	.s_power                  = fc2580_s_power,
+};
+
+static int fc2580_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "index=%d\n", v->index);
+
+	strlcpy(v->name, "FCI FC2580", sizeof(v->name));
+	v->type = V4L2_TUNER_RF;
+	v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+	v->rangelow  = bands[0].rangelow;
+	v->rangehigh = bands[0].rangehigh;
+	return 0;
+}
+
+static int fc2580_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *v)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "index=%d\n", v->index);
+	return 0;
+}
+
+static int fc2580_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "tuner=%d\n", f->tuner);
+	f->frequency = dev->f_frequency;
+	return 0;
+}
+
+static int fc2580_s_frequency(struct v4l2_subdev *sd,
+			      const struct v4l2_frequency *f)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "tuner=%d type=%d frequency=%u\n",
+		f->tuner, f->type, f->frequency);
+
+	dev->f_frequency = clamp_t(unsigned int, f->frequency,
+				   bands[0].rangelow, bands[0].rangehigh);
+	return fc2580_set_params(dev);
+}
+
+static int fc2580_enum_freq_bands(struct v4l2_subdev *sd,
+				  struct v4l2_frequency_band *band)
+{
+	struct fc2580_dev *dev = fc2580_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "tuner=%d type=%d index=%d\n",
+		band->tuner, band->type, band->index);
+
+	if (band->index >= ARRAY_SIZE(bands))
+		return -EINVAL;
+
+	band->capability = bands[band->index].capability;
+	band->rangelow = bands[band->index].rangelow;
+	band->rangehigh = bands[band->index].rangehigh;
+	return 0;
+}
+
+static const struct v4l2_subdev_tuner_ops fc2580_subdev_tuner_ops = {
+	.g_tuner                  = fc2580_g_tuner,
+	.s_tuner                  = fc2580_s_tuner,
+	.g_frequency              = fc2580_g_frequency,
+	.s_frequency              = fc2580_s_frequency,
+	.enum_freq_bands          = fc2580_enum_freq_bands,
+};
+
+static const struct v4l2_subdev_ops fc2580_subdev_ops = {
+	.core                     = &fc2580_subdev_core_ops,
+	.tuner                    = &fc2580_subdev_tuner_ops,
+};
+
+static int fc2580_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct fc2580_dev *dev = container_of(ctrl->handler, struct fc2580_dev, hdl);
+	struct i2c_client *client = dev->client;
+	int ret;
+
+	dev_dbg(&client->dev, "ctrl: id=%d name=%s cur.val=%d val=%d\n",
+		ctrl->id, ctrl->name, ctrl->cur.val, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
+	case V4L2_CID_RF_TUNER_BANDWIDTH:
+		/*
+		 * TODO: Auto logic does not work 100% correctly as tuner driver
+		 * do not have information to calculate maximum suitable
+		 * bandwidth. Calculating it is responsible of master driver.
+		 */
+		dev->f_bandwidth = dev->bandwidth->val;
+		ret = fc2580_set_params(dev);
+		break;
+	default:
+		dev_dbg(&client->dev, "unknown ctrl");
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops fc2580_ctrl_ops = {
+	.s_ctrl = fc2580_s_ctrl,
+};
+#endif
+
+static struct v4l2_subdev *fc2580_get_v4l2_subdev(struct i2c_client *client)
+{
+	struct fc2580_dev *dev = i2c_get_clientdata(client);
+
+	if (dev->subdev.ops)
+		return &dev->subdev;
+	else
+		return NULL;
+}
+
 static int fc2580_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -395,9 +574,31 @@ static int fc2580_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
+	/* Register controls */
+	v4l2_ctrl_handler_init(&dev->hdl, 2);
+	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &fc2580_ctrl_ops,
+						V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
+						0, 1, 1, 1);
+	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &fc2580_ctrl_ops,
+					   V4L2_CID_RF_TUNER_BANDWIDTH,
+					   3000, 10000000, 1, 3000);
+	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&client->dev, "Could not initialize controls\n");
+		v4l2_ctrl_handler_free(&dev->hdl);
+		goto err_kfree;
+	}
+	dev->subdev.ctrl_handler = &dev->hdl;
+	dev->f_frequency = bands[0].rangelow;
+	dev->f_bandwidth = dev->bandwidth->val;
+	v4l2_i2c_subdev_init(&dev->subdev, client, &fc2580_subdev_ops);
+#endif
 	fe->tuner_priv = dev;
-	memcpy(&fe->ops.tuner_ops, &fc2580_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
+	memcpy(&fe->ops.tuner_ops, &fc2580_dvb_tuner_ops,
+	       sizeof(fe->ops.tuner_ops));
+	pdata->get_v4l2_subdev = fc2580_get_v4l2_subdev;
 	i2c_set_clientdata(client, dev);
 
 	dev_info(&client->dev, "FCI FC2580 successfully identified\n");
@@ -415,6 +616,9 @@ static int fc2580_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
+	v4l2_ctrl_handler_free(&dev->hdl);
+#endif
 	kfree(dev);
 	return 0;
 }
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
index 61ee0e8..862ea46 100644
--- a/drivers/media/tuners/fc2580.h
+++ b/drivers/media/tuners/fc2580.h
@@ -22,6 +22,8 @@
 #define FC2580_H
 
 #include "dvb_frontend.h"
+#include <media/v4l2-subdev.h>
+#include <linux/i2c.h>
 
 /*
  * I2C address
@@ -32,10 +34,13 @@
  * struct fc2580_platform_data - Platform data for the fc2580 driver
  * @clk: Clock frequency (0 = internal clock).
  * @dvb_frontend: DVB frontend.
+ * @get_v4l2_subdev: Get V4L2 subdev.
  */
 struct fc2580_platform_data {
 	u32 clk;
 	struct dvb_frontend *dvb_frontend;
+
+	struct v4l2_subdev* (*get_v4l2_subdev)(struct i2c_client *);
 };
 
 #endif
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index bd88b01..031a43d 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -22,6 +22,8 @@
 #define FC2580_PRIV_H
 
 #include "fc2580.h"
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
 #include <linux/regmap.h>
 #include <linux/math64.h>
 
@@ -131,6 +133,15 @@ struct fc2580_dev {
 	u32 clk;
 	struct i2c_client *client;
 	struct regmap *regmap;
+	struct v4l2_subdev subdev;
+	bool active;
+	unsigned int f_frequency;
+	unsigned int f_bandwidth;
+
+	/* Controls */
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
 };
 
 #endif
-- 
http://palosaari.fi/

