Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44842 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbeECVUY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:24 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 5/9] cx231xx: Switch to using new dvb i2c helpers
Date: Thu,  3 May 2018 16:20:11 -0500
Message-Id: <1525382415-4049-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly very straight forward replace of blocks with equivalent code.

Cleanup added at end of dvb_init in case of failure.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- Un-necessary NULL checks removed
- Pointers NULL'd after release
- 'tuner' removed from probe/init/attach comments

 drivers/media/usb/cx231xx/cx231xx-dvb.c | 330 ++++++++------------------------
 1 file changed, 78 insertions(+), 252 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 681610f..b03d180 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -613,23 +613,15 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 		dvb_frontend_detach(dvb->frontend[1]);
 	dvb_frontend_detach(dvb->frontend[0]);
 	dvb_unregister_adapter(&dvb->adapter);
+
 	/* remove I2C tuner */
-	client = dvb->i2c_client_tuner;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-	/* remove I2C demod */
-	client = dvb->i2c_client_demod[1];
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-	client = dvb->i2c_client_demod[0];
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
+	dvb_module_release(dvb->i2c_client_tuner);
+	dvb->i2c_client_tuner = NULL;
+	/* remove I2C demod(s) */
+	dvb_module_release(dvb->i2c_client_demod[1]);
+	dvb->i2c_client_demod[1] = NULL;
+	dvb_module_release(dvb->i2c_client_demod[0]);
+	dvb->i2c_client_demod[0] = NULL;
 }
 
 static int dvb_init(struct cx231xx *dev)
@@ -638,6 +630,8 @@ static int dvb_init(struct cx231xx *dev)
 	struct cx231xx_dvb *dvb;
 	struct i2c_adapter *tuner_i2c;
 	struct i2c_adapter *demod_i2c;
+	struct i2c_client *client;
+	struct i2c_adapter *adapter;
 
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
@@ -785,8 +779,6 @@ static int dvb_init(struct cx231xx *dev)
 
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 	{
-		struct i2c_client *client;
-		struct i2c_board_info info;
 		struct si2165_platform_data si2165_pdata = {};
 
 		/* attach demod */
@@ -794,25 +786,14 @@ static int dvb_init(struct cx231xx *dev)
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
 		si2165_pdata.ref_freq_hz = 16000000;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &si2165_pdata;
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-		if (!client || !client->dev.driver || !dev->dvb->frontend[0]) {
-			dev_err(dev->dev,
-				"Failed to attach SI2165 front end\n");
-			result = -EINVAL;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2165", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&si2165_pdata);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dvb->i2c_client_demod[0] = client;
 
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
@@ -829,8 +810,6 @@ static int dvb_init(struct cx231xx *dev)
 	}
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	{
-		struct i2c_client *client;
-		struct i2c_board_info info;
 		struct si2165_platform_data si2165_pdata = {};
 		struct si2157_config si2157_config = {};
 
@@ -839,29 +818,16 @@ static int dvb_init(struct cx231xx *dev)
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT;
 		si2165_pdata.ref_freq_hz = 24000000;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &si2165_pdata;
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-		if (!client || !client->dev.driver || !dev->dvb->frontend[0]) {
-			dev_err(dev->dev,
-				"Failed to attach SI2165 front end\n");
-			result = -EINVAL;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2165", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&si2165_pdata);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dvb->i2c_client_demod[0] = client;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -874,27 +840,15 @@ static int dvb_init(struct cx231xx *dev)
 #endif
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = dev->board.tuner_addr;
-		info.platform_data = &si2157_config;
-		request_module("si2157");
-
-		client = i2c_new_device(
-			tuner_i2c,
-			&info);
-		if (client == NULL || client->dev.driver == NULL) {
-			dvb_frontend_detach(dev->dvb->frontend[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
 
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
-			dvb_frontend_detach(dev->dvb->frontend[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2157", NULL, tuner_i2c,
+						dev->board.tuner_addr,
+						&si2157_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dev->cx231xx_reset_analog_tuner = NULL;
 
 		dev->dvb->i2c_client_tuner = client;
@@ -902,12 +856,8 @@ static int dvb_init(struct cx231xx *dev)
 	}
 	case CX231XX_BOARD_HAUPPAUGE_955Q:
 	{
-		struct i2c_client *client;
-		struct i2c_board_info info;
 		struct si2157_config si2157_config = {};
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-
 		dev->dvb->frontend[0] = dvb_attach(lgdt3306a_attach,
 			&hauppauge_955q_lgdt3306a_config,
 			demod_i2c
@@ -932,27 +882,15 @@ static int dvb_init(struct cx231xx *dev)
 #endif
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = dev->board.tuner_addr;
-		info.platform_data = &si2157_config;
-		request_module("si2157");
-
-		client = i2c_new_device(
-			tuner_i2c,
-			&info);
-		if (client == NULL || client->dev.driver == NULL) {
-			dvb_frontend_detach(dev->dvb->frontend[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
 
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
-			dvb_frontend_detach(dev->dvb->frontend[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2157", NULL, tuner_i2c,
+						dev->board.tuner_addr,
+						&si2157_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dev->cx231xx_reset_analog_tuner = NULL;
 
 		dev->dvb->i2c_client_tuner = client;
@@ -988,9 +926,6 @@ static int dvb_init(struct cx231xx *dev)
 	{
 		struct si2157_config si2157_config = {};
 		struct si2168_config si2168_config = {};
-		struct i2c_board_info info = {};
-		struct i2c_client *client;
-		struct i2c_adapter *adapter;
 
 		/* attach demodulator chip */
 		si2168_config.ts_mode = SI2168_TS_SERIAL; /* from *.inf file */
@@ -998,24 +933,14 @@ static int dvb_init(struct cx231xx *dev)
 		si2168_config.i2c_adapter = &adapter;
 		si2168_config.ts_clock_inv = true;
 
-		strlcpy(info.type, "si2168", sizeof(info.type));
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &si2168_config;
-
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2168", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&si2168_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
-		}
-
 		dvb->i2c_client_demod[0] = client;
 
 		/* attach tuner chip */
@@ -1026,37 +951,20 @@ static int dvb_init(struct cx231xx *dev)
 		si2157_config.if_port = 1;
 		si2157_config.inversion = false;
 
-		memset(&info, 0, sizeof(info));
-		strlcpy(info.type, "si2157", sizeof(info.type));
-		info.addr = dev->board.tuner_addr;
-		info.platform_data = &si2157_config;
-
-		request_module(info.type);
-		client = i2c_new_device(tuner_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2157", NULL, tuner_i2c,
+						dev->board.tuner_addr,
+						&si2157_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dev->cx231xx_reset_analog_tuner = NULL;
 		dev->dvb->i2c_client_tuner = client;
 		break;
 	}
 	case CX231XX_BOARD_ASTROMETA_T2HYBRID:
 	{
-		struct i2c_client *client;
-		struct i2c_board_info info = {};
 		struct mn88473_config mn88473_config = {};
 
 		/* attach demodulator chip */
@@ -1064,24 +972,14 @@ static int dvb_init(struct cx231xx *dev)
 		mn88473_config.xtal = 25000000;
 		mn88473_config.fe = &dev->dvb->frontend[0];
 
-		strlcpy(info.type, "mn88473", sizeof(info.type));
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &mn88473_config;
-
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
-			result = -ENODEV;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("mn88473", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&mn88473_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dvb->i2c_client_demod[0] = client;
 
 		/* define general-purpose callback pointer */
@@ -1095,9 +993,6 @@ static int dvb_init(struct cx231xx *dev)
 	}
 	case CX231XX_BOARD_HAUPPAUGE_935C:
 	{
-		struct i2c_client *client;
-		struct i2c_adapter *adapter;
-		struct i2c_board_info info = {};
 		struct si2157_config si2157_config = {};
 		struct si2168_config si2168_config = {};
 
@@ -1107,25 +1002,14 @@ static int dvb_init(struct cx231xx *dev)
 		si2168_config.i2c_adapter = &adapter;
 		si2168_config.ts_clock_inv = true;
 
-		strlcpy(info.type, "si2168", sizeof(info.type));
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &si2168_config;
-
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-		if (client == NULL || client->dev.driver == NULL) {
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2168", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&si2168_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			dev_err(dev->dev,
-				"Failed to attach %s frontend.\n", info.type);
-			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
-		}
-
 		dvb->i2c_client_demod[0] = client;
 		dev->dvb->frontend[0]->ops.i2c_gate_ctrl = NULL;
 
@@ -1140,40 +1024,21 @@ static int dvb_init(struct cx231xx *dev)
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = dev->board.tuner_addr;
-		info.platform_data = &si2157_config;
-		request_module("si2157");
-
-		client = i2c_new_device(tuner_i2c, &info);
-		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			dev_err(dev->dev,
-				"Failed to obtain %s tuner.\n",	info.type);
-			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2157", NULL, tuner_i2c,
+						dev->board.tuner_addr,
+						&si2157_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dev->cx231xx_reset_analog_tuner = NULL;
 		dev->dvb->i2c_client_tuner = client;
 		break;
 	}
 	case CX231XX_BOARD_HAUPPAUGE_975:
 	{
-		struct i2c_client *client;
-		struct i2c_adapter *adapter;
 		struct i2c_adapter *adapter2;
-		struct i2c_board_info info = {};
 		struct si2157_config si2157_config = {};
 		struct lgdt3306a_config lgdt3306a_config = {};
 		struct si2168_config si2168_config = {};
@@ -1184,25 +1049,14 @@ static int dvb_init(struct cx231xx *dev)
 		lgdt3306a_config.i2c_adapter = &adapter;
 		lgdt3306a_config.deny_i2c_rptr = 0;
 
-		strlcpy(info.type, "lgdt3306a", sizeof(info.type));
-		info.addr = dev->board.demod_addr;
-		info.platform_data = &lgdt3306a_config;
-
-		request_module(info.type);
-		client = i2c_new_device(demod_i2c, &info);
-		if (client == NULL || client->dev.driver == NULL) {
+		/* perform probe/init/attach */
+		client = dvb_module_probe("lgdt3306a", NULL, demod_i2c,
+						dev->board.demod_addr,
+						&lgdt3306a_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			dev_err(dev->dev,
-				"Failed to attach %s frontend.\n", info.type);
-			i2c_unregister_device(client);
-			result = -ENODEV;
-			goto out_free;
-		}
-
 		dvb->i2c_client_demod[0] = client;
 
 		/* attach second demodulator chip */
@@ -1211,30 +1065,14 @@ static int dvb_init(struct cx231xx *dev)
 		si2168_config.i2c_adapter = &adapter2;
 		si2168_config.ts_clock_inv = true;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2168", sizeof(info.type));
-		info.addr = dev->board.demod_addr2;
-		info.platform_data = &si2168_config;
-
-		request_module(info.type);
-		client = i2c_new_device(adapter, &info);
-		if (client == NULL || client->dev.driver == NULL) {
-			dev_err(dev->dev,
-				"Failed to attach %s frontend.\n", info.type);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2168", NULL, adapter,
+						dev->board.demod_addr2,
+						&si2168_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dvb->i2c_client_demod[1] = client;
 		dvb->frontend[1]->id = 1;
 
@@ -1250,34 +1088,14 @@ static int dvb_init(struct cx231xx *dev)
 		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-		info.addr = dev->board.tuner_addr;
-		info.platform_data = &si2157_config;
-		request_module("si2157");
-
-		client = i2c_new_device(adapter, &info);
-		if (client == NULL || client->dev.driver == NULL) {
-			module_put(dvb->i2c_client_demod[1]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[1]);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
-
-		if (!try_module_get(client->dev.driver->owner)) {
-			dev_err(dev->dev,
-				"Failed to obtain %s tuner.\n",	info.type);
-			i2c_unregister_device(client);
-			module_put(dvb->i2c_client_demod[1]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[1]);
-			module_put(dvb->i2c_client_demod[0]->dev.driver->owner);
-			i2c_unregister_device(dvb->i2c_client_demod[0]);
+		/* perform probe/init/attach */
+		client = dvb_module_probe("si2157", NULL, adapter,
+						dev->board.tuner_addr,
+						&si2157_config);
+		if (!client) {
 			result = -ENODEV;
 			goto out_free;
 		}
-
 		dev->cx231xx_reset_analog_tuner = NULL;
 		dvb->i2c_client_tuner = client;
 
@@ -1316,6 +1134,14 @@ static int dvb_init(struct cx231xx *dev)
 	return result;
 
 out_free:
+	/* remove I2C tuner */
+	dvb_module_release(dvb->i2c_client_tuner);
+	dvb->i2c_client_tuner = NULL;
+	/* remove I2C demod(s) */
+	dvb_module_release(dvb->i2c_client_demod[1]);
+	dvb->i2c_client_demod[1] = NULL;
+	dvb_module_release(dvb->i2c_client_demod[0]);
+	dvb->i2c_client_demod[0] = NULL;
 	kfree(dvb);
 	dev->dvb = NULL;
 	goto ret;
-- 
2.7.4
