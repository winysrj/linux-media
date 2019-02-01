Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E5EC282DB
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3251321905
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfBALWv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:22:51 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:30587 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729222AbfBALWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 06:22:49 -0500
X-UUID: 80cfeebc754249da971296b24257dc4f-20190201
X-UUID: 80cfeebc754249da971296b24257dc4f-20190201
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1851047635; Fri, 01 Feb 2019 19:22:06 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 1 Feb 2019 19:22:04 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 1 Feb 2019 19:22:04 +0800
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
        <srv_heupstream@mediatek.com>
Subject: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek DIP driver
Date:   Fri, 1 Feb 2019 19:21:31 +0800
Message-ID: <1549020091-42064-8-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds the driver of Digital Image Processing (DIP)
unit in Mediatek ISP system, providing image format conversion,
resizing, and rotation features.

The mtk-isp directory will contain drivers for multiple IP
blocks found in Mediatek ISP system. It will include ISP Pass 1
driver (CAM), sensor interface driver, DIP driver and face
detection driver.

Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 drivers/media/platform/mtk-isp/Makefile            |   18 +
 drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
 drivers/media/platform/mtk-isp/isp_50/dip/Makefile |   35 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-core.h     |  188 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c     |  173 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h     |   43 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h      |  319 ++++
 .../mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c      | 1643 ++++++++++++++++++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.c      |  374 +++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.h      |  191 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c |  452 ++++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-smem.h     |   25 +
 .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c         | 1000 ++++++++++++
 .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h         |   38 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c     |  292 ++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h     |   60 +
 .../media/platform/mtk-isp/isp_50/dip/mtk_dip.c    | 1385 +++++++++++++++++
 .../media/platform/mtk-isp/isp_50/dip/mtk_dip.h    |   93 ++
 18 files changed, 6346 insertions(+)
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h

diff --git a/drivers/media/platform/mtk-isp/Makefile b/drivers/media/platform/mtk-isp/Makefile
new file mode 100644
index 0000000..24bc535
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/Makefile
@@ -0,0 +1,18 @@
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
+obj-$(CONFIG_VIDEO_MEDIATEK_ISP_COMMON) += common/
+
+obj-y += isp_50/
+
+obj-$(CONFIG_VIDEO_MEDIATEK_ISP_FD_SUPPORT) += fd/
diff --git a/drivers/media/platform/mtk-isp/isp_50/Makefile b/drivers/media/platform/mtk-isp/isp_50/Makefile
new file mode 100644
index 0000000..fd0e5bd
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
+ifeq ($(CONFIG_VIDEO_MEDIATEK_ISP_DIP_SUPPORT),y)
+obj-y += dip/
+endif
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/Makefile b/drivers/media/platform/mtk-isp/isp_50/dip/Makefile
new file mode 100644
index 0000000..9a08c62
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/Makefile
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
+$(info $(srctree))
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-mdp3
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vpu
+
+obj-y += mtk_dip.o
+obj-y += mtk_dip-v4l2.o
+
+# To provide alloc context managing memory shared
+# between CPU and ISP coprocessor
+mtk_dip_smem-objs := \
+mtk_dip-smem-drv.o
+
+obj-y += mtk_dip_smem.o
+
+# Utilits to provide frame-based streaming model
+# with v4l2 user interfaces
+mtk_dip_util-objs := \
+mtk_dip-dev.o \
+mtk_dip-v4l2-util.o \
+mtk_dip-dev-ctx-core.o \
+mtk_dip-ctrl.o \
+
+obj-y += mtk_dip_util.o
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
new file mode 100644
index 0000000..af6509a
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 MediaTek Inc.
+ * Author: Holmes Chiou <holmes.chiou@mediatek.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_CORE_H
+#define __MTK_DIP_CORE_H
+
+#include <linux/clk.h>
+
+#include "mtk-img-ipi.h"
+#include "mtk_dip-dev.h"
+
+enum dip_user_state {
+	DIP_STATE_INIT	= 0,
+	DIP_STATE_STREAMON,
+	DIP_STATE_STREAMOFF
+};
+
+struct dip_frame_job {
+	struct img_frameparam fparam;
+	int sequence;
+};
+
+struct dip_user_id {
+	struct list_head list_entry;
+	u16 id;
+	u32 num;
+	u16 state;
+};
+
+struct dip_subframe {
+	struct img_addr buffer;
+	struct sg_table table;
+	struct img_sw_addr config_data;
+	struct img_addr tuning_buf;
+	struct img_sw_addr frameparam;
+	struct list_head list_entry;
+};
+
+struct dip_queue {
+	struct list_head queue;
+	struct mutex queuelock; /* protect queue and queue_cnt */
+	u32 queue_cnt;
+};
+
+struct dip_joblist {
+	struct list_head queue;
+	spinlock_t queuelock; /* protect queue and queue_cnt */
+	u32 queue_cnt;
+};
+
+struct dip_thread {
+	struct task_struct *thread;
+	wait_queue_head_t wq;
+};
+
+struct mtk_dip_work {
+	struct list_head	    list_entry;
+	struct img_ipi_frameparam   frameparams;
+	struct dip_user_id          *user_id;
+};
+
+struct mtk_dip_submit_work {
+	struct work_struct          frame_work;
+	struct mtk_dip_hw_ctx          *dip_ctx;
+};
+
+struct mtk_mdpcb_work {
+	struct work_struct		frame_work;
+	struct img_ipi_frameparam	*frameparams;
+};
+
+struct DIP_CLK_STRUCT {
+	struct clk *DIP_IMG_LARB5;
+	struct clk *DIP_IMG_DIP;
+};
+
+struct mtk_dip_hw_ctx {
+	struct dip_joblist dip_gcejoblist;
+	struct dip_queue dip_freebufferlist;
+	struct dip_queue dip_usedbufferlist;
+
+	struct dip_thread dip_runner_thread;
+
+	struct dip_queue dip_useridlist;
+	struct dip_queue dip_worklist;
+	struct workqueue_struct *composer_wq;
+	struct mtk_dip_submit_work submit_work;
+	wait_queue_head_t composing_wq;
+	wait_queue_head_t flushing_wq;
+	atomic_t num_composing;	/* increase after ipi */
+
+	/* increase after calling MDP driver */
+	atomic_t num_running;
+
+	/*MDP/GCE callback workqueue */
+	struct workqueue_struct *mdpcb_workqueue;
+
+	/* for MDP driver  */
+	struct platform_device *mdp_pdev;
+
+	/* for VPU driver  */
+	struct platform_device *vpu_pdev;
+
+	phys_addr_t scp_workingbuf_addr;
+
+	/* increase after enqueue */
+	atomic_t dip_enque_cnt;
+	/* increase after Stream ON, decrease when Stream OFF */
+	atomic_t dip_stream_cnt;
+	/* increase after open, decrease when close */
+	atomic_t dip_user_cnt;
+};
+
+struct dip_device {
+	struct platform_device *pdev;
+
+	struct DIP_CLK_STRUCT dip_clk;
+
+	struct device *larb_dev;
+
+	dev_t dip_devno;
+	struct cdev   dip_cdev;
+	struct class *dip_class;
+
+	struct mtk_dip_hw_ctx dip_ctx;
+};
+
+struct mtk_isp_dip_drv_data {
+	struct mtk_dip_dev isp_preview_dev;
+	struct mtk_dip_dev isp_capture_dev;
+	struct dip_device dip_dev;
+};
+
+static inline struct dip_device *get_dip_device(struct device *dev)
+{
+	struct mtk_isp_dip_drv_data *drv_data =
+		dev_get_drvdata(dev);
+	if (drv_data)
+		return &drv_data->dip_dev;
+	else
+		return NULL;
+}
+
+static inline void frame_param_ipi_to_ctx(struct img_ipi_frameparam *iparam,
+					  struct mtk_dip_ctx_finish_param
+					  *fparam)
+{
+	if (!iparam || !fparam) {
+		pr_err("frame conversion failed, iparam and fparam can't be NULL\n");
+		return;
+	}
+
+	fparam->frame_id = iparam->index;
+	fparam->timestamp = iparam->timestamp;
+	fparam->state = iparam->state;
+}
+
+#define dip_dev_to_drv(__dip_dev) \
+	container_of(__dip_dev, \
+	struct mtk_isp_dip_drv_data, dip_dev)
+
+#define dip_hw_ctx_to_dev(__hw_ctx) \
+	container_of(__hw_ctx, \
+	struct dip_device, dip_ctx)
+
+#define mtk_dip_fparam_to_job(__fparam) \
+	container_of(__fparam,\
+	struct dip_frame_job, fparam)
+
+#define mtk_dip_ipi_fparam_to_job(__ipi_fparam) \
+	container_of(__ipi_fparam, \
+	struct dip_frame_job, \
+	fparam.frameparam)
+
+#endif /* __MTK_DIP_CORE_H */
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
new file mode 100644
index 0000000..9d29507
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
@@ -0,0 +1,173 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include "mtk_dip-dev.h"
+#include "mtk_dip-ctrl.h"
+
+#define CONFIG_MTK_DIP_COMMON_UT
+
+static void handle_buf_usage_config(struct v4l2_ctrl *ctrl);
+static void handle_buf_rotate_config(struct v4l2_ctrl *ctrl);
+static int mtk_dip_ctx_s_ctrl(struct v4l2_ctrl *ctrl);
+
+static void handle_buf_usage_config(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_dip_ctx_queue *queue =
+		container_of(ctrl->handler,
+			     struct mtk_dip_ctx_queue, ctrl_handler);
+
+	if (ctrl->val < MTK_DIP_V4l2_BUF_USAGE_DEFAULT ||
+	    ctrl->val >= MTK_DIP_V4l2_BUF_USAGE_NONE) {
+		pr_err("Invalid buffer usage id %d", ctrl->val);
+		return;
+	}
+	queue->buffer_usage = ctrl->val;
+}
+
+static void handle_buf_rotate_config(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_dip_ctx_queue *queue =
+		container_of(ctrl->handler,
+			     struct mtk_dip_ctx_queue, ctrl_handler);
+
+	if (ctrl->val != 0 || ctrl->val != 90 ||
+	    ctrl->val != 180 || ctrl->val != 270) {
+		pr_err("Invalid buffer rotation %d", ctrl->val);
+		return;
+	}
+	queue->rotation = ctrl->val;
+}
+
+static const struct v4l2_ctrl_ops mtk_dip_ctx_ctrl_ops = {
+	.s_ctrl = mtk_dip_ctx_s_ctrl,
+};
+
+#ifdef CONFIG_MTK_DIP_COMMON_UT
+
+static void handle_ctrl_common_util_ut_set_debug_mode
+	(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_dip_ctx *dev_ctx =
+		container_of(ctrl->handler, struct mtk_dip_ctx, ctrl_handler);
+	dev_ctx->mode = ctrl->val;
+	dev_dbg(&dev_ctx->pdev->dev, "Set ctx(id = %d) mode to %d\n",
+		dev_ctx->ctx_id, dev_ctx->mode);
+}
+
+static const struct v4l2_ctrl_config mtk_dip_mode_config = {
+	.ops	= &mtk_dip_ctx_ctrl_ops,
+	.id	= V4L2_CID_PRIVATE_SET_CTX_MODE_NUM,
+	.name	= "MTK ISP UNIT TEST CASE",
+	.type	= V4L2_CTRL_TYPE_INTEGER,
+	.min	= 0,
+	.max	= 65535,
+	.step	= 1,
+	.def	= 0,
+	.flags	= V4L2_CTRL_FLAG_SLIDER | V4L2_CTRL_FLAG_EXECUTE_ON_WRITE,
+};
+#endif /* CONFIG_MTK_DIP_COMMON_UT */
+
+static int mtk_dip_ctx_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	#ifdef CONFIG_MTK_DIP_COMMON_UT
+	case V4L2_CID_PRIVATE_SET_CTX_MODE_NUM:
+		handle_ctrl_common_util_ut_set_debug_mode(ctrl);
+		break;
+	#endif /* CONFIG_MTK_DIP_COMMON_UT */
+	default:
+			break;
+	}
+	return 0;
+}
+
+static int mtk_dip_ctx_queue_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_PRIVATE_SET_BUFFER_USAGE:
+		handle_buf_usage_config(ctrl);
+		break;
+	case V4L2_CID_ROTATE:
+		handle_buf_rotate_config(ctrl);
+		break;
+	default:
+			break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops mtk_dip_ctx_queue_ctrl_ops = {
+	.s_ctrl = mtk_dip_ctx_queue_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config mtk_dip_buf_usage_config = {
+	.ops	= &mtk_dip_ctx_queue_ctrl_ops,
+	.id	= V4L2_CID_PRIVATE_SET_BUFFER_USAGE,
+	.name	= "MTK ISP SET BUFFER USAGE",
+	.type	= V4L2_CTRL_TYPE_INTEGER,
+	.min	= MTK_DIP_V4l2_BUF_USAGE_DEFAULT,
+	.max	= MTK_DIP_V4l2_BUF_USAGE_POSTPROC,
+	.step	= 1,
+	.def	= MTK_DIP_V4l2_BUF_USAGE_DEFAULT,
+	.flags	= V4L2_CTRL_FLAG_SLIDER | V4L2_CTRL_FLAG_EXECUTE_ON_WRITE,
+	};
+
+int mtk_dip_ctrl_init(struct mtk_dip_ctx *ctx)
+{
+	struct v4l2_ctrl_handler *hdl = &ctx->ctrl_handler;
+	int i = 0;
+
+	/* Initialized HW controls, allow V4L2_CID_MTK_DIP_MAX ctrls */
+	v4l2_ctrl_handler_init(hdl, V4L2_CID_MTK_DIP_MAX);
+	if (hdl->error) {
+		pr_err("Failed in v4l2_ctrl_handler_init\n");
+		return hdl->error;
+}
+
+#ifdef CONFIG_MTK_DIP_COMMON_UT
+if (!v4l2_ctrl_new_custom(hdl, &mtk_dip_mode_config, NULL)) {
+	pr_err("Failed in v4l2_ctrl_new_custom: mtk_dip_mode_config\n");
+	return hdl->error;
+}
+#endif /* CONFIG_MTK_DIP_COMMON_UT */
+
+/* Enumerate all nodes and setup the node specified ctrl */
+for (i = 0; i < ctx->queues_attr.total_num; i++) {
+	struct v4l2_ctrl_handler *node_hdl =
+		&ctx->queue[i].ctrl_handler;
+
+	if (!node_hdl) {
+		pr_err("ctrl_handler can't be NULL\n");
+	} else {
+		v4l2_ctrl_handler_init(node_hdl, V4L2_CID_MTK_DIP_MAX);
+
+		if (v4l2_ctrl_new_custom(node_hdl,
+					 &mtk_dip_buf_usage_config,
+					 NULL) == NULL)
+			pr_err("Node (%d) create buf_usage_config ctrl failed:(%d)",
+			       i, node_hdl->error);
+		if (v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				      &mtk_dip_ctx_queue_ctrl_ops,
+				V4L2_CID_ROTATE, 0, 270, 90, 0)	== NULL)
+			pr_err("Node (%d) create rotate ctrl failed:(%d)",
+			       i, node_hdl->error);
+	}
+}
+
+return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctrl_init);
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
new file mode 100644
index 0000000..f4944af
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
@@ -0,0 +1,43 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_CTRL_H__
+#define __MTK_DIP_CTRL_H__
+
+#include <media/v4l2-ctrls.h>
+
+#define V4L2_CID_PRIVATE_UT_NUM  (V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_PRIVATE_SET_CTX_MODE_NUM \
+	(V4L2_CID_PRIVATE_UT_NUM + 1)
+#define V4L2_CID_PRIVATE_SET_BUFFER_USAGE \
+	(V4L2_CID_PRIVATE_UT_NUM + 2)
+#define V4L2_CID_MTK_DIP_MAX 100
+
+#define MTK_DIP_COMMON_UTIL_UT_OPEN (0)
+#define MTK_DIP_COMMON_UTIL_UT_CLOSE (1)
+#define MTK_DIP_COMMON_UTIL_UT_START (2)
+#define MTK_DIP_COMMON_UTIL_UT_STREAMON (3)
+#define MTK_DIP_COMMON_UTIL_UT_STREAMOFF (4)
+
+enum mtk_dip_v4l2_buffer_usage {
+		MTK_DIP_V4l2_BUF_USAGE_DEFAULT = 0,
+		MTK_DIP_V4l2_BUF_USAGE_FD,
+		MTK_DIP_V4l2_BUF_USAGE_POSTPROC,
+		MTK_DIP_V4l2_BUF_USAGE_NONE,
+};
+
+int mtk_dip_ctrl_init(struct mtk_dip_ctx *ctx);
+
+#endif /*__MTK_DIP_CTRL_H__*/
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
new file mode 100644
index 0000000..2dd014e
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
@@ -0,0 +1,319 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_CTX_H__
+#define __MTK_DIP_CTX_H__
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-subdev.h>
+#include "mtk_dip-v4l2-util.h"
+
+#define MTK_DIP_CTX_QUEUES (16)
+#define MTK_DIP_CTX_FRAME_BUNDLE_BUFFER_MAX (MTK_DIP_CTX_QUEUES)
+#define MTK_DIP_CTX_DESC_MAX (MTK_DIP_CTX_QUEUES)
+
+#define MTK_DIP_CTX_MODE_DEBUG_OFF (0)
+#define MTK_DIP_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER (1)
+#define MTK_DIP_CTX_MODE_DEBUG_BYPASS_ALL (2)
+
+#define MTK_DIP_GET_CTX_ID_FROM_SEQUENCE(sequence) \
+	((sequence) >> 16 & 0x0000FFFF)
+
+#define MTK_DIP_CTX_META_BUF_DEFAULT_SIZE (1110 * 1024)
+
+struct mtk_dip_ctx;
+struct mtk_dip_ctx_open_param;
+struct mtk_dip_ctx_release_param;
+struct mtk_dip_ctx_streamon_param;
+struct mtk_dip_ctx_streamoff_param;
+struct mtk_dip_ctx_start_param;
+struct mtk_dip_ctx_finish_param;
+
+/* Attributes setup by device context owner */
+struct mtk_dip_ctx_queue_desc {
+	int id;	/* id of the context queue */
+	char *name;
+	/* Will be exported to media entity name */
+	int capture;
+	/* 1 for capture queue (device to user), 0 for output queue */
+	/* (from user to device) */
+	int image;
+	/* Using the cam_smem_drv as alloc ctx or not */
+	int smem_alloc;
+	/* 1 for image, 0 for meta data */
+	int dynamic;
+	/* can be enabled or disabled while streaming media data*/
+	unsigned int dma_port; /*The dma port associated to the buffer*/
+	/* Supported format */
+	struct mtk_dip_ctx_format *fmts;
+	int num_fmts;
+	/* Default format of this queue */
+	int default_fmt_idx;
+};
+
+/* Supported format and the information used for */
+/* size calculation */
+struct mtk_dip_ctx_meta_format {
+	u32 dataformat;
+	u32 max_buffer_size;
+	u8 flags;
+};
+
+/* MDP module's private format definitation */
+/* (the same as struct mdp_format) */
+/* It will be removed and changed to MDP's external interface */
+/* after the integration with MDP module. */
+struct mtk_dip_ctx_mdp_format {
+	u32	pixelformat;
+	u32	mdp_color;
+	u8	depth[VIDEO_MAX_PLANES];
+	u8	row_depth[VIDEO_MAX_PLANES];
+	u8	num_planes;
+	u8	walign;
+	u8	halign;
+	u8	salign;
+	u32	flags;
+};
+
+struct mtk_dip_ctx_format {
+	union {
+		struct mtk_dip_ctx_meta_format meta;
+		struct mtk_dip_ctx_mdp_format img;
+	} fmt;
+};
+
+union mtk_v4l2_fmt {
+	struct v4l2_pix_format_mplane pix_mp;
+	struct v4l2_meta_format	meta;
+};
+
+/* Attributes setup by device context owner */
+struct mtk_dip_ctx_queues_setting {
+	int master;
+	/* The master input node to trigger the frame data enqueue */
+	struct mtk_dip_ctx_queue_desc *output_queue_descs;
+	int total_output_queues;
+	struct mtk_dip_ctx_queue_desc *capture_queue_descs;
+	int total_capture_queues;
+};
+
+struct mtk_dip_ctx_queue_attr {
+	int master;
+	int input_offset;
+	int total_num;
+};
+
+/* Video node context. Since we use */
+/* mtk_dip_ctx_frame_bundle to manage enqueued */
+/* buffers by frame now, we don't use bufs filed of */
+/* mtk_dip_ctx_queue now */
+struct mtk_dip_ctx_queue {
+	union mtk_v4l2_fmt fmt;
+	struct mtk_dip_ctx_format *ctx_fmt;
+	/* Currently we used in standard v4l2 image format */
+	/* in the device context */
+	unsigned int width_pad;	/* bytesperline, reserved */
+	struct mtk_dip_ctx_queue_desc desc;
+	struct v4l2_ctrl_handler ctrl_handler; /* Ctrl handler of the queue */
+	unsigned int buffer_usage; /* Current buffer usage of the queue */
+	int rotation;
+	struct list_head bufs; /* Reserved, not used now */
+};
+
+enum mtk_dip_ctx_frame_bundle_state {
+	MTK_DIP_CTX_FRAME_NEW,	/* Not allocated */
+	MTK_DIP_CTX_FRAME_PREPARED, /* Allocated but has not be processed */
+	MTK_DIP_CTX_FRAME_PROCESSING,	/* Queued, waiting to be filled */
+};
+
+/* The definiation is compatible with DIP driver's state definiation */
+/* currently and will be decoupled after further integration */
+enum mtk_dip_ctx_frame_data_state {
+	MTK_DIP_CTX_FRAME_DATA_EMPTY = 0, /* FRAME_STATE_INIT */
+	MTK_DIP_CTX_FRAME_DATA_DONE = 3, /* FRAME_STATE_DONE */
+	MTK_DIP_CTX_FRAME_DATA_STREAMOFF_DONE = 4, /*FRAME_STATE_STREAMOFF*/
+	MTK_DIP_CTX_FRAME_DATA_ERROR = 5, /*FRAME_STATE_ERROR*/
+};
+
+struct mtk_dip_ctx_frame_bundle {
+	struct mtk_dip_ctx_buffer*
+		buffers[MTK_DIP_CTX_FRAME_BUNDLE_BUFFER_MAX];
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
+struct mtk_dip_ctx_frame_bundle_list {
+	struct list_head list;
+};
+
+struct mtk_dip_ctx {
+	struct platform_device *pdev;
+	struct platform_device *smem_device;
+	struct v4l2_ctrl_handler ctrl_handler;
+	/* buffer queues will be added later */
+	unsigned short ctx_id;
+	char *device_name;
+	struct mtk_dip_dev_node_mapping *mtk_dip_dev_node_map;
+	unsigned int dev_node_num;
+	/* mtk_dip_ctx_queue is the context for the video nodes */
+	struct mtk_dip_ctx_queue queue[MTK_DIP_CTX_QUEUES];
+	struct mtk_dip_ctx_queue_attr queues_attr;
+	atomic_t frame_param_sequence;
+	int streaming;
+	void *default_vb2_alloc_ctx;
+	void *smem_vb2_alloc_ctx;
+	struct v4l2_subdev_fh *fh;
+	struct mtk_dip_ctx_frame_bundle frame_bundles[VB2_MAX_FRAME];
+	struct mtk_dip_ctx_frame_bundle_list processing_frames;
+	struct mtk_dip_ctx_frame_bundle_list free_frames;
+	int enabled_dma_ports;
+	int num_frame_bundle;
+	int mode; /* Reserved for debug */
+	spinlock_t qlock;
+};
+
+enum mtk_dip_ctx_buffer_state {
+	MTK_DIP_CTX_BUFFER_NEW,
+	MTK_DIP_CTX_BUFFER_PROCESSING,
+	MTK_DIP_CTX_BUFFER_DONE,
+	MTK_DIP_CTX_BUFFER_FAILED,
+};
+
+struct mtk_dip_ctx_buffer {
+	union mtk_v4l2_fmt fmt;
+	struct mtk_dip_ctx_format *ctx_fmt;
+	int capture;
+	int image;
+	int frame_id;
+	dma_addr_t daddr;
+	void *vaddr;
+	phys_addr_t paddr;
+	unsigned int queue;
+	unsigned int buffer_usage;
+	enum mtk_dip_ctx_buffer_state state;
+	int rotation;
+	struct list_head list;
+};
+
+struct mtk_dip_ctx_setting {
+	char *device_name;
+};
+
+struct mtk_dip_ctx_desc {
+	char *proc_dev_phandle;
+	/* The context device's compatble string name in device tree*/
+	int (*init)(struct mtk_dip_ctx *ctx);
+	/* configure the core functions of the device context */
+};
+
+struct mtk_dip_ctx_init_table {
+	int total_dev_ctx;
+	struct mtk_dip_ctx_desc *ctx_desc_tbl;
+};
+
+struct mtk_dip_ctx_open_param {
+	/* Bitmask used to notify that the DMA port is enabled or not */
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_dip_ctx_streamon_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_dip_ctx_streamoff_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_dip_ctx_start_param {
+	/* carry buffer information of the frame */
+	struct mtk_dip_ctx_frame_bundle *frame_bundle;
+};
+
+struct mtk_dip_ctx_release_param {
+	unsigned int enabled_dma_ports;
+};
+
+struct mtk_dip_ctx_start_param_wrapper {
+	struct mtk_dip_ctx_start_param param;
+	/* Private fields */
+	/* Don't change any field outside mtk_dip-dev-ctx-core */
+	/* Since it may corrupt the common framework */
+	struct mtk_dip_ctx *ctx;
+};
+
+struct mtk_dip_ctx_finish_param {
+	unsigned int frame_id;
+	u64 timestamp;
+	unsigned int state;
+};
+
+int mtk_dip_ctx_is_streaming(struct mtk_dip_ctx *ctx);
+int mtk_dip_ctx_core_job_finish(struct mtk_dip_ctx *ctx,
+				struct mtk_dip_ctx_finish_param *param);
+int mtk_dip_ctx_core_init(struct mtk_dip_ctx *ctx,
+			  struct platform_device *pdev, int ctx_id,
+			  struct mtk_dip_ctx_desc *ctx_desc,
+			  struct platform_device *proc_pdev,
+			  struct platform_device *smem_pdev);
+int mtk_dip_ctx_core_exit(struct mtk_dip_ctx *ctx);
+void mtk_dip_ctx_buf_init(struct mtk_dip_ctx_buffer *b,
+			  unsigned int queue, dma_addr_t daddr);
+extern enum mtk_dip_ctx_buffer_state
+	mtk_dip_ctx_get_buffer_state(struct mtk_dip_ctx_buffer *b);
+extern int mtk_dip_ctx_next_global_frame_sequence
+	(struct mtk_dip_ctx *ctx, int locked);
+extern int mtk_dip_ctx_core_steup
+	(struct mtk_dip_ctx *ctx, struct mtk_dip_ctx_setting *ctx_setting);
+int mtk_dip_ctx_core_queue_setup(struct mtk_dip_ctx *ctx,
+				 struct mtk_dip_ctx_queues_setting
+				 *queues_setting);
+int mtk_dip_ctx_core_finish_param_init(void *param,
+				       int frame_id, int state);
+int mtk_dip_ctx_finish_frame(struct mtk_dip_ctx *dev_ctx,
+			     struct mtk_dip_ctx_frame_bundle *frame_bundle,
+			     int done);
+extern int mtk_dip_ctx_frame_bundle_init
+	(struct mtk_dip_ctx_frame_bundle *frame_bundle);
+void mtk_dip_ctx_frame_bundle_add(struct mtk_dip_ctx *ctx,
+				  struct mtk_dip_ctx_frame_bundle *bundle,
+				  struct mtk_dip_ctx_buffer *ctx_buf);
+extern int mtk_dip_ctx_trigger_job
+	(struct mtk_dip_ctx *dev_ctx,
+	 struct mtk_dip_ctx_frame_bundle *bundle_data);
+extern int mtk_dip_ctx_fmt_set_img
+	(struct mtk_dip_ctx *dev_ctx, int queue_id,
+	 struct v4l2_pix_format_mplane *user_fmt,
+	 struct v4l2_pix_format_mplane *node_fmt);
+extern int mtk_dip_ctx_fmt_set_meta
+	(struct mtk_dip_ctx *dev_ctx, int queue_id,
+	 struct v4l2_meta_format *user_fmt,
+	 struct v4l2_meta_format *node_fmt);
+int mtk_dip_ctx_format_load_default_fmt
+	(struct mtk_dip_ctx_queue *queue,
+	 struct v4l2_format *fmt_to_fill);
+int mtk_dip_ctx_streamon(struct mtk_dip_ctx *dev_ctx);
+int mtk_dip_ctx_streamoff(struct mtk_dip_ctx *dev_ctx);
+int mtk_dip_ctx_release(struct mtk_dip_ctx *dev_ctx);
+int mtk_dip_ctx_open(struct mtk_dip_ctx *dev_ctx);
+#endif /*__MTK_DIP_CTX_H__*/
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
new file mode 100644
index 0000000..c735919
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
@@ -0,0 +1,1643 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <media/videobuf2-dma-contig.h>
+#include <linux/dma-mapping.h>
+#include <media/v4l2-event.h>
+#include "mtk_dip.h"
+#include "mtk_dip-dev.h"
+#include "mtk_dip-v4l2.h"
+#include "mtk_dip-v4l2-util.h"
+#include "mtk_dip-smem.h"
+#include "mtk-mdp3-regs.h"
+#include "mtk-img-ipi.h"
+
+static struct mtk_dip_ctx_format *mtk_dip_ctx_find_fmt
+	(struct mtk_dip_ctx *dev_ctx,
+	 struct mtk_dip_ctx_queue *queue,
+	 u32 format);
+
+static int mtk_dip_ctx_process_frame(struct mtk_dip_ctx *dev_ctx,
+				     struct mtk_dip_ctx_frame_bundle
+				     *frame_bundle);
+
+static int mtk_dip_ctx_free_frame(struct mtk_dip_ctx *dev_ctx,
+				  struct mtk_dip_ctx_frame_bundle
+				  *frame_bundle);
+
+static struct mtk_dip_ctx_frame_bundle *mtk_dip_ctx_get_free_frame
+	(struct mtk_dip_ctx *dev_ctx);
+
+static struct mtk_dip_ctx_frame_bundle *mtk_dip_ctx_get_processing_frame
+(struct mtk_dip_ctx *dev_ctx, int frame_id);
+
+static int mtk_dip_ctx_init_frame_bundles(struct mtk_dip_ctx *dev_ctx);
+
+static void mtk_dip_ctx_queue_event_frame_done
+	(struct mtk_dip_ctx *dev_ctx,
+	struct mtk_dip_dev_frame_done_event_data *fdone);
+
+static int mtk_dip_ctx_core_job_start(struct mtk_dip_ctx *dev_ctx,
+				      struct mtk_dip_ctx_start_param *param);
+
+static void debug_bundle(struct mtk_dip_ctx  *dev_ctx,
+			 struct mtk_dip_ctx_frame_bundle *bundle_data);
+
+struct vb2_v4l2_buffer *mtk_dip_ctx_buffer_get_vb2_v4l2_buffer
+(struct mtk_dip_ctx_buffer *ctx_buf)
+{
+	struct mtk_dip_dev_buffer *dev_buf = NULL;
+
+	if (!ctx_buf) {
+		pr_err("Failed to convert ctx_buf to dev_buf: NULL\n");
+		return NULL;
+	}
+
+	dev_buf	= mtk_dip_ctx_buf_to_dev_buf(ctx_buf);
+
+	return &dev_buf->m2m2_buf.vbb;
+}
+
+/* The helper to configure the device context */
+int mtk_dip_ctx_core_steup(struct mtk_dip_ctx *ctx,
+			   struct mtk_dip_ctx_setting *ctx_setting)
+{
+	if (!ctx || !ctx_setting)
+		return -EINVAL;
+
+	ctx->device_name = ctx_setting->device_name;
+
+	return 0;
+}
+
+int mtk_dip_ctx_core_queue_setup(struct mtk_dip_ctx *ctx,
+				 struct mtk_dip_ctx_queues_setting
+				 *queues_setting)
+{
+	int queue_idx = 0;
+	int i = 0;
+
+	for (i = 0; i < queues_setting->total_output_queues; i++) {
+		struct mtk_dip_ctx_queue_desc *queue_desc =
+			queues_setting->output_queue_descs + i;
+
+		if (!queue_desc)
+			return -EINVAL;
+
+		ctx->queue[queue_idx].desc = *queue_desc;
+		queue_idx++;
+	}
+
+	ctx->queues_attr.input_offset = queue_idx;
+
+	/* Setup the capture queue */
+	for (i = 0; i < queues_setting->total_capture_queues; i++) {
+		struct mtk_dip_ctx_queue_desc *queue_desc =
+			queues_setting->capture_queue_descs + i;
+
+		if (!queue_desc)
+			return -EINVAL;
+
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
+int mtk_dip_ctx_core_init(struct mtk_dip_ctx *ctx,
+			  struct platform_device *pdev, int ctx_id,
+	struct mtk_dip_ctx_desc *ctx_desc,
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
+		dev_err(&pdev->dev,
+			"Failed to alloc vb2 dma ctx: smem_vb2_alloc_ctx");
+
+	if (IS_ERR((__force void *)ctx->default_vb2_alloc_ctx))
+		dev_err(&pdev->dev,
+			"Failed to alloc vb2 dma ctx: default_vb2_alloc_ctx");
+
+	ctx->pdev = pdev;
+	ctx->ctx_id = ctx_id;
+	/* keep th smem pdev to use related iommu functions */
+	ctx->smem_device = smem_pdev;
+
+	/* Will set default enabled after passing the unit test */
+	ctx->mode = MTK_DIP_CTX_MODE_DEBUG_OFF;
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_core_init);
+
+int mtk_dip_ctx_core_exit(struct mtk_dip_ctx *ctx)
+{
+	ctx->smem_vb2_alloc_ctx = NULL;
+	ctx->default_vb2_alloc_ctx = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_core_exit);
+
+/* Get the corrospnd FH of a specific buffer */
+int mtk_dip_ctx_next_global_frame_sequence(struct mtk_dip_ctx *ctx,
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_next_global_frame_sequence);
+
+static void mtk_dip_ctx_buffer_done
+	(struct mtk_dip_ctx_buffer *ctx_buf, int state)
+{
+		if (!ctx_buf ||
+		    state != MTK_DIP_CTX_BUFFER_DONE ||
+			state != MTK_DIP_CTX_BUFFER_FAILED)
+			return;
+
+		ctx_buf->state = state;
+}
+
+int mtk_dip_ctx_core_job_finish(struct mtk_dip_ctx *dev_ctx,
+				struct mtk_dip_ctx_finish_param *param)
+{
+	int i = 0;
+	struct platform_device *pdev = dev_ctx->pdev;
+	struct mtk_dip_ctx_finish_param *fram_param =
+		(struct mtk_dip_ctx_finish_param *)param;
+	struct mtk_dip_dev *isp_dev = NULL;
+	struct mtk_dip_ctx_frame_bundle *frame = NULL;
+	enum vb2_buffer_state vbf_state = VB2_BUF_STATE_DONE;
+	enum mtk_dip_ctx_buffer_state ctxf_state =
+		MTK_DIP_CTX_BUFFER_DONE;
+	int master_queue = 0;
+
+	struct mtk_dip_dev_frame_done_event_data fdone;
+	const int ctx_id =
+		MTK_DIP_GET_CTX_ID_FROM_SEQUENCE(fram_param->frame_id);
+	u64 timestamp = 0;
+
+	dev_dbg(&dev_ctx->pdev->dev,
+		"mtk_dip_ctx_core_job_finish_cb:param(%llx),pdev(%llx)\n",
+		(unsigned long long)param, (unsigned long long)pdev);
+
+	if (!dev_ctx)
+		dev_err(&dev_ctx->pdev->dev,
+			"dev_ctx can't be null, can't release the frame\n");
+
+	isp_dev = mtk_dip_ctx_to_dev(dev_ctx);
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
+	frame = mtk_dip_ctx_get_processing_frame(&isp_dev->ctx,
+						 fram_param->frame_id);
+
+	if (!frame) {
+		dev_err(&isp_dev->pdev->dev,
+			"Can't find the frame boundle, Frame(%d)\n",
+			fram_param->frame_id);
+		return -EINVAL;
+	}
+
+	if (fram_param->state == MTK_DIP_CTX_FRAME_DATA_ERROR) {
+		vbf_state = VB2_BUF_STATE_ERROR;
+		ctxf_state = MTK_DIP_CTX_BUFFER_FAILED;
+	}
+
+	/* Set the buffer's VB2 status so that the user can dequeue */
+	/* the buffer */
+	timestamp = ktime_get_ns();
+	for (i = 0; i <= frame->last_index; i++) {
+		struct mtk_dip_ctx_buffer *ctx_buf = frame->buffers[i];
+
+		if (!ctx_buf) {
+			dev_dbg(&isp_dev->pdev->dev,
+				"ctx_buf(queue id= %d) of frame(%d)is NULL\n",
+				i, fram_param->frame_id);
+			continue;
+		} else {
+			struct vb2_v4l2_buffer *b =
+				mtk_dip_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
+			b->vb2_buf.timestamp = ktime_get_ns();
+			mtk_dip_ctx_buffer_done(ctx_buf, ctxf_state);
+			mtk_dip_v4l2_buffer_done(&b->vb2_buf, vbf_state);
+		}
+	}
+
+	master_queue = isp_dev->ctx.queues_attr.master;
+
+	fdone.frame_id = frame->id;
+
+	/* Notify the user frame process done */
+	mtk_dip_ctx_queue_event_frame_done(&isp_dev->ctx, &fdone);
+	mtk_dip_ctx_free_frame(&isp_dev->ctx, frame);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_core_job_finish);
+
+/* structure mtk_dip_ctx_finish_param must be the first elemt of param */
+/* So that the buffer can be return to vb2 queue successfully */
+int mtk_dip_ctx_core_finish_param_init(void *param, int frame_id, int state)
+{
+	struct mtk_dip_ctx_finish_param *fram_param =
+		(struct mtk_dip_ctx_finish_param *)param;
+	fram_param->frame_id = frame_id;
+	fram_param->state = state;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_core_finish_param_init);
+
+void mtk_dip_ctx_frame_bundle_add(struct mtk_dip_ctx *ctx,
+				  struct mtk_dip_ctx_frame_bundle *bundle,
+	struct mtk_dip_ctx_buffer *ctx_buf)
+{
+	int queue_id = 0;
+	struct mtk_dip_ctx_queue *ctx_queue = NULL;
+
+	if (!bundle || !ctx_buf) {
+		dev_err(&ctx->pdev->dev,
+			"Add buffer to frame bundle failed, bundle(%llx),buf(%llx)\n",
+			(long long)bundle, (long long)ctx_buf);
+		return;
+	}
+
+	queue_id = ctx_buf->queue;
+
+	if (bundle->buffers[queue_id])
+		dev_warn(&ctx->pdev->dev,
+			 "Queue(%d) buffer overwrite\n",
+			 queue_id);
+
+	dev_dbg(&ctx->pdev->dev, "Add queue(%d) buffer%llx\n",
+		queue_id, (unsigned long long)ctx_buf);
+		bundle->buffers[queue_id] = ctx_buf;
+
+	/* Fill context queue related information */
+	ctx_queue = &ctx->queue[queue_id];
+
+	if (!ctx_queue) {
+		dev_err(&ctx->pdev->dev,
+			"Can't find ctx queue (%d)\n", queue_id);
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_frame_bundle_add);
+
+static void debug_bundle(struct mtk_dip_ctx *dev_ctx,
+			 struct mtk_dip_ctx_frame_bundle *bundle_data)
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
+int mtk_dip_ctx_trigger_job(struct mtk_dip_ctx *dev_ctx,
+			    struct mtk_dip_ctx_frame_bundle *bundle_data)
+{
+	/* Scan all buffers and filled the ipi frame data*/
+	int i = 0;
+	struct mtk_dip_ctx_start_param s_param;
+	struct mtk_dip_ctx_finish_param fram_param;
+
+	struct mtk_dip_ctx_frame_bundle *bundle	=
+		mtk_dip_ctx_get_free_frame(dev_ctx);
+
+	memset(&s_param, 0,
+	       sizeof(struct mtk_dip_ctx_start_param));
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
+	       sizeof(struct mtk_dip_ctx_buffer *)
+			* MTK_DIP_CTX_FRAME_BUNDLE_BUFFER_MAX);
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
+		mtk_dip_ctx_next_global_frame_sequence(dev_ctx,
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
+		struct mtk_dip_ctx_buffer *ctx_buf = bundle->buffers[i];
+		struct vb2_v4l2_buffer *b = NULL;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Process queue[%d], ctx_buf:(%llx)\n",
+			i,
+			(unsigned long long)ctx_buf);
+
+		if (!ctx_buf) {
+			dev_dbg(&dev_ctx->pdev->dev,
+				"queue[%d], ctx_buf is NULL!!\n", i);
+			continue;
+		}
+
+		b = mtk_dip_ctx_buffer_get_vb2_v4l2_buffer(ctx_buf);
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
+		ctx_buf->buffer_usage = dev_ctx->queue[i].buffer_usage;
+		ctx_buf->rotation = dev_ctx->queue[i].rotation;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Buf: queue(%d), vaddr(%llx), daddr(%llx)",
+			ctx_buf->queue, (unsigned long long)ctx_buf->vaddr,
+			(unsigned long long)ctx_buf->daddr);
+
+		if (dev_ctx->queue[ctx_buf->queue].desc.smem_alloc) {
+			ctx_buf->paddr =
+				mtk_dip_smem_iova_to_phys
+				(&dev_ctx->smem_device->dev,
+				 ctx_buf->daddr);
+		} else {
+			dev_dbg(&dev_ctx->pdev->dev,
+				"No pa provided: not physical continuous\n");
+			ctx_buf->paddr = 0;
+		}
+		ctx_buf->state = MTK_DIP_CTX_BUFFER_PROCESSING;
+	}
+
+	if (mtk_dip_ctx_process_frame(dev_ctx, bundle)) {
+		dev_err(&dev_ctx->pdev->dev,
+			"mtk_dip_ctx_process_frame failed: frame(%d)\n",
+			bundle->id);
+		goto FAILE_JOB_NOT_TRIGGER;
+	}
+
+	if (dev_ctx->mode ==
+			MTK_DIP_CTX_MODE_DEBUG_BYPASS_JOB_TRIGGER) {
+		memset(&fram_param, 0,
+		       sizeof(struct mtk_dip_ctx_finish_param));
+		fram_param.frame_id = bundle->id;
+		fram_param.state = MTK_DIP_CTX_FRAME_DATA_DONE;
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Ctx(%d) in HW bypass mode, will not trigger hw\n",
+			dev_ctx->ctx_id);
+		mtk_dip_ctx_core_job_finish(dev_ctx,
+					    (void *)&fram_param);
+		return 0;
+	}
+
+	if (mtk_dip_ctx_core_job_start(dev_ctx, &s_param))
+		goto FAILE_JOB_NOT_TRIGGER;
+
+	return 0;
+
+FAILE_JOB_NOT_TRIGGER:
+	dev_err(&dev_ctx->pdev->dev,
+		"FAILE_JOB_NOT_TRIGGER: init fram_param: %llx\n",
+		(unsigned long long)&fram_param);
+	memset(&fram_param, 0, sizeof(struct mtk_dip_ctx_finish_param));
+	fram_param.frame_id = bundle->id;
+	fram_param.state = MTK_DIP_CTX_FRAME_DATA_ERROR;
+	dev_dbg(&dev_ctx->pdev->dev,
+		"Call mtk_dip_ctx_core_job_finish_cb: fram_param: %llx",
+		(unsigned long long)&fram_param);
+	mtk_dip_ctx_core_job_finish(dev_ctx, (void *)&fram_param);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_trigger_job);
+
+void mtk_dip_ctx_buf_init(struct mtk_dip_ctx_buffer *b,
+			  unsigned int queue, dma_addr_t daddr)
+{
+	b->state = MTK_DIP_CTX_BUFFER_NEW;
+	b->queue = queue;
+	b->daddr = daddr;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_buf_init);
+
+enum mtk_dip_ctx_buffer_state
+	mtk_dip_ctx_get_buffer_state(struct mtk_dip_ctx_buffer *b)
+{
+	return b->state;
+}
+
+int mtk_dip_ctx_is_streaming(struct mtk_dip_ctx *ctx)
+{
+	return ctx->streaming;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_is_streaming);
+
+int mtk_dip_ctx_init_frame_bundles(struct mtk_dip_ctx *dev_ctx)
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
+		struct mtk_dip_ctx_frame_bundle *frame_bundle =
+			&dev_ctx->frame_bundles[i];
+		frame_bundle->state = MTK_DIP_CTX_FRAME_NEW;
+		list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
+	}
+
+	spin_unlock(&dev_ctx->qlock);
+
+	return 0;
+}
+
+static int mtk_dip_ctx_process_frame(struct mtk_dip_ctx *dev_ctx,
+				     struct mtk_dip_ctx_frame_bundle
+				     *frame_bundle)
+{
+	spin_lock(&dev_ctx->qlock);
+
+	frame_bundle->state = MTK_DIP_CTX_FRAME_PROCESSING;
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
+struct mtk_dip_ctx_frame_bundle *mtk_dip_ctx_get_processing_frame
+(struct mtk_dip_ctx *dev_ctx, int frame_id)
+{
+	struct mtk_dip_ctx_frame_bundle *frame_bundle = NULL;
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
+static int mtk_dip_ctx_free_frame(struct mtk_dip_ctx *dev_ctx,
+				  struct mtk_dip_ctx_frame_bundle *frame_bundle)
+{
+	spin_lock(&dev_ctx->qlock);
+
+	frame_bundle->state = MTK_DIP_CTX_FRAME_NEW;
+	list_del(&frame_bundle->list);
+	list_add_tail(&frame_bundle->list, &dev_ctx->free_frames.list);
+
+	spin_unlock(&dev_ctx->qlock);
+
+	return 0;
+}
+
+static struct mtk_dip_ctx_frame_bundle *mtk_dip_ctx_get_free_frame
+	(struct mtk_dip_ctx *dev_ctx)
+{
+	struct mtk_dip_ctx_frame_bundle *frame_bundle = NULL;
+
+	spin_lock(&dev_ctx->qlock);
+	list_for_each_entry(frame_bundle,
+			    &dev_ctx->free_frames.list, list){
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Check frame: state %d, new should be %d\n",
+			frame_bundle->state, MTK_DIP_CTX_FRAME_NEW);
+		if (frame_bundle->state == MTK_DIP_CTX_FRAME_NEW) {
+			frame_bundle->state = MTK_DIP_CTX_FRAME_PREPARED;
+			dev_dbg(&dev_ctx->pdev->dev, "Found free frame\n");
+			spin_unlock(&dev_ctx->qlock);
+			return frame_bundle;
+		}
+	}
+	spin_unlock(&dev_ctx->qlock);
+	dev_err(&dev_ctx->pdev->dev,
+		"Can't found any bundle is MTK_DIP_CTX_FRAME_NEW\n");
+	return NULL;
+}
+
+int mtk_dip_ctx_finish_frame(struct mtk_dip_ctx *dev_ctx,
+			     struct mtk_dip_ctx_frame_bundle *frame_bundle,
+			     int done)
+{
+	spin_lock(&dev_ctx->qlock);
+	frame_bundle->state = MTK_DIP_CTX_FRAME_PROCESSING;
+	list_add_tail(&frame_bundle->list, &dev_ctx->processing_frames.list);
+	spin_unlock(&dev_ctx->qlock);
+	return 0;
+}
+
+static void mtk_dip_ctx_queue_event_frame_done
+	(struct mtk_dip_ctx *dev_ctx,
+	struct mtk_dip_dev_frame_done_event_data *fdone)
+{
+	struct v4l2_event event;
+	/* Carried the frame done information in */
+	/* data field of event */
+	struct mtk_dip_dev_frame_done_event_data *evt_frame_data =
+		(void *)event.u.data;
+
+	memset(&event, 0, sizeof(event));
+
+	evt_frame_data->frame_id = fdone->frame_id;
+
+	event.type = V4L2_EVENT_MTK_DIP_FRAME_DONE;
+	v4l2_event_queue_fh(&dev_ctx->fh->vfh, &event);
+}
+
+static void set_img_fmt(struct v4l2_pix_format_mplane *mfmt_to_fill,
+			struct mtk_dip_ctx_format *ctx_fmt)
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
+		int bpl = (mfmt_to_fill->width *
+			ctx_fmt->fmt.img.row_depth[i]) / 8;
+		int sizeimage = (mfmt_to_fill->width * mfmt_to_fill->height *
+			ctx_fmt->fmt.img.depth[i]) / 8;
+
+		mfmt_to_fill->plane_fmt[i].bytesperline = bpl;
+
+		mfmt_to_fill->plane_fmt[i].sizeimage = sizeimage;
+
+		pr_debug("plane(%d):bpl(%d),sizeimage(%u)\n",
+			 i,  bpl,
+			 mfmt_to_fill->plane_fmt[i].sizeimage);
+	}
+}
+
+static void set_meta_fmt(struct v4l2_meta_format *metafmt_to_fill,
+			 struct mtk_dip_ctx_format *ctx_fmt)
+{
+	metafmt_to_fill->dataformat = ctx_fmt->fmt.meta.dataformat;
+
+	if (ctx_fmt->fmt.meta.max_buffer_size <= 0 ||
+	    ctx_fmt->fmt.meta.max_buffer_size
+				> MTK_DIP_CTX_META_BUF_DEFAULT_SIZE){
+		pr_warn("buf size of meta(%u) can't be 0, use default %u\n",
+			ctx_fmt->fmt.meta.dataformat,
+			MTK_DIP_CTX_META_BUF_DEFAULT_SIZE);
+		metafmt_to_fill->buffersize = MTK_DIP_CTX_META_BUF_DEFAULT_SIZE;
+	} else {
+		pr_debug("Load the meta size setting %u\n",
+			 ctx_fmt->fmt.meta.max_buffer_size);
+		metafmt_to_fill->buffersize = ctx_fmt->fmt.meta.max_buffer_size;
+	}
+}
+
+/* Get the default format setting */
+int mtk_dip_ctx_format_load_default_fmt(struct mtk_dip_ctx_queue *queue,
+					struct v4l2_format *fmt_to_fill)
+{
+	struct mtk_dip_ctx_format *ctx_fmt = NULL;
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
+			node_fmt->width = MTK_DIP_OUTPUT_MAX_WIDTH;
+			node_fmt->height = MTK_DIP_OUTPUT_MAX_HEIGHT;
+		} else {
+			fmt_to_fill->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+			node_fmt->width = MTK_DIP_INPUT_MAX_WIDTH;
+			node_fmt->height = MTK_DIP_INPUT_MAX_HEIGHT;
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_format_load_default_fmt);
+
+static struct mtk_dip_ctx_format *mtk_dip_ctx_find_fmt
+	(struct mtk_dip_ctx *dev_ctx,
+	 struct mtk_dip_ctx_queue *queue,
+	 u32 format)
+{
+	int i;
+	struct mtk_dip_ctx_format *ctx_fmt;
+
+	dev_dbg(&dev_ctx->pdev->dev, "fmt to find(%x)\n", format);
+	for (i = 0; i < queue->desc.num_fmts; i++) {
+		ctx_fmt = &queue->desc.fmts[i];
+		if (queue->desc.image) {
+			dev_dbg(&dev_ctx->pdev->dev,
+				"idx(%d), pixelformat(%x), fmt(%x)\n",
+				i, ctx_fmt->fmt.img.pixelformat, format);
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
+int mtk_dip_ctx_fmt_set_meta(struct mtk_dip_ctx *dev_ctx,
+			     int queue_id,
+	struct v4l2_meta_format *user_fmt,
+	struct v4l2_meta_format *node_fmt
+	)
+{
+	struct mtk_dip_ctx_queue *queue = NULL;
+	struct mtk_dip_ctx_format *ctx_fmt;
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
+	ctx_fmt = mtk_dip_ctx_find_fmt(dev_ctx, queue,
+				       user_fmt->dataformat);
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_fmt_set_meta);
+
+int mtk_dip_ctx_fmt_set_img(struct mtk_dip_ctx *dev_ctx,
+			    int queue_id,
+	struct v4l2_pix_format_mplane *user_fmt,
+	struct v4l2_pix_format_mplane *node_fmt)
+{
+	struct mtk_dip_ctx_queue *queue = NULL;
+	struct mtk_dip_ctx_format *ctx_fmt;
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
+	ctx_fmt = mtk_dip_ctx_find_fmt(dev_ctx, queue,
+				       user_fmt->pixelformat);
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
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_fmt_set_img);
+
+int mtk_dip_ctx_streamon(struct mtk_dip_ctx *dev_ctx)
+{
+	int r = 0;
+
+	if (!dev_ctx)
+		return -EINVAL;
+
+	if (dev_ctx->streaming) {
+		dev_dbg(&dev_ctx->pdev->dev,
+			"ctx(%d): device already stream on\n",
+			dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	r = mtk_dip_streamon(dev_ctx->pdev, dev_ctx->ctx_id);
+
+	if (r) {
+		dev_err(&dev_ctx->pdev->dev,
+			"ctx(%d):failed to start hw\n",
+			dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	dev_ctx->streaming = 1;
+
+	dev_dbg(&dev_ctx->pdev->dev,
+		"ctx(%d):start hw\n", dev_ctx->ctx_id);
+
+	r = mtk_dip_dev_queue_buffers(mtk_dip_ctx_to_dev(dev_ctx),
+				      1);
+
+	if (r)
+		dev_err(&dev_ctx->pdev->dev,
+			"ctx(%d):failed to queue initial buffers (%d)",
+			dev_ctx->ctx_id, r);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_streamon);
+
+int mtk_dip_ctx_streamoff(struct mtk_dip_ctx *dev_ctx)
+{
+	int r = 0;
+
+	if (!dev_ctx)
+		return -EINVAL;
+
+	if (!dev_ctx->streaming) {
+		dev_warn(&dev_ctx->pdev->dev,
+			 "ctx(%d):device already stream off\n",
+			 dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	r = mtk_dip_streamoff(dev_ctx->pdev, dev_ctx->ctx_id);
+
+	if (r) {
+		dev_warn(&dev_ctx->pdev->dev,
+			 "ctx(%d):failed to stop hw\n",
+			 dev_ctx->ctx_id);
+		return -EBUSY;
+	}
+
+	dev_ctx->streaming = 0;
+
+	dev_dbg(&dev_ctx->pdev->dev, "ctx(%d):stop hw\n",
+		dev_ctx->ctx_id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_streamoff);
+
+int mtk_dip_ctx_open(struct mtk_dip_ctx *dev_ctx)
+{
+	if (!dev_ctx)
+		return -EINVAL;
+
+	dev_dbg(&dev_ctx->pdev->dev, "open ctx(%d):dev(%llx)\n",
+		dev_ctx->ctx_id,
+		(long long)&dev_ctx->pdev->dev);
+
+	/* Workaround for SCP EMI access */
+	mtk_dip_smem_enable_mpu(&dev_ctx->smem_device->dev);
+
+	/* Init the frame bundle pool */
+	mtk_dip_ctx_init_frame_bundles(dev_ctx);
+
+	return mtk_dip_open(dev_ctx->pdev);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_open);
+
+int mtk_dip_ctx_release(struct mtk_dip_ctx *dev_ctx)
+{
+	if (!dev_ctx)
+		return -EINVAL;
+
+	dev_dbg(&dev_ctx->pdev->dev, "release ctx(%d):dev(%llx)\n",
+		dev_ctx->ctx_id,
+		(long long)&dev_ctx->pdev->dev);
+
+	return mtk_dip_release(dev_ctx->pdev);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_release);
+
+#ifdef MTK_DIP_CTX_DIP_V4L2_UT
+static int check_and_refill_dip_ut_start_ipi_param
+	(struct img_ipi_frameparam *ipi_param,
+	 struct mtk_dip_ctx_buffer *ctx_buf_in,
+	 struct mtk_dip_ctx_buffer *ctx_buf_out)
+{
+	/* Check the buffer size information from user space */
+	int ret = 0;
+	unsigned char *buffer_ptr = NULL;
+	const unsigned int src_width = 3264;
+	const unsigned int src_height = 1836;
+	const unsigned int dst_width = 1920;
+	const unsigned int dst_height = 1080;
+	const unsigned int in_stride_size =
+		sizeof(g_imgi_array_3264x1836_b10) / src_height;
+	const unsigned int out_size = dst_width * dst_height * 2;
+	const unsigned int out_stride_size = dst_width * 2;
+	const unsigned int crop_top = 0;
+	const unsigned int crop_left = 0;
+	const unsigned int crop_width = src_width;
+	const unsigned int crop_height = src_height;
+	const unsigned int crop_left_subpix = 0;
+	const unsigned int crop_top_subpix = 0;
+	const unsigned int crop_width_subpix = 0;
+	const unsigned int crop_height_subpix = 0;
+	const unsigned int rotation = 0;
+
+	/* Copy the image to the buffer address */
+	if (!ctx_buf_in) {
+		pr_err("[CHK] ctx_buf_in(%llx) can't be NULL\n",
+		       (unsigned long long)ctx_buf_in);
+		ret = -EINVAL;
+	} else {
+		if (!ctx_buf_in->vaddr) {
+			pr_err("[CHK] ctx_buf_in(%llx)->vaddr(%llx) can't be NULL\n",
+			       (unsigned long long)ctx_buf_in,
+				(unsigned long long)ctx_buf_in->vaddr);
+			ret = -EINVAL;
+		}
+		buffer_ptr = ctx_buf_in->vaddr;
+		pr_err("[CHK] Load image data(%llx) to vaddr(%llx)\n",
+		       (unsigned long long)g_imgi_array_3264x1836_b10,
+		(unsigned long long)buffer_ptr);
+		memcpy(buffer_ptr, g_imgi_array_3264x1836_b10,
+		       sizeof(g_imgi_array_3264x1836_b10));
+	}
+
+	if (ipi_param->num_inputs != 1 ||
+	    ipi_param->num_outputs != 1 ||
+	    ipi_param->type != STREAM_ISP_IC) {
+		pr_err("PARAM-CHK:Failed,num_in(%d),num_out(%d),type(%d)\n",
+		       ipi_param->num_inputs, ipi_param->num_outputs,
+			ipi_param->type);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.format.width !=
+			src_width ||
+		ipi_param->inputs[0].buffer.format.height !=
+			src_height) {
+		pr_err("PARAM-CHK:Failed,input w(%d),h(%d) should be w(%d),h(%d)\n",
+		       ipi_param->inputs[0].buffer.format.width,
+			ipi_param->inputs[0].buffer.format.height,
+			src_width,
+			src_height);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.format.colorformat
+			!= MDP_COLOR_BAYER10) {
+		pr_err("PARAM-CHK:Failed,input colorformat(%d) should be(%d)\n",
+		       ipi_param->inputs[0].buffer.format.colorformat,
+			MDP_COLOR_BAYER10);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.format.plane_fmt[0].size
+			!= sizeof(g_imgi_array_3264x1836_b10)) {
+		pr_err("[CHK]Failed,input size(%u) should be(%ld)\n",
+		       ipi_param->inputs[0].buffer.format.plane_fmt[0].size,
+			sizeof(g_imgi_array_3264x1836_b10));
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.format.plane_fmt[0].stride
+			!= in_stride_size) {
+		pr_err("[CHK]Failed,intput stride size(%d) should be(%d)\n",
+		       ipi_param->inputs[0].buffer.format.plane_fmt[0].stride,
+			in_stride_size);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.format.ycbcr_prof != 1) {
+		pr_err("[CHK]Failed,intput ycbcr_prof(%d) should be(%d)\n",
+		       ipi_param->inputs[0].buffer.format.ycbcr_prof,
+			1);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->inputs[0].buffer.usage != 0) {
+		pr_err("[CHK]Failed, input buffer usage (%d) should be(%d)\n",
+		       ipi_param->inputs[0].buffer.usage,
+			0);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.usage != 0) {
+		pr_err("[CHK]Failed, output buffer usage (%d) should be(%d)\n",
+		       ipi_param->outputs[0].buffer.usage,
+			0);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.format.width != dst_width ||
+	    ipi_param->outputs[0].buffer.format.height != dst_height) {
+		pr_err("[CHK]Failed,output w(%d),h(%d) should be w(%d),h(%d)\n",
+		       ipi_param->outputs[0].buffer.format.width,
+			ipi_param->outputs[0].buffer.format.height,
+			dst_width,
+			dst_width);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.format.colorformat
+			!= MDP_COLOR_YUYV) {
+		pr_err("[CHK]Failed,input colorformat(%d) should be(%d)\n",
+		       ipi_param->outputs[0].buffer.format.colorformat,
+			MDP_COLOR_YUYV);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.format.ycbcr_prof
+			!= 0) {
+		pr_err("[CHK]Failed,intput ycbcr_prof(%d) should be(%d)\n",
+		       ipi_param->outputs[0].buffer.format.ycbcr_prof,
+			0);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.format.plane_fmt[0].size
+			!= out_size) {
+		pr_err("[CHK]Failed,input size(%u) should be(%u)\n",
+		       ipi_param->outputs[0].buffer.format.plane_fmt[0].size,
+			out_size);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].buffer.format.plane_fmt[0].stride
+			!= out_stride_size) {
+		pr_err("[CHK]Failed,output stride size(%d) should be(%d)\n",
+		       ipi_param->outputs[0].buffer.format.plane_fmt[0].stride,
+			out_stride_size);
+		ret = -EINVAL;
+	}
+
+	if (ipi_param->outputs[0].crop.left != crop_left ||
+	    ipi_param->outputs[0].crop.top != crop_top ||
+		ipi_param->outputs[0].crop.width != crop_width ||
+		ipi_param->outputs[0].crop.height != crop_height ||
+		ipi_param->outputs[0].crop.left_subpix != crop_left_subpix ||
+		ipi_param->outputs[0].crop.top_subpix != crop_top_subpix ||
+		ipi_param->outputs[0].crop.width_subpix != crop_width_subpix ||
+		ipi_param->outputs[0].crop.height_subpix !=
+			crop_height_subpix ||
+		ipi_param->outputs[0].rotation != rotation) {
+		pr_err("[CHK]Failed, crop setting: c_l(%d),c_t(%d),c_w(%d),c_h(%d)\n"
+			ipi_param->outputs[0].crop.left,
+			ipi_param->outputs[0].crop.top,
+			ipi_param->outputs[0].crop.width,
+			ipi_param->outputs[0].crop.height);
+		pr_err("c_ls(%d),c_ts(%d),c_ws(%d),c_hs(%d),r(%d)\n",
+		       ipi_param->outputs[0].crop.left_subpix,
+			ipi_param->outputs[0].crop.top_subpix,
+			ipi_param->outputs[0].crop.width_subpix,
+			ipi_param->outputs[0].crop.height_subpix,
+			ipi_param->outputs[0].rotation);
+
+		pr_err("[CHK]crop setting must be: c_l(%d),c_t(%d),c_w(%d),c_h(%d)\n"
+			crop_left, crop_top, crop_width, crop_height);
+
+		pr_err("c_ls(%d),c_ts(%d),c_ws(%d),c_hs(%d),r(%d)\n",
+		       crop_left_subpix, crop_top_subpix, crop_width_subpix,
+			crop_height_subpix, rotation);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+#endif /* MTK_DIP_CTX_DIP_V4L2_UT */
+
+static enum mdp_ycbcr_profile map_ycbcr_prof_mplane
+	(struct v4l2_pix_format_mplane *pix_mp,
+	 u32 mdp_color)
+{
+	if (MDP_COLOR_IS_RGB(mdp_color))
+		return MDP_YCBCR_PROFILE_FULL_BT601;
+
+	switch (pix_mp->colorspace) {
+	case V4L2_COLORSPACE_JPEG:
+		return MDP_YCBCR_PROFILE_JPEG;
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_DCI_P3:
+		if (pix_mp->quantization == V4L2_QUANTIZATION_FULL_RANGE)
+			return MDP_YCBCR_PROFILE_FULL_BT709;
+		return MDP_YCBCR_PROFILE_BT709;
+	case V4L2_COLORSPACE_BT2020:
+		if (pix_mp->quantization == V4L2_QUANTIZATION_FULL_RANGE)
+			return MDP_YCBCR_PROFILE_FULL_BT2020;
+		return MDP_YCBCR_PROFILE_BT2020;
+	}
+	/* V4L2_COLORSPACE_SRGB or else */
+	if (pix_mp->quantization == V4L2_QUANTIZATION_FULL_RANGE)
+		return MDP_YCBCR_PROFILE_FULL_BT601;
+	return MDP_YCBCR_PROFILE_BT601;
+}
+
+/* Stride that is accepted by MDP HW */
+/* Required MDP macro: */
+/* - MDP_COLOR_BITS_PER_PIXEL */
+/* - MDP_COLOR_GET_PLANE_COUNT */
+/* - MDP_COLOR_IS_BLOCK_MODE */
+static u32 dip_mdp_fmt_get_stride(const struct mtk_dip_ctx_mdp_format *fmt,
+				  u32 bytesperline, unsigned int plane)
+{
+	enum mdp_color c = fmt->mdp_color;
+	u32 stride;
+
+	stride = (bytesperline * MDP_COLOR_BITS_PER_PIXEL(c))
+		/ fmt->row_depth[0];
+	if (plane == 0)
+		return stride;
+	if (plane < MDP_COLOR_GET_PLANE_COUNT(c)) {
+		if (MDP_COLOR_IS_BLOCK_MODE(c))
+			stride = stride / 2;
+		return stride;
+	}
+	return 0;
+}
+
+/* Stride that is accepted by MDP HW of format with contiguous planes */
+/* - MDP_COLOR_GET_PLANE_COUNT */
+/* - MDP_COLOR_GET_H_SUBSAMPLE */
+/* - MDP_COLOR_IS_UV_COPLANE */
+/* - MDP_COLOR_IS_BLOCK_MODE */
+static u32 dip_mdp_fmt_get_stride_contig
+	(const struct mtk_dip_ctx_mdp_format *fmt,
+	 u32 pix_stride, unsigned int plane)
+{
+	enum mdp_color c = fmt->mdp_color;
+	u32 stride = pix_stride;
+
+	if (plane == 0)
+		return stride;
+	if (plane < MDP_COLOR_GET_PLANE_COUNT(c)) {
+		stride = stride >> MDP_COLOR_GET_H_SUBSAMPLE(c);
+		if (MDP_COLOR_IS_UV_COPLANE(c) && !MDP_COLOR_IS_BLOCK_MODE(c))
+			stride = stride * 2;
+		return stride;
+	}
+	return 0;
+}
+
+/* Plane size that is accepted by MDP HW */
+/* Stride that is accepted by MDP HW of format with contiguous planes */
+/* - MDP_COLOR_BITS_PER_PIXEL */
+/* - MDP_COLOR_GET_PLANE_COUNT */
+/* - MDP_COLOR_GET_V_SUBSAMPLE */
+/* - MDP_COLOR_IS_BLOCK_MODE */
+static u32 dip_mdp_fmt_get_plane_size
+	(const struct mtk_dip_ctx_mdp_format *fmt,
+	 u32 stride, u32 height, unsigned int plane)
+{
+	enum mdp_color c = fmt->mdp_color;
+	u32 bytesperline;
+
+	bytesperline = (stride * fmt->row_depth[0])
+		/ MDP_COLOR_BITS_PER_PIXEL(c);
+	if (plane == 0)
+		return bytesperline * height;
+	if (plane < MDP_COLOR_GET_PLANE_COUNT(c)) {
+		height = height >> MDP_COLOR_GET_V_SUBSAMPLE(c);
+		if (MDP_COLOR_IS_BLOCK_MODE(c))
+			bytesperline = bytesperline * 2;
+		return bytesperline * height;
+	}
+	return 0;
+}
+
+static int is_contig_mp_buffer(struct mtk_dip_ctx_buffer *ctx_buf)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &ctx_buf->fmt.pix_mp;
+
+	if (MDP_COLOR_GET_PLANE_COUNT(ctx_buf->ctx_fmt->fmt.img.mdp_color)
+	    == 1) {
+		/* debug only */
+		if (pix_mp->pixelformat == V4L2_PIX_FMT_YVU420)
+			pr_err("YVU420 should not be contig_mp_buffer\n");
+		return 0;
+	} else {
+		return 1;
+	}
+}
+
+static int fill_ipi_img_param_mp(struct mtk_dip_ctx *dev_ctx,
+				 struct img_image_buffer *b,
+				 struct mtk_dip_ctx_buffer *ctx_buf,
+				 char *buf_name)
+{
+	struct v4l2_pix_format_mplane *pix_mp = NULL;
+	struct mtk_dip_ctx_mdp_format *mdp_fmt = NULL;
+	unsigned int i;
+	unsigned int total_plane_size = 0;
+
+	if (!ctx_buf->ctx_fmt) {
+		dev_err(&dev_ctx->pdev->dev,
+			"%s's ctx format not set\n", buf_name);
+		return -EINVAL;
+	}
+
+	pix_mp = &ctx_buf->fmt.pix_mp;
+	mdp_fmt = &ctx_buf->ctx_fmt->fmt.img;
+
+	b->format.colorformat = ctx_buf->ctx_fmt->fmt.img.mdp_color;
+	b->format.width = ctx_buf->fmt.pix_mp.width;
+	b->format.height = ctx_buf->fmt.pix_mp.height;
+	b->format.ycbcr_prof =
+		map_ycbcr_prof_mplane(pix_mp,
+				      ctx_buf->ctx_fmt->fmt.img.mdp_color);
+
+	dev_dbg(&dev_ctx->pdev->dev,
+		"IPI(%s): w(%d),h(%d),c(%x)\n",
+		buf_name,
+		b->format.width,
+		b->format.height,
+		b->format.colorformat);
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		u32 stride =
+			dip_mdp_fmt_get_stride
+			(mdp_fmt, pix_mp->plane_fmt[i].bytesperline, i);
+
+		b->format.plane_fmt[i].stride = stride;
+		b->format.plane_fmt[i].size =
+			dip_mdp_fmt_get_plane_size(mdp_fmt,
+						   stride,
+						   pix_mp->height, i);
+		b->iova[i] = ctx_buf->daddr;
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Contiguous-mp-buf:plane(%i),stride(%d),size(%d),iova(%llx)",
+			i,
+			b->format.plane_fmt[i].stride,
+			b->format.plane_fmt[i].size,
+			(unsigned long long)b->iova[i]);
+		total_plane_size = b->format.plane_fmt[i].size;
+	}
+
+	for (; i < MDP_COLOR_GET_PLANE_COUNT(b->format.colorformat); ++i) {
+		u32 stride =
+			dip_mdp_fmt_get_stride_contig
+			(mdp_fmt, b->format.plane_fmt[0].stride, i);
+
+		b->format.plane_fmt[i].stride = stride;
+		b->format.plane_fmt[i].size =
+			dip_mdp_fmt_get_plane_size(mdp_fmt, stride,
+						   pix_mp->height, i);
+		b->iova[i] = b->iova[i - 1] + b->format.plane_fmt[i - 1].size;
+		dev_dbg(&dev_ctx->pdev->dev,
+			"Contiguous-mp-buf:plane(%i),stride(%d),size(%d),iova(%llx)",
+			i,
+			b->format.plane_fmt[i].stride,
+			b->format.plane_fmt[i].size,
+			(unsigned long long)b->iova[i]);
+		total_plane_size += b->format.plane_fmt[i].size;
+	}
+
+	b->usage = ctx_buf->buffer_usage;
+
+	dev_dbg(&dev_ctx->pdev->dev,
+		"Contiguous-mp-buf(%s),v4l2-sizeimage(%d),total-plane-size(%d)\n",
+		buf_name,
+		pix_mp->plane_fmt[0].sizeimage,
+		total_plane_size);
+
+	return 0;
+}
+
+static int fill_ipi_img_param(struct mtk_dip_ctx *dev_ctx,
+			      struct img_image_buffer *img,
+			      struct mtk_dip_ctx_buffer *ctx_buf,
+			      char *buf_name)
+{
+		img->format.width = ctx_buf->fmt.pix_mp.width;
+		img->format.height = ctx_buf->fmt.pix_mp.height;
+
+		if (ctx_buf->ctx_fmt) {
+			img->format.colorformat =
+				ctx_buf->ctx_fmt->fmt.img.mdp_color;
+		} else {
+			dev_err(&dev_ctx->pdev->dev,
+				"%s's ctx format not set\n", buf_name);
+			return -EINVAL;
+		}
+
+		img->format.plane_fmt[0].size =
+			ctx_buf->fmt.pix_mp.plane_fmt[0].sizeimage;
+		img->format.plane_fmt[0].stride =
+			ctx_buf->fmt.pix_mp.plane_fmt[0].bytesperline;
+		img->iova[0] = ctx_buf->daddr;
+		img->usage = ctx_buf->buffer_usage;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"IPI(%s): w(%d),h(%d),c(%x),size(%d)\n",
+			buf_name,
+			img->format.width,
+			img->format.height,
+			img->format.colorformat);
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"stride(%d),ycbcr(%d),iova(%llx),u(%d)\n",
+			img->format.plane_fmt[0].size,
+			img->format.plane_fmt[0].stride,
+			img->format.ycbcr_prof,
+			(unsigned long long)img->iova[0],
+			img->usage);
+
+		return 0;
+}
+
+static int fill_input_ipi_param(struct mtk_dip_ctx *dev_ctx,
+				struct img_input *iin,
+				struct mtk_dip_ctx_buffer *ctx_buf,
+				char *buf_name)
+{
+		struct img_image_buffer *img = &iin->buffer;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"To fill ipi param for ctx(%d)\n",
+			dev_ctx->ctx_id);
+
+		/* Will map the vale with V4L2 color space in the future */
+		img->format.ycbcr_prof = 1;
+		if (is_contig_mp_buffer(ctx_buf))
+			return fill_ipi_img_param_mp(dev_ctx, img, ctx_buf,
+						     buf_name);
+		else
+			return fill_ipi_img_param(dev_ctx, img, ctx_buf,
+						  buf_name);
+}
+
+static int fill_output_ipi_param(struct mtk_dip_ctx *dev_ctx,
+				 struct img_output *iout,
+				 struct mtk_dip_ctx_buffer *ctx_buf_out,
+				 struct mtk_dip_ctx_buffer *ctx_buf_in,
+				 char *buf_name)
+{
+		int r = 0;
+		struct img_image_buffer *img = &iout->buffer;
+
+		/* Will map the vale with V4L2 color space in the future */
+		img->format.ycbcr_prof = 0;
+
+		if (is_contig_mp_buffer(ctx_buf_out))
+			r = fill_ipi_img_param_mp(dev_ctx, img, ctx_buf_out,
+						  buf_name);
+		else
+			r = fill_ipi_img_param(dev_ctx, img, ctx_buf_out,
+					       buf_name);
+
+		iout->crop.left = 0;
+		iout->crop.top = 0;
+		iout->crop.width = ctx_buf_in->fmt.pix_mp.width;
+		iout->crop.height = ctx_buf_in->fmt.pix_mp.height;
+		iout->crop.left_subpix = 0;
+		iout->crop.top_subpix = 0;
+		iout->crop.width_subpix = 0;
+		iout->crop.height_subpix = 0;
+		iout->rotation = ctx_buf_out->rotation;
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"IPI-ext(%s):c_l(%d),c_t(%d),c_w(%d),c_h(%d)\n",
+			buf_name, iout->crop.left, iout->crop.top,
+			iout->crop.width,
+			iout->crop.height);
+
+		dev_dbg(&dev_ctx->pdev->dev,
+			"c_ls(%d),c_ts(%d),c_ws(%d),c_hs(%d),r(%d)\n",
+			iout->crop.left_subpix,
+			iout->crop.top_subpix,
+			iout->crop.width_subpix, iout->crop.height_subpix,
+			iout->rotation);
+
+		return r;
+}
+
+static int mtk_dip_ctx_core_job_start(struct mtk_dip_ctx *dev_ctx,
+				      struct mtk_dip_ctx_start_param *param)
+{
+	struct platform_device *pdev = dev_ctx->pdev;
+	int i = 0;
+	int ret = 0;
+	int out_img_buf_idx = 0;
+	struct img_ipi_frameparam dip_param;
+	struct mtk_dip_ctx_buffer *ctx_buf_in = NULL;
+	struct mtk_dip_ctx_buffer *ctx_buf_out = NULL;
+	struct mtk_dip_ctx_buffer *ctx_buf_tuning = NULL;
+
+	int scan_queue_idx[] = {
+		MTK_DIP_CTX_P2_RAW_QUEUE_IN, MTK_DIP_CTX_P2_TUNING_QUEUE_IN,
+		MTK_DIP_CTX_P2_MDP0_QUEUE_OUT,	MTK_DIP_CTX_P2_MDP1_QUEUE_OUT};
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
+		"trigger mtk_dip_dip_start: pdev(%llx), frame(%x)\n",
+		(long long)pdev, param->frame_bundle->id);
+
+	/* Fill ipi params for P2 driver */
+	memset(&dip_param, 0, sizeof(struct img_ipi_frameparam));
+
+	dip_param.index = param->frame_bundle->id;
+	dip_param.num_outputs = param->frame_bundle->num_img_capture_bufs;
+	dip_param.num_inputs = param->frame_bundle->num_img_output_bufs;
+	dip_param.type = STREAM_ISP_IC;
+
+	dev_dbg(&pdev->dev, "DIP frame idx(%d),num_out(%d),num_in(%d)\n",
+		param->frame_bundle->id,
+		dip_param.num_outputs,
+		dip_param.num_inputs);
+
+	/* Tuning buffer */
+	ctx_buf_tuning =
+		param->frame_bundle->buffers[MTK_DIP_CTX_P2_TUNING_QUEUE_IN];
+	if (ctx_buf_tuning) {
+		dev_dbg(&pdev->dev,
+			"Tuning buf queued: pa(%llx),va(%llx),iova(%llx)\n",
+			(unsigned long long)ctx_buf_tuning->paddr,
+			(unsigned long long)ctx_buf_tuning->vaddr,
+			(unsigned long long)ctx_buf_tuning->daddr);
+		dip_param.tuning_data.pa = (uint32_t)ctx_buf_tuning->paddr;
+		dip_param.tuning_data.va = (uint64_t)ctx_buf_tuning->vaddr;
+		dip_param.tuning_data.iova = (uint32_t)ctx_buf_tuning->daddr;
+	} else {
+		dev_dbg(&pdev->dev,
+			"Doesn't enqueued tuning buffer, by-pass\n");
+	dip_param.tuning_data.pa = 0;
+	dip_param.tuning_data.va = 0;
+	dip_param.tuning_data.iova = 0;
+	}
+
+	/* Raw-in buffer */
+	ctx_buf_in =
+		param->frame_bundle->buffers[MTK_DIP_CTX_P2_RAW_QUEUE_IN];
+	if (ctx_buf_in) {
+		struct img_input *iin = &dip_param.inputs[0];
+
+		fill_input_ipi_param(dev_ctx, iin, ctx_buf_in, "RAW");
+	}
+
+	/* MDP 0 buffer */
+	ctx_buf_out =
+		param->frame_bundle->buffers[MTK_DIP_CTX_P2_MDP0_QUEUE_OUT];
+	if (ctx_buf_out) {
+		struct img_output *iout = &dip_param.outputs[out_img_buf_idx];
+
+		fill_output_ipi_param(dev_ctx, iout, ctx_buf_out,
+				      ctx_buf_in, "MPD0");
+		out_img_buf_idx++;
+	}
+
+	/* MDP 0 buffer */
+	ctx_buf_out =
+		param->frame_bundle->buffers[MTK_DIP_CTX_P2_MDP1_QUEUE_OUT];
+	if (ctx_buf_out) {
+		struct img_output *iout = &dip_param.outputs[out_img_buf_idx];
+
+		fill_output_ipi_param(dev_ctx, iout, ctx_buf_out,
+				      ctx_buf_in,  "MPD1");
+		out_img_buf_idx++;
+	}
+
+	/* Dump all information carried in this param */
+	for (i = 0; i < total_buffer_scan; i++) {
+		int queue_idx = scan_queue_idx[i];
+		dma_addr_t daddr;
+		void *vaddr = NULL;
+		struct mtk_dip_ctx_buffer *buf =
+			param->frame_bundle->buffers[queue_idx];
+
+		dev_dbg(&pdev->dev, "get buf, queue = %d, addr = 0x%llx\n",
+			queue_idx, (long long)buf);
+
+		if (!buf) {
+			dev_dbg(&pdev->dev, "CTX buf(frame=%d, queue=%d) is NULL(disabled)\n",
+				param->frame_bundle->id, queue_idx);
+			continue;
+		}
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
+					"Buf from frame(%d):w(%d),h(%d),fmt(%d),color(%d),size(%d)\n",
+				buf->frame_id,
+				pix_fmt->width,	pix_fmt->height,
+				pix_fmt->pixelformat,
+				pix_fmt->colorspace,
+				pix_fmt->plane_fmt[0].sizeimage);
+		} else {
+			struct v4l2_meta_format *meta_fmt = &buf->fmt.meta;
+
+			if (!meta_fmt)
+				dev_warn(&pdev->dev, "meta_fmt is NULL,  queue=%d(disabled)\n",
+					 queue_idx);
+			else
+				dev_dbg(&pdev->dev,
+					"Buf from frame(%d):metatype(%d), size(%d)\n",
+				buf->frame_id, meta_fmt->dataformat,
+				meta_fmt->buffersize);
+		}
+	}
+
+	dev_dbg(&pdev->dev,
+		"Delegate job to mtk_dip_enqueue: pdev(%llx), frame(%d)\n",
+		(long long)pdev, param->frame_bundle->id);
+#ifdef MTK_DIP_CTX_DIP_V4L2_UT
+	ret = check_and_refill_dip_ut_start_ipi_param(&dip_param,
+						      ctx_buf_in, ctx_buf_out);
+	if (ret)
+		dev_err(&dev_ctx->pdev->dev, "DIP ipi param check failed!\n");
+	else
+		mtk_dip_enqueue(pdev, &dip_param);
+#else
+	ret = mtk_dip_enqueue(pdev, &dip_param);
+#endif /* MTK_DIP_CTX_DIP_V4L2_UT */
+
+	if (ret) {
+		dev_warn(&pdev->dev,
+			 "mtk_dip_enqueue failed: %d, will return buffer to user directly\n",
+			 ret);
+		return -EBUSY;
+	}
+
+	return ret;
+}
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
new file mode 100644
index 0000000..b7db119
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
@@ -0,0 +1,374 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * MTK_DIP-dev is highly based on Intel IPU 3 chrome driver
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
+#include "mtk_dip-dev.h"
+#include "mtk_dip-ctrl.h"
+
+static struct platform_device *mtk_dip_dev_of_find_smem_dev
+	(struct platform_device *pdev);
+
+/* Initliaze a mtk_dip_dev representing a completed HW ISP */
+/* device */
+int mtk_dip_dev_init(struct mtk_dip_dev *isp_dev,
+		     struct platform_device *pdev,
+	struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev)
+{
+	int r = 0;
+
+	isp_dev->pdev = pdev;
+
+	mutex_init(&isp_dev->lock);
+	atomic_set(&isp_dev->qbuf_barrier, 0);
+	init_waitqueue_head(&isp_dev->buf_drain_wq);
+
+	r = mtk_dip_ctrl_init(&isp_dev->ctx);
+
+	if (r) {
+		dev_err(&isp_dev->pdev->dev,
+			"failed to initialize ctrls (%d)\n", r);
+		goto failed_ctrl;
+	}
+
+	/* v4l2 sub-device registration */
+	r = mtk_dip_dev_mem2mem2_init(isp_dev, media_dev, v4l2_dev);
+
+	if (r) {
+		dev_err(&isp_dev->pdev->dev,
+			"failed to create V4L2 devices (%d)\n", r);
+		goto failed_mem2mem2;
+	}
+
+	return 0;
+
+failed_ctrl:
+failed_mem2mem2:
+	mutex_destroy(&isp_dev->lock);
+	return r;
+}
+
+int mtk_dip_dev_get_total_node(struct mtk_dip_dev *mtk_dip_dev)
+{
+	return mtk_dip_dev->ctx.queues_attr.total_num;
+}
+
+int mtk_dip_dev_mem2mem2_init(struct mtk_dip_dev *isp_dev,
+			      struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev)
+{
+	int r, i;
+	const int queue_master = isp_dev->ctx.queues_attr.master;
+
+	pr_info("mem2mem2.name: %s\n", isp_dev->ctx.device_name);
+	isp_dev->mem2mem2.name = isp_dev->ctx.device_name;
+	isp_dev->mem2mem2.model = isp_dev->ctx.device_name;
+	isp_dev->mem2mem2.num_nodes =
+		mtk_dip_dev_get_total_node(isp_dev);
+	isp_dev->mem2mem2.vb2_mem_ops = &vb2_dma_contig_memops;
+	isp_dev->mem2mem2.buf_struct_size =
+		sizeof(struct mtk_dip_dev_buffer);
+
+	/* support UT only currently */
+	isp_dev->mem2mem2.ctrl_handler =
+		&isp_dev->ctx.ctrl_handler;
+
+	isp_dev->mem2mem2.nodes = isp_dev->mem2mem2_nodes;
+	isp_dev->mem2mem2.dev = &isp_dev->pdev->dev;
+
+	for (i = 0; i < isp_dev->ctx.dev_node_num; i++) {
+		isp_dev->mem2mem2.nodes[i].name =
+			mtk_dip_dev_get_node_name(isp_dev, i);
+		isp_dev->mem2mem2.nodes[i].output =
+				i < isp_dev->ctx.queues_attr.input_offset;
+		isp_dev->mem2mem2.nodes[i].dynamic =
+			isp_dev->ctx.queue[i].desc.dynamic;
+		isp_dev->mem2mem2.nodes[i].immutable = 0;
+		isp_dev->mem2mem2.nodes[i].enabled = 0;
+		atomic_set(&isp_dev->mem2mem2.nodes[i].sequence, 0);
+	}
+
+	/* Master queue is always enabled */
+	isp_dev->mem2mem2.nodes[queue_master].immutable = 1;
+	isp_dev->mem2mem2.nodes[queue_master].enabled = 1;
+
+	pr_info("register v4l2 for %llx\n",
+		(unsigned long long)isp_dev);
+	r = mtk_dip_mem2mem2_v4l2_register(isp_dev, media_dev, v4l2_dev);
+
+	if (r) {
+		pr_err("v4l2 init failed, dev(ctx:%d)\n",
+		       isp_dev->ctx.ctx_id);
+		return r;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_mem2mem2_init);
+
+void mtk_dip_dev_mem2mem2_exit(struct mtk_dip_dev *isp_dev)
+{
+	mtk_dip_v4l2_unregister(isp_dev);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_mem2mem2_exit);
+
+char *mtk_dip_dev_get_node_name
+	(struct mtk_dip_dev *isp_dev, int node)
+{
+	struct mtk_dip_ctx_queue_desc *mapped_queue_desc =
+		&isp_dev->ctx.queue[node].desc;
+
+	return mapped_queue_desc->name;
+}
+
+/* Get a free buffer from a video node */
+static struct mtk_dip_ctx_buffer __maybe_unused *mtk_dip_dev_queue_getbuf
+	(struct mtk_dip_dev *isp_dev, int node)
+{
+	struct mtk_dip_dev_buffer *buf;
+	int queue = -1;
+
+	if (node > isp_dev->ctx.dev_node_num || node < 0) {
+		dev_err(&isp_dev->pdev->dev, "Invalid mtk_dip_dev node.\n");
+		return NULL;
+	}
+
+	/* Get the corrosponding queue id of the video node */
+	/* Currently the queue id is the same as the node number */
+	queue = node;
+
+	if (queue < 0) {
+		dev_err(&isp_dev->pdev->dev, "Invalid mtk_dip_dev node.\n");
+		return NULL;
+	}
+
+	/* Find first free buffer from the node */
+	list_for_each_entry(buf, &isp_dev->mem2mem2.nodes[node].buffers,
+			    m2m2_buf.list) {
+		if (mtk_dip_ctx_get_buffer_state(&buf->ctx_buf)
+			== MTK_DIP_CTX_BUFFER_NEW)
+			return &buf->ctx_buf;
+	}
+
+	/* There were no free buffers*/
+	return NULL;
+}
+
+int mtk_dip_dev_get_queue_id_of_dev_node(struct mtk_dip_dev *isp_dev,
+					 struct mtk_dip_dev_video_device *node)
+{
+	return (node - isp_dev->mem2mem2.nodes);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_get_queue_id_of_dev_node);
+
+int mtk_dip_dev_queue_buffers(struct mtk_dip_dev *isp_dev,
+			      int initial)
+{
+	unsigned int node;
+	int r = 0;
+	struct mtk_dip_dev_buffer *ibuf;
+	struct mtk_dip_ctx_frame_bundle bundle;
+	const int mtk_dip_dev_node_num = mtk_dip_dev_get_total_node(isp_dev);
+	const int queue_master = isp_dev->ctx.queues_attr.master;
+
+	memset(&bundle, 0, sizeof(struct mtk_dip_ctx_frame_bundle));
+
+	dev_dbg(&isp_dev->pdev->dev, "%s, init(%d)\n", __func__, initial);
+
+	if (!mtk_dip_ctx_is_streaming(&isp_dev->ctx)) {
+		pr_info("%s: stream is off, no hw enqueue triggered\n",
+			__func__);
+		return 0;
+	}
+
+	mutex_lock(&isp_dev->lock);
+
+	/* Buffer set is queued to background driver (e.g. DIP, FD, and P1) */
+	/* only when master input buffer is ready */
+	if (!mtk_dip_dev_queue_getbuf(isp_dev, queue_master)) {
+		mutex_unlock(&isp_dev->lock);
+		return 0;
+	}
+
+	/* Check all node from the node after the master node */
+	for (node = (queue_master + 1) % mtk_dip_dev_node_num;
+		1; node = (node + 1) % mtk_dip_dev_node_num) {
+		dev_dbg(&isp_dev->pdev->dev,
+			"Check node(%d),queue enabled(%d),node enabled(%d)\n",
+			node, isp_dev->queue_enabled[node],
+			isp_dev->mem2mem2.nodes[node].enabled);
+
+		/* May skip some node according the scenario in the future */
+		if (isp_dev->queue_enabled[node] ||
+		    isp_dev->mem2mem2.nodes[node].enabled) {
+			struct mtk_dip_ctx_buffer *buf =
+				mtk_dip_dev_queue_getbuf(isp_dev, node);
+			char *node_name =
+				mtk_dip_dev_get_node_name(isp_dev, node);
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
+					    struct mtk_dip_dev_buffer, ctx_buf);
+			dev_dbg(&isp_dev->pdev->dev,
+				"may queue user %s buffer idx(%d) to ctx\n",
+				node_name,
+				ibuf->m2m2_buf.vbb.vb2_buf.index);
+			mtk_dip_ctx_frame_bundle_add(&isp_dev->ctx,
+						     &bundle, buf);
+		}
+
+		/* Stop if there is no free buffer in master input node */
+		if (node == queue_master) {
+			if (mtk_dip_dev_queue_getbuf(isp_dev, queue_master)) {
+				/* Has collected all buffer required */
+				mtk_dip_ctx_trigger_job(&isp_dev->ctx, &bundle);
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
+	for (node = 0; node < mtk_dip_dev_node_num; node++) {
+		struct mtk_dip_dev_buffer *buf, *buf0;
+
+		if (!isp_dev->queue_enabled[node])
+			continue;	/* Skip disabled queues */
+
+		mutex_lock(&isp_dev->lock);
+		list_for_each_entry_safe(buf, buf0,
+					 &isp_dev->mem2mem2.nodes[node].buffers,
+			m2m2_buf.list) {
+			if (mtk_dip_ctx_get_buffer_state(&buf->ctx_buf) ==
+				MTK_DIP_CTX_BUFFER_PROCESSING)
+				continue;	/* Was already queued, skip */
+
+			mtk_dip_v4l2_buffer_done(&buf->m2m2_buf.vbb.vb2_buf,
+						 VB2_BUF_STATE_ERROR);
+		}
+		mutex_unlock(&isp_dev->lock);
+	}
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_queue_buffers);
+
+int mtk_dip_dev_core_init(struct platform_device *pdev,
+			  struct mtk_dip_dev *isp_dev,
+	struct mtk_dip_ctx_desc *ctx_desc)
+{
+	return mtk_dip_dev_core_init_ext(pdev,
+		isp_dev, ctx_desc, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_core_init);
+
+int mtk_dip_dev_core_init_ext(struct platform_device *pdev,
+			      struct mtk_dip_dev *isp_dev,
+	struct mtk_dip_ctx_desc *ctx_desc,
+	struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev)
+{
+	int r;
+	struct platform_device *smem_dev = NULL;
+
+	smem_dev = mtk_dip_dev_of_find_smem_dev(pdev);
+
+	if (!smem_dev)
+		dev_err(&pdev->dev, "failed to find smem_dev\n");
+
+	/* Device context must be initialized before device instance */
+	r = mtk_dip_ctx_core_init(&isp_dev->ctx, pdev,
+				  0, ctx_desc, pdev, smem_dev);
+
+	dev_info(&pdev->dev, "init isp_dev: %llx\n",
+		 (unsigned long long)isp_dev);
+	/* init other device level members */
+	mtk_dip_dev_init(isp_dev, pdev, media_dev, v4l2_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_core_init_ext);
+
+int mtk_dip_dev_core_release(struct platform_device *pdev,
+			     struct mtk_dip_dev *isp_dev)
+{
+	mtk_dip_dev_mem2mem2_exit(isp_dev);
+	v4l2_ctrl_handler_free(&isp_dev->ctx.ctrl_handler);
+	mtk_dip_ctx_core_exit(&isp_dev->ctx);
+	mutex_destroy(&isp_dev->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mtk_dip_dev_core_release);
+
+static struct platform_device *mtk_dip_dev_of_find_smem_dev
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
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
new file mode 100644
index 0000000..95a3907
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
@@ -0,0 +1,191 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * MTK_DIP-dev is highly based on Intel IPU 3 chrome driver
+ *
+ */
+
+#ifndef __MTK_DIP_DEV_H__
+#define __MTK_DIP_DEV_H__
+
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+#include "mtk_dip-ctx.h"
+
+/* Added the macro for early stage verification */
+/* based on kernel 4.4 environment. */
+/* I will remove the version check after getting */
+/* the devlopment platform based on 4.14 */
+#define MTK_DIP_KERNEL_BASE_VERSION KERNEL_VERSION(4, 14, 0)
+
+#define MTK_DIP_DEV_NODE_MAX			(MTK_DIP_CTX_QUEUES)
+
+#define MTK_DIP_INPUT_MIN_WIDTH		0U
+#define MTK_DIP_INPUT_MIN_HEIGHT		0U
+#define MTK_DIP_INPUT_MAX_WIDTH		480U
+#define MTK_DIP_INPUT_MAX_HEIGHT		640U
+#define MTK_DIP_OUTPUT_MIN_WIDTH		2U
+#define MTK_DIP_OUTPUT_MIN_HEIGHT		2U
+#define MTK_DIP_OUTPUT_MAX_WIDTH		480U
+#define MTK_DIP_OUTPUT_MAX_HEIGHT		640U
+
+#define file_to_mtk_dip_node(__file) \
+	container_of(video_devdata(__file),\
+	struct mtk_dip_dev_video_device, vdev)
+
+#define mtk_dip_ctx_to_dev(__ctx) \
+	container_of(__ctx,\
+	struct mtk_dip_dev, ctx)
+
+#define mtk_dip_m2m_to_dev(__m2m) \
+	container_of(__m2m,\
+	struct mtk_dip_dev, mem2mem2)
+
+#define mtk_dip_subdev_to_dev(__sd) \
+	container_of(__sd, \
+	struct mtk_dip_dev, mem2mem2.subdev)
+
+#define mtk_dip_vbq_to_isp_node(__vq) \
+	container_of(__vq, \
+	struct mtk_dip_dev_video_device, vbq)
+
+#define mtk_dip_ctx_buf_to_dev_buf(__ctx_buf) \
+	container_of(__ctx_buf, \
+	struct mtk_dip_dev_buffer, ctx_buf)
+
+#define mtk_dip_vb2_buf_to_dev_buf(__vb) \
+	container_of(vb, \
+	struct mtk_dip_dev_buffer, \
+	m2m2_buf.vbb.vb2_buf)
+
+#define mtk_dip_vb2_buf_to_m2m_buf(__vb) \
+	container_of(__vb, \
+	struct mtk_dip_mem2mem2_buffer, \
+	vbb.vb2_buf)
+
+#define mtk_dip_subdev_to_m2m(__sd) \
+	container_of(__sd, \
+	struct mtk_dip_mem2mem2_device, subdev)
+
+struct mtk_dip_mem2mem2_device;
+
+struct mtk_dip_mem2mem2_buffer {
+	struct vb2_v4l2_buffer vbb;
+	struct list_head list;
+};
+
+struct mtk_dip_dev_buffer {
+	struct mtk_dip_mem2mem2_buffer m2m2_buf;
+	/* Intenal part */
+	struct mtk_dip_ctx_buffer ctx_buf;
+};
+
+struct mtk_dip_dev_video_device {
+	const char *name;
+	int output;
+	int immutable;
+	int enabled;
+	int dynamic;
+	int queued;
+	struct v4l2_format vdev_fmt;
+	struct video_device vdev;
+	struct media_pad vdev_pad;
+	struct v4l2_mbus_framefmt pad_fmt;
+	struct vb2_queue vbq;
+	struct list_head buffers;
+	struct mutex lock; /* Protect node data */
+	atomic_t sequence;
+};
+
+struct mtk_dip_mem2mem2_device {
+	const char *name;
+	const char *model;
+	struct device *dev;
+	int num_nodes;
+	struct mtk_dip_dev_video_device *nodes;
+	const struct vb2_mem_ops *vb2_mem_ops;
+	unsigned int buf_struct_size;
+	int streaming;
+	struct v4l2_ctrl_handler *ctrl_handler;
+	struct v4l2_device *v4l2_dev;
+	struct media_device *media_dev;
+	struct media_pipeline pipeline;
+	struct v4l2_subdev subdev;
+	struct media_pad *subdev_pads;
+	struct v4l2_file_operations v4l2_file_ops;
+	const struct file_operations fops;
+};
+
+struct mtk_dip_dev {
+	struct platform_device *pdev;
+	struct mtk_dip_dev_video_device mem2mem2_nodes[MTK_DIP_DEV_NODE_MAX];
+	int queue_enabled[MTK_DIP_DEV_NODE_MAX];
+	struct mtk_dip_mem2mem2_device mem2mem2;
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct mtk_dip_ctx ctx;
+	struct mutex lock; /* queue protection */
+	atomic_t qbuf_barrier;
+	int suspend_in_stream;
+	wait_queue_head_t buf_drain_wq;
+};
+
+int mtk_dip_media_register(struct device *dev,
+			   struct media_device *media_dev,
+			   const char *model);
+
+int mtk_dip_v4l2_register(struct device *dev,
+			  struct media_device *media_dev,
+			  struct v4l2_device *v4l2_dev,
+			  struct v4l2_ctrl_handler *ctrl_handler);
+
+int mtk_dip_v4l2_unregister(struct mtk_dip_dev *dev);
+int mtk_dip_mem2mem2_v4l2_register(struct mtk_dip_dev *dev,
+				   struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev);
+
+void mtk_dip_v4l2_buffer_done(struct vb2_buffer *vb,
+			      enum vb2_buffer_state state);
+extern int mtk_dip_dev_queue_buffers
+	(struct mtk_dip_dev *dev, int initial);
+extern int mtk_dip_dev_get_total_node
+	(struct mtk_dip_dev *mtk_dip_dev);
+extern char *mtk_dip_dev_get_node_name
+	(struct mtk_dip_dev *mtk_dip_dev_obj, int node);
+int mtk_dip_dev_init(struct mtk_dip_dev *isp_dev,
+		     struct platform_device *pdev,
+		     struct media_device *media_dev,
+		     struct v4l2_device *v4l2_dev);
+extern void mtk_dip_dev_mem2mem2_exit
+	(struct mtk_dip_dev *mtk_dip_dev_obj);
+int mtk_dip_dev_mem2mem2_init(struct mtk_dip_dev *isp_dev,
+			      struct media_device *media_dev,
+			      struct v4l2_device *v4l2_dev);
+int mtk_dip_dev_get_queue_id_of_dev_node(struct mtk_dip_dev *isp_dev,
+					 struct mtk_dip_dev_video_device
+					 *node);
+int mtk_dip_dev_core_init(struct platform_device *pdev,
+			  struct mtk_dip_dev *isp_dev,
+			  struct mtk_dip_ctx_desc *ctx_desc);
+int mtk_dip_dev_core_init_ext(struct platform_device *pdev,
+			      struct mtk_dip_dev *isp_dev,
+			      struct mtk_dip_ctx_desc *ctx_desc,
+			      struct media_device *media_dev,
+			      struct v4l2_device *v4l2_dev);
+extern int mtk_dip_dev_core_release
+	(struct platform_device *pdev, struct mtk_dip_dev *isp_dev);
+
+#endif /* __MTK_DIP_DEV_H__ */
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
new file mode 100644
index 0000000..9dfd996
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
+#define MTK_DIP_SMEM_DEV_NAME "MTK-DIP-SMEM"
+
+struct mtk_dip_smem_drv {
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
+static int mtk_dip_smem_setup_dma_ops(struct device *smem_dev,
+				      const struct dma_map_ops *smem_ops);
+
+static int mtk_dip_smem_get_sgtable(struct device *dev,
+				    struct sg_table *sgt,
+	void *cpu_addr, dma_addr_t dma_addr,
+	size_t size, unsigned long attrs);
+
+static const struct dma_map_ops smem_dma_ops = {
+	.get_sgtable = mtk_dip_smem_get_sgtable,
+};
+
+static int mtk_dip_smem_init(struct mtk_dip_smem_drv **mtk_dip_smem_drv_out,
+			     struct platform_device *pdev)
+{
+	struct mtk_dip_smem_drv *isp_sys = NULL;
+	struct device *dev = &pdev->dev;
+
+	isp_sys = devm_kzalloc(dev,
+			       sizeof(*isp_sys), GFP_KERNEL);
+
+	isp_sys->pdev = pdev;
+
+	*mtk_dip_smem_drv_out = isp_sys;
+
+	return 0;
+}
+
+static int mtk_dip_smem_drv_probe(struct platform_device *pdev)
+{
+	struct mtk_dip_smem_drv *smem_drv = NULL;
+	int r = 0;
+	struct device *dev = &pdev->dev;
+
+	dev_dbg(dev, "probe mtk_dip_smem_drv\n");
+
+	r = mtk_dip_smem_init(&smem_drv, pdev);
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
+	r = mtk_dip_smem_setup_dma_ops(dev, &smem_dma_ops);
+
+	return r;
+}
+
+phys_addr_t mtk_dip_smem_iova_to_phys(struct device *dev,
+				      dma_addr_t iova)
+{
+		struct iommu_domain *smem_dom;
+		phys_addr_t addr;
+		phys_addr_t limit;
+		struct mtk_dip_smem_drv *smem_dev =
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
+static int mtk_dip_smem_drv_remove(struct platform_device *pdev)
+{
+	struct mtk_dip_smem_drv *smem_drv =
+		dev_get_drvdata(&pdev->dev);
+
+	kfree(smem_drv->smem_pages);
+	return 0;
+}
+
+static int mtk_dip_smem_drv_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int mtk_dip_smem_drv_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int mtk_dip_smem_drv_dummy_cb(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops mtk_dip_smem_drv_pm_ops = {
+	SET_RUNTIME_PM_OPS(&mtk_dip_smem_drv_dummy_cb,
+			   &mtk_dip_smem_drv_dummy_cb, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS
+		(&mtk_dip_smem_drv_suspend, &mtk_dip_smem_drv_resume)
+};
+
+static const struct of_device_id mtk_dip_smem_drv_of_match[] = {
+	{
+		.compatible = "mediatek,dip_smem",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mtk_dip_smem_drv_of_match);
+
+static struct platform_driver mtk_dip_smem_driver = {
+	.probe = mtk_dip_smem_drv_probe,
+	.remove = mtk_dip_smem_drv_remove,
+	.driver = {
+		.name = MTK_DIP_SMEM_DEV_NAME,
+		.of_match_table =
+			of_match_ptr(mtk_dip_smem_drv_of_match),
+		.pm = &mtk_dip_smem_drv_pm_ops,
+	},
+};
+
+static int __init mtk_dip_smem_dma_setup(struct reserved_mem
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
+RESERVEDMEM_OF_DECLARE(mtk_dip_smem,
+		       "mediatek,reserve-memory-dip_smem",
+		       mtk_dip_smem_dma_setup);
+
+int __init mtk_dip_smem_drv_init(void)
+{
+	int ret = 0;
+
+	pr_debug("platform_driver_register: mtk_dip_smem_driver\n");
+	ret = platform_driver_register(&mtk_dip_smem_driver);
+
+	if (ret)
+		pr_warn("isp smem drv init failed, driver didn't probe\n");
+
+	return ret;
+}
+subsys_initcall(mtk_dip_smem_drv_init);
+
+void __exit mtk_dip_smem_drv_ext(void)
+{
+	platform_driver_unregister(&mtk_dip_smem_driver);
+}
+module_exit(mtk_dip_smem_drv_ext);
+
+/********************************************
+ * MTK DIP SMEM DMA ops *
+ ********************************************/
+
+struct dma_coherent_mem {
+	void		*virt_base;
+	dma_addr_t	device_base;
+	unsigned long	pfn_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+	spinlock_t	spinlock; /* protect the members in dma_coherent_mem */
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
+static int mtk_dip_smem_get_sgtable(struct device *dev,
+				    struct sg_table *sgt,
+	void *cpu_addr, dma_addr_t dma_addr,
+	size_t size, unsigned long attrs)
+{
+	struct mtk_dip_smem_drv *smem_dev = dev_get_drvdata(dev);
+	int n_pages_align = 0;
+	int size_align = 0;
+	int page_start = 0;
+	unsigned long long offset_p = 0;
+	unsigned long long offset_d = 0;
+
+	phys_addr_t paddr = mtk_dip_smem_iova_to_phys(dev, dma_addr);
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
+static void *mtk_dip_smem_get_cpu_addr(struct mtk_dip_smem_drv *smem_dev,
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
+static void mtk_dip_smem_sync_sg_for_cpu(struct device *dev,
+					 struct scatterlist *sgl, int nelems,
+					 enum dma_data_direction dir)
+{
+	struct mtk_dip_smem_drv *smem_dev =
+		dev_get_drvdata(dev);
+	void *cpu_addr;
+
+	cpu_addr = mtk_dip_smem_get_cpu_addr(smem_dev, sgl);
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
+static void mtk_dip_smem_sync_sg_for_device(struct device *dev,
+					    struct scatterlist *sgl, int nelems,
+					    enum dma_data_direction dir)
+{
+	struct mtk_dip_smem_drv *smem_dev =
+			dev_get_drvdata(dev);
+	void *cpu_addr;
+
+	cpu_addr = mtk_dip_smem_get_cpu_addr(smem_dev, sgl);
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
+static int mtk_dip_smem_setup_dma_ops(struct device *dev,
+				      const struct dma_map_ops *smem_ops)
+{
+	if (!dev->dma_ops)
+		return -EINVAL;
+
+	memcpy((void *)smem_ops, dev->dma_ops, sizeof(*smem_ops));
+
+	((struct dma_map_ops *)smem_ops)->get_sgtable =
+		mtk_dip_smem_get_sgtable;
+	((struct dma_map_ops *)smem_ops)->sync_sg_for_device =
+		mtk_dip_smem_sync_sg_for_device;
+	((struct dma_map_ops *)smem_ops)->sync_sg_for_cpu =
+		mtk_dip_smem_sync_sg_for_cpu;
+
+	dev->dma_ops = smem_ops;
+
+	return 0;
+}
+
+void mtk_dip_smem_enable_mpu(struct device *dev)
+{
+	dev_warn(dev, "MPU enabling func is not ready now\n");
+}
+
+MODULE_AUTHOR("Frederic Chen <frederic.chen@mediatek.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek DIP shared memory driver");
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
new file mode 100644
index 0000000..32b6bf4
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
@@ -0,0 +1,25 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_SMEM_H__
+#define __MTK_DIP_SMEM_H__
+
+#include <linux/dma-mapping.h>
+
+phys_addr_t mtk_dip_smem_iova_to_phys(struct device *smem_dev,
+				      dma_addr_t iova);
+void mtk_dip_smem_enable_mpu(struct device *smem_dev);
+#endif /*__MTK_DIP_SMEM_H__*/
+
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
new file mode 100644
index 0000000..b425031
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
@@ -0,0 +1,1000 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * MTK_DIP-v4l2 is highly based on Intel IPU 3 chrome driver
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
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
+#include "mtk_dip-dev.h"
+#include "mtk_dip-v4l2-util.h"
+
+static u32 mtk_dip_node_get_v4l2_cap
+	(struct mtk_dip_ctx_queue *node_ctx);
+
+static int mtk_dip_videoc_s_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f);
+
+static int mtk_dip_subdev_open(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh)
+{
+	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
+
+	isp_dev->ctx.fh = fh;
+
+	return mtk_dip_ctx_open(&isp_dev->ctx);
+}
+
+static int mtk_dip_subdev_close(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
+
+	return mtk_dip_ctx_release(&isp_dev->ctx);
+}
+
+static int mtk_dip_subdev_s_stream(struct v4l2_subdev *sd,
+				   int enable)
+{
+	int ret = 0;
+
+	struct mtk_dip_dev *isp_dev = mtk_dip_subdev_to_dev(sd);
+
+	if (enable) {
+		ret = mtk_dip_ctx_streamon(&isp_dev->ctx);
+
+		if (!ret)
+			ret = mtk_dip_dev_queue_buffers
+				(mtk_dip_ctx_to_dev(&isp_dev->ctx), 1);
+		if (ret)
+			pr_err("failed to queue initial buffers (%d)", ret);
+	}	else {
+		ret = mtk_dip_ctx_streamoff(&isp_dev->ctx);
+	}
+
+	if (!ret)
+		isp_dev->mem2mem2.streaming = enable;
+
+	return ret;
+}
+
+int mtk_dip_subdev_subscribe_event(struct v4l2_subdev *subdev,
+				   struct v4l2_fh *fh,
+				   struct v4l2_event_subscription *sub)
+{
+	pr_info("sub type(%x)", sub->type);
+	if (sub->type != V4L2_EVENT_PRIVATE_START &&
+	    sub->type != V4L2_EVENT_MTK_DIP_FRAME_DONE)
+		return -EINVAL;
+
+	return v4l2_event_subscribe(fh, sub, 0, NULL);
+}
+
+int mtk_dip_subdev_unsubscribe_event(struct v4l2_subdev *subdev,
+				     struct v4l2_fh *fh,
+	struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+static int mtk_dip_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+	const struct media_pad *remote, u32 flags)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 =
+			container_of(entity,
+				     struct mtk_dip_mem2mem2_device,
+				     subdev.entity);
+	struct mtk_dip_dev *isp_dev =
+		container_of(m2m2, struct mtk_dip_dev, mem2mem2);
+
+	u32 pad = local->index;
+
+	dev_dbg(&isp_dev->pdev->dev,
+		"link setup: %d --> %d\n", pad, remote->index);
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
+static void mtk_dip_vb2_buf_queue(struct vb2_buffer *vb)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
+
+	struct mtk_dip_dev *mtk_dip_dev = mtk_dip_m2m_to_dev(m2m2);
+
+	struct device *dev = &mtk_dip_dev->pdev->dev;
+
+	struct mtk_dip_dev_buffer *buf = NULL;
+
+	struct vb2_v4l2_buffer *v4l2_buf = NULL;
+
+	struct mtk_dip_dev_video_device *node =
+		mtk_dip_vbq_to_isp_node(vb->vb2_queue);
+
+	int queue = mtk_dip_dev_get_queue_id_of_dev_node(mtk_dip_dev, node);
+
+	dev_dbg(dev,
+		"queue vb2_buf: Node(%s) queue id(%d)\n",
+		node->name,
+		queue);
+
+	if (queue < 0) {
+		dev_err(m2m2->dev, "Invalid mtk_dip_dev node.\n");
+		return;
+	}
+
+	if (mtk_dip_dev->ctx.mode == MTK_DIP_CTX_MODE_DEBUG_BYPASS_ALL) {
+		dev_dbg(m2m2->dev, "By pass mode, just loop back the buffer\n");
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		return;
+	}
+
+	if (!vb)
+		pr_err("VB can't be null\n");
+
+	buf = mtk_dip_vb2_buf_to_dev_buf(vb);
+
+	if (!buf)
+		pr_err("buf can't be null\n");
+
+	v4l2_buf = to_vb2_v4l2_buffer(vb);
+
+	if (!v4l2_buf)
+		pr_err("v4l2_buf can't be null\n");
+
+	mutex_lock(&mtk_dip_dev->lock);
+
+	/* the dma address will be filled in later frame buffer handling*/
+	mtk_dip_ctx_buf_init(&buf->ctx_buf, queue, (dma_addr_t)0);
+
+	/* Added the buffer into the tracking list */
+	list_add_tail(&buf->m2m2_buf.list,
+		      &m2m2->nodes[node - m2m2->nodes].buffers);
+	mutex_unlock(&mtk_dip_dev->lock);
+
+	/* Enqueue the buffer */
+	if (mtk_dip_dev->mem2mem2.streaming) {
+		dev_dbg(dev, "%s: mtk_dip_dev_queue_buffers\n",
+			node->name);
+		mtk_dip_dev_queue_buffers(mtk_dip_dev, 0);
+	}
+}
+
+static int mtk_dip_vb2_queue_setup(struct vb2_queue *vq,
+				   unsigned int *num_buffers,
+				unsigned int *num_planes,
+				unsigned int sizes[],
+				struct device *alloc_devs[])
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_dip_dev_video_device *node =
+		mtk_dip_vbq_to_isp_node(vq);
+	struct mtk_dip_dev *isp_dev = mtk_dip_m2m_to_dev(m2m2);
+	struct device *dev = &isp_dev->pdev->dev;
+	void *buf_alloc_ctx = NULL;
+	int queue_id = mtk_dip_dev_get_queue_id_of_dev_node(isp_dev, node);
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
+static int
+	mtk_dip_all_nodes_streaming(struct mtk_dip_mem2mem2_device *m2m2,
+				    struct mtk_dip_dev_video_device *except)
+{
+	int i;
+
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		struct mtk_dip_dev_video_device *node = &m2m2->nodes[i];
+
+		if (node == except)
+			continue;
+		if (node->enabled && !vb2_start_streaming_called(&node->vbq))
+			return 0;
+	}
+
+	return 1;
+}
+
+static void mtk_dip_return_all_buffers(struct mtk_dip_mem2mem2_device *m2m2,
+				       struct mtk_dip_dev_video_device *node,
+					enum vb2_buffer_state state)
+{
+	struct mtk_dip_dev *mtk_dip_dev = mtk_dip_m2m_to_dev(m2m2);
+	struct mtk_dip_mem2mem2_buffer *b, *b0;
+
+	/* Return all buffers */
+	mutex_lock(&mtk_dip_dev->lock);
+	list_for_each_entry_safe(b, b0, &node->buffers, list) {
+		list_del(&b->list);
+		vb2_buffer_done(&b->vbb.vb2_buf, state);
+	}
+	mutex_unlock(&mtk_dip_dev->lock);
+}
+
+static int mtk_dip_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_dip_dev_video_device *node =
+		mtk_dip_vbq_to_isp_node(vq);
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
+	if (!mtk_dip_all_nodes_streaming(m2m2, node))
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
+	mtk_dip_return_all_buffers(m2m2, node, VB2_BUF_STATE_QUEUED);
+
+	return r;
+}
+
+static void mtk_dip_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
+	struct mtk_dip_dev_video_device *node =
+		mtk_dip_vbq_to_isp_node(vq);
+	int r;
+
+	WARN_ON(!node->enabled);
+
+	/* Was this the first node with streaming disabled? */
+	if (mtk_dip_all_nodes_streaming(m2m2, node)) {
+		/* Yes, really stop streaming now */
+		r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 0);
+		if (r)
+			dev_err(m2m2->dev, "failed to stop streaming\n");
+	}
+
+	mtk_dip_return_all_buffers(m2m2, node, VB2_BUF_STATE_ERROR);
+	media_pipeline_stop(&node->vdev.entity);
+}
+
+static int mtk_dip_videoc_querycap(struct file *file, void *fh,
+				   struct v4l2_capability *cap)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+	struct mtk_dip_dev *isp_dev = mtk_dip_m2m_to_dev(m2m2);
+	int queue_id =
+		mtk_dip_dev_get_queue_id_of_dev_node(isp_dev, node);
+	struct mtk_dip_ctx_queue *node_ctx = &isp_dev->ctx.queue[queue_id];
+
+	strlcpy(cap->driver, m2m2->name, sizeof(cap->driver));
+	strlcpy(cap->card, m2m2->model, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", node->name);
+
+	cap->device_caps =
+		mtk_dip_node_get_v4l2_cap(node_ctx) | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+/* Propagate forward always the format from the CIO2 subdev */
+static int mtk_dip_videoc_g_fmt(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+
+	f->fmt = node->vdev_fmt.fmt;
+
+	return 0;
+}
+
+static int mtk_dip_videoc_try_fmt(struct file *file,
+				  void *fh,
+	 struct v4l2_format *f)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_dip_dev *isp_dev = mtk_dip_m2m_to_dev(m2m2);
+	struct mtk_dip_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+	int queue_id =
+		mtk_dip_dev_get_queue_id_of_dev_node(isp_dev, node);
+	int ret = 0;
+
+	ret = mtk_dip_ctx_fmt_set_img(dev_ctx, queue_id,
+				      &f->fmt.pix_mp,
+		&node->vdev_fmt.fmt.pix_mp);
+
+	/* Simply set the format to the node context in the initial version */
+	if (ret) {
+		pr_warn("Fmt(%d) not support for queue(%d), will load default fmt\n",
+			f->fmt.pix_mp.pixelformat, queue_id);
+
+		ret =	mtk_dip_ctx_format_load_default_fmt
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
+static int mtk_dip_videoc_s_fmt(struct file *file, void *fh,
+				struct v4l2_format *f)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_dip_dev *isp_dev = mtk_dip_m2m_to_dev(m2m2);
+	struct mtk_dip_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+	int queue_id = mtk_dip_dev_get_queue_id_of_dev_node(isp_dev, node);
+	int ret = 0;
+
+	ret = mtk_dip_ctx_fmt_set_img(dev_ctx, queue_id,
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
+static int mtk_dip_meta_enum_format(struct file *file,
+				    void *fh, struct v4l2_fmtdesc *f)
+{
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+
+	if (f->index > 0 || f->type != node->vbq.type)
+		return -EINVAL;
+
+	f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
+
+	return 0;
+}
+
+static int mtk_dip_videoc_s_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = video_drvdata(file);
+	struct mtk_dip_dev *isp_dev = mtk_dip_m2m_to_dev(m2m2);
+	struct mtk_dip_ctx *dev_ctx = &isp_dev->ctx;
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+	int queue_id = mtk_dip_dev_get_queue_id_of_dev_node(isp_dev, node);
+
+	int ret = 0;
+
+	if (f->type != node->vbq.type)
+		return -EINVAL;
+
+	ret = mtk_dip_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
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
+static int mtk_dip_videoc_g_meta_fmt(struct file *file,
+				     void *fh, struct v4l2_format *f)
+{
+	struct mtk_dip_dev_video_device *node = file_to_mtk_dip_node(file);
+
+	if (f->type != node->vbq.type)
+		return -EINVAL;
+
+	f->fmt = node->vdev_fmt.fmt;
+
+	return 0;
+}
+
+/******************** function pointers ********************/
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops mtk_dip_subdev_internal_ops = {
+	.open = mtk_dip_subdev_open,
+	.close = mtk_dip_subdev_close,
+};
+
+static const struct v4l2_subdev_core_ops mtk_dip_subdev_core_ops = {
+	.subscribe_event = mtk_dip_subdev_subscribe_event,
+	.unsubscribe_event = mtk_dip_subdev_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops mtk_dip_subdev_video_ops = {
+	.s_stream = mtk_dip_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_ops mtk_dip_subdev_ops = {
+	.core = &mtk_dip_subdev_core_ops,
+	.video = &mtk_dip_subdev_video_ops,
+};
+
+static const struct media_entity_operations mtk_dip_media_ops = {
+	.link_setup = mtk_dip_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static const struct vb2_ops mtk_dip_vb2_ops = {
+	.buf_queue = mtk_dip_vb2_buf_queue,
+	.queue_setup = mtk_dip_vb2_queue_setup,
+	.start_streaming = mtk_dip_vb2_start_streaming,
+	.stop_streaming = mtk_dip_vb2_stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+};
+
+static const struct v4l2_file_operations mtk_dip_v4l2_fops = {
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
+static const struct v4l2_ioctl_ops mtk_dip_v4l2_ioctl_ops = {
+	.vidioc_querycap = mtk_dip_videoc_querycap,
+
+	.vidioc_g_fmt_vid_cap_mplane = mtk_dip_videoc_g_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = mtk_dip_videoc_s_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = mtk_dip_videoc_try_fmt,
+
+	.vidioc_g_fmt_vid_out_mplane = mtk_dip_videoc_g_fmt,
+	.vidioc_s_fmt_vid_out_mplane = mtk_dip_videoc_s_fmt,
+	.vidioc_try_fmt_vid_out_mplane = mtk_dip_videoc_try_fmt,
+
+	/* buffer queue management */
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+};
+
+static const struct v4l2_ioctl_ops mtk_dip_v4l2_meta_ioctl_ops = {
+	.vidioc_querycap = mtk_dip_videoc_querycap,
+
+	.vidioc_enum_fmt_meta_cap = mtk_dip_meta_enum_format,
+	.vidioc_g_fmt_meta_cap = mtk_dip_videoc_g_meta_fmt,
+	.vidioc_s_fmt_meta_cap = mtk_dip_videoc_s_meta_fmt,
+	.vidioc_try_fmt_meta_cap = mtk_dip_videoc_g_meta_fmt,
+
+	.vidioc_enum_fmt_meta_out = mtk_dip_meta_enum_format,
+	.vidioc_g_fmt_meta_out = mtk_dip_videoc_g_meta_fmt,
+	.vidioc_s_fmt_meta_out = mtk_dip_videoc_s_meta_fmt,
+	.vidioc_try_fmt_meta_out = mtk_dip_videoc_g_meta_fmt,
+
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+	.vidioc_expbuf = vb2_ioctl_expbuf,
+};
+
+static u32 mtk_dip_node_get_v4l2_cap(struct mtk_dip_ctx_queue *node_ctx)
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
+static u32 mtk_dip_node_get_format_type(struct mtk_dip_ctx_queue *node_ctx)
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
+static const struct v4l2_ioctl_ops *mtk_dip_node_get_ioctl_ops
+	(struct mtk_dip_ctx_queue *node_ctx)
+{
+	const struct v4l2_ioctl_ops *ops = NULL;
+
+	if (node_ctx->desc.image)
+		ops = &mtk_dip_v4l2_ioctl_ops;
+	else
+		ops = &mtk_dip_v4l2_meta_ioctl_ops;
+	return ops;
+}
+
+/* Config node's video properties */
+/* according to the device context requirement */
+static void mtk_dip_node_to_v4l2(struct mtk_dip_dev *isp_dev,
+				 u32 node,
+				 struct video_device *vdev,
+				 struct v4l2_format *f)
+{
+	u32 cap;
+	struct mtk_dip_ctx *device_ctx = &isp_dev->ctx;
+	struct mtk_dip_ctx_queue *node_ctx = &device_ctx->queue[node];
+
+	WARN_ON(node >= mtk_dip_dev_get_total_node(isp_dev));
+	WARN_ON(!node_ctx);
+
+	/* set cap of the node */
+	cap = mtk_dip_node_get_v4l2_cap(node_ctx);
+	f->type = mtk_dip_node_get_format_type(node_ctx);
+	vdev->ioctl_ops = mtk_dip_node_get_ioctl_ops(node_ctx);
+
+	if (mtk_dip_ctx_format_load_default_fmt(&device_ctx->queue[node], f)) {
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
+			dev_info(&isp_dev->pdev->dev,
+				 "Node (%d): (%s), dfmt (f:0x%x s:%u)\n",
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
+int mtk_dip_media_register(struct device *dev,
+			   struct media_device *media_dev,
+	const char *model)
+{
+	int r = 0;
+
+	media_dev->dev = dev;
+	dev_info(dev, "setup media_dev.dev: %llx\n",
+		 (unsigned long long)media_dev->dev);
+
+	strlcpy(media_dev->model, model,
+		sizeof(media_dev->model));
+	dev_info(dev, "setup media_dev.model: %s\n",
+		 media_dev->model);
+
+	snprintf(media_dev->bus_info, sizeof(media_dev->bus_info),
+		 "%s", dev_name(dev));
+	dev_info(dev, "setup media_dev.bus_info: %s\n",
+		 media_dev->bus_info);
+
+	media_dev->hw_revision = 0;
+	dev_info(dev, "setup media_dev.hw_revision: %d\n",
+		 media_dev->hw_revision);
+
+	media_device_init(media_dev);
+	dev_info(dev, "media_device_init: media_dev:%llx\n",
+		 (unsigned long long)media_dev);
+
+	r = media_device_register(media_dev);
+
+	dev_info(dev, "Register media device: %s, %llx",
+		 media_dev->model, (unsigned long long)media_dev);
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
+EXPORT_SYMBOL_GPL(mtk_dip_media_register);
+
+int mtk_dip_v4l2_register(struct device *dev,
+			  struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev,
+	struct v4l2_ctrl_handler *ctrl_handler
+	)
+{
+	int r = 0;
+	/* Set up v4l2 device */
+	v4l2_dev->mdev = media_dev;
+	dev_info(dev, "setup v4l2_dev->mdev: %llx",
+		 (unsigned long long)v4l2_dev->mdev);
+	v4l2_dev->ctrl_handler = ctrl_handler;
+	dev_info(dev, "setup v4l2_dev->ctrl_handler: %llx",
+		 (unsigned long long)v4l2_dev->ctrl_handler);
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
+EXPORT_SYMBOL_GPL(mtk_dip_v4l2_register);
+
+int mtk_dip_mem2mem2_v4l2_register(struct mtk_dip_dev *dev,
+				   struct media_device *media_dev,
+	struct v4l2_device *v4l2_dev)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = &dev->mem2mem2;
+
+	int i, r;
+
+	/* If media_dev or v4l2_dev is not set, */
+	/* use the default one in mtk_dip_dev */
+	if (!media_dev) {
+		m2m2->media_dev = &dev->media_dev;
+		r = mtk_dip_media_register(&dev->pdev->dev,
+					   m2m2->media_dev,
+		m2m2->model);
+
+	if (r) {
+		dev_err(m2m2->dev, "failed to register media device (%d)\n", r);
+		goto fail_media_dev;
+	}
+	} else {
+		m2m2->media_dev = media_dev;
+	}
+
+	if (!v4l2_dev) {
+		m2m2->v4l2_dev = &dev->v4l2_dev;
+		m2m2->v4l2_dev->ctrl_handler = &dev->ctx.ctrl_handler;
+		r = mtk_dip_v4l2_register(&dev->pdev->dev,
+					  m2m2->media_dev,
+			m2m2->v4l2_dev,
+			m2m2->v4l2_dev->ctrl_handler);
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
+	m2m2->streaming = 0;
+	m2m2->v4l2_file_ops = mtk_dip_v4l2_fops;
+
+	/* Initialize subdev media entity */
+	m2m2->subdev_pads = kcalloc(m2m2->num_nodes,
+				    sizeof(*m2m2->subdev_pads),
+				    GFP_KERNEL);
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
+	v4l2_subdev_init(&m2m2->subdev, &mtk_dip_subdev_ops);
+
+	m2m2->subdev.entity.function =
+		MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+
+	m2m2->subdev.entity.ops = &mtk_dip_media_ops;
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
+	m2m2->subdev.ctrl_handler = &dev->ctx.ctrl_handler;
+	m2m2->subdev.internal_ops = &mtk_dip_subdev_internal_ops;
+
+	pr_info("register subdev: %s\n", m2m2->subdev.name);
+	r = v4l2_device_register_subdev(m2m2->v4l2_dev, &m2m2->subdev);
+	if (r) {
+		dev_err(m2m2->dev, "failed initialize subdev (%d)\n", r);
+		goto fail_subdev;
+	}
+	r = v4l2_device_register_subdev_nodes(m2m2->v4l2_dev);
+	if (r) {
+		dev_err(m2m2->dev, "failed to register subdevs (%d)\n", r);
+		goto fail_subdevs;
+	}
+
+	/* Create video nodes and links */
+	for (i = 0; i < m2m2->num_nodes; i++) {
+		struct mtk_dip_dev_video_device *node = &m2m2->nodes[i];
+		struct video_device *vdev = &node->vdev;
+		struct vb2_queue *vbq = &node->vbq;
+		u32 flags;
+
+		/* Initialize miscellaneous variables */
+		mutex_init(&node->lock);
+		INIT_LIST_HEAD(&node->buffers);
+
+		/* Initialize formats to default values */
+		mtk_dip_node_to_v4l2(dev, i, vdev, &node->vdev_fmt);
+
+		/* Initialize media entities */
+
+		r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
+		if (r) {
+			dev_err(m2m2->dev,
+				"failed initialize media entity (%d)\n", r);
+			goto fail_vdev_media_entity;
+		}
+		node->vdev_pad.flags = node->output ?
+			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
+		vdev->entity.ops = NULL;
+
+		/* Initialize vbq */
+		vbq->type = node->vdev_fmt.type;
+		vbq->io_modes = VB2_MMAP | VB2_DMABUF;
+		vbq->ops = &mtk_dip_vb2_ops;
+		vbq->mem_ops = m2m2->vb2_mem_ops;
+		m2m2->buf_struct_size = sizeof(struct mtk_dip_dev_buffer);
+		vbq->buf_struct_size = m2m2->buf_struct_size;
+		vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers */
+		/* Put the process hub sub device in the vb2 private data*/
+		vbq->drv_priv = m2m2;
+		vbq->lock = &node->lock;
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
+		vdev->ctrl_handler = &dev->ctx.queue[i].ctrl_handler;
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
+		/* Create link between video node and the subdev pad */
+		flags = 0;
+		if (node->dynamic)
+			flags |= MEDIA_LNK_FL_DYNAMIC;
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
+fail_subdevs:
+	v4l2_device_unregister_subdev(&m2m2->subdev);
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
+EXPORT_SYMBOL_GPL(mtk_dip_mem2mem2_v4l2_register);
+
+int mtk_dip_v4l2_unregister(struct mtk_dip_dev *dev)
+{
+	struct mtk_dip_mem2mem2_device *m2m2 = &dev->mem2mem2;
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
+EXPORT_SYMBOL_GPL(mtk_dip_v4l2_unregister);
+
+void mtk_dip_v4l2_buffer_done(struct vb2_buffer *vb,
+			      enum vb2_buffer_state state)
+{
+	struct mtk_dip_mem2mem2_buffer *b =
+		container_of(vb, struct mtk_dip_mem2mem2_buffer, vbb.vb2_buf);
+
+	list_del(&b->list);
+	vb2_buffer_done(&b->vbb.vb2_buf, state);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_v4l2_buffer_done);
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
new file mode 100644
index 0000000..3514be6
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
@@ -0,0 +1,38 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_DEV_V4L2_H__
+#define __MTK_DIP_DEV_V4L2_H__
+
+#include <media/v4l2-device.h>
+#include <media/videobuf2-v4l2.h>
+
+/*
+ * Events
+ *
+ * V4L2_EVENT_MTK_DIP_FRAME_DONE: Hardware has finished a frame
+ */
+
+#define V4L2_EVENT_MTK_DIP_CLASS	\
+	(V4L2_EVENT_PRIVATE_START | 0x200)
+#define V4L2_EVENT_MTK_DIP_FRAME_DONE	\
+	(V4L2_EVENT_MTK_DIP_CLASS | 0x2)
+
+struct mtk_dip_dev_frame_done_event_data {
+	__u32 frame_id;	/* The frame id of mtk_dip_ctx_buf */
+	__u32 user_sequence;	/* reserved and not used now */
+};
+
+#endif /* __MTK_DIP_DEV_V4L2_H__ */
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
new file mode 100644
index 0000000..ffdc45e
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
@@ -0,0 +1,292 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include "mtk_dip-ctx.h"
+#include "mtk_dip.h"
+#include "mtk_dip-v4l2.h"
+#include "mtk-mdp3-regs.h"
+
+#define MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME "MTK-ISP-DIP-V4L2"
+#define MTK_DIP_DEV_DIP_PREVIEW_NAME \
+	MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME
+#define MTK_DIP_DEV_DIP_CAPTURE_NAME "MTK-ISP-DIP-CAP-V4L2"
+
+#ifdef MTK_DIP_CTX_DIP_V4L2_UT
+#include "mtk_dip-dev-ctx-dip-test.h"
+#endif
+
+/* The setting for the quick conifgurtion provided */
+/* by mtk_dip_ctx_core_steup */
+struct mtk_dip_ctx_setting mtk_dip_ctx_dip_preview_setting = {
+	.device_name = MTK_DIP_DEV_DIP_PREVIEW_NAME,
+};
+
+struct mtk_dip_ctx_setting mtk_dip_ctx_dip_capture_setting = {
+	.device_name = MTK_DIP_DEV_DIP_CAPTURE_NAME,
+};
+
+static struct mtk_dip_ctx_format fw_param_fmts[] = {
+	{
+		.fmt.meta = {
+			.dataformat = V4L2_META_FMT_MTISP_PARAMS,
+			.max_buffer_size = 1024 * 30,
+		},
+	},
+};
+
+static struct mtk_dip_ctx_format in_fmts[] = {
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_MTISP_B10,
+			.mdp_color = MDP_COLOR_BAYER10,
+			.depth = { 10 },
+			.row_depth = { 10 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_MTISP_F10,
+			.mdp_color = MDP_COLOR_FULLG10,
+			.depth = { 15 },
+			.row_depth = { 15 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_VYUY,
+			.mdp_color = MDP_COLOR_VYUY,
+			.depth	 = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_YUYV,
+			.mdp_color = MDP_COLOR_YUYV,
+			.depth	 = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_YVYU,
+			.mdp_color = MDP_COLOR_YVYU,
+			.depth	 = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+};
+
+static struct mtk_dip_ctx_format out_fmts[] = {
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_VYUY,
+			.mdp_color = MDP_COLOR_VYUY,
+			.depth = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_YUYV,
+			.mdp_color = MDP_COLOR_YUYV,
+			.depth = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_YVYU,
+			.mdp_color = MDP_COLOR_YVYU,
+			.depth = { 16 },
+			.row_depth = { 16 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_YVU420,
+			.mdp_color = MDP_COLOR_YV12,
+			.depth = { 12 },
+			.row_depth = { 8 },
+			.num_planes = 1,
+		},
+	},
+	{
+		.fmt.img = {
+			.pixelformat = V4L2_PIX_FMT_NV12,
+			.mdp_color = MDP_COLOR_NV12,
+			.depth = { 12 },
+			.row_depth = { 8 },
+			.num_planes = 1,
+		},
+	}
+};
+
+static struct mtk_dip_ctx_queue_desc
+	output_queues[MTK_DIP_CTX_P2_TOTAL_OUTPUT] = {
+	{
+		.id = MTK_DIP_CTX_P2_RAW_QUEUE_IN,
+		.name = "Raw Input",
+		.dynamic = 0,
+		.capture = 0,
+		.image = 1,
+		.smem_alloc = 0,
+		.fmts = in_fmts,
+		.num_fmts = ARRAY_SIZE(in_fmts),
+		.default_fmt_idx = 0,
+	},
+	{
+		.id = MTK_DIP_CTX_P2_TUNING_QUEUE_IN,
+		.name = "Tuning",
+		.dynamic = 0,
+		.capture = 0,
+		.image = 0,
+		.smem_alloc = 1,
+		.fmts = fw_param_fmts,
+		.num_fmts = 1,
+		.default_fmt_idx = 0,
+	},
+};
+
+static struct mtk_dip_ctx_queue_desc
+	capture_queues[MTK_DIP_CTX_P2_TOTAL_CAPTURE] = {
+	{
+		.id = MTK_DIP_CTX_P2_MDP0_QUEUE_OUT,
+		.name = "MDP0",
+		.dynamic = 0,
+		.capture = 1,
+		.image = 1,
+		.smem_alloc = 0,
+		.fmts = out_fmts,
+		.num_fmts = ARRAY_SIZE(out_fmts),
+		.default_fmt_idx = 1,
+	},
+	{
+		.id = MTK_DIP_CTX_P2_MDP1_QUEUE_OUT,
+		.name = "MDP1",
+		.dynamic = 0,
+		.capture = 1,
+		.image = 1,
+		.smem_alloc = 0,
+		.fmts = out_fmts,
+		.num_fmts = ARRAY_SIZE(out_fmts),
+		.default_fmt_idx = 1,
+	},
+};
+
+static struct mtk_dip_ctx_queues_setting preview_queues_setting = {
+	.master = MTK_DIP_CTX_P2_RAW_QUEUE_IN,
+	.output_queue_descs = output_queues,
+	.total_output_queues = MTK_DIP_CTX_P2_TOTAL_OUTPUT,
+	.capture_queue_descs = capture_queues,
+	.total_capture_queues = MTK_DIP_CTX_P2_TOTAL_CAPTURE,
+};
+
+static struct mtk_dip_ctx_queues_setting capture_queues_setting = {
+	.master = MTK_DIP_CTX_P2_RAW_QUEUE_IN,
+	.output_queue_descs = output_queues,
+	.total_output_queues = MTK_DIP_CTX_P2_TOTAL_OUTPUT,
+	.capture_queue_descs = capture_queues,
+	.total_capture_queues = MTK_DIP_CTX_P2_TOTAL_CAPTURE,
+};
+
+static struct mtk_dip_ctx_desc mtk_dip_ctx_desc_dip_preview = {
+	"proc_device_dip_preview", mtk_dip_ctx_dip_preview_init,};
+
+static struct mtk_dip_ctx_desc mtk_dip_ctx_desc_dip_capture = {
+	"proc_device_dip_capture", mtk_dip_ctx_dip_capture_init,};
+
+int mtk_dip_ctx_dip_v4l2_init(struct platform_device *pdev,
+			      struct mtk_dip_dev *isp_preview_dev,
+	struct mtk_dip_dev *isp_capture_dev)
+{
+	struct media_device *media_dev;
+	struct v4l2_device *v4l2_dev;
+	struct v4l2_ctrl_handler *ctrl_handler;
+	int ret = 0;
+
+	/* initialize the v4l2 common part */
+	dev_info(&pdev->dev, "init v4l2 common part: dev=%llx\n",
+		 (unsigned long long)&pdev->dev);
+
+	media_dev = &isp_preview_dev->media_dev;
+	v4l2_dev = &isp_preview_dev->v4l2_dev;
+	ctrl_handler = &isp_preview_dev->ctx.ctrl_handler;
+
+	ret = mtk_dip_media_register(&pdev->dev,
+				     media_dev,
+		MTK_DIP_DEV_DIP_MEDIA_MODEL_NAME);
+
+	ret = mtk_dip_v4l2_register(&pdev->dev,
+				    media_dev,
+		v4l2_dev,
+		ctrl_handler);
+
+	dev_info(&pdev->dev, "init v4l2 preview part\n");
+	ret = mtk_dip_dev_core_init_ext(pdev,
+					isp_preview_dev,
+					&mtk_dip_ctx_desc_dip_preview,
+		media_dev, v4l2_dev);
+
+	if (ret)
+		dev_err(&pdev->dev, "Preview v4l2 part init failed: %d\n", ret);
+
+	dev_info(&pdev->dev, "init v4l2 capture part\n");
+
+	ret = mtk_dip_dev_core_init_ext(pdev,
+					isp_capture_dev,
+					&mtk_dip_ctx_desc_dip_capture,
+		media_dev, v4l2_dev);
+
+	if (ret)
+		dev_err(&pdev->dev, "Capture v4l2 part init failed: %d\n", ret);
+
+	return ret;
+}
+
+/* MTK ISP context initialization */
+int mtk_dip_ctx_dip_preview_init(struct mtk_dip_ctx *preview_ctx)
+{
+	preview_ctx->ctx_id = MTK_DIP_CTX_P2_ID_PREVIEW;
+
+	/* Initialize main data structure */
+	mtk_dip_ctx_core_queue_setup(preview_ctx, &preview_queues_setting);
+
+	return mtk_dip_ctx_core_steup(preview_ctx,
+		&mtk_dip_ctx_dip_preview_setting);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_dip_preview_init);
+
+/* MTK ISP context initialization */
+int mtk_dip_ctx_dip_capture_init(struct mtk_dip_ctx *capture_ctx)
+{
+	capture_ctx->ctx_id =  MTK_DIP_CTX_P2_ID_CAPTURE;
+	/* Initialize main data structure */
+	mtk_dip_ctx_core_queue_setup(capture_ctx, &capture_queues_setting);
+
+	return mtk_dip_ctx_core_steup(capture_ctx,
+		&mtk_dip_ctx_dip_capture_setting);
+}
+EXPORT_SYMBOL_GPL(mtk_dip_ctx_dip_capture_init);
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
new file mode 100644
index 0000000..421da60
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
@@ -0,0 +1,60 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_V4L2__
+#define __MTK_DIP_V4L2__
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include "mtk_dip-dev.h"
+#include "mtk_dip-core.h"
+
+#define MTK_DIP_CTX_P2_ID_PREVIEW (0)
+#define MTK_DIP_CTX_P2_ID_CAPTURE (1)
+
+/* Input: RAW image */
+#define MTK_DIP_CTX_P2_RAW_QUEUE_IN		(0)
+/* Input: binary parameters */
+#define MTK_DIP_CTX_P2_TUNING_QUEUE_IN		(1)
+#define MTK_DIP_CTX_P2_TOTAL_OUTPUT (2)
+
+/* OUT: Main output for still or video */
+#define MTK_DIP_CTX_P2_MDP0_QUEUE_OUT		(2)
+/* OUT: Preview */
+#define MTK_DIP_CTX_P2_MDP1_QUEUE_OUT		(3)
+#define MTK_DIP_CTX_P2_TOTAL_CAPTURE (2)
+
+enum STREAM_TYPE_ENUM {
+		STREAM_UNKNOWN,
+		STREAM_BITBLT,
+		STREAM_GPU_BITBLT,
+		STREAM_DUAL_BITBLT,
+		STREAM_2ND_BITBLT,
+		STREAM_ISP_IC,
+		STREAM_ISP_VR,
+		STREAM_ISP_ZSD,
+		STREAM_ISP_IP,
+		STREAM_ISP_VSS,
+		STREAM_ISP_ZSD_SLOW,
+		STREAM_WPE,
+		STREAM_WPE2,
+};
+
+int mtk_dip_ctx_dip_preview_init(struct mtk_dip_ctx *preview_ctx);
+int mtk_dip_ctx_dip_capture_init(struct mtk_dip_ctx *capture_ctx);
+int mtk_dip_ctx_dip_v4l2_init(struct platform_device *pdev,
+			      struct mtk_dip_dev *isp_preview_dev,
+			      struct mtk_dip_dev *isp_capture_dev);
+#endif /*__MTK_DIP_V4L2__*/
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
new file mode 100644
index 0000000..3569c7c
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
@@ -0,0 +1,1385 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+/*
+ * Copyright (c) 2018 MediaTek Inc.
+ * Author: Holmes Chiou <holmes.chiou@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/of_device.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/kthread.h> /* thread functions */
+#include <linux/pm_runtime.h>
+#include <linux/dma-iommu.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h> /* kzalloc and kfree */
+
+#include "mtk_vpu.h"
+#include "mtk-mdp3-cmdq.h"
+
+#include "mtk_dip-dev.h"
+#include "mtk_dip.h"
+#include "mtk_dip-core.h"
+#include "mtk_dip-v4l2.h"
+
+#define DIP_DEV_NAME		"camera-dip"
+
+#define DIP_COMPOSER_THREAD_TIMEOUT     (16U)
+#define DIP_COMPOSING_WQ_TIMEOUT	(16U)
+#define DIP_COMPOSING_MAX_NUM		(3)
+#define DIP_FLUSHING_WQ_TIMEOUT		(16U)
+
+#define DIP_MAX_ERR_COUNT		(188U)
+
+#define DIP_FRM_SZ		(76 * 1024)
+#define DIP_SUB_FRM_SZ		(16 * 1024)
+#define DIP_TUNING_SZ		(32 * 1024)
+#define DIP_COMP_SZ		(24 * 1024)
+#define DIP_FRAMEPARAM_SZ	(4 * 1024)
+
+#define DIP_TUNING_OFFSET	(DIP_SUB_FRM_SZ)
+#define DIP_COMP_OFFSET		(DIP_TUNING_OFFSET + DIP_TUNING_SZ)
+#define DIP_FRAMEPARAM_OFFSET	(DIP_COMP_OFFSET + DIP_COMP_SZ)
+
+#define DIP_SUB_FRM_DATA_NUM	(32)
+
+#define DIP_SCP_WORKINGBUF_OFFSET	(5 * 1024 * 1024)
+
+#define DIP_GET_ID(x)			(((x) & 0xffff0000) >> 16)
+
+static const struct of_device_id dip_of_ids[] = {
+	/* Remider: Add this device node manually in .dtsi */
+	{ .compatible = "mediatek,mt8183-dip", },
+	{}
+};
+
+static void call_mtk_dip_ctx_finish(struct dip_device *dip_dev,
+				    struct img_ipi_frameparam *iparam);
+
+static struct img_frameparam *dip_create_framejob(int sequence)
+{
+	struct dip_frame_job *fjob = NULL;
+
+	fjob = kzalloc(sizeof(*fjob), GFP_ATOMIC);
+
+	if (!fjob)
+		return NULL;
+
+	fjob->sequence = sequence;
+
+	return &fjob->fparam;
+}
+
+static void dip_free_framejob(struct img_frameparam *fparam)
+{
+	struct dip_frame_job *fjob = NULL;
+
+	fjob = mtk_dip_fparam_to_job(fparam);
+
+	/* to avoid use after free issue */
+	fjob->sequence = -1;
+
+	kfree(fjob);
+}
+
+static void dip_enable_ccf_clock(struct dip_device *dip_dev)
+{
+	int ret;
+
+	ret = pm_runtime_get_sync(dip_dev->larb_dev);
+	if (ret < 0)
+		dev_err(&dip_dev->pdev->dev, "cannot get smi larb clock\n");
+
+	ret = clk_prepare_enable(dip_dev->dip_clk.DIP_IMG_LARB5);
+	if (ret)
+		dev_err(&dip_dev->pdev->dev,
+			"cannot prepare and enable DIP_IMG_LARB5 clock\n");
+
+	ret = clk_prepare_enable(dip_dev->dip_clk.DIP_IMG_DIP);
+	if (ret)
+		dev_err(&dip_dev->pdev->dev,
+			"cannot prepare and enable DIP_IMG_DIP clock\n");
+}
+
+static void dip_disable_ccf_clock(struct dip_device *dip_dev)
+{
+	clk_disable_unprepare(dip_dev->dip_clk.DIP_IMG_DIP);
+	clk_disable_unprepare(dip_dev->dip_clk.DIP_IMG_LARB5);
+	pm_runtime_put_sync(dip_dev->larb_dev);
+}
+
+static int dip_send(struct platform_device *pdev, enum ipi_id id,
+		    void *buf, unsigned int  len, unsigned int wait)
+{
+	vpu_ipi_send_sync_async(pdev, id, buf, len, wait);
+	return 0;
+}
+
+static void call_mtk_dip_ctx_finish(struct dip_device *dip_dev,
+				    struct img_ipi_frameparam *iparam)
+{
+	struct mtk_dip_ctx_finish_param fparam;
+	struct mtk_isp_dip_drv_data *drv_data;
+	struct mtk_dip_ctx *dev_ctx;
+	int ctx_id = 0;
+	int r = 0;
+
+	if (!dip_dev) {
+		pr_err("Can't update buffer status, dip_dev can't be NULL\n");
+		return;
+	}
+
+	if (!iparam) {
+		dev_err(&dip_dev->pdev->dev,
+			"%s: iparam can't be NULL\n", __func__);
+		return;
+	}
+
+	drv_data = dip_dev_to_drv(dip_dev);
+
+	frame_param_ipi_to_ctx(iparam, &fparam);
+	ctx_id = MTK_DIP_GET_CTX_ID_FROM_SEQUENCE(fparam.frame_id);
+
+	if (ctx_id == MTK_DIP_CTX_P2_ID_PREVIEW) {
+		dev_ctx = &drv_data->isp_preview_dev.ctx;
+	} else if (ctx_id == MTK_DIP_CTX_P2_ID_CAPTURE) {
+		dev_ctx = &drv_data->isp_capture_dev.ctx;
+	} else {
+		dev_err(&dip_dev->pdev->dev,
+			"unknown ctx id: %d\n", ctx_id);
+		return;
+	}
+
+	r = mtk_dip_ctx_core_job_finish(dev_ctx, &fparam);
+
+	if (r)
+		dev_err(&dip_dev->pdev->dev, "finish op failed: %d\n",
+			r);
+	dev_dbg(&dip_dev->pdev->dev, "Ready to return buffers: CTX(%d), Frame(%d)\n",
+		ctx_id, fparam.frame_id);
+}
+
+static void mtk_dip_notify(void *data)
+{
+	struct dip_device	*dip_dev;
+	struct mtk_dip_hw_ctx	*dip_ctx;
+	struct img_frameparam	*framejob;
+	struct dip_user_id	*user_id;
+	struct dip_subframe	*buf, *tmpbuf;
+	struct img_ipi_frameparam	*frameparam;
+	u32 num;
+	bool found = false;
+
+	frameparam = (struct img_ipi_frameparam *)data;
+	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
+	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
+	framejob = container_of(frameparam,
+				struct img_frameparam,
+				frameparam);
+
+	if (frameparam->state == FRAME_STATE_HW_TIMEOUT) {
+		dip_send(dip_ctx->vpu_pdev, IPI_DIP_FRAME,
+			 (void *)frameparam, sizeof(*frameparam), 0);
+		dev_err(&dip_dev->pdev->dev, "frame no(%d) HW timeout\n",
+			frameparam->frame_no);
+	}
+
+	mutex_lock(&dip_ctx->dip_usedbufferlist.queuelock);
+	list_for_each_entry_safe(buf, tmpbuf,
+				 &dip_ctx->dip_usedbufferlist.queue,
+				 list_entry) {
+		if (buf->buffer.pa == frameparam->subfrm_data.pa) {
+			list_del(&buf->list_entry);
+			dip_ctx->dip_usedbufferlist.queue_cnt--;
+			found = true;
+			dev_dbg(&dip_dev->pdev->dev,
+				"Find used buffer (%x)\n", buf->buffer.pa);
+			break;
+		}
+	}
+	mutex_unlock(&dip_ctx->dip_usedbufferlist.queuelock);
+
+	if (!found) {
+		dev_err(&dip_dev->pdev->dev,
+			"frame_no(%d) buffer(%x) used buffer count(%d)\n",
+			frameparam->frame_no, frameparam->subfrm_data.pa,
+			dip_ctx->dip_usedbufferlist.queue_cnt);
+
+		frameparam->state = FRAME_STATE_ERROR;
+
+	} else {
+		mutex_lock(&dip_ctx->dip_freebufferlist.queuelock);
+		list_add_tail(&buf->list_entry,
+			      &dip_ctx->dip_freebufferlist.queue);
+		dip_ctx->dip_freebufferlist.queue_cnt++;
+		mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
+
+		frameparam->state = FRAME_STATE_DONE;
+	}
+
+	call_mtk_dip_ctx_finish(dip_dev, frameparam);
+
+	found = false;
+	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+	list_for_each_entry(user_id,
+			    &dip_ctx->dip_useridlist.queue,
+			    list_entry) {
+		if (DIP_GET_ID(frameparam->index) == user_id->id) {
+			user_id->num--;
+			dev_dbg(&dip_dev->pdev->dev,
+				"user_id(%x) is found, and cnt: %d\n",
+				user_id->id, user_id->num);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+	wake_up(&dip_ctx->flushing_wq);
+	dev_dbg(&dip_dev->pdev->dev,
+		"frame_no(%d) is finished\n", framejob->frameparam.frame_no);
+	dip_free_framejob(framejob);
+
+	num = atomic_dec_return(&dip_ctx->num_running);
+	dev_dbg(&dip_dev->pdev->dev, "Running count: %d\n", num);
+}
+
+static void mdp_cb_worker(struct work_struct *work)
+{
+	struct mtk_mdpcb_work *mdpcb_work;
+
+	mdpcb_work = container_of(work, struct mtk_mdpcb_work, frame_work);
+	mtk_dip_notify(mdpcb_work->frameparams);
+	kfree(mdpcb_work);
+}
+
+static struct img_ipi_frameparam *convert_to_fparam(struct cmdq_cb_data *data)
+{
+	struct device *dev = NULL;
+	struct dip_device *dip_dev = NULL;
+	struct dip_frame_job *fjob = NULL;
+	struct img_ipi_frameparam *ipi_fparam = NULL;
+
+	if (!data) {
+		dev_err(dev, "DIP got NULL in cmdq_cb_data,%s\n",
+			__func__);
+		return NULL;
+	}
+
+	if (data->sta != CMDQ_CB_NORMAL) {
+		dev_warn(dev, "DIP got CMDQ CB (%d) without CMDQ_CB_NORMAL\n",
+			 data->sta);
+	}
+
+	if (!data->data) {
+		dev_err(dev, "DIP got NULL data in cmdq_cb_data,%s\n",
+			__func__);
+		return NULL;
+	}
+
+	fjob = mtk_dip_ipi_fparam_to_job(data->data);
+
+	if (fjob->sequence == -1) {
+		dev_err(dev, "Invalid cmdq_cb_data(%llx)\n",
+			(unsigned long long)data);
+		ipi_fparam = NULL;
+	} else {
+		ipi_fparam = &fjob->fparam.frameparam;
+		dip_dev = dip_hw_ctx_to_dev((void *)ipi_fparam->drv_data);
+		dev = &dip_dev->pdev->dev;
+	}
+
+	dev_dbg(dev, "framejob(0x%llx,seq:%d):\n",
+		(unsigned long long)fjob, fjob->sequence);
+	dev_dbg(dev, "idx(%d),no(%d),s(%d),n_in(%d),n_out(%d),drv(%llx)\n",
+		fjob->fparam.frameparam.index,
+		fjob->fparam.frameparam.frame_no,
+		fjob->fparam.frameparam.state,
+		fjob->fparam.frameparam.num_inputs,
+		fjob->fparam.frameparam.num_outputs,
+		(unsigned long long)fjob->fparam.frameparam.drv_data
+	);
+
+	return ipi_fparam;
+}
+
+/* Maybe in IRQ context of cmdq */
+void dip_mdp_cb_func(struct cmdq_cb_data data)
+{
+	struct img_ipi_frameparam *frameparam;
+	struct mtk_dip_hw_ctx *dip_ctx;
+	struct mtk_mdpcb_work *mdpcb_work;
+
+	frameparam = convert_to_fparam(&data);
+
+	if (!frameparam) {
+		dev_err(NULL, "%s return due to invalid cmdq_cb_data(%llx)",
+			__func__, &data);
+		return;
+	}
+
+	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
+
+	mdpcb_work = kzalloc(sizeof(*mdpcb_work), GFP_ATOMIC);
+	WARN_ONCE(!mdpcb_work, "frame_no(%d) is lost", frameparam->frame_no);
+	if (!mdpcb_work)
+		return;
+
+	INIT_WORK(&mdpcb_work->frame_work, mdp_cb_worker);
+	mdpcb_work->frameparams = frameparam;
+	if (data.sta != CMDQ_CB_NORMAL)
+		mdpcb_work->frameparams->state = FRAME_STATE_HW_TIMEOUT;
+
+	queue_work(dip_ctx->mdpcb_workqueue, &mdpcb_work->frame_work);
+}
+
+static void dip_vpu_handler(void *data, unsigned int len, void *priv)
+{
+	struct img_frameparam *framejob;
+	struct img_ipi_frameparam *frameparam;
+	struct mtk_dip_hw_ctx *dip_ctx;
+	struct dip_device *dip_dev;
+	unsigned long flags;
+	u32 num;
+
+	WARN_ONCE(!data, "%s is failed due to NULL data\n", __func__);
+	if (!data)
+		return;
+
+	frameparam = (struct img_ipi_frameparam *)data;
+
+	framejob = dip_create_framejob(frameparam->index);
+	WARN_ONCE(!framejob, "frame_no(%d) is lost", frameparam->frame_no);
+	if (!framejob)
+		return;
+
+	dip_ctx = (struct mtk_dip_hw_ctx *)frameparam->drv_data;
+	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
+
+	wake_up(&dip_ctx->composing_wq);
+	memcpy(&framejob->frameparam, data, sizeof(framejob->frameparam));
+	num = atomic_dec_return(&dip_ctx->num_composing);
+
+	spin_lock_irqsave(&dip_ctx->dip_gcejoblist.queuelock, flags);
+	list_add_tail(&framejob->list_entry, &dip_ctx->dip_gcejoblist.queue);
+	dip_ctx->dip_gcejoblist.queue_cnt++;
+	spin_unlock_irqrestore(&dip_ctx->dip_gcejoblist.queuelock, flags);
+
+	dev_dbg(&dip_dev->pdev->dev,
+		"frame_no(%d) is back, composing num: %d\n",
+		frameparam->frame_no, num);
+
+	wake_up(&dip_ctx->dip_runner_thread.wq);
+}
+
+static int dip_runner_func(void *data)
+{
+	struct img_frameparam	*framejob;
+	struct mtk_dip_hw_ctx	*dip_ctx;
+	struct dip_device	*dip_dev;
+	struct dip_user_id	*user_id;
+	unsigned long		flags;
+	bool			found;
+	u32			queuecnt, num;
+	int			ret;
+
+	dip_ctx = (struct mtk_dip_hw_ctx *)data;
+	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
+
+	while (1) {
+		spin_lock_irqsave(&dip_ctx->dip_gcejoblist.queuelock, flags);
+		queuecnt = dip_ctx->dip_gcejoblist.queue_cnt;
+		spin_unlock_irqrestore(&dip_ctx->dip_gcejoblist.queuelock,
+				       flags);
+
+		ret = wait_event_interruptible_timeout
+			(dip_ctx->dip_runner_thread.wq,
+			 queuecnt,
+			 msecs_to_jiffies(DIP_COMPOSER_THREAD_TIMEOUT));
+
+		if (ret == 0) {
+			/* Timeout */
+			ret = -ETIME;
+		} else if (ret == -ERESTARTSYS) {
+			dev_err(&dip_dev->pdev->dev,
+				"interrupted by a signal!\n");
+		}
+
+		if (queuecnt > 0) {
+			spin_lock_irqsave(&dip_ctx->dip_gcejoblist.queuelock,
+					  flags);
+			framejob = list_first_entry
+				(&dip_ctx->dip_gcejoblist.queue,
+				 struct img_frameparam, list_entry);
+
+			dip_ctx->dip_gcejoblist.queue_cnt--;
+			list_del(&framejob->list_entry);
+			spin_unlock_irqrestore
+				(&dip_ctx->dip_gcejoblist.queuelock, flags);
+
+			found = false;
+			mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+			list_for_each_entry(user_id,
+					    &dip_ctx->dip_useridlist.queue,
+					    list_entry) {
+				if (DIP_GET_ID(framejob->frameparam.index) ==
+					user_id->id) {
+					found = true;
+					break;
+				}
+			}
+			mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+			if (!found) {
+				dev_err(&dip_dev->pdev->dev,
+					"frame_no(%d) index: %x is abnormal\n",
+					framejob->frameparam.frame_no,
+					framejob->frameparam.index);
+				/* Due to error index, DIP driver could NOT  */
+				/* notify the V4L2 common driver to  */
+				/* return buffer */
+				dip_free_framejob(framejob);
+				continue;
+			}
+
+			mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+			if (user_id->state == DIP_STATE_STREAMOFF) {
+				mutex_unlock
+					(&dip_ctx->dip_useridlist.queuelock);
+
+				framejob->frameparam.state =
+					FRAME_STATE_STREAMOFF;
+				call_mtk_dip_ctx_finish(dip_dev,
+							&framejob->frameparam);
+				mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+				user_id->num--;
+				mutex_unlock
+					(&dip_ctx->dip_useridlist.queuelock);
+
+				dev_dbg(&dip_dev->pdev->dev,
+					"user_id(%x) streamoff, current num:%d, frame_no(%d) flushed\n",
+					user_id->id, user_id->num,
+					framejob->frameparam.frame_no);
+
+				dip_free_framejob(framejob);
+				continue;
+			}
+			mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+			dev_dbg(&dip_dev->pdev->dev,
+				"MDP Run frame_no(%d) and the rest joblist count: %d\n",
+				framejob->frameparam.frame_no,
+				dip_ctx->dip_gcejoblist.queue_cnt);
+
+			/* Call MDP/GCE API to do HW excecution
+			 * Pass the framejob to MDP driver
+			 */
+			framejob->frameparam.state = FRAME_STATE_COMPOSING;
+
+			mdp_cmdq_sendtask
+				(dip_ctx->mdp_pdev,
+				 (struct img_config *)
+					framejob->frameparam.config_data.va,
+				 &framejob->frameparam, NULL, false,
+				 dip_mdp_cb_func,
+				 (void *)&framejob->frameparam);
+
+			num = atomic_inc_return(&dip_ctx->num_running);
+			dev_dbg(&dip_dev->pdev->dev,
+				"MDP Running num: %d\n", num);
+		}
+
+		if (kthread_should_stop())
+			do_exit(0);
+
+	};
+
+	return 0;
+}
+
+static void dip_submit_worker(struct work_struct *work)
+{
+	struct mtk_dip_submit_work *dip_submit_work =
+		container_of(work, struct mtk_dip_submit_work, frame_work);
+
+	struct mtk_dip_hw_ctx  *dip_ctx = dip_submit_work->dip_ctx;
+	struct mtk_dip_work *dip_work;
+	struct dip_device *dip_dev;
+	struct dip_subframe *buf;
+	u32 len, num;
+	int ret;
+
+	dip_dev = container_of(dip_ctx, struct dip_device, dip_ctx);
+	num  = atomic_read(&dip_ctx->num_composing);
+
+	mutex_lock(&dip_ctx->dip_worklist.queuelock);
+	dip_work = list_first_entry(&dip_ctx->dip_worklist.queue,
+				    struct mtk_dip_work, list_entry);
+	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
+
+	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+	if (dip_work->user_id->state == DIP_STATE_STREAMOFF) {
+		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+		dip_work->frameparams.state = FRAME_STATE_STREAMOFF;
+		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
+
+		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+		dip_work->user_id->num--;
+		dev_dbg(&dip_dev->pdev->dev,
+			"user_id(%x) is streamoff and num: %d, frame_no(%d) index: %x\n",
+			dip_work->user_id->id, dip_work->user_id->num,
+			dip_work->frameparams.frame_no,
+			dip_work->frameparams.index);
+		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+		goto free_work_list;
+	}
+	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+	while (num >= DIP_COMPOSING_MAX_NUM) {
+		ret = wait_event_interruptible_timeout
+			(dip_ctx->composing_wq,
+			 (num < DIP_COMPOSING_MAX_NUM),
+			 msecs_to_jiffies(DIP_COMPOSING_WQ_TIMEOUT));
+
+		if (ret == -ERESTARTSYS)
+			dev_err(&dip_dev->pdev->dev,
+				"interrupted by a signal!\n");
+		else if (ret == 0)
+			dev_dbg(&dip_dev->pdev->dev,
+				"timeout frame_no(%d), num: %d\n",
+				dip_work->frameparams.frame_no, num);
+		else
+			dev_dbg(&dip_dev->pdev->dev,
+				"wakeup frame_no(%d), num: %d\n",
+				dip_work->frameparams.frame_no, num);
+
+		num = atomic_read(&dip_ctx->num_composing);
+	};
+
+	mutex_lock(&dip_ctx->dip_freebufferlist.queuelock);
+	if (list_empty(&dip_ctx->dip_freebufferlist.queue)) {
+		mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
+
+		dev_err(&dip_dev->pdev->dev,
+			"frame_no(%d) index: %x no free buffer: %d\n",
+			dip_work->frameparams.frame_no,
+			dip_work->frameparams.index,
+			dip_ctx->dip_freebufferlist.queue_cnt);
+
+		/* Call callback to notify V4L2 common framework
+		 * for failure of enqueue
+		 */
+		dip_work->frameparams.state = FRAME_STATE_ERROR;
+		call_mtk_dip_ctx_finish(dip_dev, &dip_work->frameparams);
+
+		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+		dip_work->user_id->num--;
+		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+		goto free_work_list;
+	}
+
+	buf = list_first_entry(&dip_ctx->dip_freebufferlist.queue,
+			       struct dip_subframe,
+			       list_entry);
+	list_del(&buf->list_entry);
+	dip_ctx->dip_freebufferlist.queue_cnt--;
+	mutex_unlock(&dip_ctx->dip_freebufferlist.queuelock);
+
+	mutex_lock(&dip_ctx->dip_usedbufferlist.queuelock);
+	list_add_tail(&buf->list_entry, &dip_ctx->dip_usedbufferlist.queue);
+	dip_ctx->dip_usedbufferlist.queue_cnt++;
+	mutex_unlock(&dip_ctx->dip_usedbufferlist.queuelock);
+
+	memcpy(&dip_work->frameparams.subfrm_data,
+	       &buf->buffer, sizeof(buf->buffer));
+
+	memset((char *)buf->buffer.va, 0, DIP_SUB_FRM_SZ);
+
+	memcpy(&dip_work->frameparams.config_data,
+	       &buf->config_data, sizeof(buf->config_data));
+
+	memset((char *)buf->config_data.va, 0, DIP_COMP_SZ);
+
+	if (dip_work->frameparams.tuning_data.pa == 0) {
+		dev_dbg(&dip_dev->pdev->dev,
+			"frame_no(%d) has no tuning_data\n",
+			dip_work->frameparams.frame_no);
+
+		memcpy(&dip_work->frameparams.tuning_data,
+		       &buf->tuning_buf, sizeof(buf->tuning_buf));
+
+		memset((char *)buf->tuning_buf.va, 0, DIP_TUNING_SZ);
+		/* When user enqueued without tuning buffer,
+		 * it would use driver internal buffer.
+		 * So, tuning_data.va should be 0
+		 */
+		dip_work->frameparams.tuning_data.va = 0;
+	}
+
+	dip_work->frameparams.drv_data = (u64)dip_ctx;
+	dip_work->frameparams.state = FRAME_STATE_COMPOSING;
+
+	memcpy((void *)buf->frameparam.va, &dip_work->frameparams,
+	       sizeof(dip_work->frameparams));
+
+	dip_send(dip_ctx->vpu_pdev, IPI_DIP_FRAME,
+		 (void *)&dip_work->frameparams,
+		 sizeof(dip_work->frameparams), 0);
+	num = atomic_inc_return(&dip_ctx->num_composing);
+
+free_work_list:
+
+	mutex_lock(&dip_ctx->dip_worklist.queuelock);
+	list_del(&dip_work->list_entry);
+	dip_ctx->dip_worklist.queue_cnt--;
+	len = dip_ctx->dip_worklist.queue_cnt;
+	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
+
+	dev_dbg(&dip_dev->pdev->dev,
+		"frame_no(%d) index: %x, worklist count: %d, composing num: %d\n",
+		dip_work->frameparams.frame_no, dip_work->frameparams.index,
+		len, num);
+
+	kfree(dip_work);
+}
+
+static void dip_setclock(struct dip_device *dip_dev, bool enable)
+{
+	if (enable) {
+		dev_dbg(&dip_dev->pdev->dev, "CCF:prepare_enable clk\n");
+		dip_enable_ccf_clock(dip_dev);
+	} else {
+		dev_dbg(&dip_dev->pdev->dev, "CCF:disable_unprepare clk\n");
+		dip_disable_ccf_clock(dip_dev);
+	}
+}
+
+int dip_open_context(struct dip_device *dip_dev)
+{
+	u32 i;
+	phys_addr_t scp_mem_pa;
+	u64 scp_mem_va;
+	int ret = 0;
+	struct mtk_dip_hw_ctx *dip_ctx;
+
+	dip_ctx = &dip_dev->dip_ctx;
+
+	dip_ctx->mdp_pdev = mdp_get_plat_device(dip_dev->pdev);
+	if (!dip_ctx->mdp_pdev) {
+		dev_dbg(&dip_dev->pdev->dev, "Failed to get MDP device\n");
+		return -EINVAL;
+	}
+
+	init_waitqueue_head(&dip_ctx->dip_runner_thread.wq);
+
+	/*  All lists in DIP initialization */
+	INIT_LIST_HEAD(&dip_ctx->dip_gcejoblist.queue);
+	spin_lock_init(&dip_ctx->dip_gcejoblist.queuelock);
+	dip_ctx->dip_gcejoblist.queue_cnt = 0;
+
+	INIT_LIST_HEAD(&dip_ctx->dip_freebufferlist.queue);
+	mutex_init(&dip_ctx->dip_freebufferlist.queuelock);
+	dip_ctx->dip_freebufferlist.queue_cnt = 0;
+
+	INIT_LIST_HEAD(&dip_ctx->dip_usedbufferlist.queue);
+	mutex_init(&dip_ctx->dip_usedbufferlist.queuelock);
+	dip_ctx->dip_usedbufferlist.queue_cnt = 0;
+
+	dip_ctx->mdpcb_workqueue =
+		create_singlethread_workqueue("mdp_callback");
+	if (!dip_ctx->mdpcb_workqueue) {
+		dev_err(&dip_dev->pdev->dev,
+			"unable to alloc mdpcb workqueue\n");
+		ret = -ENOMEM;
+		goto err_alloc_mdpcb_wq;
+	}
+
+	dip_ctx->composer_wq =
+		create_singlethread_workqueue("dip_composer");
+	if (!dip_ctx->composer_wq) {
+		dev_err(&dip_dev->pdev->dev,
+			"unable to alloc composer workqueue\n");
+		ret = -ENOMEM;
+		goto err_alloc_composer_wq;
+	}
+	init_waitqueue_head(&dip_ctx->composing_wq);
+	init_waitqueue_head(&dip_ctx->flushing_wq);
+
+	dip_ctx->submit_work.dip_ctx = dip_ctx;
+	INIT_WORK(&dip_ctx->submit_work.frame_work, dip_submit_worker);
+
+	INIT_LIST_HEAD(&dip_ctx->dip_worklist.queue);
+	mutex_init(&dip_ctx->dip_worklist.queuelock);
+	dip_ctx->dip_worklist.queue_cnt = 0;
+
+	INIT_LIST_HEAD(&dip_ctx->dip_useridlist.queue);
+	mutex_init(&dip_ctx->dip_useridlist.queuelock);
+	dip_ctx->dip_useridlist.queue_cnt = 0;
+
+	dip_ctx->dip_runner_thread.thread =
+		kthread_run(dip_runner_func, (void *)dip_ctx, "dip_runner");
+
+	if (IS_ERR(dip_ctx->dip_runner_thread.thread)) {
+		dev_err(&dip_dev->pdev->dev, "unable to alloc workqueue\n");
+		ret = PTR_ERR(dip_ctx->dip_runner_thread.thread);
+		dip_ctx->dip_runner_thread.thread = NULL;
+		goto err_create_thread;
+	}
+
+	scp_mem_va = vpu_get_reserve_mem_virt(DIP_MEM_ID);
+	scp_mem_pa = vpu_get_reserve_mem_phys(DIP_MEM_ID);
+	dip_ctx->scp_workingbuf_addr = scp_mem_pa + DIP_SCP_WORKINGBUF_OFFSET;
+	dev_dbg(&dip_dev->pdev->dev,
+		"scp_mem_va: %llx, pa: %llx\n", scp_mem_va, (u64)scp_mem_pa);
+
+	vpu_ipi_register(dip_ctx->vpu_pdev, IPI_DIP_FRAME, dip_vpu_handler,
+			 "dip_vpu_handler", NULL);
+	/* Add debug ID  */
+
+	for (i = 0; i < DIP_SUB_FRM_DATA_NUM; i++) {
+		u32 size_align;
+		struct dip_subframe *buf;
+		struct sg_table *sgt;
+		struct page **pages;
+		u32 npages, j;
+
+		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto err_create_thread;
+		}
+
+		/* Total: 0 ~ 72 KB
+		 * SubFrame: 0 ~ 16 KB
+		 */
+		buf->buffer.pa = scp_mem_pa + i * DIP_FRM_SZ;
+		buf->buffer.va = scp_mem_va + i * DIP_FRM_SZ;
+
+		/* Tuning: 16 ~ 48 KB */
+		buf->tuning_buf.pa = buf->buffer.pa + DIP_TUNING_OFFSET;
+		buf->tuning_buf.va = buf->buffer.va + DIP_TUNING_OFFSET;
+
+		/* Config_data: 48 ~ 72 KB */
+		buf->config_data.pa = buf->buffer.pa + DIP_COMP_OFFSET;
+		buf->config_data.va = buf->buffer.va + DIP_COMP_OFFSET;
+
+		/* Frame parameters: 72 ~ 76 KB */
+		buf->frameparam.pa = buf->buffer.pa + DIP_FRAMEPARAM_OFFSET;
+		buf->frameparam.va = buf->buffer.va + DIP_FRAMEPARAM_OFFSET;
+
+		/* get iova */
+		npages = (DIP_SUB_FRM_SZ + DIP_TUNING_SZ) >> PAGE_SHIFT;
+		pages = kmalloc_array(npages,
+				      sizeof(struct page *),
+				      GFP_KERNEL);
+		if (!pages) {
+			kfree(buf);
+			ret = -ENOMEM;
+			goto err_create_thread;
+		}
+
+		sgt = &buf->table;
+		for (j = 0; j < npages; j++)
+			pages[j] =
+				phys_to_page(buf->buffer.pa + j * PAGE_SIZE);
+
+		size_align = round_up(DIP_SUB_FRM_SZ + DIP_TUNING_SZ,
+				      PAGE_SIZE);
+		ret = sg_alloc_table_from_pages(sgt, pages, npages,
+						0, size_align, GFP_KERNEL);
+		if (ret < 0) {
+			dev_err(&dip_dev->pdev->dev,
+				"failed to get sgt from pages.\n");
+			ret = -ENOMEM;
+			kfree(pages);
+			kfree(buf);
+			goto err_create_thread;
+		}
+
+		dma_map_sg_attrs(&dip_dev->pdev->dev, sgt->sgl, sgt->nents,
+				 DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
+		buf->buffer.iova = sg_dma_address(buf->table.sgl);
+		buf->tuning_buf.iova = buf->buffer.iova +
+			DIP_TUNING_OFFSET;
+
+		dev_dbg(&dip_dev->pdev->dev,
+			"buf pa (%d): %x, %x\n", i,
+			buf->buffer.pa,
+			buf->buffer.iova);
+
+		dev_dbg(&dip_dev->pdev->dev,
+			"config_data pa (%d): %x, %llx\n", i,
+			buf->config_data.pa,
+			buf->config_data.va);
+
+		dev_dbg(&dip_dev->pdev->dev,
+			"tuning_buf pa (%d): %x, %x\n", i,
+			buf->tuning_buf.pa,
+			buf->tuning_buf.iova);
+
+		dev_dbg(&dip_dev->pdev->dev,
+			"frameparam pa (%d): %x, %llx\n", i,
+			buf->frameparam.pa,
+			buf->frameparam.va);
+
+		list_add_tail(&buf->list_entry,
+			      &dip_ctx->dip_freebufferlist.queue);
+		dip_ctx->dip_freebufferlist.queue_cnt++;
+		kfree(pages);
+	}
+
+	return 0;
+
+err_create_thread:
+	mutex_destroy(&dip_ctx->dip_useridlist.queuelock);
+	mutex_destroy(&dip_ctx->dip_worklist.queuelock);
+	mutex_destroy(&dip_ctx->dip_usedbufferlist.queuelock);
+	mutex_destroy(&dip_ctx->dip_freebufferlist.queuelock);
+
+err_alloc_composer_wq:
+	destroy_workqueue(dip_ctx->composer_wq);
+
+err_alloc_mdpcb_wq:
+	destroy_workqueue(dip_ctx->mdpcb_workqueue);
+
+	return ret;
+}
+
+int dip_release_context(struct dip_device *dip_dev)
+{
+	u32 i = 0;
+	struct dip_subframe *buf, *tmpbuf;
+	struct mtk_dip_work *dip_work, *tmp_work;
+	struct dip_user_id  *dip_userid, *tmp_id;
+	struct mtk_dip_hw_ctx *dip_ctx;
+
+	dip_ctx = &dip_dev->dip_ctx;
+	dev_dbg(&dip_dev->pdev->dev, "composer work queue = %d\n",
+		dip_ctx->dip_worklist.queue_cnt);
+
+	list_for_each_entry_safe(dip_work, tmp_work,
+				 &dip_ctx->dip_worklist.queue,
+				 list_entry) {
+		list_del(&dip_work->list_entry);
+		dev_dbg(&dip_dev->pdev->dev, "dip work frame no: %d\n",
+			dip_work->frameparams.frame_no);
+		kfree(dip_work);
+		dip_ctx->dip_worklist.queue_cnt--;
+	}
+
+	if (dip_ctx->dip_worklist.queue_cnt != 0)
+		dev_dbg(&dip_dev->pdev->dev,
+			"dip_worklist is not empty (%d)\n",
+			dip_ctx->dip_worklist.queue_cnt);
+
+	list_for_each_entry_safe(dip_userid, tmp_id,
+				 &dip_ctx->dip_useridlist.queue,
+				 list_entry) {
+		list_del(&dip_userid->list_entry);
+		dev_dbg(&dip_dev->pdev->dev, "dip user id: %x\n",
+			dip_userid->id);
+		kfree(dip_userid);
+		dip_ctx->dip_useridlist.queue_cnt--;
+	}
+
+	if (dip_ctx->dip_useridlist.queue_cnt != 0)
+		dev_dbg(&dip_dev->pdev->dev,
+			"dip_useridlist is not empty (%d)\n",
+			dip_ctx->dip_useridlist.queue_cnt);
+
+	flush_workqueue(dip_ctx->mdpcb_workqueue);
+	destroy_workqueue(dip_ctx->mdpcb_workqueue);
+	dip_ctx->mdpcb_workqueue = NULL;
+
+	flush_workqueue(dip_ctx->composer_wq);
+	destroy_workqueue(dip_ctx->composer_wq);
+	dip_ctx->composer_wq = NULL;
+
+	atomic_set(&dip_ctx->num_composing, 0);
+	atomic_set(&dip_ctx->num_running, 0);
+
+	kthread_stop(dip_ctx->dip_runner_thread.thread);
+	dip_ctx->dip_runner_thread.thread = NULL;
+
+	atomic_set(&dip_ctx->dip_user_cnt, 0);
+	atomic_set(&dip_ctx->dip_stream_cnt, 0);
+	atomic_set(&dip_ctx->dip_enque_cnt, 0);
+
+	/* All the buffer should be in the freebufferlist when release */
+	list_for_each_entry_safe(buf, tmpbuf,
+				 &dip_ctx->dip_freebufferlist.queue,
+				 list_entry) {
+		struct sg_table *sgt = &buf->table;
+
+		dev_dbg(&dip_dev->pdev->dev,
+			"buf pa (%d): %x\n", i, buf->buffer.pa);
+		dip_ctx->dip_freebufferlist.queue_cnt--;
+		dma_unmap_sg_attrs(&dip_dev->pdev->dev, sgt->sgl,
+				   sgt->orig_nents,
+				   DMA_BIDIRECTIONAL, DMA_ATTR_SKIP_CPU_SYNC);
+		sg_free_table(sgt);
+		list_del(&buf->list_entry);
+		kfree(buf);
+		buf = NULL;
+		i++;
+	}
+
+	if (dip_ctx->dip_freebufferlist.queue_cnt != 0 &&
+	    i != DIP_SUB_FRM_DATA_NUM)
+		dev_err(&dip_dev->pdev->dev,
+			"dip_freebufferlist is not empty (%d/%d)\n",
+			dip_ctx->dip_freebufferlist.queue_cnt, i);
+
+	mutex_destroy(&dip_ctx->dip_useridlist.queuelock);
+	mutex_destroy(&dip_ctx->dip_worklist.queuelock);
+	mutex_destroy(&dip_ctx->dip_usedbufferlist.queuelock);
+	mutex_destroy(&dip_ctx->dip_freebufferlist.queuelock);
+
+	return 0;
+}
+
+static int mtk_dip_flush_by_id(struct platform_device *pdev,
+			       u16 id,
+			       struct dip_user_id *user_id)
+{
+	struct mtk_dip_hw_ctx	*dip_ctx;
+	struct dip_device	*dip_dev;
+
+	u32			num, err_cnt;
+	int			ret;
+
+	dip_dev = get_dip_device(&pdev->dev);
+	dip_ctx = &dip_dev->dip_ctx;
+
+	err_cnt = 0;
+	do {
+		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+		num = user_id->num;
+		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+		ret = wait_event_interruptible_timeout
+			(dip_ctx->flushing_wq,
+			 (num == 0),
+			 msecs_to_jiffies(DIP_FLUSHING_WQ_TIMEOUT));
+
+		if (ret == -ERESTARTSYS)
+			dev_err(&dip_dev->pdev->dev,
+				"interrupted by a signal! num: %d\n", num);
+		else if (ret == 0)
+			dev_dbg(&dip_dev->pdev->dev,
+				"timeout num: %d\n", num);
+		else
+			dev_dbg(&dip_dev->pdev->dev,
+				"wakeup  num: %d\n", num);
+
+		err_cnt++;
+
+		if (num > 0 && err_cnt >= DIP_MAX_ERR_COUNT) {
+			dev_err(&dip_dev->pdev->dev,
+				"Flushing is aborted num: %d, err_cnt: %d\n",
+				num, err_cnt);
+			return -EINVAL;
+		}
+
+	} while (num > 0);
+
+	dev_dbg(&dip_dev->pdev->dev, "Flushing is done num: %d\n", num);
+	return 0;
+}
+
+int mtk_dip_open(struct platform_device *pdev)
+{
+	int ret = 0;
+	s32 usercount;
+	struct dip_device *dip_dev;
+	struct mtk_dip_hw_ctx *dip_ctx;
+
+	if (!pdev) {
+		dev_err(&dip_dev->pdev->dev, "platform device is NULL\n");
+		return -EINVAL;
+	}
+
+	dip_dev = get_dip_device(&pdev->dev);
+	dip_ctx = &dip_dev->dip_ctx;
+	dev_dbg(&dip_dev->pdev->dev, "open dip_dev = 0x%p\n", dip_dev);
+
+	usercount = atomic_inc_return(&dip_dev->dip_ctx.dip_user_cnt);
+
+	if (usercount == 1) {
+		struct img_ipi_frameparam frameparam;
+
+		dip_ctx->vpu_pdev = vpu_get_plat_device(dip_dev->pdev);
+		if (!dip_ctx->vpu_pdev) {
+			dev_err(&dip_dev->pdev->dev,
+				"Failed to get VPU device\n");
+			return -EINVAL;
+		}
+		ret = vpu_load_firmware(dip_ctx->vpu_pdev);
+		if (ret < 0) {
+			/*
+			 * Return 0 if downloading firmware successfully,
+			 * otherwise it is failed
+			 */
+			dev_err(&dip_dev->pdev->dev,
+				"vpu_load_firmware failed!");
+			return -EINVAL;
+		}
+
+		/* Enable clock */
+		dip_setclock(dip_dev, true);
+
+		/* DIP HW INIT */
+		memset(&frameparam, 0, sizeof(frameparam));
+		/* SCP only support 32bits address */
+		frameparam.drv_data = (u64)dip_ctx;
+		frameparam.state = FRAME_STATE_INIT;
+		dip_send(dip_ctx->vpu_pdev, IPI_DIP_INIT,
+			 (void *)&frameparam, sizeof(frameparam), 0);
+
+		dip_open_context(dip_dev);
+	}
+
+	dev_dbg(&dip_dev->pdev->dev, "usercount = %d\n", usercount);
+	return ret;
+}
+EXPORT_SYMBOL(mtk_dip_open);
+
+int mtk_dip_release(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct dip_device *dip_dev;
+
+	if (!pdev) {
+		dev_err(&dip_dev->pdev->dev, "platform device is NULL\n");
+		return -EINVAL;
+	}
+
+	dip_dev = get_dip_device(&pdev->dev);
+
+	dev_dbg(&dip_dev->pdev->dev, "release dip_dev = 0x%p\n", dip_dev);
+
+	if (atomic_dec_and_test(&dip_dev->dip_ctx.dip_user_cnt)) {
+		dip_release_context(dip_dev);
+		dip_setclock(dip_dev, false);
+	}
+	dev_dbg(&dip_dev->pdev->dev, "usercount = %d\n",
+		atomic_read(&dip_dev->dip_ctx.dip_user_cnt));
+
+	return ret;
+}
+EXPORT_SYMBOL(mtk_dip_release);
+
+int mtk_dip_streamon(struct platform_device *pdev, u16 id)
+{
+	struct dip_device *dip_dev;
+	struct dip_user_id *user_id;
+	struct mtk_dip_hw_ctx *dip_ctx;
+	s32 count, len;
+
+	dip_dev = get_dip_device(&pdev->dev);
+	dip_ctx = &dip_dev->dip_ctx;
+	count = atomic_inc_return(&dip_ctx->dip_stream_cnt);
+
+	dev_dbg(&dip_dev->pdev->dev, "%s id: %x\n", __func__, id);
+
+	user_id = kzalloc(sizeof(*user_id), GFP_KERNEL);
+	if (!user_id)
+		return -ENOMEM;
+
+	user_id->id = id;
+	user_id->state = DIP_STATE_STREAMON;
+
+	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+	list_add_tail(&user_id->list_entry, &dip_ctx->dip_useridlist.queue);
+	dip_ctx->dip_useridlist.queue_cnt++;
+	len = dip_ctx->dip_useridlist.queue_cnt;
+	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+	dev_dbg(&dip_dev->pdev->dev,
+		"stream count = %d,  id: %x len: %d\n", count, id, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(mtk_dip_streamon);
+
+int mtk_dip_streamoff(struct platform_device *pdev, u16 id)
+{
+	struct dip_device  *dip_dev;
+	struct dip_user_id *user_id;
+	struct mtk_dip_hw_ctx *dip_ctx;
+	s32 count = -1;
+	bool found = false;
+	int ret;
+
+	dip_dev = get_dip_device(&pdev->dev);
+	dip_ctx = &dip_dev->dip_ctx;
+	dev_dbg(&dip_dev->pdev->dev, "streamoff id (%x)\n", id);
+
+	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+	list_for_each_entry(user_id,
+			    &dip_ctx->dip_useridlist.queue, list_entry) {
+		if (user_id->id == id) {
+			user_id->state = DIP_STATE_STREAMOFF;
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+	if (found) {
+		ret = mtk_dip_flush_by_id(pdev, id, user_id);
+		if (ret != 0) {
+			dev_err(&dip_dev->pdev->dev,
+				"stream id(%x) streamoff error: %d\n",
+				id, ret);
+			WARN_ON(1);
+		}
+
+		mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+		list_del(&user_id->list_entry);
+		dip_ctx->dip_useridlist.queue_cnt--;
+		dev_dbg(&dip_dev->pdev->dev,
+			"stream id(%x) user_id count: %d\n",
+			id, dip_ctx->dip_useridlist.queue_cnt);
+		mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+		kfree(user_id);
+		user_id = NULL;
+		count = atomic_dec_return(&dip_ctx->dip_stream_cnt);
+
+		dev_dbg(&dip_dev->pdev->dev, "stream id(%x) count = %d\n",
+			id, count);
+	} else {
+		dev_dbg(&dip_dev->pdev->dev,
+			"stream id(%x) is not found\n", id);
+	}
+
+	if (count < 0)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(mtk_dip_streamoff);
+
+int mtk_dip_enqueue(struct platform_device *pdev,
+		    struct img_ipi_frameparam *frameparams)
+{
+	struct mtk_dip_work	*framework = NULL;
+	struct mtk_dip_hw_ctx	*dip_ctx = NULL;
+	struct dip_device	*dip_dev = NULL;
+	struct dip_user_id	*user_id = NULL;
+	bool	found = false;
+	u32	tmpcount;
+
+	dip_dev = get_dip_device(&pdev->dev);
+	dip_ctx = &dip_dev->dip_ctx;
+
+	dev_dbg(&dip_dev->pdev->dev, "%s index: %x",
+		__func__, frameparams->index);
+
+	mutex_lock(&dip_ctx->dip_useridlist.queuelock);
+	list_for_each_entry(user_id, &dip_ctx->dip_useridlist.queue,
+			    list_entry) {
+		if (DIP_GET_ID(frameparams->index) == user_id->id) {
+			user_id->num++;
+			dev_dbg(&dip_dev->pdev->dev,
+				"user_id(%x) is found and current num: %d\n",
+				user_id->id, user_id->num);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&dip_ctx->dip_useridlist.queuelock);
+
+	if (!found) {
+		dev_err(&dip_dev->pdev->dev,
+			"user_id(%x) can NOT be found, index: %x\n",
+			DIP_GET_ID(frameparams->index),
+			frameparams->index);
+		return -EINVAL;
+	}
+
+	framework = kzalloc(sizeof(*framework), GFP_KERNEL);
+	if (!framework)
+		return -ENOMEM;
+
+	memcpy(&framework->frameparams, frameparams, sizeof(*frameparams));
+	framework->frameparams.state = FRAME_STATE_INIT;
+	framework->frameparams.frame_no =
+		atomic_inc_return(&dip_ctx->dip_enque_cnt);
+	framework->user_id = user_id;
+
+	mutex_lock(&dip_dev->dip_ctx.dip_worklist.queuelock);
+	list_add_tail(&framework->list_entry, &dip_ctx->dip_worklist.queue);
+	dip_ctx->dip_worklist.queue_cnt++;
+	tmpcount = dip_ctx->dip_worklist.queue_cnt;
+	mutex_unlock(&dip_ctx->dip_worklist.queuelock);
+	dev_dbg(&dip_dev->pdev->dev, "frame_no(%d) into worklist count: %d\n",
+		framework->frameparams.frame_no, tmpcount);
+
+	queue_work(dip_ctx->composer_wq, &dip_ctx->submit_work.frame_work);
+	return 0;
+}
+EXPORT_SYMBOL(mtk_dip_enqueue);
+
+static int mtk_dip_probe(struct platform_device *pdev)
+{
+	struct mtk_isp_dip_drv_data *dip_drv;
+	struct dip_device *dip_dev;
+	struct mtk_dip_hw_ctx *dip_ctx;
+	struct device_node *node;
+	struct platform_device *larb_pdev;
+
+	int ret = 0;
+
+	dev_info(&pdev->dev, "E. DIP driver probe.\n");
+
+	dip_drv = devm_kzalloc(&pdev->dev, sizeof(*dip_drv), GFP_KERNEL);
+	dev_set_drvdata(&pdev->dev, dip_drv);
+	dip_dev = &dip_drv->dip_dev;
+
+	if (!dip_dev)
+		return -ENOMEM;
+
+	dev_info(&pdev->dev, "Created dip_dev = 0x%p\n", dip_dev);
+
+	dip_dev->pdev = pdev;
+	dip_ctx = &dip_dev->dip_ctx;
+
+	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
+	if (!node) {
+		dev_err(&pdev->dev, "no mediatek,larb found");
+		return -EINVAL;
+	}
+	larb_pdev = of_find_device_by_node(node);
+	if (!larb_pdev) {
+		dev_err(&pdev->dev, "no mediatek,larb device found");
+		return -EINVAL;
+	}
+	dip_dev->larb_dev = &larb_pdev->dev;
+
+	/*CCF: Grab clock pointer (struct clk*) */
+	dip_dev->dip_clk.DIP_IMG_LARB5 = devm_clk_get(&pdev->dev,
+						      "DIP_CG_IMG_LARB5");
+	dip_dev->dip_clk.DIP_IMG_DIP = devm_clk_get(&pdev->dev,
+						    "DIP_CG_IMG_DIP");
+	if (IS_ERR(dip_dev->dip_clk.DIP_IMG_LARB5)) {
+		dev_err(&pdev->dev, "cannot get DIP_IMG_LARB5 clock\n");
+		return PTR_ERR(dip_dev->dip_clk.DIP_IMG_LARB5);
+	}
+	if (IS_ERR(dip_dev->dip_clk.DIP_IMG_DIP)) {
+		dev_err(&pdev->dev, "cannot get DIP_IMG_DIP clock\n");
+		return PTR_ERR(dip_dev->dip_clk.DIP_IMG_DIP);
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	atomic_set(&dip_ctx->dip_user_cnt, 0);
+	atomic_set(&dip_ctx->dip_stream_cnt, 0);
+	atomic_set(&dip_ctx->dip_enque_cnt, 0);
+
+	atomic_set(&dip_ctx->num_composing, 0);
+	atomic_set(&dip_ctx->num_running, 0);
+
+	dip_ctx->dip_worklist.queue_cnt = 0;
+
+	ret = mtk_dip_ctx_dip_v4l2_init(pdev,
+					&dip_drv->isp_preview_dev,
+		&dip_drv->isp_capture_dev);
+
+	if (ret)
+		dev_err(&pdev->dev, "v4l2 init failed: %d\n", ret);
+
+	dev_info(&pdev->dev, "X. DIP driver probe.\n");
+
+	return ret;
+}
+
+static int mtk_dip_remove(struct platform_device *pdev)
+{
+	struct mtk_isp_dip_drv_data *drv_data =
+		dev_get_drvdata(&pdev->dev);
+
+	/*  */
+	if (drv_data) {
+		mtk_dip_dev_core_release(pdev, &drv_data->isp_preview_dev);
+		mtk_dip_dev_core_release(pdev, &drv_data->isp_capture_dev);
+		dev_info(&pdev->dev, "E. %s\n", __func__);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+
+	/*  */
+	return 0;
+}
+
+static int __maybe_unused mtk_dip_pm_suspend(struct device *dev)
+{
+	struct dip_device *dip = get_dip_device(dev);
+
+	if (atomic_read(&dip->dip_ctx.dip_user_cnt) > 0) {
+		dip_setclock(dip, false);
+		dev_dbg(&dip->pdev->dev, "Disable clock\n");
+	}
+
+	return 0;
+}
+
+static int __maybe_unused mtk_dip_pm_resume(struct device *dev)
+{
+	struct dip_device *dip = get_dip_device(dev);
+
+	if (atomic_read(&dip->dip_ctx.dip_user_cnt) > 0) {
+		dip_setclock(dip, true);
+		dev_dbg(&dip->pdev->dev, "Enable clock\n");
+	}
+
+	return 0;
+}
+
+static int __maybe_unused mtk_dip_suspend(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return mtk_dip_pm_suspend(dev);
+}
+
+static int __maybe_unused mtk_dip_resume(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return mtk_dip_pm_resume(dev);
+}
+
+static const struct dev_pm_ops mtk_dip_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk_dip_suspend, mtk_dip_resume)
+	SET_RUNTIME_PM_OPS(mtk_dip_suspend, mtk_dip_resume, NULL)
+};
+
+static struct platform_driver mtk_dip_driver = {
+	.probe   = mtk_dip_probe,
+	.remove  = mtk_dip_remove,
+	.driver  = {
+		.name  = DIP_DEV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = dip_of_ids,
+		.pm     = &mtk_dip_pm_ops,
+	}
+};
+
+module_platform_driver(mtk_dip_driver);
+
+MODULE_DESCRIPTION("Camera DIP driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h
new file mode 100644
index 0000000..d785b99
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 MediaTek Inc.
+ * Author: Holmes Chiou <holmes.chiou@mediatek.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_DIP_H
+#define __MTK_DIP_H
+
+#include "mtk-img-ipi.h"
+
+enum frame_state {
+	FRAME_STATE_INIT	= 0,
+	FRAME_STATE_COMPOSING,
+	FRAME_STATE_RUNNING,
+	FRAME_STATE_DONE,
+	FRAME_STATE_STREAMOFF,
+	FRAME_STATE_ERROR,
+	FRAME_STATE_HW_TIMEOUT
+};
+
+/**
+ * mtk_dip_enqueue - enqueue to dip driver
+ *
+ * @pdev:	DIP platform device
+ * @img_ipi_frameparam:	frame parameters
+ *
+ * Enqueue a frame to dip driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int	mtk_dip_enqueue(struct platform_device *pdev,
+			struct img_ipi_frameparam *frameparams);
+
+/**
+ * mtk_dip_open -
+ *
+ * @pdev:	DIP platform device
+ * @img_ipi_frameparam:	frame parameters
+ *
+ * Enqueue a frame to dip driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_dip_open(struct platform_device *pdev);
+
+/**
+ * mtk_dip_release -
+ *
+ * @pdev:	DIP platform device
+ * @img_ipi_frameparam:	frame parameters
+ *
+ * Enqueue a frame to dip driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_dip_release(struct platform_device *pdev);
+
+/**
+ * mtk_dip_streamon -
+ *
+ * @pdev:	DIP platform device
+ * @img_ipi_frameparam:	frame parameters
+ *
+ * Enqueue a frame to dip driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_dip_streamon(struct platform_device *pdev, u16 id);
+
+/**
+ * mtk_dip_streamoff -
+ *
+ * @pdev:	DIP platform device
+ * @img_ipi_frameparam:	frame parameters
+ *
+ * Enqueue a frame to dip driver.
+ *
+ * Return: Return 0 if ipi registers successfully, otherwise it is failed.
+ */
+int mtk_dip_streamoff(struct platform_device *pdev, u16 id);
+
+#endif /* __MTK_DIP_H */
+
-- 
1.9.1

