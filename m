Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44329 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1FNQhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 12:37:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMS00MVRGU33820@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:16 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMS00737GU0H4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:14 +0100 (BST)
Date: Tue, 14 Jun 2011 18:36:56 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/4 v9] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <1308069416-24723-5-git-send-email-k.debski@samsung.com>
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Multi Format Codec 5.1 is a hardware video coding acceleration
module found in the S5PV210 and Exynos4 Samsung SoCs. It is
capable of handling a range of video codecs and this driver
provides a V4L2 interface for video decoding and encoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Jeongtae Park <jtp.park@samsung.com>
---
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    5 +
 drivers/media/video/s5p-mfc/regs-mfc.h       |  385 +++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 1359 +++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |  143 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   28 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  472 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  393 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |   27 +
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   48 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    | 1106 ++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    | 2021 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_inst.c   |   52 +
 drivers/media/video/s5p-mfc/s5p_mfc_inst.h   |   19 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   94 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_mem.h    |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1588 ++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   88 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |  131 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.h     |   24 +
 drivers/media/video/s5p-mfc/s5p_mfc_reg.c    |   30 +
 drivers/media/video/s5p-mfc/s5p_mfc_reg.h    |  126 ++
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   86 ++
 28 files changed, 8416 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_mem.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bb53de7..b6d258b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1056,4 +1056,12 @@ config VIDEO_MEM2MEM_TESTDEV
 	  framework.
 
 
+config VIDEO_SAMSUNG_S5P_MFC
+	tristate "Samsung S5P MFC 5.1 Video Codec"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	help
+	    MFC 5.1 driver for V4L2.
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f0fecd6..780d8b2 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -168,6 +168,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/video/s5p-mfc/Makefile
new file mode 100644
index 0000000..06cc35b
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
+s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
+s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
+s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_inst.o s5p_mfc_cmd.o
+s5p-mfc-y += s5p_mfc_pm.o s5p_mfc_shm.o s5p_mfc_reg.o
diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/video/s5p-mfc/regs-mfc.h
new file mode 100644
index 0000000..b853fee
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc.h
@@ -0,0 +1,385 @@
+/*
+ * Register definition file for Samsung MFC V5.1 Interface (FIMV) driver
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef _REGS_FIMV_H
+#define _REGS_FIMV_H
+
+#define S5P_FIMV_REG_SIZE	(S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR)
+#define S5P_FIMV_REG_COUNT	((S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR) / 4)
+
+/* Number of bits that the buffer address should be shifted for particular
+ * MFC buffers.  */
+#define S5P_FIMV_MEM_OFFSET	11
+
+#define S5P_FIMV_START_ADDR		0x0000
+#define S5P_FIMV_END_ADDR		0xe008
+
+#define S5P_FIMV_SW_RESET		0x0000
+#define S5P_FIMV_RISC_HOST_INT		0x0008
+
+/* Command from HOST to RISC */
+#define S5P_FIMV_HOST2RISC_CMD		0x0030
+#define S5P_FIMV_HOST2RISC_ARG1		0x0034
+#define S5P_FIMV_HOST2RISC_ARG2		0x0038
+#define S5P_FIMV_HOST2RISC_ARG3		0x003c
+#define S5P_FIMV_HOST2RISC_ARG4		0x0040
+
+/* Command from RISC to HOST */
+#define S5P_FIMV_RISC2HOST_CMD		0x0044
+#define S5P_FIMV_RISC2HOST_CMD_MASK	0x1FFFF
+#define S5P_FIMV_RISC2HOST_ARG1		0x0048
+#define S5P_FIMV_RISC2HOST_ARG2		0x004c
+#define S5P_FIMV_RISC2HOST_ARG3		0x0050
+#define S5P_FIMV_RISC2HOST_ARG4		0x0054
+
+#define S5P_FIMV_FW_VERSION		0x0058
+#define S5P_FIMV_SYS_MEM_SZ		0x005c
+#define S5P_FIMV_FW_STATUS		0x0080
+
+/* Memory controller register */
+#define S5P_FIMV_MC_DRAMBASE_ADR_A	0x0508
+#define S5P_FIMV_MC_DRAMBASE_ADR_B	0x050c
+#define S5P_FIMV_MC_STATUS		0x0510
+
+/* Common register */
+#define S5P_FIMV_COMMON_BASE_A		0x0600
+#define S5P_FIMV_COMMON_BASE_B		0x0700
+
+/* Decoder */
+#define S5P_FIMV_DEC_CHROMA_ADR		(S5P_FIMV_COMMON_BASE_A)
+#define S5P_FIMV_DEC_LUMA_ADR		(S5P_FIMV_COMMON_BASE_B)
+
+/* H.264 decoding */
+#define S5P_FIMV_H264_VERT_NB_MV_ADR	(S5P_FIMV_COMMON_BASE_A + 0x8c)	/* vertical neighbor motion vector */
+#define S5P_FIMV_H264_NB_IP_ADR		(S5P_FIMV_COMMON_BASE_A + 0x90)	/* neighbor pixels for intra pred */
+#define S5P_FIMV_H264_MV_ADR		(S5P_FIMV_COMMON_BASE_B + 0x80)	/* H264 motion vector */
+
+/* MPEG4 decoding */
+#define S5P_FIMV_MPEG4_NB_DCAC_ADR	(S5P_FIMV_COMMON_BASE_A + 0x8c)	/* neighbor AC/DC coeff. */
+#define S5P_FIMV_MPEG4_UP_NB_MV_ADR	(S5P_FIMV_COMMON_BASE_A + 0x90)	/* upper neighbor motion vector */
+#define S5P_FIMV_MPEG4_SA_MV_ADR	(S5P_FIMV_COMMON_BASE_A + 0x94)	/* subseq. anchor motion vector */
+#define S5P_FIMV_MPEG4_OT_LINE_ADR	(S5P_FIMV_COMMON_BASE_A + 0x98)	/* overlap transform line */
+#define S5P_FIMV_MPEG4_SP_ADR		(S5P_FIMV_COMMON_BASE_A + 0xa8)	/* syntax parser */
+
+/* H.263 decoding */
+#define S5P_FIMV_H263_NB_DCAC_ADR	(S5P_FIMV_COMMON_BASE_A + 0x8c)
+#define S5P_FIMV_H263_UP_NB_MV_ADR	(S5P_FIMV_COMMON_BASE_A + 0x90)
+#define S5P_FIMV_H263_SA_MV_ADR		(S5P_FIMV_COMMON_BASE_A + 0x94)
+#define S5P_FIMV_H263_OT_LINE_ADR	(S5P_FIMV_COMMON_BASE_A + 0x98)
+
+/* VC-1 decoding */
+#define S5P_FIMV_VC1_NB_DCAC_ADR	(S5P_FIMV_COMMON_BASE_A + 0x8c)
+#define S5P_FIMV_VC1_UP_NB_MV_ADR	(S5P_FIMV_COMMON_BASE_A + 0x90)
+#define S5P_FIMV_VC1_SA_MV_ADR		(S5P_FIMV_COMMON_BASE_A + 0x94)
+#define S5P_FIMV_VC1_OT_LINE_ADR	(S5P_FIMV_COMMON_BASE_A + 0x98)
+#define S5P_FIMV_VC1_BITPLANE3_ADR	(S5P_FIMV_COMMON_BASE_A + 0x9c)	/* bitplane3 */
+#define S5P_FIMV_VC1_BITPLANE2_ADR	(S5P_FIMV_COMMON_BASE_A + 0xa0)	/* bitplane2 */
+#define S5P_FIMV_VC1_BITPLANE1_ADR	(S5P_FIMV_COMMON_BASE_A + 0xa4)	/* bitplane1 */
+
+/* Encoder */
+#define S5P_FIMV_ENC_REF0_LUMA_ADR	(S5P_FIMV_COMMON_BASE_A + 0x1c)	/* reconstructed luma */
+#define S5P_FIMV_ENC_REF1_LUMA_ADR	(S5P_FIMV_COMMON_BASE_A + 0x20)
+#define S5P_FIMV_ENC_REF0_CHROMA_ADR	(S5P_FIMV_COMMON_BASE_B)	/* reconstructed chroma */
+#define S5P_FIMV_ENC_REF1_CHROMA_ADR	(S5P_FIMV_COMMON_BASE_B + 0x04)
+#define S5P_FIMV_ENC_REF2_LUMA_ADR	(S5P_FIMV_COMMON_BASE_B + 0x10)
+#define S5P_FIMV_ENC_REF2_CHROMA_ADR	(S5P_FIMV_COMMON_BASE_B + 0x08)
+#define S5P_FIMV_ENC_REF3_LUMA_ADR	(S5P_FIMV_COMMON_BASE_B + 0x14)
+#define S5P_FIMV_ENC_REF3_CHROMA_ADR	(S5P_FIMV_COMMON_BASE_B + 0x0c)
+
+/* H.264 encoding */
+#define S5P_FIMV_H264_UP_MV_ADR		(S5P_FIMV_COMMON_BASE_A)	/* upper motion vector */
+#define S5P_FIMV_H264_NBOR_INFO_ADR	(S5P_FIMV_COMMON_BASE_A + 0x04)	/* entropy engine's neighbor info. */
+#define S5P_FIMV_H264_UP_INTRA_MD_ADR	(S5P_FIMV_COMMON_BASE_A + 0x08)	/* upper intra MD */
+#define S5P_FIMV_H264_COZERO_FLAG_ADR	(S5P_FIMV_COMMON_BASE_A + 0x10)	/* direct cozero flag */
+#define S5P_FIMV_H264_UP_INTRA_PRED_ADR	(S5P_FIMV_COMMON_BASE_B + 0x40)	/* upper intra PRED */
+
+/* H.263 encoding */
+#define S5P_FIMV_H263_UP_MV_ADR		(S5P_FIMV_COMMON_BASE_A)	/* upper motion vector */
+#define S5P_FIMV_H263_ACDC_COEF_ADR	(S5P_FIMV_COMMON_BASE_A + 0x04)	/* upper Q coeff. */
+
+/* MPEG4 encoding */
+#define S5P_FIMV_MPEG4_UP_MV_ADR	(S5P_FIMV_COMMON_BASE_A)	/* upper motion vector */
+#define S5P_FIMV_MPEG4_ACDC_COEF_ADR	(S5P_FIMV_COMMON_BASE_A + 0x04)	/* upper Q coeff. */
+#define S5P_FIMV_MPEG4_COZERO_FLAG_ADR	(S5P_FIMV_COMMON_BASE_A + 0x10)	/* direct cozero flag */
+
+#define S5P_FIMV_ENC_REF_B_LUMA_ADR     0x062c /* ref B Luma addr */
+#define S5P_FIMV_ENC_REF_B_CHROMA_ADR   0x0630 /* ref B Chroma addr */
+
+#define S5P_FIMV_ENC_CUR_LUMA_ADR	0x0718 /* current Luma addr */
+#define S5P_FIMV_ENC_CUR_CHROMA_ADR	0x071C /* current Chroma addr */
+
+/* Codec common register */
+#define S5P_FIMV_ENC_HSIZE_PX		0x0818 /* frame width at encoder */
+#define S5P_FIMV_ENC_VSIZE_PX		0x081c /* frame height at encoder */
+#define S5P_FIMV_ENC_PROFILE		0x0830 /* profile register */
+#define S5P_FIMV_ENC_PROFILE_H264_MAIN			0
+#define S5P_FIMV_ENC_PROFILE_H264_HIGH			1
+#define S5P_FIMV_ENC_PROFILE_H264_BASELINE		2
+#define S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE		0
+#define S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE	1
+#define S5P_FIMV_ENC_PIC_STRUCT		0x083c /* picture field/frame flag */
+#define S5P_FIMV_ENC_LF_CTRL		0x0848 /* loop filter control */
+#define S5P_FIMV_ENC_ALPHA_OFF		0x084c /* loop filter alpha offset */
+#define S5P_FIMV_ENC_BETA_OFF		0x0850 /* loop filter beta offset */
+#define S5P_FIMV_MR_BUSIF_CTRL		0x0854 /* hidden, bus interface ctrl */
+#define S5P_FIMV_ENC_PXL_CACHE_CTRL	0x0a00 /* pixel cache control */
+
+/* Channel & stream interface register */
+#define S5P_FIMV_SI_RTN_CHID		0x2000 /* Return CH instance ID register */
+#define S5P_FIMV_SI_CH0_INST_ID		0x2040 /* codec instance ID */
+#define S5P_FIMV_SI_CH1_INST_ID		0x2080 /* codec instance ID */
+/* Decoder */
+#define S5P_FIMV_SI_VRESOL		0x2004 /* vertical resolution of decoder */
+#define S5P_FIMV_SI_HRESOL		0x2008 /* horizontal resolution of decoder */
+#define S5P_FIMV_SI_BUF_NUMBER		0x200c /* number of frames in the decoded pic */
+#define S5P_FIMV_SI_DISPLAY_Y_ADR 	0x2010 /* luma address of displayed pic */
+#define S5P_FIMV_SI_DISPLAY_C_ADR 	0x2014 /* chroma address of displayed pic */
+#define S5P_FIMV_SI_CONSUMED_BYTES 	0x2018 /* Consumed number of bytes to decode
+								a frame */
+#define S5P_FIMV_SI_DISPLAY_STATUS 	0x201c /* status of decoded picture */
+#define S5P_FIMV_SI_FRAME_TYPE		0x2020 /* frame type such as skip/I/P/B */
+
+#define S5P_FIMV_SI_CH0_SB_ST_ADR	0x2044 /* start addr of stream buf */
+#define S5P_FIMV_SI_CH0_SB_FRM_SIZE	0x2048 /* size of stream buf */
+#define S5P_FIMV_SI_CH0_DESC_ADR	0x204c /* addr of descriptor buf */
+#define S5P_FIMV_SI_CH0_CPB_SIZE	0x2058 /* max size of coded pic. buf */
+#define S5P_FIMV_SI_CH0_DESC_SIZE	0x205c /* max size of descriptor buf */
+
+#define S5P_FIMV_SI_CH1_SB_ST_ADR	0x2084 /* start addr of stream buf */
+#define S5P_FIMV_SI_CH1_SB_FRM_SIZE	0x2088 /* size of stream buf */
+#define S5P_FIMV_SI_CH1_DESC_ADR	0x208c /* addr of descriptor buf */
+#define S5P_FIMV_SI_CH1_CPB_SIZE	0x2098 /* max size of coded pic. buf */
+#define S5P_FIMV_SI_CH1_DESC_SIZE	0x209c /* max size of descriptor buf */
+
+#define S5P_FIMV_CRC_LUMA0		0x2030 /* luma crc data per frame(top field)*/
+#define S5P_FIMV_CRC_CHROMA0		0x2034 /* chroma crc data per frame(top field)*/
+#define S5P_FIMV_CRC_LUMA1		0x2038 /* luma crc data per bottom field */
+#define S5P_FIMV_CRC_CHROMA1		0x203c /* chroma crc data per bottom field */
+
+/* Display status */
+#define S5P_FIMV_DEC_STATUS_DECODING_ONLY		0
+#define S5P_FIMV_DEC_STATUS_DECODING_DISPLAY		1
+#define S5P_FIMV_DEC_STATUS_DISPLAY_ONLY		2
+#define S5P_FIMV_DEC_STATUS_DECODING_EMPTY		3
+#define S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK	7
+#define S5P_FIMV_DEC_STATUS_PROGRESSIVE			(0<<3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE			(1<<3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE_MASK		(1<<3)
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_TWO		(0<<4)
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_FOUR		(1<<4)
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_MASK		(1<<4)
+#define S5P_FIMV_DEC_STATUS_CRC_GENERATED		(1<<5)
+#define S5P_FIMV_DEC_STATUS_CRC_NOT_GENERATED		(0<<5)
+#define S5P_FIMV_DEC_STATUS_CRC_MASK			(1<<5)
+
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_MASK		(3<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_INC		(1<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_DEC		(2<<4)
+
+/* Decode frame address */
+#define S5P_FIMV_DECODE_Y_ADR			0x2024
+#define S5P_FIMV_DECODE_C_ADR			0x2028
+
+/* Decoded frame tpe */
+#define S5P_FIMV_DECODE_FRAME_TYPE		0x2020
+#define S5P_FIMV_DECODE_FRAME_MASK		7
+
+#define S5P_FIMV_DECODE_FRAME_SKIPPED		0
+#define S5P_FIMV_DECODE_FRAME_I_FRAME		1
+#define S5P_FIMV_DECODE_FRAME_P_FRAME		2
+#define S5P_FIMV_DECODE_FRAME_B_FRAME		3
+#define S5P_FIMV_DECODE_FRAME_OTHER_FRAME	4
+
+/* Sizes of buffers required for decoding */
+#define S5P_FIMV_DEC_NB_IP_SIZE			(32 * 1024)
+#define S5P_FIMV_DEC_VERT_NB_MV_SIZE		(16 * 1024)
+#define S5P_FIMV_DEC_NB_DCAC_SIZE		(16 * 1024)
+#define S5P_FIMV_DEC_UPNB_MV_SIZE		(68 * 1024)
+#define S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE		(136 * 1024)
+#define S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE     (32 * 1024)
+#define S5P_FIMV_DEC_VC1_BITPLANE_SIZE		(2 * 1024)
+#define S5P_FIMV_DEC_STX_PARSER_SIZE		(68 * 1024)
+
+#define S5P_FIMV_DEC_BUF_ALIGN			(8 * 1024)
+#define S5P_FIMV_ENC_BUF_ALIGN			(8 * 1024)
+#define S5P_FIMV_NV12M_HALIGN			16
+#define S5P_FIMV_NV12M_LVALIGN			16
+#define S5P_FIMV_NV12M_CVALIGN			8
+#define S5P_FIMV_NV12MT_HALIGN			128
+#define S5P_FIMV_NV12MT_VALIGN			32
+#define S5P_FIMV_NV12M_SALIGN			2048
+#define S5P_FIMV_NV12MT_SALIGN			8192
+
+/* Sizes of buffers required for encoding */
+#define S5P_FIMV_ENC_UPMV_SIZE		0x10000
+#define S5P_FIMV_ENC_COLFLG_SIZE	0x10000
+#define S5P_FIMV_ENC_INTRAMD_SIZE	0x10000
+#define S5P_FIMV_ENC_INTRAPRED_SIZE	0x4000
+#define S5P_FIMV_ENC_NBORINFO_SIZE	0x10000
+#define S5P_FIMV_ENC_ACDCCOEF_SIZE	0x10000
+
+/* Encoder */
+#define S5P_FIMV_ENC_SI_STRM_SIZE	0x2004 /* stream size */
+#define S5P_FIMV_ENC_SI_PIC_CNT		0x2008 /* picture count */
+#define S5P_FIMV_ENC_SI_WRITE_PTR	0x200c /* write pointer */
+#define S5P_FIMV_ENC_SI_SLICE_TYPE	0x2010 /* slice type(I/P/B/IDR) */
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_NON_CODED	0
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_I		1
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_P		2
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_B		3
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_SKIPPED	4
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_OTHERS	5
+#define S5P_FIMV_ENCODED_Y_ADDR         0x2014 /* the addr of the encoded luma pic */
+#define S5P_FIMV_ENCODED_C_ADDR         0x2018 /* the addr of the encoded chroma pic */
+
+#define S5P_FIMV_ENC_SI_CH0_SB_ADR	0x2044 /* addr of stream buf */
+#define S5P_FIMV_ENC_SI_CH0_SB_SIZE	0x204c /* size of stream buf */
+#define S5P_FIMV_ENC_SI_CH0_CUR_Y_ADR	0x2050 /* current Luma addr */
+#define S5P_FIMV_ENC_SI_CH0_CUR_C_ADR	0x2054 /* current Chroma addr */
+#define S5P_FIMV_ENC_SI_CH0_FRAME_INS	0x2058 /* frame insertion */
+
+#define S5P_FIMV_ENC_SI_CH1_SB_ADR	0x2084 /* addr of stream buf */
+#define S5P_FIMV_ENC_SI_CH1_SB_SIZE	0x208c /* size of stream buf */
+#define S5P_FIMV_ENC_SI_CH1_CUR_Y_ADR	0x2090 /* current Luma addr */
+#define S5P_FIMV_ENC_SI_CH1_CUR_C_ADR	0x2094 /* current Chroma addr */
+#define S5P_FIMV_ENC_SI_CH1_FRAME_INS	0x2098 /* frame insertion */
+
+#define S5P_FIMV_ENC_PIC_TYPE_CTRL	0xc504 /* pic type level control */
+#define S5P_FIMV_ENC_B_RECON_WRITE_ON	0xc508 /* B frame recon write ctrl */
+#define S5P_FIMV_ENC_MSLICE_CTRL	0xc50c /* multi slice control */
+#define S5P_FIMV_ENC_MSLICE_MB		0xc510 /* MB number in the one slice */
+#define S5P_FIMV_ENC_MSLICE_BIT		0xc514 /* bit count for one slice */
+#define S5P_FIMV_ENC_CIR_CTRL		0xc518 /* number of intra refresh MB */
+#define S5P_FIMV_ENC_MAP_FOR_CUR	0xc51c /* linear or tiled mode */
+#define S5P_FIMV_ENC_PADDING_CTRL	0xc520 /* padding control */
+
+#define S5P_FIMV_ENC_RC_CONFIG		0xc5a0 /* RC config */
+#define S5P_FIMV_ENC_RC_BIT_RATE	0xc5a8 /* bit rate */
+#define S5P_FIMV_ENC_RC_QBOUND		0xc5ac /* max/min QP */
+#define S5P_FIMV_ENC_RC_RPARA		0xc5b0 /* rate control reaction coeff */
+#define S5P_FIMV_ENC_RC_MB_CTRL		0xc5b4 /* MB adaptive scaling */
+
+/* Encoder for H264 only */
+#define S5P_FIMV_ENC_H264_ENTROPY_MODE	0xd004 /* CAVLC or CABAC */
+#define S5P_FIMV_ENC_H264_ALPHA_OFF	0xd008 /* loop filter alpha offset */
+#define S5P_FIMV_ENC_H264_BETA_OFF	0xd00c /* loop filter beta offset */
+#define S5P_FIMV_ENC_H264_NUM_OF_REF	0xd010 /* number of reference for P/B */
+#define S5P_FIMV_ENC_H264_TRANS_FLAG	0xd034 /* 8x8 transform flag in PPS & high profile */
+
+#define S5P_FIMV_ENC_RC_FRAME_RATE	0xd0d0 /* frame rate */
+
+/* Encoder for MPEG4 only */
+#define S5P_FIMV_ENC_MPEG4_QUART_PXL	0xe008 /* qpel interpolation ctrl */
+
+/* Additional */
+#define S5P_FIMV_SI_CH0_DPB_CONF_CTRL   0x2068 /* DPB Config Control Register */
+#define S5P_FIMV_SLICE_INT_MASK		1
+#define S5P_FIMV_SLICE_INT_SHIFT	31
+#define S5P_FIMV_DDELAY_ENA_SHIFT	30
+#define S5P_FIMV_DDELAY_VAL_MASK	0xff
+#define S5P_FIMV_DDELAY_VAL_SHIFT	16
+#define S5P_FIMV_DPB_COUNT_MASK		0xffff
+#define S5P_FIMV_DPB_FLUSH_MASK		1
+#define S5P_FIMV_DPB_FLUSH_SHIFT	14
+
+
+#define S5P_FIMV_SI_CH0_RELEASE_BUF     0x2060 /* DPB release buffer register */
+#define S5P_FIMV_SI_CH0_HOST_WR_ADR	0x2064 /* address of shared memory */
+
+/* Codec numbers  */
+#define S5P_FIMV_CODEC_NONE		-1
+
+#define S5P_FIMV_CODEC_H264_DEC		0
+#define S5P_FIMV_CODEC_VC1_DEC		1
+#define S5P_FIMV_CODEC_MPEG4_DEC	2
+#define S5P_FIMV_CODEC_MPEG2_DEC	3
+#define S5P_FIMV_CODEC_H263_DEC		4
+#define S5P_FIMV_CODEC_VC1RCV_DEC	5
+
+#define S5P_FIMV_CODEC_H264_ENC		16
+#define S5P_FIMV_CODEC_MPEG4_ENC	17
+#define S5P_FIMV_CODEC_H263_ENC		18
+
+/* Channel Control Register */
+#define S5P_FIMV_CH_SEQ_HEADER		1
+#define S5P_FIMV_CH_FRAME_START		2
+#define S5P_FIMV_CH_LAST_FRAME		3
+#define S5P_FIMV_CH_INIT_BUFS		4
+#define S5P_FIMV_CH_FRAME_START_REALLOC	5
+#define S5P_FIMV_CH_MASK		7
+#define S5P_FIMV_CH_SHIFT		16
+
+
+/* Host to RISC command */
+#define S5P_FIMV_H2R_CMD_EMPTY		0
+#define S5P_FIMV_H2R_CMD_OPEN_INSTANCE	1
+#define S5P_FIMV_H2R_CMD_CLOSE_INSTANCE	2
+#define S5P_FIMV_H2R_CMD_SYS_INIT	3
+#define S5P_FIMV_H2R_CMD_FLUSH		4
+#define S5P_FIMV_H2R_CMD_SLEEP		5
+#define S5P_FIMV_H2R_CMD_WAKEUP		6
+
+#define S5P_FIMV_R2H_CMD_EMPTY			0
+#define S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET	1
+#define S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET	2
+#define S5P_FIMV_R2H_CMD_RSV_RET		3
+#define S5P_FIMV_R2H_CMD_SEQ_DONE_RET		4
+#define S5P_FIMV_R2H_CMD_FRAME_DONE_RET		5
+#define S5P_FIMV_R2H_CMD_SLICE_DONE_RET		6
+#define S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET	7
+#define S5P_FIMV_R2H_CMD_SYS_INIT_RET		8
+#define S5P_FIMV_R2H_CMD_FW_STATUS_RET		9
+#define S5P_FIMV_R2H_CMD_SLEEP_RET		10
+#define S5P_FIMV_R2H_CMD_WAKEUP_RET		11
+#define S5P_FIMV_R2H_CMD_FLUSH_RET		12
+#define S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET	15
+#define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
+#define S5P_FIMV_R2H_CMD_ERR_RET		32
+
+/* Error handling defines */
+#define S5P_FIMV_ERR_WARNINGS_START		145
+#define S5P_FIMV_ERR_DEC_MASK			0xFFFF
+#define S5P_FIMV_ERR_DEC_SHIFT			0
+#define S5P_FIMV_ERR_DSPL_MASK			0xFFFF0000
+#define S5P_FIMV_ERR_DSPL_SHIFT			16
+
+/* Shared memory registers' offsets */
+
+/* An offset of the start position in the stream when
+ * the start position is not aligned */
+#define S5P_FIMV_SHARED_CROP_INFO_H		0x0020
+#define S5P_FIMV_SHARED_CROP_LEFT_MASK		0xFFFF
+#define S5P_FIMV_SHARED_CROP_LEFT_SHIFT		0
+#define S5P_FIMV_SHARED_CROP_RIGHT_MASK		0xFFFF0000
+#define S5P_FIMV_SHARED_CROP_RIGHT_SHIFT	16
+#define S5P_FIMV_SHARED_CROP_INFO_V		0x0024
+#define S5P_FIMV_SHARED_CROP_TOP_MASK		0xFFFF
+#define S5P_FIMV_SHARED_CROP_TOP_SHIFT		0
+#define S5P_FIMV_SHARED_CROP_BOTTOM_MASK	0xFFFF0000
+#define S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT	16
+#define S5P_FIMV_SHARED_SET_FRAME_TAG		0x0004
+#define S5P_FIMV_SHARED_GET_FRAME_TAG_TOP	0x0008
+#define S5P_FIMV_SHARED_GET_FRAME_TAG_BOT	0x000C
+#define S5P_FIMV_SHARED_START_BYTE_NUM		0x0018
+#define S5P_FIMV_SHARED_RC_VOP_TIMING		0x0030
+#define S5P_FIMV_SHARED_LUMA_DPB_SIZE		0x0064
+#define S5P_FIMV_SHARED_CHROMA_DPB_SIZE		0x0068
+#define S5P_FIMV_SHARED_MV_SIZE			0x006C
+#define S5P_FIMV_SHARED_PIC_TIME_TOP		0x0010
+#define S5P_FIMV_SHARED_PIC_TIME_BOTTOM		0x0014
+#define S5P_FIMV_SHARED_EXT_ENC_CONTROL		0x0028
+#define S5P_FIMV_SHARED_P_B_FRAME_QP		0x0070
+#define S5P_FIMV_SHARED_ASPECT_RATIO_IDC	0x0074
+#define S5P_FIMV_SHARED_EXTENDED_SAR		0x0078
+#define S5P_FIMV_SHARED_H264_I_PERIOD		0x009C
+#define S5P_FIMV_SHARED_RC_CONTROL_CONFIG	0x00A0
+
+#endif /* _REGS_FIMV_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
new file mode 100644
index 0000000..0732e6c
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -0,0 +1,1359 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.1
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-core.h>
+
+#include <linux/delay.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_reg.h"
+#include "s5p_mfc_shm.h"
+#include "s5p_mfc_ctrl.h"
+#include "s5p_mfc_dec.h"
+#include "s5p_mfc_enc.h"
+#include "s5p_mfc_pm.h"
+
+#define S5P_MFC_NAME		"s5p-mfc"
+#define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
+#define S5P_MFC_ENC_NAME	"s5p-mfc-enc"
+
+int debug;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+
+/* Helper functions for interrupt processing */
+/* Remove from hw execution round robin */
+inline void clear_work_bit(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	spin_lock(&dev->condlock);
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock(&dev->condlock);
+}
+
+/* Wake up context wait_queue */
+static inline void wake_up_ctx(struct s5p_mfc_ctx *ctx, unsigned int reason,
+			       unsigned int err)
+{
+	ctx->int_cond = 1;
+	ctx->int_type = reason;
+	ctx->int_err = err;
+	wake_up(&ctx->queue);
+}
+
+/* Wake up device wait_queue */
+static inline void wake_up_dev(struct s5p_mfc_dev *dev, unsigned int reason,
+			       unsigned int err)
+{
+	dev->int_cond = 1;
+	dev->int_type = reason;
+	dev->int_err = err;
+	wake_up(&dev->queue);
+}
+
+void s5p_mfc_watchdog(unsigned long arg)
+{
+	struct s5p_mfc_dev *dev = (struct s5p_mfc_dev *)arg;
+
+	if (test_bit(0, &dev->hw_lock))
+		atomic_inc(&dev->watchdog_cnt);
+	if (atomic_read(&dev->watchdog_cnt) >= MFC_WATCHDOG_CNT) {
+		/* This means that hw is busy and no interrupts were
+		 * generated by hw for the Nth time of running this
+		 * watchdog timer. This usually means a serious hw
+		 * error. Now it is time to kill all instances and
+		 * reset the MFC. */
+		mfc_err("Time out during waiting for HW.\n");
+		queue_work(dev->watchdog_workqueue, &dev->watchdog_work);
+	}
+	dev->watchdog_timer.expires = jiffies +
+					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
+	add_timer(&dev->watchdog_timer);
+}
+
+static void s5p_mfc_watchdog_worker(struct work_struct *work)
+{
+	struct s5p_mfc_dev *dev;
+	struct s5p_mfc_ctx *ctx;
+	int i, ret;
+	int mutex_locked;
+	unsigned long flags;
+
+	dev = container_of(work, struct s5p_mfc_dev, watchdog_work);
+	mfc_err("Driver timeout error handling.\n");
+	/* Lock the mutex that protects open and release.
+	 * This is necessary as they may load and unload firmware. */
+	mutex_locked = mutex_trylock(&dev->mfc_mutex);
+	if (!mutex_locked)
+		mfc_err("This is not good. Some instance may be "
+							"closing/opening.\n");
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	s5p_mfc_clock_off();
+
+	for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
+		ctx = dev->ctx[i];
+		if (ctx) {
+			ctx->state = MFCINST_ERROR;
+			s5p_mfc_cleanup_queue(&ctx->dst_queue,
+				&ctx->vq_dst);
+			s5p_mfc_cleanup_queue(&ctx->src_queue,
+				&ctx->vq_src);
+			clear_work_bit(ctx);
+			wake_up_ctx(ctx, S5P_FIMV_R2H_CMD_ERR_RET, 0);
+		}
+	}
+	clear_bit(0, &dev->hw_lock);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	/* Double check if there is at least one instance running.
+	 * If no instance is in memory than no firmware should be present */
+	if (dev->num_inst > 0) {
+		ret = s5p_mfc_load_firmware(dev);
+		if (ret != 0) {
+			mfc_err("Failed to reload FW.\n");
+			if (mutex_locked)
+				mutex_unlock(&dev->mfc_mutex);
+			return;
+		}
+
+		s5p_mfc_clock_on();
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0) {
+			mfc_err("Failed to reinit FW.\n");
+			if (mutex_locked)
+				mutex_unlock(&dev->mfc_mutex);
+			return;
+		}
+	}
+	if (mutex_locked)
+		mutex_unlock(&dev->mfc_mutex);
+}
+
+static inline enum s5p_mfc_node_type s5p_mfc_get_node_type(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	if (!vdev) {
+		mfc_err("failed to get video_device");
+		return MFCNODE_INVALID;
+	}
+
+	mfc_debug(2, "video_device index: %d\n", vdev->index);
+	if (vdev->index == 0)
+		return MFCNODE_DECODER;
+	else if (vdev->index == 1)
+		return MFCNODE_ENCODER;
+	else
+		return MFCNODE_INVALID;
+}
+
+static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_buf *dst_buf;
+
+	ctx->state = MFCINST_FINISHED;
+	mfc_debug(2, "Decided to finish\n");
+	ctx->sequence++;
+	while (!list_empty(&ctx->dst_queue)) {
+		dst_buf = list_entry(ctx->dst_queue.next,
+				     struct s5p_mfc_buf, list);
+		mfc_debug(2, "Cleaning up buffer: %d\n",
+					  dst_buf->b->v4l2_buf.index);
+		vb2_set_plane_payload(dst_buf->b, 0, 0);
+		vb2_set_plane_payload(dst_buf->b, 1, 0);
+		list_del(&dst_buf->list);
+		ctx->dst_queue_cnt--;
+		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
+
+		if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
+			s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+		else
+			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
+
+		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
+		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+		mfc_debug(2, "Cleaned up buffer: %d\n",
+			  dst_buf->b->v4l2_buf.index);
+	}
+	mfc_debug(2, "After cleanup\n");
+}
+
+static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_buf  *dst_buf, *src_buf;
+	size_t dec_y_addr = MFC_GET_ADR(DEC_DECODE_Y);
+	unsigned int frame_type = MFC_GET_REG(DEC_DECODE_FRAME_TYPE);
+
+	/* Copy timestamp / timecode from decoded src to dst and set
+	   appropraite flags */
+	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		if (vb2_dma_contig_plane_paddr(dst_buf->b, 0) == dec_y_addr) {
+			memcpy(&dst_buf->b->v4l2_buf.timecode,
+				&src_buf->b->v4l2_buf.timecode,
+				sizeof(struct v4l2_timecode));
+			memcpy(&dst_buf->b->v4l2_buf.timestamp,
+				&src_buf->b->v4l2_buf.timestamp,
+				sizeof(struct timeval));
+			switch (frame_type) {
+				case S5P_FIMV_DECODE_FRAME_I_FRAME:
+					dst_buf->b->v4l2_buf.flags |=
+							V4L2_BUF_FLAG_KEYFRAME;
+					break;
+				case S5P_FIMV_DECODE_FRAME_P_FRAME:
+					dst_buf->b->v4l2_buf.flags |=
+							V4L2_BUF_FLAG_PFRAME;
+					break;
+				case S5P_FIMV_DECODE_FRAME_B_FRAME:
+					dst_buf->b->v4l2_buf.flags |=
+							V4L2_BUF_FLAG_BFRAME;
+					break;
+			}
+			break;
+		}
+	}
+}
+
+static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
+{
+	struct s5p_mfc_buf  *dst_buf;
+	size_t dspl_y_addr = MFC_GET_ADR(DEC_DISPLAY_Y);
+	unsigned int frame_type = MFC_GET_REG(DEC_DECODE_FRAME_TYPE);
+	unsigned int index;
+
+	/* If frame is same as previous then skip and do not dequeue */
+	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED) {
+		if (!ctx->after_packed_pb)
+			ctx->sequence++;
+		ctx->after_packed_pb = 0;
+		return;
+	}
+	ctx->sequence++;
+
+	/* The MFC returns address of the buffer, now we have to
+	 * check which videobuf does it correspond to */
+	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		mfc_debug(2, "Listing: %d\n", dst_buf->b->v4l2_buf.index);
+		/* Check if this is the buffer we're looking for */
+		mfc_debug(2, "0x%08zx, 0x%08x", vb2_dma_contig_plane_paddr(dst_buf->b, 0),
+			dspl_y_addr);
+		if (vb2_dma_contig_plane_paddr(dst_buf->b, 0) == dspl_y_addr) {
+			list_del(&dst_buf->list);
+			ctx->dst_queue_cnt--;
+			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
+			if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
+				s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+			else
+				dst_buf->b->v4l2_buf.field =
+							V4L2_FIELD_INTERLACED;
+			vb2_set_plane_payload(dst_buf->b, 0, ctx->luma_size);
+			vb2_set_plane_payload(dst_buf->b, 1, ctx->chroma_size);
+			clear_bit(dst_buf->b->v4l2_buf.index,
+							&ctx->dec_dst_flag);
+
+			vb2_buffer_done(dst_buf->b,
+				err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+
+			index = dst_buf->b->v4l2_buf.index;
+			break;
+		}
+	}
+}
+
+/* Handle frame decoding interrupt */
+static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
+					unsigned int reason, unsigned int err)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dst_frame_status;
+	struct s5p_mfc_buf *src_buf;
+	unsigned long flags;
+	unsigned int res_change;
+
+	unsigned int index;
+
+	dst_frame_status = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
+	res_change = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
+	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
+
+	mfc_debug(2, "get frame tag: %d, %d\n",
+		  s5p_mfc_read_shm(ctx, GET_FRAME_TAG_TOP),
+		  s5p_mfc_read_shm(ctx, GET_FRAME_TAG_BOT));
+
+	if (ctx->state == MFCINST_RES_CHANGE_INIT)
+		ctx->state = MFCINST_RES_CHANGE_FLUSH;
+
+	if (res_change) {
+		mfc_debug(2, "Resolution change set to %d\n", res_change);
+		ctx->state = MFCINST_RES_CHANGE_INIT;
+
+		s5p_mfc_clear_int_flags();
+		wake_up_ctx(ctx, reason, err);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+
+		s5p_mfc_clock_off();
+
+		s5p_mfc_try_run(dev);
+		return;
+	}
+	if (ctx->dpb_flush_flag)
+		ctx->dpb_flush_flag = 0;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	/* All frames remaining in the buffer have been extracted  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY) {
+		if (ctx->state == MFCINST_RES_CHANGE_FLUSH) {
+			mfc_debug(2, "Last frame received after resolution change.\n");
+			s5p_mfc_handle_frame_all_extracted(ctx);
+			ctx->state = MFCINST_RES_CHANGE_END;
+			goto leave_handle_frame;
+		} else {
+			s5p_mfc_handle_frame_all_extracted(ctx);
+		}
+	}
+
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY ||
+		dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_ONLY)
+		s5p_mfc_handle_frame_copy_time(ctx);
+
+	/* A frame has been decoded and is in the buffer  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DISPLAY_ONLY ||
+	    dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY) {
+		s5p_mfc_handle_frame_new(ctx, err);
+	} else {
+		mfc_debug(2, "No frame decode.\n");
+	}
+	/* Mark source buffer as complete */
+	if (dst_frame_status != S5P_FIMV_DEC_STATUS_DISPLAY_ONLY
+		&& !list_empty(&ctx->src_queue)) {
+		src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
+								list);
+		mfc_debug(2, "Packed PB test. Size:%d, prev offset: %ld, this run:"
+			" %d\n", src_buf->b->v4l2_planes[0].bytesused,
+			ctx->consumed_stream, s5p_mfc_get_consumed_stream());
+		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
+		if (ctx->codec_mode != S5P_FIMV_CODEC_H264_DEC &&
+			s5p_mfc_get_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
+					&& ctx->consumed_stream + STUFF_BYTE <
+					src_buf->b->v4l2_planes[0].bytesused) {
+			/* Run MFC again on the same buffer */
+			mfc_debug(2, "Running again the same buffer.\n");
+			ctx->after_packed_pb = 1;
+		} else {
+			index = src_buf->b->v4l2_buf.index;
+			mfc_debug(2, "MFC needs next buffer.\n");
+			ctx->consumed_stream = 0;
+			list_del(&src_buf->list);
+			ctx->src_queue_cnt--;
+			if (s5p_mfc_err_dec(err) > 0)
+				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_ERROR);
+			else
+				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+		}
+	}
+leave_handle_frame:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	mfc_debug(2, "Assesing whether this context should be run again.\n");
+	/* if (!s5p_mfc_ctx_ready(ctx)) { */
+	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
+				    || ctx->dst_queue_cnt < ctx->dpb_count) {
+		mfc_debug(2, "No need to run again.\n");
+		clear_work_bit(ctx);
+	}
+	mfc_debug(2, "After assesing whether this context should be run again.\n");
+	s5p_mfc_clear_int_flags();
+	wake_up_ctx(ctx, reason, err);
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		BUG();
+
+	s5p_mfc_clock_off();
+
+	s5p_mfc_try_run(dev);
+}
+
+/* Error handling for interrupt */
+static inline void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
+	unsigned int reason, unsigned int err)
+{
+	struct s5p_mfc_dev *dev;
+	unsigned long flags;
+
+	/* If no context is available then all necessary
+	 * processing has been done. */
+	if (ctx == 0)
+		return;
+
+	dev = ctx->dev;
+	mfc_err("Interrupt Error: %08x\n", err);
+	s5p_mfc_clear_int_flags();
+	wake_up_dev(dev, reason, err);
+
+	/* Error recovery is dependent on the state of context */
+	switch (ctx->state) {
+	case MFCINST_INIT:
+		/* This error had to happen while acquireing instance */
+	case MFCINST_GOT_INST:
+		/* This error had to happen while parsing the header */
+	case MFCINST_HEAD_PARSED:
+		/* This error had to happen while setting dst buffers */
+	case MFCINST_RETURN_INST:
+		/* This error had to happen while releasing instance */
+		clear_work_bit(ctx);
+		wake_up_ctx(ctx, reason, err);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+
+		s5p_mfc_clock_off();
+
+		ctx->state = MFCINST_ERROR;
+
+		break;
+	case MFCINST_FINISHING:
+	case MFCINST_FINISHED:
+	case MFCINST_RUNNING:
+		/* It is higly probable that an error occured
+		 * while decoding a frame */
+		clear_work_bit(ctx);
+		ctx->state = MFCINST_ERROR;
+		/* Mark all dst buffers as having an error */
+		spin_lock_irqsave(&dev->irqlock, flags);
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		/* Mark all src buffers as having an error */
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+
+		s5p_mfc_clock_off();
+
+		break;
+	default:
+		mfc_err("Encountered an error interrupt which had not been handled.\n");
+		break;
+	}
+	return;
+}
+
+/* Interrupt processing */
+static irqreturn_t s5p_mfc_irq(int irq, void *priv)
+{
+	struct s5p_mfc_dev *dev = priv;
+	struct s5p_mfc_buf *src_buf;
+	struct s5p_mfc_ctx *ctx;
+	unsigned int reason;
+	unsigned int err;
+	unsigned long flags;
+	unsigned int guard_width, guard_height;
+
+	mfc_debug_enter();
+	/* Reset the timeout watchdog */
+	atomic_set(&dev->watchdog_cnt, 0);
+	ctx = dev->ctx[dev->curr_ctx];
+	/* Get the reason of interrupt and the error code */
+	reason = s5p_mfc_get_int_reason();
+	err = s5p_mfc_get_int_err();
+	mfc_debug(1, "Int reason: %d (err: %08x)\n", reason, err);
+	switch (reason) {
+	case S5P_FIMV_R2H_CMD_ERR_RET:
+		/* An error has occured */
+		if (ctx->state == MFCINST_RUNNING &&
+			s5p_mfc_err_dec(err) >= S5P_FIMV_ERR_WARNINGS_START)
+			s5p_mfc_handle_frame(ctx, reason, err);
+		else
+			s5p_mfc_handle_error(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
+	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
+		if (ctx->c_ops->post_frame_start) {
+			if (ctx->c_ops->post_frame_start(ctx))
+				mfc_err("post_frame_start() failed\n");
+
+			s5p_mfc_clear_int_flags();
+			wake_up_ctx(ctx, reason, err);
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+
+			s5p_mfc_clock_off();
+
+			s5p_mfc_try_run(dev);
+		} else {
+			s5p_mfc_handle_frame(ctx, reason, err);
+		}
+		break;
+	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+		if (ctx->c_ops->post_seq_start) {
+			if (ctx->c_ops->post_seq_start(ctx))
+				mfc_err("post_seq_start() failed\n");
+		} else {
+			ctx->img_width = s5p_mfc_get_img_width();
+			ctx->img_height = s5p_mfc_get_img_height();
+
+			ctx->buf_width = ALIGN(ctx->img_width,
+							S5P_FIMV_NV12MT_HALIGN);
+			ctx->buf_height = ALIGN(ctx->img_height,
+							S5P_FIMV_NV12MT_VALIGN);
+			mfc_debug(2, "SEQ Done: Movie dimensions %dx%d, "
+				"buffer dimensions: %dx%d\n", ctx->img_width,
+					ctx->img_height, ctx->buf_width,
+							ctx->buf_height);
+
+			if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+
+				ctx->luma_size = ALIGN(ctx->buf_width *
+					ctx->buf_height, S5P_FIMV_DEC_BUF_ALIGN);
+				ctx->chroma_size = ALIGN(ctx->buf_width *
+						 ALIGN((ctx->img_height >> 1),
+						       S5P_FIMV_NV12MT_VALIGN),
+						       S5P_FIMV_DEC_BUF_ALIGN);
+				ctx->mv_size = ALIGN(ctx->buf_width *
+						ALIGN((ctx->buf_height >> 2),
+						S5P_FIMV_NV12MT_VALIGN),
+						S5P_FIMV_DEC_BUF_ALIGN);
+			} else {
+				guard_width = ALIGN(ctx->img_width + 24,
+						S5P_FIMV_NV12MT_HALIGN);
+				guard_height = ALIGN(ctx->img_height + 16,
+							S5P_FIMV_NV12MT_VALIGN);
+				ctx->luma_size = ALIGN(guard_width *
+					guard_height, S5P_FIMV_DEC_BUF_ALIGN);
+
+				guard_width = ALIGN(ctx->img_width + 16,
+							S5P_FIMV_NV12MT_HALIGN);
+				guard_height = ALIGN((ctx->img_height >> 1) + 4,
+							S5P_FIMV_NV12MT_VALIGN);
+				ctx->chroma_size = ALIGN(guard_width *
+					guard_height, S5P_FIMV_DEC_BUF_ALIGN);
+
+				ctx->mv_size = 0;
+			}
+
+			ctx->dpb_count = s5p_mfc_get_dpb_count();
+			if (ctx->img_width == 0 || ctx->img_width == 0)
+				ctx->state = MFCINST_ERROR;
+			else
+				ctx->state = MFCINST_HEAD_PARSED;
+		}
+
+		s5p_mfc_clear_int_flags();
+		clear_work_bit(ctx);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+
+		s5p_mfc_clock_off();
+
+		s5p_mfc_try_run(dev);
+		wake_up_ctx(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_get_inst_no();
+		ctx->state = MFCINST_GOT_INST;
+		clear_work_bit(ctx);
+		wake_up(&ctx->queue);
+		goto irq_cleanup_hw;
+		break;
+	case S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET:
+		clear_work_bit(ctx);
+		ctx->state = MFCINST_FREE;
+		wake_up(&ctx->queue);
+		goto irq_cleanup_hw;
+		break;
+	case S5P_FIMV_R2H_CMD_SYS_INIT_RET:
+	case S5P_FIMV_R2H_CMD_FW_STATUS_RET:
+	case S5P_FIMV_R2H_CMD_SLEEP_RET:
+	case S5P_FIMV_R2H_CMD_WAKEUP_RET:
+		if (ctx)
+			clear_work_bit(ctx);
+		s5p_mfc_clear_int_flags();
+		wake_up_dev(dev, reason, err);
+		clear_bit(0, &dev->hw_lock);
+		break;
+	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
+		s5p_mfc_clear_int_flags();
+		ctx->int_type = reason;
+		ctx->int_err = err;
+		ctx->int_cond = 1;
+		spin_lock(&dev->condlock);
+		clear_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock(&dev->condlock);
+		if (err == 0) {
+			ctx->state = MFCINST_RUNNING;
+			if (!ctx->dpb_flush_flag) {
+				mfc_debug(2, "INIT_BUFFERS with dpb_flush - leaving image in src queue.\n");
+				spin_lock_irqsave(&dev->irqlock, flags);
+				if (!list_empty(&ctx->src_queue)) {
+					src_buf = list_entry(ctx->src_queue.next,
+						     struct s5p_mfc_buf, list);
+					list_del(&src_buf->list);
+					ctx->src_queue_cnt--;
+					vb2_buffer_done(src_buf->b,
+							VB2_BUF_STATE_DONE);
+				}
+				spin_unlock_irqrestore(&dev->irqlock, flags);
+			} else {
+				ctx->dpb_flush_flag = 0;
+			}
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+
+			s5p_mfc_clock_off();
+
+			wake_up(&ctx->queue);
+			s5p_mfc_try_run(dev);
+		} else {
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+
+			s5p_mfc_clock_off();
+
+			wake_up(&ctx->queue);
+		}
+		break;
+	default:
+		mfc_debug(2, "Unknown int reason.\n");
+		s5p_mfc_clear_int_flags();
+	}
+	mfc_debug_leave();
+	return IRQ_HANDLED;
+irq_cleanup_hw:
+	s5p_mfc_clear_int_flags();
+	ctx->int_type = reason;
+	ctx->int_err = err;
+	ctx->int_cond = 1;
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		mfc_err("Failed to unlock hw.\n");
+
+	s5p_mfc_clock_off();
+
+	s5p_mfc_try_run(dev);
+	mfc_debug(2, "%s-- (via irq_cleanup_hw)\n", __func__);
+	return IRQ_HANDLED;
+}
+
+/* Open an MFC node */
+static int s5p_mfc_open(struct file *file)
+{
+	struct s5p_mfc_ctx *ctx = NULL;
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct vb2_queue *q;
+	unsigned long flags;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
+
+	/* Allocate memory for context */
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx) {
+		mfc_err("Not enough memory.\n");
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	ret = v4l2_fh_init(&ctx->fh, video_devdata(file));
+	if (ret) {
+		mfc_err("Failed to init v4l2_fh\n");
+		goto err_fh;
+	}
+
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->dev = dev;
+	INIT_LIST_HEAD(&ctx->src_queue);
+	INIT_LIST_HEAD(&ctx->dst_queue);
+	ctx->src_queue_cnt = 0;
+	ctx->dst_queue_cnt = 0;
+	/* Get context number */
+	ctx->num = 0;
+	while (dev->ctx[ctx->num]) {
+		ctx->num++;
+		if (ctx->num >= MFC_NUM_CONTEXTS) {
+			mfc_err("Too many open contexts.\n");
+			ret = -EBUSY;
+			goto err_no_ctx;
+		}
+	}
+	/* Mark context as idle */
+	spin_lock_irqsave(&dev->condlock, flags);
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	dev->ctx[ctx->num] = ctx;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		ctx->type = MFCINST_DECODER;
+		ctx->c_ops = get_dec_codec_ops();
+		/* Setup ctrl handler */
+		ret = s5p_mfc_dec_ctrls_setup(ctx);
+		if (ret) {
+			mfc_err("Failed to setup mfc controls\n");
+			goto err_ctrls_setup;
+		}
+
+
+	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+		ctx->type = MFCINST_ENCODER;
+		ctx->c_ops = get_enc_codec_ops();
+		/* only for encoder */
+		INIT_LIST_HEAD(&ctx->ref_queue);
+		ctx->ref_queue_cnt = 0;
+
+		/* Setup ctrl handler */
+		ret = s5p_mfc_enc_ctrls_setup(ctx);
+		if (ret) {
+			mfc_err("Failed to setup mfc controls\n");
+			goto err_ctrls_setup;
+		}
+	} else {
+		ret = -ENOENT;
+		goto err_bad_node;
+	}
+
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	ctx->inst_no = -1;
+	/* Load firmware if this is the first instance */
+	if (dev->num_inst == 1) {
+		dev->watchdog_timer.expires = jiffies +
+					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
+		add_timer(&dev->watchdog_timer);
+
+		mfc_debug(2, "power on\n");
+		ret = s5p_mfc_power_on();
+		if (ret < 0) {
+			mfc_err("power on failed\n");
+			goto err_pwr_enable;
+		}
+
+		s5p_mfc_clock_on();
+
+		/* Load the FW */
+		ret = s5p_mfc_alloc_firmware(dev);
+		if (ret != 0)
+			goto err_alloc_fw;
+		ret = s5p_mfc_load_firmware(dev);
+		if (ret != 0)
+			goto err_load_fw;
+
+		/* Init the FW */
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0)
+			goto err_init_hw;
+
+		s5p_mfc_clock_off();
+	}
+
+	/* Init videobuf2 queue for CAPTURE */
+	q = &ctx->vq_dst;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->drv_priv = &ctx->fh;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		q->io_modes = VB2_MMAP;
+		q->ops = get_dec_queue_ops();
+	} else {
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->ops = get_enc_queue_ops();
+	}
+
+	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
+		goto err_queue_init;
+	}
+
+	/* Init videobuf2 queue for OUTPUT */
+	q = &ctx->vq_src;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = &ctx->fh;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		q->io_modes = VB2_MMAP;
+		q->ops = get_dec_queue_ops();
+	} else {
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->ops = get_enc_queue_ops();
+	}
+
+	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(output)\n");
+		goto err_queue_init;
+	}
+
+	init_waitqueue_head(&ctx->queue);
+	mfc_debug(2, "%s-- (via irq_cleanup_hw)\n", __func__);
+	return ret;
+
+	/* Deinit when failure occured */
+err_queue_init:
+err_init_hw:
+err_load_fw:
+	s5p_mfc_release_firmware(dev);
+err_alloc_fw:
+	dev->ctx[ctx->num] = 0;
+	del_timer_sync(&dev->watchdog_timer);
+	s5p_mfc_clock_off();
+err_pwr_enable:
+	if (dev->num_inst == 1) {
+		if (s5p_mfc_power_off() < 0)
+			mfc_err("power off failed\n");
+		s5p_mfc_release_firmware(dev);
+	}
+err_ctrls_setup:
+	s5p_mfc_dec_ctrls_delete(ctx);
+err_bad_node:
+err_no_ctx:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+err_fh:
+	kfree(ctx);
+err_alloc:
+	dev->num_inst--;
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Release MFC context */
+static int s5p_mfc_release(struct file *file)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	mfc_debug_enter();
+
+	s5p_mfc_clock_on();
+	vb2_queue_release(&ctx->vq_src);
+	vb2_queue_release(&ctx->vq_dst);
+
+	/* Mark context as idle */
+	spin_lock_irqsave(&dev->condlock, flags);
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	/* If instance was initialised then
+	 * return instance and free reosurces */
+	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
+		mfc_debug(2, "Has to free instance.\n");
+		ctx->state = MFCINST_RETURN_INST;
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_try_run(dev);
+		/* Wait until instance is returned or timeout occured */
+		if (s5p_mfc_wait_for_done_ctx
+		    (ctx, S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
+			s5p_mfc_clock_off();
+			mfc_err("Err returning instance.\n");
+		}
+		mfc_debug(2, "After free instance.\n");
+		/* Free resources */
+		s5p_mfc_release_codec_buffers(ctx);
+		s5p_mfc_release_instance_buffer(ctx);
+		if (ctx->type == MFCINST_DECODER)
+			s5p_mfc_release_dec_desc_buffer(ctx);
+
+		ctx->inst_no = MFC_NO_INSTANCE_SET;
+	}
+	/* hardware locking scheme */
+	if (dev->curr_ctx == ctx->num)
+		clear_bit(0, &dev->hw_lock);
+
+	dev->num_inst--;
+
+	if (dev->num_inst == 0) {
+		mfc_debug(2, "Last instance - release firmware.\n");
+		/* reset <-> F/W release */
+		s5p_mfc_reset();
+		s5p_mfc_release_firmware(dev);
+		del_timer_sync(&dev->watchdog_timer);
+
+		mfc_debug(2, "power off\n");
+		if (s5p_mfc_power_off() < 0)
+			mfc_err("power off failed\n");
+	}
+
+	mfc_debug(2, "Shutting down clock.\n");
+	s5p_mfc_clock_off();
+	dev->ctx[ctx->num] = 0;
+	s5p_mfc_dec_ctrls_delete(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Poll */
+static unsigned int s5p_mfc_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct vb2_queue *src_q, *dst_q;
+	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
+	unsigned int rc = 0;
+	unsigned long flags;
+
+	src_q = &ctx->vq_src;
+	dst_q = &ctx->vq_dst;
+
+	/*
+	 * There has to be at least one buffer queued on each queued_list, which
+	 * means either in driver already or waiting for driver to claim it
+	 * and start processing.
+	 */
+	if ((!src_q->streaming || list_empty(&src_q->queued_list))
+		&& (!dst_q->streaming || list_empty(&dst_q->queued_list))) {
+		rc = POLLERR;
+		goto end;
+	}
+
+	mutex_unlock(&dev->mfc_mutex);
+
+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
+	mutex_lock(&dev->mfc_mutex);
+
+	spin_lock_irqsave(&src_q->done_lock, flags);
+	if (!list_empty(&src_q->done_list))
+		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
+								done_entry);
+	if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE
+				|| src_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLOUT | POLLWRNORM;
+	spin_unlock_irqrestore(&src_q->done_lock, flags);
+
+	spin_lock_irqsave(&dst_q->done_lock, flags);
+	if (!list_empty(&dst_q->done_list))
+		dst_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
+								done_entry);
+	if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE
+				|| dst_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLIN | POLLRDNORM;
+	spin_unlock_irqrestore(&dst_q->done_lock, flags);
+end:
+	return rc;
+}
+
+/* Mmap */
+static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
+	mfc_debug_enter();
+	if (offset < DST_QUEUE_OFF_BASE) {
+		mfc_debug(2, "mmaping source.\n");
+		ret = vb2_mmap(&ctx->vq_src, vma);
+	} else {		/* capture */
+		mfc_debug(2, "mmaping destination.\n");
+		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+		ret = vb2_mmap(&ctx->vq_dst, vma);
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+/* v4l2 ops */
+static const struct v4l2_file_operations s5p_mfc_fops = {
+	.owner = THIS_MODULE,
+	.open = s5p_mfc_open,
+	.release = s5p_mfc_release,
+	.poll = s5p_mfc_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = s5p_mfc_mmap,
+};
+
+/* videodec structure */
+static struct video_device s5p_mfc_dec_videodev = {
+	.name = S5P_MFC_DEC_NAME,
+	.fops = &s5p_mfc_fops,
+	.minor = -1,
+	.release = video_device_release,
+};
+
+static struct video_device s5p_mfc_enc_videodev = {
+	.name = S5P_MFC_ENC_NAME,
+	.fops = &s5p_mfc_fops,
+	.minor = -1,
+	.release = video_device_release,
+};
+
+static int match_child(struct device *dev, void *data)
+{
+	if (!dev_name(dev))
+		return 0;
+	return !strcmp(dev_name(dev), (char *)data);
+}
+
+
+/* MFC probe function */
+static int __devinit s5p_mfc_probe(struct platform_device *pdev)
+{
+	struct s5p_mfc_dev *dev;
+	struct video_device *vfd;
+	struct resource *res;
+	int ret = -ENOENT;
+	size_t size;
+	pr_debug("%s++\n", __func__);
+	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+
+	if (!dev) {
+		dev_err(&pdev->dev, "Not enough memory for MFC device.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&dev->irqlock);
+	spin_lock_init(&dev->condlock);
+	dev_dbg(&pdev->dev, "Initialised spin lock\n");
+	dev->plat_dev = pdev;
+	if (!dev->plat_dev) {
+		dev_err(&pdev->dev, "No platform data specified\n");
+		ret = -ENODEV;
+		goto err_dev;
+	}
+
+	dev_dbg(&pdev->dev, "Getting clocks\n");
+	ret = s5p_mfc_init_pm(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get mfc clock source\n");
+		goto err_clk;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource.\n");
+		ret = -ENOENT;
+		goto err_res;
+	}
+	size = (res->end - res->start) + 1;
+	dev->mfc_mem = request_mem_region(res->start, size, pdev->name);
+	if (dev->mfc_mem == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region.\n");
+		ret = -ENOENT;
+		goto err_mem_reg;
+	}
+	dev->regs_base = ioremap(dev->mfc_mem->start,
+			      dev->mfc_mem->end - dev->mfc_mem->start + 1);
+	if (dev->regs_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap address region.\n");
+		ret = -ENOENT;
+		goto err_ioremap;
+	}
+
+	s5p_mfc_init_reg(dev->regs_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get irq resource.\n");
+		ret = -ENOENT;
+		goto err_get_res;
+	}
+	dev->irq = res->start;
+	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev->name,
+									dev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
+		goto err_req_irq;
+	}
+
+	dev->mem_dev_l = device_find_child(&dev->plat_dev->dev, "s5p-mfc-l", match_child);
+	if (!dev->mem_dev_l) {
+        	mfc_err("Mem child (L) device get failed\n");
+	        ret = -ENODEV;
+		goto err_find_child;
+	}
+	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r", match_child);
+	if (!dev->mem_dev_r) {
+        	mfc_err("Mem child (R) device get failed\n");
+	        ret = -ENODEV;
+		goto err_find_child;
+	}
+
+	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
+	if (IS_ERR_OR_NULL(dev->alloc_ctx[0])) {
+		ret = PTR_ERR(dev->alloc_ctx[0]);
+		goto err_mem_init_ctx_0;
+	}
+	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
+	if (IS_ERR_OR_NULL(dev->alloc_ctx[1])) {
+		ret = PTR_ERR(dev->alloc_ctx[1]);
+		goto err_mem_init_ctx_1;
+	}
+
+	mutex_init(&dev->mfc_mutex);
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto err_v4l2_dev_reg;
+	init_waitqueue_head(&dev->queue);
+
+
+	/* decoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto err_dec_alloc;
+	}
+	*vfd = s5p_mfc_dec_videodev;
+
+	vfd->ioctl_ops = get_dec_v4l2_ioctl_ops();
+
+	vfd->lock = &dev->mfc_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_dec_videodev.name);
+
+	dev->vfd_dec = vfd;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto err_dec_reg;
+	}
+	v4l2_info(&dev->v4l2_dev, "decoder registered as /dev/video%d\n",
+								vfd->num);
+
+	video_set_drvdata(vfd, dev);
+
+	/* encoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto err_enc_alloc;
+	}
+	*vfd = s5p_mfc_enc_videodev;
+
+	vfd->ioctl_ops = get_enc_v4l2_ioctl_ops();
+
+	vfd->lock = &dev->mfc_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_enc_videodev.name);
+
+	dev->vfd_enc = vfd;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto err_enc_reg;
+	}
+	v4l2_info(&dev->v4l2_dev, "encoder registered as /dev/video%d\n",
+								vfd->num);
+
+	video_set_drvdata(vfd, dev);
+
+	platform_set_drvdata(pdev, dev);
+
+	dev->hw_lock = 0;
+	dev->watchdog_workqueue = create_singlethread_workqueue(S5P_MFC_NAME);
+	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
+	atomic_set(&dev->watchdog_cnt, 0);
+	init_timer(&dev->watchdog_timer);
+	dev->watchdog_timer.data = (unsigned long)dev;
+	dev->watchdog_timer.function = s5p_mfc_watchdog;
+
+	pr_debug("%s--\n", __func__);
+	return 0;
+
+/* Deinit MFC if probe had failed */
+err_enc_reg:
+	video_device_release(dev->vfd_enc);
+err_enc_alloc:
+	video_unregister_device(dev->vfd_dec);
+err_dec_reg:
+	video_device_release(dev->vfd_dec);
+err_dec_alloc:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_v4l2_dev_reg:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
+err_mem_init_ctx_1:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
+err_mem_init_ctx_0:
+err_find_child:
+	free_irq(dev->irq, dev);
+err_req_irq:
+err_get_res:
+	iounmap(dev->regs_base);
+	dev->regs_base = NULL;
+err_ioremap:
+	release_resource(dev->mfc_mem);
+	kfree(dev->mfc_mem);
+err_mem_reg:
+err_res:
+	s5p_mfc_final_pm(dev);
+err_clk:
+
+err_dev:
+	kfree(dev);
+	pr_debug("%s-- with error\n", __func__);
+	return ret;
+}
+
+/* Remove the driver */
+static int __devexit s5p_mfc_remove(struct platform_device *pdev)
+{
+	struct s5p_mfc_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s++\n", __func__);
+	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
+	del_timer_sync(&dev->watchdog_timer);
+	flush_workqueue(dev->watchdog_workqueue);
+	destroy_workqueue(dev->watchdog_workqueue);
+	video_unregister_device(dev->vfd_enc);
+	video_unregister_device(dev->vfd_dec);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
+	free_irq(dev->irq, dev);
+	iounmap(dev->regs_base);
+	if (dev->mfc_mem != NULL) {
+		release_resource(dev->mfc_mem);
+		kfree(dev->mfc_mem);
+		dev->mfc_mem = NULL;
+	}
+	s5p_mfc_final_pm(dev);
+	kfree(dev);
+	dev_dbg(&pdev->dev, "%s--\n", __func__);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int s5p_mfc_suspend(struct device *dev)
+{
+	struct s5p_mfc_dev *m_dev =
+				platform_get_drvdata(to_platform_device(dev));
+	int ret;
+
+	if (m_dev->num_inst == 0)
+		return 0;
+
+	ret = s5p_mfc_sleep(m_dev);
+
+	return ret;
+}
+
+static int s5p_mfc_resume(struct device *dev)
+{
+	struct s5p_mfc_dev *m_dev =
+				platform_get_drvdata(to_platform_device(dev));
+	int ret;
+	if (m_dev->num_inst == 0)
+		return 0;
+	ret = s5p_mfc_wakeup(m_dev);
+	return ret;
+}
+#ifdef CONFIG_PM_RUNTIME
+static int s5p_mfc_runtime_suspend(struct device *dev)
+{
+	struct s5p_mfc_dev *m_dev =
+				platform_get_drvdata(to_platform_device(dev));
+	atomic_set(&m_dev->pm.power, 0);
+	return 0;
+}
+
+static int s5p_mfc_runtime_idle(struct device *dev)
+{
+	return 0;
+}
+
+static int s5p_mfc_runtime_resume(struct device *dev)
+{
+	struct s5p_mfc_dev *m_dev =
+				platform_get_drvdata(to_platform_device(dev));
+	int pre_power;
+	if (!m_dev->alloc_ctx)
+		return 0;
+	pre_power = atomic_read(&m_dev->pm.power);
+	atomic_set(&m_dev->pm.power, 1);
+	return 0;
+}
+#endif
+
+#else
+#define s5p_mfc_suspend		NULL
+#define s5p_mfc_resume		NULL
+#ifdef CONFIG_PM_RUNTIME
+#define mfc_runtime_idle	NULL
+#define mfc_runtime_suspend	NULL
+#define mfc_runtime_resume	NULL
+#endif
+#endif
+
+/* Power management */
+static const struct dev_pm_ops s5p_mfc_pm_ops = {
+	.suspend		= s5p_mfc_suspend,
+	.resume			= s5p_mfc_resume,
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_idle		= s5p_mfc_runtime_idle,
+	.runtime_suspend	= s5p_mfc_runtime_suspend,
+	.runtime_resume		= s5p_mfc_runtime_resume,
+#endif
+};
+
+static struct platform_driver s5p_mfc_pdrv = {
+	.probe	= s5p_mfc_probe,
+	.remove	= __devexit_p(s5p_mfc_remove),
+	.driver	= {
+		.name	= S5P_MFC_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &s5p_mfc_pm_ops
+	},
+};
+
+static char banner[] __initdata =
+			"S5P MFC V4L2 Driver, (c) 2010 Samsung Electronics\n";
+
+static int __init s5p_mfc_init(void)
+{
+	pr_info("%s", banner);
+	if (platform_driver_register(&s5p_mfc_pdrv) != 0) {
+		pr_err("Platform device registration failed..\n");
+		return -1;
+	}
+	return 0;
+}
+
+static void __devexit s5p_mfc_exit(void)
+{
+	platform_driver_unregister(&s5p_mfc_pdrv);
+}
+
+module_init(s5p_mfc_init);
+module_exit(s5p_mfc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
new file mode 100644
index 0000000..e640ad9
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
@@ -0,0 +1,143 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_reg.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_mem.h"
+
+static int s5p_mfc_cmd_host2risc(int cmd, struct s5p_mfc_cmd_args *args)
+{
+	int cur_cmd;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+
+	/* wait until host to risc command register becomes 'H2R_CMD_EMPTY' */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while waiting for hardware.\n");
+			return -EIO;
+		}
+
+		cur_cmd = s5p_mfc_read_reg(S5P_FIMV_HOST2RISC_CMD);
+	} while (cur_cmd != S5P_FIMV_H2R_CMD_EMPTY);
+
+	s5p_mfc_write_reg(args->arg[0], S5P_FIMV_HOST2RISC_ARG1);
+	s5p_mfc_write_reg(args->arg[1], S5P_FIMV_HOST2RISC_ARG2);
+	s5p_mfc_write_reg(args->arg[2], S5P_FIMV_HOST2RISC_ARG3);
+	s5p_mfc_write_reg(args->arg[3], S5P_FIMV_HOST2RISC_ARG4);
+
+	/* Issue the command */
+	s5p_mfc_write_reg(cmd, S5P_FIMV_HOST2RISC_CMD);
+
+	return 0;
+}
+
+int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	mfc_debug_enter();
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	h2r_args.arg[0] = FIRMWARE_CODE_SIZE;
+
+	ret = s5p_mfc_cmd_host2risc(S5P_FIMV_H2R_CMD_SYS_INIT, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	mfc_debug_enter();
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+
+	ret = s5p_mfc_cmd_host2risc(S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	mfc_debug_enter();
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+
+	ret = s5p_mfc_cmd_host2risc(S5P_FIMV_H2R_CMD_WAKEUP, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Open a new instance and get its number */
+int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	mfc_debug_enter();
+
+	mfc_debug(2, "Requested codec mode: %d\n", ctx->codec_mode);
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	h2r_args.arg[0] = ctx->codec_mode;
+	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
+	h2r_args.arg[2] = ctx->context_ofs;
+	h2r_args.arg[3] = ctx->context_size;
+
+	ret = s5p_mfc_cmd_host2risc(S5P_FIMV_H2R_CMD_OPEN_INSTANCE, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Close instance */
+int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	if (ctx->state != MFCINST_FREE) {
+		memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+		h2r_args.arg[0] = ctx->inst_no;
+
+		ret = s5p_mfc_cmd_host2risc(S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
+					    &h2r_args);
+	} else {
+		ret = -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
new file mode 100644
index 0000000..730e4d1
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
@@ -0,0 +1,28 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_CMD_H
+#define __S5P_MFC_CMD_H __FILE__
+
+#define MAX_H2R_ARG		4
+
+struct s5p_mfc_cmd_args {
+	unsigned int	arg[MAX_H2R_ARG];
+};
+
+int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev);
+int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev);
+int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev);
+int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx);
+
+#endif /* __S5P_MFC_CMD_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
new file mode 100644
index 0000000..c972a09
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -0,0 +1,472 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.0
+ *
+ * This file contains definitions of enums and structs used by the codec
+ * driver.
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef S5P_MFC_COMMON_H_
+#define S5P_MFC_COMMON_H_
+
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+
+#include <media/videobuf2-core.h>
+
+#include "regs-mfc.h"
+
+#define MFC_MAX_EXTRA_DPB       5
+#define MFC_MAX_BUFFERS		32
+
+#define MFC_NUM_CONTEXTS	4
+/* Interrupt timeout */
+#define MFC_INT_TIMEOUT		2000
+/* Busy wait timeout */
+#define MFC_BW_TIMEOUT		500
+/* Watchdog interval */
+#define MFC_WATCHDOG_INTERVAL   1000
+/* After how many executions watchdog should assume lock up */
+#define MFC_WATCHDOG_CNT        10
+
+#define MFC_NO_INSTANCE_SET	-1
+
+#define MFC_ENC_CAP_PLANE_COUNT	1
+#define MFC_ENC_OUT_PLANE_COUNT	2
+
+#define STUFF_BYTE		4
+
+#define MFC_MAX_CTRLS		64
+
+enum s5p_mfc_fmt_type {
+	MFC_FMT_DEC = 0,
+	MFC_FMT_ENC = 1,
+	MFC_FMT_RAW = 2,
+};
+
+/**
+ * enum s5p_mfc_node_type - The type of an MFC device node.
+ */
+enum s5p_mfc_node_type {
+	MFCNODE_INVALID = -1,
+	MFCNODE_DECODER = 0,
+	MFCNODE_ENCODER = 1,
+};
+
+/**
+ * enum s5p_mfc_inst_type - The type of an MFC instance.
+ */
+enum s5p_mfc_inst_type {
+	MFCINST_INVALID = 0,
+	MFCINST_DECODER = 1,
+	MFCINST_ENCODER = 2,
+};
+
+/**
+ * enum s5p_mfc_inst_state - The state of an MFC instance.
+ */
+enum s5p_mfc_inst_state {
+	MFCINST_FREE = 0,
+	MFCINST_INIT = 100,
+	MFCINST_GOT_INST,
+	MFCINST_HEAD_PARSED,
+	MFCINST_BUFS_SET,
+	MFCINST_RUNNING,
+	MFCINST_FINISHING,
+	MFCINST_FINISHED,
+	MFCINST_RETURN_INST,
+	MFCINST_ERROR,
+	MFCINST_ABORT,
+	MFCINST_RES_CHANGE_INIT,
+	MFCINST_RES_CHANGE_FLUSH,
+	MFCINST_RES_CHANGE_END,
+};
+
+/**
+ * enum s5p_mfc_queue_state - The state of buffer queue.
+ */
+enum s5p_mfc_queue_state {
+	QUEUE_FREE = 0,
+	QUEUE_BUFS_REQUESTED,
+	QUEUE_BUFS_QUERIED,
+	QUEUE_BUFS_MMAPED,
+};
+
+enum s5p_mfc_decode_arg {
+	MFC_DEC_FRAME,
+	MFC_DEC_LAST_FRAME,
+	MFC_DEC_RES_CHANGE,
+};
+
+struct s5p_mfc_ctx;
+
+/**
+ * struct s5p_mfc_buf - MFC buffer
+ */
+struct s5p_mfc_buf {
+	struct list_head list;
+	struct vb2_buffer *b;
+	union {
+		struct {
+			size_t luma;
+			size_t chroma;
+		} raw;
+		size_t stream;
+	} cookie;
+	int used;
+};
+
+
+struct s5p_mfc_pm {
+	struct clk	*clock;
+	struct clk	*clock_gate;
+	atomic_t	power;
+#ifdef CONFIG_PM_RUNTIME
+	struct device	*device;
+#endif
+};
+
+/**
+ * struct s5p_mfc_dev - The struct containing driver internal parameters.
+ */
+struct s5p_mfc_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd_dec;
+	struct video_device	*vfd_enc;
+	struct platform_device	*plat_dev;
+
+	struct device		*mem_dev_l;
+	struct device		*mem_dev_r;
+
+	void __iomem		*regs_base;
+	int			irq;
+	struct resource		*mfc_mem;
+
+	struct v4l2_ctrl_handler dec_ctrl_handler;
+	struct v4l2_ctrl_handler enc_ctrl_handler;
+
+	struct s5p_mfc_pm	pm;
+
+	int num_inst;
+	spinlock_t irqlock;
+	spinlock_t condlock;
+
+	struct mutex mfc_mutex;
+
+	int int_cond;
+	int int_type;
+	unsigned int int_err;
+	wait_queue_head_t queue;
+
+	size_t port_a;
+	size_t port_b;
+
+	unsigned long hw_lock;
+
+	struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS];
+	int curr_ctx;
+	unsigned long ctx_work_bits;
+
+	atomic_t watchdog_cnt;
+	struct timer_list watchdog_timer;
+	struct workqueue_struct *watchdog_workqueue;
+	struct work_struct watchdog_work;
+
+	void *alloc_ctx[2];
+};
+
+struct s5p_mfc_h264_enc_params {
+	enum v4l2_mpeg_video_h264_profile profile;
+	enum v4l2_mpeg_video_h264_loop_filter_mode loop_filter_mode;
+	s8 loop_filter_alpha;
+	s8 loop_filter_beta;
+	enum v4l2_mpeg_video_h264_symbol_mode entropy_mode;
+	u8 max_ref_pic;
+	u8 num_ref_pic_4p;
+	int _8x8_transform;
+	int rc_mb;
+	int rc_mb_dark;
+	int rc_mb_smooth;
+	int rc_mb_static;
+	int rc_mb_activity;
+	int vui_sar;
+	u8 vui_sar_idc;
+	u16 vui_ext_sar_width;
+	u16 vui_ext_sar_height;
+	int open_gop;
+	u16 open_gop_size;
+	u8 rc_frame_qp;
+	u8 rc_min_qp;
+	u8 rc_max_qp;
+	u8 rc_p_frame_qp;
+	u8 rc_b_frame_qp;
+	enum v4l2_mpeg_video_h264_level level_v4l2;
+	int level;
+	u16 cpb_size;
+};
+
+struct s5p_mfc_mpeg4_enc_params {
+	/* MPEG4 Only */
+	enum v4l2_mpeg_video_mpeg4_profile profile;
+	int quarter_pixel;
+	u16 vop_time_res;
+	u16 vop_frm_delta;
+	u8 rc_frame_qp;
+	u8 rc_min_qp;
+	u8 rc_max_qp;
+	u8 rc_p_frame_qp;
+	u8 rc_b_frame_qp;
+	enum v4l2_mpeg_video_mpeg4_level level_v4l2;
+	int level;
+	/* Common for MPEG4, H263 */
+};
+
+struct s5p_mfc_enc_params {
+	u16 width;
+	u16 height;
+
+	u16 gop_size;
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	u16 slice_mb;
+	u32 slice_bit;
+	u16 intra_refresh_mb;
+	int pad;
+	u8 pad_luma;
+	u8 pad_cb;
+	u8 pad_cr;
+	int rc_frame;
+	u32 rc_bitrate;
+	u16 rc_reaction_coeff;
+	u16 vbv_size;
+
+	enum v4l2_mpeg_video_header_mode seq_hdr_mode;
+	enum v4l2_mpeg_mfc51_video_frame_skip_mode frame_skip_mode;
+	int fixed_target_bit;
+
+	u8 num_b_frame;
+	u32 rc_framerate_num;
+	u32 rc_framerate_denom;
+	int interlace;
+
+	union {
+		struct s5p_mfc_h264_enc_params h264;
+		struct s5p_mfc_mpeg4_enc_params mpeg4;
+	} codec;
+
+};
+
+enum s5p_mfc_ctrl_type {
+	MFC_CTRL_TYPE_SET	= 0x1,
+	MFC_CTRL_TYPE_GET	= 0x2,
+};
+
+enum s5p_mfc_ctrl_mode {
+	MFC_CTRL_MODE_NONE	= 0x0,
+	MFC_CTRL_MODE_SFR	= 0x1,
+	MFC_CTRL_MODE_SHM	= 0x2,
+	MFC_CTRL_MODE_CST	= 0x4,
+};
+
+struct s5p_mfc_ctrl_cfg {
+	enum s5p_mfc_ctrl_type type;
+	unsigned int id;
+	unsigned int is_volatile;	/* only for MFC_CTRL_TYPE_SET */
+	unsigned int mode;
+	unsigned int addr;
+	unsigned int mask;
+	unsigned int shft;
+	unsigned int flag_mode;		/* only for MFC_CTRL_TYPE_SET */
+	unsigned int flag_addr;		/* only for MFC_CTRL_TYPE_SET */
+	unsigned int flag_shft;		/* only for MFC_CTRL_TYPE_SET */
+};
+
+struct s5p_mfc_ctx_ctrl {
+	struct list_head list;
+	enum s5p_mfc_ctrl_type type;
+	unsigned int id;
+	int has_new;
+	int val;
+};
+
+struct s5p_mfc_buf_ctrl {
+	struct list_head list;
+	unsigned int id;
+	int has_new;
+	int val;
+	unsigned int old_val;		/* only for MFC_CTRL_TYPE_SET */
+	unsigned int is_volatile;	/* only for MFC_CTRL_TYPE_SET */
+	unsigned int updated;
+	unsigned int mode;
+	unsigned int addr;
+	unsigned int mask;
+	unsigned int shft;
+	unsigned int flag_mode;		/* only for MFC_CTRL_TYPE_SET */
+	unsigned int flag_addr;		/* only for MFC_CTRL_TYPE_SET */
+	unsigned int flag_shft;		/* only for MFC_CTRL_TYPE_SET */
+};
+
+struct s5p_mfc_codec_ops {
+	/* initialization routines */
+	int (*pre_seq_start) (struct s5p_mfc_ctx *ctx);
+	int (*post_seq_start) (struct s5p_mfc_ctx *ctx);
+	/* execution routines */
+	int (*pre_frame_start) (struct s5p_mfc_ctx *ctx);
+	int (*post_frame_start) (struct s5p_mfc_ctx *ctx);
+};
+
+#define call_cop(c, op, args...)				\
+	(((c)->c_ops->op) ?					\
+		((c)->c_ops->op(args)) : 0)
+
+/**
+ * struct s5p_mfc_ctx - This struct contains the instance context
+ */
+struct s5p_mfc_ctx {
+	struct s5p_mfc_dev *dev;
+	struct v4l2_fh fh;
+
+	int num;
+
+	int int_cond;
+	int int_type;
+	unsigned int int_err;
+	wait_queue_head_t queue;
+
+	struct s5p_mfc_fmt *src_fmt;
+	struct s5p_mfc_fmt *dst_fmt;
+
+	struct vb2_queue vq_src;
+	struct vb2_queue vq_dst;
+
+	struct list_head src_queue;
+	struct list_head dst_queue;
+
+	unsigned int src_queue_cnt;
+	unsigned int dst_queue_cnt;
+
+	enum s5p_mfc_inst_type type;
+	enum s5p_mfc_inst_state state;
+	int inst_no;
+
+	/* Decoder parameters */
+	int img_width;
+	int img_height;
+	int buf_width;
+	int buf_height;
+
+	int luma_size;
+	int chroma_size;
+	int mv_size;
+
+	unsigned long consumed_stream;
+
+	unsigned int dpb_flush_flag;
+
+	/* Buffers */
+	void *port_a_buf;
+	size_t port_a_phys;
+	size_t port_a_size;
+
+	void *port_b_buf;
+	size_t port_b_phys;
+	size_t port_b_size;
+
+	enum s5p_mfc_queue_state capture_state;
+	enum s5p_mfc_queue_state output_state;
+
+	struct s5p_mfc_buf src_bufs[MFC_MAX_BUFFERS];
+	int src_bufs_cnt;
+	struct s5p_mfc_buf dst_bufs[MFC_MAX_BUFFERS];
+	int dst_bufs_cnt;
+
+	unsigned int sequence;
+	unsigned long dec_dst_flag;
+	size_t dec_src_buf_size;
+
+	/* Control values */
+	int codec_mode;
+	__u32 pix_format;
+
+	int slice_interface;
+	int loop_filter_mpeg4;
+	int display_delay;
+	int display_delay_enable;
+	int after_packed_pb;
+
+	int dpb_count;
+	int total_dpb_count;
+
+	struct s5p_mfc_ctx_ctrl src_frame_tag;
+	struct s5p_mfc_ctx_ctrl dst_frmae_tag;
+
+	int disp_status;
+	int decode_status;
+	int disp_frame;		/* SHM */
+	int decode_frame;	/* SFR */
+
+	/* Buffers */
+	void *context_buf;
+	size_t context_phys;
+	size_t context_ofs;
+	size_t context_size;
+
+	void *desc_buf;
+	size_t desc_phys;
+
+
+	void *shm_alloc;
+	void *shm;
+	size_t shm_ofs;
+
+	struct s5p_mfc_enc_params enc_params;
+
+	size_t enc_dst_buf_size;
+
+	int frame_count;
+	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
+
+	struct list_head ref_queue;
+	unsigned int ref_queue_cnt;
+
+	struct s5p_mfc_codec_ops *c_ops;
+
+	struct v4l2_ctrl *ctrls[MFC_MAX_CTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+};
+
+struct s5p_mfc_fmt {
+	char *name;
+	u32 fourcc;
+	u32 codec_mode;
+	enum s5p_mfc_fmt_type type;
+	u32 num_planes;
+};
+
+struct mfc_control {
+        __u32			id;
+        enum v4l2_ctrl_type	type;
+        __u8			name[32];  /* Whatever */
+        __s32			minimum;   /* Note signedness */
+        __s32			maximum;
+        __s32			step;
+        __s32			default_value;
+        __u32			flags;
+        __u32			reserved[2];
+	__u8			is_volatile;
+};
+
+
+#define fh_to_ctx(__fh) container_of(__fh, struct s5p_mfc_ctx, fh)
+#define ctrl_to_ctx(__ctrl) container_of((__ctrl)->handler, struct s5p_mfc_ctx, ctrl_handler)
+
+#endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
new file mode 100644
index 0000000..003846e
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -0,0 +1,393 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+
+#include <linux/firmware.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_reg.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_pm.h"
+
+static void *s5p_mfc_bitproc_buf;
+static size_t s5p_mfc_bitproc_phys;
+static unsigned char *s5p_mfc_bitproc_virt;
+
+/* Allocate firmware */
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
+{
+	void *b_base;
+	size_t b_base_phys;
+
+	mfc_debug_enter();
+
+	if (s5p_mfc_bitproc_buf) {
+		mfc_err("Attempting to allocate firmware when it seems that it is already loaded.\n");
+		return -ENOMEM;
+	}
+
+	mfc_debug(2, "Allocating memory for firmware.\n");
+
+	s5p_mfc_bitproc_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_FW_ALLOC_CTX], FIRMWARE_CODE_SIZE);
+	if (IS_ERR(s5p_mfc_bitproc_buf)) {
+		s5p_mfc_bitproc_buf = 0;
+		printk(KERN_ERR "Allocating bitprocessor buffer failed\n");
+		return -ENOMEM;
+	}
+
+	s5p_mfc_bitproc_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_FW_ALLOC_CTX], s5p_mfc_bitproc_buf);
+
+	if (s5p_mfc_bitproc_phys & ((1 << MFC_FW_ALIGN_ORDER) - 1)) {
+		mfc_err("The base memory for bank 1 is not aligned to 128KB.\n");
+		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+
+	s5p_mfc_bitproc_virt = vb2_dma_contig_memops.vaddr(s5p_mfc_bitproc_buf);
+	mfc_debug(2, "Virtual address for FW: %08lx\n",
+				(long unsigned int)s5p_mfc_bitproc_virt);
+	if (!s5p_mfc_bitproc_virt) {
+		mfc_err("Bitprocessor memory remap failed\n");
+		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+
+	dev->port_a = s5p_mfc_bitproc_phys;
+
+	b_base = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX], 1 << MFC_BANK2_ALIGN_ORDER);
+	if (IS_ERR(b_base)) {
+		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		printk(KERN_ERR "Allocating Port B base failed\n");
+		return -ENOMEM;
+	}
+
+	b_base_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX], b_base);
+
+	vb2_dma_contig_memops.put(b_base);
+
+	if (b_base_phys & ((1 << MFC_FW_ALIGN_ORDER) - 1)) {
+		mfc_err("The base memory for bank 2 is not aligned to 8KB.\n");
+		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+
+	dev->port_b = b_base_phys;
+
+	mfc_debug(2, "Port A: %08x Port B: %08x (FW: %08x size: %08x)\n",
+			dev->port_a, dev->port_b,
+			s5p_mfc_bitproc_phys,
+			FIRMWARE_CODE_SIZE);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Load firmware to MFC */
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
+{
+	struct firmware *fw_blob;
+	int err;
+
+	/* Firmare has to be present as a separate file or compiled
+	 * into kernel. */
+	mfc_debug_enter();
+	mfc_debug(2, "Requesting fw\n");
+	err = request_firmware((const struct firmware **)&fw_blob,
+				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
+
+	if (err != 0) {
+		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug(2, "Ret of request_firmware: %d Size: %d\n", err,
+								fw_blob->size);
+
+	if (fw_blob->size > FIRMWARE_CODE_SIZE) {
+		mfc_err("MFC firmware is too big to be loaded.\n");
+		release_firmware(fw_blob);
+		return -ENOMEM;
+	}
+	if (s5p_mfc_bitproc_buf == 0 || s5p_mfc_bitproc_phys == 0) {
+		mfc_err("MFC firmware is not allocated or was not mapped correctly.\n");
+		release_firmware(fw_blob);
+		return -EINVAL;
+	}
+	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
+	wmb();
+	release_firmware(fw_blob);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Release firmware memory */
+int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
+{
+	/* Before calling this function one has to make sure
+	 * that MFC is no longer processing */
+	if (!s5p_mfc_bitproc_buf)
+		return -EINVAL;
+	vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+
+	s5p_mfc_bitproc_virt =  0;
+	s5p_mfc_bitproc_phys = 0;
+	s5p_mfc_bitproc_buf = 0;
+	return 0;
+}
+
+/* Reset the device */
+int s5p_mfc_reset(void)
+{
+	unsigned int mc_status;
+	unsigned long timeout;
+
+	mfc_debug_enter();
+
+	/* Stop procedure */
+	s5p_mfc_write_reg(0x3f6, S5P_FIMV_SW_RESET);	/*  reset RISC */
+	s5p_mfc_write_reg(0x3e2, S5P_FIMV_SW_RESET);	/*  All reset except for MC */
+	mdelay(10);
+
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+
+	/* Check MC status */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while resetting MFC.\n");
+			return -EIO;
+		}
+
+		mc_status = s5p_mfc_read_reg(S5P_FIMV_MC_STATUS);
+
+	} while (mc_status & 0x3);
+
+	s5p_mfc_write_reg(0x0, S5P_FIMV_SW_RESET);
+	s5p_mfc_write_reg(0x3fe, S5P_FIMV_SW_RESET);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
+{
+	/* channelA, port0 */
+	s5p_mfc_write_reg(dev->port_a, S5P_FIMV_MC_DRAMBASE_ADR_A);
+	/* channelB, port1 */
+	s5p_mfc_write_reg(dev->port_b, S5P_FIMV_MC_DRAMBASE_ADR_B);
+
+	mfc_debug(2, "Port A: %08x, Port B: %08x\n", dev->port_a, dev->port_b);
+}
+
+static inline void s5p_mfc_clear_cmds(void)
+{
+	s5p_mfc_write_reg(0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
+	s5p_mfc_write_reg(0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
+
+	s5p_mfc_write_reg(0, S5P_FIMV_RISC2HOST_CMD);
+	s5p_mfc_write_reg(0, S5P_FIMV_HOST2RISC_CMD);
+}
+
+/* Initialize hardware */
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
+{
+	int ret;
+
+	mfc_debug_enter();
+
+	if (!s5p_mfc_bitproc_buf)
+		return -EINVAL;
+
+	/* 0. MFC reset */
+	mfc_debug(2, "MFC reset...\n");
+
+	s5p_mfc_clock_on();
+
+	ret = s5p_mfc_reset();
+	if (ret) {
+		mfc_err("Failed to reset MFC - timeout.\n");
+		return ret;
+	}
+	mfc_debug(2, "Done MFC reset...\n");
+
+	/* 1. Set DRAM base Addr */
+	s5p_mfc_init_memctrl(dev);
+
+	/* 2. Initialize registers of channel I/F */
+	s5p_mfc_clear_cmds();
+
+	/* 3. Release reset signal to the RISC */
+	s5p_mfc_clean_dev_int_flags(dev);
+	s5p_mfc_write_reg(0x3ff, S5P_FIMV_SW_RESET);
+	mfc_debug(2, "Will now wait for completion of firmware transfer.\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_FW_STATUS_RET)) {
+		mfc_err("Failed to load firmware.\n");
+		s5p_mfc_reset();
+		s5p_mfc_clock_off();
+		return -EIO;
+	}
+
+	s5p_mfc_clean_dev_int_flags(dev);
+	/* 4. Initialize firmware */
+	ret = s5p_mfc_sys_init_cmd(dev);
+	if (ret) {
+		mfc_err("Failed to send command to MFC - timeout.\n");
+		s5p_mfc_reset();
+		s5p_mfc_clock_off();
+		return ret;
+	}
+	mfc_debug(2, "Ok, now will write a command to init the system\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SYS_INIT_RET)) {
+		mfc_err("Failed to load firmware\n");
+		s5p_mfc_reset();
+		s5p_mfc_clock_off();
+		return -EIO;
+	}
+
+	dev->int_cond = 0;
+	if (dev->int_err != 0 || dev->int_type !=
+						S5P_FIMV_R2H_CMD_SYS_INIT_RET) {
+		/* Failure. */
+		mfc_err("Failed to init firmware - error: %d"
+				" int: %d.\n",dev->int_err, dev->int_type);
+		s5p_mfc_reset();
+		s5p_mfc_clock_off();
+		return -EIO;
+	}
+
+	mfc_debug(2, "MFC F/W version : %02xyy, %02xmm, %02xdd\n",
+		 MFC_GET_REG(SYS_FW_VER_YEAR),
+		 MFC_GET_REG(SYS_FW_VER_MONTH),
+		 MFC_GET_REG(SYS_FW_VER_DATE));
+
+	s5p_mfc_clock_off();
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+
+int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
+{
+	int ret;
+
+	mfc_debug_enter();
+
+	s5p_mfc_clock_on();
+
+	s5p_mfc_clean_dev_int_flags(dev);
+	ret = s5p_mfc_sleep_cmd(dev);
+	if (ret) {
+		mfc_err("Failed to send command to MFC - timeout.\n");
+		return ret;
+	}
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SLEEP_RET)) {
+		mfc_err("Failed to sleep\n");
+		return -EIO;
+	}
+
+	s5p_mfc_clock_off();
+
+	dev->int_cond = 0;
+	if (dev->int_err != 0 || dev->int_type !=
+						S5P_FIMV_R2H_CMD_SLEEP_RET) {
+		/* Failure. */
+		mfc_err("Failed to sleep - error: %d"
+				" int: %d.\n",dev->int_err, dev->int_type);
+		return -EIO;
+	}
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
+{
+	int ret;
+
+	mfc_debug_enter();
+
+	/* 0. MFC reset */
+	mfc_debug(2, "MFC reset...\n");
+
+	s5p_mfc_clock_on();
+
+	ret = s5p_mfc_reset();
+	if (ret) {
+		mfc_err("Failed to reset MFC - timeout.\n");
+		return ret;
+	}
+	mfc_debug(2, "Done MFC reset...\n");
+
+	/* 1. Set DRAM base Addr */
+	s5p_mfc_init_memctrl(dev);
+
+	/* 2. Initialize registers of channel I/F */
+	s5p_mfc_clear_cmds();
+
+	s5p_mfc_clean_dev_int_flags(dev);
+	/* 3. Initialize firmware */
+	ret = s5p_mfc_wakeup_cmd(dev);
+	if (ret) {
+		mfc_err("Failed to send command to MFC - timeout.\n");
+		return ret;
+	}
+
+	/* 4. Release reset signal to the RISC */
+	s5p_mfc_write_reg(0x3ff, S5P_FIMV_SW_RESET);
+
+	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_WAKEUP_RET)) {
+		mfc_err("Failed to load firmware\n");
+		return -EIO;
+	}
+
+	s5p_mfc_clock_off();
+
+	dev->int_cond = 0;
+	if (dev->int_err != 0 || dev->int_type !=
+						S5P_FIMV_R2H_CMD_WAKEUP_RET) {
+		/* Failure. */
+		mfc_err("Failed to wakeup - error: %d"
+				" int: %d.\n",dev->int_err, dev->int_type);
+		return -EIO;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
new file mode 100644
index 0000000..68d73df
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
@@ -0,0 +1,27 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_CTRL_H
+#define __S5P_MFC_CTRL_H
+
+int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_sleep(struct s5p_mfc_dev *dev);
+int s5p_mfc_wakeup(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_reset(void);
+
+#endif /* __S5P_MFC_CTRL_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
new file mode 100644
index 0000000..b850528
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
@@ -0,0 +1,48 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_debug.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains debug macros
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_DEBUG_H_
+#define S5P_MFC_DEBUG_H_
+
+#define DEBUG
+
+#ifdef DEBUG
+extern int debug;
+
+#define mfc_debug(level, fmt, args...)				\
+	do {							\
+		if (debug >= level)				\
+			printk(KERN_DEBUG "%s:%d: " fmt,	\
+				__func__, __LINE__, ##args);	\
+	} while(0)
+#else
+#define mfc_debug(level, fmt, args...)
+#endif
+
+#define mfc_debug_enter() mfc_debug(5, "enter")
+#define mfc_debug_leave() mfc_debug(5, "leave")
+
+#define mfc_err(fmt, args...)				\
+	do {						\
+		printk(KERN_ERR "%s:%d: " fmt,		\
+		       __func__, __LINE__, ##args);	\
+	} while(0)
+
+#define mfc_info(fmt, args...)				\
+	do {						\
+		printk(KERN_INFO "%s:%d: " fmt,		\
+		       __func__, __LINE__, ##args);	\
+	} while(0)
+
+#endif /* S5P_MFC_DEBUG_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
new file mode 100644
index 0000000..a3d7378
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -0,0 +1,1106 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_reg.h"
+#include "s5p_mfc_shm.h"
+#include "s5p_mfc_dec.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_pm.h"
+
+static struct s5p_mfc_fmt formats[] = {
+	{
+		.name = "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc = V4L2_PIX_FMT_NV12MT,
+		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.type = MFC_FMT_RAW,
+		.num_planes = 2,
+	 },
+	{
+		.name = "4:2:0 2 Planes",
+		.fourcc = V4L2_PIX_FMT_NV12M,
+		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.type = MFC_FMT_RAW,
+		.num_planes = 2,
+	},
+	{
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H264,
+		.codec_mode = S5P_FIMV_CODEC_H264_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "H263 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H263,
+		.codec_mode = S5P_FIMV_CODEC_H263_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "MPEG1 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG1,
+		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "MPEG2 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG2,
+		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "MPEG4 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG4,
+		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "XviD Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_XVID,
+		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "VC1 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_G,
+		.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "VC1 RCV Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_L,
+		.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+/* Find selected format description */
+static struct s5p_mfc_fmt *find_format(struct v4l2_format *f, unsigned int t)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].fourcc == f->fmt.pix_mp.pixelformat &&
+		    formats[i].type == t)
+			return (struct s5p_mfc_fmt *)&formats[i];
+	}
+
+	return NULL;
+}
+
+static struct mfc_control controls[] = {
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 Display Delay",
+		.minimum = 0,
+		.maximum = 16383,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 Display Delay Enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Mpeg4 Loop Filter Enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Slice Interface Enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Minimum number of cap bufs",
+		.minimum = 1,
+		.maximum = 32,
+		.step = 1,
+		.default_value = 1,
+		.is_volatile = 1,
+	},
+};
+
+#define NUM_CTRLS ARRAY_SIZE(controls)
+
+/* Check whether a context should be run on hardware */
+static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
+{
+	mfc_debug(2, "src=%d, dst=%d, state=%d capstat=%d\n",
+		  ctx->src_queue_cnt, ctx->dst_queue_cnt,
+		  ctx->state, ctx->capture_state);
+
+	/* Context is to parse header */
+	if (ctx->src_queue_cnt >= 1 && ctx->state == MFCINST_GOT_INST)
+		return 1;
+	/* Context is to decode a frame */
+	if (ctx->src_queue_cnt >= 1 &&
+	    ctx->state == MFCINST_RUNNING &&
+	    ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	/* Context is to return last frame */
+	if (ctx->state == MFCINST_FINISHING &&
+	    ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	/* Context is to set buffers */
+	if (ctx->src_queue_cnt >= 1 &&
+	    ctx->state == MFCINST_HEAD_PARSED &&
+	    ctx->capture_state == QUEUE_BUFS_MMAPED)
+		return 1;
+	/* Resolution change */
+	if ((ctx->state == MFCINST_RES_CHANGE_INIT ||
+		ctx->state == MFCINST_RES_CHANGE_FLUSH) &&
+		ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	if (ctx->state == MFCINST_RES_CHANGE_END &&
+		ctx->src_queue_cnt >= 1)
+		return 1;
+
+	mfc_debug(2, "s5p_mfc_ctx_ready: ctx is not ready.\n");
+
+	return 0;
+}
+
+static struct s5p_mfc_codec_ops decoder_codec_ops = {
+	.pre_seq_start		= NULL,
+	.post_seq_start		= NULL,
+	.pre_frame_start	= NULL,
+	.post_frame_start	= NULL,
+};
+
+/* Query capabilities of the device */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+
+	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+						    | V4L2_CAP_STREAMING;
+	return 0;
+}
+
+/* Enumerate format */
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
+{
+	struct s5p_mfc_fmt *fmt;
+	int i, j = 0;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (mplane && formats[i].num_planes == 1)
+			continue;
+		else if (!mplane && formats[i].num_planes > 1)
+			continue;
+		if (out && formats[i].type != MFC_FMT_DEC)
+			continue;
+		else if (!out && formats[i].type != MFC_FMT_RAW)
+			continue;
+
+		if (j == f->index)
+			break;
+		++j;
+	}
+	if (i == ARRAY_SIZE(formats))
+		return -EINVAL;
+	fmt = &formats[i];
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, false);
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, false);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, true);
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, true);
+}
+
+/* Get format */
+static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_mp;
+
+	mfc_debug_enter();
+	pix_mp = &f->fmt.pix_mp;
+	mfc_debug(2, "f->type = %d ctx->state = %d\n", f->type, ctx->state);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    (ctx->state == MFCINST_GOT_INST || ctx->state ==
+						MFCINST_RES_CHANGE_END)) {
+		/* If the MFC is parsing the header,
+		 * so wait until it is finished */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+									0);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state >= MFCINST_HEAD_PARSED &&
+	    ctx->state < MFCINST_ABORT) {
+		/* This is run on CAPTURE (deocde output) */
+		/* Width and height are set to the dimensions
+		   of the movie, the buffer is bigger and
+		   further processing stages should crop to this
+		   rectangle. */
+		pix_mp->width = ctx->buf_width;
+		pix_mp->height = ctx->buf_height;
+		pix_mp->field = V4L2_FIELD_NONE;
+		pix_mp->num_planes = 2;
+		/* Set pixelformat to the format in which MFC
+		   outputs the decoded frame */
+		pix_mp->pixelformat = V4L2_PIX_FMT_NV12MT;
+		pix_mp->plane_fmt[0].bytesperline = ctx->buf_width;
+		pix_mp->plane_fmt[0].sizeimage = ctx->luma_size;
+		pix_mp->plane_fmt[1].bytesperline = ctx->buf_width;
+		pix_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* This is run on OUTPUT
+		   The buffer contains compressed image
+		   so width and height have no meaning */
+		pix_mp->width = 0;
+		pix_mp->height = 0;
+		pix_mp->field = V4L2_FIELD_NONE;
+		pix_mp->plane_fmt[0].bytesperline = ctx->dec_src_buf_size;
+		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size;
+		pix_mp->pixelformat = ctx->src_fmt->fourcc;
+		pix_mp->num_planes = ctx->src_fmt->num_planes;
+	} else {
+		mfc_err("Format could not be read\n");
+		mfc_debug(2, "%s-- with error\n", __func__);
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Try format */
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug(2, "Type is %d\n", f->type);
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Currently only decoding is supported.\n");
+		return -EINVAL;
+	}
+	fmt = find_format(f, MFC_FMT_DEC);
+	if (!fmt) {
+		mfc_err("Unsupported format.\n");
+		return -EINVAL;
+	}
+	if (fmt->type != MFC_FMT_DEC) {
+		mfc_err("\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Set format */
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	unsigned long flags;
+	int ret = 0;
+	struct s5p_mfc_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix_mp;
+
+	mfc_debug_enter();
+	ret = vidioc_try_fmt(file, priv, f);
+	pix_mp = &f->fmt.pix_mp;
+	if (ret)
+		return ret;
+	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+	fmt = find_format(f, MFC_FMT_DEC);
+	if (!fmt || fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
+		mfc_err("Unknown codec.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	if (fmt->type != MFC_FMT_DEC) {
+		mfc_err("Wrong format selected, you should choose "
+					"format for decoding.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	ctx->src_fmt = fmt;
+	ctx->codec_mode = fmt->codec_mode;
+	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
+	ctx->pix_format = pix_mp->pixelformat;
+	pix_mp->height = 0;
+	pix_mp->width = 0;
+	if (pix_mp->plane_fmt[0].sizeimage)
+		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
+	else
+		ctx->dec_src_buf_size = DEF_CPB_SIZE;
+	mfc_debug(2, "s_fmt w/h: %dx%d, ctx: %dx%d\n", pix_mp->width,
+		pix_mp->height, ctx->img_width, ctx->img_height);
+	mfc_debug(2, "sizeimage: %d\n", pix_mp->plane_fmt[0].sizeimage);
+	pix_mp->plane_fmt[0].bytesperline = 0;
+	ctx->state = MFCINST_INIT;
+	ctx->dst_bufs_cnt = 0;
+	ctx->src_bufs_cnt = 0;
+	ctx->capture_state = QUEUE_FREE;
+	ctx->output_state = QUEUE_FREE;
+	s5p_mfc_alloc_instance_buffer(ctx);
+	s5p_mfc_alloc_dec_temp_buffers(ctx);
+	spin_lock_irqsave(&dev->condlock, flags);
+	set_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_try_run(dev);
+	if (s5p_mfc_wait_for_done_ctx(ctx,
+			S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
+		/* Error or timeout */
+		mfc_err("Error getting instance from hardware.\n");
+		s5p_mfc_release_instance_buffer(ctx);
+		s5p_mfc_release_dec_desc_buffer(ctx);
+		ret = -EIO;
+		goto out;
+	}
+	mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
+out:
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Reqeust buffers */
+static int vidioc_reqbufs(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret = 0;
+	unsigned long flags;
+
+
+	mfc_debug_enter();
+	mfc_debug(2, "Memory type: %d\n", reqbufs->memory);
+	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only V4L2_MEMORY_MAP is supported.\n");
+		return -EINVAL;
+	}
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* Can only request buffers after an instance has been opened.*/
+		if (ctx->state == MFCINST_GOT_INST) {
+			ctx->src_bufs_cnt = 0;
+			if (reqbufs->count == 0) {
+				mfc_debug(2, "Freeing buffers.\n");
+				s5p_mfc_clock_on();
+				ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+				s5p_mfc_clock_off();
+				return ret;
+			}
+			/* Decoding */
+			if (ctx->output_state != QUEUE_FREE) {
+				mfc_err("Bufs have already been requested.\n");
+				return -EINVAL;
+			}
+			s5p_mfc_clock_on();
+			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+			s5p_mfc_clock_off();
+			if (ret) {
+				mfc_err("vb2_reqbufs on output failed.\n");
+				return ret;
+			}
+			mfc_debug(2, "vb2_reqbufs: %d\n", ret);
+			ctx->output_state = QUEUE_BUFS_REQUESTED;
+		}
+	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ctx->dst_bufs_cnt = 0;
+		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers.\n");
+			s5p_mfc_clock_on();
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_clock_off();
+			return ret;
+		}
+		if (ctx->capture_state != QUEUE_FREE) {
+			mfc_err("Bufs have already been requested.\n");
+			return -EINVAL;
+		}
+		ctx->capture_state = QUEUE_BUFS_REQUESTED;
+		s5p_mfc_clock_on();
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		s5p_mfc_clock_off();
+		if (ret) {
+			mfc_err("vb2_reqbufs on capture failed.\n");
+			return ret;
+		}
+		if (reqbufs->count < ctx->dpb_count) {
+			mfc_err("Not enough buffers allocated.\n");
+			reqbufs->count = 0;
+			s5p_mfc_clock_on();
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_clock_off();
+			return -ENOMEM;
+		}
+		ctx->total_dpb_count = reqbufs->count;
+		ret = s5p_mfc_alloc_codec_buffers(ctx);
+		if (ret) {
+			mfc_err("Failed to allocate decoding buffers.\n");
+			reqbufs->count = 0;
+			s5p_mfc_clock_on();
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_clock_off();
+			return -ENOMEM;
+		}
+		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
+			ctx->capture_state = QUEUE_BUFS_MMAPED;
+		} else {
+			mfc_err("Not all buffers passed to buf_init.\n");
+			reqbufs->count = 0;
+			s5p_mfc_clock_on();
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_release_codec_buffers(ctx);
+			s5p_mfc_clock_off();
+			return -ENOMEM;
+		}
+		if (s5p_mfc_ctx_ready(ctx)) {
+			spin_lock_irqsave(&dev->condlock, flags);
+			set_bit(ctx->num, &dev->ctx_work_bits);
+			spin_unlock_irqrestore(&dev->condlock, flags);
+		}
+
+		mfc_debug(1, "Before try run\n");
+		s5p_mfc_try_run(dev);
+		mfc_debug(1, "After try run\n");
+
+		s5p_mfc_wait_for_done_ctx(ctx,
+					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+
+		mfc_debug(1, "Afer wait\n");
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Query buffer */
+static int vidioc_querybuf(struct file *file, void *priv,
+						   struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+	int i;
+
+	mfc_debug_enter();
+	if (buf->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only mmaped buffers can be used.\n");
+		return -EINVAL;
+	}
+	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
+	if (ctx->state == MFCINST_GOT_INST &&
+			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_src, buf);
+	} else if (ctx->state == MFCINST_RUNNING &&
+			buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		for (i = 0; i < buf->length; i++)
+			buf->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
+	} else {
+		mfc_err("vidioc_querybuf called in an inappropriate state.\n");
+		ret = -EINVAL;
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Queue a buffer */
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	mfc_debug_enter();
+	mfc_debug(2, "Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
+	if (ctx->state == MFCINST_ERROR) {
+		mfc_err("Call on QBUF after unrecoverable error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return vb2_qbuf(&ctx->vq_src, buf);
+	else
+		return vb2_qbuf(&ctx->vq_dst, buf);
+	mfc_debug_leave();
+	return -EINVAL;
+}
+
+/* Dequeue a buffer */
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	mfc_debug_enter();
+	mfc_debug(2, "Addr: %p %p %p Type: %d\n", &ctx->vq_src, buf,
+						buf->m.planes, buf->type);
+	if (ctx->state == MFCINST_ERROR) {
+		mfc_err("Call on DQBUF after unrecoverable error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+	else
+		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Stream on */
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret = -EINVAL;
+
+	mfc_debug_enter();
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamon(&ctx->vq_src, type);
+	else
+		ret = vb2_streamon(&ctx->vq_dst, type);
+	mfc_debug(2, "ctx->src_queue_cnt = %d ctx->state = %d "
+		  "ctx->dst_queue_cnt = %d ctx->dpb_count = %d\n",
+		  ctx->src_queue_cnt, ctx->state, ctx->dst_queue_cnt,
+		  ctx->dpb_count);
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Stream off, which equals to a pause */
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	mfc_debug_enter();
+	ret = -EINVAL;
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamoff(&ctx->vq_src, type);
+	else
+		ret = vb2_streamoff(&ctx->vq_dst, type);
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Set controls - v4l2 control framework */
+static int s5p_mfc_dec_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY:
+		ctx->loop_filter_mpeg4 = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE:
+		ctx->display_delay_enable = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
+		ctx->display_delay = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE:
+		ctx->slice_interface = ctrl->val;
+		break;
+	default:
+		mfc_err("invalid control 0x%08x\n", ctrl->id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+		if (ctx->state >= MFCINST_HEAD_PARSED &&
+		    ctx->state < MFCINST_ABORT) {
+			ctrl->cur.val = ctx->dpb_count;
+			break;
+		} else if (ctx->state != MFCINST_INIT) {
+			v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
+			return -EINVAL;
+		}
+
+		/* Should wait for the header to be parsed */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+		if (ctx->state >= MFCINST_HEAD_PARSED &&
+		    ctx->state < MFCINST_ABORT) {
+			ctrl->cur.val = ctx->dpb_count;
+		} else {
+			v4l2_err(&dev->v4l2_dev,
+					 "Decoding not initialised.\n");
+			return -EINVAL;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+
+static const struct v4l2_ctrl_ops s5p_mfc_dec_ctrl_ops = {
+	.s_ctrl = s5p_mfc_dec_s_ctrl,
+	.g_volatile_ctrl = s5p_mfc_dec_g_v_ctrl,
+};
+
+/* Get cropping information */
+static int vidioc_g_crop(struct file *file, void *priv,
+		struct v4l2_crop *cr)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	u32 left, right, top, bottom;
+
+	mfc_debug_enter();
+	if (ctx->state != MFCINST_HEAD_PARSED &&
+	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
+					&& ctx->state != MFCINST_FINISHED) {
+			mfc_debug(2, "%s-- with error\n", __func__);
+			return -EINVAL;
+		}
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
+		left = s5p_mfc_read_shm(ctx, CROP_INFO_H);
+		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
+		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
+		top = s5p_mfc_read_shm(ctx, CROP_INFO_V);
+		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
+		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
+		cr->c.left = left;
+		cr->c.top = top;
+		cr->c.width = ctx->img_width - left - right;
+		cr->c.height = ctx->img_height - top - bottom;
+		mfc_debug(2, "Cropping info [h264]: l=%d t=%d "
+			"w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
+			cr->c.width, cr->c.height, right, bottom,
+			ctx->buf_width, ctx->buf_height);
+	} else {
+		cr->c.left = 0;
+		cr->c.top = 0;
+		cr->c.width = ctx->img_width;
+		cr->c.height = ctx->img_height;
+		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d "
+			"fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
+							ctx->buf_height);
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+/* v4l2_ioctl_ops */
+static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt,
+	.vidioc_reqbufs = vidioc_reqbufs,
+	.vidioc_querybuf = vidioc_querybuf,
+	.vidioc_qbuf = vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+	.vidioc_g_crop = vidioc_g_crop,
+};
+
+static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
+			       unsigned int *plane_count, unsigned long psize[],
+			       void *allocators[])
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+
+	mfc_debug_enter();
+
+	/* Video output for decoding (source)
+	 * this can be set after getting an instance */
+	if (ctx->state == MFCINST_GOT_INST &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_debug(2, "setting for VIDEO output\n");
+		/* A single plane is required for input */
+		*plane_count = 1;
+		if (*buf_count < 1)
+			*buf_count = 1;
+		if (*buf_count > MFC_MAX_BUFFERS)
+			*buf_count = MFC_MAX_BUFFERS;
+	/* Video capture for decoding (destination)
+	 * this can be set after the header was parsed */
+	} else if (ctx->state == MFCINST_HEAD_PARSED &&
+		   vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_debug(2, "setting for VIDEO capture\n");
+		/* Output plane count is 2 - one for Y and one for CbCr */
+		*plane_count = 2;
+		/* Setup buffer count */
+		if (*buf_count < ctx->dpb_count)
+			*buf_count = ctx->dpb_count;
+		if (*buf_count > ctx->dpb_count + MFC_MAX_EXTRA_DPB)
+			*buf_count = ctx->dpb_count + MFC_MAX_EXTRA_DPB;
+		if (*buf_count > MFC_MAX_BUFFERS)
+			*buf_count = MFC_MAX_BUFFERS;
+	} else {
+		mfc_err("State seems invalid. State = %d, vq->type = %d\n",
+							ctx->state, vq->type);
+		return -EINVAL;
+	}
+	mfc_debug(2, "%s, buffer count=%d, plane count=%d type=0x%x\n",
+				__func__, *buf_count, *plane_count, vq->type);
+
+	if (ctx->state == MFCINST_HEAD_PARSED &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		psize[0] = ctx->luma_size;
+		psize[1] = ctx->chroma_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX];
+		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX];
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		   ctx->state == MFCINST_GOT_INST) {
+		psize[0] = ctx->dec_src_buf_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX];
+	} else {
+		mfc_err("Currently only decoding is supported. Decoding not initalised.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug(2, "%s, plane=0, size=%lu\n", __func__, psize[0]);
+	mfc_debug(2, "%s, plane=1, size=%lu\n", __func__, psize[1]);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static void s5p_mfc_unlock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->mfc_mutex);
+}
+
+static void s5p_mfc_lock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mfc_mutex);
+}
+
+static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	unsigned int i;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
+			mfc_debug_leave();
+			return 0;
+		}
+		for (i = 0; i <= ctx->src_fmt->num_planes ; i++) {
+			if (IS_ERR_OR_NULL(ERR_PTR(vb2_dma_contig_plane_paddr(vb, i)))) {
+				mfc_err("Plane mem not allocated.\n");
+				return -EINVAL;
+			}
+		}
+		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
+			vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			mfc_err("Plane buffer (CAPTURE) is too small.\n");
+			return -EINVAL;
+		}
+		mfc_debug(2, "Size: 0=%lu 2=%lu\n", vb2_plane_size(vb, 0),
+							vb2_plane_size(vb, 1));
+		i = vb->v4l2_buf.index;
+		ctx->dst_bufs[i].b = vb;
+		ctx->dst_bufs[i].cookie.raw.luma = vb2_dma_contig_plane_paddr(vb, 0);
+		ctx->dst_bufs[i].cookie.raw.chroma = vb2_dma_contig_plane_paddr(vb, 1);
+		ctx->dst_bufs_cnt++;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (IS_ERR_OR_NULL(ERR_PTR(vb2_dma_contig_plane_paddr(vb, 0)))) {
+			mfc_err("Plane memory not allocated.\n");
+			return -EINVAL;
+		}
+		mfc_debug(2, "Plane size: %ld, ctx->dec_src_buf_size: %d\n",
+				vb2_plane_size(vb, 0), ctx->dec_src_buf_size);
+		if (vb2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
+			mfc_err("Plane buffer (OUTPUT) is too small.\n");
+			return -EINVAL;
+		}
+
+		i = vb->v4l2_buf.index;
+		ctx->src_bufs[i].b = vb;
+		ctx->src_bufs[i].cookie.stream = vb2_dma_contig_plane_paddr(vb, 0);
+		ctx->src_bufs_cnt++;
+	} else {
+		mfc_err("s5p_mfc_buf_init: unknown queue type.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_start_streaming(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+
+	if (ctx->state == MFCINST_FINISHING ||
+		ctx->state == MFCINST_FINISHED)
+		ctx->state = MFCINST_RUNNING;
+
+	/* If context is ready then dev = work->data;schedule it to run */
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run(dev);
+
+	return 0;
+}
+
+static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int aborted = 0;
+
+	if ((ctx->state == MFCINST_FINISHING ||
+		ctx->state ==  MFCINST_RUNNING) &&
+		dev->curr_ctx == ctx->num && dev->hw_lock) {
+		ctx->state = MFCINST_ABORT;
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+					  0);
+		aborted = 1;
+	}
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		INIT_LIST_HEAD(&ctx->dst_queue);
+		ctx->dst_queue_cnt = 0;
+		ctx->dpb_flush_flag = 1;
+		ctx->dec_dst_flag = 0;
+	}
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		INIT_LIST_HEAD(&ctx->src_queue);
+		ctx->src_queue_cnt = 0;
+	}
+
+	if (aborted)
+		ctx->state = MFCINST_RUNNING;
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	return 0;
+}
+
+
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *mfc_buf;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf->used = 0;
+		mfc_debug(2, "Src queue: %p\n", &ctx->src_queue);
+		mfc_debug(2, "Adding to src: %p (%08zx, %08x)\n", vb,
+				vb2_dma_contig_plane_paddr(vb, 0),
+				ctx->src_bufs[vb->v4l2_buf.index].cookie.stream);
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf->used = 0;
+		mfc_debug(2, "Dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug(2, "Adding to dst: %p (%08zx)\n", vb,
+						  vb2_dma_contig_plane_paddr(vb, 0));
+		mfc_debug(2, "ADDING Flag before: %lx (%d)\n",
+					ctx->dec_dst_flag, vb->v4l2_buf.index);
+		/* Mark destination as available for use by MFC */
+		spin_lock_irqsave(&dev->irqlock, flags);
+		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
+		mfc_debug(2, "ADDING Flag after: %lx\n", ctx->dec_dst_flag);
+		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
+		ctx->dst_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else {
+		mfc_err("Unsupported buffer type (%d)\n", vq->type);
+	}
+
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run(dev);
+
+	mfc_debug_leave();
+}
+
+static struct vb2_ops s5p_mfc_dec_qops = {
+	.queue_setup	= s5p_mfc_queue_setup,
+	.wait_prepare	= s5p_mfc_unlock,
+	.wait_finish	= s5p_mfc_lock,
+	.buf_init	= s5p_mfc_buf_init,
+	.start_streaming= s5p_mfc_start_streaming,
+	.stop_streaming = s5p_mfc_stop_streaming,
+	.buf_queue	= s5p_mfc_buf_queue,
+};
+
+struct s5p_mfc_codec_ops *get_dec_codec_ops(void)
+{
+	return &decoder_codec_ops;
+}
+
+struct vb2_ops *get_dec_queue_ops(void)
+{
+	return &s5p_mfc_dec_qops;
+}
+
+const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void)
+{
+	return &s5p_mfc_dec_ioctl_ops;
+}
+
+int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
+{
+	int i;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, NUM_CTRLS);
+	if (ctx->ctrl_handler.error) {
+		mfc_err("v4l2_ctrl_handler_init failed.\n");
+		return ctx->ctrl_handler.error;
+	}
+	for (i = 0; i < NUM_CTRLS; i++) {
+
+		ctx->ctrls[i] = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&s5p_mfc_dec_ctrl_ops,
+				controls[i].id, controls[i].minimum,
+				controls[i].maximum, controls[i].step,
+				controls[i].default_value);
+		if (ctx->ctrl_handler.error) {
+			mfc_err("Adding control (%d) failed\n", i);
+			return ctx->ctrl_handler.error;
+		}
+		if (controls[i].is_volatile && ctx->ctrls[i]) {
+			ctx->ctrls[i]->is_volatile = 1;
+			ctx->ctrls[i]->flags = V4L2_CTRL_FLAG_READ_ONLY;
+		}
+	}
+
+	return 0;
+}
+
+void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx)
+{
+	int i;
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	for (i = 0; i < NUM_CTRLS; i++)
+		ctx->ctrls[i] = NULL;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
new file mode 100644
index 0000000..915e99c
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
@@ -0,0 +1,23 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_DEC_H_
+#define __S5P_MFC_DEC_H_
+
+struct s5p_mfc_codec_ops *get_dec_codec_ops(void);
+struct vb2_ops *get_dec_queue_ops(void);
+const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
+struct s5p_mfc_fmt *get_dec_def_fmt(bool src);
+int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx);
+
+#endif /* __S5P_MFC_DEC_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
new file mode 100644
index 0000000..0da189f
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -0,0 +1,2021 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Jeongtae Park	<jtp.park@samsung.com>
+ * Kamil Debski		<k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_reg.h"
+#include "s5p_mfc_enc.h"
+#include "s5p_mfc_common.h"
+
+static struct s5p_mfc_fmt formats[] = {
+	{
+		.name = "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc = V4L2_PIX_FMT_NV12MT,
+		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.type = MFC_FMT_RAW,
+		.num_planes = 2,
+	},
+	{
+		.name = "4:2:0 2 Planes",
+		.fourcc = V4L2_PIX_FMT_NV12M,
+		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.type = MFC_FMT_RAW,
+		.num_planes = 2,
+	},
+	{
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H264,
+		.codec_mode = S5P_FIMV_CODEC_H264_ENC,
+		.type = MFC_FMT_ENC,
+		.num_planes = 1,
+	},
+	{
+		.name = "MPEG4 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG4,
+		.codec_mode = S5P_FIMV_CODEC_MPEG4_ENC,
+		.type = MFC_FMT_ENC,
+		.num_planes = 1,
+	},
+	{
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H263,
+		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
+		.type = MFC_FMT_ENC,
+		.num_planes = 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct s5p_mfc_fmt *find_format(struct v4l2_format *f, unsigned int t)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].fourcc == f->fmt.pix_mp.pixelformat &&
+		    formats[i].type == t)
+			return (struct s5p_mfc_fmt *)&formats[i];
+	}
+
+	return NULL;
+}
+
+static struct v4l2_queryctrl controls[] = {
+	{
+		.id = V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The period of intra frame",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "The slice partitioning method",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of MB in a slice",
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The maximum bits per slices",
+		.minimum = 1900,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 1900,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of intra refresh MBs",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_PADDING,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Padding control enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Padding color YUV value",
+		.minimum = 0,
+		.maximum = (1 << 25) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Frame level rate control enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_BITRATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Target bit rate rate-control",
+		.minimum = 1,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Rate control reaction coeff.",
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "Force frame type",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VBV_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "VBV buffer size",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 CPB buffer size",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "Sequence header mode",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "Frame skip enable",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Fixed target bit enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_B_FRAMES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of B frames",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "H264 profile",
+		.minimum = 0,
+		.maximum = 11,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "H264 level",
+		.minimum = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
+		.maximum = V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "MPEG4 level",
+		.minimum = 0,
+		.maximum = 7,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "H264 loop filter mode",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 loop filter alpha offset",
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 loop filter beta offset",
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "H264 entorpy mode",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of ref. picture of P",
+		.minimum = 1,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 8x8 transform enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 MB level rate control",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 I-Frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 Minimum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 Maximum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 P frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 B frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H263 I-Frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H263_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H263 Minimum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H263_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H263 Maximum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H263 P frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H263 B frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 I-Frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 Minimum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 Maximum QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 P frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 B frame QP value",
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 dark region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 smooth region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 static region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 MB activity adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Aspect ratio VUI enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "VUI aspect ratio IDC",
+		.minimum = 0,
+		.maximum = 17,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Horizontal size of SAR",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Vertical size of SAR",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_GOP_CLOSURE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Closed GOP enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 I period",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "MPEG4 profile",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_QPEL,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Quarter pixel search enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 vop time resolution",
+		.minimum = 0,
+		.maximum = (1 << 15) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "MPEG4 frame delta",
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+};
+
+#define NUM_CTRLS ARRAY_SIZE(controls)
+
+static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
+{
+	mfc_debug(2, "src=%d, dst=%d, state=%d\n",
+		  ctx->src_queue_cnt, ctx->dst_queue_cnt, ctx->state);
+
+	/* context is ready to make header */
+	if (ctx->state == MFCINST_GOT_INST && ctx->dst_queue_cnt >= 1)
+		return 1;
+	/* context is ready to encode a frame */
+	if (ctx->state == MFCINST_RUNNING &&
+		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
+		return 1;
+	/* context is ready to encode remain frames */
+	if (ctx->state == MFCINST_FINISHING &&
+		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
+		return 1;
+
+	mfc_debug(2, "ctx is not ready.\n");
+
+	return 0;
+}
+
+static void cleanup_ref_queue(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_buf *mb_entry;
+	unsigned long mb_y_addr, mb_c_addr;
+
+	/* move buffers in ref queue to src queue */
+	while (!list_empty(&ctx->ref_queue)) {
+		mb_entry = list_entry((&ctx->ref_queue)->next, struct s5p_mfc_buf, list);
+
+		mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
+		mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
+
+		mfc_debug(2, "enc ref y addr: 0x%08lx", mb_y_addr);
+		mfc_debug(2, "enc ref c addr: 0x%08lx", mb_c_addr);
+
+		list_del(&mb_entry->list);
+		ctx->ref_queue_cnt--;
+
+		list_add_tail(&mb_entry->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
+	}
+
+	mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
+		  ctx->src_queue_cnt, ctx->ref_queue_cnt);
+
+	INIT_LIST_HEAD(&ctx->ref_queue);
+	ctx->ref_queue_cnt = 0;
+}
+
+static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long dst_addr;
+	unsigned int dst_size;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	return 0;
+}
+
+static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long flags;
+
+	mfc_debug(2, "seq header size: %d", s5p_mfc_get_enc_strm_size());
+
+	if (p->seq_hdr_mode == V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) {
+		spin_lock_irqsave(&dev->irqlock, flags);
+
+		dst_mb = list_entry(ctx->dst_queue.next,
+				struct s5p_mfc_buf, list);
+		list_del(&dst_mb->list);
+		ctx->dst_queue_cnt--;
+
+		vb2_set_plane_payload(dst_mb->b, 0, s5p_mfc_get_enc_strm_size());
+		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	}
+
+	ctx->state = MFCINST_RUNNING;
+
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run(dev);
+
+	return 0;
+}
+
+static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long flags;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_y_addr = vb2_dma_contig_plane_paddr(src_mb->b, 0);
+	src_c_addr = vb2_dma_contig_plane_paddr(src_mb->b, 1);
+	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mfc_debug(2, "enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug(2, "enc src c addr: 0x%08lx", src_c_addr);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mfc_debug(2, "enc dst addr: 0x%08lx", dst_addr);
+
+	return 0;
+}
+
+static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *mb_entry;
+	unsigned long enc_y_addr, enc_c_addr;
+	unsigned long mb_y_addr, mb_c_addr;
+	int slice_type;
+	unsigned int strm_size;
+	unsigned long flags;
+
+	slice_type = s5p_mfc_get_enc_slice_type();
+	strm_size = s5p_mfc_get_enc_strm_size();
+
+	mfc_debug(2, "encoded slice type: %d", slice_type);
+	mfc_debug(2, "encoded stream size: %d", strm_size);
+	mfc_debug(2, "display order: %d",
+		  s5p_mfc_read_reg(S5P_FIMV_ENC_SI_PIC_CNT));
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (slice_type >= 0) {
+		s5p_mfc_get_enc_frame_buffer(ctx, &enc_y_addr, &enc_c_addr);
+
+		mfc_debug(2, "encoded y addr: 0x%08lx", enc_y_addr);
+		mfc_debug(2, "encoded c addr: 0x%08lx", enc_c_addr);
+
+		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
+			mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
+			mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
+
+			mfc_debug(2, "enc src y addr: 0x%08lx", mb_y_addr);
+			mfc_debug(2, "enc src c addr: 0x%08lx", mb_c_addr);
+
+			if ((enc_y_addr == mb_y_addr) && (enc_c_addr == mb_c_addr)) {
+				list_del(&mb_entry->list);
+				ctx->src_queue_cnt--;
+
+				vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+				break;
+			}
+		}
+
+		list_for_each_entry(mb_entry, &ctx->ref_queue, list) {
+			mb_y_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 0);
+			mb_c_addr = vb2_dma_contig_plane_paddr(mb_entry->b, 1);
+
+			mfc_debug(2, "enc ref y addr: 0x%08lx", mb_y_addr);
+			mfc_debug(2, "enc ref c addr: 0x%08lx", mb_c_addr);
+
+			if ((enc_y_addr == mb_y_addr) && (enc_c_addr == mb_c_addr)) {
+				list_del(&mb_entry->list);
+				ctx->ref_queue_cnt--;
+
+				vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+				break;
+			}
+		}
+	}
+
+	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
+		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+
+		if (mb_entry->used) {
+			list_del(&mb_entry->list);
+			ctx->src_queue_cnt--;
+
+			list_add_tail(&mb_entry->list, &ctx->ref_queue);
+			ctx->ref_queue_cnt++;
+		}
+
+		mfc_debug(2, "enc src count: %d, enc ref count: %d\n",
+			  ctx->src_queue_cnt, ctx->ref_queue_cnt);
+	}
+
+	if (strm_size > 0) {
+		/* at least one more dest. buffers exist always  */
+		mb_entry = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+		list_del(&mb_entry->list);
+		ctx->dst_queue_cnt--;
+		switch (slice_type) {
+			case S5P_FIMV_ENC_SI_SLICE_TYPE_I:
+				mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+				break;
+			case S5P_FIMV_ENC_SI_SLICE_TYPE_P:
+				mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+				break;
+			case S5P_FIMV_ENC_SI_SLICE_TYPE_B:
+				mb_entry->b->v4l2_buf.flags |= V4L2_BUF_FLAG_BFRAME;
+				break;
+		}
+		vb2_set_plane_payload(mb_entry->b, 0, strm_size);
+		vb2_buffer_done(mb_entry->b, VB2_BUF_STATE_DONE);
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+	/*
+		clear_work_bit(ctx);
+	*/
+	{
+		spin_lock(&dev->condlock);
+		clear_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock(&dev->condlock);
+	}
+
+	return 0;
+}
+
+static struct s5p_mfc_codec_ops encoder_codec_ops = {
+	.pre_seq_start		= enc_pre_seq_start,
+	.post_seq_start		= enc_post_seq_start,
+	.pre_frame_start	= enc_pre_frame_start,
+	.post_frame_start	= enc_post_frame_start,
+};
+
+/* Query capabilities of the device */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+
+	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
+			  | V4L2_CAP_VIDEO_OUTPUT
+			  | V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
+{
+	struct s5p_mfc_fmt *fmt;
+	int i, j = 0;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (mplane && formats[i].num_planes == 1)
+			continue;
+		else if (!mplane && formats[i].num_planes > 1)
+			continue;
+		if (out && formats[i].type != MFC_FMT_RAW)
+			continue;
+		else if (!out && formats[i].type != MFC_FMT_ENC)
+			continue;
+
+		if (j == f->index) {
+			fmt = &formats[i];
+			strlcpy(f->description, fmt->name,
+				sizeof(f->description));
+			f->pixelformat = fmt->fourcc;
+
+			return 0;
+		}
+
+		++j;
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
+				   struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, false);
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, false);
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
+				   struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, true);
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, true);
+}
+
+static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+
+	mfc_debug_enter();
+
+	mfc_debug(2, "f->type = %d ctx->state = %d\n", f->type, ctx->state);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		/* This is run on output (encoder dest) */
+		pix_fmt_mp->width = 0;
+		pix_fmt_mp->height = 0;
+		pix_fmt_mp->field = V4L2_FIELD_NONE;
+		pix_fmt_mp->pixelformat = ctx->dst_fmt->fourcc;
+		pix_fmt_mp->num_planes = ctx->dst_fmt->num_planes;
+
+		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->enc_dst_buf_size;
+		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->enc_dst_buf_size;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* This is run on capture (encoder src) */
+		pix_fmt_mp->width = ctx->img_width;
+		pix_fmt_mp->height = ctx->img_height;
+		
+		pix_fmt_mp->field = V4L2_FIELD_NONE;
+		pix_fmt_mp->pixelformat = ctx->src_fmt->fourcc;
+		pix_fmt_mp->num_planes = ctx->src_fmt->num_planes;
+
+		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
+		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
+		pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
+		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
+	} else {
+		mfc_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_ENC);
+		if (!fmt) {
+			mfc_err("failed to try output format\n");
+			return -EINVAL;
+		}
+
+		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
+			mfc_err("must be set encoding output size\n");
+			return -EINVAL;
+		}
+
+		pix_fmt_mp->plane_fmt[0].bytesperline =
+			pix_fmt_mp->plane_fmt[0].sizeimage;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("failed to try output format\n");
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != pix_fmt_mp->num_planes) {
+			mfc_err("failed to try output format\n");
+			return -EINVAL;
+		}
+	} else {
+		mfc_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	unsigned long flags;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	ret = vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_ENC);
+		if (!fmt) {
+			mfc_err("failed to set capture format\n");
+			return -EINVAL;
+		}
+		ctx->state = MFCINST_INIT;
+
+		ctx->dst_fmt = fmt;
+		ctx->codec_mode = ctx->dst_fmt->codec_mode;
+		mfc_debug(2, "codec number: %d\n", ctx->dst_fmt->codec_mode);
+
+		/* CHKME: 2KB aligned, multiple of 4KB - it may be ok with SDVMM */
+		ctx->enc_dst_buf_size =	pix_fmt_mp->plane_fmt[0].sizeimage;
+		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
+
+		ctx->dst_bufs_cnt = 0;
+		ctx->capture_state = QUEUE_FREE;
+
+		s5p_mfc_alloc_instance_buffer(ctx);
+
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_try_run(dev);
+		if (s5p_mfc_wait_for_done_ctx(ctx, \
+				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+			/* Error or timeout */
+			mfc_err("Error getting instance from hardware.\n");
+			s5p_mfc_release_instance_buffer(ctx);
+			ret = -EIO;
+			goto out;
+		}
+		mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("failed to set output format\n");
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != pix_fmt_mp->num_planes) {
+			mfc_err("failed to set output format\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ctx->src_fmt = fmt;
+		ctx->img_width = pix_fmt_mp->width;
+		ctx->img_height = pix_fmt_mp->height;
+
+		mfc_debug(2, "codec number: %d\n", ctx->src_fmt->codec_mode);
+		mfc_debug(2, "fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
+			pix_fmt_mp->width, pix_fmt_mp->height,
+			ctx->img_width, ctx->img_height);
+
+		if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+			ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN);
+
+			ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+				* ALIGN(ctx->img_height, S5P_FIMV_NV12M_LVALIGN);
+			ctx->chroma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+				* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12M_CVALIGN);
+
+			ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12M_SALIGN);
+			ctx->chroma_size = ALIGN(ctx->chroma_size, S5P_FIMV_NV12M_SALIGN);
+		} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+			ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+
+			ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+				* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+			ctx->chroma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+				* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
+
+			ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12MT_SALIGN);
+			ctx->chroma_size = ALIGN(ctx->chroma_size, S5P_FIMV_NV12MT_SALIGN);
+		}
+
+		ctx->src_bufs_cnt = 0;
+		ctx->output_state = QUEUE_FREE;
+	} else {
+		mfc_err("invalid buf type\n");
+		return -EINVAL;
+	}
+out:
+	mfc_debug_leave();
+	return ret;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	mfc_debug(2, "type: %d\n", reqbufs->memory);
+
+	/* if memory is not mmp or userptr return error */
+	if ((reqbufs->memory != V4L2_MEMORY_MMAP) &&
+		(reqbufs->memory != V4L2_MEMORY_USERPTR))
+		return -EINVAL;
+
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state != QUEUE_FREE) {
+			mfc_err("invalid capture state: %d\n", ctx->capture_state);
+			return -EINVAL;
+		}
+
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		if (ret != 0) {
+			mfc_err("error in vb2_reqbufs() for E(D)\n");
+			return ret;
+		}
+		ctx->capture_state = QUEUE_BUFS_REQUESTED;
+
+		ret = s5p_mfc_alloc_codec_buffers(ctx);
+		if (ret) {
+			mfc_err("Failed to allocate encoding buffers.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (ctx->output_state != QUEUE_FREE) {
+			mfc_err("invalid output state: %d\n", ctx->output_state);
+			return -EINVAL;
+		}
+
+		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		if (ret != 0) {
+			mfc_err("error in vb2_reqbufs() for E(S)\n");
+			return ret;
+		}
+		ctx->output_state = QUEUE_BUFS_REQUESTED;
+	} else {
+		mfc_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	mfc_debug(2, "--\n");
+
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+						   struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	mfc_debug(2, "type: %d\n", buf->memory);
+
+	/* if memory is not mmp or userptr return error */
+	if ((buf->memory != V4L2_MEMORY_MMAP) &&
+		(buf->memory != V4L2_MEMORY_USERPTR))
+		return -EINVAL;
+
+	mfc_debug(2, "state: %d, buf->type: %d\n", ctx->state, buf->type);
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->state != MFCINST_GOT_INST) {
+			mfc_err("invalid context state: %d\n", ctx->state);
+			return -EINVAL;
+		}
+		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		if (ret != 0) {
+			mfc_err("error in vb2_querybuf() for E(D)\n");
+			return ret;
+		}
+		buf->m.planes[0].m.mem_offset += DST_QUEUE_OFF_BASE;
+	} else if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_src, buf);
+		if (ret != 0) {
+			mfc_err("error in vb2_querybuf() for E(S)\n");
+			return ret;
+		}
+	} else {
+		mfc_err("invalid buf type\n");
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Queue a buffer */
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	mfc_debug_enter();
+	mfc_debug(2, "Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
+	if (ctx->state == MFCINST_ERROR) {
+		mfc_err("Call on QBUF after unrecoverable error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return vb2_qbuf(&ctx->vq_src, buf);
+	else
+		return vb2_qbuf(&ctx->vq_dst, buf);
+	mfc_debug_leave();
+	return -EINVAL;
+}
+
+/* Dequeue a buffer */
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	mfc_debug_enter();
+	mfc_debug(2, "Addr: %p %p %p Type: %d\n", &ctx->vq_src, buf, buf->m.planes,
+								buf->type);
+	if (ctx->state == MFCINST_ERROR) {
+		mfc_err("Call on DQBUF after unrecoverable error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+	else
+		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Stream on */
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret = -EINVAL;
+
+	mfc_debug_enter();
+
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamon(&ctx->vq_src, type);
+	else
+		ret = vb2_streamon(&ctx->vq_dst, type);
+
+	mfc_debug(2, "ctx->src_queue_cnt = %d ctx->state = %d "
+		  "ctx->dst_queue_cnt = %d ctx->dpb_count = %d\n",
+		  ctx->src_queue_cnt, ctx->state, ctx->dst_queue_cnt,
+		  ctx->dpb_count);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Stream off, which equals to a pause */
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	mfc_debug_enter();
+
+	ret = -EINVAL;
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamoff(&ctx->vq_src, type);
+	else
+		ret = vb2_streamoff(&ctx->vq_dst, type);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+static inline int h264_level(enum v4l2_mpeg_video_h264_level lvl)
+{
+	static unsigned int t[V4L2_MPEG_VIDEO_H264_LEVEL_4_0 + 1] = {
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_1_0   */ 10,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_1B    */ 9,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_1_1   */ 11,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_1_2   */ 12,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_1_3   */ 13,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_2_0   */ 20,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_2_1   */ 21,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_2_2   */ 22,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_3_0   */ 30,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_3_1   */ 31,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_3_2   */ 32,
+		/* V4L2_MPEG_VIDEO_H264_LEVEL_4_0   */ 40,
+	};
+	return t[lvl];
+}
+
+static inline int mpeg4_level(enum v4l2_mpeg_video_mpeg4_level lvl)
+{
+	static unsigned int t[V4L2_MPEG_VIDEO_MPEG4_LEVEL_5 + 1] = {
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_0    */ 0,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B   */ 9,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_1    */ 1,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_2    */ 2,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_3    */ 3,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_3B   */ 7,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_4    */ 4,
+		/* V4L2_MPEG_VIDEO_MPEG4_LEVEL_5    */ 5,
+	};
+	return t[lvl];
+}
+
+static inline int vui_sar_idc(enum v4l2_mpeg_video_h264_vui_sar_idc sar)
+{
+	static unsigned int t[V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED + 1] = {
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED     */ 0,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_1x1             */ 1,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11           */ 2,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_10x11           */ 3,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_16x11           */ 4,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_40x33           */ 5,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_24x11           */ 6,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_20x11           */ 7,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_32x11           */ 8,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_80x33           */ 9,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_18x11           */ 10,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_15x11           */ 11,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_64x33           */ 12,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_160x99          */ 13,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_4x3             */ 14,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_3x2             */ 15,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1             */ 16,
+		/* V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED        */ 255,
+	};
+	return t[sar];
+}
+
+static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		p->gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		p->slice_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
+		p->slice_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
+		p->slice_bit = ctrl->val * 8;
+		break;
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
+		p->intra_refresh_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING:
+		p->pad = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV:
+		p->pad_luma = (ctrl->val >> 16) & 0xff;
+		p->pad_cb = (ctrl->val >> 8) & 0xff;
+		p->pad_cr = (ctrl->val >> 0) & 0xff;
+		break;
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+		p->rc_frame = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		p->rc_bitrate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF:
+		p->rc_reaction_coeff = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
+		ctx->force_frame_type = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
+		p->vbv_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
+		p->codec.h264.cpb_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		p->seq_hdr_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
+		p->frame_skip_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT:
+		p->fixed_target_bit = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+		p->num_b_frame = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		switch (ctrl->val) {
+			case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+				p->codec.h264.profile =
+						S5P_FIMV_ENC_PROFILE_H264_MAIN;
+				break;
+			case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+				p->codec.h264.profile =
+						S5P_FIMV_ENC_PROFILE_H264_HIGH;
+				break;
+			case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+				p->codec.h264.profile =
+					S5P_FIMV_ENC_PROFILE_H264_BASELINE;
+				break;
+			default:
+				ret = -EINVAL;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		p->codec.h264.level_v4l2 = ctrl->val;
+		p->codec.h264.level = h264_level(ctrl->val);
+		if (p->codec.h264.level < 0) {
+			mfc_err("Level number is wrong.\n");
+			ret = p->codec.h264.level;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+		p->codec.mpeg4.level_v4l2 = ctrl->val;
+		p->codec.mpeg4.level = mpeg4_level(ctrl->val);
+		if (p->codec.mpeg4.level < 0) {
+			mfc_err("Level number is wrong.\n");
+			ret = p->codec.mpeg4.level;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		p->codec.h264.loop_filter_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
+		p->codec.h264.loop_filter_alpha = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
+		p->codec.h264.loop_filter_beta = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		p->codec.h264.entropy_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P:
+		p->codec.h264.num_ref_pic_4p = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
+		p->codec.h264._8x8_transform = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+		p->codec.h264.rc_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
+		p->codec.h264.rc_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		p->codec.h264.rc_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+		p->codec.h264.rc_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
+		p->codec.h264.rc_p_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:
+		p->codec.h264.rc_b_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:
+		p->codec.mpeg4.rc_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:
+		p->codec.mpeg4.rc_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:
+		p->codec.mpeg4.rc_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:
+		p->codec.mpeg4.rc_p_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:
+	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:
+		p->codec.mpeg4.rc_b_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK:
+		p->codec.h264.rc_mb_dark = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH:
+		p->codec.h264.rc_mb_smooth = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC:
+		p->codec.h264.rc_mb_static = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY:
+		p->codec.h264.rc_mb_activity = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
+		p->codec.h264.vui_sar = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+		p->codec.h264.vui_sar_idc = vui_sar_idc(ctrl->val);
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:
+		p->codec.h264.vui_ext_sar_width = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT:
+		p->codec.h264.vui_ext_sar_height = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+		p->codec.h264.open_gop = !ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
+		p->codec.h264.open_gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+		switch (ctrl->val) {
+			case V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE:
+				p->codec.mpeg4.profile =
+					S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE;
+				break;
+			case V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE:
+				p->codec.mpeg4.profile =
+				S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE;
+				break;
+			default:
+				ret = -EINVAL;
+		}
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+		p->codec.mpeg4.quarter_pixel = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES:
+		p->codec.mpeg4.vop_time_res = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC:
+		p->codec.mpeg4.vop_frm_delta = ctrl->val;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n", ctrl->id, ctrl->val);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops s5p_mfc_enc_ctrl_ops = {
+	.s_ctrl = s5p_mfc_enc_s_ctrl,
+};
+
+int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_ENC) {
+			mfc_err("For MPEG4 please use the:\n"
+				"-V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_TIME_RES and\n"
+				"-V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_TIME_INC\n"
+				"controls.\n");
+			return -EINVAL;
+		}
+		ctx->enc_params.rc_framerate_num =
+					a->parm.output.timeperframe.denominator;
+		ctx->enc_params.rc_framerate_denom =
+					a->parm.output.timeperframe.numerator;
+	} else {
+		mfc_err("Setting FPS is only possible for the output queue.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		a->parm.output.timeperframe.denominator =
+					ctx->enc_params.rc_framerate_num;
+		a->parm.output.timeperframe.numerator =
+					ctx->enc_params.rc_framerate_denom;
+	} else {
+		mfc_err("Setting FPS is only possible for the output queue.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt,
+	.vidioc_reqbufs = vidioc_reqbufs,
+	.vidioc_querybuf = vidioc_querybuf,
+	.vidioc_qbuf = vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+	.vidioc_s_parm = vidioc_s_parm,
+	.vidioc_g_parm = vidioc_g_parm,
+};
+
+static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
+{
+	int i;
+
+	if (!fmt)
+		return -EINVAL;
+
+	if (fmt->num_planes != vb->num_planes) {
+		mfc_err("invalid plane number for the format\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < fmt->num_planes; i++) {
+		if (!vb2_dma_contig_plane_paddr(vb, i)) {
+			mfc_err("failed to get plane cookie\n");
+			return -EINVAL;
+		}
+
+		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx",
+				vb->v4l2_buf.index, i,
+				vb2_dma_contig_plane_paddr(vb, i));
+	}
+
+	return 0;
+}
+
+static int s5p_mfc_queue_setup(struct vb2_queue *vq,
+			       unsigned int *buf_count, unsigned int *plane_count,
+			       unsigned long psize[], void *allocators[])
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	int i;
+
+	mfc_debug_enter();
+
+	if (ctx->state != MFCINST_GOT_INST) {
+		mfc_err("inavlid state: %d\n", ctx->state);
+		return -EINVAL;
+	}
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->dst_fmt)
+			*plane_count = ctx->dst_fmt->num_planes;
+		else
+			*plane_count = MFC_ENC_CAP_PLANE_COUNT;
+
+		if (*buf_count < 1)
+			*buf_count = 1;
+		if (*buf_count > MFC_MAX_BUFFERS)
+			*buf_count = MFC_MAX_BUFFERS;
+
+		/* CHKME: 2KB aligned, multiple of 4KB - it may be ok with SDVMM */
+		psize[0] = ctx->enc_dst_buf_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX];
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (ctx->src_fmt)
+			*plane_count = ctx->src_fmt->num_planes;
+		else
+			*plane_count = MFC_ENC_OUT_PLANE_COUNT;
+
+		if (*buf_count < 1)
+			*buf_count = 1;
+		if (*buf_count > MFC_MAX_BUFFERS)
+			*buf_count = MFC_MAX_BUFFERS;
+
+		/* CHKME:
+		 * size is aligned alreay in vidioc_s_fmt.
+		 * How about alignment of start address?
+		 */
+		psize[0] = ctx->luma_size;
+		psize[1] = ctx->chroma_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX];
+		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX];
+
+	} else {
+		mfc_err("inavlid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	mfc_debug(2, "buf_count: %d, plane_count: %d\n", *buf_count, *plane_count);
+	for (i = 0; i < *plane_count; i++)
+		mfc_debug(2, "plane[%d] size=%lu\n", i, psize[i]);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static void s5p_mfc_unlock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->mfc_mutex);
+}
+
+static void s5p_mfc_lock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mfc_mutex);
+}
+
+static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	unsigned int i;
+	int ret;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		i = vb->v4l2_buf.index;
+		ctx->dst_bufs[i].b = vb;
+		ctx->dst_bufs[i].cookie.stream = vb2_dma_contig_plane_paddr(vb, 0);
+		ctx->dst_bufs_cnt++;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = check_vb_with_fmt(ctx->src_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		i = vb->v4l2_buf.index;
+		ctx->src_bufs[i].b = vb;
+		ctx->src_bufs[i].cookie.raw.luma = vb2_dma_contig_plane_paddr(vb, 0);
+		ctx->src_bufs[i].cookie.raw.chroma = vb2_dma_contig_plane_paddr(vb, 1);
+		ctx->src_bufs_cnt++;
+	} else {
+		mfc_err("inavlid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	int ret;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		mfc_debug(2, "plane size: %ld, dst size: %d\n",
+			vb2_plane_size(vb, 0), ctx->enc_dst_buf_size);
+
+		if (vb2_plane_size(vb, 0) < ctx->enc_dst_buf_size) {
+			mfc_err("plane size is too small for capture\n");
+			return -EINVAL;
+		}
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = check_vb_with_fmt(ctx->src_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		mfc_debug(2, "plane size: %ld, luma size: %d\n",
+			vb2_plane_size(vb, 0), ctx->luma_size);
+	mfc_debug(2, "plane size: %ld, chroma size: %d\n",
+			vb2_plane_size(vb, 1), ctx->chroma_size);
+
+		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
+		    vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			mfc_err("plane size is too small for output\n");
+			return -EINVAL;
+		}
+	} else {
+		mfc_err("inavlid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_start_streaming(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+
+	/* If context is ready then dev = work->data;schedule it to run */
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run(dev);
+
+	return 0;
+}
+
+static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	if ((ctx->state == MFCINST_FINISHING ||
+		ctx->state == MFCINST_RUNNING) &&
+		dev->curr_ctx == ctx->num && dev->hw_lock) {
+		ctx->state = MFCINST_ABORT;
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+					  0);
+	}
+
+	ctx->state = MFCINST_FINISHED;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		INIT_LIST_HEAD(&ctx->dst_queue);
+		ctx->dst_queue_cnt = 0;
+	}
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		cleanup_ref_queue(ctx);
+
+		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		INIT_LIST_HEAD(&ctx->src_queue);
+		ctx->src_queue_cnt = 0;
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	return 0;
+}
+
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *mfc_buf;
+
+	mfc_debug_enter();
+
+	if (ctx->state == MFCINST_ERROR) {
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		cleanup_ref_queue(ctx);
+		return;
+	}
+
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_buf->used = 0;
+		mfc_debug(2, "dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug(2, "adding to dst: %p (%08zx, %08x)\n", vb,
+			vb2_dma_contig_plane_paddr(vb, 0),
+			ctx->dst_bufs[vb->v4l2_buf.index].cookie.stream);
+
+		/* Mark destination as available for use by MFC */
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
+		ctx->dst_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_buf->used = 0;
+		mfc_debug(2, "src queue: %p\n", &ctx->src_queue);
+		mfc_debug(2, "adding to src: %p (%08zx, %08zx, %08x, %08x)\n", vb,
+			vb2_dma_contig_plane_paddr(vb, 0),
+			vb2_dma_contig_plane_paddr(vb, 1),
+			ctx->src_bufs[vb->v4l2_buf.index].cookie.raw.luma,
+			ctx->src_bufs[vb->v4l2_buf.index].cookie.raw.chroma);
+
+		spin_lock_irqsave(&dev->irqlock, flags);
+
+		if (vb->v4l2_planes[0].bytesused == 0) {
+			mfc_debug(1, "change state to FINISHING\n");
+			ctx->state = MFCINST_FINISHING;
+
+			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+
+			cleanup_ref_queue(ctx);
+		} else {
+			list_add_tail(&mfc_buf->list, &ctx->src_queue);
+			ctx->src_queue_cnt++;
+		}
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else {
+		mfc_err("unsupported buffer type (%d)\n", vq->type);
+	}
+
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+	s5p_mfc_try_run(dev);
+
+	mfc_debug_leave();
+}
+
+static struct vb2_ops s5p_mfc_enc_qops = {
+	.queue_setup	= s5p_mfc_queue_setup,
+	.wait_prepare	= s5p_mfc_unlock,
+	.wait_finish	= s5p_mfc_lock,
+	.buf_init	= s5p_mfc_buf_init,
+	.buf_prepare	= s5p_mfc_buf_prepare,
+	.start_streaming= s5p_mfc_start_streaming,
+	.stop_streaming = s5p_mfc_stop_streaming,
+	.buf_queue	= s5p_mfc_buf_queue,
+};
+
+struct s5p_mfc_codec_ops *get_enc_codec_ops(void)
+{
+	return &encoder_codec_ops;
+}
+
+struct vb2_ops *get_enc_queue_ops(void)
+{
+	return &s5p_mfc_enc_qops;
+}
+
+const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void)
+{
+	return &s5p_mfc_enc_ioctl_ops;
+}
+
+int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
+{
+	int i;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, NUM_CTRLS);
+	if (ctx->ctrl_handler.error) {
+		mfc_err("v4l2_ctrl_handler_init failed.\n");
+		return ctx->ctrl_handler.error;
+	}
+	for (i = 0; i < NUM_CTRLS; i++) {
+		if (controls[i].type == V4L2_CTRL_TYPE_MENU) {
+			ctx->ctrls[i] = v4l2_ctrl_new_std_menu(
+				&ctx->ctrl_handler, &s5p_mfc_enc_ctrl_ops,
+				controls[i].id,
+				controls[i].maximum, 0,
+				controls[i].default_value);
+		} else {
+			ctx->ctrls[i] = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+			&s5p_mfc_enc_ctrl_ops,
+			controls[i].id, controls[i].minimum,
+			controls[i].maximum, controls[i].step,
+			controls[i].default_value);
+		}
+
+		if (ctx->ctrl_handler.error) {
+			mfc_err("Adding control (%d) failed\n", i);
+			return ctx->ctrl_handler.error;
+		}
+	}
+
+	return 0;
+}
+
+void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx)
+{
+	int i;
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	for (i = 0; i < NUM_CTRLS; i++)
+		ctx->ctrls[i] = NULL;
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
new file mode 100644
index 0000000..d546982
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
@@ -0,0 +1,23 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_ENC_H_
+#define __S5P_MFC_ENC_H_
+
+struct s5p_mfc_codec_ops *get_enc_codec_ops(void);
+struct vb2_ops *get_enc_queue_ops(void);
+const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
+struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
+int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx);
+
+#endif /* __S5P_MFC_ENC_H_  */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_inst.c b/drivers/media/video/s5p-mfc/s5p_mfc_inst.c
new file mode 100644
index 0000000..a34df74
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_inst.c
@@ -0,0 +1,52 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_inst.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_intr.h"
+
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	/* Preparing decoding - getting instance number */
+	mfc_debug(2, "Getting instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_open_inst_cmd(ctx);
+	if (ret) {
+		mfc_err("Failed to create a new instance.\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+int s5p_mfc_close_inst(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	/* Closing decoding instance  */
+	mfc_debug(2, "Returning instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_close_inst_cmd(ctx);
+	if (ret) {
+		mfc_err("Failed to return an instance.\n");
+		ctx->state = MFCINST_ERROR;
+		return ret;
+	}
+	return ret;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_inst.h b/drivers/media/video/s5p-mfc/s5p_mfc_inst.h
new file mode 100644
index 0000000..4120474
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_inst.h
@@ -0,0 +1,19 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_inst.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_INST_H_
+#define __S5P_MFC_INST_H_
+
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_close_inst(struct s5p_mfc_ctx *ctx);
+
+#endif /* __S5P_MFC_INST_H_  */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
new file mode 100644
index 0000000..9cf2b9f
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -0,0 +1,94 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_intr.c
+ *
+ * C file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains functions used to wait for command completion.
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_debug.h"
+
+int s5p_mfc_wait_for_done_dev(struct s5p_mfc_dev *dev, int command)
+{
+	int ret;
+
+	ret = wait_event_interruptible_timeout(dev->queue,
+		(dev->int_cond && (dev->int_type == command
+		|| dev->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+		msecs_to_jiffies(MFC_INT_TIMEOUT));
+	if (ret == 0) {
+		mfc_err("Interrupt (dev->int_type:%d, command:%d) timed out.\n",
+							dev->int_type, command);
+		return 1;
+	} else if (ret == -ERESTARTSYS) {
+		mfc_err("Interrupted by a signal.\n");
+		return 1;
+	}
+	mfc_debug(1, "Finished waiting (dev->int_type:%d, command: %d).\n",
+							dev->int_type, command);
+	if (dev->int_type == S5P_FIMV_R2H_CMD_ERR_RET)
+		return 1;
+	return 0;
+}
+
+void s5p_mfc_clean_dev_int_flags(struct s5p_mfc_dev *dev)
+{
+	dev->int_cond = 0;
+	dev->int_type = 0;
+	dev->int_err = 0;
+}
+
+int s5p_mfc_wait_for_done_ctx(struct s5p_mfc_ctx *ctx,
+				    int command, int interrupt)
+{
+	int ret;
+
+	if (interrupt) {
+		ret = wait_event_interruptible_timeout(ctx->queue,
+				(ctx->int_cond && (ctx->int_type == command
+			|| ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+					msecs_to_jiffies(MFC_INT_TIMEOUT));
+	} else {
+		ret = wait_event_timeout(ctx->queue,
+				(ctx->int_cond && (ctx->int_type == command
+			|| ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+					msecs_to_jiffies(MFC_INT_TIMEOUT));
+	}
+	if (ret == 0) {
+		mfc_err("Interrupt (ctx->int_type:%d, command:%d) timed out.\n",
+							ctx->int_type, command);
+		return 1;
+	} else if (ret == -ERESTARTSYS) {
+		mfc_err("Interrupted by a signal.\n");
+		return 1;
+	}
+	mfc_debug(1, "Finished waiting (ctx->int_type:%d, command: %d).\n",
+							ctx->int_type, command);
+	if (ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)
+		return 1;
+	return 0;
+}
+
+void s5p_mfc_clean_ctx_int_flags(struct s5p_mfc_ctx *ctx)
+{
+	ctx->int_cond = 0;
+	ctx->int_type = 0;
+	ctx->int_err = 0;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.h b/drivers/media/video/s5p-mfc/s5p_mfc_intr.h
new file mode 100644
index 0000000..8c531b6
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.h
@@ -0,0 +1,26 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_intr.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * It contains waiting functions declarations.
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _S5P_MFC_INTR_H_
+#define _S5P_MFC_INTR_H_
+
+#include "s5p_mfc_common.h"
+
+int s5p_mfc_wait_for_done_ctx(struct s5p_mfc_ctx *ctx,
+						int command, int interrupt);
+int s5p_mfc_wait_for_done_dev(struct s5p_mfc_dev *dev, int command);
+void s5p_mfc_clean_ctx_int_flags(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_clean_dev_int_flags(struct s5p_mfc_dev *dev);
+
+#endif /* _S5P_MFC_INTR_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_mem.h b/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
new file mode 100644
index 0000000..0ffa931
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
@@ -0,0 +1,55 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_mem.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_MEM_H_
+#define __S5P_MFC_MEM_H_ __FILE__
+
+#include <linux/platform_device.h>
+#include "s5p_mfc_common.h"
+
+/* Offset base used to differentiate between CAPTURE and OUTPUT
+*  while mmaping */
+
+#define MFC_OFFSET_SHIFT	11
+
+#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
+
+#define FIRMWARE_CODE_SIZE	0x60000		/* 384KB */
+#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264 instance */
+#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
+#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC buffer */
+#define SHARED_BUF_SIZE		0x1000		/* 4KB for shared buffer */
+
+#define DEF_CPB_SIZE		0x40000		/* 512KB */
+
+#define MFC_BANK_A_ALLOC_CTX	0
+#define MFC_BANK_B_ALLOC_CTX	1
+#define MFC_FW_ALLOC_CTX	0	
+
+#define MFC_BANK1_ALIGN_ORDER	13
+#define MFC_BANK2_ALIGN_ORDER	13
+#define MFC_FW_ALIGN_ORDER	17
+
+#define MFC_BASE_ALIGN_ORDER	MFC_FW_ALIGN_ORDER
+
+#include <media/videobuf2-dma-contig.h>
+
+static inline size_t s5p_mfc_mem_cookie(void *a, void *b)
+{
+	/* Same functionality as the vb2_dma_contig_plane_paddr */
+	dma_addr_t *paddr = vb2_dma_contig_memops.cookie(b); 
+
+	return *paddr;
+}
+
+
+#endif /* __S5P_MFC_MEM_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
new file mode 100644
index 0000000..fc912cb
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -0,0 +1,1588 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_opr.c
+ *
+ * Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains hw related functions.
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+
+#include <linux/firmware.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+
+#include <linux/dma-mapping.h>
+#include <asm/cacheflush.h>
+
+#include "regs-mfc.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_inst.h"
+#include "s5p_mfc_pm.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_shm.h"
+
+/* #define S5P_MFC_DEBUG_REGWRITE  */
+#ifdef S5P_MFC_DEBUG_REGWRITE
+#undef writel
+#define writel(v, r) do { \
+	printk(KERN_ERR "MFCWRITE(%p): %08x\n", r, (unsigned int)v); \
+	__raw_writel(v, r); } while (0)
+#endif /* S5P_MFC_DEBUG_REGWRITE */
+
+#define READL(offset)		__raw_readl(dev->regs_base + (offset))
+#define WRITEL(data, offset)	__raw_writel((data), dev->regs_base + (offset))
+#define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
+#define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
+
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+{
+	void *desc_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	mfc_debug_enter();
+	ctx->desc_buf = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], DESC_BUF_SIZE);
+	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
+		ctx->desc_buf = 0;
+		mfc_err("Allocating DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	ctx->desc_phys = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], ctx->desc_buf);
+	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
+	if (desc_virt == NULL) {
+		vb2_dma_contig_memops.put(ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = 0;
+		mfc_err("Remapping DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	memset(desc_virt, 0, DESC_BUF_SIZE);
+	wmb();
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Release temproary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->desc_phys) {
+		vb2_dma_contig_memops.put(ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = 0;
+	}
+}
+
+/* Allocate codec buffers */
+int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int enc_ref_y_size = 0;
+	unsigned int enc_ref_c_size = 0;
+	unsigned int guard_width, guard_height;
+
+	mfc_debug_enter();
+
+	if (ctx->type == MFCINST_DECODER) {
+		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
+			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
+		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
+	} else if (ctx->type == MFCINST_ENCODER) {
+		enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
+
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
+			enc_ref_c_size = ALIGN(ctx->img_width,
+						S5P_FIMV_NV12MT_HALIGN)
+						* ALIGN(ctx->img_height >> 1,
+						S5P_FIMV_NV12MT_VALIGN);
+			enc_ref_c_size = ALIGN(enc_ref_c_size,
+							S5P_FIMV_NV12MT_SALIGN);
+		} else {
+			guard_width = ALIGN(ctx->img_width + 16,
+							S5P_FIMV_NV12MT_HALIGN);
+			guard_height = ALIGN((ctx->img_height >> 1) + 4,
+							S5P_FIMV_NV12MT_VALIGN);
+			enc_ref_c_size = ALIGN(guard_width * guard_height,
+					       S5P_FIMV_NV12MT_SALIGN);
+		}
+
+		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
+			  enc_ref_y_size, enc_ref_c_size);
+	} else {
+		return -EINVAL;
+	}
+
+	/* Codecs have different memory requirements */
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+		ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
+					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
+					S5P_FIMV_DEC_BUF_ALIGN);
+		/* TODO, when merged with FIMC then test will it work without
+		 * alignment to 8192. For all codecs. */
+		ctx->port_b_size = ctx->total_dpb_count * ctx->mv_size;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+		ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
+				     S5P_FIMV_DEC_UPNB_MV_SIZE +
+				     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+				     S5P_FIMV_DEC_STX_PARSER_SIZE +
+				     S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE,
+				     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->port_b_size = 0;
+		break;
+
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+	case S5P_FIMV_CODEC_VC1_DEC:
+		ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE +
+			     3 * S5P_FIMV_DEC_VC1_BITPLANE_SIZE,
+			     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->port_b_size = 0;
+		break;
+
+	case S5P_FIMV_CODEC_MPEG2_DEC:
+		ctx->port_a_size = 0;
+		ctx->port_b_size = 0;
+		break;
+	case S5P_FIMV_CODEC_H263_DEC:
+		ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE,
+			     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->port_b_size = 0;
+		break;
+
+	case S5P_FIMV_CODEC_H264_ENC:
+		ctx->port_a_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_COLFLG_SIZE +
+				   S5P_FIMV_ENC_INTRAMD_SIZE +
+				   S5P_FIMV_ENC_NBORINFO_SIZE;
+		ctx->port_b_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4) +
+				   S5P_FIMV_ENC_INTRAPRED_SIZE;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_ENC:
+		ctx->port_a_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_COLFLG_SIZE +
+				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		ctx->port_b_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4);
+		break;
+	case S5P_FIMV_CODEC_H263_ENC:
+		ctx->port_a_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		ctx->port_b_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4);
+		break;
+	default:
+		break;
+	}
+
+	/* Allocate only if memory from bank 1 is necessary */
+	if (ctx->port_a_size > 0) {
+		ctx->port_a_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], ctx->port_a_size);
+		if (IS_ERR(ctx->port_a_buf)) {
+			ctx->port_a_buf = 0;
+			printk(KERN_ERR
+			       "Buf alloc for decoding failed (port A).\n");
+			return -ENOMEM;
+		}
+		ctx->port_a_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], ctx->port_a_buf);
+		BUG_ON(ctx->port_a_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	}
+
+	/* Allocate only if memory from bank 2 is necessary */
+	if (ctx->port_b_size > 0) {
+		ctx->port_b_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX], ctx->port_b_size);
+		if (IS_ERR(ctx->port_b_buf)) {
+			ctx->port_b_buf = 0;
+			mfc_err("Buf alloc for decoding failed (port B).\n");
+			return -ENOMEM;
+		}
+		ctx->port_b_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK_B_ALLOC_CTX], ctx->port_b_buf);
+		BUG_ON(ctx->port_b_phys & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
+	}
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Release buffers allocated for codec */
+void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->port_a_buf) {
+		vb2_dma_contig_memops.put(ctx->port_a_buf);
+		ctx->port_a_buf = 0;
+		ctx->port_a_phys = 0;
+		ctx->port_a_size = 0;
+	}
+	if (ctx->port_b_buf) {
+		vb2_dma_contig_memops.put(ctx->port_b_buf);
+		ctx->port_b_buf = 0;
+		ctx->port_b_phys = 0;
+		ctx->port_b_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
+{
+	void *context_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		ctx->context_size = MFC_H264_CTX_BUF_SIZE;
+	else
+		ctx->context_size = MFC_CTX_BUF_SIZE;
+	ctx->context_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], ctx->context_size);
+	if (IS_ERR(ctx->context_buf)) {
+		mfc_err("Allocating context buffer failed.\n");
+		ctx->context_phys = 0;
+		ctx->context_buf = 0;
+		return -ENOMEM;
+	}
+
+	ctx->context_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX], ctx->context_buf);
+	BUG_ON(ctx->context_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->context_ofs = OFFSETA(ctx->context_phys);
+	context_virt = vb2_dma_contig_memops.vaddr(ctx->context_buf);
+	if (context_virt == NULL) {
+		mfc_err("Remapping instance buffer failed.\n");
+		vb2_dma_contig_memops.put(ctx->context_buf);
+		ctx->context_phys = 0;
+		ctx->context_buf = 0;
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory */
+	memset(context_virt, 0, ctx->context_size);
+	wmb();
+
+	if (s5p_mfc_init_shm(ctx) < 0) {
+		vb2_dma_contig_memops.put(ctx->context_buf);
+		ctx->context_phys = 0;
+		ctx->context_buf = 0;
+		return -ENOMEM;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Release instance buffer */
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
+{
+	mfc_debug_enter();
+	if (ctx->context_buf) {
+		vb2_dma_contig_memops.put(ctx->context_buf);
+		ctx->context_phys = 0;
+		ctx->context_buf = 0;
+	}
+	if (ctx->shm_alloc) {
+		vb2_dma_contig_memops.put(ctx->shm_alloc);
+		ctx->shm_alloc = 0;
+		ctx->shm = 0;
+	}
+	mfc_debug_leave();
+}
+
+/* Set registers for decoding temporary buffers */
+void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(OFFSETA(ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
+	WRITEL(DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+}
+
+/* Set registers for shared buffer */
+void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	WRITEL(ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int buf_size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x, buf_size: 0x"
+		"%08x (%d)\n",  ctx->inst_no, buf_addr, buf_size, buf_size);
+	WRITEL(OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
+	WRITEL(ctx->dec_src_buf_size, S5P_FIMV_SI_CH0_CPB_SIZE);
+	WRITEL(buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
+	s5p_mfc_write_shm(ctx, start_num_byte, START_BYTE_NUM);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Set decoding frame buffer */
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int frame_size, i;
+	unsigned int frame_size_ch, frame_size_mv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	size_t buf_addr1, buf_addr2;
+	int buf_size1, buf_size2;
+
+	buf_addr1 = ctx->port_a_phys;
+	buf_size1 = ctx->port_a_size;
+	buf_addr2 = ctx->port_b_phys;
+	buf_size2 = ctx->port_b_size;
+
+	mfc_debug(2, "Buf1: %p (%d) Buf2: %p (%d)\n",
+		  (void *)buf_addr1, buf_size1,
+		  (void *)buf_addr2, buf_size2);
+	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
+	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
+
+	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~S5P_FIMV_DPB_COUNT_MASK;
+	WRITEL(ctx->total_dpb_count | dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+
+	s5p_mfc_set_shared_buffer(ctx);
+
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_VERT_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_NB_IP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_STX_PARSER_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_STX_PARSER_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		break;
+	case S5P_FIMV_CODEC_H263_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		break;
+	case S5P_FIMV_CODEC_VC1_DEC:
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE3_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE2_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE1_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		break;
+	case S5P_FIMV_CODEC_MPEG2_DEC:
+		break;
+	default:
+		mfc_err("Unknown codec for decoding (%x).\n",
+			ctx->codec_mode);
+		return -EINVAL;
+		break;
+	}
+	frame_size = ctx->luma_size;
+	frame_size_ch = ctx->chroma_size;
+	frame_size_mv = ctx->mv_size;
+	mfc_debug(2, "Frame size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
+								frame_size_mv);
+	for (i = 0; i < ctx->total_dpb_count; i++) {
+		/* Port B */
+		mfc_debug(2, "Luma %d: %x\n", i, ctx->dst_bufs[i].cookie.raw.luma);
+		WRITEL(OFFSETB(ctx->dst_bufs[i].cookie.raw.luma),
+						S5P_FIMV_DEC_LUMA_ADR + i * 4);
+		mfc_debug(2, "\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.chroma);
+		WRITEL(OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
+					       S5P_FIMV_DEC_CHROMA_ADR + i * 4);
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+			mfc_debug(2, "\tBuf2: %x, size: %d\n",
+							buf_addr2, buf_size2);
+			WRITEL(OFFSETB(buf_addr2), S5P_FIMV_H264_MV_ADR + i * 4);
+			buf_addr2 += frame_size_mv;
+			buf_size2 -= frame_size_mv;
+		}
+	}
+	mfc_debug(2, "Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
+	mfc_debug(2, "Buf 1/2 size after: %d/%d (frames %d)\n",
+			buf_size1,  buf_size2, ctx->total_dpb_count);
+	if (buf_size1 < 0 || buf_size2 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	s5p_mfc_write_shm(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
+	s5p_mfc_write_shm(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+		s5p_mfc_write_shm(ctx, frame_size_mv, ALLOC_MV_SIZE);
+
+	WRITEL(((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug(2, "After setting buffers.\n");
+	return 0;
+}
+
+/* Set registers for encoding stream buffer */
+int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(OFFSETA(addr), S5P_FIMV_ENC_SI_CH0_SB_ADR);
+	WRITEL(size, S5P_FIMV_ENC_SI_CH0_SB_SIZE);
+
+	return 0;
+}
+
+void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(OFFSETB(y_addr), S5P_FIMV_ENC_SI_CH0_CUR_Y_ADR);
+	WRITEL(OFFSETB(c_addr), S5P_FIMV_ENC_SI_CH0_CUR_C_ADR);
+}
+
+void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	*y_addr = dev->port_b + (READL(S5P_FIMV_ENCODED_Y_ADDR) << MFC_OFFSET_SHIFT);
+	*c_addr = dev->port_b + (READL(S5P_FIMV_ENCODED_C_ADDR) << MFC_OFFSET_SHIFT);
+}
+
+/* Set encoding ref & codec buffer */
+int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	size_t buf_addr1, buf_addr2;
+	size_t buf_size1, buf_size2;
+	unsigned int enc_ref_y_size, enc_ref_c_size;
+	unsigned int guard_width, guard_height;
+	int i;
+
+	mfc_debug_enter();
+
+	buf_addr1 = ctx->port_a_phys;
+	buf_size1 = ctx->port_a_size;
+	buf_addr2 = ctx->port_b_phys;
+	buf_size2 = ctx->port_b_size;
+
+	enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+		* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+	enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
+		enc_ref_c_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_c_size = ALIGN(enc_ref_c_size, S5P_FIMV_NV12MT_SALIGN);
+	} else {
+		guard_width = ALIGN(ctx->img_width + 16, S5P_FIMV_NV12MT_HALIGN);
+		guard_height = ALIGN((ctx->img_height >> 1) + 4, S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_c_size = ALIGN(guard_width * guard_height,
+				       S5P_FIMV_NV12MT_SALIGN);
+	}
+
+	mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
+
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_ENC:
+		for (i = 0; i < 2; i++) {
+			WRITEL(OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+
+		for (i = 0; i < 4; i++) {
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_COZERO_FLAG_ADR);
+		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_UP_INTRA_MD_ADR);
+		buf_addr1 += S5P_FIMV_ENC_INTRAMD_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_INTRAMD_SIZE;
+
+		WRITEL(OFFSETB(buf_addr2), S5P_FIMV_H264_UP_INTRA_PRED_ADR);
+		buf_addr2 += S5P_FIMV_ENC_INTRAPRED_SIZE;
+		buf_size2 -= S5P_FIMV_ENC_INTRAPRED_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H264_NBOR_INFO_ADR);
+		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
+
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+
+	case S5P_FIMV_CODEC_MPEG4_ENC:
+		for (i = 0; i < 2; i++) {
+			WRITEL(OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+
+		for (i = 0; i < 4; i++) {
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_COZERO_FLAG_ADR);
+		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_MPEG4_ACDC_COEF_ADR);
+		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
+
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+
+	case S5P_FIMV_CODEC_H263_ENC:
+		for (i = 0; i < 2; i++) {
+			WRITEL(OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+
+		for (i = 0; i < 4; i++) {
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_H263_ACDC_COEF_ADR);
+		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
+
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+
+	default:
+		mfc_err("Unknown codec set for encoding: %d\n",
+			ctx->codec_mode);
+		return -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	unsigned int reg;
+	unsigned int shm;
+
+	mfc_debug_enter();
+
+	/* width */
+	WRITEL(ctx->img_width, S5P_FIMV_ENC_HSIZE_PX);
+	/* height */
+	WRITEL(ctx->img_height, S5P_FIMV_ENC_VSIZE_PX);
+
+	/* pictype : enable, IDR period */
+	reg = READL(S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	reg |= (1 << 18);
+	reg &= ~(0xFFFF);
+	reg |= p->gop_size;
+	WRITEL(reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+
+	WRITEL(0, S5P_FIMV_ENC_B_RECON_WRITE_ON);
+
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	WRITEL(p->slice_mode, S5P_FIMV_ENC_MSLICE_CTRL);
+	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
+		WRITEL(p->slice_mb, S5P_FIMV_ENC_MSLICE_MB);
+	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
+		WRITEL(p->slice_bit, S5P_FIMV_ENC_MSLICE_BIT);
+	} else {
+		WRITEL(0, S5P_FIMV_ENC_MSLICE_MB);
+		WRITEL(0, S5P_FIMV_ENC_MSLICE_BIT);
+	}
+
+	/* cyclic intra refresh */
+	WRITEL(p->intra_refresh_mb, S5P_FIMV_ENC_CIR_CTRL);
+
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
+		WRITEL(0, S5P_FIMV_ENC_MAP_FOR_CUR);
+	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		WRITEL(3, S5P_FIMV_ENC_MAP_FOR_CUR);
+
+	/* padding control & value */
+	reg = READL(S5P_FIMV_ENC_PADDING_CTRL);
+	if (p->pad) {
+		/** enable */
+		reg |= (1 << 31);
+		/** cr value */
+		reg &= ~(0xFF << 16);
+		reg |= (p->pad_cr << 16);
+		/** cb value */
+		reg &= ~(0xFF << 8);
+		reg |= (p->pad_cb << 8);
+		/** y value */
+		reg &= ~(0xFF);
+		reg |= (p->pad_luma);
+	} else {
+		/** disable & all value clear */
+		reg = 0;
+	}
+	WRITEL(reg, S5P_FIMV_ENC_PADDING_CTRL);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_ENC_RC_CONFIG);
+	/** frame-level rate control */
+	reg &= ~(0x1 << 9);
+	reg |= (p->rc_frame << 9);
+	WRITEL(reg, S5P_FIMV_ENC_RC_CONFIG);
+
+	/* bit rate */
+	if (p->rc_frame)
+		WRITEL(p->rc_bitrate,
+			S5P_FIMV_ENC_RC_BIT_RATE);
+	else
+		WRITEL(0, S5P_FIMV_ENC_RC_BIT_RATE);
+
+	/* reaction coefficient */
+	if (p->rc_frame)
+		WRITEL(p->rc_reaction_coeff, S5P_FIMV_ENC_RC_RPARA);
+
+	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	/** seq header ctrl */
+	shm &= ~(0x1 << 3);
+	shm |= (p->seq_hdr_mode << 3);
+	/** frame skip mode */
+	shm &= ~(0x3 << 1);
+	shm |= (p->frame_skip_mode << 1);
+	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+
+	/* fixed target bit */
+	s5p_mfc_write_shm(ctx, p->fixed_target_bit, RC_CONTROL_CONFIG);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_h264_enc_params *p_264 = &p->codec.h264;
+	unsigned int reg;
+	unsigned int shm;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/** num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p->num_b_frame << 16);
+	WRITEL(reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+
+	/* profile & level */
+	reg = READL(S5P_FIMV_ENC_PROFILE);
+	/** level */
+	reg &= ~(0xFF << 8);
+	reg |= (p_264->level << 8);
+	/** profile - 0 ~ 2 */
+	reg &= ~(0x3F);
+	reg |= p_264->profile;
+	WRITEL(reg, S5P_FIMV_ENC_PROFILE);
+
+	/* interlace  */
+	WRITEL(p->interlace, S5P_FIMV_ENC_PIC_STRUCT);
+	/** height */
+	if (p->interlace)
+		WRITEL(ctx->img_height >> 1, S5P_FIMV_ENC_VSIZE_PX);
+
+	/* loopfilter ctrl */
+	WRITEL(p_264->loop_filter_mode, S5P_FIMV_ENC_LF_CTRL);
+
+	/* loopfilter alpha offset */
+	if (p_264->loop_filter_alpha < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_264->loop_filter_alpha) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_264->loop_filter_alpha & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_ENC_ALPHA_OFF);
+
+	/* loopfilter beta offset */
+	if (p_264->loop_filter_beta < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_264->loop_filter_beta) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_264->loop_filter_beta & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_ENC_BETA_OFF);
+
+	/* entropy coding mode */
+	if (p_264->entropy_mode == V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC)
+		WRITEL(1, S5P_FIMV_ENC_H264_ENTROPY_MODE);
+	else
+		WRITEL(0, S5P_FIMV_ENC_H264_ENTROPY_MODE);
+
+	/* number of ref. picture */
+	reg = READL(S5P_FIMV_ENC_H264_NUM_OF_REF);
+	/** num of ref. pictures of P */
+	reg &= ~(0x3 << 5);
+	reg |= (p_264->num_ref_pic_4p << 5);
+	/** max number of ref. pictures */
+	reg &= ~(0x1F);
+	reg |= p_264->max_ref_pic;
+	WRITEL(reg, S5P_FIMV_ENC_H264_NUM_OF_REF);
+
+	/* 8x8 transform enable */
+	WRITEL(p_264->_8x8_transform, S5P_FIMV_ENC_H264_TRANS_FLAG);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_ENC_RC_CONFIG);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= (p_264->rc_mb << 8);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_264->rc_frame_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_CONFIG);
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_denom)
+		WRITEL(p->rc_framerate_num * 1000 / p->rc_framerate_denom,
+			S5P_FIMV_ENC_RC_FRAME_RATE);
+	else
+		WRITEL(0, S5P_FIMV_ENC_RC_FRAME_RATE);
+
+	/* max & min value of QP */
+	reg = READL(S5P_FIMV_ENC_RC_QBOUND);
+	/** max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_264->rc_max_qp << 8);
+	/** min QP */
+	reg &= ~(0x3F);
+	reg |= p_264->rc_min_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_QBOUND);
+
+	/* macroblock adaptive scaling features */
+	if (p_264->rc_mb) {
+		reg = READL(S5P_FIMV_ENC_RC_MB_CTRL);
+		/** dark region */
+		reg &= ~(0x1 << 3);
+		reg |= (p_264->rc_mb_dark << 3);
+		/** smooth region */
+		reg &= ~(0x1 << 2);
+		reg |= (p_264->rc_mb_smooth << 2);
+		/** static region */
+		reg &= ~(0x1 << 1);
+		reg |= (p_264->rc_mb_static << 1);
+		/** high activity region */
+		reg &= ~(0x1);
+		reg |= p_264->rc_mb_activity;
+		WRITEL(reg, S5P_FIMV_ENC_RC_MB_CTRL);
+	}
+
+	if (!p->rc_frame &&
+	    !p_264->rc_mb) {
+		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
+		shm |= (p_264->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+	}
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	/** AR VUI control */
+	shm &= ~(0x1 << 15);
+	shm |= (p_264->vui_sar << 1);
+	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+
+	if (p_264->vui_sar) {
+		/* aspect ration IDC */
+		shm = s5p_mfc_read_shm(ctx, SAMPLE_ASPECT_RATIO_IDC);
+		shm &= ~(0xFF);
+		shm |= p_264->vui_sar_idc;
+		s5p_mfc_write_shm(ctx, shm, SAMPLE_ASPECT_RATIO_IDC);
+
+		if (p_264->vui_sar_idc == 0xFF) {
+			/* sample  AR info */
+			shm = s5p_mfc_read_shm(ctx, EXTENDED_SAR);
+			shm &= ~(0xFFFFFFFF);
+			shm |= p_264->vui_ext_sar_width << 16;
+			shm |= p_264->vui_ext_sar_height;
+			s5p_mfc_write_shm(ctx, shm, EXTENDED_SAR);
+		}
+	}
+
+	/* intra picture period for H.264 */
+	shm = s5p_mfc_read_shm(ctx, H264_I_PERIOD);
+	/** control */
+	shm &= ~(0x1 << 16);
+	shm |= (p_264->open_gop << 16);
+	/** value */
+	if (p_264->open_gop) {
+		shm &= ~(0xFFFF);
+		shm |= p_264->open_gop_size;
+	}
+	s5p_mfc_write_shm(ctx, shm, H264_I_PERIOD);
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	/** vbv buffer size */
+	if (p->frame_skip_mode == V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p_264->cpb_size << 16);
+	}
+	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
+	unsigned int reg;
+	unsigned int shm;
+	unsigned int framerate;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/** num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p->num_b_frame << 16);
+	WRITEL(reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+
+	/* profile & level */
+	reg = READL(S5P_FIMV_ENC_PROFILE);
+	/** level */
+	reg &= ~(0xFF << 8);
+	reg |= (p_mpeg4->level << 8);
+	/** profile - 0 ~ 2 */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->profile;
+	WRITEL(reg, S5P_FIMV_ENC_PROFILE);
+
+	/* quarter_pixel */
+	WRITEL(p_mpeg4->quarter_pixel, S5P_FIMV_ENC_MPEG4_QUART_PXL);
+
+	/* qp */
+	if (!p->rc_frame) {
+		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 6);
+		shm |= (p_mpeg4->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+	}
+
+	/* frame rate */
+	if (p->rc_frame) {
+		if (p_mpeg4->vop_frm_delta > 0) {
+			framerate = p_mpeg4->vop_time_res * 1000 /
+						p_mpeg4->vop_frm_delta;
+			WRITEL(framerate,
+				S5P_FIMV_ENC_RC_FRAME_RATE);
+			shm = s5p_mfc_read_shm(ctx, RC_VOP_TIMING);
+			shm &= ~(0xFFFFFFFF);
+			shm |= (1 << 31);
+			shm |= ((p_mpeg4->vop_time_res & 0x7FFF) << 16);
+			shm |= (p_mpeg4->vop_frm_delta & 0xFFFF);
+			s5p_mfc_write_shm(ctx, shm, RC_VOP_TIMING);
+		}
+	} else {
+		WRITEL(0, S5P_FIMV_ENC_RC_FRAME_RATE);
+	}
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_ENC_RC_CONFIG);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_frame_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_CONFIG);
+
+	/* max & min value of QP */
+	reg = READL(S5P_FIMV_ENC_RC_QBOUND);
+	/** max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_mpeg4->rc_max_qp << 8);
+	/** min QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_min_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_QBOUND);
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	/** vbv buffer size */
+	if (p->frame_skip_mode == V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p->vbv_size << 16);
+	}
+	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_h263 = &p->codec.mpeg4;
+	unsigned int reg;
+	unsigned int shm;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* qp */
+	if (!p->rc_frame) {
+		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= (p_h263->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_denom)
+		WRITEL(p->rc_framerate_num * 1000 / p->rc_framerate_denom,
+			S5P_FIMV_ENC_RC_FRAME_RATE);
+	else
+		WRITEL(0, S5P_FIMV_ENC_RC_FRAME_RATE);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_ENC_RC_CONFIG);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_frame_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_CONFIG);
+
+	/* max & min value of QP */
+	reg = READL(S5P_FIMV_ENC_RC_QBOUND);
+	/** max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_h263->rc_max_qp << 8);
+	/** min QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_min_qp;
+	WRITEL(reg, S5P_FIMV_ENC_RC_QBOUND);
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	/** vbv buffer size */
+	if (p->frame_skip_mode == V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p->vbv_size << 16);
+	}
+	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Initialize decoding */
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no, S5P_FIMV_CH_SEQ_HEADER);
+	s5p_mfc_set_shared_buffer(ctx);
+	mfc_debug(2, "BUFs: %08x %08x %08x %08x %08x\n",
+		  READL(S5P_FIMV_SI_CH0_DESC_ADR),
+		  READL(S5P_FIMV_SI_CH0_CPB_SIZE),
+		  READL(S5P_FIMV_SI_CH0_DESC_SIZE),
+		  READL(S5P_FIMV_SI_CH0_SB_ST_ADR),
+		  READL(S5P_FIMV_SI_CH0_SB_FRM_SIZE));
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC) {
+		mfc_debug(2, "Set loop filter to: %d\n", ctx->loop_filter_mpeg4);
+		WRITEL(ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
+	} else {
+		WRITEL(0, S5P_FIMV_ENC_LF_CTRL);
+	}
+	WRITEL(((ctx->slice_interface & S5P_FIMV_SLICE_INT_MASK) <<
+		S5P_FIMV_SLICE_INT_SHIFT) | (ctx->display_delay_enable <<
+		S5P_FIMV_DDELAY_ENA_SHIFT) | ((ctx->display_delay &
+		S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
+		S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	WRITEL(
+	((S5P_FIMV_CH_SEQ_HEADER & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	mfc_debug_leave();
+	return 0;
+}
+
+static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	if (flush)
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (
+			S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
+	else
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
+			~(S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
+	WRITEL(dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, enum s5p_mfc_decode_arg last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug(2, "Setting flags to %08lx (free:%d WTF:%d)\n",
+				ctx->dec_dst_flag, ctx->dst_queue_cnt,
+						ctx->dst_bufs_cnt);
+	WRITEL(ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
+	s5p_mfc_set_shared_buffer(ctx);
+	s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	switch(last_frame) {
+	case MFC_DEC_FRAME:
+		WRITEL(((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT ) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_LAST_FRAME:
+		WRITEL(((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_RES_CHANGE:
+		WRITEL(((S5P_FIMV_CH_FRAME_START_REALLOC & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	}
+	mfc_debug(2, "Decoding a usual frame.\n");
+	return 0;
+}
+
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug(2, "++\n");
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		s5p_mfc_set_enc_params_h264(ctx);
+	else if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_ENC)
+		s5p_mfc_set_enc_params_mpeg4(ctx);
+	else if (ctx->codec_mode == S5P_FIMV_CODEC_H263_ENC)
+		s5p_mfc_set_enc_params_h263(ctx);
+	else {
+		mfc_err("Unknown codec for encoding (%x).\n",
+			ctx->codec_mode);
+		return -EINVAL;
+	}
+
+	s5p_mfc_set_shared_buffer(ctx);
+
+	WRITEL(((S5P_FIMV_CH_SEQ_HEADER << 16) & 0x70000) | (ctx->inst_no),
+		S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug(2, "--\n");
+
+	return 0;
+}
+
+/* Encode a single frame */
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug(2, "++\n");
+
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
+		WRITEL(0, S5P_FIMV_ENC_MAP_FOR_CUR);
+	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		WRITEL(3, S5P_FIMV_ENC_MAP_FOR_CUR);
+
+	s5p_mfc_set_shared_buffer(ctx);
+
+	WRITEL((S5P_FIMV_CH_FRAME_START << 16 & 0x70000) | (ctx->inst_no),
+		S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug(2, "--\n");
+
+	return 0;
+}
+
+static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
+{
+	unsigned long flags;
+	int new_ctx;
+	int cnt;
+
+	spin_lock_irqsave(&dev->condlock, flags);
+	mfc_debug(2, "Previos context: %d (bits %08lx)\n", dev->curr_ctx,
+							dev->ctx_work_bits);
+	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
+	cnt = 0;
+	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
+		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
+		cnt++;
+		if (cnt > MFC_NUM_CONTEXTS) {
+			/* No contexts to run */
+			spin_unlock_irqrestore(&dev->condlock, flags);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	return new_ctx;
+}
+
+static inline void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame(ctx, MFC_DEC_RES_CHANGE);
+}
+
+static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+	unsigned int index;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "No src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	temp_vb->used = 1;
+
+	mfc_debug(2, "Temp vb: %p\n", temp_vb);
+	mfc_debug(2, "Src Addr: 0x%zx\n", vb2_dma_contig_plane_paddr(temp_vb->b, 0));
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_dma_contig_plane_paddr(temp_vb->b, 0),
+		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	index = temp_vb->b->v4l2_buf.index;
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+		last_frame = MFC_DEC_LAST_FRAME;
+		mfc_debug(2, "Setting ctx->state to FINISHING\n");
+		ctx->state = MFCINST_FINISHING;
+	}
+	s5p_mfc_decode_one_frame(ctx, last_frame);
+
+	return 0;
+}
+
+static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "no src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	if (list_empty(&ctx->dst_queue)) {
+		mfc_debug(2, "no dst buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_mb->used = 1;
+	src_y_addr = vb2_dma_contig_plane_paddr(src_mb->b, 0);
+	src_c_addr = vb2_dma_contig_plane_paddr(src_mb->b, 1);
+
+	mfc_debug(2, "enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug(2, "enc src c addr: 0x%08lx", src_c_addr);
+
+	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_mb->used = 1;
+	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_encode_one_frame(ctx);
+
+	return 0;
+}
+
+static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+
+	/* Initializing decoding - parsing header */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	mfc_debug(2, "Preparing to init decoding.\n");
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	s5p_mfc_set_dec_desc_buffer(ctx);
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_dma_contig_plane_paddr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	mfc_debug(2, "paddr: %08x\n",
+			(int)phys_to_virt(vb2_dma_contig_plane_paddr(temp_vb->b, 0)));
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_decode(ctx);
+}
+
+static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long dst_addr;
+	unsigned int dst_size;
+
+	s5p_mfc_set_enc_ref_buffer(ctx);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_paddr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dev->curr_ctx = ctx->num;
+	mfc_debug(2, "paddr: %08x\n",
+			(int)phys_to_virt(vb2_dma_contig_plane_paddr(dst_mb->b, 0)));
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_encode(ctx);
+}
+
+static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+	int ret;
+	/* Header was parsed now starting processing
+	 * First set the output frame buffers
+	 * s5p_mfc_alloc_dec_buffers(ctx); */
+
+	mfc_debug(1, "cap state: %d (should be %d)\n", ctx->capture_state, QUEUE_BUFS_MMAPED);
+
+	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
+		mfc_err("It seems that not all destionation buffers were "
+			"mmaped.\nMFC requires that all destination are mmaped "
+			"before starting processing.\n");
+		return -EAGAIN;
+	}
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (list_empty(&ctx->src_queue)) {
+		mfc_err("Header has been deallocated in the middle of "
+							"initialization.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EIO;
+	}
+
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_dma_contig_plane_paddr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_dec_frame_buffer(ctx);
+	if (ret) {
+		mfc_err("Failed to alloc frame mem.\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+/* Try running an operation on hardware */
+void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned int ret = 0;
+
+	mfc_debug(1, "Try run dev: %p\n", dev);
+
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug(1, "Couldn't lock HW.\n");
+		return;
+	}
+
+	/* Choose the context to run */
+	new_ctx = s5p_mfc_get_new_ctx(dev);
+	if (new_ctx < 0) {
+		/* No contexts to run */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware.\n");
+			return;
+		}
+
+		mfc_debug(1, "No ctx is scheduled to be run.\n");
+		return;
+	}
+
+	mfc_debug(1, "New context: %d\n", new_ctx);
+	ctx = dev->ctx[new_ctx];
+	mfc_debug(1, "Seting new context to %p\n", ctx);
+	/* Got context to run in ctx */
+	mfc_debug(1, "ctx->dst_queue_cnt=%d ctx->dpb_count=%d ctx->src_queue_cnt=%d\n",
+		ctx->dst_queue_cnt, ctx->dpb_count, ctx->src_queue_cnt);
+	mfc_debug(1, "ctx->state=%d\n", ctx->state);
+	/* Last frame has already been sent to MFC
+	 * Now obtaining frames from MFC buffer */
+
+	s5p_mfc_clock_on();
+
+	if (ctx->type == MFCINST_DECODER) {
+		s5p_mfc_set_dec_desc_buffer(ctx);
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+			s5p_mfc_run_dec_frame(ctx, MFC_DEC_LAST_FRAME);
+			break;
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
+			break;
+		case MFCINST_INIT:
+			ret = s5p_mfc_open_inst(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_close_inst(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_HEAD_PARSED:
+			mfc_debug(1, "Before head parsed\n");
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			mfc_debug(1, "After head parsed\n");
+			break;
+		case MFCINST_RES_CHANGE_INIT:
+			s5p_mfc_run_res_change(ctx);
+			break;
+		case MFCINST_RES_CHANGE_FLUSH:
+			s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
+			break;
+		case MFCINST_RES_CHANGE_END:
+			mfc_debug(2, "Finished remaining frames after resolution change.\n");
+			ctx->capture_state = QUEUE_FREE;
+			mfc_debug(2, "Will re-init the codec`.\n");
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else if (ctx->type == MFCINST_ENCODER) {
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_enc_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			ret = s5p_mfc_open_inst(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_close_inst(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_enc(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else {
+		mfc_err("invalid context type: %d\n", ctx->type);
+		ret = -EAGAIN;
+	}
+
+	if (ret) {
+		/* Free hardware lock */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware.\n");
+		}
+
+		/* This is in deed imporant, as no operation has been
+		 * scheduled, reduce the clock count as no one will
+		 * ever do this, because no interrupt related to this try_run
+		 * will ever come from hardware. */
+		s5p_mfc_clock_off();
+	}
+}
+
+
+void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
+{
+	struct s5p_mfc_buf *b;
+	int i;
+
+	while (!list_empty(lh)) {
+		b = list_entry(lh->next, struct s5p_mfc_buf, list);
+		for (i = 0; i < b->b->num_planes; i++)
+			vb2_set_plane_payload(b->b, i, 0);
+		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		list_del(&b->list);
+	}
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
new file mode 100644
index 0000000..3c39e56
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -0,0 +1,88 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_opr.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains declarations of hw related functions.
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_OPR_H_
+#define S5P_MFC_OPR_H_
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_mem.h"
+
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *mfc_ctx);
+
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+						  unsigned int start_num_byte,
+						  unsigned int buf_size);
+
+void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr);
+int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size);
+void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr);
+int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *mfc_ctx);
+
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
+					enum s5p_mfc_decode_arg last_frame);
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *mfc_ctx);
+
+/* Memory allocation */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
+
+int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx);
+
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx);
+
+#define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
+					S5P_FIMV_SI_DISPLAY_Y_ADR) << \
+					MFC_OFFSET_SHIFT)
+#define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
+						S5P_FIMV_SI_DISPLAY_STATUS)
+#define s5p_mfc_get_frame_type()	(readl(dev->regs_base + \
+						S5P_FIMV_DECODE_FRAME_TYPE) \
+					& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
+						S5P_FIMV_SI_CONSUMED_BYTES)
+#define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
+					S5P_FIMV_RISC2HOST_CMD) & \
+					S5P_FIMV_RISC2HOST_CMD_MASK)
+#define s5p_mfc_get_int_err()		readl(dev->regs_base + \
+						S5P_FIMV_RISC2HOST_ARG2)
+#define s5p_mfc_err_dec(x)		(((x) & S5P_FIMV_ERR_DEC_MASK) >> \
+							S5P_FIMV_ERR_DEC_SHIFT)
+#define s5p_mfc_err_dspl(x)		(((x) & S5P_FIMV_ERR_DSPL_MASK) >> \
+							S5P_FIMV_ERR_DSPL_SHIFT)
+#define s5p_mfc_get_img_width()		readl(dev->regs_base + \
+						S5P_FIMV_SI_HRESOL)
+#define s5p_mfc_get_img_height()	readl(dev->regs_base + \
+						S5P_FIMV_SI_VRESOL)
+#define s5p_mfc_get_dpb_count()		readl(dev->regs_base + \
+						S5P_FIMV_SI_BUF_NUMBER)
+#define s5p_mfc_get_inst_no()		readl(dev->regs_base + \
+						S5P_FIMV_RISC2HOST_ARG1)
+#define s5p_mfc_get_enc_strm_size()	readl(dev->regs_base + \
+						S5P_FIMV_ENC_SI_STRM_SIZE)
+#define s5p_mfc_get_enc_slice_type()	readl(dev->regs_base + \
+						S5P_FIMV_ENC_SI_SLICE_TYPE)
+
+void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
+
+void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
+
+#endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
new file mode 100644
index 0000000..aa0ddbd
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
@@ -0,0 +1,131 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/clk.h>
+
+#include <linux/platform_device.h>
+#ifdef CONFIG_PM_RUNTIME
+#include <linux/pm_runtime.h>
+#endif
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_pm.h"
+#include "s5p_mfc_mem.h"
+
+#define MFC_CLKNAME		"sclk_mfc"
+#define MFC_GATE_CLK_NAME	"mfc"
+
+#define CLK_DEBUG
+
+static struct s5p_mfc_pm *pm;
+static struct s5p_mfc_dev *p_dev;
+
+#ifdef CLK_DEBUG
+atomic_t clk_ref;
+#endif
+
+int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
+{
+	int ret = 0;
+
+	pm = &dev->pm;
+	p_dev = dev;
+
+	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
+	if (IS_ERR(pm->clock_gate)) {
+		mfc_err("Failed to get clock-gating control\n");
+		ret = -ENOENT;
+		goto err_g_ip_clk;
+	}
+
+	pm->clock = clk_get(&dev->plat_dev->dev, MFC_CLKNAME);
+	if (IS_ERR(pm->clock)) {
+		mfc_err("Failed to get MFC clock\n");
+		ret = -ENOENT;
+		goto err_g_ip_clk_2;
+	}
+
+	atomic_set(&pm->power, 0);
+
+#ifdef CONFIG_PM_RUNTIME
+	pm->device = &dev->plat_dev->dev;
+
+	pm_runtime_enable(pm->device);
+#endif
+
+#ifdef CLK_DEBUG
+	atomic_set(&clk_ref, 0);
+#endif
+	return 0;
+
+err_g_ip_clk_2:
+	clk_put(pm->clock_gate);
+err_g_ip_clk:
+	return ret;
+}
+
+void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
+{
+	clk_put(pm->clock_gate);
+	clk_put(pm->clock);
+
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_disable(pm->device);
+#endif
+}
+
+int s5p_mfc_clock_on(void)
+{
+	int ret;
+#ifdef CLK_DEBUG
+	atomic_inc(&clk_ref);
+	mfc_debug(3, "+ %d", atomic_read(&clk_ref));
+#endif
+	ret = clk_enable(pm->clock_gate);
+	return ret;
+}
+
+void s5p_mfc_clock_off(void)
+{
+#ifdef CLK_DEBUG
+	atomic_dec(&clk_ref);
+	mfc_debug(3, "- %d", atomic_read(&clk_ref));
+#endif
+
+	clk_disable(pm->clock_gate);
+}
+
+int s5p_mfc_power_on(void)
+{
+#ifdef CONFIG_PM_RUNTIME
+	return pm_runtime_get_sync(pm->device);
+#else
+	atomic_set(&pm->power, 1);
+
+	return 0;
+#endif
+}
+
+int s5p_mfc_power_off(void)
+{
+#ifdef CONFIG_PM_RUNTIME
+	return pm_runtime_put_sync(pm->device);
+#else
+	atomic_set(&pm->power, 0);
+
+	return 0;
+#endif
+}
+
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.h b/drivers/media/video/s5p-mfc/s5p_mfc_pm.h
new file mode 100644
index 0000000..0ed6e35
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_pm.h
@@ -0,0 +1,24 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_pm.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_PM_H
+#define __S5P_MFC_PM_H
+
+int s5p_mfc_init_pm(struct s5p_mfc_dev *dev);
+void s5p_mfc_final_pm(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_clock_on(void);
+void s5p_mfc_clock_off(void);
+int s5p_mfc_power_on(void);
+int s5p_mfc_power_off(void);
+
+#endif /* __S5P_MFC_PM_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_reg.c b/drivers/media/video/s5p-mfc/s5p_mfc_reg.c
new file mode 100644
index 0000000..4aabbf3
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_reg.c
@@ -0,0 +1,30 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_reg.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+ #include <linux/io.h>
+
+static void __iomem *regs;
+
+void s5p_mfc_init_reg(void __iomem *base)
+{
+	regs = base;
+}
+
+void s5p_mfc_write_reg(unsigned int data, unsigned int offset)
+{
+	writel(data, regs + offset);
+}
+
+unsigned int s5p_mfc_read_reg(unsigned int offset)
+{
+	return readl(regs + offset);
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_reg.h b/drivers/media/video/s5p-mfc/s5p_mfc_reg.h
new file mode 100644
index 0000000..ce8496a
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_reg.h
@@ -0,0 +1,126 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_reg.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_REG_H_
+#define __S5P_MFC_REG_H_
+
+#define MFC_SYS_SW_RESET_ADDR		S5P_FIMV_SW_RESET
+#define MFC_SYS_SW_RESET_MASK		0x3FF
+#define MFC_SYS_SW_RESET_SHFT		0x0
+#define MFC_SYS_R2H_INT_ADDR		S5P_FIMV_RISC_HOST_INT
+#define MFC_SYS_R2H_INT_MASK		0x1
+#define MFC_SYS_R2H_INT_SHFT		0x0
+#define MFC_SYS_H2R_CMD_ADDR		S5P_FIMV_HOST2RISC_CMD
+#define MFC_SYS_H2R_ARG1_ADDR		S5P_FIMV_HOST2RISC_ARG1
+#define MFC_SYS_CODEC_TYPE_ADDR		S5P_FIMV_HOST2RISC_ARG1
+#define MFC_SYS_INST_ID_ADDR		S5P_FIMV_HOST2RISC_ARG1
+#define MFC_SYS_FW_MEM_SIZE_ADDR	S5P_FIMV_HOST2RISC_ARG1
+#define MFC_SYS_H2R_ARG2_ADDR		S5P_FIMV_HOST2RISC_ARG2
+#define MFC_SYS_CRC_GEN_EN_ADDR		S5P_FIMV_HOST2RISC_ARG2
+#define MFC_SYS_CRC_GEN_EN_MASK		0x1
+#define MFC_SYS_CRC_GEN_EN_SHFT		0x1F
+#define MFC_SYS_ENC_PIXEL_CACHE_ADDR	S5P_FIMV_HOST2RISC_ARG2
+#define MFC_SYS_ENC_PIXEL_CACHE_MASK	0x2
+#define MFC_SYS_ENC_PIXEL_CACHE_SHFT	0x0
+#define MFC_SYS_DEC_PIXEL_CACHE_ADDR	S5P_FIMV_HOST2RISC_ARG2
+#define MFC_SYS_DEC_PIXEL_CACHE_MASK	0x2
+#define MFC_SYS_DEC_PIXEL_CACHE_SHFT	0x0
+#define MFC_SYS_H2R_ARG3_ADDR		S5P_FIMV_HOST2RISC_ARG3
+
+#define MFC_SYS_H2R_ARG4_ADDR		S5P_FIMV_HOST2RISC_ARG4
+
+#define MFC_SYS_FW_VER_YEAR_ADDR	S5P_FIMV_FW_VERSION
+#define MFC_SYS_FW_VER_YEAR_MASK	0xFF
+#define MFC_SYS_FW_VER_YEAR_SHFT	16
+#define MFC_SYS_FW_VER_MONTH_ADDR	S5P_FIMV_FW_VERSION
+#define MFC_SYS_FW_VER_MONTH_MASK	0xFF
+#define MFC_SYS_FW_VER_MONTH_SHFT	8
+#define MFC_SYS_FW_VER_DATE_ADDR	S5P_FIMV_FW_VERSION
+#define MFC_SYS_FW_VER_DATE_MASK	0xFF
+#define MFC_SYS_FW_VER_DATE_SHFT	0
+
+#define MFC_DEC_DISPLAY_Y_ADR_ADDR	S5P_FIMV_SI_DISPLAY_Y_ADR
+#define MFC_DEC_DISPLAY_Y_ADR_MASK	0xFFFFFFFF
+#define MFC_DEC_DISPLAY_Y_ADR_SHFT	S5P_FIMV_MEM_OFFSET
+#define MFC_DEC_DISPLAY_C_ADR_ADDR	S5P_FIMV_SI_DISPLAY_C_ADR
+#define MFC_DEC_DISPLAY_C_ADR_MASK	0xFFFFFFFF
+#define MFC_DEC_DISPLAY_C_ADR_SHFT	S5P_FIMV_MEM_OFFSET
+
+#define MFC_DEC_DECODE_Y_ADR_ADDR	S5P_FIMV_DECODE_Y_ADR
+#define MFC_DEC_DECODE_Y_ADR_MASK	0xFFFFFFFF
+#define MFC_DEC_DECODE_Y_ADR_SHFT	S5P_FIMV_MEM_OFFSET
+#define MFC_DEC_DECODE_C_ADR_ADDR	S5P_FIMV_DECODE_ADR
+#define MFC_DEC_DECODE_C_ADR_MASK	0xFFFFFFFF
+#define MFC_DEC_DECODE_C_ADR_SHFT	S5P_FIMV_MEM_OFFSET
+
+#define MFC_DEC_DISPLAY_STATUS_ADDR	MFC_SI_DISPLAY_STATUS
+#define MFC_DEC_DISPLAY_STATUS_MASK	0x7
+#define MFC_DEC_DISPLAY_STATUS_SHFT	0x0
+#define MFC_DEC_DISPLAY_INTERACE_ADDR	MFC_SI_DISPLAY_STATUS
+#define MFC_DEC_DISPLAY_INTERACE_MASK	0x1
+#define MFC_DEC_DISPLAY_INTERACE_SHFT	0x3
+#define MFC_DEC_DISPLAY_RES_CHG_ADDR	MFC_SI_DISPLAY_STATUS
+#define MFC_DEC_DISPLAY_RES_CHG_MASK	0x3
+#define MFC_DEC_DISPLAY_RES_CHG_SHFT	0x4
+
+#define MFC_DEC_DECODE_FRAME_TYPE_ADDR	S5P_FIMV_DECODE_FRAME_TYPE
+#define MFC_DEC_DECODE_FRAME_TYPE_MASK	0x7
+#define MFC_DEC_DECODE_FRAME_TYPE_SHFT	0
+
+#define MFC_DEC_DECODE_STATUS_ADDR	MFC_SI_DECODE_STATUS
+#define MFC_DEC_DECODE_STATUS_MASK	0x7
+#define MFC_DEC_DECODE_STATUS_SHFT	0x0
+#define MFC_DEC_DECODE_INTERACE_ADDR	MFC_SI_DECODE_STATUS
+#define MFC_DEC_DECODE_INTERACE_MASK	0x1
+#define MFC_DEC_DECODE_INTERACE_SHFT	0x3
+#define MFC_DEC_DECODE_NUM_CRC_ADDR	MFC_SI_DECODE_STATUS
+#define MFC_DEC_DECODE_NUM_CRC_MASK	0x1
+#define MFC_DEC_DECODE_NUM_CRC_SHFT	0x4
+#define MFC_DEC_DECODE_GEN_CRC_ADDR	MFC_SI_DECODE_STATUS
+#define MFC_DEC_DECODE_GEN_CRC_MASK	0x1
+#define MFC_DEC_DECODE_GEN_CRC_SHFT	0x5
+
+#define MFC_ENC_LEVEL_ADDR	MFC_ENC_PROFILE
+#define MFC_ENC_LEVEL_MASK	0xFF
+#define MFC_ENC_LEVEL_SHFT	0x8
+#define MFC_ENC_PROFILE_ADDR	MFC_ENC_PROFILE
+#define MFC_ENC_PROFILE_MASK	0x3
+#define MFC_ENC_PROFILE_SHFT	0x0
+
+#define _MFC_SET_REG(target, val)	s5p_mfc_write_reg(val, MFC_##target##_ADDR)
+#define MFC_SET_REG(target, val, shadow)					\
+	do {									\
+		shadow = s5p_mfc_read_reg(MFC_##target##_ADDR);			\
+		shadow &= ~(MFC_##target##_MASK << MFC_##target##_SHFT);	\
+		shadow |= ((val & MFC_##target##_MASK) << MFC_##target##_SHFT);	\
+		s5p_mfc_write_reg(shadow, MFC_##target##_ADDR);			\
+	} while (0)
+
+#define _MFC_GET_REG(target)	s5p_mfc_read_reg(MFC_##target##_ADDR)
+#define MFC_GET_REG(target)						\
+	((s5p_mfc_read_reg(MFC_##target##_ADDR) >> MFC_##target##_SHFT)	\
+	& MFC_##target##_MASK)
+
+#define MFC_GET_ADR(target)						\
+	(s5p_mfc_read_reg(MFC_##target##_ADR_ADDR) << MFC_##target##_ADR_SHFT)
+
+#define s5p_mfc_clear_int_flags()				\
+	do {							\
+		s5p_mfc_write_reg(0, S5P_FIMV_RISC_HOST_INT);	\
+		s5p_mfc_write_reg(0, S5P_FIMV_RISC2HOST_CMD);	\
+		s5p_mfc_write_reg(0xffff, S5P_FIMV_SI_RTN_CHID);\
+	} while (0)
+
+void s5p_mfc_init_reg(void __iomem *base);
+void s5p_mfc_write_reg(unsigned int data, unsigned int offset);
+unsigned int s5p_mfc_read_reg(unsigned int offset);
+#endif /* __S5P_MFC_REG_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
new file mode 100644
index 0000000..ec1c2ab
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
@@ -0,0 +1,55 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#ifdef CONFIG_ARCH_EXYNOS4
+#include <linux/dma-mapping.h>
+#endif
+
+#include "s5p_mfc_mem.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_common.h"
+
+int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	void *shm_alloc_ctx = dev->alloc_ctx[MFC_BANK_A_ALLOC_CTX];
+
+	ctx->shm_alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx, SHARED_BUF_SIZE);
+	if (IS_ERR(ctx->shm_alloc)) {
+		mfc_err("failed to allocate shared memory\n");
+		return PTR_ERR(ctx->shm_alloc);
+	}
+
+	/* shm_ofs only keeps the offset from base (port a) */
+	ctx->shm_ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm_alloc)
+								- dev->port_a;
+	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
+	if (!ctx->shm) {
+		vb2_dma_contig_memops.put(ctx->shm_alloc);		
+		ctx->shm_ofs = 0;
+		ctx->shm_alloc = NULL;
+
+		mfc_err("failed to virt addr of shared memory\n");
+		return -ENOMEM;
+	}
+
+	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
+	wmb();
+
+	mfc_debug(2, "shm info addr: 0x%08x, phys: 0x%08x\n",
+		 (unsigned int)ctx->shm, ctx->shm_ofs);
+
+	return 0;
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
new file mode 100644
index 0000000..95bdd0c
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
@@ -0,0 +1,86 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __S5P_MFC_SHM_H_
+#define __S5P_MFC_SHM_H_ __FILE__
+
+enum MFC_SHM_OFS
+{
+	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
+	SET_FRAME_TAG		= 0x04, /* D */
+	GET_FRAME_TAG_TOP	= 0x08, /* D */
+	GET_FRAME_TAG_BOT	= 0x0C, /* D */
+	PIC_TIME_TOP		= 0x10, /* D */
+	PIC_TIME_BOT		= 0x14, /* D */
+	START_BYTE_NUM		= 0x18, /* D */
+
+	CROP_INFO_H		= 0x20, /* D */
+	CROP_INFO_V		= 0x24, /* D */
+	EXT_ENC_CONTROL		= 0x28,	/* E */
+	ENC_PARAM_CHANGE	= 0x2C,	/* E */
+	RC_VOP_TIMING		= 0x30,	/* E, MPEG4 */
+	HEC_PERIOD		= 0x34,	/* E, MPEG4 */
+	METADATA_ENABLE		= 0x38, /* C */
+	METADATA_STATUS		= 0x3C, /* C */
+	METADATA_DISPLAY_INDEX	= 0x40,	/* C */
+	EXT_METADATA_START_ADDR	= 0x44, /* C */
+	PUT_EXTRADATA		= 0x48, /* C */
+	EXTRADATA_ADDR		= 0x4C, /* C */
+
+	ALLOC_LUMA_DPB_SIZE	= 0x64,	/* D */
+	ALLOC_CHROMA_DPB_SIZE	= 0x68,	/* D */
+	ALLOC_MV_SIZE		= 0x6C,	/* D */
+	P_B_FRAME_QP		= 0x70,	/* E */
+	SAMPLE_ASPECT_RATIO_IDC	= 0x74, /* E, H.264, depend on ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
+	EXTENDED_SAR		= 0x78, /* E, H.264, depned on ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
+	DISP_PIC_PROFILE	= 0x7C, /* D */
+	FLUSH_CMD_TYPE		= 0x80, /* C */
+	FLUSH_CMD_INBUF1	= 0x84, /* C */
+	FLUSH_CMD_INBUF2	= 0x88, /* C */
+	FLUSH_CMD_OUTBUF	= 0x8C, /* E */
+	NEW_RC_BIT_RATE		= 0x90, /* E, format as RC_BIT_RATE(0xC5A8) depend on RC_BIT_RATE_CHANGE in ENC_PARAM_CHANGE */
+	NEW_RC_FRAME_RATE	= 0x94, /* E, format as RC_FRAME_RATE(0xD0D0) depend on RC_FRAME_RATE_CHANGE in ENC_PARAM_CHANGE */
+	NEW_I_PERIOD		= 0x98, /* E, format as I_FRM_CTRL(0xC504) depend on I_PERIOD_CHANGE in ENC_PARAM_CHANGE */
+	H264_I_PERIOD		= 0x9C, /* E, H.264, open GOP */
+	RC_CONTROL_CONFIG	= 0xA0, /* E */
+	BATCH_INPUT_ADDR	= 0xA4, /* E */
+	BATCH_OUTPUT_ADDR	= 0xA8, /* E */
+	BATCH_OUTPUT_SIZE	= 0xAC, /* E */
+	MIN_LUMA_DPB_SIZE	= 0xB0, /* D */
+	DEVICE_FORMAT_ID	= 0xB4, /* C */
+	H264_POC_TYPE		= 0xB8, /* D */
+	MIN_CHROMA_DPB_SIZE	= 0xBC, /* D */
+	DISP_PIC_FRAME_TYPE	= 0xC0, /* D */
+	FREE_LUMA_DPB		= 0xC4, /* D, VC1 MPEG4 */
+	ASPECT_RATIO_INFO	= 0xC8, /* D, MPEG4 */
+	EXTENDED_PAR		= 0xCC, /* D, MPEG4 */
+	DBG_HISTORY_INPUT0	= 0xD0, /* C */
+	DBG_HISTORY_INPUT1	= 0xD4,	/* C */
+	DBG_HISTORY_OUTPUT	= 0xD8,	/* C */
+	HIERARCHICAL_P_QP	= 0xE0, /* E, H.264 */
+};
+
+int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx);
+
+#define s5p_mfc_write_shm(ctx, x, ofs)					\
+	do {								\
+		__raw_writel(x, (ctx->shm + ofs));			\
+		wmb();							\
+	} while(0)
+
+static inline u32 s5p_mfc_read_shm(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+{
+	rmb();
+	return __raw_readl(ctx->shm + ofs);
+}
+
+#endif /* __S5P_MFC_SHM_H_ */
-- 
1.6.3.3

