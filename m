Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49358 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 10/22] si2168: enhance firmware download routine
Date: Sat,  6 Dec 2014 23:34:44 +0200
Message-Id: <1417901696-5517-10-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All known old firmware firmware formats are downloaded using 8 byte
chunks. Reject firmware if it could not be divided to 8 byte chunks
and because of that we could simplify some calculations. Now both
supported firmware download routines are rather similar.

Cc: Olli Salonen <olli.salonen@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 1fab088..e8e715f 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -348,7 +348,6 @@ static int si2168_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
-	const unsigned int i2c_wr_max = 8;
 	struct si2168_cmd cmd;
 	unsigned int chip_id;
 
@@ -459,31 +458,28 @@ static int si2168_init(struct dvb_frontend *fe)
 			cmd.wlen = len;
 			cmd.rlen = 1;
 			ret = si2168_cmd_execute(client, &cmd);
-			if (ret) {
-				dev_err(&client->dev,
-						"firmware download failed=%d\n",
-						ret);
-				goto err_release_firmware;
-			}
+			if (ret)
+				break;
 		}
-	} else {
+	} else if (fw->size % 8 == 0) {
 		/* firmware is in the old format */
-		for (remaining = fw->size; remaining > 0; remaining -= i2c_wr_max) {
-			len = remaining;
-			if (len > i2c_wr_max)
-				len = i2c_wr_max;
-
+		for (remaining = fw->size; remaining > 0; remaining -= 8) {
+			len = 8;
 			memcpy(cmd.args, &fw->data[fw->size - remaining], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
 			ret = si2168_cmd_execute(client, &cmd);
-			if (ret) {
-				dev_err(&client->dev,
-						"firmware download failed=%d\n",
-						ret);
-				goto err_release_firmware;
-			}
+			if (ret)
+				break;
 		}
+	} else {
+		/* bad or unknown firmware format */
+		ret = -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(&client->dev, "firmware download failed %d\n", ret);
+		goto err_release_firmware;
 	}
 
 	release_firmware(fw);
-- 
http://palosaari.fi/

