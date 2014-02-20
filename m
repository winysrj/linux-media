Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60914 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaBTTlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:41:40 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 10/10] ARM: dts: exynos4: Update clk provider part of the
 camera subsystem
Date: Thu, 20 Feb 2014 20:40:37 +0100
Message-id: <1392925237-31394-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused /camera/clock-controller node and required clock properties
to the camera node. This is required for a clock provider that will be
referenced by image sensor devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 08452e1..d1ee347 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -109,12 +109,10 @@
 		status = "disabled";
 		#address-cells = <1>;
 		#size-cells = <1>;
+		#clock-cells = <1>;
+		clock-output-names = "cam_mclk_a", "cam_mclk_b";
 		ranges;
 
-		clock_cam: clock-controller {
-			 #clock-cells = <1>;
-		};
-
 		fimc_0: fimc@11800000 {
 			compatible = "samsung,exynos4210-fimc";
 			reg = <0x11800000 0x1000>;
-- 
1.7.9.5

