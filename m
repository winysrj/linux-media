Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28351 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaCFQWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 11:22:33 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 10/10] ARM: dts: exynos4: Update camera clk provider and
 s5k6a3 sensor node
Date: Thu, 06 Mar 2014 17:20:19 +0100
Message-id: <1394122819-9582-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused /camera/clock-controller node and required clock properties
to the camera node. This is required for a clock provider that will be
referenced by image sensor devices.
Also add required clock related changes to s5k6a3 device node and afvdd
regulator supply.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v5:
  - none.

Changes since v4:
  - added changes at the s5k6a3 device node.
  - clock output names adjusted to better match documentation.
---
 arch/arm/boot/dts/exynos4.dtsi          |    6 ++----
 arch/arm/boot/dts/exynos4412-trats2.dts |    5 +++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 08452e1..6430a0e 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -109,12 +109,10 @@
 		status = "disabled";
 		#address-cells = <1>;
 		#size-cells = <1>;
+		#clock-cells = <1>;
+		clock-output-names = "cam_a_clkout", "cam_b_clkout";
 		ranges;
 
-		clock_cam: clock-controller {
-			 #clock-cells = <1>;
-		};
-
 		fimc_0: fimc@11800000 {
 			compatible = "samsung,exynos4210-fimc";
 			reg = <0x11800000 0x1000>;
diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 0c6afbe..d7e13a4 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -647,10 +647,11 @@
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

