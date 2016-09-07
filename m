Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36678 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965031AbcIGLpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 07:45:21 -0400
Received: by mail-wm0-f52.google.com with SMTP id b187so111248990wme.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 04:45:20 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 5/8] media: vidc: add Host Firmware Interface (HFI)
Date: Wed,  7 Sep 2016 14:37:06 +0300
Message-Id: <1473248229-5540-6-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the implementation of HFI. It is loaded with the
responsibility to comunicate with the firmware through an
interface commands and messages.

 - hfi.c has interface functions used by the core, decoder
and encoder parts to comunicate with the firmware. For example
there are functions for session and core initialisation.

 - hfi_cmds has packetization operations which preparing
packets to be send from host to firmware.

 - hfi_msgs takes care of messages sent from firmware to the
host.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/vidc/hfi.c        |  617 ++++++++++++
 drivers/media/platform/qcom/vidc/hfi.h        |  272 ++++++
 drivers/media/platform/qcom/vidc/hfi_cmds.c   | 1261 +++++++++++++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_cmds.h   |  338 +++++++
 drivers/media/platform/qcom/vidc/hfi_helper.h | 1143 ++++++++++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_msgs.c   | 1072 +++++++++++++++++++++
 drivers/media/platform/qcom/vidc/hfi_msgs.h   |  298 ++++++
 7 files changed, 5001 insertions(+)
 create mode 100644 drivers/media/platform/qcom/vidc/hfi.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_cmds.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_helper.h
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.c
 create mode 100644 drivers/media/platform/qcom/vidc/hfi_msgs.h

diff --git a/drivers/media/platform/qcom/vidc/hfi.c b/drivers/media/platform/qcom/vidc/hfi.c
new file mode 100644
index 000000000000..f5ae53b0e3f2
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi.c
@@ -0,0 +1,617 @@
+/*
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/completion.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+
+#include "core.h"
+#include "hfi.h"
+#include "hfi_cmds.h"
+#include "hfi_venus.h"
+
+#define TIMEOUT		msecs_to_jiffies(1000)
+
+static u32 to_codec_type(u32 pixfmt)
+{
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_H264_NO_SC:
+		return HFI_VIDEO_CODEC_H264;
+	case V4L2_PIX_FMT_H263:
+		return HFI_VIDEO_CODEC_H263;
+	case V4L2_PIX_FMT_MPEG1:
+		return HFI_VIDEO_CODEC_MPEG1;
+	case V4L2_PIX_FMT_MPEG2:
+		return HFI_VIDEO_CODEC_MPEG2;
+	case V4L2_PIX_FMT_MPEG4:
+		return HFI_VIDEO_CODEC_MPEG4;
+	case V4L2_PIX_FMT_VC1_ANNEX_G:
+	case V4L2_PIX_FMT_VC1_ANNEX_L:
+		return HFI_VIDEO_CODEC_VC1;
+	case V4L2_PIX_FMT_VP8:
+		return HFI_VIDEO_CODEC_VP8;
+	case V4L2_PIX_FMT_XVID:
+		return HFI_VIDEO_CODEC_DIVX;
+	default:
+		return 0;
+	}
+}
+
+int vidc_hfi_core_init(struct hfi_core *hfi)
+{
+	int ret = 0;
+
+	mutex_lock(&hfi->lock);
+
+	if (hfi->state >= CORE_INIT)
+		goto unlock;
+
+	init_completion(&hfi->done);
+
+	ret = call_hfi_op(hfi, core_init, hfi);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&hfi->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+
+	if (hfi->error != HFI_ERR_NONE) {
+		ret = -EIO;
+		goto unlock;
+	}
+
+	hfi->state = CORE_INIT;
+unlock:
+	mutex_unlock(&hfi->lock);
+	return ret;
+}
+
+int vidc_hfi_core_deinit(struct hfi_core *hfi)
+{
+	struct device *dev = hfi->dev;
+	int ret = 0;
+
+	mutex_lock(&hfi->lock);
+
+	if (hfi->state == CORE_UNINIT)
+		goto unlock;
+
+	if (!list_empty(&hfi->instances)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = call_hfi_op(hfi, core_deinit, hfi);
+	if (ret)
+		dev_err(dev, "core deinit failed: %d\n", ret);
+
+	hfi->state = CORE_UNINIT;
+
+unlock:
+	mutex_unlock(&hfi->lock);
+	return ret;
+}
+
+int vidc_hfi_core_suspend(struct hfi_core *hfi)
+{
+	return call_hfi_op(hfi, suspend, hfi);
+}
+
+int vidc_hfi_core_resume(struct hfi_core *hfi)
+{
+	return call_hfi_op(hfi, resume, hfi);
+}
+
+int vidc_hfi_core_trigger_ssr(struct hfi_core *hfi, u32 type)
+{
+	int ret;
+
+	ret = call_hfi_op(hfi, core_trigger_ssr, hfi, type);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int vidc_hfi_core_ping(struct hfi_core *hfi)
+{
+	int ret;
+
+	mutex_lock(&hfi->lock);
+
+	ret = call_hfi_op(hfi, core_ping, hfi, 0xbeef);
+	if (ret)
+		return ret;
+
+	ret = wait_for_completion_timeout(&hfi->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+	ret = 0;
+	if (hfi->error != HFI_ERR_NONE)
+		ret = -ENODEV;
+unlock:
+	mutex_unlock(&hfi->lock);
+	return ret;
+}
+
+struct hfi_inst *
+vidc_hfi_session_create(struct hfi_core *hfi, const struct hfi_inst_ops *ops,
+			void *ops_priv)
+{
+	struct hfi_inst *inst;
+
+	if (!ops)
+		return ERR_PTR(-EINVAL);
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&inst->lock);
+	INIT_LIST_HEAD(&inst->list);
+	inst->state = INST_UNINIT;
+	inst->ops = ops;
+	inst->ops_priv = ops_priv;
+
+	mutex_lock(&hfi->lock);
+	list_add_tail(&inst->list, &hfi->instances);
+	mutex_unlock(&hfi->lock);
+
+	return inst;
+}
+
+int vidc_hfi_session_init(struct hfi_core *hfi, struct hfi_inst *inst,
+			  u32 pixfmt, u32 session_type)
+{
+	u32 codec;
+	int ret;
+
+	if (!hfi || !inst)
+		return -EINVAL;
+
+	codec = to_codec_type(pixfmt);
+	inst->session_type = session_type;
+	init_completion(&inst->done);
+
+	mutex_lock(&inst->lock);
+
+	ret = call_hfi_op(hfi, session_init, hfi, inst, session_type, codec);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	if (inst->error != HFI_ERR_NONE) {
+		dev_err(hfi->dev, "%s: session init failed (%x)\n", __func__,
+			inst->error);
+		ret = -EIO;
+		goto unlock;
+	}
+
+	ret = 0;
+	inst->state = INST_INIT;
+
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+void vidc_hfi_session_destroy(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	mutex_lock(&hfi->lock);
+	list_del(&inst->list);
+	mutex_unlock(&hfi->lock);
+
+	if (mutex_is_locked(&inst->lock))
+		WARN(1, "session destroy");
+
+	mutex_destroy(&inst->lock);
+	kfree(inst);
+}
+
+int vidc_hfi_session_deinit(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state == INST_UNINIT) {
+		ret = 0;
+		goto unlock;
+	}
+
+	if (inst->state < INST_INIT) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_end, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	if (inst->error != HFI_ERR_NONE) {
+		dev_err(hfi->dev, "session deinit error (%x)\n", inst->error);
+		ret = -EIO;
+		goto unlock;
+	}
+
+	ret = 0;
+	inst->state = INST_UNINIT;
+
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_start(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state != INST_LOAD_RESOURCES) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_start, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+
+	inst->state = INST_START;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_stop(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state != INST_START) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_stop, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+
+	inst->state = INST_STOP;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_abort(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_abort, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_load_res(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state != INST_INIT) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_load_res, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+	inst->state = INST_LOAD_RESOURCES;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_unload_res(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state != INST_STOP) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_release_res, inst);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+	inst->state = INST_RELEASE_RESOURCES;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_flush(struct hfi_core *hfi, struct hfi_inst *inst)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_flush, inst, HFI_FLUSH_ALL);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_set_buffers(struct hfi_core *hfi, struct hfi_inst *inst,
+				 struct hfi_buffer_desc *bd)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+	ret = call_hfi_op(hfi, session_set_buffers, inst, bd);
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_unset_buffers(struct hfi_core *hfi, struct hfi_inst *inst,
+				   struct hfi_buffer_desc *bd)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_release_buffers, inst, bd);
+	if (ret)
+		goto unlock;
+
+	if (!bd->response_required) {
+		ret = 0;
+		goto unlock;
+	}
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	ret = 0;
+
+	if (inst->error != HFI_ERR_NONE) {
+		dev_dbg(hfi->dev, "unset buffers error (%x)\n", inst->error);
+		ret = -EIO;
+	}
+
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_get_property(struct hfi_core *hfi, struct hfi_inst *inst,
+				  u32 ptype, union hfi_get_property *hprop)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state < INST_INIT || inst->state >= INST_STOP) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	init_completion(&inst->done);
+
+	ret = call_hfi_op(hfi, session_get_property, inst, ptype);
+	if (ret)
+		goto unlock;
+
+	ret = wait_for_completion_timeout(&inst->done, TIMEOUT);
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		goto unlock;
+	}
+
+	if (inst->error != HFI_ERR_NONE) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = 0;
+	*hprop = inst->hprop;
+unlock:
+	mutex_unlock(&inst->lock);
+
+	return ret;
+}
+
+int vidc_hfi_session_set_property(struct hfi_core *hfi, struct hfi_inst *inst,
+				  u32 ptype, void *pdata)
+{
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->state < INST_INIT || inst->state >= INST_STOP) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = call_hfi_op(hfi, session_set_property, inst, ptype, pdata);
+unlock:
+	mutex_unlock(&inst->lock);
+
+	if (ret)
+		dev_err(hfi->dev, "set property %x failed (%d)\n", ptype, ret);
+
+	return ret;
+}
+
+int vidc_hfi_session_etb(struct hfi_core *hfi, struct hfi_inst *inst,
+			 struct hfi_frame_data *fdata)
+{
+	return call_hfi_op(hfi, session_etb, inst, fdata);
+}
+
+int vidc_hfi_session_ftb(struct hfi_core *hfi, struct hfi_inst *inst,
+			 struct hfi_frame_data *fdata)
+{
+	return call_hfi_op(hfi, session_ftb, inst, fdata);
+}
+
+irqreturn_t vidc_hfi_isr_thread(int irq, void *dev_id)
+{
+	struct hfi_core *hfi = dev_id;
+
+	return call_hfi_op(hfi, isr_thread, irq, hfi);
+}
+
+irqreturn_t vidc_hfi_isr(int irq, void *dev)
+{
+	struct hfi_core *hfi = dev;
+
+	return call_hfi_op(hfi, isr, irq, hfi);
+}
+
+int vidc_hfi_create(struct hfi_core *hfi, const struct vidc_resources *res,
+		    void __iomem *base)
+{
+	if (!hfi->core_ops || !hfi->dev)
+		return -EINVAL;
+
+	if (res->hfi_version)
+		hfi->packetization_type = HFI_PACKETIZATION_3XX;
+	else
+		hfi->packetization_type = HFI_PACKETIZATION_LEGACY;
+	mutex_init(&hfi->lock);
+	INIT_LIST_HEAD(&hfi->instances);
+	hfi->state = CORE_UNINIT;
+
+	hfi->pkt_ops = hfi_get_pkt_ops(hfi->packetization_type);
+	if (!hfi->pkt_ops)
+		return -EINVAL;
+
+	return venus_hfi_create(hfi, res, base);
+}
+
+void vidc_hfi_destroy(struct hfi_core *hfi)
+{
+	venus_hfi_destroy(hfi);
+	mutex_destroy(&hfi->lock);
+}
diff --git a/drivers/media/platform/qcom/vidc/hfi.h b/drivers/media/platform/qcom/vidc/hfi.h
new file mode 100644
index 000000000000..84e32ee922b6
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi.h
@@ -0,0 +1,272 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __HFI_H__
+#define __HFI_H__
+
+#include <linux/interrupt.h>
+
+#include "hfi_helper.h"
+
+#define VIDC_SESSION_TYPE_VPE			0
+#define VIDC_SESSION_TYPE_ENC			1
+#define VIDC_SESSION_TYPE_DEC			2
+
+/* core capabilities */
+#define VIDC_ENC_ROTATION_CAPABILITY		0x1
+#define VIDC_ENC_SCALING_CAPABILITY		0x2
+#define VIDC_ENC_DEINTERLACE_CAPABILITY		0x4
+#define VIDC_DEC_MULTI_STREAM_CAPABILITY	0x8
+
+#define VIDC_RESOURCE_NONE			0
+#define VIDC_RESOURCE_OCMEM			1
+#define VIDC_RESOURCE_VMEM			2
+
+struct hfi_buffer_desc {
+	u32 buffer_type;
+	u32 buffer_size;
+	u32 num_buffers;
+	u32 device_addr;
+	u32 extradata_addr;
+	u32 extradata_size;
+	u32 response_required;
+};
+
+struct hfi_frame_data {
+	u32 buffer_type;
+	u32 device_addr;
+	u32 extradata_addr;
+	u64 timestamp;
+	u32 flags;
+	u32 offset;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 mark_target;
+	u32 mark_data;
+	u32 clnt_data;
+	u32 extradata_size;
+};
+
+union hfi_get_property {
+	struct hfi_profile_level profile_level;
+	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
+};
+
+/* HFI events */
+#define EVT_SYS_EVENT_CHANGE			1
+#define EVT_SYS_WATCHDOG_TIMEOUT		2
+#define EVT_SYS_ERROR				3
+#define EVT_SESSION_ERROR			4
+
+/* HFI event callback structure */
+struct hfi_event_data {
+	u32 error;
+	u32 height;
+	u32 width;
+	u32 event_type;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 profile;
+	u32 level;
+};
+
+/* define core states */
+#define CORE_UNINIT				0
+#define CORE_INIT				1
+#define CORE_INVALID				2
+
+/* define instance states */
+#define INST_INVALID				1
+#define INST_UNINIT				2
+#define INST_INIT				3
+#define INST_LOAD_RESOURCES			4
+#define INST_START				5
+#define INST_STOP				6
+#define INST_RELEASE_RESOURCES			7
+
+#define call_hfi_op(hfi, op, args...)	\
+	(((hfi) && (hfi)->ops && (hfi)->ops->op) ?	\
+	((hfi)->ops->op(args)) : 0)
+
+struct hfi_core;
+struct hfi_inst;
+struct vidc_resources;
+
+struct hfi_core_ops {
+	int (*event_notify)(struct hfi_core *hfi, u32 event);
+};
+
+struct hfi_inst_ops {
+	int (*empty_buf_done)(struct hfi_inst *inst, u32 addr, u32 bytesused,
+			      u32 data_offset, u32 flags);
+	int (*fill_buf_done)(struct hfi_inst *inst, u32 addr, u32 bytesused,
+			     u32 data_offset, u32 flags, struct timeval *ts);
+	int (*event_notify)(struct hfi_inst *inst, u32 event,
+			    struct hfi_event_data *data);
+};
+
+struct hfi_inst {
+	struct list_head list;
+	struct mutex lock;
+	unsigned int state;
+	struct completion done;
+	unsigned int error;
+
+	/* instance operations passed by outside world */
+	const struct hfi_inst_ops *ops;
+	void *ops_priv;
+
+	void *priv;
+
+	u32 session_type;
+	union hfi_get_property hprop;
+
+	/* capabilities filled by session_init */
+	struct hfi_capability width;
+	struct hfi_capability height;
+	struct hfi_capability mbs_per_frame;
+	struct hfi_capability mbs_per_sec;
+	struct hfi_capability framerate;
+	struct hfi_capability scale_x;
+	struct hfi_capability scale_y;
+	struct hfi_capability bitrate;
+	struct hfi_capability hier_p;
+	struct hfi_capability ltr_count;
+	struct hfi_capability secure_output2_threshold;
+	bool alloc_mode_static;
+	bool alloc_mode_dynamic;
+
+	/* profile & level pairs supported */
+	unsigned int pl_count;
+	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
+
+	/* buffer requirements */
+	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
+};
+
+struct hfi_core {
+	struct device *dev;	/* mostly used for dev_xxx */
+
+	struct mutex lock;
+	unsigned int state;
+	struct completion done;
+	unsigned int error;
+
+	/*
+	 * list of 'struct hfi_inst' instances which belong to
+	 * this hfi core device
+	 */
+	struct list_head instances;
+
+	/* core operations passed by outside world */
+	const struct hfi_core_ops *core_ops;
+
+	/* filled by sys core init */
+	u32 enc_codecs;
+	u32 dec_codecs;
+
+	/* core capabilities */
+	unsigned int core_caps;
+
+	/* internal hfi operations */
+	void *priv;
+	const struct hfi_ops *ops;
+	const struct hfi_packetization_ops *pkt_ops;
+	enum hfi_packetization_type packetization_type;
+};
+
+struct hfi_ops {
+	int (*core_init)(struct hfi_core *hfi);
+	int (*core_deinit)(struct hfi_core *hfi);
+	int (*core_ping)(struct hfi_core *hfi, u32 cookie);
+	int (*core_trigger_ssr)(struct hfi_core *hfi, u32 trigger_type);
+
+	int (*session_init)(struct hfi_core *hfi, struct hfi_inst *inst,
+			    u32 session_type, u32 codec);
+	int (*session_end)(struct hfi_inst *inst);
+	int (*session_abort)(struct hfi_inst *inst);
+	int (*session_flush)(struct hfi_inst *inst, u32 flush_mode);
+	int (*session_start)(struct hfi_inst *inst);
+	int (*session_stop)(struct hfi_inst *inst);
+	int (*session_etb)(struct hfi_inst *inst,
+			   struct hfi_frame_data *input_frame);
+	int (*session_ftb)(struct hfi_inst *inst,
+			   struct hfi_frame_data *output_frame);
+	int (*session_set_buffers)(struct hfi_inst *inst,
+				   struct hfi_buffer_desc *bd);
+	int (*session_release_buffers)(struct hfi_inst *inst,
+				       struct hfi_buffer_desc *bd);
+	int (*session_load_res)(struct hfi_inst *inst);
+	int (*session_release_res)(struct hfi_inst *inst);
+	int (*session_parse_seq_hdr)(struct hfi_inst *inst, u32 seq_hdr,
+				     u32 seq_hdr_len);
+	int (*session_get_seq_hdr)(struct hfi_inst *inst, u32 seq_hdr,
+				   u32 seq_hdr_len);
+	int (*session_set_property)(struct hfi_inst *inst, u32 ptype,
+				    void *pdata);
+	int (*session_get_property)(struct hfi_inst *inst, u32 ptype);
+
+	int (*resume)(struct hfi_core *hfi);
+	int (*suspend)(struct hfi_core *hfi);
+
+	/* interrupt operations */
+	irqreturn_t (*isr)(int irq, struct hfi_core *hfi);
+	irqreturn_t (*isr_thread)(int irq, struct hfi_core *hfi);
+};
+
+static inline void *to_hfi_priv(struct hfi_core *hfi)
+{
+	return hfi->priv;
+}
+
+int vidc_hfi_create(struct hfi_core *hfi, const struct vidc_resources *res,
+		    void __iomem *base);
+void vidc_hfi_destroy(struct hfi_core *hfi);
+
+int vidc_hfi_core_init(struct hfi_core *hfi);
+int vidc_hfi_core_deinit(struct hfi_core *hfi);
+int vidc_hfi_core_suspend(struct hfi_core *hfi);
+int vidc_hfi_core_resume(struct hfi_core *hfi);
+int vidc_hfi_core_trigger_ssr(struct hfi_core *hfi, u32 type);
+int vidc_hfi_core_ping(struct hfi_core *hfi);
+
+struct hfi_inst *vidc_hfi_session_create(struct hfi_core *hfi,
+					 const struct hfi_inst_ops *ops,
+					 void *ops_priv);
+void vidc_hfi_session_destroy(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_init(struct hfi_core *hfi, struct hfi_inst *inst,
+			  u32 pixfmt, u32 session_type);
+int vidc_hfi_session_deinit(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_start(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_stop(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_abort(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_load_res(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_unload_res(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_flush(struct hfi_core *hfi, struct hfi_inst *inst);
+int vidc_hfi_session_set_buffers(struct hfi_core *hfi, struct hfi_inst *inst,
+				 struct hfi_buffer_desc *bd);
+int vidc_hfi_session_unset_buffers(struct hfi_core *hfi, struct hfi_inst *inst,
+				   struct hfi_buffer_desc *bd);
+int vidc_hfi_session_get_property(struct hfi_core *hfi, struct hfi_inst *inst,
+				  u32 ptype, union hfi_get_property *hprop);
+int vidc_hfi_session_set_property(struct hfi_core *hfi, struct hfi_inst *inst,
+				  u32 ptype, void *pdata);
+int vidc_hfi_session_etb(struct hfi_core *hfi, struct hfi_inst *inst,
+			 struct hfi_frame_data *fdata);
+int vidc_hfi_session_ftb(struct hfi_core *hfi, struct hfi_inst *inst,
+			 struct hfi_frame_data *fdata);
+irqreturn_t vidc_hfi_isr_thread(int irq, void *dev_id);
+irqreturn_t vidc_hfi_isr(int irq, void *dev);
+
+#endif
diff --git a/drivers/media/platform/qcom/vidc/hfi_cmds.c b/drivers/media/platform/qcom/vidc/hfi_cmds.c
new file mode 100644
index 000000000000..552d8c558a80
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi_cmds.c
@@ -0,0 +1,1261 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/errno.h>
+#include <linux/log2.h>
+#include <linux/hash.h>
+
+#include "hfi_cmds.h"
+
+static void pkt_sys_init(struct hfi_sys_init_pkt *pkt, u32 arch_type)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_INIT;
+	pkt->arch_type = arch_type;
+}
+
+static void pkt_sys_pc_prep(struct hfi_sys_pc_prep_pkt *pkt)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_PC_PREP;
+}
+
+static void pkt_sys_idle_indicator(struct hfi_sys_set_property_pkt *pkt,
+				   u32 enable)
+{
+	struct hfi_enable *hfi = (struct hfi_enable *) &pkt->data[1];
+
+	pkt->hdr.size = sizeof(*pkt) + sizeof(*hfi) + sizeof(u32);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_SET_PROPERTY;
+	pkt->num_properties = 1;
+	pkt->data[0] = HFI_PROPERTY_SYS_IDLE_INDICATOR;
+	hfi->enable = enable;
+}
+
+static void pkt_sys_debug_config(struct hfi_sys_set_property_pkt *pkt, u32 mode,
+				 u32 config)
+{
+	struct hfi_debug_config *hfi;
+
+	pkt->hdr.size = sizeof(*pkt) + sizeof(*hfi) + sizeof(u32);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_SET_PROPERTY;
+	pkt->num_properties = 1;
+	pkt->data[0] = HFI_PROPERTY_SYS_DEBUG_CONFIG;
+	hfi = (struct hfi_debug_config *) &pkt->data[1];
+	hfi->config = config;
+	hfi->mode = mode;
+}
+
+static void pkt_sys_coverage_config(struct hfi_sys_set_property_pkt *pkt,
+				    u32 mode)
+{
+	pkt->hdr.size = sizeof(*pkt) + sizeof(u32);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_SET_PROPERTY;
+	pkt->num_properties = 1;
+	pkt->data[0] = HFI_PROPERTY_SYS_CONFIG_COVERAGE;
+	pkt->data[1] = mode;
+}
+
+static int pkt_sys_set_resource(struct hfi_sys_set_resource_pkt *pkt,
+				u32 id, u32 size, u32 addr, void *cookie)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_SET_RESOURCE;
+	pkt->resource_handle = hash32_ptr(cookie);
+
+	switch (id) {
+	case VIDC_RESOURCE_OCMEM:
+	case VIDC_RESOURCE_VMEM: {
+		struct hfi_resource_ocmem *res =
+			(struct hfi_resource_ocmem *) &pkt->resource_data[0];
+
+		res->size = size;
+		res->mem = addr;
+		pkt->resource_type = HFI_RESOURCE_OCMEM;
+		pkt->hdr.size += sizeof(*res) - sizeof(u32);
+		break;
+	}
+	case VIDC_RESOURCE_NONE:
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static int pkt_sys_unset_resource(struct hfi_sys_release_resource_pkt *pkt,
+				  u32 id, u32 size, void *cookie)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_RELEASE_RESOURCE;
+	pkt->resource_handle = hash32_ptr(cookie);
+
+	switch (id) {
+	case VIDC_RESOURCE_OCMEM:
+	case VIDC_RESOURCE_VMEM:
+		pkt->resource_type = HFI_RESOURCE_OCMEM;
+		break;
+	case VIDC_RESOURCE_NONE:
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static void pkt_sys_ping(struct hfi_sys_ping_pkt *pkt, u32 cookie)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_PING;
+	pkt->client_data = cookie;
+}
+
+static int pkt_session_init(struct hfi_session_init_pkt *pkt,
+			    struct hfi_inst *inst, u32 session_type, u32 codec)
+{
+	if (!pkt || !inst || !codec)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SYS_SESSION_INIT;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->session_domain = session_type;
+	pkt->session_codec = codec;
+
+	return 0;
+}
+
+static void pkt_session_cmd(struct hfi_session_pkt *pkt, u32 pkt_type,
+			    struct hfi_inst *inst)
+{
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = pkt_type;
+	pkt->shdr.session_id = hash32_ptr(inst);
+}
+
+static void pkt_sys_power_control(struct hfi_sys_set_property_pkt *pkt,
+				  u32 enable)
+{
+	struct hfi_enable *hfi = (struct hfi_enable *) &pkt->data[1];
+
+	pkt->hdr.size = sizeof(*pkt) + sizeof(*hfi) + sizeof(u32);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_SET_PROPERTY;
+	pkt->num_properties = 1;
+	pkt->data[0] = HFI_PROPERTY_SYS_CODEC_POWER_PLANE_CTRL;
+	hfi->enable = enable;
+}
+
+static int pkt_session_set_buffers(struct hfi_session_set_buffers_pkt *pkt,
+				   struct hfi_inst *inst,
+				   struct hfi_buffer_desc *bd)
+{
+	int i;
+
+	if (!inst || !pkt || !bd)
+		return -EINVAL;
+
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_BUFFERS;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->buffer_size = bd->buffer_size;
+	pkt->min_buffer_size = bd->buffer_size;
+	pkt->num_buffers = bd->num_buffers;
+
+	if (bd->buffer_type == HFI_BUFFER_OUTPUT ||
+	    bd->buffer_type == HFI_BUFFER_OUTPUT2) {
+		struct hfi_buffer_info *bi;
+
+		pkt->extradata_size = bd->extradata_size;
+		pkt->shdr.hdr.size = sizeof(*pkt) - sizeof(u32) +
+			(bd->num_buffers * sizeof(*bi));
+		bi = (struct hfi_buffer_info *) pkt->buffer_info;
+		for (i = 0; i < pkt->num_buffers; i++) {
+			bi->buffer_addr = bd->device_addr;
+			bi->extradata_addr = bd->extradata_addr;
+		}
+	} else {
+		pkt->extradata_size = 0;
+		pkt->shdr.hdr.size = sizeof(*pkt) +
+			((bd->num_buffers - 1) * sizeof(u32));
+		for (i = 0; i < pkt->num_buffers; i++)
+			pkt->buffer_info[i] = bd->device_addr;
+	}
+
+	pkt->buffer_type = bd->buffer_type;
+
+	return 0;
+}
+
+static int
+pkt_session_release_buffers(struct hfi_session_release_buffer_pkt *pkt,
+			    struct hfi_inst *inst, struct hfi_buffer_desc *bd)
+{
+	int i;
+
+	if (!inst || !pkt || !bd)
+		return -EINVAL;
+
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_RELEASE_BUFFERS;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->buffer_size = bd->buffer_size;
+	pkt->num_buffers = bd->num_buffers;
+
+	if (bd->buffer_type == HFI_BUFFER_OUTPUT ||
+	    bd->buffer_type == HFI_BUFFER_OUTPUT2) {
+		struct hfi_buffer_info *bi;
+
+		bi = (struct hfi_buffer_info *) pkt->buffer_info;
+		for (i = 0; i < pkt->num_buffers; i++) {
+			bi->buffer_addr = bd->device_addr;
+			bi->extradata_addr = bd->extradata_addr;
+		}
+		pkt->shdr.hdr.size =
+				sizeof(struct hfi_session_set_buffers_pkt) -
+				sizeof(u32) + (bd->num_buffers * sizeof(*bi));
+	} else {
+		for (i = 0; i < pkt->num_buffers; i++)
+			pkt->buffer_info[i] = bd->device_addr;
+
+		pkt->extradata_size = 0;
+		pkt->shdr.hdr.size =
+				sizeof(struct hfi_session_set_buffers_pkt) +
+				((bd->num_buffers - 1) * sizeof(u32));
+	}
+
+	pkt->response_req = bd->response_required;
+	pkt->buffer_type = bd->buffer_type;
+
+	return 0;
+}
+
+static int
+pkt_session_etb_decoder(struct hfi_session_empty_buffer_compressed_pkt *pkt,
+			struct hfi_inst *inst, struct hfi_frame_data *in_frame)
+{
+	if (!inst || !in_frame->device_addr)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_EMPTY_BUFFER;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->time_stamp_hi = upper_32_bits(in_frame->timestamp);
+	pkt->time_stamp_lo = lower_32_bits(in_frame->timestamp);
+	pkt->flags = in_frame->flags;
+	pkt->mark_target = in_frame->mark_target;
+	pkt->mark_data = in_frame->mark_data;
+	pkt->offset = in_frame->offset;
+	pkt->alloc_len = in_frame->alloc_len;
+	pkt->filled_len = in_frame->filled_len;
+	pkt->input_tag = in_frame->clnt_data;
+	pkt->packet_buffer = in_frame->device_addr;
+
+	return 0;
+}
+
+static int pkt_session_etb_encoder(
+		struct hfi_session_empty_buffer_uncompressed_plane0_pkt *pkt,
+		struct hfi_inst *inst, struct hfi_frame_data *in_frame)
+{
+	if (!inst || !in_frame->device_addr)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_EMPTY_BUFFER;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->view_id = 0;
+	pkt->time_stamp_hi = upper_32_bits(in_frame->timestamp);
+	pkt->time_stamp_lo = lower_32_bits(in_frame->timestamp);
+	pkt->flags = in_frame->flags;
+	pkt->mark_target = in_frame->mark_target;
+	pkt->mark_data = in_frame->mark_data;
+	pkt->offset = in_frame->offset;
+	pkt->alloc_len = in_frame->alloc_len;
+	pkt->filled_len = in_frame->filled_len;
+	pkt->input_tag = in_frame->clnt_data;
+	pkt->packet_buffer = in_frame->device_addr;
+	pkt->extradata_buffer = in_frame->extradata_addr;
+
+	return 0;
+}
+
+static int pkt_session_ftb(struct hfi_session_fill_buffer_pkt *pkt,
+			   struct hfi_inst *inst,
+			   struct hfi_frame_data *out_frame)
+{
+	if (!inst || !out_frame || !out_frame->device_addr)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_FILL_BUFFER;
+	pkt->shdr.session_id = hash32_ptr(inst);
+
+	if (out_frame->buffer_type == HFI_BUFFER_OUTPUT)
+		pkt->stream_id = 0;
+	else if (out_frame->buffer_type == HFI_BUFFER_OUTPUT2)
+		pkt->stream_id = 1;
+
+	pkt->packet_buffer = out_frame->device_addr;
+	pkt->extradata_buffer = out_frame->extradata_addr;
+	pkt->alloc_len = out_frame->alloc_len;
+	pkt->filled_len = out_frame->filled_len;
+	pkt->offset = out_frame->offset;
+	pkt->data[0] = out_frame->extradata_size;
+
+	return 0;
+}
+
+static int pkt_session_parse_seq_header(
+		struct hfi_session_parse_sequence_header_pkt *pkt,
+		struct hfi_inst *inst, u32 seq_hdr, u32 seq_hdr_len)
+{
+	if (!inst || !seq_hdr || !seq_hdr_len)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_PARSE_SEQUENCE_HEADER;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->header_len = seq_hdr_len;
+	pkt->packet_buffer = seq_hdr;
+
+	return 0;
+}
+
+static int
+pkt_session_get_seq_hdr(struct hfi_session_get_sequence_header_pkt *pkt,
+			struct hfi_inst *inst, u32 seq_hdr, u32 seq_hdr_len)
+{
+	if (!inst || !seq_hdr || !seq_hdr_len)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_GET_SEQUENCE_HEADER;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->buffer_len = seq_hdr_len;
+	pkt->packet_buffer = seq_hdr;
+
+	return 0;
+}
+
+static int pkt_session_flush(struct hfi_session_flush_pkt *pkt,
+			     struct hfi_inst *inst, u32 type)
+{
+	switch (type) {
+	case HFI_FLUSH_INPUT:
+	case HFI_FLUSH_OUTPUT:
+	case HFI_FLUSH_OUTPUT2:
+	case HFI_FLUSH_ALL:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->flush_type = type;
+
+	return 0;
+}
+
+static int pkt_session_get_property(struct hfi_session_get_property_pkt *pkt,
+				    struct hfi_inst *inst, u32 ptype)
+{
+	switch (ptype) {
+	case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:
+	case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_GET_PROPERTY;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->num_properties = 1;
+	pkt->data[0] = ptype;
+
+	return 0;
+}
+
+static int pkt_session_set_property(struct hfi_session_set_property_pkt *pkt,
+				    struct hfi_inst *inst, u32 ptype,
+				    void *pdata)
+{
+	void *prop_data = &pkt->data[1];
+	int ret = 0;
+
+	if (!pkt || !inst || !pdata)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->num_properties = 1;
+
+	switch (ptype) {
+	case HFI_PROPERTY_CONFIG_FRAME_RATE: {
+		struct hfi_framerate *in = pdata, *frate = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_FRAME_RATE;
+		frate->buffer_type = in->buffer_type;
+		frate->framerate = in->framerate;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*frate);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT: {
+		struct hfi_uncompressed_format_select *in = pdata;
+		struct hfi_uncompressed_format_select *hfi = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
+		hfi->buffer_type = in->buffer_type;
+		hfi->format = in->format;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hfi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_FRAME_SIZE: {
+		struct hfi_framesize *in = pdata, *fsize = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_FRAME_SIZE;
+		fsize->buffer_type = in->buffer_type;
+		fsize->height = in->height;
+		fsize->width = in->width;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*fsize);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_REALTIME: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_REALTIME;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL: {
+		struct hfi_buffer_count_actual *in = pdata, *count = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
+		count->count_actual = in->count_actual;
+		count->type = in->type;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL: {
+		struct hfi_buffer_size_actual *in = pdata, *sz = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;
+		sz->size = in->size;
+		sz->type = in->type;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*sz);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL: {
+		struct hfi_buffer_display_hold_count_actual *in = pdata;
+		struct hfi_buffer_display_hold_count_actual *count = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL;
+		count->hold_count = in->hold_count;
+		count->type = in->type;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT: {
+		struct hfi_nal_stream_format_select *in = pdata;
+		struct hfi_nal_stream_format_select *fmt = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT;
+		fmt->format = in->format;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*fmt);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_OUTPUT_ORDER: {
+		u32 *in = pdata;
+
+		switch (*in) {
+		case HFI_OUTPUT_ORDER_DECODE:
+		case HFI_OUTPUT_ORDER_DISPLAY:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_OUTPUT_ORDER;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE: {
+		struct hfi_enable_picture *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE;
+		en->picture_type = in->picture_type;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER: {
+		struct hfi_enable *in = pdata;
+		struct hfi_enable *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM: {
+		struct hfi_multi_stream *in = pdata, *multi = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM;
+		multi->buffer_type = in->buffer_type;
+		multi->enable = in->enable;
+		multi->width = in->width;
+		multi->height = in->height;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*multi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT: {
+		struct hfi_display_picture_buffer_count *in = pdata;
+		struct hfi_display_picture_buffer_count *count = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT;
+		count->count = in->count;
+		count->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*count);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_DIVX_FORMAT: {
+		u32 *in = pdata;
+
+		switch (*in) {
+		case HFI_DIVX_FORMAT_4:
+		case HFI_DIVX_FORMAT_5:
+		case HFI_DIVX_FORMAT_6:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_DIVX_FORMAT;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME:
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
+		pkt->shdr.hdr.size += sizeof(u32);
+		break;
+	case HFI_PROPERTY_PARAM_VENC_MPEG4_SHORT_HEADER:
+		break;
+	case HFI_PROPERTY_PARAM_VENC_MPEG4_AC_PREDICTION:
+		break;
+	case HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE: {
+		struct hfi_bitrate *in = pdata, *brate = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
+		brate->bitrate = in->bitrate;
+		brate->layer_id = in->layer_id;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*brate);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE: {
+		struct hfi_bitrate *in = pdata, *hfi = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
+		hfi->bitrate = in->bitrate;
+		hfi->layer_id = in->layer_id;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hfi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT: {
+		struct hfi_profile_level *in = pdata, *pl = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
+		pl->level = in->level;
+		pl->profile = in->profile;
+		if (pl->profile <= 0)
+			/* Profile not supported, falling back to high */
+			pl->profile = HFI_H264_PROFILE_HIGH;
+
+		if (!pl->level)
+			/* Level not supported, falling back to 1 */
+			pl->level = 1;
+
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*pl);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL: {
+		struct hfi_h264_entropy_control *in = pdata, *hfi = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL;
+		hfi->entropy_mode = in->entropy_mode;
+		if (hfi->entropy_mode == HFI_H264_ENTROPY_CABAC)
+			hfi->cabac_model = in->cabac_model;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hfi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_RATE_CONTROL: {
+		u32 *in = pdata;
+
+		switch (*in) {
+		case HFI_RATE_CONTROL_OFF:
+		case HFI_RATE_CONTROL_CBR_CFR:
+		case HFI_RATE_CONTROL_CBR_VFR:
+		case HFI_RATE_CONTROL_VBR_CFR:
+		case HFI_RATE_CONTROL_VBR_VFR:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_RATE_CONTROL;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION: {
+		struct hfi_mpeg4_time_resolution *in = pdata, *res = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION;
+		res->time_increment_resolution = in->time_increment_resolution;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*res);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION: {
+		struct hfi_mpeg4_header_extension *in = pdata, *ext = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION;
+		ext->header_extension = in->header_extension;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ext);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL: {
+		struct hfi_h264_db_control *in = pdata, *db = prop_data;
+
+		switch (in->mode) {
+		case HFI_H264_DB_MODE_DISABLE:
+		case HFI_H264_DB_MODE_SKIP_SLICE_BOUNDARY:
+		case HFI_H264_DB_MODE_ALL_BOUNDARY:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL;
+		db->mode = in->mode;
+		db->slice_alpha_offset = in->slice_alpha_offset;
+		db->slice_beta_offset = in->slice_beta_offset;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*db);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_SESSION_QP: {
+		struct hfi_quantization *in = pdata, *quant = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SESSION_QP;
+		quant->qp_i = in->qp_i;
+		quant->qp_p = in->qp_p;
+		quant->qp_b = in->qp_b;
+		quant->layer_id = in->layer_id;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*quant);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE: {
+		struct hfi_quantization_range *in = pdata, *range = prop_data;
+		u32 min_qp, max_qp;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE;
+		min_qp = in->min_qp;
+		max_qp = in->max_qp;
+
+		/* We'll be packing in the qp, so make sure we
+		 * won't be losing data when masking
+		 */
+		if (min_qp > 0xff || max_qp > 0xff) {
+			ret = -ERANGE;
+			break;
+		}
+
+		/* When creating the packet, pack the qp value as
+		 * 0xiippbb, where ii = qp range for I-frames,
+		 * pp = qp range for P-frames, etc.
+		 */
+		range->min_qp = min_qp | min_qp << 8 | min_qp << 16;
+		range->max_qp = max_qp | max_qp << 8 | max_qp << 16;
+		range->layer_id = in->layer_id;
+
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*range);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG: {
+		struct hfi_vc1e_perf_cfg_type *in = pdata, *perf = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG;
+
+		memcpy(perf->search_range_x_subsampled,
+		       in->search_range_x_subsampled,
+		       sizeof(perf->search_range_x_subsampled));
+		memcpy(perf->search_range_y_subsampled,
+		       in->search_range_y_subsampled,
+		       sizeof(perf->search_range_y_subsampled));
+
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*perf);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES: {
+		struct hfi_max_num_b_frames *bframes = prop_data;
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES;
+		bframes->max_num_b_frames = *in;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*bframes);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD: {
+		struct hfi_intra_period *in = pdata, *intra = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD;
+		intra->pframes = in->pframes;
+		intra->bframes = in->bframes;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*intra);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD: {
+		struct hfi_idr_period *in = pdata, *idr = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
+		idr->idr_period = in->idr_period;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*idr);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR: {
+		struct hfi_conceal_color *color = prop_data;
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR;
+		color->conceal_color = *in;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*color);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VPE_OPERATIONS: {
+		struct hfi_operations_type *in = pdata, *ops = prop_data;
+
+		switch (in->rotation) {
+		case HFI_ROTATE_NONE:
+		case HFI_ROTATE_90:
+		case HFI_ROTATE_180:
+		case HFI_ROTATE_270:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		switch (in->flip) {
+		case HFI_FLIP_NONE:
+		case HFI_FLIP_HORIZONTAL:
+		case HFI_FLIP_VERTICAL:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VPE_OPERATIONS;
+		ops->rotation = in->rotation;
+		ops->flip = in->flip;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ops);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH: {
+		struct hfi_intra_refresh *in = pdata, *intra = prop_data;
+
+		switch (in->mode) {
+		case HFI_INTRA_REFRESH_NONE:
+		case HFI_INTRA_REFRESH_ADAPTIVE:
+		case HFI_INTRA_REFRESH_CYCLIC:
+		case HFI_INTRA_REFRESH_CYCLIC_ADAPTIVE:
+		case HFI_INTRA_REFRESH_RANDOM:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH;
+		intra->mode = in->mode;
+		intra->air_mbs = in->air_mbs;
+		intra->air_ref = in->air_ref;
+		intra->cir_mbs = in->cir_mbs;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*intra);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL: {
+		struct hfi_multi_slice_control *in = pdata, *multi = prop_data;
+
+		switch (in->multi_slice) {
+		case HFI_MULTI_SLICE_OFF:
+		case HFI_MULTI_SLICE_GOB:
+		case HFI_MULTI_SLICE_BY_MB_COUNT:
+		case HFI_MULTI_SLICE_BY_BYTE_COUNT:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL;
+		multi->multi_slice = in->multi_slice;
+		multi->slice_size = in->slice_size;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*multi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO: {
+		struct hfi_h264_vui_timing_info *in = pdata, *vui = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;
+		vui->enable = in->enable;
+		vui->fixed_framerate = in->fixed_framerate;
+		vui->time_scale = in->time_scale;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*vui);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VPE_DEINTERLACE: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VPE_DEINTERLACE;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE: {
+		struct hfi_buffer_alloc_mode *in = pdata, *mode = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
+		mode->type = in->type;
+		mode->mode = in->mode;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*mode);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD: {
+		struct hfi_scs_threshold *thres = prop_data;
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD;
+		thres->threshold_value = *in;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*thres);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT: {
+		struct hfi_mvc_buffer_layout_descp_type *in = pdata;
+		struct hfi_mvc_buffer_layout_descp_type *mvc = prop_data;
+
+		switch (in->layout_type) {
+		case HFI_MVC_BUFFER_LAYOUT_TOP_BOTTOM:
+		case HFI_MVC_BUFFER_LAYOUT_SEQ:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT;
+		mvc->layout_type = in->layout_type;
+		mvc->bright_view_first = in->bright_view_first;
+		mvc->ngap = in->ngap;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*mvc);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_LTRMODE: {
+		struct hfi_ltr_mode *in = pdata, *ltr = prop_data;
+
+		switch (in->ltr_mode) {
+		case HFI_LTR_MODE_DISABLE:
+		case HFI_LTR_MODE_MANUAL:
+		case HFI_LTR_MODE_PERIODIC:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_LTRMODE;
+		ltr->ltr_mode = in->ltr_mode;
+		ltr->ltr_count = in->ltr_count;
+		ltr->trust_mode = in->trust_mode;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ltr);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_USELTRFRAME: {
+		struct hfi_ltr_use *in = pdata, *ltr_use = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_USELTRFRAME;
+		ltr_use->frames = in->frames;
+		ltr_use->ref_ltr = in->ref_ltr;
+		ltr_use->use_constrnt = in->use_constrnt;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ltr_use);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME: {
+		struct hfi_ltr_mark *in = pdata, *ltr_mark = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME;
+		ltr_mark->mark_frame = in->mark_frame;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*ltr_mark);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER: {
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER: {
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_INITIAL_QP: {
+		struct hfi_initial_quantization *in = pdata, *quant = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INITIAL_QP;
+		quant->init_qp_enable = in->init_qp_enable;
+		quant->qp_i = in->qp_i;
+		quant->qp_p = in->qp_p;
+		quant->qp_b = in->qp_b;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*quant);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VPE_COLOR_SPACE_CONVERSION: {
+		struct hfi_vpe_color_space_conversion *in = pdata;
+		struct hfi_vpe_color_space_conversion *csc = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VPE_COLOR_SPACE_CONVERSION;
+		memcpy(csc->csc_matrix, in->csc_matrix,
+			sizeof(csc->csc_matrix));
+		memcpy(csc->csc_bias, in->csc_bias, sizeof(csc->csc_bias));
+		memcpy(csc->csc_limit, in->csc_limit, sizeof(csc->csc_limit));
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*csc);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] =
+			HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_CONFIG_VENC_PERF_MODE: {
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_CONFIG_VENC_PERF_MODE;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER: {
+		u32 *in = pdata;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER;
+		pkt->data[1] = *in;
+		pkt->shdr.hdr.size += sizeof(u32) * 2;
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2: {
+		struct hfi_enable *in = pdata, *en = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2;
+		en->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*en);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE: {
+		struct hfi_hybrid_hierp *in = pdata, *hierp = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE;
+		hierp->layers = in->layers;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*hierp);
+		break;
+	}
+
+	/* FOLLOWING PROPERTIES ARE NOT IMPLEMENTED IN CORE YET */
+	case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
+	case HFI_PROPERTY_CONFIG_PRIORITY:
+	case HFI_PROPERTY_CONFIG_BATCH_INFO:
+	case HFI_PROPERTY_SYS_IDLE_INDICATOR:
+	case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED:
+	case HFI_PROPERTY_PARAM_INTERLACE_FORMAT_SUPPORTED:
+	case HFI_PROPERTY_PARAM_CHROMA_SITE:
+	case HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED:
+	case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED:
+	case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED:
+	case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED:
+	case HFI_PROPERTY_PARAM_MULTI_VIEW_FORMAT:
+	case HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE:
+	case HFI_PROPERTY_PARAM_CODEC_SUPPORTED:
+	case HFI_PROPERTY_PARAM_VDEC_MULTI_VIEW_SELECT:
+	case HFI_PROPERTY_PARAM_VDEC_MB_QUANTIZATION:
+	case HFI_PROPERTY_PARAM_VDEC_NUM_CONCEALED_MB:
+	case HFI_PROPERTY_PARAM_VDEC_H264_ENTROPY_SWITCHING:
+	case HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_INFO:
+	default:
+		return -ENOTSUPP;
+	}
+
+	return ret;
+}
+
+static int
+pkt_session_set_property_3xx(struct hfi_session_set_property_pkt *pkt,
+			     struct hfi_inst *inst, u32 ptype, void *pdata)
+{
+	void *prop_data = &pkt->data[1];
+	int ret = 0;
+
+	if (!pkt || !inst || !pdata)
+		return -EINVAL;
+
+	pkt->shdr.hdr.size = sizeof(*pkt);
+	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_PROPERTY;
+	pkt->shdr.session_id = hash32_ptr(inst);
+	pkt->num_properties = 1;
+
+	/*
+	 * Any session set property which is different in 3XX packetization
+	 * should be added as a new case below. All unchanged session set
+	 * properties will be handled in the default case.
+	 */
+	switch (ptype) {
+	case HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM: {
+		struct hfi_multi_stream *in = pdata;
+		struct hfi_multi_stream_3x *multi = prop_data;
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM;
+		multi->buffer_type = in->buffer_type;
+		multi->enable = in->enable;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*multi);
+		break;
+	}
+	case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH: {
+		struct hfi_intra_refresh *in = pdata;
+		struct hfi_intra_refresh_3x *intra = prop_data;
+
+		switch (in->mode) {
+		case HFI_INTRA_REFRESH_NONE:
+		case HFI_INTRA_REFRESH_ADAPTIVE:
+		case HFI_INTRA_REFRESH_CYCLIC:
+		case HFI_INTRA_REFRESH_CYCLIC_ADAPTIVE:
+		case HFI_INTRA_REFRESH_RANDOM:
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		pkt->data[0] = HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH;
+		intra->mode = in->mode;
+		intra->mbs = in->cir_mbs;
+		pkt->shdr.hdr.size += sizeof(u32) + sizeof(*intra);
+		break;
+	}
+	default:
+		ret = pkt_session_set_property(pkt, inst, ptype, pdata);
+		break;
+	}
+
+	return ret;
+}
+
+static int pkt_ssr_cmd(u32 trigger_type, struct hfi_sys_test_ssr_pkt *pkt)
+{
+	switch (trigger_type) {
+	case HFI_TEST_SSR_SW_ERR_FATAL:
+	case HFI_TEST_SSR_SW_DIV_BY_ZERO:
+	case HFI_TEST_SSR_HW_WDOG_IRQ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_TEST_SSR;
+	pkt->trigger_type = trigger_type;
+
+	return 0;
+}
+
+static void pkt_sys_image_version(struct hfi_sys_get_property_pkt *pkt)
+{
+	pkt->hdr.size = sizeof(*pkt);
+	pkt->hdr.pkt_type = HFI_CMD_SYS_GET_PROPERTY;
+	pkt->num_properties = 1;
+	pkt->data[0] = HFI_PROPERTY_SYS_IMAGE_VERSION;
+}
+
+static const struct hfi_packetization_ops hfi_default = {
+	.sys_init = pkt_sys_init,
+	.sys_pc_prep = pkt_sys_pc_prep,
+	.sys_idle_indicator = pkt_sys_idle_indicator,
+	.sys_power_control = pkt_sys_power_control,
+	.sys_set_resource = pkt_sys_set_resource,
+	.sys_release_resource = pkt_sys_unset_resource,
+	.sys_debug_config = pkt_sys_debug_config,
+	.sys_coverage_config = pkt_sys_coverage_config,
+	.sys_ping = pkt_sys_ping,
+	.sys_image_version = pkt_sys_image_version,
+	.ssr_cmd = pkt_ssr_cmd,
+	.session_init = pkt_session_init,
+	.session_cmd = pkt_session_cmd,
+	.session_set_buffers = pkt_session_set_buffers,
+	.session_release_buffers = pkt_session_release_buffers,
+	.session_etb_decoder = pkt_session_etb_decoder,
+	.session_etb_encoder = pkt_session_etb_encoder,
+	.session_ftb = pkt_session_ftb,
+	.session_parse_seq_header = pkt_session_parse_seq_header,
+	.session_get_seq_hdr = pkt_session_get_seq_hdr,
+	.session_flush = pkt_session_flush,
+	.session_get_property = pkt_session_get_property,
+	.session_set_property = pkt_session_set_property,
+};
+
+static const struct hfi_packetization_ops *get_3xx_ops(void)
+{
+	static struct hfi_packetization_ops hfi_3xx;
+
+	hfi_3xx = hfi_default;
+	hfi_3xx.session_set_property = pkt_session_set_property_3xx;
+
+	return &hfi_3xx;
+}
+
+const struct hfi_packetization_ops *
+hfi_get_pkt_ops(enum hfi_packetization_type type)
+{
+	switch (type) {
+	case HFI_PACKETIZATION_LEGACY:
+		return &hfi_default;
+	case HFI_PACKETIZATION_3XX:
+		return get_3xx_ops();
+	}
+
+	return NULL;
+}
diff --git a/drivers/media/platform/qcom/vidc/hfi_cmds.h b/drivers/media/platform/qcom/vidc/hfi_cmds.h
new file mode 100644
index 000000000000..e57a0d4d2b9d
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi_cmds.h
@@ -0,0 +1,338 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __HFI_CMDS_H__
+#define __HFI_CMDS_H__
+
+#include "hfi_helper.h"
+#include "hfi.h"
+
+/* commands */
+#define HFI_CMD_SYS_COMMON_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_COMMON_OFFSET +	\
+					 HFI_CMD_START_OFFSET + 0x0000)
+#define HFI_CMD_SYS_INIT		(HFI_CMD_SYS_COMMON_START + 0x1)
+#define HFI_CMD_SYS_PC_PREP		(HFI_CMD_SYS_COMMON_START + 0x2)
+#define HFI_CMD_SYS_SET_RESOURCE	(HFI_CMD_SYS_COMMON_START + 0x3)
+#define HFI_CMD_SYS_RELEASE_RESOURCE	(HFI_CMD_SYS_COMMON_START + 0x4)
+#define HFI_CMD_SYS_SET_PROPERTY	(HFI_CMD_SYS_COMMON_START + 0x5)
+#define HFI_CMD_SYS_GET_PROPERTY	(HFI_CMD_SYS_COMMON_START + 0x6)
+#define HFI_CMD_SYS_SESSION_INIT	(HFI_CMD_SYS_COMMON_START + 0x7)
+#define HFI_CMD_SYS_SESSION_END		(HFI_CMD_SYS_COMMON_START + 0x8)
+#define HFI_CMD_SYS_SET_BUFFERS		(HFI_CMD_SYS_COMMON_START + 0x9)
+#define HFI_CMD_SYS_TEST_START		(HFI_CMD_SYS_COMMON_START + 0x100)
+#define HFI_CMD_SYS_TEST_SSR		(HFI_CMD_SYS_TEST_START + 0x1)
+
+#define HFI_CMD_SESSION_COMMON_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_COMMON_OFFSET +	\
+					 HFI_CMD_START_OFFSET + 0x1000)
+#define HFI_CMD_SESSION_SET_PROPERTY	(HFI_CMD_SESSION_COMMON_START + 0x1)
+#define HFI_CMD_SESSION_SET_BUFFERS	(HFI_CMD_SESSION_COMMON_START + 0x2)
+#define HFI_CMD_SESSION_GET_SEQUENCE_HEADER	\
+					(HFI_CMD_SESSION_COMMON_START + 0x3)
+
+#define HFI_CMD_SYS_OX_START		(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_OX_OFFSET +		\
+					 HFI_CMD_START_OFFSET + 0x0000)
+#define HFI_CMD_SYS_SESSION_ABORT	(HFI_CMD_SYS_OX_START + 0x1)
+#define HFI_CMD_SYS_PING		(HFI_CMD_SYS_OX_START + 0x2)
+
+#define HFI_CMD_SESSION_OX_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_OX_OFFSET +		\
+					 HFI_CMD_START_OFFSET + 0x1000)
+#define HFI_CMD_SESSION_LOAD_RESOURCES	(HFI_CMD_SESSION_OX_START + 0x1)
+#define HFI_CMD_SESSION_START		(HFI_CMD_SESSION_OX_START + 0x2)
+#define HFI_CMD_SESSION_STOP		(HFI_CMD_SESSION_OX_START + 0x3)
+#define HFI_CMD_SESSION_EMPTY_BUFFER	(HFI_CMD_SESSION_OX_START + 0x4)
+#define HFI_CMD_SESSION_FILL_BUFFER	(HFI_CMD_SESSION_OX_START + 0x5)
+#define HFI_CMD_SESSION_SUSPEND		(HFI_CMD_SESSION_OX_START + 0x6)
+#define HFI_CMD_SESSION_RESUME		(HFI_CMD_SESSION_OX_START + 0x7)
+#define HFI_CMD_SESSION_FLUSH		(HFI_CMD_SESSION_OX_START + 0x8)
+#define HFI_CMD_SESSION_GET_PROPERTY	(HFI_CMD_SESSION_OX_START + 0x9)
+#define HFI_CMD_SESSION_PARSE_SEQUENCE_HEADER	\
+					(HFI_CMD_SESSION_OX_START + 0xa)
+#define HFI_CMD_SESSION_RELEASE_BUFFERS		\
+					(HFI_CMD_SESSION_OX_START + 0xb)
+#define HFI_CMD_SESSION_RELEASE_RESOURCES	\
+					(HFI_CMD_SESSION_OX_START + 0xc)
+
+/* command packets */
+struct hfi_sys_init_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 arch_type;
+};
+
+struct hfi_sys_pc_prep_pkt {
+	struct hfi_pkt_hdr hdr;
+};
+
+struct hfi_sys_set_resource_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 resource_handle;
+	u32 resource_type;
+	u32 resource_data[1];
+};
+
+struct hfi_sys_release_resource_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 resource_type;
+	u32 resource_handle;
+};
+
+struct hfi_sys_set_property_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_sys_get_property_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_sys_set_buffers_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 buffer_type;
+	u32 buffer_size;
+	u32 num_buffers;
+	u32 buffer_addr[1];
+};
+
+struct hfi_sys_ping_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 client_data;
+};
+
+struct hfi_session_init_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 session_domain;
+	u32 session_codec;
+};
+
+struct hfi_session_end_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_abort_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_set_property_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 num_properties;
+	u32 data[0];
+};
+
+struct hfi_session_set_buffers_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 buffer_type;
+	u32 buffer_size;
+	u32 extradata_size;
+	u32 min_buffer_size;
+	u32 num_buffers;
+	u32 buffer_info[1];
+};
+
+struct hfi_session_get_sequence_header_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 buffer_len;
+	u32 packet_buffer;
+};
+
+struct hfi_session_load_resources_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_start_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_stop_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_empty_buffer_compressed_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u32 flags;
+	u32 mark_target;
+	u32 mark_data;
+	u32 offset;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 input_tag;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[1];
+};
+
+struct hfi_session_empty_buffer_uncompressed_plane0_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 view_id;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u32 flags;
+	u32 mark_target;
+	u32 mark_data;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 input_tag;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[1];
+};
+
+struct hfi_session_empty_buffer_uncompressed_plane1_pkt {
+	u32 flags;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 packet_buffer2;
+	u32 data[1];
+};
+
+struct hfi_session_empty_buffer_uncompressed_plane2_pkt {
+	u32 flags;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 packet_buffer3;
+	u32 data[1];
+};
+
+struct hfi_session_fill_buffer_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 stream_id;
+	u32 offset;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 output_tag;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[1];
+};
+
+struct hfi_session_flush_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 flush_type;
+};
+
+struct hfi_session_suspend_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_resume_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_get_property_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_session_release_buffer_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 buffer_type;
+	u32 buffer_size;
+	u32 extradata_size;
+	u32 response_req;
+	u32 num_buffers;
+	u32 buffer_info[1];
+};
+
+struct hfi_session_release_resources_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+struct hfi_session_parse_sequence_header_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 header_len;
+	u32 packet_buffer;
+};
+
+struct hfi_sfr {
+	u32 buf_size;
+	u8 data[1];
+};
+
+struct hfi_sys_test_ssr_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 trigger_type;
+};
+
+#define call_hfi_pkt_op(hfi, op, args...)			\
+	(((hfi) && (hfi)->pkt_ops && (hfi)->pkt_ops->op) ?	\
+	((hfi)->pkt_ops->op(args)) : -EINVAL)
+
+struct hfi_packetization_ops {
+	void (*sys_init)(struct hfi_sys_init_pkt *pkt, u32 arch_type);
+	void (*sys_pc_prep)(struct hfi_sys_pc_prep_pkt *pkt);
+	void (*sys_idle_indicator)(struct hfi_sys_set_property_pkt *pkt,
+				   u32 enable);
+	void (*sys_power_control)(struct hfi_sys_set_property_pkt *pkt,
+				  u32 enable);
+	int (*sys_set_resource)(struct hfi_sys_set_resource_pkt *pkt,
+				u32 id, u32 size, u32 addr, void *cookie);
+	int (*sys_release_resource)(struct hfi_sys_release_resource_pkt *pkt,
+				    u32 id, u32 size, void *cookie);
+	void (*sys_debug_config)(struct hfi_sys_set_property_pkt *pkt, u32 mode,
+				 u32 config);
+	void (*sys_coverage_config)(struct hfi_sys_set_property_pkt *pkt,
+				    u32 mode);
+	void (*sys_ping)(struct hfi_sys_ping_pkt *pkt, u32 cookie);
+	void (*sys_image_version)(struct hfi_sys_get_property_pkt *pkt);
+	int (*ssr_cmd)(u32 trigger_type, struct hfi_sys_test_ssr_pkt *pkt);
+	int (*session_init)(struct hfi_session_init_pkt *pkt,
+			    struct hfi_inst *inst, u32 session_type, u32 codec);
+	void (*session_cmd)(struct hfi_session_pkt *pkt, u32 pkt_type,
+			    struct hfi_inst *inst);
+	int (*session_set_buffers)(struct hfi_session_set_buffers_pkt *pkt,
+				   struct hfi_inst *inst,
+				   struct hfi_buffer_desc *bd);
+	int (*session_release_buffers)(
+		struct hfi_session_release_buffer_pkt *pkt,
+		struct hfi_inst *inst, struct hfi_buffer_desc *bd);
+	int (*session_etb_decoder)(
+		struct hfi_session_empty_buffer_compressed_pkt *pkt,
+		struct hfi_inst *inst,
+		struct hfi_frame_data *input_frame);
+	int (*session_etb_encoder)(
+		struct hfi_session_empty_buffer_uncompressed_plane0_pkt *pkt,
+		struct hfi_inst *inst, struct hfi_frame_data *input_frame);
+	int (*session_ftb)(struct hfi_session_fill_buffer_pkt *pkt,
+		struct hfi_inst *inst, struct hfi_frame_data *output_frame);
+	int (*session_parse_seq_header)(
+		struct hfi_session_parse_sequence_header_pkt *pkt,
+		struct hfi_inst *inst, u32 seq_hdr, u32 seq_hdr_len);
+	int (*session_get_seq_hdr)(
+		struct hfi_session_get_sequence_header_pkt *pkt,
+		struct hfi_inst *inst, u32 seq_hdr, u32 seq_hdr_len);
+	int (*session_flush)(struct hfi_session_flush_pkt *pkt,
+		struct hfi_inst *inst, u32 flush_mode);
+	int (*session_get_property)(
+		struct hfi_session_get_property_pkt *pkt,
+		struct hfi_inst *inst, u32 ptype);
+	int (*session_set_property)(struct hfi_session_set_property_pkt *pkt,
+				    struct hfi_inst *inst,
+				    u32 ptype, void *pdata);
+};
+
+const struct hfi_packetization_ops *
+hfi_get_pkt_ops(enum hfi_packetization_type);
+
+#endif
diff --git a/drivers/media/platform/qcom/vidc/hfi_helper.h b/drivers/media/platform/qcom/vidc/hfi_helper.h
new file mode 100644
index 000000000000..c4d2c263bf03
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi_helper.h
@@ -0,0 +1,1143 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __HFI_HELPER_H__
+#define __HFI_HELPER_H__
+
+#define HFI_COMMON_BASE				0
+
+#define HFI_DOMAIN_BASE_COMMON			(HFI_COMMON_BASE + 0)
+#define HFI_DOMAIN_BASE_VDEC			(HFI_COMMON_BASE + 0x1000000)
+#define HFI_DOMAIN_BASE_VENC			(HFI_COMMON_BASE + 0x2000000)
+#define HFI_DOMAIN_BASE_VPE			(HFI_COMMON_BASE + 0x3000000)
+
+#define HFI_VIDEO_ARCH_OX			(HFI_COMMON_BASE + 0x1)
+
+#define HFI_ARCH_COMMON_OFFSET			0
+
+#define HFI_CMD_START_OFFSET			0x10000
+#define HFI_MSG_START_OFFSET			0x20000
+
+#define HFI_ERR_NONE				HFI_COMMON_BASE
+#define HFI_ERR_SYS_FATAL			(HFI_COMMON_BASE + 0x1)
+#define HFI_ERR_SYS_INVALID_PARAMETER		(HFI_COMMON_BASE + 0x2)
+#define HFI_ERR_SYS_VERSION_MISMATCH		(HFI_COMMON_BASE + 0x3)
+#define HFI_ERR_SYS_INSUFFICIENT_RESOURCES	(HFI_COMMON_BASE + 0x4)
+#define HFI_ERR_SYS_MAX_SESSIONS_REACHED	(HFI_COMMON_BASE + 0x5)
+#define HFI_ERR_SYS_UNSUPPORTED_CODEC		(HFI_COMMON_BASE + 0x6)
+#define HFI_ERR_SYS_SESSION_IN_USE		(HFI_COMMON_BASE + 0x7)
+#define HFI_ERR_SYS_SESSION_ID_OUT_OF_RANGE	(HFI_COMMON_BASE + 0x8)
+#define HFI_ERR_SYS_UNSUPPORTED_DOMAIN		(HFI_COMMON_BASE + 0x9)
+
+#define HFI_ERR_SESSION_FATAL			(HFI_COMMON_BASE + 0x1001)
+#define HFI_ERR_SESSION_INVALID_PARAMETER	(HFI_COMMON_BASE + 0x1002)
+#define HFI_ERR_SESSION_BAD_POINTER		(HFI_COMMON_BASE + 0x1003)
+#define HFI_ERR_SESSION_INVALID_SESSION_ID	(HFI_COMMON_BASE + 0x1004)
+#define HFI_ERR_SESSION_INVALID_STREAM_ID	(HFI_COMMON_BASE + 0x1005)
+#define HFI_ERR_SESSION_INCORRECT_STATE_OPERATION	\
+						(HFI_COMMON_BASE + 0x1006)
+#define HFI_ERR_SESSION_UNSUPPORTED_PROPERTY	(HFI_COMMON_BASE + 0x1007)
+#define HFI_ERR_SESSION_UNSUPPORTED_SETTING	(HFI_COMMON_BASE + 0x1008)
+#define HFI_ERR_SESSION_INSUFFICIENT_RESOURCES	(HFI_COMMON_BASE + 0x1009)
+#define HFI_ERR_SESSION_STREAM_CORRUPT_OUTPUT_STALLED	\
+						(HFI_COMMON_BASE + 0x100a)
+#define HFI_ERR_SESSION_STREAM_CORRUPT		(HFI_COMMON_BASE + 0x100b)
+#define HFI_ERR_SESSION_ENC_OVERFLOW		(HFI_COMMON_BASE + 0x100c)
+#define HFI_ERR_SESSION_UNSUPPORTED_STREAM	(HFI_COMMON_BASE + 0x100d)
+#define HFI_ERR_SESSION_CMDSIZE			(HFI_COMMON_BASE + 0x100e)
+#define HFI_ERR_SESSION_UNSUPPORT_CMD		(HFI_COMMON_BASE + 0x100f)
+#define HFI_ERR_SESSION_UNSUPPORT_BUFFERTYPE	(HFI_COMMON_BASE + 0x1010)
+#define HFI_ERR_SESSION_BUFFERCOUNT_TOOSMALL	(HFI_COMMON_BASE + 0x1011)
+#define HFI_ERR_SESSION_INVALID_SCALE_FACTOR	(HFI_COMMON_BASE + 0x1012)
+#define HFI_ERR_SESSION_UPSCALE_NOT_SUPPORTED	(HFI_COMMON_BASE + 0x1013)
+
+#define HFI_EVENT_SYS_ERROR			(HFI_COMMON_BASE + 0x1)
+#define HFI_EVENT_SESSION_ERROR			(HFI_COMMON_BASE + 0x2)
+
+#define HFI_OX_BASE				0x01000000
+
+#define HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES	\
+						(HFI_OX_BASE + 0x1)
+#define HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES	\
+						(HFI_OX_BASE + 0x2)
+#define HFI_EVENT_SESSION_SEQUENCE_CHANGED	(HFI_OX_BASE + 0x3)
+#define HFI_EVENT_SESSION_PROPERTY_CHANGED	(HFI_OX_BASE + 0x4)
+#define HFI_EVENT_SESSION_LTRUSE_FAILED		(HFI_OX_BASE + 0x5)
+#define HFI_EVENT_RELEASE_BUFFER_REFERENCE	(HFI_OX_BASE + 0x6)
+
+#define HFI_BUFFERFLAG_EOS				0x00000001
+#define HFI_BUFFERFLAG_STARTTIME			0x00000002
+#define HFI_BUFFERFLAG_DECODEONLY			0x00000004
+#define HFI_BUFFERFLAG_DATACORRUPT			0x00000008
+#define HFI_BUFFERFLAG_ENDOFFRAME			0x00000010
+#define HFI_BUFFERFLAG_SYNCFRAME			0x00000020
+#define HFI_BUFFERFLAG_EXTRADATA			0x00000040
+#define HFI_BUFFERFLAG_CODECCONFIG			0x00000080
+#define HFI_BUFFERFLAG_TIMESTAMPINVALID			0x00000100
+#define HFI_BUFFERFLAG_READONLY				0x00000200
+#define HFI_BUFFERFLAG_ENDOFSUBFRAME			0x00000400
+#define HFI_BUFFERFLAG_EOSEQ				0x00200000
+#define HFI_BUFFERFLAG_MBAFF				0x08000000
+#define HFI_BUFFERFLAG_VPE_YUV_601_709_CSC_CLAMP	0x10000000
+#define HFI_BUFFERFLAG_DROP_FRAME			0x20000000
+#define HFI_BUFFERFLAG_TEI				0x40000000
+#define HFI_BUFFERFLAG_DISCONTINUITY			0x80000000
+
+#define HFI_ERR_SESSION_EMPTY_BUFFER_DONE_OUTPUT_PENDING	\
+							(HFI_OX_BASE + 0x1001)
+#define HFI_ERR_SESSION_SAME_STATE_OPERATION	\
+							(HFI_OX_BASE + 0x1002)
+#define HFI_ERR_SESSION_SYNC_FRAME_NOT_DETECTED	\
+							(HFI_OX_BASE + 0x1003)
+#define HFI_ERR_SESSION_START_CODE_NOT_FOUND	\
+							(HFI_OX_BASE + 0x1004)
+
+#define HFI_FLUSH_INPUT					(HFI_OX_BASE + 0x1)
+#define HFI_FLUSH_OUTPUT				(HFI_OX_BASE + 0x2)
+#define HFI_FLUSH_OUTPUT2				(HFI_OX_BASE + 0x3)
+#define HFI_FLUSH_ALL					(HFI_OX_BASE + 0x4)
+
+#define HFI_EXTRADATA_NONE				0x00000000
+#define HFI_EXTRADATA_MB_QUANTIZATION			0x00000001
+#define HFI_EXTRADATA_INTERLACE_VIDEO			0x00000002
+#define HFI_EXTRADATA_VC1_FRAMEDISP			0x00000003
+#define HFI_EXTRADATA_VC1_SEQDISP			0x00000004
+#define HFI_EXTRADATA_TIMESTAMP				0x00000005
+#define HFI_EXTRADATA_S3D_FRAME_PACKING			0x00000006
+#define HFI_EXTRADATA_FRAME_RATE			0x00000007
+#define HFI_EXTRADATA_PANSCAN_WINDOW			0x00000008
+#define HFI_EXTRADATA_RECOVERY_POINT_SEI		0x00000009
+#define HFI_EXTRADATA_MPEG2_SEQDISP			0x0000000d
+#define HFI_EXTRADATA_STREAM_USERDATA			0x0000000e
+#define HFI_EXTRADATA_FRAME_QP				0x0000000f
+#define HFI_EXTRADATA_FRAME_BITS_INFO			0x00000010
+#define HFI_EXTRADATA_MULTISLICE_INFO			0x7f100000
+#define HFI_EXTRADATA_NUM_CONCEALED_MB			0x7f100001
+#define HFI_EXTRADATA_INDEX				0x7f100002
+#define HFI_EXTRADATA_METADATA_LTR			0x7f100004
+#define HFI_EXTRADATA_METADATA_FILLER			0x7fe00002
+
+#define HFI_INDEX_EXTRADATA_INPUT_CROP			0x0700000e
+#define HFI_INDEX_EXTRADATA_DIGITAL_ZOOM		0x07000010
+#define HFI_INDEX_EXTRADATA_ASPECT_RATIO		0x7f100003
+
+#define HFI_INTERLACE_FRAME_PROGRESSIVE			0x01
+#define HFI_INTERLACE_INTERLEAVE_FRAME_TOPFIELDFIRST	0x02
+#define HFI_INTERLACE_INTERLEAVE_FRAME_BOTTOMFIELDFIRST	0x04
+#define HFI_INTERLACE_FRAME_TOPFIELDFIRST		0x08
+#define HFI_INTERLACE_FRAME_BOTTOMFIELDFIRST		0x10
+
+#define HFI_ARCH_OX_OFFSET				0x200000
+
+#define HFI_PROPERTY_SYS_OX_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_OX_OFFSET + 0x0000)
+
+#define HFI_PROPERTY_PARAM_OX_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_OX_OFFSET + 0x1000)
+#define HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x1)
+#define HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x2)
+#define HFI_PROPERTY_PARAM_INTERLACE_FORMAT_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x3)
+#define HFI_PROPERTY_PARAM_CHROMA_SITE	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x4)
+#define HFI_PROPERTY_PARAM_EXTRA_DATA_HEADER_CONFIG	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x5)
+#define HFI_PROPERTY_PARAM_INDEX_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x6)
+#define HFI_PROPERTY_PARAM_DIVX_FORMAT	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x7)
+#define HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x8)
+#define HFI_PROPERTY_PARAM_S3D_FRAME_PACKING_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_OX_START + 0x9)
+#define HFI_PROPERTY_PARAM_ERR_DETECTION_CODE_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_OX_START + 0xa)
+#define HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_OX_START + 0xb)
+#define HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL	\
+	(HFI_PROPERTY_PARAM_OX_START + 0xc)
+#define HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL	\
+	(HFI_PROPERTY_PARAM_OX_START + 0xd)
+
+#define HFI_PROPERTY_CONFIG_OX_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_OX_OFFSET + 0x2000)
+#define HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS	\
+	(HFI_PROPERTY_CONFIG_OX_START + 0x1)
+#define HFI_PROPERTY_CONFIG_REALTIME	\
+	(HFI_PROPERTY_CONFIG_OX_START + 0x2)
+#define HFI_PROPERTY_CONFIG_PRIORITY	\
+	(HFI_PROPERTY_CONFIG_OX_START + 0x3)
+#define HFI_PROPERTY_CONFIG_BATCH_INFO	\
+	(HFI_PROPERTY_CONFIG_OX_START + 0x4)
+
+#define HFI_PROPERTY_PARAM_VDEC_OX_START	\
+	(HFI_DOMAIN_BASE_VDEC + HFI_ARCH_OX_OFFSET + 0x3000)
+#define HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x1)
+#define HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x2)
+#define HFI_PROPERTY_PARAM_VDEC_MULTI_VIEW_SELECT	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x3)
+#define HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x4)
+#define HFI_PROPERTY_PARAM_VDEC_OUTPUT_ORDER	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x5)
+#define HFI_PROPERTY_PARAM_VDEC_MB_QUANTIZATION	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x6)
+#define HFI_PROPERTY_PARAM_VDEC_NUM_CONCEALED_MB	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x7)
+#define HFI_PROPERTY_PARAM_VDEC_H264_ENTROPY_SWITCHING	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x8)
+#define HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x9)
+#define HFI_PROPERTY_PARAM_VDEC_FRAME_RATE_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0xa)
+#define HFI_PROPERTY_PARAM_VDEC_PANSCAN_WNDW_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0xb)
+#define HFI_PROPERTY_PARAM_VDEC_RECOVERY_POINT_SEI_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0xc)
+#define HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0xd)
+#define HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0xe)
+#define HFI_PROPERTY_PARAM_VDEC_VC1_FRAMEDISP_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x11)
+#define HFI_PROPERTY_PARAM_VDEC_VC1_SEQDISP_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x12)
+#define HFI_PROPERTY_PARAM_VDEC_TIMESTAMP_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x13)
+#define HFI_PROPERTY_PARAM_VDEC_INTERLACE_VIDEO_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x14)
+#define HFI_PROPERTY_PARAM_VDEC_AVC_SESSION_SELECT	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x15)
+#define HFI_PROPERTY_PARAM_VDEC_MPEG2_SEQDISP_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x16)
+#define HFI_PROPERTY_PARAM_VDEC_STREAM_USERDATA_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x17)
+#define HFI_PROPERTY_PARAM_VDEC_FRAME_QP_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x18)
+#define HFI_PROPERTY_PARAM_VDEC_FRAME_BITS_INFO_EXTRADATA	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x19)
+#define HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD	\
+	(HFI_PROPERTY_PARAM_VDEC_OX_START + 0x1a)
+
+#define HFI_PROPERTY_CONFIG_VDEC_OX_START	\
+	(HFI_DOMAIN_BASE_VDEC + HFI_ARCH_OX_OFFSET + 0x0000)
+#define HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER	\
+	(HFI_PROPERTY_CONFIG_VDEC_OX_START + 0x1)
+#define HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING	\
+	(HFI_PROPERTY_CONFIG_VDEC_OX_START + 0x2)
+#define HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP	\
+	(HFI_PROPERTY_CONFIG_VDEC_OX_START + 0x3)
+
+#define HFI_PROPERTY_PARAM_VENC_OX_START	\
+	(HFI_DOMAIN_BASE_VENC + HFI_ARCH_OX_OFFSET + 0x5000)
+#define  HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_INFO	\
+	(HFI_PROPERTY_PARAM_VENC_OX_START + 0x1)
+#define  HFI_PROPERTY_PARAM_VENC_H264_IDR_S3D_FRAME_PACKING_NAL	\
+	(HFI_PROPERTY_PARAM_VENC_OX_START + 0x2)
+#define  HFI_PROPERTY_PARAM_VENC_LTR_INFO	\
+	(HFI_PROPERTY_PARAM_VENC_OX_START + 0x3)
+#define  HFI_PROPERTY_PARAM_VENC_MBI_DUMPING	\
+	(HFI_PROPERTY_PARAM_VENC_OX_START + 0x5)
+
+#define HFI_PROPERTY_CONFIG_VENC_OX_START	\
+	(HFI_DOMAIN_BASE_VENC + HFI_ARCH_OX_OFFSET + 0x6000)
+#define HFI_PROPERTY_CONFIG_VENC_FRAME_QP	\
+	(HFI_PROPERTY_CONFIG_VENC_OX_START + 0x1)
+
+#define HFI_PROPERTY_PARAM_VPE_OX_START	\
+	(HFI_DOMAIN_BASE_VPE + HFI_ARCH_OX_OFFSET + 0x7000)
+#define HFI_PROPERTY_PARAM_VPE_COLOR_SPACE_CONVERSION	\
+	(HFI_PROPERTY_PARAM_VPE_OX_START + 0x1)
+
+#define HFI_PROPERTY_CONFIG_VPE_OX_START	\
+	(HFI_DOMAIN_BASE_VPE + HFI_ARCH_OX_OFFSET + 0x8000)
+
+#define HFI_CHROMA_SITE_0			(HFI_OX_BASE + 0x1)
+#define HFI_CHROMA_SITE_1			(HFI_OX_BASE + 0x2)
+#define HFI_CHROMA_SITE_2			(HFI_OX_BASE + 0x3)
+#define HFI_CHROMA_SITE_3			(HFI_OX_BASE + 0x4)
+#define HFI_CHROMA_SITE_4			(HFI_OX_BASE + 0x5)
+#define HFI_CHROMA_SITE_5			(HFI_OX_BASE + 0x6)
+
+#define HFI_PRIORITY_LOW			10
+#define HFI_PRIOIRTY_MEDIUM			20
+#define HFI_PRIORITY_HIGH			30
+
+#define HFI_OUTPUT_ORDER_DISPLAY		(HFI_OX_BASE + 0x1)
+#define HFI_OUTPUT_ORDER_DECODE			(HFI_OX_BASE + 0x2)
+
+#define HFI_RATE_CONTROL_OFF			(HFI_OX_BASE + 0x1)
+#define HFI_RATE_CONTROL_VBR_VFR		(HFI_OX_BASE + 0x2)
+#define HFI_RATE_CONTROL_VBR_CFR		(HFI_OX_BASE + 0x3)
+#define HFI_RATE_CONTROL_CBR_VFR		(HFI_OX_BASE + 0x4)
+#define HFI_RATE_CONTROL_CBR_CFR		(HFI_OX_BASE + 0x5)
+
+#define HFI_VIDEO_CODEC_H264			0x00000002
+#define HFI_VIDEO_CODEC_H263			0x00000004
+#define HFI_VIDEO_CODEC_MPEG1			0x00000008
+#define HFI_VIDEO_CODEC_MPEG2			0x00000010
+#define HFI_VIDEO_CODEC_MPEG4			0x00000020
+#define HFI_VIDEO_CODEC_DIVX_311		0x00000040
+#define HFI_VIDEO_CODEC_DIVX			0x00000080
+#define HFI_VIDEO_CODEC_VC1			0x00000100
+#define HFI_VIDEO_CODEC_SPARK			0x00000200
+#define HFI_VIDEO_CODEC_VP8			0x00001000
+#define HFI_VIDEO_CODEC_HEVC			0x00002000
+#define HFI_VIDEO_CODEC_HEVC_HYBRID		0x00004000
+
+#define HFI_H264_PROFILE_BASELINE		0x00000001
+#define HFI_H264_PROFILE_MAIN			0x00000002
+#define HFI_H264_PROFILE_HIGH			0x00000004
+#define HFI_H264_PROFILE_STEREO_HIGH		0x00000008
+#define HFI_H264_PROFILE_MULTIVIEW_HIGH		0x00000010
+#define HFI_H264_PROFILE_CONSTRAINED_BASE	0x00000020
+#define HFI_H264_PROFILE_CONSTRAINED_HIGH	0x00000040
+
+#define HFI_H264_LEVEL_1			0x00000001
+#define HFI_H264_LEVEL_1b			0x00000002
+#define HFI_H264_LEVEL_11			0x00000004
+#define HFI_H264_LEVEL_12			0x00000008
+#define HFI_H264_LEVEL_13			0x00000010
+#define HFI_H264_LEVEL_2			0x00000020
+#define HFI_H264_LEVEL_21			0x00000040
+#define HFI_H264_LEVEL_22			0x00000080
+#define HFI_H264_LEVEL_3			0x00000100
+#define HFI_H264_LEVEL_31			0x00000200
+#define HFI_H264_LEVEL_32			0x00000400
+#define HFI_H264_LEVEL_4			0x00000800
+#define HFI_H264_LEVEL_41			0x00001000
+#define HFI_H264_LEVEL_42			0x00002000
+#define HFI_H264_LEVEL_5			0x00004000
+#define HFI_H264_LEVEL_51			0x00008000
+#define HFI_H264_LEVEL_52			0x00010000
+
+#define HFI_H263_PROFILE_BASELINE		0x00000001
+
+#define HFI_H263_LEVEL_10			0x00000001
+#define HFI_H263_LEVEL_20			0x00000002
+#define HFI_H263_LEVEL_30			0x00000004
+#define HFI_H263_LEVEL_40			0x00000008
+#define HFI_H263_LEVEL_45			0x00000010
+#define HFI_H263_LEVEL_50			0x00000020
+#define HFI_H263_LEVEL_60			0x00000040
+#define HFI_H263_LEVEL_70			0x00000080
+
+#define HFI_MPEG2_PROFILE_SIMPLE		0x00000001
+#define HFI_MPEG2_PROFILE_MAIN			0x00000002
+#define HFI_MPEG2_PROFILE_422			0x00000004
+#define HFI_MPEG2_PROFILE_SNR			0x00000008
+#define HFI_MPEG2_PROFILE_SPATIAL		0x00000010
+#define HFI_MPEG2_PROFILE_HIGH			0x00000020
+
+#define HFI_MPEG2_LEVEL_LL			0x00000001
+#define HFI_MPEG2_LEVEL_ML			0x00000002
+#define HFI_MPEG2_LEVEL_H14			0x00000004
+#define HFI_MPEG2_LEVEL_HL			0x00000008
+
+#define HFI_MPEG4_PROFILE_SIMPLE		0x00000001
+#define HFI_MPEG4_PROFILE_ADVANCEDSIMPLE	0x00000002
+
+#define HFI_MPEG4_LEVEL_0			0x00000001
+#define HFI_MPEG4_LEVEL_0b			0x00000002
+#define HFI_MPEG4_LEVEL_1			0x00000004
+#define HFI_MPEG4_LEVEL_2			0x00000008
+#define HFI_MPEG4_LEVEL_3			0x00000010
+#define HFI_MPEG4_LEVEL_4			0x00000020
+#define HFI_MPEG4_LEVEL_4a			0x00000040
+#define HFI_MPEG4_LEVEL_5			0x00000080
+#define HFI_MPEG4_LEVEL_6			0x00000100
+#define HFI_MPEG4_LEVEL_7			0x00000200
+#define HFI_MPEG4_LEVEL_8			0x00000400
+#define HFI_MPEG4_LEVEL_9			0x00000800
+#define HFI_MPEG4_LEVEL_3b			0x00001000
+
+#define HFI_VC1_PROFILE_SIMPLE			0x00000001
+#define HFI_VC1_PROFILE_MAIN			0x00000002
+#define HFI_VC1_PROFILE_ADVANCED		0x00000004
+
+#define HFI_VC1_LEVEL_LOW			0x00000001
+#define HFI_VC1_LEVEL_MEDIUM			0x00000002
+#define HFI_VC1_LEVEL_HIGH			0x00000004
+#define HFI_VC1_LEVEL_0				0x00000008
+#define HFI_VC1_LEVEL_1				0x00000010
+#define HFI_VC1_LEVEL_2				0x00000020
+#define HFI_VC1_LEVEL_3				0x00000040
+#define HFI_VC1_LEVEL_4				0x00000080
+
+#define HFI_VPX_PROFILE_SIMPLE			0x00000001
+#define HFI_VPX_PROFILE_ADVANCED		0x00000002
+#define HFI_VPX_PROFILE_VERSION_0		0x00000004
+#define HFI_VPX_PROFILE_VERSION_1		0x00000008
+#define HFI_VPX_PROFILE_VERSION_2		0x00000010
+#define HFI_VPX_PROFILE_VERSION_3		0x00000020
+
+#define HFI_DIVX_FORMAT_4			(HFI_COMMON_BASE + 0x1)
+#define HFI_DIVX_FORMAT_5			(HFI_COMMON_BASE + 0x2)
+#define HFI_DIVX_FORMAT_6			(HFI_COMMON_BASE + 0x3)
+
+#define HFI_DIVX_PROFILE_QMOBILE		0x00000001
+#define HFI_DIVX_PROFILE_MOBILE			0x00000002
+#define HFI_DIVX_PROFILE_MT			0x00000004
+#define HFI_DIVX_PROFILE_HT			0x00000008
+#define HFI_DIVX_PROFILE_HD			0x00000010
+
+#define HFI_HEVC_PROFILE_MAIN			0x00000001
+#define HFI_HEVC_PROFILE_MAIN10			0x00000002
+#define HFI_HEVC_PROFILE_MAIN_STILL_PIC		0x00000004
+
+#define HFI_HEVC_LEVEL_1			0x00000001
+#define HFI_HEVC_LEVEL_2			0x00000002
+#define HFI_HEVC_LEVEL_21			0x00000004
+#define HFI_HEVC_LEVEL_3			0x00000008
+#define HFI_HEVC_LEVEL_31			0x00000010
+#define HFI_HEVC_LEVEL_4			0x00000020
+#define HFI_HEVC_LEVEL_41			0x00000040
+#define HFI_HEVC_LEVEL_5			0x00000080
+#define HFI_HEVC_LEVEL_51			0x00000100
+#define HFI_HEVC_LEVEL_52			0x00000200
+#define HFI_HEVC_LEVEL_6			0x00000400
+#define HFI_HEVC_LEVEL_61			0x00000800
+#define HFI_HEVC_LEVEL_62			0x00001000
+
+#define HFI_HEVC_TIER_MAIN			0x1
+#define HFI_HEVC_TIER_HIGH0			0x2
+
+#define HFI_BUFFER_INPUT			(HFI_COMMON_BASE + 0x1)
+#define HFI_BUFFER_OUTPUT			(HFI_COMMON_BASE + 0x2)
+#define HFI_BUFFER_OUTPUT2			(HFI_COMMON_BASE + 0x3)
+#define HFI_BUFFER_INTERNAL_PERSIST		(HFI_COMMON_BASE + 0x4)
+#define HFI_BUFFER_INTERNAL_PERSIST_1		(HFI_COMMON_BASE + 0x5)
+#define HFI_BUFFER_INTERNAL_SCRATCH		(HFI_OX_BASE + 0x1)
+#define HFI_BUFFER_EXTRADATA_INPUT		(HFI_OX_BASE + 0x2)
+#define HFI_BUFFER_EXTRADATA_OUTPUT		(HFI_OX_BASE + 0x3)
+#define HFI_BUFFER_EXTRADATA_OUTPUT2		(HFI_OX_BASE + 0x4)
+#define HFI_BUFFER_INTERNAL_SCRATCH_1		(HFI_OX_BASE + 0x5)
+#define HFI_BUFFER_INTERNAL_SCRATCH_2		(HFI_OX_BASE + 0x6)
+
+#define HFI_BUFFER_TYPE_MAX			11
+
+#define HFI_BUFFER_MODE_STATIC			(HFI_OX_BASE + 0x1)
+#define HFI_BUFFER_MODE_RING			(HFI_OX_BASE + 0x2)
+#define HFI_BUFFER_MODE_DYNAMIC			(HFI_OX_BASE + 0x3)
+
+#define HFI_VENC_PERFMODE_MAX_QUALITY		0x1
+#define HFI_VENC_PERFMODE_POWER_SAVE		0x2
+
+#define HFI_PROPERTY_SYS_COMMON_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_COMMON_OFFSET + 0x0000)
+#define HFI_PROPERTY_SYS_DEBUG_CONFIG	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x1)
+#define HFI_PROPERTY_SYS_RESOURCE_OCMEM_REQUIREMENT_INFO	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x2)
+#define HFI_PROPERTY_SYS_CONFIG_VCODEC_CLKFREQ	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x3)
+#define HFI_PROPERTY_SYS_IDLE_INDICATOR	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x4)
+#define HFI_PROPERTY_SYS_CODEC_POWER_PLANE_CTRL	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x5)
+#define HFI_PROPERTY_SYS_IMAGE_VERSION	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x6)
+#define HFI_PROPERTY_SYS_CONFIG_COVERAGE	\
+	(HFI_PROPERTY_SYS_COMMON_START + 0x7)
+
+#define HFI_PROPERTY_PARAM_COMMON_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_COMMON_OFFSET + 0x1000)
+#define HFI_PROPERTY_PARAM_FRAME_SIZE	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x1)
+#define HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_INFO	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x2)
+#define HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x3)
+#define HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x4)
+#define HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x5)
+#define HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x6)
+#define HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x7)
+#define HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x8)
+#define HFI_PROPERTY_PARAM_CODEC_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0x9)
+#define HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xa)
+#define HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xb)
+#define HFI_PROPERTY_PARAM_MULTI_VIEW_FORMAT	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xc)
+#define  HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xd)
+#define  HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xe)
+#define HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT	\
+	(HFI_PROPERTY_PARAM_COMMON_START + 0xf)
+
+#define HFI_PROPERTY_CONFIG_COMMON_START	\
+	(HFI_DOMAIN_BASE_COMMON + HFI_ARCH_COMMON_OFFSET + 0x2000)
+#define HFI_PROPERTY_CONFIG_FRAME_RATE	\
+	(HFI_PROPERTY_CONFIG_COMMON_START + 0x1)
+
+#define HFI_PROPERTY_PARAM_VDEC_COMMON_START	\
+	(HFI_DOMAIN_BASE_VDEC + HFI_ARCH_COMMON_OFFSET + 0x3000)
+#define HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM	\
+	(HFI_PROPERTY_PARAM_VDEC_COMMON_START + 0x1)
+#define HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR	\
+	(HFI_PROPERTY_PARAM_VDEC_COMMON_START + 0x2)
+#define HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2	\
+	(HFI_PROPERTY_PARAM_VDEC_COMMON_START + 0x3)
+
+#define HFI_PROPERTY_CONFIG_VDEC_COMMON_START	\
+	(HFI_DOMAIN_BASE_VDEC + HFI_ARCH_COMMON_OFFSET + 0x4000)
+
+#define HFI_PROPERTY_PARAM_VENC_COMMON_START	\
+	(HFI_DOMAIN_BASE_VENC + HFI_ARCH_COMMON_OFFSET + 0x5000)
+#define HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1)
+#define HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x2)
+#define HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x3)
+#define HFI_PROPERTY_PARAM_VENC_RATE_CONTROL	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x4)
+#define HFI_PROPERTY_PARAM_VENC_H264_PICORDER_CNT_TYPE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x5)
+#define HFI_PROPERTY_PARAM_VENC_SESSION_QP	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x6)
+#define HFI_PROPERTY_PARAM_VENC_MPEG4_AC_PREDICTION	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x7)
+#define HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x8)
+#define HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x9)
+#define HFI_PROPERTY_PARAM_VENC_MPEG4_SHORT_HEADER	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xa)
+#define HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xb)
+#define HFI_PROPERTY_PARAM_VENC_OPEN_GOP	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xc)
+#define HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xd)
+#define HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xe)
+#define HFI_PROPERTY_PARAM_VENC_VBV_HRD_BUF_SIZE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0xf)
+#define HFI_PROPERTY_PARAM_VENC_QUALITY_VS_SPEED	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x10)
+#define HFI_PROPERTY_PARAM_VENC_ADVANCED	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x12)
+#define HFI_PROPERTY_PARAM_VENC_H264_SPS_ID	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x14)
+#define HFI_PROPERTY_PARAM_VENC_H264_PPS_ID	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x15)
+#define HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x16)
+#define HFI_PROPERTY_PARAM_VENC_ASPECT_RATIO	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x17)
+#define HFI_PROPERTY_PARAM_VENC_NUMREF	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x18)
+#define HFI_PROPERTY_PARAM_VENC_MULTIREF_P	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x19)
+#define HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1b)
+#define HFI_PROPERTY_PARAM_VENC_LTRMODE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1c)
+#define HFI_PROPERTY_PARAM_VENC_VIDEO_FULL_RANGE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1d)
+#define HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1e)
+#define HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x1f)
+#define HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x20)
+#define HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x21)
+#define HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x23)
+#define HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x26)
+#define HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x27)
+#define HFI_PROPERTY_PARAM_VENC_INITIAL_QP	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x28)
+#define HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x29)
+#define HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x2c)
+#define HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE	\
+	(HFI_PROPERTY_PARAM_VENC_COMMON_START + 0x2f)
+
+#define HFI_PROPERTY_CONFIG_VENC_COMMON_START	\
+	(HFI_DOMAIN_BASE_VENC + HFI_ARCH_COMMON_OFFSET + 0x6000)
+#define HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x1)
+#define HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x2)
+#define HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x3)
+#define HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x4)
+#define HFI_PROPERTY_CONFIG_VENC_SLICE_SIZE	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x5)
+#define HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x7)
+
+#define HFI_PROPERTY_PARAM_VPE_COMMON_START	\
+	(HFI_DOMAIN_BASE_VPE + HFI_ARCH_COMMON_OFFSET + 0x7000)
+#define HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x8)
+#define HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0x9)
+#define HFI_PROPERTY_CONFIG_VENC_USELTRFRAME	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0xa)
+#define HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0xb)
+#define HFI_PROPERTY_CONFIG_VENC_LTRPERIOD	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0xc)
+#define HFI_PROPERTY_CONFIG_VENC_PERF_MODE	\
+	(HFI_PROPERTY_CONFIG_VENC_COMMON_START + 0xe)
+
+#define HFI_PROPERTY_CONFIG_VPE_COMMON_START	\
+	(HFI_DOMAIN_BASE_VPE + HFI_ARCH_COMMON_OFFSET + 0x8000)
+#define HFI_PROPERTY_CONFIG_VPE_DEINTERLACE	\
+	(HFI_PROPERTY_CONFIG_VPE_COMMON_START + 0x1)
+#define HFI_PROPERTY_CONFIG_VPE_OPERATIONS	\
+	(HFI_PROPERTY_CONFIG_VPE_COMMON_START + 0x2)
+
+enum hfi_packetization_type {
+	HFI_PACKETIZATION_LEGACY,
+	HFI_PACKETIZATION_3XX,
+};
+
+struct hfi_buffer_info {
+	u32 buffer_addr;
+	u32 extradata_addr;
+};
+
+struct hfi_bitrate {
+	u32 bitrate;
+	u32 layer_id;
+};
+
+#define HFI_CAPABILITY_FRAME_WIDTH			(HFI_COMMON_BASE + 0x1)
+#define HFI_CAPABILITY_FRAME_HEIGHT			(HFI_COMMON_BASE + 0x2)
+#define HFI_CAPABILITY_MBS_PER_FRAME			(HFI_COMMON_BASE + 0x3)
+#define HFI_CAPABILITY_MBS_PER_SECOND			(HFI_COMMON_BASE + 0x4)
+#define HFI_CAPABILITY_FRAMERATE			(HFI_COMMON_BASE + 0x5)
+#define HFI_CAPABILITY_SCALE_X				(HFI_COMMON_BASE + 0x6)
+#define HFI_CAPABILITY_SCALE_Y				(HFI_COMMON_BASE + 0x7)
+#define HFI_CAPABILITY_BITRATE				(HFI_COMMON_BASE + 0x8)
+#define HFI_CAPABILITY_BFRAME				(HFI_COMMON_BASE + 0x9)
+#define HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS		(HFI_COMMON_BASE + 0x10)
+#define HFI_CAPABILITY_ENC_LTR_COUNT			(HFI_COMMON_BASE + 0x11)
+#define HFI_CAPABILITY_CP_OUTPUT2_THRESH		(HFI_COMMON_BASE + 0x12)
+#define HFI_CAPABILITY_HIER_P_HYBRID_NUM_ENH_LAYERS	(HFI_COMMON_BASE + 0x15)
+
+struct hfi_capability {
+	u32 capability_type;
+	u32 min;
+	u32 max;
+	u32 step_size;
+};
+
+struct hfi_capabilities {
+	u32 num_capabilities;
+	struct hfi_capability data[1];
+};
+
+#define HFI_DEBUG_MSG_LOW	0x00000001
+#define HFI_DEBUG_MSG_MEDIUM	0x00000002
+#define HFI_DEBUG_MSG_HIGH	0x00000004
+#define HFI_DEBUG_MSG_ERROR	0x00000008
+#define HFI_DEBUG_MSG_FATAL	0x00000010
+#define HFI_DEBUG_MSG_PERF	0x00000020
+
+#define HFI_DEBUG_MODE_QUEUE	0x00000001
+#define HFI_DEBUG_MODE_QDSS	0x00000002
+
+struct hfi_debug_config {
+	u32 config;
+	u32 mode;
+};
+
+struct hfi_enable {
+	u32 enable;
+};
+
+#define HFI_H264_DB_MODE_DISABLE		(HFI_COMMON_BASE + 0x1)
+#define HFI_H264_DB_MODE_SKIP_SLICE_BOUNDARY	(HFI_COMMON_BASE + 0x2)
+#define HFI_H264_DB_MODE_ALL_BOUNDARY		(HFI_COMMON_BASE + 0x3)
+
+struct hfi_h264_db_control {
+	u32 mode;
+	u32 slice_alpha_offset;
+	u32 slice_beta_offset;
+};
+
+#define HFI_H264_ENTROPY_CAVLC			(HFI_COMMON_BASE + 0x1)
+#define HFI_H264_ENTROPY_CABAC			(HFI_COMMON_BASE + 0x2)
+
+#define HFI_H264_CABAC_MODEL_0			(HFI_COMMON_BASE + 0x1)
+#define HFI_H264_CABAC_MODEL_1			(HFI_COMMON_BASE + 0x2)
+#define HFI_H264_CABAC_MODEL_2			(HFI_COMMON_BASE + 0x3)
+
+struct hfi_h264_entropy_control {
+	u32 entropy_mode;
+	u32 cabac_model;
+};
+
+struct hfi_framerate {
+	u32 buffer_type;
+	u32 framerate;
+};
+
+#define HFI_INTRA_REFRESH_NONE			(HFI_COMMON_BASE + 0x1)
+#define HFI_INTRA_REFRESH_CYCLIC		(HFI_COMMON_BASE + 0x2)
+#define HFI_INTRA_REFRESH_ADAPTIVE		(HFI_COMMON_BASE + 0x3)
+#define HFI_INTRA_REFRESH_CYCLIC_ADAPTIVE	(HFI_COMMON_BASE + 0x4)
+#define HFI_INTRA_REFRESH_RANDOM		(HFI_COMMON_BASE + 0x5)
+
+struct hfi_intra_refresh {
+	u32 mode;
+	u32 air_mbs;
+	u32 air_ref;
+	u32 cir_mbs;
+};
+
+struct hfi_intra_refresh_3x {
+	u32 mode;
+	u32 mbs;
+};
+
+struct hfi_idr_period {
+	u32 idr_period;
+};
+
+struct hfi_operations_type {
+	u32 rotation;
+	u32 flip;
+};
+
+struct hfi_max_num_b_frames {
+	u32 max_num_b_frames;
+};
+
+struct hfi_vc1e_perf_cfg_type {
+	u32 search_range_x_subsampled[3];
+	u32 search_range_y_subsampled[3];
+};
+
+struct hfi_conceal_color {
+	u32 conceal_color;
+};
+
+struct hfi_intra_period {
+	u32 pframes;
+	u32 bframes;
+};
+
+struct hfi_mpeg4_header_extension {
+	u32 header_extension;
+};
+
+struct hfi_mpeg4_time_resolution {
+	u32 time_increment_resolution;
+};
+
+struct hfi_multi_stream {
+	u32 buffer_type;
+	u32 enable;
+	u32 width;
+	u32 height;
+};
+
+struct hfi_multi_stream_3x {
+	u32 buffer_type;
+	u32 enable;
+};
+
+struct hfi_multi_view_format {
+	u32 views;
+	u32 view_order[1];
+};
+
+#define HFI_MULTI_SLICE_OFF			(HFI_COMMON_BASE + 0x1)
+#define HFI_MULTI_SLICE_BY_MB_COUNT		(HFI_COMMON_BASE + 0x2)
+#define HFI_MULTI_SLICE_BY_BYTE_COUNT		(HFI_COMMON_BASE + 0x3)
+#define HFI_MULTI_SLICE_GOB			(HFI_COMMON_BASE + 0x4)
+
+struct hfi_multi_slice_control {
+	u32 multi_slice;
+	u32 slice_size;
+};
+
+#define HFI_NAL_FORMAT_STARTCODES		0x1
+#define HFI_NAL_FORMAT_ONE_NAL_PER_BUFFER	0x2
+#define HFI_NAL_FORMAT_ONE_BYTE_LENGTH		0x4
+#define HFI_NAL_FORMAT_TWO_BYTE_LENGTH		0x8
+#define HFI_NAL_FORMAT_FOUR_BYTE_LENGTH		0x10
+
+struct hfi_nal_stream_format {
+	u32 format;
+};
+
+struct hfi_nal_stream_format_select {
+	u32 format;
+};
+
+#define HFI_PICTURE_TYPE_I			0x01
+#define HFI_PICTURE_TYPE_P			0x02
+#define HFI_PICTURE_TYPE_B			0x04
+#define HFI_PICTURE_TYPE_IDR			0x08
+
+struct hfi_profile_level {
+	u32 profile;
+	u32 level;
+};
+
+#define HFI_MAX_PROFILE_COUNT			16
+
+struct hfi_profile_level_supported {
+	u32 profile_count;
+	struct hfi_profile_level profile_level[1];
+};
+
+struct hfi_quality_vs_speed {
+	u32 quality_vs_speed;
+};
+
+struct hfi_quantization {
+	u32 qp_i;
+	u32 qp_p;
+	u32 qp_b;
+	u32 layer_id;
+};
+
+struct hfi_initial_quantization {
+	u32 qp_i;
+	u32 qp_p;
+	u32 qp_b;
+	u32 init_qp_enable;
+};
+
+struct hfi_quantization_range {
+	u32 min_qp;
+	u32 max_qp;
+	u32 layer_id;
+};
+
+#define HFI_LTR_MODE_DISABLE	0x0
+#define HFI_LTR_MODE_MANUAL	0x1
+#define HFI_LTR_MODE_PERIODIC	0x2
+
+struct hfi_ltr_mode {
+	u32 ltr_mode;
+	u32 ltr_count;
+	u32 trust_mode;
+};
+
+struct hfi_ltr_use {
+	u32 ref_ltr;
+	u32 use_constrnt;
+	u32 frames;
+};
+
+struct hfi_ltr_mark {
+	u32 mark_frame;
+};
+
+struct hfi_framesize {
+	u32 buffer_type;
+	u32 width;
+	u32 height;
+};
+
+struct hfi_h264_vui_timing_info {
+	u32 enable;
+	u32 fixed_framerate;
+	u32 time_scale;
+};
+
+#define HFI_COLOR_FORMAT_MONOCHROME		(HFI_COMMON_BASE + 0x1)
+#define HFI_COLOR_FORMAT_NV12			(HFI_COMMON_BASE + 0x2)
+#define HFI_COLOR_FORMAT_NV21			(HFI_COMMON_BASE + 0x3)
+#define HFI_COLOR_FORMAT_NV12_4x4TILE		(HFI_COMMON_BASE + 0x4)
+#define HFI_COLOR_FORMAT_NV21_4x4TILE		(HFI_COMMON_BASE + 0x5)
+#define HFI_COLOR_FORMAT_YUYV			(HFI_COMMON_BASE + 0x6)
+#define HFI_COLOR_FORMAT_YVYU			(HFI_COMMON_BASE + 0x7)
+#define HFI_COLOR_FORMAT_UYVY			(HFI_COMMON_BASE + 0x8)
+#define HFI_COLOR_FORMAT_VYUY			(HFI_COMMON_BASE + 0x9)
+#define HFI_COLOR_FORMAT_RGB565			(HFI_COMMON_BASE + 0xa)
+#define HFI_COLOR_FORMAT_BGR565			(HFI_COMMON_BASE + 0xb)
+#define HFI_COLOR_FORMAT_RGB888			(HFI_COMMON_BASE + 0xc)
+#define HFI_COLOR_FORMAT_BGR888			(HFI_COMMON_BASE + 0xd)
+#define HFI_COLOR_FORMAT_YUV444			(HFI_COMMON_BASE + 0xe)
+#define HFI_COLOR_FORMAT_RGBA8888		(HFI_COMMON_BASE + 0x10)
+
+#define HFI_COLOR_FORMAT_UBWC_BASE		0x8000
+#define HFI_COLOR_FORMAT_10_BIT_BASE		0x4000
+
+#define HFI_COLOR_FORMAT_YUV420_TP10	\
+	(HFI_COLOR_FORMAT_10_BIT_BASE + HFI_COLOR_FORMAT_NV12)
+#define HFI_COLOR_FORMAT_NV12_UBWC	\
+	(HFI_COLOR_FORMAT_UBWC_BASE + HFI_COLOR_FORMAT_NV12)
+#define HFI_COLOR_FORMAT_YUV420_TP10_UBWC	\
+	(HFI_COLOR_FORMAT_UBWC_BASE + HFI_COLOR_FORMAT_YUV420_TP10)
+#define HFI_COLOR_FORMAT_RGBA8888_UBWC	\
+	(HFI_COLOR_FORMAT_UBWC_BASE + HFI_COLOR_FORMAT_RGBA8888)
+
+struct hfi_uncompressed_format_select {
+	u32 buffer_type;
+	u32 format;
+};
+
+struct hfi_uncompressed_format_supported {
+	u32 buffer_type;
+	u32 format_entries;
+	u32 format_info[1];
+};
+
+struct hfi_uncompressed_plane_actual {
+	int actual_stride;
+	u32 actual_plane_buffer_height;
+};
+
+struct hfi_uncompressed_plane_actual_info {
+	u32 buffer_type;
+	u32 num_planes;
+	struct hfi_uncompressed_plane_actual plane_format[1];
+};
+
+struct hfi_uncompressed_plane_constraints {
+	u32 stride_multiples;
+	u32 max_stride;
+	u32 min_plane_buffer_height_multiple;
+	u32 buffer_alignment;
+};
+
+struct hfi_uncompressed_plane_info {
+	u32 format;
+	u32 num_planes;
+	struct hfi_uncompressed_plane_constraints plane_format[1];
+};
+
+struct hfi_uncompressed_plane_actual_constraints_info {
+	u32 buffer_type;
+	u32 num_planes;
+	struct hfi_uncompressed_plane_constraints plane_format[1];
+};
+
+struct hfi_codec_supported {
+	u32 dec_codecs;
+	u32 enc_codecs;
+};
+
+struct hfi_properties_supported {
+	u32 num_properties;
+	u32 properties[1];
+};
+
+#define HFI_MAX_MATRIX_COEFFS	9
+#define HFI_MAX_BIAS_COEFFS	3
+#define HFI_MAX_LIMIT_COEFFS	6
+
+struct hfi_vpe_color_space_conversion {
+	u32 csc_matrix[HFI_MAX_MATRIX_COEFFS];
+	u32 csc_bias[HFI_MAX_BIAS_COEFFS];
+	u32 csc_limit[HFI_MAX_LIMIT_COEFFS];
+};
+
+#define HFI_ROTATE_NONE		(HFI_COMMON_BASE + 0x1)
+#define HFI_ROTATE_90		(HFI_COMMON_BASE + 0x2)
+#define HFI_ROTATE_180		(HFI_COMMON_BASE + 0x3)
+#define HFI_ROTATE_270		(HFI_COMMON_BASE + 0x4)
+
+#define HFI_FLIP_NONE		(HFI_COMMON_BASE + 0x1)
+#define HFI_FLIP_HORIZONTAL	(HFI_COMMON_BASE + 0x2)
+#define HFI_FLIP_VERTICAL	(HFI_COMMON_BASE + 0x3)
+
+struct hfi_operations {
+	u32 rotate;
+	u32 flip;
+};
+
+#define HFI_RESOURCE_OCMEM	0x1
+
+struct hfi_resource_ocmem {
+	u32 size;
+	u32 mem;
+};
+
+struct hfi_resource_ocmem_requirement {
+	u32 session_domain;
+	u32 width;
+	u32 height;
+	u32 size;
+};
+
+struct hfi_resource_ocmem_requirement_info {
+	u32 num_entries;
+	struct hfi_resource_ocmem_requirement requirements[1];
+};
+
+struct hfi_property_sys_image_version_info_type {
+	u32 string_size;
+	u8  str_image_version[1];
+};
+
+struct hfi_seq_header_info {
+	u32 max_hader_len;
+};
+struct hfi_aspect_ratio {
+	u32 aspect_width;
+	u32 aspect_height;
+};
+#define HFI_MVC_BUFFER_LAYOUT_TOP_BOTTOM	0
+#define HFI_MVC_BUFFER_LAYOUT_SIDEBYSIDE	1
+#define HFI_MVC_BUFFER_LAYOUT_SEQ		2
+
+struct hfi_mvc_buffer_layout_descp_type {
+	u32 layout_type;
+	u32 bright_view_first;
+	u32 ngap;
+};
+
+struct hfi_scs_threshold {
+	u32 threshold_value;
+};
+
+#define HFI_TEST_SSR_SW_ERR_FATAL	0x1
+#define HFI_TEST_SSR_SW_DIV_BY_ZERO	0x2
+#define HFI_TEST_SSR_HW_WDOG_IRQ	0x3
+
+struct hfi_buffer_alloc_mode {
+	u32 type;
+	u32 mode;
+};
+
+struct hfi_index_extradata_config {
+	u32 enable;
+	u32 index_extra_data_id;
+};
+
+struct hfi_extradata_header {
+	u32 size;
+	u32 version;
+	u32 port_index;
+	u32 type;
+	u32 data_size;
+	u8 data[1];
+};
+
+struct hfi_batch_info {
+	u32 input_batch_count;
+	u32 output_batch_count;
+};
+
+struct hfi_buffer_count_actual {
+	u32 type;
+	u32 count_actual;
+};
+
+struct hfi_buffer_size_actual {
+	u32 type;
+	u32 size;
+};
+
+struct hfi_buffer_display_hold_count_actual {
+	u32 type;
+	u32 hold_count;
+};
+
+struct hfi_buffer_requirements {
+	u32 type;
+	u32 size;
+	u32 region_size;
+	u32 hold_count;
+	u32 count_min;
+	u32 count_actual;
+	u32 contiguous;
+	u32 alignment;
+};
+
+struct hfi_data_payload {
+	u32 size;
+	u8 data[1];
+};
+
+struct hfi_enable_picture {
+	u32 picture_type;
+};
+
+struct hfi_display_picture_buffer_count {
+	int enable;
+	u32 count;
+};
+
+struct hfi_extra_data_header_config {
+	u32 type;
+	u32 buffer_type;
+	u32 version;
+	u32 port_index;
+	u32 client_extra_data_id;
+};
+
+struct hfi_interlace_format_supported {
+	u32 buffer_type;
+	u32 format;
+};
+
+struct hfi_buffer_alloc_mode_supported {
+	u32 buffer_type;
+	u32 num_entries;
+	u32 data[1];
+};
+
+struct hfi_mb_error_map {
+	u32 error_map_size;
+	u8 error_map[1];
+};
+
+struct hfi_metadata_pass_through {
+	int enable;
+	u32 size;
+};
+
+struct hfi_multi_view_select {
+	u32 view_index;
+};
+
+struct hfi_hybrid_hierp {
+	u32 layers;
+};
+
+struct hfi_pkt_hdr {
+	u32 size;
+	u32 pkt_type;
+};
+
+struct hfi_session_hdr_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 session_id;
+};
+
+struct hfi_session_pkt {
+	struct hfi_session_hdr_pkt shdr;
+};
+
+#endif
diff --git a/drivers/media/platform/qcom/vidc/hfi_msgs.c b/drivers/media/platform/qcom/vidc/hfi_msgs.c
new file mode 100644
index 000000000000..0f390af30d6d
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi_msgs.c
@@ -0,0 +1,1072 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "hfi.h"
+#include "hfi_helper.h"
+#include "hfi_msgs.h"
+
+struct hfi_msg_fbd {
+	u32 stream_id;
+	u32 view_id;
+	u32 timestamp_hi;
+	u32 timestamp_lo;
+	u32 flags1;
+	u32 mark_target;
+	u32 mark_data;
+	u32 stats;
+	u32 alloc_len1;
+	u32 filled_len1;
+	u32 offset1;
+	u32 frame_width;
+	u32 frame_height;
+	u32 start_x_coord;
+	u32 start_y_coord;
+	u32 input_tag;
+	u32 input_tag1;
+	u32 picture_type;
+	u32 packet_buffer1;
+	u32 extradata_buffer;
+	u32 flags2;
+	u32 alloc_len2;
+	u32 filled_len2;
+	u32 offset2;
+	u32 packet_buffer2;
+	u32 flags3;
+	u32 alloc_len3;
+	u32 filled_len3;
+	u32 offset3;
+	u32 packet_buffer3;
+	u32 buffer_type;
+};
+
+static struct hfi_inst *to_hfi_instance(struct hfi_core *hfi, u32 session_id)
+{
+	struct hfi_inst *inst;
+
+	mutex_lock(&hfi->lock);
+	list_for_each_entry(inst, &hfi->instances, list)
+		if (hash32_ptr(inst) == session_id) {
+			mutex_unlock(&hfi->lock);
+			return inst;
+		}
+	mutex_unlock(&hfi->lock);
+
+	return NULL;
+}
+
+static void event_seq_changed(struct hfi_core *hfi, struct hfi_inst *inst,
+			      struct hfi_msg_event_notify_pkt *pkt)
+{
+	struct device *dev = hfi->dev;
+	struct hfi_event_data event = {0};
+	int num_properties_changed;
+	struct hfi_framesize *frame_sz;
+	struct hfi_profile_level *profile_level;
+	u8 *data_ptr;
+	u32 ptype;
+
+	inst->error = HFI_ERR_NONE;
+
+	switch (pkt->event_data1) {
+	case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES:
+	case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES:
+		break;
+	default:
+		inst->error = HFI_ERR_SESSION_INVALID_PARAMETER;
+		goto done;
+	}
+
+	event.event_type = pkt->event_data1;
+
+	num_properties_changed = pkt->event_data2;
+	if (!num_properties_changed) {
+		inst->error = HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
+		goto done;
+	}
+
+	data_ptr = (u8 *) &pkt->ext_event_data[0];
+	do {
+		ptype = *((u32 *)data_ptr);
+		switch (ptype) {
+		case HFI_PROPERTY_PARAM_FRAME_SIZE:
+			data_ptr += sizeof(u32);
+			frame_sz = (struct hfi_framesize *) data_ptr;
+			event.width = frame_sz->width;
+			event.height = frame_sz->height;
+			data_ptr += sizeof(frame_sz);
+			dev_dbg(dev, "%s cmd: frame size: %ux%u\n",
+				__func__, event.width, event.height);
+			break;
+		case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:
+			data_ptr += sizeof(u32);
+			profile_level = (struct hfi_profile_level *) data_ptr;
+			event.profile = profile_level->profile;
+			event.level = profile_level->level;
+			data_ptr += sizeof(profile_level);
+			dev_dbg(dev, "%s cmd: profile-level: %u - %u\n",
+				__func__, event.profile, event.level);
+			break;
+		default:
+			dev_dbg(dev, "%s cmd: %#x not supported\n",
+				__func__, ptype);
+			break;
+		}
+		num_properties_changed--;
+	} while (num_properties_changed > 0);
+
+done:
+	inst->ops->event_notify(inst, EVT_SYS_EVENT_CHANGE, &event);
+}
+
+static void event_release_buffer_ref(struct hfi_core *hfi,
+				     struct hfi_inst *inst,
+				     struct hfi_msg_event_notify_pkt *pkt)
+{
+	struct hfi_event_data event = {0};
+	struct hfi_msg_event_release_buffer_ref_pkt *data;
+
+	data = (struct hfi_msg_event_release_buffer_ref_pkt *)
+		pkt->ext_event_data;
+
+	event.event_type = HFI_EVENT_RELEASE_BUFFER_REFERENCE;
+	event.packet_buffer = data->packet_buffer;
+	event.extradata_buffer = data->extradata_buffer;
+
+	inst->error = HFI_ERR_NONE;
+	inst->ops->event_notify(inst, EVT_SYS_EVENT_CHANGE, &event);
+}
+
+static void event_sys_error(struct hfi_core *hfi, u32 event)
+{
+	hfi->core_ops->event_notify(hfi, event);
+}
+
+static void event_session_error(struct hfi_core *hfi, struct hfi_inst *inst,
+				struct hfi_msg_event_notify_pkt *pkt)
+{
+	struct device *dev = hfi->dev;
+
+	dev_dbg(dev, "session error: event id:%x, session id:%x\n",
+		pkt->event_data1, pkt->shdr.session_id);
+
+	if (!inst)
+		return;
+
+	switch (pkt->event_data1) {
+	/* non fatal session errors */
+	case HFI_ERR_SESSION_INVALID_SCALE_FACTOR:
+	case HFI_ERR_SESSION_UNSUPPORT_BUFFERTYPE:
+	case HFI_ERR_SESSION_UNSUPPORTED_SETTING:
+	case HFI_ERR_SESSION_UPSCALE_NOT_SUPPORTED:
+		inst->error = HFI_ERR_NONE;
+		break;
+	default:
+		dev_err(dev, "session error: event id:%x, session id:%x\n",
+			pkt->event_data1, pkt->shdr.session_id);
+
+		inst->error = pkt->event_data1;
+		inst->ops->event_notify(inst, EVT_SESSION_ERROR, NULL);
+		break;
+	}
+}
+
+static void hfi_event_notify(struct hfi_core *hfi, struct hfi_inst *inst,
+			     void *packet)
+{
+	struct hfi_msg_event_notify_pkt *pkt = packet;
+
+	if (!packet) {
+		dev_err(hfi->dev, "invalid packet\n");
+		return;
+	}
+
+	switch (pkt->event_id) {
+	case HFI_EVENT_SYS_ERROR:
+		event_sys_error(hfi, EVT_SYS_ERROR);
+		break;
+	case HFI_EVENT_SESSION_ERROR:
+		event_session_error(hfi, inst, pkt);
+		break;
+	case HFI_EVENT_SESSION_SEQUENCE_CHANGED:
+		event_seq_changed(hfi, inst, pkt);
+		break;
+	case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
+		event_release_buffer_ref(hfi, inst, pkt);
+		break;
+	case HFI_EVENT_SESSION_PROPERTY_CHANGED:
+		break;
+	default:
+		break;
+	}
+}
+
+static void hfi_sys_init_done(struct hfi_core *hfi, struct hfi_inst *inst,
+			      void *packet)
+{
+	struct hfi_msg_sys_init_done_pkt *pkt = packet;
+	u32 enc_codecs = 0, dec_codecs = 0;
+	u32 rem_bytes, read_bytes = 0, num_properties;
+	u8 *data_ptr;
+	u32 error;
+	u32 ptype;
+
+	error = pkt->error_type;
+	if (error != HFI_ERR_NONE)
+		goto err_no_prop;
+
+	num_properties = pkt->num_properties;
+
+	if (!num_properties) {
+		error = HFI_ERR_SYS_INVALID_PARAMETER;
+		goto err_no_prop;
+	}
+
+	rem_bytes = pkt->hdr.size - sizeof(*pkt) + sizeof(u32);
+
+	if (!rem_bytes) {
+		/* missing property data */
+		error = HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
+		goto err_no_prop;
+	}
+
+	data_ptr = (u8 *)&pkt->data[0];
+
+	while (num_properties && rem_bytes >= sizeof(u32)) {
+		ptype = *((u32 *)data_ptr);
+		data_ptr += sizeof(u32);
+
+		switch (ptype) {
+		case HFI_PROPERTY_PARAM_CODEC_SUPPORTED: {
+			struct hfi_codec_supported *prop;
+
+			prop = (struct hfi_codec_supported *)data_ptr;
+
+			if (rem_bytes < sizeof(*prop)) {
+				error = HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
+				break;
+			}
+			dec_codecs = prop->dec_codecs;
+			enc_codecs = prop->enc_codecs;
+			break;
+		}
+		default:
+			error = HFI_ERR_SYS_INVALID_PARAMETER;
+			break;
+		}
+
+		if (!error) {
+			rem_bytes -= read_bytes;
+			data_ptr += read_bytes;
+			num_properties--;
+		}
+	}
+
+	hfi->enc_codecs = enc_codecs;
+	hfi->dec_codecs = dec_codecs;
+
+err_no_prop:
+	hfi->error = error;
+	complete(&hfi->done);
+}
+
+static void
+sys_get_prop_image_version(struct device *dev,
+			   struct hfi_msg_sys_property_info_pkt *pkt)
+{
+	int req_bytes;
+
+	req_bytes = pkt->hdr.size - sizeof(*pkt);
+
+	if (req_bytes < 128 || !pkt->data[1] || pkt->num_properties > 1)
+		/* bad packet */
+		return;
+
+	dev_dbg(dev, "F/W version: %s\n", (u8 *)&pkt->data[1]);
+}
+
+static void hfi_sys_property_info(struct hfi_core *hfi, struct hfi_inst *inst,
+				  void *packet)
+{
+	struct hfi_msg_sys_property_info_pkt *pkt = packet;
+	struct device *dev = hfi->dev;
+
+	if (!pkt->num_properties) {
+		dev_dbg(dev, "%s: no properties\n", __func__);
+		return;
+	}
+
+	switch (pkt->data[0]) {
+	case HFI_PROPERTY_SYS_IMAGE_VERSION:
+		sys_get_prop_image_version(dev, pkt);
+		break;
+	default:
+		dev_dbg(dev, "%s: unknown property data\n", __func__);
+		break;
+	}
+}
+
+static void hfi_sys_rel_resource_done(struct hfi_core *hfi,
+				      struct hfi_inst *inst,
+				      void *packet)
+{
+	struct hfi_msg_sys_release_resource_done_pkt *pkt = packet;
+
+	hfi->error = pkt->error_type;
+	complete(&hfi->done);
+}
+
+static void hfi_sys_ping_done(struct hfi_core *hfi, struct hfi_inst *inst,
+			      void *packet)
+{
+	struct hfi_msg_sys_ping_ack_pkt *pkt = packet;
+
+	hfi->error = HFI_ERR_NONE;
+
+	if (pkt->client_data != 0xbeef)
+		hfi->error = HFI_ERR_SYS_FATAL;
+
+	complete(&hfi->done);
+}
+
+static void hfi_sys_idle_done(struct hfi_core *hfi, struct hfi_inst *inst,
+			      void *packet)
+{
+	dev_dbg(hfi->dev, "sys idle\n");
+}
+
+static void hfi_sys_pc_prepare_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				    void *packet)
+{
+	struct hfi_msg_sys_pc_prep_done_pkt *pkt = packet;
+
+	dev_dbg(hfi->dev, "pc prepare done (error %x)\n", pkt->error_type);
+}
+
+static void hfi_copy_cap_prop(struct hfi_capability *in, struct hfi_inst *inst)
+{
+	if (!in || !inst)
+		return;
+
+	switch (in->capability_type) {
+	case HFI_CAPABILITY_FRAME_WIDTH:
+		inst->width = *in;
+		break;
+	case HFI_CAPABILITY_FRAME_HEIGHT:
+		inst->height = *in;
+		break;
+	case HFI_CAPABILITY_MBS_PER_FRAME:
+		inst->mbs_per_frame = *in;
+		break;
+	case HFI_CAPABILITY_MBS_PER_SECOND:
+		inst->mbs_per_sec = *in;
+		break;
+	case HFI_CAPABILITY_FRAMERATE:
+		inst->framerate = *in;
+		break;
+	case HFI_CAPABILITY_SCALE_X:
+		inst->scale_x = *in;
+		break;
+	case HFI_CAPABILITY_SCALE_Y:
+		inst->scale_y = *in;
+		break;
+	case HFI_CAPABILITY_BITRATE:
+		inst->bitrate = *in;
+		break;
+	case HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS:
+		inst->hier_p = *in;
+		break;
+	case HFI_CAPABILITY_ENC_LTR_COUNT:
+		inst->ltr_count = *in;
+		break;
+	case HFI_CAPABILITY_CP_OUTPUT2_THRESH:
+		inst->secure_output2_threshold = *in;
+		break;
+	default:
+		break;
+	}
+}
+
+static unsigned int
+session_get_prop_profile_level(struct hfi_msg_session_property_info_pkt *pkt,
+			       struct hfi_profile_level *profile_level)
+{
+	struct hfi_profile_level *hfi;
+	u32 req_bytes;
+
+	req_bytes = pkt->shdr.hdr.size - sizeof(*pkt);
+
+	if (!req_bytes || req_bytes % sizeof(struct hfi_profile_level))
+		/* bad packet */
+		return HFI_ERR_SESSION_INVALID_PARAMETER;
+
+	hfi = (struct hfi_profile_level *)&pkt->data[1];
+	profile_level->profile = hfi->profile;
+	profile_level->level = hfi->level;
+
+	return HFI_ERR_NONE;
+}
+
+static unsigned int
+session_get_prop_buf_req(struct hfi_msg_session_property_info_pkt *pkt,
+			 struct hfi_buffer_requirements *bufreq)
+{
+	struct hfi_buffer_requirements *buf_req;
+	u32 req_bytes;
+	unsigned int idx = 0;
+
+	req_bytes = pkt->shdr.hdr.size - sizeof(*pkt);
+
+	if (!req_bytes || req_bytes % sizeof(*buf_req) || !pkt->data[1])
+		/* bad packet */
+		return HFI_ERR_SESSION_INVALID_PARAMETER;
+
+	buf_req = (struct hfi_buffer_requirements *)&pkt->data[1];
+	if (!buf_req)
+		return HFI_ERR_SESSION_INVALID_PARAMETER;
+
+	while (req_bytes) {
+		memcpy(&bufreq[idx], buf_req, sizeof(*bufreq));
+		idx++;
+
+		if (idx > HFI_BUFFER_TYPE_MAX)
+			return HFI_ERR_SESSION_INVALID_PARAMETER;
+
+		req_bytes -= sizeof(struct hfi_buffer_requirements);
+		buf_req++;
+	}
+
+	return HFI_ERR_NONE;
+}
+
+static void hfi_session_prop_info(struct hfi_core *hfi, struct hfi_inst *inst,
+				  void *packet)
+{
+	struct hfi_msg_session_property_info_pkt *pkt = packet;
+	struct device *dev = hfi->dev;
+	union hfi_get_property *hprop = &inst->hprop;
+	unsigned int error = HFI_ERR_NONE;
+
+	if (!pkt->num_properties) {
+		error = HFI_ERR_SESSION_INVALID_PARAMETER;
+		dev_err(dev, "%s: no properties\n", __func__);
+		goto done;
+	}
+
+	switch (pkt->data[0]) {
+	case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
+		memset(hprop->bufreq, 0, sizeof(hprop->bufreq));
+		error = session_get_prop_buf_req(pkt, hprop->bufreq);
+		break;
+	case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:
+		memset(&hprop->profile_level, 0, sizeof(hprop->profile_level));
+		error = session_get_prop_profile_level(pkt,
+						       &hprop->profile_level);
+		break;
+	default:
+		dev_dbg(dev, "%s: unknown property id:%x\n", __func__,
+			pkt->data[0]);
+		return;
+	}
+
+done:
+	inst->error = error;
+	complete(&inst->done);
+}
+
+static u32
+session_init_done_read_prop(struct hfi_core *hfi, struct hfi_inst *inst,
+			    struct hfi_msg_session_init_done_pkt *pkt)
+{
+	struct device *dev = hfi->dev;
+	u32 rem_bytes, num_props;
+	u32 ptype, next_offset = 0;
+	u32 err;
+	u8 *data;
+
+	rem_bytes = pkt->shdr.hdr.size - sizeof(*pkt) + sizeof(u32);
+	if (!rem_bytes) {
+		dev_err(dev, "%s: missing property info\n", __func__);
+		return HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
+	}
+
+	err = pkt->error_type;
+	if (err)
+		return err;
+
+	data = (u8 *) &pkt->data[0];
+	num_props = pkt->num_properties;
+
+	while (err == HFI_ERR_NONE && num_props && rem_bytes >= sizeof(u32)) {
+		ptype = *((u32 *)data);
+		next_offset = sizeof(u32);
+
+		switch (ptype) {
+		case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED: {
+			struct hfi_capabilities *caps;
+			struct hfi_capability *cap;
+			u32 num_caps;
+
+			if ((rem_bytes - next_offset) < sizeof(*cap)) {
+				err = HFI_ERR_SESSION_INVALID_PARAMETER;
+				break;
+			}
+
+			caps = (struct hfi_capabilities *)(data + next_offset);
+
+			num_caps = caps->num_capabilities;
+			cap = &caps->data[0];
+			next_offset += sizeof(u32);
+
+			while (num_caps &&
+			      (rem_bytes - next_offset) >= sizeof(u32)) {
+				hfi_copy_cap_prop(cap, inst);
+				cap++;
+				next_offset += sizeof(*cap);
+				num_caps--;
+			}
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED: {
+			struct hfi_uncompressed_format_supported *prop =
+				(struct hfi_uncompressed_format_supported *)
+				(data + next_offset);
+			u32 num_fmt_entries;
+			u8 *fmt;
+			struct hfi_uncompressed_plane_info *inf;
+
+			if ((rem_bytes - next_offset) < sizeof(*prop)) {
+				err = HFI_ERR_SESSION_INVALID_PARAMETER;
+				break;
+			}
+
+			num_fmt_entries = prop->format_entries;
+			next_offset = sizeof(*prop) - sizeof(u32);
+			fmt = (u8 *)&prop->format_info[0];
+
+			dev_dbg(dev, "uncomm format support num entries:%u\n",
+				num_fmt_entries);
+
+			while (num_fmt_entries) {
+				struct hfi_uncompressed_plane_constraints *cnts;
+				u32 bytes_to_skip;
+
+				inf = (struct hfi_uncompressed_plane_info *)fmt;
+
+				if ((rem_bytes - next_offset) < sizeof(*inf)) {
+					err = HFI_ERR_SESSION_INVALID_PARAMETER;
+					break;
+				}
+
+				dev_dbg(dev, "plane info: fmt:%x, planes:%x\n",
+					inf->format, inf->num_planes);
+
+				cnts = &inf->plane_format[0];
+				dev_dbg(dev, "%u %u %u %u\n",
+					cnts->stride_multiples,
+					cnts->max_stride,
+					cnts->min_plane_buffer_height_multiple,
+					cnts->buffer_alignment);
+
+				bytes_to_skip = sizeof(*inf) - sizeof(*cnts) +
+						inf->num_planes * sizeof(*cnts);
+
+				fmt += bytes_to_skip;
+				next_offset += bytes_to_skip;
+				num_fmt_entries--;
+			}
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED: {
+			struct hfi_properties_supported *prop =
+				(struct hfi_properties_supported *)
+				(data + next_offset);
+
+			next_offset += sizeof(*prop) - sizeof(u32)
+					+ prop->num_properties * sizeof(u32);
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED: {
+			struct hfi_profile_level_supported *prop =
+				(struct hfi_profile_level_supported *)
+				(data + next_offset);
+			struct hfi_profile_level *pl;
+			unsigned int prop_count = 0;
+			unsigned int count = 0;
+			u8 *ptr;
+
+			ptr = (u8 *)&prop->profile_level[0];
+			prop_count = prop->profile_count;
+
+			if (prop_count > HFI_MAX_PROFILE_COUNT)
+				prop_count = HFI_MAX_PROFILE_COUNT;
+
+			while (prop_count) {
+				ptr++;
+				pl = (struct hfi_profile_level *)ptr;
+
+				inst->pl[count].profile = pl->profile;
+				inst->pl[count].level = pl->level;
+				prop_count--;
+				count++;
+				ptr += sizeof(*pl) / sizeof(u32);
+			}
+
+			inst->pl_count = count;
+			next_offset += sizeof(*prop) - sizeof(*pl) +
+				       prop->profile_count * sizeof(*pl);
+
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED: {
+			struct hfi_nal_stream_format *nal =
+				(struct hfi_nal_stream_format *)
+				(data + next_offset);
+			dev_dbg(dev, "NAL format: %x\n", nal->format);
+			next_offset += sizeof(*nal);
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT: {
+			next_offset += sizeof(u32);
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE: {
+			u32 *max_seq_sz = (u32 *)(data + next_offset);
+
+			dev_dbg(dev, "max seq header sz: %x\n", *max_seq_sz);
+			next_offset += sizeof(u32);
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH: {
+			next_offset += sizeof(struct hfi_intra_refresh);
+			num_props--;
+			break;
+		}
+		case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED: {
+			struct hfi_buffer_alloc_mode_supported *prop =
+				(struct hfi_buffer_alloc_mode_supported *)
+				(data + next_offset);
+			int i;
+
+			if (prop->buffer_type == HFI_BUFFER_OUTPUT ||
+			    prop->buffer_type == HFI_BUFFER_OUTPUT2) {
+				for (i = 0; i < prop->num_entries; i++) {
+					switch (prop->data[i]) {
+					case HFI_BUFFER_MODE_STATIC:
+						inst->alloc_mode_static = true;
+						break;
+					case HFI_BUFFER_MODE_DYNAMIC:
+						inst->alloc_mode_dynamic = true;
+						break;
+					}
+				}
+			}
+			next_offset += sizeof(*prop) -
+				sizeof(u32) + prop->num_entries * sizeof(u32);
+			num_props--;
+			break;
+		}
+		default:
+			dev_dbg(dev, "%s: default case %#x\n", __func__, ptype);
+			break;
+		}
+
+		rem_bytes -= next_offset;
+		data += next_offset;
+	}
+
+	return err;
+}
+
+static void hfi_session_init_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				  void *packet)
+{
+	struct hfi_msg_session_init_done_pkt *pkt = packet;
+	unsigned int error;
+
+	error = pkt->error_type;
+	if (error != HFI_ERR_NONE)
+		goto done;
+
+	error = session_init_done_read_prop(hfi, inst, pkt);
+
+done:
+	inst->error = error;
+	complete(&inst->done);
+}
+
+static void hfi_session_load_res_done(struct hfi_core *hfi,
+				      struct hfi_inst *inst, void *packet)
+{
+	struct hfi_msg_session_load_resources_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_flush_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				   void *packet)
+{
+	struct hfi_msg_session_flush_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_etb_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				 void *packet)
+{
+	struct hfi_msg_session_empty_buffer_done_pkt *pkt = packet;
+	u32 flags = 0;
+
+	inst->error = pkt->error_type;
+
+	inst->ops->empty_buf_done(inst, pkt->input_tag, pkt->filled_len,
+				  pkt->offset, flags);
+}
+
+static void hfi_session_ftb_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				 void *packet)
+{
+	u32 session_type = inst->session_type;
+	struct hfi_msg_fbd fbd = {0};
+	struct timeval timestamp;
+	int64_t time_usec = 0;
+	unsigned int error;
+	u32 flags = 0;
+
+	if (session_type == VIDC_SESSION_TYPE_ENC) {
+		struct hfi_msg_session_fbd_compressed_pkt *pkt = packet;
+
+		fbd.timestamp_hi = pkt->time_stamp_hi;
+		fbd.timestamp_lo = pkt->time_stamp_lo;
+		fbd.flags1 = pkt->flags;
+		fbd.offset1 = pkt->offset;
+		fbd.alloc_len1 = pkt->alloc_len;
+		fbd.filled_len1 = pkt->filled_len;
+		fbd.picture_type = pkt->picture_type;
+		fbd.packet_buffer1 = pkt->packet_buffer;
+		fbd.extradata_buffer = pkt->extradata_buffer;
+		fbd.buffer_type = HFI_BUFFER_OUTPUT;
+
+		error = pkt->error_type;
+	} else if (session_type == VIDC_SESSION_TYPE_DEC) {
+		struct hfi_msg_session_fbd_uncompressed_plane0_pkt *pkt =
+			packet;
+
+		fbd.timestamp_hi = pkt->time_stamp_hi;
+		fbd.timestamp_lo = pkt->time_stamp_lo;
+		fbd.flags1 = pkt->flags;
+		fbd.offset1 = pkt->offset;
+		fbd.alloc_len1 = pkt->alloc_len;
+		fbd.filled_len1 = pkt->filled_len;
+		fbd.picture_type = pkt->picture_type;
+		fbd.packet_buffer1 = pkt->packet_buffer;
+		fbd.extradata_buffer = pkt->extradata_buffer;
+
+		if (pkt->stream_id == 0)
+			fbd.buffer_type = HFI_BUFFER_OUTPUT;
+		else if (pkt->stream_id == 1)
+			fbd.buffer_type = HFI_BUFFER_OUTPUT2;
+
+		error = pkt->error_type;
+	} else {
+		error = HFI_ERR_SESSION_INVALID_PARAMETER;
+	}
+
+	if (fbd.buffer_type != HFI_BUFFER_OUTPUT)
+		return;
+
+	if (fbd.flags1 & HFI_BUFFERFLAG_EOS)
+		flags |= V4L2_BUF_FLAG_LAST;
+
+	switch (fbd.picture_type) {
+	case HFI_PICTURE_IDR:
+		flags |= V4L2_BUF_FLAG_KEYFRAME;
+		break;
+	case HFI_PICTURE_I:
+		flags |= V4L2_BUF_FLAG_KEYFRAME;
+		break;
+	case HFI_PICTURE_P:
+		flags |= V4L2_BUF_FLAG_PFRAME;
+		break;
+	case HFI_PICTURE_B:
+		flags |= V4L2_BUF_FLAG_BFRAME;
+		break;
+	case HFI_FRAME_NOTCODED:
+	case HFI_UNUSED_PICT:
+	case HFI_FRAME_YUV:
+	default:
+		break;
+	}
+
+	if (!(fbd.flags1 & HFI_BUFFERFLAG_TIMESTAMPINVALID) &&
+	      fbd.filled_len1) {
+		time_usec = fbd.timestamp_hi;
+		time_usec = (time_usec << 32) | fbd.timestamp_lo;
+	}
+
+	timestamp = ns_to_timeval(time_usec * NSEC_PER_USEC);
+
+	inst->error = error;
+	inst->ops->fill_buf_done(inst, fbd.packet_buffer1, fbd.filled_len1,
+				 fbd.offset1, flags, &timestamp);
+}
+
+static void hfi_session_start_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				   void *packet)
+{
+	struct hfi_msg_session_start_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_stop_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				  void *packet)
+{
+	struct hfi_msg_session_stop_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_rel_res_done(struct hfi_core *hfi,
+				     struct hfi_inst *inst, void *packet)
+{
+	struct hfi_msg_session_release_resources_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_rel_buf_done(struct hfi_core *hfi,
+				     struct hfi_inst *inst, void *packet)
+{
+	struct hfi_msg_session_release_buffers_done_pkt *pkt = packet;
+
+	/*
+	 * the address of the released buffer can be extracted:
+	 * if (pkt->buffer_info) {
+	 *	cmd.data = &pkt->buffer_info;
+	 *	cmd.size = sizeof(struct hfi_buffer_info);
+	 * }
+	 */
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_end_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				 void *packet)
+{
+	struct hfi_msg_session_end_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_abort_done(struct hfi_core *hfi, struct hfi_inst *inst,
+				   void *packet)
+{
+	struct hfi_msg_sys_session_abort_done_pkt *pkt = packet;
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+static void hfi_session_get_seq_hdr_done(struct hfi_core *hfi,
+					 struct hfi_inst *inst, void *packet)
+{
+	struct hfi_msg_session_get_sequence_hdr_done_pkt *pkt = packet;
+
+	/*
+	 * output_done.packet_buffer1 = pkt->sequence_header;
+	 * output_done.filled_len1 = pkt->header_len;
+	 */
+
+	inst->error = pkt->error_type;
+	complete(&inst->done);
+}
+
+struct hfi_done_handler {
+	u32 pkt;
+	u32 pkt_sz;
+	u32 pkt_sz2;
+	void (*done)(struct hfi_core *, struct hfi_inst *, void *);
+	bool is_sys_pkt;
+};
+
+static const struct hfi_done_handler handlers[] = {
+	{.pkt = HFI_MSG_EVENT_NOTIFY,
+	 .pkt_sz = sizeof(struct hfi_msg_event_notify_pkt),
+	 .done = hfi_event_notify,
+	},
+	{.pkt = HFI_MSG_SYS_INIT,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_init_done_pkt),
+	 .done = hfi_sys_init_done,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_PROPERTY_INFO,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_property_info_pkt),
+	 .done = hfi_sys_property_info,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_RELEASE_RESOURCE,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_release_resource_done_pkt),
+	 .done = hfi_sys_rel_resource_done,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_PING_ACK,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_ping_ack_pkt),
+	 .done = hfi_sys_ping_done,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_IDLE,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_idle_pkt),
+	 .done = hfi_sys_idle_done,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_PC_PREP,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_pc_prep_done_pkt),
+	 .done = hfi_sys_pc_prepare_done,
+	 .is_sys_pkt = true,
+	},
+	{.pkt = HFI_MSG_SYS_SESSION_INIT,
+	 .pkt_sz = sizeof(struct hfi_msg_session_init_done_pkt),
+	 .done = hfi_session_init_done,
+	},
+	{.pkt = HFI_MSG_SYS_SESSION_END,
+	 .pkt_sz = sizeof(struct hfi_msg_session_end_done_pkt),
+	 .done = hfi_session_end_done,
+	},
+	{.pkt = HFI_MSG_SESSION_LOAD_RESOURCES,
+	 .pkt_sz = sizeof(struct hfi_msg_session_load_resources_done_pkt),
+	 .done = hfi_session_load_res_done,
+	},
+	{.pkt = HFI_MSG_SESSION_START,
+	 .pkt_sz = sizeof(struct hfi_msg_session_start_done_pkt),
+	 .done = hfi_session_start_done,
+	},
+	{.pkt = HFI_MSG_SESSION_STOP,
+	 .pkt_sz = sizeof(struct hfi_msg_session_stop_done_pkt),
+	 .done = hfi_session_stop_done,
+	},
+	{.pkt = HFI_MSG_SYS_SESSION_ABORT,
+	 .pkt_sz = sizeof(struct hfi_msg_sys_session_abort_done_pkt),
+	 .done = hfi_session_abort_done,
+	},
+	{.pkt = HFI_MSG_SESSION_EMPTY_BUFFER,
+	 .pkt_sz = sizeof(struct hfi_msg_session_empty_buffer_done_pkt),
+	 .done = hfi_session_etb_done,
+	},
+	{.pkt = HFI_MSG_SESSION_FILL_BUFFER,
+	 .pkt_sz = sizeof(struct hfi_msg_session_fbd_uncompressed_plane0_pkt),
+	 .pkt_sz2 = sizeof(struct hfi_msg_session_fbd_compressed_pkt),
+	 .done = hfi_session_ftb_done,
+	},
+	{.pkt = HFI_MSG_SESSION_FLUSH,
+	 .pkt_sz = sizeof(struct hfi_msg_session_flush_done_pkt),
+	 .done = hfi_session_flush_done,
+	},
+	{.pkt = HFI_MSG_SESSION_PROPERTY_INFO,
+	 .pkt_sz = sizeof(struct hfi_msg_session_property_info_pkt),
+	 .done = hfi_session_prop_info,
+	},
+	{.pkt = HFI_MSG_SESSION_RELEASE_RESOURCES,
+	 .pkt_sz = sizeof(struct hfi_msg_session_release_resources_done_pkt),
+	 .done = hfi_session_rel_res_done,
+	},
+	{.pkt = HFI_MSG_SESSION_GET_SEQUENCE_HEADER,
+	 .pkt_sz = sizeof(struct hfi_msg_session_get_sequence_hdr_done_pkt),
+	 .done = hfi_session_get_seq_hdr_done,
+	},
+	{.pkt = HFI_MSG_SESSION_RELEASE_BUFFERS,
+	 .pkt_sz = sizeof(struct hfi_msg_session_release_buffers_done_pkt),
+	 .done = hfi_session_rel_buf_done,
+	},
+};
+
+void hfi_process_watchdog_timeout(struct hfi_core *hfi)
+{
+	event_sys_error(hfi, EVT_SYS_WATCHDOG_TIMEOUT);
+}
+
+u32 hfi_process_msg_packet(struct hfi_core *hfi, struct hfi_pkt_hdr *hdr)
+{
+	const struct hfi_done_handler *handler;
+	struct device *dev = hfi->dev;
+	struct hfi_inst *inst;
+	bool found = false;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(handlers); i++) {
+		handler = &handlers[i];
+
+		if (handler->pkt != hdr->pkt_type)
+			continue;
+
+		found = true;
+		break;
+	}
+
+	if (found == false)
+		return hdr->pkt_type;
+
+	if (hdr->size && hdr->size < handler->pkt_sz &&
+	    hdr->size < handler->pkt_sz2) {
+		dev_err(dev, "bad packet size (%d should be %d, pkt type:%x)\n",
+			hdr->size, handler->pkt_sz, hdr->pkt_type);
+
+		return hdr->pkt_type;
+	}
+
+	if (handler->is_sys_pkt) {
+		inst = NULL;
+	} else {
+		struct hfi_session_pkt *pkt;
+
+		pkt = (struct hfi_session_pkt *)hdr;
+		inst = to_hfi_instance(hfi, pkt->shdr.session_id);
+
+		if (!inst)
+			dev_warn(dev, "no valid instance(pkt session_id:%x)\n",
+				 pkt->shdr.session_id);
+
+		/*
+		 * Event of type HFI_EVENT_SYS_ERROR will not have any session
+		 * associated with it
+		 */
+		if (!inst && hdr->pkt_type != HFI_MSG_EVENT_NOTIFY) {
+			dev_err(dev, "got invalid session id:%d\n",
+				pkt->shdr.session_id);
+			goto invalid_session;
+		}
+	}
+
+	handler->done(hfi, inst, hdr);
+
+invalid_session:
+	return hdr->pkt_type;
+}
diff --git a/drivers/media/platform/qcom/vidc/hfi_msgs.h b/drivers/media/platform/qcom/vidc/hfi_msgs.h
new file mode 100644
index 000000000000..34d1e8679709
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/hfi_msgs.h
@@ -0,0 +1,298 @@
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __HFI_MSGS_H__
+#define __HFI_MSGS_H__
+
+#include "hfi_helper.h"
+
+/* message calls */
+#define HFI_MSG_SYS_COMMON_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_COMMON_OFFSET +	\
+					 HFI_MSG_START_OFFSET + 0x0000)
+#define HFI_MSG_SYS_INIT		(HFI_MSG_SYS_COMMON_START + 0x1)
+#define HFI_MSG_SYS_PC_PREP		(HFI_MSG_SYS_COMMON_START + 0x2)
+#define HFI_MSG_SYS_RELEASE_RESOURCE	(HFI_MSG_SYS_COMMON_START + 0x3)
+#define HFI_MSG_SYS_DEBUG		(HFI_MSG_SYS_COMMON_START + 0x4)
+#define HFI_MSG_SYS_SESSION_INIT	(HFI_MSG_SYS_COMMON_START + 0x6)
+#define HFI_MSG_SYS_SESSION_END		(HFI_MSG_SYS_COMMON_START + 0x7)
+#define HFI_MSG_SYS_IDLE		(HFI_MSG_SYS_COMMON_START + 0x8)
+#define HFI_MSG_SYS_COV                 (HFI_MSG_SYS_COMMON_START + 0x9)
+#define HFI_MSG_SYS_PROPERTY_INFO	(HFI_MSG_SYS_COMMON_START + 0xa)
+
+#define HFI_MSG_SESSION_COMMON_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_COMMON_OFFSET +	\
+					 HFI_MSG_START_OFFSET + 0x1000)
+#define HFI_MSG_EVENT_NOTIFY		(HFI_MSG_SESSION_COMMON_START + 0x1)
+#define HFI_MSG_SESSION_GET_SEQUENCE_HEADER \
+					(HFI_MSG_SESSION_COMMON_START + 0x2)
+
+#define HFI_MSG_SYS_OX_START		(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_OX_OFFSET +		\
+					 HFI_MSG_START_OFFSET + 0x0000)
+#define HFI_MSG_SYS_PING_ACK		(HFI_MSG_SYS_OX_START + 0x2)
+#define HFI_MSG_SYS_SESSION_ABORT	(HFI_MSG_SYS_OX_START + 0x4)
+
+#define HFI_MSG_SESSION_OX_START	(HFI_DOMAIN_BASE_COMMON +	\
+					 HFI_ARCH_OX_OFFSET +	\
+					 HFI_MSG_START_OFFSET + 0x1000)
+#define HFI_MSG_SESSION_LOAD_RESOURCES	(HFI_MSG_SESSION_OX_START + 0x1)
+#define HFI_MSG_SESSION_START		(HFI_MSG_SESSION_OX_START + 0x2)
+#define HFI_MSG_SESSION_STOP		(HFI_MSG_SESSION_OX_START + 0x3)
+#define HFI_MSG_SESSION_SUSPEND		(HFI_MSG_SESSION_OX_START + 0x4)
+#define HFI_MSG_SESSION_RESUME		(HFI_MSG_SESSION_OX_START + 0x5)
+#define HFI_MSG_SESSION_FLUSH		(HFI_MSG_SESSION_OX_START + 0x6)
+#define HFI_MSG_SESSION_EMPTY_BUFFER	(HFI_MSG_SESSION_OX_START + 0x7)
+#define HFI_MSG_SESSION_FILL_BUFFER	(HFI_MSG_SESSION_OX_START + 0x8)
+#define HFI_MSG_SESSION_PROPERTY_INFO		(HFI_MSG_SESSION_OX_START + 0x9)
+#define HFI_MSG_SESSION_RELEASE_RESOURCES	(HFI_MSG_SESSION_OX_START + 0xa)
+#define HFI_MSG_SESSION_PARSE_SEQUENCE_HEADER	(HFI_MSG_SESSION_OX_START + 0xb)
+#define HFI_MSG_SESSION_RELEASE_BUFFERS		(HFI_MSG_SESSION_OX_START + 0xc)
+
+#define HFI_PICTURE_I			0x01
+#define HFI_PICTURE_P			0x02
+#define HFI_PICTURE_B			0x04
+#define HFI_PICTURE_IDR			0x08
+#define HFI_FRAME_NOTCODED		0x7f002000
+#define HFI_FRAME_YUV			0x7f004000
+#define HFI_UNUSED_PICT			0x10000000
+
+/* message packets */
+struct hfi_msg_event_notify_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 event_id;
+	u32 event_data1;
+	u32 event_data2;
+	u32 ext_event_data[1];
+};
+
+struct hfi_msg_event_release_buffer_ref_pkt {
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 output_tag;
+};
+
+struct hfi_msg_sys_init_done_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 error_type;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_msg_sys_pc_prep_done_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 error_type;
+};
+
+struct hfi_msg_sys_release_resource_done_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 resource_handle;
+	u32 error_type;
+};
+
+struct hfi_msg_session_init_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_msg_session_end_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_get_sequence_hdr_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 header_len;
+	u32 sequence_header;
+};
+
+struct hfi_msg_sys_session_abort_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_sys_idle_pkt {
+	struct hfi_pkt_hdr hdr;
+};
+
+struct hfi_msg_sys_ping_ack_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 client_data;
+};
+
+struct hfi_msg_sys_property_info_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_msg_session_load_resources_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_start_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_stop_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_suspend_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_resume_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_flush_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 flush_type;
+};
+
+struct hfi_msg_session_empty_buffer_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 offset;
+	u32 filled_len;
+	u32 input_tag;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[0];
+};
+
+struct hfi_msg_session_fbd_compressed_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u32 error_type;
+	u32 flags;
+	u32 mark_target;
+	u32 mark_data;
+	u32 stats;
+	u32 offset;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 input_tag;
+	u32 output_tag;
+	u32 picture_type;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[0];
+};
+
+struct hfi_msg_session_fbd_uncompressed_plane0_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 stream_id;
+	u32 view_id;
+	u32 error_type;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u32 flags;
+	u32 mark_target;
+	u32 mark_data;
+	u32 stats;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 frame_width;
+	u32 frame_height;
+	u32 start_x_coord;
+	u32 start_y_coord;
+	u32 input_tag;
+	u32 input_tag2;
+	u32 output_tag;
+	u32 picture_type;
+	u32 packet_buffer;
+	u32 extradata_buffer;
+	u32 data[0];
+};
+
+struct hfi_msg_session_fbd_uncompressed_plane1_pkt {
+	u32 flags;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 packet_buffer2;
+	u32 data[0];
+};
+
+struct hfi_msg_session_fbd_uncompressed_plane2_pkt {
+	u32 flags;
+	u32 alloc_len;
+	u32 filled_len;
+	u32 offset;
+	u32 packet_buffer3;
+	u32 data[0];
+};
+
+struct hfi_msg_session_parse_sequence_header_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_msg_session_property_info_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 num_properties;
+	u32 data[1];
+};
+
+struct hfi_msg_session_release_resources_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+};
+
+struct hfi_msg_session_release_buffers_done_pkt {
+	struct hfi_session_hdr_pkt shdr;
+	u32 error_type;
+	u32 num_buffers;
+	u32 buffer_info[1];
+};
+
+struct hfi_msg_sys_debug_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 msg_type;
+	u32 msg_size;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u8 msg_data[1];
+};
+
+struct hfi_msg_sys_coverage_pkt {
+	struct hfi_pkt_hdr hdr;
+	u32 msg_size;
+	u32 time_stamp_hi;
+	u32 time_stamp_lo;
+	u8 msg_data[1];
+};
+
+struct hfi_core;
+struct hfi_pkt_hdr;
+
+void hfi_process_watchdog_timeout(struct hfi_core *hfi);
+u32 hfi_process_msg_packet(struct hfi_core *hfi, struct hfi_pkt_hdr *hdr);
+
+#endif
-- 
2.7.4

