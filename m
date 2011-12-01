Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37094 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab1LAAPQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:15:16 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v2 04/11] OMAP4: hwmod: Include CSI2A and CSIPHY1 memory sections
Date: Wed, 30 Nov 2011 18:14:53 -0600
Message-ID: <1322698500-29924-5-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 7695e5d..1b59e2f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2623,8 +2623,18 @@ static struct omap_hwmod_ocp_if *omap44xx_iss_masters[] = {
 
 static struct omap_hwmod_addr_space omap44xx_iss_addrs[] = {
 	{
-		.pa_start	= 0x52000000,
-		.pa_end		= 0x520000ff,
+		.pa_start	= OMAP44XX_ISS_TOP_BASE,
+		.pa_end		= OMAP44XX_ISS_TOP_END,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= OMAP44XX_ISS_CSI2_A_REGS1_BASE,
+		.pa_end		= OMAP44XX_ISS_CSI2_A_REGS1_END,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= OMAP44XX_ISS_CAMERARX_CORE1_BASE,
+		.pa_end		= OMAP44XX_ISS_CAMERARX_CORE1_END,
 		.flags		= ADDR_TYPE_RT
 	},
 	{ }
@@ -5350,7 +5360,7 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_ipu_c1_hwmod,
 
 	/* iss class */
-/*	&omap44xx_iss_hwmod, */
+	&omap44xx_iss_hwmod,
 
 	/* iva class */
 	&omap44xx_iva_hwmod,
-- 
1.7.7.4

