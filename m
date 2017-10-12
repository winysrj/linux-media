Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:15171 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752744AbdJLT1d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:27:33 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 2/6] ARM: DRA7: hwmod: Add CAL nodes
Date: Thu, 12 Oct 2017 14:27:15 -0500
Message-ID: <20171012192719.15193-3-bparrot@ti.com>
In-Reply-To: <20171012192719.15193-1-bparrot@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the required hwmod nodes to support the Camera
Adaptation Layer (CAL) for the DRA72 family of devices.

- Added CAL hwmod entry in the DRA72x section.

The DRA72x TRM (Literature Number SPRUHP2x) states that CAL only
support NO_IDLE, FORCE_IDLE and SMART_IDLE.
Although CAL does not support standby mode per se hwmod would not
enabled the functional/interface clock if module is not a master.
Hence the SWSUP mode flags ifor SIDLE ans MSTANDBY are also enabled.
This ensure that i/f clocks are available when CAL is enabled.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 2f4f7002f38d..fc53b498975c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -240,6 +240,41 @@ static struct omap_hwmod dra7xx_bb2d_hwmod = {
 };
 
 /*
+ * 'cal' class
+ *
+ */
+
+static struct omap_hwmod_class_sysconfig dra7xx_cal_sysc = {
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_RESET_STATUS |
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_MIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   MSTANDBY_FORCE | MSTANDBY_NO),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class dra7xx_cal_hwmod_class = {
+	.name	= "cal",
+	.sysc	= &dra7xx_cal_sysc,
+};
+
+/* cal */
+static struct omap_hwmod dra7xx_cal_hwmod = {
+	.name		= "cal",
+	.class		= &dra7xx_cal_hwmod_class,
+	.clkdm_name	= "cam_clkdm",
+	.main_clk	= "vip2_gclk_mux",
+	.flags		= (HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY),
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_CAM_VIP2_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_CAM_VIP2_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/*
  * 'counter' class
  *
  */
@@ -3901,6 +3936,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_per2__vcp2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_per3 -> cal */
+static struct omap_hwmod_ocp_if dra7xx_l4_per3__cal = {
+	.master		= &dra7xx_l4_per3_hwmod,
+	.slave		= &dra7xx_cal_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_wkup -> wd_timer2 */
 static struct omap_hwmod_ocp_if dra7xx_l4_wkup__wd_timer2 = {
 	.master		= &dra7xx_l4_wkup_hwmod,
@@ -4082,6 +4125,7 @@ static struct omap_hwmod_ocp_if *dra74x_hwmod_ocp_ifs[] __initdata = {
 };
 
 static struct omap_hwmod_ocp_if *dra72x_hwmod_ocp_ifs[] __initdata = {
+	&dra7xx_l4_per3__cal,
 	NULL,
 };
 
-- 
2.9.0
