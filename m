Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:41020 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaLGWKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 17:10:15 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] mn88472: fix firmware loading
Date: Sun,  7 Dec 2014 23:10:03 +0100
Message-Id: <1417990203-758-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417990203-758-1-git-send-email-benjamin@southpole.se>
References: <1417990203-758-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmware must be loaded one byte at a time via the 0xf6 register.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index ffee187..ba1bc8d 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -290,7 +290,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
-	int ret, len, remaining;
+	int ret, i;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88472_FIRMWARE;
 
@@ -330,19 +330,12 @@ static int mn88472_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->i2c_wr_max - 1)) {
-		len = remaining;
-		if (len > (dev->i2c_wr_max - 1))
-			len = (dev->i2c_wr_max - 1);
-
-		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
-				&fw->data[fw->size - remaining], len);
-		if (ret) {
-			dev_err(&client->dev,
-					"firmware download failed=%d\n", ret);
-			goto err;
-		}
+	for (i = 0 ; i < fw->size ; i++)
+		ret |= regmap_write(dev->regmap[0], 0xf6, fw->data[i]);
+	if (ret) {
+		dev_err(&client->dev,
+				"firmware download failed=%d\n", ret);
+		goto err;
 	}
 
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
-- 
1.9.1

