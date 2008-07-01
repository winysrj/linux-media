Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6149UaV031457
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:09:30 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6149HKH016144
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:09:17 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m61497Gs008270
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:09:12 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id m61496Z7016100
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:09:07 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m61496G20210
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:09:06 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m614962a003799
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:09:06 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m61496iH003763
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:09:06 -0500
Date: Mon, 30 Jun 2008 23:09:06 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040906.GA3744@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 12/16] OMAP3 camera driver LSC support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Mohit Jalori <mjalori@ti.com>

ARM: OMAP: OMAP34XXCAM: ISP CCDC LSC support.

Adding support for CCDC Lens Shading Compensator.

Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 drivers/media/video/isp/isp.c        |   28 +++++
 drivers/media/video/isp/ispccdc.c    |  195 ++++++++++++++++++++++++++++++++++-
 drivers/media/video/isp/ispccdc.h    |    8 +
 include/asm-arm/arch-omap/isp_user.h |   31 +++++
 4 files changed, 261 insertions(+), 1 deletion(-)

--- a/drivers/media/video/isp/isp.c	2008-06-29 13:19:12.000000000 -0500
+++ b/drivers/media/video/isp/isp.c	2008-06-29 14:12:09.000000000 -0500
@@ -324,6 +324,17 @@ int isp_set_callback(enum isp_callback_t
 					IRQENABLE_TLBMISS,
 					ISPMMU_IRQENABLE);
 		break;
+	case CBK_LSC_ISR:
+		omap_writel(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+					ISP_IRQ0STATUS);
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+					IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ,
+					ISP_IRQ0ENABLE);
+		break;
 	default:
 		break;
 	}
@@ -374,6 +385,13 @@ int isp_unset_callback(enum isp_callback
 						~IRQ0ENABLE_HS_VS_IRQ,
 						ISP_IRQ0ENABLE);
 		break;
+	case CBK_LSC_ISR:
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) &
+					~(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
+					IRQ0ENABLE_CCDC_LSC_PREF_ERR_IRQ),
+					ISP_IRQ0ENABLE);
+		break;
 	default:
 		break;
 	}
@@ -848,6 +866,15 @@ static irqreturn_t omap34xx_isp_isr(int 
 		is_irqhandled = 1;
 	}
 
+	if (irqstatus & LSC_PRE_ERR) {
+		printk(KERN_ERR "isp_sr: LSC_PRE_ERR \n");
+		omap_writel(irqstatus, ISP_IRQ0STATUS);
+		ispccdc_enable_lsc(0);
+		ispccdc_enable_lsc(1);
+		spin_unlock_irqrestore(&isp_obj.lock, irqflags);
+		return IRQ_HANDLED;
+	}
+
 	if (irqstatus & IRQ0STATUS_CSIB_IRQ) {
 		u32 ispcsi1_irqstatus;
 
@@ -929,6 +956,7 @@ void isp_stop()
 	omapisp_unset_callback();
 
 	if (ispmodule_obj.isp_pipeline & OMAP_ISP_CCDC) {
+		ispccdc_enable_lsc(0);
 		ispccdc_enable(0);
 		timeout = 0;
 		while (ispccdc_busy() && (timeout < 20)) {
--- a/drivers/media/video/isp/ispccdc.c	2008-06-29 14:08:16.000000000 -0500
+++ b/drivers/media/video/isp/ispccdc.c	2008-06-29 13:31:19.000000000 -0500
@@ -83,6 +83,16 @@ static struct isp_ccdc {
 	struct mutex mutexlock;
 } ispccdc_obj;
 
+static struct ispccdc_lsc_config lsc_config;
+static u8 *lsc_gain_table;
+static unsigned long lsc_ispmmu_addr;
+static int lsc_initialized;
+static int size_mismatch;
+static u8 ccdc_use_lsc;
+static u8 ispccdc_lsc_tbl[] = {
+	#include "ispccd_lsc.dat"
+};
+
 /* Structure for saving/restoring CCDC module registers*/
 static struct isp_reg ispccdc_reg_list[] = {
 	{ISPCCDC_SYN_MODE, 0},
@@ -143,6 +153,7 @@ int omap34xx_isp_ccdc_config(void *users
 	struct ispccdc_fpc fpc_t;
 	struct ispccdc_culling cull_t;
 	struct ispccdc_update_config *ccdc_struct;
+	u32 old_size;
 
 	if (userspace_add == NULL)
 		return -EINVAL;
@@ -230,6 +241,60 @@ int omap34xx_isp_ccdc_config(void *users
 		ispccdc_config_culling(cull_t);
 	}
 
+	if (is_isplsc_activated()) {
+		if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->flag) ==
+						ISP_ABS_CCDC_CONFIG_LSC) {
+			if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) ==
+						ISP_ABS_CCDC_CONFIG_LSC) {
+				old_size = lsc_config.size;
+				if (copy_from_user(&lsc_config,
+						(struct ispccdc_lsc_config *)
+						(ccdc_struct->lsc_cfg),
+						sizeof(struct
+						ispccdc_lsc_config)))
+					goto copy_from_user_err;
+				lsc_initialized = 0;
+				if (lsc_config.size <= old_size)
+					size_mismatch = 0;
+				else
+					size_mismatch = 1;
+				ispccdc_config_lsc(&lsc_config);
+			}
+			ccdc_use_lsc = 1;
+		} else if ((ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) ==
+						ISP_ABS_CCDC_CONFIG_LSC) {
+				ispccdc_enable_lsc(0);
+				ccdc_use_lsc = 0;
+		}
+		if ((ISP_ABS_TBL_LSC & ccdc_struct->update)
+			== ISP_ABS_TBL_LSC) {
+			if (size_mismatch) {
+				ispmmu_unmap(lsc_ispmmu_addr);
+				kfree(lsc_gain_table);
+				lsc_gain_table = kmalloc(
+					lsc_config.size,
+					GFP_KERNEL | GFP_DMA);
+				if (!lsc_gain_table) {
+					printk(KERN_ERR
+						"Cannot allocate\
+						memory for \
+						gain tables \n");
+					return -ENOMEM;
+				}
+				lsc_ispmmu_addr = ispmmu_map(
+					virt_to_phys(lsc_gain_table),
+					lsc_config.size);
+				omap_writel(lsc_ispmmu_addr,
+					ISPCCDC_LSC_TABLE_BASE);
+				lsc_initialized = 1;
+				size_mismatch = 0;
+			}
+			if (copy_from_user(lsc_gain_table,
+				(ccdc_struct->lsc), lsc_config.size))
+				goto copy_from_user_err;
+		}
+	}
+
 	if ((ISP_ABS_CCDC_COLPTN & ccdc_struct->update) == ISP_ABS_CCDC_COLPTN)
 		ispccdc_config_imgattr(ccdc_struct->colptn);
 
@@ -294,6 +359,92 @@ int ispccdc_free(void)
 EXPORT_SYMBOL(ispccdc_free);
 
 /**
+ * ispccdc_load_lsc - Load Lens Shading Compensation table.
+ * @table_size: LSC gain table size.
+ *
+ * Returns 0 if successful, or -ENOMEM of its no memory available.
+ **/
+int ispccdc_load_lsc(u32 table_size)
+{
+	if (!is_isplsc_activated())
+		return 0;
+
+	if (table_size == 0)
+		return -EINVAL;
+
+	if (lsc_initialized)
+		return 0;
+
+	ispccdc_enable_lsc(0);
+	lsc_gain_table = kmalloc(table_size, GFP_KERNEL | GFP_DMA);
+
+	if (!lsc_gain_table) {
+		printk(KERN_ERR "Cannot allocate memory for gain tables \n");
+		return -ENOMEM;
+	}
+
+	memcpy(lsc_gain_table, ispccdc_lsc_tbl, table_size);
+	lsc_ispmmu_addr = ispmmu_map(virt_to_phys(lsc_gain_table), table_size);
+	omap_writel(lsc_ispmmu_addr, ISPCCDC_LSC_TABLE_BASE);
+	lsc_initialized = 1;
+	return 0;
+}
+EXPORT_SYMBOL(ispccdc_load_lsc);
+
+/**
+ * ispccdc_config_lsc - Configures the lens shading compensation module
+ * @lsc_cfg: LSC configuration structure
+ **/
+void ispccdc_config_lsc(struct ispccdc_lsc_config *lsc_cfg)
+{
+	int reg;
+
+	if (!is_isplsc_activated())
+		return;
+
+	ispccdc_enable_lsc(0);
+	omap_writel(lsc_cfg->offset, ISPCCDC_LSC_TABLE_OFFSET);
+
+	reg = 0;
+	reg |= (lsc_cfg->gain_mode_n << ISPCCDC_LSC_GAIN_MODE_N_SHIFT);
+	reg |= (lsc_cfg->gain_mode_m << ISPCCDC_LSC_GAIN_MODE_M_SHIFT);
+	reg |= (lsc_cfg->gain_format << ISPCCDC_LSC_GAIN_FORMAT_SHIFT);
+	omap_writel(reg, ISPCCDC_LSC_CONFIG);
+
+	reg = 0;
+	reg &= ~ISPCCDC_LSC_INITIAL_X_MASK;
+	reg |= (lsc_cfg->initial_x << ISPCCDC_LSC_INITIAL_X_SHIFT);
+	reg &= ~ISPCCDC_LSC_INITIAL_Y_MASK;
+	reg |= (lsc_cfg->initial_y << ISPCCDC_LSC_INITIAL_Y_SHIFT);
+	omap_writel(reg, ISPCCDC_LSC_INITIAL);
+}
+EXPORT_SYMBOL(ispccdc_config_lsc);
+
+/**
+ * ispccdc_enable_lsc - Enables/Disables the Lens Shading Compensation module.
+ * @enable: 0 Disables LSC, 1 Enables LSC.
+ **/
+void ispccdc_enable_lsc(u8 enable)
+{
+	if (!is_isplsc_activated())
+		return;
+
+	if (enable) {
+		omap_writel(omap_readl(ISP_CTRL) | ISPCTRL_SBL_SHARED_RPORTB |
+					ISPCTRL_SBL_RD_RAM_EN, ISP_CTRL);
+		omap_writel(omap_readl(ISPCCDC_LSC_CONFIG) | 0x1,
+							ISPCCDC_LSC_CONFIG);
+		ispccdc_obj.lsc_en = 1;
+	} else {
+		omap_writel(omap_readl(ISPCCDC_LSC_CONFIG) & 0xFFFE,
+							ISPCCDC_LSC_CONFIG);
+		ispccdc_obj.lsc_en = 0;
+	}
+}
+EXPORT_SYMBOL(ispccdc_enable_lsc);
+
+
+/**
  * ispccdc_config_crop - Configures crop parameters for the ISP CCDC.
  * @left: Left offset of the crop area.
  * @top: Top offset of the crop area.
@@ -420,6 +571,19 @@ int ispccdc_config_datapath(enum ccdc_in
 		return -EINVAL;
 	};
 
+	if (is_isplsc_activated()) {
+		if (input == CCDC_RAW) {
+			lsc_config.initial_x = 0;
+			lsc_config.initial_y = 0;
+			lsc_config.gain_mode_n = 0x6;
+			lsc_config.gain_mode_m = 0x6;
+			lsc_config.gain_format = 0x4;
+			lsc_config.offset = 0x60;
+			ispccdc_config_lsc(&lsc_config);
+			ispccdc_load_lsc((u32)sizeof(ispccdc_lsc_tbl));
+		}
+	}
+
 	omap_writel(syn_mode, ISPCCDC_SYN_MODE);
 
 	switch (input) {
@@ -884,7 +1048,10 @@ EXPORT_SYMBOL(ispccdc_config_imgattr);
  **/
 void ispccdc_config_shadow_registers(void)
 {
-	return;
+	if (ccdc_use_lsc && !ispccdc_obj.lsc_en && (ispccdc_obj.ccdc_inpfmt ==
+								CCDC_RAW))
+		ispccdc_enable_lsc(1);
+
 }
 EXPORT_SYMBOL(ispccdc_config_shadow_registers);
 
@@ -1044,6 +1211,13 @@ int ispccdc_config_size(u32 input_w, u32
 					ISPCCDC_VDINT_1_SHIFT), ISPCCDC_VDINT);
 	}
 
+	if (is_isplsc_activated()) {
+		if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
+			ispccdc_config_lsc(&lsc_config);
+			ispccdc_load_lsc(lsc_config.size);
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ispccdc_config_size);
@@ -1274,6 +1448,17 @@ static int __init isp_ccdc_init(void)
 	ispccdc_config_crop(0, 0, 0, 0);
 	mutex_init(&ispccdc_obj.mutexlock);
 
+	if (is_isplsc_activated()) {
+		lsc_config.initial_x = 0;
+		lsc_config.initial_y = 0;
+		lsc_config.gain_mode_n = 0x6;
+		lsc_config.gain_mode_m = 0x6;
+		lsc_config.gain_format = 0x4;
+		lsc_config.offset = 0x60;
+		lsc_config.size = sizeof(ispccdc_lsc_tbl);
+		ccdc_use_lsc = 1;
+	}
+
 	return 0;
 }
 
@@ -1282,6 +1467,14 @@ static int __init isp_ccdc_init(void)
  **/
 static void isp_ccdc_cleanup(void)
 {
+	if (is_isplsc_activated()) {
+		if (lsc_initialized) {
+			ispmmu_unmap(lsc_ispmmu_addr);
+			kfree(lsc_gain_table);
+			lsc_initialized = 0;
+		}
+	}
+
 	if (fpc_table_add_m != 0) {
 		ispmmu_unmap(fpc_table_add_m);
 		kfree(fpc_table_add);
--- a/drivers/media/video/isp/ispccdc.h	2008-06-29 14:08:16.000000000 -0500
+++ b/drivers/media/video/isp/ispccdc.h	2008-06-29 13:38:12.000000000 -0500
@@ -23,6 +23,14 @@
 
 #include <asm/arch/isp_user.h>
 
+#ifndef CONFIG_ARCH_OMAP3410
+# define cpu_is_omap3410()		0
+# define is_isplsc_activated()		1
+#else
+# define cpu_is_omap3410()		1
+# define is_isplsc_activated()		0
+#endif
+
 #ifdef OMAP_ISPCCDC_DEBUG
 # define is_ispccdc_debug_enabled()		1
 #else
--- a/include/asm-arm/arch-omap/isp_user.h	2008-06-29 14:08:16.000000000 -0500
+++ b/include/asm-arm/arch-omap/isp_user.h	2008-06-29 13:35:05.000000000 -0500
@@ -60,6 +60,37 @@ enum vpif_freq {
 };
 
 /**
+ * struct ispccdc_lsc_config - Structure for LSC configuration.
+ * @offset: Table Offset of the gain table.
+ * @gain_mode_n: Vertical dimension of a paxel in LSC configuration.
+ * @gain_mode_m: Horizontal dimension of a paxel in LSC configuration.
+ * @gain_format: Gain table format.
+ * @fmtsph: Start pixel horizontal from start of the HS sync pulse.
+ * @fmtlnh: Number of pixels in horizontal direction to use for the data
+ *          reformatter.
+ * @fmtslv: Start line from start of VS sync pulse for the data reformatter.
+ * @fmtlnv: Number of lines in vertical direction for the data reformatter.
+ * @initial_x: X position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @initial_y: Y position, in pixels, of the first active pixel in reference
+ *             to the first active paxel. Must be an even number.
+ * @size: Size of LSC gain table. Filled when loaded from userspace.
+ */
+struct ispccdc_lsc_config {
+	u8 offset;
+	u8 gain_mode_n;
+	u8 gain_mode_m;
+	u8 gain_format;
+	u16 fmtsph;
+	u16 fmtlnh;
+	u16 fmtslv;
+	u16 fmtlnv;
+	u8 initial_x;
+	u8 initial_y;
+	u32 size;
+};
+
+/**
  * struct ispccdc_bclamp - Structure for Optical & Digital black clamp subtract
  * @obgain: Optical black average gain.
  * @obstpixel: Start Pixel w.r.t. HS pulse in Optical black sample.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
