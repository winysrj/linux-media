Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab2F2VwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 17:52:01 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5TLq1h6015416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 17:52:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] drxk: pass drxk priv struct instead of I2C adapter to i2c calls
Date: Fri, 29 Jun 2012 18:51:55 -0300
Message-Id: <1341006717-32373-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341006717-32373-1-git-send-email-mchehab@redhat.com>
References: <20120629124719.2cf23f6b@endymion.delvare>
 <1341006717-32373-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As it will be using the unlocked version of i2c_transfer during
firmware loads, make sure that the priv state routine will be
used on all I2C calls, in preparation for the next patch that
will implement an exclusive lock mode to be used during firmware
load, at drxk_init.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   34 ++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 4cb8d1e..5b3a17c 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -308,16 +308,22 @@ static u32 Log10Times100(u32 x)
 /* I2C **********************************************************************/
 /****************************************************************************/
 
-static int i2c_read1(struct i2c_adapter *adapter, u8 adr, u8 *val)
+static int drxk_i2c_transfer(struct drxk_state *state, struct i2c_msg *msgs,
+			     unsigned len)
+{
+	return i2c_transfer(state->i2c, msgs, len);
+}
+
+static int i2c_read1(struct drxk_state *state, u8 adr, u8 *val)
 {
 	struct i2c_msg msgs[1] = { {.addr = adr, .flags = I2C_M_RD,
 				    .buf = val, .len = 1}
 	};
 
-	return i2c_transfer(adapter, msgs, 1);
+	return drxk_i2c_transfer(state, msgs, 1);
 }
 
-static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+static int i2c_write(struct drxk_state *state, u8 adr, u8 *data, int len)
 {
 	int status;
 	struct i2c_msg msg = {
@@ -330,7 +336,7 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 			printk(KERN_CONT " %02x", data[i]);
 		printk(KERN_CONT "\n");
 	}
-	status = i2c_transfer(adap, &msg, 1);
+	status = drxk_i2c_transfer(state, &msg, 1);
 	if (status >= 0 && status != 1)
 		status = -EIO;
 
@@ -340,7 +346,7 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 	return status;
 }
 
-static int i2c_read(struct i2c_adapter *adap,
+static int i2c_read(struct drxk_state *state,
 		    u8 adr, u8 *msg, int len, u8 *answ, int alen)
 {
 	int status;
@@ -351,7 +357,7 @@ static int i2c_read(struct i2c_adapter *adap,
 		 .buf = answ, .len = alen}
 	};
 
-	status = i2c_transfer(adap, msgs, 2);
+	status = drxk_i2c_transfer(state, msgs, 2);
 	if (status != 2) {
 		if (debug > 2)
 			printk(KERN_CONT ": ERROR!\n");
@@ -394,7 +400,7 @@ static int read16_flags(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 		len = 2;
 	}
 	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
-	status = i2c_read(state->i2c, adr, mm1, len, mm2, 2);
+	status = i2c_read(state, adr, mm1, len, mm2, 2);
 	if (status < 0)
 		return status;
 	if (data)
@@ -428,7 +434,7 @@ static int read32_flags(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 		len = 2;
 	}
 	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
-	status = i2c_read(state->i2c, adr, mm1, len, mm2, 4);
+	status = i2c_read(state, adr, mm1, len, mm2, 4);
 	if (status < 0)
 		return status;
 	if (data)
@@ -464,7 +470,7 @@ static int write16_flags(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 	mm[len + 1] = (data >> 8) & 0xff;
 
 	dprintk(2, "(0x%08x, 0x%04x, 0x%02x)\n", reg, data, flags);
-	return i2c_write(state->i2c, adr, mm, len + 2);
+	return i2c_write(state, adr, mm, len + 2);
 }
 
 static int write16(struct drxk_state *state, u32 reg, u16 data)
@@ -495,7 +501,7 @@ static int write32_flags(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 	mm[len + 3] = (data >> 24) & 0xff;
 	dprintk(2, "(0x%08x, 0x%08x, 0x%02x)\n", reg, data, flags);
 
-	return i2c_write(state->i2c, adr, mm, len + 4);
+	return i2c_write(state, adr, mm, len + 4);
 }
 
 static int write32(struct drxk_state *state, u32 reg, u32 data)
@@ -542,7 +548,7 @@ static int write_block(struct drxk_state *state, u32 Address,
 					printk(KERN_CONT " %02x", pBlock[i]);
 			printk(KERN_CONT "\n");
 		}
-		status = i2c_write(state->i2c, state->demod_address,
+		status = i2c_write(state, state->demod_address,
 				   &state->Chunk[0], Chunk + AdrLength);
 		if (status < 0) {
 			printk(KERN_ERR "drxk: %s: i2c write error at addr 0x%02x\n",
@@ -568,17 +574,17 @@ int PowerUpDevice(struct drxk_state *state)
 
 	dprintk(1, "\n");
 
-	status = i2c_read1(state->i2c, state->demod_address, &data);
+	status = i2c_read1(state, state->demod_address, &data);
 	if (status < 0) {
 		do {
 			data = 0;
-			status = i2c_write(state->i2c, state->demod_address,
+			status = i2c_write(state, state->demod_address,
 					   &data, 1);
 			msleep(10);
 			retryCount++;
 			if (status < 0)
 				continue;
-			status = i2c_read1(state->i2c, state->demod_address,
+			status = i2c_read1(state, state->demod_address,
 					   &data);
 		} while (status < 0 &&
 			 (retryCount < DRXK_MAX_RETRIES_POWERUP));
-- 
1.7.10.2

