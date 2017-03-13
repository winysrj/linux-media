Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35065 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754130AbdCMQiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 12:38:18 -0400
Received: by mail-wm0-f41.google.com with SMTP id v186so44918438wmd.0
        for <linux-media@vger.kernel.org>; Mon, 13 Mar 2017 09:38:17 -0700 (PDT)
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
Subject: [PATCH v7 4/9] media: venus: adding core part and helper functions
Date: Mon, 13 Mar 2017 18:37:33 +0200
Message-Id: <1489423058-12492-5-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

 * firmware loader

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c     | 386 ++++++++++++++++
 drivers/media/platform/qcom/venus/core.h     | 306 +++++++++++++
 drivers/media/platform/qcom/venus/firmware.c | 107 +++++
 drivers/media/platform/qcom/venus/firmware.h |  22 +
 drivers/media/platform/qcom/venus/helpers.c  | 632 +++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h  |  41 ++
 6 files changed, 1494 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/core.c
 create mode 100644 drivers/media/platform/qcom/venus/core.h
 create mode 100644 drivers/media/platform/qcom/venus/firmware.c
 create mode 100644 drivers/media/platform/qcom/venus/firmware.h
 create mode 100644 drivers/media/platform/qcom/venus/helpers.c
 create mode 100644 drivers/media/platform/qcom/venus/helpers.h

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
new file mode 100644
index 000000000000..557b6ec4cc48
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -0,0 +1,386 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
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
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-ioctl.h>
+
+#include "core.h"
+#include "vdec.h"
+#include "venc.h"
+#include "firmware.h"
+
+static const struct hfi_core_ops venus_core_ops;
+
+static void venus_sys_error_handler(struct work_struct *work)
+{
+	struct venus_core *core =
+			container_of(work, struct venus_core, work.work);
+	int ret;
+
+	dev_warn(core->dev, "system error occurred, starting recovery!\n");
+
+	pm_runtime_get_sync(core->dev);
+
+	hfi_core_deinit(core, true);
+
+	hfi_destroy(core);
+
+	mutex_lock(&core->lock);
+
+	venus_shutdown(&core->dev_fw);
+
+	pm_runtime_put_sync(core->dev);
+
+	ret = hfi_create(core, &venus_core_ops);
+
+	pm_runtime_get_sync(core->dev);
+
+	ret = venus_boot(core->dev, &core->dev_fw);
+
+	ret = hfi_core_resume(core, true);
+
+	enable_irq(core->irq);
+
+	mutex_unlock(&core->lock);
+
+	ret = hfi_core_init(core);
+	if (ret)
+		dev_err(core->dev, "hfi_core_init (%d)\n", ret);
+
+	pm_runtime_put_sync(core->dev);
+
+	core->sys_error = false;
+}
+
+static void venus_event_notify(struct venus_core *core, u32 event)
+{
+	struct venus_inst *inst;
+
+	switch (event) {
+	case EVT_SYS_WATCHDOG_TIMEOUT:
+	case EVT_SYS_ERROR:
+		break;
+	default:
+		return;
+	}
+
+	mutex_lock(&core->lock);
+	core->sys_error = true;
+	list_for_each_entry(inst, &core->instances, list)
+		inst->ops->event_notify(inst, EVT_SESSION_ERROR, NULL);
+	mutex_unlock(&core->lock);
+
+	disable_irq_nosync(core->irq);
+
+	/*
+	 * Sleep for 5 sec to ensure venus has completed any pending cache
+	 * operations. Without this sleep, we see device reset when firmware is
+	 * unloaded after a system error.
+	 */
+	schedule_delayed_work(&core->work, msecs_to_jiffies(100));
+}
+
+static const struct hfi_core_ops venus_core_ops = {
+	.event_notify = venus_event_notify,
+};
+
+static int venus_clks_get(struct venus_core *core)
+{
+	const struct venus_resources *res = core->res;
+	struct device *dev = core->dev;
+	unsigned int i;
+
+	for (i = 0; i < res->clks_num; i++) {
+		core->clks[i] = devm_clk_get(dev, res->clks[i]);
+		if (IS_ERR(core->clks[i]))
+			return PTR_ERR(core->clks[i]);
+	}
+
+	return 0;
+}
+
+static int venus_clks_enable(struct venus_core *core)
+{
+	const struct venus_resources *res = core->res;
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
+static void venus_clks_disable(struct venus_core *core)
+{
+	const struct venus_resources *res = core->res;
+	unsigned int i = res->clks_num;
+
+	while (i--)
+		clk_disable_unprepare(core->clks[i]);
+}
+
+static int venus_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct venus_core *core;
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
+	ret = venus_clks_get(core);
+	if (ret)
+		return ret;
+
+	ret = dma_set_mask_and_coherent(dev, core->res->dma_mask);
+	if (ret)
+		return ret;
+
+	INIT_LIST_HEAD(&core->instances);
+	mutex_init(&core->lock);
+	INIT_DELAYED_WORK(&core->work, venus_sys_error_handler);
+
+	ret = devm_request_threaded_irq(dev, core->irq, hfi_isr, hfi_isr_thread,
+					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+					"venus", core);
+	if (ret)
+		return ret;
+
+	ret = hfi_create(core, &venus_core_ops);
+	if (ret)
+		return ret;
+
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_runtime_disable;
+
+	ret = venus_boot(dev, &core->dev_fw);
+	if (ret)
+		goto err_runtime_disable;
+
+	ret = hfi_core_resume(core, true);
+	if (ret)
+		goto err_venus_shutdown;
+
+	ret = hfi_core_init(core);
+	if (ret)
+		goto err_venus_shutdown;
+
+	ret = v4l2_device_register(dev, &core->v4l2_dev);
+	if (ret)
+		goto err_core_deinit;
+
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret)
+		goto err_dev_unregister;
+
+	ret = pm_runtime_put_sync(dev);
+	if (ret)
+		goto err_dev_unregister;
+
+	return 0;
+
+err_dev_unregister:
+	v4l2_device_unregister(&core->v4l2_dev);
+err_core_deinit:
+	hfi_core_deinit(core, false);
+err_venus_shutdown:
+	venus_shutdown(&core->dev_fw);
+err_runtime_disable:
+	pm_runtime_set_suspended(dev);
+	pm_runtime_disable(dev);
+	hfi_destroy(core);
+	return ret;
+}
+
+static int venus_remove(struct platform_device *pdev)
+{
+	struct venus_core *core = platform_get_drvdata(pdev);
+	struct device *dev = core->dev;
+	int ret;
+
+	ret = pm_runtime_get_sync(dev);
+	WARN_ON(ret < 0);
+
+	ret = hfi_core_deinit(core, true);
+	WARN_ON(ret);
+
+	hfi_destroy(core);
+	venus_shutdown(&core->dev_fw);
+	of_platform_depopulate(dev);
+
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
+
+	v4l2_device_unregister(&core->v4l2_dev);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int venus_runtime_suspend(struct device *dev)
+{
+	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
+
+	ret = hfi_core_suspend(core);
+
+	venus_clks_disable(core);
+
+	return ret;
+}
+
+static int venus_runtime_resume(struct device *dev)
+{
+	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
+
+	ret = venus_clks_enable(core);
+	if (ret)
+		return ret;
+
+	ret = hfi_core_resume(core, false);
+	if (ret)
+		goto err_clks_disable;
+
+	return 0;
+
+err_clks_disable:
+	venus_clks_disable(core);
+	return ret;
+}
+#endif
+
+static const struct dev_pm_ops venus_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(venus_runtime_suspend, venus_runtime_resume, NULL)
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
+static const struct venus_resources msm8916_res = {
+	.freq_tbl = msm8916_freq_table,
+	.freq_tbl_size = ARRAY_SIZE(msm8916_freq_table),
+	.reg_tbl = msm8916_reg_preset,
+	.reg_tbl_size = ARRAY_SIZE(msm8916_reg_preset),
+	.clks = { "core", "iface", "bus", },
+	.clks_num = 3,
+	.max_load = 352800, /* 720p@30 + 1080p@30 */
+	.hfi_version = HFI_VERSION_LEGACY,
+	.vmem_id = VIDC_RESOURCE_NONE,
+	.vmem_size = 0,
+	.vmem_addr = 0,
+	.dma_mask = 0xddc00000 - 1,
+};
+
+static const struct freq_tbl msm8996_freq_table[] = {
+	{ 1944000, 490000000 },	/* 4k UHD @ 60 */
+	{  972000, 320000000 },	/* 4k UHD @ 30 */
+	{  489600, 150000000 },	/* 1080p @ 60 */
+	{  244800,  75000000 },	/* 1080p @ 30 */
+};
+
+static const struct reg_val msm8996_reg_preset[] = {
+	{ 0x80010, 0xffffffff },
+	{ 0x80018, 0x00001556 },
+	{ 0x8001C, 0x00001556 },
+};
+
+static const struct venus_resources msm8996_res = {
+	.freq_tbl = msm8996_freq_table,
+	.freq_tbl_size = ARRAY_SIZE(msm8996_freq_table),
+	.reg_tbl = msm8996_reg_preset,
+	.reg_tbl_size = ARRAY_SIZE(msm8996_reg_preset),
+	.clks = {"core", "iface", "bus", "mbus" },
+	.clks_num = 4,
+	.max_load = 2563200,
+	.hfi_version = HFI_VERSION_3XX,
+	.vmem_id = VIDC_RESOURCE_NONE,
+	.vmem_size = 0,
+	.vmem_addr = 0,
+	.dma_mask = 0xddc00000 - 1,
+};
+
+static const struct of_device_id venus_dt_match[] = {
+	{ .compatible = "qcom,msm8916-venus", .data = &msm8916_res, },
+	{ .compatible = "qcom,msm8996-venus", .data = &msm8996_res, },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, venus_dt_match);
+
+static struct platform_driver qcom_venus_driver = {
+	.probe = venus_probe,
+	.remove = venus_remove,
+	.driver = {
+		.name = "qcom-venus",
+		.of_match_table = venus_dt_match,
+		.pm = &venus_pm_ops,
+	},
+};
+module_platform_driver(qcom_venus_driver);
+
+MODULE_ALIAS("platform:qcom-venus");
+MODULE_DESCRIPTION("Qualcomm Venus video encoder and decoder driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
new file mode 100644
index 000000000000..c2380c1a9ee5
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -0,0 +1,306 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
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
+#ifndef __VENUS_CORE_H_
+#define __VENUS_CORE_H_
+
+#include <linux/list.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#include "hfi.h"
+
+#define VIDC_CLKS_NUM_MAX	4
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
+struct venus_resources {
+	u64 dma_mask;
+	const struct freq_tbl *freq_tbl;
+	unsigned int freq_tbl_size;
+	const struct reg_val *reg_tbl;
+	unsigned int reg_tbl_size;
+	const char * const clks[VIDC_CLKS_NUM_MAX];
+	unsigned int clks_num;
+	enum hfi_version hfi_version;
+	u32 max_load;
+	unsigned int vmem_id;
+	u32 vmem_size;
+	u32 vmem_addr;
+};
+
+struct venus_format {
+	u32 pixfmt;
+	int num_planes;
+	u32 type;
+};
+
+/**
+ * struct venus_core - holds core parameters valid for all instances
+ *
+ * @base:	IO memory base address
+ * @irq:		Venus irq
+ * @clks:	an array of struct clk pointers
+ * @core0_clk:	a struct clk pointer for core0
+ * @core1_clk:	a struct clk pointer for core1
+ * @vdev_dec:	a reference to video device structure for decoder instances
+ * @vdev_enc:	a reference to video device structure for encoder instances
+ * @v4l2_dev:	a holder for v4l2 device structure
+ * @res:		a reference to venus resources structure
+ * @dev:		convinience struct device pointer
+ * @dev_dec:	convinience struct device pointer for decoder device
+ * @dev_enc:	convinience struct device pointer for encoder device
+ * @lock:	a lock for this strucure
+ * @instances:	a list_head of all instances
+ * @insts_count:	num of instances
+ * @state:	the state of the venus core
+ * @done:	a completion for sync HFI operations
+ * @error:	an error returned during last HFI sync operations
+ * @sys_error:	an error flag that signal system error event
+ * @core_ops:	the core operations
+ * @enc_codecs:	encoders supported by this core
+ * @dec_codecs:	decoders supported by this core
+ * @max_sessions_supported:	holds the maximum number of sessions
+ * @core_caps:	core capabilities
+ * @priv:	a private filed for HFI operations
+ * @ops:		the core HFI operations
+ * @work:	a delayed work for handling system fatal error
+ */
+struct venus_core {
+	void __iomem *base;
+	int irq;
+	struct clk *clks[VIDC_CLKS_NUM_MAX];
+	struct clk *core0_clk;
+	struct clk *core1_clk;
+	struct video_device *vdev_dec;
+	struct video_device *vdev_enc;
+	struct v4l2_device v4l2_dev;
+	const struct venus_resources *res;
+	struct device *dev;
+	struct device *dev_dec;
+	struct device *dev_enc;
+	struct device dev_fw;
+	struct mutex lock;
+	struct list_head instances;
+	atomic_t insts_count;
+	unsigned int state;
+	struct completion done;
+	unsigned int error;
+	bool sys_error;
+	const struct hfi_core_ops *core_ops;
+	u32 enc_codecs;
+	u32 dec_codecs;
+	unsigned int max_sessions_supported;
+#define ENC_ROTATION_CAPABILITY		0x1
+#define ENC_SCALING_CAPABILITY		0x2
+#define ENC_DEINTERLACE_CAPABILITY	0x4
+#define DEC_MULTI_STREAM_CAPABILITY	0x8
+	unsigned int core_caps;
+	void *priv;
+	const struct hfi_ops *ops;
+	struct delayed_work work;
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
+struct venus_buffer {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+	dma_addr_t dma_addr;
+	u32 size;
+	struct list_head reg_list;
+};
+
+#define to_venus_buffer(ptr)	container_of(ptr, struct venus_buffer, vb)
+
+/**
+ * struct venus_inst - holds per instance paramerters
+ *
+ * @list:	used for attach an instance to the core
+ * @lock:	instance lock
+ * @core:	a reference to the core struct
+ * @internalbufs:	a list of internal bufferes
+ * @registeredbufs:	a list of registered capture bufferes
+ * @ctrl_handler:	v4l control handler
+ * @controls:	an union of decoder and encoder control parameters
+ * @fh:	 a holder of v4l file handle structure
+ * @width:	current capture width
+ * @height:	current capture height
+ * @out_width:	current output width
+ * @out_height:	current output height
+ * @colorspace:	current color space
+ * @quantization:	current quantization
+ * @xfer_func:	current xfer function
+ * @fps:		holds current FPS
+ * @timeperframe:	holds current time per frame structure
+ * @fmt_out:	a reference to output format structure
+ * @fmt_cap:	a reference to capture format structure
+ * @num_input_bufs:	holds number of input buffers
+ * @num_output_bufs:	holds number of output buffers
+ * @input_buf_size	holds input buffer size
+ * @output_buf_size:	holds output buffer size
+ * @reconfig:	a flag raised by decoder when the stream resolution changed
+ * @reconfig_width:	holds the new width
+ * @reconfig_height:	holds the new height
+ * @sequence:		a sequence counter
+ * @codec_cfg:	a flag used to annonce a codec configuration
+ * @m2m_dev:	a reference to m2m device structure
+ * @m2m_ctx:	a reference to m2m context structure
+ * @state:	current state of the instance
+ * @done:	a completion for sync HFI operation
+ * @error:	an error returned during last HFI sync operation
+ * @session_error:	a flag rised by HFI interface in case of session error
+ * @ops:		HFI operations
+ * @priv:	a private for HFI operations callbacks
+ * @session_type:	the type of the session (decoder or encoder)
+ * @hprop:	an union used as a holder by get property
+ * @cap_width:	width capability
+ * @cap_height:	height capability
+ * @cap_mbs_per_frame:	macroblocks per frame capability
+ * @cap_mbs_per_sec:	macroblocks per second capability
+ * @cap_framerate:	framerate capability
+ * @cap_scale_x:		horizontal scaling capability
+ * @cap_scale_y:		vertical scaling capability
+ * @cap_bitrate:		bitrate capability
+ * @cap_hier_p:		hier capability
+ * @cap_ltr_count:	LTR count capability
+ * @cap_secure_output2_threshold: secure OUTPUT2 threshold capability
+ * @cap_bufs_mode_static:	buffers allocation mode capability
+ * @cap_bufs_mode_dynamic:	buffers allocation mode capability
+ * @pl_count:	count of supported profiles/levels
+ * @pl:		supported profiles/levels
+ * @bufreq:	holds buffer requirements
+ */
+struct venus_inst {
+	struct list_head list;
+	struct mutex lock;
+	struct venus_core *core;
+	struct list_head internalbufs;
+	struct list_head registeredbufs;
+
+	struct v4l2_ctrl_handler ctrl_handler;
+	union {
+		struct vdec_controls dec;
+		struct venc_controls enc;
+	} controls;
+	struct v4l2_fh fh;
+	unsigned int streamon_cap, streamon_out;
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
+	const struct venus_format *fmt_out;
+	const struct venus_format *fmt_cap;
+	unsigned int num_input_bufs;
+	unsigned int num_output_bufs;
+	unsigned int input_buf_size;
+	unsigned int output_buf_size;
+	bool reconfig;
+	u32 reconfig_width;
+	u32 reconfig_height;
+	u64 sequence;
+	bool codec_cfg;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct v4l2_m2m_ctx *m2m_ctx;
+	unsigned int state;
+	struct completion done;
+	unsigned int error;
+	bool session_error;
+	const struct hfi_inst_ops *ops;
+	u32 session_type;
+	union hfi_get_property hprop;
+	struct hfi_capability cap_width;
+	struct hfi_capability cap_height;
+	struct hfi_capability cap_mbs_per_frame;
+	struct hfi_capability cap_mbs_per_sec;
+	struct hfi_capability cap_framerate;
+	struct hfi_capability cap_scale_x;
+	struct hfi_capability cap_scale_y;
+	struct hfi_capability cap_bitrate;
+	struct hfi_capability cap_hier_p;
+	struct hfi_capability cap_ltr_count;
+	struct hfi_capability cap_secure_output2_threshold;
+	bool cap_bufs_mode_static;
+	bool cap_bufs_mode_dynamic;
+	unsigned int pl_count;
+	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
+	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
+};
+
+#define ctrl_to_inst(ctrl)	\
+	container_of(ctrl->handler, struct venus_inst, ctrl_handler)
+
+static inline struct venus_inst *to_inst(struct file *filp)
+{
+	return container_of(filp->private_data, struct venus_inst, fh);
+}
+
+static inline void *to_hfi_priv(struct venus_core *core)
+{
+	return core->priv;
+}
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
new file mode 100644
index 000000000000..e0601a94f3f0
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (C) 2017 Linaro Ltd.
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
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/slab.h>
+#include <linux/qcom_scm.h>
+#include <linux/soc/qcom/mdt_loader.h>
+
+#define VENUS_FIRMWARE_NAME		"venus.mdt"
+#define VENUS_PAS_ID			9
+#define VENUS_FW_MEM_SIZE		SZ_8M
+
+static void device_release_dummy(struct device *dev)
+{
+	of_reserved_mem_device_release(dev);
+}
+
+int venus_boot(struct device *parent, struct device *fw_dev)
+{
+	const struct firmware *mdt;
+	phys_addr_t mem_phys;
+	ssize_t fw_size;
+	size_t mem_size;
+	void *mem_va;
+	int ret;
+
+	if (!qcom_scm_is_available())
+		return -EPROBE_DEFER;
+
+	fw_dev->parent = parent;
+	fw_dev->release = device_release_dummy;
+
+	ret = dev_set_name(fw_dev, "%s:%s", dev_name(parent), "firmware");
+	if (ret)
+		return ret;
+
+	ret = device_register(fw_dev);
+	if (ret < 0)
+		return ret;
+
+	ret = of_reserved_mem_device_init_by_idx(fw_dev, parent->of_node, 0);
+	if (ret)
+		goto err_unreg_device;
+
+	mem_size = VENUS_FW_MEM_SIZE;
+
+	mem_va = dmam_alloc_coherent(fw_dev, mem_size, &mem_phys, GFP_KERNEL);
+	if (!mem_va) {
+		ret = -ENOMEM;
+		goto err_unreg_device;
+	}
+
+	ret = request_firmware(&mdt, VENUS_FIRMWARE_NAME, fw_dev);
+	if (ret < 0)
+		goto err_unreg_device;
+
+	fw_size = qcom_mdt_get_size(mdt);
+	if (fw_size < 0) {
+		ret = fw_size;
+		release_firmware(mdt);
+		goto err_unreg_device;
+	}
+
+	ret = qcom_mdt_load(fw_dev, mdt, VENUS_FIRMWARE_NAME, VENUS_PAS_ID,
+			    mem_va, mem_phys, mem_size);
+
+	release_firmware(mdt);
+
+	if (ret)
+		goto err_unreg_device;
+
+	ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
+	if (ret)
+		goto err_unreg_device;
+
+	return 0;
+
+err_unreg_device:
+	device_unregister(fw_dev);
+	return ret;
+}
+
+int venus_shutdown(struct device *fw_dev)
+{
+	int ret;
+
+	ret = qcom_scm_pas_shutdown(VENUS_PAS_ID);
+	device_unregister(fw_dev);
+	memset(fw_dev, 0, sizeof(*fw_dev));
+
+	return ret;
+}
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
new file mode 100644
index 000000000000..782e64ae291a
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2017 Linaro Ltd.
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
+#ifndef __VENUS_FIRMWARE_H__
+#define __VENUS_FIRMWARE_H__
+
+struct device;
+
+int venus_boot(struct device *parent, struct device *fw_dev);
+int venus_shutdown(struct device *fw_dev);
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
new file mode 100644
index 000000000000..2b4a3e3e04e2
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -0,0 +1,632 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
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
+#include <linux/slab.h>
+#include <media/videobuf2-dma-sg.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "core.h"
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
+static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
+{
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev;
+	struct hfi_buffer_requirements bufreq;
+	struct hfi_buffer_desc bd;
+	struct intbuf *buf;
+	unsigned int i;
+	int ret;
+
+	ret = helper_get_bufreq(inst, type, &bufreq);
+	if (ret)
+		return 0;
+
+	if (!bufreq.size)
+		return 0;
+
+	for (i = 0; i < bufreq.count_actual; i++) {
+		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		buf->type = bufreq.type;
+		buf->size = bufreq.size;
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
+		ret = hfi_session_set_buffers(inst, &bd);
+		if (ret) {
+			dev_err(dev, "set session buffers failed\n");
+			goto dma_free;
+		}
+
+		list_add_tail(&buf->list, &inst->internalbufs);
+	}
+
+	return 0;
+
+dma_free:
+	dma_free_attrs(dev, buf->size, buf->va, buf->da, buf->attrs);
+fail:
+	kfree(buf);
+	return ret;
+}
+
+static int intbufs_unset_buffers(struct venus_inst *inst)
+{
+	struct hfi_buffer_desc bd = {0};
+	struct intbuf *buf, *n;
+	int ret = 0;
+
+	list_for_each_entry_safe(buf, n, &inst->internalbufs, list) {
+		bd.buffer_size = buf->size;
+		bd.buffer_type = buf->type;
+		bd.num_buffers = 1;
+		bd.device_addr = buf->da;
+		bd.response_required = true;
+
+		ret = hfi_session_unset_buffers(inst, &bd);
+
+		list_del(&buf->list);
+		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
+			       buf->attrs);
+		kfree(buf);
+	}
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
+static int intbufs_alloc(struct venus_inst *inst)
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
+static int intbufs_free(struct venus_inst *inst)
+{
+	return intbufs_unset_buffers(inst);
+}
+
+static u32 load_per_instance(struct venus_inst *inst)
+{
+	u32 w = inst->width;
+	u32 h = inst->height;
+	u32 mbs;
+
+	if (!inst || !(inst->state >= INST_INIT && inst->state < INST_STOP))
+		return 0;
+
+	mbs = (ALIGN(w, 16) / 16) * (ALIGN(h, 16) / 16);
+
+	return mbs * inst->fps;
+}
+
+static u32 load_per_type(struct venus_core *core, u32 session_type)
+{
+	struct venus_inst *inst = NULL;
+	u32 mbs_per_sec = 0;
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
+static int load_scale_clocks(struct venus_core *core)
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
+	if (mbs_per_sec > core->res->max_load)
+		dev_warn(dev, "HW is overloaded, needed: %d max: %d\n",
+			 mbs_per_sec, core->res->max_load);
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
+	if (core->res->hfi_version == HFI_VERSION_3XX) {
+		ret = clk_set_rate(clk, freq);
+		ret |= clk_set_rate(core->core0_clk, freq);
+		ret |= clk_set_rate(core->core1_clk, freq);
+	} else {
+		ret = clk_set_rate(clk, freq);
+	}
+
+	if (ret) {
+		dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void fill_buffer_desc(const struct venus_buffer *buf,
+			     struct hfi_buffer_desc *bd, bool response)
+{
+	memset(bd, 0, sizeof(*bd));
+	bd->buffer_type = HFI_BUFFER_OUTPUT;
+	bd->buffer_size = buf->size;
+	bd->num_buffers = 1;
+	bd->device_addr = buf->dma_addr;
+	bd->response_required = response;
+}
+
+static void return_buf_error(struct venus_inst *inst,
+			     struct vb2_v4l2_buffer *vbuf)
+{
+	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+
+	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
+	else
+		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
+
+	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+}
+
+static int
+session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
+{
+	struct venus_buffer *buf = to_venus_buffer(vbuf);
+	struct vb2_buffer *vb = &vbuf->vb2_buf;
+	unsigned int type = vb->type;
+	struct hfi_frame_data fdata;
+	int ret;
+
+	memset(&fdata, 0, sizeof(fdata));
+	fdata.alloc_len = buf->size;
+	fdata.device_addr = buf->dma_addr;
+	fdata.timestamp = vb->timestamp / NSEC_PER_USEC;
+	fdata.flags = 0;
+	fdata.clnt_data = vbuf->vb2_buf.index;
+
+	if (!fdata.timestamp)
+		fdata.flags |= HFI_BUFFERFLAG_TIMESTAMPINVALID;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fdata.buffer_type = HFI_BUFFER_INPUT;
+		fdata.filled_len = vb2_get_plane_payload(vb, 0);
+		fdata.offset = vb->planes[0].data_offset;
+
+		if (vbuf->flags & V4L2_BUF_FLAG_LAST || !fdata.filled_len)
+			fdata.flags |= HFI_BUFFERFLAG_EOS;
+
+		if (inst->codec_cfg == false &&
+		    inst->session_type == VIDC_SESSION_TYPE_DEC) {
+			inst->codec_cfg = true;
+			fdata.flags |= HFI_BUFFERFLAG_CODECCONFIG;
+		}
+	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fdata.buffer_type = HFI_BUFFER_OUTPUT;
+		fdata.filled_len = 0;
+		fdata.offset = 0;
+	}
+
+	ret = hfi_session_process_buf(inst, &fdata);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int session_unregister_bufs(struct venus_inst *inst)
+{
+	struct venus_core *core = inst->core;
+	struct hfi_buffer_desc bd;
+	struct venus_buffer *buf, *n;
+	int ret = 0;
+
+	if (core->res->hfi_version == HFI_VERSION_3XX)
+		return 0;
+
+	list_for_each_entry_safe(buf, n, &inst->registeredbufs, reg_list) {
+		fill_buffer_desc(buf, &bd, true);
+		ret = hfi_session_unset_buffers(inst, &bd);
+		list_del(&buf->reg_list);
+	}
+
+	return ret;
+}
+
+static int session_register_bufs(struct venus_inst *inst)
+{
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev;
+	struct hfi_buffer_desc bd;
+	struct venus_buffer *buf;
+	int ret = 0;
+
+	if (core->res->hfi_version == HFI_VERSION_3XX)
+		return 0;
+
+	list_for_each_entry(buf, &inst->registeredbufs, reg_list) {
+		fill_buffer_desc(buf, &bd, false);
+		ret = hfi_session_set_buffers(inst, &bd);
+		if (ret) {
+			dev_err(dev, "%s: set buffer failed\n", __func__);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int helper_get_bufreq(struct venus_inst *inst, u32 type,
+		      struct hfi_buffer_requirements *req)
+{
+	u32 ptype = HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS;
+	union hfi_get_property hprop;
+	int ret, i;
+
+	if (req)
+		memset(req, 0, sizeof(*req));
+
+	ret = hfi_session_get_property(inst, ptype, &hprop);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+
+	for (i = 0; i < HFI_BUFFER_TYPE_MAX; i++) {
+		if (hprop.bufreq[i].type != type)
+			continue;
+
+		if (req)
+			memcpy(req, &hprop.bufreq[i], sizeof(*req));
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(helper_get_bufreq);
+
+int helper_set_input_resolution(struct venus_inst *inst, unsigned int width,
+				unsigned int height)
+{
+	u32 ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
+	struct hfi_framesize fs;
+
+	fs.buffer_type = HFI_BUFFER_INPUT;
+	fs.width = width;
+	fs.height = height;
+
+	return hfi_session_set_property(inst, ptype, &fs);
+}
+EXPORT_SYMBOL(helper_set_input_resolution);
+
+int helper_set_output_resolution(struct venus_inst *inst, unsigned int width,
+				 unsigned int height)
+{
+	u32 ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
+	struct hfi_framesize fs;
+
+	fs.buffer_type = HFI_BUFFER_OUTPUT;
+	fs.width = width;
+	fs.height = height;
+
+	return hfi_session_set_property(inst, ptype, &fs);
+}
+EXPORT_SYMBOL(helper_set_output_resolution);
+
+int helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
+			unsigned int output_bufs)
+{
+	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
+	struct hfi_buffer_count_actual buf_count;
+	int ret;
+
+	buf_count.type = HFI_BUFFER_INPUT;
+	buf_count.count_actual = input_bufs;
+
+	ret = hfi_session_set_property(inst, ptype, &buf_count);
+	if (ret)
+		return ret;
+
+	buf_count.type = HFI_BUFFER_OUTPUT;
+	buf_count.count_actual = output_bufs;
+
+	return hfi_session_set_property(inst, ptype, &buf_count);
+}
+EXPORT_SYMBOL(helper_set_num_bufs);
+
+int helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
+{
+	struct hfi_uncompressed_format_select fmt;
+	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
+	int ret;
+
+	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
+		fmt.buffer_type = HFI_BUFFER_OUTPUT;
+	else if (inst->session_type == VIDC_SESSION_TYPE_ENC)
+		fmt.buffer_type = HFI_BUFFER_INPUT;
+	else
+		return -EINVAL;
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
+	ret = hfi_session_set_property(inst, ptype, &fmt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(helper_set_color_format);
+
+struct vb2_v4l2_buffer *
+helper_find_buf(struct venus_inst *inst, unsigned int type, u32 idx)
+{
+	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return v4l2_m2m_src_buf_remove_by_idx(m2m_ctx, idx);
+	else
+		return v4l2_m2m_dst_buf_remove_by_idx(m2m_ctx, idx);
+}
+EXPORT_SYMBOL(helper_find_buf);
+
+int helper_vb2_buf_init(struct vb2_buffer *vb)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct venus_buffer *buf = to_venus_buffer(vbuf);
+	struct sg_table *sgt;
+
+	sgt = vb2_dma_sg_plane_desc(vb, 0);
+	if (!sgt)
+		return -EFAULT;
+
+	buf->size = vb2_plane_size(vb, 0);
+	buf->dma_addr = sg_dma_address(sgt->sgl);
+
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		list_add_tail(&buf->reg_list, &inst->registeredbufs);
+
+	return 0;
+}
+EXPORT_SYMBOL(helper_vb2_buf_init);
+
+int helper_vb2_buf_prepare(struct vb2_buffer *vb)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    vb2_plane_size(vb, 0) < inst->output_buf_size)
+		return -EINVAL;
+	else if (vb2_plane_size(vb, 0) < inst->input_buf_size)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(helper_vb2_buf_prepare);
+
+void helper_vb2_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
+
+	if (!(inst->streamon_out & inst->streamon_cap))
+		goto unlock;
+
+	ret = session_process_buf(inst, vbuf);
+	if (ret)
+		return_buf_error(inst, vbuf);
+
+unlock:
+	mutex_unlock(&inst->lock);
+}
+EXPORT_SYMBOL(helper_vb2_buf_queue);
+
+void helper_buffers_done(struct venus_inst *inst, enum vb2_buffer_state state)
+{
+	struct vb2_v4l2_buffer *buf;
+
+	while ((buf = v4l2_m2m_src_buf_remove(inst->m2m_ctx)))
+		v4l2_m2m_buf_done(buf, state);
+	while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
+		v4l2_m2m_buf_done(buf, state);
+}
+EXPORT_SYMBOL(helper_buffers_done);
+
+void helper_vb2_stop_streaming(struct vb2_queue *q)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(q);
+	struct venus_core *core = inst->core;
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (inst->streamon_out & inst->streamon_cap) {
+		ret = hfi_session_stop(inst);
+		ret |= hfi_session_unload_res(inst);
+		ret |= session_unregister_bufs(inst);
+		ret |= intbufs_free(inst);
+		ret |= hfi_session_deinit(inst);
+
+		if (inst->session_error || core->sys_error)
+			ret = -EIO;
+
+		if (ret)
+			hfi_session_abort(inst);
+
+		load_scale_clocks(core);
+	}
+
+	helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 0;
+	else
+		inst->streamon_cap = 0;
+
+	mutex_unlock(&inst->lock);
+}
+EXPORT_SYMBOL(helper_vb2_stop_streaming);
+
+int helper_vb2_start_streaming(struct venus_inst *inst)
+{
+	struct venus_core *core = inst->core;
+	int ret;
+
+	ret = intbufs_alloc(inst);
+	if (ret)
+		return ret;
+
+	ret = session_register_bufs(inst);
+	if (ret)
+		goto err_bufs_free;
+
+	load_scale_clocks(core);
+
+	ret = hfi_session_load_res(inst);
+	if (ret)
+		goto err_unreg_bufs;
+
+	ret = hfi_session_start(inst);
+	if (ret)
+		goto err_unload_res;
+
+	return 0;
+
+err_unload_res:
+	hfi_session_unload_res(inst);
+err_unreg_bufs:
+	session_unregister_bufs(inst);
+err_bufs_free:
+	intbufs_free(inst);
+	return ret;
+}
+EXPORT_SYMBOL(helper_vb2_start_streaming);
+
+void helper_m2m_device_run(void *priv)
+{
+	struct venus_inst *inst = priv;
+	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+	struct v4l2_m2m_buffer *buf, *n;
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n) {
+		ret = session_process_buf(inst, &buf->vb);
+		if (ret)
+			return_buf_error(inst, &buf->vb);
+	}
+
+	v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
+		ret = session_process_buf(inst, &buf->vb);
+		if (ret)
+			return_buf_error(inst, &buf->vb);
+	}
+
+	mutex_unlock(&inst->lock);
+}
+EXPORT_SYMBOL(helper_m2m_device_run);
+
+void helper_m2m_job_abort(void *priv)
+{
+	struct venus_inst *inst = priv;
+
+	v4l2_m2m_job_finish(inst->m2m_dev, inst->m2m_ctx);
+}
+EXPORT_SYMBOL(helper_m2m_job_abort);
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
new file mode 100644
index 000000000000..348baa93cf9b
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
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
+#ifndef __VENUS_HELPERS_H__
+#define __VENUS_HELPERS_H__
+
+#include <media/videobuf2-v4l2.h>
+
+struct venus_inst;
+
+struct vb2_v4l2_buffer *helper_find_buf(struct venus_inst *inst,
+					unsigned int type, u32 idx);
+void helper_buffers_done(struct venus_inst *inst, enum vb2_buffer_state state);
+int helper_vb2_buf_init(struct vb2_buffer *vb);
+int helper_vb2_buf_prepare(struct vb2_buffer *vb);
+void helper_vb2_buf_queue(struct vb2_buffer *vb);
+void helper_vb2_stop_streaming(struct vb2_queue *q);
+int helper_vb2_start_streaming(struct venus_inst *inst);
+void helper_m2m_device_run(void *priv);
+void helper_m2m_job_abort(void *priv);
+int helper_get_bufreq(struct venus_inst *inst, u32 type,
+		      struct hfi_buffer_requirements *req);
+int helper_set_input_resolution(struct venus_inst *inst, unsigned int width,
+				unsigned int height);
+int helper_set_output_resolution(struct venus_inst *inst, unsigned int width,
+				 unsigned int height);
+int helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
+			unsigned int output_bufs);
+int helper_set_color_format(struct venus_inst *inst, u32 fmt);
+#endif
-- 
2.7.4
