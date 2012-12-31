Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15715 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2LaQEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:16 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 11/15] ARM: dts: Add camera node exynos4.dtsi
Date: Mon, 31 Dec 2012 17:03:09 +0100
Message-id: <1356969793-27268-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds common FIMC device nodes for all Exynos4 SoCs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   64 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index b853b11..30364ce 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -28,6 +28,12 @@
 		spi0 = &spi_0;
 		spi1 = &spi_1;
 		spi2 = &spi_2;
+		csis0 = &csis_0;
+		csis1 = &csis_1;
+		fimc0 = &fimc_0;
+		fimc1 = &fimc_1;
+		fimc2 = &fimc_2;
+		fimc3 = &fimc_3;
 	};
 
 	pd_mfc: mfc-power-domain@10023C40 {
@@ -92,6 +98,64 @@
 		power-domain = <&pd_lcd0>;
 	};
 
+	camera {
+		compatible = "samsung,fimc", "simple-bus";
+		status = "disabled";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		fimc_0: fimc@11800000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11800000 0x1000>;
+			interrupts = <0 84 0>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+
+		fimc_1: fimc@11810000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11810000 0x1000>;
+			interrupts = <0 85 0>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+
+		fimc_2: fimc@11820000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11820000 0x1000>;
+			interrupts = <0 86 0>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+
+		fimc_3: fimc@11830000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11830000 0x1000>;
+			interrupts = <0 87 0>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+
+		csis_0: csis@11880000 {
+			compatible = "samsung,exynos4210-csis";
+			reg = <0x11880000 0x4000>;
+			interrupts = <0 78 0>;
+			max-data-lanes = <4>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+
+		csis_1: csis@11890000 {
+			compatible = "samsung,exynos4210-csis";
+			reg = <0x11890000 0x4000>;
+			interrupts = <0 80 0>;
+			max-data-lanes = <2>;
+			power-domain = <&pd_cam>;
+			status = "disabled";
+		};
+	};
+
 	watchdog@10060000 {
 		compatible = "samsung,s3c2410-wdt";
 		reg = <0x10060000 0x100>;
-- 
1.7.9.5

