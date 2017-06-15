Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59705 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdFODbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:35 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/15] af9013: add dvbv5 cnr
Date: Thu, 15 Jun 2017 06:30:58 +0300
Message-Id: <20170615033105.13517-8-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DVBv5 CNR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index a6b88ae..68091f2 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -228,6 +228,7 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 {
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, len;
 	unsigned int utmp;
 	u8 buf[3];
@@ -283,6 +284,9 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
 	}
 	state->snr = utmp * 10; /* dB/10 */
 
+	c->cnr.stat[0].svalue = 1000 * utmp;
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
@@ -1508,6 +1512,7 @@ static int af9013_probe(struct i2c_client *client,
 {
 	struct af9013_state *state;
 	struct af9013_platform_data *pdata = client->dev.platform_data;
+	struct dtv_frontend_properties *c;
 	int ret, i;
 	u8 firmware_version[4];
 	static const struct regmap_bus regmap_bus = {
@@ -1572,6 +1577,10 @@ static int af9013_probe(struct i2c_client *client,
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = af9013_get_dvb_frontend;
 
+	/* Init stats to indicate which stats are supported */
+	c = &state->fe.dtv_property_cache;
+	c->cnr.len = 1;
+
 	dev_info(&client->dev, "Afatech AF9013 successfully attached\n");
 	dev_info(&client->dev, "firmware version: %d.%d.%d.%d\n",
 		 firmware_version[0], firmware_version[1],
-- 
http://palosaari.fi/
