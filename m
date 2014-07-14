Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbaGNRJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/18] si2157: rework firmware download logic a little bit
Date: Mon, 14 Jul 2014 20:08:59 +0300
Message-Id: <1405357739-3570-18-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rework firmware selection / chip detection logic a little bit.
Add missing release_firmware() to error path.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 108 +++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 3fa1f26..329004f 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -82,11 +82,11 @@ err:
 static int si2157_init(struct dvb_frontend *fe)
 {
 	struct si2157 *s = fe->tuner_priv;
-	int ret, remaining;
+	int ret, len, remaining;
 	struct si2157_cmd cmd;
-	u8 chip, len = 0;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
+	unsigned int chip_id;
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
@@ -106,64 +106,69 @@ static int si2157_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	chip = cmd.args[2]; /* 57 for Si2157, 58 for Si2158 */
+	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
+			cmd.args[4] << 0;
 
-	/* Si2158 requires firmware download */
-	if (chip == 58) {
-		if (((cmd.args[1] & 0x0f) == 1) && (cmd.args[3] == '2') &&
-				(cmd.args[4] == '0'))
-			fw_file = SI2158_A20_FIRMWARE;
-		else {
-			dev_err(&s->client->dev,
-					"%s: no firmware file for Si%d-%c%c defined\n",
-					KBUILD_MODNAME, chip, cmd.args[3], cmd.args[4]);
-			ret = -EINVAL;
-			goto err;
-		}
+	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
+	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
 
-		/* cold state - try to download firmware */
-		dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
-				KBUILD_MODNAME, si2157_ops.info.name);
+	switch (chip_id) {
+	case SI2158_A20:
+		fw_file = SI2158_A20_FIRMWARE;
+		break;
+	case SI2157_A30:
+		goto skip_fw_download;
+		break;
+	default:
+		dev_err(&s->client->dev,
+				"%s: unkown chip version Si21%d-%c%c%c\n",
+				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
+				cmd.args[3], cmd.args[4]);
+		ret = -EINVAL;
+		goto err;
+	}
 
-		/* request the firmware, this will block and timeout */
-		ret = request_firmware(&fw, fw_file, &s->client->dev);
-		if (ret) {
-			dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
-					KBUILD_MODNAME, fw_file);
-			goto err;
-		}
+	/* cold state - try to download firmware */
+	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
+			KBUILD_MODNAME, si2157_ops.info.name);
 
-		dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
+	/* request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, fw_file, &s->client->dev);
+	if (ret) {
+		dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
+		goto err;
+	}
 
-		/* firmware should be n chunks of 17 bytes */
-		if (fw->size % 17 != 0) {
-			dev_err(&s->client->dev, "%s: firmware file '%s' is invalid\n",
-					KBUILD_MODNAME, fw_file);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		for (remaining = fw->size; remaining > 0; remaining -= 17) {
-			memcpy(&len, &fw->data[fw->size - remaining], 1);
-			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1],
-					len);
-			cmd.wlen = len;
-			cmd.rlen = 1;
-			ret = si2157_cmd_execute(s, &cmd);
-			if (ret) {
-				dev_err(&s->client->dev,
-						"%s: firmware download failed=%d\n",
-						KBUILD_MODNAME, ret);
-				goto err;
-			}
-		}
+	/* firmware should be n chunks of 17 bytes */
+	if (fw->size % 17 != 0) {
+		dev_err(&s->client->dev, "%s: firmware file '%s' is invalid\n",
+				KBUILD_MODNAME, fw_file);
+		ret = -EINVAL;
+		goto err;
+	}
 
-		release_firmware(fw);
-		fw = NULL;
+	dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
+			KBUILD_MODNAME, fw_file);
 
+	for (remaining = fw->size; remaining > 0; remaining -= 17) {
+		len = fw->data[fw->size - remaining];
+		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
+		cmd.wlen = len;
+		cmd.rlen = 1;
+		ret = si2157_cmd_execute(s, &cmd);
+		if (ret) {
+			dev_err(&s->client->dev,
+					"%s: firmware download failed=%d\n",
+					KBUILD_MODNAME, ret);
+			goto err;
+		}
 	}
 
+	release_firmware(fw);
+	fw = NULL;
+
+skip_fw_download:
 	/* reboot the tuner with new firmware? */
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
@@ -176,6 +181,9 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	return 0;
 err:
+	if (fw)
+		release_firmware(fw);
+
 	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
-- 
1.9.3

