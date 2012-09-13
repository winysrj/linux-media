Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58342 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab2IMAYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/16] ec100: improve I2C routines
Date: Thu, 13 Sep 2012 03:23:45 +0300
Message-Id: <1347495837-3244-4-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ec100.c | 45 ++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/ec100.c b/drivers/media/dvb-frontends/ec100.c
index b4ea34c..9d42480 100644
--- a/drivers/media/dvb-frontends/ec100.c
+++ b/drivers/media/dvb-frontends/ec100.c
@@ -33,24 +33,33 @@ struct ec100_state {
 /* write single register */
 static int ec100_write_reg(struct ec100_state *state, u8 reg, u8 val)
 {
+	int ret;
 	u8 buf[2] = {reg, val};
-	struct i2c_msg msg = {
-		.addr = state->config.demod_address,
-		.flags = 0,
-		.len = 2,
-		.buf = buf};
-
-	if (i2c_transfer(state->i2c, &msg, 1) != 1) {
-		dev_warn(&state->i2c->dev, "%s: i2c wr failed reg=%02x\n",
-				KBUILD_MODNAME, reg);
-		return -EREMOTEIO;
+	struct i2c_msg msg[1] = {
+		{
+			.addr = state->config.demod_address,
+			.flags = 0,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 1);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		dev_warn(&state->i2c->dev, "%s: i2c wr failed=%d reg=%02x\n",
+				KBUILD_MODNAME, ret, reg);
+		ret = -EREMOTEIO;
 	}
-	return 0;
+
+	return ret;
 }
 
 /* read single register */
 static int ec100_read_reg(struct ec100_state *state, u8 reg, u8 *val)
 {
+	int ret;
 	struct i2c_msg msg[2] = {
 		{
 			.addr = state->config.demod_address,
@@ -65,12 +74,16 @@ static int ec100_read_reg(struct ec100_state *state, u8 reg, u8 *val)
 		}
 	};
 
-	if (i2c_transfer(state->i2c, msg, 2) != 2) {
-		dev_warn(&state->i2c->dev, "%s: i2c rd failed reg=%02x\n",
-				KBUILD_MODNAME, reg);
-		return -EREMOTEIO;
+	ret = i2c_transfer(state->i2c, msg, 2);
+	if (ret == 2) {
+		ret = 0;
+	} else {
+		dev_warn(&state->i2c->dev, "%s: i2c rd failed=%d reg=%02x\n",
+				KBUILD_MODNAME, ret, reg);
+		ret = -EREMOTEIO;
 	}
-	return 0;
+
+	return ret;
 }
 
 static int ec100_set_frontend(struct dvb_frontend *fe)
-- 
1.7.11.4

