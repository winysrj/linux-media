Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33291 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2HIKMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 06:12:31 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8H00C8RGCQWYX0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:30 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8H00MGUGCES850@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:30 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v4 3/4] [media] s5p-mfc: MFCv6 register definitions
Date: Thu, 09 Aug 2012 15:58:29 +0530
Message-id: <1344508110-16945-4-git-send-email-arun.kk@samsung.com>
In-reply-to: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
References: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
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
 drivers/media/video/s5p-mfc/regs-mfc-v6.h |  429 +++++++++++++++++++++++++++++
 1 files changed, 429 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h

diff --git a/drivers/media/video/s5p-mfc/regs-mfc-v6.h b/drivers/media/video/s5p-mfc/regs-mfc-v6.h
new file mode 100644
index 0000000..2f25c5d
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/regs-mfc-v6.h
@@ -0,0 +1,429 @@
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
+#define S5P_FIMV_FW_VERSION_V6			0xF000
+
+#define S5P_FIMV_INSTANCE_ID_V6			0xF008
+#define S5P_FIMV_CODEC_TYPE_V6			0xF00C
+#define S5P_FIMV_CONTEXT_MEM_ADDR_V6		0xF014
+#define S5P_FIMV_CONTEXT_MEM_SIZE_V6		0xF018
+#define S5P_FIMV_PIXEL_FORMAT_V6		0xF020
+
+#define S5P_FIMV_METADATA_ENABLE_V6		0xF024
+#define S5P_FIMV_DBG_BUFFER_ADDR_V6		0xF030
+#define S5P_FIMV_DBG_BUFFER_SIZE_V6		0xF034
+#define S5P_FIMV_RET_INSTANCE_ID_V6		0xF070
+
+#define S5P_FIMV_ERROR_CODE_V6			0xF074
+#define S5P_FIMV_ERR_WARNINGS_START_V6		160
+#define S5P_FIMV_ERR_DEC_MASK_V6		0xFFFF
+#define S5P_FIMV_ERR_DEC_SHIFT_V6		0
+#define S5P_FIMV_ERR_DSPL_MASK_V6		0xFFFF0000
+#define S5P_FIMV_ERR_DSPL_SHIFT_V6		16
+
+#define S5P_FIMV_DBG_BUFFER_OUTPUT_SIZE_V6	0xF078
+#define S5P_FIMV_METADATA_STATUS_V6		0xF07C
+#define S5P_FIMV_METADATA_ADDR_MB_INFO_V6	0xF080
+#define S5P_FIMV_METADATA_SIZE_MB_INFO_V6	0xF084
+
+/* Decoder Registers */
+#define S5P_FIMV_D_CRC_CTRL_V6			0xF0B0
+#define S5P_FIMV_D_DEC_OPTIONS_V6		0xF0B4
+#define S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6	4
+#define S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6	3
+#define S5P_FIMV_D_OPT_LF_CTRL_SHIFT_V6		1
+#define S5P_FIMV_D_OPT_LF_CTRL_MASK_V6		0x3
+#define S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6	0
+
+#define S5P_FIMV_D_DISPLAY_DELAY_V6		0xF0B8
+
+#define S5P_FIMV_D_SET_FRAME_WIDTH_V6		0xF0BC
+#define S5P_FIMV_D_SET_FRAME_HEIGHT_V6		0xF0C0
+
+#define S5P_FIMV_D_SEI_ENABLE_V6		0xF0C4
+
+/* Buffer setting registers */
+#define S5P_FIMV_D_MIN_NUM_DPB_V6		0xF0F0
+#define S5P_FIMV_D_MIN_LUMA_DPB_SIZE_V6		0xF0F4
+#define S5P_FIMV_D_MIN_CHROMA_DPB_SIZE_V6	0xF0F8
+#define S5P_FIMV_D_MVC_NUM_VIEWS_V6		0xF0FC
+#define S5P_FIMV_D_MIN_NUM_MV_V6		0xF100
+#define S5P_FIMV_D_NUM_DPB_V6			0xF130
+#define S5P_FIMV_D_LUMA_DPB_SIZE_V6		0xF134
+#define S5P_FIMV_D_CHROMA_DPB_SIZE_V6		0xF138
+#define S5P_FIMV_D_MV_BUFFER_SIZE_V6		0xF13C
+
+#define S5P_FIMV_D_LUMA_DPB_V6			0xF140
+#define S5P_FIMV_D_CHROMA_DPB_V6		0xF240
+#define S5P_FIMV_D_MV_BUFFER_V6			0xF340
+
+#define S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V6	0xF440
+#define S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V6	0xF444
+#define S5P_FIMV_D_METADATA_BUFFER_ADDR_V6	0xF448
+#define S5P_FIMV_D_METADATA_BUFFER_SIZE_V6	0xF44C
+#define S5P_FIMV_D_NUM_MV_V6			0xF478
+#define S5P_FIMV_D_CPB_BUFFER_ADDR_V6		0xF4B0
+#define S5P_FIMV_D_CPB_BUFFER_SIZE_V6		0xF4B4
+
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_UPPER_V6	0xF4B8
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6	0xF4BC
+#define S5P_FIMV_D_CPB_BUFFER_OFFSET_V6		0xF4C0
+#define S5P_FIMV_D_SLICE_IF_ENABLE_V6		0xF4C4
+#define S5P_FIMV_D_PICTURE_TAG_V6		0xF4C8
+#define S5P_FIMV_D_STREAM_DATA_SIZE_V6		0xF4D0
+
+/* Display information register */
+#define S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6	0xF500
+#define S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6	0xF504
+
+/* Display status */
+#define S5P_FIMV_D_DISPLAY_STATUS_V6		0xF508
+
+#define S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6		0xF50C
+#define S5P_FIMV_D_DISPLAY_CHROMA_ADDR_V6	0xF510
+
+#define S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6	0xF514
+
+#define S5P_FIMV_D_DISPLAY_CROP_INFO1_V6	0xF518
+#define S5P_FIMV_D_DISPLAY_CROP_INFO2_V6	0xF51C
+#define S5P_FIMV_D_DISPLAY_PICTURE_PROFILE_V6	0xF520
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_TOP_V6	0xF524
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_TOP_V6	0xF528
+#define S5P_FIMV_D_DISPLAY_LUMA_CRC_BOT_V6	0xF52C
+#define S5P_FIMV_D_DISPLAY_CHROMA_CRC_BOT_V6	0xF530
+#define S5P_FIMV_D_DISPLAY_ASPECT_RATIO_V6	0xF534
+#define S5P_FIMV_D_DISPLAY_EXTENDED_AR_V6	0xF538
+
+/* Decoded picture information register */
+#define S5P_FIMV_D_DECODED_FRAME_WIDTH_V6	0xF53C
+#define S5P_FIMV_D_DECODED_FRAME_HEIGHT_V6	0xF540
+#define S5P_FIMV_D_DECODED_STATUS_V6		0xF544
+#define S5P_FIMV_DEC_CRC_GEN_MASK_V6		0x1
+#define S5P_FIMV_DEC_CRC_GEN_SHIFT_V6		6
+
+#define S5P_FIMV_D_DECODED_LUMA_ADDR_V6		0xF548
+#define S5P_FIMV_D_DECODED_CHROMA_ADDR_V6	0xF54C
+
+#define S5P_FIMV_D_DECODED_FRAME_TYPE_V6	0xF550
+#define S5P_FIMV_DECODE_FRAME_MASK_V6		7
+
+#define S5P_FIMV_D_DECODED_CROP_INFO1_V6	0xF554
+#define S5P_FIMV_D_DECODED_CROP_INFO2_V6	0xF558
+#define S5P_FIMV_D_DECODED_PICTURE_PROFILE_V6	0xF55C
+#define S5P_FIMV_D_DECODED_NAL_SIZE_V6		0xF560
+#define S5P_FIMV_D_DECODED_LUMA_CRC_TOP_V6	0xF564
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_TOP_V6	0xF568
+#define S5P_FIMV_D_DECODED_LUMA_CRC_BOT_V6	0xF56C
+#define S5P_FIMV_D_DECODED_CHROMA_CRC_BOT_V6	0xF570
+
+/* Returned value register for specific setting */
+#define S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6		0xF574
+#define S5P_FIMV_D_RET_PICTURE_TAG_BOT_V6		0xF578
+#define S5P_FIMV_D_RET_PICTURE_TIME_TOP_V6		0xF57C
+#define S5P_FIMV_D_RET_PICTURE_TIME_BOT_V6		0xF580
+#define S5P_FIMV_D_CHROMA_FORMAT_V6			0xF588
+#define S5P_FIMV_D_MPEG4_INFO_V6			0xF58C
+#define S5P_FIMV_D_H264_INFO_V6				0xF590
+
+#define S5P_FIMV_D_METADATA_ADDR_CONCEALED_MB_V6	0xF594
+#define S5P_FIMV_D_METADATA_SIZE_CONCEALED_MB_V6	0xF598
+#define S5P_FIMV_D_METADATA_ADDR_VC1_PARAM_V6		0xF59C
+#define S5P_FIMV_D_METADATA_SIZE_VC1_PARAM_V6		0xF5A0
+#define S5P_FIMV_D_METADATA_ADDR_SEI_NAL_V6		0xF5A4
+#define S5P_FIMV_D_METADATA_SIZE_SEI_NAL_V6		0xF5A8
+#define S5P_FIMV_D_METADATA_ADDR_VUI_V6			0xF5AC
+#define S5P_FIMV_D_METADATA_SIZE_VUI_V6			0xF5B0
+
+#define S5P_FIMV_D_MVC_VIEW_ID_V6		0xF5B4
+
+/* SEI related information */
+#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6	0xF5F0
+#define S5P_FIMV_D_FRAME_PACK_ARRGMENT_ID_V6	0xF5F4
+#define S5P_FIMV_D_FRAME_PACK_SEI_INFO_V6	0xF5F8
+#define S5P_FIMV_D_FRAME_PACK_GRID_POS_V6	0xF5FC
+
+/* Encoder Registers */
+#define S5P_FIMV_E_FRAME_WIDTH_V6		0xF770
+#define S5P_FIMV_E_FRAME_HEIGHT_V6		0xF774
+#define S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6	0xF778
+#define S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6	0xF77C
+#define S5P_FIMV_E_FRAME_CROP_OFFSET_V6		0xF780
+#define S5P_FIMV_E_ENC_OPTIONS_V6		0xF784
+#define S5P_FIMV_E_PICTURE_PROFILE_V6		0xF788
+#define S5P_FIMV_E_FIXED_PICTURE_QP_V6		0xF790
+
+#define S5P_FIMV_E_RC_CONFIG_V6			0xF794
+#define S5P_FIMV_E_RC_QP_BOUND_V6		0xF798
+#define S5P_FIMV_E_RC_RPARAM_V6			0xF79C
+#define S5P_FIMV_E_MB_RC_CONFIG_V6		0xF7A0
+#define S5P_FIMV_E_PADDING_CTRL_V6		0xF7A4
+#define S5P_FIMV_E_MV_HOR_RANGE_V6		0xF7AC
+#define S5P_FIMV_E_MV_VER_RANGE_V6		0xF7B0
+
+#define S5P_FIMV_E_VBV_BUFFER_SIZE_V6		0xF84C
+#define S5P_FIMV_E_VBV_INIT_DELAY_V6		0xF850
+#define S5P_FIMV_E_NUM_DPB_V6			0xF890
+#define S5P_FIMV_E_LUMA_DPB_V6			0xF8C0
+#define S5P_FIMV_E_CHROMA_DPB_V6		0xF904
+#define S5P_FIMV_E_ME_BUFFER_V6			0xF948
+
+#define S5P_FIMV_E_SCRATCH_BUFFER_ADDR_V6	0xF98C
+#define S5P_FIMV_E_SCRATCH_BUFFER_SIZE_V6	0xF990
+#define S5P_FIMV_E_TMV_BUFFER0_V6		0xF994
+#define S5P_FIMV_E_TMV_BUFFER1_V6		0xF998
+#define S5P_FIMV_E_SOURCE_LUMA_ADDR_V6		0xF9F0
+#define S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6	0xF9F4
+#define S5P_FIMV_E_STREAM_BUFFER_ADDR_V6	0xF9F8
+#define S5P_FIMV_E_STREAM_BUFFER_SIZE_V6	0xF9FC
+#define S5P_FIMV_E_ROI_BUFFER_ADDR_V6		0xFA00
+
+#define S5P_FIMV_E_PARAM_CHANGE_V6		0xFA04
+#define S5P_FIMV_E_IR_SIZE_V6			0xFA08
+#define S5P_FIMV_E_GOP_CONFIG_V6		0xFA0C
+#define S5P_FIMV_E_MSLICE_MODE_V6		0xFA10
+#define S5P_FIMV_E_MSLICE_SIZE_MB_V6		0xFA14
+#define S5P_FIMV_E_MSLICE_SIZE_BITS_V6		0xFA18
+#define S5P_FIMV_E_FRAME_INSERTION_V6		0xFA1C
+
+#define S5P_FIMV_E_RC_FRAME_RATE_V6		0xFA20
+#define S5P_FIMV_E_RC_BIT_RATE_V6		0xFA24
+#define S5P_FIMV_E_RC_QP_OFFSET_V6		0xFA28
+#define S5P_FIMV_E_RC_ROI_CTRL_V6		0xFA2C
+#define S5P_FIMV_E_PICTURE_TAG_V6		0xFA30
+#define S5P_FIMV_E_BIT_COUNT_ENABLE_V6		0xFA34
+#define S5P_FIMV_E_MAX_BIT_COUNT_V6		0xFA38
+#define S5P_FIMV_E_MIN_BIT_COUNT_V6		0xFA3C
+
+#define S5P_FIMV_E_METADATA_BUFFER_ADDR_V6		0xFA40
+#define S5P_FIMV_E_METADATA_BUFFER_SIZE_V6		0xFA44
+#define S5P_FIMV_E_STREAM_SIZE_V6			0xFA80
+#define S5P_FIMV_E_SLICE_TYPE_V6			0xFA84
+#define S5P_FIMV_E_PICTURE_COUNT_V6			0xFA88
+#define S5P_FIMV_E_RET_PICTURE_TAG_V6			0xFA8C
+#define S5P_FIMV_E_STREAM_BUFFER_WRITE_POINTER_V6	0xFA90
+
+#define S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6		0xFA94
+#define S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6	0xFA98
+#define S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6		0xFA9C
+#define S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6		0xFAA0
+#define S5P_FIMV_E_METADATA_ADDR_ENC_SLICE_V6		0xFAA4
+#define S5P_FIMV_E_METADATA_SIZE_ENC_SLICE_V6		0xFAA8
+
+#define S5P_FIMV_E_MPEG4_OPTIONS_V6		0xFB10
+#define S5P_FIMV_E_MPEG4_HEC_PERIOD_V6		0xFB14
+#define S5P_FIMV_E_ASPECT_RATIO_V6		0xFB50
+#define S5P_FIMV_E_EXTENDED_SAR_V6		0xFB54
+
+#define S5P_FIMV_E_H264_OPTIONS_V6		0xFB58
+#define S5P_FIMV_E_H264_LF_ALPHA_OFFSET_V6	0xFB5C
+#define S5P_FIMV_E_H264_LF_BETA_OFFSET_V6	0xFB60
+#define S5P_FIMV_E_H264_I_PERIOD_V6		0xFB64
+
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE_V6		0xFB68
+#define S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6		0xFB6C
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR_V6		0xFB70
+#define S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1_V6	0xFB74
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0_V6		0xFB78
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_1_V6		0xFB7C
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_2_V6		0xFB80
+#define S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_3_V6		0xFB84
+
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_0_V6	0xFB88
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_1_V6	0xFB8C
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_2_V6	0xFB90
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_3_V6	0xFB94
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_4_V6	0xFB98
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_5_V6	0xFB9C
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_6_V6	0xFBA0
+#define S5P_FIMV_E_H264_ASO_SLICE_ORDER_7_V6	0xFBA4
+
+#define S5P_FIMV_E_H264_CHROMA_QP_OFFSET_V6	0xFBA8
+#define S5P_FIMV_E_H264_NUM_T_LAYER_V6		0xFBAC
+
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0_V6	0xFBB0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER1_V6	0xFBB4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER2_V6	0xFBB8
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER3_V6	0xFBBC
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER4_V6	0xFBC0
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER5_V6	0xFBC4
+#define S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER6_V6	0xFBC8
+
+#define S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6		0xFC4C
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE_V6	0
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TOP_BOTTOM_V6		1
+#define S5P_FIMV_ENC_FP_ARRANGEMENT_TYPE_TEMPORAL_V6		2
+
+#define S5P_FIMV_E_MVC_FRAME_QP_VIEW1_V6		0xFD40
+#define S5P_FIMV_E_MVC_RC_FRAME_RATE_VIEW1_V6		0xFD44
+#define S5P_FIMV_E_MVC_RC_BIT_RATE_VIEW1_V6		0xFD48
+#define S5P_FIMV_E_MVC_RC_QBOUND_VIEW1_V6		0xFD4C
+#define S5P_FIMV_E_MVC_RC_RPARA_VIEW1_V6		0xFD50
+#define S5P_FIMV_E_MVC_INTER_VIEW_PREDICTION_ON_V6	0xFD80
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
+#define S5P_FIMV_SI_DISPLAY_Y_ADR_V6		S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6
+#define S5P_FIMV_SI_DISPLAY_C_ADR_V6		S5P_FIMV_D_DISPLAY_CHROMA_ADDR_V6
+
+#define S5P_FIMV_CRC_LUMA0_V6			S5P_FIMV_D_DECODED_LUMA_CRC_TOP_V6
+#define S5P_FIMV_CRC_CHROMA0_V6			S5P_FIMV_D_DECODED_CHROMA_CRC_TOP_V6
+#define S5P_FIMV_CRC_LUMA1_V6			S5P_FIMV_D_DECODED_LUMA_CRC_BOT_V6
+#define S5P_FIMV_CRC_CHROMA1_V6			S5P_FIMV_D_DECODED_CHROMA_CRC_BOT_V6
+#define S5P_FIMV_CRC_DISP_LUMA0_V6		S5P_FIMV_D_DISPLAY_LUMA_CRC_TOP_V6
+#define S5P_FIMV_CRC_DISP_CHROMA0_V6		S5P_FIMV_D_DISPLAY_CHROMA_CRC_TOP_V6
+
+#define S5P_FIMV_SI_DECODED_STATUS_V6		S5P_FIMV_D_DECODED_STATUS_V6
+#define S5P_FIMV_SI_DISPLAY_STATUS_V6		S5P_FIMV_D_DISPLAY_STATUS_V6
+#define S5P_FIMV_SHARED_SET_FRAME_TAG_V6	S5P_FIMV_D_PICTURE_TAG_V6
+#define S5P_FIMV_SHARED_GET_FRAME_TAG_TOP_V6	S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6
+#define S5P_FIMV_CRC_DISP_STATUS_V6		S5P_FIMV_D_DISPLAY_STATUS_V6
+
+/* SEI related information */
+#define S5P_FIMV_FRAME_PACK_SEI_AVAIL_V6	S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6
+#define S5P_FIMV_FRAME_PACK_ARRGMENT_ID_V6	S5P_FIMV_D_FRAME_PACK_ARRGMENT_ID_V6
+#define S5P_FIMV_FRAME_PACK_SEI_INFO_V6		S5P_FIMV_D_FRAME_PACK_SEI_INFO_V6
+#define S5P_FIMV_FRAME_PACK_GRID_POS_V6		S5P_FIMV_D_FRAME_PACK_GRID_POS_V6
+
+#define S5P_FIMV_SHARED_SET_E_FRAME_TAG_V6	S5P_FIMV_E_PICTURE_TAG_V6
+#define S5P_FIMV_SHARED_GET_E_FRAME_TAG_V6	S5P_FIMV_E_RET_PICTURE_TAG_V6
+#define S5P_FIMV_ENCODED_LUMA_ADDR_V6		S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6
+#define S5P_FIMV_ENCODED_CHROMA_ADDR_V6		S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6
+#define	S5P_FIMV_FRAME_INSERTION_V6		S5P_FIMV_E_FRAME_INSERTION_V6
+
+#define S5P_FIMV_PARAM_CHANGE_FLAG_V6		S5P_FIMV_E_PARAM_CHANGE_V6 /* flag */
+#define S5P_FIMV_NEW_I_PERIOD_V6		S5P_FIMV_E_GOP_CONFIG_V6
+#define S5P_FIMV_NEW_RC_FRAME_RATE_V6		S5P_FIMV_E_RC_FRAME_RATE_V6
+#define S5P_FIMV_NEW_RC_BIT_RATE_V6		S5P_FIMV_E_RC_BIT_RATE_V6
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
+#define S5P_FIMV_FRAME_WIDTH_TO_MB_WIDTH_V6(w)		((w + 15) / 16)
+#define S5P_FIMV_FRAME_HEIGHT_TO_MB_HEIGHT_V6(h)	((h + 15) / 16)
+#define S5P_FIMV_MAX_FRAME_SIZE_V6			(2048 * 1024)
+#define S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6		16
+#define S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6		16
+
+/* Buffer size requirements defined by hardware */
+#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	((w + 1) * (h + 1) * 8)
+#define S5P_FIMV_ME_BUFFER_SIZE_V6(imw, imh, mbw, mbh) \
+						(((((imw+63)/64) * 16) * \
+						(((imh+63)/64) * 16)) + \
+						((((mbw*mbh)+31)/32) * 16))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(w, h)	((w * 192) + 64)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h) \
+						(w * (h * 64 + 144) + \
+						((2048 + 15)/16 * h * 64) + \
+						((2048 + 15)/16 * 256 + 8320))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(w, h)	(2096 * (w + h + 1))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	(w * 400)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(w, h) \
+						(w * 32 + h * 128 + 34816)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(w, h) \
+						((w * 64) + ((w + 1) * 16) + \
+						(4096 * 16))
+#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(w, h) \
+						((w * 16) + ((w + 1) * 16))
+
+#endif /* _REGS_FIMV_V6_H */
-- 
1.7.0.4

