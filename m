Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33960 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbeEGP5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:57:42 -0400
Received: by mail-wr0-f196.google.com with SMTP id p18-v6so29326062wrm.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 08:57:41 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 3/4] media: ov2680: rename powerdown gpio and fix polarity
Date: Mon,  7 May 2018 16:56:54 +0100
Message-Id: <20180507155655.1555-4-rui.silva@linaro.org>
In-Reply-To: <20180507155655.1555-1-rui.silva@linaro.org>
References: <20180507155655.1555-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the power control gpio to reset, since it is the same, and fix the
polarity code since this gpio is active at low and not at high as controlled
before.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/media/i2c/ov2680.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index cc3d06096d51..8962b397211a 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -98,7 +98,7 @@ struct ov2680_dev {
 	struct clk			*xvclk;
 	u32				xvclk_freq;
 
-	struct gpio_desc		*pwdn_gpio;
+	struct gpio_desc		*reset_gpio;
 	struct mutex			lock; /* protect members */
 
 	bool				mode_pending_changes;
@@ -295,19 +295,19 @@ static int ov2680_load_regs(struct ov2680_dev *sensor,
 
 static void ov2680_power_up(struct ov2680_dev *sensor)
 {
-	if (!sensor->pwdn_gpio)
+	if (!sensor->reset_gpio)
 		return;
 
-	gpiod_set_value(sensor->pwdn_gpio, 1);
+	gpiod_set_value(sensor->reset_gpio, 0);
 	usleep_range(5000, 10000);
 }
 
 static void ov2680_power_down(struct ov2680_dev *sensor)
 {
-	if (!sensor->pwdn_gpio)
+	if (!sensor->reset_gpio)
 		return;
 
-	gpiod_set_value(sensor->pwdn_gpio, 0);
+	gpiod_set_value(sensor->reset_gpio, 1);
 	usleep_range(5000, 10000);
 }
 
@@ -535,7 +535,7 @@ static int ov2680_power_on(struct ov2680_dev *sensor)
 	if (sensor->is_enabled)
 		return 0;
 
-	if (!sensor->pwdn_gpio) {
+	if (!sensor->reset_gpio) {
 		ret = ov2680_write_reg(sensor, OV2680_REG_SOFT_RESET, 0x01);
 		if (ret != 0) {
 			dev_err(dev, "sensor soft reset failed\n");
@@ -990,11 +990,11 @@ static int ov2860_parse_dt(struct ov2680_dev *sensor)
 	struct device *dev = ov2680_to_dev(sensor);
 	int ret;
 
-	sensor->pwdn_gpio = devm_gpiod_get_optional(dev, "powerdown",
-						    GPIOD_OUT_HIGH);
-	ret = PTR_ERR_OR_ZERO(sensor->pwdn_gpio);
+	sensor->reset_gpio = devm_gpiod_get_optional(dev, "reset",
+						     GPIOD_OUT_HIGH);
+	ret = PTR_ERR_OR_ZERO(sensor->reset_gpio);
 	if (ret < 0) {
-		dev_dbg(dev, "error while getting powerdown gpio: %d\n", ret);
+		dev_dbg(dev, "error while getting reset gpio: %d\n", ret);
 		return ret;
 	}
 
-- 
2.17.0
