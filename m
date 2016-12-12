Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48651 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752894AbcLLPze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/15] at91-sama5d3_xplained.dts: select ov2640
Date: Mon, 12 Dec 2016 16:55:20 +0100
Message-Id: <20161212155520.41375-16-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch replaces the ov7670 with the ov2640. This patch is not
meant to be merged but is for demonstration purposes only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index 2af24f7..d5f7e82 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -72,7 +72,7 @@
 					#size-cells = <0>;
 					isi_0: endpoint {
 						reg = <0>;
-						remote-endpoint = <&ov7670_0>;
+						remote-endpoint = <&ov2640_0>;
 						bus-width = <8>;
 						vsync-active = <1>;
 						hsync-active = <1>;
@@ -88,20 +88,20 @@
 			i2c1: i2c@f0018000 {
 				status = "okay";
 
-				ov7670: camera@0x21 {
-					compatible = "ovti,ov7670";
-					reg = <0x21>;
+				ov2640: camera@0x30 {
+					compatible = "ovti,ov2640";
+					reg = <0x30>;
 					pinctrl-names = "default";
 					pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
 					resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
 					pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
 					clocks = <&pck0>;
-					clock-names = "xclk";
+					clock-names = "xvclk";
 					assigned-clocks = <&pck0>;
 					assigned-clock-rates = <25000000>;
 
 					port {
-						ov7670_0: endpoint {
+						ov2640_0: endpoint {
 							remote-endpoint = <&isi_0>;
 							bus-width = <8>;
 						};
-- 
2.10.2

