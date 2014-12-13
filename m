Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:52969 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaLMASz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 19:18:55 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] mn88472: implemented ber reporting
Date: Sat, 13 Dec 2014 01:18:45 +0100
Message-Id: <1418429925-16342-4-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 746cc94..8b35639 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -392,6 +392,36 @@ err:
 	return ret;
 }
 
+static int mn88472_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct i2c_client *client = fe->demodulator_priv;
+	struct mn88472_dev *dev = i2c_get_clientdata(client);
+	int ret, err, len;
+	u8 data[3];
+
+	dev_dbg(&client->dev, "%s:\n", __func__);
+
+	ret = regmap_bulk_read(dev->regmap[0], 0x9F , data, 3);
+	if (ret)
+		goto err;
+	err = data[0]<<16 | data[1]<<8 | data[2];
+
+	ret = regmap_bulk_read(dev->regmap[0], 0xA2 , data, 2);
+	if (ret)
+		goto err;
+	len = data[0]<<8 | data[1];
+
+	if (len)
+		*ber = (err*100)/len;
+	else
+		*ber = 0;
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static struct dvb_frontend_ops mn88472_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
@@ -425,6 +455,7 @@ static struct dvb_frontend_ops mn88472_ops = {
 	.set_frontend = mn88472_set_frontend,
 
 	.read_status = mn88472_read_status,
+	.read_ber = mn88472_read_ber,
 };
 
 static int mn88472_probe(struct i2c_client *client,
-- 
1.9.1

