Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60347 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbbCXVNK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/8] ts2020: do not use i2c_transfer() on sleep()
Date: Tue, 24 Mar 2015 23:12:13 +0200
Message-Id: <1427231533-4277-9-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to use bulk i2c_transfer() to write single register.
Use write register function instead.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index b1d91dc..90164a3 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -123,29 +123,14 @@ static int ts2020_readreg(struct dvb_frontend *fe, u8 reg)
 static int ts2020_sleep(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
-	int ret;
-	u8 buf[] = { 10, 0 };
-	struct i2c_msg msg = {
-		.addr = priv->i2c_address,
-		.flags = 0,
-		.buf = buf,
-		.len = 2
-	};
-
-	if (priv->tuner == TS2020_M88TS2022)
-		buf[0] = 0x00;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	ret = i2c_transfer(priv->i2c, &msg, 1);
-	if (ret != 1)
-		printk(KERN_ERR "%s: i2c error\n", __func__);
+	u8 u8tmp;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	if (priv->tuner == TS2020_M88TS2020)
+		u8tmp = 0x0a; /* XXX: probably wrong */
+	else
+		u8tmp = 0x00;
 
-	return (ret == 1) ? 0 : ret;
+	return ts2020_writereg(fe, u8tmp, 0x00);
 }
 
 static int ts2020_init(struct dvb_frontend *fe)
-- 
http://palosaari.fi/

