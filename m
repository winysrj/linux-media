Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51046 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab3CFLyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:55 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 08/12] ARM: dts: add camera specific pinctrl nodes for Exynos5250 SoC
Date: Wed,  6 Mar 2013 17:23:54 +0530
Message-Id: <1362570838-4737-9-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device nodes for pinctrl group-1 for Exynos5250 SoC.
This only adds cam1 specific pinctrl nodes to the file.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi |   41 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi         |    7 +++++
 2 files changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 24180fc..3caaa21 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -555,6 +555,47 @@
 		};
 	};
 
+	pinctrl@13400000 {
+		gph0: gph0 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gph1: gph1 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		cam_port_a_io: cam-port-a-io {
+			samsung,pins = "gph0-0", "gph0-1", "gph0-2", "gph0-3",
+				"gph1-0", "gph1-1", "gph1-2", "gph1-3",
+				"gph1-4", "gph1-5", "gph1-6", "gph1-7";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_port_a_clk_active: cam-port-a-clk-active {
+			samsung,pins = "gph0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
+		cam_port_a_clk_idle: cam-port-a-clk-idle {
+			samsung,pins = "gph0-3";
+			samsung,pin-function = <0>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+	};
+
 	pinctrl_3: pinctrl@03680000 {
 		gpz: gpz {
 			gpio-controller;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 4754865..e09cda0 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -37,6 +37,7 @@
 		mshc2 = &dwmmc_2;
 		mshc3 = &dwmmc_3;
 		pinctrl0 = &pinctrl_0;
+		pinctrl1 = &pinctrl_1;
 		pinctrl3 = &pinctrl_3;
 		i2c0 = &i2c_0;
 		i2c1 = &i2c_1;
@@ -95,6 +96,12 @@
 		};
 	};
 
+	pinctrl_1: pinctrl@13400000 {
+		compatible = "samsung,pinctrl-exynos5250";
+		reg = <0x13400000 0x1000>;
+		interrupts = <0 47 0>;
+	};
+
 	pinctrl_3: pinctrl@03680000 {
 		compatible = "samsung,pinctrl-exynos5250";
 		reg = <0x0368000 0x1000>;
-- 
1.7.9.5

