Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59135 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:39:54 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
Date: Fri, 08 Mar 2013 09:59:14 -0500
Message-id: <1362754765-2651-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the fimc-is node and the required pinctrl nodes for
fimc-is driver for Exynos5. Also adds the DT binding documentation
for the new fimc-is node.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 .../devicetree/bindings/media/soc/exynos5-is.txt   |   81 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   60 +++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   54 ++++++++++++-
 arch/arm/boot/dts/exynos5250.dtsi                  |    8 ++
 4 files changed, 201 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/exynos5-is.txt
 mode change 100644 => 100755 arch/arm/boot/dts/exynos5250-smdk5250.dts
 mode change 100644 => 100755 arch/arm/boot/dts/exynos5250.dtsi

diff --git a/Documentation/devicetree/bindings/media/soc/exynos5-is.txt b/Documentation/devicetree/bindings/media/soc/exynos5-is.txt
new file mode 100644
index 0000000..e0fdf02
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/soc/exynos5-is.txt
@@ -0,0 +1,81 @@
+Samsung EXYNOS SoC Camera Subsystem
+-----------------------------------
+
+The camera subsystem on Samsung Exynos5 SoC has some changes relative
+to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
+FIMC-LITE IPs but removed the FIMC-CAPTURE. Instead it has an improved
+FIMC-IS which can provide imate data DMA output.
+
+The device tree binding remain similar to the Exynos4 bindings which can
+be seen at samsung-fimc.txt with the addition of fimc-is sub-node which will
+be explained here.
+
+fimc-is subnode of camera node
+------------------------------
+
+Required properties:
+
+- compatible		: must be "samsung,exynos5250-fimc-is"
+- reg			: physical base address and size of the memory mapped
+			  registers
+- interrupt-parent	: Parent interrupt controller
+- interrupts		: fimc-is interrupt to the parent combiner
+
+Board specific properties:
+
+- pinctrl-names    : pinctrl names for camera port pinmux control, at least
+		     "default" needs to be specified.
+- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names
+
+Sensor sub-nodes:
+
+FIMC-IS IP supports custom built sensors to be controlled exclusively by
+the FIMC-IS firmware. These sensor properties are to be defined here.
+Sensor nodes are described in the same way as in generic sensors used in
+Exynos4 and described in samsung-fimc.txt.
+
+Example:
+
+SoC common node:
+
+		fimc_is: fimc-is@13000000 {
+			compatible = "samsung,exynos5250-fimc-is";
+			reg = <0x13000000 0x200000>;
+			interrupt-parent = <&combiner>;
+			interrupts = <19 1>;
+			status = "disabled";
+		};
+
+Board specific node:
+
+		fimc-is@13000000 {
+			status = "okay";
+			pinctrl-0 =
+				<&cam_port_a_clk_active
+				&cam_bayer_clk_active
+				&isp_uart
+				&cam_i2c0
+				&cam_i2c1>;
+			pinctrl-names = "default";
+			s5k4e5 {
+				compatible = "samsung,s5k4e5";
+				gpios = <&gpx1 2 1>;
+				clock-frequency = <24000000>;
+				port {
+					is_s5k4e5_ep: endpoint {
+						remote-endpoint = <&csis0_ep>;
+					};
+				};
+			};
+			s5k6a3 {
+				compatible = "samsung,s5k6a3";
+				gpios = <&gpx1 0 1>;
+				clock-frequency = <24000000>;
+				port {
+					is_s5k6a3_ep: endpoint {
+						remote-endpoint = <&csis1_ep>;
+					};
+				};
+			};
+		};
+
diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 3caaa21..320c22b 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -556,6 +556,38 @@
 	};
 
 	pinctrl@13400000 {
+		gpe1: gpe1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpf0: gpf0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpf1: gpf1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpg2: gpg2 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
 		gph0: gph0 {
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -594,6 +626,34 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		cam_bayer_clk_active: cam-bayer-clk-active {
+			samsung,pins = "gpg2-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		isp_uart: isp-uart {
+			samsung,pins = "gpe1-0", "gpe1-1";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_i2c0: cam-i2c0 {
+			samsung,pins = "gpf0-0", "gpf0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_i2c1: cam-i2c1 {
+			samsung,pins = "gpf0-2", "gpf0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
 	};
 
 	pinctrl_3: pinctrl@03680000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
old mode 100644
new mode 100755
index 356e014..0a2da64
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -92,6 +92,7 @@
 
 		m5mols@1f {
 			compatible = "fujitsu,m-5mols";
+			status = "disabled";
 			reg = <0x1F>;
 			gpios = <&gpx3 3 0xf>, <&gpx1 2 1>;
 			clock-frequency = <24000000>;
@@ -242,7 +243,7 @@
 
 		csis_0: csis@13C20000 {
 			status = "okay";
-			clock-frequency = <166000000>;
+			clock-frequency = <267000000>; /* s5k4e5 */
 			#address-cells = <1>;
 			#size-cells = <0>;
 
@@ -250,7 +251,7 @@
 			port@3 {
 				reg = <3>;
 				csis0_ep: endpoint {
-					remote-endpoint = <&m5mols_ep>;
+					remote-endpoint = <&is_s5k4e5_ep>;
 					data-lanes = <1 2 3 4>;
 					samsung,csis-hs-settle = <12>;
 					samsung,csis-wclk;
@@ -258,5 +259,54 @@
 			};
 		};
 
+		csis_1: csis@13C30000 {
+			status = "okay";
+			clock-frequency = <160000000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Camera D (4) MIPI CSI-2 (CSIS1) */
+			port@4 {
+				reg = <4>;
+				csis1_ep: endpoint {
+					remote-endpoint = <&is_s5k6a3_ep>;
+					data-lanes = <1>;
+					samsung,csis-hs-settle = <18>;
+					samsung,csis-wclk;
+				};
+			};
+		};
+
+		fimc-is@13000000 {
+			status = "okay";
+			pinctrl-0 =
+				<&cam_port_a_clk_active
+				&cam_bayer_clk_active
+				&isp_uart
+				&cam_i2c0
+				&cam_i2c1>;
+			pinctrl-names = "default";
+			s5k4e5 {
+				compatible = "samsung,s5k4e5";
+				gpios = <&gpx1 2 1>;
+				clock-frequency = <24000000>;
+				port {
+					is_s5k4e5_ep: endpoint {
+						remote-endpoint = <&csis0_ep>;
+					};
+				};
+			};
+			s5k6a3 {
+				compatible = "samsung,s5k6a3";
+				gpios = <&gpx1 0 1>;
+				clock-frequency = <24000000>;
+				port {
+					is_s5k6a3_ep: endpoint {
+						remote-endpoint = <&csis1_ep>;
+					};
+				};
+			};
+		};
+
 	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
old mode 100644
new mode 100755
index 564c05f..e18df49
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -410,5 +410,13 @@
 			bus-width = <2>;
 			status = "disabled";
 		};
+
+		fimc_is: fimc-is@13000000 {
+			compatible = "samsung,exynos5250-fimc-is";
+			reg = <0x13000000 0x200000>;
+			interrupt-parent = <&combiner>;
+			interrupts = <19 1>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

