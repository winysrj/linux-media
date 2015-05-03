Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36863 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbECNAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 09:00:35 -0400
Received: by lagv1 with SMTP id v1so88819390lag.3
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 06:00:33 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH v3 3/6] si2157: support selection of IF interface
Date: Sun,  3 May 2015 16:00:20 +0300
Message-Id: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The chips supported by the si2157 driver have two IF outputs (either
pins 12+13 or pins 9+11). Instead of hardcoding the output to be used
add an option to choose which output shall be used.

As this patch changes the default behaviour, the IF interface is
specified in each driver currently using si2157 driver. This is to
keep bisectability.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 4 ++++
 drivers/media/pci/smipcie/smipcie.c     | 1 +
 drivers/media/tuners/si2157.c           | 4 +++-
 drivers/media/tuners/si2157.h           | 6 ++++++
 drivers/media/tuners/si2157_priv.h      | 1 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 2 ++
 drivers/media/usb/dvb-usb-v2/af9035.c   | 1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c   | 2 ++
 drivers/media/usb/dvb-usb/cxusb.c       | 1 +
 drivers/media/usb/em28xx/em28xx-dvb.c   | 2 ++
 10 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 745caab..37fd013 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1912,6 +1912,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = fe0->dvb.frontend;
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1957,6 +1958,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = fe0->dvb.frontend;
+		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -2093,6 +2095,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = fe0->dvb.frontend;
+		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -2172,6 +2175,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = fe0->dvb.frontend;
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index 4115925..143fd78 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -657,6 +657,7 @@ static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = port->fe;
+	si2157_config.if_port = 1;
 
 	memset(&client_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(client_info.type, "si2157", I2C_NAME_SIZE);
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d74ae26..cdaf687 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -298,7 +298,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (dev->chiptype == SI2157_CHIPTYPE_SI2146)
 		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x01", 6);
 	else
-		memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
+		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x00", 6);
+	cmd.args[4] = dev->if_port;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(client, &cmd);
@@ -378,6 +379,7 @@ static int si2157_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, dev);
 	dev->fe = cfg->fe;
 	dev->inversion = cfg->inversion;
+	dev->if_port = cfg->if_port;
 	dev->fw_loaded = false;
 	dev->chiptype = (u8)id->driver_data;
 	dev->if_frequency = 5000000; /* default value of property 0x0706 */
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index a564c4a..4db97ab 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -34,6 +34,12 @@ struct si2157_config {
 	 * Spectral Inversion
 	 */
 	bool inversion;
+
+	/*
+	 * Port selection
+	 * Select the RF interface to use (pins 9+11 or 12+13)
+	 */
+	u8 if_port;
 };
 
 #endif
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index cd8fa5b..71a5f8c 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -28,6 +28,7 @@ struct si2157_dev {
 	bool fw_loaded;
 	bool inversion;
 	u8 chiptype;
+	u8 if_port;
 	u32 if_frequency;
 };
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 610d567..66ee161 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -797,6 +797,7 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -852,6 +853,7 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 80a29f5..7b7f75d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1569,6 +1569,7 @@ static int it930x_tuner_attach(struct dvb_usb_adapter *adap)
 
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
 			&si2157_config, state->i2c_adapter_demod);
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 0f73b1d..57c8c2d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -549,6 +549,7 @@ static int dvbsky_t680c_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
@@ -633,6 +634,7 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index ffc3704..ab71511 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1350,6 +1350,7 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe_adap[0].fe;
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a5b22c5..5b7c7c88 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1579,6 +1579,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1639,6 +1640,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
+			si2157_config.if_port = 0;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2146", I2C_NAME_SIZE);
 			info.addr = 0x60;
-- 
1.9.1

