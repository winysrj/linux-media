Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbbFRRdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 13:33:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
Subject: [PATCH] [media] mantis: cleanup a warning
Date: Thu, 18 Jun 2015 14:32:39 -0300
Message-Id: <6fe2d69c07864eecf33373b0e4be401737e37fa4.1434648756.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
drivers/media/pci/mantis/mantis_i2c.c: In function 'mantis_i2c_init':
drivers/media/pci/mantis/mantis_i2c.c:222:15: warning: variable 'intmask' set but not used [-Wunused-but-set-variable]
  u32 intstat, intmask;

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index a93823490a43..d72ee47dc6e4 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -219,7 +219,7 @@ static struct i2c_algorithm mantis_algo = {
 
 int mantis_i2c_init(struct mantis_pci *mantis)
 {
-	u32 intstat, intmask;
+	u32 intstat;
 	struct i2c_adapter *i2c_adapter = &mantis->adapter;
 	struct pci_dev *pdev		= mantis->pdev;
 
@@ -242,7 +242,7 @@ int mantis_i2c_init(struct mantis_pci *mantis)
 	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
 
 	intstat = mmread(MANTIS_INT_STAT);
-	intmask = mmread(MANTIS_INT_MASK);
+	mmread(MANTIS_INT_MASK);
 	mmwrite(intstat, MANTIS_INT_STAT);
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
 	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
-- 
2.4.3

