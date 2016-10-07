Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49194 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936471AbcJGQBV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 16/22] ARM: dts: nitrogen6x: Add dtsi for BD_HDMI_MIPI HDMI to MIPI CSI-2 receiver board
Date: Fri,  7 Oct 2016 18:01:01 +0200
Message-Id: <20161007160107.5074-17-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree nodes for the BD_HDMI_MIPI HDMI to MIPI CSI-2 receiver
board with a TC358743 connected to the Nitrogen6X MIPI CSI-2 input
connector.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi  | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 arch/arm/boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi

diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi
new file mode 100644
index 0000000..e110874
--- /dev/null
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2015 Philipp Zabel, Pengutronix
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	hdmi_osc: hdmi-osc {
+		compatible = "fixed-clock";
+		clock-output-names = "hdmi-osc";
+		clock-frequency = <27000000>;
+		#clock-cells = <0>;
+	};
+};
+
+&i2c2 {
+	tc358743: tc358743@0f {
+		compatible = "toshiba,tc358743";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tc358743>;
+		reg = <0x0f>;
+		clocks = <&hdmi_osc>;
+		clock-names = "refclk";
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
+
+		port@0 {
+			tc358743_out: endpoint {
+				remote-endpoint = <&mipi_csi2_in>;
+				data-lanes = <1 2 3 4>;
+				clock-lanes = <0>;
+				clock-noncontinuous;
+				link-frequencies = /bits/ 64 <297000000>;
+			};
+		};
+	};
+};
+
+&iomuxc {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog>;
+
+	imx6q-nitrogen6x-tc358743 {
+		pinctrl_tc358743: tc358743grp {
+			fsl,pins = <
+				MX6QDL_PAD_NANDF_WP_B__GPIO6_IO09 0x4000b0b0	/* RESETN */
+				MX6QDL_PAD_NANDF_D5__GPIO2_IO05   0x400130b0	/* INT */
+			>;
+		};
+	};
+};
+
+&mipi_csi {
+	status = "okay";
+
+	port@0 {
+		mipi_csi2_in: endpoint {
+			remote-endpoint = <&tc358743_out>;
+			data-lanes = <1 2 3 4>;
+			clock-lanes = <0>;
+			clock-noncontinuous;
+			link-frequencies = /bits/ 64 <297000000>;
+		};
+	};
+};
-- 
2.9.3

