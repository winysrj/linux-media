Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34371 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753562AbdA3OJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 09:09:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 15/16] sama5d3 dts: enable atmel-isi
Date: Mon, 30 Jan 2017 15:06:27 +0100
Message-Id: <20170130140628.18088-16-hverkuil@xs4all.nl>
In-Reply-To: <20170130140628.18088-1-hverkuil@xs4all.nl>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This illustrates the changes needed to the dts in order to hook up the
ov7670. I don't plan on merging this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 61 ++++++++++++++++++++++++++---
 arch/arm/boot/dts/sama5d3.dtsi              |  4 +-
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index c51fc65..2af24f7 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -65,18 +65,53 @@
 				status = "okay";
 			};
 
+			isi0: isi@f0034000 {
+				status = "okay";
+				port {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					isi_0: endpoint {
+						reg = <0>;
+						remote-endpoint = <&ov7670_0>;
+						bus-width = <8>;
+						vsync-active = <1>;
+						hsync-active = <1>;
+					};
+				};
+			};
+
 			i2c0: i2c@f0014000 {
 				pinctrl-0 = <&pinctrl_i2c0_pu>;
-				status = "okay";
+				status = "disabled";
 			};
 
 			i2c1: i2c@f0018000 {
 				status = "okay";
 
+				ov7670: camera@0x21 {
+					compatible = "ovti,ov7670";
+					reg = <0x21>;
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
+					resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
+					pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+					clocks = <&pck0>;
+					clock-names = "xclk";
+					assigned-clocks = <&pck0>;
+					assigned-clock-rates = <25000000>;
+
+					port {
+						ov7670_0: endpoint {
+							remote-endpoint = <&isi_0>;
+							bus-width = <8>;
+						};
+					};
+				};
+
 				pmic: act8865@5b {
 					compatible = "active-semi,act8865";
 					reg = <0x5b>;
-					status = "disabled";
+					status = "okay";
 
 					regulators {
 						vcc_1v8_reg: DCDC_REG1 {
@@ -130,7 +165,7 @@
 			pwm0: pwm@f002c000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_pwm0_pwmh0_0 &pinctrl_pwm0_pwmh1_0>;
-				status = "okay";
+				status = "disabled";
 			};
 
 			usart0: serial@f001c000 {
@@ -143,7 +178,7 @@
 			};
 
 			uart0: serial@f0024000 {
-				status = "okay";
+				status = "disabled";
 			};
 
 			mmc1: mmc@f8000000 {
@@ -181,7 +216,7 @@
 			i2c2: i2c@f801c000 {
 				dmas = <0>, <0>;	/* Do not use DMA for i2c2 */
 				pinctrl-0 = <&pinctrl_i2c2_pu>;
-				status = "okay";
+				status = "disabled";
 			};
 
 			macb1: ethernet@f802c000 {
@@ -200,6 +235,22 @@
 			};
 
 			pinctrl@fffff200 {
+				camera_sensor {
+					pinctrl_pck0_as_isi_mck: pck0_as_isi_mck-0 {
+						atmel,pins =
+							<AT91_PIOD 30 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* ISI_MCK */
+					};
+
+					pinctrl_sensor_power: sensor_power-0 {
+						atmel,pins =
+							<AT91_PIOE 13 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_sensor_reset: sensor_reset-0 {
+						atmel,pins =
+							<AT91_PIOE 11 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
+					};
+				};
 				board {
 					pinctrl_i2c0_pu: i2c0_pu {
 						atmel,pins =
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index b06448b..099570e 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -176,7 +176,7 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				clocks = <&twi1_clk>;
-				status = "disabled";
+				status = "ok";
 			};
 
 			usart0: serial@f001c000 {
@@ -235,7 +235,7 @@
 				pinctrl-0 = <&pinctrl_isi_data_0_7>;
 				clocks = <&isi_clk>;
 				clock-names = "isi_clk";
-				status = "disabled";
+				status = "ok";
 				port {
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.10.2

