Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36223 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbeEGP5p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:57:45 -0400
Received: by mail-wm0-f65.google.com with SMTP id n10-v6so16266744wmc.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 08:57:44 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 4/4] media: ov2680: add regulators to supply control
Date: Mon,  7 May 2018 16:56:55 +0100
Message-Id: <20180507155655.1555-5-rui.silva@linaro.org>
In-Reply-To: <20180507155655.1555-1-rui.silva@linaro.org>
References: <20180507155655.1555-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the code to control the regulators for the analogue and digital power
supplies.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/media/i2c/ov2680.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 8962b397211a..07bb475c970c 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/gpio/consumer.h>
+#include <linux/regulator/consumer.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -65,6 +66,14 @@ struct reg_value {
 	u8 val;
 };
 
+static const char * const ov2680_supply_name[] = {
+	"DOVDD",
+	"DVDD",
+	"AVDD",
+};
+
+#define OV2680_NUM_SUPPLIES ARRAY_SIZE(ov2680_supply_name)
+
 struct ov2680_mode_info {
 	const char *name;
 	enum ov2680_mode_id id;
@@ -97,6 +106,7 @@ struct ov2680_dev {
 	struct media_pad		pad;
 	struct clk			*xvclk;
 	u32				xvclk_freq;
+	struct regulator_bulk_data	supplies[OV2680_NUM_SUPPLIES];
 
 	struct gpio_desc		*reset_gpio;
 	struct mutex			lock; /* protect members */
@@ -522,6 +532,7 @@ static int ov2680_power_off(struct ov2680_dev *sensor)
 
 	clk_disable_unprepare(sensor->xvclk);
 	ov2680_power_down(sensor);
+	regulator_bulk_disable(OV2680_NUM_SUPPLIES, sensor->supplies);
 	sensor->is_enabled = false;
 
 	return 0;
@@ -535,6 +546,12 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	if (sensor->is_enabled)
 		return 0;
 
+	ret = regulator_bulk_enable(OV2680_NUM_SUPPLIES, sensor->supplies);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable regulators: %d\n", ret);
+		return ret;
+	}
+
 	if (!sensor->reset_gpio) {
 		ret = ov2680_write_reg(sensor, OV2680_REG_SOFT_RESET, 0x01);
 		if (ret != 0) {
@@ -962,6 +979,18 @@ static int ov2680_v4l2_init(struct ov2680_dev *sensor)
 	return ret;
 }
 
+static int ov2680_get_regulators(struct ov2680_dev *sensor)
+{
+	int i;
+
+	for (i = 0; i < OV2680_NUM_SUPPLIES; i++)
+		sensor->supplies[i].supply = ov2680_supply_name[i];
+
+	return devm_regulator_bulk_get(&sensor->i2c_client->dev,
+				       OV2680_NUM_SUPPLIES,
+				       sensor->supplies);
+}
+
 static int ov2680_check_id(struct ov2680_dev *sensor)
 {
 	struct device *dev = ov2680_to_dev(sensor);
@@ -1034,6 +1063,12 @@ static int ov2680_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
+	ret = ov2680_get_regulators(sensor);
+	if (ret < 0) {
+		dev_err(dev, "failed to get regulators\n");
+		return ret;
+	}
+
 	mutex_init(&sensor->lock);
 
 	ret = ov2680_v4l2_init(sensor);
-- 
2.17.0
