Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45806 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751705AbdIOOS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:18:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v13 25/25] arm: dts: omap3: N9/N950: Add flash references to the camera
Date: Fri, 15 Sep 2017 17:17:24 +0300
Message-Id: <20170915141724.23124-26-sakari.ailus@linux.intel.com>
In-Reply-To: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add flash and indicator LED phandles to the sensor node.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/arm/boot/dts/omap3-n9.dts       | 1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 4 ++--
 arch/arm/boot/dts/omap3-n950.dts     | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
index b9e58c536afd..39e35f8b8206 100644
--- a/arch/arm/boot/dts/omap3-n9.dts
+++ b/arch/arm/boot/dts/omap3-n9.dts
@@ -26,6 +26,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash-leds = <&as3645a_flash &as3645a_indicator>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index 1b0bd72945f2..12fbb3da5fce 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -271,14 +271,14 @@
 		#size-cells = <0>;
 		reg = <0x30>;
 		compatible = "ams,as3645a";
-		flash@0 {
+		as3645a_flash: flash@0 {
 			reg = <0x0>;
 			flash-timeout-us = <150000>;
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
 			ams,input-max-microamp = <1750000>;
 		};
-		indicator@1 {
+		as3645a_indicator: indicator@1 {
 			reg = <0x1>;
 			led-max-microamp = <10000>;
 		};
diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
index 646601a3ebd8..c354a1ed1e70 100644
--- a/arch/arm/boot/dts/omap3-n950.dts
+++ b/arch/arm/boot/dts/omap3-n950.dts
@@ -60,6 +60,7 @@
 		clocks = <&isp 0>;
 		clock-frequency = <9600000>;
 		nokia,nvm-size = <(16 * 64)>;
+		flash-leds = <&as3645a_flash &as3645a_indicator>;
 		port {
 			smia_1_1: endpoint {
 				link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
-- 
2.11.0
