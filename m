Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53815 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaGKPUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:20:16 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00159ZXRX650@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:20:15 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 9/9] ARM: dts: exynos3250: add JPEG codec device node
Date: Fri, 11 Jul 2014 17:19:50 +0200
Message-id: <1405091990-28567-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3e678fa..2f7f923 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -206,6 +206,15 @@
 			interrupts = <0 240 0>;
 		};
 
+		jpeg-codec@11830000 {
+			compatible = "samsung,exynos3250-jpeg";
+			reg = <0x11830000 0x1000>;
+			interrupts = <0 171 0>;
+			clocks = <&cmu CLK_JPEG>, <&cmu CLK_SCLK_JPEG>;
+			clock-names = "jpeg", "sclk-jpeg";
+			samsung,power-domain = <&pd_cam>;
+		};
+
 		mshc_0: mshc@12510000 {
 			compatible = "samsung,exynos5250-dw-mshc";
 			reg = <0x12510000 0x1000>;
-- 
1.7.9.5

