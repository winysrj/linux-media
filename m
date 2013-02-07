Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:59014 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758194Ab3BGMF5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:05:57 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [REVIEW PATCH V4 02/12] [media] marvell-ccic: add clock tree support for marvell-ccic driver
Date: Thu,  7 Feb 2013 20:04:37 +0800
Message-Id: <1360238687-15768-3-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the clock tree support for marvell-ccic.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   47 ++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index f73a801..2b2dc06 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -82,6 +82,8 @@ struct mcam_frame_state {
 	unsigned int delivered;
 };
 
+#define NR_MCAM_CLK 3
+
 /*
  * A description of one of our devices.
  * Locking: controlled by s_mutex.  Certain fields, however, require
@@ -109,6 +111,8 @@ struct mcam_camera {
 	int lane;			/* lane number */
 
 	struct clk *pll1;
+	/* clock tree support */
+	struct clk *clk[NR_MCAM_CLK];
 
 	/*
 	 * Callbacks from the core to the platform code.
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 7ab01e9..2fe0324 100755
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
@@ -104,6 +106,26 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
 
+static void mcam_clk_enable(struct mcam_camera *mcam)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_MCAM_CLK; i++) {
+		if (mcam->clk[i])
+			clk_enable(mcam->clk[i]);
+	}
+}
+
+static void mcam_clk_disable(struct mcam_camera *mcam)
+{
+	int i;
+
+	for (i = NR_MCAM_CLK - 1; i >= 0; i--) {
+		if (mcam->clk[i])
+			clk_disable(mcam->clk[i]);
+	}
+}
+
 /*
  * Power control.
  */
@@ -134,6 +156,8 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
 	mdelay(5);
 	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
 	mdelay(5);
+
+	mcam_clk_enable(mcam);
 }
 
 static void mmpcam_power_down(struct mcam_camera *mcam)
@@ -151,6 +175,8 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	pdata = cam->pdev->dev.platform_data;
 	gpio_set_value(pdata->sensor_power_gpio, 0);
 	gpio_set_value(pdata->sensor_reset_gpio, 0);
+
+	mcam_clk_disable(mcam);
 }
 
 /*
@@ -263,6 +289,23 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
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
@@ -331,6 +374,10 @@ static int mmpcam_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto out_unmap1;
 	}
+
+	ret = mcam_init_clk(mcam, pdata);
+	if (ret)
+		goto out_unmap2;
 	/*
 	 * Find the i2c adapter.  This assumes, of course, that the
 	 * i2c bus is already up and functioning.
-- 
1.7.9.5

