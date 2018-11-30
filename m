Return-path: <linux-media-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:50224 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbeK3TQa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:16:30 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [DO NOT MERGE] ARM: dts: sunxi: libretech-all-h3-cc: Add HDF5640 camera module
Date: Fri, 30 Nov 2018 15:58:49 +0800
Message-Id: <20181130075849.16941-7-wens@csie.org>
In-Reply-To: <20181130075849.16941-1-wens@csie.org>
References: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Libretech ALL-H3-CC is compatible with the Orange Pi's camera sensor
module. This module itself features a detachable camera sensor module
ribbon connector, which is populated with a GC2035 sensor by default.
The connector is also compatible with Bananapi's HDF5640 camera module,
which features an OV5640 sensor. The Orange Pi module however does not
activate the auto focus feature of the HDF5640 module.

Enable the camera by enabling the CSI controller, I2C control bus, and
adding needed regulator supplies. As the schematics for the module are
not available, the regulators and GPIO lines controlling them are just
an educated guess.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 .../boot/dts/sunxi-libretech-all-h3-cc.dtsi   | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi b/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
index 1eadc132390c..3252e1af59cd 100644
--- a/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
+++ b/arch/arm/boot/dts/sunxi-libretech-all-h3-cc.dtsi
@@ -52,6 +52,36 @@
 		};
 	};
 
+	reg_cam_avdd: cam-avdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-avdd";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		startup-delay-us = <200>; /* 50 us + board delays */
+		enable-active-high;
+		gpio = <&r_pio 0 0 GPIO_ACTIVE_HIGH>; /* PL0 */
+	};
+
+	reg_cam_dovdd: cam-dovdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-dovdd";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		startup-delay-us = <200>; /* 50 us + board delays */
+		enable-active-high;
+		gpio = <&r_pio 0 0 GPIO_ACTIVE_HIGH>; /* PL0 */
+	};
+
+	reg_cam_dvdd: cam-dvdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-dvdd";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <1500000>;
+		startup-delay-us = <200>; /* 50 us + board delays */
+		enable-active-high;
+		gpio = <&r_pio 0 1 GPIO_ACTIVE_HIGH>; /* PL1 */
+	};
+
 	reg_vcc1v2: vcc1v2 {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc1v2";
@@ -128,6 +158,26 @@
 	cpu-supply = <&reg_vdd_cpux>;
 };
 
+&csi {
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* Parallel bus endpoint */
+		csi_from_ov5640: endpoint {
+			remote-endpoint = <&ov5640_to_csi>;
+			bus-width = <8>;
+			data-shift = <2>;
+			hsync-active = <1>; /* Active high */
+			vsync-active = <0>; /* Active low */
+			data-active = <1>;  /* Active high */
+			pclk-sample = <1>;  /* Rising */
+		};
+	};
+};
+
 &de {
 	status = "okay";
 };
@@ -165,6 +215,37 @@
 	};
 };
 
+&i2c2 {
+	status = "okay";
+
+	ov5640: camera@3c {
+		compatible = "ovti,ov5640";
+		reg = <0x3c>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&csi_mclk_pin>;
+		clocks = <&ccu CLK_CSI_MCLK>;
+		clock-names = "xclk";
+
+		powerdown-gpios = <&pio 4 14 GPIO_ACTIVE_HIGH>; /* PE14 */
+		reset-gpios = <&pio 4 15 GPIO_ACTIVE_LOW>; /* PE15 */
+		AVDD-supply = <&reg_cam_avdd>;
+		DOVDD-supply = <&reg_cam_dovdd>;
+		DVDD-supply = <&reg_cam_dvdd>;
+
+		port {
+			ov5640_to_csi: endpoint {
+				remote-endpoint = <&csi_from_ov5640>;
+				bus-width = <8>;
+				data-shift = <2>;
+				hsync-active = <1>; /* Active high */
+				vsync-active = <0>; /* Active low */
+				data-active = <1>;  /* Active high */
+				pclk-sample = <1>;  /* Rising */
+			};
+		};
+	};
+};
+
 &ir {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ir_pins_a>;
-- 
2.20.0.rc1
