Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47947 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2G3Ihl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 04:37:41 -0400
Received: by wibhq12 with SMTP id hq12so2248157wib.1
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2012 01:37:40 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hdegoede@redhat.com, s.nawrocki@samsung.com,
	hans.verkuil@cisco.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: i.MX27: Fix mx2_emmaprp mem2mem driver clocks.
Date: Mon, 30 Jul 2012 10:37:30 +0200
Message-Id: <1343637450-5562-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver wasn't converted to the new clock framework
(e038ed50a4a767add205094c035b6943e7b30140).

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 This is broken in current stable 3.5 too. So it should be applied
 to both stable and 3.6.

---
 drivers/media/video/mx2_emmaprp.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 0bd5815..2614a89 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -209,7 +209,7 @@ struct emmaprp_dev {
 
 	int			irq_emma;
 	void __iomem		*base_emma;
-	struct clk		*clk_emma;
+	struct clk		*clk_emma_ahb, *clk_emma_ipg;
 	struct resource		*res_emma;
 
 	struct v4l2_m2m_dev	*m2m_dev;
@@ -800,7 +800,8 @@ static int emmaprp_open(struct file *file)
 		return ret;
 	}
 
-	clk_enable(pcdev->clk_emma);
+	clk_prepare_enable(pcdev->clk_emma_ipg);
+	clk_prepare_enable(pcdev->clk_emma_ahb);
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[1];
 	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
 
@@ -816,7 +817,8 @@ static int emmaprp_release(struct file *file)
 
 	dprintk(pcdev, "Releasing instance %p\n", ctx);
 
-	clk_disable(pcdev->clk_emma);
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	kfree(ctx);
 
@@ -876,9 +878,15 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pcdev->irqlock);
 
-	pcdev->clk_emma = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pcdev->clk_emma)) {
-		ret = PTR_ERR(pcdev->clk_emma);
+	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		ret = PTR_ERR(pcdev->clk_emma_ipg);
+		goto free_dev;
+	}
+
+	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		ret = PTR_ERR(pcdev->clk_emma_ahb);
 		goto free_dev;
 	}
 
@@ -887,12 +895,12 @@ static int emmaprp_probe(struct platform_device *pdev)
 	if (irq_emma < 0 || res_emma == NULL) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
 		ret = -ENODEV;
-		goto free_clk;
+		goto free_dev;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
-		goto free_clk;
+		goto free_dev;
 
 	mutex_init(&pcdev->dev_mutex);
 
@@ -965,8 +973,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-free_clk:
-	clk_put(pcdev->clk_emma);
 free_dev:
 	kfree(pcdev);
 
@@ -983,7 +989,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	clk_put(pcdev->clk_emma);
 	kfree(pcdev);
 
 	return 0;
-- 
1.7.9.5

