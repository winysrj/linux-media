Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62311 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab3BMKBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 05:01:32 -0500
Received: by mail-pa0-f42.google.com with SMTP id kq12so630068pab.29
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 02:01:32 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	aditya.ps@samsung.com, tom.gall@linaro.org, patches@linaro.org,
	linux-samsung-soc@vger.kernel.org, ragesh.r@linaro.org,
	jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org
Subject: [RFC v2 2/3] video: exynos: mipi dsi: Making Exynos MIPI Compliant with CDF
Date: Wed, 13 Feb 2013 15:31:06 +0530
Message-Id: <1360749667-12028-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modifies the exynos mipi dsi driver as per the CDF-T.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/video/exynos/exynos_mipi_dsi.c        |  197 ++++++-------------------
 drivers/video/exynos/exynos_mipi_dsi_common.c |   22 ++-
 drivers/video/exynos/exynos_mipi_dsi_common.h |   12 +-
 include/video/exynos_mipi_dsim.h              |    5 +-
 4 files changed, 69 insertions(+), 167 deletions(-)

diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index 32dde44..c4eca0a 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -32,14 +32,13 @@
 #include <linux/notifier.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
-
+#include <video/display.h>
 #include <video/exynos_mipi_dsim.h>
 
 #include <plat/fb.h>
 
 #include "exynos_mipi_dsi_common.h"
 #include "exynos_mipi_dsi_lowlevel.h"
-
 struct mipi_dsim_ddi {
 	int				bus_id;
 	struct list_head		list;
@@ -97,8 +96,6 @@ static void exynos_mipi_update_cfg(struct mipi_dsim_device *dsim)
 	exynos_mipi_dsi_init_dsim(dsim);
 	exynos_mipi_dsi_init_link(dsim);
 
-	exynos_mipi_dsi_set_hs_enable(dsim);
-
 	/* set display timing. */
 	exynos_mipi_dsi_set_display_mode(dsim, dsim->dsim_config);
 
@@ -111,12 +108,13 @@ static void exynos_mipi_update_cfg(struct mipi_dsim_device *dsim)
 	exynos_mipi_dsi_stand_by(dsim, 1);
 }
 
-static int exynos_mipi_dsi_early_blank_mode(struct mipi_dsim_device *dsim,
+static int exynos_mipi_dsi_early_blank_mode(struct video_source *video_source,
 		int power)
 {
+	struct mipi_dsim_device *dsim = container_of(video_source,
+					struct mipi_dsim_device, video_source);
 	struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
 	struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
-
 	switch (power) {
 	case FB_BLANK_POWERDOWN:
 		if (dsim->suspended)
@@ -139,12 +137,13 @@ static int exynos_mipi_dsi_early_blank_mode(struct mipi_dsim_device *dsim,
 	return 0;
 }
 
-static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
+static int exynos_mipi_dsi_blank_mode(struct video_source *video_source, int power)
 {
+	struct mipi_dsim_device *dsim = container_of(video_source,
+					struct mipi_dsim_device, video_source);
 	struct platform_device *pdev = to_platform_device(dsim->dev);
 	struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
 	struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
-
 	switch (power) {
 	case FB_BLANK_UNBLANK:
 		if (!dsim->suspended)
@@ -164,6 +163,8 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
 
 		exynos_mipi_update_cfg(dsim);
 
+		exynos_mipi_dsi_set_hs_enable(dsim);
+
 		/* set lcd panel sequence commands. */
 		if (client_drv && client_drv->set_sequence)
 			client_drv->set_sequence(client_dev);
@@ -205,134 +206,31 @@ int exynos_mipi_dsi_register_lcd_device(struct mipi_dsim_lcd_device *lcd_dev)
 	return 0;
 }
 
-static struct mipi_dsim_ddi *exynos_mipi_dsi_find_lcd_device(
-					struct mipi_dsim_lcd_driver *lcd_drv)
+static void exynos_mipi_dsi_panel_release(struct video_source *src)
 {
-	struct mipi_dsim_ddi *dsim_ddi, *next;
-	struct mipi_dsim_lcd_device *lcd_dev;
-
-	mutex_lock(&mipi_dsim_lock);
-
-	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
-		if (!dsim_ddi)
-			goto out;
-
-		lcd_dev = dsim_ddi->dsim_lcd_dev;
-		if (!lcd_dev)
-			continue;
-
-		if ((strcmp(lcd_drv->name, lcd_dev->name)) == 0) {
-			/**
-			 * bus_id would be used to identify
-			 * connected bus.
-			 */
-			dsim_ddi->bus_id = lcd_dev->bus_id;
-			mutex_unlock(&mipi_dsim_lock);
-
-			return dsim_ddi;
-		}
-
-		list_del(&dsim_ddi->list);
-		kfree(dsim_ddi);
-	}
-
-out:
-	mutex_unlock(&mipi_dsim_lock);
-
-	return NULL;
+	pr_info("dsi entity release\n");
 }
 
-int exynos_mipi_dsi_register_lcd_driver(struct mipi_dsim_lcd_driver *lcd_drv)
+void  exynos_mipi_set_hs_enable(struct video_source *video_source, bool enable)
 {
-	struct mipi_dsim_ddi *dsim_ddi;
-
-	if (!lcd_drv->name) {
-		pr_err("dsim_lcd_driver name is NULL.\n");
-		return -EFAULT;
-	}
-
-	dsim_ddi = exynos_mipi_dsi_find_lcd_device(lcd_drv);
-	if (!dsim_ddi) {
-		pr_err("v mipi_dsim_ddi object not found.\n");
-		return -EFAULT;
-	}
-
-	dsim_ddi->dsim_lcd_drv = lcd_drv;
-
-	pr_info("v registered panel driver(%s) to mipi-dsi driver.\n",
-		lcd_drv->name);
-
-	return 0;
-
+	struct mipi_dsim_device *dsim = container_of(video_source,
+					struct mipi_dsim_device, video_source);
+	exynos_mipi_dsi_set_hs_enable(dsim);
+	return;
 }
 
-static struct mipi_dsim_ddi *exynos_mipi_dsi_bind_lcd_ddi(
-						struct mipi_dsim_device *dsim,
-						const char *name)
-{
-	struct mipi_dsim_ddi *dsim_ddi, *next;
-	struct mipi_dsim_lcd_driver *lcd_drv;
-	struct mipi_dsim_lcd_device *lcd_dev;
-	int ret;
-
-	mutex_lock(&dsim->lock);
-
-	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
-		lcd_drv = dsim_ddi->dsim_lcd_drv;
-		lcd_dev = dsim_ddi->dsim_lcd_dev;
-
-#if 0		
-		if (!lcd_drv || !lcd_dev ||
-			(dsim->id != dsim_ddi->bus_id))
-				continue;
-#else
-		if (!lcd_drv || !lcd_dev)
-				continue;
-#endif
-
-		dev_dbg(dsim->dev, "lcd_drv->id = %d, lcd_dev->id = %d\n",
-				lcd_drv->id, lcd_dev->id);
-		dev_dbg(dsim->dev, "lcd_dev->bus_id = %d, dsim->id = %d\n",
-				lcd_dev->bus_id, dsim->id);
-
-		if ((strcmp(lcd_drv->name, name) == 0)) {
-			lcd_dev->master = dsim;
-
-			lcd_dev->dev.parent = dsim->dev;
-			dev_set_name(&lcd_dev->dev, "%s", lcd_drv->name);
-
-			ret = device_register(&lcd_dev->dev);
-			if (ret < 0) {
-				dev_err(dsim->dev,
-					"can't register %s, status %d\n",
-					dev_name(&lcd_dev->dev), ret);
-				mutex_unlock(&dsim->lock);
-
-				return NULL;
-			}
-
-			dsim->dsim_lcd_dev = lcd_dev;
-			dsim->dsim_lcd_drv = lcd_drv;
-
-			mutex_unlock(&dsim->lock);
-
-			return dsim_ddi;
-		}
-	}
-
-	mutex_unlock(&dsim->lock);
-
-	return NULL;
-}
+static const struct common_video_source_ops dsi_common_ops = {
+	/* No common ops */
+};
 
-/* define MIPI-DSI Master operations. */
-static struct mipi_dsim_master_ops master_ops = {
-	.cmd_read			= exynos_mipi_dsi_rd_data,
-	.cmd_write			= exynos_mipi_dsi_wr_data,
-	.get_dsim_frame_done		= exynos_mipi_dsi_get_frame_done_status,
-	.clear_dsim_frame_done		= exynos_mipi_dsi_clear_frame_done,
+static const struct dsi_video_source_ops exynos_dsi_ops = {
+	.dcs_read			= exynos_mipi_dsi_rd_data,
+	.dcs_write			= exynos_mipi_dsi_wr_data,
+	.get_frame_done			= exynos_mipi_dsi_get_frame_done_status,
+	.clear_frame_done		= exynos_mipi_dsi_clear_frame_done,
 	.set_early_blank_mode		= exynos_mipi_dsi_early_blank_mode,
 	.set_blank_mode			= exynos_mipi_dsi_blank_mode,
+	.enable_hs			= exynos_mipi_set_hs_enable,
 };
 
 static int exynos_mipi_dsi_probe(struct platform_device *pdev)
@@ -341,7 +239,6 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	struct mipi_dsim_device *dsim;
 	struct mipi_dsim_config *dsim_config;
 	struct mipi_dsim_platform_data *dsim_pd;
-	struct mipi_dsim_ddi *dsim_ddi;
 	int ret = -EINVAL;
 
 	dsim = kzalloc(sizeof(struct mipi_dsim_device), GFP_KERNEL);
@@ -360,6 +257,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to get platform data for dsim.\n");
 		goto err_clock_get;
 	}
+
 	/* get mipi_dsim_config. */
 	dsim_config = dsim_pd->dsim_config;
 	if (dsim_config == NULL) {
@@ -368,7 +266,6 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	}
 
 	dsim->dsim_config = dsim_config;
-	dsim->master_ops = &master_ops;
 
 	mutex_init(&dsim->lock);
 
@@ -411,14 +308,6 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 
 	mutex_init(&dsim->lock);
 
-	/* bind lcd ddi matched with panel name. */
-	dsim_ddi = exynos_mipi_dsi_bind_lcd_ddi(dsim, dsim_pd->lcd_panel_name);
-	if (!dsim_ddi) {
-		dev_err(&pdev->dev, " >>> probe:  mipi_dsim_ddi object not found.\n");
-		ret = -EINVAL;
-		goto err_bind;
-	}
-
 	dsim->irq = platform_get_irq(pdev, 0);
 	if (dsim->irq < 0) {
 		dev_err(&pdev->dev, "failed to request dsim irq resource\n");
@@ -441,20 +330,12 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 	/* enable interrupts */
 	exynos_mipi_dsi_init_interrupt(dsim);
 
-	/* initialize mipi-dsi client(lcd panel). */
-	if (dsim_ddi->dsim_lcd_drv && dsim_ddi->dsim_lcd_drv->probe)
-		dsim_ddi->dsim_lcd_drv->probe(dsim_ddi->dsim_lcd_dev);
-
 	/* in case mipi-dsi has been enabled by bootloader */
 	if (dsim_pd->enabled) {
 		exynos_mipi_regulator_enable(dsim);
 		goto done;
 	}
 
-	/* lcd panel power on. */
-	if (dsim_ddi->dsim_lcd_drv && dsim_ddi->dsim_lcd_drv->power_on)
-		dsim_ddi->dsim_lcd_drv->power_on(dsim_ddi->dsim_lcd_dev, 1);
-
 	exynos_mipi_regulator_enable(dsim);
 
 	/* enable MIPI-DSI PHY. */
@@ -463,12 +344,22 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 
 	exynos_mipi_update_cfg(dsim);
 
-	/* set lcd panel sequence commands. */
-	if (dsim_ddi->dsim_lcd_drv && dsim_ddi->dsim_lcd_drv->set_sequence)
-		dsim_ddi->dsim_lcd_drv->set_sequence(dsim_ddi->dsim_lcd_dev);
-
 	dsim->suspended = false;
 
+	dsim->video_source.dev = &pdev->dev;
+	dsim->video_source.release = exynos_mipi_dsi_panel_release;
+	dsim->video_source.common_ops = &dsi_common_ops;
+	dsim->video_source.ops.dsi = &exynos_dsi_ops;
+	dsim->video_source.name = "exynos-mipi-dsim";
+
+	ret = video_source_register(&dsim->video_source);
+	if (ret < 0) {
+		pr_err("dsi entity register failed\n");
+		goto err_bind;
+	}
+
+	pr_info("dsi entity registered: %p\n", &dsim->video_source);
+
 done:
 	platform_set_drvdata(pdev, dsim);
 
@@ -502,6 +393,8 @@ static int __devexit exynos_mipi_dsi_remove(struct platform_device *pdev)
 	struct mipi_dsim_ddi *dsim_ddi, *next;
 	struct mipi_dsim_lcd_driver *dsim_lcd_drv;
 
+	video_source_unregister(&dsim->video_source);
+
 	iounmap(dsim->reg_base);
 
 	clk_disable(dsim->clock);
@@ -586,6 +479,8 @@ static int exynos_mipi_dsi_resume(struct device *dev)
 
 	exynos_mipi_update_cfg(dsim);
 
+	exynos_mipi_dsi_set_hs_enable(dsim);
+
 	/* set lcd panel sequence commands. */
 	if (client_drv && client_drv->set_sequence)
 		client_drv->set_sequence(client_dev);
@@ -603,7 +498,7 @@ static const struct dev_pm_ops exynos_mipi_dsi_pm_ops = {
 static struct platform_device_id exynos_mipi_driver_ids[] = {
 	{
 		.name		= "exynos-mipi",
-		.driver_data	= NULL,
+		.driver_data	= 0,
 	},
 	{},
 };
@@ -621,7 +516,7 @@ MODULE_DEVICE_TABLE(of, exynos_mipi_match);
 static struct platform_driver exynos_mipi_dsi_driver = {
 	.probe = exynos_mipi_dsi_probe,
 	.remove = __devexit_p(exynos_mipi_dsi_remove),
-	//.id_table = exynos_mipi_driver_ids,
+	.id_table = exynos_mipi_driver_ids,
 	.driver = {
 		   .name = "exynos-mipi-dsim",
 		   .owner = THIS_MODULE,
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
index 8888dc7..8971804 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -153,11 +153,12 @@ static void exynos_mipi_dsi_long_data_wr(struct mipi_dsim_device *dsim,
 		}
 	}
 }
-
-int exynos_mipi_dsi_wr_data(struct mipi_dsim_device *dsim, unsigned int data_id,
-	const unsigned char *data0, unsigned int data_size)
+int exynos_mipi_dsi_wr_data(struct video_source *video_source, int data_id,
+	u8 *data0, size_t data_size)
 {
 	unsigned int check_rx_ack = 0;
+	struct mipi_dsim_device *dsim = container_of(video_source,
+				struct mipi_dsim_device, video_source);
 
 	if (dsim->state == DSIM_STATE_ULPS) {
 		dev_err(dsim->dev, "state is ULPS.\n");
@@ -340,12 +341,14 @@ static unsigned int exynos_mipi_dsi_response_size(unsigned int req_size)
 	}
 }
 
-int exynos_mipi_dsi_rd_data(struct mipi_dsim_device *dsim, unsigned int data_id,
-	unsigned int data0, unsigned int req_size, u8 *rx_buf)
+int exynos_mipi_dsi_rd_data(struct video_source *video_source, int data_id,
+			u8 data0, u8 *rx_buf,size_t req_size)
 {
 	unsigned int rx_data, rcv_pkt, i;
 	u8 response = 0;
 	u16 rxsize;
+	struct mipi_dsim_device *dsim = container_of(video_source,
+				struct mipi_dsim_device, video_source);
 
 	if (dsim->state == DSIM_STATE_ULPS) {
 		dev_err(dsim->dev, "state is ULPS.\n");
@@ -843,13 +846,18 @@ int exynos_mipi_dsi_set_data_transfer_mode(struct mipi_dsim_device *dsim,
 	return 0;
 }
 
-int exynos_mipi_dsi_get_frame_done_status(struct mipi_dsim_device *dsim)
+int exynos_mipi_dsi_get_frame_done_status(struct video_source *video_source)
 {
+	 struct mipi_dsim_device *dsim = container_of(video_source,
+				struct mipi_dsim_device, video_source);
+
 	return _exynos_mipi_dsi_get_frame_done_status(dsim);
 }
 
-int exynos_mipi_dsi_clear_frame_done(struct mipi_dsim_device *dsim)
+int exynos_mipi_dsi_clear_frame_done(struct video_source *video_source)
 {
+	 struct mipi_dsim_device *dsim = container_of(video_source,
+				struct mipi_dsim_device, video_source);
 	_exynos_mipi_dsi_clear_frame_done(dsim);
 
 	return 0;
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.h b/drivers/video/exynos/exynos_mipi_dsi_common.h
index 4125522..cd89154 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.h
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.h
@@ -18,10 +18,10 @@
 static DECLARE_COMPLETION(dsim_rd_comp);
 static DECLARE_COMPLETION(dsim_wr_comp);
 
-int exynos_mipi_dsi_wr_data(struct mipi_dsim_device *dsim, unsigned int data_id,
-	const unsigned char *data0, unsigned int data_size);
-int exynos_mipi_dsi_rd_data(struct mipi_dsim_device *dsim, unsigned int data_id,
-	unsigned int data0, unsigned int req_size, u8 *rx_buf);
+int exynos_mipi_dsi_rd_data(struct video_source *video_source, int data_id,
+				u8 data0, u8 *rx_buf,size_t req_size);
+int exynos_mipi_dsi_wr_data(struct video_source *video_source, int data_id,
+				u8 *data0, size_t data_size);
 irqreturn_t exynos_mipi_dsi_interrupt_handler(int irq, void *dev_id);
 void exynos_mipi_dsi_init_interrupt(struct mipi_dsim_device *dsim);
 int exynos_mipi_dsi_init_dsim(struct mipi_dsim_device *dsim);
@@ -35,8 +35,8 @@ int exynos_mipi_dsi_set_data_transfer_mode(struct mipi_dsim_device *dsim,
 		unsigned int mode);
 int exynos_mipi_dsi_enable_frame_done_int(struct mipi_dsim_device *dsim,
 	unsigned int enable);
-int exynos_mipi_dsi_get_frame_done_status(struct mipi_dsim_device *dsim);
-int exynos_mipi_dsi_clear_frame_done(struct mipi_dsim_device *dsim);
+int exynos_mipi_dsi_get_frame_done_status(struct video_source *video_source);
+int exynos_mipi_dsi_clear_frame_done(struct video_source *video_source);
 
 extern struct fb_info *registered_fb[FB_MAX] __read_mostly;
 
diff --git a/include/video/exynos_mipi_dsim.h b/include/video/exynos_mipi_dsim.h
index 83ce5e6..e50438e 100644
--- a/include/video/exynos_mipi_dsim.h
+++ b/include/video/exynos_mipi_dsim.h
@@ -17,7 +17,7 @@
 
 #include <linux/device.h>
 #include <linux/fb.h>
-
+#include <video/display.h>
 #define PANEL_NAME_SIZE		(32)
 
 /*
@@ -225,9 +225,8 @@ struct mipi_dsim_device {
 	unsigned int			irq;
 	void __iomem			*reg_base;
 	struct mutex			lock;
-
+	struct video_source		video_source;
 	struct mipi_dsim_config		*dsim_config;
-	struct mipi_dsim_master_ops	*master_ops;
 	struct mipi_dsim_lcd_device	*dsim_lcd_dev;
 	struct mipi_dsim_lcd_driver	*dsim_lcd_drv;
 
-- 
1.7.9.5

