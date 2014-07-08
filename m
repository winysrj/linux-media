Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41015 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaGHFx1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 01:53:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] tda10071: force modulation to QPSK on DVB-S
Date: Tue,  8 Jul 2014 08:53:03 +0300
Message-Id: <1404798786-28361-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only supported modulation for DVB-S is QPSK. Modulation parameter
contains invalid value for DVB-S on some cases, which leads driver
refusing tuning attempt. Due to that, hard code modulation to QPSK
in case of DVB-S.

Cc: stable@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 522fe00..49874e7 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -668,6 +668,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
+	fe_modulation_t modulation;
 
 	dev_dbg(&priv->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
@@ -702,10 +703,13 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
+		modulation = QPSK;
 		rolloff = 0;
 		pilot = 2;
 		break;
 	case SYS_DVBS2:
+		modulation = c->modulation;
+
 		switch (c->rolloff) {
 		case ROLLOFF_20:
 			rolloff = 2;
@@ -750,7 +754,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 
 	for (i = 0, mode = 0xff; i < ARRAY_SIZE(TDA10071_MODCOD); i++) {
 		if (c->delivery_system == TDA10071_MODCOD[i].delivery_system &&
-			c->modulation == TDA10071_MODCOD[i].modulation &&
+			modulation == TDA10071_MODCOD[i].modulation &&
 			c->fec_inner == TDA10071_MODCOD[i].fec) {
 			mode = TDA10071_MODCOD[i].val;
 			dev_dbg(&priv->i2c->dev, "%s: mode found=%02x\n",
-- 
1.9.3

