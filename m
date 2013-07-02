Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60214 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab3GBDbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 23:31:17 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v2 1/7] marvell-ccic: add MIPI support for marvell-ccic driver
Date: Tue, 2 Jul 2013 11:31:02 +0800
Message-ID: <1372735868-15880-2-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
References: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the MIPI support for marvell-ccic.
Board driver should determine whether using MIPI or not.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   |   78 ++++++++++++-
 drivers/media/platform/marvell-ccic/mcam-core.h   |   37 +++++-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |  129 ++++++++++++++++++++-
 include/media/mmp-camera.h                        |   19 +++
 5 files changed, 256 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index d030f9b..68e82fb 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -400,7 +400,7 @@ static void cafe_ctlr_init(struct mcam_camera *mcam)
 }
 
 
-static void cafe_ctlr_power_up(struct mcam_camera *mcam)
+static int cafe_ctlr_power_up(struct mcam_camera *mcam)
 {
 	/*
 	 * Part one of the sensor dance: turn the global
@@ -415,6 +415,8 @@ static void cafe_ctlr_power_up(struct mcam_camera *mcam)
 	 */
 	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN); /* pwr up, reset */
 	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C0);
+
+	return 0;
 }
 
 static void cafe_ctlr_power_down(struct mcam_camera *mcam)
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 64ab91e..1e8b3d3 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -254,6 +255,45 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
+static void mcam_enable_mipi(struct mcam_camera *mcam)
+{
+	/* Using MIPI mode and enable MIPI */
+	cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
+			mcam->dphy[0], mcam->dphy[1], mcam->dphy[2]);
+	mcam_reg_write(mcam, REG_CSI2_DPHY3, mcam->dphy[0]);
+	mcam_reg_write(mcam, REG_CSI2_DPHY5, mcam->dphy[1]);
+	mcam_reg_write(mcam, REG_CSI2_DPHY6, mcam->dphy[2]);
+
+	if (!mcam->mipi_enabled) {
+		if (mcam->lane > 4 || mcam->lane <= 0) {
+			cam_warn(mcam, "lane number error\n");
+			mcam->lane = 1;	/* set the default value */
+		}
+		/*
+		 * 0x41 actives 1 lane
+		 * 0x43 actives 2 lanes
+		 * 0x45 actives 3 lanes (never happen)
+		 * 0x47 actives 4 lanes
+		 */
+		mcam_reg_write(mcam, REG_CSI2_CTRL0,
+			CSI2_C0_MIPI_EN | CSI2_C0_ACT_LANE(mcam->lane));
+		mcam_reg_write(mcam, REG_CLKCTRL,
+			(mcam->mclk_src << 29) | mcam->mclk_div);
+
+		mcam->mipi_enabled = true;
+	}
+}
+
+static void mcam_disable_mipi(struct mcam_camera *mcam)
+{
+	/* Using Parallel mode or disable MIPI */
+	mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x0);
+	mcam_reg_write(mcam, REG_CSI2_DPHY3, 0x0);
+	mcam_reg_write(mcam, REG_CSI2_DPHY5, 0x0);
+	mcam_reg_write(mcam, REG_CSI2_DPHY6, 0x0);
+	mcam->mipi_enabled = false;
+}
+
 /* ------------------------------------------------------------------- */
 
 #ifdef MCAM_MODE_VMALLOC
@@ -657,6 +697,13 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
 	 */
 	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
 			C0_SIFM_MASK);
+
+	/*
+	 * This field controls the generation of EOF(DVP only)
+	 */
+	if (cam->bus_type != V4L2_MBUS_CSI2)
+		mcam_reg_set_bit(cam, REG_CTRL0,
+				C0_EOF_VSYNC | C0_VEDGE_CTRL);
 }
 
 
@@ -754,15 +801,21 @@ static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
 /*
  * Power up and down.
  */
-static void mcam_ctlr_power_up(struct mcam_camera *cam)
+static int mcam_ctlr_power_up(struct mcam_camera *cam)
 {
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
-	cam->plat_power_up(cam);
+	ret = cam->plat_power_up(cam);
+	if (ret) {
+		spin_unlock_irqrestore(&cam->dev_lock, flags);
+		return ret;
+	}
 	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
 	spin_unlock_irqrestore(&cam->dev_lock, flags);
 	msleep(5); /* Just to be sure */
+	return 0;
 }
 
 static void mcam_ctlr_power_down(struct mcam_camera *cam)
@@ -887,6 +940,17 @@ static int mcam_read_setup(struct mcam_camera *cam)
 	spin_lock_irqsave(&cam->dev_lock, flags);
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	mcam_reset_buffers(cam);
+	/*
+	 * Update CSI2_DPHY value
+	 */
+	if (cam->calc_dphy)
+		cam->calc_dphy(cam);
+	cam_dbg(cam, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
+			cam->dphy[0], cam->dphy[1], cam->dphy[2]);
+	if (cam->bus_type == V4L2_MBUS_CSI2)
+		mcam_enable_mipi(cam);
+	else
+		mcam_disable_mipi(cam);
 	mcam_ctlr_irq_enable(cam);
 	cam->state = S_STREAMING;
 	if (!test_bit(CF_SG_RESTART, &cam->flags))
@@ -1503,7 +1567,9 @@ static int mcam_v4l_open(struct file *filp)
 		ret = mcam_setup_vb2(cam);
 		if (ret)
 			goto out;
-		mcam_ctlr_power_up(cam);
+		ret = mcam_ctlr_power_up(cam);
+		if (ret)
+			goto out;
 		__mcam_cam_reset(cam);
 		mcam_set_config_needed(cam, 1);
 	}
@@ -1526,10 +1592,12 @@ static int mcam_v4l_release(struct file *filp)
 	if (cam->users == 0) {
 		mcam_ctlr_stop_dma(cam);
 		mcam_cleanup_vb2(cam);
+		mcam_disable_mipi(cam);
 		mcam_ctlr_power_down(cam);
 		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
 			mcam_free_dma_bufs(cam);
 	}
+
 	mutex_unlock(&cam->s_mutex);
 	return 0;
 }
@@ -1816,7 +1884,9 @@ int mccic_resume(struct mcam_camera *cam)
 
 	mutex_lock(&cam->s_mutex);
 	if (cam->users > 0) {
-		mcam_ctlr_power_up(cam);
+		ret = mcam_ctlr_power_up(cam);
+		if (ret)
+			return ret;
 		__mcam_cam_reset(cam);
 	} else {
 		mcam_ctlr_power_down(cam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 01dec9e..90162ef 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -102,11 +102,28 @@ struct mcam_camera {
 	short int clock_speed;	/* Sensor clock speed, default 30 */
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
+
+	int mclk_min;	/* The minimal value of mclk */
+	int mclk_src;	/* which clock source the mclk derives from */
+	int mclk_div;	/* Clock Divider Value for MCLK */
+
+	enum v4l2_mbus_type bus_type;
+	/* MIPI support */
+	/* The dphy config value, allocated in board file
+	 * dphy[0]: DPHY3
+	 * dphy[1]: DPHY5
+	 * dphy[2]: DPHY6
+	 */
+	int *dphy;
+	bool mipi_enabled;	/* flag whether mipi is enable already */
+	int lane;			/* lane number */
+
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
-	void (*plat_power_up) (struct mcam_camera *cam);
+	int (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
+	void (*calc_dphy) (struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
@@ -220,6 +237,17 @@ int mccic_resume(struct mcam_camera *cam);
 #define REG_Y0BAR	0x00
 #define REG_Y1BAR	0x04
 #define REG_Y2BAR	0x08
+
+/*
+ * register definitions for MIPI support
+ */
+#define REG_CSI2_CTRL0	0x100
+#define   CSI2_C0_MIPI_EN (0x1 << 0)
+#define   CSI2_C0_ACT_LANE(n) ((n-1) << 1)
+#define REG_CSI2_DPHY3	0x12c
+#define REG_CSI2_DPHY5	0x134
+#define REG_CSI2_DPHY6	0x138
+
 /* ... */
 
 #define REG_IMGPITCH	0x24	/* Image pitch register */
@@ -288,13 +316,16 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C0_YUVE_XUVY	  0x00020000	/* 420: .UVY		*/
 #define	  C0_YUVE_XVUY	  0x00030000	/* 420: .VUY		*/
 /* Bayer bits 18,19 if needed */
+#define	  C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
+#define	  C0_VEDGE_CTRL   0x00800000	/* Detect falling edge of VSYNC */
 #define	  C0_HPOL_LOW	  0x01000000	/* HSYNC polarity active low */
 #define	  C0_VPOL_LOW	  0x02000000	/* VSYNC polarity active low */
 #define	  C0_VCLK_LOW	  0x04000000	/* VCLK on falling edge */
 #define	  C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
-#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
+/* SIFMODE */
 #define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
-#define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
+#define	  C0_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
+#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
 
 /* Bits below C1_444ALPHA are not present in Cafe */
 #define REG_CTRL1	0x40	/* Control 1 */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index c4c17fe..3b343ce 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/pm.h>
+#include <linux/clk.h>
 
 #include "mcam-core.h"
 
@@ -39,6 +40,7 @@ struct mmp_camera {
 	struct platform_device *pdev;
 	struct mcam_camera mcam;
 	struct list_head devlist;
+	struct clk *mipi_clk;
 	int irq;
 };
 
@@ -113,7 +115,7 @@ static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
 	mdelay(1);
 }
 
-static void mmpcam_power_up(struct mcam_camera *mcam)
+static int mmpcam_power_up(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
 	struct mmp_camera_platform_data *pdata;
@@ -133,6 +135,12 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
+	if (mcam->bus_type == V4L2_MBUS_CSI2) {
+		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
+		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
+			return PTR_ERR(cam->mipi_clk);
+	}
+	return 0;
 }
 
 static void mmpcam_power_down(struct mcam_camera *mcam)
@@ -150,8 +158,109 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	pdata = cam->pdev->dev.platform_data;
 	gpio_set_value(pdata->sensor_power_gpio, 0);
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
+
+	if (mcam->bus_type == V4L2_MBUS_CSI2 && !IS_ERR(cam->mipi_clk)) {
+		if (cam->mipi_clk)
+			devm_clk_put(mcam->dev, cam->mipi_clk);
+		cam->mipi_clk = NULL;
+	}
 }
 
+/*
+ * calc the dphy register values
+ * There are three dphy registers being used.
+ * dphy[0] - CSI2_DPHY3
+ * dphy[1] - CSI2_DPHY5
+ * dphy[2] - CSI2_DPHY6
+ * CSI2_DPHY3 and CSI2_DPHY6 can be set with a default value
+ * or be calculated dynamically
+ */
+void mmpcam_calc_dphy(struct mcam_camera *mcam)
+{
+	struct mmp_camera *cam = mcam_to_cam(mcam);
+	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
+	struct device *dev = &cam->pdev->dev;
+	unsigned long tx_clk_esc;
+
+	/*
+	 * If CSI2_DPHY3 is calculated dynamically,
+	 * pdata->lane_clk should be already set
+	 * either in the board driver statically
+	 * or in the sensor driver dynamically.
+	 */
+	/*
+	 * dphy[0] - CSI2_DPHY3:
+	 *  bit 0 ~ bit 7: HS Term Enable.
+	 *   defines the time that the DPHY
+	 *   wait before enabling the data
+	 *   lane termination after detecting
+	 *   that the sensor has driven the data
+	 *   lanes to the LP00 bridge state.
+	 *   The value is calculated by:
+	 *   (Max T(D_TERM_EN)/Period(DDR)) - 1
+	 *  bit 8 ~ bit 15: HS_SETTLE
+	 *   Time interval during which the HS
+	 *   receiver shall ignore any Data Lane
+	 *   HS transistions.
+	 *   The vaule has been calibrated on
+	 *   different boards. It seems to work well.
+	 *
+	 *  More detail please refer
+	 *  MIPI Alliance Spectification for D-PHY
+	 *  document for explanation of HS-SETTLE
+	 *  and D-TERM-EN.
+	 */
+	switch (pdata->dphy3_algo) {
+	case DPHY3_ALGO_PXA910:
+		/*
+		 * Calculate CSI2_DPHY3 algo for PXA910
+		 */
+		pdata->dphy[0] =
+			(((1 + (pdata->lane_clk * 80) / 1000) & 0xff) << 8)
+			| (1 + pdata->lane_clk * 35 / 1000);
+		break;
+	case DPHY3_ALGO_PXA2128:
+		/*
+		 * Calculate CSI2_DPHY3 algo for PXA2128
+		 */
+		pdata->dphy[0] =
+			(((2 + (pdata->lane_clk * 110) / 1000) & 0xff) << 8)
+			| (1 + pdata->lane_clk * 35 / 1000);
+		break;
+	default:
+		/*
+		 * Use default CSI2_DPHY3 value for PXA688/PXA988
+		 */
+		dev_dbg(dev, "camera: use the default CSI2_DPHY3 value\n");
+	}
+
+	/*
+	 * mipi_clk will never be changed, it is a fixed value on MMP
+	 */
+	if (IS_ERR(cam->mipi_clk))
+		return;
+
+	/* get the escape clk, this is hard coded */
+	tx_clk_esc = (clk_get_rate(cam->mipi_clk) / 1000000) / 12;
+
+	/*
+	 * dphy[2] - CSI2_DPHY6:
+	 * bit 0 ~ bit 7: CK Term Enable
+	 *  Time for the Clock Lane receiver to enable the HS line
+	 *  termination. The value is calculated similarly with
+	 *  HS Term Enable
+	 * bit 8 ~ bit 15: CK Settle
+	 *  Time interval during which the HS receiver shall ignore
+	 *  any Clock Lane HS transitions.
+	 *  The value is calibrated on the boards.
+	 */
+	pdata->dphy[2] =
+		((((534 * tx_clk_esc) / 2000 - 1) & 0xff) << 8)
+		| (((38 * tx_clk_esc) / 1000 - 1) & 0xff);
+
+	dev_dbg(dev, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
+		pdata->dphy[0], pdata->dphy[1], pdata->dphy[2]);
+}
 
 static irqreturn_t mmpcam_irq(int irq, void *data)
 {
@@ -174,17 +283,30 @@ static int mmpcam_probe(struct platform_device *pdev)
 	struct mmp_camera_platform_data *pdata;
 	int ret;
 
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
 	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 	if (cam == NULL)
 		return -ENOMEM;
 	cam->pdev = pdev;
+	cam->mipi_clk = NULL;
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
+	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->mclk_min = pdata->mclk_min;
+	mcam->mclk_src = pdata->mclk_src;
+	mcam->mclk_div = pdata->mclk_div;
+	mcam->bus_type = pdata->bus_type;
+	mcam->dphy = pdata->dphy;
+	mcam->mipi_enabled = false;
+	mcam->lane = pdata->lane;
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
 	spin_lock_init(&mcam->dev_lock);
@@ -223,7 +345,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
 	 */
-	pdata = pdev->dev.platform_data;
 	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
 	if (mcam->i2c_adapter == NULL) {
 		ret = -ENODEV;
@@ -250,7 +371,9 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Power the device up and hand it off to the core.
 	 */
-	mmpcam_power_up(mcam);
+	ret = mmpcam_power_up(mcam);
+	if (ret)
+		goto out_gpio2;
 	ret = mccic_register(mcam);
 	if (ret)
 		goto out_gpio2;
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 7611963..b099d4b 100644
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -1,9 +1,28 @@
+#include <media/v4l2-mediabus.h>
 /*
  * Information for the Marvell Armada MMP camera
  */
 
+enum dphy3_algo {
+	DPHY3_ALGO_DEFAULT = 0,
+	DPHY3_ALGO_PXA910,
+	DPHY3_ALGO_PXA2128
+};
+
 struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	enum v4l2_mbus_type bus_type;
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
+	/*
+	 * MIPI support
+	 */
+	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
+	enum dphy3_algo dphy3_algo;	/* algos for calculate CSI2_DPHY3 */
+	int mipi_enabled;	/* MIPI enabled flag */
+	int lane;		/* ccic used lane number; 0 means DVP mode */
+	int lane_clk;
 };
-- 
1.7.9.5

