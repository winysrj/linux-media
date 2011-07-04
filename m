Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9888 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab1GDRzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:44 -0400
Date: Mon, 04 Jul 2011 19:54:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 06/19] s5p-fimc: Remove sensor management code from FIMC
 capture driver
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The sensor subdevs need to be shared between all available FIMC instances.
Remove their registration from FIMC capture driver so they can then be
registered to the media device driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  139 +--------------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 2 files changed, 2 insertions(+), 139 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 5b08b69..e7aa61e 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -16,12 +16,9 @@
 #include <linux/bug.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
-#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/i2c.h>
 
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
@@ -32,126 +29,6 @@
 
 #include "fimc-core.h"
 
-static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
-					    struct s5p_fimc_isp_info *isp_info)
-{
-	struct i2c_adapter *i2c_adap;
-	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct v4l2_subdev *sd = NULL;
-
-	i2c_adap = i2c_get_adapter(isp_info->i2c_bus_num);
-	if (!i2c_adap)
-		return ERR_PTR(-ENOMEM);
-
-	sd = v4l2_i2c_new_subdev_board(&vid_cap->v4l2_dev, i2c_adap,
-				       isp_info->board_info, NULL);
-	if (!sd) {
-		v4l2_err(&vid_cap->v4l2_dev, "failed to acquire subdev\n");
-		return NULL;
-	}
-
-	v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered successfuly\n",
-		isp_info->board_info->type);
-
-	return sd;
-}
-
-static void fimc_subdev_unregister(struct fimc_dev *fimc)
-{
-	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct i2c_client *client;
-
-	if (vid_cap->input_index < 0)
-		return;	/* Subdevice already released or not registered. */
-
-	if (vid_cap->sd) {
-		v4l2_device_unregister_subdev(vid_cap->sd);
-		client = v4l2_get_subdevdata(vid_cap->sd);
-		i2c_unregister_device(client);
-		i2c_put_adapter(client->adapter);
-		vid_cap->sd = NULL;
-	}
-
-	vid_cap->input_index = -1;
-}
-
-/**
- * fimc_subdev_attach - attach v4l2_subdev to camera host interface
- *
- * @fimc: FIMC device information
- * @index: index to the array of available subdevices,
- *	   -1 for full array search or non negative value
- *	   to select specific subdevice
- */
-static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
-{
-	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct s5p_platform_fimc *pdata = fimc->pdata;
-	struct s5p_fimc_isp_info *isp_info;
-	struct v4l2_subdev *sd;
-	int i;
-
-	for (i = 0; i < pdata->num_clients; ++i) {
-		isp_info = &pdata->isp_info[i];
-
-		if (index >= 0 && i != index)
-			continue;
-
-		sd = fimc_subdev_register(fimc, isp_info);
-		if (!IS_ERR_OR_NULL(sd)) {
-			vid_cap->sd = sd;
-			vid_cap->input_index = i;
-
-			return 0;
-		}
-	}
-
-	vid_cap->input_index = -1;
-	vid_cap->sd = NULL;
-	v4l2_err(&vid_cap->v4l2_dev, "fimc%d: sensor attach failed\n",
-		 fimc->id);
-	return -ENODEV;
-}
-
-static int fimc_isp_subdev_init(struct fimc_dev *fimc, unsigned int index)
-{
-	struct s5p_fimc_isp_info *isp_info;
-	struct s5p_platform_fimc *pdata = fimc->pdata;
-	int ret;
-
-	if (index >= pdata->num_clients)
-		return -EINVAL;
-
-	isp_info = &pdata->isp_info[index];
-
-	if (isp_info->clk_frequency)
-		clk_set_rate(fimc->clock[CLK_CAM], isp_info->clk_frequency);
-
-	ret = clk_enable(fimc->clock[CLK_CAM]);
-	if (ret)
-		return ret;
-
-	ret = fimc_subdev_attach(fimc, index);
-	if (ret)
-		return ret;
-
-	ret = fimc_hw_set_camera_polarity(fimc, isp_info);
-	if (ret)
-		return ret;
-
-	ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 1);
-	if (!ret)
-		return ret;
-
-	/* enabling power failed so unregister subdev */
-	fimc_subdev_unregister(fimc);
-
-	v4l2_err(&fimc->vid_cap.v4l2_dev, "ISP initialization failed: %d\n",
-		 ret);
-
-	return ret;
-}
-
 static int fimc_stop_capture(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -396,15 +273,7 @@ static int fimc_capture_open(struct file *file)
 	if (ret)
 		return ret;
 
-	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_isp_subdev_init(fimc, 0);
-		if (ret) {
-			pm_runtime_put_sync(&fimc->pdev->dev);
-			fimc->vid_cap.refcnt--;
-			return -EIO;
-		}
-	}
-
+	++fimc->vid_cap.refcnt;
 	file->private_data = fimc->vid_cap.ctx;
 
 	return 0;
@@ -419,12 +288,6 @@ static int fimc_capture_close(struct file *file)
 	if (--fimc->vid_cap.refcnt == 0) {
 		fimc_stop_capture(fimc);
 		vb2_queue_release(&fimc->vid_cap.vbq);
-
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "releasing ISP\n");
-
-		v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
-		clk_disable(fimc->clock[CLK_CAM]);
-		fimc_subdev_unregister(fimc);
 	}
 
 	pm_runtime_put_sync(&fimc->pdev->dev);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index f059216..210301e 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -11,6 +11,7 @@
 
 /*#define DEBUG*/
 
+#include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -649,7 +650,6 @@ int fimc_register_m2m_device(struct fimc_dev *fimc);
 /* fimc-capture.c					*/
 int fimc_register_capture_device(struct fimc_dev *fimc);
 void fimc_unregister_capture_device(struct fimc_dev *fimc);
-int fimc_sensor_sd_init(struct fimc_dev *fimc, int index);
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
 int fimc_capture_suspend(struct fimc_dev *fimc);
-- 
1.7.5.4

