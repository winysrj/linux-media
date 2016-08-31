Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17365 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbcHaNZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:25:34 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/3] ARM: exynos: add all required FIMC-IS clocks to exynos4x12
 dtsi
Date: Wed, 31 Aug 2016 15:25:18 +0200
Message-id: <1472649918-10371-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
References: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS blocks must control 3 more clocks ("gicisp", "mcuctl_isp" and
"pwm_isp") to make the hardware fully operational.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index c452499ae8c9..3394bdcf10ae 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -157,7 +157,9 @@
 				 <&clock CLK_MOUT_MPLL_USER_T>,
 				 <&clock CLK_FIMC_ISP>, <&clock CLK_FIMC_DRC>,
 				 <&clock CLK_FIMC_FD>, <&clock CLK_MCUISP>,
-				 <&clock CLK_DIV_ISP0>,<&clock CLK_DIV_ISP1>,
+				 <&clock CLK_GICISP>, <&clock CLK_MCUCTL_ISP>,
+				 <&clock CLK_PWM_ISP>,
+				 <&clock CLK_DIV_ISP0>, <&clock CLK_DIV_ISP1>,
 				 <&clock CLK_DIV_MCUISP0>,
 				 <&clock CLK_DIV_MCUISP1>,
 				 <&clock CLK_UART_ISP_SCLK>,
@@ -167,6 +169,7 @@
 			clock-names = "lite0", "lite1", "ppmuispx",
 				      "ppmuispmx", "mpll", "isp",
 				      "drc", "fd", "mcuisp",
+				      "gicisp", "mcuctl_isp", "pwm_isp",
 				      "ispdiv0", "ispdiv1", "mcuispdiv0",
 				      "mcuispdiv1", "uart", "aclk200",
 				      "div_aclk200", "aclk400mcuisp",
-- 
1.9.1

