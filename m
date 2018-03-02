Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65105 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752528AbeCBTfK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:10 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 8/8] media: em28xx-dvb: simplify DVB module probing logic
Date: Fri,  2 Mar 2018 16:34:49 -0300
Message-Id: <278abab98eb137bd4bbd04ef059ac08320ea6f7a.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The module probing logic there is a way more complex than
it should be, and requires some special magic to avoid
stack overflows when KASAN is enabled.

Solve it by creating ancillary functions to setup the
platform data and request module.

Now, the probing functions are cleaner and easier to understand.

As a side effect, the size of the module was reduced by
about 9.7% on x86_64:

Before this patch:
   text	   data	    bss	    dec	    hex	filename
  51090	  14192	     96	  65378	   ff62	drivers/media/usb/em28xx/em28xx-dvb.o

After this patch:
   text	   data	    bss	    dec	    hex	filename
  44743	  14192	     96	  59031	   e697	drivers/media/usb/em28xx/em28xx-dvb.o

Tested with a PCTV 461e device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 528 +++++++++-------------------------
 1 file changed, 138 insertions(+), 390 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 28c4c7d8dbd8..435c2dc31e90 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1126,76 +1126,48 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 	dvb_unregister_adapter(&dvb->adapter);
 }
 
-static noinline_for_stack int em28174_dvb_init_pctv_460e(struct em28xx *dev)
+static int em28174_dvb_init_pctv_460e(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
-	struct i2c_client *client;
-	struct i2c_board_info board_info;
 	struct tda10071_platform_data tda10071_pdata = {};
 	struct a8293_platform_data a8293_pdata = {};
-	int result;
 
 	/* attach demod + tuner combo */
-	tda10071_pdata.clk = 40444000, /* 40.444 MHz */
-	tda10071_pdata.i2c_wr_max = 64,
-	tda10071_pdata.ts_mode = TDA10071_TS_SERIAL,
-	tda10071_pdata.pll_multiplier = 20,
-	tda10071_pdata.tuner_i2c_addr = 0x14,
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "tda10071_cx24118", I2C_NAME_SIZE);
-	board_info.addr = 0x55;
-	board_info.platform_data = &tda10071_pdata;
-	request_module("tda10071");
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->fe[0] = tda10071_pdata.get_dvb_frontend(client);
-	dvb->i2c_client_demod = client;
+	tda10071_pdata.clk = 40444000; /* 40.444 MHz */
+	tda10071_pdata.i2c_wr_max = 64;
+	tda10071_pdata.ts_mode = TDA10071_TS_SERIAL;
+	tda10071_pdata.pll_multiplier = 20;
+	tda10071_pdata.tuner_i2c_addr = 0x14;
+
+	dvb->i2c_client_demod = dvb_module_probe("tda10071", "tda10071_cx24118",
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x55, &tda10071_pdata);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
+
+	dvb->fe[0] = tda10071_pdata.get_dvb_frontend(dvb->i2c_client_demod);
 
 	/* attach SEC */
 	a8293_pdata.dvb_frontend = dvb->fe[0];
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "a8293", I2C_NAME_SIZE);
-	board_info.addr = 0x08;
-	board_info.platform_data = &a8293_pdata;
-	request_module("a8293");
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+
+	dvb->i2c_client_sec = dvb_module_probe("a8293", NULL,
+					       &dev->i2c_adap[dev->def_i2c_bus],
+					       0x08, &a8293_pdata);
+	if (!dvb->i2c_client_sec) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->i2c_client_sec = client;
-	result = 0;
-out_free:
-	return result;
+
+	return 0;
 }
 
-static noinline_for_stack int em28178_dvb_init_pctv_461e(struct em28xx *dev)
+static int em28178_dvb_init_pctv_461e(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
-	struct i2c_client *client;
 	struct i2c_adapter *i2c_adapter;
-	struct i2c_board_info board_info;
 	struct m88ds3103_platform_data m88ds3103_pdata = {};
 	struct ts2020_config ts2020_config = {};
 	struct a8293_platform_data a8293_pdata = {};
-	int result;
 
 	/* attach demod */
 	m88ds3103_pdata.clk = 27000000;
@@ -1204,184 +1176,98 @@ static noinline_for_stack int em28178_dvb_init_pctv_461e(struct em28xx *dev)
 	m88ds3103_pdata.ts_clk = 16000;
 	m88ds3103_pdata.ts_clk_pol = 1;
 	m88ds3103_pdata.agc = 0x99;
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
-	board_info.addr = 0x68;
-	board_info.platform_data = &m88ds3103_pdata;
-	request_module("m88ds3103");
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->fe[0] = m88ds3103_pdata.get_dvb_frontend(client);
-	i2c_adapter = m88ds3103_pdata.get_i2c_adapter(client);
-	dvb->i2c_client_demod = client;
+
+	dvb->i2c_client_demod = dvb_module_probe("m88ds3103", NULL,
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x68, &m88ds3103_pdata);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
+
+	dvb->fe[0] = m88ds3103_pdata.get_dvb_frontend(dvb->i2c_client_demod);
+	i2c_adapter = m88ds3103_pdata.get_i2c_adapter(dvb->i2c_client_demod);
 
 	/* attach tuner */
 	ts2020_config.fe = dvb->fe[0];
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "ts2022", I2C_NAME_SIZE);
-	board_info.addr = 0x60;
-	board_info.platform_data = &ts2020_config;
-	request_module("ts2020");
-	client = i2c_new_device(i2c_adapter, &board_info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+
+	dvb->i2c_client_tuner = dvb_module_probe("ts2020", "ts2022",
+					         i2c_adapter,
+					         0x60, &ts2020_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->i2c_client_tuner = client;
+
 	/* delegate signal strength measurement to tuner */
 	dvb->fe[0]->ops.read_signal_strength =
 			dvb->fe[0]->ops.tuner_ops.get_rf_strength;
 
 	/* attach SEC */
 	a8293_pdata.dvb_frontend = dvb->fe[0];
-	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "a8293", I2C_NAME_SIZE);
-	board_info.addr = 0x08;
-	board_info.platform_data = &a8293_pdata;
-	request_module("a8293");
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_tuner->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_tuner);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+	dvb->i2c_client_sec = dvb_module_probe("a8293", NULL,
+				  &dev->i2c_adap[dev->def_i2c_bus],
+				  0x08, &a8293_pdata);
+	if (!dvb->i2c_client_sec) {
+		dvb_module_release(dvb->i2c_client_tuner);
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_tuner->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_tuner);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->i2c_client_sec = client;
-	result = 0;
-out_free:
-	return result;
+
+	return 0;
 }
 
-static noinline_for_stack int em28178_dvb_init_pctv_292e(struct em28xx *dev)
+static int em28178_dvb_init_pctv_292e(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
-	int result;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &dvb->fe[0];
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
-	request_module(info.type);
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_demod = client;
+	dvb->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x64, &si2168_config);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
-	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = dvb->fe[0];
 	si2157_config.if_port = 1;
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	si2157_config.mdev = dev->media_dev;
 #endif
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
-	request_module(info.type);
-	client = i2c_new_device(adapter, &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+	dvb->i2c_client_tuner = dvb_module_probe("si2157", NULL,
+						 adapter,
+						 0x60, &si2157_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
-
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_tuner = client;
 	dvb->fe[0]->ops.set_lna = em28xx_pctv_292e_set_lna;
-	result = 0;
-out_free:
-	return result;
+
+	return 0;
 }
 
-static noinline_for_stack int em28178_dvb_init_terratec_t2_stick_hd(struct em28xx *dev)
+static int em28178_dvb_init_terratec_t2_stick_hd(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
-	int result;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &dvb->fe[0];
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
-	request_module(info.type);
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_demod = client;
+	dvb->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x64, &si2168_config);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
@@ -1390,127 +1276,65 @@ static noinline_for_stack int em28178_dvb_init_terratec_t2_stick_hd(struct em28x
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	si2157_config.mdev = dev->media_dev;
 #endif
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2146", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
-	request_module("si2157");
-	client = i2c_new_device(adapter, &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+	dvb->i2c_client_tuner = dvb_module_probe("si2157", "si2146",
+						 adapter,
+						 0x60, &si2157_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_tuner = client;
-	result = 0;
-out_free:
-	return result;
+	return 0;
 }
 
-static noinline_for_stack int em28178_dvb_init_plex_px_bcud(struct em28xx *dev)
+static int em28178_dvb_init_plex_px_bcud(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
-	struct i2c_client *client;
-	struct i2c_board_info info;
-	struct tc90522_config tc90522_config;
-	struct qm1d1c0042_config qm1d1c0042_config;
-	int result;
+	struct tc90522_config tc90522_config = {};
+	struct qm1d1c0042_config qm1d1c0042_config = {};
 
 	/* attach demod */
-	memset(&tc90522_config, 0, sizeof(tc90522_config));
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "tc90522sat", I2C_NAME_SIZE);
-	info.addr = 0x15;
-	info.platform_data = &tc90522_config;
-	request_module("tc90522");
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->i2c_client_demod = client;
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
+	dvb->i2c_client_demod = dvb_module_probe("tc90522", "tc90522sat",
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x15, &tc90522_config);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
-	memset(&qm1d1c0042_config, 0,
-	       sizeof(qm1d1c0042_config));
 	qm1d1c0042_config.fe = tc90522_config.fe;
 	qm1d1c0042_config.lpf = 1;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "qm1d1c0042", I2C_NAME_SIZE);
-	info.addr = 0x61;
-	info.platform_data = &qm1d1c0042_config;
-	request_module(info.type);
-	client = i2c_new_device(tc90522_config.tuner_i2c,
-				&info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-	dvb->i2c_client_tuner = client;
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+
+	dvb->i2c_client_tuner = dvb_module_probe("qm1d1c0042", NULL,
+						 tc90522_config.tuner_i2c,
+						 0x61, &qm1d1c0042_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
+
 	dvb->fe[0] = tc90522_config.fe;
 	px_bcud_init(dev);
-	result = 0;
-out_free:
-	return result;
+
+	return 0;
 }
 
-static noinline_for_stack int em28174_dvb_init_hauppauge_wintv_dualhd_dvb(struct em28xx *dev)
+static int em28174_dvb_init_hauppauge_wintv_dualhd_dvb(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
-	int result;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &dvb->fe[0];
 	si2168_config.ts_mode = SI2168_TS_SERIAL;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
-	request_module(info.type);
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_demod = client;
+	dvb->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x64, &si2168_config);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
@@ -1519,65 +1343,34 @@ static noinline_for_stack int em28174_dvb_init_hauppauge_wintv_dualhd_dvb(struct
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	si2157_config.mdev = dev->media_dev;
 #endif
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
-	request_module(info.type);
-	client = i2c_new_device(adapter, &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+	dvb->i2c_client_tuner = dvb_module_probe("si2157", NULL,
+						 adapter,
+						 0x60, &si2157_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_tuner = client;
-	result = 0;
-out_free:
-	return result;
+	return 0;
 }
 
 static int em28174_dvb_init_hauppauge_wintv_dualhd_01595(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb = dev->dvb;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client;
-	struct i2c_board_info info = {};
-	struct lgdt3306a_config lgdt3306a_config;
+	struct lgdt3306a_config lgdt3306a_config =  {};
 	struct si2157_config si2157_config = {};
-	int result;
 
 	/* attach demod */
 	lgdt3306a_config = hauppauge_01595_lgdt3306a_config;
 	lgdt3306a_config.fe = &dvb->fe[0];
 	lgdt3306a_config.i2c_adapter = &adapter;
-	strlcpy(info.type, "lgdt3306a", sizeof(info.type));
-	info.addr = 0x59;
-	info.platform_data = &lgdt3306a_config;
-	request_module(info.type);
-	client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus],
-			&info);
-	if (client == NULL || client->dev.driver == NULL) {
-		result = -ENODEV;
-		goto out_free;
-	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		result = -ENODEV;
-		goto out_free;
-	}
-
-	dvb->i2c_client_demod = client;
+	dvb->i2c_client_demod = dvb_module_probe("lgdt3306a", NULL,
+						 &dev->i2c_adap[dev->def_i2c_bus],
+						 0x59, &lgdt3306a_config);
+	if (!dvb->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
 	si2157_config.fe = dvb->fe[0];
@@ -1586,32 +1379,17 @@ static int em28174_dvb_init_hauppauge_wintv_dualhd_01595(struct em28xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	si2157_config.mdev = dev->media_dev;
 #endif
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", sizeof(info.type));
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
-	request_module(info.type);
-
-	client = i2c_new_device(adapter, &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
-	}
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		module_put(dvb->i2c_client_demod->dev.driver->owner);
-		i2c_unregister_device(dvb->i2c_client_demod);
-		result = -ENODEV;
-		goto out_free;
+	dvb->i2c_client_tuner = dvb_module_probe("si2157", NULL,
+						 adapter,
+						 0x60, &si2157_config);
+	if (!dvb->i2c_client_tuner) {
+		dvb_module_release(dvb->i2c_client_demod);
+		return -ENODEV;
 	}
 
-	dvb->i2c_client_tuner = client;
-	result = 0;
-out_free:
-	return result;
+	return 0;
 }
+
 static int em28xx_dvb_init(struct em28xx *dev)
 {
 	int result = 0;
@@ -1846,7 +1624,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
-		struct xc5000_config cfg;
+		struct xc5000_config cfg = {};
 
 		hauppauge_hvr930c_init(dev);
 
@@ -1863,7 +1641,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
 
 		/* Attach xc5000 */
-		memset(&cfg, 0, sizeof(cfg));
 		cfg.i2c_address  = 0x61;
 		cfg.if_khz = 4000;
 
@@ -2016,13 +1793,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2874_BOARD_KWORLD_UB435Q_V3:
 	{
-		struct i2c_client *client;
 		struct i2c_adapter *adapter = &dev->i2c_adap[dev->def_i2c_bus];
-		struct i2c_board_info board_info = {
-			.type = "tda18212",
-			.addr = 0x60,
-			.platform_data = &kworld_ub435q_v3_config,
-		};
 
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
 					&em2874_lgdt3305_nogate_dev,
@@ -2034,22 +1805,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* attach tuner */
 		kworld_ub435q_v3_config.fe = dvb->fe[0];
-		request_module("tda18212");
-		client = i2c_new_device(adapter, &board_info);
-		if (client == NULL || client->dev.driver == NULL) {
-			dvb_frontend_detach(dvb->fe[0]);
-			result = -ENODEV;
-			goto out_free;
-		}
 
-		if (!try_module_get(client->dev.driver->owner)) {
-			i2c_unregister_device(client);
+		dvb->i2c_client_tuner = dvb_module_probe("tda18212", NULL,
+							 adapter,
+							 0x60,
+							 &kworld_ub435q_v3_config);
+		if (!dvb->i2c_client_tuner) {
 			dvb_frontend_detach(dvb->fe[0]);
 			result = -ENODEV;
 			goto out_free;
 		}
-
-		dvb->i2c_client_tuner = client;
 		break;
 	}
 	case EM2874_BOARD_PCTV_HD_MINI_80E:
@@ -2140,7 +1905,6 @@ static inline void prevent_sleep(struct dvb_frontend_ops *ops)
 static int em28xx_dvb_fini(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb;
-	struct i2c_client *client;
 
 	if (dev->is_audio_only) {
 		/* Shouldn't initialize IR for this interface */
@@ -2176,26 +1940,10 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 
 	em28xx_unregister_dvb(dvb);
 
-	/* remove I2C SEC */
-	client = dvb->i2c_client_sec;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	/* remove I2C tuner */
-	client = dvb->i2c_client_tuner;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	/* remove I2C demod */
-	client = dvb->i2c_client_demod;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
+	/* release I2C module bindings */
+	dvb_module_release(dvb->i2c_client_sec);
+	dvb_module_release(dvb->i2c_client_tuner);
+	dvb_module_release(dvb->i2c_client_demod);
 
 	kfree(dvb);
 	dev->dvb = NULL;
-- 
2.14.3
