Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51207 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdCQQuy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 12:50:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] mn88472: implement PER statistics
Date: Fri, 17 Mar 2017 18:50:27 +0200
Message-Id: <20170317165027.11471-3-crope@iki.fi>
In-Reply-To: <20170317165027.11471-1-crope@iki.fi>
References: <20170317165027.11471-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 PER.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index c7e5f63..f6938f96 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -179,6 +179,26 @@ static int mn88472_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* PER */
+	if (*status & FE_HAS_SYNC) {
+		ret = regmap_bulk_read(dev->regmap[0], 0xe1, buf, 4);
+		if (ret)
+			goto err;
+
+		utmp1 = buf[0] << 8 | buf[1] << 0;
+		utmp2 = buf[2] << 8 | buf[3] << 0;
+		dev_dbg(&client->dev, "block_error=%u block_count=%u\n",
+			utmp1, utmp2);
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue += utmp1;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue += utmp2;
+	} else {
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -654,6 +674,8 @@ static int mn88472_probe(struct i2c_client *client,
 	c = &dev->fe.dtv_property_cache;
 	c->strength.len = 1;
 	c->cnr.len = 1;
+	c->block_error.len = 1;
+	c->block_count.len = 1;
 
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = mn88472_get_dvb_frontend;
-- 
http://palosaari.fi/
