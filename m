Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 42/46] [media] ite-cir: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:14 -0300
Message-Id: <e1a7c61c36608416a9f68d55ccaf2313cfa0d4a3.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 447fe35862dc..56abf9120cc2 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1666,7 +1666,6 @@ static int ite_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int ite_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct ite_dev *dev = pnp_get_drvdata(pdev);
 	unsigned long flags;
 
@@ -1681,7 +1680,7 @@ static int ite_resume(struct pnp_dev *pdev)
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void ite_shutdown(struct pnp_dev *pdev)
-- 
1.9.3

