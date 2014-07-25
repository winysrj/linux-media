Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61866 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbaGYOVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Kukjin Kim <kgene.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 9/9] ARM: dts: exynos3250: add JPEG codec device node
Date: Fri, 25 Jul 2014 16:20:53 +0200
Message-id: <1406298053-30184-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
References: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacek Anaszewski <j.anaszewski@samsung.com>

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3e678fa..46a864d 100644
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
+			clock-names = "jpeg", "sclk";
+			samsung,power-domain = <&pd_cam>;
+		};
+
 		mshc_0: mshc@12510000 {
 			compatible = "samsung,exynos5250-dw-mshc";
 			reg = <0x12510000 0x1000>;
--
1.7.9.5

