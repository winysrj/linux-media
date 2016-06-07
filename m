Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31790 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbcFGMDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 08:03:49 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 3/3] ARM: dts: exynos: enable MFC device for all boards
Date: Tue, 07 Jun 2016 14:03:38 +0200
Message-id: <1465301018-9671-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
 <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC device can be used without any external hardware dependencies (when
IOMMU is enabled), so it can be enabled by default (like it has been
already done for Exynos 542x platforms). This unifies handling of this
device for Exynos3250, Exynos4 and Exynos542x platforms. Board can still
include exynos-mfc-reserved-memory.dtsi to enable using this device
without IOMMU being enabled.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts         | 4 ----
 arch/arm/boot/dts/exynos3250.dtsi               | 1 -
 arch/arm/boot/dts/exynos4.dtsi                  | 1 -
 arch/arm/boot/dts/exynos4210-origen.dts         | 4 ----
 arch/arm/boot/dts/exynos4210-smdkv310.dts       | 4 ----
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 4 ----
 arch/arm/boot/dts/exynos4412-origen.dts         | 4 ----
 arch/arm/boot/dts/exynos4412-smdk4412.dts       | 4 ----
 8 files changed, 26 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index e4228195..a921813 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -632,10 +632,6 @@
 	status = "okay";
 };
 
-&mfc {
-	status = "okay";
-};
-
 &jpeg {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 62f3dcd..70e3ace 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -431,7 +431,6 @@
 			clocks = <&cmu CLK_MFC>, <&cmu CLK_SCLK_MFC>;
 			power-domains = <&pd_mfc>;
 			iommus = <&sysmmu_mfc>;
-			status = "disabled";
 		};
 
 		sysmmu_mfc: sysmmu@13620000 {
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index ca8f3e3..32f22e1 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -428,7 +428,6 @@
 		clock-names = "mfc", "sclk_mfc";
 		iommus = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
 		iommu-names = "left", "right";
-		status = "disabled";
 	};
 
 	serial_0: serial@13800000 {
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index 07a00dd..be2751e 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -288,10 +288,6 @@
 	};
 };
 
-&mfc {
-	status = "okay";
-};
-
 &sdhci_0 {
 	bus-width = <4>;
 	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4 &sd0_cd>;
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 2fab072..847fae3 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -133,10 +133,6 @@
 	};
 };
 
-&mfc {
-	status = "okay";
-};
-
 &pinctrl_1 {
 	keypad_rows: keypad-rows {
 		samsung,pins = "gpx2-0", "gpx2-1";
diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index b3c95d2..58ad48e7 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -509,10 +509,6 @@
 	clock-names = "iis", "i2s_opclk0", "i2s_opclk1";
 };
 
-&mfc {
-	status = "okay";
-};
-
 &mixer {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 547ae04..26a36fe 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -482,10 +482,6 @@
 	};
 };
 
-&mfc {
-	status = "okay";
-};
-
 &mshc_0 {
 	pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index d4f9383..231ffbd 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -112,10 +112,6 @@
 	};
 };
 
-&mfc {
-	status = "okay";
-};
-
 &pinctrl_1 {
 	keypad_rows: keypad-rows {
 		samsung,pins = "gpx2-0", "gpx2-1", "gpx2-2";
-- 
1.9.2

