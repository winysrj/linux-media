Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58405 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaEHRh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 13:37:57 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 4/4] ARM: dts: exynos4: Remove simple-bus compatibles from
 the camera subsystem
Date: Thu, 08 May 2014 19:37:39 +0200
Message-id: <1399570659-29864-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usage of "simple-bus" was incorrect and the drivers now will also
work without it so remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    |    2 +-
 arch/arm/boot/dts/exynos4x12.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 2f8bcd0..bfb0e73 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -125,7 +125,7 @@
 	};
 
 	camera {
-		compatible = "samsung,fimc", "simple-bus";
+		compatible = "samsung,fimc";
 		status = "disabled";
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index c4a9306..0cabb74 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -188,7 +188,7 @@
 		};
 
 		fimc_is: fimc-is@12000000 {
-			compatible = "samsung,exynos4212-fimc-is", "simple-bus";
+			compatible = "samsung,exynos4212-fimc-is";
 			reg = <0x12000000 0x260000>;
 			interrupts = <0 90 0>, <0 95 0>;
 			samsung,power-domain = <&pd_isp>;
-- 
1.7.9.5

