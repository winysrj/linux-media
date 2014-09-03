Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	James Hogan <james.hogan@imgtec.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 43/46] [media] nuvoton-cir: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:15 -0300
Message-Id: <5af5d0e7a81b051d748df8fa90eb80ecb76b60af.1409775488.git.m.chehab@samsung.com>
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

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 7f4fd859bba5..9c2c8635ff33 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -229,7 +229,6 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 {
 	unsigned long flags;
 	u8 chip_major, chip_minor;
-	int ret = 0;
 	char chip_id[12];
 	bool chip_unknown = false;
 
@@ -285,7 +284,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	nvt->chip_minor = chip_minor;
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void nvt_cir_ldev_init(struct nvt_dev *nvt)
@@ -1177,7 +1176,6 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int nvt_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
 
 	nvt_dbg("%s called", __func__);
@@ -1195,7 +1193,7 @@ static int nvt_resume(struct pnp_dev *pdev)
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
-	return ret;
+	return 0;
 }
 
 static void nvt_shutdown(struct pnp_dev *pdev)
-- 
1.9.3

