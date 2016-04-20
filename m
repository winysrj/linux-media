Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0111.outbound.protection.outlook.com ([157.55.234.111]:29312
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbcDTPep (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 11:34:45 -0400
From: Peter Rosin <peda@axentia.se>
To: <linux-kernel@vger.kernel.org>
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v7 07/24] i2c: i2c-mux-reg: convert to use an explicit i2c mux core
Date: Wed, 20 Apr 2016 17:17:47 +0200
Message-ID: <1461165484-2314-8-git-send-email-peda@axentia.se>
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-reg.c | 69 +++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 44 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
index 5fbd5bd0878f..6773cadf7c9f 100644
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
@@ -85,7 +81,7 @@ static int i2c_mux_reg_deselect(struct i2c_adapter *adap, void *data,
 
 #ifdef CONFIG_OF
 static int i2c_mux_reg_probe_dt(struct regmux *mux,
-					struct platform_device *pdev)
+				struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *adapter_np, *child;
@@ -107,7 +103,6 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 	if (!adapter)
 		return -EPROBE_DEFER;
 
-	mux->parent = adapter;
 	mux->data.parent = i2c_adapter_id(adapter);
 	put_device(&adapter->dev);
 
@@ -161,7 +156,7 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 }
 #else
 static int i2c_mux_reg_probe_dt(struct regmux *mux,
-					struct platform_device *pdev)
+				struct platform_device *pdev)
 {
 	return 0;
 }
@@ -169,10 +164,10 @@ static int i2c_mux_reg_probe_dt(struct regmux *mux,
 
 static int i2c_mux_reg_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct regmux *mux;
 	struct i2c_adapter *parent;
 	struct resource *res;
-	int (*deselect)(struct i2c_adapter *, void *, u32);
 	unsigned int class;
 	int i, ret, nr;
 
@@ -180,17 +175,9 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 	if (!mux)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, mux);
-
 	if (dev_get_platdata(&pdev->dev)) {
 		memcpy(&mux->data, dev_get_platdata(&pdev->dev),
 			sizeof(mux->data));
-
-		parent = i2c_get_adapter(mux->data.parent);
-		if (!parent)
-			return -EPROBE_DEFER;
-
-		mux->parent = parent;
 	} else {
 		ret = i2c_mux_reg_probe_dt(mux, pdev);
 		if (ret < 0) {
@@ -199,6 +186,10 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		}
 	}
 
+	parent = i2c_get_adapter(mux->data.parent);
+	if (!parent)
+		return -EPROBE_DEFER;
+
 	if (!mux->data.reg) {
 		dev_info(&pdev->dev,
 			"Register not set, using platform resource\n");
@@ -215,55 +206,45 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	mux->adap = devm_kzalloc(&pdev->dev,
-				 sizeof(*mux->adap) * mux->data.n_values,
-				 GFP_KERNEL);
-	if (!mux->adap) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
+	muxc = i2c_mux_alloc(parent, &pdev->dev, mux->data.n_values, 0, 0,
+			     i2c_mux_reg_select, NULL);
+	if (!muxc)
 		return -ENOMEM;
-	}
+	muxc->priv = mux;
+
+	platform_set_drvdata(pdev, muxc);
 
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

