Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:59615 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdIQUVp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:21:45 -0400
Subject: [PATCH 5/8] [media] cx231xx: Use common error handling code in
 dvb_init()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <3f4e988c-4552-11f4-29e8-7b5c537a910b@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:21:17 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 20:10:34 +0200

Add jump targets so that a bit of exception handling can be better reused
at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 135 +++++++++++++-------------------
 1 file changed, 53 insertions(+), 82 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 091ec0cf56a6..af51113b4a55 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -635,19 +635,15 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       tuner_i2c,
-			       &cnxt_rde250_tunerconfig)) {
-			result = -EINVAL;
-			goto out_free;
-		}
+				tuner_i2c, &cnxt_rde250_tunerconfig))
+			goto e_inval;
 
 		break;
 	case CX231XX_BOARD_CNXT_SHELBY:
@@ -659,19 +655,16 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       tuner_i2c,
-			       &cnxt_rdu250_tunerconfig)) {
-			result = -EINVAL;
-			goto out_free;
-		}
+				tuner_i2c, &cnxt_rdu250_tunerconfig))
+			goto e_inval;
+
 		break;
 	case CX231XX_BOARD_CNXT_RDE_253S:
 
@@ -681,19 +674,16 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, tuner_i2c,
-			       &cnxt_rde253s_tunerconfig)) {
-			result = -EINVAL;
-			goto out_free;
-		}
+				0x60, tuner_i2c, &cnxt_rde253s_tunerconfig))
+			goto e_inval;
+
 		break;
 	case CX231XX_BOARD_CNXT_RDU_253S:
 	case CX231XX_BOARD_KWORLD_UB445_USB_HYBRID:
@@ -704,19 +694,16 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, tuner_i2c,
-			       &cnxt_rde253s_tunerconfig)) {
-			result = -EINVAL;
-			goto out_free;
-		}
+				0x60, tuner_i2c, &cnxt_rde253s_tunerconfig))
+			goto e_inval;
+
 		break;
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
@@ -730,8 +717,7 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach LG3305 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
@@ -763,14 +749,12 @@ static int dvb_init(struct cx231xx *dev)
 		if (!client || !client->dev.driver || !dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
+			goto e_nodev;
 		}
 
 		dvb->i2c_client_demod = client;
@@ -810,14 +794,12 @@ static int dvb_init(struct cx231xx *dev)
 		if (!client || !client->dev.driver || !dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
+			goto e_nodev;
 		}
 
 		dvb->i2c_client_demod = client;
@@ -845,17 +827,12 @@ static int dvb_init(struct cx231xx *dev)
 		client = i2c_new_device(
 			tuner_i2c,
 			&info);
-		if (!client || !client->dev.driver) {
-			dvb_frontend_detach(dev->dvb->frontend);
-			result = -ENODEV;
-			goto out_free;
-		}
+		if (!client || !client->dev.driver)
+			goto detach_frontend;
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			dvb_frontend_detach(dev->dvb->frontend);
-			result = -ENODEV;
-			goto out_free;
+			goto detach_frontend;
 		}
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -878,8 +855,7 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach LGDT3306A frontend.\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
@@ -903,17 +879,12 @@ static int dvb_init(struct cx231xx *dev)
 		client = i2c_new_device(
 			tuner_i2c,
 			&info);
-		if (!client || !client->dev.driver) {
-			dvb_frontend_detach(dev->dvb->frontend);
-			result = -ENODEV;
-			goto out_free;
-		}
+		if (!client || !client->dev.driver)
+			goto detach_frontend;
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			dvb_frontend_detach(dev->dvb->frontend);
-			result = -ENODEV;
-			goto out_free;
+			goto detach_frontend;
 		}
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -934,8 +905,7 @@ static int dvb_init(struct cx231xx *dev)
 		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
-			result = -EINVAL;
-			goto out_free;
+			goto e_inval;
 		}
 
 		/* define general-purpose callback pointer */
@@ -966,15 +936,12 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-		if (!client || !client->dev.driver) {
-			result = -ENODEV;
-			goto out_free;
-		}
+		if (!client || !client->dev.driver)
+			goto e_nodev;
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
+			goto e_nodev;
 		}
 
 		dvb->i2c_client_demod = client;
@@ -994,19 +961,12 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(tuner_i2c, &info);
-		if (!client || !client->dev.driver) {
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
-			result = -ENODEV;
-			goto out_free;
-		}
+		if (!client || !client->dev.driver)
+			goto put_module;
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
-			result = -ENODEV;
-			goto out_free;
+			goto put_module;
 		}
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -1030,15 +990,12 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-		if (!client || !client->dev.driver) {
-			result = -ENODEV;
-			goto out_free;
-		}
+		if (!client || !client->dev.driver)
+			goto e_nodev;
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
+			goto e_nodev;
 		}
 
 		dvb->i2c_client_demod = client;
@@ -1061,8 +1018,7 @@ static int dvb_init(struct cx231xx *dev)
 	if (!dvb->frontend) {
 		dev_err(dev->dev,
 		       "%s/2: frontend initialization failed\n", dev->name);
-		result = -EINVAL;
-		goto out_free;
+		goto e_inval;
 	}
 
 	/* register everything */
@@ -1079,6 +1035,21 @@ static int dvb_init(struct cx231xx *dev)
 	mutex_unlock(&dev->lock);
 	return result;
 
+put_module:
+	module_put(dvb->i2c_client_demod->dev.driver->owner);
+	i2c_unregister_device(dvb->i2c_client_demod);
+	goto e_nodev;
+
+detach_frontend:
+	dvb_frontend_detach(dev->dvb->frontend);
+
+e_nodev:
+	result = -ENODEV;
+	goto out_free;
+
+e_inval:
+	result = -EINVAL;
+
 out_free:
 	kfree(dvb);
 	dev->dvb = NULL;
-- 
2.14.1
