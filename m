Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34214 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935250AbdACU5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:57:42 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 02/19] ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their connections
Date: Tue,  3 Jan 2017 12:57:12 -0800
Message-Id: <1483477049-19056-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

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

- Removed some dangling/unused endpoints (ipu2_csi0_from_csi2ipu)
- Renamed the mipi virtual channel endpoint labels, from "mipi_csiX_..."
  to "mipi_vcX...".
- Added input endpoints to the video muxes for the connections from parallel
  sensors.
- Added input endpoints to the mipi_csi for the connections from mipi csi-2
  sensors.
- The video multiplexer node has compatible string "imx-video-mux" instead
  of "video-multiplexer".
- The video multiplexer node indicates GPR register via reg propert only,
  (register offset and bitmask), instead of specifying with "bit-mask" and
  "bit-shift" properties.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl.dtsi  | 183 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6q.dtsi   | 119 +++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi |  10 ++-
 3 files changed, 311 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
index 1ade195..0a1718c 100644
--- a/arch/arm/boot/dts/imx6dl.dtsi
+++ b/arch/arm/boot/dts/imx6dl.dtsi
@@ -181,6 +181,189 @@
 		      "di0", "di1";
 };
 
+&gpr {
+	ipu1_csi0_mux: ipu1_csi0_mux@34 {
+		compatible = "imx-video-mux";
+		reg = <0x34 0x07>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
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
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
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
+};
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
+
 &vpu {
 	compatible = "fsl,imx6dl-vpu", "cnm,coda960";
 };
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e9a5d0b..56a314f 100644
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
@@ -266,6 +274,76 @@
 	};
 };
 
+&gpr {
+	ipu1_csi0_mux: ipu1_csi0_mux@4 {
+		compatible = "imx-video-mux";
+		reg = <0x04 0x80000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
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
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
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
+};
+
+&ipu1_csi1 {
+	ipu1_csi1_from_mipi_vc1: endpoint {
+		remote-endpoint = <&mipi_vc1_to_ipu1_csi1>;
+	};
+};
+
 &ldb {
 	clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>, <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
 		 <&clks IMX6QDL_CLK_IPU1_DI0_SEL>, <&clks IMX6QDL_CLK_IPU1_DI1_SEL>,
@@ -312,6 +390,47 @@
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
index 7b546e3..89218a4 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -799,8 +799,10 @@
 			};
 
 			gpr: iomuxc-gpr@020e0000 {
-				compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
+				compatible = "fsl,imx6q-iomuxc-gpr", "syscon", "simple-mfd";
 				reg = <0x020e0000 0x38>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 			};
 
 			iomuxc: iomuxc@020e0000 {
@@ -1127,6 +1129,8 @@
 			mipi_csi: mipi@021dc000 {
 				compatible = "fsl,imx-mipi-csi2";
 				reg = <0x021dc000 0x4000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <0 100 0x04>, <0 101 0x04>;
 				clocks = <&clks IMX6QDL_CLK_HSI_TX>,
 					 <&clks IMX6QDL_CLK_VIDEO_27M>,
@@ -1232,6 +1236,10 @@
 
 			ipu1_csi0: port@0 {
 				reg = <0>;
+
+				ipu1_csi0_from_ipu1_csi0_mux: endpoint {
+					remote-endpoint = <&ipu1_csi0_mux_to_ipu1_csi0>;
+				};
 			};
 
 			ipu1_csi1: port@1 {
-- 
2.7.4

