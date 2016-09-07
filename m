Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36445 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755651AbcIGLpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 07:45:06 -0400
Received: by mail-wm0-f47.google.com with SMTP id b187so111238698wme.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 04:45:05 -0700 (PDT)
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
Subject: [PATCH v2 2/8] media: vidc: adding core part and helper functions
Date: Wed,  7 Sep 2016 14:37:03 +0300
Message-Id: <1473248229-5540-3-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds core part of the vidc driver common helper functions
used by encoder and decoder specific files.

 * core.c has implemented the platform dirver methods, file
operations and v4l2 registration.

 * helpers.c has implemented common helper functions for:
   - buffer management

   - vb2_ops and functions for format propagation,

   - functions for allocating and freeing buffers for
   internal usage. The buffer parameters describing internal
   buffers depends on current format, resolution and codec.

   - functions for calculation of current load of the
   hardware. Depending on the count of instances and
   resolutions it selects the best clock rate for the video
   core.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/vidc/core.c    | 559 ++++++++++++++++++++++++++
 drivers/media/platform/qcom/vidc/core.h    | 207 ++++++++++
 drivers/media/platform/qcom/vidc/helpers.c | 604 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/vidc/helpers.h |  43 ++
 4 files changed, 1413 insertions(+)
 create mode 100644 drivers/media/platform/qcom/vidc/core.c
 create mode 100644 drivers/media/platform/qcom/vidc/core.h
 create mode 100644 drivers/media/platform/qcom/vidc/helpers.c
 create mode 100644 drivers/media/platform/qcom/vidc/helpers.h

diff --git a/drivers/media/platform/qcom/vidc/core.c b/drivers/media/platform/qcom/vidc/core.c
new file mode 100644
index 000000000000..0e495f456721
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/core.c
@@ -0,0 +1,559 @@
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
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/ioctl.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/remoteproc.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/v4l2-ioctl.h>
+
+#include "core.h"
+#include "vdec.h"
+#include "venc.h"
+
+static void vidc_add_inst(struct vidc_core *core, struct vidc_inst *inst)
+{
+	mutex_lock(&core->lock);
+	list_add_tail(&inst->list, &core->instances);
+	mutex_unlock(&core->lock);
+}
+
+static void vidc_del_inst(struct vidc_core *core, struct vidc_inst *inst)
+{
+	struct vidc_inst *pos, *n;
+
+	mutex_lock(&core->lock);
+	list_for_each_entry_safe(pos, n, &core->instances, list) {
+		if (pos == inst)
+			list_del(&inst->list);
+	}
+	mutex_unlock(&core->lock);
+}
+
+struct vidc_sys_error {
+	struct vidc_core *core;
+	struct delayed_work work;
+};
+
+static void vidc_sys_error_handler(struct work_struct *work)
+{
+	struct vidc_sys_error *handler =
+		container_of(work, struct vidc_sys_error, work.work);
+	struct vidc_core *core = handler->core;
+	struct hfi_core *hfi = &core->hfi;
+	struct device *dev = core->dev;
+	int ret;
+
+	mutex_lock(&hfi->lock);
+	if (hfi->state != CORE_INVALID)
+		goto exit;
+
+	mutex_unlock(&hfi->lock);
+
+	ret = vidc_hfi_core_deinit(hfi);
+	if (ret)
+		dev_err(dev, "core: deinit failed (%d)\n", ret);
+
+	mutex_lock(&hfi->lock);
+
+	rproc_report_crash(core->rproc, RPROC_FATAL_ERROR);
+
+	rproc_shutdown(core->rproc);
+
+	ret = rproc_boot(core->rproc);
+	if (ret)
+		goto exit;
+
+	hfi->state = CORE_INIT;
+
+exit:
+	mutex_unlock(&hfi->lock);
+	kfree(handler);
+}
+
+static int vidc_event_notify(struct hfi_core *hfi, u32 event)
+{
+	struct vidc_sys_error *handler;
+	struct hfi_inst *inst;
+
+	switch (event) {
+	case EVT_SYS_WATCHDOG_TIMEOUT:
+	case EVT_SYS_ERROR:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mutex_lock(&hfi->lock);
+
+	hfi->state = CORE_INVALID;
+
+	list_for_each_entry(inst, &hfi->instances, list) {
+		mutex_lock(&inst->lock);
+		inst->state = INST_INVALID;
+		mutex_unlock(&inst->lock);
+	}
+
+	mutex_unlock(&hfi->lock);
+
+	handler = kzalloc(sizeof(*handler), GFP_KERNEL);
+	if (!handler)
+		return -ENOMEM;
+
+	handler->core = container_of(hfi, struct vidc_core, hfi);
+	INIT_DELAYED_WORK(&handler->work, vidc_sys_error_handler);
+
+	/*
+	 * Sleep for 5 sec to ensure venus has completed any
+	 * pending cache operations. Without this sleep, we see
+	 * device reset when firmware is unloaded after a sys
+	 * error.
+	 */
+	schedule_delayed_work(&handler->work, msecs_to_jiffies(5000));
+
+	return 0;
+}
+
+static const struct hfi_core_ops vidc_core_ops = {
+	.event_notify = vidc_event_notify,
+};
+
+static int vidc_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct vidc_core *core = video_drvdata(file);
+	struct vidc_inst *inst;
+	int ret;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&inst->registeredbufs);
+	mutex_init(&inst->registeredbufs_lock);
+
+	INIT_LIST_HEAD(&inst->internalbufs);
+	mutex_init(&inst->internalbufs_lock);
+
+	INIT_LIST_HEAD(&inst->bufqueue);
+	mutex_init(&inst->bufqueue_lock);
+
+	inst->core = core;
+
+	if (vdev == core->vdev_dec) {
+		inst->session_type = VIDC_SESSION_TYPE_DEC;
+		ret = vdec_open(inst);
+		if (ret)
+			goto err_free_inst;
+		v4l2_fh_init(&inst->fh, core->vdev_dec);
+	} else {
+		inst->session_type = VIDC_SESSION_TYPE_ENC;
+		ret = venc_open(inst);
+		if (ret)
+			goto err_free_inst;
+		v4l2_fh_init(&inst->fh, core->vdev_enc);
+	}
+
+	inst->fh.ctrl_handler = &inst->ctrl_handler;
+	v4l2_fh_add(&inst->fh);
+	file->private_data = &inst->fh;
+	vidc_add_inst(core, inst);
+
+	return 0;
+
+err_free_inst:
+	kfree(inst);
+	return ret;
+}
+
+static int vidc_close(struct file *file)
+{
+	struct vidc_inst *inst = to_inst(file);
+	struct vidc_core *core = inst->core;
+
+	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
+		vdec_close(inst);
+	else
+		venc_close(inst);
+
+	vidc_del_inst(core, inst);
+
+	mutex_destroy(&inst->bufqueue_lock);
+	mutex_destroy(&inst->registeredbufs_lock);
+	mutex_destroy(&inst->internalbufs_lock);
+
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
+
+	kfree(inst);
+	return 0;
+}
+
+static unsigned int vidc_poll(struct file *file, struct poll_table_struct *pt)
+{
+	struct vidc_inst *inst = to_inst(file);
+	struct vb2_queue *outq = &inst->bufq_out;
+	struct vb2_queue *capq = &inst->bufq_cap;
+	unsigned int ret;
+
+	ret = vb2_poll(outq, file, pt);
+	ret |= vb2_poll(capq, file, pt);
+
+	return ret;
+}
+
+static int vidc_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vidc_inst *inst = to_inst(file);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
+
+	if (offset < DST_QUEUE_OFF_BASE) {
+		ret = vb2_mmap(&inst->bufq_out, vma);
+	} else {
+		vma->vm_pgoff -= DST_QUEUE_OFF_BASE >> PAGE_SHIFT;
+		ret = vb2_mmap(&inst->bufq_cap, vma);
+	}
+
+	return ret;
+}
+
+const struct v4l2_file_operations vidc_fops = {
+	.owner = THIS_MODULE,
+	.open = vidc_open,
+	.release = vidc_close,
+	.unlocked_ioctl = video_ioctl2,
+	.poll = vidc_poll,
+	.mmap = vidc_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = v4l2_compat_ioctl32,
+#endif
+};
+
+static irqreturn_t vidc_isr_thread(int irq, void *dev_id)
+{
+	return vidc_hfi_isr_thread(irq, dev_id);
+}
+
+static irqreturn_t vidc_isr(int irq, void *dev)
+{
+	return vidc_hfi_isr(irq, dev);
+}
+
+static int vidc_clks_get(struct vidc_core *core, unsigned int clks_num,
+			 const char * const *clks_id)
+{
+	struct device *dev = core->dev;
+	unsigned int i;
+
+	for (i = 0; i < clks_num; i++) {
+		core->clks[i] = devm_clk_get(dev, clks_id[i]);
+		if (IS_ERR(core->clks[i]))
+			return PTR_ERR(core->clks[i]);
+	}
+
+	return 0;
+}
+
+static int
+vidc_clks_enable(struct vidc_core *core, const struct vidc_resources *res)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < res->clks_num; i++) {
+		ret = clk_prepare_enable(core->clks[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	while (--i)
+		clk_disable_unprepare(core->clks[i]);
+
+	return ret;
+}
+
+static void
+vidc_clks_disable(struct vidc_core *core, const struct vidc_resources *res)
+{
+	unsigned int i;
+
+	for (i = 0; i < res->clks_num; i++)
+		clk_disable_unprepare(core->clks[i]);
+}
+
+static int vidc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct vidc_core *core;
+	struct device_node *rproc;
+	struct resource *r;
+	int ret;
+
+	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
+	if (!core)
+		return -ENOMEM;
+
+	core->dev = dev;
+	platform_set_drvdata(pdev, core);
+
+	rproc = of_parse_phandle(dev->of_node, "rproc", 0);
+	if (IS_ERR(rproc))
+		return PTR_ERR(rproc);
+
+	core->rproc = rproc_get_by_phandle(rproc->phandle);
+	if (IS_ERR(core->rproc))
+		return PTR_ERR(core->rproc);
+	else if (!core->rproc)
+		return -EPROBE_DEFER;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	core->base = devm_ioremap_resource(dev, r);
+	if (IS_ERR(core->base))
+		return PTR_ERR(core->base);
+
+	core->irq = platform_get_irq(pdev, 0);
+	if (core->irq < 0)
+		return core->irq;
+
+	core->res = of_device_get_match_data(dev);
+	if (!core->res)
+		return -ENODEV;
+
+	ret = vidc_clks_get(core, core->res->clks_num, core->res->clks);
+	if (ret)
+		return ret;
+
+	ret = dma_set_mask_and_coherent(dev, core->res->dma_mask);
+	if (ret)
+		return ret;
+
+	INIT_LIST_HEAD(&core->instances);
+	mutex_init(&core->lock);
+
+	ret = devm_request_threaded_irq(dev, core->irq, vidc_isr,
+					vidc_isr_thread,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					"vidc", &core->hfi);
+	if (ret)
+		return ret;
+
+	core->hfi.core_ops = &vidc_core_ops;
+	core->hfi.dev = dev;
+
+	ret = vidc_hfi_create(&core->hfi, core->res, core->base);
+	if (ret)
+		return ret;
+
+	ret = vidc_clks_enable(core, core->res);
+	if (ret)
+		goto err_hfi_destroy;
+
+	ret = rproc_boot(core->rproc);
+	if (ret) {
+		vidc_clks_disable(core, core->res);
+		goto err_hfi_destroy;
+	}
+
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_runtime_disable;
+
+	ret = vidc_hfi_core_init(&core->hfi);
+	if (ret)
+		goto err_rproc_shutdown;
+
+	ret = pm_runtime_put_sync(dev);
+	if (ret)
+		goto err_core_deinit;
+
+	vidc_clks_disable(core, core->res);
+
+	ret = v4l2_device_register(dev, &core->v4l2_dev);
+	if (ret)
+		goto err_core_deinit;
+
+	core->vdev_dec = video_device_alloc();
+	if (!core->vdev_dec) {
+		ret = -ENOMEM;
+		goto err_dev_unregister;
+	}
+
+	core->vdev_enc = video_device_alloc();
+	if (!core->vdev_enc) {
+		ret = -ENOMEM;
+		goto err_dec_release;
+	}
+
+	ret = vdec_init(core, core->vdev_dec, &vidc_fops);
+	if (ret)
+		goto err_enc_release;
+
+	ret = venc_init(core, core->vdev_enc, &vidc_fops);
+	if (ret)
+		goto err_vdec_deinit;
+
+	return 0;
+
+err_vdec_deinit:
+	vdec_deinit(core, core->vdev_dec);
+err_enc_release:
+	video_device_release(core->vdev_enc);
+err_dec_release:
+	video_device_release(core->vdev_dec);
+err_dev_unregister:
+	v4l2_device_unregister(&core->v4l2_dev);
+err_core_deinit:
+	vidc_hfi_core_deinit(&core->hfi);
+err_rproc_shutdown:
+	rproc_shutdown(core->rproc);
+err_runtime_disable:
+	pm_runtime_set_suspended(dev);
+	pm_runtime_disable(dev);
+err_hfi_destroy:
+	vidc_hfi_destroy(&core->hfi);
+	return ret;
+}
+
+static int vidc_remove(struct platform_device *pdev)
+{
+	struct vidc_core *core = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		return ret;
+
+	ret = vidc_hfi_core_deinit(&core->hfi);
+	if (ret) {
+		pm_runtime_put_sync(&pdev->dev);
+		return ret;
+	}
+
+	rproc_shutdown(core->rproc);
+
+	ret = pm_runtime_put_sync(&pdev->dev);
+
+	vidc_hfi_destroy(&core->hfi);
+	vdec_deinit(core, core->vdev_dec);
+	venc_deinit(core, core->vdev_enc);
+	v4l2_device_unregister(&core->v4l2_dev);
+	video_device_release(core->vdev_enc);
+	video_device_release(core->vdev_dec);
+
+	pm_runtime_disable(core->dev);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int vidc_runtime_suspend(struct device *dev)
+{
+	struct vidc_core *core = dev_get_drvdata(dev);
+	int ret;
+
+	ret = vidc_hfi_core_suspend(&core->hfi);
+
+	vidc_clks_disable(core, core->res);
+
+	return ret;
+}
+
+static int vidc_runtime_resume(struct device *dev)
+{
+	struct vidc_core *core = dev_get_drvdata(dev);
+	int ret;
+
+	ret = vidc_clks_enable(core, core->res);
+	if (ret)
+		return ret;
+
+	return vidc_hfi_core_resume(&core->hfi);
+}
+
+static int vidc_pm_suspend(struct device *dev)
+{
+	return vidc_runtime_suspend(dev);
+}
+
+static int vidc_pm_resume(struct device *dev)
+{
+	return vidc_runtime_resume(dev);
+}
+
+static const struct dev_pm_ops vidc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(vidc_pm_suspend, vidc_pm_resume)
+	SET_RUNTIME_PM_OPS(vidc_runtime_suspend, vidc_runtime_resume, NULL)
+};
+
+static const struct freq_tbl msm8916_freq_table[] = {
+	{ 352800, 228570000 },	/* 1920x1088 @ 30 + 1280x720 @ 30 */
+	{ 244800, 160000000 },	/* 1920x1088 @ 30 */
+	{ 108000, 100000000 },	/* 1280x720 @ 30 */
+};
+
+static const struct reg_val msm8916_reg_preset[] = {
+	{ 0xe0020, 0x05555556 },
+	{ 0xe0024, 0x05555556 },
+	{ 0x80124, 0x00000003 },
+};
+
+static const struct vidc_resources msm8916_res = {
+	.freq_tbl = msm8916_freq_table,
+	.freq_tbl_size = ARRAY_SIZE(msm8916_freq_table),
+	.reg_tbl = msm8916_reg_preset,
+	.reg_tbl_size = ARRAY_SIZE(msm8916_reg_preset),
+	.clks = {"core", "iface", "bus", },
+	.clks_num = 3,
+	.max_load = 352800, /* 720p@30 + 1080p@30 */
+	.hfi_version = 0,
+	.vmem_id = VIDC_RESOURCE_NONE,
+	.vmem_size = 0,
+	.vmem_addr = 0,
+	.dma_mask = 0xddc00000 - 1,
+};
+
+static const struct of_device_id vidc_dt_match[] = {
+	{ .compatible = "qcom,vidc-msm8916", .data = &msm8916_res, },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, vidc_dt_match);
+
+static struct platform_driver qcom_vidc_driver = {
+	.probe = vidc_probe,
+	.remove = vidc_remove,
+	.driver = {
+		.name = "qcom-vidc",
+		.of_match_table = vidc_dt_match,
+		.pm = &vidc_pm_ops,
+	},
+};
+
+module_platform_driver(qcom_vidc_driver);
+
+MODULE_ALIAS("platform:qcom-vidc");
+MODULE_DESCRIPTION("Qualcomm video encoder and decoder driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/qcom/vidc/core.h b/drivers/media/platform/qcom/vidc/core.h
new file mode 100644
index 000000000000..9a65c7fb469c
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/core.h
@@ -0,0 +1,207 @@
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
+
+#ifndef __VIDC_CORE_H_
+#define __VIDC_CORE_H_
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
+
+#include "hfi.h"
+
+#define VIDC_DRV_NAME		"vidc"
+
+/* structures needed to diferenciate resources per version/SoC */
+#define VIDC_CLKS_NUM_MAX	7
+
+struct freq_tbl {
+	unsigned int load;
+	unsigned long freq;
+};
+
+struct reg_val {
+	u32 reg;
+	u32 value;
+};
+
+struct vidc_resources {
+	u64 dma_mask;
+	const struct freq_tbl *freq_tbl;
+	unsigned int freq_tbl_size;
+	const struct reg_val *reg_tbl;
+	unsigned int reg_tbl_size;
+	const char *clks[VIDC_CLKS_NUM_MAX];
+	unsigned int clks_num;
+	unsigned int hfi_version;
+	u32 max_load;
+	unsigned int vmem_id;
+	u32 vmem_size;
+	u32 vmem_addr;
+};
+
+struct vidc_format {
+	u32 pixfmt;
+	int num_planes;
+	u32 type;
+};
+
+struct vidc_core {
+	void __iomem *base;
+	int irq;
+	struct clk *clks[VIDC_CLKS_NUM_MAX];
+	struct mutex lock;
+	struct hfi_core hfi;
+	struct video_device *vdev_dec;
+	struct video_device *vdev_enc;
+	struct v4l2_device v4l2_dev;
+	struct list_head instances;
+	const struct vidc_resources *res;
+	struct rproc *rproc;
+	struct device *dev;
+};
+
+struct vdec_controls {
+	u32 post_loop_deb_mode;
+	u32 profile;
+	u32 level;
+};
+
+struct venc_controls {
+	u16 gop_size;
+	u32 idr_period;
+	u32 num_p_frames;
+	u32 num_b_frames;
+	u32 bitrate_mode;
+	u32 bitrate;
+	u32 bitrate_peak;
+
+	u32 h264_i_period;
+	u32 h264_entropy_mode;
+	u32 h264_i_qp;
+	u32 h264_p_qp;
+	u32 h264_b_qp;
+	u32 h264_min_qp;
+	u32 h264_max_qp;
+	u32 h264_loop_filter_mode;
+	u32 h264_loop_filter_alpha;
+	u32 h264_loop_filter_beta;
+
+	u32 vp8_min_qp;
+	u32 vp8_max_qp;
+
+	u32 multi_slice_mode;
+	u32 multi_slice_max_bytes;
+	u32 multi_slice_max_mb;
+
+	u32 header_mode;
+
+	u32 profile;
+	u32 level;
+};
+
+struct vidc_inst {
+	struct list_head list;
+	struct vidc_core *core;
+
+	struct list_head internalbufs;
+	struct mutex internalbufs_lock;
+
+	struct list_head registeredbufs;
+	struct mutex registeredbufs_lock;
+
+	struct list_head bufqueue;
+	struct mutex bufqueue_lock;
+
+	struct vb2_queue bufq_out;
+	struct vb2_queue bufq_cap;
+
+	struct v4l2_ctrl_handler ctrl_handler;
+	union {
+		struct vdec_controls dec;
+		struct venc_controls enc;
+	} controls;
+	struct v4l2_fh fh;
+
+	struct hfi_inst *hfi_inst;
+
+	/* session fields */
+	u32 session_type;
+	u32 width;
+	u32 height;
+	u32 out_width;
+	u32 out_height;
+	u32 colorspace;
+	u8 ycbcr_enc;
+	u8 quantization;
+	u8 xfer_func;
+	u64 fps;
+	struct v4l2_fract timeperframe;
+	const struct vidc_format *fmt_out;
+	const struct vidc_format *fmt_cap;
+	unsigned int num_input_bufs;
+	unsigned int num_output_bufs;
+	bool in_reconfig;
+	u32 reconfig_width;
+	u32 reconfig_height;
+	u64 sequence;
+};
+
+#define ctrl_to_inst(ctrl)	\
+	container_of(ctrl->handler, struct vidc_inst, ctrl_handler)
+
+struct vidc_ctrl {
+	u32 id;
+	enum v4l2_ctrl_type type;
+	s32 min;
+	s32 max;
+	s32 def;
+	u32 step;
+	u64 menu_skip_mask;
+	u32 flags;
+	const char * const *qmenu;
+};
+
+/*
+ * Offset base for buffers on the destination queue - used to distinguish
+ * between source and destination buffers when mmapping - they receive the same
+ * offsets but for different queues
+ */
+#define DST_QUEUE_OFF_BASE	(1 << 30)
+
+static inline struct vidc_inst *to_inst(struct file *filp)
+{
+	return container_of(filp->private_data, struct vidc_inst, fh);
+}
+
+static inline struct hfi_inst *to_hfi_inst(struct file *filp)
+{
+	return to_inst(filp)->hfi_inst;
+}
+
+static inline struct vb2_queue *
+vidc_to_vb2q(struct file *file, enum v4l2_buf_type type)
+{
+	struct vidc_inst *inst = to_inst(file);
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return &inst->bufq_cap;
+	else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return &inst->bufq_out;
+
+	return NULL;
+}
+
+#endif
diff --git a/drivers/media/platform/qcom/vidc/helpers.c b/drivers/media/platform/qcom/vidc/helpers.c
new file mode 100644
index 000000000000..ce2d6b62fcf3
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/helpers.c
@@ -0,0 +1,604 @@
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
+#include <linux/clk.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "helpers.h"
+#include "hfi_helper.h"
+
+struct intbuf {
+	struct list_head list;
+	u32 type;
+	size_t size;
+	void *va;
+	dma_addr_t da;
+	unsigned long attrs;
+};
+
+static int intbufs_alloc_and_set(struct vidc_inst *inst,
+				 struct hfi_buffer_requirements *bufreq)
+{
+	struct device *dev = inst->core->dev;
+	struct hfi_core *hfi = &inst->core->hfi;
+	struct hfi_buffer_desc bd;
+	struct intbuf *buf;
+	unsigned int i;
+	int ret;
+
+	if (!bufreq->size)
+		return 0;
+
+	for (i = 0; i < bufreq->count_actual; i++) {
+		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		buf->type = bufreq->type;
+		buf->size = bufreq->size;
+		buf->attrs = DMA_ATTR_WRITE_COMBINE |
+			     DMA_ATTR_NO_KERNEL_MAPPING;
+		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
+					  buf->attrs);
+		if (!buf->va) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		memset(&bd, 0, sizeof(bd));
+		bd.buffer_size = buf->size;
+		bd.buffer_type = buf->type;
+		bd.num_buffers = 1;
+		bd.device_addr = buf->da;
+
+		ret = vidc_hfi_session_set_buffers(hfi, inst->hfi_inst, &bd);
+		if (ret) {
+			dev_err(dev, "set session buffers failed\n");
+			goto fail;
+		}
+
+		mutex_lock(&inst->internalbufs_lock);
+		list_add_tail(&buf->list, &inst->internalbufs);
+		mutex_unlock(&inst->internalbufs_lock);
+	}
+
+	return 0;
+
+fail:
+	kfree(buf);
+	return ret;
+}
+
+static int intbufs_set_buffer(struct vidc_inst *inst, u32 type)
+{
+	struct hfi_buffer_requirements bufreq;
+	int ret;
+
+	ret = vidc_get_bufreq(inst, type, &bufreq);
+	if (ret)
+		return 0;
+
+	return intbufs_alloc_and_set(inst, &bufreq);
+}
+
+static int intbufs_unset_buffers(struct vidc_inst *inst)
+{
+	struct hfi_core *hfi = &inst->core->hfi;
+	struct hfi_buffer_desc bd = {0};
+	struct intbuf *buf, *n;
+	int ret = 0;
+
+	mutex_lock(&inst->internalbufs_lock);
+	list_for_each_entry_safe(buf, n, &inst->internalbufs, list) {
+		bd.buffer_size = buf->size;
+		bd.buffer_type = buf->type;
+		bd.num_buffers = 1;
+		bd.device_addr = buf->da;
+		bd.response_required = true;
+
+		ret = vidc_hfi_session_unset_buffers(hfi, inst->hfi_inst, &bd);
+
+		list_del(&buf->list);
+		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
+			       buf->attrs);
+		kfree(buf);
+	}
+	mutex_unlock(&inst->internalbufs_lock);
+
+	return ret;
+}
+
+static const unsigned int intbuf_types[] = {
+	HFI_BUFFER_INTERNAL_SCRATCH,
+	HFI_BUFFER_INTERNAL_SCRATCH_1,
+	HFI_BUFFER_INTERNAL_SCRATCH_2,
+	HFI_BUFFER_INTERNAL_PERSIST,
+	HFI_BUFFER_INTERNAL_PERSIST_1,
+};
+
+static int internal_bufs_alloc(struct vidc_inst *inst)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(intbuf_types); i++) {
+		ret = intbufs_set_buffer(inst, intbuf_types[i]);
+		if (ret)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	intbufs_unset_buffers(inst);
+	return ret;
+}
+
+static int internal_bufs_free(struct vidc_inst *inst)
+{
+	return intbufs_unset_buffers(inst);
+}
+
+static u32 load_per_instance(struct vidc_inst *inst)
+{
+	u32 w = inst->width;
+	u32 h = inst->height;
+	u32 mbs;
+
+	if (!inst->hfi_inst || !(inst->hfi_inst->state >= INST_INIT &&
+				 inst->hfi_inst->state < INST_STOP))
+		return 0;
+
+	mbs = (ALIGN(w, 16) / 16) * (ALIGN(h, 16) / 16);
+
+	return mbs * inst->fps;
+}
+
+static u32 load_per_type(struct vidc_core *core, u32 session_type)
+{
+	struct vidc_inst *inst = NULL;
+	u64 mbs_per_sec = 0;
+
+	mutex_lock(&core->lock);
+	list_for_each_entry(inst, &core->instances, list) {
+		if (inst->session_type != session_type)
+			continue;
+
+		mbs_per_sec += load_per_instance(inst);
+	}
+	mutex_unlock(&core->lock);
+
+	return mbs_per_sec;
+}
+
+static int load_scale_clocks(struct vidc_core *core)
+{
+	const struct freq_tbl *table = core->res->freq_tbl;
+	unsigned int num_rows = core->res->freq_tbl_size;
+	unsigned long freq = table[0].freq;
+	struct clk *clk = core->clks[0];
+	struct device *dev = core->dev;
+	u32 mbs_per_sec;
+	unsigned int i;
+	int ret;
+
+	mbs_per_sec = load_per_type(core, VIDC_SESSION_TYPE_ENC) +
+		      load_per_type(core, VIDC_SESSION_TYPE_DEC);
+
+	if (mbs_per_sec > core->res->max_load) {
+		dev_warn(dev, "HW is overloaded, needed: %d max: %d\n",
+			 mbs_per_sec, core->res->max_load);
+		return -EBUSY;
+	}
+
+	if (!mbs_per_sec && num_rows > 1) {
+		freq = table[num_rows - 1].freq;
+		goto set_freq;
+	}
+
+	for (i = 0; i < num_rows; i++) {
+		if (mbs_per_sec > table[i].load)
+			break;
+		freq = table[i].freq;
+	}
+
+set_freq:
+
+	ret = clk_set_rate(clk, freq);
+	if (ret) {
+		dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int session_set_buf(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *q = vb->vb2_queue;
+	struct vidc_inst *inst = vb2_get_drv_priv(q);
+	struct vidc_core *core = inst->core;
+	struct device *dev = core->dev;
+	struct hfi_core *hfi = &core->hfi;
+	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
+	struct hfi_frame_data fdata;
+	int ret;
+
+	memset(&fdata, 0, sizeof(fdata));
+
+	fdata.alloc_len = vb2_plane_size(vb, 0);
+	fdata.device_addr = buf->dma_addr;
+	fdata.timestamp = vb->timestamp;
+	fdata.flags = 0;
+	fdata.clnt_data = buf->dma_addr;
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fdata.buffer_type = HFI_BUFFER_INPUT;
+		fdata.filled_len = vb2_get_plane_payload(vb, 0);
+		fdata.offset = vb->planes[0].data_offset;
+
+		if (vbuf->flags & V4L2_BUF_FLAG_LAST || !fdata.filled_len)
+			fdata.flags |= HFI_BUFFERFLAG_EOS;
+
+		ret = vidc_hfi_session_etb(hfi, inst->hfi_inst, &fdata);
+	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fdata.buffer_type = HFI_BUFFER_OUTPUT;
+		fdata.filled_len = 0;
+		fdata.offset = 0;
+
+		ret = vidc_hfi_session_ftb(hfi, inst->hfi_inst, &fdata);
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(dev, "failed to set session buffer (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int session_unregister_bufs(struct vidc_inst *inst)
+{
+	struct device *dev = inst->core->dev;
+	struct hfi_core *hfi = &inst->core->hfi;
+	struct hfi_buffer_desc *bd;
+	struct vidc_buffer *buf, *tmp;
+	int ret = 0;
+
+	mutex_lock(&inst->registeredbufs_lock);
+	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs, hfi_list) {
+		list_del(&buf->hfi_list);
+		bd = &buf->bd;
+		bd->response_required = 1;
+		ret = vidc_hfi_session_unset_buffers(hfi, inst->hfi_inst, bd);
+		if (ret) {
+			dev_err(dev, "%s: session release buffers failed\n",
+				__func__);
+			break;
+		}
+	}
+	mutex_unlock(&inst->registeredbufs_lock);
+
+	return ret;
+}
+
+static int session_register_bufs(struct vidc_inst *inst)
+{
+	struct device *dev = inst->core->dev;
+	struct hfi_core *hfi = &inst->core->hfi;
+	struct hfi_buffer_desc *bd;
+	struct vidc_buffer *buf, *tmp;
+	int ret = 0;
+
+	mutex_lock(&inst->registeredbufs_lock);
+	list_for_each_entry_safe(buf, tmp, &inst->registeredbufs, hfi_list) {
+		bd = &buf->bd;
+		ret = vidc_hfi_session_set_buffers(hfi, inst->hfi_inst, bd);
+		if (ret) {
+			dev_err(dev, "%s: session: set buffer failed\n",
+				__func__);
+			break;
+		}
+	}
+	mutex_unlock(&inst->registeredbufs_lock);
+
+	return ret;
+}
+
+int vidc_get_bufreq(struct vidc_inst *inst, u32 type,
+		    struct hfi_buffer_requirements *out)
+{
+	struct hfi_core *hfi = &inst->core->hfi;
+	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
+	union hfi_get_property hprop;
+	int ret, i;
+
+	if (out)
+		memset(out, 0, sizeof(*out));
+
+	ret = vidc_hfi_session_get_property(hfi, inst->hfi_inst, ptype, &hprop);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+
+	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
+		if (hprop.bufreq[i].type != type)
+			continue;
+
+		if (out)
+			memcpy(out, &hprop.bufreq[i], sizeof(*out));
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+int vidc_set_color_format(struct vidc_inst *inst, u32 type, u32 pixfmt)
+{
+	struct hfi_uncompressed_format_select fmt;
+	struct hfi_core *hfi = &inst->core->hfi;
+	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
+	int ret;
+
+	fmt.buffer_type = type;
+
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_NV12:
+		fmt.format = HFI_COLOR_FORMAT_NV12;
+		break;
+	case V4L2_PIX_FMT_NV21:
+		fmt.format = HFI_COLOR_FORMAT_NV21;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = vidc_hfi_session_set_property(hfi, inst->hfi_inst, ptype, &fmt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+struct vb2_v4l2_buffer *
+vidc_vb2_find_buf(struct vidc_inst *inst, dma_addr_t addr)
+{
+	struct vidc_buffer *buf;
+	struct vb2_v4l2_buffer *vb = NULL;
+
+	mutex_lock(&inst->bufqueue_lock);
+
+	list_for_each_entry(buf, &inst->bufqueue, list) {
+		if (buf->dma_addr == addr) {
+			vb = &buf->vb;
+			break;
+		}
+	}
+
+	if (vb)
+		list_del(&buf->list);
+
+	mutex_unlock(&inst->bufqueue_lock);
+
+	return vb;
+}
+
+int vidc_vb2_buf_init(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vb2_queue *q = vb->vb2_queue;
+	struct vidc_inst *inst = vb2_get_drv_priv(q);
+	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
+	struct hfi_buffer_desc *bd = &buf->bd;
+	struct sg_table *sgt;
+
+	memset(bd, 0, sizeof(*bd));
+
+	if (q->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return 0;
+
+	sgt = vb2_dma_sg_plane_desc(vb, 0);
+	if (!sgt)
+		return -EINVAL;
+
+	bd->buffer_size = vb2_plane_size(vb, 0);
+	bd->buffer_type = HFI_BUFFER_OUTPUT;
+	bd->num_buffers = 1;
+	bd->device_addr = sg_dma_address(sgt->sgl);
+
+	mutex_lock(&inst->registeredbufs_lock);
+	list_add_tail(&buf->hfi_list, &inst->registeredbufs);
+	mutex_unlock(&inst->registeredbufs_lock);
+
+	return 0;
+}
+
+int vidc_vb2_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
+	struct sg_table *sgt;
+
+	sgt = vb2_dma_sg_plane_desc(vb, 0);
+	if (!sgt)
+		return -EINVAL;
+
+	buf->dma_addr = sg_dma_address(sgt->sgl);
+
+	return 0;
+}
+
+void vidc_vb2_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vidc_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+	struct vidc_core *core = inst->core;
+	struct device *dev = core->dev;
+	struct vidc_buffer *buf = to_vidc_buffer(vbuf);
+	unsigned int state;
+	int ret;
+
+	mutex_lock(&inst->hfi_inst->lock);
+	state = inst->hfi_inst->state;
+	mutex_unlock(&inst->hfi_inst->lock);
+
+	if (state == INST_INVALID || state >= INST_STOP) {
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		dev_dbg(dev, "%s: type:%d, invalid instance state\n", __func__,
+			vb->type);
+		return;
+	}
+
+	mutex_lock(&inst->bufqueue_lock);
+	list_add_tail(&buf->list, &inst->bufqueue);
+	mutex_unlock(&inst->bufqueue_lock);
+
+	if (!vb2_is_streaming(&inst->bufq_cap) ||
+	    !vb2_is_streaming(&inst->bufq_out))
+		return;
+
+	ret = session_set_buf(vb);
+	if (ret)
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+}
+
+void vidc_vb2_stop_streaming(struct vb2_queue *q)
+{
+	struct vidc_inst *inst = vb2_get_drv_priv(q);
+	struct hfi_inst *hfi_inst = inst->hfi_inst;
+	struct vidc_core *core = inst->core;
+	struct device *dev = core->dev;
+	struct hfi_core *hfi = &core->hfi;
+	struct vb2_queue *other_queue;
+	struct vidc_buffer *buf, *n;
+	enum vb2_buffer_state state;
+	int ret;
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		other_queue = &inst->bufq_cap;
+	else
+		other_queue = &inst->bufq_out;
+
+	if (!vb2_is_streaming(other_queue))
+		return;
+
+	ret = vidc_hfi_session_stop(hfi, inst->hfi_inst);
+	if (ret) {
+		dev_err(dev, "session: stop failed (%d)\n", ret);
+		goto abort;
+	}
+
+	ret = vidc_hfi_session_unload_res(hfi, inst->hfi_inst);
+	if (ret) {
+		dev_err(dev, "session: release resources failed (%d)\n", ret);
+		goto abort;
+	}
+
+	ret = session_unregister_bufs(inst);
+	if (ret) {
+		dev_err(dev, "failed to release capture buffers: %d\n", ret);
+		goto abort;
+	}
+
+	ret = internal_bufs_free(inst);
+
+	if (hfi_inst->state == INST_INVALID || hfi->state == CORE_INVALID) {
+		ret = -EINVAL;
+		goto abort;
+	}
+
+abort:
+	if (ret)
+		vidc_hfi_session_abort(hfi, inst->hfi_inst);
+
+	load_scale_clocks(inst->core);
+
+	ret = vidc_hfi_session_deinit(hfi, inst->hfi_inst);
+	if (ret)
+		dev_err(dev, "stop streaming failed type: %d, ret: %d\n",
+			q->type, ret);
+
+	ret = pm_runtime_put_sync(dev);
+	if (ret < 0)
+		dev_err(dev, "%s: pm_runtime_put_sync (%d)\n", __func__, ret);
+
+	mutex_lock(&inst->bufqueue_lock);
+
+	if (list_empty(&inst->bufqueue)) {
+		mutex_unlock(&inst->bufqueue_lock);
+		return;
+	}
+
+	if (ret)
+		state = VB2_BUF_STATE_ERROR;
+	else
+		state = VB2_BUF_STATE_DONE;
+
+	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
+		list_del(&buf->list);
+	}
+
+	mutex_unlock(&inst->bufqueue_lock);
+}
+
+int vidc_vb2_start_streaming(struct vidc_inst *inst)
+{
+	struct device *dev = inst->core->dev;
+	struct hfi_core *hfi = &inst->core->hfi;
+	struct vidc_buffer *buf, *n;
+	int ret;
+
+	ret = session_register_bufs(inst);
+	if (ret)
+		return ret;
+
+	ret = internal_bufs_alloc(inst);
+	if (ret)
+		return ret;
+
+	load_scale_clocks(inst->core);
+
+	ret = vidc_hfi_session_load_res(hfi, inst->hfi_inst);
+	if (ret) {
+		dev_err(dev, "session: load resources (%d)\n", ret);
+		return ret;
+	}
+
+	ret = vidc_hfi_session_start(hfi, inst->hfi_inst);
+	if (ret) {
+		dev_err(dev, "session: start failed (%d)\n", ret);
+		return ret;
+	}
+
+	mutex_lock(&inst->bufqueue_lock);
+	list_for_each_entry_safe(buf, n, &inst->bufqueue, list) {
+		ret = session_set_buf(&buf->vb.vb2_buf);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&inst->bufqueue_lock);
+
+	return ret;
+}
diff --git a/drivers/media/platform/qcom/vidc/helpers.h b/drivers/media/platform/qcom/vidc/helpers.h
new file mode 100644
index 000000000000..e37d4d5c980b
--- /dev/null
+++ b/drivers/media/platform/qcom/vidc/helpers.h
@@ -0,0 +1,43 @@
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
+#ifndef __VIDC_COMMON_H__
+#define __VIDC_COMMON_H__
+
+#include <linux/list.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "core.h"
+
+struct vidc_buffer {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+	dma_addr_t dma_addr;
+	struct list_head hfi_list;
+	struct hfi_buffer_desc bd;
+};
+
+#define to_vidc_buffer(buf)	container_of(buf, struct vidc_buffer, vb)
+
+struct vb2_v4l2_buffer *
+vidc_vb2_find_buf(struct vidc_inst *inst, dma_addr_t addr);
+int vidc_vb2_buf_init(struct vb2_buffer *vb);
+int vidc_vb2_buf_prepare(struct vb2_buffer *vb);
+void vidc_vb2_buf_queue(struct vb2_buffer *vb);
+void vidc_vb2_stop_streaming(struct vb2_queue *q);
+int vidc_vb2_start_streaming(struct vidc_inst *inst);
+int vidc_get_bufreq(struct vidc_inst *inst, u32 type,
+		    struct hfi_buffer_requirements *out);
+int vidc_set_color_format(struct vidc_inst *inst, u32 type, u32 fmt);
+#endif
-- 
2.7.4

