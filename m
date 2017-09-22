Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42408 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751881AbdIVJe4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 05:34:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RESEND PATCH v3 3/4] as3645a: Use integer numbers for parsing LEDs
Date: Fri, 22 Sep 2017 12:34:52 +0300
Message-Id: <20170922093453.13250-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170922093453.13250-1-sakari.ailus@linux.intel.com>
References: <20170922093453.13250-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use integer numbers for LEDs, 0 is the flash and 1 is the indicator.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
 arch/arm/boot/dts/omap3-n950-n9.dtsi |  8 ++++++--
 drivers/leds/leds-as3645a.c          | 26 ++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index b86fc83a5a65..1b0bd72945f2 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -267,15 +267,19 @@
 	clock-frequency = <400000>;
 
 	as3645a@30 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		reg = <0x30>;
 		compatible = "ams,as3645a";
-		flash {
+		flash@0 {
+			reg = <0x0>;
 			flash-timeout-us = <150000>;
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
 			ams,input-max-microamp = <1750000>;
 		};
-		indicator {
+		indicator@1 {
+			reg = <0x1>;
 			led-max-microamp = <10000>;
 		};
 	};
diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index e3f89c6130d2..605e0c64e974 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -112,6 +112,10 @@
 #define AS_PEAK_mA_TO_REG(a) \
 	((min_t(u32, AS_PEAK_mA_MAX, a) - 1250) / 250)
 
+/* LED numbers for Devicetree */
+#define AS_LED_FLASH				0
+#define AS_LED_INDICATOR			1
+
 enum as_mode {
 	AS_MODE_EXT_TORCH = 0 << AS_CONTROL_MODE_SETTING_SHIFT,
 	AS_MODE_INDICATOR = 1 << AS_CONTROL_MODE_SETTING_SHIFT,
@@ -491,10 +495,29 @@ static int as3645a_parse_node(struct as3645a *flash,
 			      struct device_node *node)
 {
 	struct as3645a_config *cfg = &flash->cfg;
+	struct device_node *child;
 	const char *name;
 	int rval;
 
-	flash->flash_node = of_get_child_by_name(node, "flash");
+	for_each_child_of_node(node, child) {
+		u32 id = 0;
+
+		of_property_read_u32(child, "reg", &id);
+
+		switch (id) {
+		case AS_LED_FLASH:
+			flash->flash_node = of_node_get(child);
+			break;
+		case AS_LED_INDICATOR:
+			flash->indicator_node = of_node_get(child);
+			break;
+		default:
+			dev_warn(&flash->client->dev,
+				 "unknown LED %u encountered, ignoring\n", id);
+			break;
+		}
+	}
+
 	if (!flash->flash_node) {
 		dev_err(&flash->client->dev, "can't find flash node\n");
 		return -ENODEV;
@@ -538,7 +561,6 @@ static int as3645a_parse_node(struct as3645a *flash,
 			     &cfg->peak);
 	cfg->peak = AS_PEAK_mA_TO_REG(cfg->peak);
 
-	flash->indicator_node = of_get_child_by_name(node, "indicator");
 	if (!flash->indicator_node) {
 		dev_warn(&flash->client->dev,
 			 "can't find indicator node\n");
-- 
2.11.0
