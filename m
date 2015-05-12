Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47574 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091AbbELRvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 13:51:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 3/3] e4000: implement V4L2 subdevice tuner and core ops
Date: Tue, 12 May 2015 20:50:44 +0300
Message-Id: <1431453044-3775-3-git-send-email-crope@iki.fi>
In-Reply-To: <1431453044-3775-1-git-send-email-crope@iki.fi>
References: <1431453044-3775-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement V4L2 subdevice tuner and core ops. After that this driver
is hybrid driver implementing both V4L2 and DVB ops.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 216 +++++++++++++++++++++++++++++++-------
 drivers/media/tuners/e4000_priv.h |   2 +
 2 files changed, 182 insertions(+), 36 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 57bdca4..3b49a45 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -20,9 +20,8 @@
 
 #include "e4000_priv.h"
 
-static int e4000_init(struct dvb_frontend *fe)
+static int e4000_init(struct e4000_dev *dev)
 {
-	struct e4000_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
 
@@ -89,9 +88,8 @@ err:
 	return ret;
 }
 
-static int e4000_sleep(struct dvb_frontend *fe)
+static int e4000_sleep(struct e4000_dev *dev)
 {
-	struct e4000_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
 	int ret;
 
@@ -109,19 +107,18 @@ err:
 	return ret;
 }
 
-static int e4000_set_params(struct dvb_frontend *fe)
+static int e4000_set_params(struct e4000_dev *dev)
 {
-	struct e4000_dev *dev = fe->tuner_priv;
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	unsigned int div_n, k, k_cw, div_out;
 	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
-	dev_dbg(&client->dev,
-		"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
-		c->delivery_system, c->frequency, c->bandwidth_hz);
+	if (!dev->active) {
+		dev_dbg(&client->dev, "tuner is sleeping\n");
+		return 0;
+	}
 
 	/* gain control manual */
 	ret = regmap_write(dev->regmap, 0x1a, 0x00);
@@ -144,7 +141,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	 *                    +-------+
 	 */
 	for (i = 0; i < ARRAY_SIZE(e4000_pll_lut); i++) {
-		if (c->frequency <= e4000_pll_lut[i].freq)
+		if (dev->f_frequency <= e4000_pll_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(e4000_pll_lut)) {
@@ -154,14 +151,15 @@ static int e4000_set_params(struct dvb_frontend *fe)
 
 	#define F_REF dev->clk
 	div_out = e4000_pll_lut[i].div_out;
-	f_vco = (u64) c->frequency * div_out;
+	f_vco = (u64) dev->f_frequency * div_out;
 	/* calculate PLL integer and fractional control word */
 	div_n = div_u64_rem(f_vco, F_REF, &k);
 	k_cw = div_u64((u64) k * 0x10000, F_REF);
 
 	dev_dbg(&client->dev,
-		"frequency=%u f_vco=%llu F_REF=%u div_n=%u k=%u k_cw=%04x div_out=%u\n",
-		c->frequency, f_vco, F_REF, div_n, k, k_cw, div_out);
+		"frequency=%u bandwidth=%u f_vco=%llu F_REF=%u div_n=%u k=%u k_cw=%04x div_out=%u\n",
+		dev->f_frequency, dev->f_bandwidth, f_vco, F_REF, div_n, k,
+		k_cw, div_out);
 
 	buf[0] = div_n;
 	buf[1] = (k_cw >> 0) & 0xff;
@@ -174,7 +172,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 
 	/* LNA filter (RF filter) */
 	for (i = 0; i < ARRAY_SIZE(e400_lna_filter_lut); i++) {
-		if (c->frequency <= e400_lna_filter_lut[i].freq)
+		if (dev->f_frequency <= e400_lna_filter_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(e400_lna_filter_lut)) {
@@ -188,7 +186,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 
 	/* IF filters */
 	for (i = 0; i < ARRAY_SIZE(e4000_if_filter_lut); i++) {
-		if (c->bandwidth_hz <= e4000_if_filter_lut[i].freq)
+		if (dev->f_bandwidth <= e4000_if_filter_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(e4000_if_filter_lut)) {
@@ -205,7 +203,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 
 	/* frequency band */
 	for (i = 0; i < ARRAY_SIZE(e4000_band_lut); i++) {
-		if (c->frequency <= e4000_band_lut[i].freq)
+		if (dev->f_frequency <= e4000_band_lut[i].freq)
 			break;
 	}
 	if (i == ARRAY_SIZE(e4000_band_lut)) {
@@ -269,19 +267,133 @@ err:
 	return ret;
 }
 
-static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+/*
+ * V4L2 API
+ */
+#if IS_ENABLED(CONFIG_VIDEO_V4L2)
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.type = V4L2_TUNER_RF,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =    59000000,
+		.rangehigh  =  1105000000,
+	},
+	{
+		.type = V4L2_TUNER_RF,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   =  1249000000,
+		.rangehigh  =  2208000000,
+	},
+};
+
+static inline struct e4000_dev *e4000_subdev_to_dev(struct v4l2_subdev *sd)
 {
-	struct e4000_dev *dev = fe->tuner_priv;
+	return container_of(sd, struct e4000_dev, sd);
+}
+
+static int e4000_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
 	struct i2c_client *client = dev->client;
+	int ret;
 
-	dev_dbg(&client->dev, "\n");
+	dev_dbg(&client->dev, "on=%d\n", on);
 
-	*frequency = 0; /* Zero-IF */
+	if (on)
+		ret = e4000_init(dev);
+	else
+		ret = e4000_sleep(dev);
+	if (ret)
+		return ret;
+
+	return e4000_set_params(dev);
+}
+
+static const struct v4l2_subdev_core_ops e4000_subdev_core_ops = {
+	.s_power                  = e4000_s_power,
+};
 
+static int e4000_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "index=%d\n", v->index);
+
+	strlcpy(v->name, "Elonics E4000", sizeof(v->name));
+	v->type = V4L2_TUNER_RF;
+	v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
+	v->rangelow  = bands[0].rangelow;
+	v->rangehigh = bands[1].rangehigh;
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_VIDEO_V4L2)
+static int e4000_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *v)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "index=%d\n", v->index);
+	return 0;
+}
+
+static int e4000_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "tuner=%d\n", f->tuner);
+	f->frequency = dev->f_frequency;
+	return 0;
+}
+
+static int e4000_s_frequency(struct v4l2_subdev *sd,
+			      const struct v4l2_frequency *f)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
+	struct i2c_client *client = dev->client;
+
+	dev_dbg(&client->dev, "tuner=%d type=%d frequency=%u\n",
+		f->tuner, f->type, f->frequency);
+
+	dev->f_frequency = clamp_t(unsigned int, f->frequency,
+				   bands[0].rangelow, bands[1].rangehigh);
+	return e4000_set_params(dev);
+}
+
+static int e4000_enum_freq_bands(struct v4l2_subdev *sd,
+				  struct v4l2_frequency_band *band)
+{
+	struct e4000_dev *dev = e4000_subdev_to_dev(sd);
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
+static const struct v4l2_subdev_tuner_ops e4000_subdev_tuner_ops = {
+	.g_tuner                  = e4000_g_tuner,
+	.s_tuner                  = e4000_s_tuner,
+	.g_frequency              = e4000_g_frequency,
+	.s_frequency              = e4000_s_frequency,
+	.enum_freq_bands          = e4000_enum_freq_bands,
+};
+
+static const struct v4l2_subdev_ops e4000_subdev_ops = {
+	.core                     = &e4000_subdev_core_ops,
+	.tuner                    = &e4000_subdev_tuner_ops,
+};
+
 static int e4000_set_lna_gain(struct dvb_frontend *fe)
 {
 	struct e4000_dev *dev = fe->tuner_priv;
@@ -434,7 +546,6 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct e4000_dev *dev = container_of(ctrl->handler, struct e4000_dev, hdl);
 	struct i2c_client *client = dev->client;
-	struct dtv_frontend_properties *c = &dev->fe->dtv_property_cache;
 	int ret;
 
 	if (!dev->active)
@@ -443,8 +554,13 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH:
-		c->bandwidth_hz = dev->bandwidth->val;
-		ret = e4000_set_params(dev->fe);
+		/*
+		 * TODO: Auto logic does not work 100% correctly as tuner driver
+		 * do not have information to calculate maximum suitable
+		 * bandwidth. Calculating it is responsible of master driver.
+		 */
+		dev->f_bandwidth = dev->bandwidth->val;
+		ret = e4000_set_params(dev);
 		break;
 	case  V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
 	case  V4L2_CID_RF_TUNER_LNA_GAIN:
@@ -473,24 +589,49 @@ static const struct v4l2_ctrl_ops e4000_ctrl_ops = {
 };
 #endif
 
-static const struct dvb_tuner_ops e4000_tuner_ops = {
+/*
+ * DVB API
+ */
+static int e4000_dvb_set_params(struct dvb_frontend *fe)
+{
+	struct e4000_dev *dev = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	dev->f_frequency = c->frequency;
+	dev->f_bandwidth = c->bandwidth_hz;
+	return e4000_set_params(dev);
+}
+
+static int e4000_dvb_init(struct dvb_frontend *fe)
+{
+	return e4000_init(fe->tuner_priv);
+}
+
+static int e4000_dvb_sleep(struct dvb_frontend *fe)
+{
+	return e4000_sleep(fe->tuner_priv);
+}
+
+static int e4000_dvb_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency = 0; /* Zero-IF */
+	return 0;
+}
+
+static const struct dvb_tuner_ops e4000_dvb_tuner_ops = {
 	.info = {
 		.name           = "Elonics E4000",
 		.frequency_min  = 174000000,
 		.frequency_max  = 862000000,
 	},
 
-	.init = e4000_init,
-	.sleep = e4000_sleep,
-	.set_params = e4000_set_params,
+	.init = e4000_dvb_init,
+	.sleep = e4000_dvb_sleep,
+	.set_params = e4000_dvb_set_params,
 
-	.get_if_frequency = e4000_get_if_frequency,
+	.get_if_frequency = e4000_dvb_get_if_frequency,
 };
 
-/*
- * Use V4L2 subdev to carry V4L2 control handler, even we don't implement
- * subdev itself, just to avoid reinventing the wheel.
- */
 static int e4000_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
 {
@@ -569,10 +710,13 @@ static int e4000_probe(struct i2c_client *client,
 	}
 
 	dev->sd.ctrl_handler = &dev->hdl;
+	dev->f_frequency = bands[0].rangelow;
+	dev->f_bandwidth = dev->bandwidth->val;
+	v4l2_i2c_subdev_init(&dev->sd, client, &e4000_subdev_ops);
 #endif
 	fe->tuner_priv = dev;
-	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
+	memcpy(&fe->ops.tuner_ops, &e4000_dvb_tuner_ops,
+	       sizeof(fe->ops.tuner_ops));
 	v4l2_set_subdevdata(&dev->sd, client);
 	i2c_set_clientdata(client, &dev->sd);
 
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index 8e991df..d6d5d11 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -34,6 +34,8 @@ struct e4000_dev {
 	struct dvb_frontend *fe;
 	struct v4l2_subdev sd;
 	bool active;
+	unsigned int f_frequency;
+	unsigned int f_bandwidth;
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
-- 
http://palosaari.fi/

