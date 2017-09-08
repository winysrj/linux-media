Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35648 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754448AbdIHGDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 02:03:12 -0400
From: Hoegeun Kwon <hoegeun.kwon@samsung.com>
To: inki.dae@samsung.com, airlied@linux.ie, kgene@kernel.org,
        krzk@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mchehab@kernel.org,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, a.hajda@samsung.com,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>
Subject: [PATCH v3 6/6] ARM: dts: exynos: Remove unnecessary compatible
Date: Fri, 08 Sep 2017 15:02:40 +0900
Message-id: <1504850560-27950-7-git-send-email-hoegeun.kwon@samsung.com>
In-reply-to: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
        <CGME20170908060309epcas1p3f995a5092a5b8c7d9a9e4b6d982bc3d9@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the compatible('samsung,exynos5-gsc') is not used.
Remove unnecessary compatible.

Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi | 8 ++++----
 arch/arm/boot/dts/exynos5420.dtsi | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index bf08101..e632faf 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -637,7 +637,7 @@
 		};
 
 		gsc_0:  gsc@13e00000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
+			compatible = "samsung,exynos5250-gsc";
 			reg = <0x13e00000 0x1000>;
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&pd_gsc>;
@@ -647,7 +647,7 @@
 		};
 
 		gsc_1:  gsc@13e10000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
+			compatible = "samsung,exynos5250-gsc";
 			reg = <0x13e10000 0x1000>;
 			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&pd_gsc>;
@@ -657,7 +657,7 @@
 		};
 
 		gsc_2:  gsc@13e20000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
+			compatible = "samsung,exynos5250-gsc";
 			reg = <0x13e20000 0x1000>;
 			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&pd_gsc>;
@@ -667,7 +667,7 @@
 		};
 
 		gsc_3:  gsc@13e30000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5250-gsc";
+			compatible = "samsung,exynos5250-gsc";
 			reg = <0x13e30000 0x1000>;
 			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&pd_gsc>;
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 86afe77..58392b3 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -658,7 +658,7 @@
 		};
 
 		gsc_0: video-scaler@13e00000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5420-gsc";
+			compatible = "samsung,exynos5420-gsc";
 			reg = <0x13e00000 0x1000>;
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clock CLK_GSCL0>;
@@ -668,7 +668,7 @@
 		};
 
 		gsc_1: video-scaler@13e10000 {
-			compatible = "samsung,exynos5-gsc", "samsung,exynos5420-gsc";
+			compatible = "samsung,exynos5420-gsc";
 			reg = <0x13e10000 0x1000>;
 			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clock CLK_GSCL1>;
-- 
1.9.1
