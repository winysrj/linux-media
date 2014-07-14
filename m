Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51559 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbaGNRJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/18] si2168: few firmware download changes
Date: Mon, 14 Jul 2014 20:08:58 +0300
Message-Id: <1405357739-3570-17-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rework firmware selection logic a little bit.
Print notice asking user update firmware when old Si2168 B40
firmware is used.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 41 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index e9c138a..0422925 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -336,6 +336,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	u8 *fw_file;
 	const unsigned int i2c_wr_max = 8;
 	struct si2168_cmd cmd;
+	unsigned int chip_id;
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
@@ -361,16 +362,24 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	if (((cmd.args[1] & 0x0f) == 2) && (cmd.args[3] == '4') &&
-			(cmd.args[4] == '0'))
-		fw_file = SI2168_B40_FIRMWARE;
-	else if (((cmd.args[1] & 0x0f) == 1) && (cmd.args[3] == '3') &&
-			(cmd.args[4] == '0'))
+	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
+			cmd.args[4] << 0;
+
+	#define SI2168_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
+	#define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
+
+	switch (chip_id) {
+	case SI2168_A30:
 		fw_file = SI2168_A30_FIRMWARE;
-	else {
+		break;
+	case SI2168_B40:
+		fw_file = SI2168_B40_FIRMWARE;
+		break;
+	default:
 		dev_err(&s->client->dev,
-				"%s: no firmware file for Si2168-%c%c defined\n",
-				KBUILD_MODNAME, cmd.args[3], cmd.args[4]);
+				"%s: unkown chip version Si21%d-%c%c%c\n",
+				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
+				cmd.args[3], cmd.args[4]);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -382,15 +391,19 @@ static int si2168_init(struct dvb_frontend *fe)
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &s->client->dev);
 	if (ret) {
-		/* fallback mechanism to handle old name for
-		   SI2168_B40_FIRMWARE */
-		if (((cmd.args[1] & 0x0f) == 2) && (cmd.args[3] == '4') &&
-				(cmd.args[4] == '0')) {
+		/* fallback mechanism to handle old name for Si2168 B40 fw */
+		if (chip_id == SI2168_B40) {
 			fw_file = SI2168_B40_FIRMWARE_FALLBACK;
 			ret = request_firmware(&fw, fw_file, &s->client->dev);
 		}
-		if (ret) {
-			dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
+
+		if (ret == 0) {
+			dev_notice(&s->client->dev,
+					"%s: please install firmware file '%s'\n",
+					KBUILD_MODNAME, SI2168_B40_FIRMWARE);
+		} else {
+			dev_err(&s->client->dev,
+					"%s: firmware file '%s' not found\n",
 					KBUILD_MODNAME, fw_file);
 			goto err;
 		}
-- 
1.9.3

