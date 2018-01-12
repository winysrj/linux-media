Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45016 "EHLO
        homiemail-a68.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934110AbeALQUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:20:03 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/7] cx231xx: Add second i2c demod client
Date: Fri, 12 Jan 2018 10:19:37 -0600
Message-Id: <1515773982-6411-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include ability to add a i2c device style frontend to cx231xx USB
bridge. All current boards set to use frontend[0]. Changes are
backwards compatible with current behaviour.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 45 ++++++++++++++++++---------------
 drivers/media/usb/cx231xx/cx231xx.h     |  1 +
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4c6d2f4..7201e14 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -68,7 +68,7 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
-	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_demod[2];
 	struct i2c_client *i2c_client_tuner;
 };
 
@@ -616,7 +616,12 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 		i2c_unregister_device(client);
 	}
 	/* remove I2C demod */
-	client = dvb->i2c_client_demod;
+	client = dvb->i2c_client_demod[1];
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+	client = dvb->i2c_client_demod[0];
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
@@ -805,7 +810,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
@@ -852,7 +857,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 
@@ -1012,7 +1017,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		/* attach tuner chip */
 		si2157_config.fe = dev->dvb->frontend[0];
@@ -1031,16 +1036,16 @@ static int dvb_init(struct cx231xx *dev)
 		client = i2c_new_device(tuner_i2c, &info);
 
 		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
 
 		if (!try_module_get(client->dev.driver->owner)) {
 			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1078,7 +1083,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		/* define general-purpose callback pointer */
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
@@ -1122,7 +1127,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -1144,8 +1149,8 @@ static int dvb_init(struct cx231xx *dev)
 
 		client = i2c_new_device(adapter, &info);
 		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1154,8 +1159,8 @@ static int dvb_init(struct cx231xx *dev)
 			dev_err(dev->dev,
 				"Failed to obtain %s tuner.\n",	info.type);
 			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1196,7 +1201,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -1218,8 +1223,8 @@ static int dvb_init(struct cx231xx *dev)
 
 		client = i2c_new_device(tuner_i2c, &info);
 		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1228,8 +1233,8 @@ static int dvb_init(struct cx231xx *dev)
 			dev_err(dev->dev,
 				"Failed to obtain %s tuner.\n",	info.type);
 			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod);
+			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index fa993f7..6ffa4bd 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -345,6 +345,7 @@ struct cx231xx_board {
 
 	/* demod related */
 	int demod_addr;
+	int demod_addr2;
 	u8 demod_xfer_mode;	/* 0 - Serial; 1 - parallel */
 
 	/* GPIO Pins */
-- 
2.7.4
