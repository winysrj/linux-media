Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:51438 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbcAHPFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 10:05:32 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Rosin <peda@axentia.se>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Peter Rosin <peda@lysator.liu.se>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 2/8] i2c-mux: move select and deselect ops to i2c_mux_core
Date: Fri,  8 Jan 2016 16:04:50 +0100
Message-Id: <1452265496-22475-3-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

The mux select and deselect ops are common to the mux most of the time,
so store the ops in the mux core.

Change the select and deselect op to work in terms of the mux core instead
of the child adapter. No driver uses the child adapter anyway, and if it
is needed in a future mux driver it can be worked out from the channel id.

i2c-arb-gpio-challenge is special in that it needs the mux device pointer
in the select op, so store that device pointer in the mux core as well.
This pointer is going to get further use in later commits.

i2c-mux-pca954x is special since it does not add its deselect op to all
its child adapters, handle this by adding a mask that makes the deselect
op a no-operation for child adapters not wishing to deselect the mux.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c                      | 31 ++++++++++-------------------
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c | 18 ++++++++---------
 drivers/i2c/muxes/i2c-mux-gpio.c           | 19 +++++++++---------
 drivers/i2c/muxes/i2c-mux-pca9541.c        | 20 +++++++++++--------
 drivers/i2c/muxes/i2c-mux-pca954x.c        | 32 +++++++++++++++++++-----------
 drivers/i2c/muxes/i2c-mux-pinctrl.c        | 20 ++++++++-----------
 drivers/i2c/muxes/i2c-mux-reg.c            | 21 +++++++++-----------
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 17 +++++++---------
 drivers/media/dvb-frontends/m88ds3103.c    |  8 ++++----
 drivers/media/dvb-frontends/rtl2830.c      |  8 ++++----
 drivers/media/dvb-frontends/rtl2832.c      | 15 +++++++-------
 drivers/media/dvb-frontends/si2168.c       | 13 ++++++------
 drivers/media/usb/cx231xx/cx231xx-i2c.c    | 12 ++++-------
 drivers/of/unittest.c                      |  7 +++----
 include/linux/i2c-mux.h                    | 15 +++++++-------
 15 files changed, 122 insertions(+), 134 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index c2163f6b51d5..6c5cb9f7649b 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -32,13 +32,8 @@ struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
 	struct i2c_mux_core *muxc;
-
 	struct device *mux_dev;
-	void *mux_priv;
 	u32 chan_id;
-
-	int (*select)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
-	int (*deselect)(struct i2c_adapter *, void *mux_priv, u32 chan_id);
 };
 
 static int i2c_mux_master_xfer(struct i2c_adapter *adap,
@@ -51,11 +46,11 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 
 	/* Switch to the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
+	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
 		ret = __i2c_transfer(parent, msgs, num);
-	if (priv->deselect)
-		priv->deselect(parent, priv->mux_priv, priv->chan_id);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
 
 	return ret;
 }
@@ -72,12 +67,12 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 
 	/* Select the right mux port and perform the transfer. */
 
-	ret = priv->select(parent, priv->mux_priv, priv->chan_id);
+	ret = muxc->select(muxc, priv->chan_id);
 	if (ret >= 0)
 		ret = parent->algo->smbus_xfer(parent, addr, flags,
 					read_write, command, size, data);
-	if (priv->deselect)
-		priv->deselect(parent, priv->mux_priv, priv->chan_id);
+	if (muxc->deselect)
+		muxc->deselect(muxc, priv->chan_id);
 
 	return ret;
 }
@@ -113,18 +108,15 @@ struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
 		return NULL;
 	if (sizeof_priv)
 		muxc->priv = muxc + 1;
+	muxc->dev = dev;
 	return muxc;
 }
 EXPORT_SYMBOL_GPL(i2c_mux_alloc);
 
 struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
-				struct device *mux_dev,
-				void *mux_priv, u32 force_nr, u32 chan_id,
-				unsigned int class,
-				int (*select) (struct i2c_adapter *,
-					       void *, u32),
-				int (*deselect) (struct i2c_adapter *,
-						 void *, u32))
+					struct device *mux_dev,
+					u32 force_nr, u32 chan_id,
+					unsigned int class)
 {
 	struct i2c_adapter *parent = muxc->parent;
 	struct i2c_mux_priv *priv;
@@ -138,10 +130,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 	/* Set up private adapter data */
 	priv->muxc = muxc;
 	priv->mux_dev = mux_dev;
-	priv->mux_priv = mux_priv;
 	priv->chan_id = chan_id;
-	priv->select = select;
-	priv->deselect = deselect;
 
 	/* Need to do algo dynamically because we don't know ahead
 	 * of time what sort of physical adapter we'll be dealing with.
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 6e27ea4fb25a..1e1a479d5b61 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -58,9 +58,9 @@ struct i2c_arbitrator_data {
  *
  * Use the GPIO-based signalling protocol; return -EBUSY if we fail.
  */
-static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_arbitrator_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	const struct i2c_arbitrator_data *arb = data;
+	const struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
 	unsigned long stop_retry, stop_time;
 
 	/* Start a round of trying to claim the bus */
@@ -92,7 +92,7 @@ static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
 	/* Give up, release our claim */
 	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
 	udelay(arb->slew_delay_us);
-	dev_err(&adap->dev, "Could not claim bus, timeout\n");
+	dev_err(muxc->dev, "Could not claim bus, timeout\n");
 	return -EBUSY;
 }
 
@@ -101,10 +101,9 @@ static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
  *
  * Release the I2C bus using the GPIO-based signalling protocol.
  */
-static int i2c_arbitrator_deselect(struct i2c_adapter *adap, void *data,
-				   u32 chan)
+static int i2c_arbitrator_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	const struct i2c_arbitrator_data *arb = data;
+	const struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
 
 	/* Release the bus and wait for the other master to notice */
 	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
@@ -140,6 +139,9 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	arb = i2c_mux_priv(muxc);
 
 	platform_set_drvdata(pdev, muxc);
+
+	muxc->select = i2c_arbitrator_select,
+	muxc->deselect = i2c_arbitrator_deselect;
 	/* Request GPIOs */
 	ret = of_get_named_gpio_flags(np, "our-claim-gpio", 0, &gpio_flags);
 	if (!gpio_is_valid(ret)) {
@@ -203,9 +205,7 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	}
 
 	/* Actually add the mux adapter */
-	arb->child = i2c_add_mux_adapter(muxc, dev, arb, 0, 0, 0,
-					 i2c_arbitrator_select,
-					 i2c_arbitrator_deselect);
+	arb->child = i2c_add_mux_adapter(muxc, dev, 0, 0, 0);
 	if (!arb->child) {
 		dev_err(dev, "Failed to add adapter\n");
 		ret = -ENODEV;
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index ee43dd76a4d7..d89a0fbca4bc 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -32,18 +32,18 @@ static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
 					val & (1 << i));
 }
 
-static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_mux_gpio_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct gpiomux *mux = data;
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 
 	i2c_mux_gpio_set(mux, chan);
 
 	return 0;
 }
 
-static int i2c_mux_gpio_deselect(struct i2c_adapter *adap, void *data, u32 chan)
+static int i2c_mux_gpio_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct gpiomux *mux = data;
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 
 	i2c_mux_gpio_set(mux, mux->data.idle);
 
@@ -138,7 +138,6 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	struct i2c_mux_core *muxc;
 	struct gpiomux *mux;
 	struct i2c_adapter *parent;
-	int (*deselect) (struct i2c_adapter *, void *, u32);
 	unsigned initial_state, gpio_base;
 	int i, ret;
 
@@ -180,6 +179,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 
 	muxc->parent = parent;
+	muxc->select = i2c_mux_gpio_select;
 	mux->gpio_base = gpio_base;
 
 	mux->adap = devm_kzalloc(&pdev->dev,
@@ -193,10 +193,10 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 
 	if (mux->data.idle != I2C_MUX_GPIO_NO_IDLE) {
 		initial_state = mux->data.idle;
-		deselect = i2c_mux_gpio_deselect;
+		muxc->deselect = i2c_mux_gpio_deselect;
 	} else {
 		initial_state = mux->data.values[0];
-		deselect = NULL;
+		muxc->deselect = NULL;
 	}
 
 	for (i = 0; i < mux->data.n_gpios; i++) {
@@ -222,9 +222,8 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, mux, nr,
-						   mux->data.values[i], class,
-						   i2c_mux_gpio_select, deselect);
+		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
+						   mux->data.values[i], class);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
index 78648d1263bc..ae42039459d0 100644
--- a/drivers/i2c/muxes/i2c-mux-pca9541.c
+++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
@@ -73,6 +73,7 @@
 #define SELECT_DELAY_LONG	1000
 
 struct pca9541 {
+	struct i2c_client *client;
 	struct i2c_adapter *mux_adap;
 	unsigned long select_timeout;
 	unsigned long arb_timeout;
@@ -286,9 +287,10 @@ static int pca9541_arbitrate(struct i2c_client *client)
 	return 0;
 }
 
-static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
+static int pca9541_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
+	struct pca9541 *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
 	int ret;
 	unsigned long timeout = jiffies + ARB2_TIMEOUT;
 		/* give up after this time */
@@ -310,9 +312,11 @@ static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
 	return -ETIMEDOUT;
 }
 
-static int pca9541_release_chan(struct i2c_adapter *adap,
-				void *client, u32 chan)
+static int pca9541_release_chan(struct i2c_mux_core *muxc, u32 chan)
 {
+	struct pca9541 *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
+
 	pca9541_release_bus(client);
 	return 0;
 }
@@ -339,7 +343,10 @@ static int pca9541_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, muxc);
 
+	data->client = client;
 	muxc->parent = adap;
+	muxc->select = pca9541_select_chan;
+	muxc->deselect = pca9541_release_chan;
 
 	/*
 	 * I2C accesses are unprotected here.
@@ -354,10 +361,7 @@ static int pca9541_probe(struct i2c_client *client,
 	force = 0;
 	if (pdata)
 		force = pdata->modes[0].adap_id;
-	data->mux_adap = i2c_add_mux_adapter(muxc, &client->dev, client,
-					     force, 0, 0,
-					     pca9541_select_chan,
-					     pca9541_release_chan);
+	data->mux_adap = i2c_add_mux_adapter(muxc, &client->dev, force, 0, 0);
 
 	if (data->mux_adap == NULL) {
 		dev_err(&client->dev, "failed to register master selector\n");
diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index acc2f87fe321..9e9d708fb2cb 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -63,6 +63,8 @@ struct pca954x {
 	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
 
 	u8 last_chan;		/* last register value */
+	u8 deselect;
+	struct i2c_client *client;
 };
 
 struct chip_desc {
@@ -146,10 +148,10 @@ static int pca954x_reg_write(struct i2c_adapter *adap,
 	return ret;
 }
 
-static int pca954x_select_chan(struct i2c_adapter *adap,
-			       void *client, u32 chan)
+static int pca954x_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
 	const struct chip_desc *chip = &chips[data->type];
 	u8 regval;
 	int ret = 0;
@@ -162,21 +164,24 @@ static int pca954x_select_chan(struct i2c_adapter *adap,
 
 	/* Only select the channel if its different from the last channel */
 	if (data->last_chan != regval) {
-		ret = pca954x_reg_write(adap, client, regval);
+		ret = pca954x_reg_write(muxc->parent, client, regval);
 		data->last_chan = regval;
 	}
 
 	return ret;
 }
 
-static int pca954x_deselect_mux(struct i2c_adapter *adap,
-				void *client, u32 chan)
+static int pca954x_deselect_mux(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
+	struct i2c_client *client = data->client;
+
+	if (!(data->deselect & (1 << chan)))
+		return 0;
 
 	/* Deselect active channel */
 	data->last_chan = 0;
-	return pca954x_reg_write(adap, client, data->last_chan);
+	return pca954x_reg_write(muxc->parent, client, data->last_chan);
 }
 
 /*
@@ -204,6 +209,7 @@ static int pca954x_probe(struct i2c_client *client,
 	data = i2c_mux_priv(muxc);
 
 	i2c_set_clientdata(client, muxc);
+	data->client = client;
 
 	/* Get the mux out of reset if a reset GPIO is specified. */
 	gpio = devm_gpiod_get_optional(&client->dev, "reset", GPIOD_OUT_LOW);
@@ -220,6 +226,8 @@ static int pca954x_probe(struct i2c_client *client,
 	}
 
 	muxc->parent = adap;
+	muxc->select = pca954x_select_chan;
+	muxc->deselect = pca954x_deselect_mux;
 	data->type = id->driver_data;
 	data->last_chan = 0;		   /* force the first selection */
 
@@ -241,13 +249,13 @@ static int pca954x_probe(struct i2c_client *client,
 				/* discard unconfigured channels */
 				break;
 			idle_disconnect_pd = pdata->modes[num].deselect_on_exit;
+			data->deselect |= (idle_disconnect_pd
+					   || idle_disconnect_dt) << num;
 		}
 
 		data->virt_adaps[num] =
-			i2c_add_mux_adapter(muxc, &client->dev, client,
-				force, num, class, pca954x_select_chan,
-				(idle_disconnect_pd || idle_disconnect_dt)
-					? pca954x_deselect_mux : NULL);
+			i2c_add_mux_adapter(muxc, &client->dev,
+					    force, num, class);
 
 		if (data->virt_adaps[num] == NULL) {
 			ret = -ENODEV;
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 810f75f114a7..e87c8f77037a 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -34,18 +34,16 @@ struct i2c_mux_pinctrl {
 	struct i2c_adapter **busses;
 };
 
-static int i2c_mux_pinctrl_select(struct i2c_adapter *adap, void *data,
-				  u32 chan)
+static int i2c_mux_pinctrl_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_mux_pinctrl *mux = data;
+	struct i2c_mux_pinctrl *mux = i2c_mux_priv(muxc);
 
 	return pinctrl_select_state(mux->pinctrl, mux->states[chan]);
 }
 
-static int i2c_mux_pinctrl_deselect(struct i2c_adapter *adap, void *data,
-				    u32 chan)
+static int i2c_mux_pinctrl_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_mux_pinctrl *mux = data;
+	struct i2c_mux_pinctrl *mux = i2c_mux_priv(muxc);
 
 	return pinctrl_select_state(mux->pinctrl, mux->state_idle);
 }
@@ -132,7 +130,6 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 {
 	struct i2c_mux_core *muxc;
 	struct i2c_mux_pinctrl *mux;
-	int (*deselect)(struct i2c_adapter *, void *, u32);
 	int i, ret;
 
 	muxc = i2c_mux_alloc(&pdev->dev, sizeof(*mux));
@@ -203,10 +200,11 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 			goto err;
 		}
 
-		deselect = i2c_mux_pinctrl_deselect;
+		muxc->deselect = i2c_mux_pinctrl_deselect;
 	} else {
-		deselect = NULL;
+		muxc->deselect = NULL;
 	}
+	muxc->select = i2c_mux_pinctrl_select;
 
 	muxc->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
 	if (!muxc->parent) {
@@ -221,9 +219,7 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 				(mux->pdata->base_bus_num + i) : 0;
 
 		mux->busses[i] = i2c_add_mux_adapter(muxc, &pdev->dev,
-						     mux, bus, i, 0,
-						     i2c_mux_pinctrl_select,
-						     deselect);
+						     bus, i, 0);
 		if (!mux->busses[i]) {
 			ret = -ENODEV;
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 8bde4cfac512..3b01e7809a66 100644
--- a/drivers/i2c/muxes/i2c-mux-reg.c
+++ b/drivers/i2c/muxes/i2c-mux-reg.c
@@ -63,18 +63,16 @@ static int i2c_mux_reg_set(const struct regmux *mux, unsigned int chan_id)
 	return 0;
 }
 
-static int i2c_mux_reg_select(struct i2c_adapter *adap, void *data,
-			      unsigned int chan)
+static int i2c_mux_reg_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct regmux *mux = data;
+	struct regmux *mux = i2c_mux_priv(muxc);
 
 	return i2c_mux_reg_set(mux, chan);
 }
 
-static int i2c_mux_reg_deselect(struct i2c_adapter *adap, void *data,
-				unsigned int chan)
+static int i2c_mux_reg_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct regmux *mux = data;
+	struct regmux *mux = i2c_mux_priv(muxc);
 
 	if (mux->data.idle_in_use)
 		return i2c_mux_reg_set(mux, mux->data.idle);
@@ -173,7 +171,6 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 	struct regmux *mux;
 	struct i2c_adapter *parent;
 	struct resource *res;
-	int (*deselect)(struct i2c_adapter *, void *, u32);
 	unsigned int class;
 	int i, ret, nr;
 
@@ -225,19 +222,19 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	muxc->select = i2c_mux_reg_select;
 	if (mux->data.idle_in_use)
-		deselect = i2c_mux_reg_deselect;
+		muxc->deselect = i2c_mux_reg_deselect;
 	else
-		deselect = NULL;
+		muxc->deselect = NULL;
 
 	for (i = 0; i < mux->data.n_values; i++) {
 		nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, mux,
+		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev,
 						   nr, mux->data.values[i],
-						   class, i2c_mux_reg_select,
-						   deselect);
+						   class);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 3aab0d7a1bdc..0a47396bc5be 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -109,10 +109,9 @@ static int inv_mpu6050_write_reg_unlocked(struct inv_mpu6050_state *st,
 	return 0;
 }
 
-static int inv_mpu6050_select_bypass(struct i2c_adapter *adap, void *mux_priv,
-				     u32 chan_id)
+static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct iio_dev *indio_dev = mux_priv;
+	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 	int ret = 0;
 
@@ -138,10 +137,9 @@ write_error:
 	return ret;
 }
 
-static int inv_mpu6050_deselect_bypass(struct i2c_adapter *adap,
-				       void *mux_priv, u32 chan_id)
+static int inv_mpu6050_deselect_bypass(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct iio_dev *indio_dev = mux_priv;
+	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
 	struct inv_mpu6050_state *st = iio_priv(indio_dev);
 
 	mutex_lock(&indio_dev->mlock);
@@ -849,13 +847,12 @@ static int inv_mpu_probe(struct i2c_client *client,
 	}
 	st->muxc->priv = indio_dev;
 	st->muxc->parent = client->adapter;
+	st->muxc->select = inv_mpu6050_select_bypass;
+	st->muxc->deselect = inv_mpu6050_deselect_bypass;
 
 	st->mux_adapter = i2c_add_mux_adapter(st->muxc,
 					      &client->dev,
-					      indio_dev,
-					      0, 0, 0,
-					      inv_mpu6050_select_bypass,
-					      inv_mpu6050_deselect_bypass);
+					      0, 0, 0);
 	if (!st->mux_adapter) {
 		result = -ENODEV;
 		goto out_unreg_device;
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index a0006aec6937..c9f8296ea421 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1251,9 +1251,9 @@ static void m88ds3103_release(struct dvb_frontend *fe)
 	i2c_unregister_device(client);
 }
 
-static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int m88ds3103_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct m88ds3103_dev *dev = mux_priv;
+	struct m88ds3103_dev *dev = i2c_mux_priv(muxc);
 	struct i2c_client *client = dev->client;
 	int ret;
 	struct i2c_msg msg = {
@@ -1473,11 +1473,11 @@ static int m88ds3103_probe(struct i2c_client *client,
 	}
 	dev->muxc->priv = dev;
 	dev->muxc->parent = client->adapter;
+	dev->muxc->select = m88ds3103_select;
 
 	/* create mux i2c adapter for tuner */
 	dev->i2c_adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
-					       dev, 0, 0, 0, m88ds3103_select,
-					       NULL);
+					       0, 0, 0);
 	if (dev->i2c_adapter == NULL) {
 		ret = -ENOMEM;
 		goto err_kfree;
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index ebf28b49cab2..d6330e8d5fa4 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -677,9 +677,9 @@ err:
  * adapter lock is already taken by tuner driver.
  * Gate is closed automatically after single I2C transfer.
  */
-static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
+static int rtl2830_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
@@ -871,10 +871,10 @@ static int rtl2830_probe(struct i2c_client *client,
 	}
 	dev->muxc->priv = client;
 	dev->muxc->parent = client->adapter;
+	dev->muxc->select = rtl2830_select;
 
 	/* create muxed i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
-			client, 0, 0, 0, rtl2830_select, NULL);
+	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err_regmap_exit;
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 38402ad3ecdd..c8fd990fdae8 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -866,9 +866,9 @@ err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 }
 
-static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
+static int rtl2832_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct rtl2832_dev *dev = mux_priv;
+	struct rtl2832_dev *dev = i2c_mux_priv(muxc);
 	struct i2c_client *client = dev->client;
 	int ret;
 
@@ -889,10 +889,9 @@ err:
 	return ret;
 }
 
-static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
-			    u32 chan_id)
+static int rtl2832_deselect(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct rtl2832_dev *dev = mux_priv;
+	struct rtl2832_dev *dev = i2c_mux_priv(muxc);
 
 	schedule_delayed_work(&dev->i2c_gate_work, usecs_to_jiffies(100));
 	return 0;
@@ -1268,10 +1267,12 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 	dev->muxc->priv = dev;
 	dev->muxc->parent = i2c;
+	dev->muxc->select = rtl2832_select;
+	dev->muxc->deselect = rtl2832_deselect;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	dev->i2c_adapter_tuner = i2c_add_mux_adapter(dev->muxc, &i2c->dev, dev,
-			0, 0, 0, rtl2832_select, rtl2832_deselect);
+	dev->i2c_adapter_tuner = i2c_add_mux_adapter(dev->muxc, &i2c->dev,
+						     0, 0, 0);
 	if (dev->i2c_adapter_tuner == NULL) {
 		ret = -ENODEV;
 		goto err_regmap_exit;
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index a52756bf9834..5b1872b1bbf4 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -615,9 +615,9 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
  * We must use unlocked I2C I/O because I2C adapter lock is already taken
  * by the caller (usually tuner driver).
  */
-static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int si2168_select(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -635,9 +635,9 @@ err:
 	return ret;
 }
 
-static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int si2168_deselect(struct i2c_mux_core *muxc, u32 chan)
 {
-	struct i2c_client *client = mux_priv;
+	struct i2c_client *client = i2c_mux_priv(muxc);
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -715,10 +715,11 @@ static int si2168_probe(struct i2c_client *client,
 	}
 	dev->muxc->priv = client;
 	dev->muxc->parent = client->adapter;
+	dev->muxc->select = si2168_select;
+	dev->muxc->deselect = si2168_deselect;
 
 	/* create mux i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
-			client, 0, 0, 0, si2168_select, si2168_deselect);
+	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err_kfree;
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 09c30e753ca5..51760bfc7cbc 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -557,10 +557,9 @@ int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
  * cx231xx_i2c_mux_select()
  * switch i2c master number 1 between port1 and port3
  */
-static int cx231xx_i2c_mux_select(struct i2c_adapter *adap,
-			void *mux_priv, u32 chan_id)
+static int cx231xx_i2c_mux_select(struct i2c_mux_core *muxc, u32 chan_id)
 {
-	struct cx231xx *dev = mux_priv;
+	struct cx231xx *dev = i2c_mux_priv(muxc);
 
 	return cx231xx_enable_i2c_port_3(dev, chan_id);
 }
@@ -572,6 +571,7 @@ int cx231xx_i2c_mux_create(struct cx231xx *dev)
 		return -ENOMEM;
 	dev->muxc->priv = dev;
 	dev->muxc->parent = &dev->i2c_bus[1].i2c_adap;
+	dev->muxc->select = cx231xx_i2c_mux_select;
 	return 0;
 }
 
@@ -582,13 +582,9 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 
 	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(dev->muxc,
 				mux_dev,
-				dev /* mux_priv */,
 				0,
 				mux_no /* chan_id */,
-				0 /* class */,
-				&cx231xx_i2c_mux_select,
-				NULL);
-
+				0 /* class */);
 	if (!dev->i2c_mux_adap[mux_no])
 		dev_warn(dev->dev,
 			 "i2c mux %d register FAILED\n", mux_no);
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 6bfc2f9a5a24..a4abd9b588b9 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1682,8 +1682,7 @@ struct unittest_i2c_mux_data {
 	struct i2c_adapter *adap[];
 };
 
-static int unittest_i2c_mux_select_chan(struct i2c_adapter *adap,
-			       void *client, u32 chan)
+static int unittest_i2c_mux_select_chan(struct i2c_mux_core *muxc, u32 chan)
 {
 	return 0;
 }
@@ -1725,11 +1724,11 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 	if (!muxc)
 		return -ENOMEM;
 	muxc->parent = adap;
+	muxc->select = unittest_i2c_mux_select_chan;
 	stm = i2c_mux_priv(muxc);
 	stm->nchans = nchans;
 	for (i = 0; i < nchans; i++) {
-		stm->adap[i] = i2c_add_mux_adapter(muxc, dev, client,
-				0, i, 0, unittest_i2c_mux_select_chan, NULL);
+		stm->adap[i] = i2c_add_mux_adapter(muxc, dev, 0, i, 0);
 		if (!stm->adap[i]) {
 			dev_err(dev, "Failed to register mux #%d\n", i);
 			for (i--; i >= 0; i--)
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index 3ca1783b86ac..5cd6e1e664e0 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -29,7 +29,12 @@
 
 struct i2c_mux_core {
 	struct i2c_adapter *parent;
+	struct device *dev;
+
 	void *priv;
+
+	int (*select)(struct i2c_mux_core *, u32 chan_id);
+	int (*deselect)(struct i2c_mux_core *, u32 chan_id);
 };
 
 struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv);
@@ -46,13 +51,9 @@ static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
  * mux control.
  */
 struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
-				struct device *mux_dev,
-				void *mux_priv, u32 force_nr, u32 chan_id,
-				unsigned int class,
-				int (*select) (struct i2c_adapter *,
-					       void *mux_dev, u32 chan_id),
-				int (*deselect) (struct i2c_adapter *,
-						 void *mux_dev, u32 chan_id));
+					struct device *mux_dev,
+					u32 force_nr, u32 chan_id,
+					unsigned int class);
 
 void i2c_del_mux_adapter(struct i2c_adapter *adap);
 
-- 
2.1.4

