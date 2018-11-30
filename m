Return-path: <linux-media-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:50230 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbeK3TQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:16:32 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] [DO NOT MERGE] ARM: dts: sunxi: bananapi-m2p: Add HDF5640 camera module
Date: Fri, 30 Nov 2018 15:58:48 +0800
Message-Id: <20181130075849.16941-6-wens@csie.org>
In-Reply-To: <20181130075849.16941-1-wens@csie.org>
References: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Bananapi M2+ comes with an optional sensor based on the ov5640 from
Omnivision. Enable the support for it in the DT.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
index b3283aeb5b7d..d97a98acf378 100644
--- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
+++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
@@ -89,6 +89,42 @@
 		};
 	};
 
+	reg_cam_avdd: cam-avdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-avdd";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		startup-delay-us = <200>; /* 50 us + board delays */
+		enable-active-high;
+		gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
+	};
+
+	reg_cam_dovdd: cam-dovdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-dovdd";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		/*
+		 * This regulator also powers the pull-ups for the I2C bus.
+		 * For some reason, if this is turned off, subsequent use
+		 * of the I2C bus, even when turned on, does not work.
+		 */
+		startup-delay-us = <200>; /* 50 us + board delays */
+		regulator-always-on;
+		enable-active-high;
+		gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
+	};
+
+	reg_cam_dvdd: cam-dvdd {
+		compatible = "regulator-fixed";
+		regulator-name = "csi-dvdd";
+		regulator-min-microvolt = <1500000>;
+		regulator-max-microvolt = <1500000>;
+		startup-delay-us = <200>; /* 50 us + board delays */
+		enable-active-high;
+		gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
+	};
+
 	reg_gmac_3v3: gmac-3v3 {
 		      compatible = "regulator-fixed";
 		      regulator-name = "gmac-3v3";
@@ -106,6 +142,26 @@
 	};
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
@@ -149,6 +205,37 @@
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
+		reset-gpios = <&pio 4 14 GPIO_ACTIVE_LOW>; /* PE14 */
+		powerdown-gpios = <&pio 4 15 GPIO_ACTIVE_HIGH>; /* PE15 */
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
