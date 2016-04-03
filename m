Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:42668 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcDCIyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:54:04 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 03/24] i2c: i2c-mux-pinctrl: convert to use an explicit i2c mux core
Date: Sun,  3 Apr 2016 10:52:33 +0200
Message-Id: <1459673574-11440-4-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

Allocate an explicit i2c mux core to handle parent and child adapters
etc. Update the select/deselect ops to be in terms of the i2c mux core
instead of the child adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c | 86 +++++++++++++------------------------
 1 file changed, 30 insertions(+), 56 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index b5a982ba8898..bbfabf4f52be 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -26,27 +26,22 @@
 #include <linux/of.h>
 
 struct i2c_mux_pinctrl {
-	struct device *dev;
 	struct i2c_mux_pinctrl_platform_data *pdata;
 	struct pinctrl *pinctrl;
 	struct pinctrl_state **states;
 	struct pinctrl_state *state_idle;
-	struct i2c_adapter *parent;
-	struct i2c_adapter **busses;
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
@@ -55,6 +50,7 @@ static int i2c_mux_pinctrl_deselect(struct i2c_adapter *adap, void *data,
 static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 				struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	int num_names, i, ret;
 	struct device_node *adapter_np;
@@ -64,15 +60,12 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 		return 0;
 
 	mux->pdata = devm_kzalloc(&pdev->dev, sizeof(*mux->pdata), GFP_KERNEL);
-	if (!mux->pdata) {
-		dev_err(mux->dev,
-			"Cannot allocate i2c_mux_pinctrl_platform_data\n");
+	if (!mux->pdata)
 		return -ENOMEM;
-	}
 
 	num_names = of_property_count_strings(np, "pinctrl-names");
 	if (num_names < 0) {
-		dev_err(mux->dev, "Cannot parse pinctrl-names: %d\n",
+		dev_err(muxc->dev, "Cannot parse pinctrl-names: %d\n",
 			num_names);
 		return num_names;
 	}
@@ -80,23 +73,21 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 	mux->pdata->pinctrl_states = devm_kzalloc(&pdev->dev,
 		sizeof(*mux->pdata->pinctrl_states) * num_names,
 		GFP_KERNEL);
-	if (!mux->pdata->pinctrl_states) {
-		dev_err(mux->dev, "Cannot allocate pinctrl_states\n");
+	if (!mux->pdata->pinctrl_states)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < num_names; i++) {
 		ret = of_property_read_string_index(np, "pinctrl-names", i,
 			&mux->pdata->pinctrl_states[mux->pdata->bus_count]);
 		if (ret < 0) {
-			dev_err(mux->dev, "Cannot parse pinctrl-names: %d\n",
+			dev_err(muxc->dev, "Cannot parse pinctrl-names: %d\n",
 				ret);
 			return ret;
 		}
 		if (!strcmp(mux->pdata->pinctrl_states[mux->pdata->bus_count],
 			    "idle")) {
 			if (i != num_names - 1) {
-				dev_err(mux->dev, "idle state must be last\n");
+				dev_err(muxc->dev, "idle state must be last\n");
 				return -EINVAL;
 			}
 			mux->pdata->pinctrl_state_idle = "idle";
@@ -107,13 +98,13 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 
 	adapter_np = of_parse_phandle(np, "i2c-parent", 0);
 	if (!adapter_np) {
-		dev_err(mux->dev, "Cannot parse i2c-parent\n");
+		dev_err(muxc->dev, "Cannot parse i2c-parent\n");
 		return -ENODEV;
 	}
 	adapter = of_find_i2c_adapter_by_node(adapter_np);
 	of_node_put(adapter_np);
 	if (!adapter) {
-		dev_err(mux->dev, "Cannot find parent bus\n");
+		dev_err(muxc->dev, "Cannot find parent bus\n");
 		return -EPROBE_DEFER;
 	}
 	mux->pdata->parent_bus_num = i2c_adapter_id(adapter);
@@ -131,19 +122,18 @@ static inline int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 
 static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc;
 	struct i2c_mux_pinctrl *mux;
-	int (*deselect)(struct i2c_adapter *, void *, u32);
 	int i, ret;
 
-	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_mux_pinctrl\n");
+	muxc = i2c_mux_alloc(NULL, &pdev->dev, sizeof(*mux), 0,
+			     i2c_mux_pinctrl_select, NULL);
+	if (!muxc) {
 		ret = -ENOMEM;
 		goto err;
 	}
-	platform_set_drvdata(pdev, mux);
-
-	mux->dev = &pdev->dev;
+	mux = i2c_mux_priv(muxc);
+	platform_set_drvdata(pdev, muxc);
 
 	mux->pdata = dev_get_platdata(&pdev->dev);
 	if (!mux->pdata) {
@@ -166,14 +156,9 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	mux->busses = devm_kzalloc(&pdev->dev,
-				   sizeof(*mux->busses) * mux->pdata->bus_count,
-				   GFP_KERNEL);
-	if (!mux->busses) {
-		dev_err(&pdev->dev, "Cannot allocate busses\n");
-		ret = -ENOMEM;
+	ret = i2c_mux_reserve_adapters(muxc, mux->pdata->bus_count);
+	if (ret)
 		goto err;
-	}
 
 	mux->pinctrl = devm_pinctrl_get(&pdev->dev);
 	if (IS_ERR(mux->pinctrl)) {
@@ -203,13 +188,11 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 			goto err;
 		}
 
-		deselect = i2c_mux_pinctrl_deselect;
-	} else {
-		deselect = NULL;
+		muxc->deselect = i2c_mux_pinctrl_deselect;
 	}
 
-	mux->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
-	if (!mux->parent) {
+	muxc->parent = i2c_get_adapter(mux->pdata->parent_bus_num);
+	if (!muxc->parent) {
 		dev_err(&pdev->dev, "Parent adapter (%d) not found\n",
 			mux->pdata->parent_bus_num);
 		ret = -EPROBE_DEFER;
@@ -220,12 +203,8 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 		u32 bus = mux->pdata->base_bus_num ?
 				(mux->pdata->base_bus_num + i) : 0;
 
-		mux->busses[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev,
-						     mux, bus, i, 0,
-						     i2c_mux_pinctrl_select,
-						     deselect);
-		if (!mux->busses[i]) {
-			ret = -ENODEV;
+		ret = i2c_mux_add_adapter(muxc, bus, i, 0);
+		if (ret) {
 			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
 			goto err_del_adapter;
 		}
@@ -234,23 +213,18 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 
 err_del_adapter:
-	for (; i > 0; i--)
-		i2c_del_mux_adapter(mux->busses[i - 1]);
-	i2c_put_adapter(mux->parent);
+	i2c_mux_del_adapters(muxc);
+	i2c_put_adapter(muxc->parent);
 err:
 	return ret;
 }
 
 static int i2c_mux_pinctrl_remove(struct platform_device *pdev)
 {
-	struct i2c_mux_pinctrl *mux = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < mux->pdata->bus_count; i++)
-		i2c_del_mux_adapter(mux->busses[i]);
-
-	i2c_put_adapter(mux->parent);
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 
+	i2c_mux_del_adapters(muxc);
+	i2c_put_adapter(muxc->parent);
 	return 0;
 }
 
-- 
2.1.4

