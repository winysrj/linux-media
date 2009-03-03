Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32284 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZCCKHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 05:07:37 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, saaguirre@ti.com,
	tuukka.o.toivonen@nokia.com, dongsoo.kim@gmail.com
Subject: [PATCH 6/9] omap3isp: Add statistics collection modules (H3A and HIST)
Date: Tue,  3 Mar 2009 12:06:53 +0200
Message-Id: <1236074816-30018-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1236074816-30018-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1236074816-30018-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1236074816-30018-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1236074816-30018-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1236074816-30018-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/isp/isp_af.c  |  758 +++++++++++++++++++++++++++++++
 drivers/media/video/isp/isp_af.h  |  123 +++++
 drivers/media/video/isp/isph3a.c  |  902 +++++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/isph3a.h  |  123 +++++
 drivers/media/video/isp/isphist.c |  584 ++++++++++++++++++++++++
 drivers/media/video/isp/isphist.h |  101 ++++
 6 files changed, 2591 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/isp/isp_af.c
 create mode 100644 drivers/media/video/isp/isp_af.h
 create mode 100644 drivers/media/video/isp/isph3a.c
 create mode 100644 drivers/media/video/isp/isph3a.h
 create mode 100644 drivers/media/video/isp/isphist.c
 create mode 100644 drivers/media/video/isp/isphist.h

diff --git a/drivers/media/video/isp/isp_af.c b/drivers/media/video/isp/isp_af.c
new file mode 100644
index 0000000..2e39d1f
--- /dev/null
+++ b/drivers/media/video/isp/isp_af.c
@@ -0,0 +1,758 @@
+/*
+ * isp_af.c
+ *
+ * AF module for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+/* Linux specific include files */
+#include <asm/cacheflush.h>
+
+#include <linux/uaccess.h>
+#include <linux/dma-mapping.h>
+#include <asm/atomic.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isph3a.h"
+#include "isp_af.h"
+#include "ispmmu.h"
+
+/**
+ * struct isp_af_buffer - AF frame stats buffer.
+ * @virt_addr: Virtual address to mmap the buffer.
+ * @phy_addr: Physical address of the buffer.
+ * @addr_align: Virtual Address 32 bytes aligned.
+ * @ispmmu_addr: Address of the buffer mapped by the ISPMMU.
+ * @mmap_addr: Mapped memory area of buffer. For userspace access.
+ * @locked: 1 - Buffer locked from write. 0 - Buffer can be overwritten.
+ * @frame_num: Frame number from which the statistics are taken.
+ * @lens_position: Lens position currently set in the DW9710 Coil motor driver.
+ * @next: Pointer to link next buffer.
+ */
+struct isp_af_buffer {
+	unsigned long virt_addr;
+	unsigned long phy_addr;
+	unsigned long addr_align;
+	unsigned long ispmmu_addr;
+	unsigned long mmap_addr;
+
+	u8 locked;
+	u16 frame_num;
+	u32 config_counter;
+	struct isp_af_xtrastats xtrastats;
+	struct isp_af_buffer *next;
+};
+
+/**
+ * struct isp_af_status - AF status.
+ * @initialized: 1 - Buffers initialized.
+ * @update: 1 - Update registers.
+ * @stats_req: 1 - Future stats requested.
+ * @stats_done: 1 - Stats ready for user.
+ * @frame_req: Number of frame requested for statistics.
+ * @af_buff: Array of statistics buffers to access.
+ * @stats_buf_size: Statistics buffer size.
+ * @curr_cfg_buf_size: Current user configured stats buff size.
+ * @min_buf_size: Minimum statisitics buffer size.
+ * @frame_count: Frame Count.
+ * @stats_wait: Wait primitive for locking/unlocking the stats request.
+ * @buffer_lock: Spinlock for statistics buffers access.
+ */
+static struct isp_af_status {
+	u8 initialized;
+	u8 update;
+	u8 stats_req;
+	u8 stats_done;
+	u16 frame_req;
+
+	struct isp_af_buffer af_buff[H3A_MAX_BUFF];
+	unsigned int stats_buf_size;
+	unsigned int min_buf_size;
+	unsigned int curr_cfg_buf_size;
+
+	u32 frame_count;
+	wait_queue_head_t stats_wait;
+	atomic_t config_counter;
+	spinlock_t buffer_lock;		/* For stats buffers read/write sync */
+} afstat;
+
+struct af_device *af_dev_configptr;
+static struct isp_af_buffer *active_buff;
+static int af_major = -1;
+static int camnotify;
+
+/**
+ * isp_af_setxtrastats - Receives extra statistics from prior frames.
+ * @xtrastats: Pointer to structure containing extra statistics fields like
+ *             field count and timestamp of frame.
+ *
+ * Called from update_vbq in camera driver
+ **/
+void isp_af_setxtrastats(struct isp_af_xtrastats *xtrastats, u8 updateflag)
+{
+	int i, past_i;
+
+	if (active_buff == NULL)
+		return;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (afstat.af_buff[i].frame_num == active_buff->frame_num)
+			break;
+	}
+
+	if (i == H3A_MAX_BUFF)
+		return;
+
+	if (i == 0) {
+		if (afstat.af_buff[H3A_MAX_BUFF - 1].locked == 0)
+			past_i = H3A_MAX_BUFF - 1;
+		else
+			past_i = H3A_MAX_BUFF - 2;
+	} else if (i == 1) {
+		if (afstat.af_buff[0].locked == 0)
+			past_i = 0;
+		else
+			past_i = H3A_MAX_BUFF - 1;
+	} else {
+		if (afstat.af_buff[i - 1].locked == 0)
+			past_i = i - 1;
+		else
+			past_i = i - 2;
+	}
+
+	if (updateflag & AF_UPDATEXS_TS)
+		afstat.af_buff[past_i].xtrastats.ts = xtrastats->ts;
+
+	if (updateflag & AF_UPDATEXS_FIELDCOUNT)
+		afstat.af_buff[past_i].xtrastats.field_count =
+							xtrastats->field_count;
+}
+EXPORT_SYMBOL(isp_af_setxtrastats);
+
+/*
+ * Helper function to update buffer cache pages
+ */
+static void isp_af_update_req_buffer(struct isp_af_buffer *buffer)
+{
+	int size = afstat.stats_buf_size;
+
+	size = PAGE_ALIGN(size);
+	/* Update the kernel pages of the requested buffer */
+	dmac_inv_range((void *)buffer->addr_align, (void *)buffer->addr_align +
+									size);
+}
+
+#define IS_OUT_OF_BOUNDS(value, min, max) \
+	(((value) < (min)) || ((value) > (max)))
+
+/* Function to check paxel parameters */
+int isp_af_check_paxel(void)
+{
+	struct af_paxel *paxel_cfg = &af_dev_configptr->config->paxel_config;
+	struct af_iir *iir_cfg = &af_dev_configptr->config->iir_config;
+
+	/* Check horizontal Count */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->hz_cnt, AF_PAXEL_HORIZONTAL_COUNT_MIN,
+					AF_PAXEL_HORIZONTAL_COUNT_MAX)) {
+		DPRINTK_ISP_AF("Error : Horizontal Count is incorrect");
+		return -AF_ERR_HZ_COUNT;
+	}
+
+	/*Check Vertical Count */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->vt_cnt, AF_PAXEL_VERTICAL_COUNT_MIN,
+					AF_PAXEL_VERTICAL_COUNT_MAX)) {
+		DPRINTK_ISP_AF("Error : Vertical Count is incorrect");
+		return -AF_ERR_VT_COUNT;
+	}
+
+	/*Check Height */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->height, AF_PAXEL_HEIGHT_MIN,
+					AF_PAXEL_HEIGHT_MAX)) {
+		DPRINTK_ISP_AF("Error : Height is incorrect");
+		return -AF_ERR_HEIGHT;
+	}
+
+	/*Check width */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->width, AF_PAXEL_WIDTH_MIN,
+					AF_PAXEL_WIDTH_MAX)) {
+		DPRINTK_ISP_AF("Error : Width is incorrect");
+		return -AF_ERR_WIDTH;
+	}
+
+	/*Check Line Increment */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->line_incr, AF_PAXEL_INCREMENT_MIN,
+					AF_PAXEL_INCREMENT_MAX)) {
+		DPRINTK_ISP_AF("Error : Line Increment is incorrect");
+		return -AF_ERR_INCR;
+	}
+
+	/*Check Horizontal Start */
+	if ((paxel_cfg->hz_start % 2 != 0) ||
+			(paxel_cfg->hz_start < (iir_cfg->hz_start_pos + 2)) ||
+			IS_OUT_OF_BOUNDS(paxel_cfg->hz_start,
+			AF_PAXEL_HZSTART_MIN, AF_PAXEL_HZSTART_MAX)) {
+		DPRINTK_ISP_AF("Error : Horizontal Start is incorrect");
+		return -AF_ERR_HZ_START;
+	}
+
+	/*Check Vertical Start */
+	if (IS_OUT_OF_BOUNDS(paxel_cfg->vt_start, AF_PAXEL_VTSTART_MIN,
+					AF_PAXEL_VTSTART_MAX)) {
+		DPRINTK_ISP_AF("Error : Vertical Start is incorrect");
+		return -AF_ERR_VT_START;
+	}
+	return 0;
+}
+
+/**
+ * isp_af_check_iir - Function to check IIR Coefficient.
+ **/
+int isp_af_check_iir(void)
+{
+	struct af_iir *iir_cfg = &af_dev_configptr->config->iir_config;
+	int index;
+
+	for (index = 0; index < AF_NUMBER_OF_COEF; index++) {
+		if ((iir_cfg->coeff_set0[index]) > AF_COEF_MAX) {
+			DPRINTK_ISP_AF("Error : Coefficient for set 0 is "
+								"incorrect");
+			return -AF_ERR_IIR_COEF;
+		}
+
+		if ((iir_cfg->coeff_set1[index]) > AF_COEF_MAX) {
+			DPRINTK_ISP_AF("Error : Coefficient for set 1 is "
+								"incorrect");
+			return -AF_ERR_IIR_COEF;
+		}
+	}
+
+	if (IS_OUT_OF_BOUNDS(iir_cfg->hz_start_pos, AF_IIRSH_MIN,
+								AF_IIRSH_MAX)) {
+		DPRINTK_ISP_AF("Error : IIRSH is incorrect");
+		return -AF_ERR_IIRSH;
+	}
+
+	return 0;
+}
+/**
+ * isp_af_unlock_buffers - Helper function to unlock all buffers.
+ **/
+static void isp_af_unlock_buffers(void)
+{
+	int i;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&afstat.buffer_lock, irqflags);
+	for (i = 0; i < H3A_MAX_BUFF; i++)
+		afstat.af_buff[i].locked = 0;
+
+	spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+}
+
+/*
+ * Helper function to link allocated buffers
+ */
+static void isp_af_link_buffers(void)
+{
+	int i;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if ((i + 1) < H3A_MAX_BUFF)
+			afstat.af_buff[i].next = &afstat.af_buff[i + 1];
+		else
+			afstat.af_buff[i].next = &afstat.af_buff[0];
+	}
+}
+
+/* Function to perform hardware set up */
+int isp_af_configure(struct af_configuration *afconfig)
+{
+	int result;
+	int buff_size, i;
+	unsigned int busyaf;
+	struct af_configuration *af_curr_cfg = af_dev_configptr->config;
+
+	if (NULL == afconfig) {
+		printk(KERN_ERR "Null argument in configuration. \n");
+		return -EINVAL;
+	}
+
+	memcpy(af_curr_cfg, afconfig, sizeof(struct af_configuration));
+	/* Get the value of PCR register */
+	busyaf = isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+
+	if ((busyaf & AF_BUSYAF) == AF_BUSYAF) {
+		DPRINTK_ISP_AF("AF_register_setup_ERROR : Engine Busy");
+		DPRINTK_ISP_AF("\n Configuration cannot be done ");
+		return -AF_ERR_ENGINE_BUSY;
+	}
+
+	/* Check IIR Coefficient and start Values */
+	result = isp_af_check_iir();
+	if (result < 0)
+		return result;
+
+	/* Check Paxel Values */
+	result = isp_af_check_paxel();
+	if (result < 0)
+		return result;
+
+	/* Check HMF Threshold Values */
+	if (af_curr_cfg->hmf_config.threshold > AF_THRESHOLD_MAX) {
+		DPRINTK_ISP_AF("Error : HMF Threshold is incorrect");
+		return -AF_ERR_THRESHOLD;
+	}
+
+	/* Compute buffer size */
+	buff_size = (af_curr_cfg->paxel_config.hz_cnt + 1) *
+			(af_curr_cfg->paxel_config.vt_cnt + 1) * AF_PAXEL_SIZE;
+
+	afstat.curr_cfg_buf_size = buff_size;
+	/* Deallocate the previous buffers */
+	if (afstat.stats_buf_size && (buff_size	> afstat.stats_buf_size)) {
+		isp_af_enable(0);
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			ispmmu_kunmap(afstat.af_buff[i].ispmmu_addr);
+			dma_free_coherent(NULL, afstat.min_buf_size,
+					(void *)afstat.af_buff[i].virt_addr,
+					(dma_addr_t)afstat.af_buff[i].phy_addr);
+			afstat.af_buff[i].virt_addr = 0;
+		}
+		afstat.stats_buf_size = 0;
+	}
+
+	if (!afstat.af_buff[0].virt_addr) {
+		afstat.stats_buf_size = buff_size;
+		afstat.min_buf_size = PAGE_ALIGN(afstat.stats_buf_size);
+
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			afstat.af_buff[i].virt_addr =
+					(unsigned long)dma_alloc_coherent(NULL,
+					afstat.min_buf_size,
+					(dma_addr_t *)
+					&afstat.af_buff[i].phy_addr,
+					GFP_KERNEL | GFP_DMA);
+			if (afstat.af_buff[i].virt_addr == 0) {
+				printk(KERN_ERR "Can't acquire memory for "
+							"buffer[%d]\n", i);
+				return -ENOMEM;
+			}
+			afstat.af_buff[i].addr_align =
+						afstat.af_buff[i].virt_addr;
+			while ((afstat.af_buff[i].addr_align & 0xFFFFFFC0) !=
+						afstat.af_buff[i].addr_align)
+				afstat.af_buff[i].addr_align++;
+			afstat.af_buff[i].ispmmu_addr =
+				ispmmu_kmap(afstat.af_buff[i].phy_addr,
+							afstat.min_buf_size);
+		}
+		isp_af_unlock_buffers();
+		isp_af_link_buffers();
+
+		/* First active buffer */
+		if (active_buff == NULL)
+			active_buff = &afstat.af_buff[0];
+		isp_af_set_address(active_buff->ispmmu_addr);
+	}
+
+	result = isp_af_register_setup(af_dev_configptr);
+	if (result < 0)
+		return result;
+	af_dev_configptr->size_paxel = buff_size;
+	atomic_inc(&afstat.config_counter);
+	afstat.initialized = 1;
+	afstat.frame_count = 1;
+	active_buff->frame_num = 1;
+	/* Set configuration flag to indicate HW setup done */
+	if (af_curr_cfg->af_config)
+		isp_af_enable(1);
+	else
+		isp_af_enable(0);
+
+	/* Success */
+	return 0;
+}
+EXPORT_SYMBOL(isp_af_configure);
+
+int isp_af_register_setup(struct af_device *af_dev)
+{
+	unsigned int pcr = 0, pax1 = 0, pax2 = 0, paxstart = 0;
+	unsigned int coef = 0;
+	unsigned int base_coef_set0 = 0;
+	unsigned int base_coef_set1 = 0;
+	int index;
+
+	/* Configure Hardware Registers */
+	/* Read PCR Register */
+	pcr = isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+
+	/* Set Accumulator Mode */
+	if (af_dev->config->mode == ACCUMULATOR_PEAK)
+		pcr |= FVMODE;
+	else
+		pcr &= ~FVMODE;
+
+	/* Set A-law */
+	if (af_dev->config->alaw_enable == H3A_AF_ALAW_ENABLE)
+		pcr |= AF_ALAW_EN;
+	else
+		pcr &= ~AF_ALAW_EN;
+
+	/* Set RGB Position */
+	pcr &= ~RGBPOS;
+	pcr |= (af_dev->config->rgb_pos) << AF_RGBPOS_SHIFT;
+
+	/* HMF Configurations */
+	if (af_dev->config->hmf_config.enable == H3A_AF_HMF_ENABLE) {
+		pcr &= ~AF_MED_EN;
+		/* Enable HMF */
+		pcr |= AF_MED_EN;
+
+		/* Set Median Threshold */
+		pcr &= ~MED_TH;
+		pcr |= (af_dev->config->hmf_config.threshold) <<
+							AF_MED_TH_SHIFT;
+	} else
+		pcr &= ~AF_MED_EN;
+
+	/* Set PCR Register */
+	isp_reg_writel(pcr, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+
+	pax1 &= ~PAXW;
+	pax1 |= (af_dev->config->paxel_config.width) << AF_PAXW_SHIFT;
+
+	/* Set height in AFPAX1 */
+	pax1 &= ~PAXH;
+	pax1 |= af_dev->config->paxel_config.height;
+
+	isp_reg_writel(pax1, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX1);
+
+	/* Configure AFPAX2 Register */
+	/* Set Line Increment in AFPAX2 Register */
+	pax2 &= ~AFINCV;
+	pax2 |= (af_dev->config->paxel_config.line_incr) << AF_LINE_INCR_SHIFT;
+	/* Set Vertical Count */
+	pax2 &= ~PAXVC;
+	pax2 |= (af_dev->config->paxel_config.vt_cnt) << AF_VT_COUNT_SHIFT;
+	/* Set Horizontal Count */
+	pax2 &= ~PAXHC;
+	pax2 |= af_dev->config->paxel_config.hz_cnt;
+	isp_reg_writel(pax2, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX2);
+
+	/* Configure PAXSTART Register */
+	/*Configure Horizontal Start */
+	paxstart &= ~PAXSH;
+	paxstart |= (af_dev->config->paxel_config.hz_start) <<
+							AF_HZ_START_SHIFT;
+	/* Configure Vertical Start */
+	paxstart &= ~PAXSV;
+	paxstart |= af_dev->config->paxel_config.vt_start;
+	isp_reg_writel(paxstart, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAXSTART);
+
+	/*SetIIRSH Register */
+	isp_reg_writel(af_dev->config->iir_config.hz_start_pos,
+					OMAP3_ISP_IOMEM_H3A, ISPH3A_AFIIRSH);
+
+	/*Set IIR Filter0 Coefficients */
+	base_coef_set0 = ISPH3A_AFCOEF010;
+	for (index = 0; index <= 8; index += 2) {
+		coef &= ~COEF_MASK0;
+		coef |= af_dev->config->iir_config.coeff_set0[index];
+		coef &= ~COEF_MASK1;
+		coef |= (af_dev->config->iir_config.coeff_set0[index + 1]) <<
+								AF_COEF_SHIFT;
+		isp_reg_writel(coef, OMAP3_ISP_IOMEM_H3A, base_coef_set0);
+		base_coef_set0 = base_coef_set0 + AFCOEF_OFFSET;
+	}
+
+	/* set AFCOEF0010 Register */
+	isp_reg_writel(af_dev->config->iir_config.coeff_set0[10],
+				OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF010);
+
+	/*Set IIR Filter1 Coefficients */
+
+	base_coef_set1 = ISPH3A_AFCOEF110;
+	for (index = 0; index <= 8; index += 2) {
+		coef &= ~COEF_MASK0;
+		coef |= af_dev->config->iir_config.coeff_set1[index];
+		coef &= ~COEF_MASK1;
+		coef |= (af_dev->config->iir_config.coeff_set1[index + 1]) <<
+								AF_COEF_SHIFT;
+		isp_reg_writel(coef, OMAP3_ISP_IOMEM_H3A, base_coef_set1);
+
+		base_coef_set1 = base_coef_set1 + AFCOEF_OFFSET;
+	}
+	isp_reg_writel(af_dev->config->iir_config.coeff_set1[10],
+				OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF1010);
+
+	return 0;
+}
+
+/* Function to set address */
+void isp_af_set_address(unsigned long address)
+{
+	isp_reg_writel(address, OMAP3_ISP_IOMEM_H3A, ISPH3A_AFBUFST);
+}
+
+static int isp_af_stats_available(struct isp_af_data *afdata)
+{
+	int i, ret;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&afstat.buffer_lock, irqflags);
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		DPRINTK_ISP_AF("Checking Stats buff[%d] (%d) for %d\n",
+				i, afstat.af_buff[i].frame_num,
+				afdata->frame_number);
+		if ((afdata->frame_number == afstat.af_buff[i].frame_num) &&
+						(afstat.af_buff[i].frame_num !=
+						active_buff->frame_num)) {
+			afstat.af_buff[i].locked = 1;
+			spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+			isp_af_update_req_buffer(&afstat.af_buff[i]);
+			afstat.af_buff[i].frame_num = 0;
+			ret = copy_to_user((void *)afdata->af_statistics_buf,
+					(void *)afstat.af_buff[i].virt_addr,
+					afstat.curr_cfg_buf_size);
+			if (ret) {
+				printk(KERN_ERR "Failed copy_to_user for "
+					"H3A stats buff, %d\n", ret);
+			}
+			afdata->xtrastats.ts = afstat.af_buff[i].xtrastats.ts;
+			afdata->xtrastats.field_count =
+					afstat.af_buff[i].xtrastats.field_count;
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&afstat.buffer_lock, irqflags);
+	/* Stats unavailable */
+
+	return -1;
+}
+
+void isp_af_notify(int notify)
+{
+	camnotify = notify;
+	if (camnotify && afstat.initialized) {
+		printk(KERN_DEBUG "Warning Camera Off \n");
+		afstat.stats_req = 0;
+		afstat.stats_done = 1;
+		wake_up_interruptible(&afstat.stats_wait);
+	}
+}
+EXPORT_SYMBOL(isp_af_notify);
+/*
+ * This API allows the user to update White Balance gains, as well as
+ * exposure time and analog gain. It is also used to request frame
+ * statistics.
+ */
+int isp_af_request_statistics(struct isp_af_data *afdata)
+{
+	int ret = 0;
+	u16 frame_diff = 0;
+	u16 frame_cnt = afstat.frame_count;
+	wait_queue_t wqt;
+
+	if (!af_dev_configptr->config->af_config) {
+		printk(KERN_ERR "AF engine not enabled\n");
+		return -EINVAL;
+	}
+
+	if (!(afdata->update & REQUEST_STATISTICS)) {
+		afdata->af_statistics_buf = NULL;
+		goto out;
+	}
+
+	isp_af_unlock_buffers();
+	/* Stats available? */
+	DPRINTK_ISP_AF("Stats available?\n");
+	ret = isp_af_stats_available(afdata);
+	if (!ret)
+		goto out;
+
+	/* Stats in near future? */
+	DPRINTK_ISP_AF("Stats in near future?\n");
+	if (afdata->frame_number > frame_cnt)
+		frame_diff = afdata->frame_number - frame_cnt;
+	else if (afdata->frame_number < frame_cnt) {
+		if ((frame_cnt > (MAX_FRAME_COUNT - MAX_FUTURE_FRAMES)) &&
+				(afdata->frame_number < MAX_FRAME_COUNT)) {
+			frame_diff = afdata->frame_number + MAX_FRAME_COUNT -
+								frame_cnt;
+		} else {
+			/* Frame unavailable */
+			frame_diff = MAX_FUTURE_FRAMES + 1;
+		}
+	}
+
+	if (frame_diff > MAX_FUTURE_FRAMES) {
+		printk(KERN_ERR "Invalid frame requested, returning current"
+							" frame stats\n");
+		afdata->frame_number = frame_cnt;
+	}
+	if (!camnotify) {
+		/* Block until frame in near future completes */
+		afstat.frame_req = afdata->frame_number;
+		afstat.stats_req = 1;
+		afstat.stats_done = 0;
+		init_waitqueue_entry(&wqt, current);
+		ret = wait_event_interruptible(afstat.stats_wait,
+							afstat.stats_done == 1);
+		if (ret < 0) {
+			afdata->af_statistics_buf = NULL;
+			return ret;
+		}
+		DPRINTK_ISP_AF("ISP AF request status interrupt raised\n");
+
+		/* Stats now available */
+		ret = isp_af_stats_available(afdata);
+		if (ret) {
+			printk(KERN_ERR "After waiting for stats, stats not"
+							" available!!\n");
+			afdata->af_statistics_buf = NULL;
+		}
+	}
+
+out:
+	afdata->curr_frame = afstat.frame_count;
+
+	return 0;
+}
+EXPORT_SYMBOL(isp_af_request_statistics);
+
+/* This function will handle the H3A interrupt. */
+static void isp_af_isr(unsigned long status, isp_vbq_callback_ptr arg1,
+								void *arg2)
+{
+	u16 frame_align;
+
+	if ((H3A_AF_DONE & status) != H3A_AF_DONE)
+		return;
+
+	/* timestamp stats buffer */
+	do_gettimeofday(&active_buff->xtrastats.ts);
+	active_buff->config_counter = atomic_read(&afstat.config_counter);
+
+	/* Exchange buffers */
+	active_buff = active_buff->next;
+	if (active_buff->locked == 1)
+		active_buff = active_buff->next;
+	isp_af_set_address(active_buff->ispmmu_addr);
+
+	/* Update frame counter */
+	afstat.frame_count++;
+	frame_align = afstat.frame_count;
+	if (afstat.frame_count > MAX_FRAME_COUNT) {
+		afstat.frame_count = 1;
+		frame_align++;
+	}
+	active_buff->frame_num = afstat.frame_count;
+
+	/* Future Stats requested? */
+	if (afstat.stats_req) {
+		/* Is the frame we want already done? */
+		if (frame_align >= (afstat.frame_req + 1)) {
+			afstat.stats_req = 0;
+			afstat.stats_done = 1;
+			wake_up_interruptible(&afstat.stats_wait);
+		}
+	}
+}
+
+/* Function to Enable/Disable AF Engine */
+int isp_af_enable(int enable)
+{
+	unsigned int pcr;
+
+	pcr = isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+
+	/* Set AF_EN bit in PCR Register */
+	if (enable) {
+		if (isp_set_callback(CBK_H3A_AF_DONE, isp_af_isr,
+						(void *)NULL, (void *)NULL)) {
+			printk(KERN_ERR "No callback for AF\n");
+			return -EINVAL;
+		}
+
+		pcr |= AF_EN;
+	} else {
+		isp_unset_callback(CBK_H3A_AF_DONE);
+		pcr &= ~AF_EN;
+	}
+	isp_reg_writel(pcr, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+	return 0;
+}
+
+int isp_af_busy(void)
+{
+	return isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR)
+		& ISPH3A_PCR_BUSYAF;
+}
+
+/* Function to register the AF character device driver. */
+int __init isp_af_init(void)
+{
+	/*allocate memory for device structure and initialize it with 0 */
+	af_dev_configptr = kzalloc(sizeof(struct af_device), GFP_KERNEL);
+	if (!af_dev_configptr)
+		goto err_nomem1;
+
+	active_buff = NULL;
+
+	af_dev_configptr->config = (struct af_configuration *)
+			kzalloc(sizeof(struct af_configuration), GFP_KERNEL);
+
+	if (af_dev_configptr->config == NULL)
+		goto err_nomem2;
+
+	memset(&afstat, 0, sizeof(afstat));
+
+	init_waitqueue_head(&afstat.stats_wait);
+	spin_lock_init(&afstat.buffer_lock);
+
+	return 0;
+
+err_nomem2:
+	kfree(af_dev_configptr);
+err_nomem1:
+	printk(KERN_ERR "Error: kmalloc fail");
+	return -ENOMEM;
+}
+
+void isp_af_exit(void)
+{
+	int i;
+
+	/* Free buffers */
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (!afstat.af_buff[i].phy_addr)
+			continue;
+
+		ispmmu_kunmap(afstat.af_buff[i].ispmmu_addr);
+
+		dma_free_coherent(NULL,
+				  afstat.min_buf_size,
+				  (void *)afstat.af_buff[i].virt_addr,
+				  (dma_addr_t)afstat.af_buff[i].phy_addr);
+	}
+	kfree(af_dev_configptr->config);
+	kfree(af_dev_configptr);
+
+	memset(&afstat, 0, sizeof(afstat));
+
+	af_major = -1;
+}
diff --git a/drivers/media/video/isp/isp_af.h b/drivers/media/video/isp/isp_af.h
new file mode 100644
index 0000000..aad2dce
--- /dev/null
+++ b/drivers/media/video/isp/isp_af.h
@@ -0,0 +1,123 @@
+/*
+ * isp_af.h
+ *
+ * Include file for AF module in TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+/* Device Constants */
+#ifndef OMAP_ISP_AF_H
+#define OMAP_ISP_AF_H
+
+#include <mach/isp_user.h>
+
+#define AF_MAJOR_NUMBER			0
+#define ISPAF_NAME			"OMAPISP_AF"
+#define AF_NR_DEVS			1
+#define AF_TIMEOUT			((300 * HZ) / 1000)
+
+
+
+/* Print Macros */
+/*list of error code */
+#define AF_ERR_HZ_COUNT			800	/* Invalid Horizontal Count */
+#define AF_ERR_VT_COUNT			801	/* Invalid Vertical Count */
+#define AF_ERR_HEIGHT			802	/* Invalid Height */
+#define AF_ERR_WIDTH			803	/* Invalid width */
+#define AF_ERR_INCR			804	/* Invalid Increment */
+#define AF_ERR_HZ_START			805	/* Invalid horizontal Start */
+#define AF_ERR_VT_START			806	/* Invalud vertical Start */
+#define AF_ERR_IIRSH			807	/* Invalid IIRSH value */
+#define AF_ERR_IIR_COEF			808	/* Invalid Coefficient */
+#define AF_ERR_SETUP			809	/* Setup not done */
+#define AF_ERR_THRESHOLD		810	/* Invalid Threshold */
+#define AF_ERR_ENGINE_BUSY		811	/* Engine is busy */
+
+#define AFPID				0x0	/* Peripheral Revision
+						 * and Class Information
+						 */
+
+#define AFCOEF_OFFSET			0x00000004	/* COEFFICIENT BASE
+							 * ADDRESS
+							 */
+
+/*
+ * PCR fields
+ */
+#define AF_BUSYAF			(1 << 15)
+#define FVMODE				(1 << 14)
+#define RGBPOS				(0x7 << 11)
+#define MED_TH				(0xFF << 3)
+#define AF_MED_EN			(1 << 2)
+#define AF_ALAW_EN			(1 << 1)
+#define AF_EN				(1 << 0)
+
+/*
+ * AFPAX1 fields
+ */
+#define PAXW				(0x7F << 16)
+#define PAXH				0x7F
+
+/*
+ * AFPAX2 fields
+ */
+#define AFINCV				(0xF << 13)
+#define PAXVC				(0x7F << 6)
+#define PAXHC				0x3F
+
+/*
+ * AFPAXSTART fields
+ */
+#define PAXSH				(0xFFF<<16)
+#define PAXSV				0xFFF
+
+/*
+ * COEFFICIENT MASK
+ */
+
+#define COEF_MASK0			0xFFF
+#define COEF_MASK1			(0xFFF<<16)
+
+/* BIT SHIFTS */
+#define AF_RGBPOS_SHIFT			11
+#define AF_MED_TH_SHIFT			3
+#define AF_PAXW_SHIFT			16
+#define AF_LINE_INCR_SHIFT		13
+#define AF_VT_COUNT_SHIFT		6
+#define AF_HZ_START_SHIFT		16
+#define AF_COEF_SHIFT			16
+
+#define AF_UPDATEXS_TS			(1 << 0)
+#define AF_UPDATEXS_FIELDCOUNT	(1 << 1)
+#define AF_UPDATEXS_LENSPOS		(1 << 2)
+
+/* Structure for device of AF Engine */
+struct af_device {
+	struct af_configuration *config; /*Device configuration structure */
+	int size_paxel;		/*Paxel size in bytes */
+};
+
+int isp_af_check_paxel(void);
+int isp_af_check_iir(void);
+int isp_af_register_setup(struct af_device *af_dev);
+int isp_af_enable(int);
+int isp_af_busy(void);
+void isp_af_notify(int notify);
+int isp_af_request_statistics(struct isp_af_data *afdata);
+int isp_af_configure(struct af_configuration *afconfig);
+void isp_af_set_address(unsigned long);
+void isp_af_setxtrastats(struct isp_af_xtrastats *xtrastats, u8 updateflag);
+#endif	/* OMAP_ISP_AF_H */
diff --git a/drivers/media/video/isp/isph3a.c b/drivers/media/video/isp/isph3a.c
new file mode 100644
index 0000000..e0a0983
--- /dev/null
+++ b/drivers/media/video/isp/isph3a.c
@@ -0,0 +1,902 @@
+/*
+ * isph3a.c
+ *
+ * H3A module for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+#include <asm/cacheflush.h>
+
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
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
+	struct timeval ts;
+	u32 config_counter;
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
+	unsigned int curr_cfg_buf_size;
+
+	atomic_t config_counter;
+
+	u16 win_count;
+	u32 frame_count;
+	wait_queue_head_t stats_wait;
+	spinlock_t buffer_lock;		/* For stats buffers read/write sync */
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
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWWIN1, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINSTART, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINBLK, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWSUBWIN, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWBUFST, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX1, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAX2, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFPAXSTART, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFIIRSH, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFBUFST, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF010, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF032, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF054, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF076, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF098, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF0010, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF110, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF132, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF154, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF176, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF198, 0},
+	{OMAP3_ISP_IOMEM_H3A, ISPH3A_AFCOEF1010, 0},
+	{0, ISP_TOK_TERM, 0}
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
+
+	if (active_buff == NULL)
+		return;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (aewbstat.h3a_buff[i].frame_num != active_buff->frame_num)
+			continue;
+
+		if (i == 0) {
+			if (aewbstat.h3a_buff[H3A_MAX_BUFF - 1].
+							locked == 0) {
+				h3a_xtrastats[H3A_MAX_BUFF - 1] =
+							*xtrastats;
+			} else {
+				h3a_xtrastats[H3A_MAX_BUFF - 2] =
+							*xtrastats;
+			}
+		} else if (i == 1) {
+			if (aewbstat.h3a_buff[0].locked == 0)
+				h3a_xtrastats[0] = *xtrastats;
+			else {
+				h3a_xtrastats[H3A_MAX_BUFF - 1] =
+							*xtrastats;
+			}
+		} else {
+			if (aewbstat.h3a_buff[i - 1].locked == 0)
+				h3a_xtrastats[i - 1] = *xtrastats;
+			else
+				h3a_xtrastats[i - 2] = *xtrastats;
+		}
+		return;
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
+void isph3a_aewb_enable(u8 enable)
+{
+	isp_reg_writel(IRQ0STATUS_H3A_AWB_DONE_IRQ, OMAP3_ISP_IOMEM_MAIN,
+							ISP_IRQ0STATUS);
+
+	if (enable) {
+		aewb_regs.reg_pcr |= ISPH3A_PCR_AEW_EN;
+		DPRINTK_ISPH3A("    H3A enabled \n");
+	} else {
+		aewb_regs.reg_pcr &= ~ISPH3A_PCR_AEW_EN;
+		DPRINTK_ISPH3A("    H3A disabled \n");
+	}
+	isp_reg_and_or(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR, ~ISPH3A_PCR_AEW_EN,
+					(enable ? ISPH3A_PCR_AEW_EN : 0));
+	aewb_config_local.aewb_enable = enable;
+}
+
+int isph3a_aewb_busy(void)
+{
+	return isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR)
+		& ISPH3A_PCR_BUSYAEAWB;
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
+	isp_reg_writel(aewb_regs.reg_pcr, OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR);
+	isp_reg_writel(aewb_regs.reg_win1, OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWWIN1);
+	isp_reg_writel(aewb_regs.reg_start, OMAP3_ISP_IOMEM_H3A,
+							ISPH3A_AEWINSTART);
+	isp_reg_writel(aewb_regs.reg_blk, OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINBLK);
+	isp_reg_writel(aewb_regs.reg_subwin, OMAP3_ISP_IOMEM_H3A,
+							ISPH3A_AEWSUBWIN);
+
+	aewbstat.update = 0;
+	aewbstat.frame_count = 1;
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
+					(void *)buffer->addr_align + size);
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
+	int i, ret;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&aewbstat.buffer_lock, irqflags);
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		DPRINTK_ISPH3A("Checking Stats buff[%d] (%d) for %d\n",
+				i, aewbstat.h3a_buff[i].frame_num,
+				aewbdata->frame_number);
+		if ((aewbdata->frame_number !=
+				aewbstat.h3a_buff[i].frame_num) ||
+			(aewbstat.h3a_buff[i].frame_num ==
+				active_buff->frame_num))
+			continue;
+		aewbstat.h3a_buff[i].locked = 1;
+		spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+		isph3a_aewb_update_req_buffer(&aewbstat.h3a_buff[i]);
+		aewbstat.h3a_buff[i].frame_num = 0;
+		ret = copy_to_user((void *)aewbdata->h3a_aewb_statistics_buf,
+					(void *)aewbstat.h3a_buff[i].virt_addr,
+					aewbstat.curr_cfg_buf_size);
+		if (ret) {
+			printk(KERN_ERR "Failed copy_to_user for "
+					"H3A stats buff, %d\n", ret);
+		}
+		aewbdata->ts = aewbstat.h3a_buff[i].ts;
+		aewbdata->config_counter = aewbstat.h3a_buff[i].config_counter;
+		aewbdata->field_count = h3a_xtrastats[i].field_count;
+		return 0;
+	}
+	spin_unlock_irqrestore(&aewbstat.buffer_lock, irqflags);
+
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
+	do_gettimeofday(&active_buff->ts);
+	active_buff->config_counter = atomic_read(&aewbstat.config_counter);
+	active_buff = active_buff->next;
+	if (active_buff->locked == 1)
+		active_buff = active_buff->next;
+	isp_reg_writel(active_buff->ispmmu_addr, OMAP3_ISP_IOMEM_H3A,
+							ISPH3A_AEWBUFST);
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
+	}
+	if (aewb_config_local.saturation_limit != user_cfg->saturation_limit) {
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
+	}
+	if (aewb_config_local.win_height != user_cfg->win_height) {
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
+	}
+	if (aewb_config_local.win_width != user_cfg->win_width) {
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
+	}
+	if (aewb_config_local.ver_win_count != user_cfg->ver_win_count) {
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
+	}
+	if (aewb_config_local.hor_win_count != user_cfg->hor_win_count) {
+		WRITE_HOR_C(aewb_regs.reg_win1, user_cfg->hor_win_count);
+		aewb_config_local.hor_win_count	= user_cfg->hor_win_count;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->ver_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid vertical window start: %d\n",
+						user_cfg->ver_win_start);
+		return -EINVAL;
+	}
+	if (aewb_config_local.ver_win_start != user_cfg->ver_win_start) {
+		WRITE_VER_WIN_ST(aewb_regs.reg_start, user_cfg->ver_win_start);
+		aewb_config_local.ver_win_start = user_cfg->ver_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->hor_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid horizontal window start: %d\n",
+						user_cfg->hor_win_start);
+		return -EINVAL;
+	}
+	if (aewb_config_local.hor_win_start != user_cfg->hor_win_start) {
+		WRITE_HOR_WIN_ST(aewb_regs.reg_start, user_cfg->hor_win_start);
+		aewb_config_local.hor_win_start	= user_cfg->hor_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely(user_cfg->blk_ver_win_start > MAX_WINSTART)) {
+		printk(KERN_ERR "Invalid black vertical window start: %d\n",
+						user_cfg->blk_ver_win_start);
+		return -EINVAL;
+	}
+	if (aewb_config_local.blk_ver_win_start !=
+						user_cfg->blk_ver_win_start) {
+		WRITE_BLK_VER_WIN_ST(aewb_regs.reg_blk,
+						user_cfg->blk_ver_win_start);
+		aewb_config_local.blk_ver_win_start =
+						user_cfg->blk_ver_win_start;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->blk_win_height < MIN_WIN_H) ||
+				(user_cfg->blk_win_height > MAX_WIN_H) ||
+				(user_cfg->blk_win_height & 0x01))) {
+		printk(KERN_ERR "Invalid black window height: %d\n",
+						user_cfg->blk_win_height);
+		return -EINVAL;
+	}
+	if (aewb_config_local.blk_win_height != user_cfg->blk_win_height) {
+		WRITE_BLK_WIN_H(aewb_regs.reg_blk, user_cfg->blk_win_height);
+		aewb_config_local.blk_win_height = user_cfg->blk_win_height;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->subsample_ver_inc < MIN_SUB_INC) ||
+				(user_cfg->subsample_ver_inc > MAX_SUB_INC) ||
+				(user_cfg->subsample_ver_inc & 0x01))) {
+		printk(KERN_ERR "Invalid vertical subsample increment: %d\n",
+						user_cfg->subsample_ver_inc);
+		return -EINVAL;
+	}
+	if (aewb_config_local.subsample_ver_inc !=
+						user_cfg->subsample_ver_inc) {
+		WRITE_SUB_VER_INC(aewb_regs.reg_subwin,
+						user_cfg->subsample_ver_inc);
+		aewb_config_local.subsample_ver_inc =
+						user_cfg->subsample_ver_inc;
+		aewbstat.update = 1;
+	}
+
+	if (unlikely((user_cfg->subsample_hor_inc < MIN_SUB_INC) ||
+				(user_cfg->subsample_hor_inc > MAX_SUB_INC) ||
+				(user_cfg->subsample_hor_inc & 0x01))) {
+		printk(KERN_ERR "Invalid horizontal subsample increment: %d\n",
+						user_cfg->subsample_hor_inc);
+		return -EINVAL;
+	}
+	if (aewb_config_local.subsample_hor_inc !=
+						user_cfg->subsample_hor_inc) {
+		WRITE_SUB_HOR_INC(aewb_regs.reg_subwin,
+						user_cfg->subsample_hor_inc);
+		aewb_config_local.subsample_hor_inc =
+						user_cfg->subsample_hor_inc;
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
+						(void *)NULL, (void *)NULL);
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
+	win_count += (win_count % 8) ? 1 : 0;
+	win_count += ret;
+
+	aewbstat.win_count = win_count;
+	aewbstat.curr_cfg_buf_size = win_count * AEWB_PACKET_SIZE;
+
+	if (aewbstat.stats_buf_size && ((win_count * AEWB_PACKET_SIZE) >
+						aewbstat.stats_buf_size)) {
+		DPRINTK_ISPH3A("There was a previous buffer... "
+			"Freeing/unmapping current stat busffs\n");
+		isph3a_aewb_enable(0);
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			ispmmu_kunmap(aewbstat.h3a_buff[i].ispmmu_addr);
+			dma_free_coherent(NULL,
+				aewbstat.min_buf_size,
+				(void *)aewbstat.h3a_buff[i].virt_addr,
+				(dma_addr_t)aewbstat.h3a_buff[i].phy_addr);
+			aewbstat.h3a_buff[i].virt_addr = 0;
+		}
+		aewbstat.stats_buf_size = 0;
+	}
+
+	if (!aewbstat.h3a_buff[0].virt_addr) {
+		aewbstat.stats_buf_size = win_count * AEWB_PACKET_SIZE;
+		aewbstat.min_buf_size = PAGE_ALIGN(aewbstat.stats_buf_size);
+
+		DPRINTK_ISPH3A("Allocating/mapping new stat buffs\n");
+		for (i = 0; i < H3A_MAX_BUFF; i++) {
+			aewbstat.h3a_buff[i].virt_addr =
+				(unsigned long)dma_alloc_coherent(NULL,
+				aewbstat.min_buf_size,
+				(dma_addr_t *)&aewbstat.h3a_buff[i].phy_addr,
+				GFP_KERNEL | GFP_DMA);
+			if (aewbstat.h3a_buff[i].virt_addr == 0) {
+				printk(KERN_ERR "Can't acquire memory for "
+					"buffer[%d]\n", i);
+				return -ENOMEM;
+			}
+			aewbstat.h3a_buff[i].addr_align =
+						aewbstat.h3a_buff[i].virt_addr;
+			while ((aewbstat.h3a_buff[i].addr_align &
+							0xFFFFFFC0) !=
+							aewbstat.h3a_buff[i].
+							addr_align)
+				aewbstat.h3a_buff[i].addr_align++;
+			aewbstat.h3a_buff[i].ispmmu_addr = ispmmu_kmap(aewbstat.
+							h3a_buff[i].phy_addr,
+							aewbstat.min_buf_size);
+		}
+		isph3a_aewb_unlock_buffers();
+		isph3a_aewb_link_buffers();
+
+		if (active_buff == NULL)
+			active_buff = &aewbstat.h3a_buff[0];
+
+		isp_reg_writel(active_buff->ispmmu_addr, OMAP3_ISP_IOMEM_H3A,
+							ISPH3A_AEWBUFST);
+	}
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		DPRINTK_ISPH3A("buff[%d] addr is:\n    virt    0x%lX\n"
+					"    aligned 0x%lX\n"
+					"    phys    0x%lX\n"
+					"    ispmmu  0x%08lX\n"
+					"    mmapped 0x%lX\n"
+					"    frame_num %d\n", i,
+					aewbstat.h3a_buff[i].virt_addr,
+					aewbstat.h3a_buff[i].addr_align,
+					aewbstat.h3a_buff[i].phy_addr,
+					aewbstat.h3a_buff[i].ispmmu_addr,
+					aewbstat.h3a_buff[i].mmap_addr,
+					aewbstat.h3a_buff[i].frame_num);
+	}
+
+	active_buff->frame_num = 1;
+
+	atomic_inc(&aewbstat.config_counter);
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
+
+	DPRINTK_ISPH3A("isph3a_aewb_request_statistics: Enter "
+		"(frame req. => %d, current frame => %d, update => %d)\n",
+		aewbdata->frame_number, frame_cnt, aewbdata->update);
+	DPRINTK_ISPH3A("User data received: \n");
+	DPRINTK_ISPH3A("Digital gain = 0x%04x\n", aewbdata->dgain);
+	DPRINTK_ISPH3A("WB gain b *=   0x%04x\n", aewbdata->wb_gain_b);
+	DPRINTK_ISPH3A("WB gain r *=   0x%04x\n", aewbdata->wb_gain_r);
+	DPRINTK_ISPH3A("WB gain gb =   0x%04x\n", aewbdata->wb_gain_gb);
+	DPRINTK_ISPH3A("WB gain gr =   0x%04x\n", aewbdata->wb_gain_gr);
+
+	if (!aewbdata->update) {
+		aewbdata->h3a_aewb_statistics_buf = NULL;
+		goto out;
+	}
+	if (aewbdata->update & SET_DIGITAL_GAIN)
+		h3awb_update.dgain = (u16)aewbdata->dgain;
+	if (aewbdata->update & SET_COLOR_GAINS) {
+		h3awb_update.coef0 = (u8)aewbdata->wb_gain_gr;
+		h3awb_update.coef1 = (u8)aewbdata->wb_gain_r;
+		h3awb_update.coef2 = (u8)aewbdata->wb_gain_b;
+		h3awb_update.coef3 = (u8)aewbdata->wb_gain_gb;
+	}
+	if (aewbdata->update & (SET_COLOR_GAINS | SET_DIGITAL_GAIN))
+		wb_update = 1;
+
+	if (!(aewbdata->update & REQUEST_STATISTICS)) {
+		aewbdata->h3a_aewb_statistics_buf = NULL;
+		goto out;
+	}
+
+	if (aewbdata->frame_number < 1) {
+		printk(KERN_ERR "Illeagal frame number "
+			"requested (%d)\n",
+			aewbdata->frame_number);
+		return -EINVAL;
+	}
+
+	isph3a_aewb_unlock_buffers();
+
+	DPRINTK_ISPH3A("Stats available?\n");
+	ret = isph3a_aewb_stats_available(aewbdata);
+	if (!ret)
+		goto out;
+
+	DPRINTK_ISPH3A("Stats in near future?\n");
+	if (aewbdata->frame_number > frame_cnt)
+		frame_diff = aewbdata->frame_number - frame_cnt;
+	else if (aewbdata->frame_number < frame_cnt) {
+		if ((frame_cnt > (MAX_FRAME_COUNT - MAX_FUTURE_FRAMES)) &&
+				(aewbdata->frame_number < MAX_FRAME_COUNT)) {
+			frame_diff = aewbdata->frame_number + MAX_FRAME_COUNT -
+								frame_cnt;
+		} else
+			frame_diff = MAX_FUTURE_FRAMES + 1;
+	}
+
+	if (frame_diff > MAX_FUTURE_FRAMES) {
+		printk(KERN_ERR "Invalid frame requested, returning current"
+							" frame stats\n");
+		aewbdata->frame_number = frame_cnt;
+	}
+	if (camnotify) {
+		DPRINTK_ISPH3A("NOT Waiting on stats IRQ for frame %d "
+			"because camnotify set\n", aewbdata->frame_number);
+		aewbdata->h3a_aewb_statistics_buf = NULL;
+		goto out;
+	}
+	DPRINTK_ISPH3A("Waiting on stats IRQ for frame %d\n",
+						aewbdata->frame_number);
+	aewbstat.frame_req = aewbdata->frame_number;
+	aewbstat.stats_req = 1;
+	aewbstat.stats_done = 0;
+	init_waitqueue_entry(&wqt, current);
+	ret = wait_event_interruptible(aewbstat.stats_wait,
+						aewbstat.stats_done == 1);
+	if (ret < 0) {
+		printk(KERN_ERR "isph3a_aewb_request_statistics"
+					" Error on wait event %d\n", ret);
+		aewbdata->h3a_aewb_statistics_buf = NULL;
+		return ret;
+	}
+
+	DPRINTK_ISPH3A("ISP AEWB request status interrupt raised\n");
+	ret = isph3a_aewb_stats_available(aewbdata);
+	if (ret) {
+		DPRINTK_ISPH3A("After waiting for stats,"
+						" stats not available!!\n");
+		aewbdata->h3a_aewb_statistics_buf = NULL;
+	}
+out:
+	DPRINTK_ISPH3A("isph3a_aewb_request_statistics: "
+				"aewbdata->h3a_aewb_statistics_buf => %p\n",
+				aewbdata->h3a_aewb_statistics_buf);
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
+int __init isph3a_aewb_init(void)
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
+void isph3a_aewb_cleanup(void)
+{
+	int i;
+
+	for (i = 0; i < H3A_MAX_BUFF; i++) {
+		if (!aewbstat.h3a_buff[i].phy_addr)
+			continue;
+
+		ispmmu_kunmap(aewbstat.h3a_buff[i].ispmmu_addr);
+		dma_free_coherent(NULL,
+				  aewbstat.min_buf_size,
+				  (void *)aewbstat.h3a_buff[i].virt_addr,
+				  (dma_addr_t)aewbstat.h3a_buff[i].phy_addr);
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
+	DPRINTK_ISPH3A("ISPH3A_PCR = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_PCR));
+	DPRINTK_ISPH3A("ISPH3A_AEWWIN1 = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWWIN1));
+	DPRINTK_ISPH3A("ISPH3A_AEWINSTART = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINSTART));
+	DPRINTK_ISPH3A("ISPH3A_AEWINBLK = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWINBLK));
+	DPRINTK_ISPH3A("ISPH3A_AEWSUBWIN = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWSUBWIN));
+	DPRINTK_ISPH3A("ISPH3A_AEWBUFST = 0x%08x\n",
+			isp_reg_readl(OMAP3_ISP_IOMEM_H3A, ISPH3A_AEWBUFST));
+	DPRINTK_ISPH3A("stats windows = %d\n", aewbstat.win_count);
+	DPRINTK_ISPH3A("stats buff size = %d\n", aewbstat.stats_buf_size);
+	DPRINTK_ISPH3A("currently configured stats buff size = %d\n",
+						aewbstat.curr_cfg_buf_size);
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
diff --git a/drivers/media/video/isp/isph3a.h b/drivers/media/video/isp/isph3a.h
new file mode 100644
index 0000000..e87c8a2
--- /dev/null
+++ b/drivers/media/video/isp/isph3a.h
@@ -0,0 +1,123 @@
+/*
+ * isph3a.h
+ *
+ * Include file for H3A module in TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+#include <mach/isp_user.h>
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
+ * @field_count: Sequence number of returned framestats.
+ * @isph3a_aewb_xtrastats: Pointer to next buffer with extra stats.
+ */
+struct isph3a_aewb_xtrastats {
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
+void isph3a_aewb_enable(u8 enable);
+
+int isph3a_aewb_busy(void);
+
+void isph3a_update_wb(void);
+
+void isph3a_notify(int notify);
+#endif		/* OMAP_ISP_H3A_H */
diff --git a/drivers/media/video/isp/isphist.c b/drivers/media/video/isp/isphist.c
new file mode 100644
index 0000000..270dbc2
--- /dev/null
+++ b/drivers/media/video/isp/isphist.c
@@ -0,0 +1,584 @@
+/*
+ * isphist.c
+ *
+ * HISTOGRAM module for TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+#include <asm/cacheflush.h>
+
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isphist.h"
+#include "ispmmu.h"
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
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_WB_GAIN, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_HORZ, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_VERT, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_HORZ, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_VERT, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_HORZ, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_VERT, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_HORZ, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_VERT, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_RADD, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_RADD_OFF, 0},
+	{OMAP3_ISP_IOMEM_HIST, ISPHIST_H_V_INFO, 0},
+	{0, ISP_TOK_TERM, 0}
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
+void isp_hist_enable(u8 enable)
+{
+	if (enable)
+		DPRINTK_ISPHIST("   histogram enabled \n");
+	else
+		DPRINTK_ISPHIST("   histogram disabled \n");
+
+	isp_reg_and_or(OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR, ~ISPHIST_PCR_EN,
+						(enable ? ISPHIST_PCR_EN : 0));
+	histstat.hist_enable = enable;
+}
+
+int isp_hist_busy(void)
+{
+	return isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR) &
+							ISPHIST_PCR_BUSY;
+}
+
+
+/**
+ * isp_hist_update_regs - Helper function to update Histogram registers.
+ **/
+static void isp_hist_update_regs(void)
+{
+	isp_reg_writel(hist_regs.reg_pcr, OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR);
+	isp_reg_writel(hist_regs.reg_cnt, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT);
+	isp_reg_writel(hist_regs.reg_wb_gain, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_WB_GAIN);
+	isp_reg_writel(hist_regs.reg_r0_h, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R0_HORZ);
+	isp_reg_writel(hist_regs.reg_r0_v, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R0_VERT);
+	isp_reg_writel(hist_regs.reg_r1_h, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R1_HORZ);
+	isp_reg_writel(hist_regs.reg_r1_v, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R1_VERT);
+	isp_reg_writel(hist_regs.reg_r2_h, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R2_HORZ);
+	isp_reg_writel(hist_regs.reg_r2_v, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R2_VERT);
+	isp_reg_writel(hist_regs.reg_r3_h, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R3_HORZ);
+	isp_reg_writel(hist_regs.reg_r3_v, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_R3_VERT);
+	isp_reg_writel(hist_regs.reg_hist_addr, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_ADDR);
+	isp_reg_writel(hist_regs.reg_hist_data, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_DATA);
+	isp_reg_writel(hist_regs.reg_hist_radd, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_RADD);
+	isp_reg_writel(hist_regs.reg_hist_radd_off, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_RADD_OFF);
+	isp_reg_writel(hist_regs.reg_h_v_info, OMAP3_ISP_IOMEM_HIST,
+							ISPHIST_H_V_INFO);
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
+	isp_reg_or(OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ISPHIST_CNT_CLR_EN);
+
+	for (i = 0; i < HIST_MEM_SIZE; i++)
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+
+	isp_reg_and(OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ~ISPHIST_CNT_CLR_EN);
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
+	if (isp_hist_busy())
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
+							user_cfg->hist_radd) {
+			WRITE_RADD(hist_regs.reg_hist_radd,
+							user_cfg->hist_radd);
+		} else {
+			printk(KERN_ERR "Address should be in 32 byte boundary"
+									"\n");
+			return -EINVAL;
+		}
+
+		if ((user_cfg->hist_radd_off & ISP_32B_BOUNDARY_OFFSET) ==
+						user_cfg->hist_radd_off) {
+			WRITE_RADD_OFF(hist_regs.reg_hist_radd_off,
+						user_cfg->hist_radd_off);
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
+	if (likely((user_cfg->reg0_ver & ISPHIST_REGVERT_VEND_MASK) -
+			((user_cfg->reg0_ver & ISPHIST_REGVERT_VSTART_MASK) >>
+			ISPHIST_REGVERT_VSTART_SHIFT))) {
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
+	int i, ret;
+	u32 curr;
+
+	if (isp_hist_busy())
+		return -EBUSY;
+
+	if (!histstat.completed && histstat.initialized)
+		return -EINVAL;
+
+	isp_reg_or(OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT, ISPHIST_CNT_CLR_EN);
+
+	for (i = 0; i < HIST_MEM_SIZE; i++) {
+		curr = isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_DATA);
+		ret = put_user(curr, (histdata->hist_statistics_buf + i));
+		if (ret) {
+			printk(KERN_ERR "Failed copy_to_user for "
+						"HIST stats buff, %d\n", ret);
+		}
+	}
+
+	isp_reg_and(OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
+						~ISPHIST_CNT_CLR_EN);
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
+int __init isp_hist_init(void)
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
+void isp_hist_cleanup(void)
+{
+	memset(&histstat, 0, sizeof(histstat));
+	memset(&hist_regs, 0, sizeof(hist_regs));
+}
+
+/**
+ * isphist_save_context - Saves the values of the histogram module registers.
+ **/
+void isphist_save_context(void)
+{
+	DPRINTK_ISPHIST(" Saving context\n");
+	isp_save_context(isphist_reg_list);
+}
+EXPORT_SYMBOL(isphist_save_context);
+
+/**
+ * isphist_restore_context - Restores the values of the histogram module regs.
+ **/
+void isphist_restore_context(void)
+{
+	DPRINTK_ISPHIST(" Restoring context\n");
+	isp_restore_context(isphist_reg_list);
+}
+EXPORT_SYMBOL(isphist_restore_context);
+
+/**
+ * isp_hist_print_status - Debug print
+ **/
+static void isp_hist_print_status(void)
+{
+	DPRINTK_ISPHIST("ISPHIST_PCR = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_PCR));
+	DPRINTK_ISPHIST("ISPHIST_CNT = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT));
+	DPRINTK_ISPHIST("ISPHIST_WB_GAIN = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_WB_GAIN));
+	DPRINTK_ISPHIST("ISPHIST_R0_HORZ = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R0_VERT = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R0_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R1_HORZ = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R1_VERT = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R1_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R2_HORZ = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R2_VERT = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R2_VERT));
+	DPRINTK_ISPHIST("ISPHIST_R3_HORZ = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_HORZ));
+	DPRINTK_ISPHIST("ISPHIST_R3_VERT = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_R3_VERT));
+	DPRINTK_ISPHIST("ISPHIST_ADDR = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR));
+	DPRINTK_ISPHIST("ISPHIST_RADD = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_RADD));
+	DPRINTK_ISPHIST("ISPHIST_RADD_OFF = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_RADD_OFF));
+	DPRINTK_ISPHIST("ISPHIST_H_V_INFO = 0x%08x\n",
+		isp_reg_readl(OMAP3_ISP_IOMEM_HIST, ISPHIST_H_V_INFO));
+}
diff --git a/drivers/media/video/isp/isphist.h b/drivers/media/video/isp/isphist.h
new file mode 100644
index 0000000..e5c80d6
--- /dev/null
+++ b/drivers/media/video/isp/isphist.h
@@ -0,0 +1,101 @@
+/*
+ * isphist.h
+ *
+ * Header file for HISTOGRAM module in TI's OMAP3 Camera ISP
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contributors:
+ *	Sergio Aguirre <saaguirre@ti.com>
+ *	Troy Laramy
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
+#include <mach/isp_user.h>
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
+void isp_hist_enable(u8 enable);
+
+int isp_hist_busy(void);
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
-- 
1.5.6.5

