Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52953 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437573AbeKWB7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 20:59:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id r11-v6so9290377wmb.2
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 07:19:13 -0800 (PST)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v9 09/13] ARM: dts: imx7s-warp: add ov2680 sensor node
Date: Thu, 22 Nov 2018 15:18:30 +0000
Message-Id: <20181122151834.6194-10-rui.silva@linaro.org>
In-Reply-To: <20181122151834.6194-1-rui.silva@linaro.org>
References: <20181122151834.6194-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warp7 comes with a Omnivision OV2680 sensor, add the node here to make
complete the camera data path for this system. Add the needed regulator
to the analog voltage supply, the port and endpoints in mipi_csi node
and the pinctrl for the reset gpio.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 44 ++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 757856a3964b..4ada85850411 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -54,6 +54,14 @@
 		regulator-always-on;
 	};
 
+	reg_peri_3p15v: regulator-peri-3p15v {
+		compatible = "regulator-fixed";
+		regulator-name = "peri_3p15v_reg";
+		regulator-min-microvolt = <3150000>;
+		regulator-max-microvolt = <3150000>;
+		regulator-always-on;
+	};
+
 	sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "imx7-sgtl5000";
@@ -177,6 +185,27 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+	ov2680: camera@36 {
+		compatible = "ovti,ov2680";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov2680>;
+		reg = <0x36>;
+		clocks = <&osc>;
+		clock-names = "xvclk";
+		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
+		DOVDD-supply = <&sw2_reg>;
+		DVDD-supply = <&sw2_reg>;
+		AVDD-supply = <&reg_peri_3p15v>;
+
+		port {
+			ov2680_to_mipi: endpoint {
+				remote-endpoint = <&mipi_from_sensor>;
+				clock-lanes = <0>;
+				data-lanes = <1>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -318,6 +347,15 @@
 	#size-cells = <0>;
 	fsl,csis-hs-settle = <3>;
 
+	port@0 {
+		reg = <0>;
+
+		mipi_from_sensor: endpoint {
+			remote-endpoint = <&ov2680_to_mipi>;
+			data-lanes = <1>;
+		};
+	};
+
 	port@1 {
 		reg = <1>;
 
@@ -381,6 +419,12 @@
 		>;
 	};
 
+	pinctrl_ov2680: ov2660grp {
+		fsl,pins = <
+			MX7D_PAD_LPSR_GPIO1_IO03__GPIO1_IO3	0x14
+		>;
+	};
+
 	pinctrl_sai1: sai1grp {
 		fsl,pins = <
 			MX7D_PAD_SAI1_RX_DATA__SAI1_RX_DATA0	0x1f
-- 
2.19.1
