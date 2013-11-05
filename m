Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57491 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3KEMNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:13:34 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v12 01/12] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings documentation
Date: Tue,  5 Nov 2013 17:43:18 +0530
Message-Id: <1383653610-11835-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
References: <1383653610-11835-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds the DT binding documentation for Samsung
Exynos5 SoC series imaging subsystem (FIMC-IS).

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 .../devicetree/bindings/media/exynos5-fimc-is.txt  |  113 ++++++++++++++++++++
 1 file changed, 113 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt

diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
new file mode 100644
index 0000000..658d4a9
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
@@ -0,0 +1,113 @@
+Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
+------------------------------------------------------
+
+The camera subsystem on Samsung Exynos5 SoC has some changes relative
+to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
+FIMC-LITE IPs but has a much improved version of FIMC-IS which can
+handle sensor controls and camera post-processing operations. The
+Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
+post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
+dedicated scalers (SCC and SCP).
+
+fimc-is node
+------------
+
+Required properties:
+
+- compatible        : should contain "samsung,exynos5250-fimc-is"
+- reg               : physical base address and size of the memory mapped
+                      registers
+- interrupts        : interrupt-specifier for the fimc-is interrupt
+- clocks            : list of clock specifiers, corresponding to entries in
+                      clock-names property
+- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
+                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
+                      matching entries in the clocks property
+- samsung,pmu       : phandle to the Power Management Unit (PMU) node
+
+i2c-isp (ISP I2C bus controller) nodes
+--------------------------------------
+The i2c-isp nodes should be children of the fimc-is node.
+
+Required properties:
+
+- compatible	: must contain "samsung,exynos4212-i2c-isp" for Exynos4212,
+		  Exynos4412 and Exynos5250 SoCs
+- reg		: physical base address and length of the registers set
+- clocks	: should contain gate clock specifier for this controller
+- clock-names	: should contain "i2c_isp" for the gate clock
+- pinctrl-0	: phandle of the pinctrl node for the i2c isp
+- pinctrl-names : must contain "default"
+
+ranges, #address-cells, and #size-cells should be present as appropriate.
+
+Device tree nodes of the image sensors controlled directly by the FIMC-IS
+firmware must be child nodes of their corresponding ISP I2C bus controller node.
+The data link of these image sensors must be specified using the common video
+interfaces bindings, defined in video-interfaces.txt.
+
+Example:
+
+	fimc_is: fimc-is@13000000 {
+		compatible = "samsung,exynos5250-fimc-is";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		reg = <0x13000000 0x200000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <19 1>;
+		clocks = <&clock 346>, <&clock 347>, <&clock 512>,
+			<&clock 513>, <&clock 514>, <&clock 515>,
+			<&clock 516>;
+		clock-names = "isp", "mcu_isp", "isp_div0", "isp_div1",
+				"isp_divmpwm", "mcu_isp_div0",
+				"mcu_isp_div1";
+		samsung,pmu = <&pmu>;
+
+		i2c0_isp: i2c-isp@13130000 {
+			compatible = "samsung,exynos4212-i2c-isp";
+			reg = <0x13130000 0x100>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clock 352>;
+			clock-names = "i2c_isp";
+			pinctrl-0 = <&cam_i2c0_bus>;
+			pinctrl-names = "default";
+		};
+
+		i2c1_isp: i2c-isp@13140000 {
+			compatible = "samsung,exynos4212-i2c-isp";
+			reg = <0x13140000 0x100>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			clocks = <&clock 353>;
+			clock-names = "i2c_isp";
+			pinctrl-0 = <&cam_i2c1_bus>;
+			pinctrl-names = "default";
+		};
+	};
+
+In the board specific file the sensor nodes can be provided. For the sensor
+node documentation for s5k4e5, please refer to samsung-s5k4e5.txt
+
+	fimc-is@13000000 {
+		status = "okay";
+
+		i2c-isp@13130000 {
+			s5k4e5@20 {
+				compatible = "samsung,s5k4e5";
+				reg = <0x20>;
+				reset-gpios = <&gpx1 2 1>;
+				clock-frequency = <24000000>;
+				clocks = <&clock 129>;
+				clock-names = "extclk";
+				svdda-supply = <&vdd>;
+				svddio-supply = <&vdd>;
+				port {
+					is_s5k4e5_ep: endpoint {
+						remote-endpoint = <&csis0_ep>;
+					};
+				};
+			};
+		};
+	};
-- 
1.7.9.5

