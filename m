Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:24063 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755781AbcECKLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 06:11:41 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	<Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v10 5/8] [media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver
Date: Tue, 3 May 2016 18:11:24 +0800
Message-ID: <1462270287-11374-6-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1462270287-11374-5-git-send-email-tiffany.lin@mediatek.com>
References: <1462270287-11374-1-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-2-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-3-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-4-git-send-email-tiffany.lin@mediatek.com>
 <1462270287-11374-5-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 layer encoder driver for MT8173

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

---
 drivers/media/platform/Kconfig                     |   18 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-vcodec/Makefile         |   14 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  338 +++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1288 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   58 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  454 +++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  137 +++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |   55 +
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   27 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   94 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   87 ++
 drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  106 ++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  163 +++
 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  210 ++++
 17 files changed, 3139 insertions(+)
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d87ae31..c425461 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -166,6 +166,24 @@ config VIDEO_MEDIATEK_VPU
 	    To compile this driver as a module, choose M here: the
 	    module will be called mtk-vpu.
 
+config VIDEO_MEDIATEK_VCODEC
+	tristate "Mediatek Video Codec driver"
+        depends on ARM || ARM64
+        depends on MTK_IOMMU
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	select VIDEO_MEDIATEK_VPU
+	default n
+	---help---
+	    Mediatek video codec driver provides HW capability to
+	    encode and decode in a range of video formats
+	    This driver rely on VPU driver to communicate with VPU.
+
+	    To compile this driver as a module, choose M here: the
+	    module will be called mtk-vcodec
+
 config VIDEO_MEM2MEM_DEINTERLACE
 	tristate "Deinterlace support"
 	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 2efb7b1..6e735fe 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -58,3 +58,5 @@ obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
 obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
+
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
new file mode 100644
index 0000000..d04433be
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -0,0 +1,14 @@
+
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk-vcodec-enc.o mtk-vcodec-common.o
+
+
+
+mtk-vcodec-enc-y := mtk_vcodec_enc.o \
+		mtk_vcodec_enc_drv.o \
+		mtk_vcodec_enc_pm.o \
+		venc_drv_if.o \
+
+mtk-vcodec-common-y := mtk_vcodec_intr.o \
+		mtk_vcodec_util.o\
+
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
new file mode 100644
index 0000000..78eee50
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -0,0 +1,338 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _MTK_VCODEC_DRV_H_
+#define _MTK_VCODEC_DRV_H_
+
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+
+#include "mtk_vcodec_util.h"
+
+#define MTK_VCODEC_DRV_NAME	"mtk_vcodec_drv"
+#define MTK_VCODEC_ENC_NAME	"mtk-vcodec-enc"
+#define MTK_PLATFORM_STR	"platform:mt8173"
+
+
+#define MTK_VCODEC_MAX_PLANES	3
+#define MTK_V4L2_BENCHMARK	0
+#define WAIT_INTR_TIMEOUT_MS	1000
+
+/**
+ * enum mtk_hw_reg_idx - MTK hw register base index
+ */
+enum mtk_hw_reg_idx {
+	VDEC_SYS,
+	VDEC_MISC,
+	VDEC_LD,
+	VDEC_TOP,
+	VDEC_CM,
+	VDEC_AD,
+	VDEC_AV,
+	VDEC_PP,
+	VDEC_HWD,
+	VDEC_HWQ,
+	VDEC_HWB,
+	VDEC_HWG,
+	NUM_MAX_VDEC_REG_BASE,
+	/* h264 encoder */
+	VENC_SYS = NUM_MAX_VDEC_REG_BASE,
+	/* vp8 encoder */
+	VENC_LT_SYS,
+	NUM_MAX_VCODEC_REG_BASE
+};
+
+/**
+ * enum mtk_instance_type - The type of an MTK Vcodec instance.
+ */
+enum mtk_instance_type {
+	MTK_INST_DECODER		= 0,
+	MTK_INST_ENCODER		= 1,
+};
+
+/**
+ * enum mtk_instance_state - The state of an MTK Vcodec instance.
+ * @MTK_STATE_FREE - default state when instance is created
+ * @MTK_STATE_INIT - vcodec instance is initialized
+ * @MTK_STATE_HEADER - vdec had sps/pps header parsed or venc
+ *			had sps/pps header encoded
+ * @MTK_STATE_FLUSH - vdec is flushing. Only used by decoder
+ * @MTK_STATE_ABORT - vcodec should be aborted
+ */
+enum mtk_instance_state {
+	MTK_STATE_FREE = 0,
+	MTK_STATE_INIT = 1,
+	MTK_STATE_HEADER = 2,
+	MTK_STATE_FLUSH = 3,
+	MTK_STATE_ABORT = 4,
+};
+
+/**
+ * struct mtk_encode_param - General encoding parameters type
+ */
+enum mtk_encode_param {
+	MTK_ENCODE_PARAM_NONE = 0,
+	MTK_ENCODE_PARAM_BITRATE = (1 << 0),
+	MTK_ENCODE_PARAM_FRAMERATE = (1 << 1),
+	MTK_ENCODE_PARAM_INTRA_PERIOD = (1 << 2),
+	MTK_ENCODE_PARAM_FORCE_INTRA = (1 << 3),
+	MTK_ENCODE_PARAM_GOP_SIZE = (1 << 4),
+};
+
+enum mtk_fmt_type {
+	MTK_FMT_DEC = 0,
+	MTK_FMT_ENC = 1,
+	MTK_FMT_FRAME = 2,
+};
+
+/**
+ * struct mtk_video_fmt - Structure used to store information about pixelformats
+ */
+struct mtk_video_fmt {
+	u32	fourcc;
+	enum mtk_fmt_type	type;
+	u32	num_planes;
+};
+
+/**
+ * struct mtk_codec_framesizes - Structure used to store information about
+ *							framesizes
+ */
+struct mtk_codec_framesizes {
+	u32	fourcc;
+	struct	v4l2_frmsize_stepwise	stepwise;
+};
+
+/**
+ * struct mtk_q_type - Type of queue
+ */
+enum mtk_q_type {
+	MTK_Q_DATA_SRC = 0,
+	MTK_Q_DATA_DST = 1,
+};
+
+/**
+ * struct mtk_q_data - Structure used to store information about queue
+ */
+struct mtk_q_data {
+	unsigned int	visible_width;
+	unsigned int	visible_height;
+	unsigned int	coded_width;
+	unsigned int	coded_height;
+	enum v4l2_field	field;
+	unsigned int	bytesperline[MTK_VCODEC_MAX_PLANES];
+	unsigned int	sizeimage[MTK_VCODEC_MAX_PLANES];
+	struct mtk_video_fmt	*fmt;
+};
+
+/**
+ * struct mtk_enc_params - General encoding parameters
+ * @bitrate: target bitrate in bits per second
+ * @num_b_frame: number of b frames between p-frame
+ * @rc_frame: frame based rate control
+ * @rc_mb: macroblock based rate control
+ * @seq_hdr_mode: H.264 sequence header is encoded separately or joined
+ *		  with the first frame
+ * @intra_period: I frame period
+ * @gop_size: group of picture size, it's used as the intra frame period
+ * @framerate_num: frame rate numerator. ex: framerate_num=30 and
+ *		   framerate_denom=1 menas FPS is 30
+ * @framerate_denom: frame rate denominator. ex: framerate_num=30 and
+ *		     framerate_denom=1 menas FPS is 30
+ * @h264_max_qp: Max value for H.264 quantization parameter
+ * @h264_profile: V4L2 defined H.264 profile
+ * @h264_level: V4L2 defined H.264 level
+ * @force_intra: force/insert intra frame
+ */
+struct mtk_enc_params {
+	unsigned int	bitrate;
+	unsigned int	num_b_frame;
+	unsigned int	rc_frame;
+	unsigned int	rc_mb;
+	unsigned int	seq_hdr_mode;
+	unsigned int	intra_period;
+	unsigned int	gop_size;
+	unsigned int	framerate_num;
+	unsigned int	framerate_denom;
+	unsigned int	h264_max_qp;
+	unsigned int	h264_profile;
+	unsigned int	h264_level;
+	unsigned int	force_intra;
+};
+
+/**
+ * struct mtk_vcodec_pm - Power management data structure
+ */
+struct mtk_vcodec_pm {
+	struct clk	*vcodecpll;
+	struct clk	*univpll_d2;
+	struct clk	*clk_cci400_sel;
+	struct clk	*vdecpll;
+	struct clk	*vdec_sel;
+	struct clk	*vencpll_d2;
+	struct clk	*venc_sel;
+	struct clk	*univpll1_d2;
+	struct clk	*venc_lt_sel;
+	struct device	*larbvdec;
+	struct device	*larbvenc;
+	struct device	*larbvenclt;
+	struct device	*dev;
+	struct mtk_vcodec_dev	*mtkdev;
+};
+
+/**
+ * struct mtk_vcodec_ctx - Context (instance) private data.
+ *
+ * @type: type of the instance - decoder or encoder
+ * @dev: pointer to the mtk_vcodec_dev of the device
+ * @list: link to ctx_list of mtk_vcodec_dev
+ * @fh: struct v4l2_fh
+ * @m2m_ctx: pointer to the v4l2_m2m_ctx of the context
+ * @q_data: store information of input and output queue
+ *	    of the context
+ * @id: index of the context that this structure describes
+ * @state: state of the context
+ * @param_change: indicate encode parameter type
+ * @enc_params: encoding parameters
+ * @enc_if: hoooked encoder driver interface
+ * @drv_handle: driver handle for specific decode/encode instance
+ *
+ * @int_cond: variable used by the waitqueue
+ * @int_type: type of the last interrupt
+ * @queue: waitqueue that can be used to wait for this context to
+ *	   finish
+ * @irq_status: irq status
+ *
+ * @ctrl_hdl: handler for v4l2 framework
+ * @encode_work: worker for the encoding
+ *
+ * @colorspace: enum v4l2_colorspace; supplemental to pixelformat
+ * @ycbcr_enc: enum v4l2_ycbcr_encoding, Y'CbCr encoding
+ * @quantization: enum v4l2_quantization, colorspace quantization
+ * @xfer_func: enum v4l2_xfer_func, colorspace transfer function
+ */
+struct mtk_vcodec_ctx {
+	enum mtk_instance_type type;
+	struct mtk_vcodec_dev *dev;
+	struct list_head list;
+
+	struct v4l2_fh fh;
+	struct v4l2_m2m_ctx *m2m_ctx;
+	struct mtk_q_data q_data[2];
+	int id;
+	enum mtk_instance_state state;
+	enum mtk_encode_param param_change;
+	struct mtk_enc_params enc_params;
+
+	struct venc_common_if *enc_if;
+	unsigned long drv_handle;
+
+	int int_cond;
+	int int_type;
+	wait_queue_head_t queue;
+	unsigned int irq_status;
+
+	struct v4l2_ctrl_handler ctrl_hdl;
+	struct work_struct encode_work;
+
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+	enum v4l2_xfer_func xfer_func;
+};
+
+/**
+ * struct mtk_vcodec_dev - driver data
+ * @v4l2_dev: V4L2 device to register video devices for.
+ * @vfd_enc: Video device for encoder.
+ *
+ * @m2m_dev_enc: m2m device for encoder.
+ * @plat_dev: platform device
+ * @vpu_plat_dev: mtk vpu platform device
+ * @alloc_ctx: VB2 allocator context
+ *	       (for allocations without kernel mapping).
+ * @ctx_list: list of struct mtk_vcodec_ctx
+ * @irqlock: protect data access by irq handler and work thread
+ * @curr_ctx: The context that is waiting for codec hardware
+ *
+ * @reg_base: Mapped address of MTK Vcodec registers.
+ *
+ * @id_counter: used to identify current opened instance
+ * @num_instances: counter of active MTK Vcodec instances
+ *
+ * @encode_workqueue: encode work queue
+ *
+ * @int_cond: used to identify interrupt condition happen
+ * @int_type: used to identify what kind of interrupt condition happen
+ * @dev_mutex: video_device lock
+ * @queue: waitqueue for waiting for completion of device commands
+ *
+ * @enc_irq: h264 encoder irq resource
+ * @enc_lt_irq: vp8 encoder irq resource
+ *
+ * @enc_mutex: encoder hardware lock.
+ *
+ * @pm: power management control
+ * @dec_capability: used to identify decode capability, ex: 4k
+ * @enc_capability: used to identify encode capability
+ */
+struct mtk_vcodec_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device *vfd_enc;
+
+	struct v4l2_m2m_dev *m2m_dev_enc;
+	struct platform_device *plat_dev;
+	struct platform_device *vpu_plat_dev;
+	struct vb2_alloc_ctx *alloc_ctx;
+	struct list_head ctx_list;
+	spinlock_t irqlock;
+	struct mtk_vcodec_ctx *curr_ctx;
+	void __iomem *reg_base[NUM_MAX_VCODEC_REG_BASE];
+
+	unsigned long id_counter;
+	int num_instances;
+
+	struct workqueue_struct *encode_workqueue;
+
+	int int_cond;
+	int int_type;
+	struct mutex dev_mutex;
+	wait_queue_head_t queue;
+
+	int enc_irq;
+	int enc_lt_irq;
+
+	struct mutex enc_mutex;
+
+	struct mtk_vcodec_pm pm;
+	unsigned int dec_capability;
+	unsigned int enc_capability;
+};
+
+static inline struct mtk_vcodec_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct mtk_vcodec_ctx, fh);
+}
+
+static inline struct mtk_vcodec_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct mtk_vcodec_ctx, ctrl_hdl);
+}
+
+#endif /* _MTK_VCODEC_DRV_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
new file mode 100644
index 0000000..6e72d73
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -0,0 +1,1288 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+#include <soc/mediatek/smi.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "venc_drv_if.h"
+
+#define MTK_VENC_MIN_W	160U
+#define MTK_VENC_MIN_H	128U
+#define MTK_VENC_MAX_W	1920U
+#define MTK_VENC_MAX_H	1088U
+#define DFT_CFG_WIDTH	MTK_VENC_MIN_W
+#define DFT_CFG_HEIGHT	MTK_VENC_MIN_H
+#define MTK_MAX_CTRLS_HINT	20
+#define OUT_FMT_IDX		0
+#define CAP_FMT_IDX		4
+
+
+static void mtk_venc_worker(struct work_struct *work);
+
+static struct mtk_video_fmt mtk_video_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_NV12M,
+		.type = MTK_FMT_FRAME,
+		.num_planes = 2,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_NV21M,
+		.type = MTK_FMT_FRAME,
+		.num_planes = 2,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUV420M,
+		.type = MTK_FMT_FRAME,
+		.num_planes = 3,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YVU420M,
+		.type = MTK_FMT_FRAME,
+		.num_planes = 3,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_H264,
+		.type = MTK_FMT_ENC,
+		.num_planes = 1,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_VP8,
+		.type = MTK_FMT_ENC,
+		.num_planes = 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
+
+static const struct mtk_codec_framesizes mtk_venc_framesizes[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_H264,
+		.stepwise = { MTK_VENC_MIN_W, MTK_VENC_MAX_W, 16,
+			      MTK_VENC_MIN_H, MTK_VENC_MAX_H, 16 },
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_VP8,
+		.stepwise = { MTK_VENC_MIN_W, MTK_VENC_MAX_W, 16,
+			      MTK_VENC_MIN_H, MTK_VENC_MAX_H, 16 },
+	},
+};
+
+#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_venc_framesizes)
+
+static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct mtk_enc_params *p = &ctx->enc_params;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
+			       ctrl->val);
+		p->bitrate = ctrl->val;
+		ctx->param_change |= MTK_ENCODE_PARAM_BITRATE;
+		break;
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_B_FRAMES val = %d",
+			       ctrl->val);
+		p->num_b_frame = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE val = %d",
+			       ctrl->val);
+		p->rc_frame = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_MAX_QP val = %d",
+			       ctrl->val);
+		p->h264_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_HEADER_MODE val = %d",
+			       ctrl->val);
+		p->seq_hdr_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE val = %d",
+			       ctrl->val);
+		p->rc_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_PROFILE val = %d",
+			       ctrl->val);
+		p->h264_profile = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_LEVEL val = %d",
+			       ctrl->val);
+		p->h264_level = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_H264_I_PERIOD val = %d",
+			       ctrl->val);
+		p->intra_period = ctrl->val;
+		ctx->param_change |= MTK_ENCODE_PARAM_INTRA_PERIOD;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_GOP_SIZE val = %d",
+			       ctrl->val);
+		p->gop_size = ctrl->val;
+		ctx->param_change |= MTK_ENCODE_PARAM_GOP_SIZE;
+		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME");
+		p->force_intra = 1;
+		ctx->param_change |= MTK_ENCODE_PARAM_FORCE_INTRA;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops mtk_vcodec_enc_ctrl_ops = {
+	.s_ctrl = vidioc_venc_s_ctrl,
+};
+
+static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool output_queue)
+{
+	struct mtk_video_fmt *fmt;
+	int i, j = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (output_queue && mtk_video_formats[i].type != MTK_FMT_FRAME)
+			continue;
+		if (!output_queue && mtk_video_formats[i].type != MTK_FMT_ENC)
+			continue;
+
+		if (j == f->index) {
+			fmt = &mtk_video_formats[i];
+			f->pixelformat = fmt->fourcc;
+			memset(f->reserved, 0, sizeof(f->reserved));
+			return 0;
+		}
+		++j;
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	int i = 0;
+
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
+		if (fsize->pixel_format != mtk_venc_framesizes[i].fourcc)
+			continue;
+
+		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+		fsize->stepwise = mtk_venc_framesizes[i].stepwise;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, false);
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(f, true);
+}
+
+static int vidioc_venc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver));
+	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
+	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
+
+	return 0;
+}
+
+static int vidioc_venc_s_parm(struct file *file, void *priv,
+			      struct v4l2_streamparm *a)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	ctx->enc_params.framerate_num =
+			a->parm.output.timeperframe.denominator;
+	ctx->enc_params.framerate_denom =
+			a->parm.output.timeperframe.numerator;
+	ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
+
+	return 0;
+}
+
+static int vidioc_venc_g_parm(struct file *file, void *priv,
+			      struct v4l2_streamparm *a)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	a->parm.output.timeperframe.denominator =
+			ctx->enc_params.framerate_num;
+	a->parm.output.timeperframe.numerator =
+			ctx->enc_params.framerate_denom;
+
+	return 0;
+}
+
+static struct mtk_q_data *mtk_venc_get_q_data(struct mtk_vcodec_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	if (V4L2_TYPE_IS_OUTPUT(type))
+		return &ctx->q_data[MTK_Q_DATA_SRC];
+
+	return &ctx->q_data[MTK_Q_DATA_DST];
+}
+
+static struct mtk_video_fmt *mtk_venc_find_format(struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &mtk_video_formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+/* V4L2 specification suggests the driver corrects the format struct if any of
+ * the dimensions is unsupported
+ */
+static int vidioc_try_fmt(struct v4l2_format *f, struct mtk_video_fmt *fmt)
+{
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	int i;
+
+	pix_fmt_mp->field = V4L2_FIELD_NONE;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		pix_fmt_mp->num_planes = 1;
+		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		int tmp_w, tmp_h;
+
+		pix_fmt_mp->height = clamp(pix_fmt_mp->height,
+					MTK_VENC_MIN_H,
+					MTK_VENC_MAX_H);
+		pix_fmt_mp->width = clamp(pix_fmt_mp->width,
+					MTK_VENC_MIN_W,
+					MTK_VENC_MAX_W);
+
+		/* find next closer width align 16, heign align 32, size align
+		 * 64 rectangle
+		 */
+		tmp_w = pix_fmt_mp->width;
+		tmp_h = pix_fmt_mp->height;
+		v4l_bound_align_image(&pix_fmt_mp->width,
+					MTK_VENC_MIN_W,
+					MTK_VENC_MAX_W, 4,
+					&pix_fmt_mp->height,
+					MTK_VENC_MIN_H,
+					MTK_VENC_MAX_H, 5, 6);
+
+		if (pix_fmt_mp->width < tmp_w &&
+			(pix_fmt_mp->width + 16) <= MTK_VENC_MAX_W)
+			pix_fmt_mp->width += 16;
+		if (pix_fmt_mp->height < tmp_h &&
+			(pix_fmt_mp->height + 32) <= MTK_VENC_MAX_H)
+			pix_fmt_mp->height += 32;
+
+		mtk_v4l2_debug(0,
+			"before resize width=%d, height=%d, after resize width=%d, height=%d, sizeimage=%d",
+			tmp_w, tmp_h, pix_fmt_mp->width,
+			pix_fmt_mp->height,
+			pix_fmt_mp->width * pix_fmt_mp->height);
+
+		pix_fmt_mp->num_planes = fmt->num_planes;
+		pix_fmt_mp->plane_fmt[0].sizeimage =
+				pix_fmt_mp->width * pix_fmt_mp->height +
+				((ALIGN(pix_fmt_mp->width, 16) * 2) * 16);
+		pix_fmt_mp->plane_fmt[0].bytesperline = pix_fmt_mp->width;
+
+		if (pix_fmt_mp->num_planes == 2) {
+			pix_fmt_mp->plane_fmt[1].sizeimage =
+				(pix_fmt_mp->width * pix_fmt_mp->height) / 2 +
+				(ALIGN(pix_fmt_mp->width, 16) * 16);
+			pix_fmt_mp->plane_fmt[2].sizeimage = 0;
+			pix_fmt_mp->plane_fmt[1].bytesperline =
+							pix_fmt_mp->width;
+			pix_fmt_mp->plane_fmt[2].bytesperline = 0;
+		} else if (pix_fmt_mp->num_planes == 3) {
+			pix_fmt_mp->plane_fmt[1].sizeimage =
+			pix_fmt_mp->plane_fmt[2].sizeimage =
+				(pix_fmt_mp->width * pix_fmt_mp->height) / 4 +
+				((ALIGN(pix_fmt_mp->width, 16) / 2) * 16);
+			pix_fmt_mp->plane_fmt[1].bytesperline =
+				pix_fmt_mp->plane_fmt[2].bytesperline =
+				pix_fmt_mp->width / 2;
+		}
+	}
+
+	for (i = 0; i < pix_fmt_mp->num_planes; i++)
+		memset(&(pix_fmt_mp->plane_fmt[i].reserved[0]), 0x0,
+			   sizeof(pix_fmt_mp->plane_fmt[0].reserved));
+
+	pix_fmt_mp->flags = 0;
+	memset(&pix_fmt_mp->reserved, 0x0,
+		sizeof(pix_fmt_mp->reserved));
+
+	return 0;
+}
+
+static void mtk_venc_set_param(struct mtk_vcodec_ctx *ctx,
+				struct venc_enc_param *param)
+{
+	struct mtk_q_data *q_data_src = &ctx->q_data[MTK_Q_DATA_SRC];
+	struct mtk_enc_params *enc_params = &ctx->enc_params;
+
+	switch (q_data_src->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420M:
+		param->input_yuv_fmt = VENC_YUV_FORMAT_I420;
+		break;
+	case V4L2_PIX_FMT_YVU420M:
+		param->input_yuv_fmt = VENC_YUV_FORMAT_YV12;
+		break;
+	case V4L2_PIX_FMT_NV12M:
+		param->input_yuv_fmt = VENC_YUV_FORMAT_NV12;
+		break;
+	case V4L2_PIX_FMT_NV21M:
+		param->input_yuv_fmt = VENC_YUV_FORMAT_NV21;
+		break;
+	default:
+		mtk_v4l2_err("Unsupport fourcc =%d", q_data_src->fmt->fourcc);
+		break;
+	}
+	param->h264_profile = enc_params->h264_profile;
+	param->h264_level = enc_params->h264_level;
+
+	/* Config visible resolution */
+	param->width = q_data_src->visible_width;
+	param->height = q_data_src->visible_height;
+	/* Config coded resolution */
+	param->buf_width = q_data_src->coded_width;
+	param->buf_height = q_data_src->coded_height;
+	param->frm_rate = enc_params->framerate_num /
+			enc_params->framerate_denom;
+	param->intra_period = enc_params->intra_period;
+	param->gop_size = enc_params->gop_size;
+	param->bitrate = enc_params->bitrate;
+
+	mtk_v4l2_debug(0,
+		"fmt 0x%x, P/L %d/%d, w/h %d/%d, buf %d/%d, fps/bps %d/%d, gop %d, i_period %d",
+		param->input_yuv_fmt, param->h264_profile,
+		param->h264_level, param->width, param->height,
+		param->buf_width, param->buf_height,
+		param->frm_rate, param->bitrate,
+		param->gop_size, param->intra_period);
+}
+
+static int vidioc_venc_s_fmt_cap(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+	int i, ret;
+	struct mtk_video_fmt *fmt;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq) {
+		mtk_v4l2_err("fail to get vq");
+		return -EINVAL;
+	}
+
+	if (vb2_is_busy(vq)) {
+		mtk_v4l2_err("queue busy");
+		return -EBUSY;
+	}
+
+	q_data = mtk_venc_get_q_data(ctx, f->type);
+	if (!q_data) {
+		mtk_v4l2_err("fail to get q data");
+		return -EINVAL;
+	}
+
+	fmt = mtk_venc_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
+		fmt = mtk_venc_find_format(f);
+	}
+
+	q_data->fmt = fmt;
+	ret = vidioc_try_fmt(f, q_data->fmt);
+	if (ret)
+		return ret;
+
+	q_data->coded_width = f->fmt.pix_mp.width;
+	q_data->coded_height = f->fmt.pix_mp.height;
+	q_data->field = f->fmt.pix_mp.field;
+
+	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
+		struct v4l2_plane_pix_format	*plane_fmt;
+
+		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
+		q_data->bytesperline[i]	= plane_fmt->bytesperline;
+		q_data->sizeimage[i] = plane_fmt->sizeimage;
+	}
+
+	if (ctx->state == MTK_STATE_FREE) {
+		ret = venc_if_init(ctx, q_data->fmt->fourcc);
+		if (ret) {
+			mtk_v4l2_err("venc_if_init failed=%d, codec type=%x",
+					ret, q_data->fmt->fourcc);
+			return -EBUSY;
+		}
+		ctx->state = MTK_STATE_INIT;
+	}
+
+	return 0;
+}
+
+static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+	int ret, i;
+	struct mtk_video_fmt *fmt;
+	unsigned int pitch_w_div16;
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq) {
+		mtk_v4l2_err("fail to get vq");
+		return -EINVAL;
+	}
+
+	if (vb2_is_busy(vq)) {
+		mtk_v4l2_err("queue busy");
+		return -EBUSY;
+	}
+
+	q_data = mtk_venc_get_q_data(ctx, f->type);
+	if (!q_data) {
+		mtk_v4l2_err("fail to get q data");
+		return -EINVAL;
+	}
+
+	fmt = mtk_venc_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
+		fmt = mtk_venc_find_format(f);
+	}
+
+	pix_fmt_mp->height = clamp(pix_fmt_mp->height,
+				MTK_VENC_MIN_H,
+				MTK_VENC_MAX_H);
+	pix_fmt_mp->width = clamp(pix_fmt_mp->width,
+				MTK_VENC_MIN_W,
+				MTK_VENC_MAX_W);
+
+	q_data->visible_width = f->fmt.pix_mp.width;
+	q_data->visible_height = f->fmt.pix_mp.height;
+	q_data->fmt = fmt;
+	ret = vidioc_try_fmt(f, q_data->fmt);
+	if (ret)
+		return ret;
+
+	q_data->coded_width = f->fmt.pix_mp.width;
+	q_data->coded_height = f->fmt.pix_mp.height;
+
+	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
+	if (pitch_w_div16 % 8 != 0) {
+		/* Adjust returned width/height, so application could correctly
+		 * allocate hw required memory
+		 */
+		q_data->visible_height += 32;
+		vidioc_try_fmt(f, q_data->fmt);
+	}
+
+	q_data->field = f->fmt.pix_mp.field;
+	ctx->colorspace = f->fmt.pix_mp.colorspace;
+	ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
+	ctx->quantization = f->fmt.pix_mp.quantization;
+	ctx->xfer_func = f->fmt.pix_mp.xfer_func;
+
+	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
+		struct v4l2_plane_pix_format *plane_fmt;
+
+		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
+		q_data->bytesperline[i] = plane_fmt->bytesperline;
+		q_data->sizeimage[i] = plane_fmt->sizeimage;
+	}
+
+	return 0;
+}
+
+static int vidioc_venc_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+	int i;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, f->type);
+
+	pix->width = q_data->coded_width;
+	pix->height = q_data->coded_height;
+	pix->pixelformat = q_data->fmt->fourcc;
+	pix->field = q_data->field;
+	pix->num_planes = q_data->fmt->num_planes;
+	for (i = 0; i < pix->num_planes; i++) {
+		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
+		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
+		memset(&(pix->plane_fmt[i].reserved[0]), 0x0,
+		       sizeof(pix->plane_fmt[i].reserved));
+	}
+
+	pix->flags = 0;
+	pix->colorspace = ctx->colorspace;
+	pix->ycbcr_enc = ctx->ycbcr_enc;
+	pix->quantization = ctx->quantization;
+	pix->xfer_func = ctx->xfer_func;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+					 struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	fmt = mtk_venc_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[CAP_FMT_IDX].fourcc;
+		fmt = mtk_venc_find_format(f);
+	}
+	f->fmt.pix_mp.colorspace = ctx->colorspace;
+	f->fmt.pix_mp.ycbcr_enc = ctx->ycbcr_enc;
+	f->fmt.pix_mp.quantization = ctx->quantization;
+	f->fmt.pix_mp.xfer_func = ctx->xfer_func;
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
+					 struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+
+	fmt = mtk_venc_find_format(f);
+	if (!fmt) {
+		f->fmt.pix.pixelformat = mtk_video_formats[OUT_FMT_IDX].fourcc;
+		fmt = mtk_venc_find_format(f);
+	}
+	if (!f->fmt.pix_mp.colorspace) {
+		f->fmt.pix_mp.colorspace = V4L2_COLORSPACE_REC709;
+		f->fmt.pix_mp.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+		f->fmt.pix_mp.quantization = V4L2_QUANTIZATION_DEFAULT;
+		f->fmt.pix_mp.xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	}
+
+	return vidioc_try_fmt(f, fmt);
+}
+
+static int vidioc_venc_qbuf(struct file *file, void *priv,
+			    struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (ctx->state == MTK_STATE_ABORT) {
+		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
+				ctx->id);
+		return -EIO;
+	}
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_venc_dqbuf(struct file *file, void *priv,
+			     struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (ctx->state == MTK_STATE_ABORT) {
+		mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
+				ctx->id);
+		return -EIO;
+	}
+
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= vidioc_venc_qbuf,
+	.vidioc_dqbuf			= vidioc_venc_dqbuf,
+
+	.vidioc_querycap		= vidioc_venc_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
+
+	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
+	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+
+	.vidioc_s_parm			= vidioc_venc_s_parm,
+	.vidioc_g_parm			= vidioc_venc_g_parm,
+	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt_cap,
+	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt_out,
+
+	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
+
+	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
+	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
+};
+
+static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
+				   unsigned int *nbuffers,
+				   unsigned int *nplanes,
+				   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mtk_q_data *q_data;
+	unsigned int i;
+
+	q_data = mtk_venc_get_q_data(ctx, vq->type);
+
+	if (q_data == NULL)
+		return -EINVAL;
+
+	if (*nplanes) {
+		for (i = 0; i < *nplanes; i++) {
+			if (sizes[i] < q_data->sizeimage[i])
+				return -EINVAL;
+			alloc_ctxs[i] = ctx->dev->alloc_ctx;
+		}
+	} else {
+		*nplanes = q_data->fmt->num_planes;
+		for (i = 0; i < *nplanes; i++) {
+			sizes[i] = q_data->sizeimage[i];
+			alloc_ctxs[i] = ctx->dev->alloc_ctx;
+		}
+	}
+
+	return 0;
+}
+
+static int vb2ops_venc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mtk_q_data *q_data;
+	int i;
+
+	q_data = mtk_venc_get_q_data(ctx, vb->vb2_queue->type);
+
+	for (i = 0; i < q_data->fmt->num_planes; i++) {
+		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
+			mtk_v4l2_err("data will not fit into plane %d (%lu < %d)",
+				i, vb2_plane_size(vb, i),
+				q_data->sizeimage[i]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void vb2ops_venc_buf_queue(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vb2_v4l2 =
+			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
+
+	struct mtk_video_enc_buf *mtk_buf =
+			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
+
+	if ((vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+	    (ctx->param_change != MTK_ENCODE_PARAM_NONE)) {
+		mtk_v4l2_debug(1, "[%d] Before id=%d encode parameter change %x",
+			       ctx->id,
+			       mtk_buf->vb.vb2_buf.index,
+			       ctx->param_change);
+		mtk_buf->param_change = ctx->param_change;
+		mtk_buf->enc_params = ctx->enc_params;
+		ctx->param_change = MTK_ENCODE_PARAM_NONE;
+	}
+
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
+}
+
+static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+	struct venc_enc_param param;
+	int ret;
+	int i;
+
+	/* Once state turn into MTK_STATE_ABORT, we need stop_streaming
+	  * to clear it
+	  */
+	if ((ctx->state == MTK_STATE_ABORT) || (ctx->state == MTK_STATE_FREE)) {
+		ret = -EIO;
+		goto err_set_param;
+	}
+
+	/* Do the initialization when both start_streaming have been called */
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		if (!vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))
+			return 0;
+	} else {
+		if (!vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q))
+			return 0;
+	}
+
+	mtk_venc_set_param(ctx, &param);
+	ret = venc_if_set_param(ctx, VENC_SET_PARAM_ENC, &param);
+	if (ret) {
+		mtk_v4l2_err("venc_if_set_param failed=%d", ret);
+		ctx->state = MTK_STATE_ABORT;
+		goto err_set_param;
+	}
+	ctx->param_change = MTK_ENCODE_PARAM_NONE;
+
+	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
+	    (ctx->enc_params.seq_hdr_mode !=
+				V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE)) {
+		ret = venc_if_set_param(ctx,
+					VENC_SET_PARAM_PREPEND_HEADER,
+					NULL);
+		if (ret) {
+			mtk_v4l2_err("venc_if_set_param failed=%d", ret);
+			ctx->state = MTK_STATE_ABORT;
+			goto err_set_param;
+		}
+		ctx->state = MTK_STATE_HEADER;
+	}
+
+	return 0;
+
+err_set_param:
+	for (i = 0; i < q->num_buffers; ++i) {
+		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
+			mtk_v4l2_debug(0, "[%d] id=%d, type=%d, %d -> VB2_BUF_STATE_QUEUED",
+					ctx->id, i, q->type,
+					(int)q->bufs[i]->state);
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(q->bufs[i]),
+					VB2_BUF_STATE_QUEUED);
+		}
+	}
+
+	return ret;
+}
+
+static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_buffer *src_buf, *dst_buf;
+	int ret;
+
+	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->id, q->type);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
+			dst_buf->planes[0].bytesused = 0;
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
+					VB2_BUF_STATE_ERROR);
+		}
+	} else {
+		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
+					VB2_BUF_STATE_ERROR);
+	}
+
+	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	     vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q)) ||
+	    (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+	     vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q))) {
+		mtk_v4l2_debug(1, "[%d]-> q type %d out=%d cap=%d",
+			       ctx->id, q->type,
+			       vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q),
+			       vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q));
+		return;
+	}
+
+	/* Release the encoder if both streams are stopped. */
+	ret = venc_if_deinit(ctx);
+	if (ret)
+		mtk_v4l2_err("venc_if_deinit failed=%d", ret);
+
+	ctx->state = MTK_STATE_FREE;
+}
+
+static struct vb2_ops mtk_venc_vb2_ops = {
+	.queue_setup		= vb2ops_venc_queue_setup,
+	.buf_prepare		= vb2ops_venc_buf_prepare,
+	.buf_queue		= vb2ops_venc_buf_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+	.start_streaming	= vb2ops_venc_start_streaming,
+	.stop_streaming		= vb2ops_venc_stop_streaming,
+};
+
+static int mtk_venc_encode_header(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	int ret;
+	struct vb2_buffer *dst_buf;
+	struct mtk_vcodec_mem bs_buf;
+	struct venc_done_result enc_result;
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	if (!dst_buf) {
+		mtk_v4l2_debug(1, "No dst buffer");
+		return -EINVAL;
+	}
+
+	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	bs_buf.size = (size_t)dst_buf->planes[0].length;
+
+	mtk_v4l2_debug(1,
+			"[%d] buf id=%d va=0x%p dma_addr=0x%llx size=%zu",
+			ctx->id,
+			dst_buf->index, bs_buf.va,
+			(u64)bs_buf.dma_addr,
+			bs_buf.size);
+
+	ret = venc_if_encode(ctx,
+			VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
+			NULL, &bs_buf, &enc_result);
+
+	if (ret) {
+		dst_buf->planes[0].bytesused = 0;
+		ctx->state = MTK_STATE_ABORT;
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
+				  VB2_BUF_STATE_ERROR);
+		mtk_v4l2_err("venc_if_encode failed=%d", ret);
+		return -EINVAL;
+	}
+
+	ctx->state = MTK_STATE_HEADER;
+	dst_buf->planes[0].bytesused = enc_result.bs_size;
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
+
+	return 0;
+}
+
+static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx)
+{
+	struct venc_enc_param enc_prm;
+	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	struct vb2_v4l2_buffer *vb2_v4l2 =
+			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
+	struct mtk_video_enc_buf *mtk_buf =
+			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
+
+	int ret = 0;
+
+	memset(&enc_prm, 0, sizeof(enc_prm));
+	if (mtk_buf->param_change == MTK_ENCODE_PARAM_NONE)
+		return 0;
+
+	if (mtk_buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
+		enc_prm.bitrate = mtk_buf->enc_params.bitrate;
+		mtk_v4l2_debug(1, "[%d] id=%d, change param br=%d",
+				ctx->id,
+				mtk_buf->vb.vb2_buf.index,
+				enc_prm.bitrate);
+		ret |= venc_if_set_param(ctx,
+					 VENC_SET_PARAM_ADJUST_BITRATE,
+					 &enc_prm);
+	}
+	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
+		enc_prm.frm_rate = mtk_buf->enc_params.framerate_num /
+				   mtk_buf->enc_params.framerate_denom;
+		mtk_v4l2_debug(1, "[%d] id=%d, change param fr=%d",
+			       ctx->id,
+			       mtk_buf->vb.vb2_buf.index,
+			       enc_prm.frm_rate);
+		ret |= venc_if_set_param(ctx,
+					 VENC_SET_PARAM_ADJUST_FRAMERATE,
+					 &enc_prm);
+	}
+	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_GOP_SIZE) {
+		enc_prm.gop_size = mtk_buf->enc_params.gop_size;
+		mtk_v4l2_debug(1, "change param intra period=%d",
+			       enc_prm.gop_size);
+		ret |= venc_if_set_param(ctx,
+					 VENC_SET_PARAM_GOP_SIZE,
+					 &enc_prm);
+	}
+	if (!ret && mtk_buf->param_change & MTK_ENCODE_PARAM_FORCE_INTRA) {
+		mtk_v4l2_debug(1, "[%d] id=%d, change param force I=%d",
+				ctx->id,
+				mtk_buf->vb.vb2_buf.index,
+				mtk_buf->enc_params.force_intra);
+		if (mtk_buf->enc_params.force_intra)
+			ret |= venc_if_set_param(ctx,
+						 VENC_SET_PARAM_FORCE_INTRA,
+						 NULL);
+	}
+
+	mtk_buf->param_change = MTK_ENCODE_PARAM_NONE;
+
+	if (ret) {
+		ctx->state = MTK_STATE_ABORT;
+		mtk_v4l2_err("venc_if_set_param %d failed=%d",
+				mtk_buf->param_change, ret);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * v4l2_m2m_streamoff() holds dev_mutex and waits mtk_venc_worker()
+ * to call v4l2_m2m_job_finish().
+ * If mtk_venc_worker() tries to acquire dev_mutex, it will deadlock.
+ * So this function must not try to acquire dev->dev_mutex.
+ * This means v4l2 ioctls and mtk_venc_worker() can run at the same time.
+ * mtk_venc_worker() should be carefully implemented to avoid bugs.
+ */
+static void mtk_venc_worker(struct work_struct *work)
+{
+	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
+				    encode_work);
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct venc_frm_buf frm_buf;
+	struct mtk_vcodec_mem bs_buf;
+	struct venc_done_result enc_result;
+	int ret, i;
+	struct vb2_v4l2_buffer *vb2_v4l2;
+
+	/* check dst_buf, dst_buf may be removed in device_run
+	 * to stored encdoe header so we need check dst_buf and
+	 * call job_finish here to prevent recursion
+	 */
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	if (!dst_buf) {
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+		return;
+	}
+
+	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	memset(&frm_buf, 0, sizeof(frm_buf));
+	for (i = 0; i < src_buf->num_planes ; i++) {
+		frm_buf.fb_addr[i].va = vb2_plane_vaddr(src_buf, i);
+		frm_buf.fb_addr[i].dma_addr =
+				vb2_dma_contig_plane_dma_addr(src_buf, i);
+		frm_buf.fb_addr[i].size =
+				(size_t)src_buf->planes[i].length;
+	}
+	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	bs_buf.size = (size_t)dst_buf->planes[0].length;
+
+	mtk_v4l2_debug(2,
+			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=%zu",
+			frm_buf.fb_addr[0].va,
+			(u64)frm_buf.fb_addr[0].dma_addr,
+			frm_buf.fb_addr[0].size,
+			frm_buf.fb_addr[1].va,
+			(u64)frm_buf.fb_addr[1].dma_addr,
+			frm_buf.fb_addr[1].size,
+			frm_buf.fb_addr[2].va,
+			(u64)frm_buf.fb_addr[2].dma_addr,
+			frm_buf.fb_addr[2].size);
+
+	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
+			     &frm_buf, &bs_buf, &enc_result);
+
+	vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
+	if (enc_result.is_key_frm)
+		vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
+
+	if (ret) {
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
+				  VB2_BUF_STATE_ERROR);
+		dst_buf->planes[0].bytesused = 0;
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
+				  VB2_BUF_STATE_ERROR);
+		mtk_v4l2_err("venc_if_encode failed=%d", ret);
+	} else {
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
+				  VB2_BUF_STATE_DONE);
+		dst_buf->planes[0].bytesused = enc_result.bs_size;
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
+				  VB2_BUF_STATE_DONE);
+		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
+				 enc_result.bs_size);
+	}
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+
+	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
+			src_buf->index, dst_buf->index, ret,
+			enc_result.bs_size);
+}
+
+static void m2mops_venc_device_run(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+
+	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc == V4L2_PIX_FMT_H264) &&
+	    (ctx->state != MTK_STATE_HEADER)) {
+		/* encode h264 sps/pps header */
+		mtk_venc_encode_header(ctx);
+		queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
+		return;
+	}
+
+	mtk_venc_param_change(ctx);
+	queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
+}
+
+static int m2mops_venc_job_ready(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	if (ctx->state == MTK_STATE_ABORT || ctx->state == MTK_STATE_FREE) {
+		mtk_v4l2_debug(3, "[%d]Not ready: state=0x%x.",
+			       ctx->id, ctx->state);
+		return 0;
+	}
+
+	return 1;
+}
+
+static void m2mops_venc_job_abort(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+
+	ctx->state = MTK_STATE_ABORT;
+}
+
+static void m2mops_venc_lock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mutex_lock(&ctx->dev->dev_mutex);
+}
+
+static void m2mops_venc_unlock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mutex_unlock(&ctx->dev->dev_mutex);
+}
+
+const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
+	.device_run	= m2mops_venc_device_run,
+	.job_ready	= m2mops_venc_job_ready,
+	.job_abort	= m2mops_venc_job_abort,
+	.lock		= m2mops_venc_lock,
+	.unlock		= m2mops_venc_unlock,
+};
+
+void mtk_vcodec_enc_set_default_params(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_q_data *q_data;
+
+	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
+	ctx->fh.m2m_ctx = ctx->m2m_ctx;
+	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
+	INIT_WORK(&ctx->encode_work, mtk_venc_worker);
+
+	ctx->colorspace = V4L2_COLORSPACE_REC709;
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
+	memset(q_data, 0, sizeof(struct mtk_q_data));
+	q_data->visible_width = DFT_CFG_WIDTH;
+	q_data->visible_height = DFT_CFG_HEIGHT;
+	q_data->coded_width = DFT_CFG_WIDTH;
+	q_data->coded_height = DFT_CFG_HEIGHT;
+	q_data->field = V4L2_FIELD_NONE;
+
+	q_data->fmt = &mtk_video_formats[OUT_FMT_IDX];
+
+	v4l_bound_align_image(&q_data->coded_width,
+				MTK_VENC_MIN_W,
+				MTK_VENC_MAX_W, 4,
+				&q_data->coded_height,
+				MTK_VENC_MIN_H,
+				MTK_VENC_MAX_H, 5, 6);
+
+	if (q_data->coded_width < DFT_CFG_WIDTH &&
+		(q_data->coded_width + 16) <= MTK_VENC_MAX_W)
+		q_data->coded_width += 16;
+	if (q_data->coded_height < DFT_CFG_HEIGHT &&
+		(q_data->coded_height + 32) <= MTK_VENC_MAX_H)
+		q_data->coded_height += 32;
+
+	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
+	q_data->bytesperline[0] = q_data->coded_width;
+	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
+	q_data->bytesperline[1] = q_data->coded_width;
+
+	q_data = &ctx->q_data[MTK_Q_DATA_DST];
+	memset(q_data, 0, sizeof(struct mtk_q_data));
+	q_data->coded_width = DFT_CFG_WIDTH;
+	q_data->coded_height = DFT_CFG_HEIGHT;
+	q_data->fmt = &mtk_video_formats[CAP_FMT_IDX];
+	q_data->field = V4L2_FIELD_NONE;
+	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
+		DFT_CFG_WIDTH * DFT_CFG_HEIGHT;
+	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] = 0;
+
+}
+
+int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
+{
+	const struct v4l2_ctrl_ops *ops = &mtk_vcodec_enc_ctrl_ops;
+	struct v4l2_ctrl_handler *handler = &ctx->ctrl_hdl;
+
+	v4l2_ctrl_handler_init(handler, MTK_MAX_CTRLS_HINT);
+
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_BITRATE,
+			1, 4000000, 1, 4000000);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_B_FRAMES,
+			0, 2, 1, 0);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
+			0, 1, 1, 1);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
+			0, 51, 1, 51);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
+			0, 65535, 1, 0);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			0, 65535, 1, 0);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
+			0, 1, 1, 0);
+	v4l2_ctrl_new_std(handler, ops, V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME,
+			0, 0, 0, 0);
+	v4l2_ctrl_new_std_menu(handler, ops,
+			V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+			V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+			0, V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
+	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+			V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+			0, V4L2_MPEG_VIDEO_H264_PROFILE_MAIN);
+	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+			V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
+			0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
+	if (handler->error) {
+		mtk_v4l2_err("Init control handler fail %d",
+				handler->error);
+		return handler->error;
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
+
+	return 0;
+}
+
+int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
+			      struct vb2_queue *dst_vq)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	int ret;
+
+	/* Note: VB2_USERPTR works with dma-contig because mt8173
+	 * support iommu
+	 * https://patchwork.kernel.org/patch/8335461/
+	 * https://patchwork.kernel.org/patch/7596181/
+	 */
+	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv	= ctx;
+	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
+	src_vq->ops		= &mtk_venc_vb2_ops;
+	src_vq->mem_ops		= &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock		= &ctx->dev->dev_mutex;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv	= ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops		= &mtk_venc_vb2_ops;
+	dst_vq->mem_ops		= &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock		= &ctx->dev->dev_mutex;
+
+	return vb2_queue_init(dst_vq);
+}
+
+int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_vcodec_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->enc_mutex);
+	return 0;
+}
+
+int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_vcodec_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->enc_mutex);
+	return 0;
+}
+
+void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx)
+{
+	venc_if_deinit(ctx);
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
new file mode 100644
index 0000000..d7a154a
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
@@ -0,0 +1,58 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _MTK_VCODEC_ENC_H_
+#define _MTK_VCODEC_ENC_H_
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
+
+#define MTK_VENC_IRQ_STATUS_SPS	0x1
+#define MTK_VENC_IRQ_STATUS_PPS	0x2
+#define MTK_VENC_IRQ_STATUS_FRM	0x4
+#define MTK_VENC_IRQ_STATUS_DRAM	0x8
+#define MTK_VENC_IRQ_STATUS_PAUSE	0x10
+#define MTK_VENC_IRQ_STATUS_SWITCH	0x20
+
+#define MTK_VENC_IRQ_STATUS_OFFSET	0x05C
+#define MTK_VENC_IRQ_ACK_OFFSET	0x060
+
+/**
+ * struct mtk_video_enc_buf - Private data related to each VB2 buffer.
+ * @vb: Pointer to related VB2 buffer.
+ * @list:	list that buffer link to
+ * @param_change: Types of encode parameter change before encoding this
+ *				buffer
+ * @enc_params: Encode parameters changed before encode this buffer
+ */
+struct mtk_video_enc_buf {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+	u32 param_change;
+	struct mtk_enc_params enc_params;
+};
+
+extern const struct v4l2_ioctl_ops mtk_venc_ioctl_ops;
+extern const struct v4l2_m2m_ops mtk_venc_m2m_ops;
+
+int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx);
+int mtk_venc_lock(struct mtk_vcodec_ctx *ctx);
+int mtk_vcodec_enc_queue_init(void *priv, struct vb2_queue *src_vq,
+			      struct vb2_queue *dst_vq);
+void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx);
+int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx);
+void mtk_vcodec_enc_set_default_params(struct mtk_vcodec_ctx *ctx);
+
+#endif /* _MTK_VCODEC_ENC_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
new file mode 100644
index 0000000..06105e9
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -0,0 +1,454 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*	Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+#include <linux/pm_runtime.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_enc_pm.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu.h"
+
+module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
+module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
+
+/* Wake up context wait_queue */
+static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
+{
+	ctx->int_cond = 1;
+	ctx->int_type = reason;
+	wake_up_interruptible(&ctx->queue);
+}
+
+static void clean_irq_status(unsigned int irq_status, void __iomem *addr)
+{
+	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
+		writel(MTK_VENC_IRQ_STATUS_PAUSE, addr);
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
+		writel(MTK_VENC_IRQ_STATUS_SWITCH, addr);
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
+		writel(MTK_VENC_IRQ_STATUS_DRAM, addr);
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
+		writel(MTK_VENC_IRQ_STATUS_SPS, addr);
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
+		writel(MTK_VENC_IRQ_STATUS_PPS, addr);
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
+		writel(MTK_VENC_IRQ_STATUS_FRM, addr);
+
+}
+static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+	unsigned long flags;
+	void __iomem *addr;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	ctx = dev->curr_ctx;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mtk_v4l2_debug(1, "id=%d", ctx->id);
+	addr = dev->reg_base[VENC_SYS] + MTK_VENC_IRQ_ACK_OFFSET;
+
+	ctx->irq_status = readl(dev->reg_base[VENC_SYS] +
+				(MTK_VENC_IRQ_STATUS_OFFSET));
+
+	clean_irq_status(ctx->irq_status, addr);
+
+	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mtk_vcodec_enc_lt_irq_handler(int irq, void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+	unsigned long flags;
+	void __iomem *addr;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	ctx = dev->curr_ctx;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	mtk_v4l2_debug(1, "id=%d", ctx->id);
+	ctx->irq_status = readl(dev->reg_base[VENC_LT_SYS] +
+				(MTK_VENC_IRQ_STATUS_OFFSET));
+
+	addr = dev->reg_base[VENC_LT_SYS] + MTK_VENC_IRQ_ACK_OFFSET;
+
+	clean_irq_status(ctx->irq_status, addr);
+
+	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
+	return IRQ_HANDLED;
+}
+
+static void mtk_vcodec_enc_reset_handler(void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+
+	mtk_v4l2_debug(0, "Watchdog timeout!!");
+
+	mutex_lock(&dev->dev_mutex);
+	list_for_each_entry(ctx, &dev->ctx_list, list) {
+		ctx->state = MTK_STATE_ABORT;
+		mtk_v4l2_debug(0, "[%d] Change to state MTK_STATE_ABORT",
+				ctx->id);
+	}
+	mutex_unlock(&dev->dev_mutex);
+}
+
+static int fops_vcodec_open(struct file *file)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = NULL;
+	int ret = 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	mutex_lock(&dev->dev_mutex);
+	/*
+	 * Use simple counter to uniquely identify this context. Only
+	 * used for logging.
+	 */
+	ctx->id = dev->id_counter++;
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	INIT_LIST_HEAD(&ctx->list);
+	ctx->dev = dev;
+	init_waitqueue_head(&ctx->queue);
+
+	ctx->type = MTK_INST_ENCODER;
+	ret = mtk_vcodec_enc_ctrls_setup(ctx);
+	if (ret) {
+		mtk_v4l2_err("Failed to setup controls() (%d)",
+				ret);
+		goto err_ctrls_setup;
+	}
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
+				&mtk_vcodec_enc_queue_init);
+	if (IS_ERR((__force void *)ctx->m2m_ctx)) {
+		ret = PTR_ERR((__force void *)ctx->m2m_ctx);
+		mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
+				ret);
+		goto err_m2m_ctx_init;
+	}
+	mtk_vcodec_enc_set_default_params(ctx);
+
+	if (v4l2_fh_is_singular(&ctx->fh)) {
+		/*
+		 * vpu_load_firmware checks if it was loaded already and
+		 * does nothing in that case
+		 */
+		ret = vpu_load_firmware(dev->vpu_plat_dev);
+		if (ret < 0) {
+			/*
+			 * Return 0 if downloading firmware successfully,
+			 * otherwise it is failed
+			 */
+			mtk_v4l2_err("vpu_load_firmware failed!");
+			goto err_load_fw;
+		}
+
+		dev->enc_capability =
+			vpu_get_venc_hw_capa(dev->vpu_plat_dev);
+		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
+	}
+
+	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p ",
+			ctx->id, ctx, ctx->m2m_ctx);
+
+	dev->num_instances++;
+	list_add(&ctx->list, &dev->ctx_list);
+
+	mutex_unlock(&dev->dev_mutex);
+	mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev),
+			ctx->id);
+	return ret;
+
+	/* Deinit when failure occurred */
+err_load_fw:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+err_m2m_ctx_init:
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+err_ctrls_setup:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	mutex_unlock(&dev->dev_mutex);
+
+	return ret;
+}
+
+static int fops_vcodec_release(struct file *file)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
+
+	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
+	mutex_lock(&dev->dev_mutex);
+
+	mtk_vcodec_enc_release(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+
+	list_del_init(&ctx->list);
+	dev->num_instances--;
+	kfree(ctx);
+	mutex_unlock(&dev->dev_mutex);
+	return 0;
+}
+
+static const struct v4l2_file_operations mtk_vcodec_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fops_vcodec_open,
+	.release	= fops_vcodec_release,
+	.poll		= v4l2_m2m_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= v4l2_m2m_fop_mmap,
+};
+
+static int mtk_vcodec_probe(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev;
+	struct video_device *vfd_enc;
+	struct resource *res;
+	int i, j, ret;
+	DEFINE_DMA_ATTRS(attrs);
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dev->ctx_list);
+	dev->plat_dev = pdev;
+
+	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
+	if (dev->vpu_plat_dev == NULL) {
+		mtk_v4l2_err("[VPU] vpu device in not ready");
+		return -EPROBE_DEFER;
+	}
+
+	vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_enc_reset_handler,
+				dev, VPU_RST_ENC);
+
+	ret = mtk_vcodec_init_enc_pm(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to get mt vcodec clock source!");
+		return ret;
+	}
+
+	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
+		if (res == NULL) {
+			dev_err(&pdev->dev, "get memory resource failed.");
+			ret = -ENXIO;
+			goto err_res;
+		}
+		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR((__force void *)dev->reg_base[i])) {
+			dev_err(&pdev->dev,
+				"devm_ioremap_resource %d failed.", i);
+			ret = PTR_ERR((__force void *)dev->reg_base[i]);
+			goto err_res;
+		}
+		mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[i]);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get irq resource");
+		ret = -ENOENT;
+		goto err_res;
+	}
+
+	dev->enc_irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
+			       mtk_vcodec_enc_irq_handler,
+			       0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)",
+			dev->enc_irq,
+			ret);
+		ret = -EINVAL;
+		goto err_res;
+	}
+
+	dev->enc_lt_irq = platform_get_irq(pdev, 1);
+	ret = devm_request_irq(&pdev->dev,
+			       dev->enc_lt_irq, mtk_vcodec_enc_lt_irq_handler,
+			       0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to install dev->enc_lt_irq %d (%d)",
+			dev->enc_lt_irq, ret);
+		ret = -EINVAL;
+		goto err_res;
+	}
+
+	disable_irq(dev->enc_irq);
+	disable_irq(dev->enc_lt_irq); /* VENC_LT */
+	mutex_init(&dev->enc_mutex);
+	mutex_init(&dev->dev_mutex);
+	spin_lock_init(&dev->irqlock);
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
+		 "[MTK_V4L2_VENC]");
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		mtk_v4l2_err("v4l2_device_register err=%d", ret);
+		goto err_res;
+	}
+
+	init_waitqueue_head(&dev->queue);
+
+	/* allocate video device for encoder and register it */
+	vfd_enc = video_device_alloc();
+	if (!vfd_enc) {
+		mtk_v4l2_err("Failed to allocate video device");
+		ret = -ENOMEM;
+		goto err_enc_alloc;
+	}
+	vfd_enc->fops           = &mtk_vcodec_fops;
+	vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
+	vfd_enc->release        = video_device_release;
+	vfd_enc->lock           = &dev->dev_mutex;
+	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
+	vfd_enc->vfl_dir        = VFL_DIR_M2M;
+	vfd_enc->device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE |
+					V4L2_CAP_STREAMING;
+
+	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
+		 MTK_VCODEC_ENC_NAME);
+	video_set_drvdata(vfd_enc, dev);
+	dev->vfd_enc = vfd_enc;
+	platform_set_drvdata(pdev, dev);
+
+	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR((__force void *)dev->alloc_ctx)) {
+		mtk_v4l2_err("Failed to alloc vb2 dma context 0");
+		ret = PTR_ERR((__force void *)dev->alloc_ctx);
+		dev->alloc_ctx = NULL;
+		goto err_vb2_ctx_init;
+	}
+
+	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
+	if (IS_ERR((__force void *)dev->m2m_dev_enc)) {
+		mtk_v4l2_err("Failed to init mem2mem enc device");
+		ret = PTR_ERR((__force void *)dev->m2m_dev_enc);
+		goto err_enc_mem_init;
+	}
+
+	dev->encode_workqueue =
+			alloc_ordered_workqueue(MTK_VCODEC_ENC_NAME,
+						WQ_MEM_RECLAIM |
+						WQ_FREEZABLE);
+	if (!dev->encode_workqueue) {
+		mtk_v4l2_err("Failed to create encode workqueue");
+		ret = -EINVAL;
+		goto err_event_workq;
+	}
+
+	ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
+	if (ret) {
+		mtk_v4l2_err("Failed to register video device");
+		goto err_enc_reg;
+	}
+
+	/* Avoid the iommu eat big hunks */
+	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
+
+	mtk_v4l2_debug(0, "encoder registered as /dev/video%d",
+			vfd_enc->num);
+
+	return 0;
+
+err_enc_reg:
+	destroy_workqueue(dev->encode_workqueue);
+err_event_workq:
+	v4l2_m2m_release(dev->m2m_dev_enc);
+err_enc_mem_init:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+err_vb2_ctx_init:
+	video_unregister_device(vfd_enc);
+err_enc_alloc:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_res:
+	mtk_vcodec_release_enc_pm(dev);
+	return ret;
+}
+
+static const struct of_device_id mtk_vcodec_enc_match[] = {
+	{.compatible = "mediatek,mt8173-vcodec-enc",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mtk_vcodec_enc_match);
+
+static int mtk_vcodec_enc_remove(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
+
+	mtk_v4l2_debug_enter();
+	flush_workqueue(dev->encode_workqueue);
+	destroy_workqueue(dev->encode_workqueue);
+	if (dev->m2m_dev_enc)
+		v4l2_m2m_release(dev->m2m_dev_enc);
+	if (dev->alloc_ctx)
+		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+
+	if (dev->vfd_enc)
+		video_unregister_device(dev->vfd_enc);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	mtk_vcodec_release_enc_pm(dev);
+	return 0;
+}
+
+static struct platform_driver mtk_vcodec_enc_driver = {
+	.probe	= mtk_vcodec_probe,
+	.remove	= mtk_vcodec_enc_remove,
+	.driver	= {
+		.name	= MTK_VCODEC_ENC_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = mtk_vcodec_enc_match,
+	},
+};
+
+module_platform_driver(mtk_vcodec_enc_driver);
+
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek video codec V4L2 encoder driver");
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
new file mode 100644
index 0000000..2379e97
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
@@ -0,0 +1,137 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <linux/clk.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+#include <soc/mediatek/smi.h>
+
+#include "mtk_vcodec_enc_pm.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu.h"
+
+
+int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
+{
+	struct device_node *node;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct mtk_vcodec_pm *pm;
+	int ret = 0;
+
+	pdev = mtkdev->plat_dev;
+	pm = &mtkdev->pm;
+	memset(pm, 0, sizeof(struct mtk_vcodec_pm));
+	pm->mtkdev = mtkdev;
+	pm->dev = &pdev->dev;
+	dev = &pdev->dev;
+
+	node = of_parse_phandle(dev->of_node, "mediatek,larb", 0);
+	if (!node) {
+		mtk_v4l2_err("no mediatek,larb found");
+		return -1;
+	}
+	pdev = of_find_device_by_node(node);
+	if (!pdev) {
+		mtk_v4l2_err("no mediatek,larb device found");
+		return -1;
+	}
+	pm->larbvenc = &pdev->dev;
+
+	node = of_parse_phandle(dev->of_node, "mediatek,larb", 1);
+	if (!node) {
+		mtk_v4l2_err("no mediatek,larb found");
+		return -1;
+	}
+
+	pdev = of_find_device_by_node(node);
+	if (!pdev) {
+		mtk_v4l2_err("no mediatek,larb device found");
+		return -1;
+	}
+
+	pm->larbvenclt = &pdev->dev;
+	pdev = mtkdev->plat_dev;
+	pm->dev = &pdev->dev;
+
+	pm->vencpll_d2 = devm_clk_get(&pdev->dev, "venc_sel_src");
+	if (pm->vencpll_d2 == NULL) {
+		mtk_v4l2_err("devm_clk_get vencpll_d2 fail");
+		ret = -1;
+	}
+
+	pm->venc_sel = devm_clk_get(&pdev->dev, "venc_sel");
+	if (pm->venc_sel == NULL) {
+		mtk_v4l2_err("devm_clk_get venc_sel fail");
+		ret = -1;
+	}
+
+	pm->univpll1_d2 = devm_clk_get(&pdev->dev, "venc_lt_sel_src");
+	if (pm->univpll1_d2 == NULL) {
+		mtk_v4l2_err("devm_clk_get univpll1_d2 fail");
+		ret = -1;
+	}
+
+	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
+	if (pm->venc_lt_sel == NULL) {
+		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
+		ret = -1;
+	}
+
+	return ret;
+}
+
+void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *mtkdev)
+{
+}
+
+
+void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm)
+{
+	int ret;
+
+	ret = clk_prepare_enable(pm->venc_sel);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable fail %d", ret);
+
+	ret = clk_set_parent(pm->venc_sel, pm->vencpll_d2);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent fail %d", ret);
+
+	ret = clk_prepare_enable(pm->venc_lt_sel);
+	if (ret)
+		mtk_v4l2_err("clk_prepare_enable fail %d", ret);
+
+	ret = clk_set_parent(pm->venc_lt_sel, pm->univpll1_d2);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent fail %d", ret);
+
+	ret = mtk_smi_larb_get(pm->larbvenc);
+	if (ret)
+		mtk_v4l2_err("mtk_smi_larb_get larb3 fail %d", ret);
+
+	ret = mtk_smi_larb_get(pm->larbvenclt);
+	if (ret)
+		mtk_v4l2_err("mtk_smi_larb_get larb4 fail %d", ret);
+
+}
+
+void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm)
+{
+	mtk_smi_larb_put(pm->larbvenc);
+	mtk_smi_larb_put(pm->larbvenclt);
+	clk_disable_unprepare(pm->venc_lt_sel);
+	clk_disable_unprepare(pm->venc_sel);
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
new file mode 100644
index 0000000..f321671
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
@@ -0,0 +1,26 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _MTK_VCODEC_ENC_PM_H_
+#define _MTK_VCODEC_ENC_PM_H_
+
+#include "mtk_vcodec_drv.h"
+
+int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *dev);
+void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *dev);
+
+void mtk_vcodec_enc_clock_on(struct mtk_vcodec_pm *pm);
+void mtk_vcodec_enc_clock_off(struct mtk_vcodec_pm *pm);
+
+#endif /* _MTK_VCODEC_ENC_PM_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
new file mode 100644
index 0000000..7f1f104
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
@@ -0,0 +1,55 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <linux/errno.h>
+#include <linux/wait.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+
+int mtk_vcodec_wait_for_done_ctx(struct mtk_vcodec_ctx  *ctx, int command,
+				 unsigned int timeout_ms)
+{
+	wait_queue_head_t *waitqueue;
+	long timeout_jiff, ret;
+	int status = 0;
+
+	waitqueue = (wait_queue_head_t *)&ctx->queue;
+	timeout_jiff = msecs_to_jiffies(timeout_ms);
+
+	ret = wait_event_interruptible_timeout(*waitqueue,
+				(ctx->int_cond &&
+				(ctx->int_type == command)),
+				timeout_jiff);
+
+	if (!ret) {
+		status = -1;	/* timeout */
+		mtk_v4l2_err("[%d] cmd=%d, ctx->type=%d, wait_event_interruptible_timeout time=%ums out %d %d!",
+				ctx->id, ctx->type, command, timeout_ms,
+				ctx->int_cond, ctx->int_type);
+	} else if (-ERESTARTSYS == ret) {
+		mtk_v4l2_err("[%d] cmd=%d, ctx->type=%d, wait_event_interruptible_timeout interrupted by a signal %d %d",
+				ctx->id, ctx->type, command, ctx->int_cond,
+				ctx->int_type);
+		status = -1;
+	}
+
+	ctx->int_cond = 0;
+	ctx->int_type = 0;
+
+	return status;
+}
+EXPORT_SYMBOL(mtk_vcodec_wait_for_done_ctx);
+
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
new file mode 100644
index 0000000..33e890f
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
@@ -0,0 +1,27 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _MTK_VCODEC_INTR_H_
+#define _MTK_VCODEC_INTR_H_
+
+#define MTK_INST_IRQ_RECEIVED		0x1
+#define MTK_INST_WORK_THREAD_ABORT_DONE	0x2
+
+struct mtk_vcodec_ctx;
+
+/* timeout is ms */
+int mtk_vcodec_wait_for_done_ctx(struct mtk_vcodec_ctx *data, int command,
+				unsigned int timeout_ms);
+
+#endif /* _MTK_VCODEC_INTR_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
new file mode 100644
index 0000000..5e36513
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
@@ -0,0 +1,94 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*	Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <linux/module.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu.h"
+
+/* For encoder, this will enable logs in venc/*/
+bool mtk_vcodec_dbg;
+EXPORT_SYMBOL(mtk_vcodec_dbg);
+
+/* The log level of v4l2 encoder or decoder driver.
+ * That is, files under mtk-vcodec/.
+ */
+int mtk_v4l2_dbg_level;
+EXPORT_SYMBOL(mtk_v4l2_dbg_level);
+
+void __iomem *mtk_vcodec_get_reg_addr(struct mtk_vcodec_ctx *data,
+					unsigned int reg_idx)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	if (!data || reg_idx >= NUM_MAX_VCODEC_REG_BASE) {
+		mtk_v4l2_err("Invalid arguments, reg_idx=%d", reg_idx);
+		return NULL;
+	}
+	return ctx->dev->reg_base[reg_idx];
+}
+EXPORT_SYMBOL(mtk_vcodec_get_reg_addr);
+
+int mtk_vcodec_mem_alloc(struct mtk_vcodec_ctx *data,
+			struct mtk_vcodec_mem *mem)
+{
+	unsigned long size = mem->size;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+	struct device *dev = &ctx->dev->plat_dev->dev;
+
+	mem->va = dma_alloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
+
+	if (!mem->va) {
+		mtk_v4l2_err("%s dma_alloc size=%ld failed!", dev_name(dev),
+			     size);
+		return -ENOMEM;
+	}
+
+	memset(mem->va, 0, size);
+
+	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->id, mem->va);
+	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->id,
+		       (unsigned long)mem->dma_addr);
+	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->id, size);
+
+	return 0;
+}
+EXPORT_SYMBOL(mtk_vcodec_mem_alloc);
+
+void mtk_vcodec_mem_free(struct mtk_vcodec_ctx *data,
+			struct mtk_vcodec_mem *mem)
+{
+	unsigned long size = mem->size;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+	struct device *dev = &ctx->dev->plat_dev->dev;
+
+	if (!mem->va) {
+		mtk_v4l2_err("%s dma_free size=%ld failed!", dev_name(dev),
+			     size);
+		return;
+	}
+
+	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
+	mem->va = NULL;
+	mem->dma_addr = 0;
+	mem->size = 0;
+
+	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->id, mem->va);
+	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->id,
+		       (unsigned long)mem->dma_addr);
+	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->id, size);
+}
+EXPORT_SYMBOL(mtk_vcodec_mem_free);
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
new file mode 100644
index 0000000..d6345fc
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
@@ -0,0 +1,87 @@
+/*
+* Copyright (c) 2016 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*	Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _MTK_VCODEC_UTIL_H_
+#define _MTK_VCODEC_UTIL_H_
+
+#include <linux/types.h>
+#include <linux/dma-direction.h>
+
+struct mtk_vcodec_mem {
+	size_t size;
+	void *va;
+	dma_addr_t dma_addr;
+};
+
+struct mtk_vcodec_ctx;
+
+extern int mtk_v4l2_dbg_level;
+extern bool mtk_vcodec_dbg;
+
+#define DEBUG	1
+
+#if defined(DEBUG)
+
+#define mtk_v4l2_debug(level, fmt, args...)				 \
+	do {								 \
+		if (mtk_v4l2_dbg_level >= level)			 \
+			pr_info("[MTK_V4L2] level=%d %s(),%d: " fmt "\n",\
+				level, __func__, __LINE__, ##args);	 \
+	} while (0)
+
+#define mtk_v4l2_err(fmt, args...)                \
+	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
+	       ##args)
+
+
+#define mtk_v4l2_debug_enter()  mtk_v4l2_debug(3, "+")
+#define mtk_v4l2_debug_leave()  mtk_v4l2_debug(3, "-")
+
+#define mtk_vcodec_debug(h, fmt, args...)				\
+	do {								\
+		if (mtk_vcodec_dbg)					\
+			pr_info("[MTK_VCODEC][%d]: %s() " fmt "\n",	\
+				((struct mtk_vcodec_ctx *)h->ctx)->id, \
+				__func__, ##args);			\
+	} while (0)
+
+#define mtk_vcodec_err(h, fmt, args...)					\
+	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
+	       ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
+
+#define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+")
+#define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-")
+
+#else
+
+#define mtk_v4l2_debug(level, fmt, args...)
+#define mtk_v4l2_err(fmt, args...)
+#define mtk_v4l2_debug_enter()
+#define mtk_v4l2_debug_leave()
+
+#define mtk_vcodec_debug(h, fmt, args...)
+#define mtk_vcodec_err(h, fmt, args...)
+#define mtk_vcodec_debug_enter(h)
+#define mtk_vcodec_debug_leave(h)
+
+#endif
+
+void __iomem *mtk_vcodec_get_reg_addr(struct mtk_vcodec_ctx *data,
+				unsigned int reg_idx);
+int mtk_vcodec_mem_alloc(struct mtk_vcodec_ctx *data,
+				struct mtk_vcodec_mem *mem);
+void mtk_vcodec_mem_free(struct mtk_vcodec_ctx *data,
+				struct mtk_vcodec_mem *mem);
+#endif /* _MTK_VCODEC_UTIL_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_base.h b/drivers/media/platform/mtk-vcodec/venc_drv_base.h
new file mode 100644
index 0000000..6308d44
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_base.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *	Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *	Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _VENC_DRV_BASE_
+#define _VENC_DRV_BASE_
+
+#include "mtk_vcodec_drv.h"
+
+#include "venc_drv_if.h"
+
+struct venc_common_if {
+	/**
+	 * (*init)() - initialize driver
+	 * @ctx:	[in] mtk v4l2 context
+	 * @handle: [out] driver handle
+	 */
+	int (*init)(struct mtk_vcodec_ctx *ctx, unsigned long *handle);
+
+	/**
+	 * (*encode)() - trigger encode
+	 * @handle: [in] driver handle
+	 * @opt: [in] encode option
+	 * @frm_buf: [in] frame buffer to store input frame
+	 * @bs_buf: [in] bitstream buffer to store output bitstream
+	 * @result: [out] encode result
+	 */
+	int (*encode)(unsigned long handle, enum venc_start_opt opt,
+		      struct venc_frm_buf *frm_buf,
+		      struct mtk_vcodec_mem *bs_buf,
+		      struct venc_done_result *result);
+
+	/**
+	 * (*set_param)() - set driver's parameter
+	 * @handle: [in] driver handle
+	 * @type: [in] parameter type
+	 * @in: [in] buffer to store the parameter
+	 */
+	int (*set_param)(unsigned long handle, enum venc_set_param_type type,
+			 struct venc_enc_param *in);
+
+	/**
+	 * (*deinit)() - deinitialize driver.
+	 * @handle: [in] driver handle
+	 */
+	int (*deinit)(unsigned long handle);
+};
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
new file mode 100644
index 0000000..79ec9f5
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *	Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *	Tiffany Lin <tiffany.lin@mediatek.com>
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
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "venc_drv_if.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_enc_pm.h"
+#include "mtk_vpu.h"
+
+#include "venc_drv_base.h"
+
+int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
+{
+	int ret = 0;
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_VP8:
+	case V4L2_PIX_FMT_H264:
+	default:
+		return -EINVAL;
+	}
+
+	mtk_venc_lock(ctx);
+	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
+	ret = ctx->enc_if->init(ctx, (unsigned long *)&ctx->drv_handle);
+	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
+	mtk_venc_unlock(ctx);
+
+	return ret;
+}
+
+int venc_if_set_param(struct mtk_vcodec_ctx *ctx,
+		enum venc_set_param_type type, struct venc_enc_param *in)
+{
+	int ret = 0;
+
+	mtk_venc_lock(ctx);
+	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
+	ret = ctx->enc_if->set_param(ctx->drv_handle, type, in);
+	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
+	mtk_venc_unlock(ctx);
+
+	return ret;
+}
+
+int venc_if_encode(struct mtk_vcodec_ctx *ctx,
+		   enum venc_start_opt opt, struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   struct venc_done_result *result)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	mtk_venc_lock(ctx);
+
+	spin_lock_irqsave(&ctx->dev->irqlock, flags);
+	ctx->dev->curr_ctx = ctx;
+	spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+
+	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
+	ret = ctx->enc_if->encode(ctx->drv_handle, opt, frm_buf,
+				  bs_buf, result);
+	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
+
+	spin_lock_irqsave(&ctx->dev->irqlock, flags);
+	ctx->dev->curr_ctx = NULL;
+	spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+
+	mtk_venc_unlock(ctx);
+	return ret;
+}
+
+int venc_if_deinit(struct mtk_vcodec_ctx *ctx)
+{
+	int ret = 0;
+
+	if (ctx->drv_handle == 0)
+		return 0;
+
+	mtk_venc_lock(ctx);
+	mtk_vcodec_enc_clock_on(&ctx->dev->pm);
+	ret = ctx->enc_if->deinit(ctx->drv_handle);
+	mtk_vcodec_enc_clock_off(&ctx->dev->pm);
+	mtk_venc_unlock(ctx);
+
+	ctx->drv_handle = 0;
+
+	return ret;
+}
diff --git a/drivers/media/platform/mtk-vcodec/venc_drv_if.h b/drivers/media/platform/mtk-vcodec/venc_drv_if.h
new file mode 100644
index 0000000..a6e7d32
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_drv_if.h
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *		Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *		Tiffany Lin <tiffany.lin@mediatek.com>
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
+#ifndef _VENC_DRV_IF_H_
+#define _VENC_DRV_IF_H_
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+
+/*
+ * enum venc_yuv_fmt - The type of input yuv format
+ * (VPU related: If you change the order, you must also update the VPU codes.)
+ * @VENC_YUV_FORMAT_I420: I420 YUV format
+ * @VENC_YUV_FORMAT_YV12: YV12 YUV format
+ * @VENC_YUV_FORMAT_NV12: NV12 YUV format
+ * @VENC_YUV_FORMAT_NV21: NV21 YUV format
+ */
+enum venc_yuv_fmt {
+	VENC_YUV_FORMAT_I420 = 3,
+	VENC_YUV_FORMAT_YV12 = 5,
+	VENC_YUV_FORMAT_NV12 = 6,
+	VENC_YUV_FORMAT_NV21 = 7,
+};
+
+/*
+ * enum venc_start_opt - encode frame option used in venc_if_encode()
+ * @VENC_START_OPT_ENCODE_SEQUENCE_HEADER: encode SPS/PPS for H264
+ * @VENC_START_OPT_ENCODE_FRAME: encode normal frame
+ */
+enum venc_start_opt {
+	VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
+	VENC_START_OPT_ENCODE_FRAME,
+};
+
+/*
+ * enum venc_set_param_type - The type of set parameter used in
+ *						      venc_if_set_param()
+ * (VPU related: If you change the order, you must also update the VPU codes.)
+ * @VENC_SET_PARAM_ENC: set encoder parameters
+ * @VENC_SET_PARAM_FORCE_INTRA: force an intra frame
+ * @VENC_SET_PARAM_ADJUST_BITRATE: adjust bitrate (in bps)
+ * @VENC_SET_PARAM_ADJUST_FRAMERATE: set frame rate
+ * @VENC_SET_PARAM_GOP_SIZE: set IDR interval
+ * @VENC_SET_PARAM_INTRA_PERIOD: set I frame interval
+ * @VENC_SET_PARAM_SKIP_FRAME: set H264 skip one frame
+ * @VENC_SET_PARAM_PREPEND_HEADER: set H264 prepend SPS/PPS before IDR
+ * @VENC_SET_PARAM_TS_MODE: set VP8 temporal scalability mode
+ */
+enum venc_set_param_type {
+	VENC_SET_PARAM_ENC,
+	VENC_SET_PARAM_FORCE_INTRA,
+	VENC_SET_PARAM_ADJUST_BITRATE,
+	VENC_SET_PARAM_ADJUST_FRAMERATE,
+	VENC_SET_PARAM_GOP_SIZE,
+	VENC_SET_PARAM_INTRA_PERIOD,
+	VENC_SET_PARAM_SKIP_FRAME,
+	VENC_SET_PARAM_PREPEND_HEADER,
+	VENC_SET_PARAM_TS_MODE,
+};
+
+/*
+ * struct venc_enc_prm - encoder settings for VENC_SET_PARAM_ENC used in
+ *					  venc_if_set_param()
+ * @input_fourcc: input yuv format
+ * @h264_profile: V4L2 defined H.264 profile
+ * @h264_level: V4L2 defined H.264 level
+ * @width: image width
+ * @height: image height
+ * @buf_width: buffer width
+ * @buf_height: buffer height
+ * @frm_rate: frame rate in fps
+ * @intra_period: intra frame period
+ * @bitrate: target bitrate in bps
+ * @gop_size: group of picture size
+ */
+struct venc_enc_param {
+	enum venc_yuv_fmt input_yuv_fmt;
+	unsigned int h264_profile;
+	unsigned int h264_level;
+	unsigned int width;
+	unsigned int height;
+	unsigned int buf_width;
+	unsigned int buf_height;
+	unsigned int frm_rate;
+	unsigned int intra_period;
+	unsigned int bitrate;
+	unsigned int gop_size;
+};
+
+/*
+ * struct venc_frm_buf - frame buffer information used in venc_if_encode()
+ * @fb_addr: plane frame buffer addresses
+ */
+struct venc_frm_buf {
+	struct mtk_vcodec_mem fb_addr[MTK_VCODEC_MAX_PLANES];
+};
+
+/*
+ * struct venc_done_result - This is return information used in venc_if_encode()
+ * @bs_size: output bitstream size
+ * @is_key_frm: output is key frame or not
+ */
+struct venc_done_result {
+	unsigned int bs_size;
+	bool is_key_frm;
+};
+
+/*
+ * venc_if_init - Create the driver handle
+ * @ctx: device context
+ * @fourcc: encoder input format
+ * Return: 0 if creating handle successfully, otherwise it is failed.
+ */
+int venc_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc);
+
+/*
+ * venc_if_deinit - Release the driver handle
+ * @ctx: device context
+ * Return: 0 if releasing handle successfully, otherwise it is failed.
+ */
+int venc_if_deinit(struct mtk_vcodec_ctx *ctx);
+
+/*
+ * venc_if_set_param - Set parameter to driver
+ * @ctx: device context
+ * @type: parameter type
+ * @in: input parameter
+ * Return: 0 if setting param successfully, otherwise it is failed.
+ */
+int venc_if_set_param(struct mtk_vcodec_ctx *ctx,
+		      enum venc_set_param_type type,
+		      struct venc_enc_param *in);
+
+/*
+ * venc_if_encode - Encode one frame
+ * @ctx: device context
+ * @opt: encode frame option
+ * @frm_buf: input frame buffer information
+ * @bs_buf: output bitstream buffer infomraiton
+ * @result: encode result
+ * Return: 0 if encoding frame successfully, otherwise it is failed.
+ */
+int venc_if_encode(struct mtk_vcodec_ctx *ctx,
+		   enum venc_start_opt opt,
+		   struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   struct venc_done_result *result);
+
+#endif /* _VENC_DRV_IF_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h b/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
new file mode 100644
index 0000000..4c869cb
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
@@ -0,0 +1,210 @@
+/*
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *	   Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *	   Tiffany Lin <tiffany.lin@mediatek.com>
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
+#define AP_IPIMSG_VENC_BASE 0xC000
+#define VPU_IPIMSG_VENC_BASE 0xD000
+
+/**
+ * enum venc_ipi_msg_id - message id between AP and VPU
+ * (ipi stands for inter-processor interrupt)
+ * @AP_IPIMSG_ENC_XXX:		AP to VPU cmd message id
+ * @VPU_IPIMSG_ENC_XXX_DONE:	VPU ack AP cmd message id
+ */
+enum venc_ipi_msg_id {
+	AP_IPIMSG_ENC_INIT = AP_IPIMSG_VENC_BASE,
+	AP_IPIMSG_ENC_SET_PARAM,
+	AP_IPIMSG_ENC_ENCODE,
+	AP_IPIMSG_ENC_DEINIT,
+
+	VPU_IPIMSG_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE,
+	VPU_IPIMSG_ENC_SET_PARAM_DONE,
+	VPU_IPIMSG_ENC_ENCODE_DONE,
+	VPU_IPIMSG_ENC_DEINIT_DONE,
+};
+
+/**
+ * struct venc_ap_ipi_msg_init - AP to VPU init cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_INIT)
+ * @reserved:	reserved for future use. vpu is running in 32bit. Without
+ *		this reserved field, if kernel run in 64bit. this struct size
+ *		will be different between kernel and vpu
+ * @venc_inst:	AP encoder instance
+ *		(struct venc_vp8_inst/venc_h264_inst *)
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
+ * @vpu_inst_addr:	VPU encoder instance addr
+ *			(struct venc_vp8_vsi/venc_h264_vsi *)
+ * @param_id:	parameter id (venc_set_param_type)
+ * @data_item:	number of items in the data array
+ * @data[8]:	data array to store the set parameters
+ */
+struct venc_ap_ipi_msg_set_param {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
+	uint32_t param_id;
+	uint32_t data_item;
+	uint32_t data[8];
+};
+
+/**
+ * struct venc_ap_ipi_msg_enc - AP to VPU enc cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_ENCODE)
+ * @vpu_inst_addr:	VPU encoder instance addr
+ *			(struct venc_vp8_vsi/venc_h264_vsi *)
+ * @bs_mode:	bitstream mode for h264
+ *		(H264_BS_MODE_SPS/H264_BS_MODE_PPS/H264_BS_MODE_FRAME)
+ * @input_addr:	pointer to input image buffer plane
+ * @bs_addr:	pointer to output bit stream buffer
+ * @bs_size:	bit stream buffer size
+ */
+struct venc_ap_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
+	uint32_t bs_mode;
+	uint32_t input_addr[3];
+	uint32_t bs_addr;
+	uint32_t bs_size;
+};
+
+/**
+ * struct venc_ap_ipi_msg_deinit - AP to VPU deinit cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_DEINIT)
+ * @vpu_inst_addr:	VPU encoder instance addr
+ *			(struct venc_vp8_vsi/venc_h264_vsi *)
+ */
+struct venc_ap_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t vpu_inst_addr;
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
+ * @venc_inst:	AP encoder instance (struct venc_vp8_inst/venc_h264_inst *)
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
+ * @venc_inst:	AP encoder instance (struct venc_vp8_inst/venc_h264_inst *)
+ * @vpu_inst_addr:	VPU encoder instance addr
+ *			(struct venc_vp8_vsi/venc_h264_vsi *)
+ * @reserved:	reserved for future use. vpu is running in 32bit. Without
+ *		this reserved field, if kernel run in 64bit. this struct size
+ *		will be different between kernel and vpu
+ */
+struct venc_vpu_ipi_msg_init {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t vpu_inst_addr;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_set_param - VPU ack AP set_param cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_inst/venc_h264_inst *)
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
+ * @venc_inst:	AP encoder instance (struct venc_vp8_inst/venc_h264_inst *)
+ * @state:	encode state (venc_ipi_msg_enc_state)
+ * @is_key_frm:	whether the encoded frame is key frame
+ * @bs_size:	encoded bitstream size
+ * @reserved:	reserved for future use. vpu is running in 32bit. Without
+ *		this reserved field, if kernel run in 64bit. this struct size
+ *		will be different between kernel and vpu
+ */
+struct venc_vpu_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t state;
+	uint32_t is_key_frm;
+	uint32_t bs_size;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_deinit - VPU ack AP deinit cmd structure
+ * @msg_id:   message id (VPU_IPIMSG_XXX_ENC_DEINIT_DONE)
+ * @status:   cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_inst/venc_h264_inst *)
+ */
+struct venc_vpu_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+};
+
+#endif /* _VENC_IPI_MSG_H_ */
-- 
1.7.9.5

