Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:54181 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454Ab2LOJ7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:52 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic driver
Date: Sat, 15 Dec 2012 17:57:52 +0800
Message-Id: <1355565484-15791-4-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
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
 drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   57 +++++++++++++++++++++-
 include/media/mmp-camera.h                       |    5 ++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index ca63010..86e634e 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -88,6 +88,7 @@ struct mcam_frame_state {
  *          the dev_lock spinlock; they are marked as such by comments.
  *          dev_lock is also required for access to device registers.
  */
+#define NR_MCAM_CLK 4
 struct mcam_camera {
 	/*
 	 * These fields should be set by the platform code prior to
@@ -109,6 +110,9 @@ struct mcam_camera {
 	int lane;			/* lane number */
 
 	struct clk *pll1;
+	/* clock tree support */
+	struct clk *clk[NR_MCAM_CLK];
+	int clk_num;
 
 	/*
 	 * Callbacks from the core to the platform code.
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 603fa0a..2c4dce3 100755
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
+		for (i = mcam->clk_num; i > 0; i--) {
+			if (mcam->clk[i - 1])
+				clk_disable(mcam->clk[i - 1]);
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
@@ -202,7 +223,7 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
 	 * pll1 will never be changed, it is a fixed value
 	 */
 
-	if (IS_ERR(mcam->pll1))
+	if (IS_ERR_OR_NULL(mcam->pll1))
 		return;
 
 	tx_clk_esc = clk_get_rate(mcam->pll1) / 1000000 / 12;
@@ -229,6 +250,35 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
+static void mcam_init_clk(struct mcam_camera *mcam,
+			struct mmp_camera_platform_data *pdata, int init)
+{
+	unsigned int i;
+
+	if (NR_MCAM_CLK < pdata->clk_num) {
+		dev_err(mcam->dev, "Too many mcam clocks defined\n");
+		mcam->clk_num = 0;
+		return;
+	}
+
+	if (init) {
+		for (i = 0; i < pdata->clk_num; i++) {
+			if (pdata->clk_name[i] != NULL) {
+				mcam->clk[i] = devm_clk_get(mcam->dev,
+						pdata->clk_name[i]);
+				if (IS_ERR(mcam->clk[i])) {
+					dev_err(mcam->dev,
+						"Could not get clk: %s\n",
+						pdata->clk_name[i]);
+					mcam->clk_num = 0;
+					return;
+				}
+			}
+		}
+		mcam->clk_num = pdata->clk_num;
+	} else
+		mcam->clk_num = 0;
+}
 
 static int mmpcam_probe(struct platform_device *pdev)
 {
@@ -293,6 +343,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto out_unmap1;
 	}
+
+	mcam_init_clk(mcam, pdata, 1);
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
@@ -320,6 +372,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 		goto out_gpio;
 	}
 	gpio_direction_output(pdata->sensor_reset_gpio, 0);
+
 	/*
 	 * Power the device up and hand it off to the core.
 	 */
@@ -352,6 +405,7 @@ out_gpio2:
 out_gpio:
 	gpio_free(pdata->sensor_power_gpio);
 out_unmap2:
+	mcam_init_clk(mcam, pdata, 0);
 	iounmap(cam->power_regs);
 out_unmap1:
 	iounmap(mcam->regs);
@@ -375,6 +429,7 @@ static int mmpcam_remove(struct mmp_camera *cam)
 	gpio_free(pdata->sensor_power_gpio);
 	iounmap(cam->power_regs);
 	iounmap(mcam->regs);
+	mcam_init_clk(mcam, pdata, 0);
 	kfree(cam);
 	return 0;
 }
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 813efe2..c339d43 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -16,4 +16,9 @@ struct mmp_camera_platform_data {
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

