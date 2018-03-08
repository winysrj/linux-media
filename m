Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65479 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752052AbeCHSrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 13:47:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        Sean Young <sean@mess.org>
Subject: [PATCH 1/2] media: dvbsky: use the new dvb_module_probe() API
Date: Thu,  8 Mar 2018 15:47:38 -0300
Message-Id: <5f7aebbd7725c5021831df4fcb77fa7b8b4df01b.1520534830.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of repeating countless times a complex logic, use
the new dvb_module_probe()/dvb_module_release(), simplifying
the module.

That reduced about 15% at the module's size:

   text	   data	    bss	    dec	    hex	filename
   7083	   1108	     12	   8203	   200b	old/drivers/media/usb/dvb-usb-v2/dvbsky.o
   5817	   1108	     12	   6937	   1b19	new/drivers/media/usb/dvb-usb-v2/dvbsky.o

Tested with a DVBSky S960C DVB-S2 tuner (0572:960c)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 390 +++++++++++-----------------------
 1 file changed, 119 insertions(+), 271 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 43eb82884555..416231bf381f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -290,61 +290,44 @@ static int dvbsky_usb_read_status(struct dvb_frontend *fe,
 	return ret;
 }
 
-static const struct m88ds3103_config dvbsky_s960_m88ds3103_config = {
-	.i2c_addr = 0x68,
-	.clock = 27000000,
-	.i2c_wr_max = 33,
-	.clock_out = 0,
-	.ts_mode = M88DS3103_TS_CI,
-	.ts_clk = 16000,
-	.ts_clk_pol = 0,
-	.agc = 0x99,
-	.lnb_hv_pol = 1,
-	.lnb_en_pol = 1,
-};
-
 static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvbsky_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret = 0;
-	/* demod I2C adapter */
-	struct i2c_adapter *i2c_adapter = NULL;
-	struct i2c_client *client;
-	struct i2c_board_info info;
+	struct i2c_adapter *i2c_adapter;
+	struct m88ds3103_platform_data m88ds3103_pdata = {};
 	struct ts2020_config ts2020_config = {};
-	memset(&info, 0, sizeof(struct i2c_board_info));
 
 	/* attach demod */
-	adap->fe[0] = dvb_attach(m88ds3103_attach,
-			&dvbsky_s960_m88ds3103_config,
-			&d->i2c_adap,
-			&i2c_adapter);
-	if (!adap->fe[0]) {
-		dev_err(&d->udev->dev, "dvbsky_s960_attach fail.\n");
-		ret = -ENODEV;
-		goto fail_attach;
-	}
+	m88ds3103_pdata.clk = 27000000;
+	m88ds3103_pdata.i2c_wr_max = 33;
+	m88ds3103_pdata.clk_out = 0;
+	m88ds3103_pdata.ts_mode = M88DS3103_TS_CI;
+	m88ds3103_pdata.ts_clk = 16000;
+	m88ds3103_pdata.ts_clk_pol = 0;
+	m88ds3103_pdata.agc = 0x99;
+	m88ds3103_pdata.lnb_hv_pol = 1,
+	m88ds3103_pdata.lnb_en_pol = 1,
+
+	state->i2c_client_demod = dvb_module_probe("m88ds3103", NULL,
+						   &d->i2c_adap,
+						   0x68, &m88ds3103_pdata);
+	if (!state->i2c_client_demod)
+		return -ENODEV;
+
+	adap->fe[0] = m88ds3103_pdata.get_dvb_frontend(state->i2c_client_demod);
+	i2c_adapter = m88ds3103_pdata.get_i2c_adapter(state->i2c_client_demod);
 
 	/* attach tuner */
 	ts2020_config.fe = adap->fe[0];
 	ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
-	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &ts2020_config;
-	request_module("ts2020");
-	client = i2c_new_device(i2c_adapter, &info);
-	if (client == NULL || client->dev.driver == NULL) {
-		dvb_frontend_detach(adap->fe[0]);
-		ret = -ENODEV;
-		goto fail_attach;
-	}
 
-	if (!try_module_get(client->dev.driver->owner)) {
-		i2c_unregister_device(client);
-		dvb_frontend_detach(adap->fe[0]);
-		ret = -ENODEV;
-		goto fail_attach;
+	state->i2c_client_tuner = dvb_module_probe("ts2020", NULL,
+						   i2c_adapter,
+						   0x60, &ts2020_config);
+	if (!state->i2c_client_tuner) {
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
 	}
 
 	/* delegate signal strength measurement to tuner */
@@ -359,10 +342,7 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 	state->fe_set_voltage = adap->fe[0]->ops.set_voltage;
 	adap->fe[0]->ops.set_voltage = dvbsky_usb_set_voltage;
 
-	state->i2c_client_tuner = client;
-
-fail_attach:
-	return ret;
+	return 0;
 }
 
 static int dvbsky_usb_ci_set_voltage(struct dvb_frontend *fe,
@@ -412,80 +392,60 @@ static int dvbsky_ci_ctrl(void *priv, u8 read, int addr,
 	return ret;
 }
 
-static const struct m88ds3103_config dvbsky_s960c_m88ds3103_config = {
-	.i2c_addr = 0x68,
-	.clock = 27000000,
-	.i2c_wr_max = 33,
-	.clock_out = 0,
-	.ts_mode = M88DS3103_TS_CI,
-	.ts_clk = 10000,
-	.ts_clk_pol = 1,
-	.agc = 0x99,
-	.lnb_hv_pol = 0,
-	.lnb_en_pol = 1,
-};
-
 static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvbsky_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret = 0;
-	/* demod I2C adapter */
-	struct i2c_adapter *i2c_adapter = NULL;
-	struct i2c_client *client_tuner, *client_ci;
-	struct i2c_board_info info;
-	struct sp2_config sp2_config;
+	struct i2c_adapter *i2c_adapter;
+	struct m88ds3103_platform_data m88ds3103_pdata = {};
 	struct ts2020_config ts2020_config = {};
-	memset(&info, 0, sizeof(struct i2c_board_info));
+	struct sp2_config sp2_config = {};
 
 	/* attach demod */
-	adap->fe[0] = dvb_attach(m88ds3103_attach,
-			&dvbsky_s960c_m88ds3103_config,
-			&d->i2c_adap,
-			&i2c_adapter);
-	if (!adap->fe[0]) {
-		dev_err(&d->udev->dev, "dvbsky_s960ci_attach fail.\n");
-		ret = -ENODEV;
-		goto fail_attach;
-	}
+	m88ds3103_pdata.clk = 27000000,
+	m88ds3103_pdata.i2c_wr_max = 33,
+	m88ds3103_pdata.clk_out = 0,
+	m88ds3103_pdata.ts_mode = M88DS3103_TS_CI,
+	m88ds3103_pdata.ts_clk = 10000,
+	m88ds3103_pdata.ts_clk_pol = 1,
+	m88ds3103_pdata.agc = 0x99,
+	m88ds3103_pdata.lnb_hv_pol = 0,
+	m88ds3103_pdata.lnb_en_pol = 1,
+
+	state->i2c_client_demod = dvb_module_probe("m88ds3103", NULL,
+						   &d->i2c_adap,
+						   0x68, &m88ds3103_pdata);
+	if (!state->i2c_client_demod)
+		return -ENODEV;
+
+	adap->fe[0] = m88ds3103_pdata.get_dvb_frontend(state->i2c_client_demod);
+	i2c_adapter = m88ds3103_pdata.get_i2c_adapter(state->i2c_client_demod);
 
 	/* attach tuner */
 	ts2020_config.fe = adap->fe[0];
 	ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
-	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &ts2020_config;
-	request_module("ts2020");
-	client_tuner = i2c_new_device(i2c_adapter, &info);
-	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
-		ret = -ENODEV;
-		goto fail_tuner_device;
-	}
 
-	if (!try_module_get(client_tuner->dev.driver->owner)) {
-		ret = -ENODEV;
-		goto fail_tuner_module;
+	state->i2c_client_tuner = dvb_module_probe("ts2020", NULL,
+						   i2c_adapter,
+						   0x60, &ts2020_config);
+	if (!state->i2c_client_tuner) {
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
 	}
 
 	/* attach ci controller */
-	memset(&sp2_config, 0, sizeof(sp2_config));
 	sp2_config.dvb_adap = &adap->dvb_adap;
 	sp2_config.priv = d;
 	sp2_config.ci_control = dvbsky_ci_ctrl;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "sp2", I2C_NAME_SIZE);
-	info.addr = 0x40;
-	info.platform_data = &sp2_config;
-	request_module("sp2");
-	client_ci = i2c_new_device(&d->i2c_adap, &info);
-	if (client_ci == NULL || client_ci->dev.driver == NULL) {
-		ret = -ENODEV;
-		goto fail_ci_device;
-	}
 
-	if (!try_module_get(client_ci->dev.driver->owner)) {
-		ret = -ENODEV;
-		goto fail_ci_module;
+	state->i2c_client_ci = dvb_module_probe("sp2", NULL,
+						&d->i2c_adap,
+						0x40, &sp2_config);
+
+	if (!state->i2c_client_ci) {
+		dvb_module_release(state->i2c_client_tuner);
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
 	}
 
 	/* delegate signal strength measurement to tuner */
@@ -500,165 +460,92 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 	state->fe_set_voltage = adap->fe[0]->ops.set_voltage;
 	adap->fe[0]->ops.set_voltage = dvbsky_usb_ci_set_voltage;
 
-	state->i2c_client_tuner = client_tuner;
-	state->i2c_client_ci = client_ci;
-	return ret;
-fail_ci_module:
-	i2c_unregister_device(client_ci);
-fail_ci_device:
-	module_put(client_tuner->dev.driver->owner);
-fail_tuner_module:
-	i2c_unregister_device(client_tuner);
-fail_tuner_device:
-	dvb_frontend_detach(adap->fe[0]);
-fail_attach:
-	return ret;
+	return 0;
 }
 
 static int dvbsky_t680c_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvbsky_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret = 0;
 	struct i2c_adapter *i2c_adapter;
-	struct i2c_client *client_demod, *client_tuner, *client_ci;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
-	struct sp2_config sp2_config;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
+	struct sp2_config sp2_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &i2c_adapter;
 	si2168_config.fe = &adap->fe[0];
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
 
-	request_module(info.type);
-	client_demod = i2c_new_device(&d->i2c_adap, &info);
-	if (client_demod == NULL ||
-			client_demod->dev.driver == NULL)
-		goto fail_demod_device;
-	if (!try_module_get(client_demod->dev.driver->owner))
-		goto fail_demod_module;
+	state->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						   &d->i2c_adap,
+						   0x64, &si2168_config);
+	if (!state->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
-	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
 	si2157_config.if_port = 1;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
 
-	request_module(info.type);
-	client_tuner = i2c_new_device(i2c_adapter, &info);
-	if (client_tuner == NULL ||
-			client_tuner->dev.driver == NULL)
-		goto fail_tuner_device;
-	if (!try_module_get(client_tuner->dev.driver->owner))
-		goto fail_tuner_module;
+	state->i2c_client_tuner = dvb_module_probe("si2157", NULL,
+						   i2c_adapter,
+						   0x60, &si2157_config);
+	if (!state->i2c_client_tuner) {
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
+	}
 
 	/* attach ci controller */
-	memset(&sp2_config, 0, sizeof(sp2_config));
 	sp2_config.dvb_adap = &adap->dvb_adap;
 	sp2_config.priv = d;
 	sp2_config.ci_control = dvbsky_ci_ctrl;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "sp2", I2C_NAME_SIZE);
-	info.addr = 0x40;
-	info.platform_data = &sp2_config;
 
-	request_module(info.type);
-	client_ci = i2c_new_device(&d->i2c_adap, &info);
+	state->i2c_client_ci = dvb_module_probe("sp2", NULL,
+						&d->i2c_adap,
+						0x40, &sp2_config);
 
-	if (client_ci == NULL || client_ci->dev.driver == NULL)
-		goto fail_ci_device;
+	if (!state->i2c_client_ci) {
+		dvb_module_release(state->i2c_client_tuner);
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
+	}
 
-	if (!try_module_get(client_ci->dev.driver->owner))
-		goto fail_ci_module;
-
-	state->i2c_client_demod = client_demod;
-	state->i2c_client_tuner = client_tuner;
-	state->i2c_client_ci = client_ci;
-	return ret;
-fail_ci_module:
-	i2c_unregister_device(client_ci);
-fail_ci_device:
-	module_put(client_tuner->dev.driver->owner);
-fail_tuner_module:
-	i2c_unregister_device(client_tuner);
-fail_tuner_device:
-	module_put(client_demod->dev.driver->owner);
-fail_demod_module:
-	i2c_unregister_device(client_demod);
-fail_demod_device:
-	ret = -ENODEV;
-	return ret;
+	return 0;
 }
 
 static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvbsky_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret = 0;
 	struct i2c_adapter *i2c_adapter;
-	struct i2c_client *client_demod, *client_tuner;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &i2c_adapter;
 	si2168_config.fe = &adap->fe[0];
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 	si2168_config.ts_clock_gapped = true;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
 
-	request_module(info.type);
-	client_demod = i2c_new_device(&d->i2c_adap, &info);
-	if (client_demod == NULL ||
-			client_demod->dev.driver == NULL)
-		goto fail_demod_device;
-	if (!try_module_get(client_demod->dev.driver->owner))
-		goto fail_demod_module;
+	state->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						   &d->i2c_adap,
+						   0x64, &si2168_config);
+	if (!state->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
-	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
 	si2157_config.if_port = 1;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
 
-	request_module(info.type);
-	client_tuner = i2c_new_device(i2c_adapter, &info);
-	if (client_tuner == NULL ||
-			client_tuner->dev.driver == NULL)
-		goto fail_tuner_device;
-	if (!try_module_get(client_tuner->dev.driver->owner))
-		goto fail_tuner_module;
+	state->i2c_client_tuner = dvb_module_probe("si2157", NULL,
+						   i2c_adapter,
+						   0x60, &si2157_config);
+	if (!state->i2c_client_tuner) {
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
+	}
 
-	state->i2c_client_demod = client_demod;
-	state->i2c_client_tuner = client_tuner;
-	return ret;
-fail_tuner_module:
-	i2c_unregister_device(client_tuner);
-fail_tuner_device:
-	module_put(client_demod->dev.driver->owner);
-fail_demod_module:
-	i2c_unregister_device(client_demod);
-fail_demod_device:
-	ret = -ENODEV;
-	return ret;
+	return 0;
 }
 
 static int dvbsky_mygica_t230c_attach(struct dvb_usb_adapter *adap)
@@ -666,57 +553,34 @@ static int dvbsky_mygica_t230c_attach(struct dvb_usb_adapter *adap)
 	struct dvbsky_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct i2c_adapter *i2c_adapter;
-	struct i2c_client *client_demod, *client_tuner;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
+	struct si2168_config si2168_config = {};
+	struct si2157_config si2157_config = {};
 
 	/* attach demod */
-	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &i2c_adapter;
 	si2168_config.fe = &adap->fe[0];
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 	si2168_config.ts_clock_inv = 1;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", sizeof(info.type));
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
 
-	request_module("si2168");
-	client_demod = i2c_new_device(&d->i2c_adap, &info);
-	if (!client_demod || !client_demod->dev.driver)
-		goto fail_demod_device;
-	if (!try_module_get(client_demod->dev.driver->owner))
-		goto fail_demod_module;
+	state->i2c_client_demod = dvb_module_probe("si2168", NULL,
+						   &d->i2c_adap,
+						   0x64, &si2168_config);
+	if (!state->i2c_client_demod)
+		return -ENODEV;
 
 	/* attach tuner */
-	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
 	si2157_config.if_port = 0;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2141", sizeof(info.type));
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
 
-	request_module("si2157");
-	client_tuner = i2c_new_device(i2c_adapter, &info);
-	if (!client_tuner || !client_tuner->dev.driver)
-		goto fail_tuner_device;
-	if (!try_module_get(client_tuner->dev.driver->owner))
-		goto fail_tuner_module;
+	state->i2c_client_tuner = dvb_module_probe("si2157", "si2141",
+						   i2c_adapter,
+						   0x60, &si2157_config);
+	if (!state->i2c_client_tuner) {
+		dvb_module_release(state->i2c_client_demod);
+		return -ENODEV;
+	}
 
-	state->i2c_client_demod = client_demod;
-	state->i2c_client_tuner = client_tuner;
 	return 0;
-
-fail_tuner_module:
-	i2c_unregister_device(client_tuner);
-fail_tuner_device:
-	module_put(client_demod->dev.driver->owner);
-fail_demod_module:
-	i2c_unregister_device(client_demod);
-fail_demod_device:
-	return -ENODEV;
 }
 
 
@@ -754,26 +618,10 @@ static int dvbsky_init(struct dvb_usb_device *d)
 static void dvbsky_exit(struct dvb_usb_device *d)
 {
 	struct dvbsky_state *state = d_to_priv(d);
-	struct i2c_client *client;
 
-	client = state->i2c_client_tuner;
-	/* remove I2C tuner */
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-	client = state->i2c_client_demod;
-	/* remove I2C demod */
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-	client = state->i2c_client_ci;
-	/* remove I2C ci */
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
+	dvb_module_release(state->i2c_client_tuner);
+	dvb_module_release(state->i2c_client_demod);
+	dvb_module_release(state->i2c_client_ci);
 }
 
 /* DVB USB Driver stuff */
-- 
2.14.3
