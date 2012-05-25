Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2EYTxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:10 -0400
Date: Fri, 25 May 2012 21:52:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 08/13] ARM: dts: Add FIMC and MIPI-CSIS devices to
 Exynos4210 DT source
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-8-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4210-origen.dts   |   28 +++++++++++++++
 arch/arm/boot/dts/exynos4210-smdkv310.dts |   28 +++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi         |   54 +++++++++++++++++++++++++++++
 arch/arm/mach-exynos/mach-exynos4-dt.c    |   12 +++++++
 4 files changed, 122 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index b8c4763..20915b1 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -134,4 +134,32 @@
 	i2c@138D0000 {
 		status = "disabled";
 	};
+
+	camera {
+		status = "disabled";
+	};
+
+	fimc@11800000 {
+		status = "disabled";
+	};
+
+	fimc@11810000 {
+		status = "disabled";
+	};
+
+	fimc@11820000 {
+		status = "disabled";
+	};
+
+	fimc@11830000 {
+		status = "disabled";
+	};
+
+	csis@11880000 {
+		status = "disabled";
+	};
+
+	csis@11890000 {
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210-smdkv310.dts b/arch/arm/boot/dts/exynos4210-smdkv310.dts
index 27afc8e..da7adb7 100644
--- a/arch/arm/boot/dts/exynos4210-smdkv310.dts
+++ b/arch/arm/boot/dts/exynos4210-smdkv310.dts
@@ -179,4 +179,32 @@
 	i2c@138D0000 {
 		status = "disabled";
 	};
+
+	camera {
+		status = "disabled";
+	};
+
+	fimc@11800000 {
+		status = "disabled";
+	};
+
+	fimc@11810000 {
+		status = "disabled";
+	};
+
+	fimc@11820000 {
+		status = "disabled";
+	};
+
+	fimc@11830000 {
+		status = "disabled";
+	};
+
+	csis@11880000 {
+		status = "disabled";
+	};
+
+	csis@11890000 {
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index be3c57c..27eb245 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -183,6 +183,60 @@
 		};
 	};
 
+	fimc0: fimc@11800000 {
+		compatible = "samsung,exynos4210-fimc";
+		reg = <0x11800000 0x1000>;
+		interrupts = <0 84 0>;
+		cell-index = <0>;
+		pd = <&pd_cam>;
+	};
+
+	fimc1: fimc@11810000 {
+		compatible = "samsung,exynos4210-fimc";
+		reg = <0x11810000 0x1000>;
+		interrupts = <0 85 0>;
+		cell-index = <1>;
+		pd = <&pd_cam>;
+	};
+
+	fimc2: fimc@11820000 {
+		compatible = "samsung,exynos4210-fimc";
+		reg = <0x11820000 0x1000>;
+		interrupts = <0 86 0>;
+		cell-index = <2>;
+		pd = <&pd_cam>;
+	};
+
+	fimc3: fimc@11830000 {
+		compatible = "samsung,exynos4210-fimc";
+		reg = <0x11830000 0x1000>;
+		interrupts = <0 87 0>;
+		cell-index = <3>;
+		pd = <&pd_cam>;
+	};
+
+	csis0: csis@11880000 {
+		compatible = "samsung,exynos4210-csis";
+		reg = <0x11880000 0x1000>;
+		interrupts = <0 78 0>;
+		cell-index = <0>;
+		pd = <&pd_cam>;
+	};
+
+	csis1: csis@11890000 {
+		compatible = "samsung,exynos4210-csis";
+		reg = <0x11890000 0x1000>;
+		interrupts = <0 79 0>;
+		cell-index = <1>;
+		pd = <&pd_cam>;
+	};
+
+	camera {
+		compatible = "samsung,fimc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+	};
+
 	gpio-controllers {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index aa13ec0..6545a37 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -70,6 +70,18 @@ static const struct of_dev_auxdata exynos4210_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("samsung,s5pv210-tvmixer", S5P_PA_MIXER, "s5p-mixer", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA1, "dma-pl330.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-csis", EXYNOS4_PA_MIPI_CSIS0,
+				"s5p-mipi-csis.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-csis", EXYNOS4_PA_MIPI_CSIS1,
+				"s5p-mipi-csis.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-fimc", EXYNOS4_PA_FIMC0,
+				"exynos4-fimc.0", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-fimc", EXYNOS4_PA_FIMC1,
+				"exynos4-fimc.1", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-fimc", EXYNOS4_PA_FIMC2,
+				"exynos4-fimc.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-fimc", EXYNOS4_PA_FIMC3,
+				"exynos4-fimc.3", NULL),
 	{},
 };
 
-- 
1.7.10

