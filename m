Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55409 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab3BATKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 14:10:25 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com,
	swarren@wwwdotorg.org, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 10/10] ARM: dts: Correct camera pinctrl nodes for Exynos4x12
 SoCs
Date: Fri, 01 Feb 2013 20:09:31 +0100
Message-id: <1359745771-23684-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com>
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add separate nodes for the CAMCLK pin and turn off pull-up on camera
ports A, B. The video bus pins and the clock output (CAMCLK) pin need
separate nodes since full camera port is not used in some configurations,
e.g. for MIPI CSI-2 bus on CAMCLK is required and data/clock signal
use separate dedicated pins.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Changes since v3:
  - corrected camera port B part and removed entries for
    "inactive" state
---
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
index 8e6115a..4c3a2c3 100644
--- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
@@ -401,15 +401,21 @@
 			samsung,pin-drv = <0>;
 		};
 
-		cam_port_a: cam-port-a {
+		cam_port_a_io: cam-port-a-io {
 			samsung,pins = "gpj0-0", "gpj0-1", "gpj0-2", "gpj0-3",
 					"gpj0-4", "gpj0-5", "gpj0-6", "gpj0-7",
-					"gpj1-0", "gpj1-1", "gpj1-2", "gpj1-3",
-					"gpj1-4";
+					"gpj1-0", "gpj1-1", "gpj1-2", "gpj1-4";
 			samsung,pin-function = <2>;
-			samsung,pin-pud = <3>;
+			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		cam_port_a_clk_active: cam-port-a-clk-active {
+			samsung,pins = "gpj1-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
 	};
 
 	pinctrl@11000000 {
@@ -834,16 +840,22 @@
 			samsung,pin-drv = <0>;
 		};
 
-		cam_port_b: cam-port-b {
+		cam_port_b_io: cam-port-b-io {
 			samsung,pins = "gpm0-0", "gpm0-1", "gpm0-2", "gpm0-3",
 					"gpm0-4", "gpm0-5", "gpm0-6", "gpm0-7",
-					"gpm1-0", "gpm1-1", "gpm2-0", "gpm2-1",
-					"gpm2-2";
+					"gpm1-0", "gpm1-1", "gpm2-0", "gpm2-1";
 			samsung,pin-function = <3>;
 			samsung,pin-pud = <3>;
 			samsung,pin-drv = <0>;
 		};
 
+		cam_port_b_clk_active: cam-port-b-clk-active {
+			samsung,pins = "gpm2-2";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <3>;
+		};
+
 		eint0: ext-int0 {
 			samsung,pins = "gpx0-0";
 			samsung,pin-function = <0xf>;
-- 
1.7.9.5

