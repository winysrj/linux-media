Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:59204 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab2KWNeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:22 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic driver
Date: Fri, 23 Nov 2012 21:33:07 +0800
Message-Id: <1353677587-23998-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the MIPI support for marvell-ccic.
Board driver should determine whether using MIPI or not.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c  |   60 ++++++++++++++++++
 drivers/media/platform/marvell-ccic/mcam-core.h  |   21 ++++++-
 drivers/media/platform/marvell-ccic/mmp-driver.c |   72 +++++++++++++++++++++-
 include/media/mmp-camera.h                       |    9 +++
 4 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 7012913f..b111f0d 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -253,6 +253,46 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
+static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
+{
+	if (mcam->bus_type == V4L2_MBUS_CSI2_LANES && enable) {
+		/* Using MIPI mode and enable MIPI */
+		cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
+			(*mcam->dphy)[0], (*mcam->dphy)[1], (*mcam->dphy)[2]);
+		mcam_reg_write(mcam, REG_CSI2_DPHY3, (*mcam->dphy)[0]);
+		mcam_reg_write(mcam, REG_CSI2_DPHY6, (*mcam->dphy)[2]);
+		mcam_reg_write(mcam, REG_CSI2_DPHY5, (*mcam->dphy)[1]);
+
+		if (mcam->mipi_enabled == 0) {
+			/*
+			 * 0x41 actives 1 lane
+			 * 0x43 actives 2 lanes
+			 * 0x47 actives 4 lanes
+			 * There is no 3 lanes case
+			 */
+			if (mcam->lane == 1)
+				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x41);
+			else if (mcam->lane == 2)
+				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x43);
+			else if (mcam->lane == 4)
+				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x47);
+			else {
+				cam_err(mcam, "camera: lane number set err");
+				return -EINVAL;
+			}
+			mcam->mipi_enabled = 1;
+		}
+	} else {
+		/* Using para mode or disable MIPI */
+		mcam_reg_write(mcam, REG_CSI2_DPHY3, 0x0);
+		mcam_reg_write(mcam, REG_CSI2_DPHY6, 0x0);
+		mcam_reg_write(mcam, REG_CSI2_DPHY5, 0x0);
+		mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x0);
+		mcam->mipi_enabled = 0;
+	}
+	return 0;
+}
+
 /* ------------------------------------------------------------------- */
 
 #ifdef MCAM_MODE_VMALLOC
@@ -656,6 +696,15 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	 */
 	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
 			C0_SIFM_MASK);
+
+	/*
+	 * This field controls the generation of EOF(DVP only)
+	 */
+	if (cam->bus_type != V4L2_MBUS_CSI2_LANES) {
+		mcam_reg_set_bit(cam, REG_CTRL0,
+				C0_EOF_VSYNC | C0_VEDGE_CTRL);
+		mcam_reg_write(cam, REG_CTRL3, 0x4);
+	}
 }
 
 
@@ -886,6 +935,16 @@ static int mcam_read_setup(struct mcam_camera *cam)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	mcam_reset_buffers(cam);
+	/*
+	 * Update CSI2_DPHY value
+	 */
+	if (cam->calc_dphy)
+		cam->calc_dphy(cam);
+	cam_dbg(cam, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
+			(*cam->dphy)[0], (*cam->dphy)[1], (*cam->dphy)[2]);
+	ret = mcam_config_mipi(cam, 1);
+	if (ret < 0)
+		return ret;
 	mcam_ctlr_irq_enable(cam);
 	cam->state = S_STREAMING;
 	if (!test_bit(CF_SG_RESTART, &cam->flags))
@@ -1569,6 +1628,7 @@ static int mcam_v4l_release(struct file *filp)
 	if (cam->users == 0) {
 		mcam_ctlr_stop_dma(cam);
 		mcam_cleanup_vb2(cam);
+		mcam_config_mipi(cam, 0);
 		mcam_ctlr_power_down(cam);
 		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
 			mcam_free_dma_bufs(cam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index e226de4..2d444a1 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -101,11 +101,18 @@ struct mcam_camera {
 	short int clock_speed;	/* Sensor clock speed, default 30 */
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
+
+	/* MIPI support */
+	int bus_type;
+	int (*dphy)[3];
+	int mipi_enabled;
+	int lane;			/* lane number */
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
 	void (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
+	void (*calc_dphy)(struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
@@ -218,6 +225,15 @@ int mccic_resume(struct mcam_camera *cam);
 #define REG_Y0BAR	0x00
 #define REG_Y1BAR	0x04
 #define REG_Y2BAR	0x08
+
+/*
+ * register definitions for MIPI support
+ */
+#define REG_CSI2_CTRL0	0x100
+#define REG_CSI2_DPHY3  0x12c
+#define REG_CSI2_DPHY5  0x134
+#define REG_CSI2_DPHY6  0x138
+
 /* ... */
 
 #define REG_IMGPITCH	0x24	/* Image pitch register */
@@ -292,7 +308,9 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
 #define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
 #define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
-#define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
+#define	  C0_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
+#define   C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
+#define   C0_VEDGE_CTRL   0x00800000	/* Detecting falling edge of VSYNC */
 
 /* Bits below C1_444ALPHA are not present in Cafe */
 #define REG_CTRL1	0x40	/* Control 1 */
@@ -308,6 +326,7 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
 #define	  C1_PWRDWN	  0x10000000	/* Power down */
 
+#define REG_CTRL3	0x1ec	/* CCIC parallel mode */
 #define REG_CLKCTRL	0x88	/* Clock control */
 #define	  CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
 
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index c4c17fe..9d7aa79 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/pm.h>
+#include <linux/clk.h>
 
 #include "mcam-core.h"
 
@@ -152,6 +153,69 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
 }
 
+/*
+ * calc the dphy register values
+ * There are three dphy registers being used.
+ * dphy[0] can be set with a default value
+ * or be calculated dynamically
+ */
+void mmpcam_calc_dphy(struct mcam_camera *mcam)
+{
+	struct mmp_camera *cam = mcam_to_cam(mcam);
+	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
+	struct device *dev = &cam->pdev->dev;
+	unsigned long tx_clk_esc;
+	struct clk *pll1;
+
+	/*
+	 * If dphy[0] is calculated dynamically,
+	 * pdata->lane_clk should be already set
+	 * either in the board driver statically
+	 * or in the sensor driver dynamically.
+	 */
+	if (pdata->dphy3_algo == 1)
+		/*
+		 * dphy3_algo == 1
+		 * Calculate CSI2_DPHY3 algo for PXA910
+		 */
+		pdata->dphy[0] = ((1 + pdata->lane_clk * 80 / 1000) & 0xff) << 8
+			| (1 + pdata->lane_clk * 35 / 1000);
+	else if (pdata->dphy3_algo == 2)
+		/*
+		 * dphy3_algo == 2
+		 * Calculate CSI2_DPHY3 algo for PXA2128
+		 */
+		pdata->dphy[0] =
+			((2 + pdata->lane_clk * 110 / 1000) & 0xff) << 8
+			| (1 + pdata->lane_clk * 35 / 1000);
+	else
+		/*
+		 * dphy3_algo == 0
+		 * Use default CSI2_DPHY3 value for PXA688/PXA988
+		 */
+		dev_dbg(dev, "camera: use the default CSI2_DPHY3 value\n");
+
+	/*
+	 * pll1 will never be changed, it is a fixed value
+	 */
+	pll1 = clk_get(dev, "pll1");
+	if (IS_ERR(pll1)) {
+		dev_err(dev, "Could not get pll1 clock\n");
+		return;
+	}
+
+	tx_clk_esc = clk_get_rate(pll1) / 1000000 / 12;
+	clk_put(pll1);
+
+	/*
+	 * Update dphy6 according to current tx_clk_esc
+	 */
+	pdata->dphy[2] = ((534 * tx_clk_esc / 2000 - 1) & 0xff) << 8
+			| ((38 * tx_clk_esc / 1000 - 1) & 0xff);
+
+	dev_dbg(dev, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
+		pdata->dphy[0], pdata->dphy[1], pdata->dphy[2]);
+}
 
 static irqreturn_t mmpcam_irq(int irq, void *data)
 {
@@ -174,6 +238,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	struct mmp_camera_platform_data *pdata;
 	int ret;
 
+	pdata = pdev->dev.platform_data;
+
 	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 	if (cam == NULL)
 		return -ENOMEM;
@@ -183,8 +249,13 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam = &cam->mcam;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
+	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->bus_type = pdata->bus_type;
+	mcam->dphy = &(pdata->dphy);
+	mcam->mipi_enabled = 0;
+	mcam->lane = pdata->lane;
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
 	spin_lock_init(&mcam->dev_lock);
@@ -223,7 +294,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
 	 */
-	pdata = pdev->dev.platform_data;
 	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
 	if (mcam->i2c_adapter == NULL) {
 		ret = -ENODEV;
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 7611963..a0b034a 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -6,4 +6,13 @@ struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	/*
+	 * MIPI support
+	 */
+	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
+	int dphy3_algo;		/* Exist 2 algos for calculate CSI2_DPHY3 */
+	int bus_type;
+	int mipi_enabled;	/* MIPI enabled flag */
+	int lane;		/* ccic used lane number; 0 means DVP mode */
+	int lane_clk;
 };
-- 
1.7.9.5

