Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38398 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdLZXiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:38:05 -0500
Received: by mail-wm0-f66.google.com with SMTP id 64so36828826wme.3
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 15:38:05 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 2/4] [media] dvb-frontends/stv0910: cleanup I2C access functions
Date: Wed, 27 Dec 2017 00:37:57 +0100
Message-Id: <20171226233759.16116-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171226233759.16116-1-d.scheller.oss@gmail.com>
References: <20171226233759.16116-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

write_reg() and i2c_write_reg16() only act as a proxy to i2c_write(), which
isn't called from anywhere else throughout the driver. Clean this up by
moving the message setup and the i2c_transfer() into write_reg() so it
becomes the only I2C write function. While touching those parts, fix the
error codes from EREMOTEIO to EIO.

The I2C cleanup is picked from the upstream dddvb.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index a6c473f3647f..06d2587125dd 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -137,33 +137,21 @@ struct slookup {
 	u32  reg_value;
 };
 
-static inline int i2c_write(struct i2c_adapter *adap, u8 adr,
-			    u8 *data, int len)
+static int write_reg(struct stv *state, u16 reg, u8 val)
 {
-	struct i2c_msg msg = {.addr = adr, .flags = 0,
-			      .buf = data, .len = len};
+	struct i2c_adapter *adap = state->base->i2c;
+	u8 data[3] = {reg >> 8, reg & 0xff, val};
+	struct i2c_msg msg = {.addr = state->base->adr, .flags = 0,
+			      .buf = data, .len = 3};
 
 	if (i2c_transfer(adap, &msg, 1) != 1) {
 		dev_warn(&adap->dev, "i2c write error ([%02x] %04x: %02x)\n",
-			 adr, (data[0] << 8) | data[1],
-			 (len > 2 ? data[2] : 0));
-		return -EREMOTEIO;
+			 state->base->adr, reg, val);
+		return -EIO;
 	}
 	return 0;
 }
 
-static int i2c_write_reg16(struct i2c_adapter *adap, u8 adr, u16 reg, u8 val)
-{
-	u8 msg[3] = {reg >> 8, reg & 0xff, val};
-
-	return i2c_write(adap, adr, msg, 3);
-}
-
-static int write_reg(struct stv *state, u16 reg, u8 val)
-{
-	return i2c_write_reg16(state->base->i2c, state->base->adr, reg, val);
-}
-
 static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
 				  u16 reg, u8 *val, int count)
 {
@@ -176,7 +164,7 @@ static inline int i2c_read_regs16(struct i2c_adapter *adapter, u8 adr,
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
 		dev_warn(&adapter->dev, "i2c read error ([%02x] %04x)\n",
 			 adr, reg);
-		return -EREMOTEIO;
+		return -EIO;
 	}
 	return 0;
 }
-- 
2.13.6
