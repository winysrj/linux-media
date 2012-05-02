Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:40220 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab2EBPQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:16:09 -0400
Received: by ghbg2 with SMTP id g2so894506ghb.29
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:16:03 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v3 02/10] OMAP4: hwmod: Include CSI2A/B and CSIPHY1/2 memory sections
Date: Wed,  2 May 2012 10:15:41 -0500
Message-Id: <1335971749-21258-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In memory, They are in this particular order:
- CSI2A
- CSIPHY1
- CSI2B
- CSIPHY2

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 6abc757..a7b2380 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2641,6 +2641,26 @@ static struct omap_hwmod_addr_space omap44xx_iss_addrs[] = {
 		.pa_end		= 0x520000ff,
 		.flags		= ADDR_TYPE_RT
 	},
+	{
+		.pa_start	= 0x52001000,
+		.pa_end		= 0x5200116f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001170,
+		.pa_end		= 0x5200118f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001400,
+		.pa_end		= 0x5200156f,
+		.flags		= ADDR_TYPE_RT
+	},
+	{
+		.pa_start	= 0x52001570,
+		.pa_end		= 0x5200158f,
+		.flags		= ADDR_TYPE_RT
+	},
 	{ }
 };
 
@@ -5605,7 +5625,7 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[] = {
 	&omap44xx_ipu_c1_hwmod,
 
 	/* iss class */
-/*	&omap44xx_iss_hwmod, */
+	&omap44xx_iss_hwmod,
 
 	/* iva class */
 	&omap44xx_iva_hwmod,
-- 
1.7.5.4

