Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2LaQEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:33 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 15/15] ARM: dts: Add camera device nodes nodes for PQ
 board
Date: Mon, 31 Dec 2012 17:03:13 +0100
Message-id: <1356969793-27268-16-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds all nodes for camera devices on example Exynos4412 SoC
based board. This is all what's required in the board dts file to enable
rear facing camera (S5C73M3 sensor).

The aliases node contains entries required for the camera processing
data path entity drivers.

The sensor nodes use standard port/remote-endpoint nodes convention.
Internal SoC links between entities are not specified this way and
are coded in the driver instead, as it seemed more reasonable.

The S5C73M3 sensor uses two control buses: I2C and SPI. There are
two, i2c_0 and spi_1 bus controller child nodes assigned to it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4412-slp_pq.dts |  133 +++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-slp_pq.dts b/arch/arm/boot/dts/exynos4412-slp_pq.dts
index 3a5782d..97a4c2c 100644
--- a/arch/arm/boot/dts/exynos4412-slp_pq.dts
+++ b/arch/arm/boot/dts/exynos4412-slp_pq.dts
@@ -101,6 +101,34 @@
 		};
 	};
 
+	i2c_0: i2c@13860000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <400000>;
+		pinctrl-0 = <&i2c0_bus>;
+		status = "okay";
+
+		s5c73m3@3c {
+			compatible = "samsung,s5c73m3";
+			reg = <0x3c>;
+			gpios = <&gpm0 1 1>, /* ISP_STANDBY */
+				<&gpf1 3 1>; /* ISP_RESET */
+			vdd-int-supply = <&buck9_reg>;
+			vddio-cis-supply = <&ldo9_reg>;
+			vdda-supply = <&ldo17_reg>;
+			vddio-host-supply = <&ldo18_reg>;
+			vdd-af-supply = <&cam_af_reg>;
+			vdd-reg-supply = <&cam_io_reg>;
+			clock-frequency = <24000000>;
+
+			port {
+				s5c73m3_ep: endpoint {
+					remote-endpoint = <&csis0_ep>;
+				};
+			};
+		};
+	};
+
 	i2c@13890000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -411,6 +439,34 @@
 		enable-active-high;
 	};
 
+	cam_af_reg: voltage-regulator@2 {
+	        compatible = "regulator-fixed";
+		regulator-name = "CAM_AF";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		gpio = <&gpm0 4 0>;
+		enable-active-high;
+	};
+
+	cam_io_reg: voltage-regulator@3 {
+	        compatible = "regulator-fixed";
+		regulator-name = "CAM_SENSOR_A";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		gpio = <&gpm0 2 0>;
+		enable-active-high;
+	};
+
+	cam_isp_core_reg: voltage-regulator@4 {
+	        compatible = "regulator-fixed";
+		regulator-name = "CAM_ISP_CORE_1.2V_EN";
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <1200000>;
+		gpio = <&gpm0 3 0>;
+		enable-active-high;
+		regulator-always-on;
+	};
+
 	fimd0_lcd: panel {
 		compatible = "s6e8ax0";
 		reset-gpio = <&gpy4 5 0>;
@@ -462,4 +518,81 @@
 		vusb_d-supply = <&ldo15_reg>;
 		vusb_a-supply = <&ldo12_reg>;
 	};
+
+	spi_1: spi@13930000 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi1_bus>;
+		status = "okay";
+
+		s5c73m3_spi: s5c73m3 {
+			compatible = "samsung,s5c73m3";
+			spi-max-frequency = <50000000>;
+			reg = <0>;
+			controller-data {
+				cs-gpio = <&gpb 5 0>;
+				samsung,spi-feedback-delay = <2>;
+			};
+		};
+	};
+
+	camera {
+		compatible = "samsung,fimc", "simple-bus";
+		status = "okay";
+
+		pinctrl-names = "default", "inactive";
+		pinctrl-0 = <&cam_port_a_clk_active>;
+		pinctrl-1 = <&cam_port_a_clk_idle>;
+
+		fimc_0: fimc@11800000 {
+			status = "okay";
+		};
+
+		fimc_1: fimc@11810000 {
+			status = "okay";
+		};
+
+		fimc_2: fimc@11820000 {
+			status = "okay";
+		};
+
+		fimc_3: fimc@11830000 {
+			status = "okay";
+		};
+
+		csis_0: csis@11880000 {
+			status = "okay";
+			vddcore-supply = <&ldo8_reg>;
+			vddio-supply = <&ldo10_reg>;
+			clock-frequency = <160000000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port {
+				reg = <3>;  /* Camera C(3) MIPI */
+				csis0_ep: endpoint {
+					remote-endpoint = <&s5c73m3_ep>;
+					data-lanes = <1>, <2>, <3>, <4>;
+					samsung,csis-hs-settle = <12>;
+				};
+			};
+		};
+
+		csis_1: csis@11890000 {
+			vddcore-supply = <&ldo8_reg>;
+			vddio-supply = <&ldo10_reg>;
+			samsung,csis-hs-settle = <18>;
+			data-lanes = <1>;
+		};
+
+		fimc-is@12000000 {
+			status = "okay";
+
+			fimc_lite_0: fimc_lite@12390000 {
+				status = "okay";
+			};
+
+			fimc_lite_1: fimc_lite@123A0000 {
+				status = "okay";
+			};
+		};
+	};
 };
-- 
1.7.9.5

