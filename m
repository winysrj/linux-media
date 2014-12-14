Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33252 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLNI3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/18] rtl2830: wrap DVBv5 signal strength to DVBv3
Date: Sun, 14 Dec 2014 10:28:37 +0200
Message-Id: <1418545723-9536-12-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change legacy DVBv3 signal strength to return values calculated by
DVBv5 statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 147b3a6..a02ccdf 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -623,33 +623,14 @@ static int rtl2830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct i2c_client *client = fe->demodulator_priv;
-	struct rtl2830_dev *dev = i2c_get_clientdata(client);
-	int ret;
-	u8 buf[2];
-	u16 if_agc_raw, if_agc;
-
-	if (dev->sleeping)
-		return 0;
-
-	ret = rtl2830_rd_regs(client, 0x359, buf, 2);
-	if (ret)
-		goto err;
-
-	if_agc_raw = (buf[0] << 8 | buf[1]) & 0x3fff;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	if (if_agc_raw & (1 << 9))
-		if_agc = -(~(if_agc_raw - 1) & 0x1ff);
+	if (c->strength.stat[0].scale == FE_SCALE_RELATIVE)
+		*strength = c->strength.stat[0].uvalue;
 	else
-		if_agc = if_agc_raw;
-
-	*strength = (u8)(55 - if_agc / 182);
-	*strength |= *strength << 8;
+		*strength = 0;
 
 	return 0;
-err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
-	return ret;
 }
 
 static struct dvb_frontend_ops rtl2830_ops = {
-- 
http://palosaari.fi/

