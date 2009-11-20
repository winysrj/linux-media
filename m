Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56506 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbZKTVnb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 16:43:31 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 1/2] V4L - vpfe_capture - convert ccdc drivers to platform drivers
Date: Fri, 20 Nov 2009 16:43:33 -0500
Message-Id: <1258753414-11514-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Current implementation defines ccdc memory map in vpfe capture platform
file and update the same in ccdc through a function call. This will not
scale well. For example for DM365 CCDC, there are are additional memory
map for Linear table. So it is cleaner to define memory map for ccdc 
driver in the platform file and read it by the ccdc platform driver during
probe.

This is only for review purpose only.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to linux-davinci tree
 drivers/media/video/davinci/dm355_ccdc.c   |   90 +++++++++++++++++++++++----
 drivers/media/video/davinci/dm644x_ccdc.c  |   78 ++++++++++++++++++++----
 drivers/media/video/davinci/vpfe_capture.c |   56 ++---------------
 3 files changed, 148 insertions(+), 76 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 4629cab..ff81f07 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -37,6 +37,7 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/videodev2.h>
+#include <mach/mux.h>
 #include <media/davinci/dm355_ccdc.h>
 #include <media/davinci/vpss.h>
 #include "dm355_ccdc_regs.h"
@@ -64,7 +65,6 @@ static struct ccdc_params_raw ccdc_hw_params_raw = {
 	},
 	.config_params = {
 		.datasft = 2,
-		.data_sz = CCDC_DATA_10BITS,
 		.mfilt1 = CCDC_NO_MEDIAN_FILTER1,
 		.mfilt2 = CCDC_NO_MEDIAN_FILTER2,
 		.alaw = {
@@ -105,7 +105,6 @@ static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
 
 static enum vpfe_hw_if_type ccdc_if_type;
 static void *__iomem ccdc_base_addr;
-static int ccdc_addr_size;
 
 /* Raw Bayer formats */
 static u32 ccdc_raw_bayer_pix_formats[] =
@@ -126,12 +125,6 @@ static inline void regw(u32 val, u32 offset)
 	__raw_writel(val, ccdc_base_addr + offset);
 }
 
-static void ccdc_set_ccdc_base(void *addr, int size)
-{
-	ccdc_base_addr = addr;
-	ccdc_addr_size = size;
-}
-
 static void ccdc_enable(int en)
 {
 	unsigned int temp;
@@ -938,7 +931,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	.hw_ops = {
 		.open = ccdc_open,
 		.close = ccdc_close,
-		.set_ccdc_base = ccdc_set_ccdc_base,
 		.enable = ccdc_enable,
 		.enable_out_to_sdram = ccdc_enable_output_to_sdram,
 		.set_hw_if_params = ccdc_set_hw_if_params,
@@ -959,19 +951,89 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int dm355_ccdc_init(void)
+static int __init dm355_ccdc_probe(struct platform_device *pdev)
 {
-	printk(KERN_NOTICE "dm355_ccdc_init\n");
-	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
-		return -1;
+	static resource_size_t  res_len;
+	struct resource	*res;
+	int status = 0;
+
+	/**
+	 * first try to register with vpfe. If not correct platform, then we
+	 * don't have to iomap
+	 */
+	status = vpfe_register_ccdc_device(&ccdc_hw_dev);
+	if (status < 0)
+		return status;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		status = -ENOENT;
+		goto fail_nores;
+	}
+	res_len = res->end - res->start + 1;
+
+	res = request_mem_region(res->start, res_len, res->name);
+	if (!res) {
+		status = -EBUSY;
+		goto fail_nores;
+	}
+
+	ccdc_base_addr = ioremap_nocache(res->start, res_len);
+	if (!ccdc_base_addr) {
+		status = -EBUSY;
+		goto fail;
+	}
+	/**
+	 * setup Mux configuration for vpfe input and register
+	 * vpfe capture platform device
+	 */
+	davinci_cfg_reg(DM355_VIN_PCLK);
+	davinci_cfg_reg(DM355_VIN_CAM_WEN);
+	davinci_cfg_reg(DM355_VIN_CAM_VD);
+	davinci_cfg_reg(DM355_VIN_CAM_HD);
+	davinci_cfg_reg(DM355_VIN_YIN_EN);
+	davinci_cfg_reg(DM355_VIN_CINL_EN);
+	davinci_cfg_reg(DM355_VIN_CINH_EN);
+
 	printk(KERN_NOTICE "%s is registered with vpfe.\n",
 		ccdc_hw_dev.name);
 	return 0;
+fail:
+	release_mem_region(res->start, res_len);
+fail_nores:
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return status;
 }
 
-static void dm355_ccdc_exit(void)
+static int dm355_ccdc_remove(struct platform_device *pdev)
 {
+	struct resource	*res;
+
+	iounmap(ccdc_base_addr);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		release_mem_region(res->start, res->end - res->start + 1);
 	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return 0;
+}
+
+static struct platform_driver dm355_ccdc_driver = {
+	.driver = {
+		.name	= "dm355_ccdc",
+		.owner = THIS_MODULE,
+	},
+	.remove = __devexit_p(dm355_ccdc_remove),
+	.probe = dm355_ccdc_probe,
+};
+
+static int dm355_ccdc_init(void)
+{
+	return platform_driver_register(&dm355_ccdc_driver);
+}
+
+static void dm355_ccdc_exit(void)
+{
+	platform_driver_unregister(&dm355_ccdc_driver);
 }
 
 module_init(dm355_ccdc_init);
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 2f19a91..2469b41 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -85,7 +85,6 @@ static u32 ccdc_raw_yuv_pix_formats[] =
 	{V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};
 
 static void *__iomem ccdc_base_addr;
-static int ccdc_addr_size;
 static enum vpfe_hw_if_type ccdc_if_type;
 
 /* register access routines */
@@ -99,12 +98,6 @@ static inline void regw(u32 val, u32 offset)
 	__raw_writel(val, ccdc_base_addr + offset);
 }
 
-static void ccdc_set_ccdc_base(void *addr, int size)
-{
-	ccdc_base_addr = addr;
-	ccdc_addr_size = size;
-}
-
 static void ccdc_enable(int flag)
 {
 	regw(flag, CCDC_PCR);
@@ -838,7 +831,6 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	.hw_ops = {
 		.open = ccdc_open,
 		.close = ccdc_close,
-		.set_ccdc_base = ccdc_set_ccdc_base,
 		.reset = ccdc_sbl_reset,
 		.enable = ccdc_enable,
 		.set_hw_if_params = ccdc_set_hw_if_params,
@@ -859,19 +851,79 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int dm644x_ccdc_init(void)
+static int __init dm644x_ccdc_probe(struct platform_device *pdev)
 {
-	printk(KERN_NOTICE "dm644x_ccdc_init\n");
-	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
-		return -1;
+	static resource_size_t  res_len;
+	struct resource	*res;
+	int status = 0;
+
+	/**
+	 * first try to register with vpfe. If not correct platform, then we
+	 * don't have to iomap
+	 */
+	status = vpfe_register_ccdc_device(&ccdc_hw_dev);
+	if (status < 0)
+		return status;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		status = -ENOENT;
+		goto fail_nores;
+	}
+
+	res_len = res->end - res->start + 1;
+
+	res = request_mem_region(res->start, res_len, res->name);
+	if (!res) {
+		status = -EBUSY;
+		goto fail_nores;
+	}
+
+	ccdc_base_addr = ioremap_nocache(res->start, res_len);
+	if (!ccdc_base_addr) {
+		status = -EBUSY;
+		goto fail;
+	}
+
 	printk(KERN_NOTICE "%s is registered with vpfe.\n",
 		ccdc_hw_dev.name);
 	return 0;
+fail:
+	release_mem_region(res->start, res_len);
+fail_nores:
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return status;
+}
+
+static int dm644x_ccdc_remove(struct platform_device *pdev)
+{
+	struct resource	*res;
+
+	iounmap(ccdc_base_addr);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		release_mem_region(res->start, res->end - res->start + 1);
+	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	return 0;
+}
+
+static struct platform_driver dm644x_ccdc_driver = {
+	.driver = {
+		.name	= "dm644x_ccdc",
+		.owner = THIS_MODULE,
+	},
+	.remove = __devexit_p(dm644x_ccdc_remove),
+	.probe = dm644x_ccdc_probe,
+};
+
+static int dm644x_ccdc_init(void)
+{
+	return platform_driver_register(&dm644x_ccdc_driver);
 }
 
 static void dm644x_ccdc_exit(void)
 {
-	vpfe_unregister_ccdc_device(&ccdc_hw_dev);
+	platform_driver_unregister(&dm644x_ccdc_driver);
 }
 
 module_init(dm644x_ccdc_init);
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 402ce43..cad60e3 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -108,9 +108,6 @@ struct ccdc_config {
 	int vpfe_probed;
 	/* name of ccdc device */
 	char name[32];
-	/* for storing mem maps for CCDC */
-	int ccdc_addr_size;
-	void *__iomem ccdc_addr;
 };
 
 /* data structures */
@@ -230,7 +227,6 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 	BUG_ON(!dev->hw_ops.set_image_window);
 	BUG_ON(!dev->hw_ops.get_image_window);
 	BUG_ON(!dev->hw_ops.get_line_length);
-	BUG_ON(!dev->hw_ops.setfbaddr);
 	BUG_ON(!dev->hw_ops.getfid);
 
 	mutex_lock(&ccdc_lock);
@@ -241,25 +237,23 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 		 * walk through it during vpfe probe
 		 */
 		printk(KERN_ERR "vpfe capture not initialized\n");
-		ret = -1;
+		ret = -EFAULT;
 		goto unlock;
 	}
 
 	if (strcmp(dev->name, ccdc_cfg->name)) {
 		/* ignore this ccdc */
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
 	if (ccdc_dev) {
 		printk(KERN_ERR "ccdc already registered\n");
-		ret = -1;
+		ret = -EINVAL;
 		goto unlock;
 	}
 
 	ccdc_dev = dev;
-	dev->hw_ops.set_ccdc_base(ccdc_cfg->ccdc_addr,
-				  ccdc_cfg->ccdc_addr_size);
 unlock:
 	mutex_unlock(&ccdc_lock);
 	return ret;
@@ -1338,7 +1332,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	vpfe_dev->memory = req_buf->memory;
 	videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
 				&vpfe_videobuf_qops,
-				NULL,
+				vpfe_dev->pdev,
 				&vpfe_dev->irqlock,
 				req_buf->type,
 				vpfe_dev->fmt.fmt.pix.field,
@@ -1883,46 +1877,22 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	}
 	vpfe_dev->ccdc_irq1 = res1->start;
 
-	/* Get address base of CCDC */
-	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res1) {
-		v4l2_err(pdev->dev.driver,
-			"Unable to get register address map\n");
-		ret = -ENOENT;
-		goto probe_disable_clock;
-	}
-
-	ccdc_cfg->ccdc_addr_size = res1->end - res1->start + 1;
-	if (!request_mem_region(res1->start, ccdc_cfg->ccdc_addr_size,
-				pdev->dev.driver->name)) {
-		v4l2_err(pdev->dev.driver,
-			"Failed request_mem_region for ccdc base\n");
-		ret = -ENXIO;
-		goto probe_disable_clock;
-	}
-	ccdc_cfg->ccdc_addr = ioremap_nocache(res1->start,
-					     ccdc_cfg->ccdc_addr_size);
-	if (!ccdc_cfg->ccdc_addr) {
-		v4l2_err(pdev->dev.driver, "Unable to ioremap ccdc addr\n");
-		ret = -ENXIO;
-		goto probe_out_release_mem1;
-	}
-
 	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
 			  "vpfe_capture0", vpfe_dev);
 
 	if (0 != ret) {
 		v4l2_err(pdev->dev.driver, "Unable to request interrupt\n");
-		goto probe_out_unmap1;
+		goto probe_disable_clock;
 	}
 
+
 	/* Allocate memory for video device */
 	vfd = video_device_alloc();
 	if (NULL == vfd) {
 		ret = -ENOMEM;
 		v4l2_err(pdev->dev.driver,
 			"Unable to alloc video device\n");
-		goto probe_out_release_irq;
+		goto probe_disable_clock;
 	}
 
 	/* Initialize field of video device */
@@ -2036,12 +2006,6 @@ probe_out_v4l2_unregister:
 probe_out_video_release:
 	if (vpfe_dev->video_dev->minor == -1)
 		video_device_release(vpfe_dev->video_dev);
-probe_out_release_irq:
-	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
-probe_out_unmap1:
-	iounmap(ccdc_cfg->ccdc_addr);
-probe_out_release_mem1:
-	release_mem_region(res1->start, res1->end - res1->start + 1);
 probe_disable_clock:
 	vpfe_disable_clock(vpfe_dev);
 	mutex_unlock(&ccdc_lock);
@@ -2057,7 +2021,6 @@ probe_free_dev_mem:
 static int vpfe_remove(struct platform_device *pdev)
 {
 	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
-	struct resource *res;
 
 	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
 
@@ -2065,11 +2028,6 @@ static int vpfe_remove(struct platform_device *pdev)
 	kfree(vpfe_dev->sd);
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 	video_unregister_device(vpfe_dev->video_dev);
-	mutex_lock(&ccdc_lock);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
-	iounmap(ccdc_cfg->ccdc_addr);
-	mutex_unlock(&ccdc_lock);
 	vpfe_disable_clock(vpfe_dev);
 	kfree(vpfe_dev);
 	kfree(ccdc_cfg);
-- 
1.6.0.4

