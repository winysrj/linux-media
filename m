Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42018 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097Ab3KEJdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 04:33:40 -0500
Message-ID: <1383643996.30496.3.camel@younglee-desktop>
Subject: [RFC] [PATCH] media: marvell-ccic: use devm to release clk
From: lbyang <lbyang@marvell.com>
Reply-To: lbyang@marvell.com
To: <corbet@lwn.net>
CC: <linux-media@vger.kernel.org>, <u.kleine-koenig@pengutronix.de>,
	<linux@arm.linux.org.uk>
Date: Tue, 5 Nov 2013 17:33:16 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>
Date: Tue, 5 Nov 2013 16:29:07 +0800
Subject: [PATCH] media: marvell-ccic: use devm to release clk

This patch uses devm to release the clks instead of releasing
manually.
And it adds enable/disable mipi_clk when getting its rate.

Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c |   39
+++++-----------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 70cb57f..054507f 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -142,12 +142,6 @@ static int mmpcam_power_up(struct mcam_camera
*mcam)
 	struct mmp_camera *cam = mcam_to_cam(mcam);
 	struct mmp_camera_platform_data *pdata;
 
-	if (mcam->bus_type == V4L2_MBUS_CSI2) {
-		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
-		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
-			return PTR_ERR(cam->mipi_clk);
-	}
-
 /*
  * Turn on power and clocks to the controller.
  */
@@ -186,12 +180,6 @@ static void mmpcam_power_down(struct mcam_camera
*mcam)
 	gpio_set_value(pdata->sensor_power_gpio, 0);
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
 
-	if (mcam->bus_type == V4L2_MBUS_CSI2 && !IS_ERR(cam->mipi_clk)) {
-		if (cam->mipi_clk)
-			devm_clk_put(mcam->dev, cam->mipi_clk);
-		cam->mipi_clk = NULL;
-	}
-
 	mcam_clk_disable(mcam);
 }
 
@@ -292,8 +280,9 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
 		return;
 
 	/* get the escape clk, this is hard coded */
+	clk_prepare_enable(cam->mipi_clk);
 	tx_clk_esc = (clk_get_rate(cam->mipi_clk) / 1000000) / 12;
-
+	clk_disable_unprepare(cam->mipi_clk);
 	/*
 	 * dphy[2] - CSI2_DPHY6:
 	 * bit 0 ~ bit 7: CK Term Enable
@@ -325,19 +314,6 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
-static void mcam_deinit_clk(struct mcam_camera *mcam)
-{
-	unsigned int i;
-
-	for (i = 0; i < NR_MCAM_CLK; i++) {
-		if (!IS_ERR(mcam->clk[i])) {
-			if (mcam->clk[i])
-				devm_clk_put(mcam->dev, mcam->clk[i]);
-		}
-		mcam->clk[i] = NULL;
-	}
-}
-
 static void mcam_init_clk(struct mcam_camera *mcam)
 {
 	unsigned int i;
@@ -371,7 +347,6 @@ static int mmpcam_probe(struct platform_device
*pdev)
 	if (cam == NULL)
 		return -ENOMEM;
 	cam->pdev = pdev;
-	cam->mipi_clk = NULL;
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
@@ -387,6 +362,11 @@ static int mmpcam_probe(struct platform_device
*pdev)
 	mcam->mclk_div = pdata->mclk_div;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
+	if (mcam->bus_type == V4L2_MBUS_CSI2) {
+		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
+		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
+			return PTR_ERR(cam->mipi_clk);
+	}
 	mcam->mipi_enabled = false;
 	mcam->lane = pdata->lane;
 	mcam->chip_id = MCAM_ARMADA610;
@@ -444,7 +424,7 @@ static int mmpcam_probe(struct platform_device
*pdev)
 	 */
 	ret = mmpcam_power_up(mcam);
 	if (ret)
-		goto out_deinit_clk;
+		return ret;
 	ret = mccic_register(mcam);
 	if (ret)
 		goto out_power_down;
@@ -469,8 +449,6 @@ out_unregister:
 	mccic_shutdown(mcam);
 out_power_down:
 	mmpcam_power_down(mcam);
-out_deinit_clk:
-	mcam_deinit_clk(mcam);
 	return ret;
 }
 
@@ -482,7 +460,6 @@ static int mmpcam_remove(struct mmp_camera *cam)
 	mmpcam_remove_device(cam);
 	mccic_shutdown(mcam);
 	mmpcam_power_down(mcam);
-	mcam_deinit_clk(mcam);
 	return 0;
 }
 
-- 
1.7.9.5



