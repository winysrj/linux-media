Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60906 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaBTTlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:41:36 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 09/10] ARM: dts: Add rear camera nodes for Exynos4412 TRATS2
 board
Date: Thu, 20 Feb 2014 20:40:36 +0100
Message-id: <1392925237-31394-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enables the rear facing camera (s5c73m3) on TRATS2 board
by adding the I2C0 bus controller, s5c73m3 sensor, MIPI CSI-2 receiver
and the sensor's voltage regulator supply nodes.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |   86 +++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 4f851cc..d7e13a4 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -71,7 +71,33 @@
 			enable-active-high;
 		};
 
-		/* More to come */
+		cam_af_reg: voltage-regulator-2 {
+			compatible = "regulator-fixed";
+			regulator-name = "CAM_AF";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			gpio = <&gpm0 4 0>;
+			enable-active-high;
+		};
+
+		cam_isp_core_reg: voltage-regulator-3 {
+			compatible = "regulator-fixed";
+			regulator-name = "CAM_ISP_CORE_1.2V_EN";
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+			gpio = <&gpm0 3 0>;
+			enable-active-high;
+			regulator-always-on;
+		};
+
+		lcd_vdd3_reg: voltage-regulator-4 {
+			compatible = "regulator-fixed";
+			regulator-name = "LCD_VDD_2.2V";
+			regulator-min-microvolt = <2200000>;
+			regulator-max-microvolt = <2200000>;
+			gpio = <&gpc0 1 0>;
+			enable-active-high;
+		};
 	};
 
 	gpio-keys {
@@ -106,6 +132,38 @@
 		};
 	};
 
+	i2c_0: i2c@13860000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <400000>;
+		pinctrl-0 = <&i2c0_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		s5c73m3@3c {
+			compatible = "samsung,s5c73m3";
+			reg = <0x3c>;
+			standby-gpios = <&gpm0 1 1>;   /* ISP_STANDBY */
+			xshutdown-gpios = <&gpf1 3 1>; /* ISP_RESET */
+			vdd-int-supply = <&buck9_reg>;
+			vddio-cis-supply = <&ldo9_reg>;
+			vdda-supply = <&ldo17_reg>;
+			vddio-host-supply = <&ldo18_reg>;
+			vdd-af-supply = <&cam_af_reg>;
+			vdd-reg-supply = <&cam_io_reg>;
+			clock-frequency = <24000000>;
+			/* CAM_A_CLKOUT */
+			clocks = <&camera 0>;
+			clock-names = "cis_extclk";
+			port {
+				s5c73m3_ep: endpoint {
+					remote-endpoint = <&csis0_ep>;
+					data-lanes = <1 2 3 4>;
+				};
+			};
+		};
+	};
+
 	i2c@13890000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -511,8 +569,8 @@
 		};
 	};
 
-	camera {
-		pinctrl-0 = <&cam_port_b_clk_active>;
+	camera: camera {
+		pinctrl-0 = <&cam_port_a_clk_active &cam_port_b_clk_active>;
 		pinctrl-names = "default";
 		status = "okay";
 
@@ -532,6 +590,23 @@
 			status = "okay";
 		};
 
+		csis_0: csis@11880000 {
+			status = "okay";
+			vddcore-supply = <&ldo8_reg>;
+			vddio-supply = <&ldo10_reg>;
+			clock-frequency = <176000000>;
+
+			/* Camera C (3) MIPI CSI-2 (CSIS0) */
+			port@3 {
+				reg = <3>;
+				csis0_ep: endpoint {
+					remote-endpoint = <&s5c73m3_ep>;
+					data-lanes = <1 2 3 4>;
+					samsung,csis-hs-settle = <12>;
+				};
+			};
+		};
+
 		csis_1: csis@11890000 {
 			vddcore-supply = <&ldo8_reg>;
 			vddio-supply = <&ldo10_reg>;
@@ -572,10 +647,11 @@
 					reg = <0x10>;
 					svdda-supply = <&cam_io_reg>;
 					svddio-supply = <&ldo19_reg>;
+					afvdd-supply = <&ldo19_reg>;
 					clock-frequency = <24000000>;
 					/* CAM_B_CLKOUT */
-					clocks = <&clock_cam 1>;
-					clock-names = "mclk";
+					clocks = <&camera 1>;
+					clock-names = "extclk";
 					samsung,camclk-out = <1>;
 					gpios = <&gpm1 6 0>;
 
-- 
1.7.9.5

