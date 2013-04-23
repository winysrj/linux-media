Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:42344 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3DWRLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 13:11:43 -0400
Received: by mail-la0-f49.google.com with SMTP id ei20so758909lab.22
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 10:11:41 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH v3 2/4] ARM: shmobile: r8a7779: add VIN support
Date: Tue, 23 Apr 2013 21:10:59 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
References: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232110.59718.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add VIN clocks and platform devices for R8A7779 SoC; add function to register
the VIN platform devices.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: added 'id' parameter check to r8a7779_add_vin_device(), renamed some
variables, annotated vin[01]_resources[] and 'vin[01]_info' as '__initdata'.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Changes since version 2:
- annotated vin[01]_resources[] and 'vin[01]_info' as '__initdata' since they're
  kmemdup()'ed while registering the platform devices anyway;

Changes since the original posting:
- added 'id' parameter check to r8a7779_add_vin_device().

 arch/arm/mach-shmobile/clock-r8a7779.c        |   10 ++++++
 arch/arm/mach-shmobile/include/mach/r8a7779.h |    3 ++
 arch/arm/mach-shmobile/setup-r8a7779.c        |   38 ++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

Index: renesas/arch/arm/mach-shmobile/clock-r8a7779.c
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/clock-r8a7779.c
+++ renesas/arch/arm/mach-shmobile/clock-r8a7779.c
@@ -112,7 +112,9 @@ static struct clk *main_clks[] = {
 };
 
 enum { MSTP323, MSTP322, MSTP321, MSTP320,
+	MSTP120,
 	MSTP116, MSTP115, MSTP114,
+	MSTP110, MSTP109, MSTP108,
 	MSTP103, MSTP101, MSTP100,
 	MSTP030,
 	MSTP029, MSTP028, MSTP027, MSTP026, MSTP025, MSTP024, MSTP023, MSTP022, MSTP021,
@@ -125,9 +127,13 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP322] = SH_CLK_MSTP32(&clkp_clk, MSTPCR3, 22, 0), /* SDHI1 */
 	[MSTP321] = SH_CLK_MSTP32(&clkp_clk, MSTPCR3, 21, 0), /* SDHI2 */
 	[MSTP320] = SH_CLK_MSTP32(&clkp_clk, MSTPCR3, 20, 0), /* SDHI3 */
+	[MSTP120] = SH_CLK_MSTP32(&clks_clk, MSTPCR1, 20, 0), /* VIN3 */
 	[MSTP116] = SH_CLK_MSTP32(&clkp_clk, MSTPCR1, 16, 0), /* PCIe */
 	[MSTP115] = SH_CLK_MSTP32(&clkp_clk, MSTPCR1, 15, 0), /* SATA */
 	[MSTP114] = SH_CLK_MSTP32(&clkp_clk, MSTPCR1, 14, 0), /* Ether */
+	[MSTP110] = SH_CLK_MSTP32(&clks_clk, MSTPCR1, 10, 0), /* VIN0 */
+	[MSTP109] = SH_CLK_MSTP32(&clks_clk, MSTPCR1,  9, 0), /* VIN1 */
+	[MSTP108] = SH_CLK_MSTP32(&clks_clk, MSTPCR1,  8, 0), /* VIN2 */
 	[MSTP103] = SH_CLK_MSTP32(&clks_clk, MSTPCR1,  3, 0), /* DU */
 	[MSTP101] = SH_CLK_MSTP32(&clkp_clk, MSTPCR1,  1, 0), /* USB2 */
 	[MSTP100] = SH_CLK_MSTP32(&clkp_clk, MSTPCR1,  0, 0), /* USB0/1 */
@@ -162,10 +168,14 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("peripheral_clk",	&clkp_clk),
 
 	/* MSTP32 clocks */
+	CLKDEV_DEV_ID("rcar_vin.3", &mstp_clks[MSTP120]), /* VIN3 */
 	CLKDEV_DEV_ID("rcar-pcie", &mstp_clks[MSTP116]), /* PCIe */
 	CLKDEV_DEV_ID("sata_rcar", &mstp_clks[MSTP115]), /* SATA */
 	CLKDEV_DEV_ID("fc600000.sata", &mstp_clks[MSTP115]), /* SATA w/DT */
 	CLKDEV_DEV_ID("sh-eth", &mstp_clks[MSTP114]), /* Ether */
+	CLKDEV_DEV_ID("rcar_vin.0", &mstp_clks[MSTP110]), /* VIN0 */
+	CLKDEV_DEV_ID("rcar_vin.1", &mstp_clks[MSTP109]), /* VIN1 */
+	CLKDEV_DEV_ID("rcar_vin.2", &mstp_clks[MSTP108]), /* VIN2 */
 	CLKDEV_DEV_ID("ehci-platform.1", &mstp_clks[MSTP101]), /* USB EHCI port2 */
 	CLKDEV_DEV_ID("ohci-platform.1", &mstp_clks[MSTP101]), /* USB OHCI port2 */
 	CLKDEV_DEV_ID("ehci-platform.0", &mstp_clks[MSTP100]), /* USB EHCI port0/1 */
Index: renesas/arch/arm/mach-shmobile/include/mach/r8a7779.h
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/include/mach/r8a7779.h
+++ renesas/arch/arm/mach-shmobile/include/mach/r8a7779.h
@@ -5,6 +5,7 @@
 #include <linux/pm_domain.h>
 #include <linux/sh_eth.h>
 #include <linux/usb/rcar-phy.h>
+#include <linux/platform_data/camera-rcar.h>
 
 struct platform_device;
 
@@ -35,6 +36,8 @@ extern void r8a7779_add_standard_devices
 extern void r8a7779_add_standard_devices_dt(void);
 extern void r8a7779_add_ether_device(struct sh_eth_plat_data *pdata);
 extern void r8a7779_add_usb_phy_device(struct rcar_phy_platform_data *pdata);
+extern void r8a7779_add_vin_device(int idx,
+				   struct rcar_vin_platform_data *pdata);
 extern void r8a7779_init_late(void);
 extern void r8a7779_clock_init(void);
 extern void r8a7779_pinmux_init(void);
Index: renesas/arch/arm/mach-shmobile/setup-r8a7779.c
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/setup-r8a7779.c
+++ renesas/arch/arm/mach-shmobile/setup-r8a7779.c
@@ -559,6 +559,33 @@ static struct resource ether_resources[]
 	},
 };
 
+#define R8A7779_VIN(idx) \
+static struct resource vin##idx##_resources[] __initdata = {		\
+	DEFINE_RES_MEM(0xffc50000 + 0x1000 * (idx), 0x1000),		\
+	DEFINE_RES_IRQ(gic_iid(0x5f + (idx))),				\
+};									\
+									\
+static struct platform_device_info vin##idx##_info __initdata = {	\
+	.parent		= &platform_bus,				\
+	.name		= "rcar_vin",					\
+	.id		= idx,						\
+	.res		= vin##idx##_resources,				\
+	.num_res	= ARRAY_SIZE(vin##idx##_resources),		\
+	.dma_mask	= DMA_BIT_MASK(32),				\
+}
+
+R8A7779_VIN(0);
+R8A7779_VIN(1);
+R8A7779_VIN(2);
+R8A7779_VIN(3);
+
+static struct platform_device_info *vin_info_table[] __initdata = {
+	&vin0_info,
+	&vin1_info,
+	&vin2_info,
+	&vin3_info,
+};
+
 static struct platform_device *r8a7779_devices_dt[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -610,6 +637,17 @@ void __init r8a7779_add_usb_phy_device(s
 					  pdata, sizeof(*pdata));
 }
 
+void __init r8a7779_add_vin_device(int id,
+				   struct rcar_vin_platform_data *pdata)
+{
+	BUG_ON(id < 0 || id > 3);
+
+	vin_info_table[id]->data = pdata;
+	vin_info_table[id]->size_data = sizeof(struct rcar_vin_platform_data);
+
+	platform_device_register_full(vin_info_table[id]);
+}
+
 /* do nothing for !CONFIG_SMP or !CONFIG_HAVE_TWD */
 void __init __weak r8a7779_register_twd(void) { }
 
