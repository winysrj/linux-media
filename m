Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36744 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab0KOOaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:02 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 4/9] omap3: Remove unusued CBUFF resource
Date: Mon, 15 Nov 2010 08:29:56 -0600
Message-Id: <1289831401-593-5-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c9fc732..897ce82 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -67,11 +67,6 @@ static struct resource omap3isp_resources[] = {
 		.flags		= IORESOURCE_MEM,
 	},
 	{
-		.start		= OMAP3430_ISP_CBUFF_BASE,
-		.end		= OMAP3430_ISP_CBUFF_END,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
 		.start		= OMAP3430_ISP_CCP2_BASE,
 		.end		= OMAP3430_ISP_CCP2_END,
 		.flags		= IORESOURCE_MEM,
-- 
1.7.0.4

