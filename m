Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20979 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbIROWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:22:05 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
Date: Fri, 18 Sep 2015 16:21:00 +0200
Message-id: <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Add Exynos 5433 jpeg h/w codec node.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index 59e21b6..5cb489f 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -916,6 +916,27 @@
 			io-channel-ranges;
 			status = "disabled";
 		};
+		jpeg: jpeg@15020000 {
+			compatible = "samsung,exynos5433-jpeg";
+			reg = <0x15020000 0x10000>;
+			interrupts = <0 411 0>;
+			clock-names = "pclk",
+				      "aclk",
+				      "aclk_xiu",
+				      "sclk";
+			clocks = <&cmu_mscl CLK_PCLK_JPEG>,
+				 <&cmu_mscl CLK_ACLK_JPEG>,
+				 <&cmu_mscl CLK_ACLK_XIU_MSCLX>,
+				 <&cmu_mscl CLK_SCLK_JPEG>;
+			assigned-clocks = <&cmu_mscl CLK_MOUT_ACLK_MSCL_400_USER>,
+					  <&cmu_mscl CLK_MOUT_SCLK_JPEG_USER>,
+					  <&cmu_mscl CLK_MOUT_SCLK_JPEG>,
+					  <&cmu_top CLK_MOUT_SCLK_JPEG_A>;
+			assigned-clock-parents = <&cmu_top CLK_ACLK_MSCL_400>,
+						 <&cmu_top CLK_SCLK_JPEG_MSCL>,
+						 <&cmu_mscl CLK_MOUT_SCLK_JPEG_USER>,
+						 <&cmu_top CLK_MOUT_BUS_PLL_USER>;
+		};
 	};
 
 	timer {
-- 
1.9.1

