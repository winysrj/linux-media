Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54640 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaGKPaq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:30:46 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v3] ARM: dts: exynos3250 add MFC codec device node
Date: Fri, 11 Jul 2014 17:30:43 +0200
Message-id: <1405092643-29232-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 351871a..01bf5fa 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -283,6 +283,17 @@
 			status = "disabled";
 		};
 
+		codec@13400000 {
+			compatible = "samsung,mfc-v7";
+			reg = <0x13400000 0x10000>;
+			interrupts = <0 102 0>;
+			clock-names = "mfc", "sclk-mfc";
+			clocks = <&cmu CLK_MFC>, <&cmu CLK_SCLK_MFC>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			samsung,power-domain = <&pd_mfc>;
+		};
+
 		serial_0: serial@13800000 {
 			compatible = "samsung,exynos4210-uart";
 			reg = <0x13800000 0x100>;
-- 
1.7.9.5

