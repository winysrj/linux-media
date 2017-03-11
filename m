Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47780 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932891AbdCKLYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:24:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 16/16] at91-sama5d3_xplained.dts: select ov2640
Date: Sat, 11 Mar 2017 12:23:28 +0100
Message-Id: <20170311112328.11802-17-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch replaces the ov7670 with the ov2640. This patch is not
meant to be merged but is for demonstration purposes only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index c6b07f83578b..6951bd6a11d7 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -71,7 +71,7 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					isi_0: endpoint {
-						remote-endpoint = <&ov7670_0>;
+						remote-endpoint = <&ov2640_0>;
 						bus-width = <8>;
 						vsync-active = <1>;
 						hsync-active = <1>;
@@ -87,20 +87,20 @@
 			i2c1: i2c@f0018000 {
 				status = "okay";
 
-				ov7670: camera@21 {
-					compatible = "ovti,ov7670";
-					reg = <0x21>;
+				ov2640: camera@30 {
+					compatible = "ovti,ov2640";
+					reg = <0x30>;
 					pinctrl-names = "default";
 					pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
-					reset-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
-					powerdown-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+					resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
+					pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
 					clocks = <&pck0>;
-					clock-names = "xclk";
+					clock-names = "xvclk";
 					assigned-clocks = <&pck0>;
 					assigned-clock-rates = <25000000>;
 
 					port {
-						ov7670_0: endpoint {
+						ov2640_0: endpoint {
 							remote-endpoint = <&isi_0>;
 						};
 					};
-- 
2.11.0
