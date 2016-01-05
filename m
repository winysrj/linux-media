Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:47549 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcAEP6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 10:58:05 -0500
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
Subject: [PATCH v2 4/8] i2c-mux: remove the mux dev pointer from the mux per channel data
Date: Tue,  5 Jan 2016 16:57:14 +0100
Message-Id: <1452009438-27347-5-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

The dev pointer is readily available in the mux core struct, no point in
keeping multiple copies around.

The patch also fixes a bug in rtl2832, which attached its mux slave
adapter to the device owning the mux parent adapter instead of
attaching it to its own device.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/i2c-mux.c                      | 24 ++++++++++++------------
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c |  2 +-
 drivers/i2c/muxes/i2c-mux-gpio.c           |  3 +--
 drivers/i2c/muxes/i2c-mux-pca9541.c        |  2 +-
 drivers/i2c/muxes/i2c-mux-pca954x.c        |  3 +--
 drivers/i2c/muxes/i2c-mux-pinctrl.c        |  3 +--
 drivers/i2c/muxes/i2c-mux-reg.c            |  3 +--
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  2 +-
 drivers/media/dvb-frontends/m88ds3103.c    |  2 +-
 drivers/media/dvb-frontends/rtl2830.c      |  2 +-
 drivers/media/dvb-frontends/rtl2832.c      |  2 +-
 drivers/media/dvb-frontends/si2168.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c    |  3 ---
 drivers/of/unittest.c                      |  2 +-
 include/linux/i2c-mux.h                    |  1 -
 15 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 7ba0308537a8..5c1088079231 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -32,7 +32,6 @@ struct i2c_mux_priv {
 	struct i2c_adapter adap;
 	struct i2c_algorithm algo;
 	struct i2c_mux_core *muxc;
-	struct device *mux_dev;
 	u32 chan_id;
 };
 
@@ -137,7 +136,6 @@ struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
 EXPORT_SYMBOL_GPL(i2c_mux_alloc);
 
 int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
-			struct device *mux_dev,
 			u32 force_nr, u32 chan_id,
 			unsigned int class)
 {
@@ -162,7 +160,6 @@ int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 
 	/* Set up private adapter data */
 	priv->muxc = muxc;
-	priv->mux_dev = mux_dev;
 	priv->chan_id = chan_id;
 
 	/* Need to do algo dynamically because we don't know ahead
@@ -197,11 +194,11 @@ int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 	 * Try to populate the mux adapter's of_node, expands to
 	 * nothing if !CONFIG_OF.
 	 */
-	if (mux_dev->of_node) {
+	if (muxc->dev->of_node) {
 		struct device_node *child;
 		u32 reg;
 
-		for_each_child_of_node(mux_dev->of_node, child) {
+		for_each_child_of_node(muxc->dev->of_node, child) {
 			ret = of_property_read_u32(child, "reg", &reg);
 			if (ret)
 				continue;
@@ -215,8 +212,9 @@ int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 	/*
 	 * Associate the mux channel with an ACPI node.
 	 */
-	if (has_acpi_companion(mux_dev))
-		acpi_preset_companion(&priv->adap.dev, ACPI_COMPANION(mux_dev),
+	if (has_acpi_companion(muxc->dev))
+		acpi_preset_companion(&priv->adap.dev,
+				      ACPI_COMPANION(muxc->dev),
 				      chan_id);
 
 	if (force_nr) {
@@ -233,12 +231,14 @@ int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
 		return ret;
 	}
 
-	WARN(sysfs_create_link(&priv->adap.dev.kobj, &mux_dev->kobj, "mux_device"),
-			       "can't create symlink to mux device\n");
+	WARN(sysfs_create_link(&priv->adap.dev.kobj, &muxc->dev->kobj,
+			       "mux_device"),
+	     "can't create symlink to mux device\n");
 
 	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", chan_id);
-	WARN(sysfs_create_link(&mux_dev->kobj, &priv->adap.dev.kobj, symlink_name),
-			       "can't create symlink for channel %u\n", chan_id);
+	WARN(sysfs_create_link(&muxc->dev->kobj, &priv->adap.dev.kobj,
+			       symlink_name),
+	     "can't create symlink for channel %u\n", chan_id);
 	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
 		 i2c_adapter_id(&priv->adap));
 
@@ -259,7 +259,7 @@ void i2c_del_mux_adapters(struct i2c_mux_core *muxc)
 
 		snprintf(symlink_name, sizeof(symlink_name),
 			 "channel-%u", priv->chan_id);
-		sysfs_remove_link(&priv->mux_dev->kobj, symlink_name);
+		sysfs_remove_link(&muxc->dev->kobj, symlink_name);
 
 		sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
 		i2c_del_adapter(adap);
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index e0558e8a0e74..c2bc18c7921f 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -204,7 +204,7 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	}
 
 	/* Actually add the mux adapter */
-	ret = i2c_add_mux_adapter(muxc, dev, 0, 0, 0);
+	ret = i2c_add_mux_adapter(muxc, 0, 0, 0);
 	if (ret) {
 		dev_err(dev, "Failed to add adapter\n");
 		i2c_put_adapter(muxc->parent);
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 6bd41ace81d4..e800c4597fa4 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -216,8 +216,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		ret = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
-					  mux->data.values[i], class);
+		ret = i2c_add_mux_adapter(muxc, nr, mux->data.values[i], class);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto add_adapter_failed;
diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
index 80de0a0977a5..0e18d25334b5 100644
--- a/drivers/i2c/muxes/i2c-mux-pca9541.c
+++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
@@ -361,7 +361,7 @@ static int pca9541_probe(struct i2c_client *client,
 	force = 0;
 	if (pdata)
 		force = pdata->modes[0].adap_id;
-	ret = i2c_add_mux_adapter(muxc, &client->dev, force, 0, 0);
+	ret = i2c_add_mux_adapter(muxc, force, 0, 0);
 	if (ret) {
 		dev_err(&client->dev, "failed to register master selector\n");
 		return ret;
diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index 640670b604f5..2d15325b6282 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -256,8 +256,7 @@ static int pca954x_probe(struct i2c_client *client,
 					   || idle_disconnect_dt) << num;
 		}
 
-		ret = i2c_add_mux_adapter(muxc, &client->dev,
-					  force, num, class);
+		ret = i2c_add_mux_adapter(muxc, force, num, class);
 
 		if (ret) {
 			dev_err(&client->dev,
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 3bbb3fb1d693..0dc912898813 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -212,8 +212,7 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		u32 bus = mux->pdata->base_bus_num ?
 				(mux->pdata->base_bus_num + i) : 0;
 
-		ret = i2c_add_mux_adapter(muxc, &pdev->dev,
-					  bus, i, 0);
+		ret = i2c_add_mux_adapter(muxc, bus, i, 0);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto err_del_adapter;
diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 5c004ff5b6ad..3c919e49260c 100644
--- a/drivers/i2c/muxes/i2c-mux-reg.c
+++ b/drivers/i2c/muxes/i2c-mux-reg.c
@@ -227,8 +227,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		ret = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
-					  mux->data.values[i], class);
+		ret = i2c_add_mux_adapter(muxc, nr, mux->data.values[i], class);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto add_adapter_failed;
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index a9a163c1c22c..5cd3c48682e6 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -850,7 +850,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 	st->muxc->select = inv_mpu6050_select_bypass;
 	st->muxc->deselect = inv_mpu6050_deselect_bypass;
 
-	result = i2c_add_mux_adapter(st->muxc, &client->dev, 0, 0, 0);
+	result = i2c_add_mux_adapter(st->muxc, 0, 0, 0);
 	if (result)
 		goto out_unreg_device;
 
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index deab5cdba01f..45ad3ef82b4f 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1476,7 +1476,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 	dev->muxc->select = m88ds3103_select;
 
 	/* create mux i2c adapter for tuner */
-	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
+	ret = i2c_add_mux_adapter(dev->muxc, 0, 0, 0);
 	if (ret)
 		goto err_kfree;
 
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 9864740722dd..1da8d2e22983 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -874,7 +874,7 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev->muxc->select = rtl2830_select;
 
 	/* create muxed i2c adapter for tuner */
-	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
+	ret = i2c_add_mux_adapter(dev->muxc, 0, 0, 0);
 	if (ret)
 		goto err_regmap_exit;
 
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 99d8dbf66fd7..c586150623f7 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1271,7 +1271,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->muxc->deselect = rtl2832_deselect;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	ret = i2c_add_mux_adapter(dev->muxc, &i2c->dev, 0, 0, 0);
+	ret = i2c_add_mux_adapter(dev->muxc, 0, 0, 0);
 	if (ret)
 		goto err_regmap_exit;
 
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 06aa496cc42c..ae217b5e6618 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -719,7 +719,7 @@ static int si2168_probe(struct i2c_client *client,
 	dev->muxc->deselect = si2168_deselect;
 
 	/* create mux i2c adapter for tuner */
-	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
+	ret = i2c_add_mux_adapter(dev->muxc, 0, 0, 0);
 	if (ret)
 		goto err_kfree;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 2b5adb056827..bfa63cf69235 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -577,12 +577,9 @@ int cx231xx_i2c_mux_create(struct cx231xx *dev)
 
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
 {
-	/* what is the correct mux_dev? */
-	struct device *mux_dev = dev->dev;
 	int rc;
 
 	rc = i2c_add_mux_adapter(dev->muxc,
-				 mux_dev,
 				 0,
 				 mux_no /* chan_id */,
 				 0 /* class */);
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 77ccc54cfdc9..46897ed4e396 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1722,7 +1722,7 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 	for (i = 0; i < nchans; i++) {
-		ret = i2c_add_mux_adapter(muxc, dev, 0, i, 0);
+		ret = i2c_add_mux_adapter(muxc, 0, i, 0);
 		if (ret) {
 			dev_err(dev, "Failed to register mux #%d\n", i);
 			i2c_del_mux_adapters(muxc);
diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
index bfcdcc46f2a6..d88e0a3b6768 100644
--- a/include/linux/i2c-mux.h
+++ b/include/linux/i2c-mux.h
@@ -56,7 +56,6 @@ int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters);
  * mux control.
  */
 int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
-			struct device *mux_dev,
 			u32 force_nr, u32 chan_id,
 			unsigned int class);
 
-- 
2.1.4

