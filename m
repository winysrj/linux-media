Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35976 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab3CFLzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:55:03 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 10/12] ARM: dts: Adding media device nodes to Exynos5 SoCs
Date: Wed,  6 Mar 2013 17:23:56 +0530
Message-Id: <1362570838-4737-11-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the media device driver specific dt bindings
to the Exynos5 specific SoCs.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   64 +++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index e09cda0..564c05f 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -370,37 +370,45 @@
 		interrupts = <0 94 0>;
 	};
 
-	csis_0: csis@13C20000 {
-		compatible = "samsung,exynos5250-csis";
-		reg = <0x13C20000 0x4000>;
-		interrupts = <0 79 0>;
-		bus-width = <4>;
-		status = "disabled";
-	};
+	camera {
+		compatible = "samsung,exynos5-fimc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
 
-	csis_1: csis@13C30000 {
-		compatible = "samsung,exynos5250-csis";
-		reg = <0x13C30000 0x4000>;
-		interrupts = <0 80 0>;
-		bus-width = <4>;
-		status = "disabled";
-	};
+		fimc_lite_0: fimc-lite@13C00000 {
+			compatible = "samsung,exynos5250-fimc-lite";
+			reg = <0x13C00000 0x1000>;
+			interrupts = <0 125 0>;
+		};
 
-	fimc_lite_0: fimc-lite@13C00000 {
-		compatible = "samsung,exynos5250-fimc-lite";
-		reg = <0x13C00000 0x1000>;
-		interrupts = <0 125 0>;
-	};
+		fimc_lite_1: fimc-lite@13C10000 {
+			compatible = "samsung,exynos5250-fimc-lite";
+			reg = <0x13C10000 0x1000>;
+			interrupts = <0 126 0>;
+		};
 
-	fimc_lite_1: fimc-lite@13C10000 {
-		compatible = "samsung,exynos5250-fimc-lite";
-		reg = <0x13C10000 0x1000>;
-		interrupts = <0 126 0>;
-	};
+		fimc_lite_2: fimc-lite@13C90000 {
+			compatible = "samsung,exynos5250-fimc-lite";
+			reg = <0x13C90000 0x1000>;
+			interrupts = <0 110 0>;
+		};
 
-	fimc_lite_2: fimc-lite@13C90000 {
-		compatible = "samsung,exynos5250-fimc-lite";
-		reg = <0x13C90000 0x1000>;
-		interrupts = <0 110 0>;
+		csis_0: csis@13C20000 {
+			compatible = "samsung,exynos5250-csis";
+			reg = <0x13C20000 0x4000>;
+			interrupts = <0 79 0>;
+			bus-width = <4>;
+			clock-names = "csis", "sclk_csis", "mux", "parent";
+			status = "disabled";
+		};
+
+		csis_1: csis@13C30000 {
+			compatible = "samsung,exynos5250-csis";
+			reg = <0x13C30000 0x4000>;
+			interrupts = <0 80 0>;
+			bus-width = <2>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

