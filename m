Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:12139 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2CBCT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 21:19:27 -0500
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M080035WJQCKUG0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:19:25 +0900 (KST)
Received: from jtppark ([12.23.118.214])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0800K3YJS85520@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:19:24 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>
Cc: janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Subject: [PATCH 3/3] MFC: update MFC v4l2 driver to support MFC6.x
Date: Fri, 02 Mar 2012 11:19:20 +0900
Message-id: <007301ccf81a$e25919b0$a70b4d10$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Multi Format Codec 6.x is a hardware video coding acceleration
module fount in new Exynos5 SoC series.
It is capable of handling a range of video codecs and this driver
provides a V4L2 interface for video decoding and encoding.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Singed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Singed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/Kconfig                  |   15 +-
 drivers/media/video/s5p-mfc/Makefile         |    7 +-
 drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  671 +++++++++++
 drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  157 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  129 ++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  125 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  113 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  212 +++-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  364 +++++--
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  266 +++--
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   20 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1670 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  137 +++
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   27 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
 19 files changed, 3587 insertions(+), 376 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9495b6a..561301c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1169,13 +1169,26 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec
 
 config VIDEO_SAMSUNG_S5P_MFC
+	bool
+
+config VIDEO_SAMSUNG_S5P_MFC_V5
 	tristate "Samsung S5P MFC 5.1 Video Codec"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS4
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEO_SAMSUNG_S5P_MFC
 	default n
 	help
 	    MFC 5.1 driver for V4L2.
 
+config VIDEO_SAMSUNG_S5P_MFC_V6
+	tristate "Samsung S5P MFC 6.x Video Codec"
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	select VIDEOBUF2_DMA_CONTIG
+	select VIDEO_SAMSUNG_S5P_MFC
+	default n
+	help
+	    MFC 6.x driver for V4L2.
+
 config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_IMX27
diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/video/s5p-mfc/Makefile
index d066340..0308d74 100644
--- a/drivers/media/video/s5p-mfc/Makefile
+++ b/drivers/media/video/s5p-mfc/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
-s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
+s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
-s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd.o
-s5p-mfc-y += s5p_mfc_pm.o s5p_mfc_shm.o
+s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_pm.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V5) += s5p_mfc_opr.o s5p_mfc_cmd.o s5p_mfc_shm.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V6) += s5p_mfc_opr_v6.o s5p_mfc_cmd_v6.o
diff --git a/drivers/media/video/s5p-mfc/regs-mfc-v6.h b/drivers/media/video/s5p-mfc/regs-mfc-v6.h
new file mode 100644
index 0000000..1dd47eb
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc-v6.h
@@ -0,0 +1,671 @@
+/*
+ * Register definition file for Samsung MFC V6.x Interface (FIMV) driver
+ *
+ * Copyright (c) 2012 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGS_FIMV_V6_H
+#define _REGS_FIMV_V6_H
+
+#define S5P_FIMV_REG_SIZE	(S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR)
+#define S5P_FIMV_REG_COUNT	((S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR) / 4)
+
+/* Number of bits that the buffer address should be shifted for particular
+ * MFC buffers.  */
+#define S5P_FIMV_MEM_OFFSET		0
+
+#define S5P_FIMV_START_ADDR		0x0000
+#define S5P_FIMV_END_ADDR		0xfd80
+
+#define S5P_FIMV_REG_CLEAR_BEGIN	0xf000
+#define S5P_FIMV_REG_CLEAR_COUNT	1024
+
+/* Codec Common Registers */
+#define S5P_FIMV_RISC_ON			0x0000
+#define S5P_FIMV_RISC2HOST_INT			0x003C
+#define S5P_FIMV_HOST2RISC_INT			0x0044
+#define S5P_FIMV_RISC_BASE_ADDRESS		0x0054
+
+#define S5P_FIMV_MFC_RESET			0x1070
+
+#define S5P_FIMV_HOST2RISC_CMD			0x1100
+#define S5P_FIMV_H2R_CMD_EMPTY			0
+#define S5P_FIMV_H2R_CMD_SYS_INIT		1
+#define S5P_FIMV_H2R_CMD_OPEN_INSTANCE		2
+#define S5P_FIMV_CH_SEQ_HEADER			3
+#define S5P_FIMV_CH_INIT_BUFS			4
+#define S5P_FIMV_CH_FRAME_START			5
+#define S5P_FIMV_H2R_CMD_CLOSE_INSTANCE		6
+#define S5P_FIMV_H2R_CMD_SLEEP			7
+#define S5P_FIMV_H2R_CMD_WAKEUP			8
+#define S5P_FIMV_CH_LAST_FRAME			9
+#define S5P_FIMV_H2R_CMD_FLUSH			10
+/* RMVME: REALLOC used? */
+#define S5P_FIMV_CH_FRAME_START_REALLOC		5
+
+#define S5P_FIMV_RISC2HOST_CMD			0x1104
+#define S5P_FIMV_R2H_CMD_EMPTY			0
+#define S5P_FIMV_R2H_CMD_SYS_INIT_RET		1
+#define S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET	2
+#define S5P_FIMV_R2H_CMD_SEQ_DONE_RET		3
+#define S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET	4
+
+#define S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET	6
+#define S5P_FIMV_R2H_CMD_SLEEP_RET		7
+#define S5P_FIMV_R2H_CMD_WAKEUP_RET		8
+#define S5P_FIMV_R2H_CMD_COMPLETE_SEQ_RET	9
+#define S5P_FIMV_R2H_CMD_DPB_FLUSH_RET		10
+#define S5P_FIMV_R2H_CMD_NAL_ABORT_RET		11
+#define S5P_FIMV_R2H_CMD_FW_STATUS_RET		12
+#define S5P_FIMV_R2H_CMD_FRAME_DONE_RET		13
+#define S5P_FIMV_R2H_CMD_FIELD_DONE_RET		14
+#define S5P_FIMV_R2H_CMD_SLICE_DONE_RET		15
+#define S5P_FIMV_R2H_CMD_ENC_BUFFER_FUL_RET	16
+#define S5P_FIMV_R2H_CMD_ERR_RET		32
+
+#define S5P_FIMV_FW_VERSION			0xF000
+
+#define S5P_FIMV_INSTANCE_ID			0xF008
+#define S5P_FIMV_CODEC_TYPE			0xF00C
+#define S5P_FIMV_CONTEXT_MEM_ADDR		0xF014
+#define S5P_FIMV_CONTEXT_MEM_SIZE		0xF018
+#define S5P_FIMV_PIXEL_FORMAT			0xF020
+
+#define S5P_FIMV_METADATA_ENABLE		0xF024
+#define S5P_FIMV_DBG_BUFFER_ADDR		0xF030
+#define S5P_FIMV_DBG_BUFFER_SIZE		0xF034
+#define S5P_FIMV_RET_INSTANCE_ID		0xF070
+
+#define S5P_FIMV_ERROR_CODE			0xF074
+#define S5P_FIMV_ERR_WARNINGS_START		160
+#define S5P_FIMV_ERR_DEC_MASK			0xFFFF
+#define S5P_FIMV_ERR_DEC_SHIFT			0
+#define S5P_FIMV_ERR_DSPL_MASK			0xFFFF0000
+#define S5P_FIMV_ERR_DSPL_SHIFT			16
+
+#define S5P_FIMV_DBG_BUFFER_OUTPUT_SIZE		0xF078
+#define S5P_FIMV_METADATA_STATUS		0xF07C
+#define S5P_FIMV_METADATA_ADDR_MB_INFO		0xF080
+#define S5P_FIMV_METADATA_SIZE_MB_INFO		0xF084
+
+/* Decoder Registers */
+#define S5P_FIMV_D_CRC_CTRL			0xF0B0
+#define S5P_FIMV_D_DEC_OPTIONS			0xF0B4
+#define S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK	4
+#define S5P_FIMV_D_OPT_DDELAY_EN_SHIFT		3
+#define S5P_FIMV_D_OPT_LF_CTRL_SHIFT		1
+#define S5P_FIMV_D_OPT_LF_CTRL_MASK		0x3
+#define S5P_FIMV_D_OPT_TILE_MODE_SHIFT		0
+
+#define S5P_FIMV_D_DISPLAY_DELAY		0xF0B8
+
+#define S5P_FIMV_D_SET_FRAME_WIDTH		0xF0BC
+#define S5P_FIMV_D_SET_FRAME_HEIGHT		0xF0C0
+
+#define S5P_FIMV_D_SEI_ENABLE			0xF0C4
+
+/* Buffer setting registers */
+#define S5P_FIMV_D_MIN_NUM_DPB			0xF0F0
+#define S5P_FIMV_D_MIN_LUMA_DPB_SIZE		0xF0F4
+#define S5P_FIMV_D_MIN_CHROMA_DPB_SIZE		0xF0F8
+#define S5P_FIMV_D_MVC_NUM_VIEWS		0xF0FC
+#define S5P_FIMV_D_NUM_DPB			0xF130
+#define S5P_FIMV_D_LUMA_DPB_SIZE		0xF134
+#define S5P_FIMV_D_CHROMA_DPB_SIZE		0xF138
+#define S5P_FIMV_D_MV_BUFFER_SIZE		0xF13C
+
+#define S5P_FIMV_D_LUMA_DPB			0xF140
+#define S5P_FIMV_D_CHROMA_DPB			0xF240
+#define S5P_FIMV_D_MV_BUFFER			0xF340
+
+#define S5P_FIMV_D_SCRATCH_BUFFER_ADDR		0xF440
+#define S5P_FIMV_D_SCRATCH_BUFFER_SIZE		0xF444
+#define S5P_FIMV_D_METADATA_BUFFER_ADDR		0xF448
+#define S5P_FIMV_D_METADATA_BUFFER_SIZE		0xF44C
+#define S5P_FIMV_D_CPB_BUFFER_ADDR		0xF4B0
+#define S5P_FIMV_D_CPB_BUFFER_SIZE		0xF4B4
+
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_UPPER	0xF4B8
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER	0xF4BC
+#define S5P_FIMV_D_CPB_BUFFER_OFFSET		0xF4C0
+#define S5P_FIMV_D_SLICE_IF_ENABLE		0xF4C4
+#define S5P_FIMV_D_PICTURE_TAG			0xF4C8
+#define S5P_FIMV_D_STREAM_DATA_SIZE		0xF4D0
+
+/* Display information register */
+#define S5P_FIMV_D_DISPLAY_FRAME_WIDTH		0xF500
+#define S5P_FIMV_D_DISPLAY_FRAME_HEIGHT		0xF504
+
+/* Display status */
+#define S5P_FIMV_D_DISPLAY_STATUS		0xF508
+#define S5P_FIMV_DEC_STATUS_DECODING_ONLY		0
+#define S5P_FIMV_DEC_STATUS_DECODING_DISPLAY		1
+#define S5P_FIMV_DEC_STATUS_DISPLAY_ONLY		2
+#define S5P_FIMV_DEC_STATUS_DECODING_EMPTY		3
+#define S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK	7
+#define S5P_FIMV_DEC_STATUS_PROGRESSIVE			(0<<3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE			(1<<3)
+#define S5P_FIMV_DEC_STATUS_INTERLACE_MASK		(1<<3)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_MASK		(3<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_INC		(1<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_DEC		(2<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT		4
+#define S5P_FIMV_DEC_STATUS_CRC_GENERATED		(1<<5)
+#define S5P_FIMV_DEC_STATUS_CRC_NOT_GENERATED		(0<<5)
+#define S5P_FIMV_DEC_STATUS_CRC_MASK			(1<<5)
+
+#define S5P_FIMV_D_DISPLAY_LUMA_ADDR		0xF50C
+#define S5P_FIMV_D_DISPLAY_CHROMA_ADDR		0xF510
+
+#define S5P_FIMV_D_DISPLAY_FRAME_TYPE		0xF514
+#define S5P_FIMV_DECODE_FRAME_SKIPPED		0
+#define S5P_FIMV_DECODE_FRAME_I_FRAME		1
+#define S5P_FIMV_DECODE_FRAME_P_FRAME		2
+#define S5P_FIMV_DECODE_FRAME_B_FRAME		3
+#define S5P_FIMV_DECODE_FRAME_OTHER_FRAME	4
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
+
+#define S5P_FIMV_D_DISPLAY_CROP_INFO1		0xF518
+#define S5P_FIMV_D_DISPLAY_CROP_INFO2		0xF51C
+#define S5P_FIMV_D_DISPLAY_PICTURE_PROFILE	0xF520
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_TOP		0xF524
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_TOP	0xF528
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_BOT		0xF52C
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_BOT	0xF530
+#define S5P_FIMV_D_DISPLAY_ASPECT_RATIO		0xF534
+#define S5P_FIMV_D_DISPLAY_EXTENDED_AR		0xF538
+
+/* Decoded picture information register */
+#define S5P_FIMV_D_DECODED_FRAME_WIDTH		0xF53C
+#define S5P_FIMV_D_DECODED_FRAME_HEIGHT		0xF540
+#define S5P_FIMV_D_DECODED_STATUS		0xF544
+#define S5P_FIMV_DEC_CRC_GEN_MASK		0x1
+#define S5P_FIMV_DEC_CRC_GEN_SHIFT		6
+
+#define S5P_FIMV_D_DECODED_LUMA_ADDR		0xF548
+#define S5P_FIMV_D_DECODED_CHROMA_ADDR		0xF54C
+
+#define S5P_FIMV_D_DECODED_FRAME_TYPE		0xF550
+#define S5P_FIMV_DECODE_FRAME_MASK		7
+
+#define S5P_FIMV_D_DECODED_CROP_INFO1		0xF554
+#define S5P_FIMV_D_DECODED_CROP_INFO2		0xF558
+#define S5P_FIMV_D_DECODED_PICTURE_PROFILE	0xF55C
+#define S5P_FIMV_D_DECODED_NAL_SIZE		0xF560
+#define S5P_FIMV_D_DECODED_LUMA_CRC_TOP		0xF564
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_TOP	0xF568
+#define S5P_FIMV_D_DECODED_LUMA_CRC_BOT		0xF56C
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_BOT	0xF570
+
+/* Returned value register for specific setting */
+#define S5P_FIMV_D_RET_PICTURE_TAG_TOP		0xF574
+#define S5P_FIMV_D_RET_PICTURE_TAG_BOT		0xF578
+#define S5P_FIMV_D_RET_PICTURE_TIME_TOP		0xF57C
+#define S5P_FIMV_D_RET_PICTURE_TIME_BOT		0xF580
+#define S5P_FIMV_D_CHROMA_FORMAT		0xF588
+#define S5P_FIMV_D_MPEG4_INFO			0xF58C
+#define S5P_FIMV_D_H264_INFO			0xF590
+
+#define S5P_FIMV_D_METADATA_ADDR_CONCEALED_MB	0xF594
+#define S5P_FIMV_D_METADATA_SIZE_CONCEALED_MB	0xF598
+#define S5P_FIMV_D_METADATA_ADDR_VC1_PARAM	0xF59C
+#define S5P_FIMV_D_METADATA_SIZE_VC1_PARAM	0xF5A0
+#define S5P_FIMV_D_METADATA_ADDR_SEI_NAL	0xF5A4
+#define S5P_FIMV_D_METADATA_SIZE_SEI_NAL	0xF5A8
+#define S5P_FIMV_D_METADATA_ADDR_VUI		0xF5AC
+#define S5P_FIMV_D_METADATA_SIZE_VUI		0xF5B0
+
+#define S5P_FIMV_D_MVC_VIEW_ID			0xF5B4
+
+/* SEI related information */
+#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL		0xF5F0
+#define S5P_FIMV_D_FRAME_PACK_ARRGMENT_ID	0xF5F4
+#define S5P_FIMV_D_FRAME_PACK_SEI_INFO		0xF5F8
+#define S5P_FIMV_D_FRAME_PACK_GRID_POS		0xF5FC
+
+/* Encoder Registers */
+#define S5P_FIMV_E_FRAME_WIDTH			0xF770
+#define S5P_FIMV_E_FRAME_HEIGHT			0xF774
+#define S5P_FIMV_E_CROPPED_FRAME_WIDTH		0xF778
+#define S5P_FIMV_E_CROPPED_FRAME_HEIGHT		0xF77C
+#define S5P_FIMV_E_FRAME_CROP_OFFSET		0xF780
+#define S5P_FIMV_E_ENC_OPTIONS			0xF784
+#define S5P_FIMV_E_PICTURE_PROFILE		0xF788
+#define S5P_FIMV_ENC_PROFILE_H264_MAIN			0
+#define S5P_FIMV_ENC_PROFILE_H264_HIGH			1
+#define S5P_FIMV_ENC_PROFILE_H264_BASELINE		2
+#define S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE	3
+#define S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE		0
+#define S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE	1
+#define S5P_FIMV_E_FIXED_PICTURE_QP		0xF790
+
+#define S5P_FIMV_E_RC_CONFIG			0xF794
+#define S5P_FIMV_E_RC_QP_BOUND			0xF798
+#define S5P_FIMV_E_RC_RPARAM			0xF79C
+#define S5P_FIMV_E_MB_RC_CONFIG			0xF7A0
+#define S5P_FIMV_E_PADDING_CTRL			0xF7A4
+#define S5P_FIMV_E_MV_HOR_RANGE			0xF7AC
+#define S5P_FIMV_E_MV_VER_RANGE			0xF7B0
+
+#define S5P_FIMV_E_VBV_BUFFER_SIZE		0xF84C
+#define S5P_FIMV_E_VBV_INIT_DELAY		0xF850
+#define S5P_FIMV_E_NUM_DPB			0xF890
+#define S5P_FIMV_E_LUMA_DPB			0xF8C0
+#define S5P_FIMV_E_CHROMA_DPB			0xF904
+#define S5P_FIMV_E_ME_BUFFER			0xF948
+
+#define S5P_FIMV_E_SCRATCH_BUFFER_ADDR		0xF98C
+#define S5P_FIMV_E_SCRATCH_BUFFER_SIZE		0xF990
+#define S5P_FIMV_E_TMV_BUFFER0			0xF994
+#define S5P_FIMV_E_TMV_BUFFER1			0xF998
+#define S5P_FIMV_E_SOURCE_LUMA_ADDR		0xF9F0
+#define S5P_FIMV_E_SOURCE_CHROMA_ADDR		0xF9F4
+#define S5P_FIMV_E_STREAM_BUFFER_ADDR		0xF9F8
+#define S5P_FIMV_E_STREAM_BUFFER_SIZE		0xF9FC
+#define S5P_FIMV_E_ROI_BUFFER_ADDR		0xFA00
+
+#define S5P_FIMV_E_PARAM_CHANGE			0xFA04
+#define S5P_FIMV_E_IR_SIZE			0xFA08
+#define S5P_FIMV_E_GOP_CONFIG			0xFA0C
+#define S5P_FIMV_E_MSLICE_MODE			0xFA10
+#define S5P_FIMV_E_MSLICE_SIZE_MB		0xFA14
+#define S5P_FIMV_E_MSLICE_SIZE_BITS		0xFA18
+#define S5P_FIMV_E_FRAME_INSERTION		0xFA1C
+
+#define S5P_FIMV_E_RC_FRAME_RATE		0xFA20
+#define S5P_FIMV_E_RC_BIT_RATE			0xFA24
+#define S5P_FIMV_E_RC_QP_OFFSET			0xFA28
+#define S5P_FIMV_E_RC_ROI_CTRL			0xFA2C
+#define S5P_FIMV_E_PICTURE_TAG			0xFA30
+#define S5P_FIMV_E_BIT_COUNT_ENABLE		0xFA34
+#define S5P_FIMV_E_MAX_BIT_COUNT		0xFA38
+#define S5P_FIMV_E_MIN_BIT_COUNT		0xFA3C
+
+#define S5P_FIMV_E_METADATA_BUFFER_ADDR		0xFA40
+#define S5P_FIMV_E_METADATA_BUFFER_SIZE		0xFA44
+#define S5P_FIMV_E_STREAM_SIZE			0xFA80
+#define S5P_FIMV_E_SLICE_TYPE			0xFA84
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_NON_CODED	0
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_I		1
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_P		2
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_B		3
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_SKIPPED	4
+#define S5P_FIMV_ENC_SI_SLICE_TYPE_OTHERS	5
+#define S5P_FIMV_E_PICTURE_COUNT		0xFA88
+#define S5P_FIMV_E_RET_PICTURE_TAG		0xFA8C
+#define S5P_FIMV_E_STREAM_BUFFER_WRITE_POINTER	0xFA90
+
+#define S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR	0xFA94
+#define S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR	0xFA98
+#define S5P_FIMV_E_RECON_LUMA_DPB_ADDR		0xFA9C
+#define S5P_FIMV_E_RECON_CHROMA_DPB_ADDR	0xFAA0
+#define S5P_FIMV_E_METADATA_ADDR_ENC_SLICE	0xFAA4
+#define S5P_FIMV_E_METADATA_SIZE_ENC_SLICE	0xFAA8
+
+#define S5P_FIMV_E_MPEG4_OPTIONS		0xFB10
+#define S5P_FIMV_E_MPEG4_HEC_PERIOD		0xFB14
+#define S5P_FIMV_E_ASPECT_RATIO			0xFB50
+#define S5P_FIMV_E_EXTENDED_SAR			0xFB54
+
+#define S5P_FIMV_E_H264_OPTIONS			0xFB58
+#define S5P_FIMV_E_H264_LF_ALPHA_OFFSET		0xFB5C
+#define S5P_FIMV_E_H264_LF_BETA_OFFSET		0xFB60
+#define S5P_FIMV_E_H264_I_PERIOD		0xFB64
+
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE			0xFB68
+#define S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1		0xFB6C
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR		0xFB70
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1	0xFB74
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0	0xFB78
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_1	0xFB7C
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_2	0xFB80
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_3	0xFB84
+
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_0	0xFB88
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_1	0xFB8C
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_2	0xFB90
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_3	0xFB94
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_4	0xFB98
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_5	0xFB9C
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_6	0xFBA0
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_7	0xFBA4
+
+#define S5P_FIMV_E_H264_CHROMA_QP_OFFSET	0xFBA8
+#define S5P_FIMV_E_H264_NUM_T_LAYER		0xFBAC
+
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0	0xFBB0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER1	0xFBB4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER2	0xFBB8
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER3	0xFBBC
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER4	0xFBC0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER5	0xFBC4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER6	0xFBC8
+
+#define S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO	0xFC4C
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE	0
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TOP_BOTTOM	1
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TEMPORAL	2
+
+#define S5P_FIMV_E_MVC_FRAME_QP_VIEW1		0xFD40
+#define S5P_FIMV_E_MVC_RC_FRAME_RATE_VIEW1	0xFD44
+#define S5P_FIMV_E_MVC_RC_BIT_RATE_VIEW1	0xFD48
+#define S5P_FIMV_E_MVC_RC_QBOUND_VIEW1		0xFD4C
+#define S5P_FIMV_E_MVC_RC_RPARA_VIEW1		0xFD50
+#define S5P_FIMV_E_MVC_INTER_VIEW_PREDICTION_ON	0xFD80
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
+#define S5P_FIMV_CODEC_H264_MVC_DEC	6
+#define S5P_FIMV_CODEC_VP8_DEC		7
+
+#define S5P_FIMV_CODEC_H264_ENC		16
+#define S5P_FIMV_CODEC_MPEG4_ENC	17
+#define S5P_FIMV_CODEC_H263_ENC		18
+#define S5P_FIMV_CODEC_H264_MVC_ENC	19
+
+/***	Definitions for MFCv5 compatibility ***/
+#define S5P_FIMV_SI_DISPLAY_Y_ADR		S5P_FIMV_D_DISPLAY_LUMA_ADDR
+#define S5P_FIMV_SI_DISPLAY_C_ADR		S5P_FIMV_D_DISPLAY_CHROMA_ADDR
+
+#define S5P_FIMV_CRC_LUMA0			S5P_FIMV_D_DECODED_LUMA_CRC_TOP
+#define S5P_FIMV_CRC_CHROMA0			S5P_FIMV_D_DECODED_CHROMA_CRC_TOP
+#define S5P_FIMV_CRC_LUMA1			S5P_FIMV_D_DECODED_LUMA_CRC_BOT
+#define S5P_FIMV_CRC_CHROMA1			S5P_FIMV_D_DECODED_CHROMA_CRC_BOT
+#define S5P_FIMV_CRC_DISP_LUMA0			S5P_FIMV_D_DISPLAY_LUMA_CRC_TOP
+#define S5P_FIMV_CRC_DISP_CHROMA0		S5P_FIMV_D_DISPLAY_CHROMA_CRC_TOP
+
+#define S5P_FIMV_SI_DECODED_STATUS		S5P_FIMV_D_DECODED_STATUS
+#define S5P_FIMV_SI_DISPLAY_STATUS		S5P_FIMV_D_DISPLAY_STATUS
+#define S5P_FIMV_SHARED_SET_FRAME_TAG		S5P_FIMV_D_PICTURE_TAG
+#define S5P_FIMV_SHARED_GET_FRAME_TAG_TOP	S5P_FIMV_D_RET_PICTURE_TAG_TOP
+#define S5P_FIMV_CRC_DISP_STATUS		S5P_FIMV_D_DISPLAY_STATUS
+
+/* SEI related information */
+#define S5P_FIMV_FRAME_PACK_SEI_AVAIL		S5P_FIMV_D_FRAME_PACK_SEI_AVAIL
+#define S5P_FIMV_FRAME_PACK_ARRGMENT_ID		S5P_FIMV_D_FRAME_PACK_ARRGMENT_ID
+#define S5P_FIMV_FRAME_PACK_SEI_INFO		S5P_FIMV_D_FRAME_PACK_SEI_INFO
+#define S5P_FIMV_FRAME_PACK_GRID_POS		S5P_FIMV_D_FRAME_PACK_GRID_POS
+
+#define S5P_FIMV_SHARED_SET_E_FRAME_TAG		S5P_FIMV_E_PICTURE_TAG
+#define S5P_FIMV_SHARED_GET_E_FRAME_TAG		S5P_FIMV_E_RET_PICTURE_TAG
+#define S5P_FIMV_ENCODED_LUMA_ADDR		S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR
+#define S5P_FIMV_ENCODED_CHROMA_ADDR		S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR
+#define	S5P_FIMV_FRAME_INSERTION		S5P_FIMV_E_FRAME_INSERTION
+
+#define S5P_FIMV_PARAM_CHANGE_FLAG		S5P_FIMV_E_PARAM_CHANGE /* flag */
+#define S5P_FIMV_NEW_I_PERIOD			S5P_FIMV_E_GOP_CONFIG
+#define S5P_FIMV_NEW_RC_FRAME_RATE		S5P_FIMV_E_RC_FRAME_RATE
+#define S5P_FIMV_NEW_RC_BIT_RATE		S5P_FIMV_E_RC_BIT_RATE
+/*** End of MFCv5 compatibility definitions ***/
+
+/***      old definitions     ***/
+#if 1
+
+#define S5P_FIMV_SW_RESET		0x0000
+#define S5P_FIMV_RISC_HOST_INT		0x0008
+
+/* Command from HOST to RISC */
+#define S5P_FIMV_HOST2RISC_ARG1		0x0034
+#define S5P_FIMV_HOST2RISC_ARG2		0x0038
+#define S5P_FIMV_HOST2RISC_ARG3		0x003c
+#define S5P_FIMV_HOST2RISC_ARG4		0x0040
+
+/* Command from RISC to HOST */
+#define S5P_FIMV_RISC2HOST_CMD_MASK	0x1FFFF
+#define S5P_FIMV_RISC2HOST_ARG1		0x0048
+#define S5P_FIMV_RISC2HOST_ARG2		0x004c
+#define S5P_FIMV_RISC2HOST_ARG3		0x0050
+#define S5P_FIMV_RISC2HOST_ARG4		0x0054
+
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
+#define S5P_FIMV_SI_CONSUMED_BYTES	0x2018 /* Consumed number of bytes to decode
+								a frame */
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
+#define S5P_FIMV_SI_FIMV1_HRESOL	0x2054 /* horizontal resolution */
+#define S5P_FIMV_SI_FIMV1_VRESOL	0x2050 /* vertical resolution */
+
+/* Decode frame address */
+#define S5P_FIMV_DECODE_Y_ADR			0x2024
+#define S5P_FIMV_DECODE_C_ADR			0x2028
+
+/* Decoded frame type */
+#define S5P_FIMV_DECODE_FRAME_TYPE		0x2020
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
+#define S5P_FIMV_NV12M_HALIGN			16
+#define S5P_FIMV_NV12MT_HALIGN			16
+#define S5P_FIMV_NV12MT_VALIGN			16
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
+#define S5P_FIMV_ENC_MAP_FOR_CUR	0xc51c /* linear or 64x32 tiled mode */
+#define S5P_FIMV_ENC_PADDING_CTRL	0xc520 /* padding control */
+
+#define S5P_FIMV_ENC_RC_CONFIG		0xc5a0 /* RC config */
+#define S5P_FIMV_ENC_RC_BIT_RATE	0xc5a8 /* bit rate */
+#define S5P_FIMV_ENC_RC_QBOUND		0xc5ac /* max/min QP */
+#define S5P_FIMV_ENC_RC_RPARA		0xc5b0 /* rate control reaction coeff */
+#define S5P_FIMV_ENC_RC_MB_CTRL		0xc5b4 /* MB adaptive scaling */
+
+/* Encoder for H264 only */
+#define S5P_FIMV_ENC_H264_ENTRP_MODE	0xd004 /* CAVLC or CABAC */
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
+#define S5P_FIMV_DPB_COUNT_MASK		0xffff
+
+#define S5P_FIMV_SI_CH0_RELEASE_BUF     0x2060 /* DPB release buffer register */
+#define S5P_FIMV_SI_CH0_HOST_WR_ADR	0x2064 /* address of shared memory */
+
+/* Channel Control Register */
+#define S5P_FIMV_CH_FRAME_START_REALLOC	5
+
+#define S5P_FIMV_CH_MASK		7
+#define S5P_FIMV_CH_SHIFT		16
+
+/* Host to RISC command */
+#define S5P_FIMV_R2H_CMD_RSV_RET		3
+#define S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET	7
+#define S5P_FIMV_R2H_CMD_FLUSH_RET		12
+#define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
+
+/* Shared memory registers' offsets */
+
+/* An offset of the start position in the stream when
+ * the start position is not aligned */
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
+#endif /* End of old definitions */
+
+#endif /* _REGS_FIMV_V6_H */
diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/video/s5p-mfc/regs-mfc.h
index 053a8a8..8e61729 100644
--- a/drivers/media/video/s5p-mfc/regs-mfc.h
+++ b/drivers/media/video/s5p-mfc/regs-mfc.h
@@ -144,6 +144,7 @@
 #define S5P_FIMV_ENC_PROFILE_H264_MAIN			0
 #define S5P_FIMV_ENC_PROFILE_H264_HIGH			1
 #define S5P_FIMV_ENC_PROFILE_H264_BASELINE		2
+#define S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE	3
 #define S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE		0
 #define S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE	1
 #define S5P_FIMV_ENC_PIC_STRUCT		0x083c /* picture field/frame flag */
@@ -208,6 +209,7 @@
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_MASK		(3<<4)
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_INC		(1<<4)
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_DEC		(2<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT		4
 
 /* Decode frame address */
 #define S5P_FIMV_DECODE_Y_ADR			0x2024
@@ -372,6 +374,16 @@
 #define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
 #define S5P_FIMV_R2H_CMD_ERR_RET		32
 
+/* Dummy definition for MFCv6 compatibilty */
+#define S5P_FIMV_CODEC_H264_MVC_DEC		-1
+#define S5P_FIMV_R2H_CMD_FIELD_DONE_RET		-1
+#define S5P_FIMV_MFC_RESET			-1
+#define S5P_FIMV_RISC_ON			-1
+#define S5P_FIMV_RISC_BASE_ADDRESS		-1
+#define S5P_FIMV_CODEC_VP8_DEC			-1
+#define S5P_FIMV_REG_CLEAR_BEGIN		0
+#define S5P_FIMV_REG_CLEAR_COUNT		0
+
 /* Error handling defines */
 #define S5P_FIMV_ERR_WARNINGS_START		145
 #define S5P_FIMV_ERR_DEC_MASK			0xFFFF
@@ -409,5 +421,22 @@
 #define S5P_FIMV_SHARED_EXTENDED_SAR		0x0078
 #define S5P_FIMV_SHARED_H264_I_PERIOD		0x009C
 #define S5P_FIMV_SHARED_RC_CONTROL_CONFIG	0x00A0
+#define S5P_FIMV_SHARED_DISP_FRAME_TYPE_SHIFT	2
+
+#define S5P_FIMV_SHARED_FRAME_PACK_SEI_AVAIL    0x16C
+#define S5P_FIMV_SHARED_FRAME_PACK_ARRGMENT_ID  0x170
+#define S5P_FIMV_SHARED_FRAME_PACK_SEI_INFO     0x174
+#define S5P_FIMV_SHARED_FRAME_PACK_GRID_POS     0x178
+
+/* SEI related information */
+#define S5P_FIMV_FRAME_PACK_SEI_AVAIL           S5P_FIMV_SHARED_FRAME_PACK_SEI_AVAIL
+#define S5P_FIMV_FRAME_PACK_ARRGMENT_ID         S5P_FIMV_SHARED_FRAME_PACK_ARRGMENT_ID
+#define S5P_FIMV_FRAME_PACK_SEI_INFO            S5P_FIMV_SHARED_FRAME_PACK_SEI_INFO
+#define S5P_FIMV_FRAME_PACK_GRID_POS            S5P_FIMV_SHARED_FRAME_PACK_GRID_POS
+
+#define S5P_FIMV_SHARED_SET_E_FRAME_TAG		S5P_FIMV_SHARED_SET_FRAME_TAG
+#define S5P_FIMV_SHARED_GET_E_FRAME_TAG		S5P_FIMV_SHARED_GET_FRAME_TAG_TOP
+#define S5P_FIMV_ENCODED_LUMA_ADDR		S5P_FIMV_ENCODED_Y_ADDR
+#define S5P_FIMV_ENCODED_CHROMA_ADDR		S5P_FIMV_ENCODED_C_ADDR
 
 #endif /* _REGS_FIMV_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 83fe461..2c4b970 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -21,15 +21,13 @@
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
+#include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
 
 #define S5P_MFC_NAME		"s5p-mfc"
 #define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
@@ -179,8 +177,8 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 		ctx->dst_queue_cnt--;
 		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
 
-		if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
-			s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+		if (s5p_mfc_read_info(ctx, PIC_TIME_TOP) ==
+			s5p_mfc_read_info(ctx, PIC_TIME_BOT))
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 		else
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
@@ -195,7 +193,7 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf, *src_buf;
 	size_t dec_y_addr = s5p_mfc_get_dec_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	unsigned int frame_type = s5p_mfc_get_dec_frame_type();
 
 	/* Copy timestamp / timecode from decoded src to dst and set
 	   appropraite flags */
@@ -232,7 +230,7 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf;
 	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	unsigned int frame_type = s5p_mfc_get_disp_frame_type();
 	unsigned int index;
 
 	/* If frame is same as previous then skip and do not dequeue */
@@ -251,8 +249,8 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
 			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
-			if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
-				s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+			if (s5p_mfc_read_info(ctx, PIC_TIME_TOP) ==
+				s5p_mfc_read_info(ctx, PIC_TIME_BOT))
 				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 			else
 				dst_buf->b->v4l2_buf.field =
@@ -285,12 +283,13 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 
 	dst_frame_status = s5p_mfc_get_dspl_status()
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
-	res_change = s5p_mfc_get_dspl_status()
-				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
+	res_change = (s5p_mfc_get_dspl_status()
+				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK)
+				>> S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT;
 	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
 	if (ctx->state == MFCINST_RES_CHANGE_INIT)
 		ctx->state = MFCINST_RES_CHANGE_FLUSH;
-	if (res_change) {
+	if (res_change && res_change != 3) {
 		ctx->state = MFCINST_RES_CHANGE_INIT;
 		s5p_mfc_clear_int_flags(dev);
 		wake_up_ctx(ctx, reason, err);
@@ -300,8 +299,8 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		s5p_mfc_try_run(dev);
 		return;
 	}
-	if (ctx->dpb_flush_flag)
-		ctx->dpb_flush_flag = 0;
+	if (ctx->dpb_flush)
+		ctx->dpb_flush = 0;
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	/* All frames remaining in the buffer have been extracted  */
@@ -333,7 +332,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 								list);
 		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
 		if (ctx->codec_mode != S5P_FIMV_CODEC_H264_DEC &&
-			s5p_mfc_get_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
+			s5p_mfc_get_dec_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
 					&& ctx->consumed_stream + STUFF_BYTE <
 					src_buf->b->v4l2_planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
@@ -427,7 +426,6 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				 unsigned int reason, unsigned int err)
 {
 	struct s5p_mfc_dev *dev;
-	unsigned int guard_width, guard_height;
 
 	if (ctx == 0)
 		return;
@@ -439,45 +437,28 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		ctx->img_width = s5p_mfc_get_img_width();
 		ctx->img_height = s5p_mfc_get_img_height();
 
-		ctx->buf_width = ALIGN(ctx->img_width,
-						S5P_FIMV_NV12MT_HALIGN);
-		ctx->buf_height = ALIGN(ctx->img_height,
-						S5P_FIMV_NV12MT_VALIGN);
-		mfc_debug(2, "SEQ Done: Movie dimensions %dx%d, "
-			"buffer dimensions: %dx%d\n", ctx->img_width,
-				ctx->img_height, ctx->buf_width,
-						ctx->buf_height);
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
-			ctx->luma_size = ALIGN(ctx->buf_width *
-				ctx->buf_height, S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->chroma_size = ALIGN(ctx->buf_width *
-					 ALIGN((ctx->img_height >> 1),
-					       S5P_FIMV_NV12MT_VALIGN),
-					       S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->mv_size = ALIGN(ctx->buf_width *
-					ALIGN((ctx->buf_height >> 2),
-					S5P_FIMV_NV12MT_VALIGN),
-					S5P_FIMV_DEC_BUF_ALIGN);
-		} else {
-			guard_width = ALIGN(ctx->img_width + 24,
-					S5P_FIMV_NV12MT_HALIGN);
-			guard_height = ALIGN(ctx->img_height + 16,
-						S5P_FIMV_NV12MT_VALIGN);
-			ctx->luma_size = ALIGN(guard_width *
-				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
-			guard_width = ALIGN(ctx->img_width + 16,
-						S5P_FIMV_NV12MT_HALIGN);
-			guard_height = ALIGN((ctx->img_height >> 1) + 4,
-						S5P_FIMV_NV12MT_VALIGN);
-			ctx->chroma_size = ALIGN(guard_width *
-				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->mv_size = 0;
-		}
+		s5p_mfc_dec_calc_dpb_size(ctx);
+
 		ctx->dpb_count = s5p_mfc_get_dpb_count();
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
 			ctx->state = MFCINST_HEAD_PARSED;
+
+		if ((ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC) &&
+				!list_empty(&ctx->src_queue)) {
+			struct s5p_mfc_buf *src_buf;
+			src_buf = list_entry(ctx->src_queue.next,
+					struct s5p_mfc_buf, list);
+			mfc_debug(2, "Check consumed size of header. ");
+			mfc_debug(2, "source : %d, consumed : %d\n",
+					s5p_mfc_get_consumed_stream(),
+					src_buf->b->v4l2_planes[0].bytesused);
+			if (s5p_mfc_get_consumed_stream() <
+					src_buf->b->v4l2_planes[0].bytesused)
+				ctx->remained = 1;
+		}
 	}
 	s5p_mfc_clear_int_flags(dev);
 	clear_work_bit(ctx);
@@ -508,7 +489,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	spin_unlock(&dev->condlock);
 	if (err == 0) {
 		ctx->state = MFCINST_RUNNING;
-		if (!ctx->dpb_flush_flag) {
+		if (!ctx->dpb_flush && !ctx->remained) {
 			spin_lock_irqsave(&dev->irqlock, flags);
 			if (!list_empty(&ctx->src_queue)) {
 				src_buf = list_entry(ctx->src_queue.next,
@@ -520,7 +501,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 			}
 			spin_unlock_irqrestore(&dev->irqlock, flags);
 		} else {
-			ctx->dpb_flush_flag = 0;
+			ctx->dpb_flush = 0;
 		}
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
@@ -567,6 +548,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		break;
 
 	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
+	case S5P_FIMV_R2H_CMD_FIELD_DONE_RET:
 	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
 		if (ctx->c_ops->post_frame_start) {
 			if (ctx->c_ops->post_frame_start(ctx))
@@ -1094,6 +1076,9 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->watchdog_timer.data = (unsigned long)dev;
 	dev->watchdog_timer.function = s5p_mfc_watchdog;
 
+	dev->variant = (struct s5p_mfc_variant *)
+		platform_get_device_id(pdev)->driver_data;
+
 	pr_debug("%s--\n", __func__);
 	return 0;
 
@@ -1234,9 +1219,73 @@ static const struct dev_pm_ops s5p_mfc_pm_ops = {
 			   NULL)
 };
 
+struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
+	.h264_ctx	= 0x96000,
+	.non_h264_ctx	= 0x2800,
+	.dsc		= 0x20000,
+	.shm		= 0x1000,
+};
+
+struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
+	.dev_ctx	= 0x400,
+	.h264_dec_ctx	= 0x200000,	/* 1.6MB */
+	.other_dec_ctx	= 0x5000,	/*  20KB */
+	.h264_enc_ctx	= 0x19000,	/* 100KB */
+	.other_enc_ctx	= 0x2800,	/*  10KB */
+};
+
+struct s5p_mfc_buf_size buf_size_v5 = {
+	.fw	= 0x60000,
+	.cpb	= 0x400000,	/*   4MB */
+	.priv	= &mfc_buf_size_v5,
+};
+
+struct s5p_mfc_buf_size buf_size_v6 = {
+	.fw	= 0x100000,	/*   1MB */
+	.cpb	= 0x300000,	/*   3MB */
+	.priv	= &mfc_buf_size_v6,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v5 = {
+	.base = 17,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v6 = {
+	.base = 0,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v5 = {
+	.version	= 0x51,
+	.port_num	= 2,
+	.buf_size	= &buf_size_v5,
+	.buf_align	= &mfc_buf_align_v5,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v6 = {
+	.version	= 0x61,
+	.port_num	= 1,
+	.buf_size	= &buf_size_v6,
+	.buf_align	= &mfc_buf_align_v6,
+};
+
+static struct platform_device_id mfc_driver_ids[] = {
+	{
+		.name = "s5p-mfc",
+		.driver_data = (unsigned long)&mfc_drvdata_v6,
+	}, {
+		.name = "s5p-mfc-v5",
+		.driver_data = (unsigned long)&mfc_drvdata_v5,
+	}, {
+		.name = "s5p-mfc-v6",
+		.driver_data = (unsigned long)&mfc_drvdata_v6,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
 static struct platform_driver s5p_mfc_driver = {
-	.probe	= s5p_mfc_probe,
-	.remove	= __devexit_p(s5p_mfc_remove),
+	.probe		= s5p_mfc_probe,
+	.remove		= __devexit_p(s5p_mfc_remove),
+	.id_table	= mfc_driver_ids,
 	.driver	= {
 		.name	= S5P_MFC_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
index f0665ed..aab7320 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
@@ -16,7 +16,7 @@
 #include "s5p_mfc_debug.h"
 
 /* This function is used to send a command to the MFC */
-static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
+int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
 						struct s5p_mfc_cmd_args *args)
 {
 	int cur_cmd;
@@ -81,7 +81,7 @@ int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
 	h2r_args.arg[0] = ctx->codec_mode;
 	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
-	h2r_args.arg[2] = ctx->ctx_ofs;
+	h2r_args.arg[2] = ctx->ctx.ofs;
 	h2r_args.arg[3] = ctx->ctx_size;
 	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
 								&h2r_args);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
index 5ceebfe..5c9e662 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
@@ -21,6 +21,9 @@ struct s5p_mfc_cmd_args {
 	unsigned int	arg[MAX_H2R_ARG];
 };
 
+int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
+	struct s5p_mfc_cmd_args *args);
+
 int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev);
 int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev);
 int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
new file mode 100644
index 0000000..b686c4a
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -0,0 +1,129 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "s5p_mfc_common.h"
+
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_cmd.h"
+
+int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
+						struct s5p_mfc_cmd_args *args)
+{
+	mfc_debug(2, "Issue the command: %d\n", cmd);
+
+	/* Reset RISC2HOST command */
+	mfc_write(dev, 0x0, S5P_FIMV_RISC2HOST_CMD);
+
+	/* Issue the command */
+	mfc_write(dev, cmd, S5P_FIMV_HOST2RISC_CMD);
+	mfc_write(dev, 0x1, S5P_FIMV_HOST2RISC_INT);
+
+	return 0;
+}
+
+int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+	int ret;
+
+	mfc_debug_enter();
+
+	s5p_mfc_alloc_dev_context_buffer(dev);
+
+	mfc_write(dev, dev->ctx_buf.dma, S5P_FIMV_CONTEXT_MEM_ADDR);
+	mfc_write(dev, buf_size->dev_ctx, S5P_FIMV_CONTEXT_MEM_SIZE);
+
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SYS_INIT, &h2r_args);
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
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
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
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_WAKEUP, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Open a new instance and get its number */
+int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	mfc_debug_enter();
+
+	mfc_debug(2, "Requested codec mode: %d\n", ctx->codec_mode);
+
+	mfc_write(dev, ctx->codec_mode, S5P_FIMV_CODEC_TYPE);
+	mfc_write(dev, ctx->ctx.dma, S5P_FIMV_CONTEXT_MEM_ADDR);
+	mfc_write(dev, ctx->ctx_size, S5P_FIMV_CONTEXT_MEM_SIZE);
+	mfc_write(dev, 0, S5P_FIMV_D_CRC_CTRL); /* no crc */
+
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE, &h2r_args);
+
+	mfc_debug_leave();
+
+	return ret;
+}
+
+/* Close instance */
+int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret = 0;
+
+	mfc_debug_enter();
+
+	if (ctx->state != MFCINST_FREE) {
+		mfc_write(dev, ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+
+		ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
+					    &h2r_args);
+	} else {
+		ret = -EINVAL;
+	}
+
+	mfc_debug_leave();
+
+	return ret;
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index 91146fa..9fd7055 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -16,7 +16,6 @@
 #ifndef S5P_MFC_COMMON_H_
 #define S5P_MFC_COMMON_H_
 
-#include "regs-mfc.h"
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ctrls.h>
@@ -34,10 +33,6 @@
 #define MFC_OFFSET_SHIFT	11
 
 #define FIRMWARE_ALIGN		0x20000		/* 128KB */
-#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264 instance */
-#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
-#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC buffer */
-#define SHARED_BUF_SIZE		0x2000		/* 8KB for shared buffer */
 
 #define DEF_CPB_SIZE		0x40000		/* 512KB */
 
@@ -174,6 +169,54 @@ struct s5p_mfc_pm {
 	struct device	*device;
 };
 
+struct s5p_mfc_buf_size_v5 {
+	unsigned int h264_ctx;
+	unsigned int non_h264_ctx;
+	unsigned int dsc;
+	unsigned int shm;
+};
+
+struct s5p_mfc_buf_size_v6 {
+	unsigned int dev_ctx;
+	unsigned int h264_dec_ctx;
+	unsigned int other_dec_ctx;
+	unsigned int h264_enc_ctx;
+	unsigned int other_enc_ctx;
+};
+
+struct s5p_mfc_buf_size {
+	unsigned int fw;
+	unsigned int cpb;
+	void *priv;
+};
+
+struct s5p_mfc_buf_align {
+	unsigned int base;
+};
+
+struct s5p_mfc_variant {
+	unsigned int version;
+	unsigned int port_num;
+	struct s5p_mfc_buf_size *buf_size;
+	struct s5p_mfc_buf_align *buf_align;
+};
+
+/**
+ * struct s5p_mfc_priv_buf - represents internal used buffer
+ * @alloc:		allocation-specific context for each buffer
+ *			(videobuf2 allocator)
+ * @ofs:		offset of each buffer, will be used for MFC
+ * @virt:		kernel virtual address, only valid when the
+ *			buffer accessed by driver
+ * @dma:		DMA address, only valid when kernel DMA API used
+ */
+struct s5p_mfc_priv_buf {
+	void		*alloc;
+	unsigned long	ofs;
+	void		*virt;
+	dma_addr_t	dma;
+};
+
 /**
  * struct s5p_mfc_dev - The struct containing driver internal parameters.
  *
@@ -210,6 +253,7 @@ struct s5p_mfc_pm {
  * @watchdog_work:	worker for the watchdog
  * @alloc_ctx:		videobuf2 allocator contexts for two memory banks
  * @enter_suspend:	flag set when entering suspend
+ * @ctx_buf:		common context memory (MFCv6)
  *
  */
 struct s5p_mfc_dev {
@@ -225,6 +269,7 @@ struct s5p_mfc_dev {
 	struct v4l2_ctrl_handler dec_ctrl_handler;
 	struct v4l2_ctrl_handler enc_ctrl_handler;
 	struct s5p_mfc_pm	pm;
+	struct s5p_mfc_variant	*variant;
 	int num_inst;
 	spinlock_t irqlock;	/* lock when operating on videobuf2 queues */
 	spinlock_t condlock;	/* lock when changing/checking if a context is
@@ -247,6 +292,8 @@ struct s5p_mfc_dev {
 	struct work_struct watchdog_work;
 	void *alloc_ctx[2];
 	unsigned long enter_suspend;
+
+	struct s5p_mfc_priv_buf ctx_buf;
 };
 
 /**
@@ -280,6 +327,23 @@ struct s5p_mfc_h264_enc_params {
 	enum v4l2_mpeg_video_h264_level level_v4l2;
 	int level;
 	u16 cpb_size;
+	int interlace;
+	u8 hier_qp;
+	enum v4l2_mpeg_video_h264_hierarchical_coding_type hier_qp_type;
+	u8 hier_qp_layer;
+	u8 hier_qp_layer_qp[7];
+	u8 sei_frame_packing;
+	u8 sei_fp_curr_frame_0;
+	enum v4l2_mpeg_video_h264_sei_fp_arrangement_type sei_fp_arrangement_type;
+
+	u8 fmo;
+	enum v4l2_mpeg_video_h264_fmo_map_type fmo_map_type;
+	u8 fmo_slice_grp;
+	enum v4l2_mpeg_video_h264_fmo_change_dir fmo_chg_dir;
+	u32 fmo_chg_rate;
+	u32 fmo_run_len[4];
+	u8 aso;
+	u32 aso_slice_order[8];
 };
 
 /**
@@ -290,8 +354,6 @@ struct s5p_mfc_mpeg4_enc_params {
 	enum v4l2_mpeg_video_mpeg4_profile profile;
 	int quarter_pixel;
 	/* Common for MPEG4, H263 */
-	u16 vop_time_res;
-	u16 vop_frm_delta;
 	u8 rc_frame_qp;
 	u8 rc_min_qp;
 	u8 rc_max_qp;
@@ -318,9 +380,11 @@ struct s5p_mfc_enc_params {
 	u8 pad_cb;
 	u8 pad_cr;
 	int rc_frame;
+	int rc_mb;
 	u32 rc_bitrate;
 	u16 rc_reaction_coeff;
 	u16 vbv_size;
+	u32 vbv_delay;
 
 	enum v4l2_mpeg_video_header_mode seq_hdr_mode;
 	enum v4l2_mpeg_mfc51_video_frame_skip_mode frame_skip_mode;
@@ -329,7 +393,6 @@ struct s5p_mfc_enc_params {
 	u8 num_b_frame;
 	u32 rc_framerate_num;
 	u32 rc_framerate_denom;
-	int interlace;
 
 	union {
 		struct s5p_mfc_h264_enc_params h264;
@@ -471,7 +534,8 @@ struct s5p_mfc_ctx {
 
 	unsigned long consumed_stream;
 
-	unsigned int dpb_flush_flag;
+	unsigned int dpb_flush;
+	unsigned int remained;
 
 	/* Buffers */
 	void *bank1_buf;
@@ -501,37 +565,42 @@ struct s5p_mfc_ctx {
 	int display_delay;
 	int display_delay_enable;
 	int after_packed_pb;
+	int sei_fp_parse;
 
 	int dpb_count;
 	int total_dpb_count;
 
 	/* Buffers */
-	void *ctx_buf;
-	size_t ctx_phys;
-	size_t ctx_ofs;
-	size_t ctx_size;
-
-	void *desc_buf;
-	size_t desc_phys;
-
-
-	void *shm_alloc;
-	void *shm;
-	size_t shm_ofs;
+	unsigned int ctx_size;
+	struct s5p_mfc_priv_buf ctx;
+	struct s5p_mfc_priv_buf dsc;
+	struct s5p_mfc_priv_buf shm;
 
 	struct s5p_mfc_enc_params enc_params;
 
 	size_t enc_dst_buf_size;
+	size_t luma_dpb_size;
+	size_t chroma_dpb_size;
+	size_t me_buffer_size;
+	size_t tmv_buffer_size;
 
 	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
 
 	struct list_head ref_queue;
 	unsigned int ref_queue_cnt;
 
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	union {
+		unsigned int mb;
+		unsigned int bits;
+	} slice_size;
+
 	struct s5p_mfc_codec_ops *c_ops;
 
 	struct v4l2_ctrl *ctrls[MFC_MAX_CTRLS];
 	struct v4l2_ctrl_handler ctrl_handler;
+
+	size_t scratch_buf_size;
 };
 
 /*
@@ -569,4 +638,18 @@ struct mfc_control {
 #define ctrl_to_ctx(__ctrl) \
 	container_of((__ctrl)->handler, struct s5p_mfc_ctx, ctrl_handler)
 
+#define HAS_PORTNUM(dev)	(dev ? (dev->variant ? \
+				(dev->variant->port_num ? 1 : 0) : 0) : 0)
+#define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
+#define IS_MFCV6(dev)		(dev->variant->version >= 0x60 ? 1 : 0)
+
+#if defined(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V5)
+#include "regs-mfc.h"
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_shm.h"
+#elif defined(CONFIG_VIDEO_SAMSUNG_S5P_MFC_V6)
+#include "regs-mfc-v6.h"
+#include "s5p_mfc_opr_v6.h"
+#endif
+
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index f2481a8..4293f6f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -15,7 +15,6 @@
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
 #include <linux/sched.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
@@ -157,46 +156,80 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 {
 	unsigned int mc_status;
 	unsigned long timeout;
+	int i;
 
 	mfc_debug_enter();
-	/* Stop procedure */
-	/*  reset RISC */
-	mfc_write(dev, 0x3f6, S5P_FIMV_SW_RESET);
-	/*  All reset except for MC */
-	mfc_write(dev, 0x3e2, S5P_FIMV_SW_RESET);
-	mdelay(10);
-
-	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
-	/* Check MC status */
-	do {
-		if (time_after(jiffies, timeout)) {
-			mfc_err("Timeout while resetting MFC\n");
-			return -EIO;
-		}
-
-		mc_status = mfc_read(dev, S5P_FIMV_MC_STATUS);
-
-	} while (mc_status & 0x3);
-
-	mfc_write(dev, 0x0, S5P_FIMV_SW_RESET);
-	mfc_write(dev, 0x3fe, S5P_FIMV_SW_RESET);
+
+	if (IS_MFCV6(dev)) {
+		/* Reset IP */
+		/*  except RISC, reset */
+		mfc_write(dev, 0xFEE, S5P_FIMV_MFC_RESET);
+		/*  reset release */
+		mfc_write(dev, 0x0, S5P_FIMV_MFC_RESET);
+
+		/* Zero Initialization of MFC registers */
+		mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
+		mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD);
+		mfc_write(dev, 0, S5P_FIMV_FW_VERSION);
+
+		for (i = 0; i < S5P_FIMV_REG_CLEAR_COUNT; i++)
+			mfc_write(dev, 0, S5P_FIMV_REG_CLEAR_BEGIN + (i*4));
+
+		/* Reset */
+		mfc_write(dev, 0, S5P_FIMV_RISC_ON);
+		mfc_write(dev, 0x1FFF, S5P_FIMV_MFC_RESET);
+		mfc_write(dev, 0, S5P_FIMV_MFC_RESET);
+	} else {
+		/* Stop procedure */
+		/*  reset RISC */
+		mfc_write(dev, 0x3f6, S5P_FIMV_SW_RESET);
+		/*  All reset except for MC */
+		mfc_write(dev, 0x3e2, S5P_FIMV_SW_RESET);
+		mdelay(10);
+
+		timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+		/* Check MC status */
+		do {
+			if (time_after(jiffies, timeout)) {
+				mfc_err("Timeout while resetting MFC\n");
+				return -EIO;
+			}
+
+			mc_status = mfc_read(dev, S5P_FIMV_MC_STATUS);
+
+		} while (mc_status & 0x3);
+
+		mfc_write(dev, 0x0, S5P_FIMV_SW_RESET);
+		mfc_write(dev, 0x3fe, S5P_FIMV_SW_RESET);
+	}
+
 	mfc_debug_leave();
 	return 0;
 }
 
 static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
-	mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
-	mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
-	mfc_debug(2, "Bank1: %08x, Bank2: %08x\n", dev->bank1, dev->bank2);
+	if (IS_MFCV6(dev)) {
+		mfc_write(dev, dev->bank1, S5P_FIMV_RISC_BASE_ADDRESS);
+		mfc_debug(2, "Base Address : %08x\n", dev->bank1);
+	} else {
+		mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
+		mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
+		mfc_debug(2, "Bank1: %08x, Bank2: %08x\n", dev->bank1, dev->bank2);
+	}
 }
 
 static inline void s5p_mfc_clear_cmds(struct s5p_mfc_dev *dev)
 {
-	mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
-	mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
-	mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD);
+	if (IS_MFCV6(dev)) {
+		/* Zero initialization should be done before RESET.
+		 * Nothing to do here. */
+	} else {
+		mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
+		mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
+		mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
+		mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD);
+	}
 }
 
 /* Initialize hardware */
@@ -224,7 +257,10 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clear_cmds(dev);
 	/* 3. Release reset signal to the RISC */
 	s5p_mfc_clean_dev_int_flags(dev);
-	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+	if (IS_MFCV6(dev))
+		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON);
+	else
+		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_FW_STATUS_RET)) {
 		mfc_err("Failed to load firmware\n");
@@ -267,6 +303,18 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 }
 
 
+/* Deinitialize hardware */
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_clock_on();
+
+	s5p_mfc_reset(dev);
+	if (IS_MFCV6(dev))
+		s5p_mfc_release_dev_context_buffer(dev);
+
+	s5p_mfc_clock_off();
+}
+
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
 {
 	int ret;
@@ -322,7 +370,10 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	/* 4. Release reset signal to the RISC */
-	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+	if (IS_MFCV6(dev))
+		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON);
+	else
+		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_WAKEUP_RET)) {
 		mfc_err("Failed to load firmware\n");
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c25ec02..a709273 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -23,85 +23,110 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
 
 static struct s5p_mfc_fmt formats[] = {
 	{
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
 		.codec_mode	= S5P_FIMV_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-	 },
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_FIMV_CODEC_H264_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
+	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "H264/MVC Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264_MVC,
+		.codec_mode	= S5P_FIMV_CODEC_H264_MVC_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_FIMV_CODEC_H263_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG1,
+		.codec_mode	= S5P_FIMV_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG1,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG2 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG2,
+		.codec_mode	= S5P_FIMV_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG2 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG2,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_FIMV_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "XviD Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_XVID,
+		.codec_mode	= S5P_FIMV_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "XviD Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_XVID,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_G,
+		.codec_mode	= S5P_FIMV_CODEC_VC1_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_G,
-		.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 RCV Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_L,
+		.codec_mode	= S5P_FIMV_CODEC_VC1RCV_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 RCV Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_L,
-		.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC8 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VP8,
+		.codec_mode	= S5P_FIMV_CODEC_VP8_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 };
 
@@ -336,21 +361,41 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 /* Try format */
 static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_err("This node supports decoding only\n");
-		return -EINVAL;
-	}
-	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt) {
-		mfc_err("Unsupported format\n");
-		return -EINVAL;
-	}
-	if (fmt->type != MFC_FMT_DEC) {
-		mfc_err("\n");
-		return -EINVAL;
+	mfc_debug(2, "Type is %d\n", f->type);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_DEC);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for destination.\n");
+			return -EINVAL;
+		}
+		if (IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		} else {
+			if (fmt->fourcc != V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
 	}
+
 	return 0;
 }
 
@@ -373,6 +418,30 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EBUSY;
 		goto out;
 	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev)) {
+			if (fmt->fourcc != V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		} else if (IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
+		ctx->dst_fmt = fmt;
+		mfc_debug_leave();
+		return ret;
+	} else if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Wrong type error for S_FMT : %d", f->type);
+		return -EINVAL;
+	}
 	fmt = find_format(f, MFC_FMT_DEC);
 	if (!fmt || fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
 		mfc_err("Unknown codec\n");
@@ -385,6 +454,12 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EINVAL;
 		goto out;
 	}
+	if (!IS_MFCV6(dev)) {
+		if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+	}
 	ctx->src_fmt = fmt;
 	ctx->codec_mode = fmt->codec_mode;
 	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
@@ -498,7 +573,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		}
 		s5p_mfc_try_run(dev);
 		s5p_mfc_wait_for_done_ctx(ctx,
-					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+					S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
 	}
 	return ret;
 }
@@ -696,10 +771,10 @@ static int vidioc_g_crop(struct file *file, void *priv,
 			return -EINVAL;
 		}
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
-		left = s5p_mfc_read_shm(ctx, CROP_INFO_H);
+		left = s5p_mfc_read_info(ctx, CROP_INFO_H);
 		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
 		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
-		top = s5p_mfc_read_shm(ctx, CROP_INFO_V);
+		top = s5p_mfc_read_info(ctx, CROP_INFO_V);
 		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
 		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
 		cr->c.left = left;
@@ -750,6 +825,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	/* Video output for decoding (source)
 	 * this can be set after getting an instance */
@@ -785,7 +861,11 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+
+		if (IS_MFCV6(dev))
+			allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		else
+			allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
 		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
@@ -905,7 +985,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
-		ctx->dpb_flush_flag = 1;
+		ctx->dpb_flush = 1;
 		ctx->dec_dst_flag = 0;
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index dff9dc7..a78f40a 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -24,48 +24,60 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr.h"
 
 static struct s5p_mfc_fmt formats[] = {
 	{
-		.name = "4:2:0 2 Planes 64x32 Tiles",
-		.fourcc = V4L2_PIX_FMT_NV12MT,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_FIMV_CODEC_H264_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_FIMV_CODEC_MPEG4_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_FIMV_CODEC_H263_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
 	},
 };
 
@@ -95,7 +107,7 @@ static struct mfc_control controls[] = {
 		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
 		.type = V4L2_CTRL_TYPE_MENU,
 		.minimum = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE,
-		.maximum = V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES,
+		.maximum = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS,
 		.default_value = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE,
 		.menu_skip_mask = 0,
 	},
@@ -108,7 +120,7 @@ static struct mfc_control controls[] = {
 		.default_value = 1,
 	},
 	{
-		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES,
+		.id = V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 1900,
 		.maximum = (1 << 30) - 1,
@@ -184,6 +196,14 @@ static struct mfc_control controls[] = {
 		.default_value = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_VBV_DELAY,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
 		.id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 0,
@@ -545,6 +565,129 @@ static struct mfc_control controls[] = {
 		.step = 1,
 		.default_value = 0,
 	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE,
+		.maximum = V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL,
+		.default_value = V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE,
+		.menu_skip_mask = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES,
+		.maximum = V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN,
+		.default_value = V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES,
+		.menu_skip_mask = (
+				(1 << V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER) |
+				(1 << V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT)
+				),
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 1,
+		.maximum = 4,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT,
+		.maximum = V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_ASO,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B,
+		.maximum = V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P,
+		.step = 1,
+		.default_value = V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 7,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = INT_MIN,
+		.maximum = INT_MAX,
+		.step = 1,
+		.default_value = 0,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -647,13 +790,22 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
-	ctx->state = MFCINST_RUNNING;
-	if (s5p_mfc_ctx_ready(ctx)) {
-		spin_lock_irqsave(&dev->condlock, flags);
-		set_bit(ctx->num, &dev->ctx_work_bits);
-		spin_unlock_irqrestore(&dev->condlock, flags);
+
+	if (IS_MFCV6(dev)) {
+		ctx->state = MFCINST_HEAD_PARSED; /* for INIT_BUFFER cmd */
+	} else {
+		ctx->state = MFCINST_RUNNING;
+		if (s5p_mfc_ctx_ready(ctx)) {
+			spin_lock_irqsave(&dev->condlock, flags);
+			set_bit(ctx->num, &dev->ctx_work_bits);
+			spin_unlock_irqrestore(&dev->condlock, flags);
+		}
+		s5p_mfc_try_run(dev);
 	}
-	s5p_mfc_try_run(dev);
+
+	if (IS_MFCV6(dev))
+		ctx->dpb_count = s5p_mfc_get_enc_dpb_count();
+
 	return 0;
 }
 
@@ -965,6 +1117,19 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to set output format\n");
 			return -EINVAL;
 		}
+
+		if (!IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		} else if (IS_MFCV6(dev)) {
+			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+				mfc_err("Not supported format.\n");
+				return -EINVAL;
+			}
+		}
+
 		if (fmt->num_planes != pix_fmt_mp->num_planes) {
 			mfc_err("failed to set output format\n");
 			ret = -EINVAL;
@@ -977,45 +1142,13 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		mfc_debug(2, "fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
 			pix_fmt_mp->width, pix_fmt_mp->height,
 			ctx->img_width, ctx->img_height);
-		if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12M_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN(ctx->img_height,
-				S5P_FIMV_NV12M_LVALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12M_CVALIGN);
-
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12M_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12M_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-
-		} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12MT_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN)	* ALIGN(ctx->img_height,
-				S5P_FIMV_NV12MT_VALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12MT_VALIGN);
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-		}
+
+		s5p_mfc_enc_calc_src_size(ctx);
+		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
+		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
+		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
+		pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
+
 		ctx->src_bufs_cnt = 0;
 		ctx->output_state = QUEUE_FREE;
 	} else {
@@ -1030,6 +1163,7 @@ out:
 static int vidioc_reqbufs(struct file *file, void *priv,
 					  struct v4l2_requestbuffers *reqbufs)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
@@ -1049,12 +1183,15 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return ret;
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
-		ret = s5p_mfc_alloc_codec_buffers(ctx);
-		if (ret) {
-			mfc_err("Failed to allocate encoding buffers\n");
-			reqbufs->count = 0;
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			return -ENOMEM;
+
+		if (!IS_MFCV6(dev)) {
+			ret = s5p_mfc_alloc_codec_buffers(ctx);
+			if (ret) {
+				mfc_err("Failed to allocate encoding buffers\n");
+				reqbufs->count = 0;
+				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+				return -ENOMEM;
+			}
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->output_state != QUEUE_FREE) {
@@ -1243,7 +1380,7 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
 		p->slice_mb = ctrl->val;
 		break;
-	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS:
 		p->slice_bit = ctrl->val * 8;
 		break;
 	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
@@ -1301,6 +1438,13 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 			p->codec.h264.profile =
 				S5P_FIMV_ENC_PROFILE_H264_BASELINE;
 			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+			if (IS_MFCV6(dev))
+				p->codec.h264.profile =
+					S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE;
+			else
+				ret = -EINVAL;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -1424,6 +1568,54 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 		p->codec.mpeg4.quarter_pixel = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING:
+		p->codec.h264.sei_frame_packing = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0:
+		p->codec.h264.sei_fp_curr_frame_0 = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:
+		p->codec.h264.sei_fp_arrangement_type = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO:
+		p->codec.h264.fmo = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:
+		p->codec.h264.fmo_map_type = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP:
+		p->codec.h264.fmo_slice_grp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION:
+		p->codec.h264.fmo_chg_dir = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE:
+		p->codec.h264.fmo_chg_rate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH:
+		p->codec.h264.fmo_run_len[ctrl->val >> 30]
+			= ctrl->val & 0x3FFFFFFF;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_ASO:
+		p->codec.h264.aso = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER:
+		p->codec.h264.aso_slice_order[(ctrl->val >> 18) & 0x7]
+			|= (ctrl->val & 0xFF) << (((ctrl->val >> 16) & 0x3) << 3);
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING:
+		p->codec.h264.hier_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE:
+		p->codec.h264.hier_qp_type = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:
+		p->codec.h264.hier_qp_layer = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
+		p->codec.h264.hier_qp_layer_qp[(ctrl->val >> 16) & 0x7]
+			= ctrl->val & 0xFF;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
@@ -1518,6 +1710,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			unsigned int psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	if (ctx->state != MFCINST_GOT_INST) {
 		mfc_err("inavlid state: %d\n", ctx->state);
@@ -1546,8 +1739,13 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
-		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		if (IS_MFCV6(dev)) {
+			allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[1] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		} else {
+			allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+			allocators[1] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		}
 	} else {
 		mfc_err("inavlid queue type: %d\n", vq->type);
 		return -EINVAL;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
index 8f2f8bf..dfdc558 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index e08b21c..6cb010a 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -12,15 +12,12 @@
  * published by the Free Software Foundation.
  */
 
-#include "regs-mfc.h"
-#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
 #include <asm/cacheflush.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -37,39 +34,31 @@
 /* Allocate temporary buffers for decoding */
 int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
 {
-	void *desc_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	ctx->desc_buf = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
-	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
-		ctx->desc_buf = 0;
+	ctx->dsc.alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
+			buf_size->dsc);
+	if (IS_ERR_VALUE((int)ctx->dsc.alloc)) {
+		ctx->dsc.alloc = NULL;
 		mfc_err("Allocating DESC buffer failed\n");
 		return -ENOMEM;
 	}
-	ctx->desc_phys = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->desc_buf);
-	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
-	if (desc_virt == NULL) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = 0;
-		mfc_err("Remapping DESC buffer failed\n");
-		return -ENOMEM;
-	}
-	memset(desc_virt, 0, DESC_BUF_SIZE);
-	wmb();
+	ctx->dsc.dma = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->dsc.alloc);
+	BUG_ON(ctx->dsc.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+
 	return 0;
 }
 
 /* Release temporary buffers for decoding */
 void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->desc_phys) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = 0;
+	if (ctx->dsc.dma) {
+		vb2_dma_contig_memops.put(ctx->dsc.alloc);
+		ctx->dsc.alloc = NULL;
+		ctx->dsc.dma = 0;
 	}
 }
 
@@ -231,41 +220,43 @@ void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
 /* Allocate memory for instance data buffer */
 int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 {
-	void *context_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
 	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
 		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
-		ctx->ctx_size = MFC_H264_CTX_BUF_SIZE;
+		ctx->ctx_size = buf_size->h264_ctx;
 	else
-		ctx->ctx_size = MFC_CTX_BUF_SIZE;
-	ctx->ctx_buf = vb2_dma_contig_memops.alloc(
+		ctx->ctx_size = buf_size->non_h264_ctx;
+	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
 		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_size);
-	if (IS_ERR(ctx->ctx_buf)) {
+	if (IS_ERR(ctx->ctx.alloc)) {
 		mfc_err("Allocating context buffer failed\n");
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		ctx->ctx.alloc = NULL;
 		return -ENOMEM;
 	}
-	ctx->ctx_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_buf);
-	BUG_ON(ctx->ctx_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->ctx_ofs = OFFSETA(ctx->ctx_phys);
-	context_virt = vb2_dma_contig_memops.vaddr(ctx->ctx_buf);
-	if (context_virt == NULL) {
+	ctx->ctx.dma = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
+	BUG_ON(ctx->ctx.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
+	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
+	if (!ctx->ctx.virt) {
 		mfc_err("Remapping instance buffer failed\n");
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.ofs = 0;
+		ctx->ctx.dma = 0;
 		return -ENOMEM;
 	}
 	/* Zero content of the allocated memory */
-	memset(context_virt, 0, ctx->ctx_size);
+	memset(ctx->ctx.virt, 0, ctx->ctx_size);
 	wmb();
 	if (s5p_mfc_init_shm(ctx) < 0) {
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.ofs = 0;
+		ctx->ctx.virt = NULL;
+		ctx->ctx.dma = 0;
 		return -ENOMEM;
 	}
 	return 0;
@@ -274,15 +265,91 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->ctx_buf) {
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = 0;
+	if (ctx->ctx.alloc) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.ofs = 0;
+		ctx->ctx.virt = NULL;
+		ctx->ctx.dma = 0;
+	}
+	if (ctx->shm.alloc) {
+		vb2_dma_contig_memops.put(ctx->shm.alloc);
+		ctx->shm.alloc = NULL;
+		ctx->shm.ofs = 0;
+		ctx->shm.virt = NULL;
+	}
+}
+
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+
+	return 0;
+}
+
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+}
+
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int guard_width, guard_height;
+
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+	mfc_debug(2, "SEQ Done: Movie dimensions %dx%d, "
+			"buffer dimensions: %dx%d\n", ctx->img_width,
+			ctx->img_height, ctx->buf_width, ctx->buf_height);
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+		ctx->luma_size = ALIGN(ctx->buf_width * ctx->buf_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->chroma_size = ALIGN(ctx->buf_width *
+				ALIGN((ctx->img_height >> 1),
+					S5P_FIMV_NV12MT_VALIGN),
+				S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->mv_size = ALIGN(ctx->buf_width *
+				ALIGN((ctx->buf_height >> 2),
+					S5P_FIMV_NV12MT_VALIGN),
+				S5P_FIMV_DEC_BUF_ALIGN);
+	} else {
+		guard_width = ALIGN(ctx->img_width + 24, S5P_FIMV_NV12MT_HALIGN);
+		guard_height = ALIGN(ctx->img_height + 16, S5P_FIMV_NV12MT_VALIGN);
+		ctx->luma_size = ALIGN(guard_width * guard_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+
+		guard_width = ALIGN(ctx->img_width + 16, S5P_FIMV_NV12MT_HALIGN);
+		guard_height = ALIGN((ctx->img_height >> 1) + 4, S5P_FIMV_NV12MT_VALIGN);
+		ctx->chroma_size = ALIGN(guard_width * guard_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+
+		ctx->mv_size = 0;
 	}
-	if (ctx->shm_alloc) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_alloc = 0;
-		ctx->shm = 0;
+}
+
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN);
+
+		ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12M_LVALIGN);
+		ctx->chroma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12M_CVALIGN);
+
+		ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12M_SALIGN);
+		ctx->chroma_size = ALIGN(ctx->chroma_size, S5P_FIMV_NV12M_SALIGN);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+
+		ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+		ctx->chroma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
+
+		ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12MT_SALIGN);
+		ctx->chroma_size = ALIGN(ctx->chroma_size, S5P_FIMV_NV12MT_SALIGN);
 	}
 }
 
@@ -290,16 +357,17 @@ void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
 void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	mfc_write(dev, OFFSETA(ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
-	mfc_write(dev, DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+	mfc_write(dev, OFFSETA(ctx->dsc.dma), S5P_FIMV_SI_CH0_DESC_ADR);
+	mfc_write(dev, buf_size->dsc, S5P_FIMV_SI_CH0_DESC_SIZE);
 }
 
 /* Set registers for shared buffer */
 void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
+	mfc_write(dev, ctx->shm.ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
 }
 
 /* Set registers for decoding stream buffer */
@@ -311,7 +379,7 @@ int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
 	mfc_write(dev, OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
 	mfc_write(dev, ctx->dec_src_buf_size, S5P_FIMV_SI_CH0_CPB_SIZE);
 	mfc_write(dev, buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
-	s5p_mfc_write_shm(ctx, start_num_byte, START_BYTE_NUM);
+	s5p_mfc_write_info(ctx, start_num_byte, START_BYTE_NUM);
 	return 0;
 }
 
@@ -438,10 +506,10 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "Not enough memory has been allocated\n");
 		return -ENOMEM;
 	}
-	s5p_mfc_write_shm(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
-	s5p_mfc_write_shm(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
+	s5p_mfc_write_info(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
+	s5p_mfc_write_info(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
 	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
-		s5p_mfc_write_shm(ctx, frame_size_mv, ALLOC_MV_SIZE);
+		s5p_mfc_write_info(ctx, frame_size_mv, ALLOC_MV_SIZE);
 	mfc_write(dev, ((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK)
 					<< S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
 						S5P_FIMV_SI_CH0_INST_ID);
@@ -636,9 +704,9 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	/* multi-slice control */
 	/* multi-slice MB number or bit size */
 	mfc_write(dev, p->slice_mode, S5P_FIMV_ENC_MSLICE_CTRL);
-	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
+	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB) {
 		mfc_write(dev, p->slice_mb, S5P_FIMV_ENC_MSLICE_MB);
-	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
+	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS) {
 		mfc_write(dev, p->slice_bit, S5P_FIMV_ENC_MSLICE_BIT);
 	} else {
 		mfc_write(dev, 0, S5P_FIMV_ENC_MSLICE_MB);
@@ -685,16 +753,16 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	/* reaction coefficient */
 	if (p->rc_frame)
 		mfc_write(dev, p->rc_reaction_coeff, S5P_FIMV_ENC_RC_RPARA);
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	shm = s5p_mfc_read_info(ctx, EXT_ENC_CONTROL);
 	/* seq header ctrl */
 	shm &= ~(0x1 << 3);
 	shm |= (p->seq_hdr_mode << 3);
 	/* frame skip mode */
 	shm &= ~(0x3 << 1);
 	shm |= (p->frame_skip_mode << 1);
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+	s5p_mfc_write_info(ctx, shm, EXT_ENC_CONTROL);
 	/* fixed target bit */
-	s5p_mfc_write_shm(ctx, p->fixed_target_bit, RC_CONTROL_CONFIG);
+	s5p_mfc_write_info(ctx, p->fixed_target_bit, RC_CONTROL_CONFIG);
 	return 0;
 }
 
@@ -723,9 +791,9 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= p_264->profile;
 	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
 	/* interlace  */
-	mfc_write(dev, p->interlace, S5P_FIMV_ENC_PIC_STRUCT);
+	mfc_write(dev, p_264->interlace, S5P_FIMV_ENC_PIC_STRUCT);
 	/* height */
-	if (p->interlace)
+	if (p_264->interlace)
 		mfc_write(dev, ctx->img_height >> 1, S5P_FIMV_ENC_VSIZE_PX);
 	/* loopfilter ctrl */
 	mfc_write(dev, p_264->loop_filter_mode, S5P_FIMV_ENC_LF_CTRL);
@@ -767,7 +835,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
 	/* macroblock level rate control */
 	reg &= ~(0x1 << 8);
-	reg |= (p_264->rc_mb << 8);
+	reg |= (p->rc_mb << 8);
 	/* frame QP */
 	reg &= ~(0x3F);
 	reg |= p_264->rc_frame_qp;
@@ -788,7 +856,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= p_264->rc_min_qp;
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
 	/* macroblock adaptive scaling features */
-	if (p_264->rc_mb) {
+	if (p->rc_mb) {
 		reg = mfc_read(dev, S5P_FIMV_ENC_RC_MB_CTRL);
 		/* dark region */
 		reg &= ~(0x1 << 3);
@@ -804,37 +872,36 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg |= p_264->rc_mb_activity;
 		mfc_write(dev, reg, S5P_FIMV_ENC_RC_MB_CTRL);
 	}
-	if (!p->rc_frame &&
-	    !p_264->rc_mb) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+	if (!p->rc_frame && !p->rc_mb) {
+		shm = s5p_mfc_read_info(ctx, P_B_FRAME_QP);
 		shm &= ~(0xFFF);
 		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
 		shm |= (p_264->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+		s5p_mfc_write_info(ctx, shm, P_B_FRAME_QP);
 	}
 	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	shm = s5p_mfc_read_info(ctx, EXT_ENC_CONTROL);
 	/* AR VUI control */
 	shm &= ~(0x1 << 15);
 	shm |= (p_264->vui_sar << 1);
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+	s5p_mfc_write_info(ctx, shm, EXT_ENC_CONTROL);
 	if (p_264->vui_sar) {
 		/* aspect ration IDC */
-		shm = s5p_mfc_read_shm(ctx, SAMPLE_ASPECT_RATIO_IDC);
+		shm = s5p_mfc_read_info(ctx, SAMPLE_ASPECT_RATIO_IDC);
 		shm &= ~(0xFF);
 		shm |= p_264->vui_sar_idc;
-		s5p_mfc_write_shm(ctx, shm, SAMPLE_ASPECT_RATIO_IDC);
+		s5p_mfc_write_info(ctx, shm, SAMPLE_ASPECT_RATIO_IDC);
 		if (p_264->vui_sar_idc == 0xFF) {
 			/* sample  AR info */
-			shm = s5p_mfc_read_shm(ctx, EXTENDED_SAR);
+			shm = s5p_mfc_read_info(ctx, EXTENDED_SAR);
 			shm &= ~(0xFFFFFFFF);
 			shm |= p_264->vui_ext_sar_width << 16;
 			shm |= p_264->vui_ext_sar_height;
-			s5p_mfc_write_shm(ctx, shm, EXTENDED_SAR);
+			s5p_mfc_write_info(ctx, shm, EXTENDED_SAR);
 		}
 	}
 	/* intra picture period for H.264 */
-	shm = s5p_mfc_read_shm(ctx, H264_I_PERIOD);
+	shm = s5p_mfc_read_info(ctx, H264_I_PERIOD);
 	/* control */
 	shm &= ~(0x1 << 16);
 	shm |= (p_264->open_gop << 16);
@@ -843,16 +910,16 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		shm &= ~(0xFFFF);
 		shm |= p_264->open_gop_size;
 	}
-	s5p_mfc_write_shm(ctx, shm, H264_I_PERIOD);
+	s5p_mfc_write_info(ctx, shm, H264_I_PERIOD);
 	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	shm = s5p_mfc_read_info(ctx, EXT_ENC_CONTROL);
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
 		shm &= ~(0xFFFF << 16);
 		shm |= (p_264->cpb_size << 16);
 	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+	s5p_mfc_write_info(ctx, shm, EXT_ENC_CONTROL);
 	return 0;
 }
 
@@ -885,11 +952,11 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	mfc_write(dev, p_mpeg4->quarter_pixel, S5P_FIMV_ENC_MPEG4_QUART_PXL);
 	/* qp */
 	if (!p->rc_frame) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+		shm = s5p_mfc_read_info(ctx, P_B_FRAME_QP);
 		shm &= ~(0xFFF);
 		shm |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 6);
 		shm |= (p_mpeg4->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+		s5p_mfc_write_info(ctx, shm, P_B_FRAME_QP);
 	}
 	/* frame rate */
 	if (p->rc_frame) {
@@ -898,12 +965,12 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 						p->rc_framerate_denom;
 			mfc_write(dev, framerate,
 				S5P_FIMV_ENC_RC_FRAME_RATE);
-			shm = s5p_mfc_read_shm(ctx, RC_VOP_TIMING);
+			shm = s5p_mfc_read_info(ctx, RC_VOP_TIMING);
 			shm &= ~(0xFFFFFFFF);
 			shm |= (1 << 31);
 			shm |= ((p->rc_framerate_num & 0x7FFF) << 16);
 			shm |= (p->rc_framerate_denom & 0xFFFF);
-			s5p_mfc_write_shm(ctx, shm, RC_VOP_TIMING);
+			s5p_mfc_write_info(ctx, shm, RC_VOP_TIMING);
 		}
 	} else {
 		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
@@ -924,14 +991,14 @@ static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
 	reg |= p_mpeg4->rc_min_qp;
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
 	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	shm = s5p_mfc_read_info(ctx, EXT_ENC_CONTROL);
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
 		shm &= ~(0xFFFF << 16);
 		shm |= (p->vbv_size << 16);
 	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+	s5p_mfc_write_info(ctx, shm, EXT_ENC_CONTROL);
 	return 0;
 }
 
@@ -946,10 +1013,10 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	s5p_mfc_set_enc_params(ctx);
 	/* qp */
 	if (!p->rc_frame) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
+		shm = s5p_mfc_read_info(ctx, P_B_FRAME_QP);
 		shm &= ~(0xFFF);
 		shm |= (p_h263->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
+		s5p_mfc_write_info(ctx, shm, P_B_FRAME_QP);
 	}
 	/* frame rate */
 	if (p->rc_frame && p->rc_framerate_denom)
@@ -973,14 +1040,14 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 	reg |= p_h263->rc_min_qp;
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
 	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
+	shm = s5p_mfc_read_info(ctx, EXT_ENC_CONTROL);
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
 		shm &= ~(0xFFFF << 16);
 		shm |= (p->vbv_size << 16);
 	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
+	s5p_mfc_write_info(ctx, shm, EXT_ENC_CONTROL);
 	return 0;
 }
 
@@ -1028,7 +1095,7 @@ int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
 
 	mfc_write(dev, ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
 	s5p_mfc_set_shared_buffer(ctx);
-	s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
+	s5p_mfc_set_flush(ctx, ctx->dpb_flush);
 	/* Issue different commands to instance basing on whether it
 	 * is the last frame or not. */
 	switch (last_frame) {
@@ -1395,3 +1462,12 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
 	}
 }
 
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data, unsigned int ofs)
+{
+	s5p_mfc_write_shm(ctx, data, ofs);
+}
+
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+{
+	return s5p_mfc_read_shm(ctx, ofs);
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
index db83836..aa629e6 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -50,9 +50,18 @@ void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx);
 int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx);
 
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev);
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev);
+
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx);
+
 void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
 void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data, unsigned int ofs);
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx, unsigned int ofs);
+
 #define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
 					S5P_FIMV_SI_DISPLAY_Y_ADR) << \
 					MFC_OFFSET_SHIFT)
@@ -61,9 +70,12 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 					MFC_OFFSET_SHIFT)
 #define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
 						S5P_FIMV_SI_DISPLAY_STATUS)
-#define s5p_mfc_get_frame_type()	(readl(dev->regs_base + \
+#define s5p_mfc_get_dec_frame_type()	(readl(dev->regs_base + \
 						S5P_FIMV_DECODE_FRAME_TYPE) \
 					& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_disp_frame_type()	((s5p_mfc_read_shm(ctx, DISP_PIC_FRAME_TYPE) \
+						>> S5P_FIMV_SHARED_DISP_FRAME_TYPE_SHIFT) \
+					& S5P_FIMV_DECODE_FRAME_MASK)
 #define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
 						S5P_FIMV_SI_CONSUMED_BYTES)
 #define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
@@ -87,5 +99,11 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 						S5P_FIMV_ENC_SI_STRM_SIZE)
 #define s5p_mfc_get_enc_slice_type()	readl(dev->regs_base + \
 						S5P_FIMV_ENC_SI_SLICE_TYPE)
+#define s5p_mfc_get_enc_dpb_count()	-1
+#define s5p_mfc_get_enc_pic_count()	readl(dev->regs_base + \
+						S5P_FIMV_ENC_SI_PIC_CNT)
+#define s5p_mfc_get_sei_avail_status()	s5p_mfc_read_shm(ctx, FRAME_PACK_SEI_AVAIL)
+#define s5p_mfc_get_mvc_num_views()	-1
+#define s5p_mfc_get_mvc_view_id()	-1
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
new file mode 100644
index 0000000..fcc5a22
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
@@ -0,0 +1,1670 @@
+/*
+ * drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
+ *
+ * Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains hw related functions.
+ *
+ * Copyright (c) 2012 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#undef DEBUG
+
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/firmware.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/cacheflush.h>
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_pm.h"
+#include "s5p_mfc_debug.h"
+
+/* #define S5P_MFC_DEBUG_REGWRITE  */
+#ifdef S5P_MFC_DEBUG_REGWRITE
+#undef writel
+#define writel(v, r)								\
+	do {									\
+		printk(KERN_ERR "MFCWRITE(%p): %08x\n", r, (unsigned int)v);	\
+	__raw_writel(v, r);							\
+	} while (0)
+#endif /* S5P_MFC_DEBUG_REGWRITE */
+
+#define READL(offset)		readl(dev->regs_base + (offset))
+#define WRITEL(data, offset)	writel((data), dev->regs_base + (offset))
+#define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
+#define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
+
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+
+	return 0;
+}
+
+/* Release temproary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+}
+
+/* Allocate codec buffers */
+int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int mb_width, mb_height;
+
+	mb_width = mb_width(ctx->img_width);
+	mb_height = mb_height(ctx->img_height);
+
+	if (ctx->type == MFCINST_DECODER) {
+		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
+			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
+		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
+	} else if (ctx->type == MFCINST_ENCODER) {
+		ctx->tmv_buffer_size = 2 * ALIGN((mb_width + 1) * (mb_height + 1) * 8, 16);
+		ctx->luma_dpb_size = ALIGN((mb_width * mb_height) * 256, 256);
+		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) * 128, 256);
+		ctx->me_buffer_size = ALIGN(((((ctx->img_width+63)/64) * 16) *
+			(((ctx->img_height+63)/64) * 16)) +
+			 ((((mb_width*mb_height)+31)/32) * 16), 256);
+
+		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
+			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
+	} else {
+		return -EINVAL;
+	}
+
+	/* Codecs have different memory requirements */
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+	case S5P_FIMV_CODEC_H264_MVC_DEC:
+		ctx->scratch_buf_size = (mb_width * 128) + 65536;
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size =
+			ctx->scratch_buf_size +
+			(ctx->total_dpb_count * ctx->mv_size);
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+		/* mb_width * (mb_height * 64 + 144) + 8192 * mb_height + 41088 */
+		ctx->scratch_buf_size = mb_width * (mb_height * 64 + 144) +
+			((2048 + 15)/16 * mb_height * 64) +
+			((2048 + 15)/16 * 256 + 8320);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+	case S5P_FIMV_CODEC_VC1_DEC:
+		ctx->scratch_buf_size = 2096 * (mb_width + mb_height + 1);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_FIMV_CODEC_MPEG2_DEC:
+		ctx->bank1_size = 0;
+		ctx->bank2_size = 0;
+		break;
+	case S5P_FIMV_CODEC_H263_DEC:
+		ctx->scratch_buf_size = mb_width * 400;
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_FIMV_CODEC_VP8_DEC:
+		ctx->scratch_buf_size = mb_width * 32 + mb_height * 128 + 34816;
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_FIMV_CODEC_H264_ENC:
+		ctx->scratch_buf_size = (mb_width * 64) +
+			((mb_width + 1) * 16) + (4096 * 16);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->dpb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2_size = 0;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_ENC:
+	case S5P_FIMV_CODEC_H263_ENC:
+		ctx->scratch_buf_size = (mb_width * 16) + ((mb_width + 1) * 16);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size, 256);
+		ctx->bank1_size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->dpb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2_size = 0;
+		break;
+	default:
+		break;
+	}
+
+	/* Allocate only if memory from bank 1 is necessary */
+	if (ctx->bank1_size > 0) {
+		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
+		if (IS_ERR(ctx->bank1_buf)) {
+			ctx->bank1_buf = 0;
+			printk(KERN_ERR
+			       "Buf alloc for decoding failed (port A)\n");
+			return -ENOMEM;
+		}
+		ctx->bank1_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
+		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	}
+
+	return 0;
+}
+
+/* Release buffers allocated for codec */
+void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->bank1_buf) {
+		vb2_dma_contig_memops.put(ctx->bank1_buf);
+		ctx->bank1_buf = 0;
+		ctx->bank1_phys = 0;
+		ctx->bank1_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+
+	mfc_debug_enter();
+
+	switch (ctx->codec_mode) {
+	case S5P_FIMV_CODEC_H264_DEC:
+	case S5P_FIMV_CODEC_H264_MVC_DEC:
+		ctx->ctx_size = buf_size->h264_dec_ctx;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_FIMV_CODEC_H263_DEC:
+	case S5P_FIMV_CODEC_VC1RCV_DEC:
+	case S5P_FIMV_CODEC_VC1_DEC:
+	case S5P_FIMV_CODEC_MPEG2_DEC:
+	case S5P_FIMV_CODEC_VP8_DEC:
+		ctx->ctx_size = buf_size->other_dec_ctx;
+		break;
+	case S5P_FIMV_CODEC_H264_ENC:
+		ctx->ctx_size = buf_size->h264_enc_ctx;
+		break;
+	case S5P_FIMV_CODEC_MPEG4_ENC:
+	case S5P_FIMV_CODEC_H263_ENC:
+		ctx->ctx_size = buf_size->other_enc_ctx;
+		break;
+	default:
+		ctx->ctx_size = 0;
+		mfc_err("Codec type(%d) should be checked!\n", ctx->codec_mode);
+		break;
+	}
+
+	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_size);
+	if (IS_ERR(ctx->ctx.alloc)) {
+		mfc_err("Allocating context buffer failed.\n");
+		return PTR_ERR(ctx->ctx.alloc);
+	}
+
+	ctx->ctx.dma = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
+
+	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
+	if (!ctx->ctx.virt) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.dma = 0;
+		ctx->ctx.virt = NULL;
+
+		mfc_err("Remapping context buffer failed.\n");
+		return -ENOMEM;
+	}
+
+	memset(ctx->ctx.virt, 0, ctx->ctx_size);
+	wmb();
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
+
+	if (ctx->ctx.alloc) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.dma = 0;
+		ctx->ctx.virt = NULL;
+	}
+
+	mfc_debug_leave();
+}
+
+/* Allocate context buffers for SYS_INIT */
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+
+	mfc_debug_enter();
+
+	dev->ctx_buf.alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], buf_size->dev_ctx);
+	if (IS_ERR(dev->ctx_buf.alloc)) {
+		mfc_err("Allocating DESC buffer failed.\n");
+		return PTR_ERR(dev->ctx_buf.alloc);
+	}
+
+	dev->ctx_buf.dma = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], dev->ctx_buf.alloc);
+
+	dev->ctx_buf.virt = vb2_dma_contig_memops.vaddr(dev->ctx_buf.alloc);
+	if (!dev->ctx_buf.virt) {
+		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
+		dev->ctx_buf.alloc = NULL;
+		dev->ctx_buf.dma = 0;
+
+		mfc_err("Remapping DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+
+	memset(dev->ctx_buf.virt, 0, buf_size->dev_ctx);
+	wmb();
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Release context buffers for SYS_INIT */
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev)
+{
+	if (dev->ctx_buf.alloc) {
+		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
+		dev->ctx_buf.alloc = NULL;
+		dev->ctx_buf.dma = 0;
+		dev->ctx_buf.virt = NULL;
+	}
+}
+
+static int calc_plane(int width, int height)
+{
+	int mbX, mbY;
+
+	mbX = (width + 15)/16;
+	mbY = (height + 15)/16;
+
+	if (width * height < 2048 * 1024)
+		mbY = (mbY + 1) / 2 * 2;
+
+	return (mbX * 16) * (mbY * 16);
+}
+
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx)
+{
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+	mfc_debug(2, "SEQ Done: Movie dimensions %dx%d, "
+			"buffer dimensions: %dx%d\n", ctx->img_width,
+			ctx->img_height, ctx->buf_width, ctx->buf_height);
+
+	ctx->luma_size = calc_plane(ctx->img_width, ctx->img_height);
+	ctx->chroma_size = calc_plane(ctx->img_width, (ctx->img_height >> 1));
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC) {
+		ctx->mv_size = s5p_mfc_dec_mv_size(ctx->img_width,
+				ctx->img_height);
+		ctx->mv_size = ALIGN(ctx->mv_size, 16);
+	} else {
+		ctx->mv_size = 0;
+	}
+}
+
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int mb_width, mb_height;
+
+	mb_width = mb_width(ctx->img_width);
+	mb_height = mb_height(ctx->img_height);
+
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN);
+	ctx->luma_size = ALIGN((mb_width * mb_height) * 256, 256);
+	ctx->chroma_size = ALIGN((mb_width * mb_height) * 128, 256);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int strm_size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
+
+	mfc_debug_enter();
+	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x, buf_size: 0x"
+		"%08x (%d)\n",  ctx->inst_no, buf_addr, strm_size, strm_size);
+	WRITEL(strm_size, S5P_FIMV_D_STREAM_DATA_SIZE);
+	WRITEL(buf_addr, S5P_FIMV_D_CPB_BUFFER_ADDR);
+	WRITEL(buf_size->cpb, S5P_FIMV_D_CPB_BUFFER_SIZE);
+	WRITEL(start_num_byte, S5P_FIMV_D_CPB_BUFFER_OFFSET);
+
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
+	size_t buf_addr1;
+	int buf_size1;
+	int align_gap;
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+
+	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
+	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
+	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
+
+	WRITEL(ctx->total_dpb_count, S5P_FIMV_D_NUM_DPB);
+	WRITEL(ctx->luma_size, S5P_FIMV_D_LUMA_DPB_SIZE);
+	WRITEL(ctx->chroma_size, S5P_FIMV_D_CHROMA_DPB_SIZE);
+
+	WRITEL(buf_addr1, S5P_FIMV_D_SCRATCH_BUFFER_ADDR);
+	WRITEL(ctx->scratch_buf_size, S5P_FIMV_D_SCRATCH_BUFFER_SIZE);
+	buf_addr1 += ctx->scratch_buf_size;
+	buf_size1 -= ctx->scratch_buf_size;
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC)
+		WRITEL(ctx->mv_size, S5P_FIMV_D_MV_BUFFER_SIZE);
+
+	frame_size = ctx->luma_size;
+	frame_size_ch = ctx->chroma_size;
+	frame_size_mv = ctx->mv_size;
+	mfc_debug(2, "Frame size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
+								frame_size_mv);
+
+	for (i = 0; i < ctx->total_dpb_count; i++) {
+		/* Bank2 */
+		mfc_debug(2, "Luma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.luma);
+		WRITEL(ctx->dst_bufs[i].cookie.raw.luma,
+				S5P_FIMV_D_LUMA_DPB + i * 4);
+		mfc_debug(2, "\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.chroma);
+		WRITEL(ctx->dst_bufs[i].cookie.raw.chroma,
+				S5P_FIMV_D_CHROMA_DPB + i * 4);
+
+		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+				ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC) {
+			/* To test alignment */
+			align_gap = buf_addr1;
+			buf_addr1 = ALIGN(buf_addr1, 16);
+			align_gap = buf_addr1 - align_gap;
+			buf_size1 -= align_gap;
+
+			mfc_debug(2, "\tBuf1: %x, size: %d\n", buf_addr1, buf_size1);
+			WRITEL(buf_addr1, S5P_FIMV_D_MV_BUFFER + i * 4);
+			buf_addr1 += frame_size_mv;
+			buf_size1 -= frame_size_mv;
+		}
+	}
+
+	mfc_debug(2, "Buf1: %u, buf_size1: %d (frames %d)\n",
+			buf_addr1, buf_size1, ctx->total_dpb_count);
+	if (buf_size1 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_INIT_BUFS, NULL);
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
+	WRITEL(addr, S5P_FIMV_E_STREAM_BUFFER_ADDR); /* 16B align */
+	WRITEL(size, S5P_FIMV_E_STREAM_BUFFER_SIZE);
+
+	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d",
+		addr, size);
+
+	return 0;
+}
+
+void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR); /* 256B align */
+	WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR);
+
+	mfc_debug(2, "enc src y buf addr: 0x%08lx", y_addr);
+	mfc_debug(2, "enc src c buf addr: 0x%08lx", c_addr);
+}
+
+void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long enc_recon_y_addr, enc_recon_c_addr;
+
+	*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR);
+	*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR);
+
+	enc_recon_y_addr = READL(S5P_FIMV_E_RECON_LUMA_DPB_ADDR);
+	enc_recon_c_addr = READL(S5P_FIMV_E_RECON_CHROMA_DPB_ADDR);
+
+	mfc_debug(2, "recon y addr: 0x%08lx", enc_recon_y_addr);
+	mfc_debug(2, "recon c addr: 0x%08lx", enc_recon_c_addr);
+}
+
+/* Set encoding ref & codec buffer */
+int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	size_t buf_addr1, buf_size1;
+	int i;
+
+	mfc_debug_enter();
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+
+	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
+
+	for (i = 0; i < ctx->dpb_count; i++) {
+		WRITEL(buf_addr1, S5P_FIMV_E_LUMA_DPB + (4 * i));
+		buf_addr1 += ctx->luma_dpb_size;
+		WRITEL(buf_addr1, S5P_FIMV_E_CHROMA_DPB + (4 * i));
+		buf_addr1 += ctx->chroma_dpb_size;
+		WRITEL(buf_addr1, S5P_FIMV_E_ME_BUFFER + (4 * i));
+		buf_addr1 += ctx->me_buffer_size;
+		buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size +
+			ctx->me_buffer_size);
+	}
+
+	WRITEL(buf_addr1, S5P_FIMV_E_SCRATCH_BUFFER_ADDR);
+	WRITEL(ctx->scratch_buf_size, S5P_FIMV_E_SCRATCH_BUFFER_SIZE);
+	buf_addr1 += ctx->scratch_buf_size;
+	buf_size1 -= ctx->scratch_buf_size;
+
+	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER0);
+	buf_addr1 += ctx->tmv_buffer_size >> 1;
+	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER1);
+	buf_addr1 += ctx->tmv_buffer_size >> 1;
+	buf_size1 -= ctx->tmv_buffer_size;
+
+	mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
+			buf_addr1, buf_size1, ctx->dpb_count);
+	if (buf_size1 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_INIT_BUFS, NULL);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	WRITEL(ctx->slice_mode, S5P_FIMV_E_MSLICE_MODE);
+	if (ctx->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB) {
+		WRITEL(ctx->slice_size.mb, S5P_FIMV_E_MSLICE_SIZE_MB);
+	} else if (ctx->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS) {
+		WRITEL(ctx->slice_size.bits, S5P_FIMV_E_MSLICE_SIZE_BITS);
+	} else {
+		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_MB);
+		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_BITS);
+	}
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	/* width */
+	WRITEL(ctx->img_width, S5P_FIMV_E_FRAME_WIDTH); /* 16 align */
+	/* height */
+	WRITEL(ctx->img_height, S5P_FIMV_E_FRAME_HEIGHT); /* 16 align */
+
+	/* cropped width */
+	WRITEL(ctx->img_width, S5P_FIMV_E_CROPPED_FRAME_WIDTH);
+	/* cropped height */
+	WRITEL(ctx->img_height, S5P_FIMV_E_CROPPED_FRAME_HEIGHT);
+	/* cropped offset */
+	WRITEL(0x0, S5P_FIMV_E_FRAME_CROP_OFFSET);
+
+	/* pictype : IDR period */
+	reg = 0;
+	reg |= p->gop_size & 0xFFFF;
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG);
+
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	ctx->slice_mode = p->slice_mode;
+	reg = 0;
+	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB) {
+		reg |= (0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+		ctx->slice_size.mb = p->slice_mb;
+	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS) {
+		reg |= (0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+		ctx->slice_size.bits = p->slice_bit;
+	} else {
+		reg &= ~(0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+	}
+
+	s5p_mfc_set_slice_mode(ctx);
+
+	/* cyclic intra refresh */
+	WRITEL(p->intra_refresh_mb, S5P_FIMV_E_IR_SIZE);
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+	if (p->intra_refresh_mb == 0)
+		reg &= ~(0x1 << 4);
+	else
+		reg |= (0x1 << 4);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+
+	/* 'NON_REFERENCE_STORE_ENABLE' for debugging */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+	reg &= ~(0x1 << 9);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+		reg &= ~(0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV21M) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+		reg &= ~(0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+		reg |= (0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT);
+	}
+
+	/* memory structure recon. frame */
+	/* 0: Linear, 1: 2D tiled */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+	reg |= (0x1 << 8);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+
+	/* padding control & value */
+	WRITEL(0x0, S5P_FIMV_E_PADDING_CTRL);
+	if (p->pad) {
+		reg = 0;
+		/** enable */
+		reg |= (1 << 31);
+		/** cr value */
+		reg |= ((p->pad_cr & 0xFF) << 16);
+		/** cb value */
+		reg |= ((p->pad_cb & 0xFF) << 8);
+		/** y value */
+		reg |= p->pad_luma & 0xFF;
+		WRITEL(reg, S5P_FIMV_E_PADDING_CTRL);
+	}
+
+	/* rate control config. */
+	reg = 0;
+	/* frame-level rate control */
+	reg |= ((p->rc_frame & 0x1) << 9);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+
+	/* bit rate */
+	if (p->rc_frame)
+		WRITEL(p->rc_bitrate,
+			S5P_FIMV_E_RC_BIT_RATE);
+	else
+		WRITEL(1, S5P_FIMV_E_RC_BIT_RATE);
+
+	/* reaction coefficient */
+	if (p->rc_frame) {
+		if (p->rc_reaction_coeff < TIGHT_CBR_MAX) /* tight CBR */
+			WRITEL(1, S5P_FIMV_E_RC_RPARAM);
+		else					  /* loose CBR */
+			WRITEL(2, S5P_FIMV_E_RC_RPARAM);
+	}
+
+	/* seq header ctrl */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS);
+	reg &= ~(0x1 << 2);
+	reg |= ((p->seq_hdr_mode & 0x1) << 2);
+
+	/* frame skip mode */
+	reg &= ~(0x3);
+	reg |= (p->frame_skip_mode & 0x3);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS);
+
+	/* 'DROP_CONTROL_ENABLE', disable */
+	reg = READL(S5P_FIMV_E_RC_CONFIG);
+	reg &= ~(0x1 << 10);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+
+	/* setting for MV range [16, 256] */
+	reg = 0;
+	reg &= ~(0x3FFF);
+	reg = 256;
+	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE);
+
+	reg = 0;
+	reg &= ~(0x3FFF);
+	reg = 256;
+	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE);
+
+	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION);
+	WRITEL(0x0, S5P_FIMV_E_ROI_BUFFER_ADDR);
+	WRITEL(0x0, S5P_FIMV_E_PARAM_CHANGE);
+	WRITEL(0x0, S5P_FIMV_E_RC_ROI_CTRL);
+	WRITEL(0x0, S5P_FIMV_E_PICTURE_TAG);
+
+	WRITEL(0x0, S5P_FIMV_E_BIT_COUNT_ENABLE);
+	WRITEL(0x0, S5P_FIMV_E_MAX_BIT_COUNT);
+	WRITEL(0x0, S5P_FIMV_E_MIN_BIT_COUNT);
+
+	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_ADDR);
+	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_SIZE);
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
+	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
+	unsigned int reg = 0;
+	int i;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_E_GOP_CONFIG);
+	reg &= ~(0x3 << 16);
+	reg |= ((p->num_b_frame & 0x3) << 16);
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG);
+
+	/* profile & level */
+	reg = 0;
+	/** level */
+	reg |= ((p_h264->level & 0xFF) << 8);
+	/** profile - 0 ~ 3 */
+	reg |= p_h264->profile & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h264->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_h264->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_h264->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_h264->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_h264->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_h264->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p_h264->cpb_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY);
+	}
+
+	/* interlace */
+	reg = 0;
+	reg |= ((p_h264->interlace & 0x1) << 3);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* height */
+	if (p_h264->interlace) {
+		WRITEL(ctx->img_height >> 1, S5P_FIMV_E_FRAME_HEIGHT); /* 32 align */
+		/* cropped height */
+		WRITEL(ctx->img_height >> 1, S5P_FIMV_E_CROPPED_FRAME_HEIGHT);
+	}
+
+	/* loop filter ctrl */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x3 << 1);
+	reg |= ((p_h264->loop_filter_mode & 0x3) << 1);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* loopfilter alpha offset */
+	if (p_h264->loop_filter_alpha < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_h264->loop_filter_alpha) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_h264->loop_filter_alpha & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_E_H264_LF_ALPHA_OFFSET);
+
+	/* loopfilter beta offset */
+	if (p_h264->loop_filter_beta < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_h264->loop_filter_beta) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_h264->loop_filter_beta & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_E_H264_LF_BETA_OFFSET);
+
+	/* entropy coding mode */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1);
+	reg |= p_h264->entropy_mode & 0x1;
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* number of ref. picture */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 7);
+	reg |= (((p_h264->num_ref_pic_4p - 1) & 0x1) << 7);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* 8x8 transform enable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x3 << 12);
+	reg |= ((p_h264->_8x8_transform & 0x3) << 12);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* macroblock adaptive scaling features */
+	WRITEL(0x0, S5P_FIMV_E_MB_RC_CONFIG);
+	if (p->rc_mb) {
+		reg = 0;
+		/** dark region */
+		reg |= ((p_h264->rc_mb_dark & 0x1) << 3);
+		/** smooth region */
+		reg |= ((p_h264->rc_mb_smooth & 0x1) << 2);
+		/** static region */
+		reg |= ((p_h264->rc_mb_static & 0x1) << 1);
+		/** high activity region */
+		reg |= p_h264->rc_mb_activity & 0x1;
+		WRITEL(reg, S5P_FIMV_E_MB_RC_CONFIG);
+	}
+
+	/* aspect ratio VUI */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 5);
+	reg |= ((p_h264->vui_sar & 0x1) << 5);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	WRITEL(0x0, S5P_FIMV_E_ASPECT_RATIO);
+	WRITEL(0x0, S5P_FIMV_E_EXTENDED_SAR);
+	if (p_h264->vui_sar) {
+		/* aspect ration IDC */
+		reg = 0;
+		reg |= p_h264->vui_sar_idc & 0xFF;
+		WRITEL(reg, S5P_FIMV_E_ASPECT_RATIO);
+		if (p_h264->vui_sar_idc == 0xFF) {
+			/* extended SAR */
+			reg = 0;
+			reg |= (p_h264->vui_ext_sar_width & 0xFFFF) << 16;
+			reg |= p_h264->vui_ext_sar_height & 0xFFFF;
+			WRITEL(reg, S5P_FIMV_E_EXTENDED_SAR);
+		}
+	}
+
+	/* intra picture period for H.264 open GOP */
+	/* control */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 4);
+	reg |= ((p_h264->open_gop & 0x1) << 4);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+	/* value */
+	WRITEL(0x0, S5P_FIMV_E_H264_I_PERIOD);
+	if (p_h264->open_gop) {
+		reg = 0;
+		reg |= p_h264->open_gop_size & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_H264_I_PERIOD);
+	}
+
+	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x3 << 9);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 14);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* ASO */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 6);
+	reg |= ((p_h264->aso & 0x1) << 6);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+
+	/* hier qp enable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 8);
+	reg |= ((p_h264->open_gop & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+	reg = 0;
+	if (p_h264->hier_qp && p_h264->hier_qp_layer) {
+		reg |= (p_h264->hier_qp_type & 0x1) << 0x3;
+		reg |= p_h264->hier_qp_layer & 0x7;
+		WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER);
+		/* QP value for each layer */
+		for (i = 0; i < (p_h264->hier_qp_layer & 0x7); i++)
+			WRITEL(p_h264->hier_qp_layer_qp[i],
+				S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0 + i * 4);
+	}
+	/* number of coding layer should be zero when hierarchical is disable */
+	WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER);
+
+	/* frame packing SEI generation */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS);
+	reg &= ~(0x1 << 25);
+	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS);
+	if (p_h264->sei_frame_packing) {
+		reg = 0;
+		/** current frame0 flag */
+		reg |= ((p_h264->sei_fp_curr_frame_0 & 0x1) << 2);
+		/** arrangement type */
+		reg |= p_h264->sei_fp_arrangement_type & 0x3;
+		WRITEL(reg, S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO);
+	}
+
+	if (p_h264->fmo) {
+		switch (p_h264->fmo_map_type) {
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES:
+			if (p_h264->fmo_slice_grp > 4)
+				p_h264->fmo_slice_grp = 4;
+			for (i = 0; i < (p_h264->fmo_slice_grp & 0xF); i++)
+				WRITEL(p_h264->fmo_run_len[i] - 1,
+					S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0 + i * 4);
+			break;
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES:
+			if (p_h264->fmo_slice_grp > 4)
+				p_h264->fmo_slice_grp = 4;
+			break;
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN:
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN:
+			if (p_h264->fmo_slice_grp > 2)
+				p_h264->fmo_slice_grp = 2;
+			WRITEL(p_h264->fmo_chg_dir & 0x1, S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR);
+			/* the valid range is 0 ~ number of macroblocks -1 */
+			WRITEL(p_h264->fmo_chg_rate, S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1);
+			break;
+		default:
+			mfc_err("Unsupported map type for FMO: %d\n", p_h264->fmo_map_type);
+			p_h264->fmo_map_type = 0;
+			p_h264->fmo_slice_grp = 1;
+			break;
+		}
+
+		WRITEL(p_h264->fmo_map_type, S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE);
+		WRITEL(p_h264->fmo_slice_grp - 1, S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1);
+	} else {
+		WRITEL(0, S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1);
+	}
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
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_E_GOP_CONFIG);
+	reg &= ~(0x3 << 16);
+	reg |= ((p->num_b_frame & 0x3) << 16);
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG);
+
+	/* profile & level */
+	reg = 0;
+	/** level */
+	reg |= ((p_mpeg4->level & 0xFF) << 8);
+	/** profile - 0 ~ 1 */
+	reg |= p_mpeg4->profile & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_mpeg4->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_mpeg4->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_mpeg4->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_mpeg4->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY);
+	}
+
+	/* Disable HEC */
+	WRITEL(0x0, S5P_FIMV_E_MPEG4_OPTIONS);
+	WRITEL(0x0, S5P_FIMV_E_MPEG4_HEC_PERIOD);
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
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* profile & level */
+	reg = 0;
+	/** profile */
+	reg |= (0x1 << 4);
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_h263->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_h263->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_h263->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_h263->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_h263->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY);
+	}
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
+	unsigned int reg = 0;
+	int fmo_aso_ctrl = 0;
+
+	mfc_debug_enter();
+	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no, S5P_FIMV_CH_SEQ_HEADER);
+	mfc_debug(2, "BUFs: %08x %08x %08x\n",
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR),
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR),
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR));
+
+	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
+	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK);
+
+	/* When user sets desplay_delay to 0,
+	 * It works as "display_delay enable" and delay set to 0.
+	 * If user wants display_delay disable, It should be
+	 * set to negative value. */
+	if (ctx->display_delay >= 0) {
+		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT);
+		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY);
+	}
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC) {
+		mfc_debug(2, "Set loop filter to: %d\n", ctx->loop_filter_mpeg4);
+		reg |= (ctx->loop_filter_mpeg4 << S5P_FIMV_D_OPT_LF_CTRL_SHIFT);
+	}
+	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
+		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT);
+
+	WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS);
+
+	/* 0: NV12(CbCr), 1: NV21(CrCb) */
+	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
+		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT);
+	else
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT);
+
+	/* sei parse */
+	WRITEL(ctx->sei_fp_parse & 0x1, S5P_FIMV_D_SEI_ENABLE);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_SEQ_HEADER, NULL);
+
+	mfc_debug_leave();
+	return 0;
+}
+
+static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	if (flush)
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (1 << 14);
+	else
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~(1 << 14);
+	WRITEL(dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, int last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(0xffffffff, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER);
+	WRITEL(0xffffffff, S5P_FIMV_D_AVAILABLE_DPB_FLAG_UPPER);
+	WRITEL(ctx->slice_interface & 0x1, S5P_FIMV_D_SLICE_IF_ENABLE);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	switch (last_frame) {
+	case 0:
+		s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_FRAME_START, NULL);
+		break;
+	case 1:
+		s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_LAST_FRAME, NULL);
+		break;
+	}
+
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
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_SEQ_HEADER, NULL);
+
+	mfc_debug(2, "--\n");
+
+	return 0;
+}
+
+int s5p_mfc_h264_set_aso_slice_order(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
+	int i;
+
+	if (p_h264->aso) {
+		for (i = 0; i < 8; i++)
+			WRITEL(p_h264->aso_slice_order[i],
+				S5P_FIMV_E_H264_ASO_SLICE_ORDER_0 + i * 4);
+	}
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
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		s5p_mfc_h264_set_aso_slice_order(ctx);
+
+	s5p_mfc_set_slice_mode(ctx);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID);
+	s5p_mfc_cmd_host2risc(dev, S5P_FIMV_CH_FRAME_START, NULL);
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
+static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "No src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	temp_vb->used = 1;
+	s5p_mfc_set_dec_stream_buffer(ctx,
+			vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0, 0);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame(ctx, 1);
+}
+
+static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+	int last_frame = 0;
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
+	s5p_mfc_set_dec_stream_buffer(ctx,
+		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0,
+			temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	index = temp_vb->b->v4l2_buf.index;
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+		last_frame = 1;
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
+	/*
+	unsigned int src_y_size, src_c_size;
+	*/
+	unsigned int dst_size;
+	unsigned int index;
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
+	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+
+	mfc_debug(2, "enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug(2, "enc src c addr: 0x%08lx", src_c_addr);
+
+	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_mb->used = 1;
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	index = src_mb->b->v4l2_buf.index;
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
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer(ctx,
+		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0,
+			temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
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
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_encode(ctx);
+}
+
+static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
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
+static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	ret = s5p_mfc_alloc_codec_buffers(ctx);
+	if (ret) {
+		mfc_err("Failed to allocate encoding buffers.\n");
+		return -ENOMEM;
+	}
+
+	/* Header was generated now starting processing
+	 * First set the reference frame buffers
+	 */
+	if (ctx->capture_state != QUEUE_BUFS_REQUESTED) {
+		mfc_err("It seems that destionation buffers were not "
+			"requested.\nMFC requires that header should be generated "
+			"before allocating codec buffer.\n");
+		return -EAGAIN;
+	}
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_enc_ref_buffer(ctx);
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
+	if (ctx->type == MFCINST_DECODER) {
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			ret = s5p_mfc_open_inst_cmd(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_close_inst_cmd(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_HEAD_PARSED:
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			break;
+		case MFCINST_RES_CHANGE_INIT:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RES_CHANGE_FLUSH:
+			s5p_mfc_run_dec_last_frames(ctx);
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
+			ret = s5p_mfc_open_inst_cmd(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_close_inst_cmd(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_enc(ctx);
+			break;
+		case MFCINST_HEAD_PARSED: /* Only for MFC6.x */
+			ret = s5p_mfc_run_init_enc_buffers(ctx);
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
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data, unsigned int ofs)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_clock_on();
+	WRITEL(data, ofs);
+	s5p_mfc_clock_off();
+}
+
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	s5p_mfc_clock_on();
+	ret = READL(ofs);
+	s5p_mfc_clock_off();
+
+	return ret;
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
new file mode 100644
index 0000000..8b4b5db
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
@@ -0,0 +1,137 @@
+/*
+ * drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains declarations of hw related functions.
+ *
+ * Copyright (c) 2012 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_OPR_V6_H_
+#define S5P_MFC_OPR_V6_H_
+
+#include "s5p_mfc_common.h"
+
+#define MFC_CTRL_MODE_CUSTOM	MFC_CTRL_MODE_SFR
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
+int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx, int last_frame);
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
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev);
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev);
+
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx);
+
+#define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
+					S5P_FIMV_SI_DISPLAY_Y_ADR) << 11)
+#define s5p_mfc_get_dec_y_adr()		(readl(dev->regs_base + \
+					S5P_FIMV_D_DISPLAY_LUMA_ADDR) << 11)
+#define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
+						S5P_FIMV_D_DISPLAY_STATUS)
+#define s5p_mfc_get_decoded_status()	readl(dev->regs_base + \
+						S5P_FIMV_D_DECODED_STATUS)
+#define s5p_mfc_get_dec_frame_type()	(readl(dev->regs_base + \
+						S5P_FIMV_D_DECODED_FRAME_TYPE) \
+						& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_disp_frame_type()	(readl(ctx->dev->regs_base + \
+						S5P_FIMV_D_DISPLAY_FRAME_TYPE) \
+						& S5P_FIMV_DECODE_FRAME_MASK)
+#define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
+						S5P_FIMV_D_DECODED_NAL_SIZE)
+#define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
+					S5P_FIMV_RISC2HOST_CMD) & \
+					S5P_FIMV_RISC2HOST_CMD_MASK)
+#define s5p_mfc_get_int_err()		readl(dev->regs_base + \
+						S5P_FIMV_ERROR_CODE)
+#define s5p_mfc_err_dec(x)		(((x) & S5P_FIMV_ERR_DEC_MASK) >> \
+						S5P_FIMV_ERR_DEC_SHIFT)
+#define s5p_mfc_err_dspl(x)		(((x) & S5P_FIMV_ERR_DSPL_MASK) >> \
+						S5P_FIMV_ERR_DSPL_SHIFT)
+#define s5p_mfc_get_img_width()		readl(dev->regs_base + \
+						S5P_FIMV_D_DISPLAY_FRAME_WIDTH)
+#define s5p_mfc_get_img_height()	readl(dev->regs_base + \
+						S5P_FIMV_D_DISPLAY_FRAME_HEIGHT)
+#define s5p_mfc_get_dpb_count()		readl(dev->regs_base + \
+						S5P_FIMV_D_MIN_NUM_DPB)
+#define s5p_mfc_get_inst_no()		readl(dev->regs_base + \
+						S5P_FIMV_RET_INSTANCE_ID)
+#define s5p_mfc_get_enc_dpb_count()	readl(dev->regs_base + \
+						S5P_FIMV_E_NUM_DPB)
+#define s5p_mfc_get_enc_strm_size()	readl(dev->regs_base + \
+						S5P_FIMV_E_STREAM_SIZE)
+#define s5p_mfc_get_enc_slice_type()	readl(dev->regs_base + \
+						S5P_FIMV_E_SLICE_TYPE)
+#define s5p_mfc_get_enc_pic_count()	readl(dev->regs_base + \
+						S5P_FIMV_E_PICTURE_COUNT)
+#define s5p_mfc_get_sei_avail_status()	readl(dev->regs_base + \
+						S5P_FIMV_D_FRAME_PACK_SEI_AVAIL)
+#define s5p_mfc_get_mvc_num_views()	readl(dev->regs_base + \
+						S5P_FIMV_D_MVC_NUM_VIEWS)
+#define s5p_mfc_get_mvc_view_id()	readl(dev->regs_base + \
+						S5P_FIMV_D_MVC_VIEW_ID)
+
+#define mb_width(x_size)		((x_size + 15) / 16)
+#define mb_height(y_size)		((y_size + 15) / 16)
+#define s5p_mfc_dec_mv_size(x, y)	(mb_width(x) * (((mb_height(y)+1)/2)*2) * 64 + 128)
+
+/* Definition */
+#define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
+#define ENC_MULTI_SLICE_BIT_MIN		2800
+#define ENC_INTRA_REFRESH_MB_MAX	((1 << 18) - 1)
+#define ENC_VBV_BUF_SIZE_MAX		((1 << 30) - 1)
+#define ENC_H264_LOOP_FILTER_AB_MIN	-12
+#define ENC_H264_LOOP_FILTER_AB_MAX	12
+#define ENC_H264_RC_FRAME_RATE_MAX	((1 << 16) - 1)
+#define ENC_H263_RC_FRAME_RATE_MAX	((1 << 16) - 1)
+#define ENC_H264_PROFILE_MAX		3
+#define ENC_H264_LEVEL_MAX		42
+#define ENC_MPEG4_VOP_TIME_RES_MAX	((1 << 16) - 1)
+#define FRAME_DELTA_H264_H263		1
+#define TIGHT_CBR_MAX			10
+
+/* Definitions for shared memory compatibility */
+#define PIC_TIME_TOP		S5P_FIMV_D_RET_PICTURE_TAG_TOP
+#define PIC_TIME_BOT		S5P_FIMV_D_RET_PICTURE_TAG_BOT
+#define CROP_INFO_H		S5P_FIMV_D_DISPLAY_CROP_INFO1
+#define CROP_INFO_V		S5P_FIMV_D_DISPLAY_CROP_INFO2
+
+void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
+
+void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
+
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data, unsigned int ofs);
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx, unsigned int ofs);
+
+#endif /* S5P_MFC_OPR_V6_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
index 91fdbac..d2e7765 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
@@ -21,26 +21,27 @@ int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	void *shm_alloc_ctx = dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	ctx->shm_alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx,
-							SHARED_BUF_SIZE);
-	if (IS_ERR(ctx->shm_alloc)) {
+	ctx->shm.alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx,
+							buf_size->shm);
+	if (IS_ERR(ctx->shm.alloc)) {
 		mfc_err("failed to allocate shared memory\n");
-		return PTR_ERR(ctx->shm_alloc);
+		return PTR_ERR(ctx->shm.alloc);
 	}
-	/* shm_ofs only keeps the offset from base (port a) */
-	ctx->shm_ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm_alloc)
+	/* shared memory offset only keeps the offset from base (port a) */
+	ctx->shm.ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm.alloc)
 								- dev->bank1;
-	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
-	if (!ctx->shm) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_ofs = 0;
-		ctx->shm_alloc = NULL;
+	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->shm.virt = vb2_dma_contig_memops.vaddr(ctx->shm.alloc);
+	if (!ctx->shm.virt) {
+		vb2_dma_contig_memops.put(ctx->shm.alloc);
+		ctx->shm.alloc = NULL;
+		ctx->shm.ofs = 0;
 		mfc_err("failed to virt addr of shared memory\n");
 		return -ENOMEM;
 	}
-	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
+	memset((void *)ctx->shm.virt, 0, buf_size->shm);
 	wmb();
 	return 0;
 }
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
index 764eac6..e1ed052 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
@@ -72,20 +72,23 @@ enum MFC_SHM_OFS
 	DBG_HISTORY_INPUT1	= 0xD4,	/* C */
 	DBG_HISTORY_OUTPUT	= 0xD8,	/* C */
 	HIERARCHICAL_P_QP	= 0xE0, /* E, H.264 */
+	FRAME_PACK_SEI_ENABLE	= 0x168, /* C */
+	FRAME_PACK_SEI_AVAIL	= 0x16c, /* D */
+	FRAME_PACK_SEI_INFO	= 0x17c, /* E */
 };
 
 int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx);
 
-#define s5p_mfc_write_shm(ctx, x, ofs)		\
-	do {					\
-		writel(x, (ctx->shm + ofs));	\
-		wmb();				\
+#define s5p_mfc_write_shm(ctx, x, ofs)			\
+	do {						\
+		writel(x, (ctx->shm.virt + ofs));	\
+		wmb();					\
 	} while (0)
 
 static inline u32 s5p_mfc_read_shm(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 {
 	rmb();
-	return readl(ctx->shm + ofs);
+	return readl(ctx->shm.virt + ofs);
 }
 
 #endif /* S5P_MFC_SHM_H_ */
-- 
1.7.1


