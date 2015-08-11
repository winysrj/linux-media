Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbbHKNfj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:35:39 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	=?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
Subject: [PATCH] mantis: remove an uneeded goto
Date: Tue, 11 Aug 2015 10:33:54 -0300
Message-Id: <15f02b430a12af3098f078192cb8242f6b786d44.1439299913.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gotos makes a little harder to check the code. In this
particular case, the goto is doing nothing but jumping into
a return.

Instead, just replace the goto by the return, making it
simpler.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
index 87990ece5848..2ce310b0a022 100644
--- a/drivers/media/pci/mantis/mantis_dma.c
+++ b/drivers/media/pci/mantis/mantis_dma.c
@@ -140,12 +140,10 @@ int mantis_dma_init(struct mantis_pci *mantis)
 		/* Stop RISC Engine */
 		mmwrite(0, MANTIS_DMA_CTL);
 
-		goto err;
+		return err;
 	}
 
 	return 0;
-err:
-	return err;
 }
 EXPORT_SYMBOL_GPL(mantis_dma_init);
 
-- 
2.4.3

