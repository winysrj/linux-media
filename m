Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42632 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751586AbdHSVYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 17:24:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: javier@dowhile0.org, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 3/3] arm: dts: omap3: N9/N950: Add AS3645A camera flash
Date: Sun, 20 Aug 2017 00:24:10 +0300
Message-Id: <20170819212410.3084-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add the as3645a flash controller to the DT source.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index df3366fa5409..92c1a1da28d3 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -265,6 +265,20 @@
 
 &i2c2 {
 	clock-frequency = <400000>;
+
+	as3645a@30 {
+		reg = <0x30>;
+		compatible = "ams,as3645a";
+		as3645a_flash: flash {
+			flash-timeout-us = <150000>;
+			flash-max-microamp = <320000>;
+			led-max-microamp = <60000>;
+			peak-current-limit = <1750000>;
+		};
+		as3645a_indicator: indicator {
+			led-max-microamp = <10000>;
+		};
+	};
 };
 
 &i2c3 {
-- 
2.11.0
