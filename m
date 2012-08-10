Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:39616
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871Ab2HJN7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 09:59:15 -0400
Date: Fri, 10 Aug 2012 15:59:11 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
In-Reply-To: <501FD69D.7070702@metafoo.de>
Message-ID: <alpine.DEB.2.02.1208101558100.2011@hadrien>
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr> <20120806142323.GO4352@mwanda> <20120806142650.GT4403@mwanda> <501FD69D.7070702@metafoo.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using devm_kzalloc and devm_clk_get simplifies the code and ensures that
the use of devm_request_irq is safe.  When kzalloc and kfree were used, the
interrupt could be triggered after the handler's data argument had been
freed.

Add missing return code initializations in the error handling code for
devm_request_and_ioremap and devm_request_irq.

The problem of a free after a devm_request_irq was found using the
following semantic match (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2,x,a,b,c,d;
identifier free;
position p1,p2;
@@

  devm_request_irq@p1(e1,e2,...,x)
  ... when any
      when != e2 = a
      when != x = b
  if (...) {
    ... when != e2 = c
        when != x = d
    free@p2(...,x,...);
    ...
    return ...;
  }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2: patch updated to add nearby ret initializations.  Please let me know
if some other constants should be returned on the failure of
devm_request_and_ioremap and devm_request_irq.

 drivers/media/video/mx2_emmaprp.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
index 5f8a6f5..9fe9ec6 100644
--- a/drivers/media/video/mx2_emmaprp.c
+++ b/drivers/media/video/mx2_emmaprp.c
@@ -874,29 +874,27 @@ static int emmaprp_probe(struct platform_device *pdev)
 	int irq_emma;
 	int ret;

-	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev)
 		return -ENOMEM;

 	spin_lock_init(&pcdev->irqlock);

-	pcdev->clk_emma = clk_get(&pdev->dev, NULL);
+	pcdev->clk_emma = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk_emma)) {
-		ret = PTR_ERR(pcdev->clk_emma);
-		goto free_dev;
+		return PTR_ERR(pcdev->clk_emma);
 	}

 	irq_emma = platform_get_irq(pdev, 0);
 	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (irq_emma < 0 || res_emma == NULL) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
-		ret = -ENODEV;
-		goto free_clk;
+		return -ENODEV;
 	}

 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
-		goto free_clk;
+		return ret;

 	mutex_init(&pcdev->dev_mutex);

@@ -922,21 +920,20 @@ static int emmaprp_probe(struct platform_device *pdev)

 	platform_set_drvdata(pdev, pcdev);

-	if (devm_request_mem_region(&pdev->dev, res_emma->start,
-	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
-		goto rel_vdev;
-
-	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
-					resource_size(res_emma));
-	if (!pcdev->base_emma)
+	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
+	if (!pcdev->base_emma) {
+		ret = -ENXIO;
 		goto rel_vdev;
+	}

 	pcdev->irq_emma = irq_emma;
 	pcdev->res_emma = res_emma;

 	if (devm_request_irq(&pdev->dev, pcdev->irq_emma, emmaprp_irq,
-			     0, MEM2MEM_NAME, pcdev) < 0)
+			     0, MEM2MEM_NAME, pcdev) < 0) {
+		ret = -ENODEV;
 		goto rel_vdev;
+	}

 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(pcdev->alloc_ctx)) {
@@ -969,10 +966,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-free_clk:
-	clk_put(pcdev->clk_emma);
-free_dev:
-	kfree(pcdev);

 	return ret;
 }
@@ -987,8 +980,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	clk_put(pcdev->clk_emma);
-	kfree(pcdev);

 	return 0;
 }

