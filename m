Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56491 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbCOW6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:06 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/10] mn88472: implement firmware parity check
Date: Sun, 15 Mar 2015 23:57:51 +0100
Message-Id: <1426460275-3766-6-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/mn88472/mn88472.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 5070c37..4a00a4d 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -258,6 +258,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88472_FIRMWARE;
+	unsigned int csum;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -303,6 +304,20 @@ static int mn88472_init(struct dvb_frontend *fe)
 		}
 	}
 
+	/* parity check of firmware */
+	ret = regmap_read(dev->regmap[0], 0xf8, &csum);
+	if (ret) {
+		dev_err(&client->dev,
+				"parity reg read failed=%d\n", ret);
+		goto err;
+	}
+	if (csum & 0x10) {
+		dev_err(&client->dev,
+				"firmware parity check failed=0x%x\n", csum);
+		goto err;
+	}
+	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", csum);
+
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
 		goto err;
-- 
2.1.0

