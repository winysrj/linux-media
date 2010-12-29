Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28519 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab0L2RdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 12:33:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 29 Dec 2010 18:32:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 12/15 v2] [media] s5p-fimc: Add control of the external sensor
 clock
In-reply-to: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293643975-4528-13-git-send-email-s.nawrocki@samsung.com>
References: <1293643975-4528-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Manage the camera sensor clock in the host driver rather than
leaving this task for sensor drivers. The clock frequency
must be passed in the sensor's and host driver's platform data.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   45 ++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.c    |   59 ++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-core.h    |   18 ++++++--
 include/media/s5p_fimc.h                    |    2 +
 4 files changed, 82 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 8165eb1..9490e48 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -113,26 +113,43 @@ static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
 	return -ENODEV;
 }
 
-static int fimc_isp_subdev_init(struct fimc_dev *fimc, int index)
+static int fimc_isp_subdev_init(struct fimc_dev *fimc, unsigned int index)
 {
 	struct s5p_fimc_isp_info *isp_info;
 	int ret;
 
+	if (index >= FIMC_MAX_CAMIF_CLIENTS)
+		return -EINVAL;
+
+	isp_info = fimc->pdata->isp_info[index];
+	if (!isp_info)
+		return -EINVAL;
+
+	if (isp_info->clk_frequency)
+		clk_set_rate(fimc->clock[CLK_CAM], isp_info->clk_frequency);
+
+	ret = clk_enable(fimc->clock[CLK_CAM]);
+	if (ret)
+		return ret;
+
 	ret = fimc_subdev_attach(fimc, index);
 	if (ret)
 		return ret;
 
-	isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
 	ret = fimc_hw_set_camera_polarity(fimc, isp_info);
-	if (!ret) {
-		ret = v4l2_subdev_call(fimc->vid_cap.sd, core,
-				       s_power, 1);
-		if (!ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
+
+	ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 1);
+	if (!ret)
+		return ret;
 
+	/* enabling power failed so unregister subdev */
 	fimc_subdev_unregister(fimc);
-	err("ISP initialization failed: %d", ret);
+
+	v4l2_err(&fimc->vid_cap.v4l2_dev, "ISP initialization failed: %d\n",
+		 ret);
+
 	return ret;
 }
 
@@ -191,10 +208,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 			   test_bit(ST_CAPT_SHUT, &fimc->state),
 			   FIMC_SHUTDOWN_TIMEOUT);
 
-	ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);
-
-	if (ret && ret != -ENOIOCTLCMD)
-		v4l2_err(&fimc->vid_cap.v4l2_dev, "s_stream(0) failed\n");
+	v4l2_subdev_call(cap->sd, video, s_stream, 0);
 
 	spin_lock_irqsave(&fimc->slock, flags);
 	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
@@ -409,7 +423,7 @@ static int fimc_capture_open(struct file *file)
 		return -EBUSY;
 
 	if (++fimc->vid_cap.refcnt == 1) {
-		ret = fimc_isp_subdev_init(fimc, -1);
+		ret = fimc_isp_subdev_init(fimc, 0);
 		if (ret) {
 			fimc->vid_cap.refcnt--;
 			return -EIO;
@@ -434,6 +448,7 @@ static int fimc_capture_close(struct file *file)
 		v4l2_err(&fimc->vid_cap.v4l2_dev, "releasing ISP\n");
 
 		v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
+		clk_disable(fimc->clock[CLK_CAM]);
 		fimc_subdev_unregister(fimc);
 	}
 
@@ -605,6 +620,8 @@ static int fimc_cap_s_input(struct file *file, void *priv,
 		int ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
 		if (ret)
 			err("s_power failed: %d", ret);
+
+		clk_disable(fimc->clock[CLK_CAM]);
 	}
 
 	/* Release the attached sensor subdevice. */
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b273fe1..0775bc7 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -30,7 +30,9 @@
 
 #include "fimc-core.h"
 
-static char *fimc_clock_name[NUM_FIMC_CLOCKS] = { "sclk_fimc", "fimc" };
+static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
+	"sclk_fimc", "fimc", "sclk_cam"
+};
 
 static struct fimc_fmt fimc_formats[] = {
 	{
@@ -1474,7 +1476,7 @@ static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 static void fimc_clk_release(struct fimc_dev *fimc)
 {
 	int i;
-	for (i = 0; i < NUM_FIMC_CLOCKS; i++) {
+	for (i = 0; i < fimc->num_clocks; i++) {
 		if (fimc->clock[i]) {
 			clk_disable(fimc->clock[i]);
 			clk_put(fimc->clock[i]);
@@ -1485,15 +1487,16 @@ static void fimc_clk_release(struct fimc_dev *fimc)
 static int fimc_clk_get(struct fimc_dev *fimc)
 {
 	int i;
-	for (i = 0; i < NUM_FIMC_CLOCKS; i++) {
-		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clock_name[i]);
-		if (IS_ERR(fimc->clock[i])) {
-			dev_err(&fimc->pdev->dev,
-				"failed to get fimc clock: %s\n",
-				fimc_clock_name[i]);
-			return -ENXIO;
+	for (i = 0; i < fimc->num_clocks; i++) {
+		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
+
+		if (!IS_ERR_OR_NULL(fimc->clock[i])) {
+			clk_enable(fimc->clock[i]);
+			continue;
 		}
-		clk_enable(fimc->clock[i]);
+		dev_err(&fimc->pdev->dev, "failed to get fimc clock: %s\n",
+			fimc_clocks[i]);
+		return -ENXIO;
 	}
 	return 0;
 }
@@ -1504,6 +1507,7 @@ static int fimc_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct samsung_fimc_driverdata *drv_data;
 	int ret = 0;
+	int cap_input_index = -1;
 
 	dev_dbg(&pdev->dev, "%s():\n", __func__);
 
@@ -1553,10 +1557,26 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_req_region;
 	}
 
+	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
+	/*
+	 * Check if vide capture node needs to be registered for this device
+	 * instance.
+	 */
+	if (fimc->pdata) {
+		int i;
+		for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i)
+			if (fimc->pdata->isp_info[i])
+				break;
+		if (i < FIMC_MAX_CAMIF_CLIENTS) {
+			cap_input_index = i;
+			fimc->num_clocks++;
+		}
+	}
+
 	ret = fimc_clk_get(fimc);
 	if (ret)
 		goto err_regs_unmap;
-	clk_set_rate(fimc->clock[0], drv_data->lclk_frequency);
+	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
@@ -1586,19 +1606,12 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_irq;
 
 	/* At least one camera sensor is required to register capture node */
-	if (fimc->pdata) {
-		int i;
-		for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i)
-			if (fimc->pdata->isp_info[i])
-				break;
-
-		if (i < FIMC_MAX_CAMIF_CLIENTS) {
-			ret = fimc_register_capture_device(fimc);
-			if (ret)
-				goto err_m2m;
-		}
+	if (cap_input_index >= 0) {
+		ret = fimc_register_capture_device(fimc);
+		if (ret)
+			goto err_m2m;
+		clk_disable(fimc->clock[CLK_BUS]);
 	}
-
 	/*
 	 * Exclude the additional output DMA address registers by masking
 	 * them out on HW revisions that provide extended capabilites.
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 6431d1a..9be5135 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -37,7 +37,7 @@
 
 /* Time to wait for next frame VSYNC interrupt while stopping operation. */
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
-#define NUM_FIMC_CLOCKS		2
+#define MAX_FIMC_CLOCKS		3
 #define MODULE_NAME		"s5p-fimc"
 #define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
@@ -45,7 +45,13 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 
-/* FIMC device state flags */
+/* indices to the clocks array */
+enum {
+	CLK_BUS,
+	CLK_GATE,
+	CLK_CAM,
+};
+
 enum fimc_dev_flags {
 	/* for m2m node */
 	ST_IDLE,
@@ -408,7 +414,8 @@ struct fimc_ctx;
  * @lock:	the mutex protecting this data structure
  * @pdev:	pointer to the FIMC platform device
  * @pdata:	pointer to the device platform data
- * @id:		FIMC device index (0..2)
+ * @id:		FIMC device index (0..FIMC_MAX_DEVS)
+ * @num_clocks: the number of clocks managed by this device instance
  * @clock[]:	the clocks required for FIMC operation
  * @regs:	the mapped hardware registers
  * @regs_res:	the resource claimed for IO registers
@@ -424,8 +431,9 @@ struct fimc_dev {
 	struct platform_device		*pdev;
 	struct s5p_platform_fimc	*pdata;
 	struct samsung_fimc_variant	*variant;
-	int				id;
-	struct clk			*clock[NUM_FIMC_CLOCKS];
+	u16				id;
+	u16				num_clocks;
+	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
 	struct resource			*regs_res;
 	int				irq;
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index d30b9dee..0d457ca 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -31,6 +31,7 @@ struct i2c_board_info;
  *			      interace configuration.
  *
  * @board_info: pointer to I2C subdevice's board info
+ * @clk_frequency: frequency of the clock the host interface provides to sensor
  * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
@@ -38,6 +39,7 @@ struct i2c_board_info;
  */
 struct s5p_fimc_isp_info {
 	struct i2c_board_info *board_info;
+	unsigned long clk_frequency;
 	enum cam_bus_type bus_type;
 	u16 i2c_bus_num;
 	u16 mux_id;
-- 
1.7.2.3

