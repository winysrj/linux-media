Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35569 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZHQTat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 15:30:49 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n7HJUjux027644
	for <linux-media@vger.kernel.org>; Mon, 17 Aug 2009 14:30:50 -0500
From: neilsikka@ti.com
To: linux-media@vger.kernel.org, m-karicheri2@ti.com
Cc: Neil Sikka <neilsikka@ti.com>
Subject: [PATCH] DM365 VPSS support
Date: Mon, 17 Aug 2009 15:30:42 -0400
Message-Id: <1250537444-2077-3-git-send-email-neilsikka@ti.com>
In-Reply-To: <1250537444-2077-2-git-send-email-neilsikka@ti.com>
References: <1250537444-2077-1-git-send-email-neilsikka@ti.com>
 <1250537444-2077-2-git-send-email-neilsikka@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Sikka <neilsikka@ti.com>

This patch adds support for DM365 VPSS

Reviewed-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Mandatory-Reviewer: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Neil Sikka <neilsikka@ti.com>
---
Applies to v4l-dvb linux-next repository
 drivers/media/video/davinci/vpss.c |  232 ++++++++++++++++++++++++++++++++----
 include/media/davinci/vpss.h       |   59 +++++++++-
 2 files changed, 268 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 6d709ca..83dac1b 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -42,9 +42,12 @@ MODULE_AUTHOR("Texas Instruments");
 /* masks and shifts */
 #define VPSS_HSSISEL_SHIFT		4
 
-/*
+/* lock to write into common register */
+static spinlock_t vpss_lock;
+
+/**
  * vpss operations. Depends on platform. Not all functions are available
- * on all platforms. The api, first check if a functio is available before
+ * on all platforms. The api, first check if a function is available before
  * invoking it. In the probe, the function ptrs are intialized based on
  * vpss name. vpss name can be "dm355_vpss", "dm644x_vpss" etc.
  */
@@ -53,14 +56,19 @@ struct vpss_hw_ops {
 	int (*enable_clock)(enum vpss_clock_sel clock_sel, int en);
 	/* select input to ccdc */
 	void (*select_ccdc_source)(enum vpss_ccdc_source_sel src_sel);
-	/* clear wbl overlflow bit */
+	/* clear wbl overflow bit */
 	int (*clear_wbl_overflow)(enum vpss_wbl_sel wbl_sel);
+	/*set sync polarity */
+	void (*set_sync_pol)(struct vpss_sync_pol);
+	/*set the PG_FRAME_SIZE register*/
+	void (*set_pg_frame_size)(struct vpss_pg_frame_size);
 };
 
 /* vpss configuration */
 struct vpss_oper_config {
-	__iomem void *vpss_bl_regs_base;
-	__iomem void *vpss_regs_base;
+	__iomem void *vpss_regs_base0;
+	__iomem void *vpss_regs_base1;
+	resource_size_t *vpss_regs_base2;
 	struct resource		*r1;
 	resource_size_t		len1;
 	struct resource		*r2;
@@ -75,22 +83,32 @@ static struct vpss_oper_config oper_cfg;
 /* register access routines */
 static inline u32 bl_regr(u32 offset)
 {
-	return __raw_readl(oper_cfg.vpss_bl_regs_base + offset);
+	return __raw_readl(oper_cfg.vpss_regs_base0 + offset);
 }
 
 static inline void bl_regw(u32 val, u32 offset)
 {
-	__raw_writel(val, oper_cfg.vpss_bl_regs_base + offset);
+	__raw_writel(val, oper_cfg.vpss_regs_base0 + offset);
+}
+
+static inline u32 isp5_read(u32 offset)
+{
+	return __raw_readl(oper_cfg.vpss_regs_base0 + offset);
+}
+
+static inline void isp5_write(u32 val, u32 offset)
+{
+	__raw_writel(val, oper_cfg.vpss_regs_base0 + offset);
 }
 
 static inline u32 vpss_regr(u32 offset)
 {
-	return __raw_readl(oper_cfg.vpss_regs_base + offset);
+	return __raw_readl(oper_cfg.vpss_regs_base1 + offset);
 }
 
 static inline void vpss_regw(u32 val, u32 offset)
 {
-	__raw_writel(val, oper_cfg.vpss_regs_base + offset);
+	__raw_writel(val, oper_cfg.vpss_regs_base1 + offset);
 }
 
 static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
@@ -98,12 +116,25 @@ static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 	bl_regw(src_sel << VPSS_HSSISEL_SHIFT, DM355_VPSSBL_CCDCMUX);
 }
 
+static void dm365_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
+{
+	u32 temp = isp5_read(DM365_ISP5_CCDCMUX) & ~CCD_SRC_SEL_MASK;
+
+	/* if we are using pattern generator, enable it */
+	if (src_sel == VPSS_PGLPBK || src_sel == VPSS_CCDCPG)
+		temp |= 0x08;
+
+	temp |= (src_sel << CCD_SRC_SEL_SHIFT);
+	isp5_write(temp, DM365_ISP5_CCDCMUX);
+}
+
 int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 {
 	if (!oper_cfg.hw_ops.select_ccdc_source)
 		return -1;
 
-	dm355_select_ccdc_source(src_sel);
+	oper_cfg.hw_ops.select_ccdc_source(src_sel);
+
 	return 0;
 }
 EXPORT_SYMBOL(vpss_select_ccdc_source);
@@ -120,9 +151,56 @@ static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 	mask = ~(mask << wbl_sel);
 	val = bl_regr(DM644X_SBL_PCR_VPSS) & mask;
 	bl_regw(val, DM644X_SBL_PCR_VPSS);
+
 	return 0;
 }
 
+static void dm365_enable_irq(void)
+{
+	u32 current_val = isp5_read(DM365_VPSS_INTSEL1);
+	/*just enable INTSEL0 and INTSEL1 and leave everything else as is*/
+	current_val &= ~(CCD_INT_SEL_MASK);
+	current_val |= BIT_MASK(8);
+	isp5_write(current_val, DM365_VPSS_INTSEL1);
+}
+
+void dm365_set_sync_pol(struct vpss_sync_pol sync)
+{
+	int val = 0;
+	val = isp5_read(DM365_ISP5_CCDCMUX);
+
+	val |= (sync.ccdpg_hdpol << DM365_CCDC_PG_HD_POL_SHIFT);
+	val |= (sync.ccdpg_vdpol << DM365_CCDC_PG_VD_POL_SHIFT);
+
+	isp5_write(val, DM365_ISP5_CCDCMUX);
+}
+
+void vpss_set_sync_pol(struct vpss_sync_pol sync)
+{
+	if (!oper_cfg.hw_ops.set_sync_pol)
+		return;
+
+	oper_cfg.hw_ops.set_sync_pol(sync);
+}
+EXPORT_SYMBOL(vpss_set_sync_pol);
+
+void dm365_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
+{
+	int current_reg = ((frame_size.hlpfr >> 1) - 1) << 16;
+
+	current_reg |= (frame_size.pplen - 1);
+	isp5_write(current_reg, DM365_ISP5_PG_FRAME_SIZE);
+}
+
+void vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
+{
+	if (!oper_cfg.hw_ops.set_pg_frame_size)
+		return;
+
+	oper_cfg.hw_ops.set_pg_frame_size(frame_size);
+}
+EXPORT_SYMBOL(vpss_set_pg_frame_size);
+
 int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 {
 	if (!oper_cfg.hw_ops.clear_wbl_overflow)
@@ -132,7 +210,7 @@ int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 }
 EXPORT_SYMBOL(vpss_clear_wbl_overflow);
 
-/*
+/**
  *  dm355_enable_clock - Enable VPSS Clock
  *  @clock_sel: CLock to be enabled/disabled
  *  @en: enable/disable flag
@@ -178,6 +256,93 @@ static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
 
 	vpss_regw(utemp, DM355_VPSSCLK_CLKCTRL);
 	spin_unlock_irqrestore(&oper_cfg.vpss_lock, flags);
+
+	return 0;
+}
+
+static int dm365_enable_clock(enum vpss_clock_sel clock_sel, int en)
+{
+	unsigned long flags;
+	u32 utemp, mask = 0x1, shift = 0, offset = DM365_PCCR;
+	u32 (*read)(u32 offset) = isp5_read;
+	void(*write)(u32 val, u32 offset) = isp5_write;
+
+	switch (clock_sel) {
+	case VPSS_BL_CLOCK:
+		break;
+	case VPSS_CCDC_CLOCK:
+		shift = 1;
+		break;
+	case VPSS_H3A_CLOCK:
+		shift = 2;
+		break;
+	case VPSS_RSZ_CLOCK:
+		shift = 3;
+		break;
+	case VPSS_IPIPE_CLOCK:
+		shift = 4;
+		break;
+	case VPSS_IPIPEIF_CLOCK:
+		shift = 5;
+		break;
+	case VPSS_PCLK_INTERNAL:
+		shift = 6;
+		break;
+	case VPSS_PSYNC_CLOCK_SEL:
+		shift = 7;
+		break;
+	case VPSS_VPBE_CLOCK:
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	case VPSS_VENC_CLOCK_SEL:
+		shift = 2;
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	case VPSS_LDC_CLOCK:
+		shift = 3;
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	case VPSS_FDIF_CLOCK:
+		shift = 4;
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	case VPSS_OSD_CLOCK_SEL:
+		shift = 6;
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	case VPSS_LDC_CLOCK_SEL:
+		shift = 7;
+		read = vpss_regr;
+		write = vpss_regw;
+		offset = DM365_VPBE_CLK_CTRL;
+		break;
+	default:
+		printk(KERN_ERR "dm365_enable_clock: Invalid selector: %d\n",
+		       clock_sel);
+		return -1;
+	}
+
+	spin_lock_irqsave(&vpss_lock, flags);
+	utemp = read(offset);
+	if (!en) {
+		mask = ~mask;
+		utemp &= (mask << shift);
+	} else
+		utemp |= (mask << shift);
+
+	write(utemp, offset);
+	spin_unlock_irqrestore(&vpss_lock, flags);
+
 	return 0;
 }
 
@@ -192,7 +357,7 @@ EXPORT_SYMBOL(vpss_enable_clock);
 
 static int __init vpss_probe(struct platform_device *pdev)
 {
-	int status, dm355 = 0;
+	int status, dm355 = 0, dm365 = 0;
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data\n");
@@ -202,6 +367,8 @@ static int __init vpss_probe(struct platform_device *pdev)
 
 	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss"))
 		dm355 = 1;
+	else if (!strcmp(oper_cfg.vpss_name, "dm365_vpss"))
+		dm365 = 1;
 	else if (strcmp(oper_cfg.vpss_name, "dm644x_vpss")) {
 		dev_err(&pdev->dev, "vpss driver not supported on"
 			" this platform\n");
@@ -220,13 +387,13 @@ static int __init vpss_probe(struct platform_device *pdev)
 	if (!oper_cfg.r1)
 		return -EBUSY;
 
-	oper_cfg.vpss_bl_regs_base = ioremap(oper_cfg.r1->start, oper_cfg.len1);
-	if (!oper_cfg.vpss_bl_regs_base) {
+	oper_cfg.vpss_regs_base0 = ioremap(oper_cfg.r1->start, oper_cfg.len1);
+	if (!oper_cfg.vpss_regs_base0) {
 		status = -EBUSY;
 		goto fail1;
 	}
 
-	if (dm355) {
+	if (dm355 || dm365) {
 		oper_cfg.r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		if (!oper_cfg.r2) {
 			status = -ENOENT;
@@ -241,9 +408,9 @@ static int __init vpss_probe(struct platform_device *pdev)
 			goto fail2;
 		}
 
-		oper_cfg.vpss_regs_base = ioremap(oper_cfg.r2->start,
+		oper_cfg.vpss_regs_base1 = ioremap(oper_cfg.r2->start,
 						  oper_cfg.len2);
-		if (!oper_cfg.vpss_regs_base) {
+		if (!oper_cfg.vpss_regs_base1) {
 			status = -EBUSY;
 			goto fail3;
 		}
@@ -252,9 +419,20 @@ static int __init vpss_probe(struct platform_device *pdev)
 	if (dm355) {
 		oper_cfg.hw_ops.enable_clock = dm355_enable_clock;
 		oper_cfg.hw_ops.select_ccdc_source = dm355_select_ccdc_source;
-	} else
+		oper_cfg.hw_ops.set_sync_pol = NULL;
+		oper_cfg.hw_ops.set_pg_frame_size = NULL;
+	} else if (dm365) {
+		oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
+		oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
+		oper_cfg.hw_ops.set_sync_pol = dm365_set_sync_pol;
+		oper_cfg.hw_ops.set_pg_frame_size = dm365_set_pg_frame_size;
+
+	} else if (!strcmp(oper_cfg.vpss_name, "dm644x_vpss"))
 		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
 
+	if (dm365)
+		dm365_enable_irq();
+
 	spin_lock_init(&oper_cfg.vpss_lock);
 	dev_info(&pdev->dev, "%s vpss probe success\n", oper_cfg.vpss_name);
 	return 0;
@@ -262,7 +440,7 @@ static int __init vpss_probe(struct platform_device *pdev)
 fail3:
 	release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
 fail2:
-	iounmap(oper_cfg.vpss_bl_regs_base);
+	iounmap(oper_cfg.vpss_regs_base0);
 fail1:
 	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
 	return status;
@@ -270,12 +448,14 @@ fail1:
 
 static int vpss_remove(struct platform_device *pdev)
 {
-	iounmap(oper_cfg.vpss_bl_regs_base);
+	iounmap(oper_cfg.vpss_regs_base0);
 	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
-	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
-		iounmap(oper_cfg.vpss_regs_base);
+	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss") ||
+	    !strcmp(oper_cfg.vpss_name, "dm365_vpss")) {
+		iounmap(oper_cfg.vpss_regs_base1);
 		release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
 	}
+
 	return 0;
 }
 
@@ -290,11 +470,19 @@ static struct platform_driver vpss_driver = {
 
 static void vpss_exit(void)
 {
+	iounmap(oper_cfg.vpss_regs_base2);
+	release_mem_region(*oper_cfg.vpss_regs_base2, 4);
 	platform_driver_unregister(&vpss_driver);
 }
 
 static int __init vpss_init(void)
 {
+	if (request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control")) {
+		oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+		__raw_writel(0x18, oper_cfg.vpss_regs_base2);
+	} else
+		return -EBUSY;
+
 	return platform_driver_register(&vpss_driver);
 }
 subsys_initcall(vpss_init);
diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
index fcdff74..a8583a2 100644
--- a/include/media/davinci/vpss.h
+++ b/include/media/davinci/vpss.h
@@ -26,10 +26,41 @@
 #ifndef _VPSS_H
 #define _VPSS_H
 
+/* dm365 stuff or wutever like that */
+#define DM365_PCCR 			0x04
+#define DM365_ISP_REG_BASE 		0x01c70000
+#define DM365_VPSS_REG_BASE 		0x01c70200
+#define DM365_VPBE_CLK_CTRL 		0x00
+#define DM365_ISP5_CCDCMUX 		0x20
+#define DM365_ISP5_PG_FRAME_SIZE 	0x28
+#define DM365_CCDC_PG_VD_POL_SHIFT 	0
+#define DM365_CCDC_PG_HD_POL_SHIFT 	1
+#define DM365_VPSS_INTSEL1		0x10
+#define VPSS_CLK_CTRL			0x01C40044
+#define CCD_SRC_SEL_MASK		(BIT_MASK(5) | BIT_MASK(4))
+#define CCD_SRC_SEL_SHIFT		4
+#define CCD_INT_SEL_MASK		(BIT_MASK(12) | BIT_MASK(11)|\
+					BIT_MASK(10) | BIT_MASK(9)  |\
+					BIT_MASK(8)  | BIT_MASK(4)  |\
+					BIT_MASK(3)  | BIT_MASK(2)  |\
+					BIT_MASK(1)  | BIT_MASK(0))
+
 /* selector for ccdc input selection on DM355 */
 enum vpss_ccdc_source_sel {
 	VPSS_CCDCIN,
-	VPSS_HSSIIN
+	VPSS_HSSIIN,
+	VPSS_PGLPBK,
+	VPSS_CCDCPG
+};
+
+struct vpss_sync_pol {
+	unsigned int ccdpg_hdpol:1;
+	unsigned int ccdpg_vdpol:1;
+};
+
+struct vpss_pg_frame_size {
+	short hlpfr;
+	short pplen;
 };
 
 /* Used for enable/diable VPSS Clock */
@@ -47,12 +78,38 @@ enum vpss_clock_sel {
 	 */
 	VPSS_VENC_CLOCK_SEL,
 	VPSS_VPBE_CLOCK,
+	/* DM365 only clocks */
+	VPSS_IPIPEIF_CLOCK,
+	VPSS_RSZ_CLOCK,
+	VPSS_BL_CLOCK,
+	/*
+	 * When using VPSS_PCLK_INTERNAL in vpss_enable_clock() api
+	 * following applies:-
+	 * en = 0 disable internal PCLK
+	 * en = 1 enables internal PCLK
+	 */
+	VPSS_PCLK_INTERNAL,
+	/*
+	 * When using VPSS_PSYNC_CLOCK_SEL in vpss_enable_clock() api
+	 * following applies:-
+	 * en = 0 enables MMR clock
+	 * en = 1 enables VPSS clock
+	 */
+	VPSS_PSYNC_CLOCK_SEL,
+	VPSS_LDC_CLOCK_SEL,
+	VPSS_OSD_CLOCK_SEL,
+	VPSS_FDIF_CLOCK,
+	VPSS_LDC_CLOCK
 };
 
 /* select input to ccdc on dm355 */
 int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel);
 /* enable/disable a vpss clock, 0 - success, -1 - failure */
 int vpss_enable_clock(enum vpss_clock_sel clock_sel, int en);
+/*set sync polarity, only implemented for DM365*/
+void vpss_set_sync_pol(struct vpss_sync_pol);
+/*set the PG_FRAME_SIZE register, only implemented for DM365*/
+void vpss_set_pg_frame_size(struct vpss_pg_frame_size);
 
 /* wbl reset for dm644x */
 enum vpss_wbl_sel {
-- 
1.6.0.4

