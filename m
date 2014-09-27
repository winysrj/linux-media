Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46946 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaI0Bpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 21:45:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] pt3: fix DTV FE I2C driver load error paths
Date: Sat, 27 Sep 2014 04:45:36 +0300
Message-Id: <1411782336-28235-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of 'module_is_live' usage.

on x86_64:
when CONFIG_MODULES is not enabled:

../drivers/media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
../drivers/media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Akihiro Tsukada <tskd08@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
Maybe that is proper fix. I didn't test it.
---
 drivers/media/pci/pt3/pt3.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 90f86ce..1fdeac1 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -393,7 +393,7 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 		return -ENODEV;
 	pt3->adaps[i]->i2c_demod = cl;
 	if (!try_module_get(cl->dev.driver->owner))
-		goto err_demod;
+		goto err_demod_i2c_unregister_device;
 
 	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT, sizeof(cl->name))) {
 		struct qm1d1c0042_config tcfg;
@@ -415,28 +415,27 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 		cl = i2c_new_device(cfg.tuner_i2c, &info);
 	}
 	if (!cl || !cl->dev.driver)
-		goto err_demod;
+		goto err_demod_module_put;
 	pt3->adaps[i]->i2c_tuner = cl;
 	if (!try_module_get(cl->dev.driver->owner))
-		goto err_tuner;
+		goto err_tuner_i2c_unregister_device;
 
 	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
 	ret = dvb_register_frontend(dvb_adap, cfg.fe);
 	if (ret < 0)
-		goto err_tuner;
+		goto err_tuner_module_put;
 	pt3->adaps[i]->fe = cfg.fe;
 	return 0;
 
-err_tuner:
+err_tuner_module_put:
+	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
+err_tuner_i2c_unregister_device:
 	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-	if (pt3->adaps[i]->i2c_tuner->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_tuner->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
-err_demod:
+err_demod_module_put:
+	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
+err_demod_i2c_unregister_device:
 	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
-	if (pt3->adaps[i]->i2c_demod->dev.driver->owner &&
-	    module_is_live(pt3->adaps[i]->i2c_demod->dev.driver->owner))
-		module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
+
 	return ret;
 }
 
-- 
http://palosaari.fi/

