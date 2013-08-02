Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49503 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab3HBOFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Aug 2013 10:05:15 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <dagriego@biglakesoftware.com>,
	<dale@farnsworth.org>, <pawel@osciak.com>,
	<m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>, Rajendra Nayak <rnayak@ti.com>,
	Sricharan R <r.sricharan@ti.com>
Subject: [PATCH 5/6] arm: dra7xx: hwmod data: add VPE hwmod data and ocp_if info
Date: Fri, 2 Aug 2013 19:33:42 +0530
Message-ID: <1375452223-30524-6-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-1-git-send-email-archit@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add hwmod data for the VPE IP, this is needed for the IP to be reset during
boot, and control the functional clock when the driver needs it via
pm_runtime apis. Add the corresponding ocp_if struct and add it DRA7XX's
ocp interface list.

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 42 +++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index f647998b..181365d 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1883,6 +1883,39 @@ static struct omap_hwmod dra7xx_wd_timer2_hwmod = {
 	},
 };
 
+/*
+ * 'vpe' class
+ *
+ */
+
+static struct omap_hwmod_class_sysconfig dra7xx_vpe_sysc = {
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class dra7xx_vpe_hwmod_class = {
+	.name	= "vpe",
+	.sysc	= &dra7xx_vpe_sysc,
+};
+
+/* vpe */
+static struct omap_hwmod dra7xx_vpe_hwmod = {
+	.name		= "vpe",
+	.class		= &dra7xx_vpe_hwmod_class,
+	.clkdm_name	= "vpe_clkdm",
+	.main_clk	= "dpll_core_h23x2_ck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_VPE_VPE_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_VPE_VPE_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
 
 /*
  * Interfaces
@@ -2636,6 +2669,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_wkup__wd_timer2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_per3 -> vpe */
+static struct omap_hwmod_ocp_if dra7xx_l4_per3__vpe = {
+	.master		= &dra7xx_l4_per3_hwmod,
+	.slave		= &dra7xx_vpe_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l3_main_2__l3_instr,
 	&dra7xx_l4_cfg__l3_main_1,
@@ -2714,6 +2755,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l3_main_1__vcp2,
 	&dra7xx_l4_per2__vcp2,
 	&dra7xx_l4_wkup__wd_timer2,
+	&dra7xx_l4_per3__vpe,
 	NULL,
 };
 
-- 
1.8.1.2

