Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:34864 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaLHUbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 15:31:10 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] mn88472: implement firmware parity check
Date: Mon,  8 Dec 2014 21:31:07 +0100
Message-Id: <1418070667-13349-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418070667-13349-1-git-send-email-benjamin@southpole.se>
References: <1418070667-13349-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index df7dbe9..1df85a7 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -294,6 +294,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88472_FIRMWARE;
+	unsigned int csum;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -346,6 +347,20 @@ static int mn88472_init(struct dvb_frontend *fe)
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
1.9.1

