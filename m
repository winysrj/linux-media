Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57178 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaDOJcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/10] si2168: add support for DVB-T2
Date: Tue, 15 Apr 2014 12:31:40 +0300
Message-Id: <1397554306-14561-5-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DVB-T2.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 55 ++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index eef4e45..4f3efbe 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -66,6 +66,7 @@ err:
 static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct si2168 *s = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -76,10 +77,24 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	cmd.args[0] = 0xa0;
-	cmd.args[1] = 0x01;
-	cmd.wlen = 2;
-	cmd.rlen = 13;
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		cmd.args[0] = 0xa0;
+		cmd.args[1] = 0x01;
+		cmd.wlen = 2;
+		cmd.rlen = 13;
+		break;
+	case SYS_DVBT2:
+		cmd.args[0] = 0x50;
+		cmd.args[1] = 0x01;
+		cmd.wlen = 2;
+		cmd.rlen = 14;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
@@ -125,7 +140,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
-	u8 bandwidth;
+	u8 bandwidth, delivery_system;
 
 	dev_dbg(&s->client->dev,
 			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u\n",
@@ -138,18 +153,30 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		delivery_system = 0x20;
+		break;
+	case SYS_DVBT2:
+		delivery_system = 0x70;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
 	switch (c->bandwidth_hz) {
 	case 5000000:
-		bandwidth = 0x25;
+		bandwidth = 0x05;
 		break;
 	case 6000000:
-		bandwidth = 0x26;
+		bandwidth = 0x06;
 		break;
 	case 7000000:
-		bandwidth = 0x27;
+		bandwidth = 0x07;
 		break;
 	case 8000000:
-		bandwidth = 0x28;
+		bandwidth = 0x08;
 		break;
 	default:
 		ret = -EINVAL;
@@ -170,7 +197,11 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x89\x21\x06\x11\xff\x98", 6);
+	/* that has no big effect */
+	if (c->delivery_system == SYS_DVBT)
+		memcpy(cmd.args, "\x89\x21\x06\x11\xff\x98", 6);
+	else if (c->delivery_system == SYS_DVBT2)
+		memcpy(cmd.args, "\x89\x21\x06\x11\x89\x20", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 3;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -241,7 +272,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x0a\x10\x00\x00", 6);
-	cmd.args[4] = bandwidth;
+	cmd.args[4] = delivery_system | bandwidth;
 	cmd.wlen = 6;
 	cmd.rlen = 1;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -583,7 +614,7 @@ static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 }
 
 static const struct dvb_frontend_ops si2168_ops = {
-	.delsys = {SYS_DVBT},
+	.delsys = {SYS_DVBT, SYS_DVBT2},
 	.info = {
 		.name = "Silicon Labs Si2168",
 		.caps =	FE_CAN_FEC_1_2 |
-- 
1.9.0

