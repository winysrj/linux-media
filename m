Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60537 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab3GCF4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:56:19 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 2/7] marvell-ccic: add clock tree support for marvell-ccic driver
Date: Wed, 3 Jul 2013 13:55:59 +0800
Message-ID: <1372830964-22323-3-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the clock tree support for marvell-ccic.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.h  |    5 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   61 ++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 26fb154..07fdf68 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -83,6 +83,8 @@ struct mcam_frame_state {
 	unsigned int delivered;
 };
 
+#define NR_MCAM_CLK 3
+
 /*
  * A description of one of our devices.
  * Locking: controlled by s_mutex.  Certain fields, however, require
@@ -118,6 +120,9 @@ struct mcam_camera {
 	bool mipi_enabled;	/* flag whether mipi is enabled already */
 	int lane;			/* lane number */
 
+	/* clock tree support */
+	struct clk *clk[NR_MCAM_CLK];
+
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 2b28802..64dacc5 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -35,6 +35,8 @@ MODULE_ALIAS("platform:mmp-camera");
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_LICENSE("GPL");
 
+static char *mcam_clks[] = {"CCICAXICLK", "CCICFUNCLK", "CCICPHYCLK"};
+
 struct mmp_camera {
 	void *power_regs;
 	struct platform_device *pdev;
@@ -105,6 +107,26 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
 
+static void mcam_clk_enable(struct mcam_camera *mcam)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_MCAM_CLK; i++) {
+		if (!IS_ERR(mcam->clk[i]))
+			clk_prepare_enable(mcam->clk[i]);
+	}
+}
+
+static void mcam_clk_disable(struct mcam_camera *mcam)
+{
+	int i;
+
+	for (i = NR_MCAM_CLK - 1; i >= 0; i--) {
+		if (!IS_ERR(mcam->clk[i]))
+			clk_disable_unprepare(mcam->clk[i]);
+	}
+}
+
 /*
  * Power control.
  */
@@ -142,6 +164,9 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
+
+	mcam_clk_enable(mcam);
+
 	return 0;
 }
 
@@ -166,6 +191,8 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 			devm_clk_put(mcam->dev, cam->mipi_clk);
 		cam->mipi_clk = NULL;
 	}
+
+	mcam_clk_disable(mcam);
 }
 
 /*
@@ -276,6 +303,35 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
+static void mcam_deinit_clk(struct mcam_camera *mcam)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_MCAM_CLK; i++) {
+		if (!IS_ERR(mcam->clk[i])) {
+			if (mcam->clk[i])
+				devm_clk_put(mcam->dev, mcam->clk[i]);
+		}
+		mcam->clk[i] = NULL;
+	}
+}
+
+static void mcam_init_clk(struct mcam_camera *mcam)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_MCAM_CLK; i++) {
+		if (mcam_clks[i] != NULL) {
+			/* Some clks are not necessary on some boards
+			 * We still try to run even it fails getting clk
+			 */
+			mcam->clk[i] = devm_clk_get(mcam->dev, mcam_clks[i]);
+			if (IS_ERR(mcam->clk[i]))
+				dev_warn(mcam->dev, "Could not get clk: %s\n",
+						mcam_clks[i]);
+		}
+	}
+}
 
 static int mmpcam_probe(struct platform_device *pdev)
 {
@@ -370,6 +426,9 @@ static int mmpcam_probe(struct platform_device *pdev)
 		goto out_gpio;
 	}
 	gpio_direction_output(pdata->sensor_reset_gpio, 0);
+
+	mcam_init_clk(mcam);
+
 	/*
 	 * Power the device up and hand it off to the core.
 	 */
@@ -401,6 +460,7 @@ out_unregister:
 out_pwdn:
 	mmpcam_power_down(mcam);
 out_gpio2:
+	mcam_deinit_clk(mcam);
 	gpio_free(pdata->sensor_reset_gpio);
 out_gpio:
 	gpio_free(pdata->sensor_power_gpio);
@@ -426,6 +486,7 @@ static int mmpcam_remove(struct mmp_camera *cam)
 	pdata = cam->pdev->dev.platform_data;
 	gpio_free(pdata->sensor_reset_gpio);
 	gpio_free(pdata->sensor_power_gpio);
+	mcam_deinit_clk(mcam);
 	iounmap(cam->power_regs);
 	iounmap(mcam->regs);
 	kfree(cam);
-- 
1.7.9.5

