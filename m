Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51508 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab2EYTxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 May 2012 21:52:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 05/13] media: s5p-fimc: Add device tree support for FIMC
 devices
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1337975573-27117-5-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../bindings/camera/soc/samsung-fimc.txt           |   66 ++++
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |  410 +++++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.h           |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    8 +-
 5 files changed, 291 insertions(+), 197 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt

diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
new file mode 100644
index 0000000..1ec48e9
--- /dev/null
+++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
@@ -0,0 +1,66 @@
+Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
+----------------------------------------------
+
+The Exynos Camera subsystem uses a dedicated device node associated with
+top level device driver that manages common properties of the whole subsystem,
+like common camera port pins or clocks for external image sensors. This
+aggregate node references related platform sub-devices - FIMC, FIMC-LITE,
+MIPI-CSIS [1], and it also contains nodes describing image sensors wired to
+the host SoC's video port and using I2C or SPI as the control bus.
+
+
+Common 'camera' node
+--------------------
+
+Required properties:
+
+- compatible	   : must be "samsung,fimc"
+- fimc-controllers : an array of phandles to 'fimc' device nodes,
+		     size of this array must be at least 1;
+
+Optional properties:
+
+- csi-rx-controllers : an array of phandles to 'csis' device nodes,
+		       it is required for sensors with MIPI-CSI2 bus;
+
+'fimc' device node
+------------------
+
+Required properties:
+
+- compatible : should be one of:
+		"samsung,s5pv210-fimc"
+		"samsung,exynos4210-fimc";
+		"samsung,exynos4412-fimc";
+- reg	     : physical base address and size of the device memory mapped
+	       registers;
+- interrupts : FIMC interrupt to the CPU should be described here;
+- cell-index : FIMC IP instance index, the number of available instances
+	       depends on the SoC revision. For S5PV210 valid values are:
+	       0...2, for Exynos4x1x: 0...3.
+
+Example:
+
+	fimc0: fimc@11800000 {
+		compatible = "samsung,exynos4210-fimc";
+		reg = <0x11800000 0x1000>;
+		interrupts = <0 85 0>;
+		cell-index = <0>;
+	};
+
+	csis0: csis@11880000 {
+		compatible = "samsung,exynos4210-csis";
+		reg = <0x11880000 0x1000>;
+		interrupts = <0 78 0>;
+		cell-index = <0>;
+	};
+
+	camera {
+		compatible = "samsung,fimc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		fimc-controllers = <&fimc0>;
+		csi-rx-controllers = <&csis0>;
+	};
+
+[1] Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0549451..7585b2f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1684,7 +1684,7 @@ int fimc_initialize_capture_subdev(struct fimc_dev *fimc)
 
 	v4l2_subdev_init(sd, &fimc_subdev_ops);
 	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->id);
 
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fedcd56..30c6365 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -21,6 +21,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
@@ -188,6 +190,198 @@ static struct fimc_fmt fimc_formats[] = {
 	},
 };
 
+/* Image pixel limits, similar across several FIMC HW revisions. */
+static struct fimc_pix_limit s5p_pix_limit[4] = {
+	[0] = {
+		.scaler_en_w	= 3264,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1920,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1920,
+		.out_rot_dis_w	= 4224,
+	},
+	[1] = {
+		.scaler_en_w	= 4224,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1920,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1920,
+		.out_rot_dis_w	= 4224,
+	},
+	[2] = {
+		.scaler_en_w	= 1920,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1280,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1280,
+		.out_rot_dis_w	= 1920,
+	},
+	[3] = {
+		.scaler_en_w	= 1920,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1366,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1366,
+		.out_rot_dis_w	= 1920,
+	},
+};
+
+static struct fimc_variant fimc0_variant_s5p = {
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[0],
+};
+
+static struct fimc_variant fimc2_variant_s5p = {
+	.has_cam_if	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[1],
+};
+
+static struct fimc_variant fimc0_variant_s5pv210 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[1],
+};
+
+static struct fimc_variant fimc1_variant_s5pv210 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
+	.has_mainscaler_ext = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 1,
+	.min_vsize_align = 1,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[2],
+};
+
+static struct fimc_variant fimc2_variant_s5pv210 = {
+	.has_cam_if	 = 1,
+	.pix_hoff	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
+	.out_buf_count	 = 4,
+	.pix_limit	 = &s5p_pix_limit[2],
+};
+
+static struct fimc_variant fimc0_variant_exynos4 = {
+	.pix_hoff	 = 1,
+	.has_inp_rot	 = 1,
+	.has_out_rot	 = 1,
+	.has_cam_if	 = 1,
+	.has_cistatus2	 = 1,
+	.has_mainscaler_ext = 1,
+	.has_alpha	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 2,
+	.min_vsize_align = 1,
+	.out_buf_count	 = 32,
+	.pix_limit	 = &s5p_pix_limit[1],
+};
+
+static struct fimc_variant fimc3_variant_exynos4 = {
+	.pix_hoff	 = 1,
+	.has_cam_if	 = 1,
+	.has_cistatus2	 = 1,
+	.has_mainscaler_ext = 1,
+	.has_alpha	 = 1,
+	.min_inp_pixsize = 16,
+	.min_out_pixsize = 16,
+	.hor_offs_align	 = 2,
+	.min_vsize_align = 1,
+	.out_buf_count	 = 32,
+	.pix_limit	 = &s5p_pix_limit[3],
+};
+
+/* S5PC100 */
+static struct fimc_drvdata fimc_drvdata_s5p = {
+	.variant = {
+		[0] = &fimc0_variant_s5p,
+		[1] = &fimc0_variant_s5p,
+		[2] = &fimc2_variant_s5p,
+	},
+	.num_entities = 3,
+	.lclk_frequency = 133000000UL,
+};
+
+/* S5PV210, S5PC110 */
+static struct fimc_drvdata fimc_drvdata_s5pv210 = {
+	.variant = {
+		[0] = &fimc0_variant_s5pv210,
+		[1] = &fimc1_variant_s5pv210,
+		[2] = &fimc2_variant_s5pv210,
+	},
+	.num_entities = 3,
+	.lclk_frequency = 166000000UL,
+};
+
+/* EXYNOS4210, S5PV310, S5PC210 */
+static struct fimc_drvdata fimc_drvdata_exynos4 = {
+	.variant = {
+		[0] = &fimc0_variant_exynos4,
+		[1] = &fimc0_variant_exynos4,
+		[2] = &fimc0_variant_exynos4,
+		[3] = &fimc3_variant_exynos4,
+	},
+	.num_entities = 4,
+	.lclk_frequency = 166000000UL,
+};
+
+static struct platform_device_id fimc_driver_ids[] = {
+	{
+		.name		= "s5p-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_s5p,
+	}, {
+		.name		= "s5pv210-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
+	}, {
+		.name		= "exynos4-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_exynos4,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id fimc_of_match[] __devinitconst = {
+	{
+		.compatible = "samsung,s5pv210-fimc",
+		.data = &fimc_drvdata_s5pv210,
+	}, {
+		.compatible = "samsung,exynos4210-fimc",
+		.data = &fimc_drvdata_exynos4,
+	}, {
+		.compatible = "samsung,exynos4412-fimc",
+		.data = &fimc_drvdata_exynos4,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, fimc_of_match);
+#endif
+
 struct fimc_fmt *fimc_get_format(unsigned int index)
 {
 	if (index >= ARRAY_SIZE(fimc_formats))
@@ -865,29 +1059,39 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 static int fimc_probe(struct platform_device *pdev)
 {
-	struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
-	struct s5p_platform_fimc *pdata;
+	struct fimc_drvdata *drv_data = NULL;
+
+	const struct of_device_id *of_id;
 	struct fimc_dev *fimc;
 	struct resource *res;
 	int ret = 0;
 
-	if (pdev->id >= drv_data->num_entities) {
-		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
-			pdev->id);
-		return -EINVAL;
-	}
-
 	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
 	if (!fimc)
 		return -ENOMEM;
 
-	fimc->id = pdev->id;
+	if (pdev->dev.of_node) {
+		u32 id = 0;
+		of_id = of_match_node(fimc_of_match, pdev->dev.of_node);
+		if (of_id)
+			drv_data = of_id->data;
+
+		of_property_read_u32(pdev->dev.of_node, "cell-index", &id);
+		fimc->id = id;
+
+	} else {
+		drv_data = fimc_get_drvdata(pdev);
+		fimc->id = pdev->id;
+	}
+
+	if (drv_data == NULL || fimc->id >= drv_data->num_entities) {
+		dev_err(&pdev->dev, "Invalid driver data or device index (%d)\n",
+			fimc->id);
+		return -EINVAL;
+	}
 
 	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
-	pdata = pdev->dev.platform_data;
-	fimc->pdata = pdata;
-
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);
@@ -1036,181 +1240,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* Image pixel limits, similar across several FIMC HW revisions. */
-static struct fimc_pix_limit s5p_pix_limit[4] = {
-	[0] = {
-		.scaler_en_w	= 3264,
-		.scaler_dis_w	= 8192,
-		.in_rot_en_h	= 1920,
-		.in_rot_dis_w	= 8192,
-		.out_rot_en_w	= 1920,
-		.out_rot_dis_w	= 4224,
-	},
-	[1] = {
-		.scaler_en_w	= 4224,
-		.scaler_dis_w	= 8192,
-		.in_rot_en_h	= 1920,
-		.in_rot_dis_w	= 8192,
-		.out_rot_en_w	= 1920,
-		.out_rot_dis_w	= 4224,
-	},
-	[2] = {
-		.scaler_en_w	= 1920,
-		.scaler_dis_w	= 8192,
-		.in_rot_en_h	= 1280,
-		.in_rot_dis_w	= 8192,
-		.out_rot_en_w	= 1280,
-		.out_rot_dis_w	= 1920,
-	},
-	[3] = {
-		.scaler_en_w	= 1920,
-		.scaler_dis_w	= 8192,
-		.in_rot_en_h	= 1366,
-		.in_rot_dis_w	= 8192,
-		.out_rot_en_w	= 1366,
-		.out_rot_dis_w	= 1920,
-	},
-};
-
-static struct fimc_variant fimc0_variant_s5p = {
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
-	.pix_limit	 = &s5p_pix_limit[0],
-};
-
-static struct fimc_variant fimc2_variant_s5p = {
-	.has_cam_if	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
-	.pix_limit	 = &s5p_pix_limit[1],
-};
-
-static struct fimc_variant fimc0_variant_s5pv210 = {
-	.pix_hoff	 = 1,
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
-	.pix_limit	 = &s5p_pix_limit[1],
-};
-
-static struct fimc_variant fimc1_variant_s5pv210 = {
-	.pix_hoff	 = 1,
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.has_mainscaler_ext = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 1,
-	.min_vsize_align = 1,
-	.out_buf_count	 = 4,
-	.pix_limit	 = &s5p_pix_limit[2],
-};
-
-static struct fimc_variant fimc2_variant_s5pv210 = {
-	.has_cam_if	 = 1,
-	.pix_hoff	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.out_buf_count	 = 4,
-	.pix_limit	 = &s5p_pix_limit[2],
-};
-
-static struct fimc_variant fimc0_variant_exynos4 = {
-	.pix_hoff	 = 1,
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.has_cistatus2	 = 1,
-	.has_mainscaler_ext = 1,
-	.has_alpha	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 2,
-	.min_vsize_align = 1,
-	.out_buf_count	 = 32,
-	.pix_limit	 = &s5p_pix_limit[1],
-};
-
-static struct fimc_variant fimc3_variant_exynos4 = {
-	.pix_hoff	 = 1,
-	.has_cam_if	 = 1,
-	.has_cistatus2	 = 1,
-	.has_mainscaler_ext = 1,
-	.has_alpha	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 2,
-	.min_vsize_align = 1,
-	.out_buf_count	 = 32,
-	.pix_limit	 = &s5p_pix_limit[3],
-};
-
-/* S5PC100 */
-static struct fimc_drvdata fimc_drvdata_s5p = {
-	.variant = {
-		[0] = &fimc0_variant_s5p,
-		[1] = &fimc0_variant_s5p,
-		[2] = &fimc2_variant_s5p,
-	},
-	.num_entities = 3,
-	.lclk_frequency = 133000000UL,
-};
-
-/* S5PV210, S5PC110 */
-static struct fimc_drvdata fimc_drvdata_s5pv210 = {
-	.variant = {
-		[0] = &fimc0_variant_s5pv210,
-		[1] = &fimc1_variant_s5pv210,
-		[2] = &fimc2_variant_s5pv210,
-	},
-	.num_entities = 3,
-	.lclk_frequency = 166000000UL,
-};
-
-/* EXYNOS4210, S5PV310, S5PC210 */
-static struct fimc_drvdata fimc_drvdata_exynos4 = {
-	.variant = {
-		[0] = &fimc0_variant_exynos4,
-		[1] = &fimc0_variant_exynos4,
-		[2] = &fimc0_variant_exynos4,
-		[3] = &fimc3_variant_exynos4,
-	},
-	.num_entities = 4,
-	.lclk_frequency = 166000000UL,
-};
-
-static struct platform_device_id fimc_driver_ids[] = {
-	{
-		.name		= "s5p-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_s5p,
-	}, {
-		.name		= "s5pv210-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
-	}, {
-		.name		= "exynos4-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_exynos4,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
-
 static const struct dev_pm_ops fimc_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(fimc_suspend, fimc_resume)
 	SET_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
@@ -1221,9 +1250,10 @@ static struct platform_driver fimc_driver = {
 	.remove		= __devexit_p(fimc_remove),
 	.id_table	= fimc_driver_ids,
 	.driver = {
-		.name	= FIMC_MODULE_NAME,
-		.owner	= THIS_MODULE,
-		.pm     = &fimc_pm_ops,
+		.of_match_table = of_match_ptr(fimc_of_match),
+		.name		= FIMC_MODULE_NAME,
+		.owner		= THIS_MODULE,
+		.pm     	= &fimc_pm_ops,
 	}
 };
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 95b27ae..a1df84d 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -414,7 +414,6 @@ struct fimc_ctx;
  * @slock:	the spinlock protecting this data structure
  * @lock:	the mutex protecting this data structure
  * @pdev:	pointer to the FIMC platform device
- * @pdata:	pointer to the device platform data
  * @variant:	the IP variant information
  * @id:		FIMC device index (0..FIMC_MAX_DEVS)
  * @clock:	clocks required for FIMC operation
@@ -431,7 +430,6 @@ struct fimc_dev {
 	spinlock_t			slock;
 	struct mutex			lock;
 	struct platform_device		*pdev;
-	struct s5p_platform_fimc	*pdata;
 	struct fimc_variant		*variant;
 	u16				id;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 2d780e5..3ffc4f5e 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -335,15 +335,15 @@ static int fimc_register_callback(struct device *dev, void *p)
 	struct fimc_dev *fimc = dev_get_drvdata(dev);
 	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
 	struct fimc_md *fmd = p;
-	int ret = 0;
+	int ret;
 
-	if (!fimc || !fimc->pdev)
+	if (fimc == NULL)
 		return 0;
 
-	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
+	if (fimc->id >= FIMC_MAX_DEVS)
 		return 0;
 
-	fmd->fimc[fimc->pdev->id] = fimc;
+	fmd->fimc[fimc->id] = fimc;
 	sd->grp_id = FIMC_GROUP_ID;
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
-- 
1.7.10

