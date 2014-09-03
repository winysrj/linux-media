Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 41/46] [media] fintek-cir: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:13 -0300
Message-Id: <0cd0a451ba8422015d1fbdf066bee9a0f4157d1b.1409775488.git.m.chehab@samsung.com>
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

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index f0a1f7d31ee6..b5167573240e 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -148,7 +148,6 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 	u8 vendor_major, vendor_minor;
 	u8 portsel, ir_class;
 	u16 vendor, chip;
-	int ret = 0;
 
 	fintek_config_mode_enable(fintek);
 
@@ -208,7 +207,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 
 	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void fintek_cir_ldev_init(struct fintek_dev *fintek)
@@ -644,7 +643,6 @@ static int fintek_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int fintek_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
 
 	fit_dbg("%s called", __func__);
@@ -661,7 +659,7 @@ static int fintek_resume(struct pnp_dev *pdev)
 
 	fintek_cir_regs_init(fintek);
 
-	return ret;
+	return 0;
 }
 
 static void fintek_shutdown(struct pnp_dev *pdev)
-- 
1.9.3

