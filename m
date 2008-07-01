Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m614B2Ri032597
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:11:02 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m614AoPu016943
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:10:50 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m614Aea8009147
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:10:45 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id m614AePx008976
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:10:40 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m614AdG20358
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:10:39 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m614Adob024022
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:10:39 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m614AdUE023991
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:10:39 -0500
Date: Mon, 30 Jun 2008 23:10:39 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701041039.GA23970@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 15/16] OMAP3 camera driver histogram H3A
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

ARM: OMAP: OMAP34XXCAM: ISP 3A & Histogram Blocks.

Adding ISP 3A and Histogram Statistics block support for 
OMAP 34xx Camera Driver.

Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 drivers/media/video/isp/Makefile     |    2
 drivers/media/video/isp/isp.c        |   83 +++
 drivers/media/video/isp/isph3a.c     |  922 +++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isph3a.h     |  139 +++++
 drivers/media/video/isp/isphist.c    |  651 ++++++++++++++++++++++++
 drivers/media/video/isp/isphist.h    |   97 +++
 drivers/media/video/omap34xxcam.c    |   32 +
 include/asm-arm/arch-omap/isp_user.h |  121 ++++
 8 files changed, 2045 insertions(+), 2 deletions(-)

--- a/drivers/media/video/isp/Makefile	2008-06-29 15:37:34.000000000 -0500
+++ b/drivers/media/video/isp/Makefile	2008-06-29 15:44:08.000000000 -0500
@@ -6,6 +6,6 @@ obj-$(CONFIG_VIDEO_OMAP3) += \
 else
 obj-$(CONFIG_VIDEO_OMAP3) += \
 	isp.o ispccdc.o ispmmu.o \
-	isppreview.o ispresizer.o
+	isppreview.o ispresizer.o isph3a.o isphist.o
 
 endif
--- a/drivers/media/video/isp/isp.c	2008-06-29 15:37:34.000000000 -0500
+++ b/drivers/media/video/isp/isp.c	2008-06-29 15:43:26.000000000 -0500
@@ -43,6 +43,8 @@
 #include "ispmmu.h"
 #include "ispreg.h"
 #include "ispccdc.h"
+#include "isph3a.h"
+#include "isphist.h"
 #include "isppreview.h"
 #include "ispresizer.h"
 
@@ -392,6 +394,18 @@ int isp_set_callback(enum isp_callback_t
 					IRQENABLE_TLBMISS,
 					ISPMMU_IRQENABLE);
 		break;
+	case CBK_H3A_AWB_DONE:
+		omap_writel(IRQ0ENABLE_H3A_AWB_DONE_IRQ, ISP_IRQ0STATUS);
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+					IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+					ISP_IRQ0ENABLE);
+		break;
+	case CBK_HIST_DONE:
+		omap_writel(IRQ0ENABLE_HIST_DONE_IRQ, ISP_IRQ0STATUS);
+		omap_writel(omap_readl(ISP_IRQ0ENABLE) |
+					IRQ0ENABLE_HIST_DONE_IRQ,
+					ISP_IRQ0ENABLE);
+		break;
 	case CBK_LSC_ISR:
 		omap_writel(IRQ0ENABLE_CCDC_LSC_DONE_IRQ |
 					IRQ0ENABLE_CCDC_LSC_PREF_COMP_IRQ |
@@ -458,6 +472,16 @@ int isp_unset_callback(enum isp_callback
 						IRQENABLE_TLBMISS),
 						ISPMMU_IRQENABLE);
 		break;
+	case CBK_H3A_AWB_DONE:
+		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+						~IRQ0ENABLE_H3A_AWB_DONE_IRQ,
+						ISP_IRQ0ENABLE);
+		break;
+	case CBK_HIST_DONE:
+		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
+						~IRQ0ENABLE_HIST_DONE_IRQ,
+						ISP_IRQ0ENABLE);
+		break;
 	case CBK_HS_VS:
 		omap_writel((omap_readl(ISP_IRQ0ENABLE)) &
 						~IRQ0ENABLE_HS_VS_IRQ,
@@ -952,6 +976,22 @@ static irqreturn_t omap34xx_isp_isr(int 
 		is_irqhandled = 1;
 	}
 
+	if ((irqstatus & H3A_AWB_DONE) == H3A_AWB_DONE) {
+		if (irqdis->isp_callbk[CBK_H3A_AWB_DONE])
+			irqdis->isp_callbk[CBK_H3A_AWB_DONE](H3A_AWB_DONE,
+				irqdis->isp_callbk_arg1[CBK_H3A_AWB_DONE],
+				irqdis->isp_callbk_arg2[CBK_H3A_AWB_DONE]);
+		is_irqhandled = 1;
+	}
+
+	if ((irqstatus & HIST_DONE) == HIST_DONE) {
+		if (irqdis->isp_callbk[CBK_HIST_DONE])
+			irqdis->isp_callbk[CBK_HIST_DONE](HIST_DONE,
+				irqdis->isp_callbk_arg1[CBK_HIST_DONE],
+				irqdis->isp_callbk_arg2[CBK_HIST_DONE]);
+		is_irqhandled = 1;
+	}
+
 	if ((irqstatus & HS_VS) == HS_VS) {
 		if (irqdis->isp_callbk[CBK_HS_VS])
 			irqdis->isp_callbk[CBK_HS_VS](HS_VS,
@@ -1246,6 +1286,7 @@ void isp_vbq_done(unsigned long status, 
 				}
 			}
 			isppreview_config_shadow_registers();
+			isph3a_update_wb();
 			if (ispmodule_obj.isp_pipeline & OMAP_ISP_RESIZER)
 				return;
 		}
@@ -1563,6 +1604,44 @@ int isp_handle_private(int cmd, void *ar
 	case VIDIOC_PRIVATE_ISP_PRV_CFG:
 		rval = omap34xx_isp_preview_config(arg);
 		break;
+	case VIDIOC_PRIVATE_ISP_AEWB_CFG:
+		if (!arg)
+			rval = -EFAULT;
+		else {
+			struct isph3a_aewb_config *params;
+			params = (struct isph3a_aewb_config *) arg;
+			rval = isph3a_aewb_configure(params);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_AEWB_REQ:
+		if (!arg)
+			rval = -EFAULT;
+		else {
+			struct isph3a_aewb_data *data;
+			data = (struct isph3a_aewb_data *) arg;
+			rval = isph3a_aewb_request_statistics(data);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_HIST_CFG:
+	if (!arg)
+			rval = -EFAULT;
+		else {
+			struct isp_hist_config *params;
+
+			params = (struct isp_hist_config *) arg;
+			rval = isp_hist_configure(params);
+		}
+		break;
+	case VIDIOC_PRIVATE_ISP_HIST_REQ:
+	if (!arg)
+			rval = -EFAULT;
+		else {
+			struct isp_hist_data *data;
+
+			data = (struct isp_hist_data *) arg;
+			rval = isp_hist_request_statistics(data);
+		}
+		break;
 	default:
 		rval = -EINVAL;
 		break;
@@ -1880,6 +1959,8 @@ void isp_save_ctx(void)
 	isp_save_context(isp_reg_list);
 	ispccdc_save_context();
 	ispmmu_save_context();
+	isphist_save_context();
+	isph3a_save_context();
 	isppreview_save_context();
 	ispresizer_save_context();
 }
@@ -1896,6 +1977,8 @@ void isp_restore_ctx(void)
 	isp_restore_context(isp_reg_list);
 	ispccdc_restore_context();
 	ispmmu_restore_context();
+	isphist_restore_context();
+	isph3a_restore_context();
 	isppreview_restore_context();
 	ispresizer_restore_context();
 }
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isph3a.c	2008-06-29 15:48:58.000000000 -0500
@@ -0,0 +1,922 @@
+/*
+ * drivers/media/video/isp/isph3a.c
+ *
+ * H3A module for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isph3a.h"
+#include "ispmmu.h"
+#include "isppreview.h"
+
+/**
+ * struct isph3a_aewb_buffer - AE, AWB frame stats buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ * @locked: 1 - Buffer locked from write. 0 - Buffer can be overwritten.
+ * @frame_num: Frame number from which the statistics are taken.
+ * @next: Pointer to link next buffer.
+ */
+struct isph3a_aewb_buffer {
+	unsigned long virt_addr;
+	unsigned long phy_addr;
+	unsigned long addr_align;
+	unsigned long ispmmu_addr;
+	unsigned long mmap_addr;	/* For userspace */
+
+	u8 locked;
+	u16 frame_num;
+	struct isph3a_aewb_buffer *next;
+};
+
+/**
+ * struct isph3a_aewb_status - AE, AWB status.
+ * @initialized: 1 - Buffers initialized.
+ * @update: 1 - Update registers.
+ * @stats_req: 1 - Future stats requested.
+ * @stats_done: 1 - Stats ready for user.
+ * @frame_req: Number of frame requested for statistics.
+ * @h3a_buff: Array of statistics buffers to access.
+ * @stats_buf_size: Statistics buffer size.
+ * @min_buf_size: Minimum statisitics buffer size.
+ * @win_count: Window Count.
+ * @frame_count: Frame Count.
+ * @stats_wait: Wait primitive for locking/unlocking the stats request.
+ * @buffer_lock: Spinlock for statistics buffers access.
+ */
+static struct isph3a_aewb_status {
+	u8 initialized;
+	u8 update;
+	u8 stats_req;
+	u8 stats_done;
+	u16 frame_req;
+
+	struct isph3a_aewb_buffer h3a_buff[H3A_MAX_BUFF];
+	unsigned int stats_buf_size;
+	unsigned int min_buf_size;
+
+	u16 win_count;
+	u32 frame_count;
+	wait_queue_head_t stats_wait;
+	spinlock_t buffer_lock;
+} aewbstat;
+
+/**
+ * struct isph3a_aewb_regs - Current value of AE, AWB configuration registers.
+ * reg_pcr: Peripheral control register.
+ * reg_win1: Control register.
+ * reg_start: Start position register.
+ * reg_blk: Black line register.
+ * reg_subwin: Configuration register.
+ */
+static struct isph3a_aewb_regs {
+	u32 reg_pcr;
+	u32 reg_win1;
+	u32 reg_start;
+	u32 reg_blk;
+	u32 reg_subwin;
+} aewb_regs;
+
+static struct isph3a_aewb_config aewb_config_local = {
+	.saturation_limit = 0x3FF,
+	.win_height = 0,
+	.win_width = 0,
+	.ver_win_count = 0,
+	.hor_win_count = 0,
+	.ver_win_start = 0,
+	.hor_win_start = 0,
+	.blk_ver_win_start = 0,
+	.blk_win_height = 0,
+	.subsample_ver_inc = 0,
+	.subsample_hor_inc = 0,
+	.alaw_enable = 0,
+	.aewb_enable = 0,
+};
+
+/* Structure for saving/restoring h3a module registers */
+static struct isp_reg isph3a_reg_list[] = {
+	{ISPH3A_AEWWIN1, 0},
+	{ISPH3A_AEWINSTART, 0},
+	{ISPH3A_AEWINBLK, 0},
+	{ISPH3A_AEWSUBWIN, 0},
+	{ISPH3A_AEWBUFST, 0},
+	{ISPH3A_AFPAX1, 0},
+	{ISPH3A_AFPAX2, 0},
+	{ISPH3A_AFPAXSTART, 0},
+	{ISPH3A_AFIIRSH, 0},
+	{ISPH3A_AFBUFST, 0},
+	{ISPH3A_AFCOEF010, 0},
+	{ISPH3A_AFCOEF032, 0},
+	{ISPH3A_AFCOEF054, 0},
+	{ISPH3A_AFCOEF076, 0},
+	{ISPH3A_AFCOEF098, 0},
+	{ISPH3A_AFCOEF0010, 0},
+	{ISPH3A_AFCOEF110, 0},
+	{ISPH3A_AFCOEF132, 0},
+	{ISPH3A_AFCOEF154, 0},
+	{ISPH3A_AFCOEF176, 0},
+	{ISPH3A_AFCOEF198, 0},
+	{ISPH3A_AFCOEF1010, 0},
+	{ISP_TOK_TERM, 0}
+};
+
+static struct ispprev_wbal h3awb_update;
+static struct isph3a_aewb_buffer *active_buff;
+static struct isph3a_aewb_xtrastats h3a_xtrastats[H3A_MAX_BUFF];
+static int camnotify;
+static int wb_update;
+static void isph3a_print_status(void);
+
+/**
+ * isph3a_aewb_setxtrastats - Receives extra statistics from prior frames.
+ * @xtrastats: Pointer to structure containing extra statistics fields like
+ *             field count and timestamp of frame.
+ *
+ * Called from update_vbq in camera driver
+ **/
+void isph3a_aewb_setxtrastats(struct isph3a_aewb_xtrastats *xtrastats)
+{
+	int i;
+	if (active_buff == NULL)
+		return;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (aewbstat.h3a_buff[i].frame_num == active_buff->frame_num) {
+			if (i == 0) {
+				if (aewbstat.h3a_buff[H3A_MAX_BUFF - 1].
+								locked == 0)
+					h3a_xtrastats[H3A_MAX_BUFF - 1] =
+								*xtrastats;
+				else
+					h3a_xtrastats[H3A_MAX_BUFF - 2] =
+								*xtrastats;
+			} else if (i == 1) {
+				if (aewbstat.h3a_buff[0].locked == 0)
+					h3a_xtrastats[0] = *xtrastats;
+				else
+					h3a_xtrastats[H3A_MAX_BUFF - 1] =
+								*xtrastats;
+			} else {
+				if (aewbstat.h3a_buff[i - 1].locked == 0)
+					h3a_xtrastats[i - 1] = *xtrastats;
+				else
+					h3a_xtrastats[i - 2] = *xtrastats;
+			}
+			return;
+		}
+	}
+}
+EXPORT_SYMBOL(isph3a_aewb_setxtrastats);
+
+/**
+ * isph3a_aewb_enable - Enables AE, AWB engine in the H3A module.
+ * @enable: 1 - Enables the AE & AWB engine.
+ *
+ * Client should configure all the AE & AWB registers in H3A before this.
+ **/
+static void isph3a_aewb_enable(u8 enable)
+{
+	omap_writel(IRQ0STATUS_H3A_AWB_DONE_IRQ, ISP_IRQ0STATUS);
+
+	if (enable) {
+		aewb_regs.reg_pcr |= ISPH3A_PCR_AEW_EN;
+		omap_writel(omap_readl(ISPH3A_PCR) | ISPH3A_PCR_AEW_EN,
+								ISPH3A_PCR);
+		DPRINTK_ISPH3A("    H3A enabled \n");
+	} else {
+		aewb_regs.reg_pcr &= ~ISPH3A_PCR_AEW_EN;
+		omap_writel(omap_readl(ISPH3A_PCR) & ~ISPH3A_PCR_AEW_EN,
+								ISPH3A_PCR);
+		DPRINTK_ISPH3A("    H3A disabled \n");
+	}
+	aewb_config_local.aewb_enable = enable;
+}
+
+/**
+ * isph3a_update_wb - Updates WB parameters.
+ *
+ * Needs to be called when no ISP Preview processing is taking place.
+ **/
+void isph3a_update_wb(void)
+{
+	if (wb_update) {
+		isppreview_config_whitebalance(h3awb_update);
+		wb_update = 0;
+	}
+	return;
+}
+EXPORT_SYMBOL(isph3a_update_wb);
+
+/**
+ * isph3a_aewb_update_regs - Helper function to update h3a registers.
+ **/
+static void isph3a_aewb_update_regs(void)
+{
+	omap_writel(aewb_regs.reg_pcr, ISPH3A_PCR);
+	omap_writel(aewb_regs.reg_win1, ISPH3A_AEWWIN1);
+	omap_writel(aewb_regs.reg_start, ISPH3A_AEWINSTART);
+	omap_writel(aewb_regs.reg_blk, ISPH3A_AEWINBLK);
+	omap_writel(aewb_regs.reg_subwin, ISPH3A_AEWSUBWIN);
+
+	aewbstat.update = 0;
+	aewbstat.frame_count = 0;
+}
+
+/**
+ * isph3a_aewb_update_req_buffer - Helper function to update buffer cache pages
+ * @buffer: Pointer to structure
+ **/
+static void isph3a_aewb_update_req_buffer(struct isph3a_aewb_buffer *buffer)
+{
+	int size = aewbstat.stats_buf_size;
+
+	size = PAGE_ALIGN(size);
+	dmac_inv_range((void *)buffer->addr_align,
+		(void *)buffer->addr_align + size);
+}
+
+/**
+ * isph3a_aewb_stats_available - Check for stats available of specified frame.
+ * @aewbdata: Pointer to return AE AWB statistics data
+ *
+ * Returns 0 if successful, or -1 if statistics are unavailable.
+ **/
+static int isph3a_aewb_stats_available(struct isph3a_aewb_data *aewbdata)
+{
+	int i;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&aewbstat.buffer_lock, irqflags);
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if ((aewbdata->frame_number == aewbstat.h3a_buff[i].frame_num)
+					&& (aewbstat.h3a_buff[i].frame_num !=
+					active_buff->frame_num)) {
+			aewbstat.h3a_buff[i].locked = 1;
+			spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+			isph3a_aewb_update_req_buffer(&aewbstat.h3a_buff[i]);
+			aewbstat.h3a_buff[i].frame_num = 0;
+			aewbdata->h3a_aewb_statistics_buf = (void *)
+						aewbstat.h3a_buff[i].mmap_addr;
+			aewbdata->ts = h3a_xtrastats[i].ts;
+			aewbdata->field_count = h3a_xtrastats[i].field_count;
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+
+	aewbdata->h3a_aewb_statistics_buf = NULL;
+	return -1;
+}
+
+/**
+ * isph3a_aewb_link_buffers - Helper function to link allocated buffers.
+ **/
+static void isph3a_aewb_link_buffers(void)
+{
+	int i;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if ((i + 1) < H3A_MAX_BUFF) {
+			aewbstat.h3a_buff[i].next = &aewbstat.h3a_buff[i + 1];
+			h3a_xtrastats[i].next = &h3a_xtrastats[i + 1];
+		} else {
+			aewbstat.h3a_buff[i].next = &aewbstat.h3a_buff[0];
+			h3a_xtrastats[i].next = &h3a_xtrastats[0];
+		}
+	}
+}
+
+/**
+ * isph3a_aewb_unlock_buffers - Helper function to unlock all buffers.
+ **/
+static void isph3a_aewb_unlock_buffers(void)
+{
+	int i;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&aewbstat.buffer_lock, irqflags);
+	for (i = 0; i < H3A_MAX_BUFF; i++)
+		aewbstat.h3a_buff[i].locked = 0;
+
+	spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+}
+
+/**
+ * isph3a_aewb_isr - Callback from ISP driver for H3A AEWB interrupt.
+ * @status: IRQ0STATUS in case of MMU error, 0 for H3A interrupt.
+ * @arg1: Not used as of now.
+ * @arg2: Not used as of now.
+ */
+static void isph3a_aewb_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+								void *arg2)
+{
+	u16 frame_align;
+
+	if ((H3A_AWB_DONE & status) != H3A_AWB_DONE)
+		return;
+
+	active_buff = active_buff->next;
+	if (active_buff->locked == 1)
+		active_buff = active_buff->next;
+	omap_writel(active_buff->ispmmu_addr, ISPH3A_AEWBUFST);
+
+	aewbstat.frame_count++;
+	frame_align = aewbstat.frame_count;
+	if (aewbstat.frame_count > MAX_FRAME_COUNT) {
+		aewbstat.frame_count = 1;
+		frame_align++;
+	}
+	active_buff->frame_num = aewbstat.frame_count;
+
+	if (aewbstat.stats_req) {
+		DPRINTK_ISPH3A("waiting for frame %d\n", aewbstat.frame_req);
+		if (frame_align >= (aewbstat.frame_req + 1)) {
+			aewbstat.stats_req = 0;
+			aewbstat.stats_done = 1;
+			wake_up_interruptible(&aewbstat.stats_wait);
+		}
+	}
+
+	if (aewbstat.update)
+		isph3a_aewb_update_regs();
+
+	DPRINTK_ISPH3A(".");
+}
+
+/**
+ * isph3a_aewb_set_params - Helper function to check & store user given params.
+ * @user_cfg: Pointer to AE and AWB parameters struct.
+ *
+ * As most of them are busy-lock registers, need to wait until AEW_BUSY = 0 to
+ * program them during ISR.
+ *
+ * Returns 0 if successful, or -EINVAL if any of the parameters are invalid.
+ **/
+static int isph3a_aewb_set_params(struct isph3a_aewb_config *user_cfg)
+{
+	if (unlikely(user_cfg->saturation_limit > MAX_SATURATION_LIM)) {
+		printk(KERN_ERR "Invalid Saturation_limit: %d\n",
+			user_cfg->saturation_limit);
+		return -EINVAL;
+	} else if (aewb_config_local.saturation_limit !=
+						user_cfg->saturation_limit) {
+		WRITE_SAT_LIM(aewb_regs.reg_pcr, user_cfg->saturation_limit);
+		aewb_config_local.saturation_limit =
+						user_cfg->saturation_limit;
+		aewbstat.update = 1;
+	}
+
+	if (aewb_config_local.alaw_enable != user_cfg->alaw_enable) {
+		WRITE_ALAW(aewb_regs.reg_pcr, user_cfg->alaw_enable);
+		aewb_config_local.alaw_enable = user_cfg->alaw_enable;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->win_height < MIN_WIN_H) ||
+					(user_cfg->win_height > MAX_WIN_H) ||
+					(user_cfg->win_height & 0x01))) {
+		printk(KERN_ERR "Invalid window height: %d\n",
+							user_cfg->win_height);
+		return -EINVAL;
+	} else if (aewb_config_local.win_height != user_cfg->win_height) {
+		WRITE_WIN_H(aewb_regs.reg_win1, user_cfg->win_height);
+		aewb_config_local.win_height = user_cfg->win_height;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->win_width < MIN_WIN_W) ||
+					(user_cfg->win_width > MAX_WIN_W) ||
+					(user_cfg->win_width & 0x01))) {
+		printk(KERN_ERR "Invalid window width: %d\n",
+							user_cfg->win_width);
+		return -EINVAL;
+	} else if (aewb_config_local.win_width != user_cfg->win_width) {
+		WRITE_WIN_W(aewb_regs.reg_win1, user_cfg->win_width);
+		aewb_config_local.win_width = user_cfg->win_width;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->ver_win_count < 1) ||
+				(user_cfg->ver_win_count > MAX_WINVC))) {
+		printk(KERN_ERR "Invalid vertical window count: %d\n",
+						user_cfg->ver_win_count);
+		return -EINVAL;
+	} else if (aewb_config_local.ver_win_count
+						!= user_cfg->ver_win_count) {
+		WRITE_VER_C(aewb_regs.reg_win1, user_cfg->ver_win_count);
+		aewb_config_local.ver_win_count = user_cfg->ver_win_count;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->hor_win_count < 1) ||
+				(user_cfg->hor_win_count > MAX_WINHC))) {
+		printk(KERN_ERR "Invalid horizontal window count: %d\n",
+						user_cfg->hor_win_count);
+		return -EINVAL;
+	} else if (aewb_config_local.hor_win_count
+						!= user_cfg->hor_win_count) {
+		WRITE_HOR_C(aewb_regs.reg_win1,
+					user_cfg->hor_win_count);
+		aewb_config_local.hor_win_count	=
+					user_cfg->hor_win_count;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->ver_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid vertical window start: %d\n",
+			user_cfg->ver_win_start);
+		return -EINVAL;
+	} else if (aewb_config_local.ver_win_start
+						!= user_cfg->ver_win_start) {
+		WRITE_VER_WIN_ST(aewb_regs.reg_start, user_cfg->ver_win_start);
+		aewb_config_local.ver_win_start = user_cfg->ver_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->hor_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid horizontal window start: %d\n",
+			user_cfg->hor_win_start);
+		return -EINVAL;
+	} else if (aewb_config_local.hor_win_start
+				!= user_cfg->hor_win_start){
+		WRITE_HOR_WIN_ST(aewb_regs.reg_start,
+					 user_cfg->hor_win_start);
+		aewb_config_local.hor_win_start	=
+					user_cfg->hor_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->blk_ver_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid black vertical window start: %d\n",
+			user_cfg->blk_ver_win_start);
+		return -EINVAL;
+	} else if (aewb_config_local.blk_ver_win_start
+				!= user_cfg->blk_ver_win_start){
+		WRITE_BLK_VER_WIN_ST(aewb_regs.reg_blk,
+					user_cfg->blk_ver_win_start);
+		aewb_config_local.blk_ver_win_start =
+					user_cfg->blk_ver_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->blk_win_height < MIN_WIN_H)
+			|| (user_cfg->blk_win_height > MAX_WIN_H)
+			|| (user_cfg->blk_win_height & 0x01))) {
+		printk(KERN_ERR "Invalid black window height: %d\n",
+			user_cfg->blk_win_height);
+		return -EINVAL;
+	} else if (aewb_config_local.blk_win_height
+				!= user_cfg->blk_win_height) {
+		WRITE_BLK_WIN_H(aewb_regs.reg_blk,
+				user_cfg->blk_win_height);
+		aewb_config_local.blk_win_height
+				= user_cfg->blk_win_height;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->subsample_ver_inc < MIN_SUB_INC)
+			|| (user_cfg->subsample_ver_inc > MAX_SUB_INC)
+			|| (user_cfg->subsample_ver_inc & 0x01))) {
+		printk(KERN_ERR "Invalid vertical subsample increment: %d\n",
+			user_cfg->subsample_ver_inc);
+		return -EINVAL;
+	} else if (aewb_config_local.subsample_ver_inc
+				!= user_cfg->subsample_ver_inc) {
+		WRITE_SUB_VER_INC(aewb_regs.reg_subwin,
+						user_cfg->subsample_ver_inc);
+		aewb_config_local.subsample_ver_inc
+					= user_cfg->subsample_ver_inc;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->subsample_hor_inc < MIN_SUB_INC)
+			|| (user_cfg->subsample_hor_inc > MAX_SUB_INC)
+			|| (user_cfg->subsample_hor_inc & 0x01))) {
+		printk(KERN_ERR "Invalid horizontal subsample increment: %d\n",
+			user_cfg->subsample_hor_inc);
+		return -EINVAL;
+	} else if (aewb_config_local.subsample_hor_inc
+				!= user_cfg->subsample_hor_inc) {
+		WRITE_SUB_HOR_INC(aewb_regs.reg_subwin,
+						user_cfg->subsample_hor_inc);
+		aewb_config_local.subsample_hor_inc
+					= user_cfg->subsample_hor_inc;
+		aewbstat.update = 1;
+	}
+
+	if ((!aewbstat.initialized) || (0 == aewb_config_local.aewb_enable)) {
+		isph3a_aewb_update_regs();
+		aewbstat.initialized = 1;
+	}
+	return 0;
+}
+
+/**
+ * isph3a_aewb_munmap - Unmap kernel buffer memory from user space.
+ * @buffer: Pointer to structure containing buffer information.
+ *
+ * Always returns 0.
+ **/
+static int isph3a_aewb_munmap(struct isph3a_aewb_buffer *buffer)
+{
+	buffer->mmap_addr = 0;
+	return 0;
+}
+
+/**
+ * isph3a_aewb_mmap_buffers - Map buffer memory to user space.
+ * @buffer: Pointer to structure containing buffer information.
+ *
+ * Buffer passed need to already have a valid physical address:
+ *      buffer->phy_addr
+ *
+ * Returns user pointer as unsigned long in buffer->mmap_addr
+ **/
+static int isph3a_aewb_mmap_buffers(struct isph3a_aewb_buffer *buffer)
+{
+	struct vm_area_struct vma;
+	struct mm_struct *mm = current->mm;
+	int size = aewbstat.stats_buf_size;
+	unsigned long addr = 0;
+	unsigned long pgoff = 0, flags = MAP_SHARED | MAP_ANONYMOUS;
+	unsigned long prot = PROT_READ | PROT_WRITE;
+	void *pos = (void *)buffer->addr_align;
+
+	size = PAGE_ALIGN(size);
+
+	addr = get_unmapped_area(NULL, addr, size, pgoff, flags);
+	vma.vm_mm = mm;
+	vma.vm_start = addr;
+	vma.vm_end = addr + size;
+	vma.vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
+	vma.vm_pgoff = pgoff;
+	vma.vm_file = NULL;
+	vma.vm_page_prot = protection_map[vma.vm_flags];
+
+	while (size > 0) {
+		if (vm_insert_page(&vma, addr, vmalloc_to_page(pos)))
+			return -EAGAIN;
+		addr += PAGE_SIZE;
+		pos += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	buffer->mmap_addr = vma.vm_start;
+	return 0;
+}
+
+/**
+ * isph3a_aewb_configure - Configure AEWB regs, enable/disable H3A engine.
+ * @aewbcfg: Pointer to AEWB config structure.
+ *
+ * Returns 0 if successful, -EINVAL if aewbcfg pointer is NULL, -ENOMEM if
+ * was unable to allocate memory for the buffer, of other errors if H3A
+ * callback is not set or the parameters for AEWB are invalid.
+ **/
+int isph3a_aewb_configure(struct isph3a_aewb_config *aewbcfg)
+{
+	int ret = 0;
+	int i;
+	int win_count = 0;
+
+	if (NULL == aewbcfg) {
+		printk(KERN_ERR "Null argument in configuration. \n");
+		return -EINVAL;
+	}
+
+	if (!aewbstat.initialized) {
+		DPRINTK_ISPH3A("Setting callback for H3A\n");
+		ret = isp_set_callback(CBK_H3A_AWB_DONE, isph3a_aewb_isr,
+					(void *)NULL, (void *)NULL);
+		if (ret) {
+			printk(KERN_ERR "No callback for H3A\n");
+			return ret;
+		}
+	}
+
+	ret = isph3a_aewb_set_params(aewbcfg);
+	if (ret) {
+		printk(KERN_ERR "Invalid parameters! \n");
+		return ret;
+	}
+
+	win_count = (aewbcfg->ver_win_count * aewbcfg->hor_win_count);
+	win_count += aewbcfg->hor_win_count;
+	ret = (win_count / 8);
+	win_count += (win_count % 8) ? 1: 0;
+	win_count += ret;
+
+	aewbstat.win_count = win_count;
+
+	if (aewbstat.stats_buf_size && ((win_count * AEWB_PACKET_SIZE) >
+						aewbstat.stats_buf_size)) {
+		DPRINTK_ISPH3A("There was a previous buffer... \n");
+		isph3a_aewb_enable(0);
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			isph3a_aewb_munmap(&aewbstat.h3a_buff[i]);
+			ispmmu_unmap(aewbstat.h3a_buff[i].ispmmu_addr);
+			dma_free_coherent(NULL, aewbstat.min_buf_size + 64,
+					(void *)aewbstat.h3a_buff[i].
+					virt_addr, (dma_addr_t)aewbstat.
+					h3a_buff[i].phy_addr);
+			aewbstat.h3a_buff[i].virt_addr = 0;
+		}
+		aewbstat.stats_buf_size = 0;
+	}
+
+	if (!aewbstat.h3a_buff[0].virt_addr) {
+		aewbstat.stats_buf_size = win_count * AEWB_PACKET_SIZE;
+		aewbstat.min_buf_size = PAGE_ALIGN(aewbstat.stats_buf_size);
+
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			aewbstat.h3a_buff[i].virt_addr =
+					(unsigned long)dma_alloc_coherent(NULL,
+						aewbstat.min_buf_size,
+						(dma_addr_t *)
+						&aewbstat.h3a_buff[i].
+						phy_addr, GFP_KERNEL |
+						GFP_DMA);
+			if (aewbstat.h3a_buff[i].virt_addr == 0) {
+				printk(KERN_ERR "Can't acquire memory for "
+					"buffer[%d]\n", i);
+				return -ENOMEM;
+			}
+			aewbstat.h3a_buff[i].addr_align =
+					aewbstat.h3a_buff[i].virt_addr;
+			while ((aewbstat.h3a_buff[i].addr_align &
+							0xFFFFFFC0) !=
+							aewbstat.h3a_buff[i].
+							addr_align)
+				aewbstat.h3a_buff[i].addr_align++;
+			aewbstat.h3a_buff[i].ispmmu_addr =
+							ispmmu_map(aewbstat.
+							h3a_buff[i].phy_addr,
+							aewbstat.min_buf_size);
+		}
+		isph3a_aewb_unlock_buffers();
+		isph3a_aewb_link_buffers();
+
+		if (active_buff == NULL)
+			active_buff = &aewbstat.h3a_buff[0];
+		omap_writel(active_buff->ispmmu_addr, ISPH3A_AEWBUFST);
+	}
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (aewbstat.h3a_buff[i].mmap_addr) {
+			isph3a_aewb_munmap(&aewbstat.h3a_buff[i]);
+			DPRINTK_ISPH3A("We have munmaped buffer 0x%lX\n",
+				aewbstat.h3a_buff[i].virt_addr);
+		}
+		isph3a_aewb_mmap_buffers(&aewbstat.h3a_buff[i]);
+		DPRINTK_ISPH3A("buff[%d] addr is:\n    virt    0x%lX\n"
+					"    aligned 0x%lX\n"
+					"    phys    0x%lX\n"
+					"    ispmmu  0x%08lX\n"
+					"    mmapped 0x%lX\n", i,
+					aewbstat.h3a_buff[i].virt_addr,
+					aewbstat.h3a_buff[i].addr_align,
+					aewbstat.h3a_buff[i].phy_addr,
+					aewbstat.h3a_buff[i].ispmmu_addr,
+					aewbstat.h3a_buff[i].mmap_addr);
+	}
+	isph3a_aewb_enable(aewbcfg->aewb_enable);
+	isph3a_print_status();
+
+	return 0;
+}
+EXPORT_SYMBOL(isph3a_aewb_configure);
+
+/**
+ * isph3a_aewb_request_statistics - REquest statistics and update gains in AEWB
+ * @aewbdata: Pointer to return AE AWB statistics data.
+ *
+ * This API allows the user to update White Balance gains, as well as
+ * exposure time and analog gain. It is also used to request frame
+ * statistics.
+ *
+ * Returns 0 if successful, -EINVAL when H3A engine is not enabled, or other
+ * errors when setting gains.
+ **/
+int isph3a_aewb_request_statistics(struct isph3a_aewb_data *aewbdata)
+{
+	int ret = 0;
+	u16 frame_diff = 0;
+	u16 frame_cnt = aewbstat.frame_count;
+	wait_queue_t wqt;
+
+	if (!aewb_config_local.aewb_enable) {
+		printk(KERN_ERR "H3A engine not enabled\n");
+		return -EINVAL;
+	}
+	aewbdata->h3a_aewb_statistics_buf = NULL;
+
+	DPRINTK_ISPH3A("User data received: \n");
+	DPRINTK_ISPH3A("Digital gain = 0x%04x\n", aewbdata->dgain);
+	DPRINTK_ISPH3A("WB gain b *=   0x%04x\n", aewbdata->wb_gain_b);
+	DPRINTK_ISPH3A("WB gain r *=   0x%04x\n", aewbdata->wb_gain_r);
+	DPRINTK_ISPH3A("WB gain gb =   0x%04x\n", aewbdata->wb_gain_gb);
+	DPRINTK_ISPH3A("WB gain gr =   0x%04x\n", aewbdata->wb_gain_gr);
+	DPRINTK_ISPH3A("ISP AEWB request status wait for interrupt\n");
+
+	if (aewbdata->update != 0) {
+		if (aewbdata->update & SET_DIGITAL_GAIN)
+			h3awb_update.dgain = (u16)aewbdata->dgain;
+		if (aewbdata->update & SET_COLOR_GAINS) {
+			h3awb_update.coef3 = (u8)aewbdata->wb_gain_b;
+			h3awb_update.coef2 = (u8)aewbdata->wb_gain_gr;
+			h3awb_update.coef1 = (u8)aewbdata->wb_gain_gb;
+			h3awb_update.coef0 = (u8)aewbdata->wb_gain_r;
+		}
+		if (aewbdata->update & (SET_COLOR_GAINS | SET_DIGITAL_GAIN))
+			wb_update = 1;
+
+		if (aewbdata->update & REQUEST_STATISTICS) {
+			isph3a_aewb_unlock_buffers();
+
+			DPRINTK_ISPH3A("Stats available?\n");
+			ret = isph3a_aewb_stats_available(aewbdata);
+			if (!ret)
+				goto out;
+
+			DPRINTK_ISPH3A("Stats in near future?\n");
+			if (aewbdata->frame_number > frame_cnt) {
+				frame_diff = aewbdata->frame_number - frame_cnt;
+			} else if (aewbdata->frame_number < frame_cnt) {
+				if ((frame_cnt > (MAX_FRAME_COUNT -
+							MAX_FUTURE_FRAMES))
+							&& (aewbdata->
+							frame_number
+							< MAX_FRAME_COUNT))
+					frame_diff = aewbdata->frame_number
+							+ MAX_FRAME_COUNT
+							- frame_cnt;
+				else {
+					frame_diff = MAX_FUTURE_FRAMES + 1;
+					aewbdata->h3a_aewb_statistics_buf =
+									NULL;
+				}
+			}
+
+			if (frame_diff > MAX_FUTURE_FRAMES) {
+				printk(KERN_ERR "Invalid frame requested\n");
+
+			} else if (!camnotify) {
+				aewbstat.frame_req = aewbdata->frame_number;
+				aewbstat.stats_req = 1;
+				aewbstat.stats_done = 0;
+				init_waitqueue_entry(&wqt, current);
+				ret = wait_event_interruptible
+						(aewbstat.stats_wait,
+						aewbstat.stats_done == 1);
+				if (ret < 0)
+					return ret;
+
+				DPRINTK_ISPH3A("ISP AEWB request status"
+						" interrupt raised\n");
+				ret = isph3a_aewb_stats_available(aewbdata);
+				if (ret) {
+					DPRINTK_ISPH3A
+						("After waiting for stats,"
+						" stats not available!!\n");
+				}
+			}
+		}
+	}
+out:
+	aewbdata->curr_frame = aewbstat.frame_count;
+
+	return 0;
+}
+EXPORT_SYMBOL(isph3a_aewb_request_statistics);
+
+/**
+ * isph3a_aewb_init - Module Initialisation.
+ *
+ * Always returns 0.
+ **/
+static int __init isph3a_aewb_init(void)
+{
+	memset(&aewbstat, 0, sizeof(aewbstat));
+	memset(&aewb_regs, 0, sizeof(aewb_regs));
+
+	init_waitqueue_head(&aewbstat.stats_wait);
+	spin_lock_init(&aewbstat.buffer_lock);
+	return 0;
+}
+
+/**
+ * isph3a_aewb_cleanup - Module exit.
+ **/
+static void isph3a_aewb_cleanup(void)
+{
+	int i;
+	isph3a_aewb_enable(0);
+	isp_unset_callback(CBK_H3A_AWB_DONE);
+
+	if (aewbstat.h3a_buff) {
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			ispmmu_unmap(aewbstat.h3a_buff[i].ispmmu_addr);
+			dma_free_coherent(NULL, aewbstat.min_buf_size + 64,
+					(void *)aewbstat.h3a_buff[i].
+					virt_addr, (dma_addr_t)aewbstat.
+					h3a_buff[i].phy_addr);
+		}
+	}
+	memset(&aewbstat, 0, sizeof(aewbstat));
+	memset(&aewb_regs, 0, sizeof(aewb_regs));
+}
+
+/**
+ * isph3a_print_status - Debug print. Values of H3A related registers.
+ **/
+static void isph3a_print_status(void)
+{
+	DPRINTK_ISPH3A("ISPH3A_PCR = 0x%08x\n", omap_readl(ISPH3A_PCR));
+	DPRINTK_ISPH3A("ISPH3A_AEWWIN1 = 0x%08x\n",
+						omap_readl(ISPH3A_AEWWIN1));
+	DPRINTK_ISPH3A("ISPH3A_AEWINSTART = 0x%08x\n",
+						omap_readl(ISPH3A_AEWINSTART));
+	DPRINTK_ISPH3A("ISPH3A_AEWINBLK = 0x%08x\n",
+						omap_readl(ISPH3A_AEWINBLK));
+	DPRINTK_ISPH3A("ISPH3A_AEWSUBWIN = 0x%08x\n",
+						omap_readl(ISPH3A_AEWSUBWIN));
+	DPRINTK_ISPH3A("ISPH3A_AEWBUFST = 0x%08x\n",
+						omap_readl(ISPH3A_AEWBUFST));
+	DPRINTK_ISPH3A("stats windows = %d\n", aewbstat.win_count);
+	DPRINTK_ISPH3A("stats buff size = %d\n", aewbstat.stats_buf_size);
+}
+
+/**
+ * isph3a_notify - Unblocks user request for statistics when camera is off
+ * @notify: 1 - Camera is turned off
+ *
+ * Used when the user has requested statistics about a future frame, but the
+ * camera is turned off before it happens, and this function unblocks the
+ * request so the user can continue in its program.
+ **/
+void isph3a_notify(int notify)
+{
+	camnotify = notify;
+	if (camnotify && aewbstat.initialized) {
+		printk(KERN_DEBUG "Warning Camera Off \n");
+		aewbstat.stats_req = 0;
+		aewbstat.stats_done = 1;
+		wake_up_interruptible(&aewbstat.stats_wait);
+	}
+}
+EXPORT_SYMBOL(isph3a_notify);
+
+/**
+ * isph3a_save_context - Saves the values of the h3a module registers.
+ **/
+void isph3a_save_context(void)
+{
+	DPRINTK_ISPH3A(" Saving context\n");
+	isp_save_context(isph3a_reg_list);
+}
+EXPORT_SYMBOL(isph3a_save_context);
+
+/**
+ * isph3a_restore_context - Restores the values of the h3a module registers.
+ **/
+void isph3a_restore_context(void)
+{
+	DPRINTK_ISPH3A(" Restoring context\n");
+	isp_restore_context(isph3a_reg_list);
+}
+EXPORT_SYMBOL(isph3a_restore_context);
+
+module_init(isph3a_aewb_init);
+module_exit(isph3a_aewb_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("H3A ISP Module");
+MODULE_LICENSE("GPL");
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isph3a.h	2008-06-29 15:48:58.000000000 -0500
@@ -0,0 +1,139 @@
+/*
+ * drivers/media/video/isp/isph3a.h
+ *
+ * Include file for H3A module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_H3A_H
+#define OMAP_ISP_H3A_H
+
+#include <asm/arch/isp_user.h>
+
+#define AEWB_PACKET_SIZE	16
+#define H3A_MAX_BUFF		5
+
+/* Flags for changed registers */
+#define PCR_CHNG		(1 << 0)
+#define AEWWIN1_CHNG		(1 << 1)
+#define AEWINSTART_CHNG		(1 << 2)
+#define AEWINBLK_CHNG		(1 << 3)
+#define AEWSUBWIN_CHNG		(1 << 4)
+#define PRV_WBDGAIN_CHNG	(1 << 5)
+#define PRV_WBGAIN_CHNG		(1 << 6)
+
+/* Flags for update field */
+#define REQUEST_STATISTICS	(1 << 0)
+#define SET_COLOR_GAINS		(1 << 1)
+#define SET_DIGITAL_GAIN	(1 << 2)
+#define SET_EXPOSURE		(1 << 3)
+#define SET_ANALOG_GAIN		(1 << 4)
+
+#define MAX_SATURATION_LIM	1023
+#define MIN_WIN_H		2
+#define MAX_WIN_H		256
+#define MIN_WIN_W		6
+#define MAX_WIN_W		256
+#define MAX_WINVC		128
+#define MAX_WINHC		36
+#define MAX_WINSTART		4095
+#define MIN_SUB_INC		2
+#define MAX_SUB_INC		32
+
+
+/* ISPH3A REGISTERS bits */
+#define ISPH3A_PCR_AF_EN	(1 << 0)
+#define ISPH3A_PCR_AF_ALAW_EN	(1 << 1)
+#define ISPH3A_PCR_AF_MED_EN	(1 << 2)
+#define ISPH3A_PCR_AF_BUSY	(1 << 15)
+#define ISPH3A_PCR_AEW_EN	(1 << 16)
+#define ISPH3A_PCR_AEW_ALAW_EN	(1 << 17)
+#define ISPH3A_PCR_AEW_BUSY	(1 << 18)
+
+#define WRITE_SAT_LIM(reg, sat_limit)	\
+		(reg = (reg & (~(ISPH3A_PCR_AEW_AVE2LMT_MASK))) \
+			| (sat_limit << ISPH3A_PCR_AEW_AVE2LMT_SHIFT))
+
+#define WRITE_ALAW(reg, alaw_en) \
+		(reg = (reg & (~(ISPH3A_PCR_AEW_ALAW_EN))) \
+			| ((alaw_en & ISPH3A_PCR_AF_ALAW_EN) \
+			<< ISPH3A_PCR_AEW_ALAW_EN_SHIFT))
+
+#define WRITE_WIN_H(reg, height) \
+		(reg = (reg & (~(ISPH3A_AEWWIN1_WINH_MASK))) \
+			| (((height >> 1) - 1) << ISPH3A_AEWWIN1_WINH_SHIFT))
+
+#define WRITE_WIN_W(reg, width) \
+		(reg = (reg & (~(ISPH3A_AEWWIN1_WINW_MASK))) \
+			| (((width >> 1) - 1) << ISPH3A_AEWWIN1_WINW_SHIFT))
+
+#define WRITE_VER_C(reg, ver_count) \
+		(reg = (reg & ~(ISPH3A_AEWWIN1_WINVC_MASK)) \
+			| ((ver_count - 1) << ISPH3A_AEWWIN1_WINVC_SHIFT))
+
+#define WRITE_HOR_C(reg, hor_count) \
+		(reg = (reg & ~(ISPH3A_AEWWIN1_WINHC_MASK)) \
+			| ((hor_count - 1) << ISPH3A_AEWWIN1_WINHC_SHIFT))
+
+#define WRITE_VER_WIN_ST(reg, ver_win_st) \
+		(reg = (reg & ~(ISPH3A_AEWINSTART_WINSV_MASK)) \
+			| (ver_win_st << ISPH3A_AEWINSTART_WINSV_SHIFT))
+
+#define WRITE_HOR_WIN_ST(reg, hor_win_st) \
+		(reg = (reg & ~(ISPH3A_AEWINSTART_WINSH_MASK)) \
+			| (hor_win_st << ISPH3A_AEWINSTART_WINSH_SHIFT))
+
+#define WRITE_BLK_VER_WIN_ST(reg, blk_win_st) \
+		(reg = (reg & ~(ISPH3A_AEWINBLK_WINSV_MASK)) \
+			| (blk_win_st << ISPH3A_AEWINBLK_WINSV_SHIFT))
+
+#define WRITE_BLK_WIN_H(reg, height) \
+		(reg = (reg & ~(ISPH3A_AEWINBLK_WINH_MASK)) \
+			| (((height >> 1) - 1) << ISPH3A_AEWINBLK_WINH_SHIFT))
+
+#define WRITE_SUB_VER_INC(reg, sub_ver_inc) \
+		(reg = (reg & ~(ISPH3A_AEWSUBWIN_AEWINCV_MASK)) \
+		| (((sub_ver_inc >> 1) - 1) << ISPH3A_AEWSUBWIN_AEWINCV_SHIFT))
+
+#define WRITE_SUB_HOR_INC(reg, sub_hor_inc) \
+		(reg = (reg & ~(ISPH3A_AEWSUBWIN_AEWINCH_MASK)) \
+		| (((sub_hor_inc >> 1) - 1) << ISPH3A_AEWSUBWIN_AEWINCH_SHIFT))
+
+/**
+ * struct isph3a_aewb_xtrastats - Structure with extra statistics sent by cam.
+ * @ts: Timestamp of returned framestats.
+ * @field_count: Sequence number of returned framestats.
+ * @isph3a_aewb_xtrastats: Pointer to next buffer with extra stats.
+ */
+struct isph3a_aewb_xtrastats {
+	struct timeval ts;
+	unsigned long field_count;
+	struct isph3a_aewb_xtrastats *next;
+};
+
+void isph3a_aewb_setxtrastats(struct isph3a_aewb_xtrastats *xtrastats);
+
+int isph3a_aewb_configure(struct isph3a_aewb_config *aewbcfg);
+
+int isph3a_aewb_request_statistics(struct isph3a_aewb_data *aewbdata);
+
+void isph3a_save_context(void);
+
+void isph3a_restore_context(void);
+
+void isph3a_update_wb(void);
+
+#endif		/* OMAP_ISP_H3A_H */
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isphist.c	2008-06-29 15:49:05.000000000 -0500
@@ -0,0 +1,651 @@
+/*
+ * drivers/media/video/isp/isphist.c
+ *
+ * HISTOGRAM module for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isphist.h"
+#include "ispmmu.h"
+#include "isppreview.h"
+
+/**
+ * struct isp_hist_status - Histogram status.
+ * @hist_enable: Enables the histogram module.
+ * @initialized: Flag to indicate that the module is correctly initializated.
+ * @frame_cnt: Actual frame count.
+ * @frame_req: Frame requested by user.
+ * @completed: Flag to indicate if a frame request is completed.
+ */
+struct isp_hist_status {
+	u8 hist_enable;
+	u8 initialized;
+	u8 frame_cnt;
+	u8 frame_req;
+	u8 completed;
+} histstat;
+
+/**
+ * struct isp_hist_buffer - Frame histogram buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ */
+struct isp_hist_buffer {
+	unsigned long virt_addr;
+	unsigned long phy_addr;
+	unsigned long addr_align;
+	unsigned long ispmmu_addr;
+	unsigned long mmap_addr;
+} hist_buff;
+
+/**
+ * struct isp_hist_regs - Current value of Histogram configuration registers.
+ * @reg_pcr: Peripheral control register.
+ * @reg_cnt: Histogram control register.
+ * @reg_wb_gain: Histogram white balance gain register.
+ * @reg_r0_h: Region 0 horizontal register.
+ * @reg_r0_v: Region 0 vertical register.
+ * @reg_r1_h: Region 1 horizontal register.
+ * @reg_r1_v: Region 1 vertical register.
+ * @reg_r2_h: Region 2 horizontal register.
+ * @reg_r2_v: Region 2 vertical register.
+ * @reg_r3_h: Region 3 horizontal register.
+ * @reg_r3_v: Region 3 vertical register.
+ * @reg_hist_addr: Histogram address register.
+ * @reg_hist_data: Histogram data.
+ * @reg_hist_radd: Address register. When input data comes from mem.
+ * @reg_hist_radd_off: Address offset register. When input data comes from mem.
+ * @reg_h_v_info: Image size register. When input data comes from mem.
+ */
+static struct isp_hist_regs {
+	u32 reg_pcr;
+	u32 reg_cnt;
+	u32 reg_wb_gain;
+	u32 reg_r0_h;
+	u32 reg_r0_v;
+	u32 reg_r1_h;
+	u32 reg_r1_v;
+	u32 reg_r2_h;
+	u32 reg_r2_v;
+	u32 reg_r3_h;
+	u32 reg_r3_v;
+	u32 reg_hist_addr;
+	u32 reg_hist_data;
+	u32 reg_hist_radd;
+	u32 reg_hist_radd_off;
+	u32 reg_h_v_info;
+} hist_regs;
+
+/* Structure for saving/restoring histogram module registers */
+struct isp_reg isphist_reg_list[] = {
+	{ISPHIST_CNT, 0},
+	{ISPHIST_WB_GAIN, 0},
+	{ISPHIST_R0_HORZ, 0},
+	{ISPHIST_R0_VERT, 0},
+	{ISPHIST_R1_HORZ, 0},
+	{ISPHIST_R1_VERT, 0},
+	{ISPHIST_R2_HORZ, 0},
+	{ISPHIST_R2_VERT, 0},
+	{ISPHIST_R3_HORZ, 0},
+	{ISPHIST_R3_VERT, 0},
+	{ISPHIST_ADDR, 0},
+	{ISPHIST_RADD, 0},
+	{ISPHIST_RADD_OFF, 0},
+	{ISPHIST_H_V_INFO, 0},
+	{ISP_TOK_TERM, 0}
+};
+
+static void isp_hist_print_status(void);
+
+/**
+ * isp_hist_enable - Enables ISP Histogram submodule operation.
+ * @enable: 1 - Enables the histogram submodule.
+ *
+ * Client should configure all the Histogram registers before calling this
+ * function.
+ **/
+static void isp_hist_enable(u8 enable)
+{
+	if (enable) {
+		omap_writel(omap_readl(ISPHIST_PCR) | (ISPHIST_PCR_EN),
+								ISPHIST_PCR);
+		DPRINTK_ISPHIST("   histogram enabled \n");
+	} else {
+		omap_writel(omap_readl(ISPHIST_PCR) & ~ISPHIST_PCR_EN,
+								ISPHIST_PCR);
+		DPRINTK_ISPHIST("   histogram disabled \n");
+	}
+
+	histstat.hist_enable = enable;
+}
+
+/**
+ * isp_hist_update_regs - Helper function to update Histogram registers.
+ **/
+static void isp_hist_update_regs(void)
+{
+	omap_writel(hist_regs.reg_pcr, ISPHIST_PCR);
+	omap_writel(hist_regs.reg_cnt, ISPHIST_CNT);
+	omap_writel(hist_regs.reg_wb_gain, ISPHIST_WB_GAIN);
+	omap_writel(hist_regs.reg_r0_h, ISPHIST_R0_HORZ);
+	omap_writel(hist_regs.reg_r0_v, ISPHIST_R0_VERT);
+	omap_writel(hist_regs.reg_r1_h, ISPHIST_R1_HORZ);
+	omap_writel(hist_regs.reg_r1_v, ISPHIST_R1_VERT);
+	omap_writel(hist_regs.reg_r2_h, ISPHIST_R2_HORZ);
+	omap_writel(hist_regs.reg_r2_v, ISPHIST_R2_VERT);
+	omap_writel(hist_regs.reg_r3_h, ISPHIST_R3_HORZ);
+	omap_writel(hist_regs.reg_r3_v, ISPHIST_R3_VERT);
+	omap_writel(hist_regs.reg_hist_addr, ISPHIST_ADDR);
+	omap_writel(hist_regs.reg_hist_data, ISPHIST_DATA);
+	omap_writel(hist_regs.reg_hist_radd, ISPHIST_RADD);
+	omap_writel(hist_regs.reg_hist_radd_off, ISPHIST_RADD_OFF);
+	omap_writel(hist_regs.reg_h_v_info, ISPHIST_H_V_INFO);
+
+}
+
+/**
+ * isp_hist_isr - Callback from ISP driver for HIST interrupt.
+ * @status: IRQ0STATUS in case of MMU error, 0 for hist interrupt.
+ *          arg1 and arg2 Not used as of now.
+ **/
+static void isp_hist_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+								void *arg2)
+{
+	isp_hist_enable(0);
+
+	if ((HIST_DONE & status) != HIST_DONE)
+		return;
+
+	if (!histstat.completed) {
+		if (histstat.frame_req == histstat.frame_cnt) {
+			histstat.frame_cnt = 0;
+			histstat.frame_req = 0;
+			histstat.completed = 1;
+		} else {
+			isp_hist_enable(1);
+			histstat.frame_cnt++;
+		}
+	}
+}
+
+/**
+ * isp_hist_reset_mem - clear Histogram memory before start stats engine.
+ *
+ * Returns 0 after histogram memory was cleared.
+ **/
+static int isp_hist_reset_mem(void)
+{
+	int i;
+
+	omap_writel((omap_readl(ISPHIST_CNT)) | ISPHIST_CNT_CLR_EN,
+								ISPHIST_CNT);
+
+	for (i = 0; i < HIST_MEM_SIZE; i++)
+		omap_readl(ISPHIST_DATA);
+
+	omap_writel((omap_readl(ISPHIST_CNT)) & ~ISPHIST_CNT_CLR_EN,
+								ISPHIST_CNT);
+
+	return 0;
+}
+
+/**
+ * isp_hist_set_params - Helper function to check and store user given params.
+ * @user_cfg: Pointer to user configuration structure.
+ *
+ * Returns 0 on success configuration.
+ **/
+static int isp_hist_set_params(struct isp_hist_config *user_cfg)
+{
+
+	int reg_num = 0;
+	int bit_shift = 0;
+
+
+	if (omap_readl(ISPHIST_PCR) & ISPHIST_PCR_BUSY_MASK)
+		return -EINVAL;
+
+	if (user_cfg->input_bit_width > MIN_BIT_WIDTH)
+		WRITE_DATA_SIZE(hist_regs.reg_cnt, 0);
+	else
+		WRITE_DATA_SIZE(hist_regs.reg_cnt, 1);
+
+	WRITE_SOURCE(hist_regs.reg_cnt, user_cfg->hist_source);
+
+	if (user_cfg->hist_source) {
+		WRITE_HV_INFO(hist_regs.reg_h_v_info, user_cfg->hist_h_v_info);
+
+		if ((user_cfg->hist_radd & ISP_32B_BOUNDARY_BUF) ==
+		    user_cfg->hist_radd) {
+			WRITE_RADD(hist_regs.reg_hist_radd,
+				   user_cfg->hist_radd);
+		} else {
+			printk(KERN_ERR "Address should be in 32 byte boundary"
+									"\n");
+			return -EINVAL;
+		}
+
+		if ((user_cfg->hist_radd_off & ISP_32B_BOUNDARY_OFFSET) ==
+		    user_cfg->hist_radd_off) {
+			WRITE_RADD_OFF(hist_regs.reg_hist_radd_off,
+				       user_cfg->hist_radd_off);
+		} else {
+			printk(KERN_ERR "Offset should be in 32 byte boundary"
+									"\n");
+			return -EINVAL;
+		}
+
+	}
+
+	isp_hist_reset_mem();
+	DPRINTK_ISPHIST("ISPHIST: Memory Cleared\n");
+	histstat.frame_req = user_cfg->hist_frames;
+
+	if (unlikely((user_cfg->wb_gain_R > MAX_WB_GAIN) ||
+				(user_cfg->wb_gain_RG > MAX_WB_GAIN) ||
+				(user_cfg->wb_gain_B > MAX_WB_GAIN) ||
+				(user_cfg->wb_gain_BG > MAX_WB_GAIN))) {
+		printk(KERN_ERR "Invalid WB gain\n");
+		return -EINVAL;
+	} else {
+		WRITE_WB_R(hist_regs.reg_wb_gain, user_cfg->wb_gain_R);
+		WRITE_WB_RG(hist_regs.reg_wb_gain, user_cfg->wb_gain_RG);
+		WRITE_WB_B(hist_regs.reg_wb_gain, user_cfg->wb_gain_B);
+		WRITE_WB_BG(hist_regs.reg_wb_gain, user_cfg->wb_gain_BG);
+	}
+
+	/* Regions size and position */
+
+	if (user_cfg->num_regions > MAX_REGIONS)
+		return -EINVAL;
+
+	if (likely((user_cfg->reg0_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+					((user_cfg->reg0_hor &
+					ISPHIST_REGHORIZ_HSTART_MASK) >>
+					ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+		WRITE_REG_HORIZ(hist_regs.reg_r0_h, user_cfg->reg0_hor);
+		reg_num++;
+	} else {
+		printk(KERN_ERR "Invalid Region parameters\n");
+		return -EINVAL;
+	}
+
+	if (likely((user_cfg->reg0_ver & ISPHIST_REGVERT_VEND_MASK)
+		     - ((user_cfg->reg0_ver & ISPHIST_REGVERT_VSTART_MASK)
+			>> ISPHIST_REGVERT_VSTART_SHIFT))) {
+		WRITE_REG_VERT(hist_regs.reg_r0_v, user_cfg->reg0_ver);
+	} else {
+		printk(KERN_ERR "Invalid Region parameters\n");
+		return -EINVAL;
+	}
+
+	if (user_cfg->num_regions >= 1) {
+		if (likely((user_cfg->reg1_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+					((user_cfg->reg1_hor &
+					ISPHIST_REGHORIZ_HSTART_MASK) >>
+					ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+			WRITE_REG_HORIZ(hist_regs.reg_r1_h, user_cfg->reg1_hor);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+
+		if (likely((user_cfg->reg1_ver & ISPHIST_REGVERT_VEND_MASK) -
+					((user_cfg->reg1_ver &
+					ISPHIST_REGVERT_VSTART_MASK) >>
+					ISPHIST_REGVERT_VSTART_SHIFT))) {
+			WRITE_REG_VERT(hist_regs.reg_r1_v, user_cfg->reg1_ver);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+	}
+
+	if (user_cfg->num_regions >= 2) {
+		if (likely((user_cfg->reg2_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+					((user_cfg->reg2_hor &
+					ISPHIST_REGHORIZ_HSTART_MASK) >>
+					ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+			WRITE_REG_HORIZ(hist_regs.reg_r2_h, user_cfg->reg2_hor);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+
+		if (likely((user_cfg->reg2_ver & ISPHIST_REGVERT_VEND_MASK) -
+					((user_cfg->reg2_ver &
+					ISPHIST_REGVERT_VSTART_MASK) >>
+					ISPHIST_REGVERT_VSTART_SHIFT))) {
+			WRITE_REG_VERT(hist_regs.reg_r2_v, user_cfg->reg2_ver);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+	}
+
+	if (user_cfg->num_regions >= 3) {
+		if (likely((user_cfg->reg3_hor & ISPHIST_REGHORIZ_HEND_MASK) -
+					((user_cfg->reg3_hor &
+					ISPHIST_REGHORIZ_HSTART_MASK) >>
+					ISPHIST_REGHORIZ_HSTART_SHIFT))) {
+			WRITE_REG_HORIZ(hist_regs.reg_r3_h, user_cfg->reg3_hor);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+
+		if (likely((user_cfg->reg3_ver & ISPHIST_REGVERT_VEND_MASK) -
+					((user_cfg->reg3_ver &
+					ISPHIST_REGVERT_VSTART_MASK) >>
+					ISPHIST_REGVERT_VSTART_SHIFT))) {
+			WRITE_REG_VERT(hist_regs.reg_r3_v, user_cfg->reg3_ver);
+		} else {
+			printk(KERN_ERR "Invalid Region parameters\n");
+			return -EINVAL;
+		}
+	}
+	reg_num = user_cfg->num_regions;
+	if (unlikely(((user_cfg->hist_bins > BINS_256) &&
+				(user_cfg->hist_bins != BINS_32)) ||
+				((user_cfg->hist_bins == BINS_256) &&
+				reg_num != 0) || ((user_cfg->hist_bins ==
+				BINS_128) && reg_num >= 2))) {
+		printk(KERN_ERR "Invalid Bins Number: %d\n",
+							user_cfg->hist_bins);
+		return -EINVAL;
+	} else {
+		WRITE_NUM_BINS(hist_regs.reg_cnt, user_cfg->hist_bins);
+	}
+
+	if ((user_cfg->input_bit_width > MAX_BIT_WIDTH) ||
+				(user_cfg->input_bit_width < MIN_BIT_WIDTH)) {
+		printk(KERN_ERR "Invalid Bit Width: %d\n",
+						user_cfg->input_bit_width);
+		return -EINVAL;
+	} else {
+		switch (user_cfg->hist_bins) {
+		case BINS_256:
+			bit_shift = user_cfg->input_bit_width - 8;
+			break;
+		case BINS_128:
+			bit_shift = user_cfg->input_bit_width - 7;
+			break;
+		case BINS_64:
+			bit_shift = user_cfg->input_bit_width - 6;
+			break;
+		case BINS_32:
+			bit_shift = user_cfg->input_bit_width - 5;
+			break;
+		default:
+			return -EINVAL;
+		}
+		WRITE_BIT_SHIFT(hist_regs.reg_cnt, bit_shift);
+	}
+
+	isp_hist_update_regs();
+	histstat.initialized = 1;
+
+	return 0;
+}
+
+/**
+ * isp_hist_mmap_buffer - Map buffer memory to user space.
+ * @buffer: Pointer to buffer structure.
+ * Helper function to mmap buffers to user space. Buffer passed need to
+ * already have a valid physical address: buffer->phy_addr. It returns user
+ * pointer as unsigned long in buffer->mmap_addr.
+ *
+ * Returns 0 on success buffer mapped.
+ **/
+static int isp_hist_mmap_buffer(struct isp_hist_buffer *buffer)
+{
+	struct vm_area_struct vma;
+	struct mm_struct *mm = current->mm;
+	int size = PAGE_SIZE;
+	unsigned long addr = 0;
+	unsigned long pgoff = 0, flags = MAP_SHARED | MAP_ANONYMOUS;
+	unsigned long prot = PROT_READ | PROT_WRITE;
+	void *pos = (void *)buffer->virt_addr;
+
+	size = PAGE_ALIGN(size);
+
+	addr = get_unmapped_area(NULL, addr, size, pgoff, flags);
+	vma.vm_mm = mm;
+	vma.vm_start = addr;
+	vma.vm_end = addr + size;
+	vma.vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
+	vma.vm_pgoff = pgoff;
+	vma.vm_file = NULL;
+	vma.vm_page_prot = protection_map[vma.vm_flags];
+
+	if (vm_insert_page(&vma, addr, vmalloc_to_page(pos)))
+		return -EAGAIN;
+
+	buffer->mmap_addr = vma.vm_start;
+	return 0;
+}
+
+/**
+ * isp_hist_configure - API to configure HIST registers.
+ * @histcfg: Pointer to user configuration structure.
+ *
+ * Returns 0 on success configuration.
+ **/
+int isp_hist_configure(struct isp_hist_config *histcfg)
+{
+
+	int ret = 0;
+
+	if (NULL == histcfg) {
+		printk(KERN_ERR "Null argument in configuration. \n");
+		return -EINVAL;
+	}
+
+	if (!histstat.initialized) {
+		DPRINTK_ISPHIST("Setting callback for HISTOGRAM\n");
+		ret = isp_set_callback(CBK_HIST_DONE, isp_hist_isr,
+						(void *)NULL, (void *)NULL);
+		if (ret) {
+			printk(KERN_ERR "No callback for HIST\n");
+			return ret;
+		}
+	}
+
+	ret = isp_hist_set_params(histcfg);
+	if (ret) {
+		printk(KERN_ERR "Invalid parameters! \n");
+		return ret;
+	}
+
+	if (hist_buff.virt_addr != 0) {
+		hist_buff.mmap_addr = 0;
+		ispmmu_unmap(hist_buff.ispmmu_addr);
+		dma_free_coherent(NULL, PAGE_SIZE, (void *)hist_buff.virt_addr,
+					(dma_addr_t)hist_buff.phy_addr);
+	}
+
+	hist_buff.virt_addr = (unsigned long)dma_alloc_coherent(NULL,
+						PAGE_SIZE, (dma_addr_t *)
+						&hist_buff.phy_addr,
+						GFP_KERNEL | GFP_DMA);
+	if (hist_buff.virt_addr == 0) {
+		printk(KERN_ERR "Can't acquire memory for ");
+		return -ENOMEM;
+	}
+
+	hist_buff.ispmmu_addr = ispmmu_map(hist_buff.phy_addr, PAGE_SIZE);
+
+	if (hist_buff.mmap_addr) {
+		hist_buff.mmap_addr = 0;
+		DPRINTK_ISPHIST("We have munmaped buffer 0x%lX\n",
+				hist_buff.virt_addr);
+	}
+
+	isp_hist_mmap_buffer(&hist_buff);
+
+	histstat.frame_cnt = 0;
+	histstat.completed = 0;
+	isp_hist_enable(1);
+	isp_hist_print_status();
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_hist_configure);
+
+/**
+ * isp_hist_request_statistics - Request statistics in Histogram.
+ * @histdata: Pointer to data structure.
+ *
+ * This API allows the user to request for histogram statistics.
+ *
+ * Returns 0 on successful request.
+ **/
+int isp_hist_request_statistics(struct isp_hist_data *histdata)
+{
+	int i;
+
+	if (omap_readl(ISPHIST_PCR) & ISPHIST_PCR_BUSY_MASK)
+		return -EBUSY;
+
+	if (!histstat.completed && histstat.initialized)
+		return -EINVAL;
+
+	omap_writel((omap_readl(ISPHIST_CNT)) | ISPHIST_CNT_CLR_EN,
+								ISPHIST_CNT);
+	histdata->hist_statistics_buf = (u32 *)hist_buff.mmap_addr;
+
+	for (i = 0; i < HIST_MEM_SIZE; i++) {
+		*(histdata->hist_statistics_buf + i) =
+						omap_readl(ISPHIST_DATA);
+	}
+
+	omap_writel((omap_readl(ISPHIST_CNT)) & ~ISPHIST_CNT_CLR_EN,
+								ISPHIST_CNT);
+	histstat.completed = 0;
+	return 0;
+}
+EXPORT_SYMBOL(isp_hist_request_statistics);
+
+/**
+ * isp_hist_init - Module Initialization.
+ *
+ * Returns 0 if successful.
+ **/
+static int __init isp_hist_init(void)
+{
+	memset(&histstat, 0, sizeof(histstat));
+	memset(&hist_regs, 0, sizeof(hist_regs));
+
+	return 0;
+}
+
+/**
+ * isp_hist_cleanup - Module cleanup.
+ **/
+static void isp_hist_cleanup(void)
+{
+	isp_hist_enable(0);
+	mdelay(100);
+	isp_unset_callback(CBK_HIST_DONE);
+
+	if (hist_buff.ispmmu_addr) {
+		ispmmu_unmap(hist_buff.ispmmu_addr);
+		dma_free_coherent(NULL, PAGE_SIZE, (void *)hist_buff.virt_addr,
+					(dma_addr_t) hist_buff.phy_addr);
+	}
+
+	memset(&histstat, 0, sizeof(histstat));
+	memset(&hist_regs, 0, sizeof(hist_regs));
+}
+
+/**
+ * isphist_save_context - Saves the values of the histogram module registers.
+ **/
+void
+isphist_save_context(void)
+{
+	DPRINTK_ISPHIST(" Saving context\n");
+	isp_save_context(isphist_reg_list);
+}
+
+/**
+ * isphist_restore_context - Restores the values of the histogram module regs.
+ **/
+void
+isphist_restore_context(void)
+{
+	DPRINTK_ISPHIST(" Restoring context\n");
+	isp_restore_context(isphist_reg_list);
+}
+
+/**
+ * isp_hist_print_status - Debug print
+ **/
+static void isp_hist_print_status(void)
+{
+	DPRINTK_ISPHIST("ISPHIST_PCR = 0x%08x\n", omap_readl(ISPHIST_PCR));
+	DPRINTK_ISPHIST("ISPHIST_CNT = 0x%08x\n", omap_readl(ISPHIST_CNT));
+	DPRINTK_ISPHIST("ISPHIST_WB_GAIN = 0x%08x\n",
+						omap_readl(ISPHIST_WB_GAIN));
+	DPRINTK_ISPHIST("ISPHIST_R0_HORZ = 0x%08x\n",
+						omap_readl(ISPHIST_R0_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R0_VERT = 0x%08x\n",
+						omap_readl(ISPHIST_R0_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R1_HORZ = 0x%08x\n",
+						omap_readl(ISPHIST_R1_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R1_VERT = 0x%08x\n",
+						omap_readl(ISPHIST_R1_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R2_HORZ = 0x%08x\n",
+						omap_readl(ISPHIST_R2_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R2_VERT = 0x%08x\n",
+						omap_readl(ISPHIST_R2_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R3_HORZ = 0x%08x\n",
+						omap_readl(ISPHIST_R3_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R3_VERT = 0x%08x\n",
+						omap_readl(ISPHIST_R3_VERT));
+	DPRINTK_ISPHIST("ISPHIST_ADDR = 0x%08x\n", omap_readl(ISPHIST_ADDR));
+	DPRINTK_ISPHIST("ISPHIST_RADD = 0x%08x\n", omap_readl(ISPHIST_RADD));
+	DPRINTK_ISPHIST("ISPHIST_RADD_OFF = 0x%08x\n",
+						omap_readl(ISPHIST_RADD_OFF));
+	DPRINTK_ISPHIST("ISPHIST_H_V_INFO = 0x%08x\n",
+						omap_readl(ISPHIST_H_V_INFO));
+}
+
+module_init(isp_hist_init);
+module_exit(isp_hist_cleanup);
+module_exit(isphist_save_context);
+module_exit(isphist_restore_context);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("HISTOGRAM ISP Module");
+MODULE_LICENSE("GPL");
--- /dev/null	2004-06-24 13:05:26.000000000 -0500
+++ b/drivers/media/video/isp/isphist.h	2008-06-29 15:49:05.000000000 -0500
@@ -0,0 +1,97 @@
+/*
+ * drivers/media/video/isp/isphist.h
+ *
+ * Header file for HISTOGRAM module in TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy <t-laramy@ti.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_HIST_H
+#define OMAP_ISP_HIST_H
+
+#include <asm/arch/isp_user.h>
+
+#define MAX_REGIONS		0x4
+#define MAX_WB_GAIN		255
+#define MIN_WB_GAIN		0x0
+#define MAX_BIT_WIDTH		14
+#define MIN_BIT_WIDTH		8
+
+#define ISPHIST_PCR_EN		(1 << 0)
+#define HIST_MEM_SIZE		1024
+#define ISPHIST_CNT_CLR_EN	(1 << 7)
+
+#define WRITE_SOURCE(reg, source)	\
+		(reg = (reg & ~(ISPHIST_CNT_SOURCE_MASK)) \
+		| (source << ISPHIST_CNT_SOURCE_SHIFT))
+
+#define WRITE_HV_INFO(reg, hv_info) \
+		(reg = ((reg & ~(ISPHIST_HV_INFO_MASK)) \
+		| (hv_info & ISPHIST_HV_INFO_MASK)))
+
+#define WRITE_RADD(reg, radd) \
+		(reg = (reg & ~(ISPHIST_RADD_MASK)) \
+		| (radd << ISPHIST_RADD_SHIFT))
+
+#define WRITE_RADD_OFF(reg, radd_off) \
+		(reg = (reg & ~(ISPHIST_RADD_OFF_MASK)) \
+		| (radd_off << ISPHIST_RADD_OFF_SHIFT))
+
+#define WRITE_BIT_SHIFT(reg, bit_shift) \
+		(reg = (reg & ~(ISPHIST_CNT_SHIFT_MASK)) \
+		| (bit_shift << ISPHIST_CNT_SHIFT_SHIFT))
+
+#define WRITE_DATA_SIZE(reg, data_size) \
+		(reg = (reg & ~(ISPHIST_CNT_DATASIZE_MASK)) \
+		| (data_size << ISPHIST_CNT_DATASIZE_SHIFT))
+
+#define WRITE_NUM_BINS(reg, num_bins) \
+		(reg = (reg & ~(ISPHIST_CNT_BINS_MASK)) \
+		| (num_bins << ISPHIST_CNT_BINS_SHIFT))
+
+#define WRITE_WB_R(reg, reg_wb_gain) \
+		reg = ((reg & ~(ISPHIST_WB_GAIN_WG00_MASK)) \
+		| (reg_wb_gain << ISPHIST_WB_GAIN_WG00_SHIFT))
+
+#define WRITE_WB_RG(reg, reg_wb_gain) \
+		(reg = (reg & ~(ISPHIST_WB_GAIN_WG01_MASK)) \
+		| (reg_wb_gain << ISPHIST_WB_GAIN_WG01_SHIFT))
+
+#define WRITE_WB_B(reg, reg_wb_gain) \
+		(reg = (reg & ~(ISPHIST_WB_GAIN_WG02_MASK)) \
+		| (reg_wb_gain << ISPHIST_WB_GAIN_WG02_SHIFT))
+
+#define WRITE_WB_BG(reg, reg_wb_gain) \
+		(reg = (reg & ~(ISPHIST_WB_GAIN_WG03_MASK)) \
+		| (reg_wb_gain << ISPHIST_WB_GAIN_WG03_SHIFT))
+
+#define WRITE_REG_HORIZ(reg, reg_n_hor) \
+		(reg = ((reg & ~ISPHIST_REGHORIZ_MASK) \
+		| (reg_n_hor & ISPHIST_REGHORIZ_MASK)))
+
+#define WRITE_REG_VERT(reg, reg_n_vert) \
+		(reg = ((reg & ~ISPHIST_REGVERT_MASK) \
+		| (reg_n_vert & ISPHIST_REGVERT_MASK)))
+
+
+int isp_hist_configure(struct isp_hist_config *histcfg);
+
+int isp_hist_request_statistics(struct isp_hist_data *histdata);
+
+void isphist_save_context(void);
+
+void isphist_restore_context(void);
+
+#endif				/* OMAP_ISP_HIST */
--- a/drivers/media/video/omap34xxcam.c	2008-06-29 15:17:36.000000000 -0500
+++ b/drivers/media/video/omap34xxcam.c	2008-06-29 15:56:26.000000000 -0500
@@ -38,6 +38,7 @@
 #include "isp/ispmmu.h"
 #include "isp/ispreg.h"
 #include "isp/ispccdc.h"
+#include "isp/isph3a.h"
 
 #define OMAP34XXCAM_VERSION KERNEL_VERSION(0, 0, 0)
 
@@ -109,16 +110,21 @@ int omap34xxcam_update_vbq(struct videob
 {
 	struct omap34xxcam_fh *fh = camfh_saved;
 	struct omap34xxcam_videodev *vdev = fh->vdev;
+	struct isph3a_aewb_xtrastats xtrastats;
 	int rval = 0;
 
 	do_gettimeofday(&vb->ts);
 	vb->field_count = atomic_add_return(2, &fh->field_count);
 	vb->state = VIDEOBUF_DONE;
 
+	xtrastats.ts = vb->ts;
+	xtrastats.field_count = vb->field_count;
+
 	if (vdev->streaming)
 		rval = 1;
 
 	wake_up(&vb->done);
+	isph3a_aewb_setxtrastats(&xtrastats);
 
 	return rval;
 }
@@ -1133,11 +1139,35 @@ static int omap34xxcam_handle_private(st
 		rval = -EINVAL;
 	} else {
 		switch (cmd) {
+		case VIDIOC_PRIVATE_ISP_AEWB_REQ:
+		{
+			/* Need to update sensor first */
+			struct isph3a_aewb_data *data;
+			struct v4l2_control vc;
+
+			data = (struct isph3a_aewb_data *) arg;
+			if (data->update & SET_EXPOSURE) {
+				vc.id = V4L2_CID_EXPOSURE;
+				vc.value = data->shutter;
+				rval = vidioc_int_s_ctrl(vdev->vdev_sensor,
+							 &vc);
+				if (rval)
+					goto out;
+			}
+			if (data->update & SET_ANALOG_GAIN) {
+				vc.id = V4L2_CID_GAIN;
+				vc.value = data->gain;
+				rval = vidioc_int_s_ctrl(vdev->vdev_sensor,
+							 &vc);
+				if (rval)
+					goto out;
+			}
+		}
 		default:
 			rval = isp_handle_private(cmd, arg);
 		}
 	}
-
+out:
 	mutex_unlock(&vdev->mutex);
 	return rval;
 }
--- a/include/asm-arm/arch-omap/isp_user.h	2008-06-29 15:37:34.000000000 -0500
+++ b/include/asm-arm/arch-omap/isp_user.h	2008-06-29 15:46:06.000000000 -0500
@@ -20,6 +20,127 @@
 #ifndef OMAP_ISP_USER_H
 #define OMAP_ISP_USER_H
 
+/* AE/AWB related structures and flags*/
+
+/* Flags for update field */
+#define REQUEST_STATISTICS	(1 << 0)
+#define SET_COLOR_GAINS		(1 << 1)
+#define SET_DIGITAL_GAIN	(1 << 2)
+#define SET_EXPOSURE		(1 << 3)
+#define SET_ANALOG_GAIN		(1 << 4)
+
+#define MAX_FRAME_COUNT		0x0FFF
+#define MAX_FUTURE_FRAMES	10
+
+/**
+ * struct isph3a_aewb_config - AE AWB configuration reset values.
+ * saturation_limit: Saturation limit.
+ * @win_height: Window Height. Range 2 - 256, even values only.
+ * @win_width: Window Width. Range 6 - 256, even values only.
+ * @ver_win_count: Vertical Window Count. Range 1 - 128.
+ * @hor_win_count: Horizontal Window Count. Range 1 - 36.
+ * @ver_win_start: Vertical Window Start. Range 0 - 4095.
+ * @hor_win_start: Horizontal Window Start. Range 0 - 4095.
+ * @blk_ver_win_start: Black Vertical Windows Start. Range 0 - 4095.
+ * @blk_win_height: Black Window Height. Range 2 - 256, even values only.
+ * @subsample_ver_inc: Subsample Vertical points increment Range 2 - 32, even
+ *                     values only.
+ * @subsample_hor_inc: Subsample Horizontal points increment Range 2 - 32, even
+ *                     values only.
+ * @alaw_enable: AEW ALAW EN flag.
+ * @aewb_enable: AE AWB stats generation EN flag.
+ */
+struct isph3a_aewb_config {
+	u16 saturation_limit;
+	u16 win_height;
+	u16 win_width;
+	u16 ver_win_count;
+	u16 hor_win_count;
+	u16 ver_win_start;
+	u16 hor_win_start;
+	u16 blk_ver_win_start;
+	u16 blk_win_height;
+	u16 subsample_ver_inc;
+	u16 subsample_hor_inc;
+	u8 alaw_enable;
+	u8 aewb_enable;
+};
+
+/**
+ * struct isph3a_aewb_data - Structure of data sent to or received from user
+ * @h3a_aewb_statistics_buf: Pointer to pass to user.
+ * @shutter: Shutter speed.
+ * @gain: Sensor analog Gain.
+ * @shutter_cap: Shutter speed for capture.
+ * @gain_cap: Sensor Gain for capture.
+ * @dgain: White balance digital gain.
+ * @wb_gain_b: White balance color gain blue.
+ * @wb_gain_r: White balance color gain red.
+ * @wb_gain_gb: White balance color gain green blue.
+ * @wb_gain_gr: White balance color gain green red.
+ * @frame_number: Frame number of requested stats.
+ * @curr_frame: Current frame number being processed.
+ * @update: Bitwise flags to update parameters.
+ * @ts: Timestamp of returned framestats.
+ * @field_count: Sequence number of returned framestats.
+ */
+struct isph3a_aewb_data {
+	void *h3a_aewb_statistics_buf;
+	u32 shutter;
+	u16 gain;
+	u32 shutter_cap;
+	u16 gain_cap;
+	u16 dgain;
+	u16 wb_gain_b;
+	u16 wb_gain_r;
+	u16 wb_gain_gb;
+	u16 wb_gain_gr;
+	u16 frame_number;
+	u16 curr_frame;
+	u8 update;
+	struct timeval ts;
+	unsigned long field_count;
+};
+
+
+/* Histogram related structs */
+/* Flags for number of bins */
+#define BINS_32			0x0
+#define BINS_64			0x1
+#define BINS_128		0x2
+#define BINS_256		0x3
+
+struct isp_hist_config {
+	u8 hist_source;		/* CCDC or Memory */
+	u8 input_bit_width;	/* Needed o know the size per pixel */
+	u8 hist_frames;		/* Num of frames to be processed and
+				 * accumulated
+				 */
+	u8 hist_h_v_info;	/* frame-input width and height if source is
+				 * memory
+				 */
+	u16 hist_radd;		/* frame-input address in memory */
+	u16 hist_radd_off;	/* line-offset for frame-input */
+	u16 hist_bins;		/* number of bins: 32, 64, 128, or 256 */
+	u16 wb_gain_R;		/* White Balance Field-to-Pattern Assignments */
+	u16 wb_gain_RG;		/* White Balance Field-to-Pattern Assignments */
+	u16 wb_gain_B;		/* White Balance Field-to-Pattern Assignments */
+	u16 wb_gain_BG;		/* White Balance Field-to-Pattern Assignments */
+	u8 num_regions;		/* number of regions to be configured */
+	u16 reg0_hor;		/* Region 0 size and position */
+	u16 reg0_ver;		/* Region 0 size and position */
+	u16 reg1_hor;		/* Region 1 size and position */
+	u16 reg1_ver;		/* Region 1 size and position */
+	u16 reg2_hor;		/* Region 2 size and position */
+	u16 reg2_ver;		/* Region 2 size and position */
+	u16 reg3_hor;		/* Region 3 size and position */
+	u16 reg3_ver;		/* Region 3 size and position */
+};
+
+struct isp_hist_data {
+	u32 *hist_statistics_buf;	/* Pointer to pass to user */
+};
+
 /* ISP CCDC structs */
 
 /* Abstraction layer CCDC configurations */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
