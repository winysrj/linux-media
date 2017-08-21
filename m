Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37204 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753680AbdHUT5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 15:57:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        javier@dowhile0.org, jacek.anaszewski@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2.1 3/3] arm: dts: omap3: N9/N950: Add AS3645A camera flash
Date: Mon, 21 Aug 2017 22:57:22 +0300
Message-Id: <20170821195722.22918-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170819212410.3084-4-sakari.ailus@linux.intel.com>
References: <20170819212410.3084-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add the as3645a flash controller to the DT source.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
since v3:

- Drop reference names from flash and indicator nodes. They were unused.

 arch/arm/boot/dts/omap3-n950-n9.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index df3366fa5409..cb47ae79a5f9 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -265,6 +265,20 @@
 
 &i2c2 {
 	clock-frequency = <400000>;
+
+	as3645a@30 {
+		reg = <0x30>;
+		compatible = "ams,as3645a";
+		flash {
+			flash-timeout-us = <150000>;
+			flash-max-microamp = <320000>;
+			led-max-microamp = <60000>;
+			peak-current-limit = <1750000>;
+		};
+		indicator {
+			led-max-microamp = <10000>;
+		};
+	};
 };
 
 &i2c3 {
-- 
2.11.0
