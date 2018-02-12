Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54488 "EHLO
        homiemail-a117.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932204AbeBLVlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 16:41:55 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 2/7] cx231xx: Add second i2c demod client
Date: Mon, 12 Feb 2018 15:41:44 -0600
Message-Id: <1518471704-29459-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-3-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-3-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include ability to add a i2c device style frontend to cx231xx USB
bridge. All current boards set to use frontend[0]. Changes are
backwards compatible with current behaviour.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- replace hard coded value with a constant
- regen for dependency

  drivers/media/usb/cx231xx/cx231xx-dvb.c | 45 ++++++++++++++++++---------------
 drivers/media/usb/cx231xx/cx231xx.h     |  1 +
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index a68b5c0..a70db61 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -69,7 +69,7 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
-	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_demod[CX231XX_DVB_MAX_FRONTENDS];
 	struct i2c_client *i2c_client_tuner;
 };
 
@@ -617,7 +617,12 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
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
@@ -806,7 +811,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
@@ -853,7 +858,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 
@@ -1013,7 +1018,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		/* attach tuner chip */
 		si2157_config.fe = dev->dvb->frontend[0];
@@ -1032,16 +1037,16 @@ static int dvb_init(struct cx231xx *dev)
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
@@ -1079,7 +1084,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 
 		/* define general-purpose callback pointer */
 		dvb->frontend[0]->callback = cx231xx_tuner_callback;
@@ -1123,7 +1128,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -1147,16 +1152,16 @@ static int dvb_init(struct cx231xx *dev)
 		if (client == NULL || client->dev.driver == NULL) {
 			dev_err(dev->dev,
 				"Failed to obtain %s tuner.\n",	info.type);
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
@@ -1197,7 +1202,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dvb->i2c_client_demod = client;
+		dvb->i2c_client_demod[0] = client;
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -1221,16 +1226,16 @@ static int dvb_init(struct cx231xx *dev)
 		if (client == NULL || client->dev.driver == NULL) {
 			dev_err(dev->dev,
 				"Failed to obtain %s tuner.\n",	info.type);
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
