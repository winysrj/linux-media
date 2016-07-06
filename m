Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33158 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbcGFXHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:51 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so105127pfb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:50 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 26/28] ARM: dts: imx6qdl: Add mipi_ipu1/2 video muxes, mipi_csi, and their connections
Date: Wed,  6 Jul 2016 16:06:56 -0700
Message-Id: <1467846418-12913-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch adds the device tree graph connecting the input multiplexers
to the IPU CSIs and the MIPI-CSI2 gasket on i.MX6.

On i.MX6Q/D two two-input multiplexers in front of IPU1 CSI0 and IPU2 CSI1
allow to select between CSI0/1 parallel input pads and the MIPI CSI-2 virtual
channels 0/3.

On i.MX6DL/S two five-input multiplexers in front of IPU1 CSI0 and IPU1 CSI1
allow to select between CSI0/1 parallel input pads and any of the four MIPI
CSI-2 virtual channels.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl.dtsi  | 183 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi   | 120 +++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi |   6 ++
 3 files changed, 309 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 9a4c22c..41ef065 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -109,6 +109,118 @@
 		compatible = "fsl,imx-gpu-subsystem";
 		cores = <&gpu_2d>, <&gpu_3d>;
 	};
+
+	ipu1_csi0_mux: ipu1_csi0_mux@34 {
+		compatible = "imx-video-mux";
+		reg = <0x34 0x07>;
+		gpr = <&gpr>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		port@0 {
+			reg = <0>;
+
+			ipu1_csi0_mux_from_mipi_vc0: endpoint {
+				remote-endpoint = <&mipi_vc0_to_ipu1_csi0_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu1_csi0_mux_from_mipi_vc1: endpoint {
+				remote-endpoint = <&mipi_vc1_to_ipu1_csi0_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu1_csi0_mux_from_mipi_vc2: endpoint {
+				remote-endpoint = <&mipi_vc2_to_ipu1_csi0_mux>;
+			};
+		};
+
+		port@3 {
+			reg = <3>;
+
+			ipu1_csi0_mux_from_mipi_vc3: endpoint {
+				remote-endpoint = <&mipi_vc3_to_ipu1_csi0_mux>;
+			};
+		};
+
+		port@4 {
+			reg = <4>;
+
+			ipu1_csi0_mux_from_parallel_sensor: endpoint {
+			};
+		};
+
+		port@5 {
+			reg = <5>;
+
+			ipu1_csi0_mux_to_ipu1_csi0: endpoint {
+				remote-endpoint = <&ipu1_csi0_from_ipu1_csi0_mux>;
+			};
+		};
+	};
+
+	ipu1_csi1_mux: ipu1_csi1_mux@34 {
+		compatible = "imx-video-mux";
+		reg = <0x34 0x38>;
+		gpr = <&gpr>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		port@0 {
+			reg = <0>;
+
+			ipu1_csi1_mux_from_mipi_vc0: endpoint {
+				remote-endpoint = <&mipi_vc0_to_ipu1_csi1_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu1_csi1_mux_from_mipi_vc1: endpoint {
+				remote-endpoint = <&mipi_vc1_to_ipu1_csi1_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu1_csi1_mux_from_mipi_vc2: endpoint {
+				remote-endpoint = <&mipi_vc2_to_ipu1_csi1_mux>;
+			};
+		};
+
+		port@3 {
+			reg = <3>;
+
+			ipu1_csi1_mux_from_mipi_vc3: endpoint {
+				remote-endpoint = <&mipi_vc3_to_ipu1_csi1_mux>;
+			};
+		};
+
+		port@4 {
+			reg = <4>;
+
+			ipu1_csi1_mux_from_parallel_sensor: endpoint {
+			};
+		};
+
+		port@5 {
+			reg = <5>;
+
+			ipu1_csi1_mux_to_ipu1_csi1: endpoint {
+				remote-endpoint = <&ipu1_csi1_from_ipu1_csi1_mux>;
+			};
+		};
+	};
 };
 
 &gpt {
@@ -131,3 +243,74 @@
 &vpu {
 	compatible = "fsl,imx6dl-vpu", "cnm,coda960";
 };
+
+&ipu1_csi1 {
+	ipu1_csi1_from_ipu1_csi1_mux: endpoint {
+		remote-endpoint = <&ipu1_csi1_mux_to_ipu1_csi1>;
+	};
+};
+
+&mipi_csi {
+	port@0 {
+		reg = <0>;
+
+		mipi_csi_from_mipi_sensor: endpoint {
+		};
+	};
+
+	port@1 {
+		reg = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_vc0_to_ipu1_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu1_csi0_mux_from_mipi_vc0>;
+		};
+
+		mipi_vc0_to_ipu1_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu1_csi1_mux_from_mipi_vc0>;
+		};
+	};
+
+	port@2 {
+		reg = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_vc1_to_ipu1_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu1_csi0_mux_from_mipi_vc1>;
+		};
+
+		mipi_vc1_to_ipu1_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu1_csi1_mux_from_mipi_vc1>;
+		};
+	};
+
+	port@3 {
+		reg = <3>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_vc2_to_ipu1_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu1_csi0_mux_from_mipi_vc2>;
+		};
+
+		mipi_vc2_to_ipu1_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu1_csi1_mux_from_mipi_vc2>;
+		};
+	};
+
+	port@4 {
+		reg = <4>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mipi_vc3_to_ipu1_csi0_mux: endpoint@0 {
+			remote-endpoint = <&ipu1_csi0_mux_from_mipi_vc3>;
+		};
+
+		mipi_vc3_to_ipu1_csi1_mux: endpoint@1 {
+			remote-endpoint = <&ipu1_csi1_mux_from_mipi_vc3>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index c30c836..9b9fc91 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -143,10 +143,18 @@
 
 			ipu2_csi0: port@0 {
 				reg = <0>;
+
+				ipu2_csi0_from_mipi_vc2: endpoint {
+					remote-endpoint = <&mipi_vc2_to_ipu2_csi0>;
+				};
 			};
 
 			ipu2_csi1: port@1 {
 				reg = <1>;
+
+				ipu2_csi1_from_ipu2_csi1_mux: endpoint {
+					remote-endpoint = <&ipu2_csi1_mux_to_ipu2_csi1>;
+				};
 			};
 
 			ipu2_di0: port@2 {
@@ -207,6 +215,71 @@
 		compatible = "fsl,imx-gpu-subsystem";
 		cores = <&gpu_2d>, <&gpu_3d>, <&gpu_vg>;
 	};
+
+
+	ipu1_csi0_mux: ipu1_csi0_mux@4 {
+		compatible = "imx-video-mux";
+		reg = <0x04 0x80000>;
+		gpr = <&gpr>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		port@0 {
+			reg = <0>;
+
+			ipu1_csi0_mux_from_mipi_vc0: endpoint {
+				remote-endpoint = <&mipi_vc0_to_ipu1_csi0_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu1_csi0_mux_from_parallel_sensor: endpoint {
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu1_csi0_mux_to_ipu1_csi0: endpoint {
+				remote-endpoint = <&ipu1_csi0_from_ipu1_csi0_mux>;
+			};
+		};
+	};
+
+	ipu2_csi1_mux: ipu2_csi1_mux@4 {
+		compatible = "imx-video-mux";
+		reg = <0x04 0x100000>;
+		gpr = <&gpr>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		port@0 {
+			reg = <0>;
+
+			ipu2_csi1_mux_from_mipi_vc3: endpoint {
+				remote-endpoint = <&mipi_vc3_to_ipu2_csi1_mux>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			ipu2_csi1_mux_from_parallel_sensor: endpoint {
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			ipu2_csi1_mux_to_ipu2_csi1: endpoint {
+				remote-endpoint = <&ipu2_csi1_from_ipu2_csi1_mux>;
+			};
+		};
+	};
 };
 
 &hdmi {
@@ -229,6 +302,12 @@
 	};
 };
 
+&ipu1_csi1 {
+	ipu1_csi1_from_mipi_vc1: endpoint {
+		remote-endpoint = <&mipi_vc1_to_ipu1_csi1>;
+	};
+};
+
 &ldb {
 	clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>, <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
 		 <&clks IMX6QDL_CLK_IPU1_DI0_SEL>, <&clks IMX6QDL_CLK_IPU1_DI1_SEL>,
@@ -275,6 +354,47 @@
 	};
 };
 
+&mipi_csi {
+	port@0 {
+		reg = <0>;
+
+		mipi_csi_from_mipi_sensor: endpoint {
+		};
+	};
+
+	port@1 {
+		reg = <1>;
+
+		mipi_vc0_to_ipu1_csi0_mux: endpoint {
+			remote-endpoint = <&ipu1_csi0_mux_from_mipi_vc0>;
+		};
+	};
+
+	port@2 {
+		reg = <2>;
+
+		mipi_vc1_to_ipu1_csi1: endpoint {
+			remote-endpoint = <&ipu1_csi1_from_mipi_vc1>;
+		};
+	};
+
+	port@3 {
+		reg = <3>;
+
+		mipi_vc2_to_ipu2_csi0: endpoint {
+			remote-endpoint = <&ipu2_csi0_from_mipi_vc2>;
+		};
+	};
+
+	port@4 {
+		reg = <4>;
+
+		mipi_vc3_to_ipu2_csi1_mux: endpoint {
+			remote-endpoint = <&ipu2_csi1_mux_from_mipi_vc3>;
+		};
+	};
+};
+
 &mipi_dsi {
 	ports {
 		port@2 {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 50499eb..838d1d5 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1121,6 +1121,8 @@
 			mipi_csi: mipi@021dc000 {
 				compatible = "fsl,imx-mipi-csi2";
 				reg = <0x021dc000 0x4000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <0 100 0x04>, <0 101 0x04>;
 				clocks = <&clks IMX6QDL_CLK_HSI_TX>,
 					 <&clks IMX6QDL_CLK_VIDEO_27M>,
@@ -1226,6 +1228,10 @@
 
 			ipu1_csi0: port@0 {
 				reg = <0>;
+
+				ipu1_csi0_from_ipu1_csi0_mux: endpoint {
+					remote-endpoint = <&ipu1_csi0_mux_to_ipu1_csi0>;
+				};
 			};
 
 			ipu1_csi1: port@1 {
-- 
1.9.1

