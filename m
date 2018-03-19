Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33283 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965328AbeCSQBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 12:01:20 -0400
Received: by mail-pf0-f193.google.com with SMTP id 123so1427721pfe.0
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 09:01:20 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v5] media/dvb: earth-pt3: use the new i2c binding helper
Date: Tue, 20 Mar 2018 01:00:23 +0900
Message-Id: <20180319160023.6800-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch slightly simplifies the binding code by introducing commit
8f569c0b4e6b ("media: dvb-core: add helper functions for I2C binding").

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v4
 - pci/pt3/pt3.c: removed redundant request_module() at line 390

Changes since v3
 - earth-pt3: replaced the old helper functions (proposed by patch #27922)
              with the new one (commit:8f569c0b).
 - withdrew the following v3 patches:
       #27923 (tuners/qm1d1c0042),
       #27924 (tuners/mxl301rf),
       #27925 (dvb-frontends/tc90522).
   The new helper functions do not require changes to / apply to
   those demod/tuner i2c drivers.

 drivers/media/pci/pt3/pt3.c | 59 +++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index da74828805b..b2d9fb976c9 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -376,25 +376,22 @@ static int pt3_fe_init(struct pt3_board *pt3)
 
 static int pt3_attach_fe(struct pt3_board *pt3, int i)
 {
-	struct i2c_board_info info;
+	const struct i2c_board_info *info;
 	struct tc90522_config cfg;
 	struct i2c_client *cl;
 	struct dvb_adapter *dvb_adap;
 	int ret;
 
-	info = adap_conf[i].demod_info;
+	info = &adap_conf[i].demod_info;
 	cfg = adap_conf[i].demod_cfg;
 	cfg.tuner_i2c = NULL;
-	info.platform_data = &cfg;
 
 	ret = -ENODEV;
-	request_module("tc90522");
-	cl = i2c_new_device(&pt3->i2c_adap, &info);
-	if (!cl || !cl->dev.driver)
+	cl = dvb_module_probe("tc90522", info->type, &pt3->i2c_adap,
+			      info->addr, &cfg);
+	if (!cl)
 		return -ENODEV;
 	pt3->adaps[i]->i2c_demod = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_demod_i2c_unregister_device;
 
 	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT,
 		     strlen(TC90522_I2C_DEV_SAT))) {
@@ -402,41 +399,33 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 
 		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
 		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("qm1d1c0042");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
+		info = &adap_conf[i].tuner_info;
+		cl = dvb_module_probe("qm1d1c0042", info->type, cfg.tuner_i2c,
+				      info->addr, &tcfg);
 	} else {
 		struct mxl301rf_config tcfg;
 
 		tcfg = adap_conf[i].tuner_cfg.mxl301rf;
 		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("mxl301rf");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
+		info = &adap_conf[i].tuner_info;
+		cl = dvb_module_probe("mxl301rf", info->type, cfg.tuner_i2c,
+				      info->addr, &tcfg);
 	}
-	if (!cl || !cl->dev.driver)
-		goto err_demod_module_put;
+	if (!cl)
+		goto err_demod_module_release;
 	pt3->adaps[i]->i2c_tuner = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_tuner_i2c_unregister_device;
 
 	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
 	ret = dvb_register_frontend(dvb_adap, cfg.fe);
 	if (ret < 0)
-		goto err_tuner_module_put;
+		goto err_tuner_module_release;
 	pt3->adaps[i]->fe = cfg.fe;
 	return 0;
 
-err_tuner_module_put:
-	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
-err_tuner_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-err_demod_module_put:
-	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
-err_demod_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
+err_tuner_module_release:
+	dvb_module_release(pt3->adaps[i]->i2c_tuner);
+err_demod_module_release:
+	dvb_module_release(pt3->adaps[i]->i2c_demod);
 
 	return ret;
 }
@@ -630,14 +619,10 @@ static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
 		adap->fe->callback = NULL;
 		if (adap->fe->frontend_priv)
 			dvb_unregister_frontend(adap->fe);
-		if (adap->i2c_tuner) {
-			module_put(adap->i2c_tuner->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_tuner);
-		}
-		if (adap->i2c_demod) {
-			module_put(adap->i2c_demod->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_demod);
-		}
+		if (adap->i2c_tuner)
+			dvb_module_release(adap->i2c_tuner);
+		if (adap->i2c_demod)
+			dvb_module_release(adap->i2c_demod);
 	}
 	pt3_free_dmabuf(adap);
 	dvb_dmxdev_release(&adap->dmxdev);
-- 
2.16.2
