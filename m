Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768Ab3CDThx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Mar 2013 14:37:53 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24JbrX6023337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 4 Mar 2013 14:37:53 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] mb86a20s: Implement set_frontend cache logic
Date: Mon,  4 Mar 2013 16:37:43 -0300
Message-Id: <1362425864-29292-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Up to now, the driver was simply assuming TV mode, 13 segs.
Implement the logic to control the ISDB operational mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 74 +++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 1c135aa..1859e9d 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -24,6 +24,18 @@ static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 
+enum mb86a20s_bandwidth {
+	MB86A20S_13SEG = 0,
+	MB86A20S_13SEG_PARTIAL = 1,
+	MB86A20S_1SEG = 2,
+	MB86A20S_3SEG = 3,
+};
+
+u8 mb86a20s_subchannel[] = {
+	0xb0, 0xc0, 0xd0, 0xe0,
+	0xf0, 0x00, 0x10, 0x20,
+};
+
 struct mb86a20s_state {
 	struct i2c_adapter *i2c;
 	const struct mb86a20s_config *config;
@@ -32,6 +44,9 @@ struct mb86a20s_state {
 	struct dvb_frontend frontend;
 
 	u32 if_freq;
+	enum mb86a20s_bandwidth bw;
+	bool inversion;
+	u32 subchannel;
 
 	u32 estimated_rate[3];
 	unsigned long get_strength_time;
@@ -54,10 +69,7 @@ static struct regdata mb86a20s_init1[] = {
 	{ 0x70, 0x0f },
 	{ 0x70, 0xff },
 	{ 0x08, 0x01 },
-	{ 0x09, 0x3e },
 	{ 0x50, 0xd1 }, { 0x51, 0x20 },
-	{ 0x39, 0x01 },
-	{ 0x71, 0x00 },
 	{ 0x28, 0x2a }, { 0x29, 0x00 }, { 0x2a, 0xff }, { 0x2b, 0x80 },
 };
 
@@ -1765,7 +1777,7 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	u64 pll;
 	int rc;
-	u8  regD5 = 1;
+	u8  regD5 = 1, reg71, reg09 = 0x3a;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -1777,6 +1789,27 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	if (rc < 0)
 		goto err;
 
+	if (!state->inversion)
+		reg09 |= 0x04;
+	rc = mb86a20s_writereg(state, 0x09, reg09);
+	if (rc < 0)
+		goto err;
+	if (!state->bw)
+		reg71 = 1;
+	else
+		reg71 = 0;
+	rc = mb86a20s_writereg(state, 0x39, reg71);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x71, state->bw);
+	if (rc < 0)
+		goto err;
+	if (state->subchannel) {
+		rc = mb86a20s_writereg(state, 0x44, state->subchannel);
+		if (rc < 0)
+			goto err;
+	}
+
 	/* Adjust IF frequency to match tuner */
 	if (fe->ops.tuner_ops.get_if_frequency)
 		fe->ops.tuner_ops.get_if_frequency(fe, &state->if_freq);
@@ -1836,15 +1869,34 @@ err:
 static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc, if_freq;
-#if 0
-	/*
-	 * FIXME: Properly implement the set frontend properties
-	 */
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-#endif
+	int rc, if_freq;
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
+	if (!c->isdbt_layer_enabled)
+		c->isdbt_layer_enabled = 7;
+
+	if (c->isdbt_layer_enabled == 1)
+		state->bw = MB86A20S_1SEG;
+	else if (c->isdbt_partial_reception)
+		state->bw = MB86A20S_13SEG_PARTIAL;
+	else
+		state->bw = MB86A20S_13SEG;
+
+	if (c->inversion == INVERSION_ON)
+		state->inversion = true;
+	else
+		state->inversion = false;
+
+	if (!c->isdbt_sb_mode) {
+		state->subchannel = 0;
+	} else {
+		if (c->isdbt_sb_subchannel > ARRAY_SIZE(mb86a20s_subchannel))
+			c->isdbt_sb_subchannel = 0;
+
+		state->subchannel = mb86a20s_subchannel[c->isdbt_sb_subchannel];
+	}
+
 	/*
 	 * Gate should already be opened, but it doesn't hurt to
 	 * double-check
@@ -2058,7 +2110,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	/* Use dib8000 values per default */
 	.info = {
 		.name = "Fujitsu mb86A20s",
-		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_RECOVER |
+		.caps = FE_CAN_RECOVER  |
 			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
 			FE_CAN_QPSK     | FE_CAN_QAM_16  | FE_CAN_QAM_64 |
-- 
1.8.1.4

