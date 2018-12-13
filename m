Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA817C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87846208E7
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87846208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbeLMJvY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:24 -0500
Received: from mga04.intel.com ([192.55.52.120]:43343 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbeLMJvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="101204817"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2018 01:51:12 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 0BC4B208B8;
        Thu, 13 Dec 2018 11:51:12 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNe9-0003tO-O1; Thu, 13 Dec 2018 11:51:09 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 03/22] media: staging/intel-ipu3: abi: Add register definitions and enum
Date:   Thu, 13 Dec 2018 11:50:48 +0200
Message-Id: <20181213095107.14894-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

Add macros and enums used for IPU3 firmware interface.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3-abi.h | 661 ++++++++++++++++++++++++++++++++++
 1 file changed, 661 insertions(+)
 create mode 100644 drivers/staging/media/ipu3/ipu3-abi.h

diff --git a/drivers/staging/media/ipu3/ipu3-abi.h b/drivers/staging/media/ipu3/ipu3-abi.h
new file mode 100644
index 0000000000000..e754ff5836c2e
--- /dev/null
+++ b/drivers/staging/media/ipu3/ipu3-abi.h
@@ -0,0 +1,661 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Intel Corporation */
+
+#ifndef __IPU3_ABI_H
+#define __IPU3_ABI_H
+
+#include "include/intel-ipu3.h"
+
+/******************* IMGU Hardware information *******************/
+
+typedef u32 imgu_addr_t;
+
+#define IMGU_ISP_VMEM_ALIGN			128
+#define IMGU_DVS_BLOCK_W			64
+#define IMGU_DVS_BLOCK_H			32
+#define IMGU_GDC_BUF_X				(2 * IMGU_DVS_BLOCK_W)
+#define IMGU_GDC_BUF_Y				IMGU_DVS_BLOCK_H
+/* n = 0..1 */
+#define IMGU_SP_PMEM_BASE(n)			(0x20000 + (n) * 0x4000)
+#define IMGU_MAX_BQ_GRID_WIDTH			80
+#define IMGU_MAX_BQ_GRID_HEIGHT			60
+#define IMGU_OBGRID_TILE_SIZE			16
+#define IMGU_PIXELS_PER_WORD			50
+#define IMGU_BYTES_PER_WORD			64
+#define IMGU_STRIPE_FIXED_HALF_OVERLAP		2
+#define IMGU_SHD_SETS				3
+#define IMGU_BDS_MIN_CLIP_VAL			0
+#define IMGU_BDS_MAX_CLIP_VAL			2
+
+#define IMGU_ABI_AWB_MAX_CELLS_PER_SET		160
+#define IMGU_ABI_AF_MAX_CELLS_PER_SET		32
+#define IMGU_ABI_AWB_FR_MAX_CELLS_PER_SET	32
+
+#define IMGU_ABI_ACC_OP_IDLE			0
+#define IMGU_ABI_ACC_OP_END_OF_ACK		1
+#define IMGU_ABI_ACC_OP_END_OF_OPS		2
+#define IMGU_ABI_ACC_OP_NO_OPS			3
+
+#define IMGU_ABI_ACC_OPTYPE_PROCESS_LINES	0
+#define IMGU_ABI_ACC_OPTYPE_TRANSFER_DATA	1
+
+/* Register definitions */
+
+/* PM_CTRL_0_5_0_IMGHMMADR */
+#define IMGU_REG_PM_CTRL			0x0
+#define IMGU_PM_CTRL_START			BIT(0)
+#define IMGU_PM_CTRL_CFG_DONE			BIT(1)
+#define IMGU_PM_CTRL_RACE_TO_HALT		BIT(2)
+#define IMGU_PM_CTRL_NACK_ALL			BIT(3)
+#define IMGU_PM_CTRL_CSS_PWRDN			BIT(4)
+#define IMGU_PM_CTRL_RST_AT_EOF			BIT(5)
+#define IMGU_PM_CTRL_FORCE_HALT			BIT(6)
+#define IMGU_PM_CTRL_FORCE_UNHALT		BIT(7)
+#define IMGU_PM_CTRL_FORCE_PWRDN		BIT(8)
+#define IMGU_PM_CTRL_FORCE_RESET		BIT(9)
+
+/* SYSTEM_REQ_0_5_0_IMGHMMADR */
+#define IMGU_REG_SYSTEM_REQ			0x18
+#define IMGU_SYSTEM_REQ_FREQ_MASK		0x3f
+#define IMGU_SYSTEM_REQ_FREQ_DIVIDER		25
+#define IMGU_REG_INT_STATUS			0x30
+#define IMGU_REG_INT_ENABLE			0x34
+#define IMGU_REG_INT_CSS_IRQ			BIT(31)
+/* STATE_0_5_0_IMGHMMADR */
+#define IMGU_REG_STATE				0x130
+#define IMGU_STATE_HALT_STS			BIT(0)
+#define IMGU_STATE_IDLE_STS			BIT(1)
+#define IMGU_STATE_POWER_UP			BIT(2)
+#define IMGU_STATE_POWER_DOWN			BIT(3)
+#define IMGU_STATE_CSS_BUSY_MASK		0xc0
+#define IMGU_STATE_PM_FSM_MASK			0x180
+#define IMGU_STATE_PWRDNM_FSM_MASK		0x1E00000
+/* PM_STS_0_5_0_IMGHMMADR */
+#define IMGU_REG_PM_STS				0x140
+
+#define IMGU_REG_BASE				0x4000
+
+#define IMGU_REG_ISP_CTRL			(IMGU_REG_BASE + 0x00)
+#define IMGU_CTRL_RST				BIT(0)
+#define IMGU_CTRL_START				BIT(1)
+#define IMGU_CTRL_BREAK				BIT(2)
+#define IMGU_CTRL_RUN				BIT(3)
+#define IMGU_CTRL_BROKEN			BIT(4)
+#define IMGU_CTRL_IDLE				BIT(5)
+#define IMGU_CTRL_SLEEPING			BIT(6)
+#define IMGU_CTRL_STALLING			BIT(7)
+#define IMGU_CTRL_IRQ_CLEAR			BIT(8)
+#define IMGU_CTRL_IRQ_READY			BIT(10)
+#define IMGU_CTRL_IRQ_SLEEPING			BIT(11)
+#define IMGU_CTRL_ICACHE_INV			BIT(12)
+#define IMGU_CTRL_IPREFETCH_EN			BIT(13)
+#define IMGU_REG_ISP_START_ADDR			(IMGU_REG_BASE + 0x04)
+#define IMGU_REG_ISP_ICACHE_ADDR		(IMGU_REG_BASE + 0x10)
+#define IMGU_REG_ISP_PC				(IMGU_REG_BASE + 0x1c)
+
+/* SP Registers, sp = 0:SP0; 1:SP1 */
+#define IMGU_REG_SP_CTRL(sp)		(IMGU_REG_BASE + (sp) * 0x100 + 0x100)
+	/* For bits in IMGU_REG_SP_CTRL, see IMGU_CTRL_* */
+#define IMGU_REG_SP_START_ADDR(sp)	(IMGU_REG_BASE + (sp) * 0x100 + 0x104)
+#define IMGU_REG_SP_ICACHE_ADDR(sp)	(IMGU_REG_BASE + (sp) * 0x100 + 0x11c)
+#define IMGU_REG_SP_CTRL_SINK(sp)	(IMGU_REG_BASE + (sp) * 0x100 + 0x130)
+#define IMGU_REG_SP_PC(sp)		(IMGU_REG_BASE + (sp) * 0x100 + 0x134)
+
+#define IMGU_REG_TLB_INVALIDATE		(IMGU_REG_BASE + 0x300)
+#define IMGU_TLB_INVALIDATE			1
+#define IMGU_REG_L1_PHYS		(IMGU_REG_BASE + 0x304) /* 27-bit pfn */
+
+#define IMGU_REG_CIO_GATE_BURST_STATE	(IMGU_REG_BASE + 0x404)
+#define IMGU_CIO_GATE_BURST_MASK        0x80
+
+#define IMGU_REG_GP_BUSY		(IMGU_REG_BASE + 0x500)
+#define IMGU_REG_GP_STARVING		(IMGU_REG_BASE + 0x504)
+#define IMGU_REG_GP_WORKLOAD		(IMGU_REG_BASE + 0x508)
+#define IMGU_REG_GP_IRQ(n)	(IMGU_REG_BASE + (n) * 4 + 0x50c) /* n = 0..4 */
+#define IMGU_REG_GP_SP1_STRMON_STAT	(IMGU_REG_BASE + 0x520)
+#define IMGU_REG_GP_SP2_STRMON_STAT	(IMGU_REG_BASE + 0x524)
+#define IMGU_REG_GP_ISP_STRMON_STAT	(IMGU_REG_BASE + 0x528)
+#define IMGU_REG_GP_MOD_STRMON_STAT	(IMGU_REG_BASE + 0x52c)
+
+/* Port definitions for the streaming monitors. */
+/* For each definition there is signal pair : valid [bit 0]- accept [bit 1] */
+#define IMGU_GP_STRMON_STAT_SP1_PORT_SP12DMA		BIT(0)
+#define IMGU_GP_STRMON_STAT_SP1_PORT_DMA2SP1		BIT(2)
+#define IMGU_GP_STRMON_STAT_SP1_PORT_SP12SP2		BIT(4)
+#define IMGU_GP_STRMON_STAT_SP1_PORT_SP22SP1		BIT(6)
+#define IMGU_GP_STRMON_STAT_SP1_PORT_SP12ISP		BIT(8)
+#define IMGU_GP_STRMON_STAT_SP1_PORT_ISP2SP1		BIT(10)
+
+#define IMGU_GP_STRMON_STAT_SP2_PORT_SP22DMA		BIT(0)
+#define IMGU_GP_STRMON_STAT_SP2_PORT_DMA2SP2		BIT(2)
+#define IMGU_GP_STRMON_STAT_SP2_PORT_SP22SP1		BIT(4)
+#define IMGU_GP_STRMON_STAT_SP2_PORT_SP12SP2		BIT(6)
+
+#define IMGU_GP_STRMON_STAT_ISP_PORT_ISP2DMA		BIT(0)
+#define IMGU_GP_STRMON_STAT_ISP_PORT_DMA2ISP		BIT(2)
+#define IMGU_GP_STRMON_STAT_ISP_PORT_ISP2SP1		BIT(4)
+#define IMGU_GP_STRMON_STAT_ISP_PORT_SP12ISP		BIT(6)
+
+/* Between the devices and the fifo */
+#define IMGU_GP_STRMON_STAT_MOD_PORT_SP12DMA		BIT(0)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_DMA2SP1		BIT(2)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_SP22DMA		BIT(4)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_DMA2SP2		BIT(6)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_ISP2DMA		BIT(8)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_DMA2ISP		BIT(10)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_CELLS2GDC		BIT(12)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_GDC2CELLS		BIT(14)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_CELLS2DECOMP	BIT(16)
+#define IMGU_GP_STRMON_STAT_MOD_PORT_DECOMP2CELLS	BIT(18)
+/* n = 1..6 */
+#define IMGU_GP_STRMON_STAT_MOD_PORT_S2V(n)	(1 << (((n) - 1) * 2 + 20))
+
+/* n = 1..15 */
+#define IMGU_GP_STRMON_STAT_ACCS_PORT_ACC(n)		(1 << (((n) - 1) * 2))
+
+/* After FIFO and demux before SP1, n = 1..15 */
+#define IMGU_GP_STRMON_STAT_ACCS2SP1_MON_PORT_ACC(n)	(1 << (((n) - 1) * 2))
+
+/* After FIFO and demux before SP2, n = 1..15 */
+#define IMGU_GP_STRMON_STAT_ACCS2SP2_MON_PORT_ACC(n)	(1 << (((n) - 1) * 2))
+
+#define IMGU_REG_GP_HALT				(IMGU_REG_BASE + 0x5dc)
+
+					/* n = 0..2 (main ctrl, SP0, SP1) */
+#define IMGU_REG_IRQCTRL_BASE(n)	(IMGU_REG_BASE + (n) * 0x100 + 0x700)
+#define IMGU_IRQCTRL_MAIN			0
+#define IMGU_IRQCTRL_SP0			1
+#define IMGU_IRQCTRL_SP1			2
+#define IMGU_IRQCTRL_NUM			3
+#define IMGU_IRQCTRL_IRQ_SP1			BIT(0)
+#define IMGU_IRQCTRL_IRQ_SP2			BIT(1)
+#define IMGU_IRQCTRL_IRQ_ISP			BIT(2)
+#define IMGU_IRQCTRL_IRQ_SP1_STREAM_MON		BIT(3)
+#define IMGU_IRQCTRL_IRQ_SP2_STREAM_MON		BIT(4)
+#define IMGU_IRQCTRL_IRQ_ISP_STREAM_MON		BIT(5)
+#define IMGU_IRQCTRL_IRQ_MOD_STREAM_MON		BIT(6)
+#define IMGU_IRQCTRL_IRQ_MOD_ISP_STREAM_MON	BIT(7)
+#define IMGU_IRQCTRL_IRQ_ACCS_STREAM_MON	BIT(8)
+#define IMGU_IRQCTRL_IRQ_ACCS_SP1_STREAM_MON	BIT(9)
+#define IMGU_IRQCTRL_IRQ_ACCS_SP2_STREAM_MON	BIT(10)
+#define IMGU_IRQCTRL_IRQ_ISP_PMEM_ERROR		BIT(11)
+#define IMGU_IRQCTRL_IRQ_ISP_BAMEM_ERROR	BIT(12)
+#define IMGU_IRQCTRL_IRQ_ISP_VMEM_ERROR		BIT(13)
+#define IMGU_IRQCTRL_IRQ_ISP_DMEM_ERROR		BIT(14)
+#define IMGU_IRQCTRL_IRQ_SP1_ICACHE_MEM_ERROR	BIT(15)
+#define IMGU_IRQCTRL_IRQ_SP1_DMEM_ERROR		BIT(16)
+#define IMGU_IRQCTRL_IRQ_SP2_ICACHE_MEM_ERROR	BIT(17)
+#define IMGU_IRQCTRL_IRQ_SP2_DMEM_ERROR		BIT(18)
+#define IMGU_IRQCTRL_IRQ_ACCS_SCRATCH_MEM_ERROR	BIT(19)
+#define IMGU_IRQCTRL_IRQ_GP_TIMER(n)		BIT(20 + (n)) /* n=0..1 */
+#define IMGU_IRQCTRL_IRQ_DMA			BIT(22)
+#define IMGU_IRQCTRL_IRQ_SW_PIN(n)		BIT(23 + (n)) /* n=0..4 */
+#define IMGU_IRQCTRL_IRQ_ACC_SYS		BIT(28)
+#define IMGU_IRQCTRL_IRQ_OUT_FORM_IRQ_CTRL	BIT(29)
+#define IMGU_IRQCTRL_IRQ_SP1_IRQ_CTRL		BIT(30)
+#define IMGU_IRQCTRL_IRQ_SP2_IRQ_CTRL		BIT(31)
+#define IMGU_REG_IRQCTRL_EDGE(n)	(IMGU_REG_IRQCTRL_BASE(n) + 0x00)
+#define IMGU_REG_IRQCTRL_MASK(n)	(IMGU_REG_IRQCTRL_BASE(n) + 0x04)
+#define IMGU_REG_IRQCTRL_STATUS(n)	(IMGU_REG_IRQCTRL_BASE(n) + 0x08)
+#define IMGU_REG_IRQCTRL_CLEAR(n)	(IMGU_REG_IRQCTRL_BASE(n) + 0x0c)
+#define IMGU_REG_IRQCTRL_ENABLE(n)	(IMGU_REG_IRQCTRL_BASE(n) + 0x10)
+#define IMGU_REG_IRQCTRL_EDGE_NOT_PULSE(n) (IMGU_REG_IRQCTRL_BASE(n) + 0x14)
+#define IMGU_REG_IRQCTRL_STR_OUT_ENABLE(n) (IMGU_REG_IRQCTRL_BASE(n) + 0x18)
+
+#define IMGU_REG_GP_TIMER		(IMGU_REG_BASE + 0xa34)
+
+#define IMGU_REG_SP_DMEM_BASE(n)	(IMGU_REG_BASE + (n) * 0x4000 + 0x4000)
+#define IMGU_REG_ISP_DMEM_BASE		(IMGU_REG_BASE + 0xc000)
+
+#define IMGU_REG_GDC_BASE		(IMGU_REG_BASE + 0x18000)
+#define IMGU_REG_GDC_LUT_BASE		(IMGU_REG_GDC_BASE + 0x140)
+#define IMGU_GDC_LUT_MASK		((1 << 12) - 1) /* Range -1024..+1024 */
+
+#define IMGU_SCALER_PHASES			32
+#define IMGU_SCALER_COEFF_BITS			24
+#define IMGU_SCALER_PHASE_COUNTER_PREC_REF	6
+#define IMGU_SCALER_MAX_EXPONENT_SHIFT		3
+#define IMGU_SCALER_FILTER_TAPS			4
+#define IMGU_SCALER_TAPS_Y			IMGU_SCALER_FILTER_TAPS
+#define IMGU_SCALER_TAPS_UV			(IMGU_SCALER_FILTER_TAPS / 2)
+#define IMGU_SCALER_FIR_PHASES \
+		(IMGU_SCALER_PHASES << IMGU_SCALER_PHASE_COUNTER_PREC_REF)
+
+/******************* imgu_abi_acc_param *******************/
+
+#define IMGU_ABI_SHD_MAX_PROCESS_LINES		31
+#define IMGU_ABI_SHD_MAX_TRANSFERS		31
+#define IMGU_ABI_SHD_MAX_OPERATIONS \
+		(IMGU_ABI_SHD_MAX_PROCESS_LINES + IMGU_ABI_SHD_MAX_TRANSFERS)
+#define IMGU_ABI_SHD_MAX_CELLS_PER_SET		146
+/* largest grid is 73x56 */
+#define IMGU_ABI_SHD_MAX_CFG_SETS		(2 * 28)
+
+#define IMGU_ABI_DVS_STAT_MAX_OPERATIONS	100
+#define IMGU_ABI_DVS_STAT_MAX_PROCESS_LINES	52
+#define IMGU_ABI_DVS_STAT_MAX_TRANSFERS		52
+
+#define IMGU_ABI_BDS_SAMPLE_PATTERN_ARRAY_SIZE	8
+#define IMGU_ABI_BDS_PHASE_COEFFS_ARRAY_SIZE	32
+
+#define IMGU_ABI_AWB_FR_MAX_TRANSFERS		30
+#define IMGU_ABI_AWB_FR_MAX_PROCESS_LINES	30
+#define IMGU_ABI_AWB_FR_MAX_OPERATIONS \
+	(IMGU_ABI_AWB_FR_MAX_TRANSFERS + IMGU_ABI_AWB_FR_MAX_PROCESS_LINES)
+
+#define IMGU_ABI_AF_MAX_TRANSFERS		30
+#define IMGU_ABI_AF_MAX_PROCESS_LINES		30
+#define IMGU_ABI_AF_MAX_OPERATIONS \
+		(IMGU_ABI_AF_MAX_TRANSFERS + IMGU_ABI_AF_MAX_PROCESS_LINES)
+
+#define IMGU_ABI_AWB_MAX_PROCESS_LINES		68
+#define IMGU_ABI_AWB_MAX_TRANSFERS		68
+#define IMGU_ABI_AWB_MAX_OPERATIONS \
+		(IMGU_ABI_AWB_MAX_PROCESS_LINES + IMGU_ABI_AWB_MAX_TRANSFERS)
+
+#define IMGU_ABI_OSYS_PIN_VF			0
+#define IMGU_ABI_OSYS_PIN_OUT			1
+#define IMGU_ABI_OSYS_PINS			2
+
+#define IMGU_ABI_DVS_STAT_LEVELS		3
+#define IMGU_ABI_YUVP2_YTM_LUT_ENTRIES		256
+#define IMGU_ABI_GDC_FRAC_BITS			8
+#define IMGU_ABI_BINARY_MAX_OUTPUT_PORTS	2
+#define IMGU_ABI_MAX_BINARY_NAME		64
+#define IMGU_ABI_ISP_DDR_WORD_BITS		256
+#define IMGU_ABI_ISP_DDR_WORD_BYTES	(IMGU_ABI_ISP_DDR_WORD_BITS / 8)
+#define IMGU_ABI_MAX_STAGES			3
+#define IMGU_ABI_MAX_IF_CONFIGS			3
+#define IMGU_ABI_PIPE_CONFIG_ACQUIRE_ISP	BIT(31)
+#define IMGU_ABI_PORT_CONFIG_TYPE_INPUT_HOST	BIT(0)
+#define IMGU_ABI_PORT_CONFIG_TYPE_OUTPUT_HOST	BIT(4)
+#define IMGU_ABI_MAX_SP_THREADS			4
+#define IMGU_ABI_FRAMES_REF			3
+#define IMGU_ABI_FRAMES_TNR			4
+#define IMGU_ABI_BUF_SETS_TNR			1
+
+#define IMGU_ABI_EVENT_BUFFER_ENQUEUED(thread, queue)	\
+				(0 << 24 | (thread) << 16 | (queue) << 8)
+#define IMGU_ABI_EVENT_BUFFER_DEQUEUED(queue)	(1 << 24 | (queue) << 8)
+#define IMGU_ABI_EVENT_EVENT_DEQUEUED		(2 << 24)
+#define IMGU_ABI_EVENT_START_STREAM		(3 << 24)
+#define IMGU_ABI_EVENT_STOP_STREAM		(4 << 24)
+#define IMGU_ABI_EVENT_MIPI_BUFFERS_READY	(5 << 24)
+#define IMGU_ABI_EVENT_UNLOCK_RAW_BUFFER	(6 << 24)
+#define IMGU_ABI_EVENT_STAGE_ENABLE_DISABLE	(7 << 24)
+
+#define IMGU_ABI_HOST2SP_BUFQ_SIZE	3
+#define IMGU_ABI_SP2HOST_BUFQ_SIZE	(2 * IMGU_ABI_MAX_SP_THREADS)
+#define IMGU_ABI_HOST2SP_EVTQ_SIZE	(IMGU_ABI_QUEUE_NUM * \
+		IMGU_ABI_MAX_SP_THREADS * 2 + IMGU_ABI_MAX_SP_THREADS * 4)
+#define IMGU_ABI_SP2HOST_EVTQ_SIZE	(6 * IMGU_ABI_MAX_SP_THREADS)
+
+#define IMGU_ABI_EVTTYPE_EVENT_SHIFT	0
+#define IMGU_ABI_EVTTYPE_EVENT_MASK	(0xff << IMGU_ABI_EVTTYPE_EVENT_SHIFT)
+#define IMGU_ABI_EVTTYPE_PIPE_SHIFT	8
+#define IMGU_ABI_EVTTYPE_PIPE_MASK	(0xff << IMGU_ABI_EVTTYPE_PIPE_SHIFT)
+#define IMGU_ABI_EVTTYPE_PIPEID_SHIFT	16
+#define IMGU_ABI_EVTTYPE_PIPEID_MASK	(0xff << IMGU_ABI_EVTTYPE_PIPEID_SHIFT)
+#define IMGU_ABI_EVTTYPE_MODULEID_SHIFT	8
+#define IMGU_ABI_EVTTYPE_MODULEID_MASK (0xff << IMGU_ABI_EVTTYPE_MODULEID_SHIFT)
+#define IMGU_ABI_EVTTYPE_LINENO_SHIFT	16
+#define IMGU_ABI_EVTTYPE_LINENO_MASK   (0xffff << IMGU_ABI_EVTTYPE_LINENO_SHIFT)
+
+/* Output frame ready */
+#define IMGU_ABI_EVTTYPE_OUT_FRAME_DONE			0
+/* Second output frame ready */
+#define IMGU_ABI_EVTTYPE_2ND_OUT_FRAME_DONE		1
+/* Viewfinder Output frame ready */
+#define IMGU_ABI_EVTTYPE_VF_OUT_FRAME_DONE		2
+/* Second viewfinder Output frame ready */
+#define IMGU_ABI_EVTTYPE_2ND_VF_OUT_FRAME_DONE		3
+/* Indication that 3A statistics are available */
+#define IMGU_ABI_EVTTYPE_3A_STATS_DONE			4
+/* Indication that DIS statistics are available */
+#define IMGU_ABI_EVTTYPE_DIS_STATS_DONE			5
+/* Pipeline Done event, sent after last pipeline stage */
+#define IMGU_ABI_EVTTYPE_PIPELINE_DONE			6
+/* Frame tagged */
+#define IMGU_ABI_EVTTYPE_FRAME_TAGGED			7
+/* Input frame ready */
+#define IMGU_ABI_EVTTYPE_INPUT_FRAME_DONE		8
+/* Metadata ready */
+#define IMGU_ABI_EVTTYPE_METADATA_DONE			9
+/* Indication that LACE statistics are available */
+#define IMGU_ABI_EVTTYPE_LACE_STATS_DONE		10
+/* Extension stage executed */
+#define IMGU_ABI_EVTTYPE_ACC_STAGE_COMPLETE		11
+/* Timing measurement data */
+#define IMGU_ABI_EVTTYPE_TIMER				12
+/* End Of Frame event, sent when in buffered sensor mode */
+#define IMGU_ABI_EVTTYPE_PORT_EOF			13
+/* Performance warning encountered by FW */
+#define IMGU_ABI_EVTTYPE_FW_WARNING			14
+/* Assertion hit by FW */
+#define IMGU_ABI_EVTTYPE_FW_ASSERT			15
+
+#define IMGU_ABI_NUM_CONTINUOUS_FRAMES		10
+#define IMGU_ABI_SP_COMM_COMMAND		0x00
+
+/*
+ * The host2sp_cmd_ready command is the only command written by the SP
+ * It acknowledges that is previous command has been received.
+ * (this does not mean that the command has been executed)
+ * It also indicates that a new command can be send (it is a queue
+ * with depth 1).
+ */
+#define IMGU_ABI_SP_COMM_COMMAND_READY		1
+/* Command written by the Host */
+#define IMGU_ABI_SP_COMM_COMMAND_DUMMY		2	/* No action */
+#define IMGU_ABI_SP_COMM_COMMAND_START_FLASH	3	/* Start the flash */
+#define IMGU_ABI_SP_COMM_COMMAND_TERMINATE	4	/* Terminate */
+
+/* n = 0..IPU3_CSS_PIPE_ID_NUM-1 */
+#define IMGU_ABI_SP_COMM_EVENT_IRQ_MASK(n)		((n) * 4 + 0x60)
+#define IMGU_ABI_SP_COMM_EVENT_IRQ_MASK_OR_SHIFT	0
+#define IMGU_ABI_SP_COMM_EVENT_IRQ_MASK_AND_SHIFT	16
+
+#define IMGU_ABI_BL_DMACMD_TYPE_SP_PMEM		1	/* sp_pmem */
+
+/***** For parameter computation *****/
+
+#define IMGU_HIVE_OF_SYS_SCALER_TO_FA_OFFSET	0xC
+#define IMGU_HIVE_OF_SYS_OF_TO_FA_OFFSET	0x8
+#define IMGU_HIVE_OF_SYS_OF_SYSTEM_NWAYS	32
+
+#define IMGU_SCALER_ELEMS_PER_VEC		0x10
+#define IMGU_SCALER_FILTER_TAPS_Y		0x4
+#define IMGU_SCALER_OUT_BPP			0x8
+
+#define IMGU_SCALER_MS_TO_OUTFORMACC_SL_ADDR	0x400
+#define IMGU_SCALER_TO_OF_ACK_FA_ADDR \
+	(0xC00  + IMGU_HIVE_OF_SYS_SCALER_TO_FA_OFFSET)
+#define IMGU_OF_TO_ACK_FA_ADDR (0xC00 + IMGU_HIVE_OF_SYS_OF_TO_FA_OFFSET)
+#define IMGU_OUTFORMACC_MS_TO_SCALER_SL_ADDR 0
+#define IMGU_SCALER_INTR_BPP			10
+
+#define IMGU_PS_SNR_PRESERVE_BITS		3
+#define IMGU_CNTX_BPP				11
+#define IMGU_SCALER_FILTER_TAPS_UV	(IMGU_SCALER_FILTER_TAPS_Y / 2)
+
+#define IMGU_VMEM2_ELEMS_PER_VEC	(IMGU_SCALER_ELEMS_PER_VEC)
+#define IMGU_STRIDE_Y			(IMGU_SCALER_FILTER_TAPS_Y + 1)
+#define IMGU_MAX_FRAME_WIDTH		3840
+#define IMGU_VMEM3_ELEMS_PER_VEC	(IMGU_SCALER_ELEMS_PER_VEC)
+
+#define IMGU_VER_CNTX_WORDS		DIV_ROUND_UP((IMGU_SCALER_OUT_BPP + \
+	IMGU_PS_SNR_PRESERVE_BITS), IMGU_CNTX_BPP)	/* 1 */
+#define IMGU_MAX_INPUT_BLOCK_HEIGHT	64
+#define IMGU_HOR_CNTX_WORDS		DIV_ROUND_UP((IMGU_SCALER_INTR_BPP + \
+	IMGU_PS_SNR_PRESERVE_BITS), IMGU_CNTX_BPP)	/* 2 */
+#define IMGU_MAX_OUTPUT_BLOCK_WIDTH		128
+#define IMGU_CNTX_STRIDE_UV		(IMGU_SCALER_FILTER_TAPS_UV + 1)
+
+#define IMGU_OSYS_DMA_CROP_W_LIMIT		64
+#define IMGU_OSYS_DMA_CROP_H_LIMIT		4
+#define IMGU_OSYS_BLOCK_WIDTH			(2 * IPU3_UAPI_ISP_VEC_ELEMS)
+#define IMGU_OSYS_BLOCK_HEIGHT			32
+#define IMGU_OSYS_PHASES			0x20
+#define IMGU_OSYS_FILTER_TAPS			0x4
+#define IMGU_OSYS_PHASE_COUNTER_PREC_REF	6
+#define IMGU_OSYS_NUM_INPUT_BUFFERS		2
+#define IMGU_OSYS_FIR_PHASES \
+	(IMGU_OSYS_PHASES << IMGU_OSYS_PHASE_COUNTER_PREC_REF)
+#define IMGU_OSYS_TAPS_UV			(IMGU_OSYS_FILTER_TAPS / 2)
+#define IMGU_OSYS_TAPS_Y			(IMGU_OSYS_FILTER_TAPS)
+#define IMGU_OSYS_NUM_INTERM_BUFFERS		2
+
+#define IMGU_VMEM1_Y_SIZE \
+	(IMGU_OSYS_BLOCK_HEIGHT * IMGU_VMEM1_Y_STRIDE)
+#define IMGU_VMEM1_UV_SIZE			(IMGU_VMEM1_Y_SIZE / 4)
+#define IMGU_VMEM1_OUT_BUF_ADDR			(IMGU_VMEM1_INP_BUF_ADDR + \
+	(IMGU_OSYS_NUM_INPUT_BUFFERS * IMGU_VMEM1_BUF_SIZE))
+#define IMGU_OSYS_NUM_OUTPUT_BUFFERS		2
+
+/* transpose of input height */
+#define IMGU_VMEM2_VECS_PER_LINE \
+	(DIV_ROUND_UP(IMGU_OSYS_BLOCK_HEIGHT, IMGU_VMEM2_ELEMS_PER_VEC))
+/* size in words (vectors)  */
+#define IMGU_VMEM2_BUF_SIZE \
+	(IMGU_VMEM2_VECS_PER_LINE * IMGU_VMEM2_LINES_PER_BLOCK)
+#define IMGU_VMEM3_VER_Y_SIZE	\
+			((IMGU_STRIDE_Y * IMGU_MAX_FRAME_WIDTH \
+			 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_VER_CNTX_WORDS)
+#define IMGU_VMEM3_HOR_Y_SIZE \
+	((IMGU_STRIDE_Y * IMGU_MAX_INPUT_BLOCK_HEIGHT \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_HOR_CNTX_WORDS)
+#define IMGU_VMEM3_VER_Y_EXTRA \
+	((IMGU_STRIDE_Y * IMGU_MAX_OUTPUT_BLOCK_WIDTH \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_VER_CNTX_WORDS)
+#define IMGU_VMEM3_VER_U_SIZE \
+	(((IMGU_CNTX_STRIDE_UV * IMGU_MAX_FRAME_WIDTH \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_VER_CNTX_WORDS) / 2)
+#define IMGU_VMEM3_HOR_U_SIZE \
+	(((IMGU_STRIDE_Y * IMGU_MAX_INPUT_BLOCK_HEIGHT \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_HOR_CNTX_WORDS) / 2)
+#define IMGU_VMEM3_VER_U_EXTRA \
+	(((IMGU_CNTX_STRIDE_UV * IMGU_MAX_OUTPUT_BLOCK_WIDTH \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_VER_CNTX_WORDS) / 2)
+#define IMGU_VMEM3_VER_V_SIZE \
+	(((IMGU_CNTX_STRIDE_UV * IMGU_MAX_FRAME_WIDTH \
+	 / IMGU_VMEM3_ELEMS_PER_VEC) * IMGU_VER_CNTX_WORDS) / 2)
+
+#define IMGU_ISP_VEC_NELEMS		64
+#define IMGU_LUMA_TO_CHROMA_RATIO	2
+#define IMGU_INPUT_BLOCK_WIDTH			(128)
+#define IMGU_FIFO_ADDR_SCALER_TO_FMT \
+	(IMGU_SCALER_MS_TO_OUTFORMACC_SL_ADDR >> 2)
+#define IMGU_FIFO_ADDR_SCALER_TO_SP	(IMGU_SCALER_TO_OF_ACK_FA_ADDR >> 2)
+#define IMGU_VMEM1_INP_BUF_ADDR		0
+#define IMGU_VMEM1_Y_STRIDE \
+	(IMGU_OSYS_BLOCK_WIDTH / IMGU_VMEM1_ELEMS_PER_VEC)
+#define IMGU_VMEM1_BUF_SIZE	(IMGU_VMEM1_V_OFFSET + IMGU_VMEM1_UV_SIZE)
+
+#define IMGU_VMEM1_U_OFFSET		(IMGU_VMEM1_Y_SIZE)
+#define IMGU_VMEM1_V_OFFSET	(IMGU_VMEM1_U_OFFSET + IMGU_VMEM1_UV_SIZE)
+#define IMGU_VMEM1_UV_STRIDE		(IMGU_VMEM1_Y_STRIDE / 2)
+#define IMGU_VMEM1_INT_BUF_ADDR		(IMGU_VMEM1_OUT_BUF_ADDR + \
+	(IMGU_OSYS_NUM_OUTPUT_BUFFERS * IMGU_VMEM1_BUF_SIZE))
+
+#define IMGU_VMEM1_ELEMS_PER_VEC	(IMGU_HIVE_OF_SYS_OF_SYSTEM_NWAYS)
+#define IMGU_VMEM2_BUF_Y_ADDR		0
+#define IMGU_VMEM2_BUF_Y_STRIDE		(IMGU_VMEM2_VECS_PER_LINE)
+#define IMGU_VMEM2_BUF_U_ADDR \
+	(IMGU_VMEM2_BUF_Y_ADDR + IMGU_VMEM2_BUF_SIZE)
+#define IMGU_VMEM2_BUF_V_ADDR \
+	(IMGU_VMEM2_BUF_U_ADDR + IMGU_VMEM2_BUF_SIZE / 4)
+#define IMGU_VMEM2_BUF_UV_STRIDE	(IMGU_VMEM2_VECS_PER_LINE / 2)
+/* 1.5 x depth of intermediate buffer */
+#define IMGU_VMEM2_LINES_PER_BLOCK	192
+#define IMGU_VMEM3_HOR_Y_ADDR \
+	(IMGU_VMEM3_VER_Y_ADDR + IMGU_VMEM3_VER_Y_SIZE)
+#define IMGU_VMEM3_HOR_U_ADDR \
+	(IMGU_VMEM3_VER_U_ADDR + IMGU_VMEM3_VER_U_SIZE)
+#define IMGU_VMEM3_HOR_V_ADDR \
+	(IMGU_VMEM3_VER_V_ADDR + IMGU_VMEM3_VER_V_SIZE)
+#define IMGU_VMEM3_VER_Y_ADDR		0
+#define IMGU_VMEM3_VER_U_ADDR \
+	(IMGU_VMEM3_VER_Y_ADDR + IMGU_VMEM3_VER_Y_SIZE + \
+	max(IMGU_VMEM3_HOR_Y_SIZE, IMGU_VMEM3_VER_Y_EXTRA))
+#define IMGU_VMEM3_VER_V_ADDR \
+	(IMGU_VMEM3_VER_U_ADDR + IMGU_VMEM3_VER_U_SIZE + \
+	max(IMGU_VMEM3_HOR_U_SIZE, IMGU_VMEM3_VER_U_EXTRA))
+#define IMGU_FIFO_ADDR_FMT_TO_SP	(IMGU_OF_TO_ACK_FA_ADDR >> 2)
+#define IMGU_FIFO_ADDR_FMT_TO_SCALER (IMGU_OUTFORMACC_MS_TO_SCALER_SL_ADDR >> 2)
+#define IMGU_VMEM1_HST_BUF_ADDR		(IMGU_VMEM1_INT_BUF_ADDR + \
+	(IMGU_OSYS_NUM_INTERM_BUFFERS * IMGU_VMEM1_BUF_SIZE))
+#define IMGU_VMEM1_HST_BUF_STRIDE	120
+#define IMGU_VMEM1_HST_BUF_NLINES	3
+
+enum imgu_abi_frame_format {
+	IMGU_ABI_FRAME_FORMAT_NV11,	/* 12 bit YUV 411, Y, UV plane */
+	IMGU_ABI_FRAME_FORMAT_NV12,	/* 12 bit YUV 420, Y, UV plane */
+	IMGU_ABI_FRAME_FORMAT_NV12_16,	/* 16 bit YUV 420, Y, UV plane */
+	IMGU_ABI_FRAME_FORMAT_NV12_TILEY,/* 12 bit YUV 420,Intel tiled format */
+	IMGU_ABI_FRAME_FORMAT_NV16,	/* 16 bit YUV 422, Y, UV plane */
+	IMGU_ABI_FRAME_FORMAT_NV21,	/* 12 bit YUV 420, Y, VU plane */
+	IMGU_ABI_FRAME_FORMAT_NV61,	/* 16 bit YUV 422, Y, VU plane */
+	IMGU_ABI_FRAME_FORMAT_YV12,	/* 12 bit YUV 420, Y, V, U plane */
+	IMGU_ABI_FRAME_FORMAT_YV16,	/* 16 bit YUV 422, Y, V, U plane */
+	IMGU_ABI_FRAME_FORMAT_YUV420,	/* 12 bit YUV 420, Y, U, V plane */
+	IMGU_ABI_FRAME_FORMAT_YUV420_16,/* yuv420, 16 bits per subpixel */
+	IMGU_ABI_FRAME_FORMAT_YUV422,	/* 16 bit YUV 422, Y, U, V plane */
+	IMGU_ABI_FRAME_FORMAT_YUV422_16,/* yuv422, 16 bits per subpixel */
+	IMGU_ABI_FRAME_FORMAT_UYVY,	/* 16 bit YUV 422, UYVY interleaved */
+	IMGU_ABI_FRAME_FORMAT_YUYV,	/* 16 bit YUV 422, YUYV interleaved */
+	IMGU_ABI_FRAME_FORMAT_YUV444,	/* 24 bit YUV 444, Y, U, V plane */
+	IMGU_ABI_FRAME_FORMAT_YUV_LINE,	/* Internal format, 2 y lines */
+					/* followed by a uv-interleaved line */
+	IMGU_ABI_FRAME_FORMAT_RAW,	/* RAW, 1 plane */
+	IMGU_ABI_FRAME_FORMAT_RGB565,	/* 16 bit RGB, 1 plane. Each 3 sub
+					 * pixels are packed into one 16 bit
+					 * value, 5 bits for R, 6 bits for G
+					 * and 5 bits for B.
+					 */
+	IMGU_ABI_FRAME_FORMAT_PLANAR_RGB888, /* 24 bit RGB, 3 planes */
+	IMGU_ABI_FRAME_FORMAT_RGBA888,	/* 32 bit RGBA, 1 plane, A=Alpha
+					 * (alpha is unused)
+					 */
+	IMGU_ABI_FRAME_FORMAT_QPLANE6,	/* Internal, for advanced ISP */
+	IMGU_ABI_FRAME_FORMAT_BINARY_8,	/* byte stream, used for jpeg. For
+					 * frames of this type, we set the
+					 * height to 1 and the width to the
+					 * number of allocated bytes.
+					 */
+	IMGU_ABI_FRAME_FORMAT_MIPI,	/* MIPI frame, 1 plane */
+	IMGU_ABI_FRAME_FORMAT_RAW_PACKED,	 /* RAW, 1 plane, packed */
+	IMGU_ABI_FRAME_FORMAT_CSI_MIPI_YUV420_8, /* 8 bit per Y/U/V. Y odd line
+						  * UYVY interleaved even line
+						  */
+	IMGU_ABI_FRAME_FORMAT_CSI_MIPI_LEGACY_YUV420_8, /* Legacy YUV420.
+							 * UY odd line;
+							 * VY even line
+							 */
+	IMGU_ABI_FRAME_FORMAT_CSI_MIPI_YUV420_10,/* 10 bit per Y/U/V. Y odd
+						  * line; UYVY interleaved
+						  * even line
+						  */
+	IMGU_ABI_FRAME_FORMAT_YCGCO444_16, /* Internal format for ISP2.7,
+					    * 16 bits per plane YUV 444,
+					    * Y, U, V plane
+					    */
+	IMGU_ABI_FRAME_FORMAT_NUM
+};
+
+enum imgu_abi_bayer_order {
+	IMGU_ABI_BAYER_ORDER_GRBG,
+	IMGU_ABI_BAYER_ORDER_RGGB,
+	IMGU_ABI_BAYER_ORDER_BGGR,
+	IMGU_ABI_BAYER_ORDER_GBRG
+};
+
+enum imgu_abi_osys_format {
+	IMGU_ABI_OSYS_FORMAT_YUV420,
+	IMGU_ABI_OSYS_FORMAT_YV12,
+	IMGU_ABI_OSYS_FORMAT_NV12,
+	IMGU_ABI_OSYS_FORMAT_NV21,
+	IMGU_ABI_OSYS_FORMAT_YUV_LINE,
+	IMGU_ABI_OSYS_FORMAT_YUY2,	/* = IMGU_ABI_OSYS_FORMAT_YUYV */
+	IMGU_ABI_OSYS_FORMAT_NV16,
+	IMGU_ABI_OSYS_FORMAT_RGBA,
+	IMGU_ABI_OSYS_FORMAT_BGRA
+};
+
+enum imgu_abi_osys_tiling {
+	IMGU_ABI_OSYS_TILING_NONE,
+	IMGU_ABI_OSYS_TILING_Y,
+	IMGU_ABI_OSYS_TILING_YF,
+};
+
+enum imgu_abi_osys_procmode {
+	IMGU_ABI_OSYS_PROCMODE_BYPASS,
+	IMGU_ABI_OSYS_PROCMODE_UPSCALE,
+	IMGU_ABI_OSYS_PROCMODE_DOWNSCALE,
+};
+
+enum imgu_abi_queue_id {
+	IMGU_ABI_QUEUE_EVENT_ID = -1,
+	IMGU_ABI_QUEUE_A_ID = 0,
+	IMGU_ABI_QUEUE_B_ID,
+	IMGU_ABI_QUEUE_C_ID,
+	IMGU_ABI_QUEUE_D_ID,
+	IMGU_ABI_QUEUE_E_ID,
+	IMGU_ABI_QUEUE_F_ID,
+	IMGU_ABI_QUEUE_G_ID,
+	IMGU_ABI_QUEUE_H_ID,		/* input frame queue for skycam */
+	IMGU_ABI_QUEUE_NUM
+};
+
+enum imgu_abi_buffer_type {
+	IMGU_ABI_BUFFER_TYPE_INVALID = -1,
+	IMGU_ABI_BUFFER_TYPE_3A_STATISTICS = 0,
+	IMGU_ABI_BUFFER_TYPE_DIS_STATISTICS,
+	IMGU_ABI_BUFFER_TYPE_LACE_STATISTICS,
+	IMGU_ABI_BUFFER_TYPE_INPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_OUTPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_SEC_OUTPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_VF_OUTPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_SEC_VF_OUTPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_RAW_OUTPUT_FRAME,
+	IMGU_ABI_BUFFER_TYPE_CUSTOM_INPUT,
+	IMGU_ABI_BUFFER_TYPE_CUSTOM_OUTPUT,
+	IMGU_ABI_BUFFER_TYPE_METADATA,
+	IMGU_ABI_BUFFER_TYPE_PARAMETER_SET,
+	IMGU_ABI_BUFFER_TYPE_PER_FRAME_PARAMETER_SET,
+	IMGU_ABI_NUM_DYNAMIC_BUFFER_TYPE,
+	IMGU_ABI_NUM_BUFFER_TYPE
+};
+
+enum imgu_abi_raw_type {
+	IMGU_ABI_RAW_TYPE_BAYER,
+	IMGU_ABI_RAW_TYPE_IR_ON_GR,
+	IMGU_ABI_RAW_TYPE_IR_ON_GB
+};
+
+enum imgu_abi_memories {
+	IMGU_ABI_MEM_ISP_PMEM0 = 0,
+	IMGU_ABI_MEM_ISP_DMEM0,
+	IMGU_ABI_MEM_ISP_VMEM0,
+	IMGU_ABI_MEM_ISP_VAMEM0,
+	IMGU_ABI_MEM_ISP_VAMEM1,
+	IMGU_ABI_MEM_ISP_VAMEM2,
+	IMGU_ABI_MEM_ISP_HMEM0,
+	IMGU_ABI_MEM_SP0_DMEM0,
+	IMGU_ABI_MEM_SP1_DMEM0,
+	IMGU_ABI_MEM_DDR,
+	IMGU_ABI_NUM_MEMORIES
+};
+
+enum imgu_abi_param_class {
+	IMGU_ABI_PARAM_CLASS_PARAM,	/* Late binding parameters, like 3A */
+	IMGU_ABI_PARAM_CLASS_CONFIG,	/* Pipe config time parameters */
+	IMGU_ABI_PARAM_CLASS_STATE,	/* State parameters, eg. buffer index */
+	IMGU_ABI_PARAM_CLASS_NUM
+};
+
+enum imgu_abi_bin_input_src {
+	IMGU_ABI_BINARY_INPUT_SOURCE_SENSOR,
+	IMGU_ABI_BINARY_INPUT_SOURCE_MEMORY,
+	IMGU_ABI_BINARY_INPUT_SOURCE_VARIABLE,
+};
+
+enum imgu_abi_sp_swstate {
+	IMGU_ABI_SP_SWSTATE_TERMINATED,
+	IMGU_ABI_SP_SWSTATE_INITIALIZED,
+	IMGU_ABI_SP_SWSTATE_CONNECTED,
+	IMGU_ABI_SP_SWSTATE_RUNNING,
+};
+
+enum imgu_abi_bl_swstate {
+	IMGU_ABI_BL_SWSTATE_OK = 0x100,
+	IMGU_ABI_BL_SWSTATE_BUSY,
+	IMGU_ABI_BL_SWSTATE_ERR,
+};
+
+/* The type of pipe stage */
+enum imgu_abi_stage_type {
+	IMGU_ABI_STAGE_TYPE_SP,
+	IMGU_ABI_STAGE_TYPE_ISP,
+};
+
+#endif
-- 
2.11.0

