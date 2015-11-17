Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53410 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661AbbKQMzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:18 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 3/8] media: platform: mtk-vpu: Support Mediatek VPU
Date: Tue, 17 Nov 2015 20:54:40 +0800
Message-ID: <1447764885-23100-4-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
It is able to handle video decoding/encoding of in a range of formats.
The driver provides with VPU firmware download, memory management and
the communication interface between CPU and VPU.
For VPU initialization, it will create virtual memory for CPU access and
IOMMU address for vcodec hw device access. When a decode/encode instance
opens a device node, vpu driver will download vpu firmware to the device.
A decode/encode instant will decode/encode a frame using VPU
interface to interrupt vpu to handle decoding/encoding jobs.

Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
---
 drivers/media/platform/Kconfig                     |    6 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-vpu/Makefile            |    1 +
 .../platform/mtk-vpu/h264_enc/venc_h264_vpu.h      |  127 +++
 .../media/platform/mtk-vpu/include/venc_ipi_msg.h  |  212 +++++
 drivers/media/platform/mtk-vpu/mtk_vpu_core.c      |  823 ++++++++++++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu_core.h      |  161 ++++
 .../media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h  |  119 +++
 8 files changed, 1451 insertions(+)
 create mode 100644 drivers/media/platform/mtk-vpu/Makefile
 create mode 100644 drivers/media/platform/mtk-vpu/h264_enc/venc_h264_vpu.h
 create mode 100644 drivers/media/platform/mtk-vpu/include/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu_core.c
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu_core.h
 create mode 100644 drivers/media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ccbc974..f98eb47 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -148,6 +148,12 @@ config VIDEO_CODA
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
 
+config MEDIATEK_VPU
+	bool "Mediatek Video Processor Unit"
+	---help---
+	    This driver provides downloading firmware vpu and
+	    communicating with vpu.
+
 config VIDEO_MEM2MEM_DEINTERLACE
 	tristate "Deinterlace support"
 	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index efa0295..1b4c539 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -55,3 +55,5 @@ obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 
 ccflags-y += -I$(srctree)/drivers/media/i2c
+
+obj-$(CONFIG_MEDIATEK_VPU)		+= mtk-vpu/
diff --git a/drivers/media/platform/mtk-vpu/Makefile b/drivers/media/platform/mtk-vpu/Makefile
new file mode 100644
index 0000000..5de84d1
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MEDIATEK_VPU) += mtk_vpu_core.o
diff --git a/drivers/media/platform/mtk-vpu/h264_enc/venc_h264_vpu.h b/drivers/media/platform/mtk-vpu/h264_enc/venc_h264_vpu.h
new file mode 100644
index 0000000..9c8ebdd
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/h264_enc/venc_h264_vpu.h
@@ -0,0 +1,127 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef VENC_H264_VPU_H_
+#define VENC_H264_VPU_H_
+
+/**
+ * enum venc_h264_vpu_work_buf - h264 encoder buffer index
+ */
+enum venc_h264_vpu_work_buf {
+	VENC_H264_VPU_WORK_BUF_RC_INFO,
+	VENC_H264_VPU_WORK_BUF_RC_CODE,
+	VENC_H264_VPU_WORK_BUF_REC_LUMA,
+	VENC_H264_VPU_WORK_BUF_REC_CHROMA,
+	VENC_H264_VPU_WORK_BUF_REF_LUMA,
+	VENC_H264_VPU_WORK_BUF_REF_CHROMA,
+	VENC_H264_VPU_WORK_BUF_MV_INFO_1,
+	VENC_H264_VPU_WORK_BUF_MV_INFO_2,
+	VENC_H264_VPU_WORK_BUF_SKIP_FRAME,
+	VENC_H264_VPU_WORK_BUF_MAX,
+};
+
+/**
+ * enum venc_h264_bs_mode - for bs_mode argument in h264_enc_vpu_encode
+ */
+enum venc_h264_bs_mode {
+	H264_BS_MODE_SPS,
+	H264_BS_MODE_PPS,
+	H264_BS_MODE_FRAME,
+};
+
+/*
+ * struct venc_h264_vpu_config - Structure for h264 encoder configuration
+ * @input_fourcc: input fourcc
+ * @bitrate: target bitrate (in bps)
+ * @pic_w: picture width
+ * @pic_h: picture height
+ * @buf_w: buffer width
+ * @buf_h: buffer height
+ * @intra_period: intra frame period
+ * @framerate: frame rate
+ * @profile: as specified in standard
+ * @level: as specified in standard
+ * @wfd: WFD mode 1:on, 0:off
+ */
+struct venc_h264_vpu_config {
+	u32 input_fourcc;
+	u32 bitrate;
+	u32 pic_w;
+	u32 pic_h;
+	u32 buf_w;
+	u32 buf_h;
+	u32 intra_period;
+	u32 framerate;
+	u32 profile;
+	u32 level;
+	u32 wfd;
+};
+
+/*
+ * struct venc_h264_vpu_buf - Structure for buffer information
+ * @align: buffer alignment (in bytes)
+ * @pa: physical address
+ * @vpua: VPU side memory addr which is used by RC_CODE
+ * @size: buffer size (in bytes)
+ */
+struct venc_h264_vpu_buf {
+	u32 align;
+	u32 pa;
+	u32 vpua;
+	u32 size;
+};
+
+/*
+ * struct venc_h264_vpu_drv - Structure for VPU driver control and info share
+ * @config: h264 encoder configuration
+ * @work_bufs: working buffer information
+ */
+struct venc_h264_vpu_drv {
+	struct venc_h264_vpu_config config;
+	struct venc_h264_vpu_buf work_bufs[VENC_H264_VPU_WORK_BUF_MAX];
+};
+
+/*
+ * struct venc_h264_vpu_inst - h264 encoder VPU driver instance
+ * @wq_hd: wait queue used for vpu cmd trigger then wait vpu interrupt done
+ * @signaled: flag used for checking vpu interrupt done
+ * @failure: flag to show vpu cmd succeeds or not
+ * @state: enum venc_ipi_msg_enc_state
+ * @bs_size: bitstream size for skip frame case usage
+ * @wait_int: flag to wait interrupt done (0: for skip frame case, 1: normal case)
+ * @id: VPU instance id
+ * @drv: driver structure allocated by VPU side for control and info share
+ */
+struct venc_h264_vpu_inst {
+	wait_queue_head_t wq_hd;
+	int signaled;
+	int failure;
+	int state;
+	int bs_size;
+	int wait_int;
+	unsigned int id;
+	struct venc_h264_vpu_drv *drv;
+};
+
+int h264_enc_vpu_init(void *handle);
+int h264_enc_vpu_set_param(void *handle, unsigned int id, void *param);
+int h264_enc_vpu_encode(void *handle, unsigned int bs_mode,
+			struct venc_frm_buf *frm_buf,
+			struct mtk_vcodec_mem *bs_buf,
+			unsigned int *bs_size);
+int h264_enc_vpu_deinit(void *handle);
+
+#endif
diff --git a/drivers/media/platform/mtk-vpu/include/venc_ipi_msg.h b/drivers/media/platform/mtk-vpu/include/venc_ipi_msg.h
new file mode 100644
index 0000000..a345b98
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/include/venc_ipi_msg.h
@@ -0,0 +1,212 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_IPI_MSG_H_
+#define _VENC_IPI_MSG_H_
+
+#define IPIMSG_H264_ENC_ID 0x100
+#define IPIMSG_VP8_ENC_ID 0x200
+
+#define AP_IPIMSG_VENC_BASE 0x20000
+#define VPU_IPIMSG_VENC_BASE 0x30000
+
+/**
+ * enum venc_ipi_msg_id - message id between AP and VPU
+ * (ipi stands for inter-processor interrupt)
+ * @AP_IPIMSG_XXX:		AP to VPU cmd message id
+ * @VPU_IPIMSG_XXX_DONE:	VPU ack AP cmd message id
+ */
+enum venc_ipi_msg_id {
+	AP_IPIMSG_H264_ENC_INIT = AP_IPIMSG_VENC_BASE +
+				  IPIMSG_H264_ENC_ID,
+	AP_IPIMSG_H264_ENC_SET_PARAM,
+	AP_IPIMSG_H264_ENC_ENCODE,
+	AP_IPIMSG_H264_ENC_DEINIT,
+
+	AP_IPIMSG_VP8_ENC_INIT = AP_IPIMSG_VENC_BASE +
+				 IPIMSG_VP8_ENC_ID,
+	AP_IPIMSG_VP8_ENC_SET_PARAM,
+	AP_IPIMSG_VP8_ENC_ENCODE,
+	AP_IPIMSG_VP8_ENC_DEINIT,
+
+	VPU_IPIMSG_H264_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
+					IPIMSG_H264_ENC_ID,
+	VPU_IPIMSG_H264_ENC_SET_PARAM_DONE,
+	VPU_IPIMSG_H264_ENC_ENCODE_DONE,
+	VPU_IPIMSG_H264_ENC_DEINIT_DONE,
+
+	VPU_IPIMSG_VP8_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
+				       IPIMSG_VP8_ENC_ID,
+	VPU_IPIMSG_VP8_ENC_SET_PARAM_DONE,
+	VPU_IPIMSG_VP8_ENC_ENCODE_DONE,
+	VPU_IPIMSG_VP8_ENC_DEINIT_DONE,
+};
+
+/**
+ * struct venc_ap_ipi_msg_init - AP to VPU init cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_INIT)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_ap_ipi_msg_init {
+	uint32_t msg_id;
+	uint32_t reserved;
+	uint64_t venc_inst;
+};
+
+/**
+ * struct venc_ap_ipi_msg_set_param - AP to VPU set_param cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_SET_PARAM)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ * @param_id:	parameter id (venc_set_param_type)
+ * @data_item:	number of items in the data array
+ * @data[8]:	data array to store the set parameters
+ */
+struct venc_ap_ipi_msg_set_param {
+	uint32_t msg_id;
+	uint32_t inst_id;
+	uint32_t param_id;
+	uint32_t data_item;
+	uint32_t data[8];
+};
+
+/**
+ * struct venc_ap_ipi_msg_enc - AP to VPU enc cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_ENCODE)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ * @bs_mode:	bitstream mode for h264
+ *		(H264_BS_MODE_SPS/H264_BS_MODE_PPS/H264_BS_MODE_FRAME)
+ * @input_addr:	pointer to input image buffer plane
+ * @bs_addr:	pointer to output bit stream buffer
+ * @bs_size:	bit stream buffer size
+ */
+struct venc_ap_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t inst_id;
+	uint32_t bs_mode;
+	uint32_t input_addr[3];
+	uint32_t bs_addr;
+	uint32_t bs_size;
+};
+
+/**
+ * struct venc_ap_ipi_msg_deinit - AP to VPU deinit cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_DEINIT)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ */
+struct venc_ap_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t inst_id;
+};
+
+/**
+ * enum venc_ipi_msg_status - VPU ack AP cmd status
+ */
+enum venc_ipi_msg_status {
+	VENC_IPI_MSG_STATUS_OK,
+	VENC_IPI_MSG_STATUS_FAIL,
+};
+
+/**
+ * struct venc_vpu_ipi_msg_common - VPU ack AP cmd common structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_vpu_ipi_msg_common {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_init - VPU ack AP init cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ */
+struct venc_vpu_ipi_msg_init {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t inst_id;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_set_param - VPU ack AP set_param cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @param_id:	parameter id (venc_set_param_type)
+ * @data_item:	number of items in the data array
+ * @data[6]:	data array to store the return result
+ */
+struct venc_vpu_ipi_msg_set_param {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t param_id;
+	uint32_t data_item;
+	uint32_t data[6];
+};
+
+/**
+ * enum venc_ipi_msg_enc_state - Type of encode state
+ * VEN_IPI_MSG_ENC_STATE_FRAME:	one frame being encoded
+ * VEN_IPI_MSG_ENC_STATE_PART:	bit stream buffer full
+ * VEN_IPI_MSG_ENC_STATE_SKIP:	encoded skip frame
+ * VEN_IPI_MSG_ENC_STATE_ERROR:	encounter error
+ */
+enum venc_ipi_msg_enc_state {
+	VEN_IPI_MSG_ENC_STATE_FRAME,
+	VEN_IPI_MSG_ENC_STATE_PART,
+	VEN_IPI_MSG_ENC_STATE_SKIP,
+	VEN_IPI_MSG_ENC_STATE_ERROR,
+};
+
+/**
+ * struct venc_vpu_ipi_msg_enc - VPU ack AP enc cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_ENCODE_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @state:	encode state (venc_ipi_msg_enc_state)
+ * @key_frame:	whether the encoded frame is key frame
+ * @bs_size:	encoded bitstream size
+ */
+struct venc_vpu_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t state;
+	uint32_t key_frame;
+	uint32_t bs_size;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_deinit - VPU ack AP deinit cmd structure
+ * @msg_id:   message id (VPU_IPIMSG_XXX_ENC_DEINIT_DONE)
+ * @status:   cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_vpu_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+};
+
+#endif /* _VENC_IPI_MSG_H_ */
diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu_core.c b/drivers/media/platform/mtk-vpu/mtk_vpu_core.c
new file mode 100644
index 0000000..b524dbc
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu_core.c
@@ -0,0 +1,823 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/sched.h>
+#include <linux/sizes.h>
+
+#include "mtk_vpu_core.h"
+
+/**
+ * VPU (video processor unit) is a tiny processor controlling video hardware
+ * related to video codec, scaling and color format converting.
+ * VPU interfaces with other blocks by share memory and interrupt.
+ **/
+#define MTK_VPU_DRV_NAME	"mtk_vpu"
+
+#define INIT_TIMEOUT_MS		2000U
+#define IPI_TIMEOUT_MS		2000U
+#define VPU_FW_VER_LEN		16
+
+/* vpu extended virtural address */
+#define VPU_PMEM0_VIRT(vpu)	((vpu)->mem.p_va)
+#define VPU_DMEM0_VIRT(vpu)	((vpu)->mem.d_va)
+/* vpu extended iova address*/
+#define VPU_PMEM0_IOVA(vpu)	((vpu)->mem.p_iova)
+#define VPU_DMEM0_IOVA(vpu)	((vpu)->mem.d_iova)
+
+#define VPU_PTCM(dev)		((dev)->reg.sram)
+#define VPU_DTCM(dev)		((dev)->reg.sram + VPU_DTCM_OFFSET)
+
+#define VPU_PTCM_SIZE		(96 * SZ_1K)
+#define VPU_DTCM_SIZE		(32 * SZ_1K)
+#define VPU_DTCM_OFFSET		0x18000UL
+#define VPU_EXT_P_SIZE		SZ_1M
+#define VPU_EXT_D_SIZE		SZ_4M
+#define VPU_P_FW_SIZE		(VPU_PTCM_SIZE + VPU_EXT_P_SIZE)
+#define VPU_D_FW_SIZE		(VPU_DTCM_SIZE + VPU_EXT_D_SIZE)
+#define SHARE_BUF_SIZE		48
+
+#define VPU_P_FW		"vpu_p.bin"
+#define VPU_D_FW		"vpu_d.bin"
+
+#define VPU_BASE		0x0
+#define VPU_TCM_CFG		0x0008
+#define VPU_PMEM_EXT0_ADDR	0x000C
+#define VPU_PMEM_EXT1_ADDR	0x0010
+#define VPU_TO_HOST		0x001C
+#define VPU_DMEM_EXT0_ADDR	0x0014
+#define VPU_DMEM_EXT1_ADDR	0x0018
+#define HOST_TO_VPU		0x0024
+#define VPU_PC_REG		0x0060
+#define VPU_WDT_REG		0x0084
+
+/* vpu inter-processor communication interrupt */
+#define VPU_IPC_INT		BIT(8)
+
+/**
+ * enum vpu_fw_type - VPU firmware type
+ *
+ * @P_FW: program firmware
+ * @D_FW: data firmware
+ *
+ */
+enum vpu_fw_type {
+	P_FW,
+	D_FW,
+};
+
+/**
+ * struct vpu_mem - VPU memory information
+ *
+ * @p_va:	the kernel virtual memory address of
+ *		VPU extended program memory
+ * @d_va:	the kernel virtual memory address of VPU extended data memory
+ * @p_iova:	the iova memory address of VPU extended program memory
+ * @d_iova:	the iova memory address of VPU extended data memory
+ */
+struct vpu_mem {
+	void *p_va;
+	void *d_va;
+	dma_addr_t p_iova;
+	dma_addr_t d_iova;
+};
+
+/**
+ * struct vpu_regs - VPU SRAM and configuration registers
+ *
+ * @sram:	the register for VPU sram
+ * @cfg:	the register for VPU configuration
+ * @irq:	the irq number for VPU interrupt
+ */
+struct vpu_regs {
+	void __iomem *sram;
+	void __iomem *cfg;
+	int irq;
+};
+
+/**
+ * struct vpu_run - VPU initialization status
+ *
+ * @signaled:	the signal of vpu initialization completed
+ * @fw_ver:	VPU firmware version
+ * @wq:		wait queue for VPU initialization status
+ */
+struct vpu_run {
+	u32 signaled;
+	char fw_ver[VPU_FW_VER_LEN];
+	wait_queue_head_t wq;
+};
+
+/**
+ * struct vpu_ipi_desc - VPU IPI descriptor
+ *
+ * @handler:	IPI handler
+ * @name:	the name of IPI handler
+ * @priv:	the private data of IPI handler
+ */
+struct vpu_ipi_desc {
+	ipi_handler_t handler;
+	const char *name;
+	void *priv;
+};
+
+/**
+ * struct share_obj - The DTCM (Data Tightly-Coupled Memory) buffer shared with
+ *		      AP and VPU
+ *
+ * @id:		IPI id
+ * @len:	share buffer length
+ * @share_buf:	share buffer data
+ */
+struct share_obj {
+	int32_t id;
+	uint32_t len;
+	unsigned char share_buf[SHARE_BUF_SIZE];
+};
+
+/**
+ * struct mtk_vpu - vpu driver data
+ * @mem:		VPU extended memory information
+ * @reg:		VPU SRAM and configuration registers
+ * @run:		VPU initialization status
+ * @ipi_desc:		VPU IPI descriptor
+ * @recv_buf:		VPU DTCM share buffer for receiving. The
+ *			receive buffer is only accessed in interrupt context.
+ * @send_buf:		VPU DTCM share buffer for sending
+ * @dev:		VPU struct device
+ * @clk:		VPU clock on/off
+ * @vpu_mutex:		protect mtk_vpu (except recv_buf) and ensure only
+ *			one client to use VPU service at a time. For example,
+ *			suppose a client is using VPU to decode VP8.
+ *			If the other client wants to encode VP8,
+ *			it has to wait until VP8 decode completes.
+ *
+ */
+struct mtk_vpu {
+	struct vpu_mem mem;
+	struct vpu_regs reg;
+	struct vpu_run run;
+	struct vpu_ipi_desc ipi_desc[IPI_MAX];
+	struct share_obj *recv_buf;
+	struct share_obj *send_buf;
+	struct device *dev;
+	struct clk *clk;
+	struct mutex vpu_mutex; /* for protecting vpu data data structure */
+};
+
+/* the thread calls the function should hold the |vpu_mutex| */
+static inline void vpu_cfg_writel(struct mtk_vpu *vpu, u32 val, u32 offset)
+{
+	writel(val, vpu->reg.cfg + offset);
+}
+
+static inline u32 vpu_cfg_readl(struct mtk_vpu *vpu, u32 offset)
+{
+	return readl(vpu->reg.cfg + offset);
+}
+
+static inline bool vpu_running(struct mtk_vpu *vpu)
+{
+	return vpu_cfg_readl(vpu, VPU_BASE) & BIT(0);
+}
+
+void vpu_disable_clock(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+
+	/* Disable VPU watchdog */
+	vpu_cfg_writel(vpu,
+		       vpu_cfg_readl(vpu, VPU_WDT_REG) & ~(1L<<31),
+		       VPU_WDT_REG);
+
+	clk_disable_unprepare(vpu->clk);
+}
+
+int vpu_enable_clock(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = clk_prepare_enable(vpu->clk);
+	if (ret)
+		return ret;
+	/* Enable VPU watchdog */
+	vpu_cfg_writel(vpu, vpu_cfg_readl(vpu, VPU_WDT_REG) | (1L << 31),
+		       VPU_WDT_REG);
+
+	return ret;
+}
+
+int vpu_ipi_register(struct platform_device *pdev,
+		     enum ipi_id id, ipi_handler_t handler,
+		     const char *name, void *priv)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	struct vpu_ipi_desc *ipi_desc;
+
+	if (!vpu) {
+		dev_err(&pdev->dev, "vpu device in not ready\n");
+		return -EPROBE_DEFER;
+	}
+
+	if (id < IPI_MAX && handler != NULL) {
+		ipi_desc = vpu->ipi_desc;
+		ipi_desc[id].name = name;
+		ipi_desc[id].handler = handler;
+		ipi_desc[id].priv = priv;
+		return 0;
+	}
+
+	dev_err(&pdev->dev, "register vpu ipi with invalid arguments\n");
+	return -EINVAL;
+}
+
+int vpu_ipi_send(struct platform_device *pdev,
+		 enum ipi_id id, void *buf,
+		 unsigned int len, unsigned int wait)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	struct share_obj *send_obj = vpu->send_buf;
+	unsigned long timeout;
+
+	if (id >= IPI_MAX || len > sizeof(send_obj->share_buf) || buf == NULL) {
+		dev_err(vpu->dev, "failed to send ipi message\n");
+		return -EINVAL;
+	}
+
+	if (!vpu_running(vpu)) {
+		dev_err(vpu->dev, "vpu_ipi_send: VPU is not running\n");
+		return -ENXIO;
+	}
+
+	mutex_lock(&vpu->vpu_mutex);
+	if (vpu_cfg_readl(vpu, HOST_TO_VPU) && !wait) {
+		mutex_unlock(&vpu->vpu_mutex);
+		return -EBUSY;
+	}
+
+	if (wait)
+		while (vpu_cfg_readl(vpu, HOST_TO_VPU))
+			;
+
+	memcpy((void *)send_obj->share_buf, buf, len);
+	send_obj->len = len;
+	send_obj->id = id;
+	vpu_cfg_writel(vpu, 0x1, HOST_TO_VPU);
+
+	/* Wait until VPU receives the command */
+	timeout = jiffies + msecs_to_jiffies(IPI_TIMEOUT_MS);
+	do {
+		if (time_after(jiffies, timeout)) {
+			dev_err(vpu->dev, "vpu_ipi_send: IPI timeout!\n");
+			return -EIO;
+		}
+	} while (vpu_cfg_readl(vpu, HOST_TO_VPU));
+
+	mutex_unlock(&vpu->vpu_mutex);
+
+	return 0;
+}
+
+void *vpu_mapping_dm_addr(struct platform_device *pdev,
+			  void *dtcm_dmem_addr)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	unsigned long p_vpu_dtcm = (unsigned long)VPU_DTCM(vpu);
+	unsigned long ul_dtcm_dmem_addr = (unsigned long)(dtcm_dmem_addr);
+
+	if (dtcm_dmem_addr == NULL ||
+	    (ul_dtcm_dmem_addr > (VPU_DTCM_SIZE + VPU_EXT_D_SIZE))) {
+		dev_err(vpu->dev, "invalid virtual data memory address\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (ul_dtcm_dmem_addr < VPU_DTCM_SIZE)
+		return (void *)(ul_dtcm_dmem_addr + p_vpu_dtcm);
+
+	return (void *)((ul_dtcm_dmem_addr - VPU_DTCM_SIZE) +
+		VPU_DMEM0_VIRT(vpu));
+}
+
+dma_addr_t *vpu_mapping_iommu_dm_addr(struct platform_device *pdev,
+				      void *dmem_addr)
+{
+	unsigned long ul_dmem_addr = (unsigned long)(dmem_addr);
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+
+	if (dmem_addr == NULL ||
+	    (ul_dmem_addr < VPU_DTCM_SIZE) ||
+	    (ul_dmem_addr > (VPU_DTCM_SIZE + VPU_EXT_D_SIZE))) {
+		dev_err(vpu->dev, "invalid IOMMU data memory address\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return (dma_addr_t *)((ul_dmem_addr - VPU_DTCM_SIZE) +
+			       VPU_DMEM0_IOVA(vpu));
+}
+
+struct platform_device *vpu_get_plat_device(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *vpu_node;
+	struct platform_device *vpu_pdev;
+
+	vpu_node = of_parse_phandle(dev->of_node, "vpu", 0);
+	if (!vpu_node) {
+		dev_err(dev, "can't get vpu node\n");
+		return NULL;
+	}
+
+	vpu_pdev = of_find_device_by_node(vpu_node);
+	if (WARN_ON(!vpu_pdev)) {
+		dev_err(dev, "vpu pdev failed\n");
+		of_node_put(vpu_node);
+		return NULL;
+	}
+
+	return vpu_pdev;
+}
+
+/* load vpu program/data memory */
+static void load_requested_vpu(struct mtk_vpu *vpu,
+			       size_t fw_size,
+			       const u8 *fw_data,
+			       u8 fw_type)
+{
+	size_t target_size = fw_type ? VPU_DTCM_SIZE : VPU_PTCM_SIZE;
+	size_t extra_fw_size = 0;
+	void *dest;
+
+	/* reset VPU */
+	vpu_cfg_writel(vpu, 0x0, VPU_BASE);
+
+	/* handle extended firmware size */
+	if (fw_size > target_size) {
+		dev_dbg(vpu->dev, "fw size %lx > limited fw size %lx\n",
+			fw_size, target_size);
+		extra_fw_size = fw_size - target_size;
+		dev_dbg(vpu->dev, "extra_fw_size %lx\n", extra_fw_size);
+		fw_size = target_size;
+	}
+	dest = fw_type ? VPU_DTCM(vpu) : VPU_PTCM(vpu);
+	memcpy(dest, fw_data, fw_size);
+	/* download to extended memory if need */
+	if (extra_fw_size > 0) {
+		dest = fw_type ?
+			VPU_DMEM0_VIRT(vpu) : VPU_PMEM0_VIRT(vpu);
+
+		dev_dbg(vpu->dev, "download extended memory type %x\n",
+			fw_type);
+		memcpy(dest, fw_data + target_size, extra_fw_size);
+	}
+}
+
+int vpu_load_firmware(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct vpu_run *run = &vpu->run;
+	const struct firmware *vpu_fw;
+	int ret;
+
+	if (!pdev) {
+		dev_err(dev, "VPU platform device is invalid\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&vpu->vpu_mutex);
+
+	ret = vpu_enable_clock(pdev);
+	if (ret) {
+		dev_err(dev, "enable clock failed %d\n", ret);
+		goto OUT_LOAD_FW;
+	}
+
+	if (vpu_running(vpu)) {
+		vpu_disable_clock(pdev);
+		mutex_unlock(&vpu->vpu_mutex);
+		dev_warn(dev, "vpu is running already\n");
+		return 0;
+	}
+
+	run->signaled = false;
+	dev_dbg(vpu->dev, "firmware request\n");
+	ret = request_firmware(&vpu_fw, VPU_P_FW, dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to load %s, %d\n", VPU_P_FW, ret);
+		goto OUT_LOAD_FW;
+	}
+	if (vpu_fw->size > VPU_P_FW_SIZE) {
+		ret = -EFBIG;
+		dev_err(dev, "program fw size %zu is abnormal\n", vpu_fw->size);
+		goto OUT_LOAD_FW;
+	}
+	dev_dbg(vpu->dev, "Downloaded program fw size: %zu.\n",
+		vpu_fw->size);
+	/* Downloading program firmware to device*/
+	load_requested_vpu(vpu, vpu_fw->size, vpu_fw->data,
+			   P_FW);
+	release_firmware(vpu_fw);
+
+	ret = request_firmware(&vpu_fw, VPU_D_FW, dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to load %s, %d\n", VPU_D_FW, ret);
+		goto OUT_LOAD_FW;
+	}
+	if (vpu_fw->size > VPU_D_FW_SIZE) {
+		ret = -EFBIG;
+		dev_err(dev, "data fw size %zu is abnormal\n", vpu_fw->size);
+		goto OUT_LOAD_FW;
+	}
+	dev_dbg(vpu->dev, "Downloaded data fw size: %zu.\n",
+		vpu_fw->size);
+	/* Downloading data firmware to device */
+	load_requested_vpu(vpu, vpu_fw->size, vpu_fw->data,
+			   D_FW);
+	release_firmware(vpu_fw);
+	/* boot up vpu */
+	vpu_cfg_writel(vpu, 0x1, VPU_BASE);
+
+	ret = wait_event_interruptible_timeout(run->wq,
+					       run->signaled,
+					       msecs_to_jiffies(INIT_TIMEOUT_MS)
+					       );
+	if (0 == ret) {
+		ret = -ETIME;
+		dev_err(dev, "wait vpu initialization timout!\n");
+		goto OUT_LOAD_FW;
+	} else if (-ERESTARTSYS == ret) {
+		dev_err(dev, "wait vpu interrupted by a signal!\n");
+		goto OUT_LOAD_FW;
+	}
+
+	ret = 0;
+	dev_info(dev, "vpu is ready. Fw version %s\n", run->fw_ver);
+
+OUT_LOAD_FW:
+	vpu_disable_clock(pdev);
+	mutex_unlock(&vpu->vpu_mutex);
+
+	return ret;
+}
+
+static void vpu_init_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct mtk_vpu *vpu = (struct mtk_vpu *)priv;
+	struct vpu_run *run = (struct vpu_run *)data;
+
+	vpu->run.signaled = run->signaled;
+	strncpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);
+	wake_up_interruptible(&vpu->run.wq);
+}
+
+static int vpu_debug_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t vpu_debug_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	char buf[256];
+	unsigned int len;
+	unsigned int running, pc, vpu_to_host, host_to_vpu, wdt;
+	int ret;
+	struct device *dev = file->private_data;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtk_vpu *vpu = dev_get_drvdata(dev);
+
+	ret = vpu_enable_clock(pdev);
+	if (ret) {
+		dev_err(vpu->dev, "[VPU] enable clock failed %d\n", ret);
+		return 0;
+	}
+
+	/* vpu register status */
+	running = vpu_running(vpu);
+	pc = vpu_cfg_readl(vpu, VPU_PC_REG);
+	wdt = vpu_cfg_readl(vpu, VPU_WDT_REG);
+	host_to_vpu = vpu_cfg_readl(vpu, HOST_TO_VPU);
+	vpu_to_host = vpu_cfg_readl(vpu, VPU_TO_HOST);
+	vpu_disable_clock(pdev);
+
+	if (running) {
+		len = sprintf(buf, "VPU is running\n\n"
+		"FW Version: %s\n"
+		"PC: 0x%x\n"
+		"WDT: 0x%x\n"
+		"Host to VPU: 0x%x\n"
+		"VPU to Host: 0x%x\n",
+		vpu->run.fw_ver, pc, wdt,
+		host_to_vpu, vpu_to_host);
+	} else {
+		len = sprintf(buf, "VPU not running\n");
+	}
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations vpu_debug_fops = {
+	.open = vpu_debug_open,
+	.read = vpu_debug_read,
+};
+
+static void vpu_free_p_ext_mem(struct mtk_vpu *vpu)
+{
+	struct device *dev = vpu->dev;
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+
+	dma_free_coherent(dev, VPU_EXT_P_SIZE, VPU_PMEM0_VIRT(vpu),
+			  VPU_PMEM0_IOVA(vpu));
+
+	if (domain)
+		iommu_detach_device(domain, vpu->dev);
+}
+
+static void vpu_free_d_ext_mem(struct mtk_vpu *vpu)
+{
+	struct device *dev = vpu->dev;
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+
+	dma_free_coherent(dev, VPU_EXT_D_SIZE, VPU_DMEM0_VIRT(vpu),
+			  VPU_DMEM0_IOVA(vpu));
+
+	if (domain)
+		iommu_detach_device(domain, dev);
+}
+
+static int vpu_alloc_p_ext_mem(struct mtk_vpu *vpu)
+{
+	struct device *dev = vpu->dev;
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+	phys_addr_t p_pa;
+
+	VPU_PMEM0_VIRT(vpu) = dma_alloc_coherent(dev,
+						 VPU_EXT_P_SIZE,
+						 &(VPU_PMEM0_IOVA(vpu)),
+						 GFP_KERNEL);
+	if (VPU_PMEM0_VIRT(vpu) == NULL) {
+		dev_err(dev, "Failed to allocate the extended program memory\n");
+		return PTR_ERR(VPU_PMEM0_VIRT(vpu));
+	}
+
+	p_pa = iommu_iova_to_phys(domain, vpu->mem.p_iova);
+	/* Disable extend0. Enable extend1 */
+	vpu_cfg_writel(vpu, 0x1, VPU_PMEM_EXT0_ADDR);
+	vpu_cfg_writel(vpu, (p_pa & 0xFFFFF000), VPU_PMEM_EXT1_ADDR);
+
+	dev_info(dev, "Program extend memory phy=0x%llx virt=0x%p iova=0x%llx\n",
+		 (unsigned long long)p_pa,
+		 VPU_PMEM0_VIRT(vpu),
+		 (unsigned long long)VPU_PMEM0_IOVA(vpu));
+
+	return 0;
+}
+
+static int vpu_alloc_d_ext_mem(struct mtk_vpu *vpu)
+{
+	struct device *dev = vpu->dev;
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+	phys_addr_t d_pa;
+
+	VPU_DMEM0_VIRT(vpu) = dma_alloc_coherent(dev,
+						 VPU_EXT_D_SIZE,
+						 &(VPU_DMEM0_IOVA(vpu)),
+						 GFP_KERNEL);
+	if (VPU_DMEM0_VIRT(vpu) == NULL) {
+		dev_err(dev, "Failed to allocate the extended data memory\n");
+		return PTR_ERR(VPU_DMEM0_VIRT(vpu));
+	}
+
+	d_pa = iommu_iova_to_phys(domain, vpu->mem.d_iova);
+
+	/* Disable extend0. Enable extend1 */
+	vpu_cfg_writel(vpu, 0x1, VPU_DMEM_EXT0_ADDR);
+	vpu_cfg_writel(vpu, (d_pa & 0xFFFFF000),
+		       VPU_DMEM_EXT1_ADDR);
+
+	dev_info(dev, "Data extend memory phy=0x%llx virt=0x%p iova=0x%llx\n",
+		 (unsigned long long)d_pa,
+		 VPU_DMEM0_VIRT(vpu),
+		 (unsigned long long)VPU_DMEM0_IOVA(vpu));
+
+	return 0;
+}
+
+static void vpu_ipi_handler(struct mtk_vpu *vpu)
+{
+	struct share_obj *rcv_obj = vpu->recv_buf;
+	struct vpu_ipi_desc *ipi_desc = vpu->ipi_desc;
+
+	if (rcv_obj->id < IPI_MAX && ipi_desc[rcv_obj->id].handler) {
+		ipi_desc[rcv_obj->id].handler(rcv_obj->share_buf,
+					      rcv_obj->len,
+					      ipi_desc[rcv_obj->id].priv);
+	} else {
+		dev_err(vpu->dev, "No such ipi id = %d\n", rcv_obj->id);
+	}
+}
+
+static int vpu_ipi_init(struct mtk_vpu *vpu)
+{
+	/* Disable VPU to host interrupt */
+	vpu_cfg_writel(vpu, 0x0, VPU_TO_HOST);
+
+	/* shared buffer initialization */
+	vpu->recv_buf = (struct share_obj *)VPU_DTCM(vpu);
+	vpu->send_buf = vpu->recv_buf + 1;
+	memset(vpu->recv_buf, 0, sizeof(struct share_obj));
+	memset(vpu->send_buf, 0, sizeof(struct share_obj));
+	mutex_init(&vpu->vpu_mutex);
+
+	return 0;
+}
+
+static irqreturn_t vpu_irq_handler(int irq, void *priv)
+{
+	struct mtk_vpu *vpu = priv;
+	uint32_t vpu_to_host = vpu_cfg_readl(vpu, VPU_TO_HOST);
+
+	if (vpu_to_host & VPU_IPC_INT)
+		vpu_ipi_handler(vpu);
+	else
+		dev_err(vpu->dev, "vpu watchdog timeout!\n");
+
+	/* VPU won't send another interrupt until we set VPU_TO_HOST to 0. */
+	vpu_cfg_writel(vpu, 0x0, VPU_TO_HOST);
+
+	return IRQ_HANDLED;
+}
+
+static struct dentry *vpu_debugfs;
+static int mtk_vpu_probe(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu;
+	struct device *dev;
+	struct resource *res;
+	int ret = 0;
+
+	dev_dbg(&pdev->dev, "initialization\n");
+
+	dev = &pdev->dev;
+	vpu = devm_kzalloc(dev, sizeof(*vpu), GFP_KERNEL);
+	if (!vpu)
+		return -ENOMEM;
+
+	vpu->dev = &pdev->dev;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
+	vpu->reg.sram = devm_ioremap_resource(dev, res);
+	if (IS_ERR(vpu->reg.sram)) {
+		dev_err(dev, "devm_ioremap_resource vpu sram failed.\n");
+		return PTR_ERR(vpu->reg.sram);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cfg_reg");
+	vpu->reg.cfg = devm_ioremap_resource(dev, res);
+	if (IS_ERR(vpu->reg.cfg)) {
+		dev_err(dev, "devm_ioremap_resource vpu cfg failed.\n");
+		return PTR_ERR(vpu->reg.cfg);
+	}
+
+	/* Get VPU clock */
+	vpu->clk = devm_clk_get(dev, "main");
+	if (vpu->clk == NULL) {
+		dev_err(dev, "get vpu clock fail\n");
+		return -EINVAL;
+	}
+
+	platform_set_drvdata(pdev, vpu);
+
+	ret = vpu_enable_clock(pdev);
+	if (ret) {
+		ret = -EINVAL;
+		return ret;
+	}
+
+	dev_dbg(dev, "vpu ipi init\n");
+	ret = vpu_ipi_init(vpu);
+	if (ret) {
+		dev_err(dev, "Failed to init ipi\n");
+		goto disable_vpu_clk;
+	}
+
+	platform_set_drvdata(pdev, vpu);
+
+	/* register vpu initialization IPI */
+	ret = vpu_ipi_register(pdev, IPI_VPU_INIT, vpu_init_ipi_handler,
+			       "vpu_init", vpu);
+	if (ret) {
+		dev_err(dev, "Failed to register IPI_VPU_INIT\n");
+		goto vpu_mutex_destroy;
+	}
+
+	vpu_debugfs = debugfs_create_file("mtk_vpu", S_IRUGO, NULL, (void *)dev,
+					  &vpu_debug_fops);
+	if (!vpu_debugfs) {
+		ret = -ENOMEM;
+		goto cleanup_ipi;
+	}
+
+	/* Set PTCM to 96K and DTCM to 32K */
+	vpu_cfg_writel(vpu, 0x2, VPU_TCM_CFG);
+
+	ret = vpu_alloc_p_ext_mem(vpu);
+	if (ret) {
+		dev_err(dev, "Allocate PM failed\n");
+		goto remove_debugfs;
+	}
+
+	ret = vpu_alloc_d_ext_mem(vpu);
+	if (ret) {
+		dev_err(dev, "Allocate DM failed\n");
+		goto free_p_mem;
+	}
+
+	init_waitqueue_head(&vpu->run.wq);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get IRQ resource failed.\n");
+		ret = -ENXIO;
+		goto free_d_mem;
+	}
+	vpu->reg.irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(dev, vpu->reg.irq, vpu_irq_handler, 0,
+			       pdev->name, vpu);
+	if (ret) {
+		dev_err(dev, "failed to request irq\n");
+		goto free_d_mem;
+	}
+
+	vpu_disable_clock(pdev);
+	dev_dbg(dev, "initialization completed\n");
+
+	return 0;
+
+free_d_mem:
+	vpu_free_d_ext_mem(vpu);
+free_p_mem:
+	vpu_free_p_ext_mem(vpu);
+remove_debugfs:
+	debugfs_remove(vpu_debugfs);
+cleanup_ipi:
+	memset(vpu->ipi_desc, 0, sizeof(struct vpu_ipi_desc)*IPI_MAX);
+vpu_mutex_destroy:
+	mutex_destroy(&vpu->vpu_mutex);
+disable_vpu_clk:
+	vpu_disable_clock(pdev);
+
+	return ret;
+}
+
+static const struct of_device_id mtk_vpu_match[] = {
+	{
+		.compatible = "mediatek,mt8173-vpu",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mtk_vpu_match);
+
+static int mtk_vpu_remove(struct platform_device *pdev)
+{
+	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
+
+	vpu_free_p_ext_mem(vpu);
+	vpu_free_d_ext_mem(vpu);
+
+	return 0;
+}
+
+static struct platform_driver mtk_vpu_driver = {
+	.probe	= mtk_vpu_probe,
+	.remove	= mtk_vpu_remove,
+	.driver	= {
+		.name	= MTK_VPU_DRV_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = mtk_vpu_match,
+	},
+};
+
+module_platform_driver(mtk_vpu_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek Video Prosessor Unit driver");
diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu_core.h b/drivers/media/platform/mtk-vpu/mtk_vpu_core.h
new file mode 100644
index 0000000..20cf2a0
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu_core.h
@@ -0,0 +1,161 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VPU_CORE_H
+#define _MTK_VPU_CORE_H
+
+#include <linux/platform_device.h>
+
+/**
+ * VPU (video processor unit) is a tiny processor controlling video hardware
+ * related to video codec, scaling and color format converting.
+ * VPU interfaces with other blocks by share memory and interrupt.
+ **/
+
+typedef void (*ipi_handler_t) (void *data,
+			       unsigned int len,
+			       void *priv);
+
+/**
+ * enum ipi_id - the id of inter-processor interrupt
+ *
+ * @IPI_VPU_INIT:	 The interrupt from vpu is to notfiy kernel
+			 VPU initialization completed.
+ * @IPI_VENC_H264:	 The interrupt from vpu is to notify kernel to
+			 handle H264 video encoder job, and vice versa.
+ * @IPI_VENC_VP8:	 The interrupt fro vpu is to notify kernel to
+			 handle VP8 video encoder job,, and vice versa.
+ * @IPI_VENC_CAPABILITY: The interrupt from vpu is to
+			 get venc hardware capability.
+ * @IPI_MAX:		 The maximum IPI number
+ */
+enum ipi_id {
+	IPI_VPU_INIT = 0,
+	IPI_VENC_H264,
+	IPI_VENC_VP8,
+	IPI_VENC_CAPABILITY,
+	IPI_MAX,
+};
+
+/**
+ * vpu_disable_clock - Disable VPU clock
+ *
+ * @pdev:		VPU platform device
+ *
+ *
+ * Return: Return 0 if the clock is disabled successfully,
+ * otherwise it is failed.
+ *
+ **/
+void vpu_disable_clock(struct platform_device *pdev);
+
+/**
+ * vpu_enable_clock - Enable VPU clock
+ *
+ * @pdev:		VPU platform device
+ *
+ * Return: Return 0 if the clock is enabled successfully,
+ * otherwise it is failed.
+ *
+ **/
+int vpu_enable_clock(struct platform_device *pdev);
+
+/**
+ * vpu_ipi_register - register an ipi function
+ *
+ * @pdev:	VPU platform device
+ * @id:		IPI ID
+ * @handler:	IPI handler
+ * @name:	IPI name
+ * @priv:	private data for IPI handler
+ *
+ * Register an ipi function to receive ipi interrupt from VPU.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int vpu_ipi_register(struct platform_device *pdev, enum ipi_id id,
+		     ipi_handler_t handler, const char *name, void *priv);
+
+/**
+ * vpu_ipi_send - send data from AP to vpu.
+ *
+ * @pdev:	VPU platform device
+ * @id:		IPI ID
+ * @buf:	the data buffer
+ * @len:	the data buffer length
+ * @wait:	wait for the last ipi completed.
+ *
+ * This function is thread-safe. When this function returns,
+ * VPU has received the data and starts the processing.
+ * When the processing completes, IPI handler registered
+ * by vpu_ipi_register will be called in interrupt context.
+ *
+ * Return: Return 0 if sending data successfully, otherwise it is failed.
+ **/
+int vpu_ipi_send(struct platform_device *pdev,
+		 enum ipi_id id, void *buf,
+		 unsigned int len,
+		 unsigned int wait);
+
+/**
+ * vpu_get_plat_device - get VPU's platform device
+ *
+ * @pdev:	the platform device of the module requesting VPU platform
+ *		device for using VPU API.
+ *
+ * Return: Return NULL if it is failed.
+ * otherwise it is VPU's platform device
+ **/
+struct platform_device *vpu_get_plat_device(struct platform_device *pdev);
+
+/**
+ * vpu_load_firmware - download VPU firmware and boot it
+ *
+ * @pdev:	VPU platform device
+ *
+ * Return: Return 0 if downloading firmware successfully,
+ * otherwise it is failed
+ **/
+int vpu_load_firmware(struct platform_device *pdev);
+
+/**
+ * vpu_mapping_dm_addr - Mapping DTCM/DMEM to kernel virtual address
+ *
+ * @pdev:	VPU platform device
+ * @dmem_addr:	VPU's data memory address
+ *
+ * Mapping the VPU's DTCM (Data Tightly-Coupled Memory) /
+ * DMEM (Data Extended Memory) memory address to
+ * kernel virtual address.
+ *
+ * Return: Return ERR_PTR(-EINVAL) if mapping failed,
+ * otherwise the mapped kernel virtual address
+ **/
+void *vpu_mapping_dm_addr(struct platform_device *pdev,
+			  void *dtcm_dmem_addr);
+
+/**
+ * vpu_mapping_iommu_dm_addr - Mapping to iommu address
+ *
+ * @pdev:	VPU platform device
+ * @dmem_addr:	VPU's extended data memory address
+ *
+ * Mapping the VPU's extended data address to iommu address
+ *
+ * Return: Return ERR_PTR(-EINVAL) if mapping failed,
+ * otherwise the mapped iommu address
+ **/
+dma_addr_t *vpu_mapping_iommu_dm_addr(struct platform_device *pdev,
+				      void *dmem_addr);
+#endif /* _MTK_VPU_CORE_H */
diff --git a/drivers/media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h b/drivers/media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h
new file mode 100644
index 0000000..4e09eec
--- /dev/null
+++ b/drivers/media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef VENC_VP8_VPU_H_
+#define VENC_VP8_VPU_H_
+
+/**
+ * enum venc_vp8_vpu_work_buf - vp8 encoder buffer index
+ */
+enum venc_vp8_vpu_work_buf {
+	VENC_VP8_VPU_WORK_BUF_LUMA,
+	VENC_VP8_VPU_WORK_BUF_LUMA2,
+	VENC_VP8_VPU_WORK_BUF_LUMA3,
+	VENC_VP8_VPU_WORK_BUF_CHROMA,
+	VENC_VP8_VPU_WORK_BUF_CHROMA2,
+	VENC_VP8_VPU_WORK_BUF_CHROMA3,
+	VENC_VP8_VPU_WORK_BUF_MV_INFO,
+	VENC_VP8_VPU_WORK_BUF_BS_HD,
+	VENC_VP8_VPU_WORK_BUF_PROB_BUF,
+	VENC_VP8_VPU_WORK_BUF_RC_INFO,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE2,
+	VENC_VP8_VPU_WORK_BUF_RC_CODE3,
+	VENC_VP8_VPU_WORK_BUF_MAX,
+};
+
+/*
+ * struct venc_vp8_vpu_config - Structure for vp8 encoder configuration
+ * @input_fourcc: input fourcc
+ * @bitrate: target bitrate (in bps)
+ * @pic_w: picture width
+ * @pic_h: picture height
+ * @buf_w: buffer width (with 16 alignment)
+ * @buf_h: buffer height (with 16 alignment)
+ * @intra_period: intra frame period
+ * @framerate: frame rate
+ * @ts_mode: temporal scalability mode (0: disable, 1: enable)
+ *	     support three temporal layers - 0: 7.5fps 1: 7.5fps 2: 15fps.
+ */
+struct venc_vp8_vpu_config {
+	u32 input_fourcc;
+	u32 bitrate;
+	u32 pic_w;
+	u32 pic_h;
+	u32 buf_w;
+	u32 buf_h;
+	u32 intra_period;
+	u32 framerate;
+	u32 ts_mode;
+};
+
+/*
+ * struct venc_vp8_vpu_buf -Structure for buffer information
+ * @align: buffer alignment (in bytes)
+ * @pa: physical address
+ * @vpua: VPU side memory addr which is used by RC_CODE
+ * @size: buffer size (in bytes)
+ */
+struct venc_vp8_vpu_buf {
+	u32 align;
+	u32 pa;
+	u32 vpua;
+	u32 size;
+};
+
+/*
+ * struct venc_vp8_vpu_drv - Structure for VPU driver control and info share
+ * This structure is allocated in VPU side and shared to AP side.
+ * @config: vp8 encoder configuration
+ * @work_bufs: working buffer information in VPU side
+ * The work_bufs here is for storing the 'size' info shared to AP side.
+ * The similar item in struct venc_vp8_handle is for memory allocation
+ * in AP side. The AP driver will copy the 'size' from here to the one in
+ * struct mtk_vcodec_mem, then invoke mtk_vcodec_mem_alloc to allocate
+ * the buffer. After that, bypass the 'dma_addr' to the 'pa' field here for
+ * register setting in VPU side.
+ */
+struct venc_vp8_vpu_drv {
+	struct venc_vp8_vpu_config config;
+	struct venc_vp8_vpu_buf work_bufs[VENC_VP8_VPU_WORK_BUF_MAX];
+};
+
+/*
+ * struct venc_vp8_vpu_inst - vp8 encoder VPU driver instance
+ * @wq_hd: wait queue used for vpu cmd trigger then wait vpu interrupt done
+ * @signaled: flag used for checking vpu interrupt done
+ * @failure: flag to show vpu cmd succeeds or not
+ * @id: VPU instance id
+ * @drv: driver structure allocated by VPU side and shared to AP side for
+ *	 control and info share
+ */
+struct venc_vp8_vpu_inst {
+	wait_queue_head_t wq_hd;
+	int signaled;
+	int failure;
+	unsigned int id;
+	struct venc_vp8_vpu_drv *drv;
+};
+
+int vp8_enc_vpu_init(void *handle);
+int vp8_enc_vpu_set_param(void *handle, unsigned int id, void *param);
+int vp8_enc_vpu_encode(void *handle,
+		       struct venc_frm_buf *frm_buf,
+		       struct mtk_vcodec_mem *bs_buf);
+int vp8_enc_vpu_deinit(void *handle);
+
+#endif
-- 
1.7.9.5

