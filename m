Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753188AbdICRuF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 13:50:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v7 18/18] arm: dts: omap3: N9/N950: Add flash references to the camera
Date: Sun,  3 Sep 2017 20:49:58 +0300
Message-Id: <20170903174958.27058-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add flash and indicator LED phandles to the sensor node.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 arch/arm/boot/dts/omap3-n9.dts       | 1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 4 ++--
 arch/arm/boot/dts/omap3-n950.dts     | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

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
index cb47ae79a5f9..92c1a1da28d3 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -269,13 +269,13 @@
 	as3645a@30 {
 		reg = <0x30>;
 		compatible = "ams,as3645a";
-		flash {
+		as3645a_flash: flash {
 			flash-timeout-us = <150000>;
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
 			peak-current-limit = <1750000>;
 		};
-		indicator {
+		as3645a_indicator: indicator {
 			led-max-microamp = <10000>;
 		};
 	};
diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
index 646601a3ebd8..bba5c5a6950c 100644
--- a/arch/arm/boot/dts/omap3-n950.dts
+++ b/arch/arm/boot/dts/omap3-n950.dts
@@ -60,6 +60,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash = <&as3645a_flash &as3645a_indicator>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
-- 
2.11.0
