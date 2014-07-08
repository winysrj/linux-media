Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:43154 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaGHNFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 09:05:18 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH 2/3] ARM: dts: exynos3250 add MFC codec device node
Date: Tue, 08 Jul 2014 15:04:13 +0200
Message-id: <1404824654-5907-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org
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

