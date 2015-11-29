Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:40491 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbbK2CKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2015 21:10:18 -0500
Received: from benjamin-desktop.lan (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 98CF2727C3
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2015 03:10:16 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] mn88472: add work around for failing firmware loading
Date: Sun, 29 Nov 2015 03:10:15 +0100
Message-Id: <1448763016-10527-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes the firmware fails to load because of an i2c error.
Work around that by adding retry logic. This kind of logic
also exist in the binary driver and failures have been observed
there also. Thus this seems to be a property of the hardware
and a fix like this is needed.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index cf2e96b..80c5807 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -282,7 +282,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88472_FIRMWARE;
-	unsigned int tmp;
+	unsigned int tmp, retry_cnt;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -330,9 +330,22 @@ static int mn88472_init(struct dvb_frontend *fe)
 		if (len > (dev->i2c_wr_max - 1))
 			len = dev->i2c_wr_max - 1;
 
+		/* I2C transfers during firmware load might fail sometimes,
+		 * just retry in that case. 4 consecutive failures have
+		 * been observed thus a retry limit of 20 is used.
+		 */
+		retry_cnt = 20;
+retry:
 		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
+			if (retry_cnt) {
+				dev_dbg(&client->dev,
+				"i2c error, retry %d triggered\n", retry_cnt);
+				retry_cnt--;
+				usleep_range(200, 10000);
+				goto retry;
+			}
 			dev_err(&client->dev,
 					"firmware download failed=%d\n", ret);
 			goto firmware_release;
-- 
2.1.4

