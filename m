Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50384 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbcHaNZb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:25:31 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] media: exynos4-is: Add support for all required clocks
Date: Wed, 31 Aug 2016 15:25:16 +0200
Message-id: <1472649918-10371-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
References: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds 3 more clocks to Exynos4 ISP driver. Enabling them is
needed to make the hardware operational. Till now it worked only because
those clocks were registered with IGNORE_UNUSED flag and were enabled
by default after SoC reset.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/media/exynos4-fimc-is.txt | 7 ++++---
 drivers/media/platform/exynos4-is/fimc-is.c                 | 3 +++
 drivers/media/platform/exynos4-is/fimc-is.h                 | 3 +++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
index 55c9ad6f9599..32ced99d4244 100644
--- a/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
+++ b/Documentation/devicetree/bindings/media/exynos4-fimc-is.txt
@@ -16,9 +16,10 @@ Required properties:
 - clocks	: list of clock specifiers, corresponding to entries in
 		  clock-names property;
 - clock-names	: must contain "ppmuispx", "ppmuispx", "lite0", "lite1"
-		  "mpll", "sysreg", "isp", "drc", "fd", "mcuisp", "uart",
-		  "ispdiv0", "ispdiv1", "mcuispdiv0", "mcuispdiv1", "aclk200",
-		  "div_aclk200", "aclk400mcuisp", "div_aclk400mcuisp" entries,
+		  "mpll", "sysreg", "isp", "drc", "fd", "mcuisp", "gicisp",
+		  "pwm_isp", "mcuctl_isp", "uart", "ispdiv0", "ispdiv1",
+		  "mcuispdiv0", "mcuispdiv1", "aclk200", "div_aclk200",
+		  "aclk400mcuisp", "div_aclk400mcuisp" entries,
 		  matching entries in the clocks property.
 pmu subnode
 -----------
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 32ca55f16677..5cedf2322bb4 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -52,6 +52,9 @@ static char *fimc_is_clocks[ISS_CLKS_MAX] = {
 	[ISS_CLK_DRC]			= "drc",
 	[ISS_CLK_FD]			= "fd",
 	[ISS_CLK_MCUISP]		= "mcuisp",
+	[ISS_CLK_GICISP]		= "gicisp",
+	[ISS_CLK_PWM_ISP]		= "pwm_isp",
+	[ISS_CLK_MCUCTL_ISP]		= "mcuctl_isp",
 	[ISS_CLK_UART]			= "uart",
 	[ISS_CLK_ISP_DIV0]		= "ispdiv0",
 	[ISS_CLK_ISP_DIV1]		= "ispdiv1",
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 3a82c6a214c7..ee05da034aa1 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -77,6 +77,9 @@ enum {
 	ISS_CLK_DRC,
 	ISS_CLK_FD,
 	ISS_CLK_MCUISP,
+	ISS_CLK_GICISP,
+	ISS_CLK_PWM_ISP,
+	ISS_CLK_MCUCTL_ISP,
 	ISS_CLK_UART,
 	ISS_GATE_CLKS_MAX,
 	ISS_CLK_ISP_DIV0 = ISS_GATE_CLKS_MAX,
-- 
1.9.1

