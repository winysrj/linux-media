Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56377 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaDOJcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/10] si2168: add support for DVB-C (annex A version)
Date: Tue, 15 Apr 2014 12:31:42 +0300
Message-Id: <1397554306-14561-7-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for DVB-C (annex A version).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 4f3efbe..7aaac81 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -84,6 +84,12 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		cmd.wlen = 2;
 		cmd.rlen = 13;
 		break;
+	case SYS_DVBC_ANNEX_A:
+		cmd.args[0] = 0x90;
+		cmd.args[1] = 0x01;
+		cmd.wlen = 2;
+		cmd.rlen = 9;
+		break;
 	case SYS_DVBT2:
 		cmd.args[0] = 0x50;
 		cmd.args[1] = 0x01;
@@ -157,6 +163,9 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	case SYS_DVBT:
 		delivery_system = 0x20;
 		break;
+	case SYS_DVBC_ANNEX_A:
+		delivery_system = 0x30;
+		break;
 	case SYS_DVBT2:
 		delivery_system = 0x70;
 		break;
@@ -165,23 +174,20 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	switch (c->bandwidth_hz) {
-	case 5000000:
+	if (c->bandwidth_hz <= 5000000)
 		bandwidth = 0x05;
-		break;
-	case 6000000:
+	else if (c->bandwidth_hz <= 6000000)
 		bandwidth = 0x06;
-		break;
-	case 7000000:
+	else if (c->bandwidth_hz <= 7000000)
 		bandwidth = 0x07;
-		break;
-	case 8000000:
+	else if (c->bandwidth_hz <= 8000000)
 		bandwidth = 0x08;
-		break;
-	default:
-		ret = -EINVAL;
-		goto err;
-	}
+	else if (c->bandwidth_hz <= 9000000)
+		bandwidth = 0x09;
+	else if (c->bandwidth_hz <= 10000000)
+		bandwidth = 0x0a;
+	else
+		bandwidth = 0x0f;
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params) {
@@ -200,6 +206,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	/* that has no big effect */
 	if (c->delivery_system == SYS_DVBT)
 		memcpy(cmd.args, "\x89\x21\x06\x11\xff\x98", 6);
+	else if (c->delivery_system == SYS_DVBC_ANNEX_A)
+		memcpy(cmd.args, "\x89\x21\x06\x11\x89\xf0", 6);
 	else if (c->delivery_system == SYS_DVBT2)
 		memcpy(cmd.args, "\x89\x21\x06\x11\x89\x20", 6);
 	cmd.wlen = 6;
@@ -614,7 +622,7 @@ static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 }
 
 static const struct dvb_frontend_ops si2168_ops = {
-	.delsys = {SYS_DVBT, SYS_DVBT2},
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Silicon Labs Si2168",
 		.caps =	FE_CAN_FEC_1_2 |
-- 
1.9.0

