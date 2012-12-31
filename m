Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15730 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2LaQEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:24 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 13/15] ARM: dts: Add FIMC and MIPI CSIS device nodes for
 Exynos4x12
Date: Mon, 31 Dec 2012 17:03:11 +0100
Message-id: <1356969793-27268-14-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add common camera node and fimc nodes specific to Exynos4212 and
Exynos4412 SoCs. fimc-is is a node for the Exynos4x12 FIMC-IS
subsystem and fimc-lite nodes are created as its child nodes,
among others due to FIMC-LITE device dependencies on FIMC-IS
related clocks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi |   47 +++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 9c809b72..06fde30 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -26,6 +26,8 @@
 		pinctrl1 = &pinctrl_1;
 		pinctrl2 = &pinctrl_2;
 		pinctrl3 = &pinctrl_3;
+		fimc-lite0 = &fimc_lite_0;
+		fimc-lite1 = &fimc_lite_1;
 	};
 
 	pd_isp: isp-power-domain@10023CA0 {
@@ -71,4 +73,49 @@
 		reg = <0x106E0000 0x1000>;
 		interrupts = <0 72 0>;
 	};
+
+	camera {
+		fimc_0: fimc@11800000 {
+			compatible = "samsung,exynos4212-fimc";
+		};
+
+		fimc_1: fimc@11810000 {
+			compatible = "samsung,exynos4212-fimc";
+		};
+
+		fimc_2: fimc@11820000 {
+			compatible = "samsung,exynos4212-fimc";
+		};
+
+		fimc_3: fimc@11830000 {
+			compatible = "samsung,exynos4212-fimc";
+		};
+
+		fimc_is: fimc-is@12000000 {
+			compatible = "samsung,exynos4212-fimc-is", "simple-bus";
+			reg = <0x12000000 0x260000>;
+			interrupts = <0 90 0>, <0 95 0>;
+			power-domain = <&pd_isp>;
+			status = "disabled";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			fimc_lite_0: fimc_lite@12390000 {
+				compatible = "samsung,exynos4212-fimc-lite";
+				reg = <0x12390000 0x1000>;
+				interrupts = <0 125 0>;
+				power-domain = <&pd_isp>;
+				status = "disabled";
+			};
+
+			fimc_lite_1: fimc_lite@123A0000 {
+				compatible = "samsung,exynos4212-fimc-lite";
+				reg = <0x123A0000 0x1000>;
+				interrupts = <0 126 0>;
+				power-domain = <&pd_isp>;
+				status = "disabled";
+			};
+		};
+	};
 };
-- 
1.7.9.5

