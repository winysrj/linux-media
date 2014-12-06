Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34434 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaLFVfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 22/22] si2157: change firmware variable name and type
Date: Sat,  6 Dec 2014 23:34:56 +0200
Message-Id: <1417901696-5517-22-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename firmware variable from fw_file to fw_name and change its
type from u8 to const char as request_firmware() input is.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 27b488b..fcf139d 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -82,7 +82,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
-	u8 *fw_file;
+	const char *fw_name;
 	unsigned int chip_id;
 
 	dev_dbg(&client->dev, "\n");
@@ -123,12 +123,12 @@ static int si2157_init(struct dvb_frontend *fe)
 	switch (chip_id) {
 	case SI2158_A20:
 	case SI2148_A20:
-		fw_file = SI2158_A20_FIRMWARE;
+		fw_name = SI2158_A20_FIRMWARE;
 		break;
 	case SI2157_A30:
 	case SI2147_A30:
 	case SI2146_A10:
-		fw_file = NULL;
+		fw_name = NULL;
 		break;
 	default:
 		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
@@ -141,27 +141,27 @@ static int si2157_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
 			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
 
-	if (fw_file == NULL)
+	if (fw_name == NULL)
 		goto skip_fw_download;
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
+	ret = request_firmware(&fw, fw_name, &client->dev);
 	if (ret) {
 		dev_err(&client->dev, "firmware file '%s' not found\n",
-				fw_file);
+				fw_name);
 		goto err;
 	}
 
 	/* firmware should be n chunks of 17 bytes */
 	if (fw->size % 17 != 0) {
 		dev_err(&client->dev, "firmware file '%s' is invalid\n",
-				fw_file);
+				fw_name);
 		ret = -EINVAL;
 		goto err_release_firmware;
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-			fw_file);
+			fw_name);
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
 		len = fw->data[fw->size - remaining];
-- 
http://palosaari.fi/

