Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58814 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751079AbdCQQut (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 12:50:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] mn88472: implement signal strength statistics
Date: Fri, 17 Mar 2017 18:50:25 +0200
Message-Id: <20170317165027.11471-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 signal strength on relative scale.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index 29dd13b..25dd742 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -28,8 +28,9 @@ static int mn88472_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
-	unsigned int utmp;
+	int ret, i;
+	unsigned int utmp, utmp1;
+	u8 buf[2];
 
 	if (!dev->active) {
 		ret = -EAGAIN;
@@ -77,6 +78,24 @@ static int mn88472_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		goto err;
 	}
 
+	/* Signal strength */
+	if (*status & FE_HAS_SIGNAL) {
+		for (i = 0; i < 2; i++) {
+			ret = regmap_bulk_read(dev->regmap[2], 0x8e + i,
+					       &buf[i], 1);
+			if (ret)
+				goto err;
+		}
+
+		utmp1 = buf[0] << 8 | buf[1] << 0 | buf[0] >> 2;
+		dev_dbg(&client->dev, "strength=%u\n", utmp1);
+
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = utmp1;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -462,6 +481,7 @@ static int mn88472_probe(struct i2c_client *client,
 {
 	struct mn88472_config *pdata = client->dev.platform_data;
 	struct mn88472_dev *dev;
+	struct dtv_frontend_properties *c;
 	int ret;
 	unsigned int utmp;
 	static const struct regmap_config regmap_config = {
@@ -547,6 +567,10 @@ static int mn88472_probe(struct i2c_client *client,
 	*pdata->fe = &dev->fe;
 	i2c_set_clientdata(client, dev);
 
+	/* Init stats to indicate which stats are supported */
+	c = &dev->fe.dtv_property_cache;
+	c->strength.len = 1;
+
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = mn88472_get_dvb_frontend;
 
-- 
http://palosaari.fi/
