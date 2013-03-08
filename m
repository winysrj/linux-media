Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:15129 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab3CHQqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:46:32 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC00IWEP98S540@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:31 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJC00BU5P8ZM870@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:30 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v5 2/6] s5p-fimc: Add device tree support for FIMC device
 driver
Date: Fri, 08 Mar 2013 17:46:02 +0100
Message-id: <1362761166-5285-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
References: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree support for FIMC driver on S5PV210 and
Exynos4 SoCs.

The FIMC IP block's features and quirks encoded statically in
the driver are now parsed from the device tree. Once all relevant
platforms are converted to device tree based booting the FIMC
variant data structures will all be removed from the driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v4:
 - Added parsing of FIMC features and quirks for DT, the static
   variant data removed for Exynos4x12 SoC which is a dt-only
   platform upstream;
 - the bindings documentation moved to Documentation/
   devicetree/bindings/media/samsung-fimc.txt

Changes since v3:
 - added optional clock-frequency property to specify local bus
   (FIMCn_LCLK) clock frequency
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   86 ++++++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    6 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |  230 ++++++++++++--------
 drivers/media/platform/s5p-fimc/fimc-core.h        |   21 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |    2 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |    6 +-
 6 files changed, 243 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-fimc.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
new file mode 100644
index 0000000..c4a0480
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -0,0 +1,86 @@
+Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
+----------------------------------------------
+
+The S5P/Exynos SoC Camera subsystem comprises of multiple sub-devices
+represented by separate device tree nodes. Currently this includes: FIMC (in
+the S5P SoCs series known as CAMIF), MIPI CSIS, FIMC-LITE and FIMC-IS (ISP).
+
+The sub-subdevices are defined as child nodes of the common 'camera' node which
+also includes common properties of the whole subsystem not really specific to
+any single sub-device, like common camera port pins or the CAMCLK clock outputs
+for external image sensors attached to an SoC.
+
+Common 'camera' node
+--------------------
+
+Required properties:
+
+- compatible : must be "samsung,fimc", "simple-bus"
+
+The 'camera' node must include at least one 'fimc' child node.
+
+
+'fimc' device nodes
+-------------------
+
+Required properties:
+
+- compatible : "samsung,s5pv210-fimc" for S5PV210, "samsung,exynos4210-fimc"
+  for Exynos4210 and "samsung,exynos4212-fimc" for Exynos4x12 SoCs;
+- reg : physical base address and size of the device  memory mapped registers;
+- interrupts : FIMC interrupt to the CPU should be described here;
+- samsung,pix-limits : an array of supported image sizes in pixels, for details
+  refer to Table 2-1 in the S5PV210 SoC User Manual.
+
+For every fimc node a numbered alias should be present in the aliases node.
+Aliases are of the form fimc<n>, where <n> is an integer (0...N) specifying
+the IP's instance index.
+
+Optional properties:
+
+- clock-frequency : maximum FIMC local clock (LCLK) frequency;
+- samsung,min-pix-sizes : an array specyfing minimum image size in pixels at
+  the FIMC input and output DMA, in the first and second cell respectively.
+  Default value when this property is not present is <16 16>;
+- samsung,min-pix-alignment : minimum supported image height alignment (first
+  cell) and the horizontal image offset (second cell). The values are in pixels
+  and default to <2 1> when this property is not present;
+- samsung,mainscaler-ext : a boolean property indicating whether the FIMC IP
+  supports extended image size and has CIEXTEN register;
+- samsung,rotators : a bitmask specifying whether this IP has the input and
+  the output rotator. Bits 4 and 0 correspond to input and output rotator
+  respectively. If a rotator is present its corresponding bit should be set.
+  Default value when this property is not specified is 0x11.
+- samsung,cam-if : a bolean property indicating whether the IP block includes
+  the camera input interface.
+- samsung,isp-wb : this property must be present if the IP block has the ISP
+  writeback input.
+
+
+Example:
+
+	aliases {
+		fimc0 = &fimc_0;
+	};
+
+	camera {
+		compatible = "samsung,fimc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		status = "okay";
+
+		fimc_0: fimc@11800000 {
+			compatible = "samsung,exynos4210-fimc";
+			reg = <0x11800000 0x1000>;
+			interrupts = <0 85 0>;
+			status = "okay";
+		};
+
+		csis_0: csis@11880000 {
+			compatible = "samsung,exynos4210-csis";
+			reg = <0x11880000 0x1000>;
+			interrupts = <0 78 0>;
+		};
+	};
+
+[1] Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 87b6842..2a1da4c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -65,7 +65,7 @@ static int fimc_capture_hw_init(struct fimc_dev *fimc)
 		fimc_hw_set_effect(ctx);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
-		if (fimc->variant->has_alpha)
+		if (fimc->drv_data->alpha_color)
 			fimc_hw_set_rgb_alpha(ctx);
 		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
@@ -168,7 +168,7 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 	fimc_hw_set_effect(ctx);
 	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
 	fimc_hw_set_out_dma(ctx);
-	if (fimc->variant->has_alpha)
+	if (fimc->drv_data->alpha_color)
 		fimc_hw_set_rgb_alpha(ctx);
 
 	clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
@@ -1884,7 +1884,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 
 	v4l2_subdev_init(sd, &fimc_subdev_ops);
 	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index e3916bd..27796e9 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -21,6 +21,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
@@ -440,14 +442,14 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
-	const struct fimc_variant *variant = ctx->fimc_dev->variant;
+	bool pix_hoff = ctx->fimc_dev->drv_data->dma_pix_hoff;
 	u32 i, depth = 0;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
 		depth += f->fmt->depth[i];
 
 	f->dma_offset.y_h = f->offs_h;
-	if (!variant->pix_hoff)
+	if (!pix_hoff)
 		f->dma_offset.y_h *= (depth >> 3);
 
 	f->dma_offset.y_v = f->offs_v;
@@ -458,7 +460,7 @@ void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 	f->dma_offset.cr_h = f->offs_h;
 	f->dma_offset.cr_v = f->offs_v;
 
-	if (!variant->pix_hoff) {
+	if (!pix_hoff) {
 		if (f->fmt->colplanes == 3) {
 			f->dma_offset.cb_h >>= 1;
 			f->dma_offset.cr_h >>= 1;
@@ -589,7 +591,6 @@ static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
 
 int fimc_ctrls_create(struct fimc_ctx *ctx)
 {
-	const struct fimc_variant *variant = ctx->fimc_dev->variant;
 	unsigned int max_alpha = fimc_get_alpha_mask(ctx->d_frame.fmt);
 	struct fimc_ctrls *ctrls = &ctx->ctrls;
 	struct v4l2_ctrl_handler *handler = &ctrls->handler;
@@ -606,7 +607,7 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
 	ctrls->vflip = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
 					V4L2_CID_VFLIP, 0, 1, 1, 0);
 
-	if (variant->has_alpha)
+	if (ctx->fimc_dev->drv_data->alpha_color)
 		ctrls->alpha = v4l2_ctrl_new_std(handler, &fimc_ctrl_ops,
 					V4L2_CID_ALPHA_COMPONENT,
 					0, max_alpha, 1, 0);
@@ -677,7 +678,7 @@ void fimc_alpha_ctrl_update(struct fimc_ctx *ctx)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct v4l2_ctrl *ctrl = ctx->ctrls.alpha;
 
-	if (ctrl == NULL || !fimc->variant->has_alpha)
+	if (ctrl == NULL || !fimc->drv_data->alpha_color)
 		return;
 
 	v4l2_ctrl_lock(ctrl);
@@ -863,43 +864,107 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 	return 0;
 }
 
+static const struct of_device_id fimc_of_match[];
+
+static int fimc_parse_dt(struct fimc_dev *fimc, u32 *clk_freq)
+{
+	struct device *dev = &fimc->pdev->dev;
+	struct device_node *node = dev->of_node;
+	const struct of_device_id *of_id;
+	struct fimc_variant *v;
+	struct fimc_pix_limit *lim;
+	u32 args[FIMC_PIX_LIMITS_MAX];
+	int ret;
+
+	v = devm_kzalloc(dev, sizeof(*v) + sizeof(*lim), GFP_KERNEL);
+	if (!v)
+		return -ENOMEM;
+
+	of_id = of_match_node(fimc_of_match, node);
+	if (!of_id)
+		return -EINVAL;
+	fimc->drv_data = of_id->data;
+	ret = of_property_read_u32_array(node, "samsung,pix-limits",
+					 args, FIMC_PIX_LIMITS_MAX);
+	if (ret < 0)
+		return ret;
+
+	lim = (struct fimc_pix_limit *)&v[1];
+	lim->scaler_en_w	= args[0];
+	lim->scaler_dis_w	= args[1];
+	lim->in_rot_en_h	= args[2];
+	lim->in_rot_dis_w	= args[3];
+	lim->out_rot_en_w	= args[4];
+	lim->out_rot_dis_w	= args[5];
+	v->pix_limit		= lim;
+
+	ret = of_property_read_u32_array(node, "samsung,min-pix-sizes",
+								args, 2);
+	v->min_inp_pixsize = ret ? FIMC_DEF_MIN_SIZE : args[0];
+	v->min_out_pixsize = ret ? FIMC_DEF_MIN_SIZE : args[1];
+	ret = of_property_read_u32_array(node, "samsung,min-pix-alignment",
+								args, 2);
+	v->min_vsize_align = ret ? FIMC_DEF_HEIGHT_ALIGN : args[0];
+	v->hor_offs_align = ret ? FIMC_DEF_HOR_OFFS_ALIGN : args[1];
+
+	ret = of_property_read_u32(node, "samsung,rotators", &args[1]);
+	v->has_inp_rot = ret ? 1 : args[1] & 0x01;
+	v->has_out_rot = ret ? 1 : args[1] & 0x10;
+	v->has_mainscaler_ext = of_property_read_bool(node,
+					"samsung,mainscaler-ext");
+
+	v->has_isp_wb = of_property_read_bool(node, "samsung,isp-wb");
+	v->has_cam_if = of_property_read_bool(node, "samsung,cam-if");
+	of_property_read_u32(node, "clock-frequency", clk_freq);
+	fimc->id = of_alias_get_id(node, "fimc");
+
+	fimc->variant = v;
+	return 0;
+}
+
 static int fimc_probe(struct platform_device *pdev)
 {
-	const struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
-	struct s5p_platform_fimc *pdata;
+	struct device *dev = &pdev->dev;
+	u32 lclk_freq = 0;
 	struct fimc_dev *fimc;
 	struct resource *res;
 	int ret = 0;
 
-	if (pdev->id >= drv_data->num_entities) {
-		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
-			pdev->id);
-		return -EINVAL;
-	}
-
-	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
+	fimc = devm_kzalloc(dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
-	fimc->id = pdev->id;
-
-	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
-	pdata = pdev->dev.platform_data;
-	fimc->pdata = pdata;
+
+	if (dev->of_node) {
+		ret = fimc_parse_dt(fimc, &lclk_freq);
+		if (ret < 0)
+			return ret;
+	} else {
+		fimc->drv_data = fimc_get_drvdata(pdev);
+		fimc->id = pdev->id;
+	}
+	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
+	    fimc->id < 0) {
+		dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
+			fimc->id, fimc->drv_data->num_entities);
+		return -EINVAL;
+	}
+	if (!dev->of_node)
+		fimc->variant = fimc->drv_data->variant[fimc->id];
 
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	fimc->regs = devm_ioremap_resource(&pdev->dev, res);
+	fimc->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(fimc->regs))
 		return PTR_ERR(fimc->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
-		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
+		dev_err(dev, "Failed to get IRQ resource\n");
 		return -ENXIO;
 	}
 
@@ -907,7 +972,10 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
+	if (lclk_freq == 0)
+		lclk_freq = fimc->drv_data->lclk_frequency;
+
+	ret = clk_set_rate(fimc->clock[CLK_BUS], lclk_freq);
 	if (ret < 0)
 		return ret;
 
@@ -915,10 +983,10 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
-			       0, dev_name(&pdev->dev), fimc);
+	ret = devm_request_irq(dev, res->start, fimc_irq_handler,
+			       0, dev_name(dev), fimc);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		dev_err(dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
 	}
 
@@ -927,23 +995,23 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 
 	platform_set_drvdata(pdev, fimc);
-	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
 		goto err_sd;
 	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
 		goto err_pm;
 	}
 
-	dev_dbg(&pdev->dev, "FIMC.%d registered successfully\n", fimc->id);
+	dev_dbg(dev, "FIMC.%d registered successfully\n", fimc->id);
 
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 	return 0;
 err_pm:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put(dev);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_clk:
@@ -1085,7 +1153,6 @@ static const struct fimc_variant fimc0_variant_s5p = {
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
 	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[0],
 };
 
@@ -1095,12 +1162,10 @@ static const struct fimc_variant fimc2_variant_s5p = {
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
 	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
 static const struct fimc_variant fimc0_variant_s5pv210 = {
-	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
@@ -1108,12 +1173,10 @@ static const struct fimc_variant fimc0_variant_s5pv210 = {
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
 	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
 static const struct fimc_variant fimc1_variant_s5pv210 = {
-	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
@@ -1122,80 +1185,39 @@ static const struct fimc_variant fimc1_variant_s5pv210 = {
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
 	.min_vsize_align = 1,
-	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
 static const struct fimc_variant fimc2_variant_s5pv210 = {
 	.has_cam_if	 = 1,
-	.pix_hoff	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
 	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
 static const struct fimc_variant fimc0_variant_exynos4210 = {
-	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
 	.has_cam_if	 = 1,
-	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
-	.has_alpha	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
 	.min_vsize_align = 1,
-	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
 static const struct fimc_variant fimc3_variant_exynos4210 = {
-	.pix_hoff	 = 1,
-	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
-	.has_alpha	 = 1,
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
 	.min_vsize_align = 1,
-	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[3],
 };
 
-static const struct fimc_variant fimc0_variant_exynos4x12 = {
-	.pix_hoff		= 1,
-	.has_inp_rot		= 1,
-	.has_out_rot		= 1,
-	.has_cam_if		= 1,
-	.has_isp_wb		= 1,
-	.has_cistatus2		= 1,
-	.has_mainscaler_ext	= 1,
-	.has_alpha		= 1,
-	.min_inp_pixsize	= 16,
-	.min_out_pixsize	= 16,
-	.hor_offs_align		= 2,
-	.min_vsize_align	= 1,
-	.out_buf_count		= 32,
-	.pix_limit		= &s5p_pix_limit[1],
-};
-
-static const struct fimc_variant fimc3_variant_exynos4x12 = {
-	.pix_hoff		= 1,
-	.has_cistatus2		= 1,
-	.has_mainscaler_ext	= 1,
-	.has_alpha		= 1,
-	.min_inp_pixsize	= 16,
-	.min_out_pixsize	= 16,
-	.hor_offs_align		= 2,
-	.min_vsize_align	= 1,
-	.out_buf_count		= 32,
-	.pix_limit		= &s5p_pix_limit[3],
-};
-
 /* S5PC100 */
 static const struct fimc_drvdata fimc_drvdata_s5p = {
 	.variant = {
@@ -1203,8 +1225,9 @@ static const struct fimc_drvdata fimc_drvdata_s5p = {
 		[1] = &fimc0_variant_s5p,
 		[2] = &fimc2_variant_s5p,
 	},
-	.num_entities = 3,
+	.num_entities	= 3,
 	.lclk_frequency = 133000000UL,
+	.out_buf_count	= 4,
 };
 
 /* S5PV210, S5PC110 */
@@ -1214,8 +1237,10 @@ static const struct fimc_drvdata fimc_drvdata_s5pv210 = {
 		[1] = &fimc1_variant_s5pv210,
 		[2] = &fimc2_variant_s5pv210,
 	},
-	.num_entities = 3,
-	.lclk_frequency = 166000000UL,
+	.num_entities	= 3,
+	.lclk_frequency	= 166000000UL,
+	.out_buf_count	= 4,
+	.dma_pix_hoff	= 1,
 };
 
 /* EXYNOS4210, S5PV310, S5PC210 */
@@ -1226,20 +1251,22 @@ static const struct fimc_drvdata fimc_drvdata_exynos4210 = {
 		[2] = &fimc0_variant_exynos4210,
 		[3] = &fimc3_variant_exynos4210,
 	},
-	.num_entities = 4,
+	.num_entities	= 4,
 	.lclk_frequency = 166000000UL,
+	.dma_pix_hoff	= 1,
+	.cistatus2	= 1,
+	.alpha_color	= 1,
+	.out_buf_count	= 32,
 };
 
 /* EXYNOS4212, EXYNOS4412 */
 static const struct fimc_drvdata fimc_drvdata_exynos4x12 = {
-	.variant = {
-		[0] = &fimc0_variant_exynos4x12,
-		[1] = &fimc0_variant_exynos4x12,
-		[2] = &fimc0_variant_exynos4x12,
-		[3] = &fimc3_variant_exynos4x12,
-	},
-	.num_entities = 4,
-	.lclk_frequency = 166000000UL,
+	.num_entities	= 4,
+	.lclk_frequency	= 166000000UL,
+	.dma_pix_hoff	= 1,
+	.cistatus2	= 1,
+	.alpha_color	= 1,
+	.out_buf_count	= 32,
 };
 
 static const struct platform_device_id fimc_driver_ids[] = {
@@ -1256,10 +1283,24 @@ static const struct platform_device_id fimc_driver_ids[] = {
 		.name		= "exynos4x12-fimc",
 		.driver_data	= (unsigned long)&fimc_drvdata_exynos4x12,
 	},
-	{},
+	{ },
 };
 MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
+static const struct of_device_id fimc_of_match[] = {
+	{
+		.compatible = "samsung,s5pv210-fimc",
+		.data = &fimc_drvdata_s5pv210,
+	}, {
+		.compatible = "samsung,exynos4210-fimc",
+		.data = &fimc_drvdata_exynos4210,
+	}, {
+		.compatible = "samsung,exynos4212-fimc",
+		.data = &fimc_drvdata_exynos4x12,
+	},
+	{ /* sentinel */ },
+};
+
 static const struct dev_pm_ops fimc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(fimc_suspend, fimc_resume)
 	SET_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
@@ -1270,9 +1311,10 @@ static struct platform_driver fimc_driver = {
 	.remove		= fimc_remove,
 	.id_table	= fimc_driver_ids,
 	.driver = {
-		.name	= FIMC_MODULE_NAME,
-		.owner	= THIS_MODULE,
-		.pm     = &fimc_pm_ops,
+		.of_match_table = fimc_of_match,
+		.name		= FIMC_MODULE_NAME,
+		.owner		= THIS_MODULE,
+		.pm     	= &fimc_pm_ops,
 	}
 };
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 412d507..58b674e 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -42,6 +42,10 @@
 #define FIMC_CAMIF_MAX_HEIGHT	0x2000
 #define FIMC_MAX_JPEG_BUF_SIZE	(10 * SZ_1M)
 #define FIMC_MAX_PLANES		3
+#define FIMC_PIX_LIMITS_MAX	6
+#define FIMC_DEF_MIN_SIZE	16
+#define FIMC_DEF_HEIGHT_ALIGN	2
+#define FIMC_DEF_HOR_OFFS_ALIGN	1
 
 /* indices to the clocks array */
 enum {
@@ -365,10 +369,8 @@ struct fimc_pix_limit {
 
 /**
  * struct fimc_variant - FIMC device variant information
- * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
  * @has_inp_rot: set if has input rotator
  * @has_out_rot: set if has output rotator
- * @has_cistatus2: 1 if CISTATUS2 register is present in this IP revision
  * @has_mainscaler_ext: 1 if extended mainscaler ratios in CIEXTEN register
  *			 are present in this IP revision
  * @has_cam_if: set if this instance has a camera input interface
@@ -378,23 +380,18 @@ struct fimc_pix_limit {
  * @min_out_pixsize: minimum output pixel size
  * @hor_offs_align: horizontal pixel offset aligment
  * @min_vsize_align: minimum vertical pixel size alignment
- * @out_buf_count: the number of buffers in output DMA sequence
  */
 struct fimc_variant {
-	unsigned int	pix_hoff:1;
 	unsigned int	has_inp_rot:1;
 	unsigned int	has_out_rot:1;
-	unsigned int	has_cistatus2:1;
 	unsigned int	has_mainscaler_ext:1;
 	unsigned int	has_cam_if:1;
 	unsigned int	has_isp_wb:1;
-	unsigned int	has_alpha:1;
 	const struct fimc_pix_limit *pix_limit;
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
 	u16		hor_offs_align;
 	u16		min_vsize_align;
-	u16		out_buf_count;
 };
 
 /**
@@ -402,11 +399,20 @@ struct fimc_variant {
  * @variant: variant information for this device
  * @num_entities: number of fimc instances available in a SoC
  * @lclk_frequency: local bus clock frequency
+ * @cistatus2: 1 if the FIMC IPs have CISTATUS2 register
+ * @dma_pix_hoff: the horizontal DMA offset unit: 1 - pixels, 0 - bytes
+ * @alpha_color: 1 if alpha color component is supported
+ * @out_buf_count: maximum number of output DMA buffers supported
  */
 struct fimc_drvdata {
 	const struct fimc_variant *variant[FIMC_MAX_DEVS];
 	int num_entities;
 	unsigned long lclk_frequency;
+	/* Fields common to all FIMC IP instances */
+	u8 cistatus2;
+	u8 dma_pix_hoff;
+	u8 alpha_color;
+	u8 out_buf_count;
 };
 
 #define fimc_get_drvdata(_pdev) \
@@ -438,6 +444,7 @@ struct fimc_dev {
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
 	const struct fimc_variant	*variant;
+	const struct fimc_drvdata	*drv_data;
 	u16				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index f3d535c..9422fbf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -152,7 +152,7 @@ static void fimc_device_run(void *priv)
 		fimc_hw_set_rotation(ctx);
 		fimc_hw_set_effect(ctx);
 		fimc_hw_set_out_dma(ctx);
-		if (fimc->variant->has_alpha)
+		if (fimc->drv_data->alpha_color)
 			fimc_hw_set_rgb_alpha(ctx);
 		fimc_hw_set_output_path(ctx);
 	}
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/s5p-fimc/fimc-reg.c
index 50b97c7..4d2fc69 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-reg.c
@@ -35,7 +35,7 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	cfg &= ~FIMC_REG_CIGCTRL_SWRST;
 	writel(cfg, dev->regs + FIMC_REG_CIGCTRL);
 
-	if (dev->variant->out_buf_count > 4)
+	if (dev->drv_data->out_buf_count > 4)
 		fimc_hw_set_dma_seq(dev, 0xF);
 }
 
@@ -747,7 +747,7 @@ s32 fimc_hw_get_frame_index(struct fimc_dev *dev)
 {
 	s32 reg;
 
-	if (dev->variant->has_cistatus2) {
+	if (dev->drv_data->cistatus2) {
 		reg = readl(dev->regs + FIMC_REG_CISTATUS2) & 0x3f;
 		return reg - 1;
 	}
@@ -763,7 +763,7 @@ s32 fimc_hw_get_prev_frame_index(struct fimc_dev *dev)
 {
 	s32 reg;
 
-	if (!dev->variant->has_cistatus2)
+	if (!dev->drv_data->cistatus2)
 		return -1;
 
 	reg = readl(dev->regs + FIMC_REG_CISTATUS2);
-- 
1.7.9.5

