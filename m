Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54252 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbaGOR5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 13:57:47 -0400
From: Felipe Balbi <balbi@ti.com>
To: <hans.verkuil@cisco.com>, Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>, <robh+dt@kernel.org>
CC: <linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <archit@ti.com>,
	<detheridge@ti.com>, <sakari.ailus@iki.fi>,
	<laurent.pinchart@ideasonboard.com>, <devicetree@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 2/5] arm: omap: hwmod: add hwmod entries for AM437x VPFE
Date: Tue, 15 Jul 2014 12:56:49 -0500
Message-ID: <1405447012-5340-3-git-send-email-balbi@ti.com>
In-Reply-To: <1405447012-5340-1-git-send-email-balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benoit Parrot <bparrot@ti.com>

HWMOD entries support for TI Dual Video Processing Front
End (VPFE) (aka Dual cam) of AM43xx platform.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 56 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm43xx.h             |  3 +-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
index fea01aa..bd9067e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
@@ -483,6 +483,44 @@ static struct omap_hwmod am43xx_dss_rfbi_hwmod = {
 	},
 };
 
+static struct omap_hwmod_class_sysconfig am43xx_vpfe_sysc = {
+	.rev_offs       = 0x0,
+	.sysc_offs      = 0x104,
+	.sysc_flags     = SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE,
+	.idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+				MSTANDBY_FORCE | MSTANDBY_SMART | MSTANDBY_NO),
+	.sysc_fields    = &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am43xx_vpfe_hwmod_class = {
+	.name           = "vpfe",
+	.sysc           = &am43xx_vpfe_sysc,
+};
+
+static struct omap_hwmod am43xx_vpfe0_hwmod = {
+	.name           = "vpfe0",
+	.class          = &am43xx_vpfe_hwmod_class,
+	.clkdm_name     = "l3s_clkdm",
+	.prcm           = {
+		.omap4  = {
+			.modulemode     = MODULEMODE_SWCTRL,
+			.clkctrl_offs   = AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET,
+		},
+	},
+};
+
+static struct omap_hwmod am43xx_vpfe1_hwmod = {
+	.name           = "vpfe1",
+	.class          = &am43xx_vpfe_hwmod_class,
+	.clkdm_name     = "l3s_clkdm",
+	.prcm           = {
+		.omap4  = {
+			.modulemode     = MODULEMODE_SWCTRL,
+			.clkctrl_offs   = AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET,
+		},
+	},
+};
+
 /* Interfaces */
 static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
 	.master		= &am33xx_l3_main_hwmod,
@@ -750,6 +788,22 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
+	.master         = &am33xx_l3_main_hwmod,
+	.slave          = &am43xx_vpfe0_hwmod,
+	.clk            = "l3_gclk",
+	.flags          = OCPIF_SWSUP_IDLE,
+	.user           = OCP_USER_MPU,
+};
+
+static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
+	.master         = &am33xx_l3_main_hwmod,
+	.slave          = &am43xx_vpfe1_hwmod,
+	.clk            = "l3_gclk",
+	.flags          = OCPIF_SWSUP_IDLE,
+	.user           = OCP_USER_MPU,
+};
+
 static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_l4_wkup__synctimer,
 	&am43xx_l4_ls__timer8,
@@ -848,6 +902,8 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am43xx_l4_ls__dss,
 	&am43xx_l4_ls__dss_dispc,
 	&am43xx_l4_ls__dss_rfbi,
+	&am43xx_l3__vpfe0,
+	&am43xx_l3__vpfe1,
 	NULL,
 };
 
diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43xx.h
index ad7b3e9..8aa4c2c 100644
--- a/arch/arm/mach-omap2/prcm43xx.h
+++ b/arch/arm/mach-omap2/prcm43xx.h
@@ -143,5 +143,6 @@
 #define AM43XX_CM_PER_USB_OTG_SS1_CLKCTRL_OFFSET        0x0268
 #define AM43XX_CM_PER_USBPHYOCP2SCP1_CLKCTRL_OFFSET	0x05C0
 #define AM43XX_CM_PER_DSS_CLKCTRL_OFFSET		0x0a20
-
+#define AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET		0x0068
+#define AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET		0x0070
 #endif
-- 
2.0.0.390.gcb682f8

