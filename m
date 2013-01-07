Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:53122 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab3AGJAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 04:00:33 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/media/platform/soc_camera/pxa_camera.c: reposition free_irq to avoid access to invalid data
Date: Mon,  7 Jan 2013 11:00:15 +0100
Message-Id: <1357552816-6046-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

The data referenced by an interrupt handler should not be freed before the
interrupt is ended.  The handler is pxa_camera_irq.  This handler may call
pxa_dma_start_channels, which references the channels that are freed on the
lines before the call to free_irq.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@fn exists@
expression list es;
expression a,b;
identifier f;
@@

if (...) {
  ... when any
  free_irq(a,b);
  ... when any
  f(es);
  ... when any
  return ...;
}

@@
expression list fn.es;
expression fn.a,fn.b;
identifier fn.f;
@@

*f(es);
... when any
*free_irq(a,b);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.  I have not observed the problem in practice; the code just
looks suspicious.

 drivers/media/platform/soc_camera/pxa_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index f91f7bf..2a19aba 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1810,10 +1810,10 @@ static int pxa_camera_remove(struct platform_device *pdev)
 
 	clk_put(pcdev->clk);
 
+	free_irq(pcdev->irq, pcdev);
 	pxa_free_dma(pcdev->dma_chans[0]);
 	pxa_free_dma(pcdev->dma_chans[1]);
 	pxa_free_dma(pcdev->dma_chans[2]);
-	free_irq(pcdev->irq, pcdev);
 
 	soc_camera_host_unregister(soc_host);
 

