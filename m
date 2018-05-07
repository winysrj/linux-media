Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55843 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbeEGQW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:59 -0400
Received: by mail-wm0-f67.google.com with SMTP id a8so14334366wmg.5
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:58 -0700 (PDT)
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
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v3 12/14] ARM: dts: imx7s-warp: add ov2680 sensor node
Date: Mon,  7 May 2018 17:21:50 +0100
Message-Id: <20180507162152.2545-13-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warp7 comes with a Omnivision OV2680 sensor, add the node here to make complete
the camera data path for this system. Add the needed regulator to the analog
voltage supply.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index ffd170ae925a..10df24c05b76 100644
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
@@ -218,6 +226,25 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+	ov2680: camera@36 {
+		compatible = "ovti,ov2680";
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
-- 
2.17.0
