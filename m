Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40256 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731407AbeKMSVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 13:21:22 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 5/5] DO NOT MERGE: ARM: dts: bananapi: Add Camera support
Date: Tue, 13 Nov 2018 09:24:17 +0100
Message-Id: <12093630fdd7d8b43ebcb0340691e0f2200e26c6.1542097288.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun7i-a20-bananapi.dts | 98 +++++++++++++++++++++++++-
 1 file changed, 98 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
index 70dfc4ac0bb5..18dbff9f1ce9 100644
--- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
+++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
@@ -54,6 +54,9 @@
 	compatible = "lemaker,bananapi", "allwinner,sun7i-a20";
 
 	aliases {
+		i2c0 = &i2c0;
+		i2c1 = &i2c1;
+		i2c2 = &i2c2;
 		serial0 = &uart0;
 		serial1 = &uart3;
 		serial2 = &uart7;
@@ -63,6 +66,41 @@
 		stdout-path = "serial0:115200n8";
 	};
 
+	reg_cam: cam {
+		compatible = "regulator-fixed";
+		regulator-name = "cam";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&reg_vcc5v0>;
+		gpio = <&pio 7 16 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-always-on;
+	};
+
+        reg_cam_avdd: cam-avdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-avdd";
+                regulator-min-microvolt = <2800000>;
+                regulator-max-microvolt = <2800000>;
+                vin-supply = <&reg_cam>;
+        };
+
+        reg_cam_dovdd: cam-dovdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dovdd";
+                regulator-min-microvolt = <1800000>;
+                regulator-max-microvolt = <1800000>;
+                vin-supply = <&reg_cam>;
+        };
+
+        reg_cam_dvdd: cam-dvdd {
+                compatible = "regulator-fixed";
+                regulator-name = "cam500b-dvdd";
+                regulator-min-microvolt = <1500000>;
+                regulator-max-microvolt = <1500000>;
+                vin-supply = <&reg_cam>;
+        };
+
 	hdmi-connector {
 		compatible = "hdmi-connector";
 		type = "a";
@@ -120,6 +158,27 @@
 		>;
 };
 
+&csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&csi0_pins_a>;
+	status = "okay";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		csi_from_ov5640: endpoint {
+                        remote-endpoint = <&ov5640_to_csi>;
+                        bus-width = <8>;
+                        data-shift = <2>;
+                        hsync-active = <1>; /* Active high */
+                        vsync-active = <0>; /* Active low */
+                        data-active = <1>;  /* Active high */
+                        pclk-sample = <1>;  /* Rising */
+                };
+	};
+};
+
 &de {
 	status = "okay";
 };
@@ -167,6 +226,39 @@
 	};
 };
 
+&i2c1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c1_pins_a>;
+	status = "okay";
+
+	camera: camera@21 {
+		compatible = "ovti,ov5640";
+		reg = <0x21>;
+                clocks = <&ccu CLK_CSI0>;
+                clock-names = "xclk";
+		assigned-clocks = <&ccu CLK_CSI0>;
+		assigned-clock-rates = <24000000>;
+
+                reset-gpios = <&pio 7 14 GPIO_ACTIVE_LOW>;
+                powerdown-gpios = <&pio 7 19 GPIO_ACTIVE_HIGH>;
+                AVDD-supply = <&reg_cam_avdd>;
+                DOVDD-supply = <&reg_cam_dovdd>;
+                DVDD-supply = <&reg_cam_dvdd>;
+
+                port {
+                        ov5640_to_csi: endpoint {
+                                remote-endpoint = <&csi_from_ov5640>;
+                                bus-width = <8>;
+                                data-shift = <2>;
+                                hsync-active = <1>; /* Active high */
+                                vsync-active = <0>; /* Active low */
+                                data-active = <1>;  /* Active high */
+                                pclk-sample = <1>;  /* Rising */
+                        };
+                };
+	};
+};
+
 &i2c2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
@@ -252,6 +344,12 @@
 		"IO-6", "IO-3", "IO-2", "IO-0", "", "", "", "",
 		"", "", "", "", "", "", "", "";
 
+	csi0_pins_a: csi_pins_a@0 {
+		pins = "PE0", "PE1", "PE2", "PE3", "PE4", "PE5",
+		       "PE6", "PE7", "PE8", "PE9", "PE10", "PE11";
+		function = "csi0";
+	};
+
 	usb0_id_detect_pin: usb0_id_detect_pin@0 {
 		pins = "PH4";
 		function = "gpio_in";
-- 
git-series 0.9.1
