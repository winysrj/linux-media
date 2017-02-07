Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward20p.cmail.yandex.net ([77.88.31.15]:43504 "EHLO
        forward20p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932377AbdBGVj5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 16:39:57 -0500
Received: from smtp2o.mail.yandex.net (smtp2o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::26])
        by forward20p.cmail.yandex.net (Yandex) with ESMTP id D61E021FED
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:35:55 +0300 (MSK)
Received: from smtp2o.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp2o.mail.yandex.net (Yandex) with ESMTP id B0E905080DD2
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:35:55 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] si2157: Si2141/2151 tuner support.
Date: Tue, 07 Feb 2017 23:35:46 +0200
Message-ID: <1976995.UgqrPGCnYC@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for new tuner version.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/tuners/si2157.c      | 70 ++++++++++++++++++++++++++++++++++----
 drivers/media/tuners/si2157_priv.h |  2 ++
 2 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 57b2508..b46b149 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
+ * Silicon Labs Si2141/2146/2147/2148/2151/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
@@ -75,6 +75,7 @@ static int si2157_cmd_execute(struct i2c_client *client, struct si2157_cmd *cmd)
 	return ret;
 }
 
+#define MAX_RESET_ATTEMPTS 10
 static int si2157_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->tuner_priv;
@@ -84,7 +85,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
 	const char *fw_name;
-	unsigned int uitmp, chip_id;
+	unsigned int uitmp, chip_id, i;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -102,14 +103,44 @@ static int si2157_init(struct dvb_frontend *fe)
 	if (uitmp == dev->if_frequency / 1000)
 		goto warm;
 
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
+		for (i = 0; i < MAX_RESET_ATTEMPTS; i++)  {
+			/* reset */
+			memcpy(cmd.args, "\xc0\x05\x00\x00", 4);
+			cmd.wlen = 4;
+			cmd.rlen = 1;
+			ret = si2157_cmd_execute(client, &cmd);
+			if (ret)
+				goto err;
+
+			memcpy(cmd.args, "\xc0\x00\x0d\x0e\x00\x01\x01\x01\x01\x03", 10);
+			cmd.wlen = 10;
+			cmd.rlen = 1;
+			ret = si2157_cmd_execute(client, &cmd);
+			if (ret)
+				goto err;
+			if (cmd.args[0] != 0xfe)
+				break;
+		}
+		if (i >= MAX_RESET_ATTEMPTS)
+			goto err;
+	}
+
 	/* power up */
-	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
+	switch (dev->chiptype) {
+	case SI2157_CHIPTYPE_SI2146:
 		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
 		cmd.wlen = 9;
-	} else {
+		break;
+	case SI2157_CHIPTYPE_SI2141:
+		memcpy(cmd.args, "\xc0\x08\x01\x02\x00\x08\x01", 7);
+		cmd.wlen = 7;
+		break;
+	default:
 		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
 		cmd.wlen = 15;
 	}
+
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
@@ -131,6 +162,8 @@ static int si2157_init(struct dvb_frontend *fe)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
 	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
 	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
+	#define SI2141_A10 ('A' << 24 | 41 << 16 | '1' << 8 | '0' << 0)
+	#define SI2151_A10 ('A' << 24 | 51 << 16 | '1' << 8 | '0' << 0)
 
 	switch (chip_id) {
 	case SI2158_A20:
@@ -142,6 +175,10 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2146_A10:
 		fw_name = NULL;
 		break;
+	case SI2141_A10:
+	case SI2151_A10:
+		fw_name = SI2141_A10_FIRMWARE;
+		break;
 	default:
 		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
@@ -214,6 +251,23 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
+
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2141) {
+		/* set clock */
+		memcpy(cmd.args, "\xc0\x00\x0d", 3);
+		cmd.wlen = 3;
+		cmd.rlen = 1;
+		ret = si2157_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+		/* setup PIN */
+		memcpy(cmd.args, "\x12\x80\x80\x85\x00\x81\x00", 7);
+		cmd.wlen = 7;
+		cmd.rlen = 7;
+		ret = si2157_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+	}
 warm:
 	/* init statistics in order signal app which are supported */
 	c->strength.len = 1;
@@ -471,7 +525,8 @@ static int si2157_probe(struct i2c_client *client,
 #endif
 
 	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
-			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
+			dev->chiptype == SI2157_CHIPTYPE_SI2141 ?
+			"Si2141/2151" : dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
 			"Si2146" : "Si2147/2148/2157/2158");
 
 	return 0;
@@ -508,6 +563,8 @@ static int si2157_remove(struct i2c_client *client)
 static const struct i2c_device_id si2157_id_table[] = {
 	{"si2157", SI2157_CHIPTYPE_SI2157},
 	{"si2146", SI2157_CHIPTYPE_SI2146},
+	{"si2141", SI2157_CHIPTYPE_SI2141},
+	{"si2151", SI2157_CHIPTYPE_SI2141},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, si2157_id_table);
@@ -524,7 +581,8 @@ static int si2157_remove(struct i2c_client *client)
 
 module_i2c_driver(si2157_driver);
 
-MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver");
+MODULE_DESCRIPTION("Silicon Labs Si2141/2146/2147/2148/2151/2157/2158 silicon tuner driver");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
+MODULE_FIRMWARE(SI2141_A10_FIRMWARE);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6b2c7b..e6436f7 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -42,6 +42,7 @@ struct si2157_dev {
 
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
+#define SI2157_CHIPTYPE_SI2141 2
 
 /* firmware command struct */
 #define SI2157_ARGLEN      30
@@ -52,5 +53,6 @@ struct si2157_cmd {
 };
 
 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
+#define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
 
 #endif
-- 
1.9.1


