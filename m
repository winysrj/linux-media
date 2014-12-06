Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46531 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbaLFVfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/22] si2168: change firmware variable name and type
Date: Sat,  6 Dec 2014 23:34:47 +0200
Message-Id: <1417901696-5517-13-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename firmware variable from fw_file to fw_name and change its type
from u8 to const char as request_firmware() input defines.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 46a919b..7f966f3 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -347,7 +347,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	const struct firmware *fw;
-	u8 *fw_file;
+	const char *fw_name;
 	struct si2168_cmd cmd;
 	unsigned int chip_id;
 
@@ -405,13 +405,13 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	switch (chip_id) {
 	case SI2168_A20:
-		fw_file = SI2168_A20_FIRMWARE;
+		fw_name = SI2168_A20_FIRMWARE;
 		break;
 	case SI2168_A30:
-		fw_file = SI2168_A30_FIRMWARE;
+		fw_name = SI2168_A30_FIRMWARE;
 		break;
 	case SI2168_B40:
-		fw_file = SI2168_B40_FIRMWARE;
+		fw_name = SI2168_B40_FIRMWARE;
 		break;
 	default:
 		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
@@ -425,12 +425,12 @@ static int si2168_init(struct dvb_frontend *fe)
 			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
+	ret = request_firmware(&fw, fw_name, &client->dev);
 	if (ret) {
 		/* fallback mechanism to handle old name for Si2168 B40 fw */
 		if (chip_id == SI2168_B40) {
-			fw_file = SI2168_B40_FIRMWARE_FALLBACK;
-			ret = request_firmware(&fw, fw_file, &client->dev);
+			fw_name = SI2168_B40_FIRMWARE_FALLBACK;
+			ret = request_firmware(&fw, fw_name, &client->dev);
 		}
 
 		if (ret == 0) {
@@ -440,13 +440,13 @@ static int si2168_init(struct dvb_frontend *fe)
 		} else {
 			dev_err(&client->dev,
 					"firmware file '%s' not found\n",
-					fw_file);
+					fw_name);
 			goto err_release_firmware;
 		}
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-			fw_file);
+			fw_name);
 
 	if ((fw->size % 17 == 0) && (fw->data[0] > 5)) {
 		/* firmware is in the new format */
-- 
http://palosaari.fi/

