Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55668 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcFGMDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 08:03:48 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 2/3] ARM: dts: exynos: move MFC reserved memory regions from
 boards to .dtsi
Date: Tue, 07 Jun 2016 14:03:37 +0200
Message-id: <1465301018-9671-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
 <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves assigning reserved memory regions from each board dts
to common exynos-mfc-reserved-memory.dtsi file, where those regions are
defined.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi  | 4 ++++
 arch/arm/boot/dts/exynos4210-origen.dts            | 1 -
 arch/arm/boot/dts/exynos4210-smdkv310.dts          | 1 -
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    | 1 -
 arch/arm/boot/dts/exynos4412-origen.dts            | 1 -
 arch/arm/boot/dts/exynos4412-smdk4412.dts          | 1 -
 arch/arm/boot/dts/exynos5250-arndale.dts           | 4 ----
 arch/arm/boot/dts/exynos5250-smdk5250.dts          | 4 ----
 arch/arm/boot/dts/exynos5250-spring.dts            | 4 ----
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      | 4 ----
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 4 ----
 arch/arm/boot/dts/exynos5420-smdk5420.dts          | 4 ----
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 4 ----
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 4 ----
 14 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
index da3ced9..f78c14c 100644
--- a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
+++ b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
@@ -29,3 +29,7 @@
 		};
 	};
 };
+
+&mfc {
+	memory-region = <&mfc_left>, <&mfc_right>;
+};
diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index f5e4eb2..07a00dd 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -289,7 +289,6 @@
 };
 
 &mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index de917f0..2fab072 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -134,7 +134,6 @@
 };
 
 &mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index 13972ca..b3c95d2 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -510,7 +510,6 @@
 };
 
 &mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 2959fc8..547ae04 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -483,7 +483,6 @@
 };
 
 &mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos4412-smdk4412.dts b/arch/arm/boot/dts/exynos4412-smdk4412.dts
index 9b6d561..d4f9383 100644
--- a/arch/arm/boot/dts/exynos4412-smdk4412.dts
+++ b/arch/arm/boot/dts/exynos4412-smdk4412.dts
@@ -113,7 +113,6 @@
 };
 
 &mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 39940f4..ea70603 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -516,10 +516,6 @@
 	status = "okay";
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 9fac874..381af13 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -344,10 +344,6 @@
 	status = "okay";
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index 784130b..44f4292 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -425,10 +425,6 @@
 	status = "okay";
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index b8b5f3a..39a3b81 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -347,10 +347,6 @@
 	};
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	broken-cd;
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 5bd3f07..fe57423 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -689,10 +689,6 @@
 	status = "okay";
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 5206f41..ed8f342 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -355,10 +355,6 @@
 	};
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	broken-cd;
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index d52a80f..d562530 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -495,10 +495,6 @@
 	};
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	mmc-pwrseq = <&emmc_pwrseq>;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 65482b7..5ec71e2 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -664,10 +664,6 @@
 	status = "okay";
 };
 
-&mfc {
-	memory-region = <&mfc_left>, <&mfc_right>;
-};
-
 &mmc_0 {
 	status = "okay";
 	num-slots = <1>;
-- 
1.9.2

