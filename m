Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33965 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdGYRkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 13:40:43 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] [media] v4l2: Add support for go2001 PCI codec driver
Date: Tue, 25 Jul 2017 19:40:22 +0200
Message-Id: <1501004422-8294-2-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1501004422-8294-1-git-send-email-thierry.escande@collabora.com>
References: <1501004422-8294-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the go2001 PCI codec driver. This hardware
is present on ChromeOS based devices like the Acer ChromeBox and Acer/LG
ChromeBase 24 devices. This chipset comes on a mini PCI-E card with
Google as PCI vendor ID (0x1ae0).

This driver comes from the ChromeOS v3.18 kernel tree and has been
modified to support vb2_buffer restructuring introduced in Linux v4.4.

The go2001 firmware files can be found in the build tree of the Google
Chromium OS open source project.

This driver is originally developed by:
 Pawel Osciak <posciak@chromium.org>
 Ville-Mikko Rautio <vmr@chromium.org>
 henryhsu <henryhsu@chromium.org>
 Wu-Cheng Li <wuchengli@chromium.org>

Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/pci/Kconfig                |    2 +
 drivers/media/pci/Makefile               |    1 +
 drivers/media/pci/go2001/Kconfig         |   11 +
 drivers/media/pci/go2001/Makefile        |    2 +
 drivers/media/pci/go2001/go2001.h        |  331 ++++
 drivers/media/pci/go2001/go2001_driver.c | 2525 ++++++++++++++++++++++++++++++
 drivers/media/pci/go2001/go2001_hw.c     | 1362 ++++++++++++++++
 drivers/media/pci/go2001/go2001_hw.h     |   55 +
 drivers/media/pci/go2001/go2001_proto.h  |  359 +++++
 9 files changed, 4648 insertions(+)
 create mode 100644 drivers/media/pci/go2001/Kconfig
 create mode 100644 drivers/media/pci/go2001/Makefile
 create mode 100644 drivers/media/pci/go2001/go2001.h
 create mode 100644 drivers/media/pci/go2001/go2001_driver.c
 create mode 100644 drivers/media/pci/go2001/go2001_hw.c
 create mode 100644 drivers/media/pci/go2001/go2001_hw.h
 create mode 100644 drivers/media/pci/go2001/go2001_proto.h

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index da28e68..837681e 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -54,5 +54,7 @@ source "drivers/media/pci/smipcie/Kconfig"
 source "drivers/media/pci/netup_unidvb/Kconfig"
 endif
 
+source "drivers/media/pci/go2001/Kconfig"
+
 endif #MEDIA_PCI_SUPPORT
 endif #PCI
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index a7e8af0..58639b7 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_STA2X11_VIP) += sta2x11/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
 obj-$(CONFIG_VIDEO_COBALT) += cobalt/
 obj-$(CONFIG_VIDEO_TW5864) += tw5864/
+obj-$(CONFIG_VIDEO_GO2001) += go2001/
diff --git a/drivers/media/pci/go2001/Kconfig b/drivers/media/pci/go2001/Kconfig
new file mode 100644
index 0000000..c7b5149
--- /dev/null
+++ b/drivers/media/pci/go2001/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_GO2001
+	tristate "GO2001 codec driver"
+	depends on VIDEO_V4L2 && PCI
+	select VIDEOBUF2_DMA_SG
+	---help---
+	  This driver supports the GO2001 PCI hardware codec. This codec
+	  is present on ChromeOS based devices like the Acer ChromeBox
+	  and ChromeBase 24 and LG ChromeBase as well.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called go2001.
diff --git a/drivers/media/pci/go2001/Makefile b/drivers/media/pci/go2001/Makefile
new file mode 100644
index 0000000..20bad18
--- /dev/null
+++ b/drivers/media/pci/go2001/Makefile
@@ -0,0 +1,2 @@
+go2001-objs	:= go2001_driver.o go2001_hw.o
+obj-$(CONFIG_VIDEO_GO2001) += go2001.o
diff --git a/drivers/media/pci/go2001/go2001.h b/drivers/media/pci/go2001/go2001.h
new file mode 100644
index 0000000..0e5ccfd
--- /dev/null
+++ b/drivers/media/pci/go2001/go2001.h
@@ -0,0 +1,331 @@
+/*
+ *  go2001 - GO2001 codec driver.
+ *
+ *  Author : Pawel Osciak <posciak@chromium.org>
+ *
+ *  Copyright (C) 2017 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _MEDIA_PCI_GO2001_GO2001_H_
+#define _MEDIA_PCI_GO2001_GO2001_H_
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+
+#include "go2001_proto.h"
+
+struct go2001_msg {
+	struct list_head list_entry;
+	struct go2001_msg_payload payload;
+};
+
+static inline struct go2001_msg_hdr *msg_to_hdr(struct go2001_msg *msg)
+{
+	return &msg->payload.hdr;
+}
+
+static inline void *msg_to_param(struct go2001_msg *msg)
+{
+	return msg->payload.param;
+}
+
+struct go2001_msg_ring {
+	struct go2001_msg_ring_desc desc;
+	void __iomem *desc_iomem;
+	void __iomem *data_iomem;
+	spinlock_t lock;
+};
+
+struct go2001_hw_inst {
+	struct list_head inst_entry;
+
+	u32 session_id;
+	u32 sequence_id;
+	u32 last_reply_seq_id;
+
+	struct list_head pending_list;
+};
+
+struct go2001_dev {
+	struct pci_dev *pdev;
+	struct v4l2_device v4l2_dev;
+	struct video_device dec_vdev;
+	struct video_device enc_vdev;
+
+	struct mutex lock;
+
+	void __iomem *iomem;
+	size_t iomem_size;
+
+	struct go2001_msg_ring tx_ring;
+	struct go2001_msg_ring rx_ring;
+	size_t max_param_size;
+
+	spinlock_t irqlock;
+	struct list_head inst_list;
+	struct list_head new_inst_list;
+	struct go2001_hw_inst *curr_hw_inst;
+
+	struct list_head ctx_list;
+
+	u32 last_reply_inst_id;
+	u32 last_reply_seq_id;
+	struct go2001_msg last_reply;
+
+	/* Last seq_id for init instance message. */
+	u32 last_init_inst_seq_id;
+	wait_queue_head_t reply_wq;
+
+	struct go2001_hw_inst ctrl_inst;
+	struct completion fw_completion;
+	/* Protected by irqlock */
+	bool fw_loaded;
+	int msgs_in_flight;
+	struct delayed_work watchdog_work;
+
+	/* Protected by lock */
+	bool initialized;
+
+	struct kmem_cache *msg_cache;
+};
+
+enum go2001_codec_mode {
+	CODEC_MODE_DECODER = (1 << 0),
+	CODEC_MODE_ENCODER = (1 << 1),
+};
+
+enum go2001_fmt_type {
+	FMT_TYPE_RAW,
+	FMT_TYPE_CODED,
+};
+
+struct go2001_fmt {
+	enum go2001_fmt_type type;
+	const char *desc;
+	u32 pixelformat;
+	unsigned int num_planes;
+	u32 hw_format;
+	unsigned long codec_modes;
+	/* Minimum pixel alignment for horizontal resolution. */
+	unsigned int h_align;
+	/* Minimum pixel alignment for vertical resolution. */
+	unsigned int v_align;
+	/* Bits per line */
+	unsigned char plane_row_depth[VIDEO_MAX_PLANES];
+	/* Bits per plane */
+	unsigned char plane_depth[VIDEO_MAX_PLANES];
+};
+
+struct go2001_ctrl {
+	u32 id;
+	enum v4l2_ctrl_type type;
+	const char *name;
+	s32 min;
+	s32 max;
+	u32 step;
+	s32 def;
+	u32 flags;
+};
+
+enum go2001_codec_state {
+	UNCOMMITTED,
+	COMMITTED,
+	NEED_HEADER_INFO,
+	RUNNING,
+	PAUSED,
+	RES_CHANGE,
+	ERROR,
+};
+
+struct go2001_frame_info {
+	unsigned int width;
+	unsigned int height;
+	unsigned int coded_width;
+	unsigned int coded_height;
+	unsigned int bytesperline[VIDEO_MAX_PLANES];
+	size_t plane_size[VIDEO_MAX_PLANES];
+};
+
+#define GO2001_REPLY_TIMEOUT_MS		10000
+#define GO2001_WATCHDOG_TIMEOUT_MS	2000
+
+struct go2001_dma_desc {
+	/* DMA address of the map list */
+	dma_addr_t dma_addr;
+	/* Number of entries on the map list */
+	int num_entries;
+	/* CPU address of the map list */
+	struct go2001_mmap_list_entry *mmap_list;
+	/* Size in bytes of the list */
+	size_t list_size;
+	/*
+	 * DMA address of the first entry on the list.
+	 * Used to identify the buffer when passing it to the HW.
+	 */
+	u64 map_addr;
+};
+
+struct go2001_enc_params {
+	u32 bitrate;
+	u32 framerate_num;
+	u32 framerate_denom;
+	bool rc_enable;
+	bool request_keyframe;
+	bool multi_ref_frame_mode;
+	u32 frames_since_intra;
+};
+
+enum go2001_enc_param_change_bit {
+	GO2001_BITRATE_CHANGE,
+	GO2001_FRAMERATE_CHANGE,
+	GO2001_KEYFRAME_REQUESTED,
+	GO2001_PARAM_CHANGE_MAX,
+};
+
+struct go2001_runtime_enc_params {
+	struct go2001_enc_params enc_params;
+	unsigned long changed_mask[BITS_TO_LONGS(GO2001_PARAM_CHANGE_MAX)];
+};
+
+struct go2001_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+	struct go2001_dma_desc dma_desc[VIDEO_MAX_PLANES];
+	bool mapped;
+
+	struct go2001_msg *msg;
+
+	struct go2001_runtime_enc_params rt_enc_params;
+	size_t partition_off[VP8_MAX_NUM_PARTITIONS];
+	size_t partition_size[VP8_MAX_NUM_PARTITIONS];
+};
+
+struct go2001_job {
+	struct go2001_buffer *src_buf;
+	struct go2001_buffer *dst_buf;
+};
+
+#define GO2001_MSG_POOL_SIZE	VIDEO_MAX_FRAME
+struct go2001_ctx {
+	struct list_head ctx_entry;
+
+	struct mutex lock;
+	struct v4l2_fh v4l2_fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct go2001_dev *gdev;
+	enum go2001_codec_mode codec_mode;
+
+	struct go2001_fmt *src_fmt;
+	struct go2001_fmt *dst_fmt;
+	struct go2001_frame_info finfo;
+	size_t bitstream_buf_size;
+
+	enum go2001_codec_state state;
+	struct vb2_queue src_vq;
+	struct vb2_queue dst_vq;
+
+	spinlock_t qlock;
+	struct list_head src_buf_q;
+	struct list_head src_resume_q;
+	struct list_head dst_buf_q;
+
+	struct go2001_hw_inst hw_inst;
+
+	/* Currently running job, if any. */
+	struct go2001_job job;
+
+	struct go2001_enc_params enc_params;
+	/* Will be applied to the next source buffer queued. */
+	struct go2001_runtime_enc_params pending_rt_params;
+
+	bool need_resume;
+};
+
+static inline struct go2001_buffer *vb_to_go2001_buf(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct go2001_buffer, vb);
+}
+
+static inline struct go2001_ctx *hw_inst_to_ctx(struct go2001_hw_inst *hw_inst)
+{
+	return container_of(hw_inst, struct go2001_ctx, hw_inst);
+}
+
+static inline bool go2001_has_frame_info(struct go2001_ctx *ctx)
+{
+	if (ctx->codec_mode == CODEC_MODE_DECODER)
+		return ctx->dst_fmt && ctx->finfo.width != 0;
+	else
+		return ctx->src_fmt && ctx->finfo.width != 0;
+}
+
+static inline struct go2001_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct go2001_ctx, v4l2_fh);
+}
+
+static inline struct go2001_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct go2001_ctx, ctrl_handler);
+}
+
+extern unsigned int go2001_debug_level;
+extern unsigned int go2001_fw_debug_level;
+
+#define go2001_err_nodev(fmt, args...) \
+	pr_err("%s:%d " fmt, __func__, __LINE__, ##args)
+
+#define go2001_err(gdev, fmt, args...) \
+	dev_err(&(gdev)->pdev->dev, "%s:%d " fmt, __func__, __LINE__, ##args)
+
+#define go2001_info(gdev, fmt, args...) \
+	dev_info(&(gdev)->pdev->dev, "%s:%d " fmt, __func__, __LINE__, ##args)
+
+#define go2001_dbg(gdev, level, fmt, args...)				\
+	do {								\
+		if (go2001_debug_level >= (level))			\
+			dev_info(&(gdev)->pdev->dev, "%s:%d " fmt,	\
+				 __func__, __LINE__, ##args);		\
+	} while (0)
+
+#define go2001_trace(gdev) \
+	go2001_dbg((gdev), 5, "%s\n", __func__)
+
+static inline void go2001_set_ctx_state(struct go2001_ctx *ctx,
+					enum go2001_codec_state state)
+{
+	go2001_dbg(ctx->gdev, 2, "ctx %p state change %d->%d\n", ctx,
+		   ctx->state, state);
+	ctx->state = state;
+}
+
+#define GO2001_MIN_NUM_BITSTREAM_BUFFERS	4
+#define GO2001_MIN_NUM_FRAME_BUFFERS		8
+#define GO2001_DEF_BITSTREAM_BUFFER_SIZE	SZ_1M
+#define GO2001_DEF_BITRATE			1000000
+#define GO2001_MAX_FPS				30
+#define GO2001_DEF_RC_ENABLE			1
+#define GO2001_VPX_MACROBLOCK_SIZE		16
+
+#endif /* _MEDIA_PCI_GO2001_GO2001_H_ */
diff --git a/drivers/media/pci/go2001/go2001_driver.c b/drivers/media/pci/go2001/go2001_driver.c
new file mode 100644
index 0000000..1034efc
--- /dev/null
+++ b/drivers/media/pci/go2001/go2001_driver.c
@@ -0,0 +1,2525 @@
+/*
+ *  go2001 - GO2001 codec driver.
+ *
+ *  Author : Pawel Osciak <posciak@chromium.org>
+ *
+ *  Copyright (C) 2017 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kmod.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+
+#include <media/v4l2-event.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "go2001.h"
+#include "go2001_hw.h"
+
+#define DRIVER_NAME "go2001"
+#define VDEV_NAME_DEC (DRIVER_NAME "-dec")
+#define VDEV_NAME_ENC (DRIVER_NAME "-enc")
+
+#define DST_QUEUE_OFF_BASE	BIT(30)
+
+unsigned int go2001_debug_level;
+unsigned int go2001_fw_debug_level;
+
+module_param(go2001_debug_level, uint, 0644);
+MODULE_PARM_DESC(go2001_debug_level, " verbosity level for debug messages.");
+
+module_param(go2001_fw_debug_level, uint, 0644);
+MODULE_PARM_DESC(go2001_fw_debug_level, " verbosity level for firmware debug messages.");
+
+static void go2001_cleanup_queue(struct go2001_ctx *ctx,
+				 struct list_head *buf_list)
+{
+	struct go2001_buffer *buf, *buf_tmp;
+	int i;
+
+	assert_spin_locked(&ctx->qlock);
+
+	list_for_each_entry_safe(buf, buf_tmp, buf_list, list) {
+		list_del(&buf->list);
+		for (i = 0; i < buf->vb.num_planes; ++i)
+			vb2_set_plane_payload(&buf->vb, i, 0);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void go2001_buffer_done_queued(struct go2001_ctx *ctx,
+				      struct list_head *buf_list)
+{
+	struct go2001_buffer *buf, *buf_tmp;
+
+	assert_spin_locked(&ctx->qlock);
+
+	list_for_each_entry_safe(buf, buf_tmp, buf_list, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+}
+
+static void go2001_ctx_error_locked(struct go2001_ctx *ctx)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	unsigned long flags;
+
+	assert_spin_locked(&gdev->irqlock);
+
+	go2001_err(ctx->gdev, "Setting error state for ctx %p, session_id %d\n",
+		   ctx, ctx->hw_inst.session_id);
+
+	go2001_cancel_hw_inst_locked(gdev, &ctx->hw_inst);
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+
+	go2001_set_ctx_state(ctx, ERROR);
+	memset(&ctx->job, 0, sizeof(struct go2001_job));
+	go2001_cleanup_queue(ctx, &ctx->src_buf_q);
+	go2001_cleanup_queue(ctx, &ctx->src_resume_q);
+	go2001_cleanup_queue(ctx, &ctx->dst_buf_q);
+
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+}
+
+static void go2001_cancel_all_contexts(struct go2001_dev *gdev)
+{
+	unsigned long flags;
+	struct go2001_ctx *ctx;
+
+	go2001_trace(gdev);
+
+	WARN_ON(!mutex_is_locked(&gdev->lock));
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+
+	go2001_cancel_all_hw_inst_locked(gdev);
+
+	list_for_each_entry(ctx, &gdev->ctx_list, ctx_entry)
+		go2001_ctx_error_locked(ctx);
+
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+	wake_up_all(&gdev->reply_wq);
+}
+
+static struct go2001_fmt formats[] = {
+	{
+		.type = FMT_TYPE_RAW,
+		.pixelformat = V4L2_PIX_FMT_RGB32,
+		.num_planes = 1,
+		.hw_format = GO2001_FMT_RGB888,
+		.codec_modes = CODEC_MODE_DECODER | CODEC_MODE_ENCODER,
+		.h_align = 1,
+		.v_align = 1,
+		.plane_row_depth = { 32 },
+		.plane_depth = { 32 },
+	},
+	{
+		.type = FMT_TYPE_RAW,
+		.pixelformat = V4L2_PIX_FMT_NV12M,
+		.num_planes = 2,
+		.hw_format = GO2001_FMT_YUV420_SEMIPLANAR,
+		.codec_modes = CODEC_MODE_DECODER | CODEC_MODE_ENCODER,
+		.h_align = 4,
+		.v_align = 2,
+		.plane_row_depth = { 8, 8 },
+		.plane_depth = { 8, 4 },
+	},
+	{
+		.type = FMT_TYPE_RAW,
+		.pixelformat = V4L2_PIX_FMT_YUV420M,
+		.num_planes = 3,
+		.hw_format = GO2001_FMT_YUV420_PLANAR,
+		.codec_modes = CODEC_MODE_ENCODER,
+		.h_align = 4,
+		.v_align = 2,
+		.plane_row_depth = { 8, 4, 4 },
+		.plane_depth = { 8, 2, 2 },
+	},
+	{
+		.type = FMT_TYPE_CODED,
+		.pixelformat = V4L2_PIX_FMT_VP8,
+		.num_planes = 1,
+		.hw_format = GO2001_FMT_VP8,
+		.codec_modes = CODEC_MODE_DECODER | CODEC_MODE_ENCODER,
+	},
+};
+
+static struct go2001_fmt *go2001_find_fmt(struct go2001_ctx *ctx,
+					  __u32 pixelformat)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		if (formats[i].pixelformat == pixelformat &&
+		    (ctx->codec_mode & formats[i].codec_modes))
+			return &formats[i];
+	}
+
+	go2001_dbg(ctx->gdev, 1, "Unsupported format %d.\n", pixelformat);
+
+	return NULL;
+}
+
+struct vb2_queue *go2001_get_vq(struct go2001_ctx *ctx, enum v4l2_buf_type type)
+{
+	return V4L2_TYPE_IS_OUTPUT(type) ? &ctx->src_vq : &ctx->dst_vq;
+}
+
+static int go2001_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct go2001_dev *gdev = video_drvdata(file);
+
+	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, "GO2001 PCIe codec", sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
+		 pci_name(gdev->pdev));
+
+	return 0;
+}
+
+static int go2001_queue_setup(struct vb2_queue *q, unsigned int *num_buffers,
+			      unsigned int *num_planes, unsigned int sizes[],
+			      struct device *alloc_devs[])
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(q);
+	struct go2001_fmt *f;
+	int i;
+
+	go2001_trace(ctx->gdev);
+
+	f = V4L2_TYPE_IS_OUTPUT(q->type) ? ctx->src_fmt : ctx->dst_fmt;
+	if (!f) {
+		go2001_err(ctx->gdev, "Format(s) not selected\n");
+		return -EINVAL;
+	}
+
+	if (f->type == FMT_TYPE_CODED) {
+		if (*num_buffers < GO2001_MIN_NUM_BITSTREAM_BUFFERS)
+			*num_buffers = GO2001_MIN_NUM_BITSTREAM_BUFFERS;
+		*num_planes = 1;
+		sizes[0] = ctx->bitstream_buf_size;
+	} else if (go2001_has_frame_info(ctx)) {
+		if (*num_buffers < GO2001_MIN_NUM_FRAME_BUFFERS)
+			*num_buffers = GO2001_MIN_NUM_FRAME_BUFFERS;
+		*num_planes = f->num_planes;
+		for (i = 0; i < f->num_planes; ++i)
+			sizes[i] = ctx->finfo.plane_size[i];
+	} else {
+		go2001_err(ctx->gdev, "Invalid state\n");
+		return -EINVAL;
+	}
+
+	go2001_dbg(ctx->gdev, 2, "Num buffers: %d, planes: %d\n", *num_buffers,
+		   *num_planes);
+
+	for (i = 0; i < f->num_planes; ++i)
+		go2001_dbg(ctx->gdev, 2, "Plane %d, size: %d\n", i, sizes[i]);
+
+	return 0;
+}
+
+static int go2001_buf_init(struct vb2_buffer *vb)
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct go2001_dev *gdev = ctx->gdev;
+	struct device *dev = &gdev->pdev->dev;
+	struct go2001_buffer *gbuf = vb_to_go2001_buf(vb);
+	struct go2001_dma_desc *dma_desc;
+	struct go2001_mmap_list_entry *mmap_list;
+	enum dma_data_direction dir;
+	struct scatterlist *sg;
+	struct sg_table *sgt;
+	u64 dma_addr;
+	u32 dma_len;
+	int plane, sgi;
+	int ret;
+
+	go2001_trace(gdev);
+
+	if (WARN_ON(gbuf->mapped))
+		return -EINVAL;
+
+	dir = V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) ?
+	      DMA_TO_DEVICE :
+	      DMA_FROM_DEVICE;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		dma_desc = &gbuf->dma_desc[plane];
+		WARN_ON(!IS_ALIGNED(dma_desc->map_addr, 16));
+
+		sgt = vb2_dma_sg_plane_desc(vb, plane);
+
+		if (!IS_ALIGNED(sgt->sgl->offset, 8) ||
+		    !IS_ALIGNED(vb2_plane_size(vb, plane), 8)) {
+			go2001_err(gdev, "Plane address/size not aligned %d/%zu\n",
+				   sgt->sgl->offset, vb2_plane_size(vb, plane));
+
+			ret = -EINVAL;
+			goto err;
+		}
+
+		dma_desc->num_entries = sgt->nents;
+		dma_desc->list_size = dma_desc->num_entries *
+				      sizeof(struct go2001_mmap_list_entry);
+		dma_desc->mmap_list = dma_alloc_coherent(dev,
+							 dma_desc->list_size,
+							 &dma_desc->dma_addr,
+							 GFP_KERNEL);
+		if (!dma_desc->mmap_list) {
+			go2001_err(gdev, "Failed allocating HW memory map\n");
+
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		go2001_dbg(gdev, 3, "Plane %d: mmap list size: %zu\n", plane,
+			   dma_desc->list_size);
+
+		mmap_list = dma_desc->mmap_list;
+		for_each_sg(sgt->sgl, sg, dma_desc->num_entries, sgi) {
+			dma_addr = sg_dma_address(sg);
+			dma_len = sg_dma_len(sg);
+
+			mmap_list[sgi].dma_addr = cpu_to_le64(dma_addr);
+			mmap_list[sgi].size = cpu_to_le32(dma_len);
+
+			go2001_dbg(gdev, 4, "Chunk %d: 0x%08llx, size %d\n",
+				   sgi, dma_addr, dma_len);
+		}
+	}
+
+	ret = go2001_map_buffer(ctx, gbuf);
+	if (ret) {
+		go2001_err(ctx->gdev, "Failed mapping buffer in HW\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	for (; plane > 0; --plane) {
+		dma_desc = &gbuf->dma_desc[plane - 1];
+		dma_free_coherent(dev, dma_desc->list_size, dma_desc->mmap_list,
+				  dma_desc->dma_addr);
+		memset(dma_desc, 0, sizeof(struct go2001_dma_desc));
+	}
+
+	return ret;
+}
+
+static int go2001_buf_prepare(struct vb2_buffer *vb)
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct go2001_buffer *gbuf = vb_to_go2001_buf(vb);
+
+	return go2001_prepare_gbuf(ctx, gbuf,
+				   V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type));
+}
+
+static void go2001_buf_finish(struct vb2_buffer *vb)
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct go2001_buffer *gbuf = vb_to_go2001_buf(vb);
+	size_t plane_size;
+	void *vaddr, *ptr;
+	int i;
+
+	go2001_finish_gbuf(ctx, gbuf);
+
+	/*
+	 * If this is a CAPTURE encoder buffer, we need to reassemble
+	 * partitions, as there may be gaps between them.
+	 */
+	if (ctx->codec_mode != CODEC_MODE_ENCODER ||
+	    V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type))
+		return;
+
+	plane_size = vb2_plane_size(vb, 0);
+	vaddr = vb2_plane_vaddr(vb, 0);
+	if (!vaddr) {
+		go2001_err(ctx->gdev, "Unable to map buffer\n");
+		return;
+	}
+
+	ptr = vaddr;
+
+	/*
+	 * ith partition resides at partition_off[i] from start of the buffer
+	 * and is of size partition_size[i]. As there may be gaps between
+	 * partitions, slide them back together to remove the gaps.
+	 */
+	for (i = 0; i < VP8_MAX_NUM_PARTITIONS; ++i) {
+		if (gbuf->partition_size[i] == 0)
+			break;
+
+		if (gbuf->partition_off[i] + gbuf->partition_size[i] >
+		    plane_size) {
+			go2001_err(ctx->gdev, "Invalid partition %d info, off: 0x%zx, size: %zu, plane_size: %zu\n",
+				   i, gbuf->partition_off[i],
+				   gbuf->partition_size[i], plane_size);
+
+			return;
+		}
+
+		if (ptr != vaddr + gbuf->partition_off[i])
+			memmove(ptr, vaddr + gbuf->partition_off[i],
+				gbuf->partition_size[i]);
+
+		ptr += gbuf->partition_size[i];
+	}
+}
+
+static void go2001_buf_cleanup(struct vb2_buffer *vb)
+{
+	struct go2001_buffer *gbuf = vb_to_go2001_buf(vb);
+	struct go2001_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct go2001_dev *gdev = ctx->gdev;
+	struct device *dev = &gdev->pdev->dev;
+	struct go2001_dma_desc *dma_desc;
+	enum dma_data_direction dir;
+	int plane;
+
+	dir = V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) ?
+		DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+	go2001_unmap_buffer(ctx, gbuf);
+
+	/* Clean up regardless of whether unmap in HW succeeded or not. */
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		dma_desc = &gbuf->dma_desc[plane];
+		if (dma_desc->mmap_list)
+			dma_free_coherent(dev, dma_desc->list_size,
+					  dma_desc->mmap_list,
+					  dma_desc->dma_addr);
+
+		memset(dma_desc, 0, sizeof(struct go2001_dma_desc));
+	}
+}
+
+static void go2001_enc_start_streaming(struct go2001_ctx *ctx,
+				       enum v4l2_buf_type type)
+{
+	struct vb2_queue *q;
+
+	switch (ctx->state) {
+	case COMMITTED:
+	case PAUSED:
+		if (V4L2_TYPE_IS_OUTPUT(type))
+			q = &ctx->dst_vq;
+		else
+			q = &ctx->src_vq;
+
+		if (vb2_is_streaming(q))
+			go2001_set_ctx_state(ctx, RUNNING);
+		break;
+
+	default:
+		go2001_err(ctx->gdev, "Invalid state %d\n", ctx->state);
+		WARN_ON(1);
+		break;
+	}
+}
+
+static void go2001_dec_start_streaming(struct go2001_ctx *ctx,
+				       enum v4l2_buf_type type)
+{
+	struct vb2_queue *q;
+
+	if (V4L2_TYPE_IS_OUTPUT(type)) {
+		if (ctx->state == COMMITTED) {
+			go2001_set_ctx_state(ctx, NEED_HEADER_INFO);
+
+			return;
+		}
+
+		q = &ctx->dst_vq;
+	} else {
+		q = &ctx->src_vq;
+	}
+
+	if (ctx->state == PAUSED) {
+		if (vb2_is_streaming(q))
+			go2001_set_ctx_state(ctx, RUNNING);
+
+		return;
+	}
+
+	go2001_err(ctx->gdev, "Invalid state %d\n", ctx->state);
+	WARN_ON(1);
+}
+
+static int go2001_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(q);
+	unsigned long flags;
+	int ret = 0;
+
+	go2001_dbg(ctx->gdev, 2, "for %s queue\n",
+		   V4L2_TYPE_IS_OUTPUT(q->type) ? "OUTPUT" : "CAPTURE");
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+
+	if (ctx->state == ERROR) {
+		go2001_dbg(ctx->gdev, 1, "Instance %p in error state\n", ctx);
+
+		spin_unlock_irqrestore(&ctx->qlock, flags);
+		return -EIO;
+	}
+
+	if (ctx->codec_mode == CODEC_MODE_ENCODER)
+		go2001_enc_start_streaming(ctx, q->type);
+	else
+		go2001_dec_start_streaming(ctx, q->type);
+
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	ret = go2001_schedule_frames(ctx);
+	if (ret) {
+		go2001_err(ctx->gdev, "Failed to start streaming\n");
+
+		if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+			go2001_buffer_done_queued(ctx, &ctx->src_buf_q);
+			go2001_buffer_done_queued(ctx, &ctx->src_resume_q);
+		} else {
+			go2001_buffer_done_queued(ctx, &ctx->dst_buf_q);
+		}
+	}
+
+	return ret;
+}
+
+static void go2001_stop_streaming(struct vb2_queue *q)
+{
+	struct go2001_ctx *ctx = vb2_get_drv_priv(q);
+	unsigned long flags;
+
+	go2001_dbg(ctx->gdev, 2, "%p for %s queue\n", ctx,
+		   V4L2_TYPE_IS_OUTPUT(q->type) ? "OUTPUT" : "CAPTURE");
+
+	go2001_wait_for_ctx_done(ctx);
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+
+	switch (ctx->state) {
+	case NEED_HEADER_INFO:
+		go2001_set_ctx_state(ctx, COMMITTED);
+		break;
+
+	case RES_CHANGE:
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			go2001_set_ctx_state(ctx, PAUSED);
+		break;
+
+	case RUNNING:
+		go2001_set_ctx_state(ctx, PAUSED);
+		break;
+
+	default:
+		break;
+	}
+
+	WARN_ON(ctx->job.src_buf || ctx->job.dst_buf);
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		go2001_cleanup_queue(ctx, &ctx->src_buf_q);
+		go2001_cleanup_queue(ctx, &ctx->src_resume_q);
+	} else {
+		go2001_cleanup_queue(ctx, &ctx->dst_buf_q);
+	}
+
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+}
+
+static void go2001_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct go2001_ctx *ctx = vb2_get_drv_priv(vq);
+	struct go2001_buffer *gbuf = vb_to_go2001_buf(vb);
+	unsigned long flags;
+
+	if (ctx->codec_mode == CODEC_MODE_ENCODER &&
+	    V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		gbuf->rt_enc_params = ctx->pending_rt_params;
+		memset(&ctx->pending_rt_params, 0,
+		       sizeof(ctx->pending_rt_params));
+	}
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+
+	if (V4L2_TYPE_IS_OUTPUT(vq->type))
+		list_add_tail(&gbuf->list, &ctx->src_buf_q);
+	else
+		list_add_tail(&gbuf->list, &ctx->dst_buf_q);
+
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	go2001_schedule_frames(ctx);
+}
+
+static const struct vb2_ops go2001_qops = {
+	.queue_setup = go2001_queue_setup,
+
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+
+	.buf_init = go2001_buf_init,
+	.buf_prepare = go2001_buf_prepare,
+	.buf_finish = go2001_buf_finish,
+	.buf_cleanup = go2001_buf_cleanup,
+
+	.start_streaming = go2001_start_streaming,
+	.stop_streaming = go2001_stop_streaming,
+
+	.buf_queue = go2001_buf_queue,
+};
+
+static int go2001_init_vb2_queue(struct vb2_queue *q, struct go2001_ctx *ctx,
+				 enum v4l2_buf_type type)
+{
+	q->type = type;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->lock = &ctx->lock;
+	q->ops = &go2001_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->drv_priv = ctx;
+	q->buf_struct_size = sizeof(struct go2001_buffer);
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER && V4L2_TYPE_IS_OUTPUT(type))
+		q->allow_zero_bytesused = 1;
+
+	return vb2_queue_init(q);
+}
+
+static int go2001_enc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct go2001_ctx *ctx = ctrl_to_ctx(ctrl);
+
+	go2001_trace(ctx->gdev);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		set_bit(GO2001_BITRATE_CHANGE,
+			ctx->pending_rt_params.changed_mask);
+		ctx->pending_rt_params.enc_params.bitrate = ctrl->val;
+		go2001_dbg(ctx->gdev, 2, "Bitrate changed to %d bps.\n",
+			   ctx->pending_rt_params.enc_params.bitrate);
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
+		set_bit(GO2001_KEYFRAME_REQUESTED,
+			ctx->pending_rt_params.changed_mask);
+		ctx->pending_rt_params.enc_params.request_keyframe = true;
+		go2001_dbg(ctx->gdev, 2, "Keyframe requested.\n");
+		break;
+
+	default:
+		go2001_dbg(ctx->gdev, 1, "Unsupported control id=%d, ignoring.\n",
+			   ctrl->id);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops go2001_enc_ctrl_ops = {
+	.s_ctrl = go2001_enc_s_ctrl,
+};
+
+static int go2001_init_ctrl_handler(struct go2001_ctx *ctx)
+{
+	struct v4l2_ctrl_handler *hdl = &ctx->ctrl_handler;
+	int ret;
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER) {
+		ret = v4l2_ctrl_handler_init(hdl, 1);
+		if (ret)
+			return ret;
+
+		v4l2_ctrl_new_std(hdl, NULL, V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
+				  1, 32, 1, 8);
+	} else {
+		ret = v4l2_ctrl_handler_init(hdl, 3);
+		if (ret)
+			return ret;
+
+		v4l2_ctrl_new_std(hdl, &go2001_enc_ctrl_ops,
+				  V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
+				  1, 1, 1, GO2001_DEF_RC_ENABLE);
+		v4l2_ctrl_new_std(hdl, &go2001_enc_ctrl_ops,
+				  V4L2_CID_MPEG_VIDEO_BITRATE,
+				  10000, 40000000, 1, GO2001_DEF_BITRATE);
+		v4l2_ctrl_new_std(hdl, &go2001_enc_ctrl_ops,
+				  V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME,
+				  0, 0, 0, 0);
+	}
+
+	ret = hdl->error;
+	if (ret)
+		v4l2_ctrl_handler_free(hdl);
+	else
+		ctx->v4l2_fh.ctrl_handler = hdl;
+
+	return ret;
+}
+
+static int go2001_init_ctx(struct go2001_dev *gdev, struct go2001_ctx *ctx,
+			   struct file *file, struct video_device *vdev,
+			   enum go2001_codec_mode mode)
+{
+	int ret;
+
+	ctx->gdev = gdev;
+	ctx->codec_mode = mode;
+
+	mutex_init(&ctx->lock);
+	spin_lock_init(&ctx->qlock);
+	INIT_LIST_HEAD(&ctx->src_buf_q);
+	INIT_LIST_HEAD(&ctx->src_resume_q);
+	INIT_LIST_HEAD(&ctx->dst_buf_q);
+	v4l2_fh_init(&ctx->v4l2_fh, vdev);
+	ctx->state = UNCOMMITTED;
+	go2001_init_hw_inst(&ctx->hw_inst, 0);
+
+	ctx->bitstream_buf_size = GO2001_DEF_BITSTREAM_BUFFER_SIZE;
+	if (ctx->codec_mode == CODEC_MODE_DECODER) {
+		ctx->src_fmt = go2001_find_fmt(ctx, V4L2_PIX_FMT_VP8);
+		ctx->dst_fmt = go2001_find_fmt(ctx, V4L2_PIX_FMT_RGB32);
+	} else {
+		ctx->src_fmt = go2001_find_fmt(ctx, V4L2_PIX_FMT_NV12M);
+		ctx->dst_fmt = go2001_find_fmt(ctx, V4L2_PIX_FMT_VP8);
+		ctx->enc_params.rc_enable = GO2001_DEF_RC_ENABLE;
+		ctx->enc_params.request_keyframe = true;
+		ctx->enc_params.bitrate = GO2001_DEF_BITRATE;
+		ctx->enc_params.framerate_num = GO2001_MAX_FPS;
+		ctx->enc_params.framerate_denom = 1;
+	}
+
+	ret = go2001_init_ctrl_handler(ctx);
+	if (ret)
+		return ret;
+
+	ret = go2001_init_vb2_queue(&ctx->src_vq, ctx,
+				    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	if (ret)
+		return ret;
+
+	ret = go2001_init_vb2_queue(&ctx->dst_vq, ctx,
+				    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (ret)
+		return ret;
+
+	mutex_lock(&gdev->lock);
+	list_add_tail(&ctx->ctx_entry, &gdev->ctx_list);
+	mutex_unlock(&gdev->lock);
+
+	file->private_data = &ctx->v4l2_fh;
+	v4l2_fh_add(&ctx->v4l2_fh);
+
+	return 0;
+}
+
+static void go2001_release_ctx(struct go2001_ctx *ctx)
+{
+	unsigned long flags;
+
+	vb2_queue_release(&ctx->src_vq);
+	vb2_queue_release(&ctx->dst_vq);
+
+	go2001_release_codec(ctx);
+
+	mutex_lock(&ctx->gdev->lock);
+	spin_lock_irqsave(&ctx->qlock, flags);
+	list_del(&ctx->ctx_entry);
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+	mutex_unlock(&ctx->gdev->lock);
+
+	v4l2_fh_del(&ctx->v4l2_fh);
+	v4l2_fh_exit(&ctx->v4l2_fh);
+
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+}
+
+static int go2001_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct go2001_dev *gdev = video_drvdata(file);
+	struct go2001_ctx *ctx;
+	enum go2001_codec_mode mode;
+	int ret = 0;
+
+	go2001_trace(gdev);
+
+	mutex_lock(&gdev->lock);
+	if (!gdev->initialized) {
+		ret = go2001_init(gdev);
+		if (!ret)
+			gdev->initialized = true;
+	}
+	mutex_unlock(&gdev->lock);
+
+	if (ret)
+		return ret;
+
+	if (vdev->index == gdev->dec_vdev.index) {
+		mode = CODEC_MODE_DECODER;
+	} else if (vdev->index == gdev->enc_vdev.index) {
+		mode = CODEC_MODE_ENCODER;
+	} else {
+		go2001_err(gdev, "Invalid video node\n");
+		return -ENXIO;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ret = go2001_init_ctx(gdev, ctx, file, vdev, mode);
+	if (ret) {
+		go2001_err(gdev, "Failed initializing context\n");
+		kfree(ctx);
+		return ret;
+	}
+
+	go2001_dbg(ctx->gdev, 1, "Opened ctx %p\n", ctx);
+
+	return 0;
+}
+
+static int go2001_release(struct file *file)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	unsigned long flags;
+
+	go2001_dbg(ctx->gdev, 1, "Releasing ctx %p\n", ctx);
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+	go2001_set_ctx_state(ctx, UNCOMMITTED);
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	go2001_wait_for_ctx_done(ctx);
+	go2001_release_ctx(ctx);
+	kfree(ctx);
+
+	return 0;
+}
+
+static unsigned int go2001_poll(struct file *file,
+				struct poll_table_struct *wait)
+{
+	unsigned long req_events = poll_requested_events(wait);
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *src_q = &ctx->src_vq;
+	struct vb2_queue *dst_q = &ctx->dst_vq;
+	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
+	struct v4l2_fh *fh = &ctx->v4l2_fh;
+	unsigned long flags;
+	unsigned int rc = 0;
+
+	if (v4l2_event_pending(fh))
+		rc = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->wait, wait);
+
+	if (!(req_events & (POLLOUT | POLLWRNORM | POLLIN | POLLRDNORM)))
+		return rc;
+
+	if ((!vb2_is_streaming(src_q) || list_empty(&src_q->queued_list)) &&
+	    (!vb2_is_streaming(dst_q) || list_empty(&dst_q->queued_list))) {
+		rc |= POLLERR;
+		return rc;
+	}
+
+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
+	spin_lock_irqsave(&src_q->done_lock, flags);
+	if (!list_empty(&src_q->done_list))
+		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
+					  done_entry);
+	if (src_vb && (src_vb->state == VB2_BUF_STATE_DONE ||
+		       src_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLOUT | POLLWRNORM;
+	spin_unlock_irqrestore(&src_q->done_lock, flags);
+
+	spin_lock_irqsave(&dst_q->done_lock, flags);
+	if (!list_empty(&dst_q->done_list))
+		dst_vb = list_first_entry(&dst_q->done_list, struct vb2_buffer,
+					  done_entry);
+	if (dst_vb && (dst_vb->state == VB2_BUF_STATE_DONE ||
+		       dst_vb->state == VB2_BUF_STATE_ERROR))
+		rc |= POLLIN | POLLRDNORM;
+	spin_unlock_irqrestore(&dst_q->done_lock, flags);
+
+	return rc;
+}
+
+static int go2001_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
+
+	if (offset < DST_QUEUE_OFF_BASE) {
+		ret = vb2_mmap(&ctx->src_vq, vma);
+	} else {
+		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+		ret = vb2_mmap(&ctx->dst_vq, vma);
+	}
+
+	return ret;
+}
+
+static int go2001_handle_init_reply(struct go2001_dev *gdev,
+				    struct go2001_msg *msg,
+				    u32 status)
+{
+	struct go2001_init_decoder_reply *reply = msg_to_param(msg);
+	struct go2001_hw_inst *hw_inst;
+	struct go2001_ctx *ctx = NULL;
+	int ret = 0;
+
+	list_for_each_entry(hw_inst, &gdev->new_inst_list, inst_entry) {
+		if (hw_inst->sequence_id == gdev->last_reply_seq_id) {
+			ctx = hw_inst_to_ctx(hw_inst);
+			break;
+		}
+	}
+
+	if (!ctx) {
+		go2001_err(gdev, "No ctx awaiting VM_INIT_*, dropping\n");
+		return -EIO;
+	}
+
+	if (gdev->curr_hw_inst == &ctx->hw_inst)
+		gdev->curr_hw_inst = NULL;
+
+	list_del_init(&ctx->hw_inst.inst_entry);
+
+	switch (status) {
+	case GO2001_STATUS_OK:
+		go2001_init_hw_inst(&ctx->hw_inst, reply->session_id);
+		list_add_tail(&ctx->hw_inst.inst_entry, &ctx->gdev->inst_list);
+		break;
+
+	case GO2001_STATUS_RES_NA:
+		ret = -ENOMEM;
+		break;
+
+	case GO2001_STATUS_INVALID_PARAM:
+		ret = -EINVAL;
+		break;
+
+	default:
+		ret = -EIO;
+		break;
+	}
+
+	if (ret)
+		go2001_ctx_error_locked(ctx);
+
+	return ret;
+}
+
+static void go2001_handle_release_instance_reply(struct go2001_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+	ctx->hw_inst.session_id = 0;
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+}
+
+static void go2001_calc_finfo(struct go2001_ctx *ctx, struct go2001_fmt *fmt,
+			      struct go2001_frame_info *finfo,
+			      unsigned int width, unsigned int height)
+{
+	int i;
+
+	finfo->width = round_up(width, fmt->h_align);
+	finfo->height = round_up(height, fmt->v_align);
+	finfo->coded_width = round_up(finfo->width, GO2001_VPX_MACROBLOCK_SIZE);
+	finfo->coded_height = round_up(finfo->height,
+				       GO2001_VPX_MACROBLOCK_SIZE);
+
+	go2001_dbg(ctx->gdev, 2, "Visible (coded) resolution: %ux%u (%ux%u)\n",
+		   finfo->width, finfo->height, finfo->coded_width,
+		   finfo->coded_height);
+
+	for (i = 0; i < fmt->num_planes; ++i) {
+		finfo->bytesperline[i] =
+			(finfo->coded_width * fmt->plane_row_depth[i]) / 8;
+		finfo->plane_size[i] = (finfo->coded_width  *
+					finfo->coded_height *
+					fmt->plane_depth[i]) / 8;
+		go2001_dbg(ctx->gdev, 2, "Plane %d: bpl: %u, size: %zu\n",
+			   i, finfo->bytesperline[i], finfo->plane_size[i]);
+	}
+}
+
+static int go2001_handle_new_info(struct go2001_ctx *ctx,
+				  struct go2001_get_info_reply *reply)
+{
+	struct go2001_frame_info *finfo = &ctx->finfo;
+	struct go2001_fmt *fmt;
+
+	fmt = (ctx->codec_mode == CODEC_MODE_DECODER) ?
+	      ctx->dst_fmt : ctx->src_fmt;
+
+	go2001_dbg(ctx->gdev, 2, "HW reports new resolution: %ux%u (%ux%u)\n",
+		   reply->visible_width, reply->visible_height,
+		   reply->coded_width, reply->coded_height);
+
+	go2001_calc_finfo(ctx, fmt, finfo, reply->visible_width,
+			  reply->visible_height);
+
+	if (finfo->width != reply->visible_width ||
+	    finfo->height != reply->visible_height ||
+	    finfo->coded_width != reply->coded_width ||
+	    finfo->coded_height != reply->coded_height) {
+		go2001_err(ctx->gdev, "Invalid resolution from the HW\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int go2001_handle_get_info_reply(struct go2001_ctx *ctx,
+					struct go2001_msg *msg, u32 status)
+{
+	struct go2001_get_info_reply *reply = msg_to_param(msg);
+
+	if (status != GO2001_STATUS_OK)
+		return -EIO;
+
+	return go2001_handle_new_info(ctx, reply);
+}
+
+static int go2001_fill_dst_buf_info(struct go2001_ctx *ctx,
+				    struct go2001_job *job,
+				    struct go2001_msg *reply, bool error)
+{
+	struct vb2_v4l2_buffer *src_vbuf;
+	struct vb2_v4l2_buffer *dst_vbuf;
+	int i;
+
+	src_vbuf = to_vb2_v4l2_buffer(&job->src_buf->vb);
+	dst_vbuf = to_vb2_v4l2_buffer(&job->dst_buf->vb);
+
+	switch (ctx->codec_mode) {
+	case CODEC_MODE_DECODER:
+		for (i = 0; i < dst_vbuf->vb2_buf.num_planes; ++i) {
+			vb2_set_plane_payload(&dst_vbuf->vb2_buf, i,
+					      error ?
+					      0 :
+					      ctx->finfo.plane_size[i]);
+		}
+		break;
+
+	case CODEC_MODE_ENCODER: {
+		struct go2001_empty_buffer_enc_reply *enc_reply =
+							msg_to_param(reply);
+		struct go2001_buffer *gbuf;
+
+		gbuf = vb_to_go2001_buf(&dst_vbuf->vb2_buf);
+
+		memset(gbuf->partition_off, 0, sizeof(gbuf->partition_off));
+		memset(gbuf->partition_size, 0, sizeof(gbuf->partition_size));
+
+		/*
+		 * Partitions may have gaps between them, we will have to
+		 * reassemble the bitstream later in buf_finish. For now just
+		 * save the size and offset of each partition and set the
+		 * payload for the buffer to the sum of sizes (returned in
+		 * enc_reply->payload_size).
+		 */
+		if (enc_reply->payload_size >
+		    vb2_plane_size(&dst_vbuf->vb2_buf, 0) || error) {
+			vb2_set_plane_payload(&dst_vbuf->vb2_buf, 0, 0);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(&dst_vbuf->vb2_buf, 0,
+				      enc_reply->payload_size);
+
+		for (i = 0; i < VP8_MAX_NUM_PARTITIONS; ++i) {
+			gbuf->partition_off[i] = enc_reply->partition_off[i];
+			gbuf->partition_size[i] = enc_reply->partition_size[i];
+		}
+
+		dst_vbuf->flags = 0;
+		if (enc_reply->frame_type ==
+					GO2001_EMPTY_BUF_ENC_FRAME_KEYFRAME)
+			dst_vbuf->flags = V4L2_BUF_FLAG_KEYFRAME;
+		break;
+	}
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	dst_vbuf->timecode = src_vbuf->timecode;
+	dst_vbuf->vb2_buf.timestamp = src_vbuf->vb2_buf.timestamp;
+
+	go2001_dbg(ctx->gdev, 5, "Returning frame ts=%llu\n",
+		   dst_vbuf->vb2_buf.timestamp);
+
+	return 0;
+}
+
+static int go2001_handle_empty_buffer_reply(struct go2001_ctx *ctx,
+					    struct go2001_msg *msg, u32 status)
+{
+	enum vb2_buffer_state src_state = VB2_BUF_STATE_DONE;
+	enum vb2_buffer_state dst_state = VB2_BUF_STATE_DONE;
+	struct go2001_job *job;
+	struct go2001_buffer *src_buf, *dst_buf;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+	job = &ctx->job;
+	src_buf = job->src_buf;
+	if (!src_buf) {
+		go2001_err(ctx->gdev, "No src buffer!\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	list_del(&src_buf->list);
+
+	dst_buf = job->dst_buf;
+
+	switch (status) {
+	case GO2001_STATUS_NEW_PICTURE_SIZE: {
+		static const struct v4l2_event ev_src_ch = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes =	V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+		struct go2001_empty_buffer_dec_reply *dec_reply =
+							msg_to_param(msg);
+
+		WARN_ON(ctx->state != NEED_HEADER_INFO &&
+			ctx->state != RUNNING);
+
+		go2001_handle_new_info(ctx, &dec_reply->info);
+		v4l2_event_queue_fh(&ctx->v4l2_fh, &ev_src_ch);
+		go2001_set_ctx_state(ctx, RES_CHANGE);
+		/* Fallthrough */
+	}
+	case GO2001_STATUS_WAITING_PICTURE_SIZE_CHANGED:
+		ctx->need_resume = true;
+		/*
+		 * We will retry this frame after reallocating output buffers.
+		 * Add the source buffer to the resume queue, which will
+		 * be spliced in front of the source queue after reallocation.
+		 */
+		go2001_dbg(ctx->gdev, 3, "Pending buffer %p\n", src_buf);
+		list_add_tail(&src_buf->list, &ctx->src_resume_q);
+		break;
+
+	case GO2001_STATUS_STREAM_ERROR:
+		src_state = VB2_BUF_STATE_ERROR;
+		/* Fallthrough */
+	case GO2001_STATUS_OK:
+		vb2_buffer_done(&src_buf->vb, src_state);
+		if (!dst_buf)
+			break;
+
+		if (go2001_fill_dst_buf_info(ctx, job, msg,
+					     dst_state == VB2_BUF_STATE_ERROR))
+			dst_state = VB2_BUF_STATE_ERROR;
+
+		list_del(&dst_buf->list);
+		vb2_buffer_done(&dst_buf->vb, dst_state);
+		break;
+
+	case GO2001_STATUS_NO_OUTPUT:
+		vb2_buffer_done(&src_buf->vb, src_state);
+		/*
+		 * No output produced, reuse dst_buf for next job
+		 * without returning the buffer to userspace.
+		 */
+		break;
+
+	default:
+		ret = -EIO;
+		break;
+	}
+
+out:
+	job->src_buf = NULL;
+	job->dst_buf = NULL;
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	return ret;
+}
+
+static void go2001_handle_get_version_reply(struct go2001_dev *gdev,
+					    struct go2001_msg *msg)
+{
+	struct go2001_get_version_reply *reply = msg_to_param(msg);
+
+	dev_info(&gdev->pdev->dev, "GO2001 ver: %d/%d, VP8 decoder: %d/%d VP8 encoder: %d/%d, VP9 decoder: %d/%d\n",
+		 reply->hw_ver, reply->sw_ver, reply->vp8dec_hw_ver,
+		 reply->vp8dec_sw_ver, reply->vp8enc_hw_ver,
+		 reply->vp8enc_sw_ver, reply->vp9dec_hw_ver,
+		 reply->vp9dec_sw_ver);
+}
+
+static inline int go2001_handle_reply_default(struct go2001_dev *gdev, u32 type,
+					      u32 status)
+{
+	int ret = 0;
+
+	switch (status) {
+	case GO2001_STATUS_OK:
+		break;
+
+	case GO2001_STATUS_NEW_PICTURE_SIZE:
+	case GO2001_STATUS_WAITING_PICTURE_SIZE_CHANGED:
+	case GO2001_STATUS_STREAM_ERROR:
+	case GO2001_STATUS_NO_OUTPUT:
+		WARN_ON(type != GO2001_VM_EMPTY_BUFFER);
+		go2001_err(gdev, "Unexpected status in reply\n");
+		ret = -EIO;
+		break;
+
+	case GO2001_STATUS_RES_NA:
+		go2001_err(gdev, "Hardware ran out of resources\n");
+		ret = -ENOMEM;
+		break;
+
+	case GO2001_STATUS_INVALID_PARAM:
+		go2001_err(gdev, "Invalid parameters\n");
+		ret = -EINVAL;
+		break;
+
+	default:
+		go2001_err(gdev, "Invalid status in reply\n");
+		ret = -EIO;
+		break;
+	}
+
+	return ret;
+}
+
+static struct go2001_hw_inst *find_hw_inst_by_id_locked(struct go2001_dev *gdev,
+							u32 session_id)
+{
+	struct go2001_hw_inst *hw_inst;
+
+	list_for_each_entry(hw_inst, &gdev->inst_list, inst_entry)
+		if (hw_inst->session_id == session_id)
+			return hw_inst;
+
+	return NULL;
+}
+
+static int go2001_process_reply(struct go2001_dev *gdev,
+				struct go2001_msg *reply)
+{
+	struct go2001_hw_inst *hw_inst;
+	struct go2001_ctx *ctx = NULL;
+	struct go2001_msg_hdr *hdr = msg_to_hdr(reply);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+
+	hw_inst = find_hw_inst_by_id_locked(gdev, hdr->session_id);
+	if (!hw_inst) {
+		go2001_err(gdev, "Got reply for an invalid instance id %d\n",
+			   hdr->session_id);
+		ret = -EIO;
+		goto out;
+	}
+
+	if (hdr->type != GO2001_VM_EVENT_ASSERT	&&
+	    hdr->type != GO2001_VM_EVENT_LOG) {
+		if (WARN_ON(gdev->msgs_in_flight == 0)) {
+			go2001_err(gdev, "Unexpected reply without a request\n");
+			ret = -EIO;
+			goto out;
+		}
+
+		cancel_delayed_work(&gdev->watchdog_work);
+		--gdev->msgs_in_flight;
+		if (gdev->msgs_in_flight > 0)
+			schedule_delayed_work(&gdev->watchdog_work,
+				msecs_to_jiffies(GO2001_WATCHDOG_TIMEOUT_MS));
+
+		go2001_dbg(gdev, 3, "Messages in flight: %d\n",
+			   gdev->msgs_in_flight);
+
+		gdev->last_reply_inst_id = hdr->session_id;
+		gdev->last_reply_seq_id = hdr->sequence_id;
+
+		WARN_ON(hw_inst->last_reply_seq_id + 1 != hdr->sequence_id);
+		hw_inst->last_reply_seq_id = hdr->sequence_id;
+	}
+
+	if (hdr->session_id != 0)
+		ctx = hw_inst_to_ctx(hw_inst);
+
+	switch (hdr->type) {
+	case GO2001_VM_INIT_DECODER:
+	case GO2001_VM_INIT_ENCODER:
+		go2001_dbg(gdev, 5, "VM_INIT reply\n");
+		ret = go2001_handle_init_reply(gdev, reply, hdr->status);
+		break;
+
+	case GO2001_VM_GET_VERSION:
+		go2001_dbg(gdev, 5, "VM_GET_VERSION reply\n");
+		go2001_handle_get_version_reply(gdev, reply);
+		break;
+
+	case GO2001_VM_SET_MMAP:
+	case GO2001_VM_RELEASE_MMAP:
+		go2001_dbg(gdev, 5, "VM_*_MMAP reply\n");
+		ret = go2001_handle_reply_default(gdev, hdr->type, hdr->status);
+		break;
+
+	case GO2001_VM_EMPTY_BUFFER:
+		go2001_dbg(gdev, 5, "VM_EMPTY_BUFFER reply\n");
+		ret = go2001_handle_empty_buffer_reply(ctx, reply, hdr->status);
+		break;
+
+	case GO2001_VM_GET_INFO:
+		go2001_dbg(gdev, 5, "VM_GET_INFO reply\n");
+		ret = go2001_handle_get_info_reply(ctx, reply, hdr->status);
+		break;
+
+	case GO2001_VM_SET_CTRL:
+		go2001_dbg(gdev, 5, "VM_SET_CTRL reply\n");
+		ret = go2001_handle_reply_default(gdev, hdr->type, hdr->status);
+		break;
+
+	case GO2001_VM_RELEASE:
+		go2001_dbg(gdev, 5, "VM_RELEASE reply\n");
+		go2001_handle_release_instance_reply(ctx);
+		break;
+
+	case GO2001_VM_EVENT_ASSERT: {
+		struct go2001_event_assert_reply *a = msg_to_param(reply);
+
+		a->filename[ARRAY_SIZE(a->filename) - 1] = '\0';
+		a->funcname[ARRAY_SIZE(a->funcname) - 1] = '\0';
+		a->expr[ARRAY_SIZE(a->expr) - 1] = '\0';
+		go2001_err(gdev, "FW ASSERT at %s:%d in %s, executing %s\n",
+			   a->filename, a->line_no, a->funcname, a->expr);
+		ret = -EIO;
+		break;
+	}
+
+	case GO2001_VM_EVENT_LOG: {
+		struct go2001_event_log_reply *l = msg_to_param(reply);
+
+		l->data[ARRAY_SIZE(l->data) - 1] = '\0';
+		go2001_err(gdev, "VM_EVENT_LOG: %s\n", l->data);
+		break;
+	}
+
+	case GO2001_VM_SET_LOG_LEVEL: {
+		struct go2001_set_log_level_reply *l = msg_to_param(reply);
+
+		go2001_dbg(gdev, 1, "VM_SET_LOG_LEVEL: %d\n", l->level);
+		ret = go2001_handle_reply_default(gdev, hdr->type, hdr->status);
+		break;
+	}
+
+	default:
+		go2001_err(gdev, "Unexpected reply [%d:%d], type=0x%x\n",
+			   hdr->session_id, hdr->sequence_id, hdr->type);
+		ret = -EIO;
+		break;
+	}
+
+out:
+	if (ret) {
+		go2001_err(gdev, "Error %d for reply [%d:%d] type=0x%x, status=0x%x\n",
+			   ret, hdr->session_id, hdr->sequence_id, hdr->type,
+			   hdr->status);
+		if (ctx)
+			go2001_ctx_error_locked(ctx);
+	}
+
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	if (ctx && ret == 0)
+		go2001_schedule_frames(ctx);
+	/*
+	 * Critical failure only on EIO, otherwise we may be able to continue
+	 * using other instances.
+	 */
+	return ret == -EIO ? ret : 0;
+}
+
+static void go2001_watchdog(struct work_struct *work)
+{
+	int ret;
+	struct go2001_dev *gdev = container_of(to_delayed_work(work),
+					       struct go2001_dev,
+					       watchdog_work);
+
+	go2001_err(gdev, "Watchdog resetting firmware\n");
+
+	mutex_lock(&gdev->lock);
+
+	go2001_cancel_all_contexts(gdev);
+	gdev->msgs_in_flight = 0;
+
+	ret = go2001_init(gdev);
+	if (ret) {
+		gdev->initialized = false;
+		go2001_err(gdev, "Failed resetting firmware\n");
+	}
+
+	mutex_unlock(&gdev->lock);
+}
+
+static irqreturn_t go2001_irq(int irq, void *priv)
+{
+	struct go2001_dev *gdev = priv;
+	struct go2001_msg *reply = &gdev->last_reply;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	if (unlikely(!gdev->fw_loaded)) {
+		gdev->fw_loaded = true;
+		complete(&gdev->fw_completion);
+		spin_unlock_irqrestore(&gdev->irqlock, flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	while (go2001_get_reply(gdev, reply) == 0) {
+		ret = go2001_process_reply(gdev, reply);
+		wake_up_all(&gdev->reply_wq);
+		if (ret)
+			return IRQ_HANDLED;
+	}
+
+	go2001_send_pending(gdev);
+
+	return IRQ_HANDLED;
+}
+
+static const struct v4l2_file_operations go2001_fops = {
+	.owner = THIS_MODULE,
+	.open = go2001_open,
+	.release = go2001_release,
+	.unlocked_ioctl = video_ioctl2,
+	.poll = go2001_poll,
+	.mmap = go2001_mmap,
+};
+
+static int go2001_enum_fmt(enum go2001_codec_mode codec_mode,
+			   enum go2001_fmt_type type, struct v4l2_fmtdesc *f)
+{
+	struct go2001_fmt *fmt;
+	int num_matched = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		fmt = &formats[i];
+		if (!(codec_mode & fmt->codec_modes) || fmt->type != type)
+			continue;
+
+		if (num_matched == f->index) {
+			f->pixelformat = fmt->pixelformat;
+
+			return 0;
+		}
+
+		++num_matched;
+	}
+
+	return -EINVAL;
+}
+
+static int go2001_enum_fmt_cap(struct file *file, void *fh,
+			       struct v4l2_fmtdesc *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER)
+		return go2001_enum_fmt(ctx->codec_mode, FMT_TYPE_RAW, f);
+
+	return go2001_enum_fmt(ctx->codec_mode, FMT_TYPE_CODED, f);
+}
+
+static int go2001_enum_fmt_out(struct file *file, void *fh,
+			       struct v4l2_fmtdesc *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER)
+		return go2001_enum_fmt(ctx->codec_mode, FMT_TYPE_CODED, f);
+
+	return go2001_enum_fmt(ctx->codec_mode, FMT_TYPE_RAW, f);
+}
+
+static int fill_v4l2_format_raw(struct v4l2_format *f, struct go2001_fmt *gfmt,
+				struct go2001_frame_info *finfo)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	int i;
+
+	pix_mp->width = finfo->coded_width;
+	pix_mp->height = finfo->coded_height;
+	pix_mp->pixelformat = gfmt->pixelformat;
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->num_planes = gfmt->num_planes;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		pix_mp->plane_fmt[i].bytesperline = finfo->bytesperline[i];
+		pix_mp->plane_fmt[i].sizeimage = finfo->plane_size[i];
+	}
+
+	return 0;
+}
+
+static void fill_v4l2_format_coded(struct v4l2_format *f,
+				   struct go2001_fmt *gfmt, size_t buf_size)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+
+	pix_mp->width = 0;
+	pix_mp->height = 0;
+	pix_mp->pixelformat = gfmt->pixelformat;
+	pix_mp->field = V4L2_FIELD_NONE;
+	pix_mp->num_planes = 1;
+	pix_mp->plane_fmt[0].bytesperline = 0;
+
+	if (buf_size != 0) {
+		pix_mp->plane_fmt[0].sizeimage = buf_size;
+	} else if (pix_mp->plane_fmt[0].sizeimage == 0) {
+		pix_mp->plane_fmt[0].sizeimage =
+					GO2001_DEF_BITSTREAM_BUFFER_SIZE;
+	}
+}
+
+static int go2001_dec_g_fmt_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "Frame info not available yet\n");
+		return -EINVAL;
+	}
+
+	return fill_v4l2_format_raw(f, ctx->dst_fmt, &ctx->finfo);
+}
+
+static int go2001_enc_g_fmt_out(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "Frame info not available yet\n");
+		return -EINVAL;
+	}
+
+	return fill_v4l2_format_raw(f, ctx->dst_fmt, &ctx->finfo);
+}
+
+static int go2001_dec_g_fmt_out(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (!ctx->src_fmt) {
+		go2001_dbg(ctx->gdev, 1, "Format not ready yet\n");
+		return -EINVAL;
+	}
+
+	fill_v4l2_format_coded(f, ctx->src_fmt, ctx->bitstream_buf_size);
+
+	return 0;
+}
+
+static int go2001_enc_g_fmt_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+
+	if (!ctx->dst_fmt) {
+		go2001_dbg(ctx->gdev, 1, "Format not ready yet\n");
+		return -EINVAL;
+	}
+
+	fill_v4l2_format_coded(f, ctx->dst_fmt, ctx->bitstream_buf_size);
+
+	return 0;
+}
+
+static struct go2001_fmt *__go2001_dec_try_fmt_out(struct file *file, void *fh,
+						   struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct go2001_fmt *fmt;
+
+	fmt = go2001_find_fmt(ctx, pix_mp->pixelformat);
+	if (!fmt || fmt->type != FMT_TYPE_CODED)
+		return NULL;
+
+	fill_v4l2_format_coded(f, fmt, 0);
+
+	return fmt;
+}
+
+static int go2001_dec_try_fmt_out(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct go2001_fmt *fmt = __go2001_dec_try_fmt_out(file, fh, f);
+
+	return fmt ? 0 : -EINVAL;
+}
+
+static struct go2001_fmt *__go2001_dec_try_fmt_cap(struct file *file, void *fh,
+						   struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct go2001_fmt *fmt;
+
+	/*
+	 * S_FMT on CAPTURE allows setting destination fourcc only,
+	 * resolution is set after parsing headers and comes from the HW.
+	 */
+	fmt = go2001_find_fmt(ctx, pix_mp->pixelformat);
+	if (!fmt || fmt->type != FMT_TYPE_RAW)
+		return NULL;
+
+	return fmt;
+}
+
+static int go2001_dec_try_fmt_cap(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct go2001_fmt *fmt = __go2001_dec_try_fmt_cap(file, fh, f);
+
+	return fmt ? 0 : -EINVAL;
+}
+
+static struct go2001_fmt *__go2001_enc_try_fmt_out(struct file *file, void *fh,
+						struct v4l2_format *f,
+						struct go2001_frame_info *finfo)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct go2001_fmt *fmt;
+
+	fmt = go2001_find_fmt(ctx, pix_mp->pixelformat);
+	if (!fmt || fmt->type != FMT_TYPE_RAW)
+		return NULL;
+
+	go2001_calc_finfo(ctx, fmt, finfo, pix_mp->width, pix_mp->height);
+	fill_v4l2_format_raw(f, fmt, finfo);
+
+	return fmt;
+}
+
+static int go2001_enc_try_fmt_out(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct go2001_frame_info finfo;
+	struct go2001_fmt *fmt = __go2001_enc_try_fmt_out(file, fh, f, &finfo);
+
+	return fmt ? 0 : -EINVAL;
+}
+
+static struct go2001_fmt *__go2001_enc_try_fmt_cap(struct file *file, void *fh,
+						   struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_fmt *fmt;
+
+	fmt = go2001_find_fmt(ctx, f->fmt.pix_mp.pixelformat);
+	if (!fmt || fmt->type != FMT_TYPE_CODED)
+		return NULL;
+
+	fill_v4l2_format_coded(f, fmt, 0);
+
+	/* TODO: This should allow setting scaling */
+	return fmt;
+}
+
+static int go2001_enc_try_fmt_cap(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct go2001_fmt *fmt = __go2001_enc_try_fmt_cap(file, fh, f);
+
+	return fmt ? 0 : -EINVAL;
+}
+
+static int go2001_dec_s_fmt_out(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_fmt *fmt;
+
+	go2001_trace(ctx->gdev);
+
+	if (ctx->state != UNCOMMITTED) {
+		go2001_err(ctx->gdev, "Format cannot be set in this state\n");
+		return -EBUSY;
+	}
+
+	fmt = __go2001_dec_try_fmt_out(file, fh, f);
+	if (!fmt)
+		return -EINVAL;
+
+	ctx->src_fmt = fmt;
+	ctx->bitstream_buf_size = f->fmt.pix_mp.plane_fmt[0].sizeimage;
+
+	go2001_dbg(ctx->gdev, 1, "S_FMT on OUTPUT to %s\n", fmt->desc);
+
+	return 0;
+}
+
+static int go2001_dec_s_fmt_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_fmt *fmt;
+
+	go2001_trace(ctx->gdev);
+
+	if (ctx->state != UNCOMMITTED) {
+		go2001_err(ctx->gdev, "Format cannot be set in this state\n");
+		return -EBUSY;
+	}
+
+	fmt = __go2001_dec_try_fmt_cap(file, fh, f);
+	if (!fmt)
+		return -EINVAL;
+
+	ctx->dst_fmt = fmt;
+	memset(&ctx->finfo, 0, sizeof(ctx->finfo));
+
+	go2001_dbg(ctx->gdev, 1, "S_FMT on CAPTURE to %s\n", fmt->desc);
+
+	return 0;
+}
+
+static int go2001_enc_s_fmt_out(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_frame_info finfo;
+	struct go2001_fmt *fmt;
+
+	go2001_trace(ctx->gdev);
+
+	if (ctx->state != UNCOMMITTED) {
+		go2001_err(ctx->gdev, "Format cannot be set in this state\n");
+		return -EBUSY;
+	}
+
+	fmt = __go2001_enc_try_fmt_out(file, fh, f, &finfo);
+	if (!fmt)
+		return -EINVAL;
+
+	/* At 1280x720 and below go2001 can do three reference frames. */
+	ctx->enc_params.multi_ref_frame_mode =
+				finfo.width * finfo.height <= 1280 * 720;
+
+	ctx->src_fmt = fmt;
+	ctx->finfo = finfo;
+
+	go2001_dbg(ctx->gdev, 1, "S_FMT on OUTPUT to %s, planes:%d\n",
+		   fmt->desc, f->fmt.pix_mp.num_planes);
+
+	return 0;
+}
+
+static int go2001_enc_s_fmt_cap(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_fmt *fmt;
+
+	go2001_trace(ctx->gdev);
+
+	if (ctx->state != UNCOMMITTED) {
+		go2001_err(ctx->gdev, "Format cannot be set in this state\n");
+		return -EBUSY;
+	}
+
+	fmt = __go2001_enc_try_fmt_cap(file, fh, f);
+	if (!fmt)
+		return -EINVAL;
+
+	ctx->dst_fmt = fmt;
+	ctx->bitstream_buf_size = f->fmt.pix_mp.plane_fmt[0].sizeimage;
+
+	go2001_dbg(ctx->gdev, 1, "S_FMT on CAPTURE to %s\n", fmt->desc);
+
+	return 0;
+}
+
+static int go2001_enc_g_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_frame_info *finfo = &ctx->finfo;
+
+	go2001_trace(ctx->gdev);
+
+	if (!V4L2_TYPE_IS_OUTPUT(s->type)) {
+		go2001_err(ctx->gdev, "G_CROP on CAPTURE for encoder unsupported\n");
+		return -EINVAL;
+	}
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "Frame info not available yet\n");
+		return -EINVAL;
+	}
+
+	switch (s->type) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = finfo->width;
+		s->r.height = finfo->height;
+		go2001_dbg(ctx->gdev, 2, "Crop: (%d, %d) -> (%u, %u)\n",
+			s->r.left, s->r.top, s->r.width, s->r.height);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int go2001_enc_s_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_frame_info *finfo = &ctx->finfo;
+	int aligned_w, aligned_h;
+	struct go2001_fmt *fmt;
+
+	go2001_trace(ctx->gdev);
+
+	if (!V4L2_TYPE_IS_OUTPUT(s->type)) {
+		go2001_err(ctx->gdev, "Crop can only be set on the OUTPUT queue\n");
+		return -EINVAL;
+	}
+
+	if (s->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "Crop must be set after setting format\n");
+		return -EINVAL;
+	}
+
+	fmt = ctx->src_fmt;
+
+	aligned_w = round_up(s->r.width, fmt->h_align);
+	aligned_h = round_up(s->r.height, fmt->v_align);
+
+	if (finfo->width != s->r.width || finfo->height != s->r.height) {
+		go2001_dbg(ctx->gdev, 1, "Adjusted crop from (%d, %d) to (%d, %d)\n",
+			   s->r.width, s->r.height, aligned_w, aligned_h);
+	}
+
+	if (s->r.left != 0 || s->r.top != 0 || aligned_w > finfo->coded_width ||
+	    aligned_h > finfo->coded_height) {
+		go2001_err(ctx->gdev, "Invalid crop (%d, %d) -> (%u, %u) for coded size %ux%u\n",
+			   s->r.left, s->r.top, aligned_w, aligned_h,
+			   finfo->coded_width, finfo->coded_height);
+		return -EINVAL;
+	}
+
+	finfo->width = aligned_w;
+	finfo->height = aligned_h;
+	go2001_dbg(ctx->gdev, 2, "Visible size set to %ux%u\n",
+		   finfo->width, finfo->height);
+
+	return 0;
+}
+
+static int go2001_dec_g_selection(struct file *file, void *fh,
+				  struct v4l2_selection *s)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct go2001_frame_info *finfo = &ctx->finfo;
+
+	go2001_trace(ctx->gdev);
+
+	if (V4L2_TYPE_IS_OUTPUT(s->type)) {
+		go2001_err(ctx->gdev, "G_SEL on OUTPUT for decoder unsupported\n");
+		return -EINVAL;
+	}
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_dbg(ctx->gdev, 1, "Frame info not ready\n");
+		return -EINVAL;
+	}
+
+	switch (s->type) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = finfo->width;
+		s->r.height = finfo->height;
+		go2001_dbg(ctx->gdev, 2, "Crop: (%d, %d) -> (%u, %u)\n",
+			s->r.left, s->r.top, s->r.width, s->r.height);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int go2001_enc_s_parm(struct file *file, void *fh,
+			     struct v4l2_streamparm *p)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_fract *timeperframe;
+	int fps;
+
+	go2001_trace(ctx->gdev);
+
+	if (p->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	timeperframe = &p->parm.output.timeperframe;
+	if (timeperframe->numerator == 0 || timeperframe->denominator == 0) {
+		go2001_err(ctx->gdev, "Invalid values for timeperframe\n");
+		return -EINVAL;
+	}
+
+	/* For now just normalize to 1/x sec/frame. */
+	fps = timeperframe->denominator / timeperframe->numerator;
+	fps = max(1, fps);
+	ctx->pending_rt_params.enc_params.framerate_num = fps;
+	ctx->pending_rt_params.enc_params.framerate_denom = 1;
+	set_bit(GO2001_FRAMERATE_CHANGE, ctx->pending_rt_params.changed_mask);
+	go2001_dbg(ctx->gdev, 2, "FPS changed to %d\n", fps);
+
+	return 0;
+}
+
+static int go2001_enc_g_parm(struct file *file, void *fh,
+			     struct v4l2_streamparm *p)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_fract *timeperframe;
+
+	if (p->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	memset(&p->parm, 0, sizeof(p->parm));
+	p->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+	timeperframe = &p->parm.output.timeperframe;
+	timeperframe->numerator = ctx->enc_params.framerate_denom;
+	timeperframe->denominator = ctx->enc_params.framerate_num;
+
+	return 0;
+}
+
+static int go2001_reqbufs_out(struct go2001_ctx *ctx,
+			      struct v4l2_requestbuffers *rb)
+{
+	struct vb2_queue *vq = &ctx->src_vq;
+	int ret;
+
+	go2001_dbg(ctx->gdev, 3, "count: %d\n", rb->count);
+
+	if (rb->count == 0)
+		return vb2_reqbufs(vq, rb);
+
+	if (!ctx->src_fmt || !ctx->dst_fmt) {
+		go2001_err(ctx->gdev, "Formats not set\n");
+		return -EINVAL;
+	}
+
+	if (ctx->codec_mode == CODEC_MODE_ENCODER &&
+	    !go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "No frame info available yet\n");
+		return -EINVAL;
+	}
+
+	if (ctx->state == UNCOMMITTED) {
+		ret = go2001_init_codec(ctx);
+		if (ret) {
+			go2001_err(ctx->gdev, "Failed initializing codec\n");
+			return ret;
+		}
+
+		go2001_set_ctx_state(ctx, COMMITTED);
+	}
+
+	return vb2_reqbufs(vq, rb);
+}
+
+static int go2001_move_from_resume_queue(struct go2001_ctx *ctx)
+{
+	struct list_head temp_list;
+	struct go2001_buffer *gbuf;
+	unsigned long flags;
+	int ret = 0;
+
+	/*
+	 * The buffer which triggered the resolution change, and any buffers
+	 * which might have followed it and were sent by us to the hardware
+	 * before we got the resolution change notification, have to be
+	 * processed again, in the same order.
+	 * Move them from the resume queue to the front of the source
+	 * queue, and reinitialize for processing.
+	 *
+	 * First, make a copy of the resume list, so we can release
+	 * the lock to be able to call go2001_prepare_gbuf() on each element.
+	 */
+	INIT_LIST_HEAD(&temp_list);
+	spin_lock_irqsave(&ctx->qlock, flags);
+	list_splice_init(&ctx->src_resume_q, &temp_list);
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+	list_for_each_entry(gbuf, &temp_list, list) {
+		go2001_dbg(ctx->gdev, 3, "Requeuing buffer %p\n", gbuf);
+
+		ret = go2001_prepare_gbuf(ctx, gbuf, true);
+		if (ret)
+			break;
+	}
+
+	/*
+	 * Finally, splice the lists so that the resume list is added in
+	 * front of the source list.
+	 */
+	spin_lock_irqsave(&ctx->qlock, flags);
+	list_splice_init(&temp_list, &ctx->src_buf_q);
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	return ret;
+}
+
+static int go2001_reqbufs_cap(struct go2001_ctx *ctx,
+			      struct v4l2_requestbuffers *rb)
+{
+	struct vb2_queue *vq = &ctx->dst_vq;
+	int ret = 0;
+
+	go2001_dbg(ctx->gdev, 3, "count: %d\n", rb->count);
+
+	if (rb->count == 0)
+		return vb2_reqbufs(vq, rb);
+
+	if (!go2001_has_frame_info(ctx)) {
+		go2001_err(ctx->gdev, "No frame info available yet\n");
+		return -EINVAL;
+	}
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER) {
+		switch (ctx->state) {
+		case RES_CHANGE:
+		case PAUSED:
+			ret = go2001_move_from_resume_queue(ctx);
+			if (ret)
+				go2001_set_ctx_state(ctx, ERROR);
+			else
+				go2001_set_ctx_state(ctx, PAUSED);
+			break;
+
+		default:
+			go2001_err(ctx->gdev, "Invalid state\n");
+			return -EINVAL;
+		}
+	} else {
+		if (ctx->state == UNCOMMITTED) {
+			ret = go2001_init_codec(ctx);
+			if (ret) {
+				go2001_err(ctx->gdev, "Failed initializing codec\n");
+				return ret;
+			}
+
+			go2001_set_ctx_state(ctx, COMMITTED);
+		}
+	}
+
+	return vb2_reqbufs(vq, rb);
+}
+
+static int go2001_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *rb)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	int ret;
+
+	if (V4L2_TYPE_IS_OUTPUT(rb->type))
+		ret = go2001_reqbufs_out(ctx, rb);
+	else
+		ret = go2001_reqbufs_cap(ctx, rb);
+
+	if (ret)
+		go2001_err(ctx->gdev, "REQBUFS for type %d failed\n", rb->type);
+	else
+		go2001_dbg(ctx->gdev, 2, "Allocated %d buffers for type %d\n",
+			   rb->count, rb->type);
+
+	return ret;
+}
+
+static int go2001_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	int ret;
+	int i;
+
+	go2001_trace(ctx->gdev);
+
+	if (V4L2_TYPE_IS_OUTPUT(b->type))
+		return vb2_querybuf(&ctx->src_vq, b);
+
+	/* Capture buffer */
+	ret = vb2_querybuf(&ctx->dst_vq, b);
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type))
+		for (i = 0; i < b->length; ++i)
+			b->m.planes[i].m.mem_offset += DST_QUEUE_OFF_BASE;
+	else
+		b->m.offset += DST_QUEUE_OFF_BASE;
+
+	return ret;
+}
+
+static int go2001_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *vq = go2001_get_vq(ctx, b->type);
+
+	if (ctx->state == ERROR) {
+		go2001_dbg(ctx->gdev, 1, "Context %p in error state\n", ctx);
+		return -EIO;
+	}
+
+	return vb2_qbuf(vq, b);
+}
+
+static int go2001_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *vq = go2001_get_vq(ctx, b->type);
+
+	return vb2_dqbuf(vq, b, file->f_flags & O_NONBLOCK);
+}
+
+static int go2001_expbuf(struct file *file, void *fh,
+			 struct v4l2_exportbuffer *e)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *vq = go2001_get_vq(ctx, e->type);
+
+	return vb2_expbuf(vq, e);
+}
+
+static int go2001_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *vq = go2001_get_vq(ctx, type);
+
+	go2001_trace(ctx->gdev);
+
+	return vb2_streamon(vq, type);
+}
+
+static int go2001_streamoff(struct file *file, void *fh,
+			    enum v4l2_buf_type type)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct vb2_queue *vq = go2001_get_vq(ctx, type);
+
+	go2001_trace(ctx->gdev);
+
+	return vb2_streamoff(vq, type);
+}
+
+static int go2001_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+
+	default:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	}
+}
+
+static int go2001_enum_framesizes(struct file *file, void *fh,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct go2001_ctx *ctx = fh_to_ctx(file->private_data);
+	struct v4l2_frmsize_stepwise *s = &fsize->stepwise;
+	struct go2001_fmt *fmt;
+
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	fmt = go2001_find_fmt(ctx, fsize->pixel_format);
+	if (!fmt) {
+		go2001_dbg(ctx->gdev, 1, "Unsupported pixelformat %d\n",
+			   fsize->pixel_format);
+		return -EINVAL;
+	}
+
+	if (fmt->type != FMT_TYPE_CODED) {
+		go2001_dbg(ctx->gdev, 1, "Only supported for coded formats\n");
+		return -EINVAL;
+	}
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	s->min_width = GO2001_VPX_MACROBLOCK_SIZE;
+	s->max_width = 1920;
+	s->step_width = 2;
+	s->min_height = GO2001_VPX_MACROBLOCK_SIZE;
+	s->max_height = 1088;
+	s->step_height = 2;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops go2001_ioctl_dec_ops = {
+	.vidioc_querycap = go2001_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane = go2001_enum_fmt_cap,
+	.vidioc_enum_fmt_vid_out_mplane = go2001_enum_fmt_out,
+
+	.vidioc_g_fmt_vid_cap_mplane = go2001_dec_g_fmt_cap,
+	.vidioc_g_fmt_vid_out_mplane = go2001_dec_g_fmt_out,
+
+	.vidioc_s_fmt_vid_cap_mplane = go2001_dec_s_fmt_cap,
+	.vidioc_s_fmt_vid_out_mplane = go2001_dec_s_fmt_out,
+
+	.vidioc_try_fmt_vid_cap_mplane = go2001_dec_try_fmt_cap,
+	.vidioc_try_fmt_vid_out_mplane = go2001_dec_try_fmt_out,
+
+	.vidioc_g_selection = go2001_dec_g_selection,
+
+	.vidioc_reqbufs = go2001_reqbufs,
+	.vidioc_querybuf = go2001_querybuf,
+	.vidioc_qbuf = go2001_qbuf,
+	.vidioc_dqbuf = go2001_dqbuf,
+	.vidioc_streamon = go2001_streamon,
+	.vidioc_streamoff = go2001_streamoff,
+	.vidioc_expbuf = go2001_expbuf,
+
+	.vidioc_enum_framesizes = go2001_enum_framesizes,
+
+	.vidioc_subscribe_event = go2001_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ioctl_ops go2001_ioctl_enc_ops = {
+	.vidioc_querycap = go2001_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane = go2001_enum_fmt_cap,
+	.vidioc_enum_fmt_vid_out_mplane = go2001_enum_fmt_out,
+
+	.vidioc_g_fmt_vid_cap_mplane = go2001_enc_g_fmt_cap,
+	.vidioc_g_fmt_vid_out_mplane = go2001_enc_g_fmt_out,
+
+	.vidioc_s_fmt_vid_cap_mplane = go2001_enc_s_fmt_cap,
+	.vidioc_s_fmt_vid_out_mplane = go2001_enc_s_fmt_out,
+
+	.vidioc_try_fmt_vid_cap_mplane = go2001_enc_try_fmt_cap,
+	.vidioc_try_fmt_vid_out_mplane = go2001_enc_try_fmt_out,
+
+	.vidioc_g_selection = go2001_enc_g_selection,
+	.vidioc_s_selection = go2001_enc_s_selection,
+
+	.vidioc_s_parm = go2001_enc_s_parm,
+	.vidioc_g_parm = go2001_enc_g_parm,
+
+	.vidioc_reqbufs = go2001_reqbufs,
+	.vidioc_querybuf = go2001_querybuf,
+	.vidioc_qbuf = go2001_qbuf,
+	.vidioc_dqbuf = go2001_dqbuf,
+	.vidioc_streamon = go2001_streamon,
+	.vidioc_streamoff = go2001_streamoff,
+	.vidioc_expbuf = go2001_expbuf,
+
+	.vidioc_enum_framesizes = go2001_enum_framesizes,
+
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static int go2001_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int ret;
+	struct go2001_dev *gdev;
+	struct video_device *vdev;
+
+	dev_info(&pdev->dev, "Probing GO2001\n");
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		go2001_err_nodev("Failed enabling device\n");
+		return ret;
+	}
+
+	ret = pci_request_regions(pdev, DRIVER_NAME);
+	if (ret) {
+		go2001_err_nodev("Failed requesting regions\n");
+		goto disable_device;
+	}
+
+	pci_set_master(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (!ret)
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+
+	if (ret) {
+		go2001_err_nodev("No suitable DMA available\n");
+		goto release_regions;
+	}
+
+	gdev = devm_kzalloc(&pdev->dev, sizeof(*gdev), GFP_KERNEL);
+	if (!gdev) {
+		ret = -ENOMEM;
+		goto release_regions;
+	}
+
+	gdev->pdev = pdev;
+	mutex_init(&gdev->lock);
+
+	spin_lock_init(&gdev->irqlock);
+	INIT_LIST_HEAD(&gdev->inst_list);
+	INIT_LIST_HEAD(&gdev->new_inst_list);
+	INIT_LIST_HEAD(&gdev->ctx_list);
+	init_waitqueue_head(&gdev->reply_wq);
+	init_completion(&gdev->fw_completion);
+	INIT_DELAYED_WORK(&gdev->watchdog_work, go2001_watchdog);
+
+	gdev->msg_cache = kmem_cache_create("msg_cache",
+					    sizeof(struct go2001_msg), 0,
+					    SLAB_HWCACHE_ALIGN, NULL);
+	if (!gdev->msg_cache) {
+		go2001_err(gdev, "Failed creating msg cache\n");
+		goto release_regions;
+	}
+
+	ret = go2001_map_iomem(gdev);
+	if (ret) {
+		go2001_err(gdev, "Failed mapping IO memory\n");
+		goto release_cache;
+	}
+
+	ret = pci_enable_msi(pdev);
+	if (ret) {
+		go2001_err(gdev, "Failed enabling MSI\n");
+		goto unmap;
+	}
+
+	ret = request_irq(pdev->irq, go2001_irq, 0, DRIVER_NAME, gdev);
+	if (ret) {
+		go2001_err(gdev, "Failed requesting IRQ\n");
+		goto disable_msi;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &gdev->v4l2_dev);
+	if (ret) {
+		go2001_err(gdev, "Failed registering V4L2 device\n");
+		goto free_irq;
+	}
+
+	vdev = &gdev->dec_vdev;
+	strlcpy(vdev->name, VDEV_NAME_DEC, sizeof(vdev->name));
+	vdev->v4l2_dev = &gdev->v4l2_dev;
+	vdev->vfl_dir = VFL_DIR_M2M;
+	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	vdev->fops = &go2001_fops;
+	vdev->ioctl_ops = &go2001_ioctl_dec_ops;
+	vdev->lock = &gdev->lock;
+	vdev->release = video_device_release_empty;
+
+	video_set_drvdata(vdev, gdev);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto unregister_v4l2_device;
+
+	vdev = &gdev->enc_vdev;
+	strlcpy(vdev->name, VDEV_NAME_ENC, sizeof(vdev->name));
+	vdev->v4l2_dev = &gdev->v4l2_dev;
+	vdev->vfl_dir = VFL_DIR_M2M;
+	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	vdev->fops = &go2001_fops;
+	vdev->ioctl_ops = &go2001_ioctl_enc_ops;
+	vdev->lock = &gdev->lock;
+	vdev->release = video_device_release_empty;
+
+	video_set_drvdata(vdev, gdev);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto unregister_video_device_dec;
+
+	dev_info(&pdev->dev, "GO2001 successfully initialized.\n");
+
+	return 0;
+
+unregister_video_device_dec:
+	video_unregister_device(&gdev->dec_vdev);
+unregister_v4l2_device:
+	v4l2_device_unregister(&gdev->v4l2_dev);
+free_irq:
+	free_irq(pdev->irq, gdev);
+disable_msi:
+	pci_disable_msi(pdev);
+unmap:
+	go2001_unmap_iomem(gdev);
+release_cache:
+	kmem_cache_destroy(gdev->msg_cache);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void go2001_remove(struct pci_dev *pdev)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct go2001_dev *gdev = container_of(v4l2_dev, struct go2001_dev,
+					       v4l2_dev);
+
+	dev_info(&pdev->dev, "Removing GO2001\n");
+
+	video_unregister_device(&gdev->enc_vdev);
+	video_unregister_device(&gdev->dec_vdev);
+
+	v4l2_device_unregister(&gdev->v4l2_dev);
+
+	free_irq(pdev->irq, gdev);
+
+	pci_disable_msi(pdev);
+
+	go2001_unmap_iomem(gdev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int go2001_suspend(struct device *dev)
+{
+	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	unsigned long flags1, flags2;
+	struct go2001_ctx *ctx;
+	struct go2001_dev *gdev = container_of(v4l2_dev, struct go2001_dev,
+					       v4l2_dev);
+
+	go2001_trace(gdev);
+
+	spin_lock_irqsave(&gdev->irqlock, flags1);
+
+	list_for_each_entry(ctx, &gdev->ctx_list, ctx_entry) {
+		spin_lock_irqsave(&ctx->qlock, flags2);
+		go2001_set_ctx_state(ctx, ERROR);
+		spin_unlock_irqrestore(&ctx->qlock, flags2);
+	}
+
+	spin_unlock_irqrestore(&gdev->irqlock, flags1);
+
+	ret = wait_event_timeout(gdev->reply_wq, gdev->msgs_in_flight == 0,
+				 msecs_to_jiffies(GO2001_WATCHDOG_TIMEOUT_MS));
+	if (ret == 0)
+		go2001_err(gdev, "Timed out waiting for HW to become idle\n");
+
+	mutex_lock(&gdev->lock);
+	go2001_cancel_all_contexts(gdev);
+	mutex_unlock(&gdev->lock);
+
+	return 0;
+}
+
+static int go2001_resume(struct device *dev)
+{
+	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct go2001_dev *gdev = container_of(v4l2_dev, struct go2001_dev,
+					       v4l2_dev);
+
+	go2001_trace(gdev);
+
+	mutex_lock(&gdev->lock);
+
+	ret = go2001_init(gdev);
+	if (ret) {
+		gdev->initialized = false;
+		go2001_err(gdev, "Failed resetting firmware\n");
+	}
+
+	mutex_unlock(&gdev->lock);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(go2001_pm_ops, go2001_suspend, go2001_resume);
+
+static const struct pci_device_id go2001_pci_tbl[] = {
+	{ PCI_DEVICE(0x1ae0, 0x001a) },
+	{},
+};
+
+static struct pci_driver go2001_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = go2001_probe,
+	.remove = go2001_remove,
+	.id_table = go2001_pci_tbl,
+	.driver.pm = &go2001_pm_ops,
+};
+
+module_pci_driver(go2001_driver);
+
+MODULE_DESCRIPTION("GO2001 PCI-E codec driver");
+MODULE_AUTHOR("Pawel Osciak <posciak@chromium.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(pci, go2001_pci_tbl);
diff --git a/drivers/media/pci/go2001/go2001_hw.c b/drivers/media/pci/go2001/go2001_hw.c
new file mode 100644
index 0000000..eec1bfc
--- /dev/null
+++ b/drivers/media/pci/go2001/go2001_hw.c
@@ -0,0 +1,1362 @@
+/*
+ *  go2001 - GO2001 codec driver.
+ *
+ *  Author : Pawel Osciak <posciak@chromium.org>
+ *
+ *  Copyright (C) 2017 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/delay.h>
+#include <linux/firmware.h>
+
+#include "go2001.h"
+#include "go2001_hw.h"
+#include "go2001_proto.h"
+
+static int go2001_load_fw_image(struct go2001_dev *gdev,
+				const struct firmware *fw,
+				void __iomem *ctrl_addr, size_t ctrl_size,
+				void __iomem *load_addr, size_t max_size,
+				u32 entry_addr)
+{
+	struct go2001_boot_hdr hdr;
+	u8 *chksum_ptr;
+	size_t chksum_size;
+	unsigned long flags;
+	u32 reg;
+	int i;
+
+	if (fw->size > GO2001_FW_MAX_SIZE || fw->size > max_size) {
+		go2001_err(gdev, "Firmware image too large (%zu)\n", fw->size);
+		return -EINVAL;
+	}
+
+	if (ctrl_size < GO2001_FW_HDR_OFF + sizeof(hdr) ||
+	    ctrl_size < GO2001_FW_STOP + sizeof(u32)) {
+		go2001_err(gdev, "PCI BAR sizes invalid\n");
+		return -ENODEV;
+	}
+
+	hdr.signature = GO2001_FW_SIGNATURE;
+	hdr.entry_addr = entry_addr;
+	hdr.size = 16;
+	hdr.checksum = 0;
+
+	/*
+	 * Calculate a checksum of the header (excluding checksum field itself).
+	 */
+	chksum_ptr = (u8 *)&hdr;
+	chksum_size = offsetof(struct go2001_boot_hdr, checksum);
+	for (i = 0; i < chksum_size; ++i)
+		hdr.checksum += chksum_ptr[i];
+	hdr.checksum &= 0xff;
+
+	/* Stop the firmware via a soft interrupt. */
+	writeb('p', ctrl_addr + GO2001_FW_HDR_OFF);
+	reg = readl(ctrl_addr + GO2001_FW_STOP);
+	reg |= GO2001_FW_STOP_BIT;
+	writel(reg, ctrl_addr + GO2001_FW_STOP);
+
+	/*
+	 * The next interrupt after resuming will be the "firmware loaded"
+	 * interrupt, clear the flag so we handle this on next IRQ.
+	 */
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	gdev->fw_loaded = false;
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	/* Copy firmware and the header */
+	memcpy_toio(load_addr, fw->data, fw->size);
+	writel(hdr.entry_addr, ctrl_addr + GO2001_FW_HDR_OFF +
+			       offsetof(struct go2001_boot_hdr, entry_addr));
+	writel(hdr.size, ctrl_addr + GO2001_FW_HDR_OFF +
+			 offsetof(struct go2001_boot_hdr, size));
+	writel(hdr.checksum, ctrl_addr + GO2001_FW_HDR_OFF +
+			     offsetof(struct go2001_boot_hdr, checksum));
+	/*
+	 * Write signature last, as this is what the device is spinning on
+	 * while we are loading the firmware
+	 */
+	writel(hdr.signature, ctrl_addr + GO2001_FW_HDR_OFF +
+			      offsetof(struct go2001_boot_hdr, signature));
+
+	/* Clear the interrupt. */
+	reg &= ~GO2001_FW_STOP_BIT;
+	writel(reg, ctrl_addr + GO2001_FW_STOP);
+
+	return 0;
+}
+
+static int go2001_load_firmware(struct go2001_dev *gdev)
+{
+	resource_size_t ctrl_start, fw_start;
+	const struct firmware *boot_fw = NULL;
+	const struct firmware *fw = NULL;
+	void __iomem *fw_iomem;
+	void __iomem *ctrl_iomem;
+	size_t fw_iomem_size, ctrl_iomem_size;
+	int time_spent = 0;
+	int ret;
+
+	init_completion(&gdev->fw_completion);
+
+	ctrl_start = pci_resource_start(gdev->pdev, 2);
+	ctrl_iomem_size = pci_resource_len(gdev->pdev, 2);
+	if (!ctrl_start || !ctrl_iomem_size) {
+		go2001_err(gdev, "PCI BAR 2 invalid\n");
+		return -ENODEV;
+	}
+
+	fw_start = pci_resource_start(gdev->pdev, 0);
+	fw_iomem_size = pci_resource_len(gdev->pdev, 0);
+	if (!fw_start || !fw_iomem_size) {
+		go2001_err(gdev, "PCI BAR 0 invalid\n");
+		return -ENODEV;
+	}
+
+	if (ctrl_iomem_size < GO2001_BOOT_FW_OFF ||
+	    fw_iomem_size < GO2001_FW_OFF) {
+		go2001_err(gdev, "Invalid PCI BAR sizes\n");
+		return -EINVAL;
+	}
+
+	ctrl_iomem = ioremap_nocache(ctrl_start, ctrl_iomem_size);
+	if (!ctrl_iomem) {
+		go2001_err(gdev, "Failed mapping PCI BAR 2\n");
+		return -ENOMEM;
+	}
+
+	fw_iomem = ioremap_nocache(fw_start, fw_iomem_size);
+	if (!fw_iomem) {
+		go2001_err(gdev, "Failed mapping PCI BAR 0\n");
+		ret = -ENOMEM;
+		goto out_unmap_ctrl_iomem;
+	}
+
+	ret = request_firmware(&boot_fw, GO2001_BOOT_FW_NAME, &gdev->pdev->dev);
+	if (ret) {
+		go2001_err(gdev, "Unable to open firmware %s\n",
+			   GO2001_BOOT_FW_NAME);
+		goto out_unmap_fw_iomem;
+	}
+
+	ret = request_firmware(&fw, GO2001_FW_NAME, &gdev->pdev->dev);
+	if (ret) {
+		go2001_err(gdev, "Unable to open firmware %s\n",
+			   GO2001_FW_NAME);
+		goto out_release_boot_fw;
+	}
+
+	ret = go2001_load_fw_image(gdev, boot_fw,
+				ctrl_iomem, ctrl_iomem_size,
+				ctrl_iomem + GO2001_BOOT_FW_OFF,
+				ctrl_iomem_size - GO2001_BOOT_FW_OFF,
+				GO2001_BOOT_FW_ENTRY_BASE + GO2001_BOOT_FW_OFF);
+	if (ret) {
+		go2001_err(gdev, "Failed loading firmware %s\n",
+			   GO2001_BOOT_FW_NAME);
+		goto out_release_fw;
+	}
+
+	/*
+	 * Boot firmware will change GO2001_FW_SIGNATURE to
+	 * GO2001_FW_DONE_SIGNATURE when done.
+	 */
+	while (readl(ctrl_iomem + GO2001_FW_HDR_OFF) !=
+						GO2001_FW_DONE_SIGNATURE &&
+	       time_spent < GO2001_REPLY_TIMEOUT_MS) {
+		mdelay(100);
+		time_spent += 100;
+	}
+
+	if (time_spent >= GO2001_REPLY_TIMEOUT_MS) {
+		go2001_err(gdev, "Timed out waiting for firmware to start\n");
+		ret = -ENODEV;
+		goto out_release_fw;
+	}
+
+	go2001_dbg(gdev, 1, "Firmware %s loaded\n", GO2001_BOOT_FW_NAME);
+
+	ret = go2001_load_fw_image(gdev, fw, ctrl_iomem, ctrl_iomem_size,
+				   fw_iomem + GO2001_FW_OFF,
+				   fw_iomem_size - GO2001_FW_OFF,
+				   GO2001_FW_ENTRY_BASE + GO2001_FW_OFF);
+	if (ret) {
+		go2001_err(gdev, "Failed loading firmware %s\n",
+			   GO2001_FW_NAME);
+		goto out_release_fw;
+	}
+
+	if (wait_for_completion_timeout(&gdev->fw_completion,
+			msecs_to_jiffies(GO2001_REPLY_TIMEOUT_MS)) == 0) {
+		go2001_err(gdev, "Timed out waiting for firmware\n");
+		ret = -ENODEV;
+		goto out_release_fw;
+	}
+
+	go2001_dbg(gdev, 1, "Firmware %s loaded\n", GO2001_FW_NAME);
+
+out_release_fw:
+	release_firmware(fw);
+out_release_boot_fw:
+	release_firmware(boot_fw);
+out_unmap_fw_iomem:
+	iounmap(fw_iomem);
+out_unmap_ctrl_iomem:
+	iounmap(ctrl_iomem);
+
+	return ret;
+}
+
+int go2001_map_iomem(struct go2001_dev *gdev)
+{
+	resource_size_t start = pci_resource_start(gdev->pdev, 0);
+	resource_size_t len = pci_resource_len(gdev->pdev, 0);
+
+	if (!start || !len)
+		return -ENODEV;
+
+	if (len < GO2001_MSG_RING_MEM_OFFSET + GO2001_MSG_RING_MEM_SIZE)
+		return -ENODEV;
+
+	gdev->iomem_size = GO2001_MSG_RING_MEM_SIZE;
+	gdev->iomem = ioremap(start + GO2001_MSG_RING_MEM_OFFSET,
+			      gdev->iomem_size);
+	if (!gdev->iomem)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void go2001_unmap_iomem(struct go2001_dev *gdev)
+{
+	iounmap(gdev->iomem);
+}
+
+void go2001_init_hw_inst(struct go2001_hw_inst *inst, u32 inst_id)
+{
+	inst->session_id = inst_id;
+	inst->sequence_id = 0;
+	inst->last_reply_seq_id = 0;
+	INIT_LIST_HEAD(&inst->pending_list);
+	INIT_LIST_HEAD(&inst->inst_entry);
+}
+
+static void go2001_release_hw_inst(struct go2001_dev *gdev,
+				   struct go2001_hw_inst *inst)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	go2001_cancel_hw_inst_locked(gdev, inst);
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+}
+
+static int go2001_init_ring(struct go2001_dev *gdev,
+			    struct go2001_msg_ring *ring,
+			    off_t ring_desc_offset)
+{
+	struct go2001_msg_ring_desc *desc = &ring->desc;
+
+	spin_lock_init(&ring->lock);
+
+	ring->desc_iomem = gdev->iomem + ring_desc_offset;
+	memcpy_fromio(desc, ring->desc_iomem, sizeof(*desc));
+	go2001_dbg(gdev, 1, "Ring %p: [0x%x-0x%x], msg size: %d, capacity: %d, wr_off: 0x%x, rd_off: 0x%x\n",
+		   ring->desc_iomem, desc->start_off, desc->end_off,
+		   desc->msg_size,
+		   (desc->end_off - desc->start_off) / desc->msg_size,
+		   desc->wr_off, desc->rd_off);
+
+	if (WARN_ON(desc->msg_size == 0 || desc->end_off <= desc->start_off ||
+		    desc->end_off > gdev->iomem_size ||
+		    desc->wr_off != desc->rd_off)) {
+		go2001_err(gdev, "Invalid ring descriptor\n");
+		return -EIO;
+	}
+
+	if (WARN_ON(desc->msg_size > sizeof(struct go2001_msg))) {
+		go2001_err(gdev, "Ring message size over limit\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int go2001_init_messaging(struct go2001_dev *gdev)
+{
+	int ret = 0;
+
+	go2001_dbg(gdev, 1, "Initializing TX ring\n");
+
+	ret = go2001_init_ring(gdev, &gdev->tx_ring,
+			       GO2001_TX_RING_DESC_OFFSET);
+	if (ret)
+		return ret;
+
+	go2001_dbg(gdev, 1, "Initializing RX ring\n");
+
+	ret = go2001_init_ring(gdev, &gdev->rx_ring,
+			       GO2001_RX_RING_DESC_OFFSET);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void go2001_update_ring_locked(struct go2001_msg_ring *r)
+{
+	r->desc.wr_off = ioread32(r->desc_iomem +
+				offsetof(struct go2001_msg_ring_desc, wr_off));
+	r->desc.rd_off = ioread32(r->desc_iomem +
+				offsetof(struct go2001_msg_ring_desc, rd_off));
+}
+
+static inline bool go2001_ring_is_full_locked(struct go2001_msg_ring *r)
+{
+	u32 next_off;
+
+	go2001_update_ring_locked(r);
+	next_off = r->desc.wr_off + r->desc.msg_size;
+	return (next_off == r->desc.rd_off ||
+		(r->desc.rd_off == r->desc.start_off &&
+		 next_off >= r->desc.end_off));
+}
+
+static inline bool go2001_ring_is_empty_locked(struct go2001_msg_ring *r)
+{
+	go2001_update_ring_locked(r);
+	return r->desc.rd_off == r->desc.wr_off;
+}
+
+static struct go2001_msg *prepare_msg(struct go2001_dev *gdev,
+				      enum go2001_msg_type type,
+				      size_t param_size)
+{
+	struct go2001_msg *msg;
+	struct go2001_msg_hdr *hdr;
+
+	msg = kmem_cache_zalloc(gdev->msg_cache, GFP_KERNEL);
+	if (!msg) {
+		go2001_err(gdev, "Failed allocating msg\n");
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&msg->list_entry);
+	hdr = msg_to_hdr(msg);
+	hdr->type = type;
+	hdr->size = go2001_calc_payload_size(param_size);
+
+	return msg;
+}
+
+static void free_msg(struct go2001_dev *gdev, struct go2001_msg *msg)
+{
+	WARN_ON(!list_empty(&msg->list_entry));
+	kmem_cache_free(gdev->msg_cache, msg);
+}
+
+static struct go2001_hw_inst *get_next_ready_hw_inst(struct go2001_dev *gdev)
+{
+	struct go2001_hw_inst *hw_inst;
+
+	go2001_trace(gdev);
+
+	if (list_empty(&gdev->inst_list))
+		return NULL;
+
+	if (!gdev->curr_hw_inst) {
+		gdev->curr_hw_inst = list_first_entry(&gdev->inst_list,
+					struct go2001_hw_inst, inst_entry);
+	}
+
+	hw_inst = gdev->curr_hw_inst;
+	list_for_each_entry_continue(hw_inst, &gdev->inst_list, inst_entry) {
+		if (!list_empty(&hw_inst->pending_list))
+			return hw_inst;
+	}
+
+	list_for_each_entry(hw_inst, &gdev->inst_list, inst_entry) {
+		if (!list_empty(&hw_inst->pending_list))
+			return hw_inst;
+
+		if (hw_inst == gdev->curr_hw_inst)
+			break;
+	}
+
+	return NULL;
+}
+
+static struct go2001_msg *go2001_get_pending_msg_locked(struct go2001_dev *gdev)
+{
+	struct go2001_hw_inst *hw_inst;
+	struct go2001_msg_hdr *hdr;
+	struct go2001_msg *msg;
+
+	assert_spin_locked(&gdev->irqlock);
+
+	hw_inst = get_next_ready_hw_inst(gdev);
+	if (!hw_inst) {
+		go2001_dbg(gdev, 5, "No pending messages\n");
+		return NULL;
+	}
+
+	gdev->curr_hw_inst = hw_inst;
+	msg = list_first_entry(&hw_inst->pending_list, struct go2001_msg,
+			       list_entry);
+	hdr = msg_to_hdr(msg);
+	go2001_dbg(gdev, 5, "Found pending message for instance %d, seqid %d\n",
+		   hw_inst->session_id, hdr->sequence_id);
+
+	list_del_init(&msg->list_entry);
+
+	return msg;
+}
+
+static void go2001_drop_pending_for_hw_inst_locked(struct go2001_dev *gdev,
+						struct go2001_hw_inst *hw_inst)
+{
+	struct go2001_msg *msg, *tmp_msg;
+
+	assert_spin_locked(&gdev->irqlock);
+
+	list_for_each_entry_safe(msg, tmp_msg, &hw_inst->pending_list,
+				 list_entry) {
+		list_del_init(&msg->list_entry);
+		free_msg(gdev, msg);
+	}
+
+	INIT_LIST_HEAD(&hw_inst->pending_list);
+}
+
+void go2001_cancel_hw_inst_locked(struct go2001_dev *gdev,
+				  struct go2001_hw_inst *hw_inst)
+{
+	assert_spin_locked(&gdev->irqlock);
+
+	WARN_ON(!list_empty(&hw_inst->inst_entry) &&
+		!list_empty(&hw_inst->pending_list));
+
+	go2001_drop_pending_for_hw_inst_locked(gdev, hw_inst);
+	list_del_init(&hw_inst->inst_entry);
+	if (gdev->curr_hw_inst == hw_inst)
+		gdev->curr_hw_inst = NULL;
+}
+
+void go2001_cancel_all_hw_inst_locked(struct go2001_dev *gdev)
+{
+	struct go2001_hw_inst *hw_inst;
+
+	assert_spin_locked(&gdev->irqlock);
+
+	list_for_each_entry(hw_inst, &gdev->inst_list, inst_entry)
+		go2001_drop_pending_for_hw_inst_locked(gdev, hw_inst);
+	INIT_LIST_HEAD(&gdev->inst_list);
+
+	list_for_each_entry(hw_inst, &gdev->new_inst_list, inst_entry)
+		go2001_drop_pending_for_hw_inst_locked(gdev, hw_inst);
+	INIT_LIST_HEAD(&gdev->new_inst_list);
+
+	gdev->curr_hw_inst = NULL;
+}
+
+static void go2001_print_msg(struct go2001_dev *gdev, struct go2001_msg *msg,
+			     const char *prefix)
+{
+	struct go2001_msg_hdr *hdr = msg_to_hdr(msg);
+
+	go2001_dbg(gdev, 4, "%s: MSG: [%d/%d], type=0x%x, size=%d, status=0x%x\n",
+		   prefix, hdr->session_id, hdr->sequence_id, hdr->type,
+		   hdr->size, hdr->status);
+
+	if (go2001_debug_level >= 5)
+		print_hex_dump(KERN_DEBUG, prefix, DUMP_PREFIX_NONE, 16, 1,
+			       msg_to_param(msg),
+			       hdr->size - sizeof(struct go2001_msg_hdr),
+			       false);
+}
+
+static void go2001_print_mmap_list(struct go2001_dev *gdev,
+				   struct go2001_dma_desc *dma_desc)
+{
+	struct go2001_mmap_list_entry *mmap_list = dma_desc->mmap_list;
+	int i;
+
+	for (i = 0; i < dma_desc->num_entries; ++i)
+		go2001_dbg(gdev, 4, "entry %02d: addr: 0x%08llx, size: %d\n",
+			   i, mmap_list[i].dma_addr, mmap_list[i].size);
+}
+
+static void go2001_send_pending_locked(struct go2001_dev *gdev)
+{
+	struct go2001_msg_ring *r = &gdev->tx_ring;
+	struct go2001_msg *msg;
+	struct go2001_msg_hdr *hdr;
+	unsigned long flags;
+	struct go2001_msg_ring_desc *desc = &r->desc;
+
+	spin_lock_irqsave(&r->lock, flags);
+
+	while (1) {
+		if (go2001_ring_is_full_locked(r)) {
+			go2001_dbg(gdev, 5, "TX ring full, not sending.\n");
+			break;
+		}
+
+		msg = go2001_get_pending_msg_locked(gdev);
+		if (!msg)
+			break;
+
+		hdr = msg_to_hdr(msg);
+
+		memcpy_toio(r->desc_iomem + desc->wr_off, hdr, hdr->size);
+		go2001_print_msg(gdev, msg, "TX: ");
+		desc->wr_off += desc->msg_size;
+		if (desc->wr_off >= desc->end_off)
+			desc->wr_off = desc->start_off;
+
+		iowrite32(desc->wr_off, r->desc_iomem
+			  + offsetof(struct go2001_msg_ring_desc, wr_off));
+
+		if (gdev->msgs_in_flight == 0)
+			schedule_delayed_work(&gdev->watchdog_work,
+				msecs_to_jiffies(GO2001_WATCHDOG_TIMEOUT_MS));
+
+		++gdev->msgs_in_flight;
+
+		go2001_dbg(gdev, 5, "Messages in flight: %d\n",
+			   gdev->msgs_in_flight);
+
+		free_msg(gdev, msg);
+	}
+
+	spin_unlock_irqrestore(&r->lock, flags);
+}
+
+void go2001_send_pending(struct go2001_dev *gdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	go2001_send_pending_locked(gdev);
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+}
+
+/*
+ * NOTE: msg must not be used by the caller after this functions returns;
+ * either we'll free it after sending it to HW, or it will be cleaned up by the
+ * watchdog on timeout (if still on the pending_list at that time).
+ */
+static u32 go2001_queue_msg_locked(struct go2001_dev *gdev,
+				   struct go2001_hw_inst *hw_inst,
+				   struct go2001_msg *msg)
+{
+	struct go2001_msg_hdr *hdr = msg_to_hdr(msg);
+	u32 seqid;
+
+	assert_spin_locked(&gdev->irqlock);
+
+	hdr->session_id = hw_inst->session_id;
+	seqid = ++hw_inst->sequence_id;
+	hdr->sequence_id = seqid;
+	list_add_tail(&msg->list_entry, &hw_inst->pending_list);
+
+	return seqid;
+}
+
+static u32 go2001_queue_msg(struct go2001_ctx *ctx, struct go2001_msg *msg)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	unsigned long flags;
+	u32 type = msg_to_hdr(msg)->type;
+	u32 seqid;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	seqid = go2001_queue_msg_locked(gdev, &ctx->hw_inst, msg);
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+	go2001_dbg(gdev, 5, "Queued message type 0x%x for inst %d, seqid: %d\n",
+		   type, ctx->hw_inst.session_id, seqid);
+
+	/* The message is freed after being sent to hardware or on error. */
+	go2001_send_pending(gdev);
+
+	return seqid;
+}
+
+static struct go2001_hw_inst *find_hw_inst_by_id_locked(struct go2001_dev *gdev,
+							u32 session_id)
+{
+	struct go2001_hw_inst *hw_inst;
+
+	list_for_each_entry(hw_inst, &gdev->inst_list, inst_entry)
+		if (hw_inst->session_id == session_id)
+			return hw_inst;
+
+	return NULL;
+}
+
+static bool go2001_sequence_passed(struct go2001_dev *gdev,
+				   u32 session_id, u32 seq_id)
+{
+	struct go2001_hw_inst *hw_inst;
+	unsigned long flags;
+	bool ret = true;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+
+	hw_inst = find_hw_inst_by_id_locked(gdev, session_id);
+	if (hw_inst)
+		ret = (hw_inst->last_reply_seq_id >= seq_id);
+
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	return ret;
+}
+
+static int go2001_wait_for_reply(struct go2001_dev *gdev, u32 session_id,
+				 u32 sequence_id)
+{
+	int ret;
+
+	ret = wait_event_timeout(gdev->reply_wq,
+			go2001_sequence_passed(gdev, session_id, sequence_id),
+			msecs_to_jiffies(GO2001_REPLY_TIMEOUT_MS));
+	if (ret == 0) {
+		go2001_err(gdev, "Timeout waiting for reply to %d/%d\n",
+			   session_id, sequence_id);
+		return -ETIMEDOUT;
+	}
+
+	go2001_dbg(gdev, 5, "Finished waiting for %d/%d\n",
+		   session_id, sequence_id);
+
+	return 0;
+}
+
+static inline bool go2001_ctx_idle(struct go2001_ctx *ctx)
+{
+	unsigned long flags1, flags2;
+	bool idle;
+
+	spin_lock_irqsave(&ctx->gdev->irqlock, flags1);
+	spin_lock_irqsave(&ctx->qlock, flags2);
+	idle = list_empty(&ctx->hw_inst.inst_entry) ||
+		(list_empty(&ctx->hw_inst.pending_list) && !ctx->job.src_buf);
+	spin_unlock_irqrestore(&ctx->qlock, flags2);
+	spin_unlock_irqrestore(&ctx->gdev->irqlock, flags1);
+
+	return idle;
+}
+
+void go2001_wait_for_ctx_done(struct go2001_ctx *ctx)
+{
+	/* No timeout, the watchdog will wake us up if needed. */
+	wait_event(ctx->gdev->reply_wq, go2001_ctx_idle(ctx));
+	go2001_wait_for_reply(ctx->gdev, ctx->hw_inst.session_id,
+			      ctx->hw_inst.sequence_id);
+}
+
+static int go2001_queue_msg_and_wait(struct go2001_ctx *ctx,
+				     struct go2001_msg *msg)
+{
+	u32 session_id = ctx->hw_inst.session_id;
+	u32 seqid;
+
+	/* msg becomes invalid after the call to go2001_queue_msg. */
+	seqid = go2001_queue_msg(ctx, msg);
+
+	return go2001_wait_for_reply(ctx->gdev, session_id, seqid);
+}
+
+static int go2001_queue_ctrl_msg_and_wait(struct go2001_dev *gdev,
+					  struct go2001_msg *msg)
+{
+	unsigned long flags;
+	u32 seqid;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+	seqid = go2001_queue_msg_locked(gdev, &gdev->ctrl_inst, msg);
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	go2001_dbg(gdev, 5, "Queued control msg seqid: %d\n", seqid);
+
+	go2001_send_pending(gdev);
+
+	return go2001_wait_for_reply(gdev, 0, seqid);
+}
+
+static int go2001_queue_init_msg_and_wait(struct go2001_ctx *ctx,
+					  struct go2001_msg *msg)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	unsigned long flags;
+	u32 seqid;
+
+	spin_lock_irqsave(&gdev->irqlock, flags);
+
+	seqid = go2001_queue_msg_locked(gdev, &gdev->ctrl_inst, msg);
+	if (ctx && !WARN_ON(!list_empty(&ctx->hw_inst.inst_entry))) {
+		go2001_dbg(gdev, 5, "New inst seq %d\n", seqid);
+		list_add_tail(&ctx->hw_inst.inst_entry, &gdev->new_inst_list);
+		/* Will use sequence_id to check if we got the
+		 * reply for the correct new ctx in IRQ.
+		 */
+		ctx->hw_inst.sequence_id = seqid;
+	}
+
+	spin_unlock_irqrestore(&gdev->irqlock, flags);
+
+	go2001_send_pending(gdev);
+
+	return go2001_wait_for_reply(gdev, 0, seqid);
+}
+
+int go2001_get_reply(struct go2001_dev *gdev, struct go2001_msg *msg)
+{
+	struct go2001_msg_ring *r = &gdev->rx_ring;
+	struct go2001_msg_hdr *hdr = msg_to_hdr(msg);
+	struct go2001_msg_ring_desc *desc = &r->desc;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&r->lock, flags);
+
+	if (go2001_ring_is_empty_locked(r)) {
+		go2001_dbg(gdev, 5, "Ring empty\n");
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	memcpy_fromio(hdr, r->desc_iomem + desc->rd_off, desc->msg_size);
+	go2001_print_msg(gdev, msg, "RX: ");
+
+	desc->rd_off += desc->msg_size;
+	if (desc->rd_off >= desc->end_off)
+		desc->rd_off = desc->start_off;
+
+	iowrite32(desc->rd_off, r->desc_iomem +
+				offsetof(struct go2001_msg_ring_desc, rd_off));
+
+out:
+	spin_unlock_irqrestore(&r->lock, flags);
+	return ret;
+}
+
+static int go2001_init_decoder(struct go2001_ctx *ctx)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_init_decoder_param *param;
+	struct go2001_msg *msg;
+	unsigned long flags;
+	int ret;
+
+	if (!ctx->src_fmt) {
+		go2001_err(gdev, "Input format not set\n");
+		return -EINVAL;
+	}
+
+	go2001_dbg(gdev, 2, "Initializing decoder for format %s\n",
+		   ctx->src_fmt->desc);
+
+	msg = prepare_msg(gdev, GO2001_VM_INIT_DECODER, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+
+	param = msg_to_param(msg);
+	param->coded_fmt = ctx->src_fmt->hw_format;
+	param->concealment = 0;
+
+	ret = go2001_queue_init_msg_and_wait(ctx, msg);
+	spin_lock_irqsave(&ctx->qlock, flags);
+	if (ret || ctx->state == ERROR) {
+		go2001_err(gdev, "Failed initializing decoder\n");
+		ret = ret ? ret : -EIO;
+	}
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	return ret;
+}
+
+static int go2001_s_ctrl(struct go2001_ctx *ctx, enum go2001_hw_ctrl_type type,
+			 union go2001_hw_ctrl *ctrl)
+{
+	struct go2001_set_ctrl_param *param;
+	struct go2001_msg *msg;
+
+	msg = prepare_msg(ctx->gdev, GO2001_VM_SET_CTRL, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+
+	param = msg_to_param(msg);
+	param->type = type;
+
+	memcpy(&param->ctrl, ctrl, sizeof(*ctrl));
+
+	return go2001_queue_msg_and_wait(ctx, msg);
+}
+
+static int go2001_set_def_encoder_ctrls(struct go2001_ctx *ctx)
+{
+	union go2001_hw_ctrl hw_ctrl;
+	struct go2001_enc_coding_ctrl *ctrl = &hw_ctrl.coding_ctrl;
+
+	memset(&hw_ctrl, 0, sizeof(hw_ctrl));
+	ctrl->interp_filter_type = GO2001_CODING_CTRL_INTERP_FILTER_BICUBIC;
+	ctrl->deblock_filter_type = GO2001_CODING_CTRL_DEBLOCK_FILTER_NORMAL;
+	ctrl->deblock_filter_level = 64;
+	ctrl->deblock_filter_sharpness = 8;
+	ctrl->num_dct_parts = 1;
+	ctrl->error_resilient = 1;
+	ctrl->split_mv = GO2001_CODING_CTRL_MV_ADAPTIVE;
+	ctrl->quarter_pixel_mv = GO2001_CODING_CTRL_MV_ADAPTIVE;
+	ctrl->deadzone_enabled = 1;
+	ctrl->max_num_passes = 1;
+	ctrl->quality_metric = GO2001_CODING_CTRL_QM_SSIM;
+
+	return go2001_s_ctrl(ctx, GO2001_HW_CTRL_TYPE_CODING, &hw_ctrl);
+}
+
+static int go2001_init_encoder(struct go2001_ctx *ctx)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_init_encoder_param *param;
+	struct go2001_frame_info *finfo;
+	struct go2001_msg *msg;
+	int ret;
+
+	if (WARN_ON(!ctx->src_fmt || !ctx->dst_fmt ||
+		    !go2001_has_frame_info(ctx))) {
+		go2001_dbg(ctx->gdev, 2, "Formats not set\n");
+		return -EINVAL;
+	}
+
+	go2001_dbg(gdev, 2, "Initializing encoder for formats %s->%s at %dx%d\n",
+		   ctx->src_fmt->desc, ctx->dst_fmt->desc, ctx->finfo.width,
+		   ctx->finfo.height);
+
+	msg = prepare_msg(gdev, GO2001_VM_INIT_ENCODER, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+
+	param = msg_to_param(msg);
+	finfo = &ctx->finfo;
+
+	param->session_id = 0;
+	param->num_ref_frames = ctx->enc_params.multi_ref_frame_mode ? 1 : 3;
+	param->width = finfo->width;
+	param->height = finfo->height;
+	param->orig_width = finfo->width;
+	param->orig_height = finfo->height;
+	param->framerate_num = ctx->enc_params.framerate_num;
+	param->framerate_denom = ctx->enc_params.framerate_denom;
+	param->raw_fmt = ctx->src_fmt->hw_format;
+
+	ret = go2001_queue_init_msg_and_wait(ctx, msg);
+	if (ret || ctx->state == ERROR) {
+		go2001_err(gdev, "Failed initializing encoder\n");
+		return ret ? ret : -EIO;
+	}
+
+	return go2001_set_def_encoder_ctrls(ctx);
+}
+
+void go2001_release_codec(struct go2001_ctx *ctx)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_msg *msg;
+
+	go2001_dbg(gdev, 2, "Releasing session id %d, codec state %d\n",
+		   ctx->hw_inst.session_id, ctx->state);
+
+	if (ctx->hw_inst.session_id != 0) {
+		msg = prepare_msg(gdev, GO2001_VM_RELEASE, 0);
+		if (msg)
+			go2001_queue_msg_and_wait(ctx, msg);
+	}
+
+	/* Regardless of whether we sent and/or got a reply or not, clean up. */
+	go2001_release_hw_inst(gdev, &ctx->hw_inst);
+}
+
+int go2001_map_buffer(struct go2001_ctx *ctx, struct go2001_buffer *buf)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_set_mmap_param *param;
+	struct vb2_buffer *vb = &buf->vb;
+	struct go2001_dma_desc *dma_desc;
+	struct go2001_msg *msg;
+	struct go2001_mmap_list_desc *list_desc;
+	unsigned int i;
+
+	if (buf->mapped) {
+		go2001_err(gdev, "Buffer already mapped\n");
+		return -EINVAL;
+	}
+
+	if (vb->num_planes > GO2001_MMAP_MAX_ENTRIES) {
+		go2001_err(gdev, "Too many planes to map\n");
+		return -EIO;
+	}
+
+	msg = prepare_msg(gdev, GO2001_VM_SET_MMAP, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+	param = msg_to_param(msg);
+	param->dir = V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) ?
+		     GO2001_VSM_DIR_IN : GO2001_VSM_DIR_OUT;
+	param->count = vb->num_planes;
+	for (i = 0; i < vb->num_planes; ++i) {
+		dma_desc = &buf->dma_desc[i];
+		list_desc = &param->mmap_list_desc[i];
+
+		dma_desc->map_addr = dma_desc->mmap_list[0].dma_addr;
+
+		list_desc->first_entry_dma_addr = dma_desc->map_addr;
+		list_desc->entry_count = dma_desc->num_entries;
+		list_desc->mmap_list_addr = dma_desc->dma_addr;
+
+		go2001_dbg(gdev, 4, "Mapping plane %u: 0x%08llx, chunks: %d in HW\n",
+			   i, dma_desc->map_addr, dma_desc->num_entries);
+		go2001_print_mmap_list(gdev, dma_desc);
+	}
+
+	go2001_queue_msg(ctx, msg);
+
+	buf->mapped = true;
+
+	return 0;
+}
+
+void go2001_unmap_buffer(struct go2001_ctx *ctx, struct go2001_buffer *buf)
+{
+	struct go2001_release_mmap_param *param;
+	struct go2001_dev *gdev = ctx->gdev;
+	struct vb2_buffer *vb = &buf->vb;
+	struct go2001_msg *msg;
+	unsigned int i;
+
+	if (!buf->mapped) {
+		go2001_dbg(gdev, 1, "Buffer not mapped\n");
+		return;
+	}
+
+	if (vb->num_planes > GO2001_MMAP_MAX_ENTRIES) {
+		go2001_dbg(gdev, 1, "Too many planes\n");
+		return;
+	}
+
+	go2001_dbg(gdev, 3, "Unmapping buffer %p from HW\n", buf);
+
+	msg = prepare_msg(gdev, GO2001_VM_RELEASE_MMAP, sizeof(*param));
+	if (!msg)
+		return;
+
+	param = msg_to_param(msg);
+	param->dir = V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) ?
+		     GO2001_VSM_DIR_IN :
+		     GO2001_VSM_DIR_OUT;
+	param->count = vb->num_planes;
+	for (i = 0; i < vb->num_planes; ++i) {
+		param->addr[i] = buf->dma_desc[i].map_addr;
+		go2001_dbg(gdev, 4, "Unmapping plane %u, 0x%08llx from HW\n",
+			   i, buf->dma_desc[i].map_addr);
+	}
+
+	go2001_queue_msg_and_wait(ctx, msg);
+
+	buf->mapped = false;
+}
+
+int go2001_unmap_buffers(struct go2001_ctx *ctx, bool unmap_src, bool unmap_dst)
+{
+	struct go2001_release_mmap_param *param;
+	struct go2001_msg *msg;
+
+	if (WARN_ON(!unmap_src && !unmap_dst))
+		return 0;
+
+	msg = prepare_msg(ctx->gdev, GO2001_VM_RELEASE_MMAP, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+	param = msg_to_param(msg);
+	param->dir |= (unmap_src ? GO2001_VSM_DIR_IN : 0);
+	param->dir |= (unmap_dst ? GO2001_VSM_DIR_OUT : 0);
+
+	return go2001_queue_msg_and_wait(ctx, msg);
+}
+
+static int go2001_build_dec_msg(struct go2001_ctx *ctx, struct go2001_msg *msg,
+				struct go2001_buffer *src_buf,
+				struct go2001_buffer *dst_buf)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_empty_buffer_dec_param *param;
+	int i;
+
+	assert_spin_locked(&ctx->qlock);
+
+	if (!src_buf->mapped || (dst_buf && !dst_buf->mapped)) {
+		go2001_err(gdev, "Buffer(s) not mapped!\n");
+		return -EINVAL;
+	}
+
+	param = msg_to_param(msg);
+
+	param->in_addr = src_buf->dma_desc[0].map_addr;
+	param->payload_size = vb2_get_plane_payload(&src_buf->vb, 0);
+	if (dst_buf) {
+		if (WARN_ON(dst_buf->vb.num_planes >
+					ARRAY_SIZE(param->out_addr)))
+			return -EINVAL;
+
+		for (i = 0; i < dst_buf->vb.num_planes; ++i) {
+			param->out_addr[i] = dst_buf->dma_desc[i].map_addr;
+			WARN_ON(!IS_ALIGNED(param->out_addr[i], 16));
+		}
+
+		if (!ctx->dst_fmt) {
+			go2001_err(gdev, "Destination format not set\n");
+			return -EINVAL;
+		}
+		param->raw_fmt = ctx->dst_fmt->hw_format;
+	}
+
+	param->flags = ctx->need_resume ?
+		       G02001_EMPTY_BUF_DEC_FLAG_RES_CHANGE_DONE :
+		       0;
+	ctx->need_resume = false;
+
+	return 0;
+}
+
+static void go2001_update_enc_params(struct go2001_ctx *ctx,
+			struct go2001_runtime_enc_params *rt_enc_params) {
+	unsigned long *changed_mask;
+	struct go2001_enc_params *new_params;
+
+	if (!rt_enc_params->changed_mask)
+		return;
+
+	changed_mask = rt_enc_params->changed_mask;
+	new_params = &rt_enc_params->enc_params;
+
+	if (test_and_clear_bit(GO2001_BITRATE_CHANGE, changed_mask))
+		ctx->enc_params.bitrate = new_params->bitrate;
+
+	if (test_and_clear_bit(GO2001_FRAMERATE_CHANGE, changed_mask)) {
+		ctx->enc_params.framerate_num =	new_params->framerate_num;
+		ctx->enc_params.framerate_denom = new_params->framerate_denom;
+	}
+
+	if (test_and_clear_bit(GO2001_KEYFRAME_REQUESTED, changed_mask))
+		ctx->enc_params.request_keyframe = new_params->request_keyframe;
+}
+
+static int go2001_build_enc_msg(struct go2001_ctx *ctx, struct go2001_msg *msg,
+				struct go2001_buffer *src_buf,
+				struct go2001_buffer *dst_buf)
+{
+	struct go2001_empty_buffer_enc_param *param;
+	struct go2001_dev *gdev = ctx->gdev;
+	int i;
+
+	if (WARN_ON(!src_buf || !dst_buf))
+		return -EINVAL;
+
+	assert_spin_locked(&ctx->qlock);
+
+	if (!src_buf->mapped || !dst_buf->mapped) {
+		go2001_err(gdev, "Buffer(s) not mapped!\n");
+		return -EINVAL;
+	}
+
+	param = msg_to_param(msg);
+
+	if (WARN_ON(src_buf->vb.num_planes > ARRAY_SIZE(param->in_addr)))
+		return -EINVAL;
+
+	for (i = 0; i < src_buf->vb.num_planes; ++i) {
+		param->in_addr[i] = src_buf->dma_desc[i].map_addr;
+		WARN_ON(!IS_ALIGNED(param->in_addr[i], 16));
+	}
+	param->out_addr = dst_buf->dma_desc[0].map_addr;
+	param->out_size = vb2_plane_size(&dst_buf->vb, 0);
+
+	go2001_update_enc_params(ctx, &src_buf->rt_enc_params);
+	if (ctx->enc_params.request_keyframe) {
+		param->frame_type = GO2001_EMPTY_BUF_ENC_FRAME_KEYFRAME;
+		ctx->enc_params.frames_since_intra = 0;
+		ctx->enc_params.request_keyframe = false;
+	} else {
+		param->frame_type = GO2001_EMPTY_BUF_ENC_FRAME_PRED;
+	}
+
+	if (WARN_ON(ctx->enc_params.framerate_num == 0))
+		return -EINVAL;
+
+	param->time_increment = GO2001_MAX_FPS / ctx->enc_params.framerate_num;
+	param->bits_per_sec = ctx->enc_params.bitrate;
+	ctx->enc_params.bitrate = 0;
+
+	if (!ctx->enc_params.multi_ref_frame_mode ||
+	    ctx->enc_params.frames_since_intra % 4 == 0) {
+		/* Frame controls for temporal layer 0. */
+		param->ipf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE_AND_REFRESH;
+		param->grf_frame_ctrl = GO2001_FRM_CTRL_NO_REFRESH;
+		param->arf_frame_ctrl = GO2001_FRM_CTRL_NO_REFRESH;
+	} else if (ctx->enc_params.frames_since_intra % 2 == 0) {
+		/* Frame controls for temporal layer 1. */
+		param->ipf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE;
+		param->grf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE_AND_REFRESH;
+		param->arf_frame_ctrl = GO2001_FRM_CTRL_NO_REFRESH;
+	} else {
+		/* Frame controls for temporal layer 2. */
+		param->ipf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE;
+		param->grf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE;
+		param->arf_frame_ctrl = GO2001_FRM_CTRL_REFERENCE_AND_REFRESH;
+	}
+	ctx->enc_params.frames_since_intra++;
+
+	return 0;
+}
+
+static void go2001_flush(struct go2001_ctx *ctx, struct go2001_buffer *src_buf)
+{
+	assert_spin_locked(&ctx->qlock);
+
+	go2001_dbg(ctx->gdev, 4, "Flushing at src_buf ts=%llu\n",
+		   src_buf->vb.timestamp);
+
+	/*
+	 * Since VPX has no frame reordering and buffers are returned as
+	 * soon as they are decoded, there is no need trigger anything on the
+	 * destination queue. Just return the flush buffer to userspace.
+	 */
+	list_del(&src_buf->list);
+	vb2_buffer_done(&src_buf->vb, VB2_BUF_STATE_DONE);
+}
+
+int go2001_prepare_gbuf(struct go2001_ctx *ctx, struct go2001_buffer *gbuf,
+			bool is_src)
+{
+	struct go2001_msg *msg;
+	size_t size;
+
+	if (!is_src)
+		return 0;
+
+	if (WARN_ON(gbuf->msg))
+		return -EINVAL;
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER)
+		size = sizeof(struct go2001_empty_buffer_dec_param);
+	else
+		size = sizeof(struct go2001_empty_buffer_enc_param);
+
+	msg = prepare_msg(ctx->gdev, GO2001_VM_EMPTY_BUFFER, size);
+	if (!msg)
+		return -ENOMEM;
+
+	gbuf->msg = msg;
+	return 0;
+}
+
+void go2001_finish_gbuf(struct go2001_ctx *ctx, struct go2001_buffer *gbuf)
+{
+	if (gbuf->msg) {
+		free_msg(ctx->gdev, gbuf->msg);
+		gbuf->msg = NULL;
+	}
+}
+
+int go2001_schedule_frames(struct go2001_ctx *ctx)
+{
+	struct go2001_dev *gdev = ctx->gdev;
+	struct go2001_job *job = &ctx->job;
+	struct go2001_msg *msg = NULL;
+	struct go2001_buffer *src_buf;
+	struct go2001_buffer *dst_buf;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ctx->qlock, flags);
+	if (job->src_buf) {
+		go2001_dbg(gdev, 5, "Job already running\n");
+		goto out;
+	}
+
+	if (WARN_ON(job->dst_buf)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	go2001_dbg(gdev, 5, "State: %d\n", ctx->state);
+again:
+	src_buf = NULL;
+	dst_buf = NULL;
+
+	switch (ctx->state) {
+	case NEED_HEADER_INFO:
+		if (WARN_ON(ctx->codec_mode == CODEC_MODE_ENCODER)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!list_empty(&ctx->src_buf_q)) {
+			src_buf = list_first_entry(&ctx->src_buf_q,
+						   struct go2001_buffer, list);
+		}
+		break;
+
+	case RUNNING:
+		if (!list_empty(&ctx->src_buf_q) &&
+		    !list_empty(&ctx->dst_buf_q)) {
+			src_buf = list_first_entry(&ctx->src_buf_q,
+						   struct go2001_buffer, list);
+			dst_buf = list_first_entry(&ctx->dst_buf_q,
+						   struct go2001_buffer, list);
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	if (!src_buf)
+		goto out;
+
+	msg = src_buf->msg;
+	if (WARN_ON(!msg))
+		goto out;
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER) {
+		if (vb2_get_plane_payload(&src_buf->vb, 0) == 0) {
+			/* Flush buffer */
+			go2001_flush(ctx, src_buf);
+			goto again;
+		}
+
+		ret = go2001_build_dec_msg(ctx, msg, src_buf, dst_buf);
+	} else {
+		ret = go2001_build_enc_msg(ctx, msg, src_buf, dst_buf);
+	}
+	if (ret)
+		goto out;
+
+	job->src_buf = src_buf;
+	if (dst_buf)
+		job->dst_buf = dst_buf;
+
+	src_buf->msg = NULL;
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+
+	go2001_queue_msg(ctx, msg);
+	return 0;
+out:
+	if (ret) {
+		go2001_set_ctx_state(ctx, ERROR);
+		go2001_err(gdev, "Error scheduling frames\n");
+	}
+
+	spin_unlock_irqrestore(&ctx->qlock, flags);
+	return ret;
+}
+
+static int go2001_query_hw_version(struct go2001_dev *gdev)
+{
+	struct go2001_msg *msg;
+
+	msg = prepare_msg(gdev, GO2001_VM_GET_VERSION, 0);
+	if (!msg)
+		return -ENOMEM;
+
+	return go2001_queue_ctrl_msg_and_wait(gdev, msg);
+}
+
+static int go2001_set_log_level(struct go2001_dev *gdev, u32 level)
+{
+	struct go2001_set_log_level_param *param;
+	struct go2001_msg *msg;
+
+	if (level != GO2001_LOG_LEVEL_DISABLED && level > GO2001_LOG_LEVEL_MAX)
+		level = GO2001_LOG_LEVEL_MAX;
+
+	msg = prepare_msg(gdev, GO2001_VM_SET_LOG_LEVEL, sizeof(*param));
+	if (!msg)
+		return -ENOMEM;
+
+	param = msg_to_param(msg);
+	param->level = level;
+
+	return go2001_queue_ctrl_msg_and_wait(gdev, msg);
+}
+
+int go2001_init_codec(struct go2001_ctx *ctx)
+{
+	int ret = 0;
+
+	if (WARN_ON(ctx->hw_inst.session_id != 0))
+		return -EINVAL;
+
+	if (ctx->codec_mode == CODEC_MODE_DECODER)
+		ret = go2001_init_decoder(ctx);
+	else
+		ret = go2001_init_encoder(ctx);
+
+	return ret;
+}
+
+int go2001_init(struct go2001_dev *gdev)
+{
+	int ret;
+
+	WARN_ON(!mutex_is_locked(&gdev->lock));
+
+	WARN_ON(!list_empty(&gdev->inst_list));
+	INIT_LIST_HEAD(&gdev->inst_list);
+
+	WARN_ON(!list_empty(&gdev->new_inst_list));
+	INIT_LIST_HEAD(&gdev->new_inst_list);
+
+	go2001_init_hw_inst(&gdev->ctrl_inst, 0);
+	list_add_tail(&gdev->ctrl_inst.inst_entry, &gdev->inst_list);
+	gdev->curr_hw_inst = &gdev->ctrl_inst;
+
+	ret = go2001_load_firmware(gdev);
+	if (ret) {
+		go2001_err(gdev, "Failed loading firmware\n");
+		return ret;
+	}
+
+	ret = go2001_init_messaging(gdev);
+	if (ret) {
+		go2001_err(gdev, "Failed to init messaging\n");
+		return ret;
+	}
+
+	ret = go2001_query_hw_version(gdev);
+	if (ret) {
+		go2001_err(gdev, "Failed querying HW version\n");
+		return ret;
+	}
+
+	ret = go2001_set_log_level(gdev, go2001_fw_debug_level);
+	if (ret) {
+		go2001_err(gdev, "Failed setting log level\n");
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/media/pci/go2001/go2001_hw.h b/drivers/media/pci/go2001/go2001_hw.h
new file mode 100644
index 0000000..5cbfd49
--- /dev/null
+++ b/drivers/media/pci/go2001/go2001_hw.h
@@ -0,0 +1,55 @@
+/*
+ *  go2001 - GO2001 codec driver.
+ *
+ *  Author : Pawel Osciak <posciak@chromium.org>
+ *
+ *  Copyright (C) 2017 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _MEDIA_PCI_GO2001_GO2001_HW_H_
+#define _MEDIA_PCI_GO2001_GO2001_HW_H_
+
+#include "go2001.h"
+
+int go2001_map_iomem(struct go2001_dev *gdev);
+void go2001_unmap_iomem(struct go2001_dev *gdev);
+
+int go2001_init(struct go2001_dev *gdev);
+
+int go2001_init_codec(struct go2001_ctx *ctx);
+void go2001_release_codec(struct go2001_ctx *ctx);
+
+int go2001_set_dec_raw_fmt(struct go2001_ctx *ctx);
+
+int go2001_map_buffer(struct go2001_ctx *ctx, struct go2001_buffer *buf);
+void go2001_unmap_buffer(struct go2001_ctx *ctx, struct go2001_buffer *buf);
+int go2001_unmap_buffers(struct go2001_ctx *ctx, bool unmap_src,
+			 bool unmap_dst);
+
+int go2001_prepare_gbuf(struct go2001_ctx *ctx, struct go2001_buffer *gbuf,
+			bool is_src);
+void go2001_finish_gbuf(struct go2001_ctx *ctx, struct go2001_buffer *gbuf);
+int go2001_schedule_frames(struct go2001_ctx *ctx);
+void go2001_wait_for_ctx_done(struct go2001_ctx *ctx);
+void go2001_send_pending(struct go2001_dev *gdev);
+void go2001_cancel_hw_inst_locked(struct go2001_dev *gdev,
+				  struct go2001_hw_inst *hw_inst);
+void go2001_cancel_all_hw_inst_locked(struct go2001_dev *gdev);
+
+void go2001_init_hw_inst(struct go2001_hw_inst *inst, u32 inst_id);
+
+int go2001_get_reply(struct go2001_dev *gdev, struct go2001_msg *msg);
+
+#endif /* _MEDIA_PCI_GO2001_GO2001_HW_H_ */
diff --git a/drivers/media/pci/go2001/go2001_proto.h b/drivers/media/pci/go2001/go2001_proto.h
new file mode 100644
index 0000000..a5f8b67
--- /dev/null
+++ b/drivers/media/pci/go2001/go2001_proto.h
@@ -0,0 +1,359 @@
+/*
+ *  go2001 - GO2001 codec driver.
+ *
+ *  Author : Pawel Osciak <posciak@chromium.org>
+ *
+ *  Copyright (C) 2017 Google, Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef _MEDIA_PCI_GO2001_GO2001_PROTO_H_
+#define _MEDIA_PCI_GO2001_GO2001_PROTO_H_
+
+struct go2001_msg_ring_desc {
+	u32 msg_size;
+	u32 start_off;
+	u32 end_off;
+	u32 wr_off;
+	u32 rd_off;
+} __packed;
+
+#define GO2001_CTRL_SESSION_ID	0
+struct go2001_msg_hdr {
+	u32 size;
+	u32 session_id;
+	u32 sequence_id;
+	u32 type;
+	u32 status;
+} __packed;
+
+#define GO2001_MAX_MSG_PAYLOAD_SIZE	SZ_256
+struct go2001_msg_payload {
+	struct go2001_msg_hdr hdr;
+	u8 param[GO2001_MAX_MSG_PAYLOAD_SIZE - sizeof(struct go2001_msg_hdr)];
+} __packed;
+
+#define go2001_calc_payload_size(param_size) \
+	(sizeof(struct go2001_msg_hdr) + (param_size))
+
+enum go2001_msg_status {
+	GO2001_STATUS_OK = 0,
+	GO2001_STATUS_FAIL = 1,
+	GO2001_STATUS_RES_NA = 2,
+	GO2001_STATUS_INVALID_PARAM = 3,
+	GO2001_STATUS_NOT_IMPLEMENTED = 4,
+	GO2001_STATUS_NEW_PICTURE_SIZE = 5,
+	GO2001_STATUS_WAITING_PICTURE_SIZE_CHANGED = 6,
+	GO2001_STATUS_STREAM_ERROR = 7,
+	GO2001_STATUS_NO_OUTPUT = 8,
+	GO2001_STATUS_INFO_NOT_READY = 9,
+	GO2001_STATUS_RESTART_SYS = 10,
+};
+
+enum go2001_msg_type {
+	GO2001_VM_INIT_DECODER = 0x100,
+	GO2001_VM_INIT_ENCODER = 0x101,
+	GO2001_VM_INIT_PASSTHROUGH = 0x102,
+	GO2001_VM_GET_VERSION = 0x104,
+	GO2001_VM_SET_MMAP = 0x105,
+	GO2001_VM_RELEASE_MMAP = 0x106,
+	GO2001_VM_EMPTY_BUFFER = 0x107,
+	GO2001_VM_GET_INFO = 0x108,
+	GO2001_VM_SET_CTRL = 0x109,
+	GO2001_VM_GET_CTRL = 0x10a,
+	GO2001_VM_RELEASE = 0x10b,
+	GO2001_VM_RELEASE_ALL = 0x10c,
+	GO2001_VM_EVENT_ASSERT = 0x200,
+	GO2001_VM_EVENT_LOG = 0x201,
+	GO2001_VM_SET_LOG_LEVEL = 0x300,
+};
+
+#define GO2001_MSG_RING_MEM_OFFSET	0x401000
+#define GO2001_MSG_RING_MEM_SIZE	0x2000
+#define GO2001_RX_RING_DESC_OFFSET	0x0
+#define GO2001_TX_RING_DESC_OFFSET	0x100
+
+#define GO2001_FMT_NV12			0x20001
+#define GO2001_FMT_NV12_TILED_8X4	0x20002
+#define GO2001_FMT_ARGB			0x20003
+
+enum go2001_hw_format_coded {
+	GO2001_FMT_VP8 = 1,
+	GO2001_FMT_VP9 = 2,
+};
+
+enum go2001_hw_format_raw {
+	GO2001_FMT_YUV420_PLANAR = 0,
+	GO2001_FMT_YUV420_SEMIPLANAR = 1,
+	GO2001_FMT_YUV420_SEMIPLANAR_VU = 2,
+	GO2001_FMT_YUV422_INTERLEAVED_YUYV = 3,
+	GO2001_FMT_YUV422_INTERLEAVED_UYVY = 4,
+	GO2001_FMT_RGB565 = 5,
+	GO2001_FMT_BGR565 = 6,
+	GO2001_FMT_RGB555 = 7,
+	GO2001_FMT_BGR555 = 8,
+	GO2001_FMT_RGB444 = 9,
+	GO2001_FMT_BGR444 = 10,
+	GO2001_FMT_RGB888 = 11,
+	GO2001_FMT_BGR888 = 12,
+	GO2001_FMT_RGB101010 = 13,
+	GO2001_FMT_BGR101010 = 14,
+};
+
+struct go2001_init_decoder_param {
+	u32 coded_fmt;
+	u32 concealment;
+} __packed;
+
+struct go2001_init_decoder_reply {
+	u32 session_id;
+	u32 input_address;
+	u32 input_buffer_size;
+	u32 output_address;
+} __packed;
+
+struct go2001_init_encoder_param {
+	u32 session_id;
+	u32 num_ref_frames;
+	u32 width;
+	u32 height;
+	u32 orig_width;
+	u32 orig_height;
+	u32 framerate_num;
+	u32 framerate_denom;
+	u32 raw_fmt;
+} __packed;
+
+struct go2001_init_encoder_reply {
+} __packed;
+
+struct go2001_get_info_reply {
+	u32 vpx_version;
+	u32 vpx_profile;
+	u32 visible_width;
+	u32 visible_height;
+	u32 coded_width;
+	u32 coded_height;
+	u32 scaled_width;
+	u32 scaled_height;
+} __packed;
+
+struct go2001_get_version_reply {
+	u32 hw_ver;
+	u32 sw_ver;
+	u32 vp8dec_hw_ver;
+	u32 vp8dec_sw_ver;
+	u32 vp8enc_hw_ver;
+	u32 vp8enc_sw_ver;
+	u32 vp9dec_hw_ver;
+	u32 vp9dec_sw_ver;
+} __packed;
+
+struct go2001_enc_coding_ctrl_area {
+	u32 enabled;
+	u32 top;
+	u32 left;
+	u32 bottom;
+	u32 right;
+} __packed;
+
+#define GO2001_CODING_CTRL_INTERP_FILTER_BICUBIC	0x0
+#define GO2001_CODING_CTRL_INTERP_FILTER_BILINEAR	0x1
+#define GO2001_CODING_CTRL_INTERP_FILTER_NONE		0x2
+
+#define GO2001_CODING_CTRL_DEBLOCK_FILTER_NORMAL	0x0
+#define GO2001_CODING_CTRL_DEBLOCK_FILTER_SIMPLE	0x1
+
+#define GO2001_CODING_CTRL_MV_DISABLED		0x0
+#define GO2001_CODING_CTRL_MV_ADAPTIVE		0x1
+#define GO2001_CODING_CTRL_MV_ENABLED		0x2
+
+#define GO2001_CODING_CTRL_QM_PSNR	0x0
+#define GO2001_CODING_CTRL_QM_SSIM	0x1
+struct go2001_enc_coding_ctrl {
+	u32 interp_filter_type;
+	u32 deblock_filter_type;
+	u32 deblock_filter_level;
+	u32 deblock_filter_sharpness;
+	u32 num_dct_parts;
+	u32 error_resilient;
+	u32 split_mv;
+	u32 quarter_pixel_mv;
+	u32 cir_start;
+	u32 cir_interval;
+	struct go2001_enc_coding_ctrl_area intra_area;
+	struct go2001_enc_coding_ctrl_area roi1_area;
+	struct go2001_enc_coding_ctrl_area roi2_area;
+	s32 roi1_delta_qp;
+	s32 roi2_delta_qp;
+	u32 deadzone_enabled;
+	u32 max_num_passes;
+	u32 quality_metric;
+	s32 qp_delta[5];
+	s32 adaptive_roi;
+	s32 adaptive_roi_color;
+} __packed;
+
+struct go2001_enc_rate_ctrl {
+} __packed;
+
+struct go2001_enc_preprocess_ctrl {
+} __packed;
+
+enum go2001_hw_ctrl_type {
+	GO2001_HW_CTRL_TYPE_RATE = 1,
+	GO2001_HW_CTRL_TYPE_CODING = 2,
+	GO2001_HW_CTRL_TYPE_PREPROCESS = 3,
+};
+
+union go2001_hw_ctrl {
+	struct go2001_enc_rate_ctrl rate_ctrl;
+	struct go2001_enc_coding_ctrl coding_ctrl;
+	struct go2001_enc_preprocess_ctrl prep_ctrl;
+} __packed;
+
+struct go2001_set_ctrl_param {
+	u32 type;
+	union go2001_hw_ctrl ctrl;
+} __packed;
+
+struct go2001_set_ctrl_reply {
+} __packed;
+
+#define G02001_EMPTY_BUF_DEC_FLAG_RES_CHANGE_DONE	0x1
+struct go2001_empty_buffer_dec_param {
+	u64 in_addr;
+	u32 payload_size;
+	u64 out_addr[2];
+	u32 flags;
+	u32 raw_fmt;
+} __packed;
+
+struct go2001_empty_buffer_dec_reply {
+	struct go2001_get_info_reply info;
+	u32 intra_frame;
+	u32 golden_frame;
+	u32 num_error_mbs;
+	u32 num_slice_rows;
+} __packed;
+
+#define GO2001_EMPTY_BUF_ENC_FRAME_KEYFRAME	0x0
+#define GO2001_EMPTY_BUF_ENC_FRAME_PRED		0x1
+
+enum go2001_enc_frame_control {
+	GO2001_FRM_CTRL_NO_REFRESH = 0,
+	GO2001_FRM_CTRL_REFERENCE = 1,
+	GO2001_FRM_CTRL_REFRESH = 2,
+	GO2001_FRM_CTRL_REFERENCE_AND_REFRESH = 3,
+};
+
+struct go2001_empty_buffer_enc_param {
+	u64 in_addr[3];
+	u64 out_addr;
+	u32 out_size;
+	u32 frame_type;
+	u32 time_increment;
+	u64 stab_in_addr;
+	u32 ipf_frame_ctrl;
+	u32 grf_frame_ctrl;
+	u32 arf_frame_ctrl;
+	u32 layer_id;
+	u32 bits_per_sec;
+} __packed;
+
+#define VP8_MAX_NUM_PARTITIONS 9
+struct go2001_empty_buffer_enc_reply {
+	u32 frame_type;
+	u32 partition_off[VP8_MAX_NUM_PARTITIONS];
+	u32 partition_size[VP8_MAX_NUM_PARTITIONS];
+	u32 payload_size;
+	u32 ipf_frame_ctrl;
+	u32 grf_frame_ctrl;
+	u32 arf_frame_ctrl;
+} __packed;
+
+struct go2001_mmap_list_desc {
+	u64 first_entry_dma_addr;
+	u32 entry_count;
+	u64 mmap_list_addr;
+} __packed;
+
+#define GO2001_VSM_DIR_IN	BIT(0)
+#define GO2001_VSM_DIR_OUT	BIT(1)
+#define GO2001_MMAP_MAX_ENTRIES	9
+struct go2001_set_mmap_param {
+	u32 dir;
+	u32 count;
+	struct go2001_mmap_list_desc mmap_list_desc[GO2001_MMAP_MAX_ENTRIES];
+} __packed;
+
+struct go2001_mmap_list_entry {
+	u64 dma_addr;
+	u32 size;
+} __packed;
+
+struct go2001_release_mmap_param {
+	u32 dir;
+	u32 count;
+	u64 addr[GO2001_MMAP_MAX_ENTRIES];
+} __packed;
+
+struct go2001_event_assert_reply {
+	u8 filename[32];
+	u8 funcname[32];
+	u8 expr[32];
+	u32 line_no;
+} __packed;
+
+struct go2001_event_log_reply {
+	u8 data[128];
+} __packed;
+
+#define GO2001_LOG_LEVEL_MAX		5
+#define GO2001_LOG_LEVEL_DISABLED	0xFFFFFFFF
+struct go2001_set_log_level_param {
+	u32 level;
+} __packed;
+
+struct go2001_set_log_level_reply {
+	u32 level;
+} __packed;
+
+struct go2001_boot_hdr {
+	u32 signature;
+	u32 entry_addr;
+	u32 size;
+	u32 checksum;
+} __packed;
+
+#define GO2001_FW_HDR_OFF	0x20afc0
+#define GO2001_FW_STOP		0x212010
+#define GO2001_FW_STOP_BIT	BIT(20)
+
+#define GO2001_BOOT_FW_NAME		"go2001-boot.fw"
+#define GO2001_BOOT_FW_OFF		0x207000
+#define GO2001_BOOT_FW_ENTRY_BASE	0xd0000000
+
+#define GO2001_FW_NAME		"go2001.fw"
+#define GO2001_FW_OFF		0
+#define GO2001_FW_ENTRY_BASE	0
+
+#define GO2001_FW_SIGNATURE \
+(((u32)'P') | (((u32)'C') << 8) | (((u32)'I') << 16) | (((u32)'E') << 24))
+#define GO2001_FW_DONE_SIGNATURE \
+(((u32)'D') | (((u32)'O') << 8) | (((u32)'N') << 16) | (((u32)'E') << 24))
+
+#define GO2001_FW_MAX_SIZE	SZ_1M
+
+#endif /* _MEDIA_PCI_GO2001_GO2001_PROTO_H_ */
-- 
2.7.4
