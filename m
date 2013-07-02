Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:54026 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab3GBDbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 23:31:21 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v2 2/7] marvell-ccic: add clock tree support for marvell-ccic driver
Date: Tue, 2 Jul 2013 11:31:03 +0800
Message-ID: <1372735868-15880-3-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
References: <1372735868-15880-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the clock tree support for marvell-ccic.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.h  |    6 +++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   47 ++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 90162ef..6a68aa4 100644
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
@@ -118,6 +120,10 @@ struct mcam_camera {
 	bool mipi_enabled;	/* flag whether mipi is enable already */
 	int lane;			/* lane number */
 
+	/* clock tree support */
+	struct clk *clk[NR_MCAM_CLK];
+
+
 	/*
 	 * Callbacks from the core to the platform code.
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 3b343ce..3830c44 100644
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
@@ -135,6 +157,9 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
+
+	mcam_clk_enable(mcam);
+
 	if (mcam->bus_type == V4L2_MBUS_CSI2) {
 		cam->mipi_clk = devm_clk_get(mcam->dev, "mipi");
 		if ((IS_ERR(cam->mipi_clk) && mcam->dphy[2] == 0))
@@ -164,6 +189,8 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 			devm_clk_put(mcam->dev, cam->mipi_clk);
 		cam->mipi_clk = NULL;
 	}
+
+	mcam_clk_disable(mcam);
 }
 
 /*
@@ -274,6 +301,23 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
 	return IRQ_RETVAL(handled);
 }
 
+static int mcam_init_clk(struct mcam_camera *mcam,
+			struct mmp_camera_platform_data *pdata)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_MCAM_CLK; i++) {
+		if (mcam_clks[i] != NULL) {
+			mcam->clk[i] = devm_clk_get(mcam->dev, mcam_clks[i]);
+			if (IS_ERR(mcam->clk[i])) {
+				dev_err(mcam->dev, "Could not get clk: %s\n",
+						mcam_clks[i]);
+				return PTR_ERR(mcam->clk[i]);
+			}
+		}
+	}
+	return 0;
+}
 
 static int mmpcam_probe(struct platform_device *pdev)
 {
@@ -341,6 +385,9 @@ static int mmpcam_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto out_unmap1;
 	}
+
+	mcam_init_clk(mcam, pdata);
+
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
-- 
1.7.9.5

