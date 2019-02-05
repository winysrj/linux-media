Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F95FC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA7F2080D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfBEGoQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:44:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:17086 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726956AbfBEGoP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:44:15 -0500
X-UUID: cdf781c8c8f14c788353940428cdb650-20190205
X-UUID: cdf781c8c8f14c788353940428cdb650-20190205
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 39438573; Tue, 05 Feb 2019 14:43:26 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:24 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 5 Feb 2019 14:43:24 +0800
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>
Subject: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP Pass 1 driver
Date:   Tue, 5 Feb 2019 14:42:46 +0800
Message-ID: <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 93389A65638587445762B08E556E7647354CD43E4AB54D10544DD9B696A7B3E72000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Jungo Lin <jungo.lin@mediatek.com>

This patch adds the driver for Pass unit in Mediatek's camera
ISP system. Pass 1 unit is embedded in Mediatek SOCs. It
provides RAW processing which includes optical black correction,
defect pixel correction, W/IR imbalance correction and lens
shading correction.

The mtk-isp directory will contain drivers for multiple IP
blocks found in Mediatek ISP system. It will include ISP Pass 1
driver, sensor interface driver, DIP driver and face detection
driver.

Signed-off-by: Jungo Lin <jungo.lin@mediatek.com>
Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-isp/Makefile            |   14 +
 drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
 drivers/media/platform/mtk-isp/isp_50/cam/Makefile |   35 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h      |  327 ++++
 .../mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c      |  986 +++++++++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-dev.c      |  381 +++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-dev.h      |  204 +++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-regs.h     |  146 ++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c |  452 ++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-smem.h     |   27 +
 .../mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c         | 1555 ++++++++++++++++++++
 .../mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h         |   49 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c     |  288 ++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h     |   40 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c      |  466 ++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h      |  158 ++
 .../media/platform/mtk-isp/isp_50/cam/mtk_cam.c    | 1235 ++++++++++++++++
 .../media/platform/mtk-isp/isp_50/cam/mtk_cam.h    |  347 +++++
 19 files changed, 6729 insertions(+)
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.h

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e6deb25..9773b3a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -103,3 +103,5 @@ obj-y					+= meson/
 obj-y					+= cros-ec-cec/
 
 obj-$(CONFIG_VIDEO_SUN6I_CSI)		+= sunxi/sun6i-csi/
+
+obj-y	+= mtk-isp/
diff --git a/drivers/media/platform/mtk-isp/Makefile b/drivers/media/platform/mtk-isp/Makefile
new file mode 100644
index 0000000..84d575a
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/Makefile
@@ -0,0 +1,14 @@
+#
+# Copyright (C) 2018 MediaTek Inc.
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+
+obj-y += isp_50/
diff --git a/drivers/media/platform/mtk-isp/isp_50/Makefile b/drivers/media/platform/mtk-isp/isp_50/Makefile
new file mode 100644
index 0000000..b4718a2
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/Makefile
@@ -0,0 +1,17 @@
+#
+# Copyright (C) 2018 MediaTek Inc.
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+
+ifeq ($(CONFIG_VIDEO_MEDIATEK_ISP_PASS1_SUPPORT),y)
+obj-y += cam/
+endif
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/Makefile b/drivers/media/platform/mtk-isp/isp_50/cam/Makefile
new file mode 100644
index 0000000..12dea40
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/Makefile
@@ -0,0 +1,35 @@
+#
+# Copyright (C) 2018 MediaTek Inc.
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+#
+
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-isp/isp_50/cam
+
+obj-y += mtk_cam-vpu.o
+obj-y += mtk_cam.o
+obj-y += mtk_cam-v4l2.o
+
+# To provide alloc context managing memory shared
+# between CPU and ISP coprocessor
+mtk_cam_smem-objs := \
+mtk_cam-smem-drv.o
+
+obj-y += mtk_cam_smem.o
+
+# Utilits to provide frame-based streaming model
+# with v4l2 user interfaces
+mtk_cam_util-objs := \
+mtk_cam-dev.o \
+mtk_cam-v4l2-util.o \
+mtk_cam-dev-ctx-core.o \
+
+obj-y += mtk_cam_util.o
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
new file mode 100644
index 0000000..11a60a6
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
@@ -0,0 +1,327 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_CAM_CTX_H__
+#define __MTK_CAM_CTX_H__
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-subdev.h>
+#include "mtk_cam-v4l2-util.h"
+
+#define MTK_CAM_CTX_QUEUES (16)
+#define MTK_CAM_CTX_FRAME_BUNDLE_BUFFER_MAX (MTK_CAM_CTX_QUEUES)
+#define MTK_CAM_CTX_DESC_MAX (MTK_CAM_CTX_QUEUES)
+
+#define MTK_CAM_CTX_MODE_DEBUG_OFF (0)
+#define MTK_CAM_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER (1)
+#define MTK_CAM_CTX_MODE_DEBUG_BYPASS_ALL (2)
+
+#define MTK_CAM_GET_CTX_ID_FROM_SEQUENCE(sequence) \
+	((sequence) >> 16 & 0x0000FFFF)
+
+#define MTK_CAM_CTX_META_BUF_DEFAULT_SIZE (1110 * 1024)
+
+struct mtk_cam_ctx;
+struct mtk_cam_ctx_open_param;
+struct mtk_cam_ctx_release_param;
+struct mtk_cam_ctx_streamon_param;
+struct mtk_cam_ctx_streamoff_param;
+struct mtk_cam_ctx_start_param;
+struct mtk_cam_ctx_finish_param;
+
+/* struct mtk_cam_ctx_ops - background hardware driving ops */
+/* sdefines background driver specific callback APIs  */
+struct mtk_cam_ctx_ops {
+	int (*open)(struct mtk_cam_ctx *dev_ctx,
+		    struct mtk_cam_ctx_open_param *param);
+	int (*release)(struct mtk_cam_ctx *dev_ctx,
+		       struct mtk_cam_ctx_release_param *param);
+	int (*start)(struct mtk_cam_ctx *dev_ctx,
+		     struct mtk_cam_ctx_start_param *param);
+	int (*finish)(struct mtk_cam_ctx *dev_ctx,
+		      struct mtk_cam_ctx_finish_param *param);
+	int (*streamon)(struct mtk_cam_ctx *dev_ctx,
+			struct mtk_cam_ctx_streamon_param *param);
+	int (*streamoff)(struct mtk_cam_ctx *dev_ctx,
+			 struct mtk_cam_ctx_streamoff_param *param);
+};
+
+/* Attributes setup by device context owner */
+struct mtk_cam_ctx_queue_desc {
+	int id;	/* id of the context queue */
+	char *name;
+	/* Will be exported to media entity name */
+	int capture;
+	/* true for capture queue (device to user), false for output queue */
+	/* (from user to device) */
+	int image;
+	/* Using the cam_smem_drv as alloc ctx or not */
+	int smem_alloc;
+	/* true for image, false for meta data */
+	unsigned int dma_port; /*The dma port associated to the buffer*/
+	/* Supported format */
+	struct mtk_cam_ctx_format *fmts;
+	int num_fmts;
+	/* Default format of this queue */
+	int default_fmt_idx;
+};
+
+/* Supported format and the information used for */
+/* size calculation */
+struct mtk_cam_ctx_meta_format {
+	u32 dataformat;
+	u32 max_buffer_size;
+	u8 flags;
+};
+
+struct mtk_cam_ctx_img_format {
+	u32	pixelformat;
+	u8	depth[VIDEO_MAX_PLANES];
+	u8	row_depth[VIDEO_MAX_PLANES];
+	u8	num_planes;
+	u32	flags;
+};
+
+struct mtk_cam_ctx_format {
+	union {
+		struct mtk_cam_ctx_meta_format meta;
+		struct mtk_cam_ctx_img_format img;
+	} fmt;
+};
+
+union mtk_v4l2_fmt {
+	struct v4l2_pix_format_mplane pix_mp;
+	struct v4l2_meta_format	meta;
+};
+
+/* Attributes setup by device context owner */
+struct mtk_cam_ctx_queues_setting {
+	int master;
+	/* The master input node to trigger the frame data enqueue */
+	struct mtk_cam_ctx_queue_desc *output_queue_descs;
+	int total_output_queues;
+	struct mtk_cam_ctx_queue_desc *capture_queue_descs;
+	int total_capture_queues;
+};
+
+struct mtk_cam_ctx_queue_attr {
+	int master;
+	int input_offset;
+	int total_num;
+};
+
+/* Video node context. Since we use */
+/* mtk_cam_ctx_frame_bundle to manage enqueued */
+/* buffers by frame now, we don't use bufs filed of */
+/* mtk_cam_ctx_queue now */
+struct mtk_cam_ctx_queue {
+	union mtk_v4l2_fmt fmt;
+	struct mtk_cam_ctx_format *ctx_fmt;
+	/* Currently we used in standard v4l2 image format */
+	/* in the device context */
+	unsigned int width_pad;	/* bytesperline, reserved */
+	struct mtk_cam_ctx_queue_desc desc;
+	struct list_head bufs; /* Reserved, not used now */
+};
+
+enum mtk_cam_ctx_frame_bundle_state {
+	MTK_CAM_CTX_FRAME_NEW,	/* Not allocated */
+	MTK_CAM_CTX_FRAME_PREPARED, /* Allocated but has not be processed */
+	MTK_CAM_CTX_FRAME_PROCESSING,	/* Queued, waiting to be filled */
+};
+
+/* The definiation is compatible with DIP driver's state definiation */
+/* currently and will be decoupled after further integration */
+enum mtk_cam_ctx_frame_data_state {
+	MTK_CAM_CTX_FRAME_DATA_EMPTY = 0, /* FRAME_STATE_INIT */
+	MTK_CAM_CTX_FRAME_DATA_DONE = 3, /* FRAME_STATE_DONE */
+	MTK_CAM_CTX_FRAME_DATA_STREAMOFF_DONE = 4, /*FRAME_STATE_STREAMOFF*/
+	MTK_CAM_CTX_FRAME_DATA_ERROR = 5, /*FRAME_STATE_ERROR*/
+};
+
+struct mtk_cam_ctx_frame_bundle {
+	struct mtk_cam_ctx_buffer*
+		buffers[MTK_CAM_CTX_FRAME_BUNDLE_BUFFER_MAX];
+	int id;
+	int num_img_capture_bufs;
+	int num_img_output_bufs;
+	int num_meta_capture_bufs;
+	int num_meta_output_bufs;
+	int last_index;
+	int state;
+	struct list_head list;
+};
+
+struct mtk_cam_ctx_frame_bundle_list {
+	struct list_head list;
+};
+
+struct mtk_cam_ctx {
+	struct platform_device *pdev;
+	struct platform_device *smem_device;
+	/* buffer queues will be added later */
+	unsigned short ctx_id;
+	char *device_name;
+	const struct mtk_cam_ctx_ops *ops;
+	struct mtk_cam_dev_node_mapping *mtk_cam_dev_node_map;
+	unsigned int dev_node_num;
+	/* mtk_cam_ctx_queue is the context for the video nodes */
+	struct mtk_cam_ctx_queue queue[MTK_CAM_CTX_QUEUES];
+	struct mtk_cam_ctx_queue_attr queues_attr;
+	atomic_t frame_param_sequence;
+	int streaming;
+	void *default_vb2_alloc_ctx;
+	void *smem_vb2_alloc_ctx;
+	struct v4l2_subdev_fh *fh;
+	struct mtk_cam_ctx_frame_bundle frame_bundles[VB2_MAX_FRAME];
+	struct mtk_cam_ctx_frame_bundle_list processing_frames;
+	struct mtk_cam_ctx_frame_bundle_list free_frames;
+	int enabled_dma_ports;
+	int num_frame_bundle;
+	spinlock_t qlock; /* frame queues protection */
+};
+
+enum mtk_cam_ctx_buffer_state {
+	MTK_CAM_CTX_BUFFER_NEW,
+	MTK_CAM_CTX_BUFFER_PROCESSING,
+	MTK_CAM_CTX_BUFFER_DONE,
+	MTK_CAM_CTX_BUFFER_FAILED,
+};
+
+struct mtk_cam_ctx_buffer {
+	union mtk_v4l2_fmt fmt;
+	struct mtk_cam_ctx_format *ctx_fmt;
+	int capture;
+	int image;
+	int frame_id;
+	int user_sequence; /* Sequence number assigned by user */
+	dma_addr_t daddr;
+	void *vaddr;
+	phys_addr_t paddr;
+	unsigned int queue;
+	enum mtk_cam_ctx_buffer_state state;
+	struct list_head list;
+};
+
+struct mtk_cam_ctx_setting {
+	struct mtk_cam_ctx_ops *ops;
+	char *device_name;
+};
+
+struct mtk_cam_ctx_desc {
+	char *proc_dev_phandle;
+	/* The context device's compatble string name in device tree*/
+	int (*init)(struct mtk_cam_ctx *ctx);
+	/* configure the core functions of the device context */
+};
+
+struct mtk_cam_ctx_init_table {
+	int total_dev_ctx;
+	struct mtk_cam_ctx_desc *ctx_desc_tbl;
+};
+
+struct mtk_cam_ctx_open_param {
+	/* Bitmask used to notify that the DMA port is enabled or not */
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_cam_ctx_streamon_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_cam_ctx_streamoff_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_cam_ctx_start_param {
+	/* carry buffer information of the frame */
+	struct mtk_cam_ctx_frame_bundle *frame_bundle;
+};
+
+struct mtk_cam_ctx_release_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_cam_ctx_start_param_wrapper {
+	struct mtk_cam_ctx_start_param param;
+	/* Private fields */
+	/* Don't change any field outside mtk_cam-dev-ctx-core */
+	/* Since it may corrupt the common framework */
+	struct mtk_cam_ctx *ctx;
+};
+
+struct mtk_cam_ctx_finish_param {
+	unsigned int frame_id;
+	u64 timestamp;
+	unsigned int state;
+	unsigned int sequence;
+};
+
+int mtk_cam_ctx_is_streaming(struct mtk_cam_ctx *ctx);
+int mtk_cam_ctx_core_job_finish(struct mtk_cam_ctx *ctx,
+				struct mtk_cam_ctx_finish_param *param);
+int mtk_cam_ctx_core_init(struct mtk_cam_ctx *ctx,
+			  struct platform_device *pdev, int ctx_id,
+			  struct mtk_cam_ctx_desc *ctx_desc,
+			  struct platform_device *proc_pdev,
+			  struct platform_device *smem_pdev);
+int mtk_cam_ctx_core_exit(struct mtk_cam_ctx *ctx);
+void mtk_cam_ctx_buf_init(struct mtk_cam_ctx_buffer *b,
+			  unsigned int queue, dma_addr_t daddr);
+extern enum mtk_cam_ctx_buffer_state
+	mtk_cam_ctx_get_buffer_state(struct mtk_cam_ctx_buffer *b);
+extern int mtk_cam_ctx_next_global_frame_sequence
+	(struct mtk_cam_ctx *ctx, int locked);
+extern int mtk_cam_ctx_core_steup
+	(struct mtk_cam_ctx *ctx,
+	 struct mtk_cam_ctx_setting *ctx_setting);
+int mtk_cam_ctx_core_queue_setup
+	(struct mtk_cam_ctx *ctx,
+	 struct mtk_cam_ctx_queues_setting *queues_setting);
+int mtk_cam_ctx_core_finish_param_init(void *param,
+				       int frame_id, int state);
+int mtk_cam_ctx_queue_event_dev_state
+	(struct mtk_cam_ctx *dev_ctx,
+	 struct mtk_cam_dev_stat_event_data *stat);
+int mtk_cam_ctx_finish_frame(struct mtk_cam_ctx *dev_ctx,
+			     struct mtk_cam_ctx_frame_bundle *frame_bundle,
+			     int done);
+extern int mtk_cam_ctx_frame_bundle_init
+	(struct mtk_cam_ctx_frame_bundle *frame_bundle);
+void mtk_cam_ctx_frame_bundle_add(struct mtk_cam_ctx *ctx,
+				  struct mtk_cam_ctx_frame_bundle *bundle,
+	struct mtk_cam_ctx_buffer *ctx_buf);
+extern int mtk_cam_ctx_trigger_job
+	(struct mtk_cam_ctx *dev_ctx,
+	struct mtk_cam_ctx_frame_bundle *bundle_data);
+extern int mtk_cam_ctx_fmt_set_img
+	(struct mtk_cam_ctx *dev_ctx, int queue_id,
+	 struct v4l2_pix_format_mplane *user_fmt,
+	 struct v4l2_pix_format_mplane *node_fmt);
+extern int mtk_cam_ctx_fmt_set_meta
+	(struct mtk_cam_ctx *dev_ctx, int queue_id,
+	 struct v4l2_meta_format *user_fmt,
+	 struct v4l2_meta_format *node_fmt);
+int mtk_cam_ctx_format_load_default_fmt
+	(struct mtk_cam_ctx_queue *queue,
+	 struct v4l2_format *fmt_to_fill);
+int mtk_cam_ctx_streamon(struct mtk_cam_ctx *dev_ctx);
+int mtk_cam_ctx_streamoff(struct mtk_cam_ctx *dev_ctx);
+int mtk_cam_ctx_release(struct mtk_cam_ctx *dev_ctx);
+int mtk_cam_ctx_open(struct mtk_cam_ctx *dev_ctx);
+#endif /*__MTK_CAM_CTX_H__*/
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
new file mode 100644
index 0000000..7d0197b
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
@@ -0,0 +1,986 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <media/videobuf2-dma-contig.h>
+#include <linux/dma-mapping.h>
+#include <media/v4l2-event.h>
+
+#include "mtk_cam-dev.h"
+#include "mtk_cam-v4l2-util.h"
+#include "mtk_cam-v4l2.h"
+#include "mtk_cam-smem.h"
+
+static struct mtk_cam_ctx_format *mtk_cam_ctx_find_fmt
+	(struct mtk_cam_ctx_queue *queue,
+	 u32 format);
+
+static int mtk_cam_ctx_process_frame(struct mtk_cam_ctx *dev_ctx,
+				     struct mtk_cam_ctx_frame_bundle
+				     *frame_bundle);
+
+static int mtk_cam_ctx_free_frame(struct mtk_cam_ctx *dev_ctx,
+				  struct mtk_cam_ctx_frame_bundle
+				  *frame_bundle);
+
+static struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_free_frame
+	(struct mtk_cam_ctx *dev_ctx);
+
+static struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_processing_frame
+(struct mtk_cam_ctx *dev_ctx, int frame_id);
+
+static int mtk_cam_ctx_init_frame_bundles(struct mtk_cam_ctx *dev_ctx);
+
+static void mtk_cam_ctx_queue_event_frame_done
+	(struct mtk_cam_ctx *dev_ctx,
+	struct mtk_cam_dev_frame_done_event_data *fdone);
+
+static void debug_bundle(struct mtk_cam_ctx  *dev_ctx,
+			 struct mtk_cam_ctx_frame_bundle *bundle_data);
+
+struct vb2_v4l2_buffer *mtk_cam_ctx_buffer_get_vb2_v4l2_buffer
+(struct mtk_cam_ctx_buffer *ctx_buf)
+{
+	struct mtk_cam_dev_buffer *dev_buf = NULL;
+
+	if (!ctx_buf) {
+		pr_err("Failed to convert ctx_buf to dev_buf: Null pointer\n");
+		return NULL;
+	}
+
+	dev_buf	= mtk_cam_ctx_buf_to_dev_buf(ctx_buf);
+
+	return &dev_buf->m2m2_buf.vbb;
+}
+
+/* The helper to configure the device context */
+int mtk_cam_ctx_core_steup(struct mtk_cam_ctx *ctx,
+			   struct mtk_cam_ctx_setting *ctx_setting)
+{
+	if (!ctx || !ctx_setting)
+		return -EINVAL;
+
+	ctx->ops = ctx_setting->ops;
+	ctx->device_name = ctx_setting->device_name;
+
+	return 0;
+}
+
+int mtk_cam_ctx_core_queue_setup(struct mtk_cam_ctx *ctx,
+				 struct mtk_cam_ctx_queues_setting
+				 *queues_setting)
+{
+	int queue_idx = 0;
+	int i = 0;
+
+	for (i = 0; i < queues_setting->total_output_queues; i++) {
+		struct mtk_cam_ctx_queue_desc *queue_desc =
+			queues_setting->output_queue_descs + i;
+
+		if (!queue_desc)
+			return -EINVAL;
+
+		/* Since the *ctx->queue has been initialized to 0 */
+		/* when it is allocated with mtk_cam_dev , */
+		/* I don't initialize the struct here */
+		ctx->queue[queue_idx].desc = *queue_desc;
+		queue_idx++;
+	}
+
+	ctx->queues_attr.input_offset = queue_idx;
+
+	/* Setup the capture queue */
+	for (i = 0; i < queues_setting->total_capture_queues; i++) {
+		struct mtk_cam_ctx_queue_desc *queue_desc =
+			queues_setting->capture_queue_descs + i;
+
+		if (!queue_desc)
+			return -EINVAL;
+
+		/* Since the *ctx->queue has been initialized to 0 */
+		/* when allocating the memory, I don't */
+		/* reinitialied the struct here */
+		ctx->queue[queue_idx].desc = *queue_desc;
+		queue_idx++;
+	}
+
+	ctx->queues_attr.master = queues_setting->master;
+	ctx->queues_attr.total_num = queue_idx;
+	ctx->dev_node_num = ctx->queues_attr.total_num;
+	return 0;
+}
+
+/* Mediatek ISP context core initialization */
+int mtk_cam_ctx_core_init(struct mtk_cam_ctx *ctx,
+			  struct platform_device *pdev, int ctx_id,
+	struct mtk_cam_ctx_desc *ctx_desc,
+	struct platform_device *proc_pdev,
+	struct platform_device *smem_pdev)
+{
+	/* Initialize main data structure */
+	int r = 0;
+
+	ctx->smem_vb2_alloc_ctx = &smem_pdev->dev;
+	ctx->default_vb2_alloc_ctx = &pdev->dev;
+
+	if (IS_ERR((__force void *)ctx->smem_vb2_alloc_ctx))
+		pr_err("Failed to alloc vb2 dma context: smem_vb2_alloc_ctx");
+
+	if (IS_ERR((__force void *)ctx->default_vb2_alloc_ctx))
+		pr_err("Failed to alloc vb2 dma context: default_vb2_alloc_ctx");
+
+	ctx->pdev = pdev;
+	ctx->ctx_id = ctx_id;
+	/* keep th smem pdev to use related iommu functions */
+	ctx->smem_device = smem_pdev;
+
+	/* initialized the global frame index of the device context */
+	atomic_set(&ctx->frame_param_sequence, 0);
+	spin_lock_init(&ctx->qlock);
+
+	/* setup the core operation of the device context */
+	if (ctx_desc && ctx_desc->init)
+		r = ctx_desc->init(ctx);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_init);
+
+int mtk_cam_ctx_core_exit(struct mtk_cam_ctx *ctx)
+{
+	ctx->smem_vb2_alloc_ctx = NULL;
+	ctx->default_vb2_alloc_ctx = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_exit);
+
+/* Get the corrospnd FH of a specific buffer */
+int mtk_cam_ctx_next_global_frame_sequence(struct mtk_cam_ctx *ctx,
+					   int locked)
+{
+	int global_frame_sequence =
+		atomic_inc_return(&ctx->frame_param_sequence);
+
+	if (!locked)
+		spin_lock(&ctx->qlock);
+
+	global_frame_sequence =
+		(global_frame_sequence & 0x0000FFFF) | (ctx->ctx_id << 16);
+
+	if (!locked)
+		spin_unlock(&ctx->qlock);
+
+	return global_frame_sequence;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_next_global_frame_sequence);
+
+static void mtk_cam_ctx_buffer_done
+	(struct mtk_cam_ctx_buffer *ctx_buf, int state)
+{
+		if (!ctx_buf ||
+		    state != MTK_CAM_CTX_BUFFER_DONE ||
+			state != MTK_CAM_CTX_BUFFER_FAILED)
+			return;
+
+		ctx_buf->state = state;
+}
+
+int mtk_cam_ctx_core_job_finish(struct mtk_cam_ctx *dev_ctx,
+				struct mtk_cam_ctx_finish_param *param)
+{
+	int i = 0;
+	struct platform_device *pdev = NULL;
+	struct mtk_cam_ctx_finish_param *fram_param =
+		(struct mtk_cam_ctx_finish_param *)param;
+	struct mtk_cam_dev *isp_dev = NULL;
+	struct mtk_cam_ctx_frame_bundle *frame = NULL;
+	enum vb2_buffer_state vbf_state = VB2_BUF_STATE_DONE;
+	enum mtk_cam_ctx_buffer_state ctxf_state =
+		MTK_CAM_CTX_BUFFER_DONE;
+	int user_sequence = fram_param->sequence;
+
+	struct mtk_cam_dev_frame_done_event_data fdone;
+	const int ctx_id =
+		MTK_CAM_GET_CTX_ID_FROM_SEQUENCE(fram_param->frame_id);
+
+	if (!dev_ctx)
+		dev_err(&isp_dev->pdev->dev,
+			"dev_ctx can't be null, can't release the frame\n");
+
+	pdev = dev_ctx->pdev;
+	isp_dev = mtk_cam_ctx_to_dev(dev_ctx);
+
+	dev_dbg(&isp_dev->pdev->dev,
+		"mtk_cam_ctx_core_job_finish_cb: param (%llx), pdev(%llx)\n",
+		(unsigned long long)param, (unsigned long long)pdev);
+
+	if (fram_param) {
+		dev_dbg(&isp_dev->pdev->dev,
+			"CB recvied from ctx(%d), frame(%d), state(%d), isp_dev(%llx)\n",
+			ctx_id, fram_param->frame_id,
+			fram_param->state, (long long)isp_dev);
+	} else {
+		dev_err(&isp_dev->pdev->dev,
+			"CB recvied from ctx(%d), frame param is NULL\n",
+			ctx_id);
+			return -EINVAL;
+	}
+
+	/* Get the buffers of the processed frame */
+	frame = mtk_cam_ctx_get_processing_frame(&isp_dev->ctx,
+						 fram_param->frame_id);
+
+	if (!frame) {
+		dev_err(&isp_dev->pdev->dev,
+			"Can't find the frame boundle, Frame(%d)\n",
+			fram_param->frame_id);
+			return -EINVAL;
+	}
+
+	if (fram_param->state == MTK_CAM_CTX_FRAME_DATA_ERROR) {
+		vbf_state = VB2_BUF_STATE_ERROR;
+		ctxf_state = MTK_CAM_CTX_BUFFER_FAILED;
+	}
+
+	/* Set the buffer's VB2 status so that the user can dequeue */
+	/* the buffer */
+	for (i = 0; i <= frame->last_index; i++) {
+		struct mtk_cam_ctx_buffer *ctx_buf = frame->buffers[i];
+
+		if (!ctx_buf) {
+			dev_dbg(&isp_dev->pdev->dev,
+				"ctx_buf(queue id= %d) of frame(%d)is NULL\n",
+				i, fram_param->frame_id);
+			continue;
+		} else {
+			struct vb2_v4l2_buffer *b =
+				mtk_cam_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
+			b->vb2_buf.timestamp = ktime_get_ns();
+			b->sequence = user_sequence;
+
+			mtk_cam_ctx_buffer_done(ctx_buf, ctxf_state);
+			mtk_cam_v4l2_buffer_done(&b->vb2_buf, vbf_state);
+		}
+	}
+
+	fdone.user_sequence = user_sequence;
+	fdone.frame_id = frame->id;
+
+	/* Notify the user frame process done */
+	mtk_cam_ctx_queue_event_frame_done(&isp_dev->ctx, &fdone);
+	mtk_cam_ctx_free_frame(&isp_dev->ctx, frame);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_job_finish);
+
+/* structure mtk_cam_ctx_finish_param must be the first elemt of param */
+/* So that the buffer can be return to vb2 queue successfully */
+int mtk_cam_ctx_core_finish_param_init(void *param, int frame_id, int state)
+{
+	struct mtk_cam_ctx_finish_param *fram_param =
+		(struct mtk_cam_ctx_finish_param *)param;
+	fram_param->frame_id = frame_id;
+	fram_param->state = state;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_core_finish_param_init);
+
+void mtk_cam_ctx_frame_bundle_add(struct mtk_cam_ctx *ctx,
+				  struct mtk_cam_ctx_frame_bundle *bundle,
+	struct mtk_cam_ctx_buffer *ctx_buf)
+{
+	int queue_id = 0;
+	struct mtk_cam_ctx_queue *ctx_queue = NULL;
+
+	if (!bundle || !ctx_buf) {
+		pr_warn("Add buffer to frame bundle failed, bundle(%llx),buf(%llx)\n",
+			(long long)bundle, (long long)ctx_buf);
+		return;
+	}
+
+	queue_id = ctx_buf->queue;
+
+	if (bundle->buffers[queue_id])
+		pr_warn("Queue(%d) buffer has alreay in this bundle, overwrite happen\n",
+			queue_id);
+
+	pr_debug("Add queue(%d) buffer%llx\n",
+		 queue_id, (unsigned long long)ctx_buf);
+		bundle->buffers[queue_id] = ctx_buf;
+
+	/* Fill context queue related information */
+	ctx_queue = &ctx->queue[queue_id];
+
+	if (!ctx_queue) {
+		pr_err("Can't find ctx queue (%d)\n", queue_id);
+		return;
+	}
+
+	if (ctx->queue[ctx_buf->queue].desc.image) {
+		if (ctx->queue[ctx_buf->queue].desc.capture)
+			bundle->num_img_capture_bufs++;
+		else
+			bundle->num_img_output_bufs++;
+	} else {
+		if (ctx->queue[ctx_buf->queue].desc.capture)
+			bundle->num_meta_capture_bufs++;
+		else
+			bundle->num_meta_output_bufs++;
+	}
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_frame_bundle_add);
+
+static void debug_bundle(struct mtk_cam_ctx *dev_ctx,
+			 struct mtk_cam_ctx_frame_bundle *bundle_data)
+{
+	int i = 0;
+
+	if (!dev_ctx)
+		return;
+
+	if (!bundle_data) {
+		dev_dbg(&dev_ctx->pdev->dev, "bundle_data is NULL\n");
+		return;
+	}
+
+	dev_dbg(&dev_ctx->pdev->dev, "bundle buf nums (%d, %d,%d,%d)\n",
+		bundle_data->num_img_capture_bufs,
+		bundle_data->num_img_output_bufs,
+		bundle_data->num_meta_capture_bufs,
+		bundle_data->num_meta_output_bufs);
+
+	for (i = 0; i < 16 ; i++) {
+		dev_dbg(&dev_ctx->pdev->dev, "Bundle, buf[%d] = %llx\n",
+			i,
+			(unsigned long long)bundle_data->buffers[i]);
+	}
+
+	dev_dbg(&dev_ctx->pdev->dev, "Bundle last idx: %d\n",
+		bundle_data->last_index);
+}
+
+int mtk_cam_ctx_trigger_job(struct mtk_cam_ctx *dev_ctx,
+			    struct mtk_cam_ctx_frame_bundle *bundle_data)
+{
+	/* Scan all buffers and filled the ipi frame data*/
+	int i = 0;
+	struct mtk_cam_ctx_start_param s_param;
+	struct mtk_cam_ctx_finish_param fram_param;
+
+	struct mtk_cam_ctx_frame_bundle *bundle	=
+		mtk_cam_ctx_get_free_frame(dev_ctx);
+
+	memset(&s_param, 0,
+	       sizeof(struct mtk_cam_ctx_start_param));
+
+	dev_dbg(&dev_ctx->pdev->dev,
+		"trigger job of ctx(%d)\n", dev_ctx->ctx_id);
+
+	debug_bundle(dev_ctx, bundle_data);
+
+	if (!bundle) {
+		dev_err(&dev_ctx->pdev->dev, "bundle can't be NULL\n");
+		goto FAILE_JOB_NOT_TRIGGER;
+	}
+	if (!bundle_data) {
+		dev_err(&dev_ctx->pdev->dev,
+			"bundle_data can't be NULL\n");
+		goto FAILE_JOB_NOT_TRIGGER;
+	}
+
+	memcpy(bundle->buffers, bundle_data->buffers,
+	       sizeof(struct mtk_cam_ctx_buffer *)
+			* MTK_CAM_CTX_FRAME_BUNDLE_BUFFER_MAX);
+
+	dev_dbg(&dev_ctx->pdev->dev, "bundle setup (%d,%d,%d,%d)\n",
+		bundle_data->num_img_capture_bufs,
+		bundle_data->num_img_output_bufs,
+		bundle_data->num_meta_capture_bufs,
+		bundle_data->num_meta_output_bufs);
+
+	bundle->num_img_capture_bufs =
+		bundle_data->num_img_capture_bufs;
+	bundle->num_img_output_bufs =
+		 bundle_data->num_img_output_bufs;
+	bundle->num_meta_capture_bufs =
+		bundle_data->num_meta_capture_bufs;
+	bundle->num_meta_output_bufs =
+		bundle_data->num_meta_output_bufs;
+	bundle->id =
+		mtk_cam_ctx_next_global_frame_sequence(dev_ctx,
+						       dev_ctx->ctx_id);
+	bundle->last_index = dev_ctx->queues_attr.total_num - 1;
+
+	debug_bundle(dev_ctx, bundle);
+
+	s_param.frame_bundle = bundle;
+
+	dev_dbg(&dev_ctx->pdev->dev, "Fill Address data\n");
+
+	for (i = 0; i <= bundle->last_index; i++) {
+		struct mtk_cam_ctx_buffer *ctx_buf = bundle->buffers[i];
+		struct vb2_v4l2_buffer *b = NULL;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Process queue[%d], ctx_buf:(%llx)\n",
+			i,
+			(unsigned long long)ctx_buf);
+
+		if (!ctx_buf) {
+			dev_warn(&dev_ctx->pdev->dev,
+				 "queue[%d], ctx_buf is NULL!!\n", i);
+			continue;
+		}
+
+		b = mtk_cam_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
+
+		ctx_buf->image = dev_ctx->queue[ctx_buf->queue].desc.image;
+		ctx_buf->capture = dev_ctx->queue[ctx_buf->queue].desc.capture;
+		/* copy the fmt setting for queue's fmt*/
+		ctx_buf->fmt = dev_ctx->queue[ctx_buf->queue].fmt;
+		ctx_buf->ctx_fmt = dev_ctx->queue[ctx_buf->queue].ctx_fmt;
+			ctx_buf->frame_id = bundle->id;
+		ctx_buf->daddr =
+			vb2_dma_contig_plane_dma_addr(&b->vb2_buf, 0);
+		dev_dbg(&dev_ctx->pdev->dev,
+			"%s:vb2_buf: type(%d),idx(%d),mem(%d)\n",
+			 __func__,
+			 b->vb2_buf.type,
+			 b->vb2_buf.index,
+			 b->vb2_buf.memory);
+		ctx_buf->vaddr = vb2_plane_vaddr(&b->vb2_buf, 0);
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Buf: queue(%d), vaddr(%llx), daddr(%llx)",
+			 ctx_buf->queue, (unsigned long long)ctx_buf->vaddr,
+			(unsigned long long)ctx_buf->daddr);
+
+		if (dev_ctx->queue[ctx_buf->queue].desc.smem_alloc) {
+			ctx_buf->paddr =
+				mtk_cam_smem_iova_to_phys
+				(&dev_ctx->smem_device->dev,
+				ctx_buf->daddr);
+		} else {
+			dev_dbg(&dev_ctx->pdev->dev,
+				"No pa provided: not physical continuous\n");
+			ctx_buf->paddr = 0;
+		}
+		ctx_buf->state = MTK_CAM_CTX_BUFFER_PROCESSING;
+	}
+
+	if (mtk_cam_ctx_process_frame(dev_ctx, bundle)) {
+		dev_err(&dev_ctx->pdev->dev,
+			"mtk_cam_ctx_process_frame failed: frame(%d)\n",
+			bundle->id);
+		goto FAILE_JOB_NOT_TRIGGER;
+	}
+
+	if (dev_ctx->ops->start) {
+		if (dev_ctx->ops->start(dev_ctx,
+					&s_param))
+			goto FAILE_JOB_NOT_TRIGGER;
+	} else {
+		dev_err(&dev_ctx->pdev->dev,
+			"Ctx(%d)'s start op can't be NULL\n",
+			dev_ctx->ctx_id);
+		goto FAILE_JOB_NOT_TRIGGER;
+	}
+	return 0;
+
+FAILE_JOB_NOT_TRIGGER:
+	dev_err(&dev_ctx->pdev->dev,
+		"FAILE_JOB_NOT_TRIGGER: init fram_param: %llx\n",
+		 (unsigned long long)&fram_param);
+	memset(&fram_param, 0, sizeof(struct mtk_cam_ctx_finish_param));
+	fram_param.frame_id = bundle->id;
+	fram_param.state = MTK_CAM_CTX_FRAME_DATA_ERROR;
+	dev_dbg(&dev_ctx->pdev->dev,
+		"Call mtk_cam_ctx_core_job_finish_cb: fram_param: %llx",
+		(unsigned long long)&fram_param);
+	if (dev_ctx->ops->finish)
+		dev_ctx->ops->finish(dev_ctx, (void *)&fram_param);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_trigger_job);
+
+void mtk_cam_ctx_buf_init(struct mtk_cam_ctx_buffer *b,
+			  unsigned int queue, dma_addr_t daddr)
+{
+	b->state = MTK_CAM_CTX_BUFFER_NEW;
+	b->queue = queue;
+	b->daddr = daddr;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_buf_init);
+
+enum mtk_cam_ctx_buffer_state
+	mtk_cam_ctx_get_buffer_state(struct mtk_cam_ctx_buffer *b)
+{
+	return b->state;
+}
+
+int mtk_cam_ctx_is_streaming(struct mtk_cam_ctx *ctx)
+{
+	return ctx->streaming;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_is_streaming);
+
+int mtk_cam_ctx_init_frame_bundles(struct mtk_cam_ctx *dev_ctx)
+{
+	int i = 0;
+
+	dev_ctx->num_frame_bundle = VB2_MAX_FRAME;
+
+	spin_lock(&dev_ctx->qlock);
+
+	/* Reset the queue*/
+	INIT_LIST_HEAD(&dev_ctx->processing_frames.list);
+	INIT_LIST_HEAD(&dev_ctx->free_frames.list);
+
+	for (i = 0; i < dev_ctx->num_frame_bundle; i++) {
+		struct mtk_cam_ctx_frame_bundle *frame_bundle =
+			&dev_ctx->frame_bundles[i];
+		frame_bundle->state = MTK_CAM_CTX_FRAME_NEW;
+		list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
+	}
+
+	spin_unlock(&dev_ctx->qlock);
+
+	return 0;
+}
+
+static int mtk_cam_ctx_process_frame(struct mtk_cam_ctx *dev_ctx,
+				     struct mtk_cam_ctx_frame_bundle
+				     *frame_bundle)
+{
+	spin_lock(&dev_ctx->qlock);
+
+	frame_bundle->state = MTK_CAM_CTX_FRAME_PROCESSING;
+	list_del(&frame_bundle->list);
+	list_add_tail(&frame_bundle->list, &dev_ctx->processing_frames.list);
+
+	spin_unlock(&dev_ctx->qlock);
+	return 0;
+}
+
+/* Since the ISP physical doesn't guanartee FIFO order when processing */
+/* the frame, for example, flushing buffers when streaming off, */
+/* we search the list to get the frame by frame id */
+struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_processing_frame
+(struct mtk_cam_ctx *dev_ctx, int frame_id)
+{
+	struct mtk_cam_ctx_frame_bundle *frame_bundle = NULL;
+
+	spin_lock(&dev_ctx->qlock);
+
+	list_for_each_entry(frame_bundle,
+			    &dev_ctx->processing_frames.list, list) {
+		if (frame_bundle->id == frame_id) {
+			spin_unlock(&dev_ctx->qlock);
+			return frame_bundle;
+		}
+	}
+
+	spin_unlock(&dev_ctx->qlock);
+
+	return NULL;
+}
+
+static int mtk_cam_ctx_free_frame(struct mtk_cam_ctx *dev_ctx,
+				  struct mtk_cam_ctx_frame_bundle *frame_bundle)
+{
+	spin_lock(&dev_ctx->qlock);
+
+	frame_bundle->state = MTK_CAM_CTX_FRAME_NEW;
+	list_del(&frame_bundle->list);
+	list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
+
+	spin_unlock(&dev_ctx->qlock);
+
+	return 0;
+}
+
+static struct mtk_cam_ctx_frame_bundle *mtk_cam_ctx_get_free_frame
+	(struct mtk_cam_ctx *dev_ctx)
+{
+	struct mtk_cam_ctx_frame_bundle *frame_bundle = NULL;
+
+	spin_lock(&dev_ctx->qlock);
+	list_for_each_entry(frame_bundle,
+			    &dev_ctx->free_frames.list, list){
+		pr_debug("Check frame: state %d, new should be %d\n",
+			 frame_bundle->state, MTK_CAM_CTX_FRAME_NEW);
+		if (frame_bundle->state == MTK_CAM_CTX_FRAME_NEW) {
+			frame_bundle->state = MTK_CAM_CTX_FRAME_PREPARED;
+			pr_debug("Found free frame\n");
+			spin_unlock(&dev_ctx->qlock);
+			return frame_bundle;
+		}
+	}
+	spin_unlock(&dev_ctx->qlock);
+	pr_err("Can't found any bundle is MTK_CAM_CTX_FRAME_NEW\n");
+	return NULL;
+}
+
+int mtk_cam_ctx_finish_frame(struct mtk_cam_ctx *dev_ctx,
+			     struct mtk_cam_ctx_frame_bundle *frame_bundle,
+			     int done)
+{
+	spin_lock(&dev_ctx->qlock);
+	frame_bundle->state = MTK_CAM_CTX_FRAME_PROCESSING;
+	list_add_tail(&frame_bundle->list, &dev_ctx->processing_frames.list);
+	spin_unlock(&dev_ctx->qlock);
+	return 0;
+}
+
+int mtk_cam_ctx_queue_event_dev_state(struct mtk_cam_ctx *dev_ctx,
+				      struct mtk_cam_dev_stat_event_data *stat)
+{
+	struct v4l2_event event;
+	struct mtk_cam_dev_stat_event_data *evt_stat_data =
+		(void *)event.u.data;
+
+	memset(&event, 0, sizeof(event));
+	evt_stat_data->frame_number = stat->frame_number;
+	evt_stat_data->irq_status_mask = stat->irq_status_mask;
+	evt_stat_data->dma_status_mask = stat->dma_status_mask;
+
+	event.type = V4L2_EVENT_MTK_CAM_ENGINE_STATE;
+	v4l2_event_queue_fh(&dev_ctx->fh->vfh, &event);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_queue_event_dev_state);
+
+static void mtk_cam_ctx_queue_event_frame_done
+	(struct mtk_cam_ctx *dev_ctx,
+	struct mtk_cam_dev_frame_done_event_data *fdone)
+{
+	struct v4l2_event event;
+	/* Carried the frame done information in */
+	/* data field of event */
+	struct mtk_cam_dev_frame_done_event_data *evt_frame_data =
+		(void *)event.u.data;
+
+	memset(&event, 0, sizeof(event));
+
+	evt_frame_data->frame_id = fdone->frame_id;
+	evt_frame_data->user_sequence = fdone->user_sequence;
+
+	event.type = V4L2_EVENT_MTK_CAM_FRAME_DONE;
+	v4l2_event_queue_fh(&dev_ctx->fh->vfh, &event);
+}
+
+static void set_img_fmt(struct v4l2_pix_format_mplane *mfmt_to_fill,
+			struct mtk_cam_ctx_format *ctx_fmt)
+{
+	int i = 0;
+
+	mfmt_to_fill->pixelformat = ctx_fmt->fmt.img.pixelformat;
+	mfmt_to_fill->num_planes = ctx_fmt->fmt.img.num_planes;
+
+	pr_debug("%s: Fmt(%d),w(%d),h(%d)\n",
+		 __func__,
+		 mfmt_to_fill->pixelformat,
+		 mfmt_to_fill->width,
+		 mfmt_to_fill->height);
+
+	/* The implementation wil be adjust after integrating MDP module */
+	/* since it provides the common format suppporting function */
+	for (i = 0 ; i < mfmt_to_fill->num_planes; ++i) {
+		int bpl = (mfmt_to_fill->width * ctx_fmt->fmt.img.row_depth[i])
+			/ 8;
+		int sizeimage = (mfmt_to_fill->width * mfmt_to_fill->height *
+			ctx_fmt->fmt.img.depth[i]) / 8;
+
+		mfmt_to_fill->plane_fmt[i].bytesperline = bpl;
+
+		mfmt_to_fill->plane_fmt[i].sizeimage = sizeimage;
+
+		pr_debug("plane(%d):bpl(%d),sizeimage(%u)\n",
+			 i,  bpl, mfmt_to_fill->plane_fmt[i].sizeimage);
+	}
+}
+
+static void set_meta_fmt(struct v4l2_meta_format *metafmt_to_fill,
+			 struct mtk_cam_ctx_format *ctx_fmt)
+{
+	metafmt_to_fill->dataformat = ctx_fmt->fmt.meta.dataformat;
+
+	if (ctx_fmt->fmt.meta.max_buffer_size <= 0 ||
+	    ctx_fmt->fmt.meta.max_buffer_size
+				> MTK_CAM_CTX_META_BUF_DEFAULT_SIZE){
+		pr_warn("buf size of meta(%u) can't be 0, use default %u\n",
+			ctx_fmt->fmt.meta.dataformat,
+			MTK_CAM_CTX_META_BUF_DEFAULT_SIZE);
+		metafmt_to_fill->buffersize = MTK_CAM_CTX_META_BUF_DEFAULT_SIZE;
+	} else {
+		pr_debug("Load the meta size setting %u\n",
+			 ctx_fmt->fmt.meta.max_buffer_size);
+		metafmt_to_fill->buffersize = ctx_fmt->fmt.meta.max_buffer_size;
+	}
+}
+
+/* Get the default format setting */
+int mtk_cam_ctx_format_load_default_fmt(struct mtk_cam_ctx_queue *queue,
+					struct v4l2_format *fmt_to_fill)
+{
+	struct mtk_cam_ctx_format *ctx_fmt = NULL;
+
+	if (queue->desc.num_fmts == 0)
+		return 0; /* no format support list associated to this queue */
+
+	if (queue->desc.default_fmt_idx >= queue->desc.num_fmts) {
+		pr_warn("Queue(%s) err: default idx(%d) must < num_fmts(%d)\n",
+			queue->desc.name, queue->desc.default_fmt_idx,
+			queue->desc.num_fmts);
+		queue->desc.default_fmt_idx = 0;
+		pr_warn("Queue(%s) : reset default idx(%d)\n",
+			queue->desc.name, queue->desc.default_fmt_idx);
+	}
+
+	ctx_fmt	= &queue->desc.fmts[queue->desc.default_fmt_idx];
+
+	/* Check the type of the buffer */
+	if (queue->desc.image) {
+		struct v4l2_pix_format_mplane *node_fmt =
+			&fmt_to_fill->fmt.pix_mp;
+
+		if (queue->desc.capture) {
+			fmt_to_fill->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+			node_fmt->width = MTK_CAM_OUTPUT_MAX_WIDTH;
+			node_fmt->height = MTK_CAM_OUTPUT_MAX_HEIGHT;
+		} else {
+			fmt_to_fill->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+			node_fmt->width = MTK_CAM_INPUT_MAX_WIDTH;
+			node_fmt->height = MTK_CAM_INPUT_MAX_HEIGHT;
+		}
+		set_img_fmt(node_fmt, ctx_fmt);
+	}	else {
+		/* meta buffer type */
+		struct v4l2_meta_format *node_fmt = &fmt_to_fill->fmt.meta;
+
+		if (queue->desc.capture)
+			fmt_to_fill->type = V4L2_BUF_TYPE_META_CAPTURE;
+		else
+			fmt_to_fill->type = V4L2_BUF_TYPE_META_OUTPUT;
+
+		set_meta_fmt(node_fmt, ctx_fmt);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_format_load_default_fmt);
+
+static struct mtk_cam_ctx_format *mtk_cam_ctx_find_fmt
+	(struct mtk_cam_ctx_queue *queue,
+	 u32 format)
+{
+	int i;
+	struct mtk_cam_ctx_format *ctx_fmt;
+
+	pr_debug("fmt to find(%x)\n", format);
+	for (i = 0; i < queue->desc.num_fmts; i++) {
+		ctx_fmt = &queue->desc.fmts[i];
+		if (queue->desc.image) {
+			pr_debug("idx(%d), pixelformat(%x), fmt(%x)\n",
+				 i, ctx_fmt->fmt.img.pixelformat, format);
+			if (ctx_fmt->fmt.img.pixelformat == format)
+				return ctx_fmt;
+		} else {
+			if (ctx_fmt->fmt.meta.dataformat == format)
+				return ctx_fmt;
+		}
+	}
+	return NULL;
+}
+
+int mtk_cam_ctx_fmt_set_meta(struct mtk_cam_ctx *dev_ctx,
+			     int queue_id,
+	struct v4l2_meta_format *user_fmt,
+	struct v4l2_meta_format *node_fmt
+	)
+{
+	struct mtk_cam_ctx_queue *queue = NULL;
+	struct mtk_cam_ctx_format *ctx_fmt;
+
+	if (queue_id >= dev_ctx->queues_attr.total_num) {
+		pr_err("Invalid queue id:%d\n", queue_id);
+		return -EINVAL;
+	}
+
+	queue = &dev_ctx->queue[queue_id];
+
+	if (!user_fmt || !node_fmt)
+		return -EINVAL;
+
+	ctx_fmt = mtk_cam_ctx_find_fmt(queue, user_fmt->dataformat);
+
+	if (!ctx_fmt)
+		return -EINVAL;
+
+	queue->ctx_fmt = ctx_fmt;
+	set_meta_fmt(node_fmt, ctx_fmt);
+	*user_fmt = *node_fmt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_fmt_set_meta);
+
+int mtk_cam_ctx_fmt_set_img(struct mtk_cam_ctx *dev_ctx,
+			    int queue_id,
+	struct v4l2_pix_format_mplane *user_fmt,
+	struct v4l2_pix_format_mplane *node_fmt)
+{
+	struct mtk_cam_ctx_queue *queue = NULL;
+	struct mtk_cam_ctx_format *ctx_fmt;
+
+	if (queue_id >= dev_ctx->queues_attr.total_num) {
+		pr_err("Invalid queue id:%d\n", queue_id);
+		return -EINVAL;
+	}
+
+	queue = &dev_ctx->queue[queue_id];
+
+	if (!user_fmt || !node_fmt)
+		return -EINVAL;
+
+	ctx_fmt = mtk_cam_ctx_find_fmt(queue, user_fmt->pixelformat);
+
+	if (!ctx_fmt)
+		return -EINVAL;
+
+	queue->ctx_fmt = ctx_fmt;
+	node_fmt->width = user_fmt->width;
+	node_fmt->height = user_fmt->height;
+
+	set_img_fmt(node_fmt, ctx_fmt);
+
+	*user_fmt = *node_fmt;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_fmt_set_img);
+
+int mtk_cam_ctx_streamon(struct mtk_cam_ctx *dev_ctx)
+{
+	int ret = 0;
+	struct mtk_cam_ctx_streamon_param params = {0};
+
+	if (dev_ctx->streaming) {
+		pr_warn("stream on failed, pdev(%llx), ctx(%d) already stream on\n",
+			(long long)dev_ctx->pdev, dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	pr_debug("streamon: pdev(%llx), ctx(%d)\n",
+		 (long long)dev_ctx->pdev, dev_ctx->ctx_id);
+
+	params.enabled_dma_ports = dev_ctx->enabled_dma_ports;
+
+	ret = dev_ctx->ops->streamon(dev_ctx,
+		&params);
+
+	if (ret) {
+		pr_err("streamon: ctx(%d) failed, notified by context\n",
+		       dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	dev_ctx->streaming = true;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_streamon);
+
+int mtk_cam_ctx_streamoff(struct mtk_cam_ctx *dev_ctx)
+{
+	int ret = 0;
+	struct mtk_cam_ctx_streamoff_param params = {0};
+
+	if (!dev_ctx->streaming) {
+		pr_warn("Do nothing, pdev(%llx), ctx(%d) is already stream off\n",
+			(long long)dev_ctx->pdev, dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	pr_debug("streamoff: pdev(%llx), ctx(%d)\n",
+		 (long long)dev_ctx->pdev, dev_ctx->ctx_id);
+
+	params.enabled_dma_ports = dev_ctx->enabled_dma_ports;
+
+	ret = dev_ctx->ops->streamoff(dev_ctx, &params);
+
+	if (ret) {
+		pr_warn("streamoff: ctx(%d) failed, notified by context\n",
+			dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	dev_ctx->streaming = false;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_streamoff);
+
+int mtk_cam_ctx_open(struct mtk_cam_ctx *dev_ctx)
+{
+	struct mtk_cam_dev *isp_dev = mtk_cam_ctx_to_dev(dev_ctx);
+	struct mtk_cam_ctx_open_param params = {0};
+	int i = 0;
+
+	if (!dev_ctx || !dev_ctx->ops || !dev_ctx->ops->finish ||
+	    !dev_ctx->ops->open)
+		return -EINVAL;
+
+	/* Get the enabled DMA ports */
+	for (i = 0; i < isp_dev->mem2mem2.num_nodes; i++) {
+		if (isp_dev->mem2mem2.nodes[i].enabled)
+			params.enabled_dma_ports |=
+				dev_ctx->queue[i].desc.dma_port;
+	}
+
+	dev_ctx->enabled_dma_ports = params.enabled_dma_ports;
+
+	dev_dbg(&isp_dev->pdev->dev, "open device: (%llx)\n",
+		(long long)&isp_dev->pdev->dev);
+
+	dev_ctx->ops->open(dev_ctx, &params);
+
+	/* Init the frame bundle pool */
+	mtk_cam_ctx_init_frame_bundles(dev_ctx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_open);
+
+int mtk_cam_ctx_release(struct mtk_cam_ctx *dev_ctx)
+{
+	struct device *dev = &dev_ctx->pdev->dev;
+
+	struct mtk_cam_ctx_release_param params = {0};
+
+	if (!dev_ctx || !dev_ctx->ops ||
+	    !dev_ctx->ops->release)
+		return -EINVAL;
+
+	dev_dbg(dev, "release: (%llx)\n",
+		(long long)dev);
+
+	params.enabled_dma_ports = dev_ctx->enabled_dma_ports;
+
+	dev_ctx->ops->release(dev_ctx, &params);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_release);
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.c
new file mode 100644
index 0000000..994c2d9
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.c
@@ -0,0 +1,381 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 Mediatek Corporation.
+ * Copyright (c) 2017 Intel Corporation.
+ * Copyright (C) 2017 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * MTK_CAM-dev is highly based on Intel IPU 3 chrome driver
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <media/videobuf2-dma-contig.h>
+#include "mtk_cam-dev.h"
+
+static struct platform_device *mtk_cam_dev_of_find_smem_dev
+	(struct platform_device *pdev);
+static int mtk_cam_dev_io_init(struct mtk_cam_dev *isp_dev);
+
+/* Initliaze a mtk_cam_dev representing a completed HW ISP */
+/* device */
+int mtk_cam_dev_init(struct mtk_cam_dev *isp_dev,
+		     struct platform_device *pdev,
+		     struct media_device *media_dev,
+		     struct v4l2_device *v4l2_dev)
+{
+	int r = 0;
+
+	isp_dev->pdev = pdev;
+	mutex_init(&isp_dev->lock);
+	r = mtk_cam_dev_io_init(isp_dev);
+
+	if (r) {
+		dev_err(&isp_dev->pdev->dev,
+			"failed to init cam-io: (%d)\n", r);
+		goto failed_camio;
+	}
+
+	/* v4l2 sub-device registration */
+	r = mtk_cam_dev_mem2mem2_init(isp_dev, media_dev, v4l2_dev);
+
+	if (r) {
+		dev_err(&isp_dev->pdev->dev,
+			"failed to create V4L2 devices (%d)\n", r);
+		goto failed_mem2mem2;
+	}
+
+	return 0;
+failed_camio:
+failed_mem2mem2:
+	mutex_destroy(&isp_dev->lock);
+	return r;
+}
+
+int mtk_cam_dev_io_init(struct mtk_cam_dev *isp_dev)
+{
+	struct mtk_cam_io_connection *cio = &isp_dev->cio;
+
+	cio->pdev = isp_dev->pdev;
+	dev_info(&cio->pdev->dev, "init cam-io\n");
+
+	return 0;
+}
+
+int mtk_cam_dev_get_total_node(struct mtk_cam_dev *mtk_cam_dev)
+{
+	return mtk_cam_dev->ctx.queues_attr.total_num;
+}
+
+int mtk_cam_dev_mem2mem2_init(struct mtk_cam_dev *isp_dev,
+			      struct media_device *media_dev,
+			      struct v4l2_device *v4l2_dev)
+{
+	int r, i;
+	const int queue_master = isp_dev->ctx.queues_attr.master;
+
+	pr_info("mem2mem2.name: %s\n", isp_dev->ctx.device_name);
+	pr_info("mtk_cam mem2mem2.name: %s\n", isp_dev->ctx.device_name);
+
+	isp_dev->mem2mem2.name = isp_dev->ctx.device_name;
+	isp_dev->mem2mem2.model = isp_dev->ctx.device_name;
+	isp_dev->mem2mem2.num_nodes =
+		mtk_cam_dev_get_total_node(isp_dev);
+	isp_dev->mem2mem2.vb2_mem_ops = &vb2_dma_contig_memops;
+	isp_dev->mem2mem2.buf_struct_size =
+		sizeof(struct mtk_cam_dev_buffer);
+
+	isp_dev->mem2mem2.nodes = isp_dev->mem2mem2_nodes;
+	isp_dev->mem2mem2.dev = &isp_dev->pdev->dev;
+
+	for (i = 0; i < isp_dev->ctx.dev_node_num; i++) {
+		isp_dev->mem2mem2.nodes[i].name =
+			mtk_cam_dev_get_node_name(isp_dev, i);
+		isp_dev->mem2mem2.nodes[i].output =
+				i < isp_dev->ctx.queues_attr.input_offset;
+		isp_dev->mem2mem2.nodes[i].immutable = false;
+		isp_dev->mem2mem2.nodes[i].enabled = false;
+		atomic_set(&isp_dev->mem2mem2.nodes[i].sequence, 0);
+	}
+
+	/* Master queue is always enabled */
+	isp_dev->mem2mem2.nodes[queue_master].immutable = true;
+	isp_dev->mem2mem2.nodes[queue_master].enabled = true;
+
+	pr_info("register v4l2 for %llx\n",
+		(unsigned long long)isp_dev);
+	r = mtk_cam_mem2mem2_v4l2_register(isp_dev, media_dev, v4l2_dev);
+
+	if (r) {
+		pr_err("v4l2 init failed, dev(ctx:%d)\n",
+		       isp_dev->ctx.ctx_id);
+		return r;
+	}
+
+	r = mtk_cam_v4l2_async_register(isp_dev);
+	if (r) {
+		dev_err(&isp_dev->pdev->dev, "v4l2 async init failed\n",
+			isp_dev->ctx.ctx_id);
+		return r;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_mem2mem2_init);
+
+void mtk_cam_dev_mem2mem2_exit(struct mtk_cam_dev *isp_dev)
+{
+	mtk_cam_v4l2_unregister(isp_dev);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_mem2mem2_exit);
+
+char *mtk_cam_dev_get_node_name
+	(struct mtk_cam_dev *isp_dev, int node)
+{
+	struct mtk_cam_ctx_queue_desc *mapped_queue_desc =
+		&isp_dev->ctx.queue[node].desc;
+
+	return mapped_queue_desc->name;
+}
+
+/* Get a free buffer from a video node */
+static struct mtk_cam_ctx_buffer __maybe_unused *mtk_cam_dev_queue_getbuf
+	(struct mtk_cam_dev *isp_dev, int node)
+{
+	struct mtk_cam_dev_buffer *buf;
+	int queue = -1;
+
+	if (node > isp_dev->ctx.dev_node_num || node < 0) {
+		dev_err(&isp_dev->pdev->dev, "Invalid mtk_cam_dev node.\n");
+		return NULL;
+	}
+
+	/* Get the corrosponding queue id of the video node */
+	/* Currently the queue id is the same as the node number */
+	queue = node;
+
+	if (queue < 0) {
+		dev_err(&isp_dev->pdev->dev, "Invalid mtk_cam_dev node.\n");
+		return NULL;
+	}
+
+	/* Find first free buffer from the node */
+	list_for_each_entry(buf, &isp_dev->mem2mem2.nodes[node].buffers,
+			    m2m2_buf.list) {
+		if (mtk_cam_ctx_get_buffer_state(&buf->ctx_buf)
+			== MTK_CAM_CTX_BUFFER_NEW)
+			return &buf->ctx_buf;
+	}
+
+	/* There were no free buffers*/
+	return NULL;
+}
+
+int mtk_cam_dev_get_queue_id_of_dev_node(struct mtk_cam_dev *isp_dev,
+					 struct mtk_cam_dev_video_device *node
+)
+{
+	return (node - isp_dev->mem2mem2.nodes);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_get_queue_id_of_dev_node);
+
+int mtk_cam_dev_queue_buffers(struct mtk_cam_dev *isp_dev,
+			      int initial)
+{
+	unsigned int node;
+	int r = 0;
+	struct mtk_cam_dev_buffer *ibuf;
+	struct mtk_cam_ctx_frame_bundle bundle;
+	const int mtk_cam_dev_node_num = mtk_cam_dev_get_total_node(isp_dev);
+	const int queue_master = isp_dev->ctx.queues_attr.master;
+
+	memset(&bundle, 0, sizeof(struct mtk_cam_ctx_frame_bundle));
+
+	pr_debug("%s, init(%d)\n", __func__, initial);
+
+	if (!mtk_cam_ctx_is_streaming(&isp_dev->ctx)) {
+		pr_debug("%s: stream is off, no hw enqueue triggered\n",
+			 __func__);
+		return 0;
+	}
+
+	mutex_lock(&isp_dev->lock);
+
+	/* Buffer set is queued to background driver (e.g. DIP, FD, and P1) */
+	/* only when master input buffer is ready */
+	if (!mtk_cam_dev_queue_getbuf(isp_dev, queue_master)) {
+		mutex_unlock(&isp_dev->lock);
+		return 0;
+	}
+
+	/* Check all node from the node after the master node */
+	for (node = (queue_master + 1) % mtk_cam_dev_node_num;
+		1; node = (node + 1) % mtk_cam_dev_node_num) {
+		pr_debug("Check node(%d), queue enabled(%d), node enabled(%d)\n",
+			 node, isp_dev->queue_enabled[node],
+			 isp_dev->mem2mem2.nodes[node].enabled);
+
+		/* May skip some node according the scenario in the future */
+		if (isp_dev->queue_enabled[node] ||
+		    isp_dev->mem2mem2.nodes[node].enabled) {
+			struct mtk_cam_ctx_buffer *buf =
+				mtk_cam_dev_queue_getbuf(isp_dev, node);
+			char *node_name =
+				mtk_cam_dev_get_node_name(isp_dev, node);
+
+			if (!buf) {
+				dev_dbg(&isp_dev->pdev->dev,
+					"No free buffer of enabled node %s\n",
+					node_name);
+				break;
+			}
+
+			/* To show the debug message */
+			ibuf = container_of(buf,
+					    struct mtk_cam_dev_buffer, ctx_buf);
+			dev_dbg(&isp_dev->pdev->dev,
+				"may queue user %s buffer idx(%d) to ctx\n",
+				node_name,
+				ibuf->m2m2_buf.vbb.vb2_buf.index);
+			mtk_cam_ctx_frame_bundle_add(&isp_dev->ctx,
+						     &bundle, buf);
+		}
+
+		/* Stop if there is no free buffer in master input node */
+		if (node == queue_master) {
+			if (mtk_cam_dev_queue_getbuf(isp_dev, queue_master)) {
+				/* Has collected all buffer required */
+				mtk_cam_ctx_trigger_job(&isp_dev->ctx, &bundle);
+			} else {
+				pr_debug("no new buffer found in master node, not trigger job\n");
+				break;
+			}
+		}
+	}
+	mutex_unlock(&isp_dev->lock);
+
+	if (r && r != -EBUSY)
+		goto failed;
+
+	return 0;
+
+failed:
+	/*
+	 * On error, mark all buffers as failed which are not
+	 * yet queued to CSS
+	 */
+	dev_err(&isp_dev->pdev->dev,
+		"failed to queue buffer to ctx on queue %i (%d)\n",
+		node, r);
+
+	if (initial)
+		/* If we were called from streamon(), no need to finish bufs */
+		return r;
+
+	for (node = 0; node < mtk_cam_dev_node_num; node++) {
+		struct mtk_cam_dev_buffer *buf, *buf0;
+
+		if (!isp_dev->queue_enabled[node])
+			continue;	/* Skip disabled queues */
+
+		mutex_lock(&isp_dev->lock);
+		list_for_each_entry_safe(buf, buf0,
+					 &isp_dev->mem2mem2.nodes[node].buffers,
+					 m2m2_buf.list) {
+			if (mtk_cam_ctx_get_buffer_state(&buf->ctx_buf) ==
+			    MTK_CAM_CTX_BUFFER_PROCESSING)
+				continue;	/* Was already queued, skip */
+
+			mtk_cam_v4l2_buffer_done(&buf->m2m2_buf.vbb.vb2_buf,
+						 VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&isp_dev->lock);
+	}
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_queue_buffers);
+
+int mtk_cam_dev_core_init(struct platform_device *pdev,
+			  struct mtk_cam_dev *isp_dev,
+			  struct mtk_cam_ctx_desc *ctx_desc)
+{
+	return mtk_cam_dev_core_init_ext(pdev,
+		isp_dev, ctx_desc, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_core_init);
+
+int mtk_cam_dev_core_init_ext(struct platform_device *pdev,
+			      struct mtk_cam_dev *isp_dev,
+			      struct mtk_cam_ctx_desc *ctx_desc,
+			      struct media_device *media_dev,
+			      struct v4l2_device *v4l2_dev)
+{
+	int r;
+	struct platform_device *smem_dev = NULL;
+
+	smem_dev = mtk_cam_dev_of_find_smem_dev(pdev);
+
+	if (!smem_dev)
+		dev_err(&pdev->dev, "failed to find smem_dev\n");
+
+	/* Device context must be initialized before device instance */
+	r = mtk_cam_ctx_core_init(&isp_dev->ctx, pdev,
+				  0, ctx_desc, pdev, smem_dev);
+
+	dev_dbg(&pdev->dev, "init isp_dev: %llx\n",
+		(unsigned long long)isp_dev);
+	/* init other device level members */
+	mtk_cam_dev_init(isp_dev, pdev, media_dev, v4l2_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_core_init_ext);
+
+int mtk_cam_dev_core_release(struct platform_device *pdev,
+			     struct mtk_cam_dev *isp_dev)
+{
+	mtk_cam_v4l2_async_unregister(isp_dev);
+	mtk_cam_dev_mem2mem2_exit(isp_dev);
+	mtk_cam_ctx_core_exit(&isp_dev->ctx);
+	mutex_destroy(&isp_dev->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_dev_core_release);
+
+static struct platform_device *mtk_cam_dev_of_find_smem_dev
+	(struct platform_device *pdev)
+{
+	struct device_node *smem_dev_node = NULL;
+
+	if (!pdev) {
+		pr_err("Find_smem_dev failed, pdev can't be NULL\n");
+		return NULL;
+	}
+
+	smem_dev_node = of_parse_phandle(pdev->dev.of_node,
+					 "smem_device", 0);
+
+	if (!smem_dev_node) {
+		dev_err(&pdev->dev,
+			"failed to find isp smem device for (%s)\n",
+			pdev->name);
+		return NULL;
+	}
+
+	dev_dbg(&pdev->dev, "smem of node found, try to discovery device\n");
+	return of_find_device_by_node(smem_dev_node);
+}
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.h
new file mode 100644
index 0000000..bebfe8b
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 Mediatek Corporation.
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * MTK_CAM-dev is highly based on Intel IPU 3 chrome driver
+ *
+ */
+
+#ifndef __MTK_CAM_DEV_H__
+#define __MTK_CAM_DEV_H__
+
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include "mtk_cam-ctx.h"
+
+#define MTK_CAM_DEV_NODE_MAX			(MTK_CAM_CTX_QUEUES)
+
+#define MTK_CAM_INPUT_MIN_WIDTH		0U
+#define MTK_CAM_INPUT_MIN_HEIGHT		0U
+#define MTK_CAM_INPUT_MAX_WIDTH		480U
+#define MTK_CAM_INPUT_MAX_HEIGHT		640U
+#define MTK_CAM_OUTPUT_MIN_WIDTH		2U
+#define MTK_CAM_OUTPUT_MIN_HEIGHT		2U
+#define MTK_CAM_OUTPUT_MAX_WIDTH		480U
+#define MTK_CAM_OUTPUT_MAX_HEIGHT		640U
+
+#define file_to_mtk_cam_node(__file) \
+	container_of(video_devdata(__file),\
+	struct mtk_cam_dev_video_device, vdev)
+
+#define mtk_cam_ctx_to_dev(__ctx) \
+	container_of(__ctx,\
+	struct mtk_cam_dev, ctx)
+
+#define mtk_cam_m2m_to_dev(__m2m) \
+	container_of(__m2m,\
+	struct mtk_cam_dev, mem2mem2)
+
+#define mtk_cam_subdev_to_dev(__sd) \
+	container_of(__sd, \
+	struct mtk_cam_dev, mem2mem2.subdev)
+
+#define mtk_cam_vbq_to_isp_node(__vq) \
+	container_of(__vq, \
+	struct mtk_cam_dev_video_device, vbq)
+
+#define mtk_cam_ctx_buf_to_dev_buf(__ctx_buf) \
+	container_of(__ctx_buf, \
+	struct mtk_cam_dev_buffer, ctx_buf)
+
+#define mtk_cam_vb2_buf_to_dev_buf(__vb) \
+	container_of(vb, \
+	struct mtk_cam_dev_buffer, \
+	m2m2_buf.vbb.vb2_buf)
+
+#define mtk_cam_vb2_buf_to_m2m_buf(__vb) \
+	container_of(__vb, \
+	struct mtk_cam_mem2mem2_buffer, \
+	vbb.vb2_buf)
+
+#define mtk_cam_subdev_to_m2m(__sd) \
+	container_of(__sd, \
+	struct mtk_cam_mem2mem2_device, subdev)
+
+struct mtk_cam_mem2mem2_device;
+
+struct mtk_cam_mem2mem2_buffer {
+	struct vb2_v4l2_buffer vbb;
+	struct list_head list;
+};
+
+struct mtk_cam_dev_buffer {
+	struct mtk_cam_mem2mem2_buffer m2m2_buf;
+	/* Intenal part */
+	struct mtk_cam_ctx_buffer ctx_buf;
+};
+
+#define MTK_CAM_IO_CON_PADS (1)
+
+/* mtk_cam_io_connection --> sensor IF --> sensor 1 */
+/*                                     --> sensor 2 */
+struct mtk_cam_io_connection {
+	const char *name;
+	struct platform_device *pdev;
+	struct v4l2_subdev subdev;
+	int enable;
+	/* sensor connected */
+	struct v4l2_subdev *sensor;
+	/* sensor interface connected */
+	struct v4l2_subdev *sensor_if;
+	struct media_pad subdev_pads[MTK_CAM_IO_CON_PADS];
+	/* Current sensor input format*/
+	struct v4l2_mbus_framefmt subdev_fmt;
+};
+
+struct mtk_cam_dev_video_device {
+	const char *name;
+	int output;
+	int immutable;
+	int enabled;
+	int queued;
+	struct v4l2_format vdev_fmt;
+	struct video_device vdev;
+	struct media_pad vdev_pad;
+	struct v4l2_mbus_framefmt pad_fmt;
+	struct vb2_queue vbq;
+	struct list_head buffers;
+	struct mutex lock; /* vb2 queue and video device data protection */
+	atomic_t sequence;
+};
+
+struct mtk_cam_mem2mem2_device {
+	const char *name;
+	const char *model;
+	struct device *dev;
+	int num_nodes;
+	struct mtk_cam_dev_video_device *nodes;
+	const struct vb2_mem_ops *vb2_mem_ops;
+	unsigned int buf_struct_size;
+	int streaming;
+	struct v4l2_device *v4l2_dev;
+	struct media_device *media_dev;
+	struct media_pipeline pipeline;
+	struct v4l2_subdev subdev;
+	struct media_pad *subdev_pads;
+	struct v4l2_file_operations v4l2_file_ops;
+	const struct file_operations fops;
+};
+
+struct mtk_cam_dev {
+	struct platform_device *pdev;
+	struct mtk_cam_dev_video_device mem2mem2_nodes[MTK_CAM_DEV_NODE_MAX];
+	int queue_enabled[MTK_CAM_DEV_NODE_MAX];
+	struct mtk_cam_mem2mem2_device mem2mem2;
+	struct mtk_cam_io_connection cio;
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct mtk_cam_ctx ctx;
+	struct v4l2_async_notifier notifier;
+	struct mutex lock; /* device level data protection */
+};
+
+int mtk_cam_media_register(struct device *dev,
+			   struct media_device *media_dev,
+	const char *model);
+int mtk_cam_v4l2_register(struct device *dev,
+			  struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev,
+	struct v4l2_ctrl_handler *ctrl_handler);
+int mtk_cam_v4l2_unregister(struct mtk_cam_dev *dev);
+int mtk_cam_mem2mem2_v4l2_register(struct mtk_cam_dev *dev,
+				   struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev);
+
+int mtk_cam_v4l2_async_register(struct mtk_cam_dev *isp_dev);
+
+void mtk_cam_v4l2_async_unregister(struct mtk_cam_dev *isp_dev);
+
+int mtk_cam_v4l2_discover_sensor(struct mtk_cam_dev *isp_dev);
+
+void mtk_cam_v4l2_buffer_done(struct vb2_buffer *vb,
+			      enum vb2_buffer_state state);
+extern int mtk_cam_dev_queue_buffers
+	(struct mtk_cam_dev *dev, int initial);
+extern int mtk_cam_dev_get_total_node
+	(struct mtk_cam_dev *mtk_cam_dev);
+extern char *mtk_cam_dev_get_node_name
+	(struct mtk_cam_dev *mtk_cam_dev_obj, int node);
+int mtk_cam_dev_init(struct mtk_cam_dev *isp_dev,
+		     struct platform_device *pdev,
+		     struct media_device *media_dev,
+		     struct v4l2_device *v4l2_dev);
+extern void mtk_cam_dev_mem2mem2_exit
+	(struct mtk_cam_dev *mtk_cam_dev_obj);
+int mtk_cam_dev_mem2mem2_init(struct mtk_cam_dev *isp_dev,
+			      struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev);
+int mtk_cam_dev_get_queue_id_of_dev_node
+	(struct mtk_cam_dev *mtk_cam_dev_obj,
+	 struct mtk_cam_dev_video_device *node);
+int mtk_cam_dev_core_init(struct platform_device *pdev,
+			  struct mtk_cam_dev *isp_dev,
+	struct mtk_cam_ctx_desc *ctx_desc);
+int mtk_cam_dev_core_init_ext(struct platform_device *pdev,
+			      struct mtk_cam_dev *isp_dev,
+	struct mtk_cam_ctx_desc *ctx_desc,
+	struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev);
+extern int mtk_cam_dev_core_release
+(struct platform_device *pdev, struct mtk_cam_dev *isp_dev);
+
+#endif /* __MTK_CAM_DEV_H__ */
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
new file mode 100644
index 0000000..b5067d6
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
@@ -0,0 +1,146 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Ryan Yu <ryan.yu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CAM_REGS_H
+#define _CAM_REGS_H
+
+/* TG Bit Mask */
+#define VFDATA_EN_BIT BIT(0)
+#define CMOS_EN_BIT BIT(0)
+
+/* normal signal bit */
+#define VS_INT_ST	BIT(0)
+#define HW_PASS1_DON_ST	BIT(11)
+#define SOF_INT_ST	BIT(12)
+#define SW_PASS1_DON_ST	BIT(30)
+
+/* err status bit */
+#define TG_ERR_ST	BIT(4)
+#define TG_GBERR_ST	BIT(5)
+#define CQ_CODE_ERR_ST	BIT(6)
+#define CQ_APB_ERR_ST	BIT(7)
+#define CQ_VS_ERR_ST	BIT(8)
+#define AMX_ERR_ST	BIT(15)
+#define RMX_ERR_ST	BIT(16)
+#define BMX_ERR_ST	BIT(17)
+#define RRZO_ERR_ST	BIT(18)
+#define AFO_ERR_ST	BIT(19)
+#define IMGO_ERR_ST	BIT(20)
+#define AAO_ERR_ST	BIT(21)
+#define PSO_ERR_ST	BIT(22)
+#define LCSO_ERR_ST	BIT(23)
+#define BNR_ERR_ST	BIT(24)
+#define LSCI_ERR_ST	BIT(25)
+#define DMA_ERR_ST	BIT(29)
+
+/* CAM DMA done status */
+#define FLKO_DONE_ST	BIT(4)
+#define AFO_DONE_ST	BIT(5)
+#define AAO_DONE_ST	BIT(7)
+#define PSO_DONE_ST	BIT(14)
+
+/* IRQ signal mask */
+#define INT_ST_MASK_CAM	( \
+			VS_INT_ST |\
+			HW_PASS1_DON_ST |\
+			SOF_INT_ST |\
+			SW_PASS1_DON_ST)
+
+/* IRQ Warning Mask */
+#define INT_ST_MASK_CAM_WARN	(\
+				RRZO_ERR_ST |\
+				AFO_ERR_ST |\
+				IMGO_ERR_ST |\
+				AAO_ERR_ST |\
+				PSO_ERR_ST | \
+				LCSO_ERR_ST |\
+				BNR_ERR_ST |\
+				LSCI_ERR_ST)
+
+/* IRQ Error Mask */
+#define INT_ST_MASK_CAM_ERR	(\
+				TG_ERR_ST |\
+				TG_GBERR_ST |\
+				CQ_CODE_ERR_ST |\
+				CQ_APB_ERR_ST |\
+				CQ_VS_ERR_ST |\
+				BNR_ERR_ST |\
+				RMX_ERR_ST |\
+				BMX_ERR_ST |\
+				BNR_ERR_ST |\
+				LSCI_ERR_ST |\
+				DMA_ERR_ST)
+
+/* IRQ Signal Log Mask */
+#define INT_ST_LOG_MASK_CAM	(\
+				SOF_INT_ST |\
+				SW_PASS1_DON_ST |\
+				VS_INT_ST |\
+				TG_ERR_ST |\
+				TG_GBERR_ST |\
+				RRZO_ERR_ST |\
+				AFO_ERR_ST |\
+				IMGO_ERR_ST |\
+				AAO_ERR_ST |\
+				DMA_ERR_ST)
+
+/* DMA Event Notification Mask */
+#define DMA_ST_MASK_CAM	(\
+			AFO_DONE_ST |\
+			AAO_DONE_ST |\
+			PSO_DONE_ST |\
+			FLKO_DONE_ST)
+
+/* Status check */
+#define REG_CTL_EN			0x0004
+#define REG_CTL_DMA_EN			0x0008
+#define REG_CTL_FMT_SEL		0x0010
+#define REG_CTL_EN2			0x0018
+#define REG_CTL_RAW_INT_EN		0x0020
+#define REG_CTL_RAW_INT_STAT		0x0024
+#define REG_CTL_RAW_INT2_STAT		0x0034
+#define REG_CTL_RAW_INT3_STAT		0x00C4
+#define REG_CTL_TWIN_STAT		0x0050
+
+#define REG_TG_SEN_MODE		0x0230
+#define REG_TG_SEN_GRAB_PIX		0x0238
+#define REG_TG_SEN_GRAB_LIN		0x023C
+#define REG_TG_VF_CON			0x0234
+#define REG_TG_INTER_ST		0x026C
+#define REG_TG_SUB_PERIOD		0x02A4
+
+#define REG_IMGO_BASE_ADDR		0x1020
+#define REG_RRZO_BASE_ADDR		0x1050
+
+/* Error status log */
+#define REG_IMGO_ERR_STAT		0x1360
+#define REG_RRZO_ERR_STAT		0x1364
+#define REG_AAO_ERR_STAT		0x1368
+#define REG_AFO_ERR_STAT		0x136C
+#define REG_LCSO_ERR_STAT		0x1370
+#define REG_UFEO_ERR_STAT		0x1374
+#define REG_PDO_ERR_STAT		0x1378
+#define REG_BPCI_ERR_STAT		0x137C
+#define REG_LSCI_ERR_STAT		0x1384
+#define REG_PDI_ERR_STAT		0x138C
+#define REG_LMVO_ERR_STAT		0x1390
+#define REG_FLKO_ERR_STAT		0x1394
+#define REG_PSO_ERR_STAT		0x13A0
+
+/* ISP command */
+#define REG_CQ_THR0_BASEADDR		0x0198
+#define REG_CTL_SPARE2			0x0058
+#define REG_HW_FRAME_NUM		0x13B8
+#endif	/* _CAM_REGS_H */
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
new file mode 100644
index 0000000..020c38c
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
@@ -0,0 +1,452 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/dma-contiguous.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/iommu.h>
+#include <asm/cacheflush.h>
+
+#define MTK_CAM_SMEM_DEV_NAME "MTK-CAM-SMEM"
+
+struct mtk_cam_smem_drv {
+	struct platform_device *pdev;
+	struct sg_table sgt;
+	struct page **smem_pages;
+	int num_smem_pages;
+	phys_addr_t smem_base;
+	dma_addr_t smem_dma_base;
+	int smem_size;
+};
+
+static struct reserved_mem *isp_reserved_smem;
+
+static int mtk_cam_smem_setup_dma_ops(struct device *smem_dev,
+				      const struct dma_map_ops *smem_ops);
+
+static int mtk_cam_smem_get_sgtable(struct device *dev,
+				    struct sg_table *sgt,
+	void *cpu_addr, dma_addr_t dma_addr,
+	size_t size, unsigned long attrs);
+
+static const struct dma_map_ops smem_dma_ops = {
+	.get_sgtable = mtk_cam_smem_get_sgtable,
+};
+
+static int mtk_cam_smem_init(struct mtk_cam_smem_drv **mtk_cam_smem_drv_out,
+			     struct platform_device *pdev)
+{
+	struct mtk_cam_smem_drv *isp_sys = NULL;
+	struct device *dev = &pdev->dev;
+
+	isp_sys = devm_kzalloc(dev,
+			       sizeof(*isp_sys), GFP_KERNEL);
+
+	isp_sys->pdev = pdev;
+
+	*mtk_cam_smem_drv_out = isp_sys;
+
+	return 0;
+}
+
+static int mtk_cam_smem_drv_probe(struct platform_device *pdev)
+{
+	struct mtk_cam_smem_drv *smem_drv = NULL;
+	int r = 0;
+	struct device *dev = &pdev->dev;
+
+	dev_dbg(dev, "probe mtk_cam_smem_drv\n");
+
+	r = mtk_cam_smem_init(&smem_drv, pdev);
+
+	if (!smem_drv)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, smem_drv);
+
+	if (isp_reserved_smem) {
+		dma_addr_t dma_addr;
+		phys_addr_t addr;
+		struct iommu_domain *smem_dom;
+		int i = 0;
+		int size_align = 0;
+		struct page **pages = NULL;
+		int n_pages = 0;
+		struct sg_table *sgt = &smem_drv->sgt;
+
+		size_align = round_down(isp_reserved_smem->size,
+					PAGE_SIZE);
+		n_pages = size_align >> PAGE_SHIFT;
+
+		pages = kmalloc_array(n_pages, sizeof(struct page *),
+				      GFP_KERNEL);
+
+		if (!pages)
+			return -ENOMEM;
+
+		for (i = 0; i < n_pages; i++)
+			pages[i] = phys_to_page(isp_reserved_smem->base
+						+ i * PAGE_SIZE);
+
+		r = sg_alloc_table_from_pages(sgt, pages, n_pages, 0,
+					      size_align, GFP_KERNEL);
+
+		if (r) {
+			dev_err(dev, "failed to get alloca sg table\n");
+			return -ENOMEM;
+		}
+
+		dma_map_sg_attrs(dev, sgt->sgl, sgt->nents,
+				 DMA_BIDIRECTIONAL,
+				 DMA_ATTR_SKIP_CPU_SYNC);
+
+		dma_addr = sg_dma_address(sgt->sgl);
+		smem_dom = iommu_get_domain_for_dev(dev);
+		addr = iommu_iova_to_phys(smem_dom, dma_addr);
+
+		if (addr != isp_reserved_smem->base)
+			dev_err(dev,
+				"incorrect pa(%llx) from iommu_iova_to_phys, should be %llx\n",
+			(unsigned long long)addr,
+			(unsigned long long)isp_reserved_smem->base);
+
+		r = dma_declare_coherent_memory(dev,
+						isp_reserved_smem->base,
+			dma_addr, size_align, DMA_MEMORY_EXCLUSIVE);
+
+		dev_dbg(dev,
+			"Coherent mem base(%llx,%llx),size(%lx),ret(%d)\n",
+			isp_reserved_smem->base,
+			dma_addr, size_align, r);
+
+		smem_drv->smem_base = isp_reserved_smem->base;
+		smem_drv->smem_size = size_align;
+		smem_drv->smem_pages = pages;
+		smem_drv->num_smem_pages = n_pages;
+		smem_drv->smem_dma_base = dma_addr;
+
+		dev_dbg(dev, "smem_drv setting (%llx,%lx,%llx,%d)\n",
+			smem_drv->smem_base, smem_drv->smem_size,
+			(unsigned long long)smem_drv->smem_pages,
+			smem_drv->num_smem_pages);
+	}
+
+	r = mtk_cam_smem_setup_dma_ops(dev, &smem_dma_ops);
+
+	return r;
+}
+
+phys_addr_t mtk_cam_smem_iova_to_phys(struct device *dev,
+				      dma_addr_t iova)
+{
+		struct iommu_domain *smem_dom;
+		phys_addr_t addr;
+		phys_addr_t limit;
+		struct mtk_cam_smem_drv *smem_dev =
+			dev_get_drvdata(dev);
+
+		if (!smem_dev)
+			return 0;
+
+		smem_dom = iommu_get_domain_for_dev(dev);
+
+		if (!smem_dom)
+			return 0;
+
+		addr = iommu_iova_to_phys(smem_dom, iova);
+
+		limit = smem_dev->smem_base + smem_dev->smem_size;
+
+		if (addr < smem_dev->smem_base || addr >= limit) {
+			dev_err(dev,
+				"Unexpected paddr %pa (must >= %pa and <%pa)\n",
+				&addr, &smem_dev->smem_base, &limit);
+			return 0;
+		}
+		dev_dbg(dev, "Pa verifcation pass: %pa(>=%pa, <%pa)\n",
+			&addr, &smem_dev->smem_base, &limit);
+		return addr;
+}
+
+static int mtk_cam_smem_drv_remove(struct platform_device *pdev)
+{
+	struct mtk_cam_smem_drv *smem_drv =
+		dev_get_drvdata(&pdev->dev);
+
+	kfree(smem_drv->smem_pages);
+	return 0;
+}
+
+static int mtk_cam_smem_drv_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int mtk_cam_smem_drv_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int mtk_cam_smem_drv_dummy_cb(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops mtk_cam_smem_drv_pm_ops = {
+	SET_RUNTIME_PM_OPS(&mtk_cam_smem_drv_dummy_cb,
+			   &mtk_cam_smem_drv_dummy_cb, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS
+		(&mtk_cam_smem_drv_suspend, &mtk_cam_smem_drv_resume)
+};
+
+static const struct of_device_id mtk_cam_smem_drv_of_match[] = {
+	{
+		.compatible = "mediatek,cam_smem",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mtk_cam_smem_drv_of_match);
+
+static struct platform_driver mtk_cam_smem_driver = {
+	.probe = mtk_cam_smem_drv_probe,
+	.remove = mtk_cam_smem_drv_remove,
+	.driver = {
+		.name = MTK_CAM_SMEM_DEV_NAME,
+		.of_match_table =
+			of_match_ptr(mtk_cam_smem_drv_of_match),
+		.pm = &mtk_cam_smem_drv_pm_ops,
+	},
+};
+
+static int __init mtk_cam_smem_dma_setup(struct reserved_mem
+					 *rmem)
+{
+	unsigned long node = rmem->fdt_node;
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
+		pr_err("Reserved memory: regions without no-map are not yet supported\n");
+		return -EINVAL;
+	}
+
+	isp_reserved_smem = rmem;
+
+	pr_debug("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		 &rmem->base, (unsigned long)rmem->size / SZ_1M);
+	return 0;
+}
+
+RESERVEDMEM_OF_DECLARE(mtk_cam_smem,
+		       "mediatek,reserve-memory-cam_smem",
+		       mtk_cam_smem_dma_setup);
+
+int __init mtk_cam_smem_drv_init(void)
+{
+	int ret = 0;
+
+	pr_debug("platform_driver_register: mtk_cam_smem_driver\n");
+	ret = platform_driver_register(&mtk_cam_smem_driver);
+
+	if (ret)
+		pr_warn("isp smem drv init failed, driver didn't probe\n");
+
+	return ret;
+}
+subsys_initcall(mtk_cam_smem_drv_init);
+
+void __exit mtk_cam_smem_drv_ext(void)
+{
+	platform_driver_unregister(&mtk_cam_smem_driver);
+}
+module_exit(mtk_cam_smem_drv_ext);
+
+/********************************************
+ * MTK CAM SMEM DMA ops *
+ ********************************************/
+
+struct dma_coherent_mem {
+	void		*virt_base;
+	dma_addr_t	device_base;
+	unsigned long	pfn_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+	spinlock_t	spinlock; /* dma_coherent_mem attributes protection */
+	bool		use_dev_dma_pfn_offset;
+};
+
+static struct dma_coherent_mem *dev_get_coherent_memory(struct device *dev)
+{
+	if (dev && dev->dma_mem)
+		return dev->dma_mem;
+	return NULL;
+}
+
+static int mtk_cam_smem_get_sgtable(struct device *dev,
+				    struct sg_table *sgt,
+	void *cpu_addr, dma_addr_t dma_addr,
+	size_t size, unsigned long attrs)
+{
+	struct mtk_cam_smem_drv *smem_dev = dev_get_drvdata(dev);
+	int n_pages_align = 0;
+	int size_align = 0;
+	int page_start = 0;
+	unsigned long long offset_p = 0;
+	unsigned long long offset_d = 0;
+
+	phys_addr_t paddr = mtk_cam_smem_iova_to_phys(dev, dma_addr);
+
+	offset_d = (unsigned long long)dma_addr -
+		(unsigned long long)smem_dev->smem_dma_base;
+
+	offset_p = (unsigned long long)paddr -
+		(unsigned long long)smem_dev->smem_base;
+
+	dev_dbg(dev, "%s:dma_addr:%llx,cpu_addr:%llx,pa:%llx,size:%d\n",
+		__func__,
+		(unsigned long long)dma_addr,
+		(unsigned long long)cpu_addr,
+		(unsigned long long)paddr,
+		size
+		);
+
+	dev_dbg(dev, "%s:offset p:%llx,offset d:%llx\n",
+		__func__,
+		(unsigned long long)offset_p,
+		(unsigned long long)offset_d
+		);
+
+	size_align = round_up(size, PAGE_SIZE);
+	n_pages_align = size_align >> PAGE_SHIFT;
+	page_start = offset_p >> PAGE_SHIFT;
+
+	dev_dbg(dev,
+		"%s:page idx:%d,page pa:%llx,pa:%llx, aligned size:%d\n",
+		__func__,
+		page_start,
+		(unsigned long long)page_to_phys(*(smem_dev->smem_pages
+			+ page_start)),
+		(unsigned long long)paddr,
+		size_align
+		);
+
+	if (!smem_dev) {
+		dev_err(dev, "can't get sgtable from smem_dev\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "get sgt of the smem: %d pages\n", n_pages_align);
+
+	return sg_alloc_table_from_pages(sgt,
+		smem_dev->smem_pages + page_start,
+		n_pages_align,
+		0, size_align, GFP_KERNEL);
+}
+
+static void *mtk_cam_smem_get_cpu_addr(struct mtk_cam_smem_drv *smem_dev,
+				       struct scatterlist *sg)
+{
+	struct device *dev = &smem_dev->pdev->dev;
+	struct dma_coherent_mem *dma_mem =
+		dev_get_coherent_memory(dev);
+
+	phys_addr_t addr = (phys_addr_t)sg_phys(sg);
+
+	if (addr < smem_dev->smem_base ||
+	    addr > smem_dev->smem_base + smem_dev->smem_size) {
+		dev_err(dev, "Invalid paddr 0x%llx from sg\n", addr);
+		return NULL;
+	}
+
+	return dma_mem->virt_base + (addr - smem_dev->smem_base);
+}
+
+static void mtk_cam_smem_sync_sg_for_cpu(struct device *dev,
+					 struct scatterlist *sgl, int nelems,
+					 enum dma_data_direction dir)
+{
+	struct mtk_cam_smem_drv *smem_dev =
+		dev_get_drvdata(dev);
+	void *cpu_addr;
+
+	cpu_addr = mtk_cam_smem_get_cpu_addr(smem_dev, sgl);
+
+	dev_dbg(dev,
+		"__dma_unmap_area:paddr(0x%llx),vaddr(0x%llx),size(%d)\n",
+		(unsigned long long)sg_phys(sgl),
+		(unsigned long long)cpu_addr,
+		sgl->length);
+
+	__dma_unmap_area(cpu_addr, sgl->length, dir);
+}
+
+static void mtk_cam_smem_sync_sg_for_device(struct device *dev,
+					    struct scatterlist *sgl, int nelems,
+					    enum dma_data_direction dir)
+{
+	struct mtk_cam_smem_drv *smem_dev =
+			dev_get_drvdata(dev);
+	void *cpu_addr;
+
+	cpu_addr = mtk_cam_smem_get_cpu_addr(smem_dev, sgl);
+
+	dev_dbg(dev,
+		"__dma_map_area:paddr(0x%llx),vaddr(0x%llx),size(%d)\n",
+		(unsigned long long)sg_phys(sgl),
+		(unsigned long long)cpu_addr,
+		sgl->length);
+
+	__dma_map_area(cpu_addr, sgl->length, dir);
+}
+
+static int mtk_cam_smem_setup_dma_ops(struct device *dev,
+				      const struct dma_map_ops *smem_ops)
+{
+	if (!dev->dma_ops)
+		return -EINVAL;
+
+	memcpy((void *)smem_ops, dev->dma_ops, sizeof(*smem_ops));
+
+	((struct dma_map_ops *)smem_ops)->get_sgtable =
+		mtk_cam_smem_get_sgtable;
+	((struct dma_map_ops *)smem_ops)->sync_sg_for_device =
+		mtk_cam_smem_sync_sg_for_device;
+	((struct dma_map_ops *)smem_ops)->sync_sg_for_cpu =
+		mtk_cam_smem_sync_sg_for_cpu;
+
+	dev->dma_ops = smem_ops;
+
+	return 0;
+}
+
+void mtk_cam_smem_enable_mpu(struct device *dev)
+{
+	dev_warn(dev, "MPU enabling func is not ready now\n");
+}
+
+MODULE_AUTHOR("Frederic Chen <frederic.chen@mediatek.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek CAM shared memory driver");
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
new file mode 100644
index 0000000..4e1cf20
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_CAM_SMEM_H__
+#define __MTK_CAM_SMEM_H__
+
+#include <linux/dma-mapping.h>
+
+phys_addr_t mtk_cam_smem_iova_to_phys(struct device *smem_dev,
+				      dma_addr_t iova);
+
+void mtk_cam_smem_enable_mpu(struct device *smem_dev);
+
+#endif /*__MTK_CAM_SMEM_H__*/
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
new file mode 100644
index 0000000..7da312d
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
@@ -0,0 +1,1555 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 Mediatek Corporation.
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * MTK_CAM-v4l2 is highly based on Intel IPU 3 chrome driver
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <media/v4l2-common.h>
+#include <media/media-entity.h>
+#include <media/v4l2-async.h>
+
+#include "mtk_cam.h"
+#include "mtk_cam-dev.h"
+#include "mtk_cam-v4l2.h"
+#include "mtk_cam-v4l2-util.h"
+
+#define CONFIG_MEDIATEK_MEDIA_REQUEST
+
+#define MTK_CAM_SENSOR_MAIN_PAD_SRC 0
+#define MTK_CAM_SENSOR_SUB_PAD_SRC 0
+#define MTK_CAM_SENSOR_IF_PAD_MAIN_SINK 0
+#define MTK_CAM_SENSOR_IF_PAD_SUB_SINK 1
+#define MTK_CAM_SENSOR_IF_PAD_SRC 4
+#define MTK_CAM_CIO_PAD_SINK 0
+
+static u32 mtk_cam_node_get_v4l2_cap
+	(struct mtk_cam_ctx_queue *node_ctx);
+
+static int mtk_cam_videoc_s_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f);
+
+static int mtk_cam_subdev_open(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh)
+{
+	struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
+
+	isp_dev->ctx.fh = fh;
+	return mtk_cam_ctx_open(&isp_dev->ctx);
+}
+
+static int mtk_cam_subdev_close(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
+
+	return mtk_cam_ctx_release(&isp_dev->ctx);
+}
+
+static int mtk_cam_subdev_s_stream(struct v4l2_subdev *sd,
+				   int enable)
+{
+	int ret = 0;
+	struct mtk_cam_dev *isp_dev = mtk_cam_subdev_to_dev(sd);
+	struct mtk_cam_io_connection *cio = &isp_dev->cio;
+
+	if (enable) {
+		/* Get sensor interace and sensor sub device */
+		/* If the call succeeds, sensor if and sensor are filled */
+		/* in isp_dev->cio->sensor_if and isp_dev->cio->sensor */
+		ret = mtk_cam_v4l2_discover_sensor(isp_dev);
+		if (ret) {
+			dev_err(&isp_dev->pdev->dev,
+				"no sensor or sensor if connected (%d)\n",
+				ret);
+			return -EPERM;
+		}
+
+		/* seninf must stream on first */
+		ret = v4l2_subdev_call(cio->sensor_if, video, s_stream, 1);
+		if (ret) {
+			dev_err(&isp_dev->pdev->dev,
+				"sensor-if(%s) stream on failed (%d)\n",
+				cio->sensor_if->entity.name, ret);
+			return -EPERM;
+		}
+
+		dev_dbg(&isp_dev->pdev->dev, "streamed on sensor-if(%s)\n",
+			cio->sensor_if->entity.name);
+
+		ret = v4l2_subdev_call(cio->sensor, video, s_stream, 1);
+		if (ret) {
+			dev_err(&isp_dev->pdev->dev,
+				"sensor(%s) stream on failed (%d)\n",
+				cio->sensor->entity.name, ret);
+			return -EPERM;
+		}
+
+		dev_dbg(&isp_dev->pdev->dev, "streamed on sensor(%s)\n",
+			cio->sensor->entity.name);
+
+		ret = mtk_cam_ctx_streamon(&isp_dev->ctx);
+		if (ret) {
+			dev_err(&isp_dev->pdev->dev,
+				"Pass 1 stream on failed (%d)\n", ret);
+			return -EPERM;
+		}
+
+		isp_dev->mem2mem2.streaming = enable;
+
+		ret = mtk_cam_dev_queue_buffers(isp_dev, true);
+		if (ret)
+			dev_err(&isp_dev->pdev->dev,
+				"failed to queue initial buffers (%d)", ret);
+
+		dev_dbg(&isp_dev->pdev->dev, "streamed on Pass 1\n");
+	} else {
+		if (cio->sensor) {
+			ret = v4l2_subdev_call(cio->sensor, video, s_stream, 0);
+			if (ret) {
+				dev_err(&isp_dev->pdev->dev,
+					"sensor(%s) stream off failed (%d)\n",
+					cio->sensor->entity.name, ret);
+			} else {
+				dev_dbg(&isp_dev->pdev->dev,
+					"streamed off sensor(%s)\n",
+					cio->sensor->entity.name);
+				cio->sensor = NULL;
+			}
+		} else {
+			dev_err(&isp_dev->pdev->dev,
+				"Can't find sensor connected\n");
+		}
+
+		if (cio->sensor_if) {
+			ret = v4l2_subdev_call(cio->sensor_if, video,
+					       s_stream, 0);
+			if (ret) {
+				dev_err(&isp_dev->pdev->dev,
+					"sensor if(%s) stream off failed (%d)\n",
+					cio->sensor_if->entity.name, ret);
+			} else {
+				dev_dbg(&isp_dev->pdev->dev,
+					"streamed off sensor-if(%s)\n",
+					cio->sensor_if->entity.name);
+				cio->sensor_if = NULL;
+			}
+		} else {
+			dev_err(&isp_dev->pdev->dev,
+				"Can't find sensor-if connected\n");
+		}
+
+		ret = mtk_cam_ctx_streamoff(&isp_dev->ctx);
+		if (ret) {
+			dev_err(&isp_dev->pdev->dev,
+				"Pass 1 stream off failed (%d)\n", ret);
+			return -EPERM;
+		}
+
+		isp_dev->mem2mem2.streaming = false;
+
+		dev_dbg(&isp_dev->pdev->dev, "streamed off Pass 1\n");
+	}
+
+	return 0;
+}
+
+static void v4l2_event_merge(const struct v4l2_event *old,
+			     struct v4l2_event *new)
+{
+	struct mtk_cam_dev_stat_event_data *old_evt_stat_data =
+		(void *)old->u.data;
+	struct mtk_cam_dev_stat_event_data *new_evt_stat_data =
+		(void *)new->u.data;
+
+	if (old->type == V4L2_EVENT_MTK_CAM_ENGINE_STATE &&
+	    new->type == V4L2_EVENT_MTK_CAM_ENGINE_STATE) {
+		pr_debug("%s, merge IRQ, old(type(0x%x) frame no(%d) IRQ(0x%x) DMA(0x%x)), new(type(0x%x) frame_number(%d) IRQ(0x%x) DMA(0x%x))",
+			 __func__,
+			old->type,
+			old_evt_stat_data->frame_number,
+			old_evt_stat_data->irq_status_mask,
+			old_evt_stat_data->dma_status_mask,
+			new->type,
+			new_evt_stat_data->frame_number,
+			new_evt_stat_data->irq_status_mask,
+			new_evt_stat_data->dma_status_mask);
+
+		/* merge IRQ event */
+		new_evt_stat_data->irq_status_mask |=
+			old_evt_stat_data->irq_status_mask;
+		new_evt_stat_data->dma_status_mask |=
+			old_evt_stat_data->dma_status_mask;
+	}
+}
+
+static void v4l2_event_replace(struct v4l2_event *old,
+			       const struct v4l2_event *new)
+{
+	struct mtk_cam_dev_stat_event_data *old_evt_stat_data =
+		(void *)old->u.data;
+	struct mtk_cam_dev_stat_event_data *new_evt_stat_data =
+		(void *)new->u.data;
+
+	pr_debug("%s, old(frame no(%d) IRQ(0x%x) DMA(0x%x)), new(frame_number(%d) IRQ(0x%x) DMA(0x%x))",
+		 __func__,
+		old_evt_stat_data->frame_number,
+		old_evt_stat_data->irq_status_mask,
+		old_evt_stat_data->dma_status_mask,
+		new_evt_stat_data->frame_number,
+		new_evt_stat_data->irq_status_mask,
+		new_evt_stat_data->dma_status_mask);
+
+	old_evt_stat_data->frame_number = new_evt_stat_data->frame_number;
+	old_evt_stat_data->irq_status_mask = new_evt_stat_data->irq_status_mask;
+	old_evt_stat_data->dma_status_mask = new_evt_stat_data->dma_status_mask;
+}
+
+static const struct v4l2_subscribed_event_ops v4l2_event_ops = {
+	.merge = v4l2_event_merge,
+	.replace = v4l2_event_replace,
+};
+
+int mtk_cam_subdev_subscribe_event(struct v4l2_subdev *subdev,
+				   struct v4l2_fh *fh,
+					struct v4l2_event_subscription *sub)
+{
+	pr_debug("sub type(%x)", sub->type);
+	if (sub->type != V4L2_EVENT_PRIVATE_START &&
+	    sub->type != V4L2_EVENT_MTK_CAM_ENGINE_STATE &&
+			sub->type != V4L2_EVENT_MTK_CAM_FRAME_DONE)
+		return -EINVAL;
+	/* currently we use the default depth of event queue */
+	if (sub->type == V4L2_EVENT_MTK_CAM_ENGINE_STATE)
+		return v4l2_event_subscribe(fh, sub, 2, &v4l2_event_ops);
+
+	return v4l2_event_subscribe(fh, sub, 0, NULL);
+}
+
+int mtk_cam_subdev_unsubscribe_event(struct v4l2_subdev *subdev,
+				     struct v4l2_fh *fh,
+	struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+static int mtk_cam_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+	const struct media_pad *remote, u32 flags)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 =
+		container_of(entity,
+			     struct mtk_cam_mem2mem2_device,
+			     subdev.entity);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+
+	u32 pad = local->index;
+
+	pr_debug("link setup: %d --> %d\n", pad, remote->index);
+
+	WARN_ON(entity->obj_type != MEDIA_ENTITY_TYPE_V4L2_SUBDEV);
+
+	WARN_ON(pad >= m2m2->num_nodes);
+
+	m2m2->nodes[pad].enabled = !!(flags & MEDIA_LNK_FL_ENABLED);
+
+	/* queue_enable can be phase out in the future since */
+	/* we don't have internal queue of each node in */
+	/* v4l2 common module */
+	isp_dev->queue_enabled[pad] = m2m2->nodes[pad].enabled;
+
+	return 0;
+}
+
+static void mtk_cam_vb2_buf_queue(struct vb2_buffer *vb)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
+
+	struct mtk_cam_dev *mtk_cam_dev = mtk_cam_m2m_to_dev(m2m2);
+
+	struct device *dev = &mtk_cam_dev->pdev->dev;
+
+	struct mtk_cam_dev_buffer *buf = NULL;
+
+	struct vb2_v4l2_buffer *v4l2_buf = NULL;
+
+	struct mtk_cam_dev_video_device *node =
+		mtk_cam_vbq_to_isp_node(vb->vb2_queue);
+
+	int queue = mtk_cam_dev_get_queue_id_of_dev_node(mtk_cam_dev, node);
+
+	dev_dbg(dev,
+		"queue vb2_buf: Node(%s) queue id(%d)\n",
+		node->name,
+		queue);
+
+	if (queue < 0) {
+		dev_err(m2m2->dev, "Invalid mtk_cam_dev node.\n");
+		return;
+	}
+
+	if (!vb)
+		pr_err("VB can't be null\n");
+
+	buf = mtk_cam_vb2_buf_to_dev_buf(vb);
+
+	if (!buf)
+		pr_err("buf can't be null\n");
+
+	v4l2_buf = to_vb2_v4l2_buffer(vb);
+
+	if (!v4l2_buf)
+		pr_err("v4l2_buf can't be null\n");
+
+	mutex_lock(&mtk_cam_dev->lock);
+
+	pr_debug("init  mtk_cam_ctx_buf, sequence(%d)\n", v4l2_buf->sequence);
+
+	/* the dma address will be filled in later frame buffer handling*/
+	mtk_cam_ctx_buf_init(&buf->ctx_buf, queue, (dma_addr_t)0);
+	pr_debug("set mtk_cam_ctx_buf_init: user seq=%d\n",
+		 buf->ctx_buf.user_sequence);
+
+	/* Added the buffer into the tracking list */
+	list_add_tail(&buf->m2m2_buf.list,
+		      &m2m2->nodes[node - m2m2->nodes].buffers);
+	mutex_unlock(&mtk_cam_dev->lock);
+
+	/* Enqueue the buffer */
+	if (mtk_cam_dev->mem2mem2.streaming) {
+		pr_debug("%s: mtk_cam_dev_queue_buffers\n",
+			 node->name);
+		mtk_cam_dev_queue_buffers(mtk_cam_dev, false);
+	}
+}
+
+static int mtk_cam_vb2_queue_setup(struct vb2_queue *vq,
+				   unsigned int *num_buffers,
+				unsigned int *num_planes,
+				unsigned int sizes[],
+				struct device *alloc_devs[])
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_cam_dev_video_device *node =
+		mtk_cam_vbq_to_isp_node(vq);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct device *dev = &isp_dev->pdev->dev;
+	void *buf_alloc_ctx = NULL;
+	int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+
+	/* Get V4L2 format with the following method */
+	const struct v4l2_format *fmt = &node->vdev_fmt;
+
+	*num_planes = 1;
+	*num_buffers = clamp_val(*num_buffers, 1, VB2_MAX_FRAME);
+
+	if (isp_dev->ctx.queue[queue_id].desc.smem_alloc) {
+		buf_alloc_ctx = isp_dev->ctx.smem_vb2_alloc_ctx;
+		dev_dbg(dev, "Select smem_vb2_alloc_ctx(%llx)\n",
+			(unsigned long long)buf_alloc_ctx);
+	} else {
+		buf_alloc_ctx = isp_dev->ctx.default_vb2_alloc_ctx;
+		dev_dbg(dev, "Select default_vb2_alloc_ctx(%llx)\n",
+			(unsigned long long)buf_alloc_ctx);
+	}
+
+	vq->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
+	dev_dbg(dev, "queue(%d): cached mmap enabled\n", queue_id);
+
+	if (vq->type == V4L2_BUF_TYPE_META_CAPTURE ||
+	    vq->type == V4L2_BUF_TYPE_META_OUTPUT)
+		sizes[0] = fmt->fmt.meta.buffersize;
+	else
+		sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
+
+	alloc_devs[0] = (struct device *)buf_alloc_ctx;
+
+	dev_dbg(dev, "queue(%d):type(%d),size(%d),alloc_ctx(%llx)\n",
+		queue_id, vq->type, sizes[0],
+		(unsigned long long)buf_alloc_ctx);
+
+	/* Initialize buffer queue */
+	INIT_LIST_HEAD(&node->buffers);
+
+	return 0;
+}
+
+static bool
+	mtk_cam_all_nodes_streaming(struct mtk_cam_mem2mem2_device *m2m2,
+				    struct mtk_cam_dev_video_device *except)
+{
+	int i;
+
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		struct mtk_cam_dev_video_device *node = &m2m2->nodes[i];
+
+		if (node == except)
+			continue;
+		if (node->enabled && !vb2_start_streaming_called(&node->vbq))
+			return false;
+	}
+
+	return true;
+}
+
+static void mtk_cam_return_all_buffers(struct mtk_cam_mem2mem2_device *m2m2,
+				       struct mtk_cam_dev_video_device *node,
+					enum vb2_buffer_state state)
+{
+	struct mtk_cam_dev *mtk_cam_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct mtk_cam_mem2mem2_buffer *b, *b0;
+
+	/* Return all buffers */
+	mutex_lock(&mtk_cam_dev->lock);
+	list_for_each_entry_safe(b, b0, &node->buffers, list) {
+		list_del(&b->list);
+		vb2_buffer_done(&b->vbb.vb2_buf, state);
+	}
+	mutex_unlock(&mtk_cam_dev->lock);
+}
+
+static int mtk_cam_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_cam_dev_video_device *node =
+		mtk_cam_vbq_to_isp_node(vq);
+	int r;
+
+	if (m2m2->streaming) {
+		r = -EBUSY;
+		goto fail_return_bufs;
+	}
+
+	if (!node->enabled) {
+		pr_err("Node (%ld) is not enable\n", node - m2m2->nodes);
+		r = -EINVAL;
+		goto fail_return_bufs;
+	}
+
+	r = media_pipeline_start(&node->vdev.entity, &m2m2->pipeline);
+	if (r < 0) {
+		pr_err("Node (%ld) media_pipeline_start failed\n",
+		       node - m2m2->nodes);
+		goto fail_return_bufs;
+	}
+
+	if (!mtk_cam_all_nodes_streaming(m2m2, node))
+		return 0;
+
+	/* Start streaming of the whole pipeline now */
+
+	r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 1);
+	if (r < 0) {
+		pr_err("Node (%ld) v4l2_subdev_call s_stream failed\n",
+		       node - m2m2->nodes);
+		goto fail_stop_pipeline;
+	}
+	return 0;
+
+fail_stop_pipeline:
+	media_pipeline_stop(&node->vdev.entity);
+fail_return_bufs:
+	mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_QUEUED);
+
+	return r;
+}
+
+static void mtk_cam_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_cam_dev_video_device *node =
+		mtk_cam_vbq_to_isp_node(vq);
+	int r;
+
+	WARN_ON(!node->enabled);
+
+	/* Was this the first node with streaming disabled? */
+	if (mtk_cam_all_nodes_streaming(m2m2, node)) {
+		/* Yes, really stop streaming now */
+		r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 0);
+		if (r)
+			dev_err(m2m2->dev, "failed to stop streaming\n");
+	}
+
+	mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_ERROR);
+	media_pipeline_stop(&node->vdev.entity);
+}
+
+static int mtk_cam_videoc_querycap(struct file *file, void *fh,
+				   struct v4l2_capability *cap)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	int queue_id =
+		mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+	struct mtk_cam_ctx_queue *node_ctx = &isp_dev->ctx.queue[queue_id];
+
+	strlcpy(cap->driver, m2m2->name, sizeof(cap->driver));
+	strlcpy(cap->card, m2m2->model, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 node->name);
+
+	cap->device_caps =
+		mtk_cam_node_get_v4l2_cap(node_ctx) | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+/* Propagate forward always the format from the mtk_cam_dev subdev */
+static int mtk_cam_videoc_g_fmt(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+
+	f->fmt = node->vdev_fmt.fmt;
+
+	return 0;
+}
+
+static int mtk_cam_videoc_try_fmt(struct file *file,
+				  void *fh,
+	 struct v4l2_format *f)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+	int queue_id =
+		mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+	int ret = 0;
+
+	ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
+				      &f->fmt.pix_mp,
+		&node->vdev_fmt.fmt.pix_mp);
+
+	/* Simply set the format to the node context in the initial version */
+	if (ret) {
+		pr_warn("Fmt(%d) not support for queue(%d), will load default fmt\n",
+			f->fmt.pix_mp.pixelformat, queue_id);
+
+		ret =	mtk_cam_ctx_format_load_default_fmt
+			(&dev_ctx->queue[queue_id], f);
+	}
+
+	if (!ret) {
+		node->vdev_fmt.fmt.pix_mp = f->fmt.pix_mp;
+		dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
+	}
+
+	return ret;
+}
+
+static int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+	int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+	int ret = 0;
+
+	ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
+				      &f->fmt.pix_mp,
+		&node->vdev_fmt.fmt.pix_mp);
+
+	/* Simply set the format to the node context in the initial version */
+	if (!ret)
+		dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
+	else
+		dev_warn(&isp_dev->pdev->dev,
+			 "s_fmt, format not support\n");
+
+	return ret;
+}
+
+static int mtk_cam_enum_framesizes(struct file *filp, void *priv,
+				   struct v4l2_frmsizeenum *sizes)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(filp);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct mtk_cam_dev_video_device *node =
+		file_to_mtk_cam_node(filp);
+	int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+
+	if (sizes->index != 0)
+		return -EINVAL;
+
+	if (queue_id == MTK_CAM_CTX_P1_MAIN_STREAM_OUT) {
+		sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+		sizes->stepwise.max_width = CAM_B_MAX_WIDTH;
+		sizes->stepwise.min_width = CAM_MIN_WIDTH;
+		sizes->stepwise.max_height = CAM_B_MAX_HEIGHT;
+		sizes->stepwise.min_height = CAM_MIN_HEIGHT;
+		sizes->stepwise.step_height = 1;
+		sizes->stepwise.step_width = 1;
+	} else if (queue_id == MTK_CAM_CTX_P1_PACKED_BIN_OUT) {
+		sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+		sizes->stepwise.max_width = RRZ_MAX_WIDTH;
+		sizes->stepwise.min_width = RRZ_MIN_WIDTH;
+		sizes->stepwise.max_height = RRZ_MAX_HEIGHT;
+		sizes->stepwise.min_height = RRZ_MIN_HEIGHT;
+		sizes->stepwise.step_height = 1;
+		sizes->stepwise.step_width = 1;
+	}
+
+	return 0;
+}
+
+static int mtk_cam_meta_enum_format(struct file *file,
+				    void *fh, struct v4l2_fmtdesc *f)
+{
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+
+	if (f->index > 0 || f->type != node->vbq.type)
+		return -EINVAL;
+
+	f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
+
+	return 0;
+}
+
+static int mtk_cam_videoc_s_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
+	struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+	int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
+
+	int ret = 0;
+
+	if (f->type != node->vbq.type)
+		return -EINVAL;
+
+	ret = mtk_cam_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
+
+	if (!ret) {
+		node->vdev_fmt.fmt.meta = f->fmt.meta;
+		dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
+	} else {
+		dev_warn(&isp_dev->pdev->dev,
+			 "s_meta_fm failed, format not support\n");
+	}
+
+	return ret;
+}
+
+static int mtk_cam_videoc_g_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f)
+{
+	struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
+
+	if (f->type != node->vbq.type)
+		return -EINVAL;
+
+	f->fmt = node->vdev_fmt.fmt;
+
+	return 0;
+}
+
+int mtk_cam_videoc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct vb2_buffer *vb;
+	struct mtk_cam_dev_buffer *db;
+	int r = 0;
+
+	/* check if vb2 queue is busy */
+	if (vdev->queue->owner &&
+	    vdev->queue->owner != file->private_data)
+		return -EBUSY;
+
+	/* Keep the value of sequence in v4l2_buffer */
+	/* in ctx buf since vb2_qbuf will set it to 0 */
+	vb = vdev->queue->bufs[p->index];
+
+	if (vb) {
+		db = mtk_cam_vb2_buf_to_dev_buf(vb);
+		pr_debug("qbuf: p:%llx,vb:%llx, db:%llx\n",
+			 (unsigned long long)p,
+			(unsigned long long)vb,
+			(unsigned long long)db);
+		db->ctx_buf.user_sequence = p->sequence;
+	}
+
+	r = vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
+
+	if (r)
+		pr_err("vb2_qbuf failed(err=%d): buf idx(%d)\n",
+		       r, p->index);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_videoc_qbuf);
+
+/******************** function pointers ********************/
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops mtk_cam_subdev_internal_ops = {
+	.open = mtk_cam_subdev_open,
+	.close = mtk_cam_subdev_close,
+};
+
+static const struct v4l2_subdev_core_ops mtk_cam_subdev_core_ops = {
+	.subscribe_event = mtk_cam_subdev_subscribe_event,
+	.unsubscribe_event = mtk_cam_subdev_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops mtk_cam_subdev_video_ops = {
+	.s_stream = mtk_cam_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_ops mtk_cam_subdev_ops = {
+	.core = &mtk_cam_subdev_core_ops,
+	.video = &mtk_cam_subdev_video_ops,
+};
+
+static const struct media_entity_operations mtk_cam_media_ops = {
+	.link_setup = mtk_cam_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
+static void mtk_cam_vb2_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req,
+				   m2m2->v4l2_dev->ctrl_handler);
+}
+#endif
+
+static const struct vb2_ops mtk_cam_vb2_ops = {
+	.buf_queue = mtk_cam_vb2_buf_queue,
+	.queue_setup = mtk_cam_vb2_queue_setup,
+	.start_streaming = mtk_cam_vb2_start_streaming,
+	.stop_streaming = mtk_cam_vb2_stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
+	.buf_request_complete = mtk_cam_vb2_buf_request_complete,
+#endif
+};
+
+static const struct v4l2_file_operations mtk_cam_v4l2_fops = {
+	.unlocked_ioctl = video_ioctl2,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = v4l2_compat_ioctl32,
+#endif
+};
+
+static const struct v4l2_ioctl_ops mtk_cam_v4l2_ioctl_ops = {
+	.vidioc_querycap = mtk_cam_videoc_querycap,
+	.vidioc_enum_framesizes = mtk_cam_enum_framesizes,
+
+	.vidioc_g_fmt_vid_cap_mplane = mtk_cam_videoc_g_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = mtk_cam_videoc_s_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = mtk_cam_videoc_try_fmt,
+
+	.vidioc_g_fmt_vid_out_mplane = mtk_cam_videoc_g_fmt,
+	.vidioc_s_fmt_vid_out_mplane = mtk_cam_videoc_s_fmt,
+	.vidioc_try_fmt_vid_out_mplane = mtk_cam_videoc_try_fmt,
+
+	/* buffer queue management */
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = mtk_cam_videoc_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+};
+
+static const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_ioctl_ops = {
+	.vidioc_querycap = mtk_cam_videoc_querycap,
+
+	.vidioc_enum_fmt_meta_cap = mtk_cam_meta_enum_format,
+	.vidioc_g_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
+	.vidioc_s_fmt_meta_cap = mtk_cam_videoc_s_meta_fmt,
+	.vidioc_try_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
+
+	.vidioc_enum_fmt_meta_out = mtk_cam_meta_enum_format,
+	.vidioc_g_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
+	.vidioc_s_fmt_meta_out = mtk_cam_videoc_s_meta_fmt,
+	.vidioc_try_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
+
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = mtk_cam_videoc_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+};
+
+static u32 mtk_cam_node_get_v4l2_cap(struct mtk_cam_ctx_queue *node_ctx)
+{
+	u32 cap = 0;
+
+	if (node_ctx->desc.capture)
+		if (node_ctx->desc.image)
+			cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+		else
+			cap = V4L2_CAP_META_CAPTURE;
+	else
+		if (node_ctx->desc.image)
+			cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+		else
+			cap = V4L2_CAP_META_OUTPUT;
+
+	return cap;
+}
+
+static u32 mtk_cam_node_get_format_type(struct mtk_cam_ctx_queue *node_ctx)
+{
+	u32 type;
+
+	if (node_ctx->desc.capture)
+		if (node_ctx->desc.image)
+			type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		else
+			type = V4L2_BUF_TYPE_META_CAPTURE;
+	else
+		if (node_ctx->desc.image)
+			type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+		else
+			type = V4L2_BUF_TYPE_META_OUTPUT;
+
+	return type;
+}
+
+static const struct v4l2_ioctl_ops *mtk_cam_node_get_ioctl_ops
+	(struct mtk_cam_ctx_queue *node_ctx)
+{
+	const struct v4l2_ioctl_ops *ops = NULL;
+
+	if (node_ctx->desc.image)
+		ops = &mtk_cam_v4l2_ioctl_ops;
+	else
+		ops = &mtk_cam_v4l2_meta_ioctl_ops;
+	return ops;
+}
+
+/* Config node's video properties */
+/* according to the device context requirement */
+static void mtk_cam_node_to_v4l2(struct mtk_cam_dev *isp_dev, u32 node,
+				 struct video_device *vdev,
+				 struct v4l2_format *f)
+{
+	u32 cap;
+	struct mtk_cam_ctx *device_ctx = &isp_dev->ctx;
+	struct mtk_cam_ctx_queue *node_ctx = &device_ctx->queue[node];
+
+	WARN_ON(node >= mtk_cam_dev_get_total_node(isp_dev));
+	WARN_ON(!node_ctx);
+
+	/* set cap of the node */
+	cap = mtk_cam_node_get_v4l2_cap(node_ctx);
+	f->type = mtk_cam_node_get_format_type(node_ctx);
+	vdev->ioctl_ops = mtk_cam_node_get_ioctl_ops(node_ctx);
+
+	if (mtk_cam_ctx_format_load_default_fmt(&device_ctx->queue[node], f)) {
+		dev_err(&isp_dev->pdev->dev,
+			"Can't load default for node (%d): (%s)",
+		node, device_ctx->queue[node].desc.name);
+	}	else {
+		if (device_ctx->queue[node].desc.image) {
+			dev_dbg(&isp_dev->pdev->dev,
+				"Node (%d): (%s), dfmt (f:0x%x w:%d: h:%d s:%d)\n",
+			node, device_ctx->queue[node].desc.name,
+			f->fmt.pix_mp.pixelformat,
+			f->fmt.pix_mp.width,
+			f->fmt.pix_mp.height,
+			f->fmt.pix_mp.plane_fmt[0].sizeimage
+			);
+			node_ctx->fmt.pix_mp = f->fmt.pix_mp;
+		} else {
+			dev_dbg(&isp_dev->pdev->dev,
+				"Node (%d): (%s), dfmt (f:0x%x s:%u)\n",
+			node, device_ctx->queue[node].desc.name,
+			f->fmt.meta.dataformat,
+			f->fmt.meta.buffersize
+			);
+			node_ctx->fmt.meta = f->fmt.meta;
+		}
+	}
+
+	vdev->device_caps = V4L2_CAP_STREAMING | cap;
+}
+
+#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
+static const struct media_device_ops mtk_cam_media_req_ops = {
+	.req_validate = vb2_request_validate,
+	.req_queue = vb2_request_queue,
+};
+#endif
+
+int mtk_cam_media_register(struct device *dev,
+			   struct media_device *media_dev,
+	const char *model)
+{
+	int r = 0;
+
+	media_dev->dev = dev;
+	dev_dbg(dev, "setup media_dev.dev: %llx\n",
+		(unsigned long long)media_dev->dev);
+
+	strlcpy(media_dev->model, model,
+		sizeof(media_dev->model));
+	dev_dbg(dev, "setup media_dev.model: %s\n",
+		media_dev->model);
+
+	snprintf(media_dev->bus_info, sizeof(media_dev->bus_info),
+		 "%s", dev_name(dev));
+	dev_dbg(dev, "setup media_dev.bus_info: %s\n",
+		media_dev->bus_info);
+
+	media_dev->hw_revision = 0;
+	dev_dbg(dev, "setup media_dev.hw_revision: %d\n",
+		media_dev->hw_revision);
+
+	dev_dbg(dev, "media_device_init: media_dev:%llx\n",
+		(unsigned long long)media_dev);
+	media_device_init(media_dev);
+
+#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
+	media_dev->ops = &mtk_cam_media_req_ops;
+#endif
+
+	pr_info("Register media device: %s, %llx",
+		media_dev->model,
+		(unsigned long long)media_dev);
+
+	r = media_device_register(media_dev);
+
+	if (r) {
+		dev_err(dev, "failed to register media device (%d)\n", r);
+		goto fail_v4l2_dev;
+	}
+	return 0;
+
+fail_v4l2_dev:
+	media_device_unregister(media_dev);
+	media_device_cleanup(media_dev);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_media_register);
+
+int mtk_cam_v4l2_register(struct device *dev,
+			  struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev,
+	struct v4l2_ctrl_handler *ctrl_handler
+	)
+{
+	int r = 0;
+	/* Set up v4l2 device */
+	v4l2_dev->mdev = media_dev;
+	dev_dbg(dev, "setup v4l2_dev->mdev: %llx",
+		(unsigned long long)v4l2_dev->mdev);
+	v4l2_dev->ctrl_handler = ctrl_handler;
+	dev_dbg(dev, "setup v4l2_dev->ctrl_handler: %llx",
+		(unsigned long long)v4l2_dev->ctrl_handler);
+
+	pr_info("Register v4l2 device: %llx",
+		(unsigned long long)v4l2_dev);
+
+	r = v4l2_device_register(dev, v4l2_dev);
+
+	if (r) {
+		dev_err(dev, "failed to register V4L2 device (%d)\n", r);
+		goto fail_v4l2_dev;
+	}
+
+	return 0;
+
+fail_v4l2_dev:
+	media_device_unregister(media_dev);
+	media_device_cleanup(media_dev);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_register);
+
+int mtk_cam_mem2mem2_v4l2_register(struct mtk_cam_dev *dev,
+				   struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = &dev->mem2mem2;
+
+	int i, r;
+
+	/* If media_dev or v4l2_dev is not set, */
+	/* use the default one in mtk_cam_dev */
+	if (!media_dev) {
+		m2m2->media_dev = &dev->media_dev;
+		r = mtk_cam_media_register(&dev->pdev->dev,
+					   m2m2->media_dev,
+		m2m2->model);
+
+		if (r) {
+			dev_err(m2m2->dev,
+				"failed to register media device (%d)\n", r);
+			goto fail_media_dev;
+		}
+	} else {
+		m2m2->media_dev = media_dev;
+	}
+
+	if (!v4l2_dev) {
+		m2m2->v4l2_dev = &dev->v4l2_dev;
+		r = mtk_cam_v4l2_register(&dev->pdev->dev,
+					  m2m2->media_dev,
+			m2m2->v4l2_dev,
+			NULL);
+
+	if (r) {
+		dev_err(m2m2->dev, "failed to register V4L2 device (%d)\n", r);
+		goto fail_v4l2_dev;
+	}
+	} else {
+		m2m2->v4l2_dev = v4l2_dev;
+	}
+
+	/* Initialize miscellaneous variables */
+	m2m2->streaming = false;
+	m2m2->v4l2_file_ops = mtk_cam_v4l2_fops;
+
+	/* Initialize subdev media entity */
+	m2m2->subdev_pads = kcalloc(m2m2->num_nodes,
+				    sizeof(*m2m2->subdev_pads), GFP_KERNEL);
+	if (!m2m2->subdev_pads) {
+		r = -ENOMEM;
+		goto fail_subdev_pads;
+	}
+
+	r = media_entity_pads_init(&m2m2->subdev.entity, m2m2->num_nodes,
+				   m2m2->subdev_pads);
+	if (r) {
+		dev_err(m2m2->dev,
+			"failed initialize subdev media entity (%d)\n", r);
+		goto fail_media_entity;
+	}
+
+	/* Initialize subdev */
+	v4l2_subdev_init(&m2m2->subdev, &mtk_cam_subdev_ops);
+
+	m2m2->subdev.entity.function =
+		MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+
+	m2m2->subdev.entity.ops = &mtk_cam_media_ops;
+
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		m2m2->subdev_pads[i].flags = m2m2->nodes[i].output ?
+			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+	}
+
+	m2m2->subdev.flags =
+		V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	snprintf(m2m2->subdev.name, sizeof(m2m2->subdev.name),
+		 "%s", m2m2->name);
+	v4l2_set_subdevdata(&m2m2->subdev, m2m2);
+	m2m2->subdev.internal_ops = &mtk_cam_subdev_internal_ops;
+
+	pr_info("register subdev: %s\n", m2m2->subdev.name);
+	r = v4l2_device_register_subdev(m2m2->v4l2_dev, &m2m2->subdev);
+	if (r) {
+		dev_err(m2m2->dev, "failed initialize subdev (%d)\n", r);
+		goto fail_subdev;
+	}
+
+	/* Create video nodes and links */
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		struct mtk_cam_dev_video_device *node = &m2m2->nodes[i];
+		struct video_device *vdev = &node->vdev;
+		struct vb2_queue *vbq = &node->vbq;
+		u32 flags;
+
+		/* Initialize miscellaneous variables */
+		mutex_init(&node->lock);
+		INIT_LIST_HEAD(&node->buffers);
+
+		/* Initialize formats to default values */
+		mtk_cam_node_to_v4l2(dev, i, vdev, &node->vdev_fmt);
+
+		/* Initialize media entities */
+		r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
+		if (r) {
+			dev_err(m2m2->dev,
+				"failed initialize media entity (%d)\n", r);
+			goto fail_vdev_media_entity;
+		}
+		node->vdev_pad.flags = node->output ?
+			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
+		vdev->entity.ops = NULL;
+		if (node->vdev_fmt.type == V4L2_BUF_TYPE_META_CAPTURE)
+			vdev->entity.function =
+				MEDIA_ENT_F_PROC_VIDEO_STATISTICS;
+
+		/* Initialize vbq */
+		vbq->type = node->vdev_fmt.type;
+		vbq->io_modes = VB2_MMAP | VB2_DMABUF;
+		vbq->ops = &mtk_cam_vb2_ops;
+		vbq->mem_ops = m2m2->vb2_mem_ops;
+		m2m2->buf_struct_size = sizeof(struct mtk_cam_dev_buffer);
+		vbq->buf_struct_size = m2m2->buf_struct_size;
+		vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers */
+		/* Put the process hub sub device in the vb2 private data*/
+		vbq->drv_priv = m2m2;
+		vbq->lock = &node->lock;
+#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
+		vbq->supports_requests = true;
+#endif
+
+		r = vb2_queue_init(vbq);
+		if (r) {
+			dev_err(m2m2->dev,
+				"failed to initialize video queue (%d)\n", r);
+			goto fail_vdev;
+		}
+
+		/* Initialize vdev */
+		snprintf(vdev->name, sizeof(vdev->name), "%s %s",
+			 m2m2->name, node->name);
+		vdev->release = video_device_release_empty;
+		vdev->fops = &m2m2->v4l2_file_ops;
+		vdev->lock = &node->lock;
+		vdev->v4l2_dev = m2m2->v4l2_dev;
+		vdev->queue = &node->vbq;
+		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
+		video_set_drvdata(vdev, m2m2);
+		pr_info("register vdev: %s\n", vdev->name);
+		r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+		if (r) {
+			dev_err(m2m2->dev,
+				"failed to register video device (%d)\n", r);
+			goto fail_vdev;
+		}
+
+		if (vdev->cdev->ops) {
+			memcpy((void *)&m2m2->fops, vdev->cdev->ops,
+			       sizeof(m2m2->fops));
+			vdev->cdev->ops = &m2m2->fops;
+		}
+
+		/* Create link between video node and the subdev pad */
+		flags = 0;
+		if (node->enabled)
+			flags |= MEDIA_LNK_FL_ENABLED;
+		if (node->immutable)
+			flags |= MEDIA_LNK_FL_IMMUTABLE;
+		if (node->output) {
+			r = media_create_pad_link(&vdev->entity, 0,
+						  &m2m2->subdev.entity,
+						  i, flags);
+		} else {
+			r = media_create_pad_link(&m2m2->subdev.entity,
+						  i, &vdev->entity, 0,
+						  flags);
+		}
+		if (r)
+			goto fail_link;
+	}
+
+	return 0;
+
+	for (; i >= 0; i--) {
+fail_link:
+		video_unregister_device(&m2m2->nodes[i].vdev);
+fail_vdev:
+		media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
+fail_vdev_media_entity:
+		mutex_destroy(&m2m2->nodes[i].lock);
+	}
+fail_subdev:
+	media_entity_cleanup(&m2m2->subdev.entity);
+fail_media_entity:
+	kfree(m2m2->subdev_pads);
+fail_subdev_pads:
+	v4l2_device_unregister(m2m2->v4l2_dev);
+fail_v4l2_dev:
+fail_media_dev:
+	pr_err("fail_v4l2_dev: media_device_unregister and clenaup:%llx",
+	       (unsigned long long)m2m2->media_dev);
+	media_device_unregister(m2m2->media_dev);
+	media_device_cleanup(m2m2->media_dev);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_mem2mem2_v4l2_register);
+
+int mtk_cam_v4l2_unregister(struct mtk_cam_dev *dev)
+{
+	struct mtk_cam_mem2mem2_device *m2m2 = &dev->mem2mem2;
+	unsigned int i;
+
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		video_unregister_device(&m2m2->nodes[i].vdev);
+		media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
+		mutex_destroy(&m2m2->nodes[i].lock);
+	}
+
+	v4l2_device_unregister_subdev(&m2m2->subdev);
+	media_entity_cleanup(&m2m2->subdev.entity);
+	kfree(m2m2->subdev_pads);
+	v4l2_device_unregister(m2m2->v4l2_dev);
+	media_device_unregister(m2m2->media_dev);
+	media_device_cleanup(m2m2->media_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_unregister);
+
+void mtk_cam_v4l2_buffer_done(struct vb2_buffer *vb,
+			      enum vb2_buffer_state state)
+{
+	struct mtk_cam_mem2mem2_buffer *b =
+		container_of(vb, struct mtk_cam_mem2mem2_buffer, vbb.vb2_buf);
+
+	list_del(&b->list);
+	vb2_buffer_done(&b->vbb.vb2_buf, state);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_buffer_done);
+
+/* link setup from cio_conn to sersor interface */
+int mtk_cam_cio_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote,
+			   u32 flags)
+{
+	struct mtk_cam_io_connection *cio;
+	struct media_entity *entity_sensor_cio = local->entity;
+
+	if (!entity_sensor_cio) {
+		dev_err(NULL, "entity_sensor_cio(%d) can't be found\n",
+			local, remote->index);
+		return -EINVAL;
+	}
+
+	cio = container_of(entity_sensor_cio,
+			   struct mtk_cam_io_connection, subdev.entity);
+
+	dev_dbg(&cio->pdev->dev, "link setup: %d --> %d\n",
+		local, remote->index);
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		dev_dbg(&cio->pdev->dev,
+			"Disabled pipeline to sensor IF (%s)\n",
+			 entity->name);
+		cio->enable = false;
+	} else {
+		dev_dbg(&cio->pdev->dev,
+			"Enabled pipeline to sensor IF (%s)\n",
+			 entity->name);
+		cio->enable = true;
+	}
+	return 0;
+}
+
+struct sensor_async_subdev {
+	struct v4l2_async_subdev asd;
+};
+
+static const struct v4l2_subdev_ops mtk_cam_cio_subdev_ops = {
+};
+
+static const struct media_entity_operations mtk_cam_cio_media_ops = {
+	.link_setup = mtk_cam_cio_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static int mtk_cam_dev_notifier_bound(struct v4l2_async_notifier *notifier,
+				      struct v4l2_subdev *sd,
+			       struct v4l2_async_subdev *asd)
+{
+	struct mtk_cam_dev *isp_dev =
+		container_of(notifier, struct mtk_cam_dev, notifier);
+	struct device *dev = &isp_dev->pdev->dev;
+
+	dev_dbg(dev, "%s bound\n", sd->entity.name);
+	pr_info("mtk_cam %s bound\n", sd->entity.name);
+
+	return 0;
+}
+
+static void mtk_cam_dev_notifier_unbind(struct v4l2_async_notifier *notifier,
+					struct v4l2_subdev *sd,
+				 struct v4l2_async_subdev *asd)
+{
+	struct mtk_cam_dev *isp_dev =
+		container_of(notifier, struct mtk_cam_dev, notifier);
+	struct device *dev = &isp_dev->pdev->dev;
+
+	dev_dbg(dev, "%s unbound\n", sd->entity.name);
+}
+
+static struct v4l2_subdev *get_subdev_by_name(struct mtk_cam_dev *isp_dev,
+					      char *name)
+{
+	struct device_node *node;
+	struct v4l2_subdev *sd = NULL;
+
+	list_for_each_entry(sd, &isp_dev->v4l2_dev.subdevs, list) {
+		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
+			continue;
+		node = to_of_node(sd->fwnode);
+		if (node) {
+			if (!strcmp(node->name, name))
+				return sd;
+		}
+	}
+	return NULL;
+}
+
+static int mtk_cam_dev_notifier_complete(struct v4l2_async_notifier *notifier)
+{
+	struct mtk_cam_dev *isp_dev =
+		container_of(notifier, struct mtk_cam_dev, notifier);
+	struct device *dev = &isp_dev->pdev->dev;
+	struct mtk_cam_io_connection *cio = &isp_dev->cio;
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev *src_sd, *sink_sd;
+	struct device_node *node;
+	int r = 0;
+
+	dev_dbg(dev, "Complete the v4l2 registration\n");
+
+	r = media_entity_pads_init(&cio->subdev.entity, MTK_CAM_IO_CON_PADS,
+				   cio->subdev_pads);
+	if (r) {
+		dev_err(dev,
+			"failed initialize cio subdev (%d)\n", r);
+		return -EINVAL;
+	}
+
+	v4l2_subdev_init(&cio->subdev, &mtk_cam_cio_subdev_ops);
+
+	cio->name = "cam-io";
+	cio->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	cio->subdev.entity.ops = &mtk_cam_cio_media_ops;
+	cio->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(cio->subdev.name, sizeof(cio->subdev.name),
+		 "%s", cio->name);
+
+	v4l2_set_subdevdata(&cio->subdev, cio);
+
+	r = v4l2_device_register_subdev(&isp_dev->v4l2_dev,	&cio->subdev);
+	if (r) {
+		dev_err(dev, "Unable to v4l2_device_register_subdev\n");
+		goto complete_out;
+	}
+
+	r = v4l2_device_register_subdev_nodes(&isp_dev->v4l2_dev);
+	if (r) {
+		dev_err(dev, "Unable to v4l2_device_register_subdev_nodes\n");
+		goto complete_out;
+	}
+
+	/* Links among sensor, sensor interface and cio */
+	list_for_each_entry(sd, &isp_dev->v4l2_dev.subdevs, list) {
+		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
+			continue;
+		node = to_of_node(sd->fwnode);
+		if (node)
+			sd->entity.name = node->name;
+	}
+
+	src_sd = get_subdev_by_name(isp_dev, "sensor_main");
+	sink_sd = get_subdev_by_name(isp_dev, "seninf");
+
+	if (src_sd && sink_sd) {
+		dev_dbg(dev, "Link create: %s --> %s\n",
+			src_sd->entity.name, sink_sd->entity.name);
+		r = media_create_pad_link(&src_sd->entity,
+					  MTK_CAM_SENSOR_MAIN_PAD_SRC,
+					  &sink_sd->entity,
+					  MTK_CAM_SENSOR_IF_PAD_MAIN_SINK, 0);
+		if (r)
+			dev_err(dev,
+				"fail to create pad link %s %s, ret(%d)\n",
+				src_sd->entity.name, sink_sd->entity.name, r);
+	} else {
+		dev_err(dev,
+			"Sub dev not found: sensor_main(0x%llx), seninf(0x%llx)\n",
+			src_sd, sink_sd);
+	}
+
+	src_sd = get_subdev_by_name(isp_dev, "sensor_sub");
+
+	if (src_sd && sink_sd) {
+		dev_dbg(dev, "Link create: %s --> %s\n",
+			src_sd->entity.name, sink_sd->entity.name);
+		r = media_create_pad_link(&src_sd->entity,
+					  MTK_CAM_SENSOR_SUB_PAD_SRC,
+					  &sink_sd->entity,
+					  MTK_CAM_SENSOR_IF_PAD_SUB_SINK, 0);
+		if (r)
+			dev_err(dev,
+				"fail to create pad link %s %s, ret(%d)\n",
+				src_sd->entity.name, sink_sd->entity.name, r);
+	} else {
+		dev_warn(dev,
+			 "Sub dev not found: sensor_sub(0x%llx), seninf(0x%llx)\n",
+			 src_sd, sink_sd);
+	}
+
+	r = media_create_pad_link(&sink_sd->entity, MTK_CAM_SENSOR_IF_PAD_SRC,
+				  &cio->subdev.entity,
+				  MTK_CAM_CIO_PAD_SINK, 0);
+
+	if (r)
+		dev_err(dev,
+			"fail to create pad link %s %s\n",
+			sink_sd->entity.name, cio->subdev.entity.name);
+	return r;
+
+complete_out:
+	v4l2_device_unregister(&isp_dev->v4l2_dev);
+	return r;
+}
+
+static const struct v4l2_async_notifier_operations mtk_cam_async_ops = {
+	.bound = mtk_cam_dev_notifier_bound,
+	.unbind = mtk_cam_dev_notifier_unbind,
+	.complete = mtk_cam_dev_notifier_complete,
+};
+
+static int mtk_cam_dev_fwnode_parse(struct device *dev,
+				    struct v4l2_fwnode_endpoint *vep,
+				    struct v4l2_async_subdev *asd)
+{
+	dev_dbg(dev, "%s: To be implemented\n", __func__);
+
+	return 0;
+}
+
+int mtk_cam_v4l2_async_register(struct mtk_cam_dev *isp_dev)
+{
+	int ret;
+
+	ret = v4l2_async_notifier_parse_fwnode_endpoints
+		(&isp_dev->pdev->dev, &isp_dev->notifier,
+		 sizeof(struct sensor_async_subdev),
+		 mtk_cam_dev_fwnode_parse);
+	if (ret < 0)
+		return ret;
+
+	if (!isp_dev->notifier.num_subdevs)
+		return -ENODEV;
+
+	isp_dev->notifier.ops = &mtk_cam_async_ops;
+	pr_info("mtk_cam v4l2_async_notifier_register\n");
+	ret = v4l2_async_notifier_register(&isp_dev->v4l2_dev,
+					   &isp_dev->notifier);
+
+	if (ret) {
+		dev_err(&isp_dev->pdev->dev,
+			"failed to register async notifier : %d\n", ret);
+		v4l2_async_notifier_cleanup(&isp_dev->notifier);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_async_register);
+
+void mtk_cam_v4l2_async_unregister(struct mtk_cam_dev *isp_dev)
+{
+	v4l2_async_notifier_unregister(&isp_dev->notifier);
+	v4l2_async_notifier_cleanup(&isp_dev->notifier);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_async_unregister);
+
+int mtk_cam_v4l2_discover_sensor(struct mtk_cam_dev *isp_dev)
+{
+	struct media_graph graph;
+	struct mtk_cam_io_connection *cio = &isp_dev->cio;
+	struct media_entity *entity = &cio->subdev.entity;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct device *dev = &isp_dev->pdev->dev;
+	struct v4l2_subdev *sensor = NULL;
+	struct v4l2_subdev *sensor_if = NULL;
+
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	ret = media_graph_walk_init(&graph, mdev);
+	if (ret) {
+		mutex_unlock(&mdev->graph_mutex);
+		return ret;
+	}
+
+	media_graph_walk_start(&graph, entity);
+
+	while ((entity = media_graph_walk_next(&graph))) {
+		dev_dbg(dev, "Graph traversal: entity: %s\n", entity->name);
+
+		if (!strcmp(entity->name, "seninf")) {
+			sensor_if = media_entity_to_v4l2_subdev(entity);
+			dev_dbg(dev, "Sensor if entity found: %s\n",
+				entity->name);
+		}
+
+		if (!strncmp(entity->name, "sensor", 6)) {
+			sensor = media_entity_to_v4l2_subdev(entity);
+			dev_dbg(dev, "Sensor if entity found: %s\n",
+				entity->name);
+		}
+	}
+
+	mutex_unlock(&mdev->graph_mutex);
+	media_graph_walk_cleanup(&graph);
+
+	if (!sensor_if) {
+		dev_err(dev, "Sensor IF has not been connected\n");
+		return -EINVAL;
+	}
+
+	cio->sensor_if = sensor_if;
+
+	if (!sensor) {
+		dev_err(dev, "Sensor has not been not connected\n");
+		return -EINVAL;
+	}
+
+	cio->sensor = sensor;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_cam_v4l2_discover_sensor);
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h
new file mode 100644
index 0000000..499c5fc
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_CAM_DEV_V4L2_H__
+#define __MTK_CAM_DEV_V4L2_H__
+
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+
+/*
+ * Events
+ *
+ * V4L2_EVENT_MTK_CAM_ENGINE_STATE: AF statistics data ready
+ * V4L2_EVENT_MTK_CAM_FRAME_DONE: Hardware has finished a frame
+ */
+
+#define V4L2_EVENT_MTK_CAM_CLASS	\
+	(V4L2_EVENT_PRIVATE_START | 0x200)
+#define V4L2_EVENT_MTK_CAM_ENGINE_STATE	\
+	(V4L2_EVENT_MTK_CAM_CLASS | 0x1)
+#define V4L2_EVENT_MTK_CAM_FRAME_DONE	\
+	(V4L2_EVENT_MTK_CAM_CLASS | 0x2)
+
+/* For v4l2 event data, must smaller than 64 bytes */
+struct mtk_cam_dev_stat_event_data {
+	__u32 frame_number;
+	__u32 irq_status_mask;
+	__u32 dma_status_mask;
+};
+
+struct mtk_cam_dev_frame_done_event_data {
+	__u32 frame_id;	/* The frame id of mtk_cam_ctx_buf */
+	__u32 user_sequence;	/* Sequence number assigned by user, */
+				/* for example, HW's frame number */
+};
+
+#endif /* __MTK_CAM_DEV_V4L2_H__ */
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c
new file mode 100644
index 0000000..7a2aa4b
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include "mtk_cam-ctx.h"
+#include "mtk_cam.h"
+#include "mtk_cam-v4l2.h"
+
+#define MTK_CAM_DEV_P1_NAME			"MTK-ISP-P1-V4L2"
+
+static int mtk_cam_ctx_p1_open(struct mtk_cam_ctx *dev_ctx,
+			       struct mtk_cam_ctx_open_param *param);
+
+static int mtk_cam_ctx_p1_release(struct mtk_cam_ctx *dev_ctx,
+				  struct mtk_cam_ctx_release_param *param);
+
+static int mtk_cam_ctx_p1_start(struct mtk_cam_ctx *dev_ctx,
+				struct mtk_cam_ctx_start_param *param);
+
+static int mtk_cam_ctx_p1_streamon(struct mtk_cam_ctx *dev_ctx,
+				   struct mtk_cam_ctx_streamon_param *param);
+
+static int mtk_cam_ctx_p1_streamoff(struct mtk_cam_ctx *dev_ctx,
+				    struct mtk_cam_ctx_streamoff_param *param);
+
+/* The implementation of P1 device context operation */
+struct mtk_cam_ctx_ops mtk_cam_ctx_p1_ops = {
+	.open = mtk_cam_ctx_p1_open,
+	.release = mtk_cam_ctx_p1_release,
+	.start = mtk_cam_ctx_p1_start,
+	.finish = mtk_cam_ctx_core_job_finish,
+	.streamon = mtk_cam_ctx_p1_streamon,
+	.streamoff = mtk_cam_ctx_p1_streamoff,
+};
+
+/* The setting for the quick conifgurtion provided */
+/* by mtk_cam_ctx_core_steup */
+struct mtk_cam_ctx_setting mtk_cam_ctx_p1_setting = {
+	.device_name = MTK_CAM_DEV_P1_NAME,
+	.ops = &mtk_cam_ctx_p1_ops,
+};
+
+static struct mtk_cam_ctx_format meta_fmts[] = {
+	{
+		.fmt.meta = {
+			.dataformat = V4L2_META_FMT_MTISP_PARAMS,
+			.max_buffer_size = 1110 * 1024,
+		},
+	},
+};
+
+static struct mtk_cam_ctx_format out_fmts[] = {
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_MTISP_B10,
+			.depth		= { 10 },
+			.row_depth	= { 10 },
+			.num_planes	= 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_MTISP_F10,
+			.depth		= { 15 },
+			.row_depth	= { 15 },
+			.num_planes	= 1,
+		},
+	},
+};
+
+static struct mtk_cam_ctx_queue_desc
+	output_queues[MTK_CAM_CTX_P1_TOTAL_OUTPUT] = {
+	{
+		.id = MTK_CAM_CTX_P1_META_IN_0,
+		.name = "meta intput",
+		.capture = 0,
+		.image = 0,
+		.smem_alloc = 1,
+		.fmts = meta_fmts,
+		.num_fmts = ARRAY_SIZE(meta_fmts),
+		.default_fmt_idx = 0,
+	},
+};
+
+static struct mtk_cam_ctx_queue_desc
+	capture_queues[MTK_CAM_CTX_P1_TOTAL_CAPTURE] = {
+	{
+		.id = MTK_CAM_CTX_P1_META_OUT_0,
+		.name = "partial meta 0",
+		.capture = 1,
+		.image = 0,
+		.smem_alloc = 0,
+		.dma_port = R_AAO | R_FLKO | R_PSO,
+		.fmts = meta_fmts,
+		.num_fmts = ARRAY_SIZE(meta_fmts),
+		.default_fmt_idx = 0,
+	},
+	{
+		.id = MTK_CAM_CTX_P1_META_OUT_1,
+		.name = "partial meta 1",
+		.capture = 1,
+		.image = 0,
+		.smem_alloc = 0,
+		.dma_port = R_AFO,
+		.fmts = meta_fmts,
+		.num_fmts = ARRAY_SIZE(meta_fmts),
+		.default_fmt_idx = 0,
+
+	},
+	{
+		.id = MTK_CAM_CTX_P1_MAIN_STREAM_OUT,
+		.name = "main stream",
+		.capture = 1,
+		.image = 1,
+		.smem_alloc = 0,
+		.dma_port = R_IMGO,
+		.fmts = out_fmts,
+		.num_fmts = ARRAY_SIZE(out_fmts),
+		.default_fmt_idx = 0,
+
+	},
+	{
+		.id = MTK_CAM_CTX_P1_PACKED_BIN_OUT,
+		.name = "packed out",
+		.capture = 1,
+		.image = 1,
+		.smem_alloc = 0,
+		.dma_port = R_RRZO,
+		.fmts = out_fmts,
+		.num_fmts = ARRAY_SIZE(out_fmts),
+		.default_fmt_idx = 1,
+
+	},
+};
+
+static struct mtk_cam_ctx_queues_setting queues_setting = {
+	.master = MTK_CAM_CTX_P1_MAIN_STREAM_OUT,
+	.output_queue_descs = output_queues,
+	.total_output_queues = MTK_CAM_CTX_P1_TOTAL_OUTPUT,
+	.capture_queue_descs = capture_queues,
+	.total_capture_queues = MTK_CAM_CTX_P1_TOTAL_CAPTURE,
+};
+
+/* MTK ISP context initialization */
+int mtk_cam_ctx_p1_init(struct mtk_cam_ctx *ctx)
+{
+	/* Initialize main data structure */
+	mtk_cam_ctx_core_queue_setup(ctx, &queues_setting);
+	return mtk_cam_ctx_core_steup(ctx, &mtk_cam_ctx_p1_setting);
+}
+EXPORT_SYMBOL_GPL(mtk_cam_ctx_p1_init);
+
+static int mtk_cam_ctx_p1_open(struct mtk_cam_ctx *dev_ctx,
+			       struct mtk_cam_ctx_open_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+
+	dev_dbg(&pdev->dev,
+		"open: pdev(%llx), enabled DMA port %x\n",
+		(long long)pdev, param->enabled_dma_ports);
+	mtk_isp_prepare(pdev, param);
+	mtk_isp_open(pdev);
+	return 0;
+}
+
+static int mtk_cam_ctx_p1_release(struct mtk_cam_ctx *dev_ctx,
+				  struct mtk_cam_ctx_release_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+
+	dev_dbg(&pdev->dev,
+		"release: pdev(%llx)\n", (long long)pdev);
+	mtk_isp_release(pdev);
+	return 0;
+}
+
+static int mtk_cam_ctx_p1_start(struct mtk_cam_ctx *dev_ctx,
+				struct mtk_cam_ctx_start_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+	int i = 0;
+	int scan_queue_idx[] = {MTK_CAM_CTX_P1_META_IN_0,
+		MTK_CAM_CTX_P1_META_OUT_0, MTK_CAM_CTX_P1_META_OUT_1,
+		MTK_CAM_CTX_P1_MAIN_STREAM_OUT,	MTK_CAM_CTX_P1_PACKED_BIN_OUT};
+	int total_buffer_scan = ARRAY_SIZE(scan_queue_idx);
+
+	if (!pdev || !param) {
+		dev_err(&pdev->dev,
+			"pdev(%llx) and param(%llx) in start can't be NULL\n",
+			(long long)pdev, (long long)param);
+		return -EINVAL;
+	}
+
+	dev_dbg(&pdev->dev,
+		"trigger start op: pdev(%llx), frame(%x)\n",
+		(long long)pdev, param->frame_bundle->id);
+
+	/* Dump all information carried in this param */
+	for (i = 0; i < total_buffer_scan; i++) {
+		int queue_idx = scan_queue_idx[i];
+		dma_addr_t daddr;
+		void *vaddr = NULL;
+		struct mtk_cam_ctx_buffer *buf =
+			param->frame_bundle->buffers[queue_idx];
+
+		if (!buf) {
+			dev_dbg(&pdev->dev, "CTX buf(frame=%d, queue=%d) is NULL\n",
+				param->frame_bundle->id, queue_idx);
+			continue;
+		}
+
+		dev_dbg(&pdev->dev,
+			"get buf, queue = %d, user_sequence = %d, addr = 0x%llx\n",
+			queue_idx, buf->user_sequence, (long long)buf);
+
+		daddr = buf->daddr;
+		vaddr = buf->vaddr;
+
+		if (buf->image) {
+			struct v4l2_pix_format_mplane *pix_fmt =
+				&buf->fmt.pix_mp;
+
+			if (!pix_fmt)
+				dev_warn(&pdev->dev, "v4l2_pix_format is NULL,  queue=%d\n",
+					 queue_idx);
+			else
+				dev_dbg(&pdev->dev,
+					"Buf f(%d):w(%d),h(%d),fmt(%d),color(%d),size(%d),useq(%d)\n",
+					buf->frame_id,
+					pix_fmt->width,	pix_fmt->height,
+					pix_fmt->pixelformat,
+					pix_fmt->colorspace,
+					pix_fmt->plane_fmt[0].sizeimage,
+					buf->user_sequence);
+		} else {
+			struct v4l2_meta_format *meta_fmt = &buf->fmt.meta;
+
+			if (!meta_fmt)
+				dev_warn(&pdev->dev, "meta_fmt is NULL,  queue=%d\n",
+					 queue_idx);
+			else
+				dev_dbg(&pdev->dev,
+					"Buf from frame(%d):metatype(%d),size(%d),useq(%d)\n",
+					buf->frame_id, meta_fmt->dataformat,
+					meta_fmt->buffersize,
+					buf->user_sequence);
+		}
+	}
+
+	mtk_isp_enqueue(pdev, param);
+	return 0;
+}
+
+static int mtk_cam_ctx_p1_streamon(struct mtk_cam_ctx *dev_ctx,
+				   struct mtk_cam_ctx_streamon_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+	unsigned short ctx_id = dev_ctx->ctx_id;
+
+	dev_dbg(&pdev->dev,
+		"streamon: pdev(%llx), ctx(%d)\n", (long long)pdev, ctx_id);
+
+	return mtk_isp_streamon(pdev, ctx_id);
+}
+
+static int mtk_cam_ctx_p1_streamoff(struct mtk_cam_ctx *dev_ctx,
+				    struct mtk_cam_ctx_streamoff_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+	unsigned short ctx_id = dev_ctx->ctx_id;
+
+	dev_dbg(&pdev->dev,
+		"streamoff: pdev(%llx), ctx(%d)\n", (long long)pdev, ctx_id);
+	return mtk_isp_streamoff(pdev, ctx_id);
+}
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h
new file mode 100644
index 0000000..649c175
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Frederic Chen <frederic.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_CAM_CTX_P1_H__
+#define __MTK_CAM_CTX_P1_H__
+
+#include <linux/types.h>
+#include "mtk_cam-ctx.h"
+
+/* Input: */
+#define MTK_CAM_CTX_P1_META_IN_0		(0)
+#define MTK_CAM_CTX_P1_TOTAL_OUTPUT (1)
+
+/* Output: */
+#define MTK_CAM_CTX_P1_META_OUT_0		(1)
+#define MTK_CAM_CTX_P1_META_OUT_1		(2)
+#define MTK_CAM_CTX_P1_MAIN_STREAM_OUT (3)
+#define MTK_CAM_CTX_P1_PACKED_BIN_OUT		(4)
+#define MTK_CAM_CTX_P1_TOTAL_CAPTURE (4)
+
+struct mtk_cam_ctx_p1_finish_param {
+	struct mtk_cam_ctx_finish_param base;
+	/* P1 private params */
+};
+
+int mtk_cam_ctx_p1_init(struct mtk_cam_ctx *ctx);
+
+#endif /* __MTK_CAM_CTX_P1_H__ */
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c
new file mode 100644
index 0000000..93cefcb
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c
@@ -0,0 +1,466 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Seraph Huang <seraph.huang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/atomic.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include "mtk_cam.h"
+#include "mtk_cam-vpu.h"
+#include "mtk_vpu.h"
+
+void isp_composer_dma_sg_init(struct mtk_isp_p1_ctx *isp_ctx)
+{
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(isp_ctx);
+	struct platform_device *pdev = p1_dev->pdev;
+	u32 size, size_align;
+	struct sg_table *sgt;
+	int n_pages = 0, i = 0, r = 0;
+	struct page **pages = NULL;
+
+	isp_ctx->scp_mem_iova = 0;
+	isp_ctx->scp_mem_va = (void *)vpu_get_reserve_mem_virt(ISP_MEM_ID);
+	isp_ctx->scp_mem_pa = vpu_get_reserve_mem_phys(ISP_MEM_ID);
+	size = (u32)vpu_get_reserve_mem_size(ISP_MEM_ID);
+
+	dev_dbg(&pdev->dev, "isp scp mem: va:0x%llx, pa:0x%llx sz:0x%x\n",
+		isp_ctx->scp_mem_va, isp_ctx->scp_mem_pa, size);
+
+	if (isp_ctx->scp_mem_va != 0 && size > 0)
+		memset((void *)isp_ctx->scp_mem_va, 0, size);
+
+	/* get iova */
+	sgt = &isp_ctx->sgtable;
+	sg_alloc_table(sgt, 1, GFP_KERNEL);
+
+	size_align = round_up(size, PAGE_SIZE);
+	n_pages = size_align >> PAGE_SHIFT;
+
+	pages = kmalloc_array(n_pages, sizeof(struct page *),
+			      GFP_KERNEL);
+
+	for (i = 0; i < n_pages; i++)
+		pages[i] = phys_to_page(isp_ctx->scp_mem_pa + i * PAGE_SIZE);
+
+	r = sg_alloc_table_from_pages(sgt, pages, n_pages,
+				      0, size_align, GFP_KERNEL);
+
+	if (r) {
+		dev_err(&pdev->dev, "failed to get alloca sg table\n");
+		kfree(pages);
+		return;
+	}
+
+	dma_map_sg_attrs(&pdev->dev, sgt->sgl, sgt->nents,
+			 DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
+	isp_ctx->scp_mem_iova = sg_dma_address(sgt->sgl);
+	kfree(pages);
+}
+
+static void isp_composer_deinit(struct mtk_isp_p1_ctx *isp_ctx)
+{
+	struct mtk_isp_queue_work *framejob, *tmp_framejob;
+
+	list_for_each_entry_safe(framejob, tmp_framejob,
+				 &isp_ctx->composer_txlist.queue,
+				 list_entry) {
+		list_del(&framejob->list_entry);
+		kfree(framejob);
+		isp_ctx->composer_txlist.queue_cnt--;
+	}
+
+	list_for_each_entry_safe(framejob, tmp_framejob,
+				 &isp_ctx->composer_eventlist.queue,
+				 list_entry) {
+		list_del(&framejob->list_entry);
+		kfree(framejob);
+		isp_ctx->composer_eventlist.queue_cnt--;
+	}
+
+	atomic_set(&isp_ctx->num_composing, 0);
+	atomic_set(&isp_ctx->num_frame_composing, 0);
+	atomic_set(&isp_ctx->vpu_state, VPU_ISP_STATE_INVALID);
+
+	mutex_destroy(&isp_ctx->composer_tx_lock);
+	sg_free_table(&isp_ctx->sgtable);
+
+	isp_ctx->composer_event_thread.thread = NULL;
+	isp_ctx->composer_deinit_donecb(isp_ctx);
+}
+
+static int isp_composer_tx_work(void *data)
+{
+	struct mtk_isp_p1_ctx *isp_ctx = (struct mtk_isp_p1_ctx *)data;
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(isp_ctx);
+	struct platform_device *pdev = p1_dev->pdev;
+	unsigned int num_composing, buf_used;
+	struct mtk_isp_queue_work *isp_composer_work;
+	int ret;
+
+	while (1) {
+		spin_lock(&isp_ctx->composer_txlist.lock);
+		buf_used = atomic_read(&isp_ctx->num_frame_composing);
+		num_composing = atomic_read(&isp_ctx->num_composing);
+		spin_unlock(&isp_ctx->composer_txlist.lock);
+
+		if (isp_ctx->composer_txlist.queue_cnt == 0 ||
+		    buf_used >= ISP_FRAME_COMPOSING_MAX_NUM ||
+		    num_composing >= ISP_COMPOSING_MAX_NUM) {
+			ret = wait_event_interruptible
+				(isp_ctx->composer_tx_thread.wq,
+				 isp_ctx->composer_txlist.queue_cnt > 0);
+			if (ret == 0)
+				ret = -ETIME;
+			else if (-ERESTARTSYS == ret)
+				dev_err(&pdev->dev, "interrupted by a signal!\n");
+
+			buf_used = atomic_read(&isp_ctx->num_frame_composing);
+			num_composing = atomic_read(&isp_ctx->num_composing);
+			if (buf_used >= ISP_FRAME_COMPOSING_MAX_NUM ||
+			    num_composing >= ISP_COMPOSING_MAX_NUM)
+				continue;
+		}
+
+		spin_lock(&isp_ctx->composer_txlist.lock);
+		isp_composer_work =
+		    list_first_entry_or_null
+			(&isp_ctx->composer_txlist.queue,
+			 struct mtk_isp_queue_work,
+			 list_entry);
+		list_del(&isp_composer_work->list_entry);
+		isp_ctx->composer_txlist.queue_cnt--;
+		spin_unlock(&isp_ctx->composer_txlist.lock);
+
+		if (atomic_read(&isp_ctx->vpu_state) == VPU_ISP_STATE_INVALID) {
+			dev_err(&pdev->dev,
+				"ignore IPI type: %d, VPU state %d!\n",
+				isp_composer_work->type,
+				atomic_read(&isp_ctx->vpu_state));
+			kfree(isp_composer_work);
+			continue;
+		}
+		if (isp_composer_work->type == VPU_ISP_CMD) {
+			mutex_lock(&isp_ctx->composer_tx_lock);
+			vpu_ipi_send_sync_async
+				(p1_dev->vpu_pdev,
+				 IPI_ISP_CMD,
+				 &isp_composer_work->cmd,
+				 sizeof(isp_composer_work->cmd),
+				 0);
+			mutex_unlock(&isp_ctx->composer_tx_lock);
+			num_composing =
+				atomic_inc_return(&isp_ctx->num_composing);
+			dev_dbg(&pdev->dev, "%s cmd id %d sent, frame/buf used: %d,%d",
+				__func__,
+				isp_composer_work->cmd.cmd_id,
+				num_composing, buf_used);
+		} else if (isp_composer_work->type == VPU_ISP_FRAME) {
+			mutex_lock(&isp_ctx->composer_tx_lock);
+			vpu_ipi_send_sync_async
+				(p1_dev->vpu_pdev,
+				 IPI_ISP_FRAME,
+				 &isp_composer_work->frameparams,
+				 sizeof(isp_composer_work->frameparams),
+				 0);
+			mutex_unlock(&isp_ctx->composer_tx_lock);
+			num_composing =
+				atomic_inc_return(&isp_ctx->num_composing);
+			buf_used =
+				atomic_inc_return
+					(&isp_ctx->num_frame_composing);
+			dev_dbg(&pdev->dev, "%s frame id %d sent, frame/buf used: %d,%d",
+				__func__,
+				isp_composer_work->frameparams.frame_num,
+				num_composing, buf_used);
+		} else {
+			dev_err(&pdev->dev,
+				"ignore IPI type: %d!\n",
+				isp_composer_work->type);
+			kfree(isp_composer_work);
+			continue;
+		}
+		kfree(isp_composer_work);
+	}
+	return ret;
+}
+
+static int isp_composer_rx_work(void *data)
+{
+	struct mtk_isp_p1_ctx *isp_ctx = (struct mtk_isp_p1_ctx *)data;
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(data);
+	struct platform_device *pdev = p1_dev->pdev;
+	struct mtk_isp_vpu_cmd *ipi_msg;
+	struct isp_vpu_param *cmdjob;
+	int ret, queue_used, buf_used;
+	unsigned long flags;
+	u8 ack_cmd_id;
+
+	while (1) {
+		if (isp_ctx->composer_eventlist.queue_cnt == 0) {
+			ret = wait_event_interruptible
+				(isp_ctx->composer_event_thread.wq,
+				 isp_ctx->composer_eventlist.queue_cnt > 0);
+			if (ret == 0)
+				ret = -ETIME;
+			else if (-ERESTARTSYS == ret)
+				dev_err(&pdev->dev, "interrupted by a signal!\n");
+		}
+		spin_lock_irqsave(&isp_ctx->composer_eventlist.lock, flags);
+		cmdjob =
+		    list_first_entry(&isp_ctx->composer_eventlist.queue,
+				     struct isp_vpu_param, list_entry);
+		if (!cmdjob) {
+			spin_unlock_irqrestore
+				(&isp_ctx->composer_eventlist.lock, flags);
+			dev_err(&pdev->dev, "null work\n", __func__);
+			continue;
+		}
+		isp_ctx->composer_eventlist.queue_cnt--;
+		list_del(&cmdjob->list_entry);
+		spin_unlock_irqrestore(&isp_ctx->composer_eventlist.lock,
+				       flags);
+
+		ipi_msg = &cmdjob->cmd;
+		switch (ipi_msg->cmd_id) {
+		case ISP_CMD_VPU_STATE:
+			atomic_set(&isp_ctx->vpu_state,
+				   ipi_msg->cmd_data[0]);
+			break;
+		case ISP_CMD_ACK:
+			queue_used = atomic_dec_return(&isp_ctx->num_composing);
+			if (queue_used >= ISP_COMPOSING_MAX_NUM)
+				wake_up_interruptible
+					(&isp_ctx->composer_tx_thread.wq);
+
+			buf_used = atomic_read(&isp_ctx->num_frame_composing);
+			ack_cmd_id = ipi_msg->ack_info.cmd_id;
+			if (ack_cmd_id == ISP_CMD_FRAME_ACK) {
+				dev_dbg(&pdev->dev, "%s cmd/frame ID: %d/%d, queue used: %d\n",
+					__func__,
+					ack_cmd_id,
+					ipi_msg->ack_info.frame_num,
+					queue_used);
+				atomic_set(&isp_ctx->composed_frame_id,
+					   ipi_msg->ack_info.frame_num);
+			} else {
+				dev_dbg(&pdev->dev, "%s cmd ID: %d, queue used: %d\n",
+					__func__,
+					ack_cmd_id,
+					queue_used);
+				if (ack_cmd_id == ISP_CMD_DEINIT) {
+					isp_composer_deinit(isp_ctx);
+					kfree(cmdjob);
+					return -1;
+				}
+			}
+			break;
+		default:
+			break;
+		};
+		kfree(cmdjob);
+	}
+	return ret;
+}
+
+static void isp_composer_handler(void *data, unsigned int len, void *priv)
+{
+	struct isp_p1_device *p1_dev;
+	struct platform_device *pdev;
+	struct mtk_isp_p1_ctx *isp_ctx;
+	struct isp_vpu_param *cmdparam;
+	struct mtk_isp_vpu_cmd *ipi_msg_ptr;
+	unsigned long flags;
+
+	WARN_ONCE(!data, "%s is failed due to NULL data\n", __func__);
+	if (!data)
+		return;
+
+	WARN_ONCE(!data, "%s is failed due to incorrect length\n", __func__);
+	if (len != sizeof(cmdparam->cmd))
+		return;
+
+	ipi_msg_ptr = (struct mtk_isp_vpu_cmd *)data;
+
+	cmdparam = kzalloc(sizeof(*cmdparam), GFP_ATOMIC);
+	memcpy(&cmdparam->cmd, data, sizeof(cmdparam->cmd));
+	WARN_ONCE(!data, "%s ipi_msg_ptr->drv_data=0x%x\n",
+		  __func__, ipi_msg_ptr->drv_data);
+	isp_ctx = (struct mtk_isp_p1_ctx *)ipi_msg_ptr->drv_data;
+	p1_dev = p1_ctx_to_dev(isp_ctx);
+	pdev = p1_dev->pdev;
+
+	spin_lock_irqsave(&isp_ctx->composer_eventlist.lock, flags);
+	list_add_tail(&cmdparam->list_entry,
+		      &isp_ctx->composer_eventlist.queue);
+	isp_ctx->composer_eventlist.queue_cnt++;
+	spin_unlock_irqrestore(&isp_ctx->composer_eventlist.lock, flags);
+
+	wake_up_interruptible(&isp_ctx->composer_event_thread.wq);
+}
+
+int isp_composer_init(struct mtk_isp_p1_ctx *isp_ctx)
+{
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(isp_ctx);
+	struct platform_device *pdev = p1_dev->pdev;
+	int ret = 0;
+
+	atomic_set(&isp_ctx->vpu_state, VPU_ISP_STATE_INVALID);
+
+	vpu_ipi_register(p1_dev->vpu_pdev, IPI_ISP_CMD, isp_composer_handler,
+			 "AP ISP IPI", NULL);
+
+	if (!isp_ctx->composer_tx_thread.thread) {
+		mutex_init(&isp_ctx->composer_tx_lock);
+		init_waitqueue_head(&isp_ctx->composer_tx_thread.wq);
+		INIT_LIST_HEAD(&isp_ctx->composer_txlist.queue);
+		spin_lock_init(&isp_ctx->composer_txlist.lock);
+		isp_ctx->composer_tx_thread.thread =
+			kthread_run(isp_composer_tx_work, (void *)isp_ctx,
+				    "isp_composer_tx");
+		if (IS_ERR(isp_ctx->composer_tx_thread.thread)) {
+			dev_err(&pdev->dev, "unable to alloc workqueue\n");
+			ret = PTR_ERR(isp_ctx->composer_tx_thread.thread);
+			isp_ctx->composer_tx_thread.thread = NULL;
+			return ret;
+		}
+	}
+	isp_ctx->composer_txlist.queue_cnt = 0;
+
+	if (!isp_ctx->composer_event_thread.thread) {
+		init_waitqueue_head(&isp_ctx->composer_event_thread.wq);
+		INIT_LIST_HEAD(&isp_ctx->composer_eventlist.queue);
+		spin_lock_init(&isp_ctx->composer_eventlist.lock);
+		isp_ctx->composer_event_thread.thread =
+			kthread_run(isp_composer_rx_work, (void *)isp_ctx,
+				    "isp_composer_rx");
+		if (IS_ERR(isp_ctx->composer_event_thread.thread)) {
+			dev_err(&pdev->dev, "unable to alloc workqueue\n");
+			ret = PTR_ERR(isp_ctx->composer_event_thread.thread);
+			isp_ctx->composer_event_thread.thread = NULL;
+			return ret;
+		}
+	}
+	isp_ctx->composer_eventlist.queue_cnt = 0;
+
+	atomic_set(&isp_ctx->num_composing, 0);
+	atomic_set(&isp_ctx->num_frame_composing, 0);
+	atomic_set(&isp_ctx->vpu_state, VPU_ISP_STATE_BOOTING);
+	return ret;
+}
+
+void isp_composer_enqueue(struct mtk_isp_p1_ctx *isp_ctx,
+			  void *data,
+			  enum mtk_isp_vpu_ipi_type type)
+{
+	struct mtk_isp_queue_work *isp_composer_work = NULL;
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(isp_ctx);
+	struct platform_device *pdev = p1_dev->pdev;
+
+	isp_composer_work = kzalloc(sizeof(*isp_composer_work), GFP_KERNEL);
+	isp_composer_work->type = type;
+	switch (type) {
+	case VPU_ISP_CMD:
+		memcpy(&isp_composer_work->cmd, data,
+		       sizeof(isp_composer_work->cmd));
+
+		spin_lock(&isp_ctx->composer_txlist.lock);
+		list_add_tail(&isp_composer_work->list_entry,
+			      &isp_ctx->composer_txlist.queue);
+		isp_ctx->composer_txlist.queue_cnt++;
+		spin_unlock(&isp_ctx->composer_txlist.lock);
+
+		dev_dbg(&pdev->dev, "Enq ipi cmd id:%d\n",
+			isp_composer_work->cmd.cmd_id);
+		wake_up_interruptible(&isp_ctx->composer_tx_thread.wq);
+		break;
+	case VPU_ISP_FRAME:
+		memcpy(&isp_composer_work->frameparams, data,
+		       sizeof(isp_composer_work->frameparams));
+
+		spin_lock(&isp_ctx->composer_txlist.lock);
+		list_add_tail(&isp_composer_work->list_entry,
+			      &isp_ctx->composer_txlist.queue);
+		isp_ctx->composer_txlist.queue_cnt++;
+		spin_unlock(&isp_ctx->composer_txlist.lock);
+
+		dev_dbg(&pdev->dev, "Enq ipi frame_num:%d\n",
+			isp_composer_work->frameparams.frame_num);
+		wake_up_interruptible(&isp_ctx->composer_tx_thread.wq);
+		break;
+	default:
+		dev_err(&pdev->dev, "Unknown ipi type(%d)\n", type);
+		break;
+	}
+}
+
+void isp_composer_hw_init(struct mtk_isp_p1_ctx *isp_ctx)
+{
+	struct img_buffer frameparam;
+	struct mtk_isp_vpu_cmd composer_tx_cmd;
+
+	isp_ctx->isp_hw_module = ISP_CAM_B_IDX;
+	isp_composer_dma_sg_init(isp_ctx);
+	frameparam.pa = (u32)isp_ctx->scp_mem_pa;
+	frameparam.iova = (u32)isp_ctx->scp_mem_iova;
+
+	composer_tx_cmd.cmd_id = ISP_CMD_INIT;
+	composer_tx_cmd.drv_data = (__u64)isp_ctx;
+	composer_tx_cmd.frameparam.hw_module = isp_ctx->isp_hw_module;
+	memcpy(&composer_tx_cmd.frameparam.cq_addr,
+	       &frameparam, sizeof(struct img_buffer));
+	isp_composer_enqueue(isp_ctx, &composer_tx_cmd, VPU_ISP_CMD);
+}
+
+void isp_composer_hw_config(struct mtk_isp_p1_ctx *isp_ctx,
+			    struct p1_config_param *config_param)
+{
+	struct mtk_isp_vpu_cmd composer_tx_cmd;
+
+	memset(&composer_tx_cmd, 0, sizeof(composer_tx_cmd));
+	composer_tx_cmd.cmd_id = ISP_CMD_CONFIG;
+	composer_tx_cmd.drv_data = (__u64)isp_ctx;
+	memcpy(&composer_tx_cmd.cmd_data[0],
+	       config_param,
+	       sizeof(struct p1_config_param));
+	isp_composer_enqueue(isp_ctx, &composer_tx_cmd, VPU_ISP_CMD);
+}
+
+void isp_composer_stream(struct mtk_isp_p1_ctx *isp_ctx, int on)
+{
+	struct mtk_isp_vpu_cmd composer_tx_cmd;
+
+	memset(&composer_tx_cmd, 0, sizeof(composer_tx_cmd));
+	composer_tx_cmd.cmd_id = ISP_CMD_STREAM;
+	composer_tx_cmd.drv_data = (__u64)isp_ctx;
+	memcpy(&composer_tx_cmd.cmd_data[0], &on, sizeof(on));
+	isp_composer_enqueue(isp_ctx, &composer_tx_cmd, VPU_ISP_CMD);
+}
+
+void isp_composer_hw_deinit(struct mtk_isp_p1_ctx *isp_ctx,
+			    void (*donecb)(void *data))
+{
+	int dummy_val = 0;
+	struct mtk_isp_vpu_cmd composer_tx_cmd;
+
+	memset(&composer_tx_cmd, 0, sizeof(composer_tx_cmd));
+	composer_tx_cmd.cmd_id = ISP_CMD_DEINIT;
+	composer_tx_cmd.drv_data = (__u64)isp_ctx;
+	memcpy(&composer_tx_cmd.cmd_data[0], &dummy_val, sizeof(dummy_val));
+	isp_ctx->composer_deinit_donecb = donecb;
+	isp_composer_enqueue(isp_ctx, &composer_tx_cmd, VPU_ISP_CMD);
+}
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h
new file mode 100644
index 0000000..fbd9723
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Seraph Huang <seraph.huang@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _MTK_ISP_VPU_H
+#define _MTK_ISP_VPU_H
+
+#include <linux/types.h>
+
+#define MAX_IMG_DMA_PORT    2
+#define MAX_META_DMA_PORT   8
+#define MAX_META_DMA_NODES  2
+
+/* describes the maximum size of a payload */
+#define MTK_IPI_CMD_SIZE 272
+
+struct img_size {
+	__u32 w;        /* unit:pixel */
+	__u32 h;        /* unit:pixel */
+	__u32 stride;   /* unit:byte */
+	__u32 xsize;	/* unit:byte */
+} __packed;
+
+struct img_buffer {
+	/* used by DMA access */
+	__u32 iova;
+	/* used by external HW device */
+	__u32 pa;
+} __packed;
+
+struct p1_img_crop {
+	__u32 left;
+	__u32 top;
+	__u32 width;
+	__u32 height;
+} __packed;
+
+struct p1_img_output {
+	struct img_buffer buffer;
+	struct img_size size;
+	struct p1_img_crop crop;
+	__u8 dma_port;
+	__u8 pixel_byte;
+	__u32 img_fmt;
+} __packed;
+
+struct cfg_in_param {
+	__u8 continuous;
+	__u8 subsample;
+	__u8 pixel_mode;
+	__u8 data_pattern;
+	__u8 raw_pixel_id;
+	__u16 tg_fps;
+	__u32 img_fmt;
+	struct p1_img_crop crop;
+} __packed;
+
+struct cfg_main_out_param {
+	/* Bypass main out parameters */
+	__u8 bypass;
+	/* Control HW image raw path */
+	__u8 pure_raw;
+	/* Control HW image pack function */
+	__u8 pure_raw_pack;
+	struct p1_img_output output;
+} __packed;
+
+struct cfg_resize_out_param {
+	/* Bypass resize parameters */
+	__u8 bypass;
+	struct p1_img_output output;
+} __packed;
+
+struct cfg_meta_out_param {
+	__u8 meta_dmas[MAX_META_DMA_PORT];
+} __packed;
+
+struct p1_config_param {
+	/* TG info */
+	struct cfg_in_param cfg_in_param;
+    /* IMGO DMA */
+	struct cfg_main_out_param cfg_main_param;
+    /* RRZO DMA */
+	struct cfg_resize_out_param cfg_resize_param;
+    /* 3A DMAs and other. */
+	struct cfg_meta_out_param cfg_meta_param;
+} __packed;
+
+struct p1_frame_param {
+	/* frame serial number */
+	__u32 frame_num;
+	/* SOF index */
+	__u32 sof_idx;
+	/* The memory address of tuning buffer from user space */
+	struct img_buffer tuning_addr;
+	struct p1_img_output img_dma_buffers[MAX_IMG_DMA_PORT];
+	struct img_buffer meta_addrs[MAX_META_DMA_NODES];
+} __packed;
+
+// isp_ipi_frameparam
+struct isp_init_info {
+	__u8 hw_module;
+	struct img_buffer cq_addr;
+} __packed;
+
+// isp ipi ack
+struct isp_ack_info {
+	__u8 cmd_id;
+	__u32 frame_num;
+} __packed;
+
+enum mtk_isp_scp_CMD {
+	ISP_CMD_INIT,
+	ISP_CMD_CONFIG,
+	ISP_CMD_STREAM,
+	ISP_CMD_DEINIT,
+	ISP_CMD_ACK,
+	ISP_CMD_VPU_STATE,
+	ISP_CMD_FRAME_ACK,
+	ISP_CMD_RESERVED,
+};
+
+struct mtk_isp_vpu_cmd {
+	__u8 cmd_id;
+	__u64 drv_data;
+	union {
+		/* isp_ipi_frameparam */
+		struct isp_init_info frameparam;
+		struct p1_config_param config_param;
+		__u8 cmd_data[MTK_IPI_CMD_SIZE - sizeof(__u8) - sizeof(__u64)];
+		__u8 is_stream_on;
+		struct isp_ack_info ack_info;
+	};
+} __packed;
+
+enum mtk_isp_vpu_state {
+	VPU_ISP_STATE_INVALID = 0,
+	VPU_ISP_STATE_BOOTING,
+	VPU_ISP_STATE_RBREADY,
+};
+
+struct isp_vpu_param {
+	struct list_head list_entry;
+	struct mtk_isp_vpu_cmd cmd;
+};
+
+#endif /* _MTK_ISP_VPU_H */
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.c
new file mode 100644
index 0000000..064806e
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.c
@@ -0,0 +1,1235 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Ryan Yu <ryan.yu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/atomic.h>
+#include <linux/cdev.h>
+#include <linux/compat.h>
+#include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/sched/clock.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/vmalloc.h>
+
+#include "mtk_cam.h"
+#include "mtk_cam-regs.h"
+#include "mtk_cam-v4l2.h"
+#include "mtk_cam-ctx.h"
+#include "mtk_vpu.h"
+
+static const struct of_device_id mtk_isp_of_ids[] = {
+	{.compatible = "mediatek,mt8183-camisp",},
+	{}
+};
+
+/* list of clocks required by isp cam */
+static const char * const mtk_isp_clks[] = {
+	"CAMSYS_CAM_CGPDN", "CAMSYS_CAMTG_CGPDN"
+};
+
+static void isp_dumpdmastat(struct isp_device *isp_dev)
+{
+	dev_err(isp_dev->dev,
+		"IMGO:0x%x, RRZO:0x%x, AAO=0x%x, AFO=0x%x\n",
+		readl(isp_dev->regs + REG_IMGO_ERR_STAT),
+		readl(isp_dev->regs + REG_RRZO_ERR_STAT),
+		readl(isp_dev->regs + REG_AAO_ERR_STAT),
+		readl(isp_dev->regs + REG_AFO_ERR_STAT));
+	dev_err(isp_dev->dev,
+		"LCSO=0x%x, PSO=0x%x, FLKO=0x%x, BPCI:0x%x, LSCI=0x%x\n",
+		readl(isp_dev->regs + REG_LCSO_ERR_STAT),
+		readl(isp_dev->regs + REG_BPCI_ERR_STAT),
+		readl(isp_dev->regs + REG_LSCI_ERR_STAT),
+		readl(isp_dev->regs + REG_FLKO_ERR_STAT));
+}
+
+static void mtk_isp_notify(struct mtk_isp_p1_ctx *isp_ctx,
+			   unsigned int frame_id,
+			   unsigned int request_id,
+			   enum mtk_cam_ctx_frame_data_state state)
+{
+	struct mtk_isp_p1_drv_data *drv_data = p1_ctx_to_drv(isp_ctx);
+	struct device *dev = &drv_data->p1_dev.pdev->dev;
+	struct mtk_cam_ctx_finish_param fram_param;
+
+	fram_param.frame_id = frame_id;
+	fram_param.state = state;
+	fram_param.sequence = request_id;
+	dev_dbg(dev, "frame_id(%d) sequence(%d)\n",
+		fram_param.frame_id,
+		fram_param.sequence);
+	mtk_cam_ctx_core_job_finish(&drv_data->cam_dev.ctx, &fram_param);
+}
+
+static void isp_deque_work_queue(struct work_struct *work)
+{
+	struct mtk_isp_queue_job *isp_composer_work =
+	    container_of(work, struct mtk_isp_queue_job, frame_work);
+	struct isp_device *isp_dev = isp_composer_work->isp_dev;
+	struct isp_p1_device *p1_dev = get_p1_device(isp_dev->dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct device *dev = isp_dev->dev;
+	struct mtk_cam_ctx *dev_ctx = &(p1_ctx_to_drv(isp_ctx))->cam_dev.ctx;
+	struct mtk_cam_dev_stat_event_data event_data;
+	struct mtk_isp_queue_job *framejob, *tmp;
+	unsigned long flags;
+	int request_num = isp_composer_work->request_num;
+
+	/* Pull dequeue work of irq event or ready frame */
+	spin_lock_irqsave(&isp_ctx->p1_dequeue_list.lock, flags);
+	isp_composer_work =
+			list_first_entry
+				(&isp_ctx->p1_dequeue_list.queue,
+				 struct mtk_isp_queue_job,
+				 list_entry);
+	list_del(&isp_composer_work->list_entry);
+	isp_ctx->p1_dequeue_list.queue_cnt--;
+	spin_unlock_irqrestore(&isp_ctx->p1_dequeue_list.lock, flags);
+
+	/* Notify specific HW events to user space */
+	if ((isp_composer_work->irq_status & (VS_INT_ST | SW_PASS1_DON_ST)) |
+		(isp_composer_work->dma_status & (AFO_DONE_ST))) {
+		event_data.frame_number = isp_dev->sof_count;
+		event_data.irq_status_mask = isp_composer_work->irq_status;
+		event_data.dma_status_mask = isp_composer_work->dma_status;
+		mtk_cam_ctx_queue_event_dev_state(dev_ctx,
+						  &event_data);
+		dev_dbg(dev, "event IRQ(0x%x) DMA(0x%x) is sent\n",
+			event_data.irq_status_mask,
+			event_data.dma_status_mask);
+	}
+
+    /* Only handle SW_PASS1_DONE_ST ISR event */
+	if (!(isp_composer_work->irq_status & SW_PASS1_DON_ST)) {
+		kfree(isp_composer_work);
+		return;
+	}
+
+	/* Match dequeue work and enqueue frame */
+	spin_lock(&isp_ctx->p1_enqueue_list.lock);
+	list_for_each_entry_safe(framejob, tmp, &isp_ctx->p1_enqueue_list.queue,
+				 list_entry) {
+		dev_dbg(dev, "%s req_num=%d, isp_composer_work->req_num=%d\n",
+			__func__, framejob->request_num, request_num);
+		/* Match by the en-queued request number */
+		if (framejob->request_num == request_num) {
+			/* Pass to user space */
+			mtk_isp_notify(isp_ctx,
+				       framejob->frame_id,
+				       framejob->request_num,
+				       MTK_CAM_CTX_FRAME_DATA_DONE);
+			isp_ctx->p1_enqueue_list.queue_cnt--;
+			dev_dbg(dev,
+				"frame(request_num=%d) is finished, queue_cnt(%d)\n",
+				framejob->request_num,
+				isp_ctx->p1_enqueue_list.queue_cnt);
+
+			/* remove only when frame ready */
+			list_del(&framejob->list_entry);
+			kfree(framejob);
+			break;
+		} else if (framejob->request_num < request_num) {
+			/* Pass to user space for frame drop */
+			mtk_isp_notify(isp_ctx,
+				       framejob->frame_id,
+				       framejob->request_num,
+				       MTK_CAM_CTX_FRAME_DATA_ERROR);
+			isp_ctx->p1_enqueue_list.queue_cnt--;
+			dev_dbg(dev, "frame(request_num=%d) drop, queue_cnt(%d)\n",
+				framejob->request_num,
+				isp_ctx->p1_enqueue_list.queue_cnt);
+
+			/* remove only drop frame */
+			list_del(&framejob->list_entry);
+			kfree(framejob);
+		}
+	}
+	kfree(isp_composer_work);
+	spin_unlock(&isp_ctx->p1_enqueue_list.lock);
+}
+
+static int irq_handle_sof(struct isp_device *isp_dev,
+			  dma_addr_t base_addr,
+			  unsigned int frame_num)
+{
+	unsigned int cq_addr_index;
+	struct isp_p1_device *p1_dev = get_p1_device(isp_dev->dev);
+	int cq_num = atomic_read(&p1_dev->isp_ctx.composed_frame_id);
+
+	if (cq_num > frame_num) {
+		cq_addr_index = frame_num % CQ_BUFFER_COUNT;
+
+		writel(base_addr +
+			(phys_addr_t)(CQ_ADDRESS_OFFSET * cq_addr_index),
+			isp_dev->regs + REG_CQ_THR0_BASEADDR);
+		dev_dbg(isp_dev->dev,
+			"SOF_INT_ST cq_num:%d, frame_num:%d cq_addr:%d",
+			cq_num, frame_num, cq_addr_index);
+	} else {
+		dev_dbg(isp_dev->dev,
+			"SOF_INT_ST cq_num:%d, frame_num:%d",
+			cq_num, frame_num);
+	}
+
+	isp_dev->sof_count += 1;
+
+	return cq_num;
+}
+
+static int irq_handle_notify_event(struct isp_device *isp_dev,
+				   unsigned int irqstatus,
+				   unsigned int dmastatus)
+{
+	struct isp_p1_device *p1_dev = get_p1_device(isp_dev->dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct mtk_isp_queue_job *isp_composer_work = NULL;
+	unsigned long flags;
+
+	isp_composer_work = kzalloc(sizeof(*isp_composer_work), GFP_ATOMIC);
+
+	isp_composer_work->isp_dev = isp_dev;
+	isp_composer_work->request_num = isp_dev->current_frame;
+	isp_composer_work->irq_status = (irqstatus & INT_ST_MASK_CAM);
+	isp_composer_work->dma_status = (dmastatus & DMA_ST_MASK_CAM);
+
+	spin_lock_irqsave(&isp_ctx->p1_dequeue_list.lock, flags);
+	list_add_tail(&isp_composer_work->list_entry,
+		      &isp_ctx->p1_dequeue_list.queue);
+	isp_ctx->p1_dequeue_list.queue_cnt++;
+	INIT_WORK(&isp_composer_work->frame_work, isp_deque_work_queue);
+	queue_work(isp_ctx->p1_dequeue_workq, &isp_composer_work->frame_work);
+	spin_unlock_irqrestore(&isp_ctx->p1_dequeue_list.lock, flags);
+
+	dev_dbg(isp_dev->dev,
+		"%s notify IRQ status (0x%x) DMA status (0x%x) for req_num: %d\n",
+		__func__,
+		isp_composer_work->irq_status,
+		isp_composer_work->dma_status,
+		isp_composer_work->request_num);
+
+	return 0;
+}
+
+irqreturn_t isp_irq_cam(int irq, void *data)
+{
+	struct isp_device *isp_dev = (struct isp_device *)data;
+	struct isp_p1_device *p1_dev = get_p1_device(isp_dev->dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct device *dev = isp_dev->dev;
+	unsigned int cardinalnum = 0, cq_num = 0, hw_frame_num = 0;
+	unsigned int irqstatus, errstatus, warnstatus, dmastatus;
+	unsigned long flags;
+	int stream_on = atomic_read(&isp_ctx->isp_stream_cnt);
+
+	/* Check the streaming is off or not */
+	if (stream_on == 0)
+		return IRQ_HANDLED;
+
+	cardinalnum = isp_dev->isp_hw_module - ISP_CAM_A_IDX;
+
+	spin_lock_irqsave(&isp_dev->spinlock_irq, flags);
+	irqstatus = readl(isp_dev->regs + REG_CTL_RAW_INT_STAT);
+	dmastatus =	readl(isp_dev->regs + REG_CTL_RAW_INT2_STAT);
+	hw_frame_num = readl(isp_dev->regs + REG_HW_FRAME_NUM);
+	spin_unlock_irqrestore(&isp_dev->spinlock_irq, flags);
+
+    /* Ignore unnecessary IRQ */
+	if (irqstatus == 0)
+		return IRQ_HANDLED;
+
+	errstatus = irqstatus & INT_ST_MASK_CAM_ERR;
+	warnstatus = irqstatus & INT_ST_MASK_CAM_WARN;
+	irqstatus = irqstatus & INT_ST_MASK_CAM;
+
+	/* sof , done order chech . */
+	spin_lock_irqsave(&isp_dev->spinlock_irq, flags);
+	if ((irqstatus & HW_PASS1_DON_ST) && (irqstatus & SOF_INT_ST)) {
+		dev_warn(dev,
+			 "isp sof_don block, %d\n",
+			 isp_dev->sof_count);
+
+		/* notify IRQ event and enque ready frame */
+		irq_handle_notify_event(isp_dev, irqstatus, dmastatus);
+		isp_dev->current_frame = hw_frame_num;
+	} else {
+		if (irqstatus & SOF_INT_ST)
+			isp_dev->current_frame = hw_frame_num;
+
+		if ((irqstatus & INT_ST_MASK_CAM) ||
+		    (dmastatus & DMA_ST_MASK_CAM))
+			irq_handle_notify_event(isp_dev, irqstatus, dmastatus);
+	}
+	spin_unlock_irqrestore(&isp_dev->spinlock_irq, flags);
+
+	if (irqstatus & SOF_INT_ST)
+		cq_num = irq_handle_sof(isp_dev, isp_ctx->scp_mem_iova,
+					hw_frame_num);
+
+	if (irqstatus & SW_PASS1_DON_ST) {
+		int num = atomic_read(&isp_ctx->num_frame_composing);
+
+		if (num > 0) {
+			dev_dbg(dev, "SW_PASS1_DON_ST queued frame:%d\n", num);
+			atomic_dec_return(&isp_ctx->num_frame_composing);
+			/* Notify TX thread to send if TX frame is blocked */
+			if (num >= ISP_FRAME_COMPOSING_MAX_NUM)
+				wake_up_interruptible
+					(&isp_ctx->composer_tx_thread.wq);
+		}
+	}
+
+	/* check ISP error status */
+	if (errstatus) {
+		dev_err(dev,
+			"raw_int_err:0x%x_0x%x, raw_int3_err:0x%x\n",
+			warnstatus, errstatus);
+
+		/* show DMA errors in detail */
+		if (errstatus & DMA_ERR_ST)
+			isp_dumpdmastat(isp_dev);
+	}
+
+	if (irqstatus & INT_ST_LOG_MASK_CAM)
+		dev_dbg(dev, IRQ_STAT_STR,
+			'A' + cardinalnum,
+			isp_dev->sof_count,
+			irqstatus,
+			dmastatus,
+			hw_frame_num,
+			cq_num);
+	return IRQ_HANDLED;
+}
+
+static int enable_sys_clock(struct isp_p1_device *p1_dev)
+{
+	struct device *dev = &p1_dev->pdev->dev;
+	int ret;
+
+	dev_info(dev, "- %s dev id:%d\n", __func__, dev->id);
+
+	ret = clk_bulk_prepare_enable(p1_dev->isp_clk.num_clks,
+				      p1_dev->isp_clk.clk_list);
+	if (ret < 0)
+		goto clk_err;
+	return 0;
+clk_err:
+	dev_err(dev, "cannot pre-en isp_cam clock:%d\n", ret);
+	clk_bulk_disable_unprepare(p1_dev->isp_clk.num_clks,
+				   p1_dev->isp_clk.clk_list);
+	return ret;
+}
+
+static void disable_sys_clock(struct isp_p1_device *p1_dev)
+{
+	struct device *dev = &p1_dev->pdev->dev;
+
+	dev_info(dev, "- %s dev id:%d\n", __func__, dev->id);
+	clk_bulk_disable_unprepare(p1_dev->isp_clk.num_clks,
+				   p1_dev->isp_clk.clk_list);
+}
+
+static struct mtk_cam_ctx_desc mtk_cam_ctx_desc_p1 = {
+	"proc_device_camisp", mtk_cam_ctx_p1_init,};
+
+static int mtk_isp_probe(struct platform_device *pdev)
+{
+	struct mtk_isp_p1_drv_data *drv_data;
+	struct isp_p1_device *p1_dev = NULL;
+	struct mtk_isp_p1_ctx *isp_ctx;
+	struct isp_device *isp_dev = NULL;
+	struct device *dev = &pdev->dev;
+	struct resource *res = NULL;
+	int ret = 0;
+	int i = 0;
+
+	/* Allocate context */
+	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, drv_data);
+	p1_dev = &drv_data->p1_dev;
+	isp_ctx = &p1_dev->isp_ctx;
+	p1_dev->pdev = pdev;
+	p1_dev->isp_devs =
+		devm_kzalloc(dev,
+			     sizeof(struct isp_device) * ISP_DEV_NODE_NUM,
+			     GFP_KERNEL);
+	if (!p1_dev->isp_devs)
+		return -ENOMEM;
+
+	/* iomap registers */
+	for (i = ISP_CAMSYS_CONFIG_IDX; i < ISP_DEV_NODE_NUM; i++) {
+		isp_dev = &p1_dev->isp_devs[i + 1];
+		isp_dev->isp_hw_module = i;
+		isp_dev->dev = dev;
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		isp_dev->regs = devm_ioremap_resource(dev, res);
+
+		dev_info(dev, "cam%u, map_addr=0x%lx\n",
+			 i, (unsigned long)isp_dev->regs);
+
+		if (!isp_dev->regs)
+			return PTR_ERR(isp_dev->regs);
+
+		/* support IRQ from ISP_CAM_A_IDX */
+		if (i >= ISP_CAM_A_IDX) {
+			/* reg & interrupts index is shifted with 1  */
+			isp_dev->irq = platform_get_irq(pdev, i - 1);
+			if (isp_dev->irq > 0) {
+				ret = devm_request_irq(dev, isp_dev->irq,
+						       isp_irq_cam,
+						       IRQF_SHARED,
+						       dev_driver_string(dev),
+						       (void *)isp_dev);
+				if (ret) {
+					dev_err(dev,
+						"request_irq fail, dev(%s) irq=%d\n",
+						dev->of_node->name,
+						isp_dev->irq);
+					return ret;
+				}
+				dev_info(dev, "Registered irq=%d, ISR: %s\n",
+					 isp_dev->irq, dev_driver_string(dev));
+			}
+		}
+		spin_lock_init(&isp_dev->spinlock_irq);
+	}
+
+	p1_dev->isp_clk.num_clks = ARRAY_SIZE(mtk_isp_clks);
+	p1_dev->isp_clk.clk_list =
+		devm_kcalloc(dev,
+			     p1_dev->isp_clk.num_clks,
+			     sizeof(*p1_dev->isp_clk.clk_list),
+			     GFP_KERNEL);
+	if (!p1_dev->isp_clk.clk_list)
+		return -ENOMEM;
+
+	for (i = 0; i < p1_dev->isp_clk.num_clks; ++i)
+		p1_dev->isp_clk.clk_list->id = mtk_isp_clks[i];
+
+	ret = devm_clk_bulk_get(dev,
+				p1_dev->isp_clk.num_clks,
+				p1_dev->isp_clk.clk_list);
+	if (ret) {
+		dev_err(dev, "cannot get isp cam clock:%d\n", ret);
+		return ret;
+	}
+
+	/* initialize the v4l2 common part */
+	ret = mtk_cam_dev_core_init(pdev, &drv_data->cam_dev,
+				    &mtk_cam_ctx_desc_p1);
+	if (ret)
+		return ret;
+
+	spin_lock_init(&isp_ctx->p1_enqueue_list.lock);
+	spin_lock_init(&isp_ctx->p1_dequeue_list.lock);
+	atomic_set(&p1_dev->isp_ctx.isp_user_cnt, 0);
+	pm_runtime_enable(dev);
+
+	return 0;
+}
+
+static int mtk_isp_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mtk_isp_p1_drv_data *drv_data = dev_get_drvdata(dev);
+
+	pm_runtime_disable(dev);
+	mtk_cam_dev_core_release(pdev, &drv_data->cam_dev);
+
+	return 0;
+}
+
+static int mtk_isp_suspend(struct device *dev)
+{
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct isp_device *isp_dev;
+	unsigned int reg_val;
+	int usercount, module;
+
+	module = p1_dev->isp_ctx.isp_hw_module;
+	usercount = atomic_read(&p1_dev->isp_ctx.isp_user_cnt);
+
+	dev_dbg(dev, "- %s:%d\n", __func__, usercount);
+
+	/* If no user count, no further action */
+	if (!usercount)
+		return 0;
+
+	isp_dev = &p1_dev->isp_devs[module];
+	reg_val = readl(isp_dev->regs + REG_TG_VF_CON);
+	if (reg_val & VFDATA_EN_BIT) {
+		dev_dbg(dev, "Cam:%d suspend, disable VF\n", module);
+		/* disable VF */
+		writel((reg_val & (~VFDATA_EN_BIT)),
+		       isp_dev->regs + REG_TG_VF_CON);
+		/*
+		 * After VF enable, The TG frame count will be reset to 0;
+		 */
+		reg_val = readl(isp_dev->regs + REG_TG_SEN_MODE);
+		writel((reg_val & (~CMOS_EN_BIT)),
+		       isp_dev->regs +  + REG_TG_SEN_MODE);
+	}
+
+	disable_sys_clock(p1_dev);
+
+	return 0;
+}
+
+static int mtk_isp_resume(struct device *dev)
+{
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct isp_device *isp_dev;
+	unsigned int reg_val;
+	int module, usercount, streamon;
+
+	module = p1_dev->isp_ctx.isp_hw_module;
+	usercount = atomic_read(&p1_dev->isp_ctx.isp_user_cnt);
+
+	dev_dbg(dev, "- %s:%d\n", __func__, usercount);
+
+	/* If no user count, no further action */
+	if (!usercount)
+		return 0;
+
+	enable_sys_clock(p1_dev);
+
+	streamon = atomic_read(&p1_dev->isp_ctx.isp_stream_cnt);
+	if (streamon) {
+		isp_dev = &p1_dev->isp_devs[module];
+		dev_dbg(dev, "Cam:%d resume,enable VF\n", module);
+		/* Enable CMOS */
+		reg_val = readl(isp_dev->regs + REG_TG_SEN_MODE);
+		writel((reg_val | CMOS_EN_BIT),
+		       isp_dev->regs + REG_TG_SEN_MODE);
+		/* Enable VF */
+		reg_val = readl(isp_dev->regs + REG_TG_VF_CON);
+		writel((reg_val | VFDATA_EN_BIT),
+		       isp_dev->regs + REG_TG_VF_CON);
+	}
+	return 0;
+}
+
+static int isp_init_context(struct isp_p1_device *p1_dev)
+{
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	int ret = 0, i;
+
+	isp_ctx->p1_dequeue_workq =
+		create_singlethread_workqueue("isp_dequeue");
+	if (!isp_ctx->p1_dequeue_workq) {
+		ret = -ENOMEM;
+		destroy_workqueue(isp_ctx->p1_dequeue_workq);
+		return ret;
+	}
+
+	INIT_LIST_HEAD(&isp_ctx->p1_enqueue_list.queue);
+	isp_ctx->p1_enqueue_list.queue_cnt = 0;
+
+	INIT_LIST_HEAD(&isp_ctx->p1_dequeue_list.queue);
+	isp_ctx->p1_dequeue_list.queue_cnt = 0;
+
+	for (i = 0; i < ISP_DEV_NODE_NUM; i++)
+		spin_lock_init(&p1_dev->isp_devs[i].spinlock_irq);
+
+	spin_lock_init(&isp_ctx->p1_enqueue_list.lock);
+	spin_lock_init(&isp_ctx->p1_dequeue_list.lock);
+	spin_lock_init(&isp_ctx->composer_txlist.lock);
+	spin_lock_init(&isp_ctx->composer_eventlist.lock);
+
+	return ret;
+}
+
+static int isp_uninit_context(struct isp_p1_device *p1_dev)
+{
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct mtk_isp_queue_job *framejob, *tmp_framejob;
+	unsigned long flags;
+
+	flush_workqueue(isp_ctx->p1_dequeue_workq);
+	destroy_workqueue(isp_ctx->p1_dequeue_workq);
+	isp_ctx->p1_dequeue_workq = NULL;
+
+	spin_lock_irq(&isp_ctx->p1_enqueue_list.lock);
+	list_for_each_entry_safe(framejob, tmp_framejob,
+				 &isp_ctx->p1_enqueue_list.queue, list_entry) {
+		list_del(&framejob->list_entry);
+		kfree(framejob);
+	}
+	isp_ctx->p1_enqueue_list.queue_cnt = 0;
+	spin_unlock_irq(&isp_ctx->p1_enqueue_list.lock);
+
+	spin_lock_irqsave(&isp_ctx->p1_dequeue_list.lock, flags);
+	list_for_each_entry_safe(framejob, tmp_framejob,
+				 &isp_ctx->p1_dequeue_list.queue, list_entry) {
+		list_del(&framejob->list_entry);
+		kfree(framejob);
+	}
+	isp_ctx->p1_dequeue_list.queue_cnt = 0;
+	spin_unlock_irqrestore(&isp_ctx->p1_dequeue_list.lock, flags);
+
+	atomic_set(&isp_ctx->isp_user_cnt, 0);
+	atomic_set(&isp_ctx->isp_stream_cnt, 0);
+
+	return 0;
+}
+
+/******* Utility ***********/
+static unsigned int get_sensor_pixel_id(unsigned int fmt)
+{
+	switch (fmt) {
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SBGGR14_1X14:
+		return raw_pxl_id_b;
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGBRG14_1X14:
+		return raw_pxl_id_gb;
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG14_1X14:
+		return raw_pxl_id_gr;
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SRGGB14_1X14:
+		return raw_pxl_id_r;
+	default:
+		return raw_pxl_id_b;
+	}
+}
+
+static unsigned int get_sensor_fmt(unsigned int fmt)
+{
+	switch (fmt) {
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+		return img_fmt_bayer8;
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+		return img_fmt_bayer10;
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
+		return img_fmt_bayer12;
+	case MEDIA_BUS_FMT_SBGGR14_1X14:
+	case MEDIA_BUS_FMT_SGBRG14_1X14:
+	case MEDIA_BUS_FMT_SGRBG14_1X14:
+	case MEDIA_BUS_FMT_SRGGB14_1X14:
+		return img_fmt_bayer14;
+	default:
+		return img_fmt_unknown;
+	}
+}
+
+static unsigned int get_img_fmt(unsigned int fourcc)
+{
+	switch (fourcc) {
+	case V4L2_PIX_FMT_MTISP_B8:
+		return img_fmt_bayer8;
+	case V4L2_PIX_FMT_MTISP_F8:
+		return img_fmt_fg_bayer8;
+	case V4L2_PIX_FMT_MTISP_B10:
+		return img_fmt_bayer10;
+	case V4L2_PIX_FMT_MTISP_F10:
+		return img_fmt_fg_bayer10;
+	case V4L2_PIX_FMT_MTISP_B12:
+		return img_fmt_bayer12;
+	case V4L2_PIX_FMT_MTISP_F12:
+		return img_fmt_fg_bayer12;
+	case V4L2_PIX_FMT_MTISP_B14:
+		return img_fmt_bayer14;
+	case V4L2_PIX_FMT_MTISP_F14:
+		return img_fmt_fg_bayer14;
+	default:
+		return img_fmt_unknown;
+	}
+}
+
+static unsigned int get_pixel_byte(unsigned int fourcc)
+{
+	switch (fourcc) {
+	case V4L2_PIX_FMT_MTISP_U8:
+	case V4L2_PIX_FMT_MTISP_B8:
+	case V4L2_PIX_FMT_MTISP_F8:
+		return 8;
+	case V4L2_PIX_FMT_MTISP_U10:
+	case V4L2_PIX_FMT_MTISP_B10:
+	case V4L2_PIX_FMT_MTISP_F10:
+		return 10;
+	case V4L2_PIX_FMT_MTISP_U12:
+	case V4L2_PIX_FMT_MTISP_B12:
+	case V4L2_PIX_FMT_MTISP_F12:
+		return 12;
+	case V4L2_PIX_FMT_MTISP_U14:
+	case V4L2_PIX_FMT_MTISP_B14:
+	case V4L2_PIX_FMT_MTISP_F14:
+		return 14;
+	default:
+		return 10;
+	}
+}
+
+static unsigned int query_imgo_pix_mode_align_size(unsigned int size,
+						   unsigned int pix_mode)
+{
+	switch (pix_mode) {
+	case default_pixel_mode:
+	case four_pixel_mode:
+		return ALIGN(size, 8);
+	case two_pixel_mode:
+		return ALIGN(size, 4);
+	case one_pixel_mode:
+		return ALIGN(size, 2);
+	default:
+		break;
+	}
+	return 0;
+}
+
+static unsigned int query_rrzo_pix_mode_align_size(unsigned int size,
+						   unsigned int pix_mode,
+						   unsigned int img_format)
+{
+	switch (pix_mode) {
+	case default_pixel_mode:
+	case four_pixel_mode:
+		return ALIGN(size, 16);
+	case two_pixel_mode:
+		return ALIGN(size, 8);
+	case one_pixel_mode:
+		if (img_format == img_fmt_fg_bayer10)
+			return ALIGN(size, 4);
+		else
+			return ALIGN(size, 8);
+	default:
+		return ALIGN(size, 16);
+	}
+	return 0;
+}
+
+static bool query_imgo_constraint(struct device *dev,
+				  unsigned int img_width,
+				  unsigned int img_format,
+				  u8 pix_mode,
+				  unsigned int *stride)
+{
+	img_width = ALIGN(img_width, 4);
+
+	switch (img_format) {
+	case img_fmt_bayer8:
+		*stride = img_width;
+		break;
+	case img_fmt_bayer10:
+		*stride = ALIGN(DIV_ROUND_UP(img_width * 10, 8), 2);
+		break;
+	case img_fmt_bayer12:
+		*stride = ALIGN(DIV_ROUND_UP(img_width * 12, 8), 2);
+		break;
+	default:
+		*stride = 0;
+		dev_err(dev, "no support img_format(0x%0x)", img_format);
+		return false;
+	}
+
+	/* expand stride, instead of shrink width */
+	*stride = query_imgo_pix_mode_align_size(*stride, pix_mode);
+
+	dev_dbg(dev,
+		"%s: img_width(%d), img_format(0x%0x), pix_mode(%d), stride(%d)\n",
+		__func__, img_width, img_format, pix_mode, *stride);
+	return true;
+}
+
+static bool query_rrzo_constraint(struct device *dev,
+				  unsigned int img_width,
+				  unsigned int img_format,
+				  u8 pix_mode,
+				  unsigned int *stride)
+{
+	img_width = ALIGN(img_width, 4);
+	*stride = DIV_ROUND_UP(img_width * 3, 2);
+
+	switch (img_format) {
+	case img_fmt_fg_bayer10:
+		*stride = DIV_ROUND_UP(*stride * 10, 8);
+		break;
+	case img_fmt_fg_bayer12:
+		*stride = DIV_ROUND_UP(*stride * 12, 8);
+		break;
+	default:
+		*stride = 0;
+		dev_dbg(dev, "rrzo no support img_format(%d)",
+			img_format);
+		return false;
+	}
+
+	/* expand stride, instead of shrink width */
+	*stride = query_rrzo_pix_mode_align_size(*stride, pix_mode,
+						 img_format);
+
+	dev_dbg(dev,
+		"%s: img_width(%d), img_format(0x%0x), pix_mode(%d), stride(%d)\n",
+		__func__, img_width, img_format, pix_mode, *stride);
+	return true;
+}
+
+static void composer_deinit_done_cb(void *data)
+{
+	struct isp_p1_device *p1_dev = p1_ctx_to_dev(data);
+
+	disable_sys_clock(p1_dev);
+	/* Notify PM */
+	pm_runtime_put_sync(&p1_dev->pdev->dev);
+}
+
+/******* ISP P1 Interface ***********/
+int mtk_isp_open(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	s32 usercount = atomic_inc_return(&isp_ctx->isp_user_cnt);
+	int ret = 0;
+
+	dev_dbg(&pdev->dev,
+		"%s, open isp_dev = 0x%p, usercount=%d\n",
+		__func__, p1_dev, usercount);
+
+	if (usercount == 1) {
+		p1_dev->vpu_pdev = vpu_get_plat_device(p1_dev->pdev);
+		if (!p1_dev->vpu_pdev) {
+			dev_err(&p1_dev->pdev->dev,
+				"Failed to get VPU device\n");
+			return -EINVAL;
+		}
+
+		ret = vpu_load_firmware(p1_dev->vpu_pdev);
+		if (ret < 0) {
+			/*
+			 * Return 0 if downloading firmware successfully,
+			 * otherwise it is failed
+			 */
+			dev_err(&p1_dev->pdev->dev,
+				"vpu_load_firmware failed\n");
+			return -EINVAL;
+		}
+
+		isp_init_context(p1_dev);
+		/* Notify PM */
+		pm_runtime_get_sync(&pdev->dev);
+
+		if (isp_composer_init(isp_ctx) < 0) {
+			dev_err(&pdev->dev, "isp_composer_init fail\n");
+			return -1;
+		}
+
+		/*ISP HW INIT */
+		isp_ctx->isp_hw_module = ISP_CAM_B_IDX;
+		isp_composer_hw_init(isp_ctx);
+	}
+	dev_dbg(&pdev->dev, "usercount = %d\n", usercount);
+	return ret;
+}
+EXPORT_SYMBOL(mtk_isp_open);
+
+int mtk_isp_release(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	int ret = 0;
+
+	if (atomic_dec_and_test(&p1_dev->isp_ctx.isp_user_cnt)) {
+		isp_composer_hw_deinit(isp_ctx, composer_deinit_done_cb);
+		isp_uninit_context(p1_dev);
+	}
+	dev_dbg(dev, "%s usercount = %d\n", __func__,
+		atomic_read(&p1_dev->isp_ctx.isp_user_cnt));
+
+	return ret;
+}
+EXPORT_SYMBOL(mtk_isp_release);
+
+int mtk_isp_prepare(struct platform_device *pdev,
+		    struct mtk_cam_ctx_open_param *param)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	int ret = 0;
+
+	isp_ctx->enabled_dma_ports = param->enabled_dma_ports;
+
+	dev_dbg(dev, "%s, enabled_dma_ports(0x%x)\n", __func__,
+		isp_ctx->enabled_dma_ports);
+	return ret;
+}
+EXPORT_SYMBOL(mtk_isp_prepare);
+
+int mtk_isp_streamon(struct platform_device *pdev, u16 id)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct mtk_cam_ctx *dev_ctx = &(p1_ctx_to_drv(isp_ctx))->cam_dev.ctx;
+	struct p1_config_param config_param;
+	struct mtk_cam_dev *cam_dev = mtk_cam_ctx_to_dev(dev_ctx);
+	struct mtk_cam_io_connection *cio = &cam_dev->cio;
+	struct v4l2_subdev_format sd_format;
+	int sensor_ret = 0;
+	s32 count;
+	int enable_dma = 0, i = 0;
+
+	p1_dev->isp_devs[isp_ctx->isp_hw_module].current_frame = 0;
+	p1_dev->isp_devs[isp_ctx->isp_hw_module].sof_count = 0;
+
+	isp_ctx->isp_frame_cnt = 1;
+	atomic_set(&isp_ctx->composed_frame_id, 0);
+
+	/* Config CQ */
+	enable_dma = isp_ctx->enabled_dma_ports;
+
+	/* sensor config */
+	sd_format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	sensor_ret = v4l2_subdev_call(cio->sensor,
+				      pad, get_fmt, NULL, &sd_format);
+
+	if (sensor_ret) {
+		dev_dbg(dev, "sensor(%s) g_fmt on failed(%d)\n",
+			cio->sensor->entity.name, sensor_ret);
+		return -EPERM;
+	}
+
+	dev_dbg(dev,
+		"sensor get_fmt ret=%d, w=%d, h=%d, code=0x%x, field=%d, color=%d\n",
+		sensor_ret, sd_format.format.width, sd_format.format.height,
+		sd_format.format.code, sd_format.format.field,
+		sd_format.format.colorspace);
+
+	config_param.cfg_in_param.continuous = 0x1;
+	config_param.cfg_in_param.subsample = 0x0;
+	/* fix to one pixel mode in default */
+	config_param.cfg_in_param.pixel_mode = one_pixel_mode;
+	/* support noraml pattern in default */
+	config_param.cfg_in_param.data_pattern = 0x0;
+
+	config_param.cfg_in_param.crop.left = 0x0;
+	config_param.cfg_in_param.crop.top = 0x0;
+
+	config_param.cfg_in_param.raw_pixel_id =
+		get_sensor_pixel_id(sd_format.format.code);
+	config_param.cfg_in_param.img_fmt =
+		get_sensor_fmt(sd_format.format.code);
+	config_param.cfg_in_param.crop.width = sd_format.format.width;
+	config_param.cfg_in_param.crop.height = sd_format.format.height;
+
+	if ((enable_dma & R_IMGO) == R_IMGO) {
+		unsigned int stride = 0;
+		struct mtk_cam_ctx_queue imgo_ctx_queue =
+			dev_ctx->queue[MTK_CAM_CTX_P1_MAIN_STREAM_OUT];
+
+		config_param.cfg_main_param.pure_raw = 1;
+		config_param.cfg_main_param.pure_raw_pack = 1;
+		config_param.cfg_main_param.bypass = 0;
+
+		config_param.cfg_main_param.output.dma_port = 6;
+		config_param.cfg_main_param.output.img_fmt =
+			get_img_fmt(imgo_ctx_queue.fmt.pix_mp.pixelformat);
+		config_param.cfg_main_param.output.pixel_byte =
+			get_pixel_byte(imgo_ctx_queue.fmt.pix_mp.pixelformat);
+		config_param.cfg_main_param.output.size.w =
+			imgo_ctx_queue.fmt.pix_mp.width;
+		config_param.cfg_main_param.output.size.h =
+			imgo_ctx_queue.fmt.pix_mp.height;
+
+		query_imgo_constraint
+			(&pdev->dev,
+			 config_param.cfg_main_param.output.size.w,
+			 config_param.cfg_main_param.output.img_fmt,
+			 config_param.cfg_in_param.pixel_mode,
+			 &stride);
+		config_param.cfg_main_param.output.size.stride = stride;
+		config_param.cfg_main_param.output.size.xsize = stride;
+
+		config_param.cfg_main_param.output.crop.left = 0x0;
+		config_param.cfg_main_param.output.crop.top = 0x0;
+
+		config_param.cfg_main_param.output.crop.width =
+				config_param.cfg_main_param.output.size.w;
+		config_param.cfg_main_param.output.crop.height =
+				config_param.cfg_main_param.output.size.h;
+
+		dev_dbg(dev,
+			"imgo pixel_byte:%d img_fmt:0x%x\n",
+			config_param.cfg_main_param.output.pixel_byte,
+			config_param.cfg_main_param.output.img_fmt);
+		dev_dbg(dev,
+			"imgo param:size=(%0dx%0d),stride:%d,xsize:%d,crop=(%0dx%0d)\n",
+			config_param.cfg_main_param.output.size.w,
+			config_param.cfg_main_param.output.size.h,
+			config_param.cfg_main_param.output.size.stride,
+			config_param.cfg_main_param.output.size.xsize,
+			config_param.cfg_main_param.output.crop.width,
+			config_param.cfg_main_param.output.crop.height);
+	} else {
+		config_param.cfg_main_param.bypass = 1;
+	}
+
+	if ((enable_dma & R_RRZO) == R_RRZO) {
+		unsigned int stride = 0;
+		struct mtk_cam_ctx_queue rrzo_ctx_queue =
+			dev_ctx->queue[MTK_CAM_CTX_P1_PACKED_BIN_OUT];
+
+		config_param.cfg_resize_param.bypass = 0;
+		/* EPortIndex_RRZO */
+		config_param.cfg_resize_param.output.dma_port = 8;
+		config_param.cfg_resize_param.output.img_fmt =
+			get_img_fmt(rrzo_ctx_queue.fmt.pix_mp.pixelformat);
+		config_param.cfg_resize_param.output.pixel_byte =
+			get_pixel_byte(rrzo_ctx_queue.fmt.pix_mp.pixelformat);
+		config_param.cfg_resize_param.output.size.w =
+					rrzo_ctx_queue.fmt.pix_mp.width;
+		config_param.cfg_resize_param.output.size.h =
+					rrzo_ctx_queue.fmt.pix_mp.height;
+
+		query_rrzo_constraint
+			(&pdev->dev,
+			 config_param.cfg_resize_param.output.size.w,
+			 config_param.cfg_resize_param.output.img_fmt,
+			 config_param.cfg_in_param.pixel_mode,
+			 &stride);
+		config_param.cfg_resize_param.output.size.stride = stride;
+		config_param.cfg_resize_param.output.size.xsize = stride;
+
+		config_param.cfg_resize_param.output.crop.left = 0x0;
+		config_param.cfg_resize_param.output.crop.top = 0x0;
+		config_param.cfg_resize_param.output.crop.width =
+				config_param.cfg_resize_param.output.size.w;
+		config_param.cfg_resize_param.output.crop.height =
+				config_param.cfg_resize_param.output.size.h;
+
+		dev_dbg(dev, "rrzo pixel_byte:%d img_fmt:0x%x\n",
+			config_param.cfg_resize_param.output.pixel_byte,
+			config_param.cfg_resize_param.output.img_fmt);
+		dev_dbg(dev,
+			"rrzo param:size:=(%0dx%0d),stride:%d,xsize:%d,crop=(%0dx%0d)\n",
+			config_param.cfg_resize_param.output.size.w,
+			config_param.cfg_resize_param.output.size.h,
+			config_param.cfg_resize_param.output.size.stride,
+			config_param.cfg_resize_param.output.size.xsize,
+			config_param.cfg_resize_param.output.crop.width,
+			config_param.cfg_resize_param.output.crop.height);
+	} else {
+		config_param.cfg_resize_param.bypass = 1;
+	}
+
+	if ((enable_dma & R_AAO) == R_AAO)
+		config_param.cfg_meta_param.meta_dmas[i++] = PORT_AAO;
+
+	if ((enable_dma & R_FLKO) == R_FLKO)
+		config_param.cfg_meta_param.meta_dmas[i++] = PORT_FLKO;
+
+	if ((enable_dma & R_PSO) == R_PSO)
+		config_param.cfg_meta_param.meta_dmas[i++] = PORT_PSO;
+
+	config_param.cfg_meta_param.meta_dmas[i] = PORT_UNKNOWN;
+
+	isp_composer_hw_config(isp_ctx, &config_param);
+
+	/* Stream on */
+	count = atomic_inc_return(&isp_ctx->isp_stream_cnt);
+	dev_dbg(dev, "%s count:%d\n", __func__, count);
+	isp_composer_stream(isp_ctx, 1);
+	return 0;
+}
+EXPORT_SYMBOL(mtk_isp_streamon);
+
+int mtk_isp_streamoff(struct platform_device *pdev, u16 id)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	s32 count;
+
+	count = atomic_dec_return(&isp_ctx->isp_stream_cnt);
+	dev_dbg(dev, "%s stream count:%d\n", __func__, count);
+	isp_composer_stream(isp_ctx, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL(mtk_isp_streamoff);
+
+int mtk_isp_enqueue(struct platform_device *pdev,
+		    struct mtk_cam_ctx_start_param *frameparamsbase)
+{
+	struct device *dev = &pdev->dev;
+	struct isp_p1_device *p1_dev = get_p1_device(dev);
+	struct mtk_isp_p1_ctx *isp_ctx = &p1_dev->isp_ctx;
+	struct p1_frame_param frameparams;
+	struct mtk_isp_queue_job *framejob;
+	struct mtk_cam_ctx_buffer **bundle_buffers;
+	struct mtk_cam_ctx_buffer *pbuf = NULL;
+	struct mtk_cam_dev_buffer *dbuf = NULL;
+
+	framejob = kzalloc(sizeof(*framejob), GFP_ATOMIC);
+	memset(framejob, 0, sizeof(*framejob));
+	bundle_buffers = &frameparamsbase->frame_bundle->buffers[0];
+	memset(&frameparams, 0, sizeof(frameparams));
+
+	if (bundle_buffers[MTK_CAM_CTX_P1_META_IN_0]) {
+		frameparams.tuning_addr.iova =
+			bundle_buffers[MTK_CAM_CTX_P1_META_IN_0]->daddr;
+		frameparams.tuning_addr.pa =
+			bundle_buffers[MTK_CAM_CTX_P1_META_IN_0]->paddr;
+		dev_dbg(dev, "tuning_addr.pa:0x%x iova:0x%x\n",
+			frameparams.tuning_addr.pa,
+			frameparams.tuning_addr.iova);
+
+		/* In P1, we use the user sequence number as the */
+		/* sequence number of the buffer */
+		pbuf = bundle_buffers[MTK_CAM_CTX_P1_META_IN_0];
+		dbuf = mtk_cam_ctx_buf_to_dev_buf(pbuf);
+		dbuf->m2m2_buf.vbb.sequence = pbuf->user_sequence;
+	}
+
+	/* Image output */
+	if (bundle_buffers[MTK_CAM_CTX_P1_MAIN_STREAM_OUT]) {
+		int user_sequence = isp_ctx->isp_frame_cnt++;
+
+		frameparams.frame_num = user_sequence;
+		frameparams.sof_idx =
+			p1_dev->isp_devs[isp_ctx->isp_hw_module].sof_count;
+
+		dev_dbg(dev, "sof(%d), user_sequence/frame_num(%d)\n",
+			frameparams.sof_idx,
+			frameparams.frame_num);
+
+		frameparams.img_dma_buffers[0].buffer.iova =
+			bundle_buffers[MTK_CAM_CTX_P1_MAIN_STREAM_OUT]->daddr;
+		frameparams.img_dma_buffers[0].buffer.pa =
+			bundle_buffers[MTK_CAM_CTX_P1_MAIN_STREAM_OUT]->paddr;
+		dev_dbg(dev, "main stream address pa:0x%x iova:0x%x\n",
+			frameparams.img_dma_buffers[0].buffer.pa,
+			frameparams.img_dma_buffers[0].buffer.iova);
+
+		/* In P1, we use the user sequence number as the */
+		/* sequence number of the buffer */
+		pbuf = bundle_buffers[MTK_CAM_CTX_P1_MAIN_STREAM_OUT];
+		dbuf = mtk_cam_ctx_buf_to_dev_buf(pbuf);
+		dbuf->m2m2_buf.vbb.sequence = pbuf->user_sequence;
+	}
+
+	framejob->frame_id = frameparamsbase->frame_bundle->id;
+	framejob->request_num = frameparams.frame_num;
+
+	spin_lock(&isp_ctx->p1_enqueue_list.lock);
+	list_add_tail(&framejob->list_entry, &isp_ctx->p1_enqueue_list.queue);
+	isp_ctx->p1_enqueue_list.queue_cnt++;
+	spin_unlock(&isp_ctx->p1_enqueue_list.lock);
+
+	/* Resize output */
+	if (bundle_buffers[MTK_CAM_CTX_P1_PACKED_BIN_OUT]) {
+		frameparams.img_dma_buffers[1].buffer.iova =
+			bundle_buffers[MTK_CAM_CTX_P1_PACKED_BIN_OUT]->daddr;
+		frameparams.img_dma_buffers[1].buffer.pa =
+			bundle_buffers[MTK_CAM_CTX_P1_PACKED_BIN_OUT]->paddr;
+		dev_dbg(dev, "packed out address:0x%x iova:0x%x\n",
+			frameparams.img_dma_buffers[1].buffer.pa,
+			frameparams.img_dma_buffers[1].buffer.iova);
+
+		/* In P1, we use the user sequence number as the */
+		/* sequence number of the buffer */
+		pbuf = bundle_buffers[MTK_CAM_CTX_P1_PACKED_BIN_OUT];
+		dbuf = mtk_cam_ctx_buf_to_dev_buf(pbuf);
+		dbuf->m2m2_buf.vbb.sequence = pbuf->user_sequence;
+	}
+
+	if (bundle_buffers[MTK_CAM_CTX_P1_META_OUT_0]) {
+		frameparams.meta_addrs[0].iova =
+			bundle_buffers[MTK_CAM_CTX_P1_META_OUT_0]->daddr;
+		frameparams.meta_addrs[0].pa =
+			bundle_buffers[MTK_CAM_CTX_P1_META_OUT_0]->paddr;
+
+		/* In P1, we use the user sequence number as the */
+		/* sequence number of the buffer */
+		pbuf = bundle_buffers[MTK_CAM_CTX_P1_META_OUT_0];
+		dbuf = mtk_cam_ctx_buf_to_dev_buf(pbuf);
+		dbuf->m2m2_buf.vbb.sequence = pbuf->user_sequence;
+	}
+
+	if (bundle_buffers[MTK_CAM_CTX_P1_META_OUT_1]) {
+		frameparams.meta_addrs[1].iova =
+			bundle_buffers[MTK_CAM_CTX_P1_META_OUT_1]->daddr;
+		frameparams.meta_addrs[1].pa =
+			bundle_buffers[MTK_CAM_CTX_P1_META_OUT_1]->paddr;
+
+		/* In P1, we use the user sequence number as the */
+		/* sequence number of the buffer */
+		pbuf = bundle_buffers[MTK_CAM_CTX_P1_META_OUT_1];
+		dbuf = mtk_cam_ctx_buf_to_dev_buf(pbuf);
+		dbuf->m2m2_buf.vbb.sequence = pbuf->user_sequence;
+	}
+
+	isp_composer_enqueue(isp_ctx, &frameparams, VPU_ISP_FRAME);
+	dev_dbg(dev, "bundle id(0x%x) frame_num(%d) is queued cnt:(%d)\n",
+		frameparamsbase->frame_bundle->id,
+		frameparams.frame_num,
+		isp_ctx->p1_enqueue_list.queue_cnt);
+
+	return 0;
+}
+EXPORT_SYMBOL(mtk_isp_enqueue);
+
+static const struct dev_pm_ops mtk_isp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk_isp_suspend, mtk_isp_resume)
+	SET_RUNTIME_PM_OPS(mtk_isp_suspend, mtk_isp_resume, NULL)
+};
+
+static struct platform_driver mtk_isp_driver = {
+	.probe   = mtk_isp_probe,
+	.remove  = mtk_isp_remove,
+	.driver  = {
+		.name  = ISP_DEV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = mtk_isp_of_ids,
+		.pm     = &mtk_isp_pm_ops,
+	}
+};
+
+module_platform_driver(mtk_isp_driver);
+
+MODULE_DESCRIPTION("Camera ISP driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.h b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.h
new file mode 100644
index 0000000..b71b17d
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.h
@@ -0,0 +1,347 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Ryan Yu <ryan.yu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __CAMERA_ISP_H
+#define __CAMERA_ISP_H
+
+#include <linux/cdev.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+#include <linux/irqreturn.h>
+#include <linux/miscdevice.h>
+#include <linux/pm_qos.h>
+#include <linux/scatterlist.h>
+
+#include "mtk_cam-dev.h"
+#include "mtk_cam-ctx.h"
+#include "mtk_cam-vpu.h"
+
+#define ISP_DEV_NAME		"mtk-cam"
+#define ISP_NODE_NAME		"mtkcam"
+
+#define UNI_A_BASE_HW		0x1A003000
+#define CAM_A_BASE_HW		0x1A004000
+#define CAM_B_BASE_HW		0x1A006000
+
+#define CAM_A_MAX_WIDTH		3328
+#define CAM_A_MAX_HEIGHT	2496
+#define CAM_B_MAX_WIDTH		5376
+#define CAM_B_MAX_HEIGHT	4032
+#define CAM_MIN_WIDTH		(120 * 4)
+#define CAM_MIN_HEIGHT		(90 * 2)
+
+#define RRZ_MAX_WIDTH		8192
+#define RRZ_MAX_HEIGHT		6144
+#define RRZ_MIN_WIDTH		CAM_MIN_WIDTH
+#define RRZ_MIN_HEIGHT		CAM_MIN_HEIGHT
+
+#define R_IMGO		BIT(0)
+#define R_RRZO		BIT(1)
+#define R_AAO		BIT(3)
+#define R_AFO		BIT(4)
+#define R_LCSO		BIT(5)
+#define R_PDO		BIT(6)
+#define R_LMVO		BIT(7)
+#define R_FLKO		BIT(8)
+#define R_RSSO		BIT(9)
+#define R_PSO		BIT(10)
+
+#define PORT_AAO	12
+#define PORT_FLKO	16
+#define PORT_PSO	18
+#define PORT_UNKNOWN	53
+
+#define ISP_COMPOSING_MAX_NUM		4
+#define ISP_FRAME_COMPOSING_MAX_NUM	3
+
+#define CQ_ADDRESS_OFFSET		0x640
+#define CQ_BUFFER_COUNT			3
+
+#define IRQ_STAT_STR "cam%c, SOF_%d irq(0x%x), " \
+					"dma(0x%x), frame_num(%d)/cq_num(%d)\n"
+
+/*
+ * In order with the sequence of device nodes defined in dtsi rule,
+ * one hw module should mapping to one node
+ */
+enum isp_dev_node_enum {
+	ISP_CAMSYS_CONFIG_IDX = 0,
+	ISP_CAM_UNI_IDX,
+	ISP_CAM_A_IDX,
+	ISP_CAM_B_IDX,
+	ISP_DEV_NODE_NUM
+};
+
+enum {
+	img_fmt_unknown		= 0x0000,
+	img_fmt_raw_start	= 0x2200,
+	img_fmt_bayer8		= img_fmt_raw_start,
+	img_fmt_bayer10,
+	img_fmt_bayer12,
+	img_fmt_bayer14,
+	img_fmt_fg_bayer8,
+	img_fmt_fg_bayer10,
+	img_fmt_fg_bayer12,
+	img_fmt_fg_bayer14,
+};
+
+enum {
+	raw_pxl_id_b   = 0,  // B Gb Gr R
+	raw_pxl_id_gb,       // Gb B R Gr
+	raw_pxl_id_gr,       // Gr R B Gb
+	raw_pxl_id_r         // R Gr Gb B
+};
+
+enum {
+	default_pixel_mode = 0,
+	one_pixel_mode,
+	two_pixel_mode,
+	four_pixel_mode,
+	pixel_mode_num,
+};
+
+struct isp_queue {
+	struct list_head queue;
+	struct mutex queuelock; /* Not used now, may be removed in further */
+	unsigned int queue_cnt;
+	spinlock_t lock; /* queue attributes protection */
+};
+
+struct isp_thread {
+	struct task_struct *thread;
+	wait_queue_head_t wq;
+};
+
+enum mtk_isp_vpu_ipi_type {
+	VPU_ISP_CMD = 0,
+	VPU_ISP_FRAME,
+};
+
+struct mtk_isp_queue_work {
+	union {
+		struct mtk_isp_vpu_cmd cmd;
+		struct p1_frame_param frameparams;
+	};
+	struct list_head list_entry;
+	enum mtk_isp_vpu_ipi_type type;
+};
+
+struct mtk_isp_queue_job {
+	struct list_head list_entry;
+	struct work_struct frame_work;
+	struct isp_device *isp_dev;
+	unsigned int frame_id;
+	unsigned int request_num;
+	unsigned int irq_status;
+	unsigned int dma_status;
+};
+
+struct isp_clk_struct {
+	int num_clks;
+	struct clk_bulk_data *clk_list;
+};
+
+struct isp_device {
+	struct device *dev;
+	void __iomem *regs;
+	int irq;
+	spinlock_t spinlock_irq; /* ISP reg setting integrity */
+	unsigned int current_frame;
+	u8 sof_count;
+	u8 isp_hw_module;
+};
+
+struct mtk_isp_p1_ctx {
+	atomic_t vpu_state;
+	struct isp_queue composer_txlist;
+	struct isp_thread composer_tx_thread;
+
+	struct isp_queue composer_eventlist;
+	struct isp_thread composer_event_thread;
+
+	struct workqueue_struct *composer_cmd_wrkq;
+	struct workqueue_struct *composer_frame_wrkq;
+	wait_queue_head_t composing_cmd_waitq;
+	wait_queue_head_t composing_frame_waitq;
+	struct mutex composer_tx_lock; /* isp composer work protection */
+	/* increase after ipi */
+	atomic_t num_composing;
+	/* increase after frame enqueue */
+	atomic_t num_frame_composing;
+	/* current composed frame id */
+	atomic_t composed_frame_id;
+
+	struct isp_queue p1_enqueue_list;
+	struct isp_queue p1_dequeue_list;
+	struct workqueue_struct *p1_dequeue_workq;
+
+	struct platform_device *v4l2_pdev;
+
+	unsigned int isp_hw_module;
+	phys_addr_t scp_mem_pa;
+	void *scp_mem_va;
+	dma_addr_t scp_mem_iova;
+	struct sg_table sgtable;
+
+	/* increase after Stream ON, decrease when Stream OFF */
+	atomic_t isp_stream_cnt;
+	/* increase after open, decrease when close */
+	atomic_t isp_user_cnt;
+	/* increase after enqueue */
+	int isp_frame_cnt;
+
+	void (*composer_deinit_donecb)(void *isp_ctx);
+
+	unsigned int enabled_dma_ports;
+
+	struct list_head list;
+};
+
+struct isp_p1_device {
+	struct platform_device *pdev;
+
+	/* for VPU driver  */
+	struct platform_device *vpu_pdev;
+
+	struct mtk_isp_p1_ctx isp_ctx;
+	struct isp_clk_struct isp_clk;
+	struct isp_device *isp_devs;
+};
+
+struct mtk_isp_p1_drv_data {
+	struct mtk_cam_dev cam_dev;
+	struct isp_p1_device p1_dev;
+};
+
+static inline struct mtk_isp_p1_drv_data *p1_ctx_to_drv
+	(const struct mtk_isp_p1_ctx *__p1_ctx)
+{
+	return container_of(__p1_ctx,
+		struct mtk_isp_p1_drv_data, p1_dev.isp_ctx);
+}
+
+static inline struct isp_p1_device *p1_ctx_to_dev
+	(const struct mtk_isp_p1_ctx *__p1_ctx)
+{
+	return container_of(__p1_ctx,
+		struct isp_p1_device, isp_ctx);
+}
+
+static inline struct isp_p1_device *get_p1_device(struct device *dev)
+{
+	return &(((struct mtk_isp_p1_drv_data *)
+		dev_get_drvdata(dev))->p1_dev);
+}
+
+int isp_composer_init(struct mtk_isp_p1_ctx *isp_ctx);
+void isp_composer_hw_init(struct mtk_isp_p1_ctx *isp_ctx);
+void isp_composer_hw_config(struct mtk_isp_p1_ctx *isp_ctx,
+			    struct p1_config_param *config_param);
+void isp_composer_stream(struct mtk_isp_p1_ctx *isp_ctx, int on);
+void isp_composer_hw_deinit(struct mtk_isp_p1_ctx *isp_ctx,
+			    void (*donecb)(void *data));
+void isp_composer_enqueue(struct mtk_isp_p1_ctx *isp_ctx,
+			  void *data,
+			  enum mtk_isp_vpu_ipi_type type);
+
+/**
+ * mtk_isp_open -
+ *
+ * @pdev:	isp platform device
+ *
+ * Enqueue a frame to isp driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_open(struct platform_device *pdev);
+
+/**
+ * mtk_isp_release -
+ *
+ * @pdev:	isp platform device
+ *
+ * Release isp driver and related resources.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_release(struct platform_device *pdev);
+
+/**
+ * mtk_isp_prepare -
+ *
+ * @pdev:	isp platform device
+ * @param: isp configuration parameters
+ *
+ * Prepare isp HW.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_prepare(struct platform_device *pdev,
+		    struct mtk_cam_ctx_open_param *param);
+
+/**
+ * mtk_isp_streamon -
+ *
+ * @pdev:	isp platform device
+ * @id: reserved
+ *
+ * Start output image.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_streamon(struct platform_device *pdev, u16 id);
+
+/**
+ * mtk_isp_streamoff -
+ *
+ * @pdev:	isp platform device
+ * @id: reserved
+ *
+ *  Stop output image.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_streamoff(struct platform_device *pdev, u16 id);
+
+/**
+ * mtk_isp_register_cb -
+ *
+ * @pdev:	isp platform device
+ * @v4l2_pdev:	v4l2 driver platform device
+ * @func:	the callback function to be registered
+ *
+ * Registered from v4l2 and to be called if image is ready.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_register_finished_cb(struct platform_device *pdev,
+				 struct platform_device *v4l2_pdev,
+	void (*func)(void *, struct platform_device *));
+
+/**
+ * mtk_isp_enqueue - enqueue to isp driver
+ *
+ * @pdev:	isp platform device
+ * @frameparamsbase: frame parameters
+ *
+ * Enqueue a frame to isp driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_isp_enqueue(struct platform_device *pdev,
+		    struct mtk_cam_ctx_start_param *frameparamsbase);
+
+#endif /*__CAMERA_ISP_H*/
-- 
1.9.1

