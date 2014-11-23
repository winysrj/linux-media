Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:42430 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaKWUSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 15:18:11 -0500
Received: by mail-la0-f50.google.com with SMTP id pv20so6564891lab.23
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 12:18:09 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] si2157: Add support for Si2146-A10
Date: Sun, 23 Nov 2014 22:17:52 +0200
Message-Id: <1416773873-27221-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Silicon Labs Si2146 tuner seems to work with the same driver as the Si2157, but there a few exceptions. The powerup command seems to be quite a bit different. In addition there's a property 0207 that requires a different value. Thus another entry is created in the si2157_id table to support also si2146 in this driver.

The datasheet is available on manufacturer's website:
http://www.silabs.com/support%20documents/technicaldocs/Si2146-short.pdf

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 23 +++++++++++++++++++----
 drivers/media/tuners/si2157_priv.h |  5 +++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index b086b87..e867b28 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -93,8 +93,13 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto warm;
 
 	/* power up */
-	memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
-	cmd.wlen = 15;
+	if (s->chiptype == SI2157_CHIPTYPE_SI2146) {
+		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
+		cmd.wlen = 9;
+	} else {
+		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
+		cmd.wlen = 15;
+	}
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
@@ -114,6 +119,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
 	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
+	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
 
 	switch (chip_id) {
 	case SI2158_A20:
@@ -121,6 +127,7 @@ static int si2157_init(struct dvb_frontend *fe)
 		break;
 	case SI2157_A30:
 	case SI2147_A30:
+	case SI2146_A10:
 		goto skip_fw_download;
 		break;
 	default:
@@ -275,7 +282,10 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
+	if (s->chiptype == SI2157_CHIPTYPE_SI2146)
+		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x01", 6);
+	else
+		memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(s, &cmd);
@@ -339,6 +349,7 @@ static int si2157_probe(struct i2c_client *client,
 	s->fe = cfg->fe;
 	s->inversion = cfg->inversion;
 	s->fw_loaded = false;
+	s->chiptype = (u8)id->driver_data;
 	mutex_init(&s->i2c_mutex);
 
 	/* check if the tuner is there */
@@ -355,7 +366,10 @@ static int si2157_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, s);
 
 	dev_info(&s->client->dev,
-			"Silicon Labs Si2157/Si2158 successfully attached\n");
+			"Silicon Labs %s successfully attached\n",
+			s->chiptype == SI2157_CHIPTYPE_SI2146 ?
+			"Si2146" : "Si2147/2157/2158");
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -380,6 +394,7 @@ static int si2157_remove(struct i2c_client *client)
 
 static const struct i2c_device_id si2157_id[] = {
 	{"si2157", 0},
+	{"si2146", 1},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, si2157_id);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index e71ffaf..66ecf30 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -28,8 +28,13 @@ struct si2157 {
 	bool active;
 	bool fw_loaded;
 	bool inversion;
+	u8 chiptype;
 };
 
+#define SI2157_CHIPTYPE_SI2157 0
+#define SI2157_CHIPTYPE_SI2146 1
+
+
 /* firmare command struct */
 #define SI2157_ARGLEN      30
 struct si2157_cmd {
-- 
1.9.1

