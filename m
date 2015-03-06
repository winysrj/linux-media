Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54335 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952AbbCFKc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 05:32:56 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 1/2] ARM: dts: exynos5420: add nodes for jpeg codec
Date: Fri, 06 Mar 2015 11:32:39 +0100
Message-id: <1425637960-10687-2-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1425637960-10687-1-git-send-email-andrzej.p@samsung.com>
References: <1425637960-10687-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

