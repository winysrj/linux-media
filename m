Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:52968 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaLMASz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 19:18:55 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] mn88472: elaborate debug printout
Date: Sat, 13 Dec 2014 01:18:44 +0100
Message-Id: <1418429925-16342-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 4d80046..746cc94 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -33,6 +33,7 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	u64 tmp;
 	u8 delivery_system_val, if_val[3], bw_val[7], bw_val2;
 
+	dev_dbg(&client->dev, "%s:\n", __func__);
 	dev_dbg(&client->dev,
 			"delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
 			c->delivery_system, c->modulation,
@@ -288,7 +289,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 	u8 *fw_file = MN88472_FIRMWARE;
 	unsigned int csum;
 
-	dev_dbg(&client->dev, "\n");
+	dev_dbg(&client->dev, "%s:\n", __func__);
 
 	/* set cold state by default */
 	dev->warm = false;
@@ -371,7 +372,7 @@ static int mn88472_sleep(struct dvb_frontend *fe)
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	dev_dbg(&client->dev, "\n");
+	dev_dbg(&client->dev, "%s:\n", __func__);
 
 	/* power off */
 	ret = regmap_write(dev->regmap[2], 0x0b, 0x30);
-- 
1.9.1

