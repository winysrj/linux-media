Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751832AbdIVJck (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 05:32:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com
Cc: linux-media@vger.kernel.org, devicetree@kernel.org
Subject: [PATCH v3 1/4] as3645a: Use ams,input-max-microamp as documented in DT bindings
Date: Fri, 22 Sep 2017 12:32:35 +0300
Message-Id: <20170922093238.13070-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
References: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DT bindings document the property "ams,input-max-microamp" that limits the
chip's maximum input current. The driver and the DTS however used
"peak-current-limit" property. Fix this by using the property documented
in DT binding documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
---
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 2 +-
 drivers/leds/leds-as3645a.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index cb47ae79a5f9..b86fc83a5a65 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -273,7 +273,7 @@
 			flash-timeout-us = <150000>;
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
-			peak-current-limit = <1750000>;
+			ams,input-max-microamp = <1750000>;
 		};
 		indicator {
 			led-max-microamp = <10000>;
diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index bbbbe0898233..e3f89c6130d2 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -534,7 +534,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 	of_property_read_u32(flash->flash_node, "voltage-reference",
 			     &cfg->voltage_reference);
 
-	of_property_read_u32(flash->flash_node, "peak-current-limit",
+	of_property_read_u32(flash->flash_node, "ams,input-max-microamp",
 			     &cfg->peak);
 	cfg->peak = AS_PEAK_mA_TO_REG(cfg->peak);
 
-- 
2.11.0
