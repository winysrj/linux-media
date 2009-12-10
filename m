Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761194AbZLJRAb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 12:00:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com, nsekhar@ti.com, hvaibhav@ti.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v1 1/6] V4L - vpfe-capture : DM365 vpss enhancements
Date: Thu, 10 Dec 2009 12:00:27 -0500
Message-Id: <1260464429-10537-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1260464429-10537-3-git-send-email-m-karicheri2@ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
 <1260464429-10537-2-git-send-email-m-karicheri2@ti.com>
 <1260464429-10537-3-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Enhancements to support DM365 ISP5 and VPSS module configuration.
Also cleaned up the driver by removing redundant variables.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-next v4l-dvb tree
 drivers/media/video/davinci/vpss.c |  289 +++++++++++++++++++++++++++++-------
 include/media/davinci/vpss.h       |   41 +++++-
 2 files changed, 275 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 6d709ca..03f625d 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- * common vpss driver for all video drivers.
+ * common vpss system module platform driver for all video drivers.
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -35,12 +35,52 @@ MODULE_AUTHOR("Texas Instruments");
 /* DM644x defines */
 #define DM644X_SBL_PCR_VPSS		(4)
 
+#define DM355_VPSSBL_INTSEL		0x10
+#define DM355_VPSSBL_EVTSEL		0x14
 /* vpss BL register offsets */
 #define DM355_VPSSBL_CCDCMUX		0x1c
 /* vpss CLK register offsets */
 #define DM355_VPSSCLK_CLKCTRL		0x04
 /* masks and shifts */
 #define VPSS_HSSISEL_SHIFT		4
+/*
+ * VDINT0 - vpss_int0, VDINT1 - vpss_int1, H3A - vpss_int4,
+ * IPIPE_INT1_SDR - vpss_int5
+ */
+#define DM355_VPSSBL_INTSEL_DEFAULT	0xff83ff10
+/* VENCINT - vpss_int8 */
+#define DM355_VPSSBL_EVTSEL_DEFAULT	0x4
+
+#define DM365_ISP5_PCCR 		0x04
+#define DM365_ISP5_INTSEL1		0x10
+#define DM365_ISP5_INTSEL2		0x14
+#define DM365_ISP5_INTSEL3		0x18
+#define DM365_ISP5_CCDCMUX 		0x20
+#define DM365_ISP5_PG_FRAME_SIZE 	0x28
+#define DM365_VPBE_CLK_CTRL 		0x00
+/*
+ * vpss interrupts. VDINT0 - vpss_int0, VDINT1 - vpss_int1,
+ * AF - vpss_int3
+ */
+#define DM365_ISP5_INTSEL1_DEFAULT	0x0b1f0100
+/* AEW - vpss_int6, RSZ_INT_DMA - vpss_int5 */
+#define DM365_ISP5_INTSEL2_DEFAULT	0x1f0a0f1f
+/* VENC - vpss_int8 */
+#define DM365_ISP5_INTSEL3_DEFAULT	0x00000015
+
+/* masks and shifts for DM365*/
+#define DM365_CCDC_PG_VD_POL_SHIFT 	0
+#define DM365_CCDC_PG_HD_POL_SHIFT 	1
+
+#define CCD_SRC_SEL_MASK		(BIT_MASK(5) | BIT_MASK(4))
+#define CCD_SRC_SEL_SHIFT		4
+
+/* Different SoC platforms supported by this driver */
+enum vpss_platform_type {
+	DM644X,
+	DM355,
+	DM365,
+};
 
 /*
  * vpss operations. Depends on platform. Not all functions are available
@@ -59,13 +99,9 @@ struct vpss_hw_ops {
 
 /* vpss configuration */
 struct vpss_oper_config {
-	__iomem void *vpss_bl_regs_base;
-	__iomem void *vpss_regs_base;
-	struct resource		*r1;
-	resource_size_t		len1;
-	struct resource		*r2;
-	resource_size_t		len2;
-	char vpss_name[32];
+	__iomem void *vpss_regs_base0;
+	__iomem void *vpss_regs_base1;
+	enum vpss_platform_type platform;
 	spinlock_t vpss_lock;
 	struct vpss_hw_ops hw_ops;
 };
@@ -75,22 +111,46 @@ static struct vpss_oper_config oper_cfg;
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
+}
+
+/* For DM365 only */
+static inline u32 isp5_read(u32 offset)
+{
+	return __raw_readl(oper_cfg.vpss_regs_base0 + offset);
+}
+
+/* For DM365 only */
+static inline void isp5_write(u32 val, u32 offset)
+{
+	__raw_writel(val, oper_cfg.vpss_regs_base0 + offset);
+}
+
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
 }
 
 static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
@@ -101,9 +161,9 @@ static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
 {
 	if (!oper_cfg.hw_ops.select_ccdc_source)
-		return -1;
+		return -EINVAL;
 
-	dm355_select_ccdc_source(src_sel);
+	oper_cfg.hw_ops.select_ccdc_source(src_sel);
 	return 0;
 }
 EXPORT_SYMBOL(vpss_select_ccdc_source);
@@ -114,7 +174,7 @@ static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 
 	if (wbl_sel < VPSS_PCR_AEW_WBL_0 ||
 	    wbl_sel > VPSS_PCR_CCDC_WBL_O)
-		return -1;
+		return -EINVAL;
 
 	/* writing a 0 clear the overflow */
 	mask = ~(mask << wbl_sel);
@@ -126,7 +186,7 @@ static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
 {
 	if (!oper_cfg.hw_ops.clear_wbl_overflow)
-		return -1;
+		return -EINVAL;
 
 	return oper_cfg.hw_ops.clear_wbl_overflow(wbl_sel);
 }
@@ -166,7 +226,7 @@ static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
 	default:
 		printk(KERN_ERR "dm355_enable_clock:"
 				" Invalid selector: %d\n", clock_sel);
-		return -1;
+		return -EINVAL;
 	}
 
 	spin_lock_irqsave(&oper_cfg.vpss_lock, flags);
@@ -181,100 +241,221 @@ static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
 	return 0;
 }
 
+static int dm365_enable_clock(enum vpss_clock_sel clock_sel, int en)
+{
+	unsigned long flags;
+	u32 utemp, mask = 0x1, shift = 0, offset = DM365_ISP5_PCCR;
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
+	spin_lock_irqsave(&oper_cfg.vpss_lock, flags);
+	utemp = read(offset);
+	if (!en) {
+		mask = ~mask;
+		utemp &= (mask << shift);
+	} else
+		utemp |= (mask << shift);
+
+	write(utemp, offset);
+	spin_unlock_irqrestore(&oper_cfg.vpss_lock, flags);
+
+	return 0;
+}
+
 int vpss_enable_clock(enum vpss_clock_sel clock_sel, int en)
 {
 	if (!oper_cfg.hw_ops.enable_clock)
-		return -1;
+		return -EINVAL;
 
 	return oper_cfg.hw_ops.enable_clock(clock_sel, en);
 }
 EXPORT_SYMBOL(vpss_enable_clock);
 
+void dm365_vpss_set_sync_pol(struct vpss_sync_pol sync)
+{
+	int val = 0;
+	val = isp5_read(DM365_ISP5_CCDCMUX);
+
+	val |= (sync.ccdpg_hdpol << DM365_CCDC_PG_HD_POL_SHIFT);
+	val |= (sync.ccdpg_vdpol << DM365_CCDC_PG_VD_POL_SHIFT);
+
+	isp5_write(val, DM365_ISP5_CCDCMUX);
+}
+EXPORT_SYMBOL(dm365_vpss_set_sync_pol);
+
+void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
+{
+	int current_reg = ((frame_size.hlpfr >> 1) - 1) << 16;
+
+	current_reg |= (frame_size.pplen - 1);
+	isp5_write(current_reg, DM365_ISP5_PG_FRAME_SIZE);
+}
+EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
+
 static int __init vpss_probe(struct platform_device *pdev)
 {
-	int status, dm355 = 0;
+	struct resource		*r1, *r2;
+	char *platform_name;
+	int status;
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data\n");
 		return -ENOENT;
 	}
-	strcpy(oper_cfg.vpss_name, pdev->dev.platform_data);
 
-	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss"))
-		dm355 = 1;
-	else if (strcmp(oper_cfg.vpss_name, "dm644x_vpss")) {
+	platform_name = pdev->dev.platform_data;
+	if (!strcmp(platform_name, "dm355_vpss"))
+		oper_cfg.platform = DM355;
+	else if (!strcmp(platform_name, "dm365_vpss"))
+		oper_cfg.platform = DM365;
+	else if (!strcmp(platform_name, "dm644x_vpss"))
+		oper_cfg.platform = DM644X;
+	else {
 		dev_err(&pdev->dev, "vpss driver not supported on"
 			" this platform\n");
 		return -ENODEV;
 	}
 
-	dev_info(&pdev->dev, "%s vpss probed\n", oper_cfg.vpss_name);
-	oper_cfg.r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!oper_cfg.r1)
+	dev_info(&pdev->dev, "%s vpss probed\n", platform_name);
+	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r1)
 		return -ENOENT;
 
-	oper_cfg.len1 = oper_cfg.r1->end - oper_cfg.r1->start + 1;
-
-	oper_cfg.r1 = request_mem_region(oper_cfg.r1->start, oper_cfg.len1,
-					 oper_cfg.r1->name);
-	if (!oper_cfg.r1)
+	r1 = request_mem_region(r1->start, resource_size(r1), r1->name);
+	if (!r1)
 		return -EBUSY;
 
-	oper_cfg.vpss_bl_regs_base = ioremap(oper_cfg.r1->start, oper_cfg.len1);
-	if (!oper_cfg.vpss_bl_regs_base) {
+	oper_cfg.vpss_regs_base0 = ioremap(r1->start, resource_size(r1));
+	if (!oper_cfg.vpss_regs_base0) {
 		status = -EBUSY;
 		goto fail1;
 	}
 
-	if (dm355) {
-		oper_cfg.r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!oper_cfg.r2) {
+	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
+		r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!r2) {
 			status = -ENOENT;
 			goto fail2;
 		}
-		oper_cfg.len2 = oper_cfg.r2->end - oper_cfg.r2->start + 1;
-		oper_cfg.r2 = request_mem_region(oper_cfg.r2->start,
-						 oper_cfg.len2,
-						 oper_cfg.r2->name);
-		if (!oper_cfg.r2) {
+		r2 = request_mem_region(r2->start, resource_size(r2), r2->name);
+		if (!r2) {
 			status = -EBUSY;
 			goto fail2;
 		}
 
-		oper_cfg.vpss_regs_base = ioremap(oper_cfg.r2->start,
-						  oper_cfg.len2);
-		if (!oper_cfg.vpss_regs_base) {
+		oper_cfg.vpss_regs_base1 = ioremap(r2->start,
+						   resource_size(r2));
+		if (!oper_cfg.vpss_regs_base1) {
 			status = -EBUSY;
 			goto fail3;
 		}
 	}
 
-	if (dm355) {
+	if (oper_cfg.platform == DM355) {
 		oper_cfg.hw_ops.enable_clock = dm355_enable_clock;
 		oper_cfg.hw_ops.select_ccdc_source = dm355_select_ccdc_source;
+		/* Setup vpss interrupts */
+		bl_regw(DM355_VPSSBL_INTSEL_DEFAULT, DM355_VPSSBL_INTSEL);
+		bl_regw(DM355_VPSSBL_EVTSEL_DEFAULT, DM355_VPSSBL_EVTSEL);
+	} else if (oper_cfg.platform == DM365) {
+		oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
+		oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
+		/* Setup vpss interrupts */
+		isp5_write(DM365_ISP5_INTSEL1_DEFAULT, DM365_ISP5_INTSEL1);
+		isp5_write(DM365_ISP5_INTSEL2_DEFAULT, DM365_ISP5_INTSEL2);
+		isp5_write(DM365_ISP5_INTSEL3_DEFAULT, DM365_ISP5_INTSEL3);
 	} else
 		oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
 
 	spin_lock_init(&oper_cfg.vpss_lock);
-	dev_info(&pdev->dev, "%s vpss probe success\n", oper_cfg.vpss_name);
+	dev_info(&pdev->dev, "%s vpss probe success\n", platform_name);
 	return 0;
 
 fail3:
-	release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
+	release_mem_region(r2->start, resource_size(r2));
 fail2:
-	iounmap(oper_cfg.vpss_bl_regs_base);
+	iounmap(oper_cfg.vpss_regs_base0);
 fail1:
-	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
+	release_mem_region(r1->start, resource_size(r1));
 	return status;
 }
 
 static int vpss_remove(struct platform_device *pdev)
 {
-	iounmap(oper_cfg.vpss_bl_regs_base);
-	release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
-	if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
-		iounmap(oper_cfg.vpss_regs_base);
-		release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
+	struct resource		*res;
+
+	iounmap(oper_cfg.vpss_regs_base0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
+		iounmap(oper_cfg.vpss_regs_base1);
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		release_mem_region(res->start, resource_size(res));
 	}
 	return 0;
 }
diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
index fcdff74..c59cc02 100644
--- a/include/media/davinci/vpss.h
+++ b/include/media/davinci/vpss.h
@@ -29,7 +29,19 @@
 /* selector for ccdc input selection on DM355 */
 enum vpss_ccdc_source_sel {
 	VPSS_CCDCIN,
-	VPSS_HSSIIN
+	VPSS_HSSIIN,
+	VPSS_PGLPBK,	/* for DM365 only */
+	VPSS_CCDCPG	/* for DM365 only */
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
@@ -47,12 +59,38 @@ enum vpss_clock_sel {
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
+/* set sync polarity, only for DM365*/
+void dm365_vpss_set_sync_pol(struct vpss_sync_pol);
+/* set the PG_FRAME_SIZE register, only for DM365 */
+void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size);
 
 /* wbl reset for dm644x */
 enum vpss_wbl_sel {
@@ -65,5 +103,6 @@ enum vpss_wbl_sel {
 	VPSS_PCR_PREV_WBL_0,
 	VPSS_PCR_CCDC_WBL_O,
 };
+/* clear wbl overflow flag for DM6446 */
 int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel);
 #endif
-- 
1.6.0.4

