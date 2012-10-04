Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61493 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2JCRGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:06:24 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB00K5CU699FC0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:22 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBB009RUU5VQI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:22 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH v10 6/7] [media] s5p-mfc: MFCv6 register definitions
Date: Thu, 04 Oct 2012 06:49:10 +0530
Message-id: <1349313551-23368-7-git-send-email-arun.kk@samsung.com>
In-reply-to: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
References: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

Adds register definitions for MFC v6.x firmware

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Signed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h |  408 ++++++++++++++++++++++++++
 1 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v6.h

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
new file mode 100644
index 0000000..363a97c
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -0,0 +1,408 @@
+/*
+ * Register definition file for Samsung MFC V6.x Interface (FIMV) driver
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
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
+#include <linux/kernel.h>
+#include <linux/sizes.h>
+
+#define S5P_FIMV_REG_SIZE_V6	(S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR)
+#define S5P_FIMV_REG_COUNT_V6	((S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR) / 4)
+
+/* Number of bits that the buffer address should be shifted for particular
+ * MFC buffers.  */
+#define S5P_FIMV_MEM_OFFSET_V6		0
+
+#define S5P_FIMV_START_ADDR_V6		0x0000
+#define S5P_FIMV_END_ADDR_V6		0xfd80
+
+#define S5P_FIMV_REG_CLEAR_BEGIN_V6	0xf000
+#define S5P_FIMV_REG_CLEAR_COUNT_V6	1024
+
+/* Codec Common Registers */
+#define S5P_FIMV_RISC_ON_V6			0x0000
+#define S5P_FIMV_RISC2HOST_INT_V6		0x003C
+#define S5P_FIMV_HOST2RISC_INT_V6		0x0044
+#define S5P_FIMV_RISC_BASE_ADDRESS_V6		0x0054
+
+#define S5P_FIMV_MFC_RESET_V6			0x1070
+
+#define S5P_FIMV_HOST2RISC_CMD_V6		0x1100
+#define S5P_FIMV_H2R_CMD_EMPTY_V6		0
+#define S5P_FIMV_H2R_CMD_SYS_INIT_V6		1
+#define S5P_FIMV_H2R_CMD_OPEN_INSTANCE_V6	2
+#define S5P_FIMV_CH_SEQ_HEADER_V6		3
+#define S5P_FIMV_CH_INIT_BUFS_V6		4
+#define S5P_FIMV_CH_FRAME_START_V6		5
+#define S5P_FIMV_H2R_CMD_CLOSE_INSTANCE_V6	6
+#define S5P_FIMV_H2R_CMD_SLEEP_V6		7
+#define S5P_FIMV_H2R_CMD_WAKEUP_V6		8
+#define S5P_FIMV_CH_LAST_FRAME_V6		9
+#define S5P_FIMV_H2R_CMD_FLUSH_V6		10
+/* RMVME: REALLOC used? */
+#define S5P_FIMV_CH_FRAME_START_REALLOC_V6	5
+
+#define S5P_FIMV_RISC2HOST_CMD_V6		0x1104
+#define S5P_FIMV_R2H_CMD_EMPTY_V6		0
+#define S5P_FIMV_R2H_CMD_SYS_INIT_RET_V6	1
+#define S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET_V6	2
+#define S5P_FIMV_R2H_CMD_SEQ_DONE_RET_V6	3
+#define S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET_V6	4
+
+#define S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET_V6	6
+#define S5P_FIMV_R2H_CMD_SLEEP_RET_V6		7
+#define S5P_FIMV_R2H_CMD_WAKEUP_RET_V6		8
+#define S5P_FIMV_R2H_CMD_COMPLETE_SEQ_RET_V6	9
+#define S5P_FIMV_R2H_CMD_DPB_FLUSH_RET_V6	10
+#define S5P_FIMV_R2H_CMD_NAL_ABORT_RET_V6	11
+#define S5P_FIMV_R2H_CMD_FW_STATUS_RET_V6	12
+#define S5P_FIMV_R2H_CMD_FRAME_DONE_RET_V6	13
+#define S5P_FIMV_R2H_CMD_FIELD_DONE_RET_V6	14
+#define S5P_FIMV_R2H_CMD_SLICE_DONE_RET_V6	15
+#define S5P_FIMV_R2H_CMD_ENC_BUFFER_FUL_RET_V6	16
+#define S5P_FIMV_R2H_CMD_ERR_RET_V6		32
+
+#define S5P_FIMV_FW_VERSION_V6			0xf000
+
+#define S5P_FIMV_INSTANCE_ID_V6			0xf008
+#define S5P_FIMV_CODEC_TYPE_V6			0xf00c
+#define S5P_FIMV_CONTEXT_MEM_ADDR_V6		0xf014
+#define S5P_FIMV_CONTEXT_MEM_SIZE_V6		0xf018
+#define S5P_FIMV_PIXEL_FORMAT_V6		0xf020
+
+#define S5P_FIMV_METADATA_ENABLE_V6		0xf024
+#define S5P_FIMV_DBG_BUFFER_ADDR_V6		0xf030
+#define S5P_FIMV_DBG_BUFFER_SIZE_V6		0xf034
+#define S5P_FIMV_RET_INSTANCE_ID_V6		0xf070
+
+#define S5P_FIMV_ERROR_CODE_V6			0xf074
+#define S5P_FIMV_ERR_WARNINGS_START_V6		160
+#define S5P_FIMV_ERR_DEC_MASK_V6		0xffff
+#define S5P_FIMV_ERR_DEC_SHIFT_V6		0
+#define S5P_FIMV_ERR_DSPL_MASK_V6		0xffff0000
+#define S5P_FIMV_ERR_DSPL_SHIFT_V6		16
+
+#define S5P_FIMV_DBG_BUFFER_OUTPUT_SIZE_V6	0xf078
+#define S5P_FIMV_METADATA_STATUS_V6		0xf07C
+#define S5P_FIMV_METADATA_ADDR_MB_INFO_V6	0xf080
+#define S5P_FIMV_METADATA_SIZE_MB_INFO_V6	0xf084
+
+/* Decoder Registers */
+#define S5P_FIMV_D_CRC_CTRL_V6			0xf0b0
+#define S5P_FIMV_D_DEC_OPTIONS_V6		0xf0b4
+#define S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6	4
+#define S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6	3
+#define S5P_FIMV_D_OPT_LF_CTRL_SHIFT_V6		1
+#define S5P_FIMV_D_OPT_LF_CTRL_MASK_V6		0x3
+#define S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6	0
+
+#define S5P_FIMV_D_DISPLAY_DELAY_V6		0xf0b8
+
+#define S5P_FIMV_D_SET_FRAME_WIDTH_V6		0xf0bc
+#define S5P_FIMV_D_SET_FRAME_HEIGHT_V6		0xf0c0
+
+#define S5P_FIMV_D_SEI_ENABLE_V6		0xf0c4
+
+/* Buffer setting registers */
+#define S5P_FIMV_D_MIN_NUM_DPB_V6		0xf0f0
+#define S5P_FIMV_D_MIN_LUMA_DPB_SIZE_V6		0xf0f4
+#define S5P_FIMV_D_MIN_CHROMA_DPB_SIZE_V6	0xf0f8
+#define S5P_FIMV_D_MVC_NUM_VIEWS_V6		0xf0fc
+#define S5P_FIMV_D_MIN_NUM_MV_V6		0xf100
+#define S5P_FIMV_D_NUM_DPB_V6			0xf130
+#define S5P_FIMV_D_LUMA_DPB_SIZE_V6		0xf134
+#define S5P_FIMV_D_CHROMA_DPB_SIZE_V6		0xf138
+#define S5P_FIMV_D_MV_BUFFER_SIZE_V6		0xf13c
+
+#define S5P_FIMV_D_LUMA_DPB_V6			0xf140
+#define S5P_FIMV_D_CHROMA_DPB_V6		0xf240
+#define S5P_FIMV_D_MV_BUFFER_V6			0xf340
+
+#define S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V6	0xf440
+#define S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V6	0xf444
+#define S5P_FIMV_D_METADATA_BUFFER_ADDR_V6	0xf448
+#define S5P_FIMV_D_METADATA_BUFFER_SIZE_V6	0xf44c
+#define S5P_FIMV_D_NUM_MV_V6			0xf478
+#define S5P_FIMV_D_CPB_BUFFER_ADDR_V6		0xf4b0
+#define S5P_FIMV_D_CPB_BUFFER_SIZE_V6		0xf4b4
+
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_UPPER_V6	0xf4b8
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6	0xf4bc
+#define S5P_FIMV_D_CPB_BUFFER_OFFSET_V6		0xf4c0
+#define S5P_FIMV_D_SLICE_IF_ENABLE_V6		0xf4c4
+#define S5P_FIMV_D_PICTURE_TAG_V6		0xf4c8
+#define S5P_FIMV_D_STREAM_DATA_SIZE_V6		0xf4d0
+
+/* Display information register */
+#define S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6	0xf500
+#define S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6	0xf504
+
+/* Display status */
+#define S5P_FIMV_D_DISPLAY_STATUS_V6		0xf508
+
+#define S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6		0xf50c
+#define S5P_FIMV_D_DISPLAY_CHROMA_ADDR_V6	0xf510
+
+#define S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6	0xf514
+
+#define S5P_FIMV_D_DISPLAY_CROP_INFO1_V6	0xf518
+#define S5P_FIMV_D_DISPLAY_CROP_INFO2_V6	0xf51c
+#define S5P_FIMV_D_DISPLAY_PICTURE_PROFILE_V6	0xf520
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_TOP_V6	0xf524
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_TOP_V6	0xf528
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_BOT_V6	0xf52c
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_BOT_V6	0xf530
+#define S5P_FIMV_D_DISPLAY_ASPECT_RATIO_V6	0xf534
+#define S5P_FIMV_D_DISPLAY_EXTENDED_AR_V6	0xf538
+
+/* Decoded picture information register */
+#define S5P_FIMV_D_DECODED_FRAME_WIDTH_V6	0xf53c
+#define S5P_FIMV_D_DECODED_FRAME_HEIGHT_V6	0xf540
+#define S5P_FIMV_D_DECODED_STATUS_V6		0xf544
+#define S5P_FIMV_DEC_CRC_GEN_MASK_V6		0x1
+#define S5P_FIMV_DEC_CRC_GEN_SHIFT_V6		6
+
+#define S5P_FIMV_D_DECODED_LUMA_ADDR_V6		0xf548
+#define S5P_FIMV_D_DECODED_CHROMA_ADDR_V6	0xf54c
+
+#define S5P_FIMV_D_DECODED_FRAME_TYPE_V6	0xf550
+#define S5P_FIMV_DECODE_FRAME_MASK_V6		7
+
+#define S5P_FIMV_D_DECODED_CROP_INFO1_V6	0xf554
+#define S5P_FIMV_D_DECODED_CROP_INFO2_V6	0xf558
+#define S5P_FIMV_D_DECODED_PICTURE_PROFILE_V6	0xf55c
+#define S5P_FIMV_D_DECODED_NAL_SIZE_V6		0xf560
+#define S5P_FIMV_D_DECODED_LUMA_CRC_TOP_V6	0xf564
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_TOP_V6	0xf568
+#define S5P_FIMV_D_DECODED_LUMA_CRC_BOT_V6	0xf56c
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_BOT_V6	0xf570
+
+/* Returned value register for specific setting */
+#define S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6		0xf574
+#define S5P_FIMV_D_RET_PICTURE_TAG_BOT_V6		0xf578
+#define S5P_FIMV_D_RET_PICTURE_TIME_TOP_V6		0xf57c
+#define S5P_FIMV_D_RET_PICTURE_TIME_BOT_V6		0xf580
+#define S5P_FIMV_D_CHROMA_FORMAT_V6			0xf588
+#define S5P_FIMV_D_MPEG4_INFO_V6			0xf58c
+#define S5P_FIMV_D_H264_INFO_V6				0xf590
+
+#define S5P_FIMV_D_METADATA_ADDR_CONCEALED_MB_V6	0xf594
+#define S5P_FIMV_D_METADATA_SIZE_CONCEALED_MB_V6	0xf598
+#define S5P_FIMV_D_METADATA_ADDR_VC1_PARAM_V6		0xf59c
+#define S5P_FIMV_D_METADATA_SIZE_VC1_PARAM_V6		0xf5a0
+#define S5P_FIMV_D_METADATA_ADDR_SEI_NAL_V6		0xf5a4
+#define S5P_FIMV_D_METADATA_SIZE_SEI_NAL_V6		0xf5a8
+#define S5P_FIMV_D_METADATA_ADDR_VUI_V6			0xf5ac
+#define S5P_FIMV_D_METADATA_SIZE_VUI_V6			0xf5b0
+
+#define S5P_FIMV_D_MVC_VIEW_ID_V6		0xf5b4
+
+/* SEI related information */
+#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6	0xf5f0
+#define S5P_FIMV_D_FRAME_PACK_ARRGMENT_ID_V6	0xf5f4
+#define S5P_FIMV_D_FRAME_PACK_SEI_INFO_V6	0xf5f8
+#define S5P_FIMV_D_FRAME_PACK_GRID_POS_V6	0xf5fc
+
+/* Encoder Registers */
+#define S5P_FIMV_E_FRAME_WIDTH_V6		0xf770
+#define S5P_FIMV_E_FRAME_HEIGHT_V6		0xf774
+#define S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6	0xf778
+#define S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6	0xf77c
+#define S5P_FIMV_E_FRAME_CROP_OFFSET_V6		0xf780
+#define S5P_FIMV_E_ENC_OPTIONS_V6		0xf784
+#define S5P_FIMV_E_PICTURE_PROFILE_V6		0xf788
+#define S5P_FIMV_E_FIXED_PICTURE_QP_V6		0xf790
+
+#define S5P_FIMV_E_RC_CONFIG_V6			0xf794
+#define S5P_FIMV_E_RC_QP_BOUND_V6		0xf798
+#define S5P_FIMV_E_RC_RPARAM_V6			0xf79c
+#define S5P_FIMV_E_MB_RC_CONFIG_V6		0xf7a0
+#define S5P_FIMV_E_PADDING_CTRL_V6		0xf7a4
+#define S5P_FIMV_E_MV_HOR_RANGE_V6		0xf7ac
+#define S5P_FIMV_E_MV_VER_RANGE_V6		0xf7b0
+
+#define S5P_FIMV_E_VBV_BUFFER_SIZE_V6		0xf84c
+#define S5P_FIMV_E_VBV_INIT_DELAY_V6		0xf850
+#define S5P_FIMV_E_NUM_DPB_V6			0xf890
+#define S5P_FIMV_E_LUMA_DPB_V6			0xf8c0
+#define S5P_FIMV_E_CHROMA_DPB_V6		0xf904
+#define S5P_FIMV_E_ME_BUFFER_V6			0xf948
+
+#define S5P_FIMV_E_SCRATCH_BUFFER_ADDR_V6	0xf98c
+#define S5P_FIMV_E_SCRATCH_BUFFER_SIZE_V6	0xf990
+#define S5P_FIMV_E_TMV_BUFFER0_V6		0xf994
+#define S5P_FIMV_E_TMV_BUFFER1_V6		0xf998
+#define S5P_FIMV_E_SOURCE_LUMA_ADDR_V6		0xf9f0
+#define S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6	0xf9f4
+#define S5P_FIMV_E_STREAM_BUFFER_ADDR_V6	0xf9f8
+#define S5P_FIMV_E_STREAM_BUFFER_SIZE_V6	0xf9fc
+#define S5P_FIMV_E_ROI_BUFFER_ADDR_V6		0xfA00
+
+#define S5P_FIMV_E_PARAM_CHANGE_V6		0xfa04
+#define S5P_FIMV_E_IR_SIZE_V6			0xfa08
+#define S5P_FIMV_E_GOP_CONFIG_V6		0xfa0c
+#define S5P_FIMV_E_MSLICE_MODE_V6		0xfa10
+#define S5P_FIMV_E_MSLICE_SIZE_MB_V6		0xfa14
+#define S5P_FIMV_E_MSLICE_SIZE_BITS_V6		0xfa18
+#define S5P_FIMV_E_FRAME_INSERTION_V6		0xfa1c
+
+#define S5P_FIMV_E_RC_FRAME_RATE_V6		0xfa20
+#define S5P_FIMV_E_RC_BIT_RATE_V6		0xfa24
+#define S5P_FIMV_E_RC_QP_OFFSET_V6		0xfa28
+#define S5P_FIMV_E_RC_ROI_CTRL_V6		0xfa2c
+#define S5P_FIMV_E_PICTURE_TAG_V6		0xfa30
+#define S5P_FIMV_E_BIT_COUNT_ENABLE_V6		0xfa34
+#define S5P_FIMV_E_MAX_BIT_COUNT_V6		0xfa38
+#define S5P_FIMV_E_MIN_BIT_COUNT_V6		0xfa3c
+
+#define S5P_FIMV_E_METADATA_BUFFER_ADDR_V6		0xfa40
+#define S5P_FIMV_E_METADATA_BUFFER_SIZE_V6		0xfa44
+#define S5P_FIMV_E_STREAM_SIZE_V6			0xfa80
+#define S5P_FIMV_E_SLICE_TYPE_V6			0xfa84
+#define S5P_FIMV_E_PICTURE_COUNT_V6			0xfa88
+#define S5P_FIMV_E_RET_PICTURE_TAG_V6			0xfa8c
+#define S5P_FIMV_E_STREAM_BUFFER_WRITE_POINTER_V6	0xfa90
+
+#define S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6		0xfa94
+#define S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6	0xfa98
+#define S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6		0xfa9c
+#define S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6		0xfaa0
+#define S5P_FIMV_E_METADATA_ADDR_ENC_SLICE_V6		0xfaa4
+#define S5P_FIMV_E_METADATA_SIZE_ENC_SLICE_V6		0xfaa8
+
+#define S5P_FIMV_E_MPEG4_OPTIONS_V6		0xfb10
+#define S5P_FIMV_E_MPEG4_HEC_PERIOD_V6		0xfb14
+#define S5P_FIMV_E_ASPECT_RATIO_V6		0xfb50
+#define S5P_FIMV_E_EXTENDED_SAR_V6		0xfb54
+
+#define S5P_FIMV_E_H264_OPTIONS_V6		0xfb58
+#define S5P_FIMV_E_H264_LF_ALPHA_OFFSET_V6	0xfb5c
+#define S5P_FIMV_E_H264_LF_BETA_OFFSET_V6	0xfb60
+#define S5P_FIMV_E_H264_I_PERIOD_V6		0xfb64
+
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE_V6		0xfb68
+#define S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6		0xfb6c
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR_V6		0xfb70
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1_V6	0xfb74
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0_V6		0xfb78
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_1_V6		0xfb7c
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_2_V6		0xfb80
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_3_V6		0xfb84
+
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_0_V6	0xfb88
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_1_V6	0xfb8c
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_2_V6	0xfb90
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_3_V6	0xfb94
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_4_V6	0xfb98
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_5_V6	0xfb9c
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_6_V6	0xfba0
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_7_V6	0xfba4
+
+#define S5P_FIMV_E_H264_CHROMA_QP_OFFSET_V6	0xfba8
+#define S5P_FIMV_E_H264_NUM_T_LAYER_V6		0xfbac
+
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0_V6	0xfbb0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER1_V6	0xfbb4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER2_V6	0xfbb8
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER3_V6	0xfbbc
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER4_V6	0xfbc0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER5_V6	0xfbc4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER6_V6	0xfbc8
+
+#define S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6		0xfc4c
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE_V6	0
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TOP_BOTTOM_V6		1
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TEMPORAL_V6		2
+
+#define S5P_FIMV_E_MVC_FRAME_QP_VIEW1_V6		0xfd40
+#define S5P_FIMV_E_MVC_RC_FRAME_RATE_VIEW1_V6		0xfd44
+#define S5P_FIMV_E_MVC_RC_BIT_RATE_VIEW1_V6		0xfd48
+#define S5P_FIMV_E_MVC_RC_QBOUND_VIEW1_V6		0xfd4c
+#define S5P_FIMV_E_MVC_RC_RPARA_VIEW1_V6		0xfd50
+#define S5P_FIMV_E_MVC_INTER_VIEW_PREDICTION_ON_V6	0xfd80
+
+/* Codec numbers  */
+#define S5P_FIMV_CODEC_NONE_V6		-1
+
+
+#define S5P_FIMV_CODEC_H264_DEC_V6	0
+#define S5P_FIMV_CODEC_H264_MVC_DEC_V6	1
+
+#define S5P_FIMV_CODEC_MPEG4_DEC_V6	3
+#define S5P_FIMV_CODEC_FIMV1_DEC_V6	4
+#define S5P_FIMV_CODEC_FIMV2_DEC_V6	5
+#define S5P_FIMV_CODEC_FIMV3_DEC_V6	6
+#define S5P_FIMV_CODEC_FIMV4_DEC_V6	7
+#define S5P_FIMV_CODEC_H263_DEC_V6	8
+#define S5P_FIMV_CODEC_VC1RCV_DEC_V6	9
+#define S5P_FIMV_CODEC_VC1_DEC_V6	10
+/* FIXME: Add 11~12 */
+#define S5P_FIMV_CODEC_MPEG2_DEC_V6	13
+#define S5P_FIMV_CODEC_VP8_DEC_V6	14
+/* FIXME: Add 15~16 */
+#define S5P_FIMV_CODEC_H264_ENC_V6	20
+#define S5P_FIMV_CODEC_H264_MVC_ENC_V6	21
+
+#define S5P_FIMV_CODEC_MPEG4_ENC_V6	23
+#define S5P_FIMV_CODEC_H263_ENC_V6	24
+
+#define S5P_FIMV_NV12M_HALIGN_V6		16
+#define S5P_FIMV_NV12MT_HALIGN_V6		16
+#define S5P_FIMV_NV12MT_VALIGN_V6		16
+
+#define S5P_FIMV_TMV_BUFFER_ALIGN_V6		16
+#define S5P_FIMV_LUMA_DPB_BUFFER_ALIGN_V6	256
+#define S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6	256
+#define S5P_FIMV_ME_BUFFER_ALIGN_V6		256
+#define S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6	256
+
+#define S5P_FIMV_LUMA_MB_TO_PIXEL_V6		256
+#define S5P_FIMV_CHROMA_MB_TO_PIXEL_V6		128
+#define S5P_FIMV_NUM_TMV_BUFFERS_V6		2
+
+#define S5P_FIMV_MAX_FRAME_SIZE_V6		(2 * SZ_1M)
+#define S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6	16
+#define S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6	16
+
+/* Buffer size requirements defined by hardware */
+#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	(((w) + 1) * ((h) + 1) * 8)
+#define S5P_FIMV_ME_BUFFER_SIZE_V6(imw, imh, mbw, mbh) \
+	((DIV_ROUND_UP(imw, 64) *  DIV_ROUND_UP(imh, 64) * 256) + \
+	 (DIV_ROUND_UP((mbw) * (mbh), 32) * 16))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(w, h)	(((w) * 192) + 64)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h) \
+			((w) * ((h) * 64 + 144) + (2048/16 * (h) * 64) + \
+			 (2048/16 * 256 + 8320))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(w, h) \
+						(2096 * ((w) + (h) + 1))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	((w) * 400)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(w, h) \
+			((w) * 32 + (h) * 128 + (((w) + 1) / 2) * 64 + 2112)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(w, h) \
+			(((w) * 64) + (((w) + 1) * 16) + (4096 * 16))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(w, h) \
+			(((w) * 16) + (((w) + 1) * 16))
+
+/* MFC Context buffer sizes */
+#define MFC_CTX_BUF_SIZE_V6		(28 * SZ_1K)	/*  28KB */
+#define MFC_H264_DEC_CTX_BUF_SIZE_V6	(2 * SZ_1M)	/*  2MB */
+#define MFC_OTHER_DEC_CTX_BUF_SIZE_V6	(20 * SZ_1K)	/*  20KB */
+#define MFC_H264_ENC_CTX_BUF_SIZE_V6	(100 * SZ_1K)	/* 100KB */
+#define MFC_OTHER_ENC_CTX_BUF_SIZE_V6	(12 * SZ_1K)	/*  12KB */
+
+/* MFCv6 variant defines */
+#define MAX_FW_SIZE_V6			(SZ_1M)		/* 1MB */
+#define MAX_CPB_SIZE_V6			(3 * SZ_1M)	/* 3MB */
+#define MFC_VERSION_V6			0x61
+#define MFC_NUM_PORTS_V6		1
+
+#endif /* _REGS_FIMV_V6_H */
-- 
1.7.0.4

