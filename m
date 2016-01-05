Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:47166 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbcAEP6N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 10:58:13 -0500
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
Subject: [PATCH v2 5/8] i2c-mux: pinctrl: get rid of the driver private struct device pointer
Date: Tue,  5 Jan 2016 16:57:15 +0100
Message-Id: <1452009438-27347-6-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

There is a copy of the device pointer in the mux core.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/i2c/muxes/i2c-mux-pinctrl.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 0dc912898813..38129850cbe4 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -26,7 +26,6 @@
 #include <linux/of.h>
 
 struct i2c_mux_pinctrl {
-	struct device *dev;
 	struct i2c_mux_pinctrl_platform_data *pdata;
 	struct pinctrl *pinctrl;
 	struct pinctrl_state **states;
@@ -51,6 +50,7 @@ static int i2c_mux_pinctrl_deselect(struct i2c_mux_core *muxc, u32 chan)
 static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 				struct platform_device *pdev)
 {
+	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	int num_names, i, ret;
 	struct device_node *adapter_np;
@@ -60,15 +60,12 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
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
@@ -76,23 +73,21 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
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
@@ -103,13 +98,13 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 
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
@@ -139,8 +134,6 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 	mux = i2c_mux_priv(muxc);
 	platform_set_drvdata(pdev, muxc);
 
-	mux->dev = &pdev->dev;
-
 	mux->pdata = dev_get_platdata(&pdev->dev);
 	if (!mux->pdata) {
 		ret = i2c_mux_pinctrl_parse_dt(mux, pdev);
-- 
2.1.4

