Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39972 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbeEVOxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 10:53:24 -0400
Received: by mail-wm0-f66.google.com with SMTP id j5-v6so522012wme.5
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 07:53:23 -0700 (PDT)
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
Subject: [PATCH v6 10/13] ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
Date: Tue, 22 May 2018 15:52:42 +0100
Message-Id: <20180522145245.3143-11-rui.silva@linaro.org>
In-Reply-To: <20180522145245.3143-1-rui.silva@linaro.org>
References: <20180522145245.3143-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the device tree nodes for csi, video multiplexer and mipi-csi
besides the graph connecting the necessary endpoints to make the media capture
entities to work in imx7 Warp board.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 51 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 8a30b148534d..cb175ee2fc9d 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -310,6 +310,57 @@
 	status = "okay";
 };
 
+&gpr {
+	csi_mux {
+		compatible = "video-mux";
+		mux-controls = <&mux 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@1 {
+			reg = <1>;
+
+			csi_mux_from_mipi_vc0: endpoint {
+				remote-endpoint = <&mipi_vc0_to_csi_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			csi_mux_to_csi: endpoint {
+				remote-endpoint = <&csi_from_csi_mux>;
+			};
+		};
+	};
+};
+
+&csi {
+	status = "okay";
+
+	port {
+		csi_from_csi_mux: endpoint {
+			remote-endpoint = <&csi_mux_to_csi>;
+		};
+	};
+};
+
+&mipi_csi {
+	clock-frequency = <166000000>;
+	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	fsl,csis-hs-settle = <3>;
+
+	port@1 {
+		reg = <1>;
+
+		mipi_vc0_to_csi_mux: endpoint {
+			remote-endpoint = <&csi_mux_from_mipi_vc0>;
+		};
+	};
+};
+
 &wdog1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 0b0b85438869..4fce2f46c766 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -46,6 +46,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/reset/imx7-reset.h>
 #include "imx7d-pinfunc.h"
 
 / {
@@ -738,6 +739,17 @@
 				status = "disabled";
 			};
 
+			csi: csi@30710000 {
+				compatible = "fsl,imx7-csi";
+				reg = <0x30710000 0x10000>;
+				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX7D_CLK_DUMMY>,
+						<&clks IMX7D_CSI_MCLK_ROOT_CLK>,
+						<&clks IMX7D_CLK_DUMMY>;
+				clock-names = "axi", "mclk", "dcic";
+				status = "disabled";
+			};
+
 			lcdif: lcdif@30730000 {
 				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
 				reg = <0x30730000 0x10000>;
@@ -747,6 +759,21 @@
 				clock-names = "pix", "axi";
 				status = "disabled";
 			};
+
+			mipi_csi: mipi-csi@30750000 {
+				compatible = "fsl,imx7-mipi-csi2";
+				reg = <0x30750000 0x10000>;
+				interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX7D_IPG_ROOT_CLK>,
+						<&clks IMX7D_MIPI_CSI_ROOT_CLK>,
+						<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
+				clock-names = "pclk", "wrap", "phy";
+				power-domains = <&pgc_mipi_phy>;
+				phy-supply = <&reg_1p0d>;
+				resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
+				reset-names = "mrst";
+				status = "disabled";
+			};
 		};
 
 		aips3: aips-bus@30800000 {
-- 
2.17.0
