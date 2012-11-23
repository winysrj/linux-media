Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47400 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317Ab2KWNeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:23 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic driver
Date: Fri, 23 Nov 2012 21:33:15 +0800
Message-Id: <1353677595-24034-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the clock tree support for marvell-ccic.

Each board may require different clk enabling sequence.
Developer need add the clk_name in correct sequence in board driver
to use this feature.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.h  |    6 +++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   57 ++++++++++++++++++++++
 include/media/mmp-camera.h                       |    5 ++
 3 files changed, 68 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 2d444a1..0df6b1c 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -88,6 +88,7 @@ struct mmp_frame_state {
  *          the dev_lock spinlock; they are marked as such by comments.
  *          dev_lock is also required for access to device registers.
  */
+#define NR_MCAM_CLK 4
 struct mcam_camera {
 	/*
 	 * These fields should be set by the platform code prior to
@@ -107,6 +108,11 @@ struct mcam_camera {
 	int (*dphy)[3];
 	int mipi_enabled;
 	int lane;			/* lane number */
+
+	/* clock tree support */
+	struct clk *clk[NR_MCAM_CLK];
+	int clk_num;
+
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 9d7aa79..80977b0 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -104,6 +104,23 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
 
+static void mcam_clk_set(struct mcam_camera *mcam, int on)
+{
+	unsigned int i;
+
+	if (on) {
+		for (i = 0; i < mcam->clk_num; i++) {
+			if (mcam->clk[i])
+				clk_enable(mcam->clk[i]);
+		}
+	} else {
+		for (i = 0; i < mcam->clk_num; i++) {
+			if (mcam->clk[i])
+				clk_disable(mcam->clk[i]);
+		}
+	}
+}
+
 /*
  * Power control.
  */
@@ -134,6 +151,8 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
+
+	mcam_clk_set(mcam, 1);
 }
 
 static void mmpcam_power_down(struct mcam_camera *mcam)
@@ -151,6 +170,8 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	pdata = cam->pdev->dev.platform_data;
 	gpio_set_value(pdata->sensor_power_gpio, 0);
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
+
+	mcam_clk_set(mcam, 0);
 }
 
 /*
@@ -229,6 +250,37 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
+static void mcam_init_clk(struct mcam_camera *mcam,
+			struct mmp_camera_platform_data *pdata, int init)
+{
+	unsigned int i;
+
+	if (NR_MCAM_CLK < pdata->clk_num) {
+		dev_warn(mcam->dev, "Too many mcam clocks defined\n");
+		mcam->clk_num = 0;
+		return;
+	}
+
+	if (init) {
+		for (i = 0; i < pdata->clk_num; i++) {
+			if (pdata->clk_name[i] != NULL)
+				mcam->clk[i] = clk_get(mcam->dev,
+						pdata->clk_name[i]);
+			if (IS_ERR(mcam->clk[i]))
+				dev_warn(mcam->dev, "Could not get clk: %s\n",
+						 pdata->clk_name[i]);
+		}
+		mcam->clk_num = pdata->clk_num;
+	} else {
+		for (i = 0; i < pdata->clk_num; i++) {
+			if (mcam->clk[i]) {
+				clk_put(mcam->clk[i]);
+				mcam->clk[i] = NULL;
+			}
+		}
+		mcam->clk_num = 0;
+	}
+}
 
 static int mmpcam_probe(struct platform_device *pdev)
 {
@@ -290,6 +342,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto out_unmap1;
 	}
+
+	mcam_init_clk(mcam, pdata, 1);
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
@@ -317,6 +371,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 		goto out_gpio;
 	}
 	gpio_direction_output(pdata->sensor_reset_gpio, 0);
+
 	/*
 	 * Power the device up and hand it off to the core.
 	 */
@@ -349,6 +404,7 @@ out_gpio2:
 out_gpio:
 	gpio_free(pdata->sensor_power_gpio);
 out_unmap2:
+	mcam_init_clk(mcam, pdata, 0);
 	iounmap(cam->power_regs);
 out_unmap1:
 	iounmap(mcam->regs);
@@ -372,6 +428,7 @@ static int mmpcam_remove(struct mmp_camera *cam)
 	gpio_free(pdata->sensor_power_gpio);
 	iounmap(cam->power_regs);
 	iounmap(mcam->regs);
+	mcam_init_clk(mcam, pdata, 0);
 	kfree(cam);
 	return 0;
 }
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index a0b034a..e161ae0 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -15,4 +15,9 @@ struct mmp_camera_platform_data {
 	int mipi_enabled;	/* MIPI enabled flag */
 	int lane;		/* ccic used lane number; 0 means DVP mode */
 	int lane_clk;
+	/*
+	 * clock tree support
+	 */
+	char *clk_name[4];
+	int clk_num;
 };
-- 
1.7.9.5

