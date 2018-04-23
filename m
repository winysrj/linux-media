Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44667 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbeDWNtG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:49:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id o15-v6so41483872wro.11
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 06:49:06 -0700 (PDT)
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
Subject: [PATCH v2 13/15] ARM: dts: imx7s-warp: add ov2680 sensor node
Date: Mon, 23 Apr 2018 14:47:48 +0100
Message-Id: <20180423134750.30403-14-rui.silva@linaro.org>
In-Reply-To: <20180423134750.30403-1-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warp7 comes with a Omnivision OV2680 sensor, add the node here to make complete
the camera data path for this system.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 91d06adf7c24..d80e9af768b9 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -218,6 +218,22 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+	ov2680: camera@36 {
+		compatible = "ovti,ov2680";
+		reg = <0x36>;
+		clocks = <&osc>;
+		clock-names = "xvclk";
+		powerdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
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
