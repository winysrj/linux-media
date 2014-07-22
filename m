Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59062 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbaGVPyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 11:54:24 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so682510wiv.15
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 08:54:22 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] si2168: Add ts_mode config.
Date: Tue, 22 Jul 2014 16:54:17 +0100
Message-Id: <1406044457-15923-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the TS mode as a config option:
- ts_mode added to config struct.
- Possible (interesting) values are
   * Parallel mode = 0x06
   * Serial mode = 0x03

Currently the modules using this demod only use parallel mode.

Regards,
Luis

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c  | 17 ++++++++++-------
 drivers/media/dvb-frontends/si2168.h  |  6 ++++++
 drivers/media/usb/dvb-usb/cxusb.c     |  1 +
 drivers/media/usb/em28xx/em28xx-dvb.c |  1 +
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 41bdbc4..d45a1c6 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -297,13 +297,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x18", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
@@ -350,6 +343,7 @@ err:
 static int si2168_init(struct dvb_frontend *fe)
 {
 	struct si2168 *s = fe->demodulator_priv;
+	struct si2168_config *config = s->client->dev.platform_data;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
@@ -479,6 +473,15 @@ static int si2168_init(struct dvb_frontend *fe)
 	dev_info(&s->client->dev, "%s: found a '%s' in warm state\n",
 			KBUILD_MODNAME, si2168_ops.info.name);
 
+	/* Set TSMODE */
+	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
+	cmd.args[4] |= config->ts_mode;
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2168_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	s->active = true;
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/si2168.h b/drivers/media/dvb-frontends/si2168.h
index 3c5b5ab..ebbf309 100644
--- a/drivers/media/dvb-frontends/si2168.h
+++ b/drivers/media/dvb-frontends/si2168.h
@@ -34,6 +34,12 @@ struct si2168_config {
 	 * returned by driver
 	 */
 	struct i2c_adapter **i2c_adapter;
+
+	/* TS mode */
+	u8 ts_mode;
 };
 
+#define SI2168_TSMODE_PARALLEL	0x06
+#define SI2168_TSMODE_SERIAL	0x03
+
 #endif
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index b7461ac..18a2720 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1369,6 +1369,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	/* attach frontend */
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe_adap[0].fe;
+	si2168_config.ts_mode = SI2168_TSMODE_PARALLEL;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 	info.addr = 0x64;
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 96a0bdb..27d5d84 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1525,6 +1525,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach demod */
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &dvb->fe[0];
+			si2168_config.ts_mode = SI2168_TSMODE_PARALLEL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
-- 
1.9.1

