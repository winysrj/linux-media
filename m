Return-Path: <SRS0=znln=PF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53253C43387
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 07:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC4B208E4
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 07:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbeL1H7H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 02:59:07 -0500
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:46723 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728377AbeL1H7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 02:59:06 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2018 02:58:55 EST
X-IronPort-AV: E=Sophos;i="5.56,408,1539628200"; 
   d="scan'208";a="343245"
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by alexa-out-blr-01.qualcomm.com with ESMTP/TLS/AES256-SHA; 28 Dec 2018 13:22:10 +0530
X-IronPort-AV: E=McAfee;i="5900,7806,9119"; a="6375881"
Received: from mgottam-linux.qualcomm.com ([10.204.65.20])
  by ironmsg01-blr.qualcomm.com with ESMTP; 28 Dec 2018 13:22:09 +0530
Received: by mgottam-linux.qualcomm.com (Postfix, from userid 2305155)
        id 002C33390; Fri, 28 Dec 2018 13:22:08 +0530 (IST)
From:   Malathi Gottam <mgottam@codeaurora.org>
To:     stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH] media: venus: add debugfs support
Date:   Fri, 28 Dec 2018 13:22:06 +0530
Message-Id: <1545983526-3923-1-git-send-email-mgottam@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Enable logs in venus through debugfs to print
debug information.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/core.c       |  62 ++++++++-
 drivers/media/platform/qcom/venus/core.h       |  32 +++++
 drivers/media/platform/qcom/venus/firmware.c   |   6 +-
 drivers/media/platform/qcom/venus/helpers.c    |  51 +++++--
 drivers/media/platform/qcom/venus/hfi.c        |  93 ++++++++++---
 drivers/media/platform/qcom/venus/hfi_cmds.c   |  33 +++--
 drivers/media/platform/qcom/venus/hfi_msgs.c   |   5 +
 drivers/media/platform/qcom/venus/vdec.c       | 185 +++++++++++++++++++------
 drivers/media/platform/qcom/venus/vdec_ctrls.c |   7 +-
 drivers/media/platform/qcom/venus/venc.c       | 139 +++++++++++++++----
 drivers/media/platform/qcom/venus/venc_ctrls.c |   9 +-
 11 files changed, 512 insertions(+), 110 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index cb411eb..6531830 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -13,6 +13,7 @@
  *
  */
 #include <linux/clk.h>
+#include <linux/debugfs.h>
 #include <linux/init.h>
 #include <linux/ioctl.h>
 #include <linux/list.h>
@@ -31,6 +32,50 @@
 #include "venc.h"
 #include "firmware.h"
 
+struct dentry *debugfs_root;
+int venus_debug = ERR;
+EXPORT_SYMBOL_GPL(venus_debug);
+
+static struct dentry *venus_debugfs_init_drv(void)
+{
+	bool ok = false;
+	struct dentry *dir = NULL;
+
+	dir = debugfs_create_dir("venus", NULL);
+	if (IS_ERR_OR_NULL(dir)) {
+		dir = NULL;
+		pr_err("failed to create debug dir");
+		goto failed_create_dir;
+	}
+
+#define __debugfs_create(__type, __fname, __value) ({                          \
+	struct dentry *f = debugfs_create_##__type(__fname, 0644,	\
+		dir, __value);                                                \
+	if (IS_ERR_OR_NULL(f)) {                                              \
+		dprintk(ERR, "Failed creating debugfs file '%pd/%s'\n",  \
+			dir, __name);                                         \
+		f = NULL;                                                     \
+	}                                                                     \
+	f;                                                                    \
+})
+
+	ok =
+	__debugfs_create(x32, "debug_level", &venus_debug);
+
+#undef __debugfs_create
+
+	if (!ok)
+		goto failed_create_dir;
+
+	return dir;
+
+failed_create_dir:
+	if (dir)
+		debugfs_remove_recursive(debugfs_root);
+
+	return NULL;
+}
+
 static void venus_event_notify(struct venus_core *core, u32 event)
 {
 	struct venus_inst *inst;
@@ -137,6 +182,7 @@ static int venus_clks_enable(struct venus_core *core)
 
 	return 0;
 err:
+	dprintk(ERR, "Failed to enable clk:%d\n", i);
 	while (i--)
 		clk_disable_unprepare(core->clks[i]);
 
@@ -236,6 +282,8 @@ static int venus_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret;
 
+	debugfs_root = venus_debugfs_init_drv();
+
 	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
 	if (!core)
 		return -ENOMEM;
@@ -245,8 +293,10 @@ static int venus_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	core->base = devm_ioremap_resource(dev, r);
-	if (IS_ERR(core->base))
+	if (IS_ERR(core->base)) {
+		dprintk(ERR, "Failed to ioremap platform resources");
 		return PTR_ERR(core->base);
+		}
 
 	core->irq = platform_get_irq(pdev, 0);
 	if (core->irq < 0)
@@ -297,8 +347,10 @@ static int venus_probe(struct platform_device *pdev)
 		goto err_runtime_disable;
 
 	ret = venus_firmware_init(core);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init video firmware\n");
 		goto err_runtime_disable;
+		}
 
 	ret = venus_boot(core);
 	if (ret)
@@ -321,8 +373,10 @@ static int venus_probe(struct platform_device *pdev)
 		goto err_venus_shutdown;
 
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to register v4l2 device\n");
 		goto err_core_deinit;
+		}
 
 	ret = pm_runtime_put_sync(dev);
 	if (ret)
@@ -366,6 +420,8 @@ static int venus_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(&core->v4l2_dev);
 
+	debugfs_remove_recursive(debugfs_root);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 6382cea..c31d9e0 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -25,6 +25,38 @@
 
 #define VIDC_CLKS_NUM_MAX	4
 
+extern int venus_debug;
+enum venus_msg_prio {
+	ERR  = 0x0001,
+	WARN = 0x0002,
+	INFO = 0x0004,
+	DBG  = 0x0008,
+};
+
+static inline char *get_debug_level_str(int level)
+{
+	switch (level) {
+	case ERR:
+		return "err";
+	case WARN:
+		return "warn";
+	case INFO:
+		return "info";
+	case DBG:
+		return "dbg";
+	default:
+		return "???";
+	}
+}
+
+#define dprintk(dbg_lvl, fmt, arg...)				\
+	do {							\
+		if (venus_debug & dbg_lvl)				\
+			pr_info("venus:" fmt, \
+					get_debug_level_str(dbg_lvl),	\
+					## arg);	\
+	} while (0)
+
 struct freq_tbl {
 	unsigned int load;
 	unsigned long freq;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index c29acfd..eaf5951 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -142,7 +142,8 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
 		dev_err(dev, "could not map video firmware region\n");
 		return ret;
 	}
-
+	dprintk(DBG, "%s: Successfully mapped and performed test translation\n",
+		dev_name(dev));
 	venus_reset_cpu(core);
 
 	return 0;
@@ -258,7 +259,8 @@ int venus_firmware_init(struct venus_core *core)
 		dev_err(core->fw.dev, "could not attach device\n");
 		goto err_iommu_free;
 	}
-
+	dprintk(DBG, "Attached and created mapping for %s\n",
+		dev_name(core->fw.dev));
 	core->fw.iommu_domain = iommu_dom;
 
 	of_node_put(np);
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index e436385..9065b44 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -75,6 +75,7 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
 		codec = HFI_VIDEO_CODEC_HEVC;
 		break;
 	default:
+		dprintk(WARN, "Unknown format:%x\n", pixfmt);
 		return false;
 	}
 
@@ -102,8 +103,11 @@ static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 		fdata.buffer_type = buf->type;
 
 		ret = hfi_session_process_buf(inst, &fdata);
-		if (ret)
+		if (ret) {
+			dprintk(ERR, "%s: Failed to queue dpb buf to hfi: %d\n",
+				__func__, ret);
 			goto fail;
+		}
 	}
 
 fail:
@@ -157,6 +161,7 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 		return ret;
 
 	count = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+	dprintk(DBG, "buf count min %d", count);
 
 	for (i = 0; i < count; i++) {
 		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
@@ -174,6 +179,7 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 		if (!buf->va) {
 			kfree(buf);
 			ret = -ENOMEM;
+			dprintk(ERR, "Failed to alloc dma attrs for dpbbufs\n");
 			goto fail;
 		}
 
@@ -208,6 +214,7 @@ static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
 	for (i = 0; i < bufreq.count_actual; i++) {
 		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 		if (!buf) {
+			dprintk(ERR, "Out of memory\n");
 			ret = -ENOMEM;
 			goto fail;
 		}
@@ -220,6 +227,7 @@ static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
 					  buf->attrs);
 		if (!buf->va) {
 			ret = -ENOMEM;
+			dprintk(ERR, "Failed to alloc dma attrs for intbufs\n");
 			goto fail;
 		}
 
@@ -228,6 +236,8 @@ static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
 		bd.buffer_type = buf->type;
 		bd.num_buffers = 1;
 		bd.device_addr = buf->da;
+		dprintk(DBG, "Buffer address: %#x\n bufsize: %d, buf_type: %d",
+			bd.device_addr, bd.buffer_size, bd.buffer_type);
 
 		ret = hfi_session_set_buffers(inst, &bd);
 		if (ret) {
@@ -380,8 +390,11 @@ static int load_scale_clocks(struct venus_core *core)
 set_freq:
 
 	ret = clk_set_rate(clk, freq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set clock rate %lu clk: %d\n",
+			freq, ret);
 		goto err;
+	}
 
 	ret = clk_set_rate(core->core0_clk, freq);
 	if (ret)
@@ -459,8 +472,10 @@ static void return_buf_error(struct venus_inst *inst,
 	}
 
 	ret = hfi_session_process_buf(inst, &fdata);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "%s: Failed qbuf to hfi: %d\n", __func__, ret);
 		return ret;
+		}
 
 	return 0;
 }
@@ -544,11 +559,15 @@ int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 		memset(req, 0, sizeof(*req));
 
 	ret = hfi_session_get_property(inst, ptype, &hprop);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed getting buffer requirements: %d", ret);
 		return ret;
+		}
 
 	ret = -EINVAL;
-
+	dprintk(DBG, "Buffer requirements from HW:\n");
+	dprintk(DBG, "%15s %8s %8s %8s\n",
+		"buffer type", "count", "mincount_fw", "size");
 	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
 		if (hprop.bufreq[i].type != type)
 			continue;
@@ -556,6 +575,9 @@ int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 		if (req)
 			memcpy(req, &hprop.bufreq[i], sizeof(*req));
 		ret = 0;
+		dprintk(DBG, "%8d %8d %8d %8d\n",
+			req->type, req->count_actual,
+			req->count_min, req->size);
 		break;
 	}
 
@@ -730,16 +752,24 @@ int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 	buf_count.count_actual = input_bufs;
 
 	ret = hfi_session_set_property(inst, ptype, &buf_count);
-	if (ret)
+	if (ret) {
+		dprintk(ERR,
+			"Failed to set actual buffer count %d for buffer type %d\n",
+			buf_count.count_actual, buf_count.type);
 		return ret;
 
 	buf_count.type = HFI_BUFFER_OUTPUT;
 	buf_count.count_actual = output_bufs;
 
 	ret = hfi_session_set_property(inst, ptype, &buf_count);
-	if (ret)
+	if (ret) {
+		dprintk(ERR,
+			"Failed to set actual buffer count %d for buffer type %d\n",
+			buf_count.count_actual, buf_count.type);
 		return ret;
-
+	}
+	dprintk(DBG, "output buf: num = %d, input buf = %d\n",
+		output_bufs, input_bufs);
 	if (output2_bufs) {
 		buf_count.type = HFI_BUFFER_OUTPUT2;
 		buf_count.count_actual = output2_bufs;
@@ -776,8 +806,11 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
 		return -EINVAL;
 
 	hfi_format = to_hfi_raw_fmt(pixfmt);
-	if (!hfi_format)
+	if (!hfi_format) {
+		dprintk(ERR, "Using unsupported colorformat %#x\n",
+			pixfmt);
 		return -EINVAL;
+	}
 
 	return venus_helper_set_raw_format(inst, hfi_format, buftype);
 }
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 2420782..80bfb47 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -52,6 +52,7 @@ static u32 to_codec_type(u32 pixfmt)
 	case V4L2_PIX_FMT_HEVC:
 		return HFI_VIDEO_CODEC_HEVC;
 	default:
+		dprintk(WARN, "Wrong codec: fmt %x\n", pixfmt);
 		return 0;
 	}
 }
@@ -62,8 +63,11 @@ int hfi_core_init(struct venus_core *core)
 
 	mutex_lock(&core->lock);
 
-	if (core->state >= CORE_INIT)
+	if (core->state >= CORE_INIT) {
+		dprintk(INFO, "Video core is already in state: %d\n",
+			core->state);
 		goto unlock;
+	}
 
 	reinit_completion(&core->done);
 
@@ -71,8 +75,11 @@ int hfi_core_init(struct venus_core *core)
 	if (ret)
 		goto unlock;
 
+	dprintk(DBG, "Waiting for HFI_MSG_SYS_INIT\n");
 	ret = wait_for_completion_timeout(&core->done, TIMEOUT);
 	if (!ret) {
+		dprintk(ERR, "%s: Wait interrupted or timed out\n",
+			__func__);
 		ret = -ETIMEDOUT;
 		goto unlock;
 	}
@@ -85,6 +92,7 @@ int hfi_core_init(struct venus_core *core)
 	}
 
 	core->state = CORE_INIT;
+	dprintk(DBG, "SYS_INIT_DONE!!!\n");
 unlock:
 	mutex_unlock(&core->lock);
 	return ret;
@@ -207,13 +215,21 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
 	const struct hfi_ops *ops = core->ops;
 	int ret;
 
+	if (inst->state >= INST_INIT && inst->state < INST_STOP) {
+		dprintk(INFO, "inst: %pK is already in state: %d\n",
+			inst, inst->state);
+		return 0;
+		}
 	inst->hfi_codec = to_codec_type(pixfmt);
 	reinit_completion(&inst->done);
 
+	dprintk(DBG, "%s: inst %pK\n", __func__, inst);
 	ret = ops->session_init(inst, inst->session_type, inst->hfi_codec);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init session, type = %d\n",
+			inst->session_type);
 		return ret;
-
+	}
 	ret = wait_session_msg(inst);
 	if (ret)
 		return ret;
@@ -241,17 +257,27 @@ int hfi_session_deinit(struct venus_inst *inst)
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
-	if (inst->state == INST_UNINIT)
+	if (inst->state == INST_UNINIT) {
+		dprintk(INFO,
+			"inst: %pK is already in state: %d\n",
+		inst, inst->state);
 		return 0;
+	}
 
-	if (inst->state < INST_INIT)
+	if (inst->state < INST_INIT) {
+		dprintk(ERR, "%s: inst %pK is in invalid state\n",
+			__func__, inst);
 		return -EINVAL;
+	}
 
 	reinit_completion(&inst->done);
 
+	dprintk(DBG, "%s: inst %pK\n", __func__, inst);
 	ret = ops->session_end(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to send close\n");
 		return ret;
+		}
 
 	ret = wait_session_msg(inst);
 	if (ret)
@@ -268,14 +294,20 @@ int hfi_session_start(struct venus_inst *inst)
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
-	if (inst->state != INST_LOAD_RESOURCES)
+	if (inst->state != INST_LOAD_RESOURCES) {
+		dprintk(ERR,
+			"%s: inst %pK is in invalid state\n",
+			__func__, inst);
 		return -EINVAL;
+	}
 
 	reinit_completion(&inst->done);
 
 	ret = ops->session_start(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to send start\n");
 		return ret;
+		}
 
 	ret = wait_session_msg(inst);
 	if (ret)
@@ -291,11 +323,16 @@ int hfi_session_stop(struct venus_inst *inst)
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
-	if (inst->state != INST_START)
+	if (inst->state != INST_START) {
+		dprintk(ERR,
+			"%s: inst %pK is in invalid state\n",
+			__func__, inst);
 		return -EINVAL;
+	}
 
 	reinit_completion(&inst->done);
 
+	dprintk(DBG, "%s: inst %pK\n", __func__, inst);
 	ret = ops->session_stop(inst);
 	if (ret)
 		return ret;
@@ -328,12 +365,17 @@ int hfi_session_abort(struct venus_inst *inst)
 	reinit_completion(&inst->done);
 
 	ret = ops->session_abort(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "session_abort failed ret: %d\n", ret);
 		return ret;
+	}
 
 	ret = wait_session_msg(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "%s: inst %pK session %x abort timed out\n",
+			__func__, inst, inst->session_type);
 		return ret;
+	}
 
 	return 0;
 }
@@ -343,15 +385,21 @@ int hfi_session_load_res(struct venus_inst *inst)
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
-	if (inst->state != INST_INIT)
+	if (inst->state != INST_INIT) {
+		dprintk(ERR,
+			"%s: inst %pK is in invalid state\n",
+			__func__, inst);
 		return -EINVAL;
+	}
 
 	reinit_completion(&inst->done);
 
+	dprintk(DBG, "%s: inst %pK\n", __func__, inst);
 	ret = ops->session_load_res(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to send load resources\n");
 		return ret;
-
+	}
 	ret = wait_session_msg(inst);
 	if (ret)
 		return ret;
@@ -366,14 +414,21 @@ int hfi_session_unload_res(struct venus_inst *inst)
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
-	if (inst->state != INST_STOP)
+	if (inst->state != INST_STOP) {
+		dprintk(ERR,
+			"%s: inst %pK is in invalid state\n",
+			__func__, inst);
 		return -EINVAL;
+		}
 
 	reinit_completion(&inst->done);
 
+	dprintk(DBG, "%s: inst %pK\n", __func__, inst);
 	ret = ops->session_release_res(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to send release resources\n");
 		return ret;
+		}
 
 	ret = wait_session_msg(inst);
 	if (ret)
@@ -461,8 +516,10 @@ int hfi_session_set_property(struct venus_inst *inst, u32 ptype, void *pdata)
 {
 	const struct hfi_ops *ops = inst->core->ops;
 
-	if (inst->state < INST_INIT || inst->state >= INST_STOP)
+	if (inst->state < INST_INIT || inst->state >= INST_STOP) {
+		dprintk(ERR, "Not in proper state to set property\n");
 		return -EINVAL;
+		}
 
 	return ops->session_set_property(inst, ptype, pdata);
 }
@@ -478,6 +535,8 @@ int hfi_session_process_buf(struct venus_inst *inst, struct hfi_frame_data *fd)
 		 fd->buffer_type == HFI_BUFFER_OUTPUT2)
 		return ops->session_ftb(inst, fd);
 
+	dprintk(ERR, "%s: invalid qbuf type %d:\n", __func__,
+		fd->buffer_type);
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(hfi_session_process_buf);
diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index 87a4414..3c451a7 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -16,6 +16,7 @@
 #include <linux/hash.h>
 
 #include "hfi_cmds.h"
+#include "core.h"
 
 static enum hfi_version hfi_ver;
 
@@ -161,8 +162,10 @@ void pkt_sys_image_version(struct hfi_sys_get_property_pkt *pkt)
 int pkt_session_init(struct hfi_session_init_pkt *pkt, void *cookie,
 		     u32 session_type, u32 codec)
 {
-	if (!pkt || !cookie || !codec)
+	if (!pkt || !cookie || !codec) {
+		dprintk(ERR, "%s invalid parameters\n", __func__);
 		return -EINVAL;
+		}
 
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SYS_SESSION_INIT;
@@ -185,8 +188,10 @@ int pkt_session_set_buffers(struct hfi_session_set_buffers_pkt *pkt,
 {
 	unsigned int i;
 
-	if (!cookie || !pkt || !bd)
+	if (!cookie || !pkt || !bd) {
+		dprintk(ERR, "%s - invalid params\n", __func__);
 		return -EINVAL;
+		}
 
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_SET_BUFFERS;
 	pkt->shdr.session_id = hash32_ptr(cookie);
@@ -215,7 +220,8 @@ int pkt_session_set_buffers(struct hfi_session_set_buffers_pkt *pkt,
 	}
 
 	pkt->buffer_type = bd->buffer_type;
-
+	dprintk(DBG, "buftype:%d buffer addr: %x\n",
+		pkt->buffer_type, bd->device_addr);
 	return 0;
 }
 
@@ -263,9 +269,11 @@ int pkt_session_unset_buffers(struct hfi_session_release_buffer_pkt *pkt,
 int pkt_session_etb_decoder(struct hfi_session_empty_buffer_compressed_pkt *pkt,
 			    void *cookie, struct hfi_frame_data *in_frame)
 {
-	if (!cookie || !in_frame->device_addr)
+	if (!cookie || !in_frame->device_addr) {
+		dprintk(ERR, "%s: invalid params addr: %#x\n",
+			__func__, in_frame->device_addr);
 		return -EINVAL;
-
+	}
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_EMPTY_BUFFER;
 	pkt->shdr.session_id = hash32_ptr(cookie);
@@ -287,8 +295,11 @@ int pkt_session_etb_encoder(
 		struct hfi_session_empty_buffer_uncompressed_plane0_pkt *pkt,
 		void *cookie, struct hfi_frame_data *in_frame)
 {
-	if (!cookie || !in_frame->device_addr)
+	if (!cookie || !in_frame->device_addr) {
+		dprintk(ERR, "%s: invalid params addr: %#x\n",
+			__func__, in_frame->device_addr);
 		return -EINVAL;
+	}
 
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_EMPTY_BUFFER;
@@ -312,8 +323,11 @@ int pkt_session_etb_encoder(
 int pkt_session_ftb(struct hfi_session_fill_buffer_pkt *pkt, void *cookie,
 		    struct hfi_frame_data *out_frame)
 {
-	if (!cookie || !out_frame || !out_frame->device_addr)
+	if (!cookie || !out_frame || !out_frame->device_addr) {
+		dprintk(ERR, "%s: invalid params addr: %#x\n",
+			__func__, out_frame->device_addr);
 		return -EINVAL;
+	}
 
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_FILL_BUFFER;
@@ -339,8 +353,11 @@ int pkt_session_parse_seq_header(
 		struct hfi_session_parse_sequence_header_pkt *pkt,
 		void *cookie, u32 seq_hdr, u32 seq_hdr_len)
 {
-	if (!cookie || !seq_hdr || !seq_hdr_len)
+	if (!cookie || !seq_hdr || !seq_hdr_len) {
+		dprintk(ERR, "%s: invalid params hdr: %d, hdr_len:%d\n",
+			__func__, seq_hdr, seq_hdr_len);
 		return -EINVAL;
+	}
 
 	pkt->shdr.hdr.size = sizeof(*pkt);
 	pkt->shdr.hdr.pkt_type = HFI_CMD_SESSION_PARSE_SEQUENCE_HEADER;
diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index 0ecdaa1..b6ea2f9 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -238,9 +238,14 @@ static void hfi_sys_init_done(struct venus_core *core, struct venus_inst *inst,
 	}
 
 	error = hfi_parser(core, inst, pkt->data, rem_bytes);
+	dprintk(DBG,
+		"supported_codecs[%d]: enc = %#x, dec = %#x\n",
+		core->codecs_count, core->enc_codecs,
+		core->dec_codecs);
 
 done:
 	core->error = error;
+	dprintk(INFO, "sys init ret: %d", core->error);
 	complete(&core->done);
 }
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 282de21..7f65e10 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -97,9 +97,10 @@
 			break;
 	}
 
-	if (i == size || fmt[i].type != type)
+	if (i == size || fmt[i].type != type) {
+		dprintk(INFO, "Format not found\n");
 		return NULL;
-
+	}
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
 		return NULL;
@@ -130,8 +131,10 @@
 			k++;
 	}
 
-	if (i == size)
+	if (i == size) {
+		dprintk(INFO, "Format not found by index\n");
 		return NULL;
+		}
 
 	return &fmt[i];
 }
@@ -236,6 +239,13 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 
 	vdec_try_fmt_common(inst, f);
 
+	dprintk(DBG,
+		"g_fmt: %x : type %d wxh %dx%d pixelfmt %#x num_planes %d size[0] %d in_reconfig %d\n",
+		inst->session_type, f->type,
+		f->fmt.pix_mp.width, f->fmt.pix_mp.height,
+		f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.num_planes,
+		f->fmt.pix_mp.plane_fmt[0].sizeimage, inst->reconfig);
+
 	return 0;
 }
 
@@ -292,7 +302,8 @@ static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 		inst->fmt_out = fmt;
 	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		inst->fmt_cap = fmt;
-
+	dprintk(INFO, "s_fmt: inst width: %d height: %d\n",
+		inst->width, inst->height);
 	return 0;
 }
 
@@ -372,8 +383,10 @@ static int vdec_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	u64 us_per_frame, fps;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
-	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		dprintk(ERR, "Unknown buffer type %d\n", a->type);
 		return -EINVAL;
+		}
 
 	memset(cap->reserved, 0, sizeof(cap->reserved));
 	if (!timeperframe->denominator)
@@ -386,8 +399,11 @@ static int vdec_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
+	if (!us_per_frame) {
+		dprintk(ERR,
+			"Failed to scale clocks : time between frames is 0\n");
 		return -EINVAL;
+	}
 
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
@@ -395,6 +411,7 @@ static int vdec_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	inst->fps = fps;
 	inst->timeperframe = *timeperframe;
 
+	dprintk(INFO, "dec: reported fps for %pK: %d\n", inst, inst->fps);
 	return 0;
 }
 
@@ -439,6 +456,7 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 	case V4L2_EVENT_CTRL:
 		return v4l2_ctrl_subscribe_event(fh, sub);
 	default:
+		dprintk(ERR, "Failed to subscribe event\n");
 		return -EINVAL;
 	}
 }
@@ -452,6 +470,7 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 			return -EINVAL;
 		break;
 	default:
+		dprintk(ERR, "Invalid decoder cmd\n");
 		return -EINVAL;
 	}
 
@@ -527,8 +546,10 @@ static int vdec_set_properties(struct venus_inst *inst)
 	if (ctr->post_loop_deb_mode) {
 		ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
 		ret = hfi_session_set_property(inst, ptype, &en);
-		if (ret)
+		if (ret) {
+			dprintk(ERR, "Failed to set dec prop: 0x%x", ptype);
 			return ret;
+			}
 	}
 
 	return 0;
@@ -548,18 +569,24 @@ static int vdec_output_conf(struct venus_inst *inst)
 	int ret;
 
 	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set workmode 2\n");
 		return ret;
+	}
 
 	ret = venus_helper_set_core_usage(inst, VIDC_CORE_ID_1);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set core usage\n");
 		return ret;
+		}
 
 	if (core->res->hfi_version == HFI_VERSION_1XX) {
 		ptype = HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER;
 		ret = hfi_session_set_property(inst, ptype, &en);
-		if (ret)
+		if (ret) {
+			dprintk(ERR, "Failed to set dec prop: 0x%x", ptype);
 			return ret;
+			}
 	}
 
 	/* Force searching UBWC formats for bigger then HD resolutions */
@@ -572,8 +599,10 @@ static int vdec_output_conf(struct venus_inst *inst)
 
 	ret = venus_helper_get_out_fmts(inst, inst->fmt_cap->pixfmt, &out_fmt,
 					&out2_fmt, ubwc);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get outfmt:%x", inst->fmt_cap->pixfmt);
 		return ret;
+		}
 
 	inst->output_buf_size =
 			venus_helper_get_framesz_raw(out_fmt, width, height);
@@ -599,23 +628,34 @@ static int vdec_output_conf(struct venus_inst *inst)
 
 	ret = venus_helper_set_raw_format(inst, inst->opb_fmt,
 					  inst->opb_buftype);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set raw fmt opb fmt:0x%x",
+			inst->opb_fmt);
 		return ret;
+	}
 
 	if (inst->dpb_fmt) {
 		ret = venus_helper_set_multistream(inst, false, true);
-		if (ret)
+		if (ret) {
+			dprintk(ERR, "Failed to set multistream");
 			return ret;
+		}
 
 		ret = venus_helper_set_raw_format(inst, inst->dpb_fmt,
 						  inst->dpb_buftype);
-		if (ret)
+		if (ret) {
+			dprintk(ERR, "Failed to set raw fmt dpb fmt:0x%x",
+				inst->dpb_fmt);
 			return ret;
-
+			}
 		ret = venus_helper_set_output_resolution(inst, width, height,
 							 HFI_BUFFER_OUTPUT2);
-		if (ret)
+		if (ret) {
+			dprintk(ERR,
+				"Failed to set o/p resolution width:%d, height:%d",
+				width, height);
 			return ret;
+		}
 	}
 
 	if (IS_V3(core) || IS_V4(core)) {
@@ -623,23 +663,32 @@ static int vdec_output_conf(struct venus_inst *inst)
 			ret = venus_helper_set_bufsize(inst,
 						       inst->output2_buf_size,
 						       HFI_BUFFER_OUTPUT2);
-			if (ret)
+			if (ret) {
+				dprintk(ERR,
+					"Failed to set bufsize: %d for o/p2",
+					inst->output2_buf_size);
 				return ret;
+			}
 		}
 
 		if (inst->output_buf_size) {
 			ret = venus_helper_set_bufsize(inst,
 						       inst->output_buf_size,
 						       HFI_BUFFER_OUTPUT);
-			if (ret)
+			if (ret) {
+				dprintk(ERR,
+					"Failed to set bufsize: %d for o/p",
+						inst->output_buf_size);
 				return ret;
+			}
 		}
 	}
 
 	ret = venus_helper_set_dyn_bufmode(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set dynamic buffer mode\n");
 		return ret;
-
+		}
 	return 0;
 }
 
@@ -648,17 +697,26 @@ static int vdec_init_session(struct venus_inst *inst)
 	int ret;
 
 	ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init firmware session\n");
 		return ret;
+	}
 
 	ret = venus_helper_set_input_resolution(inst, inst->out_width,
 						inst->out_height);
-	if (ret)
+	if (ret) {
+		dprintk(ERR,
+			"Failed to set i/p resolution width:%d, height:%d",
+			inst->out_width, inst->out_height);
 		goto deinit;
+	}
 
 	ret = venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set color format fmt:0x%x",
+			inst->fmt_cap->pixfmt);
 		goto deinit;
+		}
 
 	return 0;
 deinit:
@@ -676,18 +734,24 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
 	*in_num = *out_num = 0;
 
 	ret = vdec_init_session(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init decoder session");
 		return ret;
+		}
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq on i/p");
 		goto deinit;
+		}
 
 	*in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq on i/p");
 		goto deinit;
+	}
 
 	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
 
@@ -728,8 +792,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
 	}
 
 	ret = vdec_num_buffers(inst, &in_num, &out_num);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed : No buffer requirements\n");
 		return ret;
+		}
 
 	switch (q->type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -752,10 +818,14 @@ static int vdec_queue_setup(struct vb2_queue *q,
 		inst->num_output_bufs = *num_buffers;
 		break;
 	default:
+		dprintk(ERR, "Invalid q type = %d\n", q->type);
 		ret = -EINVAL;
 		break;
 	}
-
+	dprintk(DBG,
+		"%s: %d : type %d num_buffers %d num_planes %d sizes[0] %d\n",
+		__func__, inst->session_type, q->type, *num_buffers,
+		*num_planes, sizes[0]);
 	return ret;
 }
 
@@ -765,24 +835,45 @@ static int vdec_verify_conf(struct venus_inst *inst)
 	struct hfi_buffer_requirements bufreq;
 	int ret;
 
-	if (!inst->num_input_bufs || !inst->num_output_bufs)
+	if (!inst->num_input_bufs || !inst->num_output_bufs) {
+		dprintk(ERR, "Failed: insuffice bufs i/p_buf: %d o/p_buf: %d",
+			inst->num_input_bufs, inst->num_output_bufs);
 		return -EINVAL;
+		}
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq o/p\n");
 		return ret;
-
+		}
+	dprintk(DBG, "Verifying Buffer: %d\n", bufreq.type);
 	if (inst->num_output_bufs < bufreq.count_actual ||
-	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver)) {
+		dprintk(ERR,
+			"Invalid data : Counts mismatch\n");
+		dprintk(ERR, "num of output bufs = %d ",
+			inst->num_output_bufs);
+		dprintk(ERR, "actual buf count = %d ",
+			bufreq.count_actual);
+		dprintk(ERR, "Min Actual Count = %d\n",
+			HFI_BUFREQ_COUNT_MIN(&bufreq, ver));
 		return -EINVAL;
-
+	}
+	dprintk(DBG, "Verifying Buffer: %d\n", bufreq.type);
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq i/p\n");
 		return ret;
-
-	if (inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+		}
+	if (inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver)) {
+		dprintk(ERR,
+			"Invalid data : Counts mismatch\n");
+		dprintk(ERR, "num of input bufs = %d ",
+			inst->num_input_bufs);
+		dprintk(ERR, "Min Actual Count = %d\n",
+			HFI_BUFREQ_COUNT_MIN(&bufreq, ver));
 		return -EINVAL;
-
+	}
 	return 0;
 }
 
@@ -791,6 +882,9 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct venus_inst *inst = vb2_get_drv_priv(q);
 	int ret;
 
+	dprintk(DBG, "Streamon called on: %d capability for inst: %pK\n",
+		q->type, inst);
+
 	mutex_lock(&inst->lock);
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
@@ -894,8 +988,12 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
 			const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
 
+			dprintk(DBG, "Received EOS buffer");
 			v4l2_event_queue_fh(&inst->fh, &ev);
 		}
+		dprintk(INFO,
+			"buf done: data_offset = %d; bytesused = %d; length = %d\n",
+			vb->planes[0].data_offset, vb->planes[0].length);
 	} else {
 		vbuf->sequence = inst->sequence_out++;
 	}
@@ -1021,8 +1119,10 @@ static int vdec_open(struct file *file)
 	int ret;
 
 	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
-	if (!inst)
+	if (!inst) {
+		dprintk(ERR, "dec: Failed to create video instance");
 		return -ENOMEM;
+		}
 
 	INIT_LIST_HEAD(&inst->dpbbufs);
 	INIT_LIST_HEAD(&inst->registeredbufs);
@@ -1041,12 +1141,16 @@ static int vdec_open(struct file *file)
 		goto err_free_inst;
 
 	ret = vdec_ctrl_init(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed control initialization\n");
 		goto err_put_sync;
+	}
 
 	ret = hfi_session_create(inst, &vdec_hfi_ops);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to create session\n");
 		goto err_ctrl_deinit;
+	}
 
 	vdec_inst_init(inst);
 
@@ -1232,6 +1336,7 @@ static __maybe_unused int vdec_runtime_resume(struct device *dev)
 err_unprepare_core0:
 	clk_disable_unprepare(core->core0_clk);
 err_power_disable:
+	dprintk(ERR, "Failed to enable core0 clk\n");
 	venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/venus/vdec_ctrls.c b/drivers/media/platform/qcom/venus/vdec_ctrls.c
index f4604b0..bfc6904 100644
--- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
+++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
@@ -91,8 +91,11 @@ int vdec_ctrl_init(struct venus_inst *inst)
 	int ret;
 
 	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 7);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "CTRL ERR: Control handler init failed, %d\n",
+			inst->ctrl_handler.error);
 		return ret;
+	}
 
 	ctrl = v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &vdec_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
@@ -147,6 +150,8 @@ int vdec_ctrl_init(struct venus_inst *inst)
 
 	ret = inst->ctrl_handler.error;
 	if (ret) {
+		dprintk(ERR, "Error adding ctrl to ctrl handle, %d\n",
+			inst->ctrl_handler.error);
 		v4l2_ctrl_handler_free(&inst->ctrl_handler);
 		return ret;
 	}
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 32cff29..0151b01 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -79,9 +79,10 @@
 			break;
 	}
 
-	if (i == size || fmt[i].type != type)
+	if (i == size || fmt[i].type != type) {
+		dprintk(INFO, "Format not found\n");
 		return NULL;
-
+	}
 	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
 	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
 		return NULL;
@@ -112,9 +113,10 @@
 			k++;
 	}
 
-	if (i == size)
+	if (i == size) {
+		dprintk(INFO, "Format not found by index\n");
 		return NULL;
-
+	}
 	return &fmt[i];
 }
 
@@ -289,8 +291,10 @@ static int venc_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 
 	memset(f->reserved, 0, sizeof(f->reserved));
 
-	if (!fmt)
+	if (!fmt) {
+		dprintk(DBG, "No more formats found\n");
 		return -EINVAL;
+	}
 
 	f->pixelformat = fmt->pixfmt;
 
@@ -367,8 +371,11 @@ static int venc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	orig_pixmp = *pixmp;
 
 	fmt = venc_try_fmt_common(inst, f);
-	if (!fmt)
+	if (!fmt) {
+		dprintk(ERR, "Format: %d not supported\n",
+			f->fmt.pix_mp.pixelformat);
 		return -EINVAL;
+	}
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		pixfmt_out = pixmp->pixelformat;
@@ -410,7 +417,8 @@ static int venc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 		inst->fmt_out = fmt;
 	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		inst->fmt_cap = fmt;
-
+	dprintk(INFO, "s_fmt: inst width: %d height: %d\n",
+		inst->width, inst->height);
 	return 0;
 }
 
@@ -443,6 +451,13 @@ static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 
 	venc_try_fmt_common(inst, f);
 
+	dprintk(DBG,
+		"g_fmt: %x : type %d wxh %dx%d pixelfmt %#x num_planes %d size[0] %d in_reconfig %d\n",
+		inst->session_type, f->type,
+		f->fmt.pix_mp.width, f->fmt.pix_mp.height,
+		f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.num_planes,
+		f->fmt.pix_mp.plane_fmt[0].sizeimage, inst->reconfig);
+
 	return 0;
 }
 
@@ -504,8 +519,10 @@ static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	u64 us_per_frame, fps;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
-	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		dprintk(ERR, "Unknown buffer type %d\n", a->type);
 		return -EINVAL;
+	}
 
 	memset(out->reserved, 0, sizeof(out->reserved));
 
@@ -519,8 +536,11 @@ static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
+	if (!us_per_frame) {
+		dprintk(ERR,
+			"Failed to scale clocks : time between frames is 0\n");
 		return -EINVAL;
+		}
 
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
@@ -528,6 +548,7 @@ static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 	inst->timeperframe = *timeperframe;
 	inst->fps = fps;
 
+	dprintk(INFO, "enc: reported fps for %pK: %d\n", inst, inst->fps);
 	return 0;
 }
 
@@ -657,20 +678,26 @@ static int venc_set_properties(struct venus_inst *inst)
 	int ret;
 
 	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set workmode 2\n");
 		return ret;
+	}
 
 	ret = venus_helper_set_core_usage(inst, VIDC_CORE_ID_2);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set core usage\n");
 		return ret;
+		}
 
 	ptype = HFI_PROPERTY_CONFIG_FRAME_RATE;
 	frate.buffer_type = HFI_BUFFER_OUTPUT;
 	frate.framerate = inst->fps * (1 << 16);
 
 	ret = hfi_session_set_property(inst, ptype, &frate);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set core usage\n");
 		return ret;
+		}
 
 	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
 		struct hfi_h264_vui_timing_info info;
@@ -829,28 +856,41 @@ static int venc_init_session(struct venus_inst *inst)
 	int ret;
 
 	ret = hfi_session_init(inst, inst->fmt_cap->pixfmt);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init firmware session\n");
 		return ret;
+	}
 
 	ret = venus_helper_set_input_resolution(inst, inst->width,
 						inst->height);
-	if (ret)
+	if (ret) {
+		dprintk(ERR,
+			"Failed to set i/p resolution width: %d, height: %d",
+			inst->width, inst->height);
 		goto deinit;
+	}
 
 	ret = venus_helper_set_output_resolution(inst, inst->width,
 						 inst->height,
 						 HFI_BUFFER_OUTPUT);
-	if (ret)
+	if (ret) {
+		dprintk(ERR,
+			"Failed to set o/p resolution width: %d, height: %d",
+			inst->width, inst->height);
 		goto deinit;
+	}
 
 	ret = venus_helper_set_color_format(inst, inst->fmt_out->pixfmt);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set color format");
 		goto deinit;
+		}
 
 	ret = venc_set_properties(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to set enc properties");
 		goto deinit;
-
+	}
 	return 0;
 deinit:
 	hfi_session_deinit(inst);
@@ -863,8 +903,10 @@ static int venc_out_num_buffers(struct venus_inst *inst, unsigned int *num)
 	int ret;
 
 	ret = venc_init_session(inst);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to init encoder session");
 		return ret;
+		}
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
 
@@ -908,9 +950,12 @@ static int venc_queue_setup(struct vb2_queue *q,
 		*num_planes = inst->fmt_out->num_planes;
 
 		ret = venc_out_num_buffers(inst, &num);
-		if (ret)
+		if (ret) {
+			dprintk(ERR,
+				"Failed : No buffer requirements : %x\n",
+				HFI_BUFFER_INPUT);
 			break;
-
+		}
 		num = max(num, min);
 		*num_buffers = max(*num_buffers, num);
 		inst->num_input_bufs = *num_buffers;
@@ -930,10 +975,15 @@ static int venc_queue_setup(struct vb2_queue *q,
 		inst->output_buf_size = sizes[0];
 		break;
 	default:
+		dprintk(ERR, "Invalid q type = %d\n", q->type);
 		ret = -EINVAL;
 		break;
 	}
 
+	dprintk(DBG,
+		"queue_setup: %d : type %d num_buffers %d num_planes %d sizes[0] %d\n",
+		inst->session_type, q->type, *num_buffers,
+		*num_planes, sizes[0]);
 	return ret;
 }
 
@@ -943,25 +993,52 @@ static int venc_verify_conf(struct venus_inst *inst)
 	struct hfi_buffer_requirements bufreq;
 	int ret;
 
-	if (!inst->num_input_bufs || !inst->num_output_bufs)
+	if (!inst->num_input_bufs || !inst->num_output_bufs) {
+		dprintk(ERR,
+			"Failed with insufficient bufs i/p_buf: %d o/p_buf: %d",
+			inst->num_input_bufs, inst->num_output_bufs);
 		return -EINVAL;
+	}
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq o/p\n");
 		return ret;
+		}
+	dprintk(DBG, "Verifying Buffer: %d\n", bufreq.type);
 
 	if (inst->num_output_bufs < bufreq.count_actual ||
-	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver)) {
+		dprintk(ERR,
+			"Invalid data : Counts mismatch\n");
+		dprintk(ERR, "num of output bufs = %d ",
+			inst->num_output_bufs);
+		dprintk(ERR, "actual buf count = %d ",
+			bufreq.count_actual);
+		dprintk(ERR, "Min Actual Count = %d\n",
+			HFI_BUFREQ_COUNT_MIN(&bufreq, ver));
 		return -EINVAL;
+		}
 
+	dprintk(DBG, "Verifying Buffer: %d\n", bufreq.type);
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "Failed to get bufreq i/p\n");
 		return ret;
+		}
 
 	if (inst->num_input_bufs < bufreq.count_actual ||
-	    inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver)) {
+		dprintk(ERR,
+			"Invalid data : Counts mismatch\n");
+		dprintk(ERR, "num of input bufs = %d ",
+			inst->num_output_bufs);
+		dprintk(ERR, "actual buf count = %d ",
+			bufreq.count_actual);
+		dprintk(ERR, "Min Actual Count = %d\n",
+			HFI_BUFREQ_COUNT_MIN(&bufreq, ver));
 		return -EINVAL;
-
+		}
 	return 0;
 }
 
@@ -972,6 +1049,9 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	mutex_lock(&inst->lock);
 
+	dprintk(DBG, "Streamon called on: %d capability for inst: %pK\n",
+		q->type, inst);
+
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		inst->streamon_out = 1;
 	else
@@ -1148,8 +1228,10 @@ static int venc_open(struct file *file)
 	int ret;
 
 	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
-	if (!inst)
+	if (!inst) {
+		dprintk(ERR, "enc: Failed to create video instance");
 		return -ENOMEM;
+	}
 
 	INIT_LIST_HEAD(&inst->dpbbufs);
 	INIT_LIST_HEAD(&inst->registeredbufs);
@@ -1358,6 +1440,7 @@ static __maybe_unused int venc_runtime_resume(struct device *dev)
 err_unprepare_core1:
 	clk_disable_unprepare(core->core1_clk);
 err_power_disable:
+	dprintk(ERR, "Failed to enable core1 clk");
 	venus_helper_power_enable(core, VIDC_SESSION_TYPE_ENC, false);
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index ac1e1d2..dbbec61 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -203,6 +203,7 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		mutex_unlock(&inst->lock);
 		break;
 	default:
+		dprintk(ERR, "Unsupported ctrl: %x\n", ctrl->id);
 		return -EINVAL;
 	}
 
@@ -218,9 +219,11 @@ int venc_ctrl_init(struct venus_inst *inst)
 	int ret;
 
 	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 28);
-	if (ret)
+	if (ret) {
+		dprintk(ERR, "CTRL ERR: Control handler init failed, %d\n",
+			inst->ctrl_handler.error);
 		return ret;
-
+	}
 	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
 		V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
@@ -351,6 +354,8 @@ int venc_ctrl_init(struct venus_inst *inst)
 
 	return 0;
 err:
+	dprintk(ERR, "Error adding ctrl to ctrl handle, %d\n",
+		inst->ctrl_handler.error);
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	return ret;
 }
-- 
1.9.1

