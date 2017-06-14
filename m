Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34372 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751727AbdFNJr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:47:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 8/8] arm: dts: omap3: N9/N950: Add AS3645A camera flash
Date: Wed, 14 Jun 2017 12:47:19 +0300
Message-Id: <1497433639-13101-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add the as3645a flash controller to the DT source as well as the flash
property with the as3645a device phandle to the sensor DT node.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 arch/arm/boot/dts/omap3-n9.dts       |  1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 14 ++++++++++++++
 arch/arm/boot/dts/omap3-n950.dts     |  1 +
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
index b9e58c5..f95e7b1 100644
--- a/arch/arm/boot/dts/omap3-n9.dts
+++ b/arch/arm/boot/dts/omap3-n9.dts
@@ -26,6 +26,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash = <&as3645a>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index df3366f..8bd6673 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -265,6 +265,20 @@
 
 &i2c2 {
 	clock-frequency = <400000>;
+
+	as3645a: flash@30 {
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
diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
index 646601a..8fca038 100644
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
2.1.4
