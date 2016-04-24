Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33243 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDXVKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:34 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so17689104wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:33 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 20/24] ARM: dts: omap3-n900: enable cameras
Date: Mon, 25 Apr 2016 00:08:20 +0300
Message-Id: <1461532104-24032-21-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 arch/arm/boot/dts/omap3-n900.dts | 140 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index cc4cab2..03e1613 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -177,6 +177,84 @@
 		io-channels = <&twl_madc 0>, <&twl_madc 4>, <&twl_madc 12>;
 		io-channel-names = "temp", "bsi", "vbat";
 	};
+
+	rear_camera: camera@0 {
+		compatible = "linux,camera";
+
+		module {
+			model = "TCM8341MD";
+			sensor = <&cam1>;
+			focus = <&autofocus>;
+		};
+	};
+
+	front_camera: camera@1 {
+		compatible = "linux,camera";
+
+		module {
+			model = "VS6555";
+			sensor = <&cam2>;
+		};
+	};
+
+	video-bus-switch {
+		compatible = "video-bus-switch";
+
+		switch-gpios = <&gpio4 1 GPIO_ACTIVE_HIGH>; /* 97 */
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+
+				csi_switch_in: endpoint {
+					remote-endpoint = <&csi_isp>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+
+				csi_switch_out1: endpoint {
+					remote-endpoint = <&csi_cam1>;
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+
+				csi_switch_out2: endpoint {
+					remote-endpoint = <&csi_cam2>;
+				};
+			};
+		};
+	};
+};
+
+&isp {
+	vdds_csib-supply = <&vaux2>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&camera_pins>;
+
+	ports {
+		port@1 {
+			reg = <1>;
+
+			csi_isp: endpoint {
+				remote-endpoint = <&csi_switch_in>;
+				bus-type = <3>; /* CCP2 */
+				clock-lanes = <0>;
+				data-lanes = <1>;
+				lane-polarity = <0 0>;
+				clock-inv = <0>;
+				strobe = <0>;
+				crc = <0>;
+			};
+		};
+	};
 };
 
 &omap3_pmx_core {
@@ -341,6 +419,22 @@
 			OMAP3_CORE1_IOPAD(0x218e, PIN_OUTPUT | MUX_MODE4)		/* gpio 157 => cmt_bsi */
 		>;
 	};
+
+	camera_pins: pinmux_camera {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x210c, PIN_OUTPUT | MUX_MODE7)       /* cam_hs */
+			OMAP3_CORE1_IOPAD(0x210e, PIN_OUTPUT | MUX_MODE7)       /* cam_vs */
+			OMAP3_CORE1_IOPAD(0x2110, PIN_OUTPUT | MUX_MODE0)       /* cam_xclka */
+			OMAP3_CORE1_IOPAD(0x211e, PIN_OUTPUT | MUX_MODE7)       /* cam_d4 */
+			OMAP3_CORE1_IOPAD(0x2122, PIN_INPUT | MUX_MODE0)        /* cam_d6 */
+			OMAP3_CORE1_IOPAD(0x2124, PIN_INPUT | MUX_MODE0)        /* cam_d7 */
+			OMAP3_CORE1_IOPAD(0x2126, PIN_INPUT | MUX_MODE0)        /* cam_d8 */
+			OMAP3_CORE1_IOPAD(0x2128, PIN_INPUT | MUX_MODE0)        /* cam_d9 */
+			OMAP3_CORE1_IOPAD(0x212a, PIN_OUTPUT | MUX_MODE7)       /* cam_d10 */
+			OMAP3_CORE1_IOPAD(0x212e, PIN_OUTPUT | MUX_MODE7)       /* cam_xclkb */
+			OMAP3_CORE1_IOPAD(0x2132, PIN_OUTPUT | MUX_MODE0)       /* cam_strobe */
+		>;
+	};
 };
 
 &i2c1 {
@@ -529,6 +623,28 @@
 
 	clock-frequency = <100000>;
 
+	cam2: camera@10 {
+		compatible = "nokia,smia";
+		reg = <0x10>;
+
+		vana-supply = <&vaux4>;
+
+		clocks = <&isp 0>;
+		clock-frequency = <9600000>;
+
+		port {
+			csi_cam2: endpoint {
+				link-frequencies = /bits/ 64 <60000000>;
+				bus-type = <3>; /* CCP2 */
+				strobe = <0>;
+				clock-inv = <0>;
+				crc = <0>;
+
+				remote-endpoint = <&csi_switch_out2>;
+			};
+		};
+	};
+
 	tlv320aic3x: tlv320aic3x@18 {
 		compatible = "ti,tlv320aic3x";
 		reg = <0x18>;
@@ -738,6 +854,30 @@
 		st,max-limit-y = <32>;
 		st,max-limit-z = <32>;
 	};
+
+	cam1: camera@3e {
+		compatible = "toshiba,et8ek8";
+		reg = <0x3e>;
+
+		vana-supply = <&vaux4>;
+
+		clocks = <&isp 0>;
+		clock-names = "extclk";
+		clock-frequency = <9600000>;
+
+		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
+
+		port {
+			csi_cam1: endpoint {
+				bus-type = <3>; /* CCP2 */
+				strobe = <1>;
+				clock-inv = <0>;
+				crc = <1>;
+
+				remote-endpoint = <&csi_switch_out1>;
+			};
+		};
+	};
 };
 
 &mmc1 {
-- 
1.9.1

