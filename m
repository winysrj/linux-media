Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:47398 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577AbcCCW3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 17:29:09 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v4 07/18] i2c: i2c-mux-reg: convert to use an explicit i2c mux core
Date: Thu,  3 Mar 2016 23:27:19 +0100
Message-Id: <1457044050-15230-8-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-reg.c | 63 ++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 5fbd5bd0878f..3ac9a2dab111 100644
--- a/drivers/i2c/muxes/i2c-mux-reg.c
+++ b/drivers/i2c/muxes/i2c-mux-reg.c
@@ -21,8 +21,6 @@
 #include <linux/slab.h>
 
 struct regmux {
-	struct i2c_adapter *parent;
-	struct i2c_adapter **adap; /* child busses */
 	struct i2c_mux_reg_platform_data data;
 };
 
@@ -64,18 +62,16 @@ static int i2c_mux_reg_set(const struct regmux *mux, unsigned int chan_id)
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
@@ -87,6 +83,7 @@ static int i2c_mux_reg_deselect(struct i2c_adapter *adap, void *data,
 static int i2c_mux_reg_probe_dt(struct regmux *mux,
 					struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *adapter_np, *child;
 	struct i2c_adapter *adapter;
@@ -107,7 +104,7 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 	if (!adapter)
 		return -EPROBE_DEFER;
 
-	mux->parent = adapter;
+	muxc->parent = adapter;
 	mux->data.parent = i2c_adapter_id(adapter);
 	put_device(&adapter->dev);
 
@@ -169,18 +166,20 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 
 static int i2c_mux_reg_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct regmux *mux;
 	struct i2c_adapter *parent;
 	struct resource *res;
-	int (*deselect)(struct i2c_adapter *, void *, u32);
 	unsigned int class;
 	int i, ret, nr;
 
-	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux)
+	muxc = i2c_mux_alloc(NULL, &pdev->dev, sizeof(*mux), 0,
+			     i2c_mux_reg_select, NULL);
+	if (!muxc)
 		return -ENOMEM;
+	mux = i2c_mux_priv(muxc);
 
-	platform_set_drvdata(pdev, mux);
+	platform_set_drvdata(pdev, muxc);
 
 	if (dev_get_platdata(&pdev->dev)) {
 		memcpy(&mux->data, dev_get_platdata(&pdev->dev),
@@ -190,7 +189,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		if (!parent)
 			return -EPROBE_DEFER;
 
-		mux->parent = parent;
+		muxc->parent = parent;
 	} else {
 		ret = i2c_mux_reg_probe_dt(mux, pdev);
 		if (ret < 0) {
@@ -215,55 +214,41 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	mux->adap = devm_kzalloc(&pdev->dev,
-				 sizeof(*mux->adap) * mux->data.n_values,
-				 GFP_KERNEL);
-	if (!mux->adap) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
-		return -ENOMEM;
-	}
+	ret = i2c_mux_reserve_adapters(muxc, mux->data.n_values);
+	if (ret)
+		return ret;
 
 	if (mux->data.idle_in_use)
-		deselect = i2c_mux_reg_deselect;
-	else
-		deselect = NULL;
+		muxc->deselect = i2c_mux_reg_deselect;
 
 	for (i = 0; i < mux->data.n_values; i++) {
 		nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
 		class = mux->data.classes ? mux->data.classes[i] : 0;
 
-		mux->adap[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev, mux,
-						   nr, mux->data.values[i],
-						   class, i2c_mux_reg_select,
-						   deselect);
-		if (!mux->adap[i]) {
-			ret = -ENODEV;
+		ret = i2c_mux_add_adapter(muxc, nr, mux->data.values[i], class);
+		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto add_adapter_failed;
 		}
 	}
 
 	dev_dbg(&pdev->dev, "%d port mux on %s adapter\n",
-		 mux->data.n_values, mux->parent->name);
+		 mux->data.n_values, muxc->parent->name);
 
 	return 0;
 
 add_adapter_failed:
-	for (; i > 0; i--)
-		i2c_del_mux_adapter(mux->adap[i - 1]);
+	i2c_mux_del_adapters(muxc);
 
 	return ret;
 }
 
 static int i2c_mux_reg_remove(struct platform_device *pdev)
 {
-	struct regmux *mux = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < mux->data.n_values; i++)
-		i2c_del_mux_adapter(mux->adap[i]);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 
-	i2c_put_adapter(mux->parent);
+	i2c_mux_del_adapters(muxc);
+	i2c_put_adapter(muxc->parent);
 
 	return 0;
 }
-- 
2.1.4

