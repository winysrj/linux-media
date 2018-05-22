Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38939 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbeEVOx0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 10:53:26 -0400
Received: by mail-wm0-f68.google.com with SMTP id f8-v6so547384wmc.4
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 07:53:26 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v6 11/13] ARM: dts: imx7s-warp: add ov2680 sensor node
Date: Tue, 22 May 2018 15:52:43 +0100
Message-Id: <20180522145245.3143-12-rui.silva@linaro.org>
In-Reply-To: <20180522145245.3143-1-rui.silva@linaro.org>
References: <20180522145245.3143-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warp7 comes with a Omnivision OV2680 sensor, add the node here to make complete
the camera data path for this system. Add the needed regulator to the analog
voltage supply, the port and endpoints in mipi_csi node and the pinctrl for the
reset gpio.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 44 ++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index cb175ee2fc9d..bf04e13afd02 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -91,6 +91,14 @@
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
@@ -218,6 +226,27 @@
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
 
 &i2c4 {
@@ -352,6 +381,15 @@
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
 
@@ -408,6 +446,12 @@
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
2.17.0
