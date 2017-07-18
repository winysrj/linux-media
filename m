Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60038 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751921AbdGRTEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC 08/19] arm: dts: omap3: N9/N950: Add AS3645A camera flash
Date: Tue, 18 Jul 2017 22:03:50 +0300
Message-Id: <20170718190401.14797-9-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add the as3645a flash controller to the DT source as well as the flash
property with the as3645a device phandle to the sensor DT node.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 arch/arm/boot/dts/omap3-n9.dts       |  1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 14 ++++++++++++++
 arch/arm/boot/dts/omap3-n950.dts     |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
index b9e58c536afd..a2944010f62f 100644
--- a/arch/arm/boot/dts/omap3-n9.dts
+++ b/arch/arm/boot/dts/omap3-n9.dts
@@ -26,6 +26,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash = <&as3645a_flash &as3645a_indicator>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index df3366fa5409..e15722b83a70 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -265,6 +265,20 @@
 
 &i2c2 {
 	clock-frequency = <400000>;
+
+	as3645a: flash@30 {
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
diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
index 646601a3ebd8..8fca0384d2df 100644
--- a/arch/arm/boot/dts/omap3-n950.dts
+++ b/arch/arm/boot/dts/omap3-n950.dts
@@ -60,6 +60,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash = <&as3645a>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
-- 
2.11.0
