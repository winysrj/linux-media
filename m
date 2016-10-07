Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38881 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935466AbcJGQBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 14/22] ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their connections
Date: Fri,  7 Oct 2016 18:00:59 +0200
Message-Id: <20161007160107.5074-15-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the device tree graph connecting the input multiplexers
to the IPU CSIs and the MIPI-CSI2 gasket on i.MX6. The MIPI_IPU
multiplexers are added as children of the iomuxc-gpr syscon device node.
On i.MX6Q/D two two-input multiplexers in front of IPU1 CSI0 and IPU2
CSI1 allow to select between CSI0/1 parallel input pads and the MIPI
CSI-2 virtual channels 0/3.
On i.MX6DL/S two five-input multiplexers in front of IPU1 CSI0 and IPU1
CSI1 allow to select between CSI0/1 parallel input pads and any of the
four MIPI CSI-2 virtual channels.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx6dl.dtsi  | 182 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi   | 118 ++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi |  10 ++-
 3 files changed, 309 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 3c817de..7ed4efd6f 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -133,6 +133,188 @@
 		      "di0", "di1";
 };
 
+&gpr {
+	ipu_csi0_mux {
+		compatible = "video-multiplexer";
+		reg = <0x34>;
+		bit-mask = <0x7>;
+		bit-shift = <0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			ipu_csi0_mux_from_mipi_csi0: endpoint {
+				remote-endpoint = <&mipi_csi0_to_ipu_csi0_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu_csi0_mux_from_mipi_csi1: endpoint {
+				remote-endpoint = <&mipi_csi1_to_ipu_csi0_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu_csi0_mux_from_mipi_csi2: endpoint {
+				remote-endpoint = <&mipi_csi2_to_ipu_csi0_mux>;
+			};
+		};
+
+		port@3 {
+			reg = <3>;
+
+			ipu_csi0_mux_from_mipi_csi3: endpoint {
+				remote-endpoint = <&mipi_csi3_to_ipu_csi0_mux>;
+			};
+		};
+
+		csi0: port@4 {
+			reg = <4>;
+		};
+
+		port@5 {
+			reg = <5>;
+
+			ipu_csi0_mux_to_ipu1_csi0: endpoint {
+				remote-endpoint = <&ipu1_csi0_from_ipu_csi0_mux>;
+			};
+		};
+	};
+
+	ipu_csi1_mux {
+		compatible = "video-multiplexer";
+		reg = <0x34>;
+		bit-mask = <0x7>;
+		bit-shift = <3>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			ipu_csi1_mux_from_mipi_csi0: endpoint {
+				remote-endpoint = <&mipi_csi0_to_ipu_csi1_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu_csi1_mux_from_mipi_csi1: endpoint {
+				remote-endpoint = <&mipi_csi1_to_ipu_csi1_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu_csi1_mux_from_mipi_csi2: endpoint {
+				remote-endpoint = <&mipi_csi2_to_ipu_csi1_mux>;
+			};
+		};
+
+		port@3 {
+			reg = <3>;
+
+			ipu_csi1_mux_from_mipi_csi3: endpoint {
+				remote-endpoint = <&mipi_csi3_to_ipu_csi1_mux>;
+			};
+		};
+
+		csi1: port@4 {
+			reg = <4>;
+		};
+
+		port@5 {
+			reg = <5>;
+
+			ipu_csi1_mux_to_ipu1_csi1: endpoint {
+				remote-endpoint = <&ipu1_csi1_from_ipu_csi1_mux>;
+			};
+		};
+	};
+};
+
+&ipu1_csi0 {
+	ipu1_csi0_from_ipu_csi0_mux: endpoint {
+		remote-endpoint = <&ipu_csi0_mux_to_ipu1_csi0>;
+	};
+};
+
+&ipu1_csi1 {
+	ipu1_csi1_from_ipu_csi1_mux: endpoint {
+		remote-endpoint = <&ipu_csi1_mux_to_ipu1_csi1>;
+	};
+};
+
+&mipi_csi {
+	port@0 {
+		reg = <0>;
+	};
+
+	port@1 {
+		reg = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_csi0_to_ipu_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu_csi0_mux_from_mipi_csi0>;
+		};
+
+		mipi_csi0_to_ipu_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu_csi1_mux_from_mipi_csi0>;
+		};
+	};
+
+	port@2 {
+		reg = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_csi1_to_ipu_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu_csi0_mux_from_mipi_csi1>;
+		};
+
+		mipi_csi1_to_ipu_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu_csi1_mux_from_mipi_csi1>;
+		};
+	};
+
+	port@3 {
+		reg = <3>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_csi2_to_ipu_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu_csi0_mux_from_mipi_csi2>;
+		};
+
+		mipi_csi2_to_ipu_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu_csi1_mux_from_mipi_csi2>;
+		};
+	};
+
+	port@4 {
+		reg = <4>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_csi3_to_ipu_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu_csi0_mux_from_mipi_csi3>;
+		};
+
+		mipi_csi3_to_ipu_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu_csi1_mux_from_mipi_csi3>;
+		};
+	};
+};
+
 &vpu {
 	compatible = "fsl,imx6dl-vpu", "cnm,coda960";
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 0c87a69..675723b 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -143,10 +143,18 @@
 
 			ipu2_csi0: port@0 {
 				reg = <0>;
+
+				ipu2_csi0_from_csi2ipu: endpoint {
+					remote-endpoint = <&csi2ipu_to_ipu2_csi0>;
+				};
 			};
 
 			ipu2_csi1: port@1 {
 				reg = <1>;
+
+				ipu2_csi1_from_mipi_ipu2_mux: endpoint {
+					remote-endpoint = <&mipi_ipu2_mux_to_ipu2_csi1>;
+				};
 			};
 
 			ipu2_di0: port@2 {
@@ -234,6 +242,78 @@
 	};
 };
 
+&gpr {
+	mipi_ipu1_mux {
+		compatible = "video-multiplexer";
+		reg = <0x04>;
+		bit-mask = <1>;
+		bit-shift = <19>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			mipi_ipu1_mux_from_mipi_csi0: endpoint {
+				remote-endpoint = <&mipi_csi0_to_mipi_ipu1_mux>;
+			};
+		};
+
+		csi0: port@1 {
+			reg = <1>;
+		};
+
+		port@2 {
+			reg = <2>;
+
+			mipi_ipu1_mux_to_ipu1_csi0: endpoint {
+				remote-endpoint = <&ipu1_csi0_from_mipi_ipu1_mux>;
+			};
+		};
+	};
+
+	mipi_ipu2_mux {
+		compatible = "video-multiplexer";
+		reg = <0x04>;
+		bit-mask = <1>;
+		bit-shift = <20>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			mipi_ipu2_mux_from_mipi_csi3: endpoint {
+				remote-endpoint = <&mipi_csi3_to_mipi_ipu2_mux>;
+			};
+		};
+
+		csi1: port@1 {
+			reg = <1>;
+		};
+
+		port@2 {
+			reg = <2>;
+
+			mipi_ipu2_mux_to_ipu2_csi1: endpoint {
+				remote-endpoint = <&ipu2_csi1_from_mipi_ipu2_mux>;
+			};
+		};
+	};
+};
+
+&ipu1_csi1 {
+	ipu1_csi1_from_mipi_csi1: endpoint {
+		remote-endpoint = <&mipi_csi1_to_ipu1_csi1>;
+	};
+};
+
+&ipu2_csi0 {
+	ipu2_csi0_from_mipi_csi2: endpoint {
+		remote-endpoint = <&mipi_csi2_to_ipu2_csi0>;
+	};
+};
+
 &ldb {
 	clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>, <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
 		 <&clks IMX6QDL_CLK_IPU1_DI0_SEL>, <&clks IMX6QDL_CLK_IPU1_DI1_SEL>,
@@ -280,6 +360,44 @@
 	};
 };
 
+&mipi_csi {
+	port@0 {
+		reg = <0>;
+	};
+
+	port@1 {
+		reg = <1>;
+
+		mipi_csi0_to_mipi_ipu1_mux: endpoint {
+			remote-endpoint = <&mipi_ipu1_mux_from_mipi_csi0>;
+		};
+	};
+
+	port@2 {
+		reg = <2>;
+
+		mipi_csi1_to_ipu1_csi1: endpoint {
+			remote-endpoint = <&ipu1_csi1_from_mipi_csi1>;
+		};
+	};
+
+	port@3 {
+		reg = <3>;
+
+		mipi_csi2_to_ipu2_csi0: endpoint {
+			remote-endpoint = <&ipu2_csi0_from_mipi_csi2>;
+		};
+	};
+
+	port@4 {
+		reg = <4>;
+
+		mipi_csi3_to_mipi_ipu2_mux: endpoint {
+			remote-endpoint = <&mipi_ipu2_mux_from_mipi_csi3>;
+		};
+	};
+};
+
 &mipi_dsi {
 	ports {
 		port@2 {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index b13b0b2..cd325bd 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -798,8 +798,10 @@
 			};
 
 			gpr: iomuxc-gpr@020e0000 {
-				compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
+				compatible = "fsl,imx6q-iomuxc-gpr", "syscon", "simple-mfd";
 				reg = <0x020e0000 0x38>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 			};
 
 			iomuxc: iomuxc@020e0000 {
@@ -1122,6 +1124,8 @@
 
 			mipi_csi: mipi@021dc000 {
 				reg = <0x021dc000 0x4000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 			};
 
 			mipi_dsi: mipi@021e0000 {
@@ -1221,6 +1225,10 @@
 
 			ipu1_csi0: port@0 {
 				reg = <0>;
+
+				ipu1_csi0_from_mipi_ipu1_mux: endpoint {
+					remote-endpoint = <&mipi_ipu1_mux_to_ipu1_csi0>;
+				};
 			};
 
 			ipu1_csi1: port@1 {
-- 
2.9.3

