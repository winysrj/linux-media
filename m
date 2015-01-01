Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbAAPvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 10:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] mb86a20s: remove two uneeded macros
Date: Thu,  1 Jan 2015 13:51:24 -0200
Message-Id: <216db047d8a0780a050a6d4d5d7cabb2e25f949e.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two macros that are there just to simplify the parameter
passage. Remove them, as the i2c address is already inside the
i2c client structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 8dd608be1edd..7d6a688f6f12 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -224,12 +224,12 @@ static struct regdata mb86a20s_per_ber_reset[] = {
  * I2C read/write functions and macros
  */
 
-static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
-			     u8 i2c_addr, u8 reg, u8 data)
+static int mb86a20s_writereg(struct mb86a20s_state *state,
+			     u8 reg, u8 data)
 {
 	u8 buf[] = { reg, data };
 	struct i2c_msg msg = {
-		.addr = i2c_addr, .flags = 0, .buf = buf, .len = 2
+		.addr = state->i2c->addr, .flags = 0, .buf = buf, .len = 2
 	};
 	int rc;
 
@@ -245,27 +245,25 @@ static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 }
 
 static int mb86a20s_i2c_writeregdata(struct mb86a20s_state *state,
-				     u8 i2c_addr, struct regdata *rd, int size)
+				 struct regdata *rd, int size)
 {
 	int i, rc;
 
 	for (i = 0; i < size; i++) {
-		rc = mb86a20s_i2c_writereg(state, i2c_addr, rd[i].reg,
-					   rd[i].data);
+		rc = mb86a20s_writereg(state, rd[i].reg, rd[i].data);
 		if (rc < 0)
 			return rc;
 	}
 	return 0;
 }
 
-static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
-				u8 i2c_addr, u8 reg)
+static int mb86a20s_readreg(struct mb86a20s_state *state, u8 reg)
 {
 	u8 val;
 	int rc;
 	struct i2c_msg msg[] = {
-		{ .addr = i2c_addr, .flags = 0, .buf = &reg, .len = 1 },
-		{ .addr = i2c_addr, .flags = I2C_M_RD, .buf = &val, .len = 1 }
+		{ .addr = state->i2c->addr, .flags = 0, .buf = &reg, .len = 1 },
+		{ .addr = state->i2c->addr, .flags = I2C_M_RD, .buf = &val, .len = 1 }
 	};
 
 	rc = i2c_transfer(state->i2c->adapter, msg, 2);
@@ -279,12 +277,8 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	return val;
 }
 
-#define mb86a20s_readreg(state, reg) \
-	mb86a20s_i2c_readreg(state, state->i2c->addr, reg)
-#define mb86a20s_writereg(state, reg, val) \
-	mb86a20s_i2c_writereg(state, state->i2c->addr, reg, val)
 #define mb86a20s_writeregdata(state, regdata) \
-	mb86a20s_i2c_writeregdata(state, state->i2c->addr, \
+	mb86a20s_i2c_writeregdata(state, \
 	regdata, ARRAY_SIZE(regdata))
 
 /*
-- 
2.1.0

