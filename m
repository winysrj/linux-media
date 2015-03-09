Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8787 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbCIMcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 08:32:54 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCHv3 1/2] ARM: dts: exynos5420: add nodes for jpeg codec
Date: Mon, 09 Mar 2015 13:32:45 +0100
Message-id: <1425904366-14447-2-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1425904366-14447-1-git-send-email-andrzej.p@samsung.com>
References: <1425904366-14447-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add nodes for jpeg codec in Exynos5420 SoC.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 73c1851..f8f583c 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -775,6 +775,22 @@
 		iommus = <&sysmmu_gscl1>;
 	};
 
+	jpeg_0: jpeg@11F50000 {
+		compatible = "samsung,exynos5420-jpeg";
+		reg = <0x11F50000 0x1000>;
+		interrupts = <0 89 0>;
+		clock-names = "jpeg";
+		clocks = <&clock CLK_JPEG>;
+	};
+
+	jpeg_1: jpeg@11F60000 {
+		compatible = "samsung,exynos5420-jpeg";
+		reg = <0x11F60000 0x1000>;
+		interrupts = <0 168 0>;
+		clock-names = "jpeg";
+		clocks = <&clock CLK_JPEG2>;
+	};
+
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5420-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
-- 
1.9.1

