Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65471 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0KBKmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 06:42:54 -0400
Date: Tue, 02 Nov 2010 11:42:42 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v2 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <1288694563-18489-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1288694563-18489-4-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1288694563-18489-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Multi Format Codec 5.1 is a module available on S5PC110 and S5PC210
Samsung SoCs. Hardware is capable of handling a range of video codecs
and this driver provides V4L2 interface for video decoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    3 +
 drivers/media/video/s5p-mfc/regs-mfc5.h      |  304 ++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 1948 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  190 +++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  173 +++
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   44 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   88 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   32 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  836 +++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   90 ++
 13 files changed, 3743 insertions(+), 0 deletions(-)
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
index 6d0bd36..e141cab 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1047,4 +1047,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	  This is a v4l2 driver for the S5P camera interface
 	  (video postprocessor)
 
+config VIDEO_SAMSUNG_S5P_MFC
+	tristate "Samsung S5P MFC 5.1 Video Codec"
+	depends on VIDEO_V4L2 && CMA
+	select VIDEOBUF2_CMA
+	default n
+	help
+	    MFC 5.1 driver for V4L2.
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 4146700..117a3cb 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -178,6 +178,7 @@ obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/video/s5p-mfc/Makefile
new file mode 100644
index 0000000..69b6294
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
+s5p-mfc-y := s5p_mfc.o s5p_mfc_intr.o  s5p_mfc_opr.o
+
diff --git a/drivers/media/video/s5p-mfc/regs-mfc5.h b/drivers/media/video/s5p-mfc/regs-mfc5.h
new file mode 100644
index 0000000..9973ae1
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc5.h
@@ -0,0 +1,304 @@
+/*
+ *
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
+#define S5P_FIMV_SYS_MEM_SZ	0x005c
+#define S5P_FIMV_FW_STATUS	0x0080
+/* Memory controller register */
+#define S5P_FIMV_MC_DRAMBASE_ADR_A	0x0508
+#define S5P_FIMV_MC_DRAMBASE_ADR_B	0x050c
+#define S5P_FIMV_MC_STATUS	0x0510
+
+/* Common register */
+#define S5P_FIMV_SYS_MEM_ADR	0x0600 /* firmware buffer */
+#define S5P_FIMV_CPB_BUF_ADR	0x0604 /* stream buffer */
+#define S5P_FIMV_DESC_BUF_ADR	0x0608 /* descriptor buffer */
+/* H264 decoding */
+#define S5P_FIMV_VERT_NB_MV_ADR	0x068c /* vertical neighbor motion vector */
+#define S5P_FIMV_VERT_NB_IP_ADR	0x0690 /* neighbor pixels for intra pred */
+#define S5P_FIMV_H264_LUMA_ADR	0x0700 /* Luma0 ~ Luma18 700 */
+#define S5P_FIMV_H264_CHROMA_ADR	0x0600 /* Chroma0 ~ Chroma18 614 */
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
+#define S5P_FIMV_SI_RTN_CHID	0x2000 /* Return CH instance ID register */
+#define S5P_FIMV_SI_CH0_INST_ID	0x2040 /* codec instance ID */
+#define S5P_FIMV_SI_CH1_INST_ID	0x2080 /* codec instance ID */
+/* Decoder */
+#define S5P_FIMV_SI_VRESOL	0x2004 /* vertical resolution of decoder */
+#define S5P_FIMV_SI_HRESOL	0x2008 /* horizontal resolution of decoder */
+#define S5P_FIMV_SI_BUF_NUMBER	0x200c /* number of frames in the decoded pic */
+#define S5P_FIMV_SI_DISPLAY_Y_ADR 0x2010 /* luma address of displayed pic */
+#define S5P_FIMV_SI_DISPLAY_C_ADR 0x2014 /* chroma address of displayed pic */
+#define S5P_FIMV_SI_CONSUMED_BYTES 0x2018 /* Consumed number of bytes to decode
+								a frame */
+#define S5P_FIMV_SI_DISPLAY_STATUS 0x201c /* status of decoded picture */
+#define S5P_FIMV_SI_FRAME_TYPE	0x2020 /* frame type such as skip/I/P/B */
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
+#define S5P_FIMV_CRC_LUMA0	0x2030 /* luma crc data per frame(top field)*/
+#define S5P_FIMV_CRC_CHROMA0	0x2034 /* chroma crc data per frame(top field)*/
+#define S5P_FIMV_CRC_LUMA1	0x2038 /* luma crc data per bottom field */
+#define S5P_FIMV_CRC_CHROMA1	0x203c /* chroma crc data per bottom field */
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
+#define S5P_FIMV_DEC_NB_IP_SIZE			(32*1024)
+#define S5P_FIMV_DEC_VERT_NB_MV_SIZE		(16*1024)
+#define S5P_FIMV_DEC_NB_DCAC_SIZE		(16*1024)
+#define S5P_FIMV_DEC_UPNB_MV_SIZE		(68*1024)
+#define S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE		(136*1024)
+#define S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE     (32*1024)
+#define S5P_FIMV_DEC_VC1_BITPLANE_SIZE		(2*1024)
+#define S5P_FIMV_DEC_STX_PARSER_SIZE		(68*1024)
+
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
+#define S5P_FIMV_ENC_MSLICE_BYTE	0xc514 /* byte number for one slice */
+#define S5P_FIMV_ENC_CIR_CTRL		0xc518 /* number of intra refresh MB */
+#define S5P_FIMV_ENC_MAP_FOR_CUR	0xc51c /* linear or 64x32 tiled mode */
+#define S5P_FIMV_ENC_PADDING_CTRL	0xc520 /* padding control */
+#define S5P_FIMV_ENC_INT_MASK		0xc528 /* interrupt mask */
+
+#define S5P_FIMV_ENC_RC_CONFIG		0xc5a0 /* RC config */
+#define S5P_FIMV_ENC_RC_FRAME_RATE	0xc5a4 /* frame rate */
+#define S5P_FIMV_ENC_RC_BIT_RATE	0xc5a8 /* bit rate */
+#define S5P_FIMV_ENC_RC_QBOUND		0xc5ac /* max/min QP */
+#define S5P_FIMV_ENC_RC_RPARA		0xc5b0 /* rate control reaction coeff */
+#define S5P_FIMV_ENC_RC_MB_CTRL		0xc5b4 /* MB adaptive scaling */
+
+/* Encoder for H264 */
+#define S5P_FIMV_ENC_ENTRP_MODE		0xd004 /* CAVLC or CABAC */
+#define S5P_FIMV_ENC_H264_ALPHA_OFF	0xd008 /* loop filter alpha offset */
+#define S5P_FIMV_ENC_H264_BETA_OFF	0xd00c /* loop filter beta offset */
+#define S5P_FIMV_ENC_H264_NUM_OF_REF	0xd010 /* number of reference for P/B */
+#define S5P_FIMV_ENC_H264_MDINTER_WGT	0xd01c /* inter weighted parameter */
+#define S5P_FIMV_ENC_H264_MDINTRA_WGT	0xd020 /* intra weighted parameter */
+#define S5P_FIMV_ENC_H264_TRANS_FLAG	0xd034 /* 8x8 transform flag in PPS &
+								high profile */
+/* Encoder for MPEG4 */
+#define S5P_FIMV_ENC_MPEG4_QUART_PXL	0xe008 /* qpel interpolation ctrl */
+
+/* Additional */
+#define S5P_FIMV_SI_CH0_DPB_CONF_CTRL   0x2068 /* DPB Config Control Register */
+#define S5P_FIMV_SI_CH0_RELEASE_BUF     0x2060 /* DPB release buffer register */
+#define S5P_FIMV_SI_CH0_HOST_WR_ADR	0x2064 /* address of shared memory */
+#define S5P_FIMV_ENC_B_RECON_WRITE_ON   0xc508 /* B frame recon write ctrl */
+#define S5P_FIMV_ENC_REF_B_LUMA_ADR     0x062c /* ref B Luma addr */
+#define S5P_FIMV_ENC_REF_B_CHROMA_ADR   0x0630 /* ref B Chroma addr */
+#define S5P_FIMV_ENCODED_Y_ADDR         0x2014 /* the address of the encoded
+							luminance picture */
+#define S5P_FIMV_ENCODED_C_ADDR         0x2018 /* the address of the encoded
+							chrominance picture*/
+
+/* Codec numbers  */
+#define S5P_FIMV_CODEC_H264_DEC			0
+#define S5P_FIMV_CODEC_VC1_DEC			1
+#define S5P_FIMV_CODEC_MPEG4_DEC		2
+#define S5P_FIMV_CODEC_MPEG2_DEC		3
+#define S5P_FIMV_CODEC_H263_DEC			4
+#define S5P_FIMV_CODEC_VC1RCV_DEC		5
+#define S5P_FIMV_CODEC_DIVX311_DEC		6
+#define S5P_FIMV_CODEC_DIVX412_DEC		7
+#define S5P_FIMV_CODEC_DIVX502_DEC		8
+#define S5P_FIMV_CODEC_DIVX503_DEC		9
+
+#define S5P_FIMV_CODEC_H264_ENC			16
+#define S5P_FIMV_CODEC_MPEG4_ENC		17
+#define S5P_FIMV_CODEC_H263_ENC			18
+
+/* Channel Control Register */
+#define S5P_FIMV_CH_SEQ_HEADER		1
+#define S5P_FIMV_CH_FRAME_START		2
+#define S5P_FIMV_CH_LAST_FRAME		3
+#define S5P_FIMV_CH_INIT_BUFS		4
+#define S5P_FIMV_CH_FRAME_START_REALLOC	5
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
+/* Shared memory registers' offsets */
+
+/* An offset of the start position in the stream when
+ * the start position is not aligned */
+#define S5P_FIMV_SHARED_CROP_INFO_H		0x0020
+#define S5P_FIMV_SHARED_CROP_INFO_V		0x0024
+#define S5P_FIMV_SHARED_START_BYTE_NUM		0x0018
+#define S5P_FIMV_SHARED_LUMA_DPB_SIZE		0x0064
+#define S5P_FIMV_SHARED_CHROMA_DPB_SIZE		0x0068
+#define S5P_FIMV_SHARED_MV_SIZE			0x006C
+#define S5P_FIMV_SHARED_PIC_TIME_TOP		0x0010
+#define S5P_FIMV_SHARED_PIC_TIME_BOTTOM		0x0014
+
+#endif /* _REGS_FIMV_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
new file mode 100644
index 0000000..0b6150f
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -0,0 +1,1948 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.0
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
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
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
+#define S5P_MFC_NAME	"s5p-mfc5"
+
+/* Offset base used to differentiate between CAPTURE and OUTPUT
+*  while mmaping */
+#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
+
+int debug = 0;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+
+struct s5p_mfc_dev *dev;
+static const char *s5p_mem_types[] = {"b", "a"};
+static unsigned long s5p_mem_alignments[] = {8192, 8192};
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
+	wake_up_interruptible(&ctx->queue);
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
+	struct vb2_buffer *b;
+	int i;
+
+	spin_lock(&dev->irqlock);
+	while (!list_empty(lh)) {
+		b = list_entry(lh->next, struct vb2_buffer, drv_entry);
+		for (i = 0; i < b->num_planes; i++)
+			vb2_set_plane_payload(b, i, 0);
+		spin_unlock(&dev->irqlock);
+		vb2_buffer_done(b, VB2_BUF_STATE_ERROR);
+		spin_lock(&dev->irqlock);
+		list_del(&b->drv_entry);
+	}
+	spin_unlock(&dev->irqlock);
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
+
+	mfc_err("Driver timeout error handling.\n");
+	/* Lock the mutex that protects open and release.
+	 * This is necessary as they may load and unload firmware. */
+	mutex_locked = mutex_trylock(dev->mfc_mutex);
+	if (!mutex_locked)
+		mfc_err("This is not good. Some instance may be "
+							"closing/opening.\n");
+	clk_disable(dev->clock1);
+	clk_disable(dev->clock2);
+	spin_lock(&dev->irqlock);
+	for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
+		ctx = dev->ctx[i];
+		if (ctx) {
+			ctx->state = MFCINST_DEC_ERROR;
+			spin_unlock(&dev->irqlock);
+			s5p_mfc_error_cleanup_queue(&ctx->dst_queue,
+				&ctx->vq_dst);
+			s5p_mfc_error_cleanup_queue(&ctx->src_queue,
+				&ctx->vq_src);
+			spin_lock(&dev->irqlock);
+			clear_work_bit(ctx);
+			wake_up_ctx(ctx, S5P_FIMV_R2H_CMD_DECODE_ERR_RET, 0);
+		}
+	}
+	clear_bit(0, &dev->hw_lock);
+	spin_unlock(&dev->irqlock);
+	/* Double check if there is at least one instance running.
+	 * If no instance is in memory than no firmware should be present */
+	if (atomic_read(&dev->num_inst) > 0) {
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
+	"state=%d\n", ctx->src_queue_cnt, ctx->dst_queue_cnt, ctx->state);
+	/* Context is to parse header */
+	if (ctx->src_queue_cnt >= 1 && ctx->state == MFCINST_DEC_GOT_INST)
+		return 1;
+	/* Context is to decode a frame */
+	if (ctx->src_queue_cnt >= 1 && ctx->state == MFCINST_DEC_RUNNING &&
+					ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	/* Context is to return last frame */
+	if (ctx->state == MFCINST_DEC_FINISHING &&
+	    ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	/* Context is to set buffers */
+	if (ctx->src_queue_cnt >= 1 &&
+	    ctx->state == MFCINST_DEC_HEAD_PARSED &&
+	    ctx->capture_state == QUEUE_BUFS_MMAPED)
+		return 1;
+	mfc_debug("s5p_mfc_ctx_ready: ctx is not ready.\n");
+	return 0;
+}
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
+		else if (!out && formats[i].type != MFC_FMT_DEC)
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
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("f->type = %d ctx->state = %d\n", f->type,
+								ctx->state);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state == MFCINST_DEC_GOT_INST) {
+		/* If the MFC is parsing the header,
+		 * so wait until it is finished */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+									1);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+	    ctx->state < MFCINST_ENC_INIT) {
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
+		f->fmt.pix_mp.pixelformat = ctx->fmt->fourcc;
+		f->fmt.pix_mp.num_planes = ctx->fmt->num_planes;
+	} else {
+		mfc_err("Format could not be read\n");
+		mfc_debug("%s-- with error\n", __func__);
+		return -EINVAL;
+	}
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Find selected format description */
+static struct s5p_mfc_fmt *find_format(struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		fmt = &formats[i];
+		if (fmt->fourcc == f->fmt.pix_mp.pixelformat)
+			break;
+	}
+	if (i == NUM_FORMATS)
+		return NULL;
+	return fmt;
+}
+
+/* Try format */
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug("Type is %d\n", f->type);
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Currently only decoding is "
+								"supported.\n");
+		return -EINVAL;
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f);
+		if (!fmt) {
+			mfc_err("Unsupported format.\n");
+			return -EINVAL;
+		}
+		if (fmt->type != MFC_FMT_DEC) {
+			mfc_err("\n");
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
+/* Set format */
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	unsigned long flags;
+	int ret = 0;
+	struct s5p_mfc_fmt *fmt;
+
+	mfc_debug("%s++\n", __func__);
+	ret = vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+	mutex_lock(&ctx->vq_src.vb_lock);
+	mutex_lock(&ctx->vq_dst.vb_lock);
+	if (ctx->vq_src.streaming || ctx->vq_dst.streaming) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		ret = -EBUSY;
+		goto out;
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f);
+		if (!fmt || fmt->codec_mode == MFC_FORMATS_NO_CODEC) {
+			mfc_err("Unknown codec.\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (fmt->type != MFC_FMT_DEC) {
+			mfc_err("Wrong format selected, you "
+					"should choose format for decoding.\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		ctx->fmt = fmt;
+		ctx->codec_mode = fmt->codec_mode;
+		mfc_debug("The codec number is: %d\n",
+							ctx->codec_mode);
+		ctx->pix_format = f->fmt.pix_mp.pixelformat;
+		if (f->fmt.pix_mp.pixelformat != V4L2_PIX_FMT_DIVX3) {
+			f->fmt.pix_mp.height = 1;
+			f->fmt.pix_mp.width = 1;
+		} else {
+			ctx->img_height = f->fmt.pix_mp.height;
+			ctx->img_width = f->fmt.pix_mp.width;
+		}
+		mfc_debug("s_fmt w/h: %dx%d, ctx: %dx%d\n",
+				f->fmt.pix_mp.width, f->fmt.pix_mp.height,
+					ctx->img_width, ctx->img_height);
+		ctx->dec_src_buf_size =	f->fmt.pix_mp.plane_fmt[0].sizeimage;
+		f->fmt.pix_mp.plane_fmt[0].bytesperline = 0;
+		ctx->state = MFCINST_DEC_INIT;
+		ctx->dec_dst_buf_cnt = 0;
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
+			mfc_err("Error getting instance from"
+								" hardware.\n");
+			s5p_mfc_release_instance_buffer(ctx);
+			s5p_mfc_release_dec_buffers(ctx);
+			ret = -EAGAIN;
+			goto out;
+		}
+		mfc_debug("Got instance number: %d\n",
+								ctx->inst_no);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_err("Currently only decoding is "
+								"supported.\n");
+		ret = -EINVAL;
+	}
+out:
+	mutex_unlock(&ctx->vq_dst.vb_lock);
+	mutex_unlock(&ctx->vq_src.vb_lock);
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Reqeust buffers */
+static int vidioc_reqbufs(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = 0;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Memory type: %d\n", reqbufs->memory);
+	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only V4L2_MEMORY_MAP is supported."
+									"\n");
+		return -EINVAL;
+	}
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		/* Can only request buffers after an instance has been opened.*/
+		if (ctx->state == MFCINST_DEC_GOT_INST) {
+			/* Decoding */
+			if (ctx->output_state != QUEUE_FREE) {
+				mfc_err("Bufs have already "
+							"been requested.\n");
+				return -EINVAL;
+			}
+			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+			if (ret) {
+				mfc_err("vb2_reqbufs on "
+							"output failed.\n");
+				return ret;
+			}
+			mfc_debug("vb2_reqbufs: %d\n", ret);
+			ctx->output_state = QUEUE_BUFS_REQUESTED;
+		}
+	}
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state != QUEUE_FREE) {
+			mfc_err("Bufs have already been "
+								"requested.\n");
+			return -EINVAL;
+		}
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		if (ret) {
+			mfc_err("vb2_reqbufs on capture "
+								"failed.\n");
+			return ret;
+		}
+		if (reqbufs->count < ctx->dpb_count) {
+			mfc_err("Not enough buffers "
+								"allocated.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+		ctx->total_dpb_count = reqbufs->count;
+		ret = s5p_mfc_alloc_dec_buffers(ctx);
+		if (ret) {
+			mfc_err("Failed to allocate decoding"
+								" buffers.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+		ctx->capture_state = QUEUE_BUFS_REQUESTED;
+	}
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
+	if (buf->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only mmaped buffers can be "
+								"used.\n");
+		return -EINVAL;
+	}
+	mfc_debug("State: %d, buf->type: %d\n", ctx->state,
+								buf->type);
+	if (ctx->state == MFCINST_DEC_GOT_INST &&
+			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_src, buf);
+	} else if (ctx->state == MFCINST_DEC_HEAD_PARSED &&
+			buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_dst, buf);
+		for (i = 0; i < buf->length; i++)
+			buf->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
+	} else {
+		mfc_err("vidioc_querybuf called in an "
+						"inappropriate state.\n");
+		ret = -EINVAL;
+	}
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Queue a buffer */
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Enqueued buf: %d (type = %d)\n", buf->index,
+								 buf->type);
+	if (ctx->state == MFCINST_DEC_ERROR) {
+		mfc_err("Call on QBUF after unrecoverable "
+								"error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return vb2_qbuf(&ctx->vq_src, buf);
+	else
+		return vb2_qbuf(&ctx->vq_dst, buf);
+	mfc_debug("%s--\n", __func__);
+	return -EINVAL;
+}
+
+/* Dequeue a buffer */
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Addr: %p %p %p Type: %d\n", &ctx->vq_src,
+						buf, buf->m.planes, buf->type);
+	if (ctx->state == MFCINST_DEC_ERROR) {
+		mfc_err("Call on DQBUF after unrecoverable "
+								"error.\n");
+		return -EIO;
+	}
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_dqbuf(&ctx->vq_src, buf,
+				      file->f_flags & O_NONBLOCK);
+	} else {
+		ret = vb2_dqbuf(&ctx->vq_dst, buf,
+				      file->f_flags & O_NONBLOCK);
+	}
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Stream on */
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret = -EINVAL;
+	unsigned long flags;
+
+	mfc_debug("%s++\n", __func__);
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamon(&ctx->vq_src, type);
+	else
+		ret = vb2_streamon(&ctx->vq_dst, type);
+	mfc_debug("ctx->src_queue_cnt = %d ctx->state = %d "
+		  "ctx->dst_queue_cnt = %d ctx->dpb_count = %d\n",
+		  ctx->src_queue_cnt, ctx->state, ctx->dst_queue_cnt,
+		  ctx->dpb_count);
+	/* If context is ready then schedule it to run */
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+	s5p_mfc_try_run();
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
+	ret = -EINVAL;
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		ret = vb2_streamoff(&ctx->vq_src, type);
+	else
+		ret = vb2_streamoff(&ctx->vq_dst, type);
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
+	switch (ctrl->id) {
+	case V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE:
+		ctrl->value = ctx->loop_filter_mpeg4;
+		break;
+	case V4L2_CID_CODEC_DISPLAY_DELAY:
+		ctrl->value = ctx->display_delay;
+		break;
+	case V4L2_CID_CODEC_REQ_NUM_BUFS:
+		if (ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+		    ctx->state < MFCINST_ENC_INIT) {
+			ctrl->value = ctx->dpb_count;
+		} else if (ctx->state == MFCINST_DEC_INIT) {
+			/* Should wait for the header to be parsed */
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_wait_for_done_ctx(ctx,
+					S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 1);
+			if (ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+			    ctx->state < MFCINST_ENC_INIT) {
+				ctrl->value = ctx->dpb_count;
+			} else {
+				v4l2_err(&dev->v4l2_dev,
+						 "Decoding not initialised.\n");
+				return -EINVAL;
+			}
+		} else {
+			v4l2_err(&dev->v4l2_dev,
+						 "Decoding not initialised.\n");
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
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
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
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+/* Get cropping information */
+static int vidioc_g_crop(struct file *file, void *priv,
+		struct v4l2_crop *cr)
+{
+	struct s5p_mfc_ctx *ctx = priv;
+	u32 left, right, top, bottom;
+
+	mfc_debug("%s++\n", __func__);
+	if (ctx->state != MFCINST_DEC_HEAD_PARSED &&
+	ctx->state != MFCINST_DEC_RUNNING && ctx->state != MFCINST_DEC_FINISHING
+					&& ctx->state != MFCINST_DEC_FINISHED) {
+			mfc_debug("%s-- with error\n",
+								__func__);
+			return -EINVAL;
+		}
+	if (ctx->fmt->fourcc == V4L2_PIX_FMT_H264) {
+		left = s5p_mfc_get_h_crop(ctx);
+		right = left >> 16;
+		left = left & 0xFFFF;
+		top = s5p_mfc_get_v_crop(ctx);
+		bottom = top >> 16;
+		top = top & 0xFFFF;
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
+	mfc_debug("%s--\n", __func__);
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
+/* Negotiate buffers */
+static int s5p_mfc_buf_negotiate(struct vb2_queue *vq, unsigned int *buf_count,
+						unsigned int *plane_count)
+{
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+
+	mfc_debug("%s++\n", __func__);
+	/* Video output for decoding (source)
+	 * this can be set after getting an instance */
+	if (ctx->state == MFCINST_DEC_GOT_INST &&
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
+	} else if (ctx->state == MFCINST_DEC_HEAD_PARSED &&
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
+		mfc_err("State seems invalid. State = %d, "
+				"vq->type = %d\n", ctx->state, vq->type);
+		return -EINVAL;
+	}
+	mfc_debug("%s, buffer count=%d, plane count=%d "
+		"type=0x%x\n", __func__, *buf_count, *plane_count, vq->type);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Setup plane */
+static int s5p_mfc_buf_setup_plane(struct vb2_queue *vq,
+			   unsigned int plane, unsigned long *plane_size)
+{
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+
+	mfc_debug("%s++\n", __func__);
+	if (ctx->state == MFCINST_DEC_HEAD_PARSED &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		switch (plane) {
+		case 0:
+			/* Plane 0 is for luma (Y) */
+			*plane_size = ctx->luma_size;
+			break;
+		case 1:
+			/* Plane 1 is for chroma (C) */
+			*plane_size = ctx->chroma_size;
+			break;
+		default:
+			mfc_err("%s, invalid plane=%d\n",
+							__func__, plane);
+			return -EINVAL;
+		}
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		   ctx->state == MFCINST_DEC_GOT_INST) {
+		if (plane != 0) {
+			mfc_err("%s, invalid plane=%d\n",
+							__func__, plane);
+			return -EINVAL;
+		}
+		/* dec_src_buf_size was set in s_fmt */
+		*plane_size = ctx->dec_src_buf_size;
+	} else {
+		mfc_err("Currently only decoding is "
+				"supported. Decoding not initalised.\n");
+		return -EINVAL;
+	}
+	mfc_debug("%s, plane=%d, size=%lu\n", __func__, plane,
+								*plane_size);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Prepare a buffer */
+static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	unsigned int i;
+
+	mfc_debug("%s++\n", __func__);
+	BUG_ON(NULL == ctx->fmt);
+	if (!ctx->fmt) {
+		mfc_err("Format passed to the function is "
+								"nul.\n");
+		return -EINVAL;
+	}
+	mfc_debug("Addr: %p (%d)\n",
+			(void *)vb2_plane_paddr(vb, 0),	vb->v4l2_buf.index);
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
+			mfc_debug("%s--\n", __func__);
+			return 0;
+		}
+		for (i = 0; i <= ctx->fmt->num_planes ; i++) {
+			if (vb2_plane_paddr(vb, i) == 0) {
+				mfc_err("Plane mem not "
+								"allocated.\n");
+				return -EINVAL;
+			}
+		}
+		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
+			vb2_plane_size(vb, 1) < ctx->chroma_size) {
+			mfc_err("Plane buffer (CAPTURE) is "
+								"too small.\n");
+			return -EINVAL;
+		}
+		mfc_debug("Size: 0=%lu 2=%lu\n",
+				vb2_plane_size(vb, 0), vb2_plane_size(vb, 1));
+		i = vb->v4l2_buf.index;
+		ctx->dec_dst_buf_luma[i] = vb2_plane_paddr(vb, 0);
+		ctx->dec_dst_buf_chroma[i] = vb2_plane_paddr(vb, 1);
+		ctx->dec_dst_buf_cnt++;
+		if (ctx->dec_dst_buf_cnt == ctx->total_dpb_count)
+			ctx->capture_state = QUEUE_BUFS_MMAPED;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (vb2_plane_paddr(vb, 0)  == 0) {
+			mfc_err("Plane memory not "
+								"allocated.\n");
+			return -EINVAL;
+		}
+		mfc_debug("Plane size: %ld, "
+			"ctx->dec_src_buf_size: %d\n",	vb2_plane_size(vb, 0),
+							ctx->dec_src_buf_size);
+		if (vb2_plane_size(vb, 0) < ctx->dec_src_buf_size) {
+			mfc_err("Plane buffer (OUTPUT) is "
+								"too small.\n");
+			return -EINVAL;
+		}
+	} else {
+		mfc_err("s5p_mfc_buf_prepare: unknown queue "
+								"type.\n");
+		return -EINVAL;
+	}
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Try running an operation on hardware */
+static void s5p_mfc_try_run()
+{
+	struct vb2_buffer *temp_vb;
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned long flags;
+	unsigned int cnt;
+	unsigned int ret;
+
+	mfc_debug("Try run dev: %p\n", dev);
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) == 0) {
+		/* Choose the context to run */
+		spin_lock_irqsave(&dev->condlock, flags);
+		mfc_debug("Previos context: %d (bits %08lx)\n",
+					  dev->curr_ctx, dev->ctx_work_bits);
+		new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
+		cnt = 0;
+		while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
+			new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
+			cnt++;
+			if (cnt > MFC_NUM_CONTEXTS) {
+				/* No contexts to run */
+				spin_unlock_irqrestore(&dev->condlock, flags);
+				if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+					mfc_err("Failed to "
+							"unlock hardware.\n");
+					return;
+				}
+				mfc_debug("No ctx is scheduled"
+							" to be run.\n");
+				return;
+			}
+		}
+		mfc_debug("New context: %d\n", new_ctx);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+		ctx = dev->ctx[new_ctx];
+		mfc_debug("Seting new context to %p\n", ctx);
+		/* Got context to run in ctx */
+		mfc_debug("ctx->dst_queue_cnt=%d "
+			"ctx->dpb_count=%d ctx->src_queue_cnt=%d\n",
+			ctx->dst_queue_cnt, ctx->dpb_count, ctx->src_queue_cnt);
+		mfc_debug("ctx->state=%d\n", ctx->state);
+		/* Last frame has already been sent to MFC
+		 * Now obtaining frames from MFC buffer */
+		if (ctx->state == MFCINST_DEC_FINISHING) {
+			s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_decode_one_frame(ctx, 1);
+		} else if (ctx->state == MFCINST_DEC_RUNNING) {
+			/* Frames are being decoded */
+			if (list_empty(&ctx->src_queue)) {
+				if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+					mfc_err("Failed to "
+							"unlock hardware.\n");
+					return;
+				}
+				mfc_debug("No src buffers.\n");
+				return;
+			}
+			/* Get the next source buffer */
+			temp_vb = list_entry(ctx->src_queue.next,
+						struct vb2_buffer, drv_entry);
+			mfc_debug("Temp vb: %p\n", temp_vb);
+			mfc_debug("Src Addr: %08lx\n",
+						vb2_plane_paddr(temp_vb, 0));
+			s5p_mfc_set_dec_stream_buffer(ctx,
+			      vb2_plane_paddr(temp_vb, 0), 0,
+			      temp_vb->v4l2_planes[0].bytesused);
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_decode_one_frame(ctx,
+				temp_vb->v4l2_planes[0].bytesused == 0);
+		} else if (ctx->state == MFCINST_DEC_INIT) {
+			/* Preparing decoding - getting instance number */
+			mfc_debug("Getting instance number\n");
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_open_inst(ctx);
+			if (ret) {
+				mfc_err("Failed to create a "
+							"new instance.\n");
+				ctx->state = MFCINST_DEC_ERROR;
+			}
+		} else if (ctx->state == MFCINST_DEC_RETURN_INST) {
+			/* Closing decoding instance  */
+			mfc_debug("Returning instance "
+								"number\n");
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_return_inst_no(ctx);
+			if (ret) {
+				mfc_err("Failed to return an"
+								" instance.\n");
+				ctx->state = MFCINST_DEC_ERROR;
+			}
+
+		} else if (ctx->state == MFCINST_DEC_GOT_INST) {
+			/* Initializing decoding - parsing header */
+			mfc_debug("Preparing to init "
+								"decoding.\n");
+			temp_vb = list_entry(ctx->src_queue.next,
+						struct vb2_buffer, drv_entry);
+			s5p_mfc_set_dec_desc_buffer(ctx);
+			mfc_debug("Header size: %d\n",
+					temp_vb->v4l2_planes[0].bytesused);
+			s5p_mfc_set_dec_stream_buffer(ctx,\
+					vb2_plane_paddr(temp_vb, 0), 0,
+					 temp_vb->v4l2_planes[0].bytesused);
+			dev->curr_ctx = ctx->num;
+			mfc_debug("paddr: %08x\n",
+				(int)phys_to_virt(vb2_plane_paddr(temp_vb, 0)));
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_init_decode(ctx);
+		} else if (ctx->state == MFCINST_DEC_HEAD_PARSED) {
+			/* Header was parsed now starting processing
+			 * First set the output frame buffers
+			 * s5p_mfc_alloc_dec_buffers(ctx); */
+			if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
+				temp_vb = list_entry(ctx->src_queue.next,
+						struct vb2_buffer, drv_entry);
+				mfc_debug("Header size: %d\n",
+					temp_vb->v4l2_planes[0].bytesused);
+				s5p_mfc_set_dec_stream_buffer(ctx,
+					vb2_plane_paddr(temp_vb, 0), 0,
+					temp_vb->v4l2_planes[0].bytesused);
+				dev->curr_ctx = ctx->num;
+				s5p_mfc_clean_ctx_int_flags(ctx);
+				if (s5p_mfc_set_dec_frame_buffer(ctx)) {
+					mfc_err("Failed to "
+							"alloc frame mem.\n");
+					ctx->state = MFCINST_DEC_ERROR;
+				}
+			} else {
+				mfc_err("It seems that not "
+					"all destionation buffers were mmaped."
+					"\nMFC requires that all destination "
+					"are mmaped before starting "
+							"processing.\n");
+				if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+					mfc_err("Failed to "
+							"unlock hardware.\n");
+					return;
+				}
+			}
+		} else {
+			/* Free hardware lock */
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+				mfc_err("Failed to unlock "
+								"hardware.\n");
+				return;
+			}
+		}
+	} else {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug("Couldn't lock HW.\n");
+	}
+}
+
+/* Queue buffer */
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	unsigned long flags;
+
+	mfc_debug("%s++\n", __func__);
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_debug("Src queue: %p\n", &ctx->src_queue);
+		mfc_debug("Adding to src: %p (%08lx)\n", vb,
+							vb2_plane_paddr(vb, 0));
+		list_add_tail(&vb->drv_entry, &ctx->src_queue);
+		ctx->src_queue_cnt++;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_debug("Dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug("Adding to dst: %p (%lx)\n", vb,
+						  vb2_plane_paddr(vb, 0));
+		mfc_debug("ADDING Flag before: %lx (%d)\n",
+					ctx->dec_dst_flag, vb->v4l2_buf.index);
+		/* Mark destination as available for use by MFC */
+		set_bit(vb->v4l2_buf.index, &ctx->dec_dst_flag);
+		mfc_debug("ADDING Flag after: %lx\n",
+							ctx->dec_dst_flag);
+		list_add_tail(&vb->drv_entry, &ctx->dst_queue);
+		ctx->dst_queue_cnt++;
+	} else {
+		mfc_err("Unsupported buffer type (%d)\n",
+								vq->type);
+	}
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+	s5p_mfc_try_run();
+	mfc_debug("%s--\n", __func__);
+}
+
+/* Videobuf opts */
+static struct vb2_ops s5p_mfc_qops = {
+	.buf_queue = s5p_mfc_buf_queue,
+	.queue_negotiate = s5p_mfc_buf_negotiate,
+	.plane_setup = s5p_mfc_buf_setup_plane,
+	.buf_prepare = s5p_mfc_buf_prepare,
+};
+
+/* Handle frame decoding interrupt */
+static void s5p_mfc_handle_frame_int(struct s5p_mfc_ctx *ctx,
+					unsigned int reason, unsigned int err)
+{
+	size_t dst_ret_addr_y;
+	unsigned int dst_frame_status;
+	unsigned int dec_frame_type;
+	struct vb2_buffer *src_buf, *dst_buf;
+
+	dst_ret_addr_y = s5p_mfc_get_dspl_y_adr();
+	dst_frame_status = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
+	dec_frame_type = s5p_mfc_get_frame_type();
+	mfc_debug("Status: %x,addrY: %08x\n", dst_frame_status,
+								dst_ret_addr_y);
+	spin_lock(&dev->irqlock);
+	/* All frames remaining in the buffer have been extracted  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY) {
+		ctx->state = MFCINST_DEC_FINISHED;
+		mfc_debug("Decided to finish\n");
+		ctx->sequence++;
+		while (!list_empty(&ctx->dst_queue)) {
+			dst_buf = list_entry(ctx->dst_queue.next,
+					     struct vb2_buffer, drv_entry);
+			mfc_debug("Cleaning up buffer: %d\n",
+						  dst_buf->v4l2_buf.index);
+			vb2_set_plane_payload(dst_buf, 0, 0);
+			vb2_set_plane_payload(dst_buf, 1, 0);
+			list_del(&dst_buf->drv_entry);
+			ctx->dst_queue_cnt--;
+			dst_buf->v4l2_buf.sequence = (ctx->sequence++);
+			if (s5p_mfc_get_pic_time_top(ctx) ==
+				s5p_mfc_get_pic_time_bottom(ctx))
+				dst_buf->v4l2_buf.field = V4L2_FIELD_NONE;
+			else
+				dst_buf->v4l2_buf.field = V4L2_FIELD_INTERLACED;
+			spin_unlock(&dev->irqlock);
+			ctx->dec_dst_flag &= ~(1 << dst_buf->v4l2_buf.index);
+			vb2_buffer_done(dst_buf, VB2_BUF_STATE_DONE);
+			spin_lock(&dev->irqlock);
+			mfc_debug("Cleaned up buffer: %d\n",
+				  dst_buf->v4l2_buf.index);
+		}
+		mfc_debug("After cleanup\n");
+	}
+
+	/* A frame has been decoded and is in the buffer  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DISPLAY_ONLY ||
+	    dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY) {
+		ctx->sequence++;
+		/* If frame is same as previous then skip and do not dequeue */
+		if (dec_frame_type !=  S5P_FIMV_DECODE_FRAME_SKIPPED) {
+		/* The MFC returns address of the buffer, now we have to
+		 * check which videobuf does it correspond to */
+		list_for_each_entry(dst_buf, &ctx->dst_queue, drv_entry) {
+			mfc_debug("Listing: %d\n",
+						dst_buf->v4l2_buf.index);
+			/* Check if this is the buffer we're looking for */
+			if (vb2_plane_paddr(dst_buf, 0) == dst_ret_addr_y) {
+				list_del(&dst_buf->drv_entry);
+				ctx->dst_queue_cnt--;
+				dst_buf->v4l2_buf.sequence = ctx->sequence;
+				if (s5p_mfc_get_pic_time_top(ctx) ==
+					s5p_mfc_get_pic_time_bottom(ctx))
+					dst_buf->v4l2_buf.field =
+								V4L2_FIELD_NONE;
+				else
+					dst_buf->v4l2_buf.field =
+							V4L2_FIELD_INTERLACED;
+				vb2_set_plane_payload(dst_buf, 0,
+								ctx->luma_size);
+				vb2_set_plane_payload(dst_buf, 1,
+							ctx->chroma_size);
+				spin_unlock(&dev->irqlock);
+				clear_bit(dst_buf->v4l2_buf.index,
+							&ctx->dec_dst_flag);
+				if (err) {
+					vb2_buffer_done(dst_buf,
+							VB2_BUF_STATE_ERROR);
+				} else {
+					vb2_buffer_done(dst_buf,
+							VB2_BUF_STATE_DONE);
+				}
+				spin_lock(&dev->irqlock);
+				break;
+			}
+		}
+		}
+	} else {
+		mfc_debug("No frame decode.\n");
+	}
+	/* Mark source buffer as complete */
+	if (dst_frame_status != S5P_FIMV_DEC_STATUS_DISPLAY_ONLY
+		&& !list_empty(&ctx->src_queue)) {
+		src_buf = list_entry(ctx->src_queue.next, struct vb2_buffer,
+								drv_entry);
+		mfc_debug("Packed PB test. Size:%d, prev off:"\
+			"%ld now con:%d\n", src_buf->v4l2_planes[0].bytesused,
+			ctx->consumed_stream, s5p_mfc_get_consumed_stream());
+		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
+		if (dec_frame_type == S5P_FIMV_DECODE_FRAME_P_FRAME
+						&& ctx->consumed_stream <
+					src_buf->v4l2_planes[0].bytesused) {
+			/* Run MFC again on the same buffer */
+			mfc_debug("Running again the same "
+								"buffer.\n");
+			s5p_mfc_set_dec_stream_buffer(ctx,
+						vb2_plane_paddr(src_buf, 0),
+							ctx->consumed_stream,
+					src_buf->v4l2_planes[0].bytesused -
+							ctx->consumed_stream);
+			dev->curr_ctx = ctx->num;
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			spin_unlock(&dev->irqlock);
+			s5p_mfc_clear_int_flags();
+			wake_up_ctx(ctx, reason, err);
+			s5p_mfc_decode_one_frame(ctx, 0);
+			return;
+		} else {
+			mfc_debug("MFC needs next buffer..\n");
+			/* Advance to next buffer */
+			ctx->consumed_stream = 0;
+			list_del(&src_buf->drv_entry);
+			ctx->src_queue_cnt--;
+			if (vb2_plane_size(src_buf, 0) == 0) {
+				mfc_debug("Setting ctx->state "
+							"to FINISHING\n");
+				ctx->state = MFCINST_DEC_FINISHING;
+			}
+			spin_unlock(&dev->irqlock);
+			vb2_buffer_done(src_buf, VB2_BUF_STATE_DONE);
+
+		}
+	} else {
+		spin_unlock(&dev->irqlock);
+	}
+	mfc_debug("Assesing whether this context should be run"
+								" again.\n");
+	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_DEC_FINISHING)
+				    || ctx->dst_queue_cnt < ctx->dpb_count) {
+		mfc_debug("No need to run again.\n");
+		clear_work_bit(ctx);
+	}
+	mfc_debug("After assesing whether this context should "
+							"be run again.\n");
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
+	mfc_err("Interrupt Error: %08x\n", err);
+	s5p_mfc_clear_int_flags();
+	wake_up_dev(reason, err);
+	/* If no context is available then all necessary
+	 * processing has been done. */
+	if (ctx == 0)
+		return;
+	/* Error recovery is dependent on the state of context */
+	switch (ctx->state) {
+	case MFCINST_DEC_INIT:
+		/* This error had to happen while acquireing instance */
+	case MFCINST_DEC_GOT_INST:
+		/* This error had to happen while parsing the header */
+	case MFCINST_DEC_HEAD_PARSED:
+		/* This error had to happen while setting dst buffers */
+	case MFCINST_DEC_RETURN_INST:
+		/* This error had to happen while releasing instance */
+		clear_work_bit(ctx);
+		wake_up_ctx(ctx, reason, err);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		break;
+	case MFCINST_DEC_FINISHING:
+	case MFCINST_DEC_FINISHED:
+	case MFCINST_DEC_RUNNING:
+		/* It is higly probable that an error occured
+		 * while decoding a frame */
+		clear_work_bit(ctx);
+		ctx->state = MFCINST_DEC_ERROR;
+		/* Mark all dst buffers as having an error */
+		s5p_mfc_error_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		/* Mark all src buffers as having an error */
+		s5p_mfc_error_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		break;
+	default:
+		mfc_err("Encountered an error interrupt "
+					"which had not been handled.\n");
+		break;
+	}
+	return;
+}
+
+/* Interrupt processing */
+static irqreturn_t s5p_mfc_irq(int irq, void *priv)
+{
+	struct vb2_buffer *src_buf;
+	struct s5p_mfc_ctx *ctx;
+	unsigned int reason;
+	unsigned int err;
+
+	mfc_debug("%s++\n", __func__);
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
+		if (ctx->state == MFCINST_DEC_RUNNING &&
+					err >= S5P_FIMV_ERR_WARNINGS_START)
+			s5p_mfc_handle_frame_int(ctx, reason, err);
+		else
+			s5p_mfc_handle_error(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
+	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
+		s5p_mfc_handle_frame_int(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+		if (ctx->fmt->fourcc != V4L2_PIX_FMT_DIVX3) {
+			ctx->img_width = s5p_mfc_get_img_width();
+			ctx->img_height = s5p_mfc_get_img_height();
+		}
+		ctx->buf_width = ALIGN(ctx->img_width, 128);
+		ctx->buf_height = ALIGN(ctx->img_height, 32);
+		mfc_debug("SEQ Done: Movie dimensions %dx%d, "
+			"buffer dimensions: %dx%d\n", ctx->img_width,
+			ctx->img_height, ctx->buf_width, ctx->buf_height);
+		ctx->luma_size = ALIGN(ctx->buf_width * ctx->buf_height, 8192);
+		ctx->chroma_size = ALIGN(ctx->buf_width *
+					ALIGN(ctx->img_height / 2, 32), 8192);
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+			ctx->mv_size = ALIGN(ctx->buf_width *
+					 ALIGN(ctx->buf_height / 4, 32), 8192);
+		else
+			ctx->mv_size = 0;
+		ctx->dpb_count = s5p_mfc_get_dpb_count();
+		ctx->state = MFCINST_DEC_HEAD_PARSED;
+		s5p_mfc_clear_int_flags();
+		clear_work_bit(ctx);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		s5p_mfc_try_run();
+		wake_up_ctx(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_get_inst_no();
+		ctx->state = MFCINST_DEC_GOT_INST;
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
+			ctx->state = MFCINST_DEC_RUNNING;
+			spin_lock(&dev->irqlock);
+			src_buf =
+			    list_entry(ctx->src_queue.next,
+				       struct vb2_buffer, drv_entry);
+			list_del(&src_buf->drv_entry);
+			ctx->src_queue_cnt--;
+			spin_unlock(&dev->irqlock);
+			vb2_buffer_done(src_buf, VB2_BUF_STATE_DONE);
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
+	mfc_debug("%s--\n", __func__);
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
+	unsigned long flags;
+	int ret = 0;
+
+	mfc_debug("%s++\n", __func__);
+	mutex_lock(dev->mfc_mutex);
+	atomic_inc(&dev->num_inst);	/* It is guarded by mfc_mutex */
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
+	/* Default format */
+	ctx->fmt = &formats[0];
+	/* Load firmware if this is the first instance */
+	if (atomic_read(&dev->num_inst) == 1) {
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
+	/* Init videobuf2 queue for CAPTURE */
+	ret = vb2_queue_init(&ctx->vq_dst, &s5p_mfc_qops,
+			       dev->alloc_ctx[0], &dev->irqlock,
+			       V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, ctx);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 "
+							"queue(capture)\n");
+		goto out_open_3;
+	}
+	/* Init videobuf2 queue for OUTPUT */
+	ret = vb2_queue_init(&ctx->vq_src, &s5p_mfc_qops,
+			       dev->alloc_ctx[1], &dev->irqlock,
+			       V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, ctx);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 "
+							" queue(output)\n");
+		goto out_open_3;
+	}
+	vb2_set_alloc_ctx(&ctx->vq_dst, dev->alloc_ctx[1], 1);
+	init_waitqueue_head(&ctx->queue);
+	mutex_unlock(dev->mfc_mutex);
+	mfc_debug("%s-- (via irq_cleanup_hw)\n", __func__);
+	return ret;
+	/* Deinit when failure occured */
+out_open_3:
+	if (atomic_read(&dev->num_inst) == 1) {
+		clk_disable(dev->clock1);
+		clk_disable(dev->clock2);
+		s5p_mfc_release_firmware();
+	}
+out_open_2:
+	s5p_mfc_release_firmware();
+out_open_2a:
+	dev->ctx[ctx->num] = 0;
+	kfree(ctx);
+out_open:
+	atomic_dec(&dev->num_inst);
+	mutex_unlock(dev->mfc_mutex);
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Release MFC context */
+static int s5p_mfc_release(struct file *file)
+{
+	struct s5p_mfc_ctx *ctx = file->private_data;
+	unsigned long flags;
+
+	mfc_debug("%s++\n", __func__);
+	mutex_lock(dev->mfc_mutex);
+	/* Stop all the processing */
+	vb2_queue_release(&ctx->vq_src);
+	vb2_queue_release(&ctx->vq_dst);
+	/* Mark context as idle */
+	clear_bit(ctx->num, &dev->ctx_work_bits);
+	/* If instance was initialised then
+	 * return instance and free reosurces */
+	if (ctx->state < MFCINST_ENC_INIT && ctx->state >= MFCINST_DEC_INIT) {
+		ctx->state = MFCINST_DEC_RETURN_INST;
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
+		s5p_mfc_release_dec_buffers(ctx);
+		s5p_mfc_release_instance_buffer(ctx);
+		s5p_mfc_release_dec_desc_buffer(ctx);
+	}
+	/* hardware locking scheme */
+	if (dev->curr_ctx == ctx->num)
+		clear_bit(0, &dev->hw_lock);
+	atomic_dec(&dev->num_inst);
+	if (atomic_read(&dev->num_inst) == 0) {
+		/* Actually this is also protected by mfc_mutex */
+		s5p_mfc_deinit_hw(dev);
+		mfc_debug("Disabling clocks...\n");
+		clk_disable(dev->clock1);
+		clk_disable(dev->clock2);
+		s5p_mfc_release_firmware();
+		del_timer_sync(&dev->watchdog_timer);
+	}
+	dev->ctx[ctx->num] = 0;
+	kfree(ctx);
+	mutex_unlock(dev->mfc_mutex);
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
+	if (offset < DST_QUEUE_OFF_BASE) {
+		mfc_debug("mmaping source.\n");
+		ret = vb2_mmap(&ctx->vq_src, vma);
+	} else {		/* capture */
+		mfc_debug("mmaping destination.\n");
+		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+		ret = vb2_mmap(&ctx->vq_dst, vma);
+	}
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* v4l2 ops */
+static const struct v4l2_file_operations s5p_mfc_fops = {
+	.owner = THIS_MODULE,
+	.open = s5p_mfc_open,
+	.release = s5p_mfc_release,
+	.poll = s5p_mfc_poll,
+	.ioctl = video_ioctl2,
+	.mmap = s5p_mfc_mmap,
+};
+
+/* videodec structure */
+static struct video_device s5p_mfc_videodev = {
+	.name = S5P_MFC_NAME,
+	.fops = &s5p_mfc_fops,
+	.ioctl_ops = &s5p_mfc_ioctl_ops,
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
+
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
+	atomic_set(&dev->num_inst, 0);
+	init_waitqueue_head(&dev->queue);
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+	*vfd = s5p_mfc_videodev;
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", s5p_mfc_videodev.name);
+	dev->vfd = vfd;
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
+	dev->alloc_ctx = vb2_cma_init_multi(&pdev->dev, 2, s5p_mem_types,
+							s5p_mem_alignments);
+	if (IS_ERR(dev->alloc_ctx)) {
+		mfc_err("Couldn't prepare allocator ctx.\n");
+		ret = PTR_ERR(dev->alloc_ctx);
+		goto alloc_ctx_fail;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(vfd);
+		goto rel_vdev;
+	}
+	v4l2_info(&dev->v4l2_dev, "Device registered as /dev/video%d\n",
+								vfd->num);
+	pr_debug("%s--\n", __func__);
+	return 0;
+
+/* Deinit MFC if probe had failed */
+rel_vdev:
+	vb2_cma_cleanup_multi(dev->alloc_ctx);
+alloc_ctx_fail:
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+
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
+	video_unregister_device(dev->vfd);
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
new file mode 100644
index 0000000..4f18937
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -0,0 +1,190 @@
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
+#include "regs-mfc5.h"
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+#include <media/videobuf2-core.h>
+
+#define MFC_MAX_EXTRA_DPB       5
+#define MFC_MAX_BUFFERS		32
+#define MFC_FRAME_PLANES	2
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
+
+/**
+ * enum s5p_mfc_inst_state - The state of an MFC instance.
+ */
+enum s5p_mfc_inst_state {
+	MFCINST_FREE = 0,
+	MFCINST_DEC_INIT = 100,
+	MFCINST_DEC_GOT_INST,
+	MFCINST_DEC_HEAD_PARSED,
+	MFCINST_DEC_BUFS_SET,
+	MFCINST_DEC_RUNNING,
+	MFCINST_DEC_FINISHING,
+	MFCINST_DEC_FINISHED,
+	MFCINST_DEC_RETURN_INST,
+	MFCINST_DEC_ERROR,
+	MFCINST_ENC_INIT = 200,
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
+ * struct s5p_mfc_dev - The struct containing driver internal parameters.
+ */
+struct s5p_mfc_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vfd;
+	struct platform_device *plat_dev;
+
+	atomic_t num_inst;
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
+	struct s5p_mfc_fmt *fmt;
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
+	size_t port_a;
+	size_t port_a_size;
+	size_t port_b;
+	size_t port_b_size;
+
+
+	enum s5p_mfc_queue_state capture_state;
+	enum s5p_mfc_queue_state output_state;
+
+	size_t dec_dst_buf_luma[MFC_MAX_BUFFERS];
+	size_t dec_dst_buf_chroma[MFC_MAX_BUFFERS];
+
+	int dec_dst_buf_cnt;
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
+	size_t instance_phys;
+	size_t instance_size;
+	size_t desc_phys;
+	size_t shared_phys;
+	void *shared_virt;
+
+};
+
+#endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
new file mode 100644
index 0000000..222ed71
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
@@ -0,0 +1,173 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.0
+ *
+ * This file contains description of formats used by MFC and cotrols
+ * used by the driver.
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
+static struct s5p_mfc_fmt formats[] = {
+	{
+	.name = "4:2:0 2 Planes 64x32 Tiles",
+	.fourcc = V4L2_PIX_FMT_NV12MT,
+	.codec_mode = MFC_FORMATS_NO_CODEC,
+	.type = MFC_FMT_RAW,
+	.num_planes = 2,
+	 },
+	{
+	.name = "4:2:0 2 Planes",
+	.fourcc = V4L2_PIX_FMT_NV12,
+	.codec_mode = MFC_FORMATS_NO_CODEC,
+	.type = MFC_FMT_RAW,
+	.num_planes = 2,
+	},
+	{
+	.name = "H264 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_H264,
+	.codec_mode = S5P_FIMV_CODEC_H264_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "H263 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_H263,
+	.codec_mode = S5P_FIMV_CODEC_H263_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "MPEG1/MPEG2 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_MPEG12,
+	.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "MPEG4 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_MPEG4,
+	.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "DivX Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_DIVX,
+	.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "DivX 3.11 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_DIVX3,
+	.codec_mode = S5P_FIMV_CODEC_DIVX311_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "DivX 4.12 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_DIVX4,
+	.codec_mode = S5P_FIMV_CODEC_DIVX412_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "DivX 5.00-5.02 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_DIVX500,
+	.codec_mode = S5P_FIMV_CODEC_DIVX502_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "DivX 5.03 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_DIVX503,
+	.codec_mode = S5P_FIMV_CODEC_DIVX503_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "XviD Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_XVID,
+	.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "VC1 Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_VC1,
+	.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+	{
+	.name = "VC1 RCV Encoded Stream",
+	.fourcc = V4L2_PIX_FMT_VC1_RCV,
+	.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
+	.type = MFC_FMT_DEC,
+	.num_planes = 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct v4l2_queryctrl s5p_mfc_ctrls[] = {
+/* For decoding */
+	{
+	.id = V4L2_CID_CODEC_DISPLAY_DELAY,
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.name = "",
+	.minimum = 0,
+	.maximum = 16383,
+	.step = 1,
+	.default_value = 0,
+	},
+	{
+	.id = V4L2_CID_CODEC_LOOP_FILTER_MPEG4_ENABLE,
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.name = "Mpeg4 Loop Filter Enable",
+	.minimum = 0,
+	.maximum = 1,
+	.step = 1,
+	.default_value = 0,
+	},
+	{
+	.id = V4L2_CID_CODEC_SLICE_INTERFACE,
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.name = "Slice Interface Enable",
+	.minimum = 0,
+	.maximum = 1,
+	.step = 1,
+	.default_value = 0,
+	},
+};
+
+#define NUM_CTRLS ARRAY_SIZE(s5p_mfc_ctrls)
+
+#endif /* S5P_MFC_CTRLS_H_ */
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_debug.h b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
new file mode 100644
index 0000000..d6f3109
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
@@ -0,0 +1,44 @@
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
+/* Debug macro */
+#define mfc_debug(fmt, ...)						\
+	do {								\
+		if (debug)						\
+			dev_dbg(dev->v4l2_dev.dev, fmt, ##__VA_ARGS__);	\
+	}while (0)
+
+#else
+#define mfc_debug(fmt, ...)
+#endif
+
+#define mfc_err(fmt, ...)						\
+	do {								\
+			dev_err(dev->v4l2_dev.dev, fmt, ##__VA_ARGS__);	\
+	}while (0)
+
+#define mfc_info(fmt, ...)						\
+	do {								\
+			dev_info(dev->v4l2_dev.dev, fmt, ##__VA_ARGS__);\
+	}while (0)
+
+#endif /* S5P_MFC_DEBUG_H_ */
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
new file mode 100644
index 0000000..d91178b
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -0,0 +1,88 @@
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
+		mfc_err("Interrupt (%d dev) timed out.\n", dev->int_type);
+		return 1;
+	} else if (ret == -ERESTARTSYS) {
+		mfc_err("Interrupted by a signal.\n");
+		return 1;
+	}
+	mfc_debug("Finished waiting (dev->queue, %d).\n", dev->int_type);
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
+		mfc_err("Interrupt (%d ctx) timed out.\n", ctx->int_type);
+		return 1;
+	} else if (ret == -ERESTARTSYS) {
+		mfc_err("Interrupted by a signal.\n");
+		return 1;
+	}
+	mfc_debug("Finished waiting (ctx->queue, %d).\n", ctx->int_type);
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_memory.h b/drivers/media/video/s5p-mfc/s5p_mfc_memory.h
new file mode 100644
index 0000000..a7e4009
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_memory.h
@@ -0,0 +1,32 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_memory.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains memory related defines.
+ *
+ * Kamil Debski, Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#define MFC_CMA_BANK1		"a"
+#define MFC_CMA_BANK2		"b"
+#define MFC_CMA_FW		"f"
+
+#endif /* S5P_MFC_MEMORY_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
new file mode 100644
index 0000000..d2c1d66
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -0,0 +1,836 @@
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
+static size_t s5p_mfc_phys_bitproc_buff;
+static unsigned char *s5p_mfc_virt_bitproc_buff;
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
+#define OFFSETA(x)		(((x) - dev->port_a) >> 11)
+#define OFFSETB(x)		(((x) - dev->port_b) >> 11)
+
+/* Reset the device */
+static int s5p_mfc_cmd_reset(struct s5p_mfc_dev *dev)
+{
+	unsigned int mc_status;
+	unsigned long timeout;
+
+	mfc_debug("%s++\n", __func__);
+	/* Stop procedure */
+	WRITEL(0x3f6, S5P_FIMV_SW_RESET);	/*  reset RISC */
+	WRITEL(0x3e2, S5P_FIMV_SW_RESET);	/*  All reset except for MC */
+	mdelay(10);
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* Check MC status */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while resetting MFC"
+									".\n");
+			return -EIO;
+		}
+		mc_status = READL(S5P_FIMV_MC_STATUS);
+	} while (mc_status & 0x3);
+	WRITEL(0x0, S5P_FIMV_SW_RESET);
+	WRITEL(0x3fe, S5P_FIMV_SW_RESET);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Send a command to the MFC */
+static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev,
+				struct s5p_mfc_ctx *mfc_ctx, int cmd, int arg)
+{
+	int cur_cmd;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* wait until host to risc command register becomes 'H2R_CMD_EMPTY' */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while waiting for "
+								"hardware.\n");
+			return -EIO;
+		}
+		cur_cmd = READL(S5P_FIMV_HOST2RISC_CMD);
+	} while (cur_cmd != S5P_FIMV_H2R_CMD_EMPTY);
+	WRITEL(arg, S5P_FIMV_HOST2RISC_ARG1);
+	if (cmd == S5P_FIMV_H2R_CMD_OPEN_INSTANCE) {
+		/* No CRC calculation (slow!) */
+		WRITEL(0, S5P_FIMV_HOST2RISC_ARG2);
+		/* Physical addr of the instance buffer */
+		WRITEL(OFFSETA(mfc_ctx->instance_phys),
+		       S5P_FIMV_HOST2RISC_ARG3);
+		/* Size of the instance buffer */
+		WRITEL(mfc_ctx->instance_size, S5P_FIMV_HOST2RISC_ARG4);
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
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *mfc_ctx)
+{
+	void *desc_virt;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_ctx->desc_phys = cma_alloc(mfc_ctx->dev->v4l2_dev.dev,
+					MFC_CMA_BANK1, DESC_BUF_SIZE, 2048);
+	if (IS_ERR_VALUE(mfc_ctx->desc_phys)) {
+		mfc_ctx->desc_phys = 0;
+		mfc_err("Allocating DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	desc_virt = ioremap_nocache(mfc_ctx->desc_phys, DESC_BUF_SIZE);
+	if (desc_virt == NULL) {
+		cma_free(mfc_ctx->desc_phys);
+		mfc_ctx->desc_phys = 0;
+		mfc_err("Remapping DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory, in future this might be done
+	 * by cma_alloc */
+	memset(desc_virt, 0, DESC_BUF_SIZE);
+	iounmap(desc_virt);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Release temproary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	if (mfc_ctx->desc_phys) {
+		cma_free(mfc_ctx->desc_phys);
+		mfc_ctx->desc_phys = 0;
+	}
+}
+
+/* Allocate decoding buffers */
+int s5p_mfc_alloc_dec_buffers(struct s5p_mfc_ctx *mfc_ctx)
+{
+	unsigned int luma_size, chroma_size, mv_size;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	luma_size = mfc_ctx->luma_size;
+	chroma_size = mfc_ctx->chroma_size;
+	mv_size = mfc_ctx->mv_size;
+	mfc_debug("Luma size:%d Chroma size:%d MV size:%d\n",
+		  luma_size, chroma_size, mv_size);
+	/* Codecs have different memory requirements */
+	switch (mfc_ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+		mfc_ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
+			     S5P_FIMV_DEC_VERT_NB_MV_SIZE, 8192);
+		mfc_ctx->port_b_size =
+		    mfc_ctx->total_dpb_count * ALIGN(mv_size, 8192) * 2;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_FIMV_CODEC_DIVX412_DEC:
+	case S5P_FIMV_CODEC_DIVX311_DEC:
+	case S5P_FIMV_CODEC_DIVX502_DEC:
+	case S5P_FIMV_CODEC_DIVX503_DEC:
+		mfc_ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_STX_PARSER_SIZE +
+			     S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE, 8192);
+		mfc_ctx->port_b_size = 0;
+		break;
+
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+	case S5P_FIMV_CODEC_VC1_DEC:
+		mfc_ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE +
+			     3 * S5P_FIMV_DEC_VC1_BITPLANE_SIZE, 8192);
+		mfc_ctx->port_b_size = 0;
+		break;
+
+	case S5P_FIMV_CODEC_MPEG2_DEC:
+		mfc_ctx->port_a_size = 0;
+		mfc_ctx->port_b_size = 0;
+		break;
+	case S5P_FIMV_CODEC_H263_DEC:
+		mfc_ctx->port_a_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE, 8192);
+		mfc_ctx->port_b_size = 0;
+		break;
+	default:
+		break;
+	}
+
+	/* Allocate only if memory from bank 1 is necessary */
+	if (mfc_ctx->port_a_size > 0) {
+		mfc_ctx->port_a = cma_alloc(mfc_ctx->dev->v4l2_dev.dev,
+				MFC_CMA_BANK1, mfc_ctx->port_a_size, 2048);
+		if (IS_ERR_VALUE(mfc_ctx->port_a)) {
+			mfc_ctx->port_a = 0;
+			printk(KERN_ERR
+			       "Buf alloc for decoding failed (port A).\n");
+			return -ENOMEM;
+		}
+	}
+
+	/* Allocate only if memory from bank 2 is necessary */
+	if (mfc_ctx->port_b_size > 0) {
+		mfc_ctx->port_b = cma_alloc(mfc_ctx->dev->v4l2_dev.dev,
+				MFC_CMA_BANK2, mfc_ctx->port_b_size, 2048);
+		if (IS_ERR_VALUE(mfc_ctx->port_b)) {
+			mfc_ctx->port_b = 0;
+			mfc_err("Buf alloc for decoding "
+							"failed (port B).\n");
+			return -ENOMEM;
+		}
+	}
+	mfc_debug("%s--\n", __func__);
+
+	return 0;
+}
+
+/* Release buffers allocated for decoding */
+void s5p_mfc_release_dec_buffers(struct s5p_mfc_ctx *mfc_ctx)
+{
+	if (mfc_ctx->port_a) {
+		cma_free(mfc_ctx->port_a);
+		mfc_ctx->port_a = 0;
+		mfc_ctx->port_a_size = 0;
+	}
+	if (mfc_ctx->port_b) {
+		cma_free(mfc_ctx->port_b);
+		mfc_ctx->port_b = 0;
+		mfc_ctx->port_b_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	void *instance_virt;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	if (mfc_ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+		mfc_ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		mfc_ctx->instance_size = MFC_H264_INSTANCE_BUF_SIZE;
+	else
+		mfc_ctx->instance_size = MFC_INSTANCE_BUF_SIZE;
+	mfc_ctx->instance_phys = cma_alloc(mfc_ctx->dev->v4l2_dev.dev, \
+				MFC_CMA_BANK1, mfc_ctx->instance_size, 2048);
+	if (IS_ERR_VALUE(mfc_ctx->instance_phys)) {
+		mfc_ctx->instance_phys = 0;
+		mfc_err("Allocating instance buffer "
+								"failed.\n");
+		return -ENOMEM;
+	}
+	instance_virt = ioremap_nocache(mfc_ctx->instance_phys,
+		mfc_ctx->instance_size);
+	if (instance_virt == NULL) {
+		cma_free(mfc_ctx->instance_phys);
+		mfc_ctx->instance_phys = 0;
+		mfc_err("Remapping instance buffer "
+								"failed.\n");
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory, in future this might be done
+	 * by cma_alloc */
+	memset(instance_virt, 0, mfc_ctx->instance_size);
+	iounmap(instance_virt);
+	mfc_ctx->shared_phys = cma_alloc(mfc_ctx->dev->v4l2_dev.dev, \
+					MFC_CMA_BANK1, SHARED_BUF_SIZE, 2048);
+	if (IS_ERR_VALUE(mfc_ctx->shared_phys)) {
+		mfc_ctx->shared_phys = 0;
+		mfc_err("Allocating shared buffer failed\n");
+		cma_free(mfc_ctx->instance_phys);
+		return -ENOMEM;
+	}
+	mfc_ctx->shared_virt = ioremap_nocache(mfc_ctx->shared_phys,
+							       SHARED_BUF_SIZE);
+	if (!mfc_ctx->shared_virt) {
+		cma_free(mfc_ctx->instance_phys);
+		cma_free(mfc_ctx->shared_phys);
+		mfc_ctx->shared_phys = 0;
+		mfc_ctx->instance_phys = 0;
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory, in future this might be done
+	 * by cma_alloc */
+	memset((void *)mfc_ctx->shared_virt, 0, SHARED_BUF_SIZE);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Release instance buffer */
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	if (mfc_ctx->instance_phys) {
+		cma_free(mfc_ctx->instance_phys);
+		mfc_ctx->instance_phys = 0;
+	}
+	if (mfc_ctx->shared_virt) {
+		iounmap(mfc_ctx->shared_virt);
+		mfc_ctx->shared_virt = 0;
+	}
+	if (mfc_ctx->shared_phys) {
+		cma_free(mfc_ctx->shared_phys);
+		mfc_ctx->shared_phys = 0;
+	}
+	mfc_debug("%s--\n", __func__);
+}
+
+/* Set registers for decoding temporary buffers */
+void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	WRITEL(OFFSETA(mfc_ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
+	WRITEL(DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+}
+
+/* Set registers for shared buffer */
+void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	WRITEL(mfc_ctx->shared_phys - mfc_ctx->dev->port_a,
+	       S5P_FIMV_SI_CH0_HOST_WR_ADR);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *mfc_ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int buf_size)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("inst_no: %d, buf_addr: 0x%08x, buf_size: 0x"
+		"%08x (%d)\n",  mfc_ctx->inst_no, buf_addr, buf_size, buf_size);
+	if (buf_addr & (2048 - 1)) {
+		mfc_err("Source stream buffer is not aligned"
+							" correctly.\n");
+		return -EINVAL;
+	}
+	WRITEL(OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
+	WRITEL(CPB_BUF_SIZE, S5P_FIMV_SI_CH0_CPB_SIZE);
+	WRITEL(buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
+	mfc_debug("Shared_virt: %p (start offset: %d)\n",
+					mfc_ctx->shared_virt, start_num_byte);
+	writel(start_num_byte, mfc_ctx->shared_virt \
+					 + S5P_FIMV_SHARED_START_BYTE_NUM);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Set decoding frame buffer */
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *mfc_ctx)
+{
+	unsigned int frame_size, i;
+	unsigned int frame_size_ch, frame_size_mv;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+	unsigned int dpb;
+	size_t buf_addr1, buf_addr2;
+	int buf_size1, buf_size2;
+
+	buf_addr1 = mfc_ctx->port_a;
+	buf_size1 = mfc_ctx->port_a_size;
+	buf_addr2 = mfc_ctx->port_b;
+	buf_size2 = mfc_ctx->port_b_size;
+	mfc_debug("Buf1: %p (%d) Buf2: %p (%d)\n",
+		(void *)buf_addr1, buf_size1, (void *)buf_addr2, buf_size2);
+	mfc_debug("Total DPB COUNT: %d\n",
+						mfc_ctx->total_dpb_count);
+	mfc_debug("Setting display delay to %d\n",
+						mfc_ctx->display_delay);
+	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & 0xFFFF0000;
+	WRITEL(mfc_ctx->total_dpb_count | dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	s5p_mfc_set_shared_buffer(mfc_ctx);
+	switch (mfc_ctx->codec_mode) {
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
+			mfc_ctx->codec_mode);
+		return -EINVAL;
+		break;
+	}
+	frame_size = mfc_ctx->luma_size;
+	frame_size_ch = mfc_ctx->chroma_size;
+	frame_size_mv = mfc_ctx->mv_size;
+	mfc_debug("Frame size: %d ch: %d mv: %d\n", frame_size,
+						 frame_size_ch, frame_size_mv);
+	for (i = 0; i < mfc_ctx->total_dpb_count; i++) {
+		/* Port B */
+		mfc_debug("Luma %d: %x\n", i,
+						mfc_ctx->dec_dst_buf_luma[i]);
+		WRITEL(OFFSETB(mfc_ctx->dec_dst_buf_luma[i]),
+		       S5P_FIMV_LUMA_ADR + i * 4);
+		mfc_debug("\tChroma %d: %x\n", i, \
+						mfc_ctx->dec_dst_buf_chroma[i]);
+		WRITEL(OFFSETA(mfc_ctx->dec_dst_buf_chroma[i]),
+		       S5P_FIMV_CHROMA_ADR + i * 4);
+		if (mfc_ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+			mfc_debug("\tBuf2: %x, size: %d\n",
+							buf_addr2, buf_size2);
+			WRITEL(OFFSETB(buf_addr2), S5P_FIMV_MV_ADR + i * 4);
+			buf_addr2 += ALIGN(frame_size_mv, 8192);
+			buf_size2 -= ALIGN(frame_size_mv, 8192);
+		}
+	}
+	mfc_debug("Buf1: %u, buf_size1: %d\n", buf_addr1,
+								buf_size1);
+	mfc_debug("Buf 1/2 size after: %d/%d (frames %d)\n",
+			buf_size1,  buf_size2, mfc_ctx->total_dpb_count);
+	if (buf_size1 < 0 || buf_size2 < 0) {
+		mfc_debug("Not enough memory has been "
+								"allocated.\n");
+		return -ENOMEM;
+	}
+	writel(frame_size, mfc_ctx->shared_virt \
+					+ S5P_FIMV_SHARED_LUMA_DPB_SIZE);
+	writel(frame_size_ch, mfc_ctx->shared_virt \
+					+ S5P_FIMV_SHARED_CHROMA_DPB_SIZE);
+	if (mfc_ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+		writel(frame_size_mv, mfc_ctx->shared_virt \
+						+ S5P_FIMV_SHARED_MV_SIZE);
+	}
+	WRITEL(((S5P_FIMV_CH_INIT_BUFS << 16) & 0x70000) | (mfc_ctx->inst_no),
+						S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug("After setting buffers.\n");
+	return 0;
+}
+
+/* Allocate firmware */
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
+{
+	int err;
+	struct cma_info mem_info_f, mem_info_a, mem_info_b;
+
+	mfc_debug("%s++\n", __func__);
+	if (s5p_mfc_phys_bitproc_buff) {
+		mfc_err("Attempting to allocate firmware "
+				"when it seems that it is already loaded.\n");
+		return -ENOMEM;
+	}
+	/* Get memory region information and check if it is correct */
+	err = cma_info(&mem_info_f, dev->v4l2_dev.dev, MFC_CMA_FW);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has "
+		"size %08x","f", mem_info_f.lower_bound, mem_info_f.upper_bound,
+		mem_info_f.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information "
+								" from CMA.\n");
+		return -EINVAL;
+	}
+	err = cma_info(&mem_info_a, dev->v4l2_dev.dev, MFC_CMA_BANK1);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has "
+		"size %08x","a", mem_info_a.lower_bound, mem_info_a.upper_bound,
+		mem_info_a.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information "
+								"from CMA.\n");
+		return -EINVAL;
+	}
+	err = cma_info(&mem_info_b, dev->v4l2_dev.dev, MFC_CMA_BANK2);
+	mfc_debug("Area \"%s\" is from %08x to %08x and has "
+		"size %08x","b", mem_info_b.lower_bound, mem_info_b.upper_bound,
+		mem_info_b.total_size);
+	if (err) {
+		mfc_err("Couldn't get memory information "
+								"from CMA.\n");
+		return -EINVAL;
+	}
+	if (mem_info_f.upper_bound > mem_info_a.lower_bound) {
+			mfc_err("Firmware has to be "
+			"allocated before  memory for buffers (bank A).\n");
+		return -EINVAL;
+	}
+	mfc_debug("Allocating memory for firmware.\n");
+	s5p_mfc_phys_bitproc_buff = cma_alloc(dev->v4l2_dev.dev, MFC_CMA_FW,
+						FIRMWARE_CODE_SIZE, 128 * 1024);
+	mfc_debug("Phys addr from CMA: %08x\n",
+						s5p_mfc_phys_bitproc_buff);
+	if (IS_ERR_VALUE(s5p_mfc_phys_bitproc_buff)) {
+		s5p_mfc_phys_bitproc_buff = 0;
+		printk(KERN_ERR "Allocating bitprocessor buffer failed\n");
+		return -ENOMEM;
+	}
+	if (s5p_mfc_phys_bitproc_buff & 0x0001FFFF) {
+		mfc_err("The base memory is not aligned to "
+								"128KB.\n");
+		cma_free(s5p_mfc_phys_bitproc_buff);
+		return -EIO;
+	}
+	dev->port_a = s5p_mfc_phys_bitproc_buff;
+	dev->port_b = mem_info_b.lower_bound;
+	mfc_debug("Port A: %08x Port B: %08x (FW: %08x size: "
+		"%08x)\n", dev->port_a, dev->port_b, s5p_mfc_phys_bitproc_buff,
+							FIRMWARE_CODE_SIZE);
+	s5p_mfc_virt_bitproc_buff = ioremap_nocache(s5p_mfc_phys_bitproc_buff,
+							FIRMWARE_CODE_SIZE);
+	mfc_debug("Virtual address for FW: %08lx\n",
+				(long unsigned int)s5p_mfc_virt_bitproc_buff);
+	if (!s5p_mfc_virt_bitproc_buff) {
+		mfc_err("Bitprocessor memory ioremap "
+								"failed\n");
+		cma_free(s5p_mfc_phys_bitproc_buff);
+		s5p_mfc_phys_bitproc_buff = 0;
+		return -EIO;;
+	}
+	mfc_debug("%s--\n", __func__);
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
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Requesting fw\n");
+	err = request_firmware((const struct firmware **)&fw_blob,
+				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
+	mfc_debug("Ret of request_firmware: %d Size: %d\n",
+							err, fw_blob->size);
+	if (err != 0) {
+		mfc_err("Firmware is not present in the "
+			"/lib/firmware directory nor compiled in kernel.\n");
+		return -EINVAL;
+	}
+	if (fw_blob->size > FIRMWARE_CODE_SIZE) {
+		mfc_err("MFC firmware is too big to be "
+								"loaded.\n");
+		release_firmware(fw_blob);
+		return -ENOMEM;
+	}
+	if (s5p_mfc_phys_bitproc_buff == 0 || s5p_mfc_phys_bitproc_buff == 0) {
+		mfc_err("MFC firmware is not allocated or "
+						"was not mapped correctly.\n");
+		release_firmware(fw_blob);
+		return -EINVAL;
+	}
+	memcpy(s5p_mfc_virt_bitproc_buff, fw_blob->data, fw_blob->size);
+	release_firmware(fw_blob);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Release firmware memory */
+int s5p_mfc_release_firmware()
+{
+	/* Before calling this function one has to make sure
+	 * that MFC is no longer processing */
+	if (!s5p_mfc_phys_bitproc_buff)
+		return -EINVAL;
+	iounmap(s5p_mfc_virt_bitproc_buff);
+	s5p_mfc_virt_bitproc_buff = NULL;
+	cma_free(s5p_mfc_phys_bitproc_buff);
+	s5p_mfc_phys_bitproc_buff = 0;
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
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Device pointer: %p\n", dev);
+	if (!s5p_mfc_phys_bitproc_buff)
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
+	mfc_debug("Port A: %08x, Port B: %08x\n", dev->port_a,
+								dev->port_b);
+	/* 2. Initialize registers of stream I/F for decoder */
+	WRITEL(0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
+	WRITEL(0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
+	WRITEL(0, S5P_FIMV_RISC2HOST_CMD);
+	WRITEL(0, S5P_FIMV_HOST2RISC_CMD);
+	/* 3. Release reset signal to the RISC.  */
+	WRITEL(0x3ff, S5P_FIMV_SW_RESET);
+	mfc_debug("Will now wait for completion of firmware "
+								"transfer.\n");
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
+		mfc_err("Failed to send command to MFC - "
+								"timeout.\n");
+		return ret;
+	}
+	mfc_debug("Ok, now will write a command to init the "
+								"system\n");
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SYS_INIT_RET)) {
+		mfc_err("Failed to load firmware\n");
+		return -EIO;
+	}
+	dev->int_cond = 0;
+	if (dev->int_err != 0 || dev->int_type !=
+						S5P_FIMV_R2H_CMD_SYS_INIT_RET) {
+		/* Failure. */
+		mfc_err("Failed to init firmware - error: %d"
+				" int: %d.\n",dev->int_err, dev->int_type);
+		return -EIO;
+	}
+	fw_version = READL(S5P_FIMV_FW_VERSION);
+	mfc_info("MFC FW version : %02xyy, %02xmm, %02xdd\n",
+			 (fw_version >> 16) & 0xff, (fw_version >> 8) & 0xff,
+							 (fw_version) & 0xff);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Open a new instance and get its number */
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *mfc_ctx)
+{
+	int ret;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("Requested codec mode: %d\n",
+							mfc_ctx->codec_mode);
+	ret = s5p_mfc_cmd_host2risc(mfc_ctx->dev, mfc_ctx, \
+			S5P_FIMV_H2R_CMD_OPEN_INSTANCE, mfc_ctx->codec_mode);
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Close instance */
+int s5p_mfc_return_inst_no(struct s5p_mfc_ctx *mfc_ctx)
+{
+	int ret = 0;
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	if (mfc_ctx->state != MFCINST_FREE) {
+		ret = s5p_mfc_cmd_host2risc(dev, mfc_ctx,
+			S5P_FIMV_H2R_CMD_CLOSE_INSTANCE, mfc_ctx->inst_no);
+	} else {
+		ret = -EINVAL;
+	}
+	mfc_debug("%s--\n", __func__);
+	return ret;
+}
+
+/* Initialize decoding */
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *mfc_ctx)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("%s++\n", __func__);
+	mfc_debug("InstNo: %d/%d\n", mfc_ctx->inst_no,
+							S5P_FIMV_CH_SEQ_HEADER);
+	s5p_mfc_set_shared_buffer(mfc_ctx);
+	mfc_debug("BUFs: %08x %08x %08x %08x %08x\n",
+		  READL(S5P_FIMV_SI_CH0_DESC_ADR),
+		  READL(S5P_FIMV_SI_CH0_CPB_SIZE),
+		  READL(S5P_FIMV_SI_CH0_DESC_SIZE),
+		  READL(S5P_FIMV_SI_CH0_SB_ST_ADR),
+		  READL(S5P_FIMV_SI_CH0_SB_FRM_SIZE));
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (mfc_ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC) {
+		mfc_debug("Setting loop filter to: %d\n", \
+						mfc_ctx->loop_filter_mpeg4);
+		WRITEL(mfc_ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
+	} else {
+		WRITEL(0, S5P_FIMV_ENC_LF_CTRL);
+	}
+	WRITEL(((mfc_ctx->slice_interface & 1)<<31) |
+				((mfc_ctx->display_delay > 0 ? 1 : 0) << 30) |
+					((mfc_ctx->display_delay & 0xFF) << 16),
+						S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	if (mfc_ctx->codec_mode == S5P_FIMV_CODEC_DIVX311_DEC) {
+		mfc_debug("Setting DivX 3.11 resolution to "
+			"%dx%d\n", mfc_ctx->img_width, mfc_ctx->img_height);
+		WRITEL(mfc_ctx->img_width, S5P_FIMV_SI_DIVX311_HRESOL);
+		WRITEL(mfc_ctx->img_height, S5P_FIMV_SI_DIVX311_VRESOL);
+	}
+	WRITEL(((S5P_FIMV_CH_SEQ_HEADER << 16) & 0x70000) | (mfc_ctx->inst_no),
+						       S5P_FIMV_SI_CH0_INST_ID);
+	mfc_debug("%s--\n", __func__);
+	return 0;
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *mfc_ctx, int last_frame)
+{
+	struct s5p_mfc_dev *dev = mfc_ctx->dev;
+
+	mfc_debug("Setting flags to %08lx (free:%d WTF:%d)\n",
+				mfc_ctx->dec_dst_flag, mfc_ctx->dst_queue_cnt,
+						mfc_ctx->dec_dst_buf_cnt);
+	WRITEL(mfc_ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
+	s5p_mfc_set_shared_buffer(mfc_ctx);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	if (!last_frame)
+		WRITEL((S5P_FIMV_CH_FRAME_START << 16 & 0x70000) |
+				(mfc_ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	else
+		WRITEL((S5P_FIMV_CH_LAST_FRAME << 16 & 0x70000) |
+				(mfc_ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	mfc_debug("Decoding a usual frame.\n");
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
index 0000000..71dd4fe
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -0,0 +1,90 @@
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
+
+int s5p_mfc_release_firmware(void);
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
+int s5p_mfc_set_sleep(struct s5p_mfc_ctx *mfc_ctx);
+int s5p_mfc_set_wakeup(struct s5p_mfc_ctx *mfc_ctx);
+
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *mfc_ctx);
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *mfc_ctx, int buf_addr,
+						  unsigned int start_num_byte,
+						  unsigned int buf_size);
+
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *mfc_ctx, int last_frame);
+
+/* Instance handling */
+int s5p_mfc_open_inst(struct s5p_mfc_ctx *mfc_ctx);
+int s5p_mfc_return_inst_no(struct s5p_mfc_ctx *mfc_ctx);
+
+/* Memory allocation */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *mfc_ctx);
+
+int s5p_mfc_alloc_dec_buffers(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_release_dec_buffers(struct s5p_mfc_ctx *mfc_ctx);
+
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *mfc_ctx);
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *mfc_ctx);
+
+/* Getting parameters from MFC */
+#define s5p_mfc_get_h_crop(ctx)		readl((ctx)->shared_virt + \
+						S5P_FIMV_SHARED_CROP_INFO_H)
+#define s5p_mfc_get_v_crop(ctx)		readl((ctx)->shared_virt + \
+						S5P_FIMV_SHARED_CROP_INFO_V)
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
+#define s5p_mfc_get_pic_time_top(ctx)	readl((ctx)->shared_virt + \
+						S5P_FIMV_SHARED_PIC_TIME_TOP)
+#define s5p_mfc_get_pic_time_bottom(ctx) readl((ctx)->shared_virt + \
+						S5P_FIMV_SHARED_PIC_TIME_BOTTOM)
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
1.6.3.3

