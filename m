Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37634 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348Ab1CDL0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 06:26:44 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 12:26:20 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH v7 3/5] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, kgene.kim@samsung.com
Message-id: <1299237982-31687-4-git-send-email-k.debski@samsung.com>
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Multi Format Codec 5.1 is capable of handling a range of video codecs
and this driver provides V4L2 interface for video decoding.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    3 +
 drivers/media/video/s5p-mfc/regs-mfc5.h      |  346 ++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 2253 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  240 +++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  182 +++
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   47 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   92 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   43 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  913 +++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  142 ++
 13 files changed, 4296 insertions(+), 0 deletions(-)
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
index 12fb325..0bdc64d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1025,4 +1025,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	  This is a v4l2 driver for the S5P camera interface
 	  (video postprocessor)
 
+config VIDEO_SAMSUNG_S5P_MFC
+	tristate "Samsung S5P MFC 5.1 Video Codec"
+	depends on VIDEO_V4L2
+	select VIDEOBUF2_S5P_IOMMU
+	default n
+	help
+	    MFC 5.1 driver for V4L2.
+
 endif # V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index fd9488d..4b09ddb 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -164,6 +164,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
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
index 0000000..eeb6e2e
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc5.h
@@ -0,0 +1,346 @@
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
+#define S5P_FIMV_DEC_STATUS_PROGRESSIVE			(0 << 3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE			(1 << 3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE_MASK		(1 << 3)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_MASK		(3 << 4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_INC		(1 << 4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_DEC		(2 << 4)
+
+#if 0
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_TWO		(0 << 4)
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_FOUR		(1 << 4)
+#define S5P_FIMV_DEC_STATUS_CRC_NUMBER_MASK		(1 << 4)
+#define S5P_FIMV_DEC_STATUS_CRC_GENERATED		(1 << 5)
+#define S5P_FIMV_DEC_STATUS_CRC_NOT_GENERATED		(0 << 5)
+#define S5P_FIMV_DEC_STATUS_CRC_MASK			(1 << 5)
+#endif
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
+#define S5P_FIMV_NV12T_HALIGN			128
+#define S5P_FIMV_NV12T_VALIGN			32
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
+#define S5P_FIMV_SLICE_INT		(1 << 31)
+#define S5P_FIMV_DDELAY_ENA		(1 << 30)
+#define S5P_FIMV_DDELAY_VAL_MASK	0x3fff
+#define S5P_FIMV_DDELAY_VAL_SHIFT	16
+#define S5P_FIMV_DPB_COUNT_MASK		0x3fff
+#define S5P_FIMV_DPB_COUNT_SHIFT	0
+#define S5P_FIMV_DPB_FLUSH		(1 << 14)
+
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
index 0000000..43b598e
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -0,0 +1,2253 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.1
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
+#define DEBUG
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <media/videobuf2-s5p-iommu.h>
+#include <media/videobuf2-core.h>
+#include "regs-mfc5.h"
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_memory.h"
+#include "s5p_mfc_ctrls.h"
+#include "s5p_mfc_debug.h"
+
+#define S5P_MFC_NAME	"s5p-mfc"
+
+/* Offset base used to differentiate between CAPTURE and OUTPUT
+*  while mmaping */
+#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
+
+int debug = 10;
+module_param(debug, int, S_IRUGO | S_IWUSR);
+
+
+/* Function prototypes */
+static void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
+
+static int clk_count = 0;
+
+static inline void mfc_clk_enable(struct s5p_mfc_dev *dev)
+{
+	clk_count++;
+	mfc_debug("CLK_E: %d\n", clk_count);
+	clk_enable(dev->clock1);
+	clk_enable(dev->clock2);
+}
+
+static inline void mfc_clk_disable(struct s5p_mfc_dev *dev)
+{
+	clk_disable(dev->clock2);
+	clk_disable(dev->clock1);
+	clk_count--;
+	mfc_debug("CLK_D: %d\n", clk_count);
+}
+
+/* Helper functions for interrupt processing */
+/* Remove from hw execution round robin */
+static inline void clear_work_bit(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
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
+	wake_up(&ctx->queue);
+}
+
+/* Wake up device wait_queue */
+static inline void wake_up_dev(struct s5p_mfc_dev *dev, unsigned int reason,
+							unsigned int err)
+{
+	dev->int_cond = 1;
+	dev->int_type = reason;
+	dev->int_err = err;
+	wake_up(&dev->queue);
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
+
+	mfc_err("Driver timeout error handling.\n");
+	/* Lock the mutex that protects open and release.
+	 * This is necessary as they may load and unload firmware. */
+	mutex_locked = mutex_trylock(&dev->mfc_mutex);
+	if (!mutex_locked)
+		mfc_err("This is not good. Some instance may be "
+							"closing/opening.\n");
+	spin_lock_irqsave(&dev->irqlock, flags);
+	mfc_clk_disable(dev);
+	for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
+		ctx = dev->ctx[i];
+		if (ctx) {
+			ctx->state = MFCINST_DEC_ERROR;
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
+				mutex_unlock(&dev->mfc_mutex);
+			return;
+		}
+		mfc_clk_enable(dev);
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0) {
+			mfc_err("Failed to reinit FW.\n");
+			if (mutex_locked)
+				mutex_unlock(&dev->mfc_mutex);
+			return;
+		}
+		mfc_clk_disable(dev);
+	}
+	if (mutex_locked)
+		mutex_unlock(&dev->mfc_mutex);
+}
+
+/* Check whether a context should be run on hardware */
+int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug("s5p_mfc_ctx_ready: src=%d, dst=%d, "
+		"state=%d capstat=%d\n", ctx->src_queue_cnt, ctx->dst_queue_cnt,
+			ctx->state, ctx->capture_state);
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
+	if ((ctx->state == MFCINST_DEC_RES_CHANGE_INIT ||
+		ctx->state == MFCINST_DEC_RES_CHANGE_FLUSH) &&
+		ctx->dst_queue_cnt >= ctx->dpb_count)
+		return 1;
+	if (ctx->state == MFCINST_DEC_RES_CHANGE_END &&
+		ctx->src_queue_cnt >= 1)
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = priv;
+	struct v4l2_pix_format_mplane *pix_mp;
+
+	mfc_debug_enter();
+	pix_mp = &f->fmt.pix_mp;
+	mfc_debug("f->type = %d ctx->state = %d\n", f->type, ctx->state);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    (ctx->state == MFCINST_DEC_GOT_INST || ctx->state ==
+					MFCINST_DEC_RES_CHANGE_END)) {
+		/* If the MFC is parsing the header,
+		 * so wait until it is finished */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+									0);
+	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+	    ctx->state < MFCINST_ENC_INIT) {
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
+		pix_mp->pixelformat = ctx->fmt->fourcc;
+		pix_mp->num_planes = ctx->fmt->num_planes;
+	} else {
+		mfc_err("Format could not be read\n");
+		mfc_debug("%s-- with error\n", __func__);
+		return -EINVAL;
+	}
+	mfc_debug_leave();
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix_mp;
+
+	mfc_debug("Type is %d\n", f->type);
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Currently only decoding is supported.\n");
+		return -EINVAL;
+	}
+	fmt = find_format(f);
+	if (!fmt) {
+		mfc_err("Unsupported format.\n");
+		return -EINVAL;
+	}
+	if (fmt->type != MFC_FMT_DEC) {
+		mfc_err("\n");
+		return -EINVAL;
+	}
+	pix_mp = &f->fmt.pix_mp;
+	if (pix_mp->plane_fmt[0].sizeimage == 0) {
+		mfc_err("Application is required to "
+			"specify input buffer size (via sizeimage)\n");
+		return -EINVAL;
+	}
+	/* As this buffer will contain compressed data, the size is set
+	 * to the maximum size.
+	 * Width and height are left intact as they may be relevant for
+	 * DivX 3.11 decoding. */
+	pix_mp->plane_fmt[0].bytesperline = pix_mp->plane_fmt[0].sizeimage;
+	return 0;
+}
+
+/* Set format */
+static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = priv;
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
+	fmt = find_format(f);
+	if (!fmt || fmt->codec_mode == MFC_FORMATS_NO_CODEC) {
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
+	ctx->fmt = fmt;
+	ctx->codec_mode = fmt->codec_mode;
+	mfc_debug("The codec number is: %d\n", ctx->codec_mode);
+	ctx->pix_format = pix_mp->pixelformat;
+	if (pix_mp->pixelformat != V4L2_PIX_FMT_DIVX3) {
+		pix_mp->height = 0;
+		pix_mp->width = 0;
+	} else {
+		ctx->img_height = pix_mp->height;
+		ctx->img_width = pix_mp->width;
+	}
+	mfc_debug("s_fmt w/h: %dx%d, ctx: %dx%d\n", pix_mp->width,
+		pix_mp->height, ctx->img_width, ctx->img_height);
+	ctx->dec_src_buf_size =	pix_mp->plane_fmt[0].sizeimage;
+	pix_mp->plane_fmt[0].bytesperline = 0;
+	ctx->state = MFCINST_DEC_INIT;
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
+		s5p_mfc_release_dec_buffers(ctx);
+		ret = -EIO;
+		goto out;
+	}
+	mfc_debug("Got instance number: %d\n", ctx->inst_no);
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
+		if (ctx->state == MFCINST_DEC_GOT_INST) {
+			ctx->src_bufs_cnt = 0;
+			if (reqbufs->count == 0){
+				mfc_debug("Freeing src buffers.\n");
+				ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+				return ret;
+			}
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
+	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ctx->dst_bufs_cnt = 0;
+		if (reqbufs->count == 0) {
+			mfc_debug("Freeing dst buffers.\n");
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return ret;
+		}
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
+		ret = s5p_mfc_alloc_dec_buffers(ctx);
+		if (ret) {
+			mfc_err("Failed to allocate decoding buffers.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			return -ENOMEM;
+		}
+		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
+			ctx->capture_state = QUEUE_BUFS_MMAPED;
+		} else {
+			mfc_debug("ctx->dst_bufs_cnt = %d ctx->total_dpb_count"
+						" = %d\n", ctx->dst_bufs_cnt,
+							ctx->total_dpb_count);
+			mfc_err("Not all buffers passed to buf_init.\n");
+			reqbufs->count = 0;
+			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			s5p_mfc_release_dec_buffers(ctx);
+			return -ENOMEM;
+		}
+		if (s5p_mfc_ctx_ready(ctx)) {
+			spin_lock_irqsave(&dev->condlock, flags);
+			set_bit(ctx->num, &dev->ctx_work_bits);
+			spin_unlock_irqrestore(&dev->condlock, flags);
+		}
+		s5p_mfc_try_run(dev);
+		s5p_mfc_wait_for_done_ctx(ctx,
+					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+	}
+	mfc_debug_leave();
+	return ret;
+}
+
+/* Query buffer */
+static int vidioc_querybuf(struct file *file, void *priv,
+						   struct v4l2_buffer *buf)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
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
+	if (ctx->state == MFCINST_DEC_GOT_INST &&
+			buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = vb2_querybuf(&ctx->vq_src, buf);
+	} else if (ctx->state == MFCINST_DEC_RUNNING &&
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = priv;
+
+	mfc_debug_enter();
+	mfc_debug("Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
+	if (ctx->state == MFCINST_DEC_ERROR) {
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = priv;
+	int ret;
+
+	mfc_debug_enter();
+	mfc_debug("Addr: %p %p %p Type: %d\n", &ctx->vq_src, buf, buf->m.planes,
+								buf->type);
+	if (ctx->state == MFCINST_DEC_ERROR) {
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
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
+	case V4L2_CID_CODEC_DISPLAY_DELAY_ENABLE:
+		ctrl->value = ctx->display_delay_enable;
+		break;
+	case V4L2_CID_CODEC_MIN_REQ_BUFS_CAP:
+		if (ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+		    ctx->state < MFCINST_ENC_INIT) {
+			ctrl->value = ctx->dpb_count;
+			break;
+		} else if (ctx->state != MFCINST_DEC_INIT) {
+			v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
+			return -EINVAL;
+		}
+
+		/* Should wait for the header to be parsed */
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+		if (ctx->state >= MFCINST_DEC_HEAD_PARSED &&
+		    ctx->state < MFCINST_ENC_INIT) {
+			ctrl->value = ctx->dpb_count;
+		} else {
+			v4l2_err(&dev->v4l2_dev,
+					 "Decoding not initialised.\n");
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
+	struct s5p_mfc_dev *dev = ctx->dev;
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
+	struct s5p_mfc_dev *dev = video_drvdata(file);
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
+	case V4L2_CID_CODEC_DISPLAY_DELAY_ENABLE:
+		if (stream_on)
+			return -EBUSY;
+		ctx->display_delay_enable = ctrl->value;
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
+/* Get cropping information */
+static int vidioc_g_crop(struct file *file, void *priv,
+		struct v4l2_crop *cr)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = priv;
+	u32 left, right, top, bottom;
+
+	mfc_debug_enter();
+	if (ctx->state != MFCINST_DEC_HEAD_PARSED &&
+	ctx->state != MFCINST_DEC_RUNNING && ctx->state != MFCINST_DEC_FINISHING
+					&& ctx->state != MFCINST_DEC_FINISHED) {
+			mfc_debug("%s-- with error\n", __func__);
+			return -EINVAL;
+		}
+	if (ctx->fmt->fourcc == V4L2_PIX_FMT_H264) {
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
+/* Negotiate buffers */
+static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
+			       unsigned int *plane_count, unsigned long psize[],
+			       void *allocators[])
+{
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug_enter();
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
+		mfc_err("State seems invalid. State = %d, vq->type = %d\n",
+							ctx->state, vq->type);
+		return -EINVAL;
+	}
+	mfc_debug("%s, buffer count=%d, plane count=%d type=0x%x\n", __func__,
+					*buf_count, *plane_count, vq->type);
+
+	if (ctx->state == MFCINST_DEC_HEAD_PARSED &&
+	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		psize[0] = ctx->luma_size;
+		psize[1] = ctx->chroma_size;
+		allocators[0] = ctx->dev->alloc_ctx[1];
+		allocators[1] = ctx->dev->alloc_ctx[0];
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		   ctx->state == MFCINST_DEC_GOT_INST) {
+		psize[0] = ctx->dec_src_buf_size;
+		allocators[0] = ctx->dev->alloc_ctx[0];
+	} else {
+		mfc_err("Currently only decoding is supported. Decoding not initalised.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug("%s, plane=0, size=%lu\n", __func__, psize[0]);
+        mfc_debug("%s, plane=1, size=%lu\n", __func__, psize[1]);
+        mfc_debug("%s--\n", __func__);  
+	return 0;
+}
+
+static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int i;
+
+	mfc_debug_enter();
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (ctx->capture_state == QUEUE_BUFS_MMAPED) {
+			mfc_debug_leave();
+			return 0;
+		}
+		for (i = 0; i <= ctx->fmt->num_planes ; i++) {
+			if (s5p_mfc_plane_addr(vb, i) == 0) {
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
+		ctx->dst_bufs[i].cookie.raw.luma = s5p_mfc_plane_addr(vb, 0);
+		ctx->dst_bufs[i].cookie.raw.chroma = s5p_mfc_plane_addr(vb, 1);
+		ctx->dst_bufs_cnt++;
+
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		if (s5p_mfc_plane_addr(vb, 0)  == 0) {
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
+		ctx->src_bufs[i].cookie.stream = s5p_mfc_plane_addr(vb, 0);
+		ctx->src_bufs_cnt++;
+	} else {
+		mfc_err("s5p_mfc_buf_init: unknown queue type.\n");
+		return -EINVAL;
+	}
+	mfc_debug_leave();
+	return 0;
+}
+
+static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
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
+static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame(ctx, MFC_DEC_LAST_FRAME);
+}
+
+static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+	int dec_arg = MFC_DEC_FRAME;
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
+	mfc_debug("Src Addr: %08x\n", s5p_mfc_plane_addr(temp_vb->b, 0));
+	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b, 0),
+				ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+	        mfc_debug("Setting ctx->state to FINISHING\n");
+	        ctx->state = MFCINST_DEC_FINISHING;
+		dec_arg = MFC_DEC_LAST_FRAME;
+	}
+	s5p_mfc_decode_one_frame(ctx,
+				dec_arg);
+
+	return 0;
+}
+
+static inline int s5p_mfc_run_get_inst_no(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	/* Preparing decoding - getting instance number */
+	mfc_debug("Getting instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_open_inst(ctx);
+	if (ret) {
+		mfc_err("Failed to create a new instance.\n");
+		ctx->state = MFCINST_DEC_ERROR;
+	}
+	return ret;
+}
+
+static inline int s5p_mfc_run_return_inst(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	/* Closing decoding instance  */
+	mfc_debug("Returning instance number\n");
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_return_inst_no(ctx);
+	if (ret) {
+		mfc_err("Failed to return an instance.\n");
+		ctx->state = MFCINST_DEC_ERROR;
+		return ret;
+	}
+	return ret;
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
+	mfc_debug("Preparing to init decoding.\n");
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	s5p_mfc_set_dec_desc_buffer(ctx);
+	mfc_debug("Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	mfc_debug("paddr: %08x\n",
+			(int)phys_to_virt(s5p_mfc_plane_addr(temp_vb->b, 0)));
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_decode(ctx);
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
+	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_dec_frame_buffer(ctx);
+	if (ret) {
+		mfc_err("Failed to alloc frame mem.\n");
+		ctx->state = MFCINST_DEC_ERROR;
+	}
+	return ret;
+}
+/* Try running an operation on hardware */
+static void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned int ret;
+
+	mfc_debug("Try run dev: %p\n", dev);
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug("Couldn't lock HW.\n");
+		return;
+	}
+	/* Choose the context to run */
+	new_ctx = s5p_mfc_get_new_ctx(dev);
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
+	ret = 0;
+	mfc_clk_enable(dev);
+	s5p_mfc_set_dec_desc_buffer(ctx);
+	switch (ctx->state) {
+		case MFCINST_DEC_FINISHING:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_DEC_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx);
+			break;
+		case MFCINST_DEC_INIT:
+			ret = s5p_mfc_run_get_inst_no(ctx);
+			break;
+		case MFCINST_DEC_RETURN_INST:
+			ret = s5p_mfc_run_return_inst(ctx);
+			break;
+		case MFCINST_DEC_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_DEC_HEAD_PARSED:
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			break;
+		case MFCINST_DEC_RES_CHANGE_INIT:
+			mfc_err("try run - running resolution change\n");
+			s5p_mfc_run_res_change(ctx);
+			break;
+		case MFCINST_DEC_RES_CHANGE_FLUSH:
+			s5p_mfc_run_dec_frame(ctx);
+			break;
+		case MFCINST_DEC_RES_CHANGE_END:
+			mfc_debug("Finished remaining frames after resolution change.\n");
+			ctx->capture_state = QUEUE_FREE;
+			mfc_debug("Will re-init the codec`.\n");
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+			mfc_clk_disable(dev);
+	}
+	if (ret) {
+		/* Free hardware lock */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware.\n");
+		}
+	}
+}
+
+/* Queue buffer */
+static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct s5p_mfc_ctx *ctx = vq->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *mfc_buf;
+
+	mfc_debug_enter();
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_buf = &ctx->src_bufs[vb->v4l2_buf.index];
+		mfc_debug("Src queue: %p\n", &ctx->src_queue);
+		mfc_debug("Adding to src: %p (%08x, %08x)\n", vb,
+				s5p_mfc_plane_addr(vb, 0),
+				ctx->src_bufs[vb->v4l2_buf.index].cookie.stream);
+		spin_lock_irqsave(&dev->irqlock, flags);
+		list_add_tail(&mfc_buf->list, &ctx->src_queue);
+		ctx->src_queue_cnt++;
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		mfc_buf = &ctx->dst_bufs[vb->v4l2_buf.index];
+		mfc_debug("Dst queue: %p\n", &ctx->dst_queue);
+		mfc_debug("Adding to dst: %p (%08x)\n", vb,
+						  s5p_mfc_plane_addr(vb, 0));
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
+	s5p_mfc_try_run(dev);
+	mfc_debug_leave();
+}
+
+/* Let the streaming begin. */
+static int s5p_mfc_start_streaming(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = q->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	unsigned long flags;
+
+	if (ctx->state == MFCINST_DEC_FINISHING ||
+		ctx->state == MFCINST_DEC_FINISHED)
+		ctx->state = MFCINST_DEC_RUNNING;
+
+	/* If context is ready then dev = work->data;schedule it to run */
+	if (s5p_mfc_ctx_ready(ctx)) {
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+	}
+
+	s5p_mfc_try_run(dev);
+	return 0;
+}
+
+/* Thou shalt stream no more. */
+static int s5p_mfc_stop_streaming(struct vb2_queue *q)
+{
+	unsigned long flags;
+	struct s5p_mfc_ctx *ctx = q->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int aborted = 0;
+
+	mfc_debug_enter();
+	if ((ctx->state == MFCINST_DEC_FINISHING ||
+		ctx->state ==  MFCINST_DEC_RUNNING) &&
+		dev->curr_ctx == ctx->num && dev->hw_lock) {
+		ctx->state = MFCINST_DEC_ABORT;
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+									0);
+		aborted = 1;
+	}
+	spin_lock_irqsave(&dev->irqlock, flags);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		s5p_mfc_error_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		INIT_LIST_HEAD(&ctx->dst_queue);
+		ctx->dst_queue_cnt = 0;
+		ctx->dpb_flush_flag = 1;
+		ctx->dec_dst_flag = 0;
+	}
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		s5p_mfc_error_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		INIT_LIST_HEAD(&ctx->src_queue);
+		ctx->src_queue_cnt = 0;
+	}
+	if (aborted)
+		ctx->state = MFCINST_DEC_RUNNING;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	mfc_debug_leave();
+	return 0;
+}
+
+void s5p_mfc_lock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = q->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	mutex_lock(&dev->mfc_mutex);
+}
+
+void s5p_mfc_unlock(struct vb2_queue *q)
+{
+	struct s5p_mfc_ctx *ctx = q->drv_priv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	mutex_unlock(&dev->mfc_mutex);
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
+static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *dst_buf;
+
+	ctx->state = MFCINST_DEC_FINISHED;
+	mfc_debug("Decided to finish\n");
+	ctx->sequence++;
+	mfc_debug("Sequence is %d (++)\n", ctx->sequence);
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
+		mfc_debug("Sequence is %d (++)\n", ctx->sequence);
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
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf  *dst_buf, *src_buf;
+	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
+	size_t dec_y_addr = s5p_mfc_get_dec_y_adr();
+	unsigned int frame_type = s5p_mfc_get_dec_frame_type();
+
+	mfc_debug("Sequence is %d (++)\n", ctx->sequence);
+	/* If frame is same as previous then skip and do not dequeue */
+	if (frame_type ==  S5P_FIMV_DECODE_FRAME_SKIPPED) {
+		mfc_debug("Skipping frame.\n");
+		return;
+	}
+	ctx->sequence++;
+	/* Copy timestamp / timecode from decoded src to dst and set
+	   appropraite flags */
+	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		if (s5p_mfc_plane_addr(dst_buf->b, 0) == dec_y_addr) {
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
+
+	/* The MFC returns address of the buffer, now we have to
+	 * check which videobuf does it correspond to */
+	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
+		mfc_debug("Listing: %d\n", dst_buf->b->v4l2_buf.index);
+		/* Check if this is the buffer we're looking for */
+		if (s5p_mfc_plane_addr(dst_buf->b, 0) == dspl_y_addr) {
+			mfc_debug("Got the buffer\n");
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
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dst_frame_status;
+	struct s5p_mfc_buf *src_buf;
+	unsigned long flags;
+	unsigned int res_change;
+
+	dst_frame_status = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
+	res_change = s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
+	mfc_debug("Frame Status: %x\n", dst_frame_status);
+	if (ctx->state == MFCINST_DEC_RES_CHANGE_INIT)
+		ctx->state = MFCINST_DEC_RES_CHANGE_FLUSH;
+	if (res_change) {
+		mfc_err("Resolution change set to %d\n", res_change);
+		ctx->state = MFCINST_DEC_RES_CHANGE_INIT;
+
+		s5p_mfc_clear_int_flags();
+		wake_up_ctx(ctx, reason, err);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		s5p_mfc_try_run(dev);
+		return;
+	}
+	if (ctx->dpb_flush_flag)
+		ctx->dpb_flush_flag = 0;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	/* All frames remaining in the buffer have been extracted  */
+	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_EMPTY) {
+		if (ctx->state == MFCINST_DEC_RES_CHANGE_FLUSH) {
+			mfc_debug("Last frame received after resolution change.\n");
+			s5p_mfc_handle_frame_all_extracted(ctx);
+			ctx->state = MFCINST_DEC_RES_CHANGE_END;
+			goto leave_handle_frame;
+		} else {
+			s5p_mfc_handle_frame_all_extracted(ctx);
+		}
+	}
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
+		if (ctx->codec_mode != S5P_FIMV_CODEC_H264_DEC &&
+					s5p_mfc_get_dec_frame_type() ==
+					S5P_FIMV_DECODE_FRAME_P_FRAME
+					&& ctx->consumed_stream <
+					src_buf->b->v4l2_planes[0].bytesused) {
+			/* Run MFC again on the same buffer */
+			mfc_debug("Running again the same buffer.\n");
+		} else {
+			mfc_debug("MFC needs next buffer.\n");
+			/* Advance to next buffer */
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
+	mfc_debug("Assesing whether this context should be run again.\n");
+	if (!s5p_mfc_ctx_ready(ctx)) {
+		mfc_debug("No need to run again.\n");
+		clear_work_bit(ctx);
+	}
+	mfc_debug("After assesing whether this context should be run again.\n");
+	s5p_mfc_clear_int_flags();
+	wake_up_ctx(ctx, reason, err);
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		BUG();
+	s5p_mfc_try_run(dev);
+}
+
+/* Error handling for interrupt */
+static inline void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
+	unsigned int reason, unsigned int err)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	mfc_err("Interrupt Error: %08x\n", err);
+	s5p_mfc_clear_int_flags();
+	wake_up_dev(dev, reason, err);
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
+		spin_lock_irqsave(&dev->irqlock, flags);
+		s5p_mfc_error_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		/* Mark all src buffers as having an error */
+		s5p_mfc_error_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
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
+		if (ctx->state == MFCINST_DEC_RUNNING &&
+			s5p_mfc_err_dec(err) >= S5P_FIMV_ERR_WARNINGS_START)
+			s5p_mfc_handle_frame(ctx, reason, err);
+		else
+			s5p_mfc_handle_error(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
+	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
+		s5p_mfc_handle_frame(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+		if (ctx->fmt->fourcc != V4L2_PIX_FMT_DIVX3) {
+			ctx->img_width = s5p_mfc_get_img_width();
+			ctx->img_height = s5p_mfc_get_img_height();
+		}
+		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12T_HALIGN);
+		ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12T_VALIGN);
+		mfc_debug("SEQ Done: Movie dimensions %dx%d, "
+			"buffer dimensions: %dx%d\n", ctx->img_width,
+			ctx->img_height, ctx->buf_width, ctx->buf_height);
+		ctx->luma_size = ALIGN(ctx->buf_width * ctx->buf_height,
+							S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->chroma_size = ALIGN(ctx->buf_width *
+					ALIGN(ctx->img_height / 2,
+					S5P_FIMV_NV12T_VALIGN),
+					S5P_FIMV_DEC_BUF_ALIGN);
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+			ctx->mv_size = ALIGN(ctx->buf_width *
+					ALIGN(ctx->buf_height / 4,
+					S5P_FIMV_NV12T_VALIGN),
+					S5P_FIMV_DEC_BUF_ALIGN);
+		else
+			ctx->mv_size = 0;
+		ctx->dpb_count = s5p_mfc_get_dpb_count();
+		mfc_debug("Minimum DPB count: %d\n", ctx->dpb_count);
+		if (ctx->img_width != 0 && ctx->img_width != 0)
+		{
+			ctx->state = MFCINST_DEC_HEAD_PARSED;
+			s5p_mfc_clear_int_flags();
+			clear_work_bit(ctx);
+		} else {
+			ctx->state = MFCINST_DEC_ERROR;
+			s5p_mfc_clear_int_flags();
+			clear_work_bit(ctx);
+		}
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			BUG();
+		s5p_mfc_try_run(dev);
+		wake_up_ctx(ctx, reason, err);
+		break;
+	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_get_inst_no();
+		ctx->state = MFCINST_DEC_GOT_INST;
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
+		mfc_clk_enable(dev);
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
+			ctx->state = MFCINST_DEC_RUNNING;
+
+			if (!ctx->dpb_flush_flag) {
+				mfc_debug("INIT_BUFFERS with dpb_flush - leaving image in src queue.\n");
+				spin_lock_irqsave(&dev->irqlock, flags);
+				if (!list_empty(&ctx->src_queue)) {
+					src_buf = list_entry(ctx->src_queue.next,
+						       struct s5p_mfc_buf, list);
+					list_del(&src_buf->list);
+					ctx->src_queue_cnt--;
+					vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
+				}
+				spin_unlock_irqrestore(&dev->irqlock, flags);
+			} else {
+				ctx->dpb_flush_flag = 0;
+			}
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+			wake_up(&ctx->queue);
+			s5p_mfc_try_run(dev);
+		} else {
+			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+				BUG();
+			wake_up(&ctx->queue);
+		}
+		break;
+	default:
+		mfc_debug("Unknown int reason.\n");
+		s5p_mfc_clear_int_flags();
+	}
+	mfc_clk_disable(dev);
+	mfc_debug_leave();
+	return IRQ_HANDLED;
+irq_cleanup_hw:
+	s5p_mfc_clear_int_flags();
+	ctx->int_type = reason;
+	ctx->int_err = err;
+	ctx->int_cond = 1;
+	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+		mfc_err("Failed to unlock hw.\n");
+	mfc_clk_disable(dev);
+	s5p_mfc_try_run(dev);
+	mfc_debug("%s-- (via irq_cleanup_hw)\n", __func__);
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
+			ret = -EBUSY;
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
+	ctx->inst_no = -1;
+	pm_runtime_get_sync(&dev->plat_dev->dev);
+	/* Load firmware if this is the first instance */
+	if (dev->num_inst == 1) {
+		dev->watchdog_timer.expires = jiffies +
+					msecs_to_jiffies(MFC_WATCHDOG_INTERVAL);
+		add_timer(&dev->watchdog_timer);
+
+		mfc_debug("Enabling clocks.\n");
+		mfc_clk_enable(dev);
+
+		ret = s5p_mfc_init_alloc_ctx(dev);
+		if (ret != 0)
+			goto out_open_2aa;
+
+		/* Load the FW */
+		ret = s5p_mfc_alloc_firmware(dev);
+		if (ret != 0)
+			goto out_open_2a;
+		ret = s5p_mfc_load_firmware(dev);
+		if (ret != 0)
+			goto out_open_2;
+
+		/* Init the FW */
+		ret = s5p_mfc_init_hw(dev);
+		if (ret != 0)
+			goto out_open_3;
+
+		mfc_clk_disable(dev);
+	}
+
+	/* Init videobuf2 queue for CAPTURE */
+	q = &ctx->vq_dst;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->io_modes = VB2_MMAP;
+	q->drv_priv = ctx;
+	q->ops = &s5p_mfc_qops;
+	q->mem_ops = &vb2_s5p_iommu_memops;
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
+	q->ops = &s5p_mfc_qops;
+	q->mem_ops = &vb2_s5p_iommu_memops;
+	ret = vb2_queue_init(q);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(output)\n");
+		goto out_open_3;
+	}
+	init_waitqueue_head(&ctx->queue);
+	mfc_debug_leave();
+	return ret;
+	/* Deinit when failure occured */
+out_open_3:
+	if (dev->num_inst == 1) {
+		s5p_mfc_release_firmware(dev);
+	}
+out_open_2:
+	s5p_mfc_release_firmware(dev);
+out_open_2a:
+	if (dev->num_inst == 1) {
+		s5p_mfc_cleanup_alloc_ctx(dev);
+	}
+out_open_2aa:
+	if (dev->num_inst == 1) {
+		mfc_clk_disable(dev);
+	}
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
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+
+	mfc_debug_enter();
+
+	mfc_clk_enable(dev);
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
+		ctx->state = MFCINST_DEC_RETURN_INST;
+		spin_lock_irqsave(&dev->condlock, flags);
+		set_bit(ctx->num, &dev->ctx_work_bits);
+		spin_unlock_irqrestore(&dev->condlock, flags);
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_try_run(dev);
+		/* Wait until instance is returned or timeout occured */
+		if (s5p_mfc_wait_for_done_ctx
+		    (ctx, S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
+			mfc_err("Err returning instance.\n");
+		}
+		/* Free resources */
+		s5p_mfc_release_dec_buffers(ctx);
+		s5p_mfc_release_instance_buffer(ctx);
+		s5p_mfc_release_dec_desc_buffer(ctx);
+		ctx->inst_no = -1;
+	}
+	/* hardware locking scheme */
+	if (dev->curr_ctx == ctx->num)
+		clear_bit(0, &dev->hw_lock);
+	dev->num_inst--;
+	if (dev->num_inst == 0) {
+		s5p_mfc_deinit_hw(dev);
+		s5p_mfc_release_firmware(dev);
+		mfc_debug("Alloc ctx cleanup\n");
+		s5p_mfc_cleanup_alloc_ctx(dev);
+		mfc_debug("Disabling clocks...\n");
+		del_timer_sync(&dev->watchdog_timer);
+		mfc_clk_disable(dev);
+		pm_runtime_put(&dev->plat_dev->dev);
+	} else {
+		mfc_clk_disable(dev);
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
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
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
+	struct s5p_mfc_dev *dev;
+	struct video_device *vfd;
+	struct resource *res;
+	int ret = -ENOENT;
+	size_t size;
+
+	printk(KERN_ERR "Entering probe.\n");
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
+	dev->regs_base = ioremap(dev->mfc_mem->start,
+			      dev->mfc_mem->end - dev->mfc_mem->start + 1);
+	if (dev->regs_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap address region.\n");
+		ret = -ENOENT;
+		goto probe_out3;
+	}
+	dev->regs_base = dev->regs_base;
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
+	mutex_init(&dev->mfc_mutex);
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		goto probe_out6;
+	init_waitqueue_head(&dev->queue);
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+	*vfd = s5p_mfc_videodev;
+	vfd->lock = &dev->mfc_mutex;
+
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
+	dev->watchdog_timer.data = (unsigned long)dev;
+	dev->watchdog_timer.function = s5p_mfc_watchdog;
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+/*	dev->alloc_ctx = vb2_cma_init_multi(&pdev->dev, MFC_CMA_ALLOC_CTX_NUM,
+					s5p_mem_types, s5p_mem_alignments);*/
+
+	/* Initialize sysmmu memory allocator */
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
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+probe_out6:
+	free_irq(dev->irq, dev);
+probe_out5:
+probe_out4:
+	iounmap(dev->regs_base);
+	dev->regs_base = NULL;
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
+	struct s5p_mfc_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s++\n", __func__);
+	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
+	del_timer_sync(&dev->watchdog_timer);
+	flush_workqueue(dev->watchdog_workqueue);
+	destroy_workqueue(dev->watchdog_workqueue);
+	video_unregister_device(dev->vfd);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	mfc_debug("Will now deinit HW\n");
+	s5p_mfc_deinit_hw(dev);
+	free_irq(dev->irq, dev);
+	iounmap(dev->regs_base);
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
+static int s5p_mfc_runtime_suspend(struct device *dev)
+{
+	dev_dbg(dev, "%s\n", __func__);
+	return 0;
+}
+
+static int s5p_mfc_runtime_resume(struct device *dev)
+{
+	dev_dbg(dev, "%s\n", __func__);
+	return 0;
+}
+
+/* Power management */
+static const struct dev_pm_ops s5p_mfc_pm_ops = {
+	.suspend = s5p_mfc_suspend,
+	.resume = s5p_mfc_resume,
+	.runtime_suspend = s5p_mfc_runtime_suspend,
+	.runtime_resume = s5p_mfc_runtime_resume,
+};
+
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
+	printk(KERN_ERR "s5p_mfc_init: enter\n");
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
index 0000000..8bba55c
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -0,0 +1,240 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.1
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
+#define MFC_NO_INSTANCE_SET	-1
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
+	MFCINST_DEC_ABORT,
+	MFCINST_DEC_RES_CHANGE_INIT,
+	MFCINST_DEC_RES_CHANGE_FLUSH,
+	MFCINST_DEC_RES_CHANGE_END,
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
+/**
+ * enum s5p_mfc_decode_arg - Argument to the frame decode function
+ */
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
+	} cookie;
+};
+
+/**
+ * struct s5p_mfc_dev - The struct containing driver internal parameters.
+ */
+struct s5p_mfc_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vfd;
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
+	struct vb2_alloc_ctx *alloc_ctx[2];
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
+
+	enum s5p_mfc_queue_state capture_state;
+	enum s5p_mfc_queue_state output_state;
+
+//	size_t dec_dst_buf_luma[MFC_MAX_BUFFERS];
+//	size_t dec_dst_buf_chroma[MFC_MAX_BUFFERS];
+
+	struct s5p_mfc_buf src_bufs[MFC_MAX_BUFFERS];
+	int src_bufs_cnt;
+	struct s5p_mfc_buf dst_bufs[MFC_MAX_BUFFERS];
+	int dst_bufs_cnt;
+
+//	int dec_dst_buf_cnt;
+	unsigned int sequence;
+	unsigned long dec_dst_flag;
+	size_t dec_src_buf_size;
+
+	/* Control values */
+	int codec_mode;
+	__u32 pix_format;
+	int loop_filter_mpeg4;
+	int display_delay;
+	int display_delay_enable;
+
+	/* Buffers */
+
+	void *instance_buf;
+	size_t instance_phys;
+	size_t instance_size;
+	dma_addr_t instance_dma;
+
+	void *desc_buf;
+	size_t desc_phys;
+	dma_addr_t desc_dma;
+
+	void *shared_buf;
+	size_t shared_phys;
+	void *shared_virt;
+	dma_addr_t shared_dma;
+
+};
+
+#endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
new file mode 100644
index 0000000..158e28d
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
@@ -0,0 +1,182 @@
+/*
+ * Samsung S5P Multi Format Codec v 5.1
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
+	.name = "H264 Display Delay",
+	.minimum = 0,
+	.maximum = 16383,
+	.step = 1,
+	.default_value = 0,
+	},
+	{
+	.id = V4L2_CID_CODEC_DISPLAY_DELAY_ENABLE,
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.name = "H264 Display Delay Enable",
+	.minimum = 0,
+	.maximum = 1,
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
index 0000000..dd653a4
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_debug.h
@@ -0,0 +1,47 @@
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
+			dev_dbg(dev->v4l2_dev.dev, "%s:%s:%d:" fmt, __FILE__, __func__, __LINE__, ##__VA_ARGS__);	\
+	}while (0)
+#else
+#define mfc_debug(fmt, ...)
+#endif
+
+#define mfc_debug_enter() mfc_debug("enter")
+#define mfc_debug_leave() mfc_debug("leave")
+
+#define mfc_err(fmt, ...)						\
+	do {								\
+			dev_err(dev->v4l2_dev.dev,  "%s:%s:%d:" fmt, __FILE__, __func__, __LINE__, ##__VA_ARGS__);	\
+	}while (0)
+
+#define mfc_info(fmt, ...)						\
+	do {								\
+			dev_info(dev->v4l2_dev.dev, "%s:%s:%d:" fmt,  __FILE__, __func__, __LINE__, ##__VA_ARGS__);\
+	}while (0)
+
+
+#endif /* S5P_MFC_DEBUG_H_ */
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
new file mode 100644
index 0000000..fb878f8
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -0,0 +1,92 @@
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
+	ret = wait_event_timeout(dev->queue,
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
index 0000000..c45c5eb
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_memory.h
@@ -0,0 +1,43 @@
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
+#define MFC_CMA_ALLOC_CTX_NUM	3
+
+#define MFC_CMA_BANK1		"a"
+#define MFC_CMA_BANK2		"b"
+#define MFC_CMA_FW		"f"
+
+#define MFC_CMA_BANK1_ALLOC_CTX 0
+#define MFC_CMA_BANK2_ALLOC_CTX 1 
+#define MFC_CMA_FW_ALLOC_CTX 	2
+
+#define MFC_CMA_BANK1_ALIGN	0x2000	/* 8KB */
+#define MFC_CMA_BANK2_ALIGN	0x2000	/* 8KB */
+#define MFC_CMA_FW_ALIGN	0x20000	/* 128KB */
+
+
+#endif /* S5P_MFC_MEMORY_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
new file mode 100644
index 0000000..4e97cae
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -0,0 +1,913 @@
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
+#include <linux/platform_device.h>
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
+
+#include <media/videobuf2-s5p-iommu.h>
+
+static void *s5p_mfc_bitproc_buf;
+static size_t s5p_mfc_bitproc_phys;
+static unsigned char *s5p_mfc_bitproc_virt;
+static dma_addr_t s5p_mfc_bitproc_dma;
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
+	return vb2_s5p_iommu_memops.alloc(a, s);
+}
+
+static inline size_t s5p_mfc_mem_paddr(void *a, void *b)
+{
+	return (size_t)vb2_s5p_iommu_memops.cookie(b);
+}
+
+static inline void s5p_mfc_mem_put(void *a, void *b)
+{
+	vb2_s5p_iommu_memops.put(b);
+}
+
+static inline void *s5p_mfc_mem_vaddr(void *a, void *b)
+{
+	return vb2_s5p_iommu_memops.vaddr(b);
+}
+
+int s5p_mfc_init_alloc_ctx(struct s5p_mfc_dev *dev)
+{
+	struct vb2_s5p_iommu_request iommu_req;
+	mfc_debug_enter();
+
+	mfc_debug("Initializing MFC_L aka BANK_1\n");
+	memset(&iommu_req, 0, sizeof(iommu_req));
+	iommu_req.ip = S5P_SYSMMU_MFC_L;
+	iommu_req.align_order = 17;
+	iommu_req.mem_base = 0x30000000;
+	dev->port_a = iommu_req.mem_base;
+	iommu_req.mem_size = 0x10000000;
+	dev->alloc_ctx[0] = vb2_s5p_iommu_init(&dev->plat_dev->dev, &iommu_req);
+	if (IS_ERR(dev->alloc_ctx[0]))
+		goto alloc_ctx_err1;
+
+	mfc_debug("Initializing MFC_R aka BANK_2\n");
+	memset(&iommu_req, 0, sizeof(iommu_req));
+	iommu_req.ip = S5P_SYSMMU_MFC_R;
+	iommu_req.align_order = 17;
+	iommu_req.mem_base = 0x40000000;
+	dev->port_b = iommu_req.mem_base;
+	iommu_req.mem_size = 0x10000000;
+	dev->alloc_ctx[1] = vb2_s5p_iommu_init(&dev->plat_dev->dev, &iommu_req);
+	if (IS_ERR(dev->alloc_ctx[1]))
+		goto alloc_ctx_err2;
+
+	vb2_s5p_iommu_enable(dev->alloc_ctx[0]);
+	vb2_s5p_iommu_enable(dev->alloc_ctx[1]);
+
+	mfc_debug_leave();
+	return 0;
+alloc_ctx_err2:
+	vb2_s5p_iommu_cleanup(dev->alloc_ctx[0]);
+alloc_ctx_err1:
+	mfc_debug_leave();
+	return -ENOMEM;
+}
+
+void s5p_mfc_cleanup_alloc_ctx(struct s5p_mfc_dev *dev)
+{
+	mfc_debug_enter();
+	vb2_s5p_iommu_disable(dev->alloc_ctx[0]);
+	vb2_s5p_iommu_disable(dev->alloc_ctx[1]);
+	vb2_s5p_iommu_cleanup(dev->alloc_ctx[0]);
+	vb2_s5p_iommu_cleanup(dev->alloc_ctx[1]);
+	mfc_debug_leave();
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
+		ctx->desc_dma = 0;
+	}
+}
+
+/* Allocate decoding buffers */
+int s5p_mfc_alloc_dec_buffers(struct s5p_mfc_ctx *ctx)
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
+/* Release buffers allocated for decoding */
+void s5p_mfc_release_dec_buffers(struct s5p_mfc_ctx *ctx)
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
+
+	mfc_debug("Allocating is %d for instance\n", MFC_CMA_BANK1_ALLOC_CTX);
+
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
+	mfc_debug("Setting display delay to %d (ena=%d)\n", ctx->display_delay,
+						ctx->display_delay_enable);
+	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
+		~(S5P_FIMV_DPB_COUNT_MASK << S5P_FIMV_DPB_COUNT_SHIFT);
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
+		mfc_debug("Luma %d: %x\n", i, ctx->dst_bufs[i].cookie.raw.luma);
+		WRITEL(OFFSETB(ctx->dst_bufs[i].cookie.raw.luma),
+						S5P_FIMV_LUMA_ADR + i * 4);
+		mfc_debug("\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.chroma);
+		WRITEL(OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
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
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+		s5p_mfc_set_mv_size(ctx, frame_size_mv);
+	}
+	WRITEL(((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
+	mfc_debug("After setting buffers.\n");
+	return 0;
+}
+
+/* Allocate firmware */
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
+{
+	mfc_debug_enter();
+	if (s5p_mfc_bitproc_buf) {
+		mfc_err("Attempting to allocate firmware when it seems that it is already loaded.\n");
+		return -ENOMEM;
+	}
+	mfc_debug("Allocating memory for firmware.\n");
+	s5p_mfc_bitproc_buf = s5p_mfc_mem_alloc(
+		dev->alloc_ctx[0], FIRMWARE_CODE_SIZE);
+	if (IS_ERR(s5p_mfc_bitproc_buf)) {
+		s5p_mfc_bitproc_buf = 0;
+		printk(KERN_ERR "Allocating bitprocessor buffer failed\n");
+		return -ENOMEM;
+	}
+	s5p_mfc_bitproc_phys = s5p_mfc_mem_paddr(
+		dev->alloc_ctx, s5p_mfc_bitproc_buf);
+	if (s5p_mfc_bitproc_phys & (128 << 10)) {
+		mfc_err("The base memory is not aligned to 128KB.\n");
+		s5p_mfc_mem_put(dev->alloc_ctx,
+							s5p_mfc_bitproc_buf);
+		s5p_mfc_bitproc_phys = 0;
+		s5p_mfc_bitproc_buf = 0;
+		return -EIO;
+	}
+	mfc_debug("Port A: %08x Port B: %08x (FW: %08x size: %08x)\n",
+				dev->port_a, dev->port_b, s5p_mfc_bitproc_phys,
+							FIRMWARE_CODE_SIZE);
+	s5p_mfc_bitproc_virt = s5p_mfc_mem_vaddr(
+		dev->alloc_ctx, s5p_mfc_bitproc_buf);
+	mfc_debug("Virtual address for FW: %08lx\n",
+				(long unsigned int)s5p_mfc_bitproc_virt);
+	if (!s5p_mfc_bitproc_virt) {
+		mfc_err("Bitprocessor memory remap failed\n");
+		s5p_mfc_mem_put(dev->alloc_ctx,
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
+		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel.\n");
+		return -EINVAL;
+	}
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
+
+	s5p_mfc_mem_put(dev->alloc_ctx[MFC_CMA_FW_ALLOC_CTX],
+							s5p_mfc_bitproc_buf);
+	s5p_mfc_bitproc_virt =  0;
+	s5p_mfc_bitproc_phys = 0;
+	s5p_mfc_bitproc_buf = 0;
+	s5p_mfc_bitproc_dma = 0;
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
+				" int: %d.\n",dev->int_err, dev->int_type);
+		return -EIO;
+	}
+	fw_version = READL(S5P_FIMV_FW_VERSION);
+	mfc_debug("MFC FW version : %02xyy, %02xmm, %02xdd\n",
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
+	WRITEL((ctx->slice_interface ? S5P_FIMV_SLICE_INT : 0) |
+		(ctx->display_delay_enable ? S5P_FIMV_DDELAY_ENA : 0) |
+		((ctx->display_delay & S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
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
+void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	if (flush)
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) |
+						S5P_FIMV_DPB_FLUSH;
+	else
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
+					~S5P_FIMV_DPB_FLUSH;
+	WRITEL(dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
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
+	s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	switch (last_frame) {
+	case MFC_DEC_FRAME:
+		WRITEL(((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT ) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_LAST_FRAME:
+		WRITEL(((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_RES_CHANGE:
+		mfc_err("Resolution change command\n");
+		WRITEL(((S5P_FIMV_CH_FRAME_START_REALLOC & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	}
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
index 0000000..e9189f1
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -0,0 +1,142 @@
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
+#include "s5p_mfc_memory.h"
+#include "s5p_mfc_common.h"
+#include <linux/dma-mapping.h>
+
+#define s5p_mfc_plane_addr(vb, i) (u32)vb2_s5p_iommu_plane_addr(vb, i)
+
+int s5p_mfc_init_alloc_ctx(struct s5p_mfc_dev *dev);
+void s5p_mfc_cleanup_alloc_ctx(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
+int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
+int s5p_mfc_set_sleep(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_wakeup(struct s5p_mfc_ctx *ctx);
+
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+						  unsigned int start_num_byte,
+						  unsigned int buf_size);
+
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, int last_frame);
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
+int s5p_mfc_alloc_dec_buffers(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_release_dec_buffers(struct s5p_mfc_ctx *ctx);
+
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx);
+
+/* Getting parameters from MFC */
+static inline u32 s5p_mfc_get_h_crop(struct s5p_mfc_ctx *ctx)
+{
+	u32 d;
+	d = readl((ctx)->shared_virt + S5P_FIMV_SHARED_CROP_INFO_H);
+	return d;
+}
+
+static inline u32 s5p_mfc_get_v_crop(struct s5p_mfc_ctx *ctx)
+{
+	u32 d;
+	d = readl((ctx)->shared_virt + S5P_FIMV_SHARED_CROP_INFO_V);
+	return d;
+}
+
+#define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
+					S5P_FIMV_SI_DISPLAY_Y_ADR) << 11)
+#define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
+						S5P_FIMV_SI_DISPLAY_STATUS)
+#define s5p_mfc_get_dec_frame_type()	(readl(dev->regs_base + \
+						S5P_FIMV_DECODE_FRAME_TYPE) \
+					& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_dec_y_adr()		(readl(dev->regs_base + \
+					S5P_FIMV_DECODE_Y_ADR) << 11)
+#define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
+						S5P_FIMV_SI_CONSUMED_BYTES)
+#define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
+					S5P_FIMV_RISC2HOST_CMD) & 0x1FFFF)
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
+
+static inline u32 s5p_mfc_get_pic_time_top(struct s5p_mfc_ctx *ctx)
+{
+	u32 d;
+	d = readl((ctx)->shared_virt + S5P_FIMV_SHARED_PIC_TIME_TOP);
+	return d;
+}
+
+static inline u32 s5p_mfc_get_pic_time_bottom(struct s5p_mfc_ctx *ctx)
+{
+	u32 d;
+	d = readl((ctx)->shared_virt + S5P_FIMV_SHARED_PIC_TIME_BOTTOM);
+	return d;
+}
+
+/* Setting parameters of MFC */
+void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush);
+
+#define s5p_mfc_set_start_num(ctx, x) 	do { \
+	writel((x), ctx->shared_virt + S5P_FIMV_SHARED_START_BYTE_NUM); \
+	} while(0)
+
+#define s5p_mfc_set_luma_size(ctx, x) do { \
+	writel((x), ctx->shared_virt + S5P_FIMV_SHARED_LUMA_DPB_SIZE); \
+	} while(0)
+
+#define s5p_mfc_set_chroma_size(ctx, x) do { \
+	writel((x), ctx->shared_virt + S5P_FIMV_SHARED_CHROMA_DPB_SIZE); \
+	 } while(0)
+
+#define s5p_mfc_set_mv_size(ctx, x) do { \
+	writel((x), ctx->shared_virt + S5P_FIMV_SHARED_MV_SIZE); \
+	} while(0)
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
