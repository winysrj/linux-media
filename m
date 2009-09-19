Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZISEGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 00:06:38 -0400
Date: Sat, 19 Sep 2009 01:06:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Diffs between our tree and upstream
Message-ID: <20090919010602.7e8f2df2@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I'm about to send our pull request.

While doing my last checks, I noticed a difference between our tree and
upstream. I'm not sure what happens. Could you please check?

The enclosed patch is the diff from upstream to -hg.



Cheers,
Mauro

diff -upr oldtree/drivers/media/video/sh_mobile_ceu_camera.c /home/v4l/tokernel/wrk/linux-next/drivers/media/video/sh_mobile_ceu_camera.c
--- oldtree/drivers/media/video/sh_mobile_ceu_camera.c	2009-09-19 01:00:51.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/drivers/media/video/sh_mobile_ceu_camera.c	2009-09-19 00:56:27.000000000 -0300
@@ -30,7 +30,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
-#include <linux/clk.h>
+#include <linux/pm_runtime.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -93,7 +93,6 @@ struct sh_mobile_ceu_dev {
 
 	unsigned int irq;
 	void __iomem *base;
-	struct clk *clk;
 	unsigned long video_limit;
 
 	/* lock used to protect videobuf */
@@ -1649,7 +1648,6 @@ static int __devinit sh_mobile_ceu_probe
 	struct sh_mobile_ceu_dev *pcdev;
 	struct resource *res;
 	void __iomem *base;
-	char clk_name[8];
 	unsigned int irq;
 	int err = 0;
 
@@ -1713,13 +1711,9 @@ static int __devinit sh_mobile_ceu_probe
 		goto exit_release_mem;
 	}
 
-	snprintf(clk_name, sizeof(clk_name), "ceu%d", pdev->id);
-	pcdev->clk = clk_get(&pdev->dev, clk_name);
-	if (IS_ERR(pcdev->clk)) {
-		dev_err(&pdev->dev, "cannot get clock \"%s\"\n", clk_name);
-		err = PTR_ERR(pcdev->clk);
-		goto exit_free_irq;
-	}
+	pm_suspend_ignore_children(&pdev->dev, true);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_resume(&pdev->dev);
 
 	pcdev->ici.priv = pcdev;
 	pcdev->ici.v4l2_dev.dev = &pdev->dev;
@@ -1729,12 +1723,10 @@ static int __devinit sh_mobile_ceu_probe
 
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
-		goto exit_free_clk;
+		goto exit_free_irq;
 
 	return 0;
 
-exit_free_clk:
-	clk_put(pcdev->clk);
 exit_free_irq:
 	free_irq(pcdev->irq, pcdev);
 exit_release_mem:
@@ -1755,7 +1747,6 @@ static int __devexit sh_mobile_ceu_remov
 					struct sh_mobile_ceu_dev, ici);
 
 	soc_camera_host_unregister(soc_host);
-	clk_put(pcdev->clk);
 	free_irq(pcdev->irq, pcdev);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		dma_release_declared_memory(&pdev->dev);
@@ -1764,9 +1755,27 @@ static int __devexit sh_mobile_ceu_remov
 	return 0;
 }
 
+static int sh_mobile_ceu_runtime_nop(struct device *dev)
+{
+	/* Runtime PM callback shared between ->runtime_suspend()
+	 * and ->runtime_resume(). Simply returns success.
+	 *
+	 * This driver re-initializes all registers after
+	 * pm_runtime_get_sync() anyway so there is no need
+	 * to save and restore registers here.
+	 */
+	return 0;
+}
+
+static struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
+	.runtime_suspend = sh_mobile_ceu_runtime_nop,
+	.runtime_resume = sh_mobile_ceu_runtime_nop,
+};
+
 static struct platform_driver sh_mobile_ceu_driver = {
 	.driver 	= {
 		.name	= "sh_mobile_ceu",
+		.pm	= &sh_mobile_ceu_dev_pm_ops,
 	},
 	.probe		= sh_mobile_ceu_probe,
 	.remove		= __exit_p(sh_mobile_ceu_remove),

