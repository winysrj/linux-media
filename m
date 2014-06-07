Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60169 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFGV5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:36 -0400
Received: by mail-pb0-f50.google.com with SMTP id ma3so3909907pbc.9
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:36 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 34/43] ARM: dts: imx6-sabreauto: add video capture ports and endpoints
Date: Sat,  7 Jun 2014 14:56:36 -0700
Message-Id: <1402178205-22697-35-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines the host v4l2-capture device node and the ADV7180 decoder
sensor. The host capture device is a child of ipu1. The ADV7180 is
connected to the host parallel-bus endpoint on CSI0.

On the sabreauto, two analog video inputs are routed to the ADV7180,
composite on Ain1, and composite on Ain3. Those inputs are defined
via inputs and input-names under the host endpoint node on CSI0.

Regulators and port expanders are defined which are required for the
ADV7180 (power pin is via port expander gpio on i2c3). The reset pin
to the port expander chip (MAX7310) is controlled by a gpio, so define
the reset-gpios property to control it.

The sabreauto uses a steering pin to select between the SDA signal on
i2c3 bus, and a data-in pin for an SPI NOR chip. Use i2cmux to control
this steering pin. Idle state of the i2cmux selects SPI NOR. This is not
a classic way to use i2cmux, since one side of the mux selects something
other than an i2c bus, but it works and is probably the cleanest
solution. Note that if one thread is attempting to access SPI NOR while
another thread is accessing i2c3, the SPI NOR access will fail since the
i2cmux has selected the SDA pin rather than SPI NOR data-in. This couldn't
be avoided in any case, the board is not designed to allow concurrent
i2c3 and SPI NOR functions (and the default device-tree does not enable
SPI NOR anyway).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi |  149 ++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 009abd6..27ac698 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -17,6 +17,39 @@
 		reg = <0x10000000 0x80000000>;
 	};
 
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reg_2p5v: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "2P5V";
+			regulator-min-microvolt = <2500000>;
+			regulator-max-microvolt = <2500000>;
+			regulator-always-on;
+		};
+
+		reg_3p3v: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		reg_2p8v: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "2P8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			regulator-always-on;
+		};
+	};
+
 	leds {
 		compatible = "gpio-leds";
 		pinctrl-names = "default";
@@ -43,6 +76,66 @@
 		default-brightness-level = <7>;
 		status = "okay";
 	};
+
+	i2cmux {
+		compatible = "i2c-mux-gpio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_i2c3mux>;
+		mux-gpios = <&gpio5 4 0>;
+		i2c-parent = <&i2c3>;
+		idle-state = <0>;
+
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			camera: adv7180@21 {
+				compatible = "adi,adv7180";
+				reg = <0x21>;
+				DOVDD-supply = <&reg_3p3v>;
+				AVDD-supply = <&reg_3p3v>;
+				DVDD-supply = <&reg_3p3v>;
+				PVDD-supply = <&reg_3p3v>;
+				pwdn-gpio = <&port_exp_b 2 0>;
+				interrupt-parent = <&gpio1>;
+				interrupts = <27 0x8>;
+
+				port {
+					adv7180_1: endpoint {
+						remote-endpoint = <&csi0>;
+						bus-width = <16>;
+					};
+				};
+			};
+
+			port_exp_a: gpio_pca953x@30 {
+				compatible = "maxim,max7310";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x30>;
+				reset-gpios = <&gpio1 15 GPIO_ACTIVE_LOW>;
+			};
+
+			port_exp_b: gpio_pca953x@32 {
+				compatible = "maxim,max7310";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x32>;
+				reset-gpios = <&gpio1 15 GPIO_ACTIVE_LOW>;
+			};
+
+			port_exp_c: gpio_pca953x@34 {
+				compatible = "maxim,max7310";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x34>;
+				reset-gpios = <&gpio1 15 GPIO_ACTIVE_LOW>;
+			};
+		};
+	};
 };
 
 &ecspi1 {
@@ -182,6 +275,13 @@
 	};
 };
 
+&i2c3 {
+	status = "okay";
+	clock-frequency = <400000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c3>;
+};
+
 &iomuxc {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_hog>;
@@ -192,6 +292,7 @@
 				MX6QDL_PAD_NANDF_CS2__GPIO6_IO15 0x80000000
 				MX6QDL_PAD_SD2_DAT2__GPIO1_IO13  0x80000000
 				MX6QDL_PAD_GPIO_18__SD3_VSELECT 0x17059
+				MX6QDL_PAD_SD2_DAT0__GPIO1_IO15 0x80000000
 			>;
 		};
 
@@ -265,6 +366,19 @@
 			>;
 		};
 
+		pinctrl_i2c3: i2c3grp {
+			fsl,pins = <
+				MX6QDL_PAD_GPIO_3__I2C3_SCL	0x4001b8b1
+				MX6QDL_PAD_EIM_D18__I2C3_SDA	0x4001b8b1
+			>;
+		};
+
+		pinctrl_i2c3mux: i2c3muxgrp {
+			fsl,pins = <
+				MX6QDL_PAD_EIM_A24__GPIO5_IO04 0x80000000
+			>;
+		};
+
 		pinctrl_pwm3: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD4_DAT1__PWM3_OUT		0x1b0b1
@@ -456,3 +570,38 @@
 				0x0000c000 0x1404a38e 0x00000000>;
 	};
 };
+
+&ipu1 {
+	status = "okay";
+
+	v4l2-capture {
+		compatible = "fsl,imx6-v4l2-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&pinctrl_ipu1_csi0_d4_d7
+			&pinctrl_ipu1_csi0_1
+		>;
+
+		/* CSI0 */
+		port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			/* Parallel bus */
+			csi0: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&adv7180_1>;
+				bus-width = <16>;
+				data-shift = <4>; /* Lines 19:4 used */
+
+				inputs = <0x00 0x02>;
+				input-names = "ADV7180 Composite on Ain1",
+						"ADV7180 Composite on Ain3";
+			};
+		};
+	};
+};
-- 
1.7.9.5

