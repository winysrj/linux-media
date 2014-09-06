Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33944 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaIFOZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 10:25:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9033: init DVBv5 statistics
Date: Sat,  6 Sep 2014 17:25:12 +0300
Message-Id: <1410013512-30117-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to init supported stats here in order signal app which
stats are supported.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index be5002a..63a89c1 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -238,6 +238,7 @@ static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 static int af9033_init(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, len;
 	const struct reg_val *init;
 	u8 buf[4];
@@ -448,6 +449,19 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	dev->bandwidth_hz = 0; /* force to program all parameters */
+	/* init stats here in order signal app which stats are supported */
+	c->strength.len = 1;
+	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_count.len = 1;
+	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	/* start statistics polling */
 	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 
-- 
http://palosaari.fi/

