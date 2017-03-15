Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:51692 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdCOWWz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:22:55 -0400
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 1/3] [media] si2157: get chip id during probing
Date: Wed, 15 Mar 2017 23:22:08 +0100
Message-Id: <1489616530-4025-2-git-send-email-andreas@kemnade.info>
In-Reply-To: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the si2157 is behind a e.g. si2168, the si2157 will
at least in some situations not be readable after the si268
got the command 0101. It still accepts commands but the answer
is just ffffff. So read the chip id before that so the
information is not lost.

The following line in kernel output is a symptome
of that problem:
si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xffffffff

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/media/tuners/si2157.c      | 54 ++++++++++++++++++++++----------------
 drivers/media/tuners/si2157_priv.h |  7 +++++
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 57b2508..0da7a33 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -84,7 +84,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
 	const char *fw_name;
-	unsigned int uitmp, chip_id;
+	unsigned int uitmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -115,24 +115,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* query chip revision */
-	memcpy(cmd.args, "\x02", 1);
-	cmd.wlen = 1;
-	cmd.rlen = 13;
-	ret = si2157_cmd_execute(client, &cmd);
-	if (ret)
-		goto err;
-
-	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
-			cmd.args[4] << 0;
-
-	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
-	#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
-	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
-	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
-	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
-
-	switch (chip_id) {
+	switch (dev->chip_id) {
 	case SI2158_A20:
 	case SI2148_A20:
 		fw_name = SI2158_A20_FIRMWARE;
@@ -150,9 +133,6 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
-			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
-
 	if (fw_name == NULL)
 		goto skip_fw_download;
 
@@ -444,6 +424,36 @@ static int si2157_probe(struct i2c_client *client,
 
 	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = client;
+	/* power up */
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
+		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
+		cmd.wlen = 9;
+	} else {
+		memcpy(cmd.args,
+		"\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01",
+		15);
+		cmd.wlen = 15;
+	}
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+	/* query chip revision */
+	/* hack: do it here because after the si2168 gets 0101, commands will
+	 * still be executed here but no result
+	 */
+	memcpy(cmd.args, "\x02", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 13;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err_kfree;
+	dev->chip_id = cmd.args[1] << 24 |
+			cmd.args[2] << 16 |
+			cmd.args[3] << 8 |
+			cmd.args[4] << 0;
+	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
+			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (cfg->mdev) {
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6b2c7b..54c1a856 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -30,6 +30,7 @@ struct si2157_dev {
 	u8 chiptype;
 	u8 if_port;
 	u32 if_frequency;
+	u32 chip_id;
 	struct delayed_work stat_work;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -43,6 +44,12 @@ struct si2157_dev {
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
 
+#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
+#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
+#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
+#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
+#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
+
 /* firmware command struct */
 #define SI2157_ARGLEN      30
 struct si2157_cmd {
-- 
2.1.4
