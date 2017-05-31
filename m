Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26349 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdEaLAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 07:00:34 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] ARM: dts: exynos: Add HDMI CEC device to Exynos5 SoC family
Date: Wed, 31 May 2017 13:00:17 +0200
Message-id: <1496228417-31126-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170531110029eucas1p14bb9468f72155d88364c0aa5093ac05d@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos5250 and Exynos542x SoCs have the same CEC hardware module as
Exynos4 SoC series, so enable support for it using the same compatible
string.

Tested on Odroid XU3 (Exynos5422) and Google Snow (Exynos5250) boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |  7 +++++++
 arch/arm/boot/dts/exynos5250-snow-common.dtsi      |  4 ++++
 arch/arm/boot/dts/exynos5250.dtsi                  | 13 +++++++++++++
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi          |  7 +++++++
 arch/arm/boot/dts/exynos5420.dtsi                  | 13 +++++++++++++
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  4 ++++
 6 files changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 2f6ab32b5954..1fd122db18e6 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -589,6 +589,13 @@
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
 	};
+
+	hdmi_cec: hdmi-cec {
+		samsung,pins = "gpx3-6";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_3>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
+	};
 };
 
 &pinctrl_1 {
diff --git a/arch/arm/boot/dts/exynos5250-snow-common.dtsi b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
index 8f3a80430748..e1d293dbbe5d 100644
--- a/arch/arm/boot/dts/exynos5250-snow-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-snow-common.dtsi
@@ -272,6 +272,10 @@
 	vdd_pll-supply = <&ldo8_reg>;
 };
 
+&hdmicec {
+	status = "okay";
+};
+
 &i2c_0 {
 	status = "okay";
 	samsung,i2c-sda-delay = <100>;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 79c9c885613a..fbdc1d53a2ce 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -689,6 +689,19 @@
 			samsung,syscon-phandle = <&pmu_system_controller>;
 		};
 
+		hdmicec: cec@101B0000 {
+			compatible = "samsung,s5p-cec";
+			reg = <0x101B0000 0x200>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clock CLK_HDMI_CEC>;
+			clock-names = "hdmicec";
+			samsung,syscon-phandle = <&pmu_system_controller>;
+			hdmi-phandle = <&hdmi>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hdmi_cec>;
+			status = "disabled";
+		};
+
 		mixer@14450000 {
 			compatible = "samsung,exynos5250-mixer";
 			reg = <0x14450000 0x10000>;
diff --git a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
index 3924b4fafe72..65aa0e300c23 100644
--- a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
@@ -67,6 +67,13 @@
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
 	};
+
+	hdmi_cec: hdmi-cec {
+		samsung,pins = "gpx3-6";
+		samsung,pin-function = <EXYNOS_PIN_FUNC_3>;
+		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
+		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
+	};
 };
 
 &pinctrl_1 {
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 0db0bcf8da36..acd77b10b3df 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -624,6 +624,19 @@
 			reg = <0x145D0000 0x20>;
 		};
 
+		hdmicec: cec@101B0000 {
+			compatible = "samsung,s5p-cec";
+			reg = <0x101B0000 0x200>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clock CLK_HDMI_CEC>;
+			clock-names = "hdmicec";
+			samsung,syscon-phandle = <&pmu_system_controller>;
+			hdmi-phandle = <&hdmi>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&hdmi_cec>;
+			status = "disabled";
+		};
+
 		mixer: mixer@14450000 {
 			compatible = "samsung,exynos5420-mixer";
 			reg = <0x14450000 0x10000>;
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index 05b9afdd6757..01d6ac99e974 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -265,6 +265,10 @@
 	vdd-supply = <&ldo6_reg>;
 };
 
+&hdmicec {
+	status = "okay";
+};
+
 &hsi2c_4 {
 	status = "okay";
 
-- 
1.9.1
