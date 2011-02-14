Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab1BNMVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 02/10] omap3: Remove unusued ISP CBUFF resource
Date: Mon, 14 Feb 2011 13:21:29 +0100
Message-Id: <1297686097-9804-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sergio Aguirre <saaguirre@ti.com>

The ISP CBUFF module isn't use, its resource isn't needed.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 95c69f9..d389756 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -69,11 +69,6 @@ static struct resource omap3isp_resources[] = {
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
1.7.3.4

