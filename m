Return-path: <linux-media-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:28611
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab2JIODC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 10:03:02 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <g.liakhovetski@gmx.de>
CC: <mchehab@infradead.org>, <kernel@pengutronix.de>,
	<gcembed@gmail.com>, <javier.martin@vista-silicon.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: =?UTF-8?q?=5BPATCH=20v3=202/2=5D=20=5Bmedia=5D=3A=20mx2=5Fcamera=3A=20Fix=20regression=20caused=20by=20clock=20conversion?=
Date: Tue, 9 Oct 2012 11:02:32 -0300
Message-ID: <1349791352-9829-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since mx27 transitioned to the commmon clock framework in 3.5, the correct way
to acquire the csi clock is to get csi_ahb and csi_per clocks separately.

By not doing so the camera sensor does not probe correctly:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
mx2-camera mx2-camera.0: Camera driver attached to camera 0
ov2640 0-0030: Product ID error fb:fb
mx2-camera mx2-camera.0: Camera driver detached from camera 0
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock frequency: 66500000

Adapt the mx2_camera driver to the new clock framework and make it functional
again.

Tested-by: Gaëtan Carlier <gcembed@gmail.com>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Fix clock error handling code as pointed out by Russell King
Changes since v1:
- Rebased against linux-next 20121008.
 drivers/media/platform/soc_camera/mx2_camera.c |   50 ++++++++++++++++++------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 403d7f1..382b305 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -272,7 +272,8 @@ struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
 	struct soc_camera_device *icd;
-	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
+	struct clk		*clk_emma_ahb, *clk_emma_ipg;
+	struct clk		*clk_csi_ahb, *clk_csi_per;
 
 	void __iomem		*base_csi, *base_emma;
 
@@ -432,7 +433,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
 
-	clk_disable_unprepare(pcdev->clk_csi);
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
+	clk_disable_unprepare(pcdev->clk_csi_per);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -460,10 +462,14 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	ret = clk_prepare_enable(pcdev->clk_csi);
+	ret = clk_prepare_enable(pcdev->clk_csi_ahb);
 	if (ret < 0)
 		return ret;
 
+	ret = clk_prepare_enable(pcdev->clk_csi_per);
+	if (ret < 0)
+		goto exit_csi_ahb;
+
 	csicr1 = CSICR1_MCLKEN;
 
 	if (cpu_is_mx27())
@@ -480,6 +486,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 		 icd->devnum);
 
 	return 0;
+
+exit_csi_ahb:
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
+
+	return ret;
 }
 
 static void mx2_camera_remove_device(struct soc_camera_device *icd)
@@ -1725,27 +1736,35 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(pcdev->clk_csi)) {
-		dev_err(&pdev->dev, "Could not get csi clock\n");
-		err = PTR_ERR(pcdev->clk_csi);
+	pcdev->clk_csi_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(pcdev->clk_csi_ahb)) {
+		dev_err(&pdev->dev, "Could not get csi ahb clock\n");
+		err = PTR_ERR(pcdev->clk_csi_ahb);
 		goto exit;
 	}
 
+	pcdev->clk_csi_per = devm_clk_get(&pdev->dev, "per");
+	if (IS_ERR(pcdev->clk_csi_per)) {
+		dev_err(&pdev->dev, "Could not get csi per clock\n");
+		err = PTR_ERR(pcdev->clk_csi_per);
+		goto exit_csi_ahb;
+	}
+
 	pcdev->pdata = pdev->dev.platform_data;
 	if (pcdev->pdata) {
 		long rate;
 
 		pcdev->platform_flags = pcdev->pdata->flags;
 
-		rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
+		rate = clk_round_rate(pcdev->clk_csi_per,
+						pcdev->pdata->clk * 2);
 		if (rate <= 0) {
 			err = -ENODEV;
-			goto exit;
+			goto exit_csi_per;
 		}
-		err = clk_set_rate(pcdev->clk_csi, rate);
+		err = clk_set_rate(pcdev->clk_csi_per, rate);
 		if (err < 0)
-			goto exit;
+			goto exit_csi_per;
 	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
@@ -1801,7 +1820,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit_free_emma;
 
 	dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
-			clk_get_rate(pcdev->clk_csi));
+			clk_get_rate(pcdev->clk_csi_per));
 
 	return 0;
 
@@ -1812,6 +1831,10 @@ eallocctx:
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}
+exit_csi_per:
+	clk_disable_unprepare(pcdev->clk_csi_per);
+exit_csi_ahb:
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
 exit:
 	return err;
 }
@@ -1831,6 +1854,9 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
 	}
 
+	clk_disable_unprepare(pcdev->clk_csi_per);
+	clk_disable_unprepare(pcdev->clk_csi_ahb);
+
 	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
 
 	return 0;
-- 
1.7.9.5


