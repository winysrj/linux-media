Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38390 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab0LVMMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:49 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH 7/9] media: MFC: Add MFC v5.1 V4L2 driver
Date: Wed, 22 Dec 2010 20:54:43 +0900
Message-Id: <1293018885-15239-8-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
References: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-2-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-3-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-4-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-5-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-6-git-send-email-jtp.park@samsung.com>
 <1293018885-15239-7-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Multi Format Codec v5.1 is a module available on S5PC110 and S5PC210
Samsung SoCs. Hardware is capable of handling a range of video codecs
and this driver provides V4L2 interface for video decoding & encoding.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
---
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    3 +
 drivers/media/video/s5p-mfc/regs-mfc5.h      |  356 +++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 3237 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  333 +++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  622 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   94 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   42 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1349 +++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  147 ++
 13 files changed, 6273 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 1c4a24a..4b98c3e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1022,4 +1022,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	  This is a v4l2 driver for the S5P camera interface
 	  (video postprocessor)
 
+config VIDEO_SAMSUNG_S5P_MFC
+	tristate "Samsung S5P MFC 5.1 Video Codec"
+	depends on VIDEO_V4L2 && CMA && PLAT_S5P
+	select VIDEOBUF2_CMA
+	default n
+	help
+	  MFC 5.1 driver for V4L2
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 082e64c..f58870d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -171,6 +171,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/video/s5p-mfc/Makefile
new file mode 100644
index 0000000..d4f21e0
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
+s5p-mfc-y := s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
+
diff --git a/drivers/media/video/s5p-mfc/regs-mfc5.h b/drivers/media/video/s5p-mfc/regs-mfc5.h
new file mode 100644
index 0000000..08dd6c0
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc5.h
@@ -0,0 +1,356 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * This file contains definitions of MFC reigsters
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
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
+#define S5P_FIMV_START_ADDR	0x0000
+#define S5P_FIMV_END_ADDR	0xe008
+
+#define S5P_FIMV_SW_RESET	0x0000
+#define S5P_FIMV_RISC_HOST_INT	0x0008
+/* Command from HOST to RISC */
+#define S5P_FIMV_HOST2RISC_CMD	0x0030
+#define S5P_FIMV_HOST2RISC_ARG1	0x0034
+#define S5P_FIMV_HOST2RISC_ARG2	0x0038
+#define S5P_FIMV_HOST2RISC_ARG3	0x003c
+#define S5P_FIMV_HOST2RISC_ARG4	0x0040
+/* Command from RISC to HOST */
+#define S5P_FIMV_RISC2HOST_CMD	0x0044
+#define S5P_FIMV_RISC2HOST_ARG1	0x0048
+#define S5P_FIMV_RISC2HOST_ARG2	0x004c
+#define S5P_FIMV_RISC2HOST_ARG3	0x0050
+#define S5P_FIMV_RISC2HOST_ARG4	0x0054
+
+#define S5P_FIMV_FW_VERSION	0x0058
+#define S5P_FIMV_FW_Y_SHIFT	16
+#define S5P_FIMV_FW_M_SHIFT	8
+#define S5P_FIMV_FW_D_SHIFT	0
+#define S5P_FIMV_FW_MASK	0xff
+
+#define S5P_FIMV_SYS_MEM_SZ	0x005c
+#define S5P_FIMV_FW_STATUS	0x0080
+/* Memory controller register */
+#define S5P_FIMV_MC_DRAMBASE_ADR_A	0x0508
+#define S5P_FIMV_MC_DRAMBASE_ADR_B	0x050c
+#define S5P_FIMV_MC_STATUS		0x0510
+
+/* Common register */
+#define S5P_FIMV_SYS_MEM_ADR	0x0600 /* firmware buffer */
+#define S5P_FIMV_CPB_BUF_ADR	0x0604 /* stream buffer */
+#define S5P_FIMV_DESC_BUF_ADR	0x0608 /* descriptor buffer */
+/* H264 decoding */
+#define S5P_FIMV_VERT_NB_MV_ADR	0x068c /* vertical neighbor motion vector */
+#define S5P_FIMV_VERT_NB_IP_ADR	0x0690 /* neighbor pixels for intra pred */
+#define S5P_FIMV_H264_LUMA_ADR	0x0700 /* Luma0 ~ Luma18 */
+#define S5P_FIMV_H264_CHROMA_ADR	0x0600 /* Chroma0 ~ Chroma18 */
+#define S5P_FIMV_MV_ADR		0x0780 /* H264 motion vector 660 780 */
+/* H263/MPEG4/MPEG2/VC-1/ decoding */
+#define S5P_FIMV_NB_DCAC_ADR	0x068c /* neighbor AC/DC coeff. buffer */
+#define S5P_FIMV_UP_NB_MV_ADR	0x0690 /* upper neighbor motion vector buffer */
+#define S5P_FIMV_SA_MV_ADR	0x0694 /* subseq. anchor motion vector buffer */
+#define S5P_FIMV_OT_LINE_ADR	0x0698 /* overlap transform line buffer */
+#define S5P_FIMV_BITPLANE3_ADR	0x069C /* bitplane3 addr */
+#define S5P_FIMV_BITPLANE2_ADR	0x06A0 /* bitplane2 addr */
+#define S5P_FIMV_BITPLANE1_ADR	0x06A4 /* bitplane1 addr */
+#define S5P_FIMV_SP_ADR		0x06A8 /* syntax parser addr */
+#define S5P_FIMV_LUMA_ADR	0x0700 /* Luma0 ~ Luma5 */
+#define S5P_FIMV_CHROMA_ADR	0x0600 /* Chroma0 ~ Chroma5 */
+/* Encoder register */
+#define S5P_FIMV_ENC_UP_MV_ADR		0x0600 /* upper motion vector addr */
+#define S5P_FIMV_ENC_COZERO_FLAG_ADR	0x0610 /* direct cozero flag addr */
+#define S5P_FIMV_ENC_UP_INTRA_MD_ADR	0x0608 /* upper intra MD addr */
+#define S5P_FIMV_ENC_UP_INTRA_PRED_ADR	0x0740 /* upper intra PRED addr */
+#define S5P_FIMV_ENC_NB_DCAC_ADR	0x0604 /* entropy engine's neighbor
+						inform and AC/DC coeff. */
+
+#define S5P_FIMV_ENC_CUR_LUMA_ADR	0x0718 /* current Luma addr */
+#define S5P_FIMV_ENC_CUR_CHROMA_ADR	0x071C /* current Chroma addr */
+
+#define S5P_FIMV_ENC_REF0_LUMA_ADR	0x061c /* ref0 Luma addr */
+#define S5P_FIMV_ENC_REF0_CHROMA_ADR	0x0700 /* ref0 Chroma addr */
+#define S5P_FIMV_ENC_REF1_LUMA_ADR	0x0620 /* ref1 Luma addr */
+#define S5P_FIMV_ENC_REF1_CHROMA_ADR	0x0704 /* ref1 Chroma addr */
+#define S5P_FIMV_ENC_REF2_LUMA_ADR	0x0710 /* ref2 Luma addr */
+#define S5P_FIMV_ENC_REF2_CHROMA_ADR	0x0708 /* ref2 Chroma addr */
+#define S5P_FIMV_ENC_REF3_LUMA_ADR	0x0714 /* ref3 Luma addr */
+#define S5P_FIMV_ENC_REF3_CHROMA_ADR	0x070c /* ref3 Chroma addr */
+
+/* Codec common register */
+#define S5P_FIMV_ENC_HSIZE_PX		0x0818 /* frame width at encoder */
+#define S5P_FIMV_ENC_VSIZE_PX		0x081c /* frame height at encoder */
+#define S5P_FIMV_ENC_PROFILE		0x0830 /* profile register */
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
+#define S5P_FIMV_SI_DISPLAY_Y_ADR	0x2010 /* luma address of displayed pic */
+#define S5P_FIMV_SI_DISPLAY_C_ADR	0x2014 /* chroma address of displayed pic */
+#define S5P_FIMV_SI_CONSUMED_BYTES	0x2018 /* Consumed number of bytes to decode
+								a frame */
+#define S5P_FIMV_SI_DISPLAY_STATUS	0x201c /* status of decoded picture */
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
+#define S5P_FIMV_SI_DIVX311_HRESOL	0x2054 /* horizontal resolution */
+#define S5P_FIMV_SI_DIVX311_VRESOL	0x2050 /* vertical resolution */
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
+#define S5P_FIMV_DECODE_FRAME_202_FRAME		3
+#define S5P_FIMV_DECODE_FRAME_OTHER_FRAME	4
+
+/* Sizes of buffers required for decoding */
+#define S5P_FIMV_DEC_NB_IP_SIZE			(32 * 1024)
+#define S5P_FIMV_DEC_VERT_NB_MV_SIZE		(16 * 1024)
+#define S5P_FIMV_DEC_NB_DCAC_SIZE		(16 * 1024)
+#define S5P_FIMV_DEC_UPNB_MV_SIZE		(68 * 1024)
+#define S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE		(136 * 1024)
+#define S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE	(32 * 1024)
+#define S5P_FIMV_DEC_VC1_BITPLANE_SIZE		(2 * 1024)
+#define S5P_FIMV_DEC_STX_PARSER_SIZE		(68 * 1024)
+
+#define S5P_FIMV_DEC_BUF_ALIGN			(8 * 1024)
+#define S5P_FIMV_ENC_BUF_ALIGN			(8 * 1024)
+#define S5P_FIMV_NV12T_VALIGN			128
+#define S5P_FIMV_NV12T_HALIGN			32
+
+/* Sizes of buffers required for encoding */
+#define S5P_FIMV_ENC_UPMV_SIZE			(0x10000)
+#define S5P_FIMV_ENC_COLFLG_SIZE		(0x10000)
+#define S5P_FIMV_ENC_INTRAMD_SIZE		(0x10000)
+#define S5P_FIMV_ENC_INTRAPRED_SIZE		(0x4000)
+#define S5P_FIMV_ENC_NBORINFO_SIZE		(0x10000)
+#define S5P_FIMV_ENC_ACDCCOEF_SIZE		(0x10000)
+
+/* Encoder */
+#define S5P_FIMV_ENC_SI_STRM_SIZE	0x2004 /* stream size */
+#define S5P_FIMV_ENC_SI_PIC_CNT		0x2008 /* picture count */
+#define S5P_FIMV_ENC_SI_WRITE_PTR	0x200c /* write pointer */
+#define S5P_FIMV_ENC_SI_SLICE_TYPE	0x2010 /* slice type(I/P/B/IDR) */
+
+#define S5P_FIMV_ENC_SI_CH0_SB_U_ADR	0x2044 /* addr of upper stream buf */
+#define S5P_FIMV_ENC_SI_CH0_SB_L_ADR	0x2048 /* addr of lower stream buf */
+#define S5P_FIMV_ENC_SI_CH0_SB_SIZE	0x204c /* size of stream buf */
+#define S5P_FIMV_ENC_SI_CH0_CUR_Y_ADR	0x2050 /* current Luma addr */
+#define S5P_FIMV_ENC_SI_CH0_CUR_C_ADR	0x2054 /* current Chroma addr */
+#define S5P_FIMV_ENC_SI_CH0_FRAME_QP	0x2058 /* frame QP */
+#define S5P_FIMV_ENC_SI_CH0_SLICE_ARG	0x205c /* slice argument */
+
+#define S5P_FIMV_ENC_SI_CH1_SB_U_ADR	0x2084 /* addr of upper stream buf */
+#define S5P_FIMV_ENC_SI_CH1_SB_L_ADR	0x2088 /* addr of lower stream buf */
+#define S5P_FIMV_ENC_SI_CH1_SB_SIZE	0x208c /* size of stream buf */
+#define S5P_FIMV_ENC_SI_CH1_CUR_Y_ADR	0x2090 /* current Luma addr */
+#define S5P_FIMV_ENC_SI_CH1_CUR_C_ADR	0x2094 /* current Chroma addr */
+#define S5P_FIMV_ENC_SI_CH1_FRAME_QP	0x2098 /* frame QP */
+#define S5P_FIMV_ENC_SI_CH1_SLICE_ARG	0x209c /* slice argument */
+
+#define S5P_FIMV_ENC_STR_BF_U_FULL	0xc004 /* upper stream buf full */
+#define S5P_FIMV_ENC_STR_BF_U_EMPTY	0xc008 /* upper stream buf empty */
+#define S5P_FIMV_ENC_STR_BF_L_FULL	0xc00c /* lower stream buf full */
+#define S5P_FIMV_ENC_STR_BF_L_EMPTY	0xc010 /* lower stream buf empty */
+#define S5P_FIMV_ENC_STR_STATUS		0xc018 /* stream buf interrupt status */
+#define S5P_FIMV_ENC_SF_EPB_ON_CTRL	0xc054 /* stream control */
+#define S5P_FIMV_ENC_SF_BUF_CTRL	0xc058 /* buffer control */
+#define S5P_FIMV_ENC_BF_MODE_CTRL	0xc05c /* fifo level control */
+
+#define S5P_FIMV_ENC_PIC_TYPE_CTRL	0xc504 /* pic type level control */
+#define S5P_FIMV_ENC_B_RECON_WRITE_ON	0xc508 /* B frame recon write ctrl */
+#define S5P_FIMV_ENC_MSLICE_CTRL	0xc50c /* multi slice control */
+#define S5P_FIMV_ENC_MSLICE_MB		0xc510 /* MB number in the one slice */
+#define S5P_FIMV_ENC_MSLICE_BIT		0xc514 /* bit count for one slice */
+#define S5P_FIMV_ENC_CIR_CTRL		0xc518 /* number of intra refresh MB */
+#define S5P_FIMV_ENC_MAP_FOR_CUR	0xc51c /* linear or 64x32 tiled mode */
+#define S5P_FIMV_ENC_PADDING_CTRL	0xc520 /* padding control */
+#define S5P_FIMV_ENC_INT_MASK		0xc528 /* interrupt mask */
+
+#define S5P_FIMV_ENC_RC_CONFIG		0xc5a0 /* RC config */
+#define S5P_FIMV_ENC_RC_BIT_RATE	0xc5a8 /* bit rate */
+#define S5P_FIMV_ENC_RC_QBOUND		0xc5ac /* max/min QP */
+#define S5P_FIMV_ENC_RC_RPARA		0xc5b0 /* rate control reaction coeff */
+#define S5P_FIMV_ENC_RC_MB_CTRL		0xc5b4 /* MB adaptive scaling */
+
+/* Encoder for H264 */
+#define S5P_FIMV_ENC_H264_ENTRP_MODE	0xd004 /* CAVLC or CABAC */
+#define S5P_FIMV_ENC_H264_ALPHA_OFF	0xd008 /* loop filter alpha offset */
+#define S5P_FIMV_ENC_H264_BETA_OFF	0xd00c /* loop filter beta offset */
+#define S5P_FIMV_ENC_H264_NUM_OF_REF	0xd010 /* number of reference for P/B */
+#define S5P_FIMV_ENC_H264_MDINTER_WGT	0xd01c /* inter weighted parameter */
+#define S5P_FIMV_ENC_H264_MDINTRA_WGT	0xd020 /* intra weighted parameter */
+#define S5P_FIMV_ENC_H264_TRANS_FLAG	0xd034 /* 8x8 transform flag in PPS &
+								high profile */
+
+#define S5P_FIMV_ENC_RC_FRAME_RATE	0xd0d0 /* frame rate */
+
+/* Encoder for MPEG4 */
+#define S5P_FIMV_ENC_MPEG4_QUART_PXL	0xe008 /* qpel interpolation ctrl */
+
+/* Additional */
+#define S5P_FIMV_SI_CH0_DPB_CONF_CTRL	0x2068 /* DPB Config Control Register */
+#define S5P_FIMV_SLICE_INT_MASK		1
+#define S5P_FIMV_SLICE_INT_SHIFT	31
+#define S5P_FIMV_DDELAY_ENA_SHIFT	30
+#define S5P_FIMV_DDELAY_VAL_MASK	0xff
+#define S5P_FIMV_DDELAY_VAL_SHIFT	16
+#define S5P_FIMV_DPB_COUNT_MASK		0xffff
+
+#define S5P_FIMV_SI_CH0_RELEASE_BUF	0x2060 /* DPB release buffer register */
+#define S5P_FIMV_SI_CH0_HOST_WR_ADR	0x2064 /* address of shared memory */
+#define S5P_FIMV_ENC_B_RECON_WRITE_ON	0xc508 /* B frame recon write ctrl */
+#define S5P_FIMV_ENC_REF_B_LUMA_ADR	0x062c /* ref B Luma addr */
+#define S5P_FIMV_ENC_REF_B_CHROMA_ADR	0x0630 /* ref B Chroma addr */
+#define S5P_FIMV_ENCODED_Y_ADDR		0x2014 /* the address of the encoded
+							luminance picture */
+#define S5P_FIMV_ENCODED_C_ADDR		0x2018 /* the address of the encoded
+							chrominance picture*/
+
+/* Codec numbers  */
+#define S5P_FIMV_CODEC_H264_DEC		0
+#define S5P_FIMV_CODEC_VC1_DEC		1
+#define S5P_FIMV_CODEC_MPEG4_DEC	2
+#define S5P_FIMV_CODEC_MPEG2_DEC	3
+#define S5P_FIMV_CODEC_H263_DEC		4
+#define S5P_FIMV_CODEC_VC1RCV_DEC	5
+#define S5P_FIMV_CODEC_DIVX311_DEC	6
+#define S5P_FIMV_CODEC_DIVX412_DEC	7
+#define S5P_FIMV_CODEC_DIVX502_DEC	8
+#define S5P_FIMV_CODEC_DIVX503_DEC	9
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
+
+#define S5P_FIMV_CH_MASK		7
+#define S5P_FIMV_CH_SHIFT		16
+
+
+/* Host to RISC command */
+#define S5P_FIMV_H2R_CMD_EMPTY		0
+#define S5P_FIMV_H2R_CMD_OPEN_INSTANCE	1
+#define S5P_FIMV_H2R_CMD_CLOSE_INSTANCE	2
+#define S5P_FIMV_H2R_CMD_SYS_INIT	3
+
+#define S5P_FIMV_R2H_CMD_EMPTY			0
+#define S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET	1
+#define S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET	2
+#define S5P_FIMV_R2H_CMD_ERROR_RET		3
+#define S5P_FIMV_R2H_CMD_SEQ_DONE_RET		4
+#define S5P_FIMV_R2H_CMD_FRAME_DONE_RET		5
+#define S5P_FIMV_R2H_CMD_SLICE_DONE_RET		6
+#define S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET	7
+#define S5P_FIMV_R2H_CMD_SYS_INIT_RET		8
+#define S5P_FIMV_R2H_CMD_FW_STATUS_RET		9
+#define S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET	15
+#define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
+#define S5P_FIMV_R2H_CMD_DECODE_ERR_RET		32
+
+/* Error handling defines */
+#define S5P_FIMV_ERR_WARNINGS_START		145
+
+/* An offset of the start position in the stream when
+ * the start position is not aligned */
+#define S5P_FIMV_SHARED_CROP_LEFT_MASK		0xFFFF
+#define S5P_FIMV_SHARED_CROP_LEFT_SHIFT		0
+#define S5P_FIMV_SHARED_CROP_RIGHT_MASK		0xFFFF0000
+#define S5P_FIMV_SHARED_CROP_RIGHT_SHIFT	16
+#define S5P_FIMV_SHARED_CROP_INFO_V		0x0024
+#define S5P_FIMV_SHARED_CROP_TOP_MASK		0xFFFF
+#define S5P_FIMV_SHARED_CROP_TOP_SHIFT		0
+#define S5P_FIMV_SHARED_CROP_BOTTOM_MASK	0xFFFF0000
+#define S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT	16
+
+/* Shared memory registers' offsets */
+#define S5P_FIMV_SHARED_PIC_TIME_TOP		0x0010
+#define S5P_FIMV_SHARED_PIC_TIME_BOTTOM		0x0014
+#define S5P_FIMV_SHARED_START_BYTE_NUM		0x0018
+#define S5P_FIMV_SHARED_CROP_INFO_H		0x0020
+#define S5P_FIMV_SHARED_CROP_INFO_V		0x0024
+#define S5P_FIMV_SHARED_EXT_ENC_CONTROL		0x0028
+#define S5P_FIMV_SHARED_LUMA_DPB_SIZE		0x0064
+#define S5P_FIMV_SHARED_CHROMA_DPB_SIZE		0x0068
+#define S5P_FIMV_SHARED_MV_SIZE			0x006C
+#define S5P_FIMV_SHARED_P_B_FRAME_QP		0x0070
+#define S5P_FIMV_SHARED_ASPECT_RATIO_IDC	0x0074
+#define S5P_FIMV_SHARED_EXTENDED_SAR		0x0078
+#define S5P_FIMV_SHARED_H264_I_PERIOD		0x009C
+#define S5P_FIMV_SHARED_RC_CONTROL_CONFIG	0x00A0
+
+#endif /* _REGS_FIMV_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
new file mode 100644
index 0000000..2653864
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -0,0 +1,3237 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#define DEBUG
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-cma.h>
+#include <media/videobuf2-core.h>
+#include "regs-mfc5.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_memory.h"
+#include "s5p_mfc_ctrls.h"
+#include "s5p_mfc_debug.h"
+
+#define S5P_MFC_NAME		"s5p-mfc"
+#define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
+#define S5P_MFC_ENC_NAME	"s5p-mfc-enc"
+
+/* Offset base used to differentiate between CAPTURE and OUTPUT
+*  while mmaping */
+#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
+
+int debug;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+
+struct s5p_mfc_dev *dev;
+/* Order must be as defined in s5p_mfc_memory.h */
+static const char *s5p_mem_types[] = {MFC_CMA_BANK2, MFC_CMA_BANK1, MFC_CMA_FW};
+static unsigned long s5p_mem_alignments[] = {MFC_CMA_BANK2_ALIGN,
+					MFC_CMA_BANK1_ALIGN, MFC_CMA_FW_ALIGN};
+
+
+/* Function prototypes */
+static void s5p_mfc_try_run(void);
+
+/* Helper functions for interrupt processing */
+/* Remove from hw execution round robin */
+static inline void clear_work_bit(struct s5p_mfc_ctx *ctx)
+{
+	spin_lock(&dev->condlock);
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock(&dev->condlock);
+}
+
+/* Wake up context wait_queue */
+static inline void wake_up_ctx(struct s5p_mfc_ctx *ctx,
+	unsigned int reason, unsigned int err)
+{
+	ctx->int_cond = 1;
+	ctx->int_type = reason;
+	ctx->int_err = err;
+	if (ctx->state != MFCINST_ABORT)
+		wake_up_interruptible(&ctx->queue);
+	else
+		wake_up(&ctx->queue);
+}
+
+/* Wake up device wait_queue */
+static inline void wake_up_dev(unsigned int reason, unsigned int err)
+{
+	dev->int_cond = 1;
+	dev->int_type = reason;
+	dev->int_err = err;
+	wake_up_interruptible(&dev->queue);
+}
+
+void s5p_mfc_error_cleanup_queue(struct list_head *lh,
+						struct vb2_queue *vq)
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
+void s5p_mfc_watchdog(unsigned long arg)
+{
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
+	struct s5p_mfc_ctx *ctx;
+	int i, ret;
+	int mutex_locked;
+	unsigned long flags;
+
+	mfc_err("Driver timeout error handling.\n");
+	/* Lock the mutex that protects open and release.
+	 * This is necessary as they may load and unload firmware. */
+	mutex_locked = mutex_trylock(dev->mfc_mutex);
+	if (!mutex_locked)
+		mfc_err("This is not good. Some instance may be "
+							"closing/opening.\n");
+	spin_lock_irqsave(&dev->irqlock, flags);
+	clk_disable(dev->clock1);
+	clk_disable(dev->clock2);
+	for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
+		ctx = dev->ctx[i];
+		if (ctx) {
+			ctx->state = MFCINST_ERROR;
+			s5p_mfc_error_cleanup_queue(&ctx->dst_queue,
+				&ctx->vq_dst);
+			s5p_mfc_error_cleanup_queue(&ctx->src_queue,
+				&ctx->vq_src);
+			clear_work_bit(ctx);
+			wake_up_ctx(ctx, S5P_FIMV_R2H_CMD_DECODE_ERR_RET, 0);
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
+				mutex_unlock(dev->mfc_mutex);
+			return;
+		}
+		clk_enable(dev->clock1);
+		clk_enable(dev->clock2);
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0) {
+			mfc_err("Failed to reinit FW.\n");
+			if (mutex_locked)
+				mutex_unlock(dev->mfc_mutex);
+			return;
+		}
+	}
+	if (mutex_locked)
+		mutex_unlock(dev->mfc_mutex);
+}
+
+/* Check whether a context should be run on hardware */
+int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
+{
+	mfc_debug("s5p_mfc_ctx_ready: src=%d, dst=%d, "
+		"state=%d capstat=%d\n", ctx->src_queue_cnt, ctx->dst_queue_cnt,
+			ctx->state, ctx->capture_state);
+	if (ctx->type == MFCINST_DECODER) {
+		/* Context is to parse header */
+		if (ctx->src_queue_cnt >= 1 && ctx->state == MFCINST_GOT_INST)
+			return 1;
+		/* Context is to decode a frame */
+		if (ctx->src_queue_cnt >= 1 &&
+		    ctx->state == MFCINST_RUNNING &&
+		    ctx->dst_queue_cnt >= ctx->dpb_count)
+			return 1;
+		/* Context is to return last frame */
+		if (ctx->state == MFCINST_FINISHING &&
+		    ctx->dst_queue_cnt >= ctx->dpb_count)
+			return 1;
+		/* Context is to set buffers */
+		if (ctx->src_queue_cnt >= 1 &&
+		    ctx->state == MFCINST_HEAD_PARSED &&
+		    ctx->capture_state == QUEUE_BUFS_MMAPED)
+			return 1;
+	} else if (ctx->type == MFCINST_ENCODER) {
+		/* context is to make header */
+		if (ctx->state == MFCINST_GOT_INST && ctx->dst_queue_cnt >= 1)
+			return 1;
+		/* context is to encode a freame */
+		if (ctx->state == MFCINST_RUNNING &&
+			ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
+			return 1;
+	} else {
+		mfc_err("invalid context type: %d\n", ctx->type);
+		return 0;
+	}
+	mfc_debug("s5p_mfc_ctx_ready: ctx is not ready.\n");
+	return 0;
+}
+
+static inline enum s5p_mfc_node_type s5p_mfc_get_node_type(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (!vdev) {
+		mfc_err("failed to get video_device");
+		return MFCNODE_INVALID;
+	}
+
+	mfc_debug("video_device index: %d\n", vdev->index);
+
+	if (vdev->index == 0)
+		return MFCNODE_DECODER;
+	else if (vdev->index == 1)
+		return MFCNODE_ENCODER;
+	else
+		return MFCNODE_INVALID;
+}
+
+static struct s5p_mfc_codec_ops decoder_codec_ops = {
+	.pre_seq_start		= NULL,
+	.post_seq_start		= NULL,
+	.pre_frame_start	= NULL,
+	.post_frame_start	= NULL,
+};
+
+static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_cma_plane_paddr(dst_mb->b, 0);
+	dst_size = dst_mb->b->v4l2_planes[0].bytesused;
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	return 0;
+}
+
+static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_buf *dst_mb;
+
+	mfc_debug("seq header size: %d", s5p_mfc_get_enc_strm_size());
+
+	if (p->seq_hdr_mode == V4L2_CODEC_MFC51_ENC_SEQ_HDR_MODE_SEQ) {
+		spin_lock_irqsave(&dev->irqlock, flags);
+
+		dst_mb = list_entry(ctx->dst_queue.next,
+				struct s5p_mfc_buf, list);
+		list_del(&dst_mb->list);
+		ctx->dst_queue_cnt--;
+
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+
+		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+	}
+
+	ctx->state = MFCINST_RUNNING;
+
+	return 0;
+}
+
+static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_y_addr = vb2_cma_plane_paddr(src_mb->b, 0);
+	src_c_addr = vb2_cma_plane_paddr(src_mb->b, 1);
+	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mfc_debug("enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug("enc src c addr: 0x%08lx", src_c_addr);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_cma_plane_paddr(dst_mb->b, 0);
+	dst_size = dst_mb->b->v4l2_planes[0].bytesused;
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mfc_debug("enc dst addr: 0x%08lx", dst_addr);
+
+	return 0;
+}
+
+static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *src_mb;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long enc_y_addr, enc_c_addr;
+	unsigned long src_y_addr, src_c_addr;
+
+	mfc_debug("encoded stream size: %d", s5p_mfc_get_enc_strm_size());
+	mfc_debug("encoded slice type: %d", s5p_mfc_get_enc_slice_type());
+
+	s5p_mfc_get_enc_frame_buffer(ctx, &enc_y_addr, &enc_c_addr);
+
+	mfc_debug("encoded y addr: 0x%08lx", enc_y_addr);
+	mfc_debug("encoded c addr: 0x%08lx", enc_c_addr);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	list_for_each_entry(src_mb, &ctx->src_queue, list) {
+		src_y_addr = vb2_cma_plane_paddr(src_mb->b, 0);
+		src_c_addr = vb2_cma_plane_paddr(src_mb->b, 1);
+
+		mfc_debug("enc src y addr: 0x%08lx", src_y_addr);
+		mfc_debug("enc src c addr: 0x%08lx", src_c_addr);
+
+		if ((enc_y_addr == src_y_addr) && (enc_c_addr == src_c_addr)) {
+			list_del(&src_mb->list);
+			ctx->src_queue_cnt--;
+
+			vb2_buffer_done(src_mb->b, VB2_BUF_STATE_DONE);
+			break;
+		}
+	}
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	list_del(&dst_mb->list);
+	ctx->dst_queue_cnt--;
+	vb2_set_plane_payload(dst_mb->b, 0, s5p_mfc_get_enc_strm_size());
+	vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+		clear_work_bit(ctx);
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
+/* Query control */
+static struct v4l2_queryctrl *get_ctrl(int id)
+{
+	int i;
+
+	for (i = 0; i < NUM_CTRLS; ++i)
+		if (id == s5p_mfc_ctrls[i].id)
+			return &s5p_mfc_ctrls[i];
+	return NULL;
+}
+
+/* Query capabilities of the device */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
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
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out,
+						enum s5p_mfc_node_type node)
+{
+	struct s5p_mfc_fmt *fmt;
+	int i, j = 0;
+
+	if (node == MFCNODE_INVALID)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (mplane && formats[i].num_planes == 1)
+			continue;
+		else if (!mplane && formats[i].num_planes > 1)
+			continue;
+		if (node == MFCNODE_DECODER) {
+			if (out && formats[i].type != MFC_FMT_DEC)
+				continue;
+			else if (!out && formats[i].type != MFC_FMT_RAW)
+				continue;
+		} else if (node == MFCNODE_ENCODER) {
+			if (out && formats[i].type != MFC_FMT_RAW)
+				continue;
+			else if (!out && formats[i].type != MFC_FMT_ENC)
+				continue;
+		}
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
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, false, s5p_mfc_get_node_type(file));
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, false, s5p_mfc_get_node_type(file));
+}
+
+static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false, true, s5p_mfc_get_node_type(file));
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+							struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true, true, s5p_mfc_get_node_type(file));
+}
+
+/* Get format */
+static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug_enter();
+	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state == MFCINST_GOT_INST) {
+		/* If the MFC is parsing the header,
+		 * so wait until it is finished */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+									1);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state >= MFCINST_HEAD_PARSED &&
+	    ctx->state <= MFCINST_ABORT) {
+		/* This is run on CAPTURE (deocde output) */
+		/* Width and height are set to the dimensions
+		   of the movie, the buffer is bigger and
+		   further processing stages should crop to this
+		   rectangle. */
+		f->fmt.pix_mp.width = ctx->buf_width;
+		f->fmt.pix_mp.height = ctx->buf_height;
+		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
+		f->fmt.pix_mp.num_planes = 2;
+		/* Set pixelformat to the format in which MFC
+		   outputs the decoded frame */
+		f->fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->buf_width;
+		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->luma_size;
+		f->fmt.pix_mp.plane_fmt[1].bytesperline = ctx->buf_width;
+		f->fmt.pix_mp.plane_fmt[1].sizeimage = ctx->chroma_size;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* This is run on OUTPUT
+		   The buffer contains compressed image
+		   so width and height have no meaning */
+		f->fmt.pix_mp.width = 1;
+		f->fmt.pix_mp.height = 1;
+		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->dec_src_buf_size;
+		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->dec_src_buf_size;
+		f->fmt.pix_mp.pixelformat = ctx->src_fmt->fourcc;
+		f->fmt.pix_mp.num_planes = ctx->src_fmt->num_planes;
+	} else {
+		mfc_err("Format could not be read\n");
+		mfc_debug("%s-- with error\n", __func__);
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+static int vidioc_g_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug_enter();
+
+	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		/* This is run on OUTPUT (encoder dest) */
+		f->fmt.pix_mp.width = 1;
+		f->fmt.pix_mp.height = 1;
+		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
+		f->fmt.pix_mp.pixelformat = ctx->dst_fmt->fourcc;
+		f->fmt.pix_mp.num_planes = ctx->dst_fmt->num_planes;
+
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->enc_dst_buf_size;
+		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->enc_dst_buf_size;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* This is run on CAPTURE (encoder src) */
+		f->fmt.pix_mp.width = ctx->img_width;
+		f->fmt.pix_mp.height = ctx->img_height;
+		f->fmt.pix_mp.field = V4L2_FIELD_NONE;
+		f->fmt.pix_mp.pixelformat = ctx->src_fmt->fourcc;
+		f->fmt.pix_mp.num_planes = ctx->src_fmt->num_planes;
+
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = ctx->buf_width;
+		f->fmt.pix_mp.plane_fmt[0].sizeimage = ctx->luma_size;
+		f->fmt.pix_mp.plane_fmt[1].bytesperline = ctx->buf_width;
+		f->fmt.pix_mp.plane_fmt[1].sizeimage = ctx->chroma_size;
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
+/* Try format */
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug("Type is %d\n", f->type);
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Currently only decoding is supported.\n");
+		return -EINVAL;
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_DEC);
+		if (!fmt) {
+			mfc_err("Unsupported format.\n");
+			return -EINVAL;
+		}
+		if (f->fmt.pix_mp.plane_fmt[0].sizeimage == 0) {
+			mfc_err("Application is required to "
+				"specify input buffer size (via sizeimage)\n");
+			return -EINVAL;
+		}
+		/* As this buffer will contain compressed data, the size is set
+		 * to the maximum size.
+		 * Width and height are left intact as they may be relevant for
+		 * DivX 3.11 decoding. */
+		f->fmt.pix_mp.plane_fmt[0].bytesperline =
+					f->fmt.pix_mp.plane_fmt[0].sizeimage;
+	}
+	return 0;
+}
+
+static int vidioc_try_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_ENC);
+		if (!fmt) {
+			mfc_err("failed to try output format\n");
+			return -EINVAL;
+		}
+
+		if (f->fmt.pix_mp.plane_fmt[0].sizeimage == 0) {
+			mfc_err("must be set encoding output size\n");
+			return -EINVAL;
+		}
+
+		f->fmt.pix_mp.plane_fmt[0].bytesperline =
+			f->fmt.pix_mp.plane_fmt[0].sizeimage;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("failed to try output format\n");
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
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
+/* Set format */
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	unsigned long flags;
+	int ret = 0;
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug_enter();
+	ret = vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_DEC);
+		if (!fmt || fmt->codec_mode == MFC_FORMATS_NO_CODEC) {
+			mfc_err("Unknown codec.\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		ctx->src_fmt = fmt;
+		ctx->codec_mode = fmt->codec_mode;
+		mfc_debug("The codec number is: %d\n", ctx->codec_mode);
+		ctx->pix_format = f->fmt.pix_mp.pixelformat;
+		if (f->fmt.pix_mp.pixelformat != V4L2_PIX_FMT_DIVX3) {
+			f->fmt.pix_mp.height = 1;
+			f->fmt.pix_mp.width = 1;
+		} else {
+			ctx->img_height = f->fmt.pix_mp.height;
+			ctx->img_width = f->fmt.pix_mp.width;
+		}
+		mfc_debug("s_fmt w/h: %dx%d, ctx: %dx%d\n", f->fmt.pix_mp.width,
+			f->fmt.pix_mp.height, ctx->img_width, ctx->img_height);
+		ctx->dec_src_buf_size =	f->fmt.pix_mp.plane_fmt[0].sizeimage;
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
+		ctx->state = MFCINST_INIT;
+		ctx->dst_bufs_cnt = 0;
+		ctx->src_bufs_cnt = 0;
+		ctx->capture_state = QUEUE_FREE;
+		ctx->output_state = QUEUE_FREE;
+		s5p_mfc_alloc_instance_buffer(ctx);
+		s5p_mfc_alloc_dec_temp_buffers(ctx);
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_try_run();
+		if (s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+			/* Error or timeout */
+			mfc_err("Error getting instance from hardware.\n");
+			s5p_mfc_release_instance_buffer(ctx);
+			s5p_mfc_release_dec_desc_buffer(ctx);
+			ret = -EIO;
+			goto out;
+		}
+		mfc_debug("Got instance number: %d\n", ctx->inst_no);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_err("Currently only decoding is supported.\n");
+		ret = -EINVAL;
+	}
+out:
+	mfc_debug_leave();
+	return ret;
+}
+
+static int vidioc_s_fmt_enc(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	unsigned long flags;
+	int ret = 0;
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug_enter();
+
+	ret = vidioc_try_fmt_enc(file, priv, f);
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
+		mfc_debug("codec number: %d\n", ctx->dst_fmt->codec_mode);
+
+		ctx->enc_dst_buf_size =	f->fmt.pix_mp.plane_fmt[0].sizeimage;
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
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
+		s5p_mfc_try_run();
+		if (s5p_mfc_wait_for_done_ctx(ctx, \
+				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+			/* Error or timeout */
+			mfc_err("Error getting instance from hardware.\n");
+			s5p_mfc_release_instance_buffer(ctx);
+			ret = -EIO;
+			goto out;
+		}
+		mfc_debug("Got instance number: %d\n", ctx->inst_no);
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("failed to set output format\n");
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
+			mfc_err("failed to set output format\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ctx->src_fmt = fmt;
+		ctx->img_width = f->fmt.pix_mp.width;
+		ctx->img_height = f->fmt.pix_mp.height;
+
+		mfc_debug("codec number: %d\n", ctx->src_fmt->codec_mode);
+		mfc_debug("fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
+			f->fmt.pix_mp.width, f->fmt.pix_mp.height,
+			ctx->img_width, ctx->img_height);
+
+		ctx->buf_width = f->fmt.pix_mp.plane_fmt[0].bytesperline;
+		ctx->luma_size = f->fmt.pix_mp.plane_fmt[0].sizeimage;
+		ctx->buf_width = f->fmt.pix_mp.plane_fmt[1].bytesperline;
+		ctx->chroma_size = f->fmt.pix_mp.plane_fmt[1].sizeimage;
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
+/* Reqeust buffers */
+static int vidioc_reqbufs(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+	unsigned long flags;
+
+	mfc_debug_enter();
+	mfc_debug("Memory type: %d\n", reqbufs->memory);
+	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only V4L2_MEMORY_MAP is supported.\n");
+		return -EINVAL;
+	}
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* Can only request buffers after an instance has been opened.*/
+		if (ctx->state == MFCINST_GOT_INST) {
+			/* Decoding */
+			if (ctx->output_state != QUEUE_FREE) {
+				mfc_err("Bufs have already been requested.\n");
+				return -EINVAL;
+			}
+			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+			if (ret) {
+				mfc_err("vb2_reqbufs on output failed.\n");
+				return ret;
+			}
+			mfc_debug("vb2_reqbufs: %d\n", ret);
+			ctx->output_state = QUEUE_BUFS_REQUESTED;
+		}
+	}
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state != QUEUE_FREE) {
+			mfc_err("Bufs have already been requested.\n");
+			return -EINVAL;
+		}
+		ctx->capture_state = QUEUE_BUFS_REQUESTED;
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		if (ret) {
+			mfc_err("vb2_reqbufs on capture failed.\n");
+			return ret;
+		}
+		if (reqbufs->count < ctx->dpb_count) {
+			mfc_err("Not enough buffers allocated.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+		ctx->total_dpb_count = reqbufs->count;
+		ret = s5p_mfc_alloc_codec_buffers(ctx);
+		if (ret) {
+			mfc_err("Failed to allocate decoding buffers.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
+			ctx->capture_state = QUEUE_BUFS_MMAPED;
+		} else {
+			mfc_err("Not all buffers passed to buf_init.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_release_codec_buffers(ctx);
+			return -ENOMEM;
+		}
+		if (s5p_mfc_ctx_ready(ctx)) {
+			spin_lock_irqsave(&dev->condlock, flags);
+			set_bit(ctx->num, &dev->ctx_work_bits);
+			spin_unlock_irqrestore(&dev->condlock, flags);
+		}
+		s5p_mfc_try_run();
+		s5p_mfc_wait_for_done_ctx(ctx,
+					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 1);
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+static int vidioc_reqbufs_enc(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	mfc_debug("type: %d\n", reqbufs->memory);
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
+	mfc_debug("--\n");
+
+	return ret;
+}
+
+/* Query buffer */
+static int vidioc_querybuf(struct file *file, void *priv,
+						   struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret;
+	int i;
+
+	mfc_debug_enter();
+	if (buf->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only mmaped buffers can be used.\n");
+		return -EINVAL;
+	}
+	mfc_debug("State: %d, buf->type: %d\n", ctx->state, buf->type);
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
+static int vidioc_querybuf_enc(struct file *file, void *priv,
+						   struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	mfc_debug("type: %d\n", buf->memory);
+
+	/* if memory is not mmp or userptr return error */
+	if ((buf->memory != V4L2_MEMORY_MMAP) &&
+		(buf->memory != V4L2_MEMORY_USERPTR))
+		return -EINVAL;
+
+	mfc_debug("state: %d, buf->type: %d\n", ctx->state, buf->type);
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->state != MFCINST_GOT_INST) {
+			mfc_err("invalid context state: %d\n", ctx->state);
+			return -EINVAL;
+		}
+
+		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		if (ret != 0) {
+			mfc_err("error in vb2_querybuf() for E(D)\n");
+			return ret;
+		}
+
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
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug_enter();
+	mfc_debug("Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
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
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret;
+
+	mfc_debug_enter();
+	mfc_debug("Addr: %p %p %p Type: %d\n", &ctx->vq_src, buf, buf->m.planes,
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
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = -EINVAL;
+
+	mfc_debug_enter();
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamon(&ctx->vq_src, type);
+	else
+		ret = vb2_streamon(&ctx->vq_dst, type);
+	mfc_debug("ctx->src_queue_cnt = %d ctx->state = %d "
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
+	struct s5p_mfc_ctx *ctx = priv;
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
+/* Query a ctrl */
+static int vidioc_queryctrl(struct file *file, void *priv,
+			    struct v4l2_queryctrl *qc)
+{
+	struct v4l2_queryctrl *c;
+
+	c = get_ctrl(qc->id);
+	if (!c)
+		return -EINVAL;
+	*qc = *c;
+	return 0;
+}
+
+/* Get ctrl */
+static int vidioc_g_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug_enter();
+	switch (ctrl->id) {
+	case V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE:
+		ctrl->value = ctx->loop_filter_mpeg4;
+		break;
+	case V4L2_CID_CODEC_DISPLAY_DELAY:
+		ctrl->value = ctx->display_delay;
+		break;
+	case V4L2_CID_CODEC_REQ_NUM_BUFS:
+		if (ctx->state >= MFCINST_HEAD_PARSED &&
+		    ctx->state <= MFCINST_ABORT) {
+			ctrl->value = ctx->dpb_count;
+		} else if (ctx->state == MFCINST_INIT) {
+			/* Should wait for the header to be parsed */
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_wait_for_done_ctx(ctx,
+					S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 1);
+			if (ctx->state >= MFCINST_HEAD_PARSED &&
+			    ctx->state <= MFCINST_ABORT) {
+				ctrl->value = ctx->dpb_count;
+			} else {
+				v4l2_err(&dev->v4l2_dev,
+						 "Decoding not initialised.\n");
+				return -EINVAL;
+			}
+		} else {
+			v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
+			return -EINVAL;
+		}
+		break;
+	case V4L2_CID_CODEC_SLICE_INTERFACE:
+		ctrl->value = ctx->slice_interface;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Check whether a ctrl value if correct */
+static int check_ctrl_val(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
+{
+	struct v4l2_queryctrl *c;
+
+	c = get_ctrl(ctrl->id);
+	if (!c)
+		return -EINVAL;
+	if (ctrl->value < c->minimum || ctrl->value > c->maximum
+	    || (c->step != 0 && ctrl->value % c->step != 0)) {
+		v4l2_err(&dev->v4l2_dev, "Invalid control value\n");
+		return -ERANGE;
+	}
+	return 0;
+}
+
+/* Set a ctrl */
+static int vidioc_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+	int stream_on;
+
+	mfc_debug_enter();
+	stream_on = ctx->vq_src.streaming || ctx->vq_dst.streaming;
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret != 0)
+		return ret;
+	switch (ctrl->id) {
+	case V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE:
+		if (stream_on)
+			return -EBUSY;
+		ctx->loop_filter_mpeg4 = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_DISPLAY_DELAY:
+		if (stream_on)
+			return -EBUSY;
+		ctx->display_delay = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_SLICE_INTERFACE:
+		if (stream_on)
+			return -EBUSY;
+		ctx->slice_interface = ctrl->value;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+static int get_ctrl_val_enc(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
+{
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_CODEC_MFC51_ENC_STREAM_SIZE:
+		ctrl->value = ctx->enc_dst_buf_size;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_FRAME_COUNT:
+		ctrl->value = ctx->frame_count;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_FRAME_TYPE:
+		ctrl->value = ctx->frame_type;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int vidioc_g_ctrl_enc(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+
+	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
+		return -EINVAL;
+
+	ret = get_ctrl_val_enc(ctx, ctrl);
+	if (ret != 0)
+		return ret;
+
+	return ret;
+}
+
+static int set_ctrl_val_enc(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
+{
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_CODEC_MFC51_ENC_GOP_SIZE:
+		p->gop_size = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MODE:
+		p->slice_mode = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MB:
+		p->slice_mb = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_BIT:
+		p->slice_bit = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_INTRA_REFRESH_MB:
+		p->intra_refresh_mb = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_PAD_CTRL_ENABLE:
+		p->pad = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_PAD_LUMA_VALUE:
+		p->pad_luma = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_PAD_CB_VALUE:
+		p->pad_cb = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_PAD_CR_VALUE:
+		p->pad_cr = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_RC_FRAME_ENABLE:
+		p->rc_frame = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_RC_BIT_RATE:
+		p->rc_bitrate = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_RC_REACTION_COEFF:
+		p->rc_reaction_coeff = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_FORCE_FRAME_TYPE:
+		ctx->force_frame_type = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_VBV_BUF_SIZE:
+		p->vbv_buf_size = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_SEQ_HDR_MODE:
+		p->seq_hdr_mode = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_FRAME_SKIP_MODE:
+		p->frame_skip_mode = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_RC_FIXED_TARGET_BIT:
+		p->fixed_target_bit = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_B_FRAMES:
+		p->codec.h264.num_b_frame = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_PROFILE:
+		p->codec.h264.profile = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_LEVEL:
+		p->codec.h264.level = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_INTERLACE:
+		p->codec.h264.interlace = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_MODE:
+		p->codec.h264.loop_filter_mode = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_ALPHA:
+		p->codec.h264.loop_filter_alpha = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_BETA:
+		p->codec.h264.loop_filter_beta = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_ENTROPY_MODE:
+		p->codec.h264.entropy_mode = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_MAX_REF_PIC:
+		p->codec.h264.max_ref_pic = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_NUM_REF_PIC_4P:
+		p->codec.h264.num_ref_pic_4p = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_8X8_TRANSFORM:
+		p->codec.h264._8x8_transform = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_ENABLE:
+		p->codec.h264.rc_mb = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_FRAME_RATE:
+		p->codec.h264.rc_framerate = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_FRAME_QP:
+		p->codec.h264.rc_frame_qp = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MIN_QP:
+		p->codec.h264.rc_min_qp = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MAX_QP:
+		p->codec.h264.rc_max_qp = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_DARK:
+		p->codec.h264.rc_mb_dark = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_SMOOTH:
+		p->codec.h264.rc_mb_smooth = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_STATIC:
+		p->codec.h264.rc_mb_static = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_ACTIVITY:
+		p->codec.h264.rc_mb_activity = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_P_FRAME_QP:
+		p->codec.h264.rc_p_frame_qp = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_RC_B_FRAME_QP:
+		p->codec.h264.rc_b_frame_qp = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_AR_VUI_ENABLE:
+		p->codec.h264.ar_vui = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_AR_VUI_IDC:
+		p->codec.h264.ar_vui_idc = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_EXT_SAR_WIDTH:
+		p->codec.h264.ext_sar_width = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_EXT_SAR_HEIGHT:
+		p->codec.h264.ext_sar_height = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_OPEN_GOP:
+		p->codec.h264.open_gop = ctrl->value;
+		break;
+	case V4L2_CID_CODEC_MFC51_ENC_H264_I_PERIOD:
+		p->codec.h264.open_gop_size = ctrl->value;
+		break;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int vidioc_s_ctrl_enc(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+
+	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
+		return -EINVAL;
+
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret != 0)
+		return ret;
+
+	ret = set_ctrl_val_enc(ctx, ctrl);
+	if (ret != 0)
+		return ret;
+
+	return ret;
+}
+
+static int vidioc_g_ext_ctrls(struct file *file, void *priv,
+				struct v4l2_ext_controls *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	struct v4l2_ext_control *ext_ctrl;
+	struct v4l2_control ctrl;
+	int i;
+	int ret = 0;
+
+	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
+		return -EINVAL;
+
+	if (f->ctrl_class != V4L2_CTRL_CLASS_CODEC)
+		return -EINVAL;
+
+	for (i = 0; i < f->count; i++) {
+		ext_ctrl = (f->controls + i);
+
+		ctrl.id = ext_ctrl->id;
+
+		ret = get_ctrl_val_enc(ctx, &ctrl);
+		if (ret == 0) {
+			ext_ctrl->value = ctrl.value;
+		} else {
+			f->error_idx = i;
+			break;
+		}
+
+		mfc_debug("[%d] id: 0x%08x, value: %d", i, ext_ctrl->id,
+				ext_ctrl->value);
+	}
+
+	return ret;
+}
+
+static int vidioc_s_ext_ctrls(struct file *file, void *priv,
+				struct v4l2_ext_controls *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	struct v4l2_ext_control *ext_ctrl;
+	struct v4l2_control ctrl;
+	int i;
+	int ret = 0;
+
+	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
+		return -EINVAL;
+
+	if (f->ctrl_class != V4L2_CTRL_CLASS_CODEC)
+		return -EINVAL;
+
+	for (i = 0; i < f->count; i++) {
+		ext_ctrl = (f->controls + i);
+
+		ctrl.id = ext_ctrl->id;
+		ctrl.value = ext_ctrl->value;
+
+		ret = check_ctrl_val(ctx, &ctrl);
+		if (ret != 0) {
+			f->error_idx = i;
+			break;
+		}
+
+		ret = set_ctrl_val_enc(ctx, &ctrl);
+		if (ret != 0) {
+			f->error_idx = i;
+			break;
+		}
+
+		mfc_debug("[%d] id: 0x%08x, value: %d", i, ext_ctrl->id,
+				ext_ctrl->value);
+	}
+
+	return ret;
+}
+
+static int vidioc_try_ext_ctrls(struct file *file, void *priv,
+				struct v4l2_ext_controls *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	struct v4l2_ext_control *ext_ctrl;
+	struct v4l2_control ctrl;
+	int i;
+	int ret = 0;
+
+	if (s5p_mfc_get_node_type(file) != MFCNODE_ENCODER)
+		return -EINVAL;
+
+	if (f->ctrl_class != V4L2_CTRL_CLASS_CODEC)
+		return -EINVAL;
+
+	for (i = 0; i < f->count; i++) {
+		ext_ctrl = (f->controls + i);
+
+		ctrl.id = ext_ctrl->id;
+		ctrl.value = ext_ctrl->value;
+
+		ret = check_ctrl_val(ctx, &ctrl);
+		if (ret != 0) {
+			f->error_idx = i;
+			break;
+		}
+
+		mfc_debug("[%d] id: 0x%08x, value: %d", i, ext_ctrl->id,
+				ext_ctrl->value);
+	}
+
+	return ret;
+}
+/* Get cropping information */
+static int vidioc_g_crop(struct file *file, void *priv,
+		struct v4l2_crop *cr)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	u32 left, right, top, bottom;
+
+	mfc_debug_enter();
+	if (ctx->state != MFCINST_HEAD_PARSED &&
+	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
+					&& ctx->state != MFCINST_FINISHED) {
+			mfc_debug("%s-- with error\n", __func__);
+			return -EINVAL;
+		}
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
+		left = s5p_mfc_get_h_crop(ctx);
+		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
+		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
+		top = s5p_mfc_get_v_crop(ctx);
+		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
+		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
+		cr->c.left = left;
+		cr->c.top = top;
+		cr->c.width = ctx->img_width - left - right;
+		cr->c.height = ctx->img_height - top - bottom;
+		mfc_debug("Cropping info [h264]: l=%d t=%d "
+			"w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
+			cr->c.width, cr->c.height, right, bottom,
+			ctx->buf_width, ctx->buf_height);
+	} else {
+		cr->c.left = 0;
+		cr->c.top = 0;
+		cr->c.width = ctx->img_width;
+		cr->c.height = ctx->img_height;
+		mfc_debug("Cropping info: w=%d h=%d fw=%d "
+			"fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
+							ctx->buf_height);
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+/* v4l2_ioctl_ops */
+static const struct v4l2_ioctl_ops s5p_mfc_ioctl_ops = {
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
+	.vidioc_queryctrl = vidioc_queryctrl,
+	.vidioc_g_ctrl = vidioc_g_ctrl,
+	.vidioc_s_ctrl = vidioc_s_ctrl,
+	.vidioc_g_crop = vidioc_g_crop,
+};
+
+static const struct v4l2_ioctl_ops s5p_mfc_enc_ioctl_ops = {
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_g_fmt_vid_cap_mplane = vidioc_g_fmt_enc,
+	.vidioc_g_fmt_vid_out_mplane = vidioc_g_fmt_enc,
+	.vidioc_try_fmt_vid_cap_mplane = vidioc_try_fmt_enc,
+	.vidioc_try_fmt_vid_out_mplane = vidioc_try_fmt_enc,
+	.vidioc_s_fmt_vid_cap_mplane = vidioc_s_fmt_enc,
+	.vidioc_s_fmt_vid_out_mplane = vidioc_s_fmt_enc,
+	.vidioc_reqbufs = vidioc_reqbufs_enc,
+	.vidioc_querybuf = vidioc_querybuf_enc,
+	.vidioc_qbuf = vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+	.vidioc_queryctrl = vidioc_queryctrl,
+	.vidioc_g_ctrl = vidioc_g_ctrl_enc,
+	.vidioc_s_ctrl = vidioc_s_ctrl_enc,
+	.vidioc_g_ext_ctrls = vidioc_g_ext_ctrls,
+	.vidioc_s_ext_ctrls = vidioc_s_ext_ctrls,
+	.vidioc_try_ext_ctrls = vidioc_try_ext_ctrls,
+	.vidioc_g_crop = vidioc_g_crop,
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
+		if (!vb2_cma_plane_paddr(vb, i)) {
+			mfc_err("failed to get plane paddr\n");
+			return -EINVAL;
+		}
+
+		mfc_debug("index: %d, plane[%d] paddr: 0x%08lx",
+				vb->v4l2_buf.index, i,
+				vb2_cma_plane_paddr(vb, i));
+	}
+
+	return 0;
+}
+
+/* Negotiate buffers */
+static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
+			       unsigned int *plane_count, unsigned long psize[],
+			       void *allocators[])
+{
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+
+	mfc_debug_enter();
+	/* Video output for decoding (source)
+	 * this can be set after getting an instance */
+	if (ctx->state == MFCINST_GOT_INST &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_debug("setting for VIDEO output\n");
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
+		mfc_debug("setting for VIDEO capture\n");
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
+	mfc_debug("%s, buffer count=%d, plane count=%d type=0x%x\n", __func__,
+					*buf_count, *plane_count, vq->type);
+
+	if (ctx->state == MFCINST_HEAD_PARSED &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		psize[0] = ctx->luma_size;
+		psize[1] = ctx->chroma_size;
+		allocators[0] = ctx->dev->alloc_ctx[0];
+		allocators[1] = ctx->dev->alloc_ctx[1];
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		   ctx->state == MFCINST_GOT_INST) {
+		psize[0] = ctx->dec_src_buf_size;
+		allocators[0] = ctx->dev->alloc_ctx[1];
+	} else {
+		mfc_err("Decoding not initalised.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug("%s, plane=0, size=%lu\n", __func__, psize[0]);
+	mfc_debug("%s, plane=1, size=%lu\n", __func__, psize[1]);
+	mfc_debug_leave();
+	return 0;
+}
+
+static int s5p_mfc_enc_queue_setup(struct vb2_queue *vq,
+		unsigned int *buf_count, unsigned int *plane_count,
+		unsigned long psize[], void *allocators[])
+{
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
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
+		psize[0] = ctx->enc_dst_buf_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX];
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
+		psize[0] = ctx->luma_size;
+		psize[1] = ctx->chroma_size;
+		allocators[0] = ctx->dev->alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX];
+		allocators[1] = ctx->dev->alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX];
+
+	} else {
+		mfc_err("inavlid queue type: %d\n", vq->type);
+		return -EINVAL;
+	}
+
+	mfc_debug("buf_count: %d, plane_count: %d\n", *buf_count, *plane_count);
+	for (i = 0; i < *plane_count; i++)
+		mfc_debug("plane[%d] size=%lu\n", i, psize[i]);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	unsigned int i;
+
+	mfc_debug_enter();
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
+			mfc_debug_leave();
+			return 0;
+		}
+		for (i = 0; i <= ctx->src_fmt->num_planes ; i++) {
+			if (vb2_cma_plane_paddr(vb, i) == 0) {
+				mfc_err("Plane mem not allocated.\n");
+				return -EINVAL;
+			}
+		}
+		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
+			vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			mfc_err("Plane buffer (CAPTURE) is too small.\n");
+			return -EINVAL;
+		}
+		mfc_debug("Size: 0=%lu 2=%lu\n", vb2_plane_size(vb, 0),
+							vb2_plane_size(vb, 1));
+		i = vb->v4l2_buf.index;
+		ctx->dst_bufs[i].b = vb;
+		ctx->dst_bufs[i].paddr.raw.luma = vb2_cma_plane_paddr(vb, 0);
+		ctx->dst_bufs[i].paddr.raw.chroma = vb2_cma_plane_paddr(vb, 1);
+		ctx->dst_bufs_cnt++;
+
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (vb2_cma_plane_paddr(vb, 0)  == 0) {
+			mfc_err("Plane memory not allocated.\n");
+			return -EINVAL;
+		}
+		mfc_debug("Plane size: %ld, ctx->dec_src_buf_size: %d\n",
+				vb2_plane_size(vb, 0), ctx->dec_src_buf_size);
+		if (vb2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
+			mfc_err("Plane buffer (OUTPUT) is too small.\n");
+			return -EINVAL;
+		}
+		i = vb->v4l2_buf.index;
+		ctx->src_bufs[i].b = vb;
+		ctx->src_bufs[i].paddr.stream = vb2_cma_plane_paddr(vb, 0);
+		ctx->src_bufs_cnt++;
+	} else {
+		mfc_err("s5p_mfc_buf_init: unknown queue type.\n");
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+static int s5p_mfc_enc_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
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
+		ctx->dst_bufs[i].paddr.stream = vb2_cma_plane_paddr(vb, 0);
+		ctx->dst_bufs_cnt++;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = check_vb_with_fmt(ctx->src_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		i = vb->v4l2_buf.index;
+		ctx->src_bufs[i].b = vb;
+		ctx->src_bufs[i].paddr.raw.luma = vb2_cma_plane_paddr(vb, 0);
+		ctx->src_bufs[i].paddr.raw.chroma = vb2_cma_plane_paddr(vb, 1);
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
+static int s5p_mfc_enc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	int ret;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
+		if (ret < 0)
+			return ret;
+
+		mfc_debug("plane size: %ld, dst size: %d\n",
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
+		mfc_debug("plane size: %ld, luma size: %d\n",
+			vb2_plane_size(vb, 0), ctx->luma_size);
+		mfc_debug("plane size: %ld, luma size: %d\n",
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
+static inline int s5p_mfc_get_new_ctx(void)
+{
+	unsigned long flags;
+	int new_ctx;
+	int cnt;
+	spin_lock_irqsave(&dev->condlock, flags);
+	mfc_debug("Previos context: %d (bits %08lx)\n", dev->curr_ctx,
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
+static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
+{
+	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame(ctx, 1);
+}
+
+static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug("No src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	mfc_debug("Temp vb: %p\n", temp_vb);
+	mfc_debug("Src Addr: %08lx\n", vb2_cma_plane_paddr(temp_vb->b, 0));
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_cma_plane_paddr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame(ctx,
+				temp_vb->b->v4l2_planes[0].bytesused == 0);
+
+	return 0;
+}
+
+static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	/*
+	unsigned int src_y_size, src_c_size;
+	*/
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug("no src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	if (list_empty(&ctx->dst_queue)) {
+		mfc_debug("no dst buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_y_addr = vb2_cma_plane_paddr(src_mb->b, 0);
+	src_c_addr = vb2_cma_plane_paddr(src_mb->b, 1);
+
+	mfc_debug("enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug("enc src c addr: 0x%08lx", src_c_addr);
+
+	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_cma_plane_paddr(dst_mb->b, 0);
+	dst_size = dst_mb->b->v4l2_planes[0].bytesused;
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
+static inline int s5p_mfc_run_get_inst_no(struct s5p_mfc_ctx *ctx)
+{
+	int ret;
+	/* Preparing decoding - getting instance number */
+	mfc_debug("Getting instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_open_inst(ctx);
+	if (ret) {
+		mfc_err("Failed to create a new instance.\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+static inline int s5p_mfc_run_return_inst(struct s5p_mfc_ctx *ctx)
+{
+	int ret;
+
+	/* Closing decoding instance  */
+	mfc_debug("Returning instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_return_inst_no(ctx);
+	if (ret) {
+		mfc_err("Failed to return an instance.\n");
+		ctx->state = MFCINST_ERROR;
+		return ret;
+	}
+	return ret;
+}
+
+static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+
+	/* Initializing decoding - parsing header */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	mfc_debug("Preparing to init decoding.\n");
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	s5p_mfc_set_dec_desc_buffer(ctx);
+	mfc_debug("Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_cma_plane_paddr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	mfc_debug("paddr: %08x\n",
+			(int)phys_to_virt(vb2_cma_plane_paddr(temp_vb->b, 0)));
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_decode(ctx);
+}
+
+static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
+{
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
+	dst_addr = vb2_cma_plane_paddr(dst_mb->b, 0);
+	dst_size = dst_mb->b->v4l2_planes[0].bytesused;
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dev->curr_ctx = ctx->num;
+	mfc_debug("paddr: %08x\n",
+			(int)phys_to_virt(vb2_cma_plane_paddr(dst_mb->b, 0)));
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_encode(ctx);
+}
+
+static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+	int ret;
+	/* Header was parsed now starting processing
+	 * First set the output frame buffers
+	 * s5p_mfc_alloc_dec_buffers(ctx); */
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
+	mfc_debug("Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx, vb2_cma_plane_paddr(temp_vb->b, 0),
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
+/* Try running an operation on hardware */
+static void s5p_mfc_try_run(void)
+{
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned int ret = 0;
+
+	mfc_debug("Try run dev: %p\n", dev);
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug("Couldn't lock HW.\n");
+		return;
+	}
+	/* Choose the context to run */
+	new_ctx = s5p_mfc_get_new_ctx();
+	if (new_ctx < 0) {
+		/* No contexts to run */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware.\n");
+			return;
+		}
+		mfc_debug("No ctx is scheduled to be run.\n");
+		return;
+	}
+	mfc_debug("New context: %d\n", new_ctx);
+	ctx = dev->ctx[new_ctx];
+	mfc_debug("Seting new context to %p\n", ctx);
+	/* Got context to run in ctx */
+	mfc_debug("ctx->dst_queue_cnt=%d ctx->dpb_count=%d ctx->src_queue_cnt=%d\n",
+		ctx->dst_queue_cnt, ctx->dpb_count, ctx->src_queue_cnt);
+	mfc_debug("ctx->state=%d\n", ctx->state);
+	/* Last frame has already been sent to MFC
+	 * Now obtaining frames from MFC buffer */
+	if (ctx->type == MFCINST_DECODER) {
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			ret = s5p_mfc_run_get_inst_no(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_run_return_inst(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_HEAD_PARSED:
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else if (ctx->type == MFCINST_ENCODER) {
+		switch (ctx->state) {
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_enc_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			ret = s5p_mfc_run_get_inst_no(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_run_return_inst(ctx);
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
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			mfc_err("Failed to unlock hardware.\n");
+	}
+}
+
+/* Queue buffer */
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	unsigned long flags;
+	struct s5p_mfc_buf *mfc_buf;
+
+	mfc_debug_enter();
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_debug("Src queue: %p\n", &ctx->src_queue);
+		mfc_debug("Adding to src: %p (%08lx, %08x)\n", vb,
+				vb2_cma_plane_paddr(vb, 0),
+				ctx->src_bufs[vb->v4l2_buf.index].paddr.stream);
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_debug("Dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug("Adding to dst: %p (%lx)\n", vb,
+						  vb2_cma_plane_paddr(vb, 0));
+		mfc_debug("ADDING Flag before: %lx (%d)\n",
+					ctx->dec_dst_flag, vb->v4l2_buf.index);
+		/* Mark destination as available for use by MFC */
+		spin_lock_irqsave(&dev->irqlock, flags);
+		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
+		mfc_debug("ADDING Flag after: %lx\n", ctx->dec_dst_flag);
+		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
+		ctx->dst_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else {
+		mfc_err("Unsupported buffer type (%d)\n", vq->type);
+	}
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+	s5p_mfc_try_run();
+	mfc_debug_leave();
+}
+
+static void s5p_mfc_enc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	unsigned long flags;
+	struct s5p_mfc_buf *mfc_buf;
+
+	mfc_debug_enter();
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_debug("dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug("adding to dst: %p (%08lx, %08x)\n", vb,
+			vb2_cma_plane_paddr(vb, 0),
+			ctx->dst_bufs[vb->v4l2_buf.index].paddr.stream);
+		/* Mark destination as available for use by MFC */
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
+		ctx->dst_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_debug("src queue: %p\n", &ctx->src_queue);
+		mfc_debug("adding to src: %p (%08lx, %08lx, %08x, %08x)\n", vb,
+			vb2_cma_plane_paddr(vb, 0),
+			vb2_cma_plane_paddr(vb, 1),
+			ctx->src_bufs[vb->v4l2_buf.index].paddr.raw.luma,
+			ctx->src_bufs[vb->v4l2_buf.index].paddr.raw.chroma);
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
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
+	s5p_mfc_try_run();
+
+	mfc_debug_leave();
+}
+
+/* Let the streaming begin. */
+static int s5p_mfc_start_streaming(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = q->drv_priv;
+
+	unsigned long flags;
+	/* If context is ready then schedule it to run */
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run();
+	return 0;
+}
+
+/* Thou shalt stream no more. */
+static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct s5p_mfc_ctx *ctx;
+
+	ctx = q->drv_priv;
+
+	if ((ctx->state == MFCINST_FINISHING ||
+		ctx->state ==  MFCINST_RUNNING) &&
+		dev->curr_ctx == ctx->num && dev->hw_lock) {
+		ctx->state = MFCINST_ABORT;
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+									0);
+	}
+	ctx->state = MFCINST_FINISHED;
+	spin_lock_irqsave(&dev->irqlock, flags);
+	s5p_mfc_error_cleanup_queue(&ctx->dst_queue,
+					&ctx->vq_dst);
+	s5p_mfc_error_cleanup_queue(&ctx->src_queue,
+					&ctx->vq_src);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		INIT_LIST_HEAD(&ctx->dst_queue);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		INIT_LIST_HEAD(&ctx->src_queue);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return 0;
+}
+
+void s5p_mfc_lock(struct vb2_queue *q)
+{
+	mutex_lock(dev->mfc_mutex);
+}
+
+void s5p_mfc_unlock(struct vb2_queue *q)
+{
+	mutex_unlock(dev->mfc_mutex);
+}
+
+/* Videobuf opts */
+static struct vb2_ops s5p_mfc_qops = {
+	.buf_queue = s5p_mfc_buf_queue,
+	.queue_setup = s5p_mfc_queue_setup,
+	.start_streaming = s5p_mfc_start_streaming,
+	.buf_init = s5p_mfc_buf_init,
+	.stop_streaming = s5p_mfc_stop_streaming,
+	.wait_prepare = s5p_mfc_unlock,
+	.wait_finish = s5p_mfc_lock,
+};
+
+static struct vb2_ops s5p_mfc_enc_qops = {
+	.buf_queue = s5p_mfc_enc_buf_queue,
+	.queue_setup = s5p_mfc_enc_queue_setup,
+	.start_streaming = s5p_mfc_start_streaming,
+	.buf_init = s5p_mfc_enc_buf_init,
+	.buf_prepare  = s5p_mfc_enc_buf_prepare,
+	.stop_streaming = s5p_mfc_stop_streaming,
+	.wait_prepare = s5p_mfc_unlock,
+	.wait_finish = s5p_mfc_lock,
+};
+
+static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_buf *dst_buf;
+
+	ctx->state = MFCINST_FINISHED;
+	mfc_debug("Decided to finish\n");
+	ctx->sequence++;
+	while (!list_empty(&ctx->dst_queue)) {
+		dst_buf = list_entry(ctx->dst_queue.next,
+				     struct s5p_mfc_buf, list);
+		mfc_debug("Cleaning up buffer: %d\n",
+					  dst_buf->b->v4l2_buf.index);
+		vb2_set_plane_payload(dst_buf->b, 0, 0);
+		vb2_set_plane_payload(dst_buf->b, 1, 0);
+		list_del(&dst_buf->list);
+		ctx->dst_queue_cnt--;
+		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
+		if (s5p_mfc_get_pic_time_top(ctx) ==
+			s5p_mfc_get_pic_time_bottom(ctx))
+			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+		else
+			dst_buf->b->v4l2_buf.field =
+				V4L2_FIELD_INTERLACED;
+		ctx->dec_dst_flag &= ~(1 << dst_buf->b->v4l2_buf.index);
+		vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+		mfc_debug("Cleaned up buffer: %d\n",
+			  dst_buf->b->v4l2_buf.index);
+	}
+	mfc_debug("After cleanup\n");
+}
+
+static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
+{
+	struct s5p_mfc_buf  *dst_buf;
+	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
+
+	ctx->sequence++;
+	/* If frame is same as previous then skip and do not dequeue */
+	if (s5p_mfc_get_frame_type() ==  S5P_FIMV_DECODE_FRAME_SKIPPED)
+		return;
+	/* The MFC returns address of the buffer, now we have to
+	 * check which videobuf does it correspond to */
+	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		mfc_debug("Listing: %d\n", dst_buf->b->v4l2_buf.index);
+		/* Check if this is the buffer we're looking for */
+		if (vb2_cma_plane_paddr(dst_buf->b, 0) == dspl_y_addr) {
+			list_del(&dst_buf->list);
+			ctx->dst_queue_cnt--;
+			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
+			if (s5p_mfc_get_pic_time_top(ctx) ==
+				s5p_mfc_get_pic_time_bottom(ctx))
+				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
+			else
+				dst_buf->b->v4l2_buf.field =
+						V4L2_FIELD_INTERLACED;
+			vb2_set_plane_payload(dst_buf->b, 0, ctx->luma_size);
+			vb2_set_plane_payload(dst_buf->b, 1, ctx->chroma_size);
+			clear_bit(dst_buf->b->v4l2_buf.index,
+						&ctx->dec_dst_flag);
+			if (err) {
+				vb2_buffer_done(dst_buf->b,
+						VB2_BUF_STATE_ERROR);
+			} else {
+				vb2_buffer_done(dst_buf->b, VB2_BUF_STATE_DONE);
+			}
+			break;
+		}
+	}
+}
+
+/* Handle frame decoding interrupt */
+static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
+					unsigned int reason, unsigned int err)
+{
+	unsigned int dst_frame_status;
+	struct s5p_mfc_buf *src_buf;
+	unsigned long flags;
+
+	dst_frame_status = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
+	mfc_debug("Frame Status: %x\n", dst_frame_status);
+	spin_lock_irqsave(&dev->irqlock, flags);
+	/* All frames remaining in the buffer have been extracted  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY)
+		s5p_mfc_handle_frame_all_extracted(ctx);
+
+	/* A frame has been decoded and is in the buffer  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DISPLAY_ONLY ||
+	    dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY) {
+		s5p_mfc_handle_frame_new(ctx, err);
+	} else {
+		mfc_debug("No frame decode.\n");
+	}
+	/* Mark source buffer as complete */
+	if (dst_frame_status != S5P_FIMV_DEC_STATUS_DISPLAY_ONLY
+		&& !list_empty(&ctx->src_queue)) {
+		src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
+								list);
+		mfc_debug("Packed PB test. Size:%d, prev offset: %ld, this run:"
+			" %d\n", src_buf->b->v4l2_planes[0].bytesused,
+			ctx->consumed_stream, s5p_mfc_get_consumed_stream());
+		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
+		if (s5p_mfc_get_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
+					&& ctx->consumed_stream <
+					src_buf->b->v4l2_planes[0].bytesused) {
+			/* Run MFC again on the same buffer */
+			mfc_debug("Running again the same buffer.\n");
+			s5p_mfc_set_dec_stream_buffer(ctx,
+				src_buf->paddr.stream, ctx->consumed_stream,
+				src_buf->b->v4l2_planes[0].bytesused -
+							ctx->consumed_stream);
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+			s5p_mfc_clear_int_flags();
+			wake_up_ctx(ctx, reason, err);
+			s5p_mfc_decode_one_frame(ctx, 0);
+			return;
+		} else {
+			mfc_debug("MFC needs next buffer.\n");
+			/* Advance to next buffer */
+			if (src_buf->b->v4l2_planes[0].bytesused == 0) {
+				mfc_debug("Setting ctx->state to FINISHING\n");
+				ctx->state = MFCINST_FINISHING;
+			}
+			ctx->consumed_stream = 0;
+			list_del(&src_buf->list);
+			ctx->src_queue_cnt--;
+			vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+		}
+	}
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	mfc_debug("Assesing whether this context should be run again.\n");
+	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
+				    || ctx->dst_queue_cnt < ctx->dpb_count) {
+		mfc_debug("No need to run again.\n");
+		clear_work_bit(ctx);
+	}
+	mfc_debug("After assesing whether this context should be run again.\n");
+	s5p_mfc_clear_int_flags();
+	wake_up_ctx(ctx, reason, err);
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		BUG();
+	s5p_mfc_try_run();
+}
+
+/* Error handling for interrupt */
+static inline void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
+	unsigned int reason, unsigned int err)
+{
+	unsigned long flags;
+
+	mfc_err("Interrupt Error: %08x\n", err);
+	s5p_mfc_clear_int_flags();
+	wake_up_dev(reason, err);
+	/* If no context is available then all necessary
+	 * processing has been done. */
+	if (ctx == 0)
+		return;
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
+		s5p_mfc_error_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		/* Mark all src buffers as having an error */
+		s5p_mfc_error_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		break;
+	default:
+		mfc_err("invalid state to handle interrupt: %d\n", ctx->state);
+		break;
+	}
+	return;
+}
+
+/* Interrupt processing */
+static irqreturn_t s5p_mfc_irq(int irq, void *priv)
+{
+	struct s5p_mfc_buf *src_buf;
+	struct s5p_mfc_ctx *ctx;
+	unsigned int reason;
+	unsigned int err;
+	unsigned long flags;
+
+	mfc_debug_enter();
+	/* Reset the timeout watchdog */
+	atomic_set(&dev->watchdog_cnt, 0);
+	ctx = dev->ctx[dev->curr_ctx];
+	/* Get the reason of interrupt and the error code */
+	reason = s5p_mfc_get_int_reason();
+	err = s5p_mfc_get_int_err();
+	mfc_debug("Int reason: %d (err: %08x)\n", reason, err);
+	switch (reason) {
+	case S5P_FIMV_R2H_CMD_DECODE_ERR_RET:
+		/* An error has occured */
+		if (ctx->state == MFCINST_RUNNING &&
+					err >= S5P_FIMV_ERR_WARNINGS_START)
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
+			s5p_mfc_try_run();
+		} else {
+			s5p_mfc_handle_frame(ctx, reason, err);
+		}
+		break;
+	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+		if (ctx->c_ops->post_seq_start) {
+			if (ctx->c_ops->post_seq_start(ctx))
+				mfc_err("post_seq_start() failed\n");
+		} else {
+			if (ctx->src_fmt->fourcc != V4L2_PIX_FMT_DIVX3) {
+				ctx->img_width = s5p_mfc_get_img_width();
+				ctx->img_height = s5p_mfc_get_img_height();
+			}
+			ctx->buf_width = ALIGN(ctx->img_width,
+						S5P_FIMV_NV12T_VALIGN);
+			ctx->buf_height = ALIGN(ctx->img_height,
+						S5P_FIMV_NV12T_HALIGN);
+			mfc_debug("SEQ Done: Movie dimensions %dx%d, "
+					"buffer dimensions: %dx%d\n",
+					ctx->img_width, ctx->img_height,
+					ctx->buf_width, ctx->buf_height);
+			ctx->luma_size = ALIGN(ctx->buf_width * ctx->buf_height,
+						S5P_FIMV_DEC_BUF_ALIGN);
+			ctx->chroma_size = ALIGN(ctx->buf_width *
+						ALIGN(ctx->img_height / 2,
+						S5P_FIMV_NV12T_HALIGN),
+						S5P_FIMV_DEC_BUF_ALIGN);
+			if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+				ctx->mv_size = ALIGN(ctx->buf_width *
+						ALIGN(ctx->buf_height / 4,
+						S5P_FIMV_NV12T_HALIGN),
+						S5P_FIMV_DEC_BUF_ALIGN);
+			else
+				ctx->mv_size = 0;
+			ctx->dpb_count = s5p_mfc_get_dpb_count();
+			ctx->state = MFCINST_HEAD_PARSED;
+		}
+
+		s5p_mfc_clear_int_flags();
+		clear_work_bit(ctx);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		s5p_mfc_try_run();
+		wake_up_ctx(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_get_inst_no();
+		ctx->state = MFCINST_GOT_INST;
+		clear_work_bit(ctx);
+		wake_up_interruptible(&ctx->queue);
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
+		if (ctx)
+			clear_work_bit(ctx);
+		s5p_mfc_clear_int_flags();
+		wake_up_dev(reason, err);
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
+			spin_lock_irqsave(&dev->irqlock, flags);
+			if (!list_empty(&ctx->src_queue)) {
+				src_buf = list_entry(ctx->src_queue.next,
+					       struct s5p_mfc_buf, list);
+				list_del(&src_buf->list);
+				ctx->src_queue_cnt--;
+				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+			}
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+			wake_up_interruptible(&ctx->queue);
+			s5p_mfc_try_run();
+		} else {
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+			wake_up_interruptible(&ctx->queue);
+		}
+		break;
+	default:
+		mfc_debug("Unknown int reason.\n");
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
+	s5p_mfc_try_run();
+	mfc_debug("%s-- (via irq_cleanup_hw)\n", __func__);
+	return IRQ_HANDLED;
+}
+
+/* Open an MFC node */
+static int s5p_mfc_open(struct file *file)
+{
+	struct s5p_mfc_ctx *ctx = NULL;
+	struct vb2_queue *q;
+	unsigned long flags;
+	int ret = 0;
+
+	mfc_debug_enter();
+	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
+	/* Allocate memory for context */
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx) {
+		mfc_err("Not enough memory.\n");
+		ret = -ENOMEM;
+		goto out_open;
+	}
+	file->private_data = ctx;
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
+			ret = -EAGAIN;
+			goto out_open;
+		}
+	}
+	/* Mark context as idle */
+	spin_lock_irqsave(&dev->condlock, flags);
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	dev->ctx[ctx->num] = ctx;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		ctx->type = MFCINST_DECODER;
+		ctx->c_ops = &decoder_codec_ops;
+		/* Default format */
+		ctx->src_fmt = &formats[DEC_DEF_SRC_FMT];
+		ctx->dst_fmt = &formats[DEC_DEF_DST_FMT];
+	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+		ctx->type = MFCINST_ENCODER;
+		ctx->c_ops = &encoder_codec_ops;
+		/* Default format */
+		ctx->src_fmt = &formats[ENC_DEF_SRC_FMT];
+		ctx->dst_fmt = &formats[ENC_DEF_DST_FMT];
+	} else {
+		ret = -ENOENT;
+		goto out_open;
+	}
+	ctx->inst_no = -1;
+	/* Load firmware if this is the first instance */
+	if (dev->num_inst == 1) {
+		dev->watchdog_timer.expires = jiffies +
+					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
+		add_timer(&dev->watchdog_timer);
+
+		/* Load the FW */
+		ret = s5p_mfc_alloc_firmware(dev);
+		if (ret != 0)
+			goto out_open_2a;
+		ret = s5p_mfc_load_firmware(dev);
+		if (ret != 0)
+			goto out_open_2;
+		mfc_debug("Enabling clocks.\n");
+		clk_enable(dev->clock1);
+		clk_enable(dev->clock2);
+		/* Init the FW */
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0)
+			goto out_open_3;
+	}
+
+	/* Init videobuf2 queue for CAPTURE */
+	q = &ctx->vq_dst;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->drv_priv = ctx;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		q->io_modes = VB2_MMAP;
+		q->ops = &s5p_mfc_qops;
+	} else {
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->ops = &s5p_mfc_enc_qops;
+	}
+	q->mem_ops = &vb2_cma_memops;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
+		goto out_open_3;
+	}
+
+	/* Init videobuf2 queue for OUTPUT */
+	q = &ctx->vq_src;
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = ctx;
+	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+		q->io_modes = VB2_MMAP;
+		q->ops = &s5p_mfc_qops;
+	} else {
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->ops = &s5p_mfc_enc_qops;
+	}
+	q->mem_ops = &vb2_cma_memops;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(output)\n");
+		goto out_open_3;
+	}
+	init_waitqueue_head(&ctx->queue);
+	mfc_debug("%s-- (via irq_cleanup_hw)\n", __func__);
+	return ret;
+	/* Deinit when failure occured */
+out_open_3:
+	if (dev->num_inst == 1) {
+		clk_disable(dev->clock1);
+		clk_disable(dev->clock2);
+		s5p_mfc_release_firmware(dev);
+	}
+out_open_2:
+	s5p_mfc_release_firmware(dev);
+out_open_2a:
+	dev->ctx[ctx->num] = 0;
+	kfree(ctx);
+	del_timer_sync(&dev->watchdog_timer);
+out_open:
+	dev->num_inst--;
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Release MFC context */
+static int s5p_mfc_release(struct file *file)
+{
+	struct s5p_mfc_ctx *ctx = file->private_data;
+	unsigned long flags;
+
+	mfc_debug_enter();
+
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
+		ctx->state = MFCINST_RETURN_INST;
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_try_run();
+		/* Wait until instance is returned or timeout occured */
+		if (s5p_mfc_wait_for_done_ctx
+		    (ctx, S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
+			mfc_err("Err returning instance.\n");
+		}
+		/* Free resources */
+		s5p_mfc_release_codec_buffers(ctx);
+		s5p_mfc_release_instance_buffer(ctx);
+		if (ctx->type == MFCINST_DECODER)
+			s5p_mfc_release_dec_desc_buffer(ctx);
+
+		ctx->inst_no = -1;
+	}
+	/* hardware locking scheme */
+	if (dev->curr_ctx == ctx->num)
+		clear_bit(0, &dev->hw_lock);
+	dev->num_inst--;
+	if (dev->num_inst == 0) {
+		s5p_mfc_deinit_hw(dev);
+		mfc_debug("Disabling clocks...\n");
+		clk_disable(dev->clock1);
+		clk_disable(dev->clock2);
+		s5p_mfc_release_firmware(dev);
+		del_timer_sync(&dev->watchdog_timer);
+	}
+
+	dev->ctx[ctx->num] = 0;
+	kfree(ctx);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Poll */
+static unsigned int s5p_mfc_poll(struct file *file,
+				 struct poll_table_struct *wait)
+{
+	struct s5p_mfc_ctx *ctx = file->private_data;
+
+	return vb2_poll(&ctx->vq_dst, file, wait);
+}
+
+/* Mmap */
+static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct s5p_mfc_ctx *ctx = file->private_data;
+	int ret;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	mfc_debug_enter();
+	if (offset < DST_QUEUE_OFF_BASE) {
+		mfc_debug("mmaping source.\n");
+		ret = vb2_mmap(&ctx->vq_src, vma);
+	} else {		/* capture */
+		mfc_debug("mmaping destination.\n");
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
+static struct video_device s5p_mfc_videodev = {
+	.name = S5P_MFC_DEC_NAME,
+	.fops = &s5p_mfc_fops,
+	.ioctl_ops = &s5p_mfc_ioctl_ops,
+	.minor = -1,
+	.release = video_device_release,
+};
+
+static struct video_device s5p_mfc_enc_videodev = {
+	.name = S5P_MFC_ENC_NAME,
+	.fops = &s5p_mfc_fops,
+	.ioctl_ops = &s5p_mfc_enc_ioctl_ops,
+	.minor = -1,
+	.release = video_device_release,
+};
+
+/* MFC probe function */
+static int s5p_mfc_probe(struct platform_device *pdev)
+{
+	struct video_device *vfd;
+	struct resource *res;
+	int ret = -ENOENT;
+	size_t size;
+
+	pr_debug("%s++\n", __func__);
+	dev = kzalloc(sizeof *dev, GFP_KERNEL);
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
+		goto free_dev;
+	}
+	dev_dbg(&pdev->dev, "Getting clocks\n");
+	dev->clock1 = clk_get(&pdev->dev, "sclk_mfc");
+	dev->clock2 = clk_get(&pdev->dev, "mfc");
+	if (IS_ERR(dev->clock1) || IS_ERR(dev->clock2)) {
+		dev_err(&pdev->dev, "failed to get mfc clock source\n");
+		goto free_clk;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region resource.\n");
+		ret = -ENOENT;
+		goto probe_out1;
+	}
+	size = (res->end - res->start) + 1;
+	dev->mfc_mem = request_mem_region(res->start, size, pdev->name);
+	if (dev->mfc_mem == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region.\n");
+		ret = -ENOENT;
+		goto probe_out2;
+	}
+	dev->base_virt_addr = ioremap(dev->mfc_mem->start,
+			      dev->mfc_mem->end - dev->mfc_mem->start + 1);
+	if (dev->base_virt_addr == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap address region.\n");
+		ret = -ENOENT;
+		goto probe_out3;
+	}
+	dev->regs_base = dev->base_virt_addr;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get irq resource.\n");
+		ret = -ENOENT;
+		goto probe_out4;
+	}
+	dev->irq = res->start;
+	ret = request_irq(dev->irq, s5p_mfc_irq, IRQF_DISABLED, pdev->name,
+									dev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
+		goto probe_out5;
+	}
+	dev->mfc_mutex = kmalloc(sizeof(struct mutex), GFP_KERNEL);
+	if (dev->mfc_mutex == NULL) {
+		dev_err(&pdev->dev, "Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto probe_out6;
+	}
+	mutex_init(dev->mfc_mutex);
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto probe_out7;
+	init_waitqueue_head(&dev->queue);
+
+	/* decoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+	*vfd = s5p_mfc_videodev;
+	vfd->lock = dev->mfc_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_videodev.name);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto rel_vdev_dec;
+	}
+	v4l2_info(&dev->v4l2_dev,
+			"MFC decoder device registered as /dev/video%d\n",
+			vfd->num);
+
+	dev->vfd_dec = vfd;
+
+	/* encoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev,
+				"Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_vdev_dec;
+	}
+	*vfd = s5p_mfc_enc_videodev;
+	vfd->lock = dev->mfc_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_enc_videodev.name);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto rel_vdev_enc;
+	}
+	v4l2_info(&dev->v4l2_dev,
+			"MFC encoder device registered as /dev/video%d\n",
+			vfd->num);
+
+	dev->vfd_enc = vfd;
+
+	video_set_drvdata(vfd, dev);
+
+	platform_set_drvdata(pdev, dev);
+	dev->hw_lock = 0;
+	dev->watchdog_workqueue = create_singlethread_workqueue("s5p-mfc");
+	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
+	atomic_set(&dev->watchdog_cnt, 0);
+	init_timer(&dev->watchdog_timer);
+	dev->watchdog_timer.data = 0;
+	dev->watchdog_timer.function = s5p_mfc_watchdog;
+
+	dev->alloc_ctx = vb2_cma_init_multi(&pdev->dev, MFC_CMA_ALLOC_CTX_NUM,
+					s5p_mem_types, s5p_mem_alignments);
+	if (IS_ERR(dev->alloc_ctx)) {
+		mfc_err("Couldn't prepare allocator ctx.\n");
+		ret = PTR_ERR(dev->alloc_ctx);
+		goto alloc_ctx_fail;
+	}
+
+	pr_debug("%s--\n", __func__);
+	return 0;
+
+/* Deinit MFC if probe had failed */
+alloc_ctx_fail:
+	video_unregister_device(dev->vfd_enc);
+rel_vdev_enc:
+	video_device_release(dev->vfd_enc);
+unreg_vdev_dec:
+	video_unregister_device(dev->vfd_dec);
+rel_vdev_dec:
+	video_device_release(dev->vfd_dec);
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+probe_out7:
+	if (dev->mfc_mutex) {
+		mutex_destroy(dev->mfc_mutex);
+		kfree(dev->mfc_mutex);
+	}
+probe_out6:
+	free_irq(dev->irq, dev);
+probe_out5:
+probe_out4:
+	iounmap(dev->base_virt_addr);
+	dev->base_virt_addr = NULL;
+probe_out3:
+	release_resource(dev->mfc_mem);
+	kfree(dev->mfc_mem);
+probe_out2:
+probe_out1:
+	clk_put(dev->clock1);
+	clk_put(dev->clock2);
+free_clk:
+
+free_dev:
+	kfree(dev);
+	pr_debug("%s-- with error\n", __func__);
+	return ret;
+}
+
+/* Remove the driver */
+static int s5p_mfc_remove(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "%s++\n", __func__);
+	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
+	del_timer_sync(&dev->watchdog_timer);
+	flush_workqueue(dev->watchdog_workqueue);
+	destroy_workqueue(dev->watchdog_workqueue);
+	video_unregister_device(dev->vfd_enc);
+	video_unregister_device(dev->vfd_dec);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	vb2_cma_cleanup_multi(dev->alloc_ctx);
+	if (dev->mfc_mutex) {
+		mutex_destroy(dev->mfc_mutex);
+		kfree(dev->mfc_mutex);
+	}
+	mfc_debug("Will now deinit HW\n");
+	s5p_mfc_deinit_hw(dev);
+	free_irq(dev->irq, dev);
+	iounmap(dev->base_virt_addr);
+	if (dev->mfc_mem != NULL) {
+		release_resource(dev->mfc_mem);
+		kfree(dev->mfc_mem);
+		dev->mfc_mem = NULL;
+	}
+	clk_put(dev->clock1);
+	clk_put(dev->clock2);
+	kfree(dev);
+	dev_dbg(&pdev->dev, "%s--\n", __func__);
+	return 0;
+}
+
+static int s5p_mfc_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int s5p_mfc_resume(struct device *dev)
+{
+	return 0;
+}
+
+/* Power management */
+static const struct dev_pm_ops s5p_mfc_pm_ops = {
+	.suspend = s5p_mfc_suspend,
+	.resume = s5p_mfc_resume,
+};
+
+static struct platform_driver s5p_mfc_pdrv = {
+	.probe = s5p_mfc_probe,
+	.remove = __devexit_p(s5p_mfc_remove),
+	.driver = {
+		   .name = S5P_MFC_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = &s5p_mfc_pm_ops},
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
+MODULE_AUTHOR("Jeongtae Park <jtp.park@samsung.com>");
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
new file mode 100644
index 0000000..7df013c
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -0,0 +1,333 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * This file contains definitions of enums and structs used by the codec
+ * driver.
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
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
+#include "regs-mfc5.h"
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+#include <media/videobuf2-core.h>
+
+#define MFC_MAX_EXTRA_DPB	5
+#define MFC_MAX_BUFFERS		32
+#define MFC_FRAME_PLANES	2
+
+#define MFC_NUM_CONTEXTS	4
+/* Interrupt timeout */
+#define MFC_INT_TIMEOUT		2000
+/* Busy wait timeout */
+#define MFC_BW_TIMEOUT		500
+/* Watchdog interval */
+#define MFC_WATCHDOG_INTERVAL	1000
+/* After how many executions watchdog should assume lock up */
+#define MFC_WATCHDOG_CNT	10
+
+#define MFC_NO_INSTANCE_SET	-1
+
+#define MFC_ENC_CAP_PLANE_COUNT	1
+#define MFC_ENC_OUT_PLANE_COUNT	2
+
+/**
+ * enum s5p_mfc_inst_type - The type of an MFC device node.
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
+struct s5p_mfc_ctx;
+
+/**
+ * struct s5p_mfc_buf - MFC buffer
+ *
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
+	} paddr;
+};
+
+/**
+ * struct s5p_mfc_dev - The struct containing driver internal parameters.
+ */
+struct s5p_mfc_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vfd_dec;
+	struct video_device *vfd_enc;
+	struct platform_device *plat_dev;
+
+	int num_inst;
+	spinlock_t irqlock;
+	spinlock_t condlock;
+
+	void __iomem *regs_base;
+	int irq;
+
+	struct resource *mfc_mem;
+	void __iomem *base_virt_addr;
+
+	struct mutex *mfc_mutex;
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
+	struct clk *clock1;
+	struct clk *clock2;
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
+	struct vb2_alloc_ctx **alloc_ctx;
+};
+
+/**
+ * struct s5p_mfc_h264_enc_params - The H.264 specific encoding parameters.
+ */
+struct s5p_mfc_h264_enc_params {
+	u8 num_b_frame;
+	enum v4l2_codec_mfc5x_enc_h264_profile profile;
+	u8 level;
+	enum v4l2_codec_mfc5x_enc_switch interlace;
+	enum v4l2_codec_mfc5x_enc_h264_loop_filter loop_filter_mode;
+	s8 loop_filter_alpha;
+	s8 loop_filter_beta;
+	enum v4l2_codec_mfc5x_enc_h264_entropy_mode entropy_mode;
+	u8 max_ref_pic;
+	u8 num_ref_pic_4p;
+	enum v4l2_codec_mfc5x_enc_switch _8x8_transform;
+	enum v4l2_codec_mfc5x_enc_switch rc_mb;
+	u32 rc_framerate;
+	u8 rc_frame_qp;
+	u8 rc_min_qp;
+	u8 rc_max_qp;
+	enum v4l2_codec_mfc5x_enc_switch_inv rc_mb_dark;
+	enum v4l2_codec_mfc5x_enc_switch_inv rc_mb_smooth;
+	enum v4l2_codec_mfc5x_enc_switch_inv rc_mb_static;
+	enum v4l2_codec_mfc5x_enc_switch_inv rc_mb_activity;
+	u8 rc_p_frame_qp;
+	u8 rc_b_frame_qp;
+	enum v4l2_codec_mfc5x_enc_switch ar_vui;
+	u8 ar_vui_idc;
+	u16 ext_sar_width;
+	u16 ext_sar_height;
+	enum v4l2_codec_mfc5x_enc_switch open_gop;
+	u16 open_gop_size;
+};
+
+/**
+ * struct s5p_mfc_enc_params - The common encoding parameters for MFC51.
+ */
+struct s5p_mfc_enc_params {
+	u16 width;
+	u16 height;
+
+	u16 gop_size;
+	enum v4l2_codec_mfc5x_enc_multi_slice_mode slice_mode;
+	u16 slice_mb;
+	u32 slice_bit;
+	u16 intra_refresh_mb;
+	enum v4l2_codec_mfc5x_enc_switch pad;
+	u8 pad_luma;
+	u8 pad_cb;
+	u8 pad_cr;
+	enum v4l2_codec_mfc5x_enc_switch rc_frame;
+	u32 rc_bitrate;
+	u16 rc_reaction_coeff;
+
+	u16 vbv_buf_size;
+	enum v4l2_codec_mfc5x_enc_seq_hdr_mode seq_hdr_mode;
+	enum v4l2_codec_mfc5x_enc_frame_skip_mode frame_skip_mode;
+	enum v4l2_codec_mfc5x_enc_switch fixed_target_bit;
+
+	union {
+		struct s5p_mfc_h264_enc_params h264;
+	} codec;
+};
+
+/**
+ * struct s5p_mfc_codec_ops - codec-specific callbacks
+ *
+ * @pre_seq_start:	called before run SEQ_START command
+ * @post_seq_start:	called after run SEQ_START command
+ * @pre_frame_start:	called before run every FRAME_START command
+ * @post_frame_start:	called after run every FRAME_START command
+ */
+struct s5p_mfc_codec_ops {
+	/* initialization routines */
+	int (*pre_seq_start) (struct s5p_mfc_ctx *ctx);
+	int (*post_seq_start) (struct s5p_mfc_ctx *ctx);
+	/* execution routines */
+	int (*pre_frame_start) (struct s5p_mfc_ctx *ctx);
+	int (*post_frame_start) (struct s5p_mfc_ctx *ctx);
+};
+
+/**
+ * struct s5p_mfc_ctx - This struct contains the instance context
+ */
+struct s5p_mfc_ctx {
+	struct s5p_mfc_dev *dev;
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
+	int dpb_count;
+	int total_dpb_count;
+
+	int luma_size;
+	int chroma_size;
+	int mv_size;
+
+	unsigned long consumed_stream;
+	int slice_interface;
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
+	int loop_filter_mpeg4;
+	int display_delay;
+
+	/* Buffers */
+	void *instance_buf;
+	size_t instance_phys;
+	size_t instance_size;
+
+	void *desc_buf;
+	size_t desc_phys;
+
+	void *shared_buf;
+	size_t shared_phys;
+	void *shared_virt;
+
+	/* Encoder parameters */
+	struct s5p_mfc_enc_params enc_params;
+
+	size_t enc_dst_buf_size;
+
+	int frame_count;
+	enum v4l2_codec_mfc5x_enc_frame_type frame_type;
+	enum v4l2_codec_mfc5x_enc_force_frame_type force_frame_type;
+
+	struct s5p_mfc_codec_ops *c_ops;
+};
+
+#endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
new file mode 100644
index 0000000..9de3820
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
@@ -0,0 +1,622 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * This file contains description of formats used by MFC and cotrols
+ * used by the driver.
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef S5P_MFC_CTRLS_H_
+#define S5P_MFC_CTRLS_H_
+
+#include <media/v4l2-ioctl.h>
+#include "regs-mfc5.h"
+
+#define MFC_FMT_DEC	0
+#define MFC_FMT_ENC	1
+#define MFC_FMT_RAW	2
+
+struct s5p_mfc_fmt {
+	char *name;
+	u32 fourcc;
+	u32 codec_mode;
+	u32 type;
+	u32 num_planes;
+};
+
+#define MFC_FORMATS_NO_CODEC -1
+
+#define DEC_DEF_SRC_FMT	2
+#define DEC_DEF_DST_FMT	0
+#define ENC_DEF_SRC_FMT	1
+#define ENC_DEF_DST_FMT	3
+
+static struct s5p_mfc_fmt formats[] = {
+	{
+		.name = "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc = V4L2_PIX_FMT_NV12MT,
+		.codec_mode = MFC_FORMATS_NO_CODEC,
+		.type = MFC_FMT_RAW,
+		.num_planes = 2,
+	},
+	{
+		.name = "4:2:0 2 Planes",
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.codec_mode = MFC_FORMATS_NO_CODEC,
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
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H264,
+		.codec_mode = S5P_FIMV_CODEC_H264_ENC,
+		.type = MFC_FMT_ENC,
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
+		.name = "MPEG1/MPEG2 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG12,
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
+		.name = "DivX Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_DIVX,
+		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "DivX 3.11 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_DIVX3,
+		.codec_mode = S5P_FIMV_CODEC_DIVX311_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "DivX 4.12 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_DIVX4,
+		.codec_mode = S5P_FIMV_CODEC_DIVX412_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "DivX 5.00-5.02 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_DIVX500,
+		.codec_mode = S5P_FIMV_CODEC_DIVX502_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "DivX 5.03 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_DIVX503,
+		.codec_mode = S5P_FIMV_CODEC_DIVX503_DEC,
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
+		.fourcc = V4L2_PIX_FMT_VC1,
+		.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+	{
+		.name = "VC1 RCV Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_VC1_RCV,
+		.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
+		.type = MFC_FMT_DEC,
+		.num_planes = 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct v4l2_queryctrl s5p_mfc_ctrls[] = {
+/* For decoding */
+	{
+		.id = V4L2_CID_CODEC_DISPLAY_DELAY,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "",
+		.minimum = 0,
+		.maximum = 16383,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Mpeg4 Loop Filter Enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_SLICE_INTERFACE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Slice Interface Enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+/* For encoding */
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_GOP_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The period of intra frame",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MODE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The slice partitioning method",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_MB,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of MB in a slice",
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_MULTI_SLICE_BIT,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The maximum bits per slices",
+		.minimum = 1900,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 1900,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_INTRA_REFRESH_MB,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of intra refresh MBs",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_PAD_CTRL_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Padding control enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_PAD_LUMA_VALUE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Y image's padding value",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_PAD_CB_VALUE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Cb image's padding value",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_PAD_CR_VALUE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Cr image's padding value",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_RC_FRAME_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Frame level rate control enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_RC_BIT_RATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Target bit rate rate-control",
+		.minimum = 1,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_RC_REACTION_COEFF,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Rate control reaction coeff.",
+		.minimum = 1,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_STREAM_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Encoded stream size",
+		.minimum = 0,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 0,
+		.flags = V4L2_CTRL_FLAG_READ_ONLY,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_FRAME_COUNT,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Encoded frame count",
+		.minimum = 0,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 0,
+		.flags = V4L2_CTRL_FLAG_READ_ONLY,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_FRAME_TYPE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Encoded frame type",
+		.minimum = 0,
+		.maximum = 5,
+		.step = 1,
+		.default_value = 0,
+		.flags = V4L2_CTRL_FLAG_READ_ONLY,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_FORCE_FRAME_TYPE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Force frame type",
+		.minimum = 1,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_VBV_BUF_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "VBV buffer size (1Kbits)",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_SEQ_HDR_MODE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Sequence header mode",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_FRAME_SKIP_MODE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Frame skip enable",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_RC_FIXED_TARGET_BIT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Fixed target bit enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_B_FRAMES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of B frames",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_PROFILE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 profile",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_LEVEL,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 level",
+		.minimum = 9,
+		.maximum = 40,
+		.step = 1,
+		.default_value = 9,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_INTERLACE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 interface mode",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_MODE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 loop filter mode",
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_ALPHA,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 loop filter alpha offset",
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_LOOP_FILTER_BETA,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 loop filter beta offset",
+		.minimum = -6,
+		.maximum = 6,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_ENTROPY_MODE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 entorpy mode",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_MAX_REF_PIC,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The max number of ref. picture",
+		.minimum = 1,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 2,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_NUM_REF_PIC_4P,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "The number of ref. picture of P",
+		.minimum = 1,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_8X8_TRANSFORM,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 8x8 transform enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 MB level rate control",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_FRAME_RATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Frame rate",
+		.minimum = 1,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Frame QP value",
+		.minimum = 1,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Minimum QP value",
+		.minimum = 1,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Maximum QP value",
+		.minimum = 1,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_DARK,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 dark region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_SMOOTH,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 smooth region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_STATIC,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 static region adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_MB_ACTIVITY,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "H264 MB activity adaptive",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "P frame QP value",
+		.minimum = 1,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_RC_B_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "B frame QP value",
+		.minimum = 1,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_AR_VUI_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Aspect ratio VUI enable",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_AR_VUI_IDC,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "VUI aspect ratio IDC",
+		.minimum = 0,
+		.maximum = 255,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_EXT_SAR_WIDTH,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Horizontal size of SAR",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_EXT_SAR_HEIGHT,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Vertical size of SAR",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_OPEN_GOP,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Open GOP enable (I-picture)",
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_CODEC_MFC51_ENC_H264_I_PERIOD,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "H264 I period",
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 0,
+	},
+};
+
+#define NUM_CTRLS ARRAY_SIZE(s5p_mfc_ctrls)
+
+#endif /* S5P_MFC_CTRLS_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
new file mode 100644
index 0000000..50ff583
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
@@ -0,0 +1,55 @@
+/*
+ * Smasung S5P Multi Format Codec v5.1
+ *
+ * This file contains debug macros
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef S5P_MFC_DEBUG_H_
+#define S5P_MFC_DEBUG_H_
+
+#define DEBUG
+
+#ifdef DEBUG
+extern int debug;
+/* Debug macro */
+
+#define mfc_debug(fmt, ...)						\
+	do {								\
+		if (debug)						\
+			dev_dbg(dev->v4l2_dev.dev, "%s:%s:%d:" fmt,	\
+					__FILE__, __func__,		\
+					__LINE__, ##__VA_ARGS__);	\
+	} while (0)
+#else
+#define mfc_debug(fmt, ...)
+#endif
+
+#define mfc_debug_enter() mfc_debug("enter")
+#define mfc_debug_leave() mfc_debug("leave")
+
+#define mfc_err(fmt, ...)						\
+	do {								\
+			dev_err(dev->v4l2_dev.dev,  "%s:%s:%d:" fmt,	\
+					__FILE__, __func__,		\
+					__LINE__, ##__VA_ARGS__);	\
+	} while (0)
+
+#define mfc_info(fmt, ...)						\
+	do {								\
+			dev_info(dev->v4l2_dev.dev, "%s:%s:%d:" fmt,	\
+					__FILE__, __func__,		\
+					__LINE__, ##__VA_ARGS__);	\
+	} while (0)
+
+#endif /* S5P_MFC_DEBUG_H_ */
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
new file mode 100644
index 0000000..c6faca9
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -0,0 +1,94 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * This file contains functions used to wait for command completion
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+#include "regs-mfc5.h"
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
+		|| dev->int_type == S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
+		msecs_to_jiffies(MFC_INT_TIMEOUT));
+	if (ret == 0) {
+		mfc_err("Interrupt (dev->int_type:%d, command:%d) timed out.\n",
+							dev->int_type, command);
+		return 1;
+	} else if (ret == -ERESTARTSYS) {
+		mfc_err("Interrupted by a signal.\n");
+		return 1;
+	}
+	mfc_debug("Finished waiting (dev->int_type:%d, command: %d).\n",
+							dev->int_type, command);
+	if (dev->int_type == S5P_FIMV_R2H_CMD_ERROR_RET)
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
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	if (interrupt) {
+		ret = wait_event_interruptible_timeout(ctx->queue,
+				(ctx->int_cond && (ctx->int_type == command
+			|| ctx->int_type == S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
+					msecs_to_jiffies(MFC_INT_TIMEOUT));
+	} else {
+		ret = wait_event_timeout(ctx->queue,
+				(ctx->int_cond && (ctx->int_type == command
+			|| ctx->int_type == S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
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
+	mfc_debug("Finished waiting (ctx->int_type:%d, command: %d).\n",
+							ctx->int_type, command);
+	if (ctx->int_type == S5P_FIMV_R2H_CMD_ERROR_RET)
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.h b/drivers/media/video/s5p-mfc/s5p_mfc_intr.h
new file mode 100644
index 0000000..440863e
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.h
@@ -0,0 +1,26 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_memory.h b/drivers/media/video/s5p-mfc/s5p_mfc_memory.h
new file mode 100644
index 0000000..8c0ccf7
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_memory.h
@@ -0,0 +1,42 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef S5P_MFC_MEMORY_H_
+#define S5P_MFC_MEMORY_H_
+
+#include "s5p_mfc_common.h"
+
+#define FIRMWARE_CODE_SIZE		0x60000	/* 384KB */
+#define MFC_H264_INSTANCE_BUF_SIZE	0x96000	/* 600KB per H264 instance */
+#define MFC_INSTANCE_BUF_SIZE		0x2800	/* 10KB per instance */
+#define DESC_BUF_SIZE			0x20000	/* 128KB for DESC buffer */
+#define SHARED_BUF_SIZE			0x01000	/* 4KB for shared buffer */
+#define CPB_BUF_SIZE			0x400000/* 4MB fr decoder */
+
+/* Define names for CMA memory kinds used by MFC */
+#define MFC_CMA_ALLOC_CTX_NUM	3
+
+#define MFC_CMA_BANK1		"a"
+#define MFC_CMA_BANK2		"b"
+#define MFC_CMA_FW		"f"
+
+#define MFC_CMA_BANK1_ALLOC_CTX 1
+#define MFC_CMA_BANK2_ALLOC_CTX 0
+#define MFC_CMA_FW_ALLOC_CTX	2
+
+#define MFC_CMA_BANK1_ALIGN	0x2000	/* 8KB */
+#define MFC_CMA_BANK2_ALIGN	0x2000	/* 8KB */
+#define MFC_CMA_FW_ALIGN	0x20000	/* 128KB */
+
+#endif /* S5P_MFC_MEMORY_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
new file mode 100644
index 0000000..89a9cfd
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -0,0 +1,1349 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#define DEBUG
+
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include "regs-mfc5.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_memory.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_debug.h"
+
+#include <linux/firmware.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/cma.h>
+
+#include <linux/dma-mapping.h>
+#include <asm/cacheflush.h>
+
+#include <media/videobuf2-cma.h>
+
+static void *s5p_mfc_bitproc_buf;
+static size_t s5p_mfc_bitproc_phys;
+static unsigned char *s5p_mfc_bitproc_virt;
+
+/* #define S5P_MFC_DEBUG_REGWRITE  */
+#ifdef S5P_MFC_DEBUG_REGWRITE
+#undef writel
+#define writel(v, r) do { \
+	printk(KERN_ERR "MFCWRITE(%p): %08x\n", r, (unsigned int)v); \
+	__raw_writel(v, r); } while (0)
+#endif /* S5P_MFC_DEBUG_REGWRITE */
+
+#define READL(offset)		readl(dev->regs_base + (offset))
+#define WRITEL(data, offset)	writel((data), dev->regs_base + (offset))
+#define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
+#define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
+
+static inline void *s5p_mfc_mem_alloc(void *a, unsigned int s)
+{
+	return vb2_cma_memops.alloc(a, s);
+}
+
+static inline size_t s5p_mfc_mem_paddr(void *a, void *b)
+{
+	return (size_t)vb2_cma_memops.cookie(b);
+}
+
+static inline void s5p_mfc_mem_put(void *a, void *b)
+{
+	vb2_cma_memops.put(b);
+}
+
+static inline void *s5p_mfc_mem_vaddr(void *a, void *b)
+{
+	return vb2_cma_memops.vaddr(b);
+}
+
+static void s5p_mfc_mem_cache_clean(const void *start_addr, unsigned long size)
+{
+	unsigned long paddr;
+
+	dmac_map_area(start_addr, size, DMA_TO_DEVICE);
+	/*
+	 * virtual & phsical addrees mapped directly, so we can convert
+	 * the address just using offset
+	 */
+	paddr = __pa((unsigned long)start_addr);
+	outer_clean_range(paddr, paddr + size);
+}
+
+static void s5p_mfc_mem_cache_inv(const void *start_addr, unsigned long size)
+{
+	unsigned long paddr;
+
+	paddr = __pa((unsigned long)start_addr);
+	outer_inv_range(paddr, paddr + size);
+	dmac_unmap_area(start_addr, size, DMA_FROM_DEVICE);
+}
+
+void s5p_mfc_write_shm(const void *start_addr, unsigned int data,
+			unsigned long offset)
+{
+	writel(data, (start_addr + offset));
+	s5p_mfc_mem_cache_clean((void *)(start_addr + offset), 4);
+}
+
+unsigned int s5p_mfc_read_shm(const void *start_addr, unsigned long offset)
+{
+	s5p_mfc_mem_cache_inv((void *)(start_addr + offset), 4);
+
+	return readl(start_addr + offset);
+}
+
+/* Reset the device */
+static int s5p_mfc_cmd_reset(struct s5p_mfc_dev *dev)
+{
+	unsigned int mc_status;
+	unsigned long timeout;
+
+	mfc_debug_enter();
+	/* Stop procedure */
+	WRITEL(0x3f6, S5P_FIMV_SW_RESET);	/*  reset RISC */
+	WRITEL(0x3e2, S5P_FIMV_SW_RESET);	/*  All reset except for MC */
+	mdelay(10);
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* Check MC status */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while resetting MFC.\n");
+			return -EIO;
+		}
+		mc_status = READL(S5P_FIMV_MC_STATUS);
+	} while (mc_status & 0x3);
+	WRITEL(0x0, S5P_FIMV_SW_RESET);
+	WRITEL(0x3fe, S5P_FIMV_SW_RESET);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Send a command to the MFC */
+static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev,
+				struct s5p_mfc_ctx *ctx, int cmd, int arg)
+{
+	int cur_cmd;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* wait until host to risc command register becomes 'H2R_CMD_EMPTY' */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while waiting for hardware.\n");
+			return -EIO;
+		}
+		cur_cmd = READL(S5P_FIMV_HOST2RISC_CMD);
+	} while (cur_cmd != S5P_FIMV_H2R_CMD_EMPTY);
+	WRITEL(arg, S5P_FIMV_HOST2RISC_ARG1);
+	if (cmd == S5P_FIMV_H2R_CMD_OPEN_INSTANCE) {
+		/* No CRC calculation (slow!) */
+		WRITEL(0, S5P_FIMV_HOST2RISC_ARG2);
+		/* Physical addr of the instance buffer */
+		WRITEL(OFFSETA(ctx->instance_phys),
+		       S5P_FIMV_HOST2RISC_ARG3);
+		/* Size of the instance buffer */
+		WRITEL(ctx->instance_size, S5P_FIMV_HOST2RISC_ARG4);
+	}
+	/* Issue the command */
+	WRITEL(cmd, S5P_FIMV_HOST2RISC_CMD);
+	return 0;
+}
+/*
+static void s5p_mfc_cmd_sleep()
+{
+	WRITEL(-1, S5P_FIMV_CH_ID);
+	WRITEL(MFC_SLEEP, S5P_FIMV_COMMAND_TYPE);
+}
+*/
+
+/*
+static void s5p_mfc_cmd_wakeup()
+{
+	WRITEL(-1, S5P_FIMV_CH_ID);
+	WRITEL(MFC_WAKEUP, S5P_FIMV_COMMAND_TYPE);
+	mdelay(100);
+}
+*/
+
+
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+{
+	void *desc_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	mfc_debug_enter();
+	ctx->desc_buf = s5p_mfc_mem_alloc(
+			dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
+	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
+		ctx->desc_buf = 0;
+		mfc_err("Allocating DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	ctx->desc_phys = s5p_mfc_mem_paddr(
+			dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->desc_buf);
+	desc_virt = s5p_mfc_mem_vaddr(
+			dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->desc_buf);
+	if (desc_virt == NULL) {
+		s5p_mfc_mem_put(
+			dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = 0;
+		mfc_err("Remapping DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory */
+	memset(desc_virt, 0, DESC_BUF_SIZE);
+	flush_cache_all();
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Release temproary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->desc_phys) {
+		s5p_mfc_mem_put(ctx->dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+								ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = 0;
+	}
+}
+
+/* Allocate codec buffers */
+int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int luma_size, chroma_size, mv_size;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	luma_size = ctx->luma_size;
+	chroma_size = ctx->chroma_size;
+	mv_size = ctx->mv_size;
+	mfc_debug("Luma size:%d Chroma size:%d MV size:%d Totals bufs: %d\n",
+		  luma_size, chroma_size, mv_size, ctx->total_dpb_count);
+	/* Codecs have different memory requirements */
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+		ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
+					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
+					S5P_FIMV_DEC_BUF_ALIGN);
+		/* TODO, when merged with FIMC then test will it work without
+		 * alignment to 8192. For all codecs. */
+		ctx->port_b_size =
+		    ctx->total_dpb_count * mv_size;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_FIMV_CODEC_DIVX412_DEC:
+	case S5P_FIMV_CODEC_DIVX311_DEC:
+	case S5P_FIMV_CODEC_DIVX502_DEC:
+	case S5P_FIMV_CODEC_DIVX503_DEC:
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
+	case S5P_FIMV_CODEC_H264_ENC:
+		ctx->port_a_size =
+			ALIGN(luma_size, S5P_FIMV_ENC_BUF_ALIGN) * 2 +
+			S5P_FIMV_ENC_UPMV_SIZE +
+			S5P_FIMV_ENC_COLFLG_SIZE +
+			S5P_FIMV_ENC_INTRAMD_SIZE +
+			S5P_FIMV_ENC_NBORINFO_SIZE;
+		ctx->port_b_size =
+			ALIGN(luma_size, S5P_FIMV_ENC_BUF_ALIGN) * 2 +
+			ALIGN(chroma_size, S5P_FIMV_ENC_BUF_ALIGN) * 4 +
+			S5P_FIMV_ENC_INTRAPRED_SIZE;
+		break;
+	default:
+		break;
+	}
+
+	/* Allocate only if memory from bank 1 is necessary */
+	if (ctx->port_a_size > 0) {
+		ctx->port_a_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->port_a_size);
+		if (IS_ERR(ctx->port_a_buf)) {
+			ctx->port_a_buf = 0;
+			printk(KERN_ERR
+			       "Buf alloc for decoding failed (port A).\n");
+			return -ENOMEM;
+		}
+		ctx->port_a_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->port_a_buf);
+	}
+
+	/* Allocate only if memory from bank 2 is necessary */
+	if (ctx->port_b_size > 0) {
+		ctx->port_b_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX], ctx->port_b_size);
+		if (IS_ERR(ctx->port_b_buf)) {
+			ctx->port_b_buf = 0;
+			mfc_err("Buf alloc for decoding failed (port B).\n");
+			return -ENOMEM;
+		}
+		ctx->port_b_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX], ctx->port_b_buf);
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
+		s5p_mfc_mem_put(ctx->dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->port_a_buf);
+		ctx->port_a_buf = 0;
+		ctx->port_a_phys = 0;
+		ctx->port_a_size = 0;
+	}
+	if (ctx->port_b_buf) {
+		s5p_mfc_mem_put(ctx->dev->alloc_ctx[MFC_CMA_BANK2_ALLOC_CTX],
+							ctx->port_b_buf);
+		ctx->port_b_buf = 0;
+		ctx->port_b_phys = 0;
+		ctx->port_b_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
+{
+	void *instance_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		ctx->instance_size = MFC_H264_INSTANCE_BUF_SIZE;
+	else
+		ctx->instance_size = MFC_INSTANCE_BUF_SIZE;
+	ctx->instance_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->instance_size);
+	if (IS_ERR(ctx->instance_buf)) {
+		mfc_err("Allocating instance buffer failed.\n");
+		ctx->instance_phys = 0;
+		ctx->instance_buf = 0;
+		return -ENOMEM;
+	}
+	ctx->instance_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->instance_buf);
+	instance_virt = s5p_mfc_mem_vaddr(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->instance_buf);
+	if (instance_virt == NULL) {
+		mfc_err("Remapping instance buffer failed.\n");
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->instance_buf);
+		ctx->instance_phys = 0;
+		ctx->instance_buf = 0;
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory */
+	memset(instance_virt, 0, ctx->instance_size);
+	flush_cache_all();
+	ctx->shared_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], SHARED_BUF_SIZE);
+	if (IS_ERR(ctx->shared_buf)) {
+		mfc_err("Allocating shared buffer failed\n");
+		ctx->shared_buf = 0;
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->instance_buf);
+		ctx->instance_phys = 0;
+		ctx->instance_buf = 0;
+		return -ENOMEM;
+	}
+	ctx->shared_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->shared_buf);
+	ctx->shared_virt = s5p_mfc_mem_vaddr(
+		dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX], ctx->shared_buf);
+	if (!ctx->shared_virt) {
+		mfc_err("Remapping shared buffer failed\n");
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->shared_buf);
+		ctx->shared_phys = 0;
+		ctx->shared_buf = 0;
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->instance_buf);
+		ctx->instance_phys = 0;
+		ctx->instance_buf = 0;
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory */
+	memset((void *)ctx->shared_virt, 0, SHARED_BUF_SIZE);
+	flush_cache_all();
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Release instance buffer */
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	if (ctx->instance_buf) {
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->instance_buf);
+		ctx->instance_phys = 0;
+		ctx->instance_buf = 0;
+	}
+	if (ctx->shared_phys) {
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_BANK1_ALLOC_CTX],
+							ctx->shared_buf);
+		ctx->shared_phys = 0;
+		ctx->shared_buf = 0;
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
+
+	WRITEL(ctx->shared_phys - ctx->dev->port_a,
+	       S5P_FIMV_SI_CH0_HOST_WR_ADR);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int buf_size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	mfc_debug("inst_no: %d, buf_addr: 0x%08x, buf_size: 0x"
+		"%08x (%d)\n",  ctx->inst_no, buf_addr, buf_size, buf_size);
+	WRITEL(OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
+	WRITEL(CPB_BUF_SIZE, S5P_FIMV_SI_CH0_CPB_SIZE);
+	WRITEL(buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
+	mfc_debug("Shared_virt: %p (start offset: %d)\n",
+					ctx->shared_virt, start_num_byte);
+	s5p_mfc_set_start_num(ctx, start_num_byte);
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
+	mfc_debug("Buf1: %p (%d) Buf2: %p (%d)\n", (void *)buf_addr1, buf_size1,
+						(void *)buf_addr2, buf_size2);
+	mfc_debug("Total DPB COUNT: %d\n", ctx->total_dpb_count);
+	mfc_debug("Setting display delay to %d\n", ctx->display_delay);
+	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~S5P_FIMV_DPB_COUNT_MASK;
+	WRITEL(ctx->total_dpb_count | dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	s5p_mfc_set_shared_buffer(ctx);
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VERT_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_VERT_NB_IP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_FIMV_CODEC_DIVX311_DEC:
+	case S5P_FIMV_CODEC_DIVX412_DEC:
+	case S5P_FIMV_CODEC_DIVX502_DEC:
+	case S5P_FIMV_CODEC_DIVX503_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_SP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_STX_PARSER_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_STX_PARSER_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		break;
+	case S5P_FIMV_CODEC_H263_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		break;
+	case S5P_FIMV_CODEC_VC1_DEC:
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_BITPLANE3_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_BITPLANE2_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_BITPLANE1_ADR);
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
+	mfc_debug("Frame size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
+								frame_size_mv);
+	for (i = 0; i < ctx->total_dpb_count; i++) {
+		/* Port B */
+		mfc_debug("Luma %d: %x\n", i, ctx->dst_bufs[i].paddr.raw.luma);
+		WRITEL(OFFSETB(ctx->dst_bufs[i].paddr.raw.luma),
+						S5P_FIMV_LUMA_ADR + i * 4);
+		mfc_debug("\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].paddr.raw.chroma);
+		WRITEL(OFFSETA(ctx->dst_bufs[i].paddr.raw.chroma),
+					       S5P_FIMV_CHROMA_ADR + i * 4);
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+			mfc_debug("\tBuf2: %x, size: %d\n",
+							buf_addr2, buf_size2);
+			WRITEL(OFFSETB(buf_addr2), S5P_FIMV_MV_ADR + i * 4);
+			buf_addr2 += frame_size_mv;
+			buf_size2 -= frame_size_mv;
+		}
+	}
+	mfc_debug("Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
+	mfc_debug("Buf 1/2 size after: %d/%d (frames %d)\n",
+			buf_size1,  buf_size2, ctx->total_dpb_count);
+	if (buf_size1 < 0 || buf_size2 < 0) {
+		mfc_debug("Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	s5p_mfc_set_luma_size(ctx, frame_size);
+	s5p_mfc_set_chroma_size(ctx, frame_size_ch);
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+		s5p_mfc_set_mv_size(ctx, frame_size_mv);
+
+	WRITEL(((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug("After setting buffers.\n");
+	return 0;
+}
+
+/* Set registers for encoding stream buffer */
+int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(OFFSETA(addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
+	WRITEL(size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
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
+	*y_addr = dev->port_b + (READL(S5P_FIMV_ENCODED_Y_ADDR) << 11);
+	*c_addr = dev->port_b + (READL(S5P_FIMV_ENCODED_C_ADDR) << 11);
+}
+
+/* Set encoding ref & codec buffer */
+int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	size_t buf_addr1, buf_addr2;
+	size_t buf_size1, buf_size2;
+	unsigned int luma_size, chroma_size;
+	int i;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("++\n");
+
+	luma_size = ALIGN(mfc_ctx->luma_size, S5P_FIMV_ENC_BUF_ALIGN);
+	chroma_size = ALIGN(mfc_ctx->chroma_size, S5P_FIMV_ENC_BUF_ALIGN);
+
+	buf_addr1 = mfc_ctx->port_a_phys;
+	buf_size1 = mfc_ctx->port_a_size;
+	buf_addr2 = mfc_ctx->port_b_phys;
+	buf_size2 = mfc_ctx->port_b_size;
+
+	mfc_debug("buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
+
+	switch (mfc_ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_ENC:
+		for (i = 0; i < 2; i++) {
+			WRITEL(OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += luma_size;
+			buf_size1 -= luma_size;
+
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += luma_size;
+			buf_size2 -= luma_size;
+		}
+
+		for (i = 0; i < 4; i++) {
+			WRITEL(OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += chroma_size;
+			buf_size2 -= chroma_size;
+		}
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_ENC_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_ENC_COZERO_FLAG_ADR);
+		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_ENC_UP_INTRA_MD_ADR);
+		buf_addr1 += S5P_FIMV_ENC_INTRAMD_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_INTRAMD_SIZE;
+
+		WRITEL(OFFSETB(buf_addr2), S5P_FIMV_ENC_UP_INTRA_PRED_ADR);
+		buf_addr2 += S5P_FIMV_ENC_INTRAPRED_SIZE;
+		buf_size2 -= S5P_FIMV_ENC_INTRAPRED_SIZE;
+
+		WRITEL(OFFSETA(buf_addr1), S5P_FIMV_ENC_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
+
+		mfc_debug("buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+	default:
+		mfc_err("Unknown codec set for encoding: %d\n",
+			mfc_ctx->codec_mode);
+		return -EINVAL;
+	}
+
+	mfc_debug("--\n");
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
+	if (p->slice_mode == V4L2_CODEC_MFC51_ENC_MULTI_SLICE_MODE_MACROBLOCK_COUNT) {
+		WRITEL(p->slice_mb, S5P_FIMV_ENC_MSLICE_MB);
+	} else if (p->slice_mode == V4L2_CODEC_MFC51_ENC_MULTI_SLICE_MODE_BIT_COUNT) {
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
+	/*
+	if (ctx->enc_src_fmt->fourcc == V4L2_PIX_FMT_NV12)
+		WRITEL(S5P_FIMV_ENC_MAP_FOR_CUR, 0);
+	else if (ctx->enc_src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		WRITEL(S5P_FIMV_ENC_MAP_FOR_CUR, 3);
+	*/
+
+	/* padding control & value */
+	reg = READL(S5P_FIMV_ENC_PADDING_CTRL);
+	if (p->pad == V4L2_CODEC_MFC51_ENC_SW_ENABLE) {
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
+	if (p->rc_frame == V4L2_CODEC_MFC51_ENC_SW_ENABLE)
+		WRITEL(p->rc_bitrate,
+			S5P_FIMV_ENC_RC_BIT_RATE);
+	else
+		WRITEL(0, S5P_FIMV_ENC_RC_BIT_RATE);
+
+	/* reaction coefficient */
+	if (p->rc_frame == V4L2_CODEC_MFC51_ENC_SW_ENABLE)
+		WRITEL(p->rc_reaction_coeff, S5P_FIMV_ENC_RC_RPARA);
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx->shared_virt,
+		S5P_FIMV_SHARED_EXT_ENC_CONTROL);
+	/** vbv buffer size */
+	if (p->frame_skip_mode == V4L2_CODEC_MFC51_ENC_FRAME_SKIP_MODE_VBV_BUF_SIZE) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p->vbv_buf_size << 16);
+	}
+	/** seq header ctrl */
+	shm &= ~(0x1 << 3);
+	shm |= (p->seq_hdr_mode << 3);
+	/** frame skip mode */
+	shm &= ~(0x3 << 1);
+	shm |= (p->frame_skip_mode << 1);
+	s5p_mfc_write_shm(ctx->shared_virt, shm,
+		S5P_FIMV_SHARED_EXT_ENC_CONTROL);
+
+	/* fixed target bit */
+	s5p_mfc_write_shm(ctx->shared_virt, p->fixed_target_bit,
+		S5P_FIMV_SHARED_RC_CONTROL_CONFIG);
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
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/** num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p_264->num_b_frame << 16);
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
+	/* interface  */
+	WRITEL(p_264->interlace, S5P_FIMV_ENC_PIC_STRUCT);
+	/** height */
+	if (p_264->interlace == V4L2_CODEC_MFC51_ENC_SW_ENABLE)
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
+	WRITEL(p_264->entropy_mode, S5P_FIMV_ENC_H264_ENTRP_MODE);
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
+	if (p->rc_frame == V4L2_CODEC_MFC51_ENC_SW_ENABLE)
+		WRITEL(p_264->rc_framerate * 1000,
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
+	if (p_264->rc_mb == V4L2_CODEC_MFC51_ENC_SW_ENABLE) {
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
+	if ((p->rc_frame == V4L2_CODEC_MFC51_ENC_SW_DISABLE) &&
+	    (p_264->rc_mb == V4L2_CODEC_MFC51_ENC_SW_DISABLE)) {
+		shm = s5p_mfc_read_shm(ctx->shared_virt,
+			S5P_FIMV_SHARED_P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
+		shm |= (p_264->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_shm(ctx->shared_virt, shm,
+			S5P_FIMV_SHARED_P_B_FRAME_QP);
+	}
+
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_shm(ctx->shared_virt,
+		S5P_FIMV_SHARED_EXT_ENC_CONTROL);
+	/** AR VUI control */
+	shm &= ~(0x1 << 15);
+	shm |= (p_264->ar_vui << 1);
+	s5p_mfc_write_shm(ctx->shared_virt, shm,
+		S5P_FIMV_SHARED_EXT_ENC_CONTROL);
+
+	if (p_264->ar_vui == V4L2_CODEC_MFC51_ENC_SW_ENABLE) {
+		/* aspect ration IDC */
+		shm = s5p_mfc_read_shm(ctx->shared_virt,
+			S5P_FIMV_SHARED_ASPECT_RATIO_IDC);
+		shm &= ~(0xFF);
+		shm |= p_264->ar_vui_idc;
+		s5p_mfc_write_shm(ctx->shared_virt, shm,
+			S5P_FIMV_SHARED_ASPECT_RATIO_IDC);
+
+		if (p_264->ar_vui_idc == 0xFF) {
+			/* sample  AR info */
+			shm = s5p_mfc_read_shm(ctx->shared_virt,
+				S5P_FIMV_SHARED_EXTENDED_SAR);
+			shm &= ~(0xFFFFFFFF);
+			shm |= p_264->ext_sar_width << 16;
+			shm |= p_264->ext_sar_height;
+			s5p_mfc_write_shm(ctx->shared_virt, shm,
+				S5P_FIMV_SHARED_EXTENDED_SAR);
+		}
+	}
+
+	/* intra picture period for H.264 */
+	shm = s5p_mfc_read_shm(ctx->shared_virt,
+		S5P_FIMV_SHARED_H264_I_PERIOD);
+	/** control */
+	shm &= ~(0x1 << 16);
+	shm |= (p_264->open_gop << 16);
+	/** value */
+	if (p_264->open_gop == V4L2_CODEC_MFC51_ENC_SW_ENABLE) {
+		shm &= ~(0xFFFF);
+		shm |= p_264->open_gop_size;
+	}
+	s5p_mfc_write_shm(ctx->shared_virt, shm,
+		S5P_FIMV_SHARED_H264_I_PERIOD);
+
+	return 0;
+}
+
+/* Allocate firmware */
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
+{
+	int err;
+	struct cma_info mem_info_f, mem_info_a, mem_info_b;
+	mfc_debug_enter();
+	if (s5p_mfc_bitproc_buf) {
+		mfc_err("MFC firmware is already loaded.\n");
+		return -ENOMEM;
+	}
+	/* Get memory region information and check if it is correct */
+	err = cma_info(&mem_info_f, dev->v4l2_dev.dev, MFC_CMA_FW);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has size %08x", "f",
+				mem_info_f.lower_bound, mem_info_f.upper_bound,
+							mem_info_f.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information from CMA.\n");
+		return -EINVAL;
+	}
+	err = cma_info(&mem_info_a, dev->v4l2_dev.dev, MFC_CMA_BANK1);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has size %08x", "a",
+			mem_info_a.lower_bound, mem_info_a.upper_bound,
+						mem_info_a.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information from CMA.\n");
+		return -EINVAL;
+	}
+	err = cma_info(&mem_info_b, dev->v4l2_dev.dev, MFC_CMA_BANK2);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has size %08x", "b",
+		mem_info_b.lower_bound, mem_info_b.upper_bound,
+					mem_info_b.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information from CMA.\n");
+		return -EINVAL;
+	}
+	if (mem_info_f.upper_bound > mem_info_a.lower_bound) {
+			mfc_err("Firmware has to be "
+			"allocated before  memory for buffers (bank A).\n");
+		return -EINVAL;
+	}
+	mfc_debug("Allocating memory for firmware.\n");
+	s5p_mfc_bitproc_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX], FIRMWARE_CODE_SIZE);
+	if (IS_ERR(s5p_mfc_bitproc_buf)) {
+		s5p_mfc_bitproc_buf = 0;
+		printk(KERN_ERR "Allocating bitprocessor buffer failed\n");
+		return -ENOMEM;
+	}
+	s5p_mfc_bitproc_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX], s5p_mfc_bitproc_buf);
+	if (s5p_mfc_bitproc_phys & (128 << 10)) {
+		mfc_err("The base memory is not aligned to 128KB.\n");
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX],
+							s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+	dev->port_a = s5p_mfc_bitproc_phys;
+	dev->port_b = mem_info_b.lower_bound;
+	mfc_debug("Port A: %08x Port B: %08x (FW: %08x size: %08x)\n",
+				dev->port_a, dev->port_b, s5p_mfc_bitproc_phys,
+							FIRMWARE_CODE_SIZE);
+	s5p_mfc_bitproc_virt = s5p_mfc_mem_vaddr(
+		dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX], s5p_mfc_bitproc_buf);
+	mfc_debug("Virtual address for FW: %08lx\n",
+				(long unsigned int)s5p_mfc_bitproc_virt);
+	if (!s5p_mfc_bitproc_virt) {
+		mfc_err("Bitprocessor memory remap failed\n");
+		s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX],
+							s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+	mfc_debug_leave();
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
+	mfc_debug("Requesting fw\n");
+	err = request_firmware((const struct firmware **)&fw_blob,
+				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
+	mfc_debug("Ret of request_firmware: %d Size: %d\n", err, fw_blob->size);
+	if (err != 0) {
+		mfc_err("failed to requeset MFC firmware.\n");
+		return -EINVAL;
+	}
+	if (fw_blob->size > FIRMWARE_CODE_SIZE) {
+		mfc_err("MFC firmware is too big to be loaded.\n");
+		release_firmware(fw_blob);
+		return -ENOMEM;
+	}
+	if (s5p_mfc_bitproc_buf == 0 || s5p_mfc_bitproc_phys == 0) {
+		mfc_err("failed to get MFC firmware buffer.\n");
+		release_firmware(fw_blob);
+		return -EINVAL;
+	}
+	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
+	flush_cache_all();
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
+	s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX],
+							s5p_mfc_bitproc_buf);
+	s5p_mfc_bitproc_virt =  0;
+	s5p_mfc_bitproc_phys = 0;
+	s5p_mfc_bitproc_buf = 0;
+	return 0;
+}
+
+/* Initialize hardware */
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
+{
+	int fw_buf_size;
+	unsigned int fw_version;
+	int ret;
+
+	mfc_debug_enter();
+	mfc_debug("Device pointer: %p\n", dev);
+	if (!s5p_mfc_bitproc_buf)
+		return -EINVAL;
+	/* 0. MFC reset */
+	mfc_debug("MFC reset...\n");
+	ret = s5p_mfc_cmd_reset(dev);
+	if (ret) {
+		mfc_err("Failed to reset MFC - timeout.\n");
+		return ret;
+	}
+	mfc_debug("Done MFC reset...\n");
+	/* 1. Set DRAM base Addr */
+	WRITEL(dev->port_a, S5P_FIMV_MC_DRAMBASE_ADR_A); /* channelA, port0 */
+	WRITEL(dev->port_b, S5P_FIMV_MC_DRAMBASE_ADR_B); /* channelB, port1 */
+	mfc_debug("Port A: %08x, Port B: %08x\n", dev->port_a, dev->port_b);
+	/* 2. Initialize registers of stream I/F for decoder */
+	WRITEL(0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
+	WRITEL(0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
+	WRITEL(0, S5P_FIMV_RISC2HOST_CMD);
+	WRITEL(0, S5P_FIMV_HOST2RISC_CMD);
+	/* 3. Release reset signal to the RISC.  */
+	WRITEL(0x3ff, S5P_FIMV_SW_RESET);
+	mfc_debug("Will now wait for completion of firmware transfer.\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_FW_STATUS_RET)) {
+		mfc_err("Failed to load firmware.\n");
+		s5p_mfc_clean_dev_int_flags(dev);
+		return -EIO;
+	}
+	s5p_mfc_clean_dev_int_flags(dev);
+	/* 4. Initialize firmware */
+	fw_buf_size = FIRMWARE_CODE_SIZE;
+	mfc_debug("Writing a command\n");
+	ret = s5p_mfc_cmd_host2risc(dev, 0, S5P_FIMV_H2R_CMD_SYS_INIT,
+								fw_buf_size);
+	if (ret) {
+		mfc_err("Failed to send command to MFC - timeout.\n");
+		return ret;
+	}
+	mfc_debug("Ok, now will write a command to init the system\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SYS_INIT_RET)) {
+		mfc_err("Failed to load firmware\n");
+		return -EIO;
+	}
+	dev->int_cond = 0;
+	if (dev->int_err != 0 || dev->int_type !=
+						S5P_FIMV_R2H_CMD_SYS_INIT_RET) {
+		/* Failure. */
+		mfc_err("Failed to init firmware - error: %d"
+				" int: %d.\n", dev->int_err, dev->int_type);
+		return -EIO;
+	}
+	fw_version = READL(S5P_FIMV_FW_VERSION);
+	mfc_info("MFC FW version : %02xyy, %02xmm, %02xdd\n",
+		 (fw_version >> S5P_FIMV_FW_Y_SHIFT) & S5P_FIMV_FW_MASK,
+		 (fw_version >> S5P_FIMV_FW_M_SHIFT) & S5P_FIMV_FW_MASK,
+		 (fw_version >> S5P_FIMV_FW_D_SHIFT) & S5P_FIMV_FW_MASK);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Open a new instance and get its number */
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *ctx)
+{
+	int ret;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	mfc_debug("Requested codec mode: %d\n", ctx->codec_mode);
+	ret = s5p_mfc_cmd_host2risc(ctx->dev, ctx, \
+			S5P_FIMV_H2R_CMD_OPEN_INSTANCE, ctx->codec_mode);
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Close instance */
+int s5p_mfc_return_inst_no(struct s5p_mfc_ctx *ctx)
+{
+	int ret = 0;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	if (ctx->state != MFCINST_FREE) {
+		ret = s5p_mfc_cmd_host2risc(dev, ctx,
+			S5P_FIMV_H2R_CMD_CLOSE_INSTANCE, ctx->inst_no);
+	} else {
+		ret = -EINVAL;
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Initialize decoding */
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
+	mfc_debug("InstNo: %d/%d\n", ctx->inst_no, S5P_FIMV_CH_SEQ_HEADER);
+	s5p_mfc_set_shared_buffer(ctx);
+	mfc_debug("BUFs: %08x %08x %08x %08x %08x\n",
+		  READL(S5P_FIMV_SI_CH0_DESC_ADR),
+		  READL(S5P_FIMV_SI_CH0_CPB_SIZE),
+		  READL(S5P_FIMV_SI_CH0_DESC_SIZE),
+		  READL(S5P_FIMV_SI_CH0_SB_ST_ADR),
+		  READL(S5P_FIMV_SI_CH0_SB_FRM_SIZE));
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC) {
+		mfc_debug("Set loop filter to: %d\n", ctx->loop_filter_mpeg4);
+		WRITEL(ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
+	} else {
+		WRITEL(0, S5P_FIMV_ENC_LF_CTRL);
+	}
+	WRITEL(((ctx->slice_interface & S5P_FIMV_SLICE_INT_MASK) <<
+		S5P_FIMV_SLICE_INT_SHIFT) | ((ctx->display_delay > 0 ? 1 : 0) <<
+		S5P_FIMV_DDELAY_ENA_SHIFT) | ((ctx->display_delay &
+		S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
+		S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	if (ctx->codec_mode == S5P_FIMV_CODEC_DIVX311_DEC) {
+		mfc_debug("Setting DivX 3.11 resolution to %dx%d\n",
+					ctx->img_width, ctx->img_height);
+		WRITEL(ctx->img_width, S5P_FIMV_SI_DIVX311_HRESOL);
+		WRITEL(ctx->img_height, S5P_FIMV_SI_DIVX311_VRESOL);
+	}
+	WRITEL(
+	((S5P_FIMV_CH_SEQ_HEADER & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, int last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug("Setting flags to %08lx (free:%d WTF:%d)\n",
+				ctx->dec_dst_flag, ctx->dst_queue_cnt,
+						ctx->dst_bufs_cnt);
+	WRITEL(ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
+	s5p_mfc_set_shared_buffer(ctx);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	if (!last_frame)
+		WRITEL(((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	else
+		WRITEL(((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	mfc_debug("Decoding a usual frame.\n");
+	return 0;
+}
+
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("++\n");
+
+	s5p_mfc_set_enc_params_h264(mfc_ctx);
+
+	s5p_mfc_set_shared_buffer(mfc_ctx);
+
+	WRITEL(((S5P_FIMV_CH_SEQ_HEADER << 16) & 0x70000) | (mfc_ctx->inst_no),
+		S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug("--\n");
+
+	return 0;
+}
+
+/* Encode a single frame */
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("++\n");
+
+	/* memory structure cur. frame */
+	/*
+	if (ctx->enc_src_fmt->fourcc == V4L2_PIX_FMT_NV12)
+		WRITEL(S5P_FIMV_ENC_MAP_FOR_CUR, 0);
+	else if (ctx->enc_src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		WRITEL(S5P_FIMV_ENC_MAP_FOR_CUR, 3);
+	*/
+
+	s5p_mfc_set_shared_buffer(mfc_ctx);
+
+	WRITEL((S5P_FIMV_CH_FRAME_START << 16 & 0x70000) | (mfc_ctx->inst_no),
+		S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug("--\n");
+
+	return 0;
+}
+
+/* Deinitialize hardware */
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_cmd_reset(dev);
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
new file mode 100644
index 0000000..8311cec
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -0,0 +1,147 @@
+/*
+ * Samsung S5P Multi Format Codec v5.1
+ *
+ * This file ontains declarations of hw related functions
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Kamil Debski, <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef S5P_MFC_OPR_H_
+#define S5P_MFC_OPR_H_
+
+#include <asm/cacheflush.h>
+#include "s5p_mfc_common.h"
+
+int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
+int s5p_mfc_set_sleep(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_wakeup(struct s5p_mfc_ctx *ctx);
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
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, int last_frame);
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *mfc_ctx);
+
+/* Instance handling */
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_return_inst_no(struct s5p_mfc_ctx *ctx);
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
+/* Getting parameters from MFC */
+static inline u32 s5p_mfc_get_h_crop(struct s5p_mfc_ctx *ctx)
+{
+	flush_cache_all();
+	return readl((ctx)->shared_virt + S5P_FIMV_SHARED_CROP_INFO_H);
+}
+
+static inline u32 s5p_mfc_get_v_crop(struct s5p_mfc_ctx *ctx)
+{
+	flush_cache_all();
+	return readl((ctx)->shared_virt + S5P_FIMV_SHARED_CROP_INFO_V);
+}
+
+#define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
+					S5P_FIMV_SI_DISPLAY_Y_ADR) << 11)
+#define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
+						S5P_FIMV_SI_DISPLAY_STATUS)
+#define s5p_mfc_get_frame_type()	(readl(dev->regs_base + \
+						S5P_FIMV_DECODE_FRAME_TYPE) \
+					& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
+						S5P_FIMV_SI_CONSUMED_BYTES)
+#define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
+					S5P_FIMV_RISC2HOST_CMD) & 0x1FFFF)
+#define s5p_mfc_get_int_err()		readl(dev->regs_base + \
+						S5P_FIMV_RISC2HOST_ARG2)
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
+static inline u32 s5p_mfc_get_pic_time_top(struct s5p_mfc_ctx *ctx)
+{
+	flush_cache_all();
+	return readl((ctx)->shared_virt + S5P_FIMV_SHARED_PIC_TIME_TOP);
+}
+
+static inline u32 s5p_mfc_get_pic_time_bottom(struct s5p_mfc_ctx *ctx)
+{
+	flush_cache_all();
+	return readl((ctx)->shared_virt + S5P_FIMV_SHARED_PIC_TIME_BOTTOM);
+}
+
+#define s5p_mfc_set_start_num(ctx, x) do { \
+			writel((x), \
+			ctx->shared_virt + S5P_FIMV_SHARED_START_BYTE_NUM); \
+			flush_cache_all(); \
+			} while (0)
+
+#define s5p_mfc_set_luma_size(ctx, x) do { \
+			writel((x), \
+			ctx->shared_virt + S5P_FIMV_SHARED_LUMA_DPB_SIZE); \
+			flush_cache_all(); \
+			} while (0)
+
+#define s5p_mfc_set_chroma_size(ctx, x) do { \
+			writel((x), \
+			 ctx->shared_virt + S5P_FIMV_SHARED_CHROMA_DPB_SIZE); \
+			 flush_cache_all(); \
+			 } while (0)
+
+#define s5p_mfc_set_mv_size(ctx, x) do { \
+			writel((x), \
+			ctx->shared_virt + S5P_FIMV_SHARED_MV_SIZE); \
+			flush_cache_all(); \
+			} while (0)
+
+/* Interrupt handling routines */
+#define s5p_mfc_clear_int_flags()				\
+do {								\
+	writel(0, dev->regs_base + S5P_FIMV_RISC_HOST_INT);	\
+	writel(0, dev->regs_base + S5P_FIMV_RISC2HOST_CMD);	\
+	writel(0xffff, dev->regs_base + S5P_FIMV_SI_RTN_CHID);	\
+} while (0)
+#endif /* S5P_MFC_OPR_H_ */
-- 
1.6.2.5

