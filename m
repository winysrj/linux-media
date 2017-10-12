Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:15175 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754188AbdJLT1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:27:38 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 5/6] ARM: DRA7: hwmod: Add VPE nodes
Date: Thu, 12 Oct 2017 14:27:18 -0500
Message-ID: <20171012192719.15193-6-bparrot@ti.com>
In-Reply-To: <20171012192719.15193-1-bparrot@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add hwmod entries for VPE (Video Processing Engine) hardware block
found in DRA7x family of devices.

DRA75x_DRA74x_ES1.1 Version T Technical Reference Manual
(Literature Number SPRUHI2T) states that VPE only support NO_STANDBY,
FORCE_STANDBY, NO_IDLE, FORCE_IDLE and SMART_IDLE.
The hwmod flags were set to reflect this fact and make sure that
both are software supervised (SWSUSP).

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index fc53b498975c..c0bbc1099a11 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -240,6 +240,40 @@ static struct omap_hwmod dra7xx_bb2d_hwmod = {
 };
 
 /*
+ * 'vpe' class
+ *
+ */
+
+static struct omap_hwmod_class_sysconfig dra7xx_vpe_sysc = {
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART),
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
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_VPE_VPE_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_VPE_VPE_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/*
  * 'cal' class
  *
  */
@@ -3936,6 +3970,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_per2__vcp2 = {
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
 /* l4_per3 -> cal */
 static struct omap_hwmod_ocp_if dra7xx_l4_per3__cal = {
 	.master		= &dra7xx_l4_per3_hwmod,
@@ -4099,6 +4141,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_per2__vcp1,
 	&dra7xx_l3_main_1__vcp2,
 	&dra7xx_l4_per2__vcp2,
+	&dra7xx_l4_per3__vpe,
 	&dra7xx_l4_wkup__wd_timer2,
 	&dra7xx_l4_per2__epwmss0,
 	&dra7xx_l4_per2__epwmss1,
-- 
2.9.0
