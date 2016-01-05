Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:58670 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbcAEP5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 10:57:41 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Peter Rosin <peda@lysator.liu.se>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 1/8] i2c-mux: add common core data for every mux instance
Date: Tue,  5 Jan 2016 16:57:11 +0100
Message-Id: <1452009438-27347-2-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

The initial core mux structure starts off small with only the parent
adapter pointer, which all muxes have, and a priv pointer for mux
driver private data.

Add i2c_mux_alloc function to unify the creation of a mux.

Where appropriate, pass around the mux core structure instead of the
parent adapter or the driver private data.

Remove the parent adapter pointer from the driver private data for all
mux drivers.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c                        | 28 +++++++++++++++++-----
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c   | 24 +++++++++----------
 drivers/i2c/muxes/i2c-mux-gpio.c             | 20 ++++++++--------
 drivers/i2c/muxes/i2c-mux-pca9541.c          | 35 ++++++++++++++--------------
 drivers/i2c/muxes/i2c-mux-pca954x.c          | 19 ++++++++++-----
 drivers/i2c/muxes/i2c-mux-pinctrl.c          | 23 +++++++++---------
 drivers/i2c/muxes/i2c-mux-reg.c              | 23 ++++++++++--------
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   | 10 +++++++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |  1 +
 drivers/media/dvb-frontends/m88ds3103.c      | 10 +++++++-
 drivers/media/dvb-frontends/m88ds3103_priv.h |  1 +
 drivers/media/dvb-frontends/rtl2830.c        | 10 +++++++-
 drivers/media/dvb-frontends/rtl2830_priv.h   |  1 +
 drivers/media/dvb-frontends/rtl2832.c        | 10 +++++++-
 drivers/media/dvb-frontends/rtl2832_priv.h   |  1 +
 drivers/media/dvb-frontends/si2168.c         | 10 +++++++-
 drivers/media/dvb-frontends/si2168_priv.h    |  1 +
 drivers/media/usb/cx231xx/cx231xx-core.c     |  3 +++
 drivers/media/usb/cx231xx/cx231xx-i2c.c      | 13 +++++++++--
 drivers/media/usb/cx231xx/cx231xx.h          |  2 ++
 drivers/of/unittest.c                        | 16 +++++++------
 include/linux/i2c-mux.h                      | 14 ++++++++++-
 22 files changed, 187 insertions(+), 88 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 00fc5b1c7b66..c2163f6b51d5 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -31,8 +31,8 @@
 struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
+	struct i2c_mux_core *muxc;
 
-	struct i2c_adapter *parent;
 	struct device *mux_dev;
 	void *mux_priv;
 	u32 chan_id;
@@ -45,7 +45,8 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
 			       struct i2c_msg msgs[], int num)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
 	int ret;
 
 	/* Switch to the right mux port and perform the transfer. */
@@ -65,7 +66,8 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 			      int size, union i2c_smbus_data *data)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_mux_core *muxc = priv->muxc;
+	struct i2c_adapter *parent = muxc->parent;
 	int ret;
 
 	/* Select the right mux port and perform the transfer. */
@@ -84,7 +86,7 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
 static u32 i2c_mux_functionality(struct i2c_adapter *adap)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	struct i2c_adapter *parent = priv->parent;
+	struct i2c_adapter *parent = priv->muxc->parent;
 
 	return parent->algo->functionality(parent);
 }
@@ -102,7 +104,20 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
 	return class;
 }
 
-struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
+struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
+{
+	struct i2c_mux_core *muxc;
+
+	muxc = devm_kzalloc(dev, sizeof(*muxc) + sizeof_priv, GFP_KERNEL);
+	if (!muxc)
+		return NULL;
+	if (sizeof_priv)
+		muxc->priv = muxc + 1;
+	return muxc;
+}
+EXPORT_SYMBOL_GPL(i2c_mux_alloc);
+
+struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 				struct device *mux_dev,
 				void *mux_priv, u32 force_nr, u32 chan_id,
 				unsigned int class,
@@ -111,6 +126,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 				int (*deselect) (struct i2c_adapter *,
 						 void *, u32))
 {
+	struct i2c_adapter *parent = muxc->parent;
 	struct i2c_mux_priv *priv;
 	char symlink_name[20];
 	int ret;
@@ -120,7 +136,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 		return NULL;
 
 	/* Set up private adapter data */
-	priv->parent = parent;
+	priv->muxc = muxc;
 	priv->mux_dev = mux_dev;
 	priv->mux_priv = mux_priv;
 	priv->chan_id = chan_id;
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 402e3a6c671a..6e27ea4fb25a 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -42,7 +42,6 @@
  */
 
 struct i2c_arbitrator_data {
-	struct i2c_adapter *parent;
 	struct i2c_adapter *child;
 	int our_gpio;
 	int our_gpio_release;
@@ -119,6 +118,7 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct device_node *parent_np;
+	struct i2c_mux_core *muxc;
 	struct i2c_arbitrator_data *arb;
 	enum of_gpio_flags gpio_flags;
 	unsigned long out_init;
@@ -134,13 +134,12 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	arb = devm_kzalloc(dev, sizeof(*arb), GFP_KERNEL);
-	if (!arb) {
-		dev_err(dev, "Cannot allocate i2c_arbitrator_data\n");
+	muxc = i2c_mux_alloc(dev, sizeof(*arb));
+	if (!muxc)
 		return -ENOMEM;
-	}
-	platform_set_drvdata(pdev, arb);
+	arb = i2c_mux_priv(muxc);
 
+	platform_set_drvdata(pdev, muxc);
 	/* Request GPIOs */
 	ret = of_get_named_gpio_flags(np, "our-claim-gpio", 0, &gpio_flags);
 	if (!gpio_is_valid(ret)) {
@@ -196,21 +195,21 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 		dev_err(dev, "Cannot parse i2c-parent\n");
 		return -EINVAL;
 	}
-	arb->parent = of_get_i2c_adapter_by_node(parent_np);
+	muxc->parent = of_find_i2c_adapter_by_node(parent_np);
 	of_node_put(parent_np);
-	if (!arb->parent) {
+	if (!muxc->parent) {
 		dev_err(dev, "Cannot find parent bus\n");
 		return -EPROBE_DEFER;
 	}
 
 	/* Actually add the mux adapter */
-	arb->child = i2c_add_mux_adapter(arb->parent, dev, arb, 0, 0, 0,
+	arb->child = i2c_add_mux_adapter(muxc, dev, arb, 0, 0, 0,
 					 i2c_arbitrator_select,
 					 i2c_arbitrator_deselect);
 	if (!arb->child) {
 		dev_err(dev, "Failed to add adapter\n");
 		ret = -ENODEV;
-		i2c_put_adapter(arb->parent);
+		i2c_put_adapter(muxc->parent);
 	}
 
 	return ret;
@@ -218,10 +217,11 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 
 static int i2c_arbitrator_remove(struct platform_device *pdev)
 {
-	struct i2c_arbitrator_data *arb = platform_get_drvdata(pdev);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
+	struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
 
 	i2c_del_mux_adapter(arb->child);
-	i2c_put_adapter(arb->parent);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index b8e11c16d98c..ee43dd76a4d7 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -18,7 +18,6 @@
 #include <linux/of_gpio.h>
 
 struct gpiomux {
-	struct i2c_adapter *parent;
 	struct i2c_adapter **adap; /* child busses */
 	struct i2c_mux_gpio_platform_data data;
 	unsigned gpio_base;
@@ -136,19 +135,19 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 
 static int i2c_mux_gpio_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct gpiomux *mux;
 	struct i2c_adapter *parent;
 	int (*deselect) (struct i2c_adapter *, void *, u32);
 	unsigned initial_state, gpio_base;
 	int i, ret;
 
-	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate gpiomux structure");
+	muxc = i2c_mux_alloc(&pdev->dev, sizeof(*mux));
+	if (!muxc)
 		return -ENOMEM;
-	}
+	mux = i2c_mux_priv(muxc);
 
-	platform_set_drvdata(pdev, mux);
+	platform_set_drvdata(pdev, muxc);
 
 	if (!dev_get_platdata(&pdev->dev)) {
 		ret = i2c_mux_gpio_probe_dt(mux, pdev);
@@ -180,7 +179,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	if (!parent)
 		return -EPROBE_DEFER;
 
-	mux->parent = parent;
+	muxc->parent = parent;
 	mux->gpio_base = gpio_base;
 
 	mux->adap = devm_kzalloc(&pdev->dev,
@@ -223,7 +222,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
+		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, mux, nr,
 						   mux->data.values[i], class,
 						   i2c_mux_gpio_select, deselect);
 		if (!mux->adap[i]) {
@@ -253,7 +252,8 @@ alloc_failed:
 
 static int i2c_mux_gpio_remove(struct platform_device *pdev)
 {
-	struct gpiomux *mux = platform_get_drvdata(pdev);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
+	struct gpiomux *mux = i2c_mux_priv(muxc);
 	int i;
 
 	for (i = 0; i < mux->data.n_values; i++)
@@ -262,7 +262,7 @@ static int i2c_mux_gpio_remove(struct platform_device *pdev)
 	for (i = 0; i < mux->data.n_gpios; i++)
 		gpio_free(mux->gpio_base + mux->data.gpios[i]);
 
-	i2c_put_adapter(mux->parent);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
index d0ba424adebc..47ae2259d1ca 100644
--- a/drivers/i2c/muxes/i2c-mux-pca9541.c
+++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
@@ -73,6 +73,7 @@
 #define SELECT_DELAY_LONG	1000
 
 struct pca9541 {
+	struct i2c_client *client;
 	struct i2c_adapter *mux_adap;
 	unsigned long select_timeout;
 	unsigned long arb_timeout;
@@ -217,7 +218,8 @@ static const u8 pca9541_control[16] = {
  */
 static int pca9541_arbitrate(struct i2c_client *client)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca9541 *data = i2c_mux_priv(muxc);
 	int reg;
 
 	reg = pca9541_reg_read(client, PCA9541_CONTROL);
@@ -324,20 +326,22 @@ static int pca9541_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adap = client->adapter;
 	struct pca954x_platform_data *pdata = dev_get_platdata(&client->dev);
+	struct i2c_mux_core *muxc;
 	struct pca9541 *data;
 	int force;
-	int ret = -ENODEV;
 
 	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
-		goto err;
+		return -ENODEV;
 
-	data = kzalloc(sizeof(struct pca9541), GFP_KERNEL);
-	if (!data) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	muxc = i2c_mux_alloc(&client->dev, sizeof(*data));
+	if (!muxc)
+		return -ENOMEM;
+	data = i2c_mux_priv(muxc);
+
+	i2c_set_clientdata(client, muxc);
 
-	i2c_set_clientdata(client, data);
+	data->client = client;
+	muxc->parent = adap;
 
 	/*
 	 * I2C accesses are unprotected here.
@@ -352,34 +356,29 @@ static int pca9541_probe(struct i2c_client *client,
 	force = 0;
 	if (pdata)
 		force = pdata->modes[0].adap_id;
-	data->mux_adap = i2c_add_mux_adapter(adap, &client->dev, client,
+	data->mux_adap = i2c_add_mux_adapter(muxc, &client->dev, client,
 					     force, 0, 0,
 					     pca9541_select_chan,
 					     pca9541_release_chan);
 
 	if (data->mux_adap == NULL) {
 		dev_err(&client->dev, "failed to register master selector\n");
-		goto exit_free;
+		return -ENODEV;
 	}
 
 	dev_info(&client->dev, "registered master selector for I2C %s\n",
 		 client->name);
 
 	return 0;
-
-exit_free:
-	kfree(data);
-err:
-	return ret;
 }
 
 static int pca9541_remove(struct i2c_client *client)
 {
-	struct pca9541 *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca9541 *data = i2c_mux_priv(muxc);
 
 	i2c_del_mux_adapter(data->mux_adap);
 
-	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index acfcef3d4068..a4df831fae9d 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -63,6 +63,7 @@ struct pca954x {
 	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
 
 	u8 last_chan;		/* last register value */
+	struct i2c_client *client;
 };
 
 struct chip_desc {
@@ -191,17 +192,20 @@ static int pca954x_probe(struct i2c_client *client,
 	bool idle_disconnect_dt;
 	struct gpio_desc *gpio;
 	int num, force, class;
+	struct i2c_mux_core *muxc;
 	struct pca954x *data;
 	int ret;
 
 	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE))
 		return -ENODEV;
 
-	data = devm_kzalloc(&client->dev, sizeof(struct pca954x), GFP_KERNEL);
-	if (!data)
+	muxc = i2c_mux_alloc(&client->dev, sizeof(*data));
+	if (!muxc)
 		return -ENOMEM;
+	data = i2c_mux_priv(muxc);
 
-	i2c_set_clientdata(client, data);
+	i2c_set_clientdata(client, muxc);
+	data->client = client;
 
 	/* Get the mux out of reset if a reset GPIO is specified. */
 	gpio = devm_gpiod_get_optional(&client->dev, "reset", GPIOD_OUT_LOW);
@@ -217,6 +221,7 @@ static int pca954x_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
+	muxc->parent = adap;
 	data->type = id->driver_data;
 	data->last_chan = 0;		   /* force the first selection */
 
@@ -241,7 +246,7 @@ static int pca954x_probe(struct i2c_client *client,
 		}
 
 		data->virt_adaps[num] =
-			i2c_add_mux_adapter(adap, &client->dev, client,
+			i2c_add_mux_adapter(muxc, &client->dev, client,
 				force, num, class, pca954x_select_chan,
 				(idle_disconnect_pd || idle_disconnect_dt)
 					? pca954x_deselect_mux : NULL);
@@ -270,7 +275,8 @@ virt_reg_failed:
 
 static int pca954x_remove(struct i2c_client *client)
 {
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
 	const struct chip_desc *chip = &chips[data->type];
 	int i;
 
@@ -287,7 +293,8 @@ static int pca954x_remove(struct i2c_client *client)
 static int pca954x_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct pca954x *data = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct pca954x *data = i2c_mux_priv(muxc);
 
 	data->last_chan = 0;
 	return i2c_smbus_write_byte(client, 0);
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index b5a982ba8898..810f75f114a7 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -31,7 +31,6 @@ struct i2c_mux_pinctrl {
 	struct pinctrl *pinctrl;
 	struct pinctrl_state **states;
 	struct pinctrl_state *state_idle;
-	struct i2c_adapter *parent;
 	struct i2c_adapter **busses;
 };
 
@@ -131,17 +130,18 @@ static inline int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 
 static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct i2c_mux_pinctrl *mux;
 	int (*deselect)(struct i2c_adapter *, void *, u32);
 	int i, ret;
 
-	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_mux_pinctrl\n");
+	muxc = i2c_mux_alloc(&pdev->dev, sizeof(*mux));
+	if (!muxc) {
 		ret = -ENOMEM;
 		goto err;
 	}
-	platform_set_drvdata(pdev, mux);
+	mux = i2c_mux_priv(muxc);
+	platform_set_drvdata(pdev, muxc);
 
 	mux->dev = &pdev->dev;
 
@@ -208,8 +208,8 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		deselect = NULL;
 	}
 
-	mux->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
-	if (!mux->parent) {
+	muxc->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
+	if (!muxc->parent) {
 		dev_err(&pdev->dev, "Parent adapter (%d) not found\n",
 			mux->pdata->parent_bus_num);
 		ret = -EPROBE_DEFER;
@@ -220,7 +220,7 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		u32 bus = mux->pdata->base_bus_num ?
 				(mux->pdata->base_bus_num + i) : 0;
 
-		mux->busses[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev,
+		mux->busses[i] = i2c_add_mux_adapter(muxc, &pdev->dev,
 						     mux, bus, i, 0,
 						     i2c_mux_pinctrl_select,
 						     deselect);
@@ -236,20 +236,21 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 err_del_adapter:
 	for (; i > 0; i--)
 		i2c_del_mux_adapter(mux->busses[i - 1]);
-	i2c_put_adapter(mux->parent);
+	i2c_put_adapter(muxc->parent);
 err:
 	return ret;
 }
 
 static int i2c_mux_pinctrl_remove(struct platform_device *pdev)
 {
-	struct i2c_mux_pinctrl *mux = platform_get_drvdata(pdev);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
+	struct i2c_mux_pinctrl *mux = i2c_mux_priv(muxc);
 	int i;
 
 	for (i = 0; i < mux->pdata->bus_count; i++)
 		i2c_del_mux_adapter(mux->busses[i]);
 
-	i2c_put_adapter(mux->parent);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 5fbd5bd0878f..8bde4cfac512 100644
--- a/drivers/i2c/muxes/i2c-mux-reg.c
+++ b/drivers/i2c/muxes/i2c-mux-reg.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 
 struct regmux {
-	struct i2c_adapter *parent;
 	struct i2c_adapter **adap; /* child busses */
 	struct i2c_mux_reg_platform_data data;
 };
@@ -87,6 +86,7 @@ static int i2c_mux_reg_deselect(struct i2c_adapter *adap, void *data,
 static int i2c_mux_reg_probe_dt(struct regmux *mux,
 					struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *adapter_np, *child;
 	struct i2c_adapter *adapter;
@@ -107,7 +107,7 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 	if (!adapter)
 		return -EPROBE_DEFER;
 
-	mux->parent = adapter;
+	muxc->parent = adapter;
 	mux->data.parent = i2c_adapter_id(adapter);
 	put_device(&adapter->dev);
 
@@ -169,6 +169,7 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 
 static int i2c_mux_reg_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct regmux *mux;
 	struct i2c_adapter *parent;
 	struct resource *res;
@@ -176,11 +177,12 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 	unsigned int class;
 	int i, ret, nr;
 
-	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux)
+	muxc = i2c_mux_alloc(&pdev->dev, sizeof(*mux));
+	if (!muxc)
 		return -ENOMEM;
+	mux = i2c_mux_priv(muxc);
 
-	platform_set_drvdata(pdev, mux);
+	platform_set_drvdata(pdev, muxc);
 
 	if (dev_get_platdata(&pdev->dev)) {
 		memcpy(&mux->data, dev_get_platdata(&pdev->dev),
@@ -190,7 +192,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		if (!parent)
 			return -EPROBE_DEFER;
 
-		mux->parent = parent;
+		muxc->parent = parent;
 	} else {
 		ret = i2c_mux_reg_probe_dt(mux, pdev);
 		if (ret < 0) {
@@ -232,7 +234,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev, mux,
+		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, mux,
 						   nr, mux->data.values[i],
 						   class, i2c_mux_reg_select,
 						   deselect);
@@ -244,7 +246,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 	}
 
 	dev_dbg(&pdev->dev, "%d port mux on %s adapter\n",
-		 mux->data.n_values, mux->parent->name);
+		 mux->data.n_values, muxc->parent->name);
 
 	return 0;
 
@@ -257,13 +259,14 @@ add_adapter_failed:
 
 static int i2c_mux_reg_remove(struct platform_device *pdev)
 {
-	struct regmux *mux = platform_get_drvdata(pdev);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
+	struct regmux *mux = i2c_mux_priv(muxc);
 	int i;
 
 	for (i = 0; i < mux->data.n_values; i++)
 		i2c_del_mux_adapter(mux->adap[i]);
 
-	i2c_put_adapter(mux->parent);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index f0e06093b5e8..3aab0d7a1bdc 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -842,7 +842,15 @@ static int inv_mpu_probe(struct i2c_client *client,
 		goto out_remove_trigger;
 	}
 
-	st->mux_adapter = i2c_add_mux_adapter(client->adapter,
+	st->muxc = i2c_mux_alloc(&client->dev, 0);
+	if (!st->muxc) {
+		result = -ENOMEM;
+		goto out_unreg_device;
+	}
+	st->muxc->priv = indio_dev;
+	st->muxc->parent = client->adapter;
+
+	st->mux_adapter = i2c_add_mux_adapter(st->muxc,
 					      &client->dev,
 					      indio_dev,
 					      0, 0, 0,
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index db0a4a2758ab..d4929db4b40e 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -120,6 +120,7 @@ struct inv_mpu6050_state {
 	enum   inv_devices chip_type;
 	spinlock_t time_stamp_lock;
 	struct i2c_client *client;
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *mux_adapter;
 	struct i2c_client *mux_client;
 	unsigned int powerup_count;
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index feeeb70d841e..a0006aec6937 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1466,8 +1466,16 @@ static int m88ds3103_probe(struct i2c_client *client,
 	if (ret)
 		goto err_kfree;
 
+	dev->muxc  = i2c_mux_alloc(&client->dev, 0);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+	dev->muxc->priv = dev;
+	dev->muxc->parent = client->adapter;
+
 	/* create mux i2c adapter for tuner */
-	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+	dev->i2c_adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
 					       dev, 0, 0, 0, m88ds3103_select,
 					       NULL);
 	if (dev->i2c_adapter == NULL) {
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index eee8c22c51ec..52d66c566ac1 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -42,6 +42,7 @@ struct m88ds3103_dev {
 	enum fe_status fe_status;
 	u32 dvbv3_ber; /* for old DVBv3 API read_ber */
 	bool warm; /* FW running */
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *i2c_adapter;
 	/* auto detect chip id to do different config */
 	u8 chip_id;
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index b792f305cf15..ebf28b49cab2 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -864,8 +864,16 @@ static int rtl2830_probe(struct i2c_client *client,
 	if (ret)
 		goto err_regmap_exit;
 
+	dev->muxc = i2c_mux_alloc(&client->dev, 0);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
+		goto err_regmap_exit;
+	}
+	dev->muxc->priv = client;
+	dev->muxc->parent = client->adapter;
+
 	/* create muxed i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
 			client, 0, 0, 0, rtl2830_select, NULL);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index cf793f39a09b..2169c8d9c99c 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -29,6 +29,7 @@ struct rtl2830_dev {
 	struct rtl2830_platform_data *pdata;
 	struct i2c_client *client;
 	struct regmap *regmap;
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *adapter;
 	struct dvb_frontend fe;
 	bool sleeping;
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 78b87b260d74..38402ad3ecdd 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1261,8 +1261,16 @@ static int rtl2832_probe(struct i2c_client *client,
 	if (ret)
 		goto err_regmap_exit;
 
+	dev->muxc = i2c_mux_alloc(&client->dev, 0);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
+		goto err_regmap_exit;
+	}
+	dev->muxc->priv = dev;
+	dev->muxc->parent = i2c;
+
 	/* create muxed i2c adapter for demod tuner bus */
-	dev->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, dev,
+	dev->i2c_adapter_tuner = i2c_add_mux_adapter(dev->muxc, &i2c->dev, dev,
 			0, 0, 0, rtl2832_select, rtl2832_deselect);
 	if (dev->i2c_adapter_tuner == NULL) {
 		ret = -ENODEV;
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 5dcd3a41d23f..2d252bd5b8b1 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -36,6 +36,7 @@ struct rtl2832_dev {
 	struct mutex regmap_mutex;
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
 	struct delayed_work stat_work;
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 821a8f481507..a52756bf9834 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -708,8 +708,16 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	dev->muxc = i2c_mux_alloc(&client->dev, 0);
+	if (!dev->muxc) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+	dev->muxc->priv = client;
+	dev->muxc->parent = client->adapter;
+
 	/* create mux i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
 			client, 0, 0, 0, si2168_select, si2168_deselect);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index c07e6fe2cb10..53efb9d562da 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -29,6 +29,7 @@
 
 /* state struct */
 struct si2168_dev {
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *adapter;
 	struct dvb_frontend fe;
 	enum fe_delivery_system delivery_system;
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index a2fd49b6be83..d805e192e4ca 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1291,6 +1291,9 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	cx231xx_i2c_register(&dev->i2c_bus[1]);
 	cx231xx_i2c_register(&dev->i2c_bus[2]);
 
+	errCode = cx231xx_i2c_mux_create(dev);
+	if (errCode < 0)
+		return errCode;
 	cx231xx_i2c_mux_register(dev, 0);
 	cx231xx_i2c_mux_register(dev, 1);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index a29c345b027d..09c30e753ca5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -565,13 +565,22 @@ static int cx231xx_i2c_mux_select(struct i2c_adapter *adap,
 	return cx231xx_enable_i2c_port_3(dev, chan_id);
 }
 
+int cx231xx_i2c_mux_create(struct cx231xx *dev)
+{
+	dev->muxc = i2c_mux_alloc(dev->dev, 0);
+	if (!dev->muxc)
+		return -ENOMEM;
+	dev->muxc->priv = dev;
+	dev->muxc->parent = &dev->i2c_bus[1].i2c_adap;
+	return 0;
+}
+
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 {
-	struct i2c_adapter *i2c_parent = &dev->i2c_bus[1].i2c_adap;
 	/* what is the correct mux_dev? */
 	struct device *mux_dev = dev->dev;
 
-	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(i2c_parent,
+	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(dev->muxc,
 				mux_dev,
 				dev /* mux_priv */,
 				0,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 54790fbe8fdc..72f8188e0b01 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -625,6 +625,7 @@ struct cx231xx {
 
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
+	struct i2c_mux_core *muxc;
 	struct i2c_adapter *i2c_mux_adap[2];
 
 	unsigned int xc_fw_load_done:1;
@@ -759,6 +760,7 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+int cx231xx_i2c_mux_create(struct cx231xx *dev);
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no);
 void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no);
 struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index e16ea5717b7f..6bfc2f9a5a24 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1695,6 +1695,7 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct i2c_adapter *adap = to_i2c_adapter(dev->parent);
 	struct device_node *np = client->dev.of_node, *child;
+	struct i2c_mux_core *muxc;
 	struct unittest_i2c_mux_data *stm;
 	u32 reg, max_reg;
 
@@ -1720,14 +1721,14 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 	}
 
 	size = offsetof(struct unittest_i2c_mux_data, adap[nchans]);
-	stm = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (!stm) {
-		dev_err(dev, "Out of memory\n");
+	muxc = i2c_mux_alloc(dev, size);
+	if (!muxc)
 		return -ENOMEM;
-	}
+	muxc->parent = adap;
+	stm = i2c_mux_priv(muxc);
 	stm->nchans = nchans;
 	for (i = 0; i < nchans; i++) {
-		stm->adap[i] = i2c_add_mux_adapter(adap, dev, client,
+		stm->adap[i] = i2c_add_mux_adapter(muxc, dev, client,
 				0, i, 0, unittest_i2c_mux_select_chan, NULL);
 		if (!stm->adap[i]) {
 			dev_err(dev, "Failed to register mux #%d\n", i);
@@ -1737,7 +1738,7 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 		}
 	}
 
-	i2c_set_clientdata(client, stm);
+	i2c_set_clientdata(client, muxc);
 
 	return 0;
 };
@@ -1746,7 +1747,8 @@ static int unittest_i2c_mux_remove(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct device_node *np = client->dev.of_node;
-	struct unittest_i2c_mux_data *stm = i2c_get_clientdata(client);
+	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
+	struct unittest_i2c_mux_data *stm = i2c_mux_priv(muxc);
 	int i;
 
 	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index b5f9a007a3ab..3ca1783b86ac 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -27,13 +27,25 @@
 
 #ifdef __KERNEL__
 
+struct i2c_mux_core {
+	struct i2c_adapter *parent;
+	void *priv;
+};
+
+struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv);
+
+static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
+{
+	return muxc->priv;
+}
+
 /*
  * Called to create a i2c bus on a multiplexed bus segment.
  * The mux_dev and chan_id parameters are passed to the select
  * and deselect callback functions to perform hardware-specific
  * mux control.
  */
-struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
+struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 				struct device *mux_dev,
 				void *mux_priv, u32 force_nr, u32 chan_id,
 				unsigned int class,
-- 
2.1.4

