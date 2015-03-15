Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56490 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbbCOW6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:05 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/10] mn88473: implement firmware parity check
Date: Sun, 15 Mar 2015 23:57:52 +0100
Message-Id: <1426460275-3766-7-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88473/mn88473.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index 84bd4fa..607ce4d 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -192,6 +192,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88473_FIRMWARE;
+	unsigned int tmp;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -227,6 +228,20 @@ static int mn88473_init(struct dvb_frontend *fe)
 		}
 	}
 
+	/* parity check of firmware */
+	ret = regmap_read(dev->regmap[0], 0xf8, &tmp);
+	if (ret) {
+		dev_err(&client->dev,
+				"parity reg read failed=%d\n", ret);
+		goto err;
+	}
+	if (tmp & 0x10) {
+		dev_err(&client->dev,
+				"firmware parity check failed=0x%x\n", tmp);
+		goto err;
+	}
+	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", tmp);
+
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
 		goto err;
-- 
2.1.0

