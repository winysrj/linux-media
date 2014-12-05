Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61762 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaLEK4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 05:56:25 -0500
Received: by mail-pa0-f43.google.com with SMTP id kx10so501936pab.2
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 02:56:25 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 5/5] dvb: pci/pt3: use dvb-core i2c binding model template
Date: Fri,  5 Dec 2014 19:55:40 +0900
Message-Id: <1417776940-16381-6-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
References: <1417776940-16381-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt3/pt3.c | 89 ++++++++++++++-------------------------------
 drivers/media/pci/pt3/pt3.h | 12 +++---
 2 files changed, 33 insertions(+), 68 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 7a37e8f..3fe491b 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -26,6 +26,7 @@
 #include "dvbdev.h"
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
+#include "dvb_i2c.h"
 
 #include "pt3.h"
 
@@ -103,12 +104,12 @@ pt3_demod_write(struct pt3_adapter *adap, const struct reg_val *data, int num)
 	int i, ret;
 
 	ret = 0;
-	msg.addr = adap->i2c_demod->addr;
+	msg.addr = adap->fe->fe_cl->addr;
 	msg.flags = 0;
 	msg.len = 2;
 	for (i = 0; i < num; i++) {
 		msg.buf = (u8 *)&data[i];
-		ret = i2c_transfer(adap->i2c_demod->adapter, &msg, 1);
+		ret = i2c_transfer(adap->fe->fe_cl->adapter, &msg, 1);
 		if (ret == 0)
 			ret = -EREMOTE;
 		if (ret < 0)
@@ -375,67 +376,38 @@ static int pt3_fe_init(struct pt3_board *pt3)
 
 static int pt3_attach_fe(struct pt3_board *pt3, int i)
 {
-	struct i2c_board_info info;
-	struct tc90522_config cfg;
-	struct i2c_client *cl;
+	struct dvb_frontend *fe;
+	struct tc90522_out *out;
+	struct i2c_client *tuner_cl;
 	struct dvb_adapter *dvb_adap;
 	int ret;
 
-	info = adap_conf[i].demod_info;
-	cfg = adap_conf[i].demod_cfg;
-	cfg.tuner_i2c = NULL;
-	info.platform_data = &cfg;
+	out = NULL;
+	fe = dvb_i2c_attach_fe(&pt3->i2c_adap, &adap_conf[i].demod_info,
+			       &adap_conf[i].demod_cfg, (void **)&out);
+	if (!fe)
+		return -ENODEV;
 
 	ret = -ENODEV;
-	request_module("tc90522");
-	cl = i2c_new_device(&pt3->i2c_adap, &info);
-	if (!cl || !cl->dev.driver)
-		return -ENODEV;
-	pt3->adaps[i]->i2c_demod = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_demod_i2c_unregister_device;
-
-	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT, sizeof(cl->name))) {
-		struct qm1d1c0042_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("qm1d1c0042");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	} else {
-		struct mxl301rf_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.mxl301rf;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("mxl301rf");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	}
-	if (!cl || !cl->dev.driver)
-		goto err_demod_module_put;
-	pt3->adaps[i]->i2c_tuner = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_tuner_i2c_unregister_device;
+	if (!out)
+		goto err;
+	tuner_cl = dvb_i2c_attach_tuner(&(out->demod_bus),
+					&adap_conf[i].tuner_info, fe,
+					&adap_conf[i].tuner_cfg, NULL);
+	if (!tuner_cl)
+		goto err;
 
 	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
-	ret = dvb_register_frontend(dvb_adap, cfg.fe);
+	ret = dvb_register_frontend(dvb_adap, fe);
 	if (ret < 0)
-		goto err_tuner_module_put;
-	pt3->adaps[i]->fe = cfg.fe;
+		goto err;
+	pt3->adaps[i]->fe = fe;
 	return 0;
 
-err_tuner_module_put:
-	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
-err_tuner_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-err_demod_module_put:
-	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
-err_demod_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
-
+err:
+	/* tuner i2c_client is unregister'ed as well, */
+	/* because it is a (grand) child of the demod i2c_client device */
+	i2c_unregister_device(fe->fe_cl);
 	return ret;
 }
 
@@ -630,17 +602,10 @@ static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
 	dmx = &adap->demux.dmx;
 	dmx->close(dmx);
 	if (adap->fe) {
-		adap->fe->callback = NULL;
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
+		if (adap->fe->fe_cl)
+			i2c_unregister_device(adap->fe->fe_cl);
 	}
 	pt3_free_dmabuf(adap);
 	dvb_dmxdev_release(&adap->dmxdev);
diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
index 1b3f2ad..88c3d17 100644
--- a/drivers/media/pci/pt3/pt3.h
+++ b/drivers/media/pci/pt3/pt3.h
@@ -104,15 +104,17 @@ struct dma_data_buffer {
 /*
  * device things
  */
+union pt3_tuner_config {
+	struct qm1d1c0042_config qm1d1c0042;
+	struct mxl301rf_config   mxl301rf;
+};
+
 struct pt3_adap_config {
 	struct i2c_board_info demod_info;
 	struct tc90522_config demod_cfg;
 
 	struct i2c_board_info tuner_info;
-	union tuner_config {
-		struct qm1d1c0042_config qm1d1c0042;
-		struct mxl301rf_config   mxl301rf;
-	} tuner_cfg;
+	union pt3_tuner_config tuner_cfg;
 	u32 init_freq;
 };
 
@@ -123,8 +125,6 @@ struct pt3_adapter {
 	struct dvb_demux    demux;
 	struct dmxdev       dmxdev;
 	struct dvb_frontend *fe;
-	struct i2c_client   *i2c_demod;
-	struct i2c_client   *i2c_tuner;
 
 	/* data fetch thread */
 	struct task_struct *thread;
-- 
2.1.3

