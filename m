Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab1AMSOQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 13:14:16 -0500
Date: Thu, 13 Jan 2011 16:13:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: mkrufky@kernellabs.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] tda8290: Make all read operations atomic
Message-ID: <20110113161333.1370919b@pedra>
In-Reply-To: <7c3d11fc6242f190067a9c64cb2b3ba670e51739.1294942291.git.mchehab@redhat.com>
References: <7c3d11fc6242f190067a9c64cb2b3ba670e51739.1294942291.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Read operations should be preceeded by a write operation. However,
nothing prevents that an I2C operation could happen between the two
transactions.

To avoid that problem, use an unique I2C transfer for both parts of
the I2C transaction.

Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index c9062ce..5f889c1 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -95,8 +95,7 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
 		msleep(20);
 	} else {
 		msg = disable;
-		tuner_i2c_xfer_send(&priv->i2c_props, msg, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &msg[1], 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props, msg, 1, &msg[1], 1);
 
 		buf[2] = msg[1];
 		buf[2] &= ~0x04;
@@ -239,13 +238,15 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 		fe->ops.tuner_ops.set_analog_params(fe, params);
 
 	for (i = 0; i < 3; i++) {
-		tuner_i2c_xfer_send(&priv->i2c_props, &addr_pll_stat, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &pll_stat, 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props,
+					 &addr_pll_stat, 1, &pll_stat, 1);
 		if (pll_stat & 0x80) {
-			tuner_i2c_xfer_send(&priv->i2c_props, &addr_adc_sat, 1);
-			tuner_i2c_xfer_recv(&priv->i2c_props, &adc_sat, 1);
-			tuner_i2c_xfer_send(&priv->i2c_props, &addr_agc_stat, 1);
-			tuner_i2c_xfer_recv(&priv->i2c_props, &agc_stat, 1);
+			tuner_i2c_xfer_send_recv(&priv->i2c_props,
+						 &addr_adc_sat, 1,
+						 &adc_sat, 1);
+			tuner_i2c_xfer_send_recv(&priv->i2c_props,
+						 &addr_agc_stat, 1,
+						 &agc_stat, 1);
 			tuner_dbg("tda8290 is locked, AGC: %d\n", agc_stat);
 			break;
 		} else {
@@ -259,20 +260,22 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 			   agc_stat, adc_sat, pll_stat & 0x80);
 		tuner_i2c_xfer_send(&priv->i2c_props, gainset_2, 2);
 		msleep(100);
-		tuner_i2c_xfer_send(&priv->i2c_props, &addr_agc_stat, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &agc_stat, 1);
-		tuner_i2c_xfer_send(&priv->i2c_props, &addr_pll_stat, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &pll_stat, 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props,
+					 &addr_agc_stat, 1, &agc_stat, 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props,
+					 &addr_pll_stat, 1, &pll_stat, 1);
 		if ((agc_stat > 115) || !(pll_stat & 0x80)) {
 			tuner_dbg("adjust gain, step 2. Agc: %d, lock: %d\n",
 				   agc_stat, pll_stat & 0x80);
 			if (priv->cfg.agcf)
 				priv->cfg.agcf(fe);
 			msleep(100);
-			tuner_i2c_xfer_send(&priv->i2c_props, &addr_agc_stat, 1);
-			tuner_i2c_xfer_recv(&priv->i2c_props, &agc_stat, 1);
-			tuner_i2c_xfer_send(&priv->i2c_props, &addr_pll_stat, 1);
-			tuner_i2c_xfer_recv(&priv->i2c_props, &pll_stat, 1);
+			tuner_i2c_xfer_send_recv(&priv->i2c_props,
+						 &addr_agc_stat, 1,
+						 &agc_stat, 1);
+			tuner_i2c_xfer_send_recv(&priv->i2c_props,
+						 &addr_pll_stat, 1,
+						 &pll_stat, 1);
 			if((agc_stat > 115) || !(pll_stat & 0x80)) {
 				tuner_dbg("adjust gain, step 3. Agc: %d\n", agc_stat);
 				tuner_i2c_xfer_send(&priv->i2c_props, adc_head_12, 2);
@@ -284,10 +287,12 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 
 	/* l/ l' deadlock? */
 	if(priv->tda8290_easy_mode & 0x60) {
-		tuner_i2c_xfer_send(&priv->i2c_props, &addr_adc_sat, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &adc_sat, 1);
-		tuner_i2c_xfer_send(&priv->i2c_props, &addr_pll_stat, 1);
-		tuner_i2c_xfer_recv(&priv->i2c_props, &pll_stat, 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props,
+					 &addr_adc_sat, 1,
+					 &adc_sat, 1);
+		tuner_i2c_xfer_send_recv(&priv->i2c_props,
+					 &addr_pll_stat, 1,
+					 &pll_stat, 1);
 		if ((adc_sat > 20) || !(pll_stat & 0x80)) {
 			tuner_dbg("trying to resolve SECAM L deadlock\n");
 			tuner_i2c_xfer_send(&priv->i2c_props, agc_rst_on, 2);
@@ -307,8 +312,7 @@ static void tda8295_power(struct dvb_frontend *fe, int enable)
 	struct tda8290_priv *priv = fe->analog_demod_priv;
 	unsigned char buf[] = { 0x30, 0x00 }; /* clb_stdbt */
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &buf[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &buf[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props, &buf[0], 1, &buf[1], 1);
 
 	if (enable)
 		buf[1] = 0x01;
@@ -323,8 +327,7 @@ static void tda8295_set_easy_mode(struct dvb_frontend *fe, int enable)
 	struct tda8290_priv *priv = fe->analog_demod_priv;
 	unsigned char buf[] = { 0x01, 0x00 };
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &buf[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &buf[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props, &buf[0], 1, &buf[1], 1);
 
 	if (enable)
 		buf[1] = 0x01; /* rising edge sets regs 0x02 - 0x23 */
@@ -353,8 +356,7 @@ static void tda8295_agc1_out(struct dvb_frontend *fe, int enable)
 	struct tda8290_priv *priv = fe->analog_demod_priv;
 	unsigned char buf[] = { 0x02, 0x00 }; /* DIV_FUNC */
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &buf[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &buf[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props, &buf[0], 1, &buf[1], 1);
 
 	if (enable)
 		buf[1] &= ~0x40;
@@ -370,10 +372,10 @@ static void tda8295_agc2_out(struct dvb_frontend *fe, int enable)
 	unsigned char set_gpio_cf[]    = { 0x44, 0x00 };
 	unsigned char set_gpio_val[]   = { 0x46, 0x00 };
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &set_gpio_cf[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &set_gpio_cf[1], 1);
-	tuner_i2c_xfer_send(&priv->i2c_props, &set_gpio_val[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &set_gpio_val[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props,
+				 &set_gpio_cf[0], 1, &set_gpio_cf[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props,
+				 &set_gpio_val[0], 1, &set_gpio_val[1], 1);
 
 	set_gpio_cf[1] &= 0xf0; /* clear GPIO_0 bits 3-0 */
 
@@ -392,8 +394,7 @@ static int tda8295_has_signal(struct dvb_frontend *fe)
 	unsigned char hvpll_stat = 0x26;
 	unsigned char ret;
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &hvpll_stat, 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &ret, 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props, &hvpll_stat, 1, &ret, 1);
 	return (ret & 0x01) ? 65535 : 0;
 }
 
@@ -413,8 +414,8 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 	tda8295_power(fe, 1);
 	tda8295_agc1_out(fe, 1);
 
-	tuner_i2c_xfer_send(&priv->i2c_props, &blanking_mode[0], 1);
-	tuner_i2c_xfer_recv(&priv->i2c_props, &blanking_mode[1], 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props,
+				 &blanking_mode[0], 1, &blanking_mode[1], 1);
 
 	tda8295_set_video_std(fe);
 
@@ -447,8 +448,8 @@ static int tda8290_has_signal(struct dvb_frontend *fe)
 	unsigned char i2c_get_afc[1] = { 0x1B };
 	unsigned char afc = 0;
 
-	tuner_i2c_xfer_send(&priv->i2c_props, i2c_get_afc, ARRAY_SIZE(i2c_get_afc));
-	tuner_i2c_xfer_recv(&priv->i2c_props, &afc, 1);
+	tuner_i2c_xfer_send_recv(&priv->i2c_props,
+				 i2c_get_afc, ARRAY_SIZE(i2c_get_afc), &afc, 1);
 	return (afc & 0x80)? 65535:0;
 }
 
@@ -654,20 +655,26 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 static int tda8290_probe(struct tuner_i2c_props *i2c_props)
 {
 #define TDA8290_ID 0x89
-	unsigned char tda8290_id[] = { 0x1f, 0x00 };
+	u8 reg = 0x1f, id;
+	struct i2c_msg msg_read[] = {
+		{ .addr = 0x4b, .flags = 0, .len = 1, .buf = &reg },
+		{ .addr = 0x4b, .flags = I2C_M_RD, .len = 1, .buf = &id },
+	};
 
 	/* detect tda8290 */
-	tuner_i2c_xfer_send(i2c_props, &tda8290_id[0], 1);
-	tuner_i2c_xfer_recv(i2c_props, &tda8290_id[1], 1);
+	if (i2c_transfer(i2c_props->adap, msg_read, 2) != 2) {
+		printk(KERN_WARNING "%s: tda8290 couldn't read register 0x%02x\n",
+			       __func__, reg);
+		return -ENODEV;
+	}
 
-	if (tda8290_id[1] == TDA8290_ID) {
+	if (id == TDA8290_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: tda8290 detected @ %d-%04x\n",
 			       __func__, i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
 		return 0;
 	}
-
 	return -ENODEV;
 }
 
@@ -675,16 +682,23 @@ static int tda8295_probe(struct tuner_i2c_props *i2c_props)
 {
 #define TDA8295_ID 0x8a
 #define TDA8295C2_ID 0x8b
-	unsigned char tda8295_id[] = { 0x2f, 0x00 };
+	u8 reg = 0x2f, id;
+	struct i2c_msg msg_read[] = {
+		{ .addr = 0x4b, .flags = 0, .len = 1, .buf = &reg },
+		{ .addr = 0x4b, .flags = I2C_M_RD, .len = 1, .buf = &id },
+	};
 
-	/* detect tda8295 */
-	tuner_i2c_xfer_send(i2c_props, &tda8295_id[0], 1);
-	tuner_i2c_xfer_recv(i2c_props, &tda8295_id[1], 1);
+	/* detect tda8290 */
+	if (i2c_transfer(i2c_props->adap, msg_read, 2) != 2) {
+		printk(KERN_WARNING "%s: tda8290 couldn't read register 0x%02x\n",
+			       __func__, reg);
+		return -ENODEV;
+	}
 
-	if ((tda8295_id[1] & 0xfe) == TDA8295_ID) {
+	if ((id & 0xfe) == TDA8295_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: %s detected @ %d-%04x\n",
-			       __func__, (tda8295_id[1] == TDA8295_ID) ?
+			       __func__, (id == TDA8295_ID) ?
 			       "tda8295c1" : "tda8295c2",
 			       i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
@@ -809,8 +823,8 @@ int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr)
 	int i;
 
 	/* rule out tda9887, which would return the same byte repeatedly */
-	tuner_i2c_xfer_send(&i2c_props, soft_reset, 1);
-	tuner_i2c_xfer_recv(&i2c_props, buf, PROBE_BUFFER_SIZE);
+	tuner_i2c_xfer_send_recv(&i2c_props,
+				 soft_reset, 1, buf, PROBE_BUFFER_SIZE);
 	for (i = 1; i < PROBE_BUFFER_SIZE; i++) {
 		if (buf[i] != buf[0])
 			break;
@@ -827,13 +841,12 @@ int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr)
 	/* fall back to old probing method */
 	tuner_i2c_xfer_send(&i2c_props, easy_mode_b, 2);
 	tuner_i2c_xfer_send(&i2c_props, soft_reset, 2);
-	tuner_i2c_xfer_send(&i2c_props, &addr_dto_lsb, 1);
-	tuner_i2c_xfer_recv(&i2c_props, &data, 1);
+	tuner_i2c_xfer_send_recv(&i2c_props, &addr_dto_lsb, 1, &data, 1);
 	if (data == 0) {
 		tuner_i2c_xfer_send(&i2c_props, easy_mode_g, 2);
 		tuner_i2c_xfer_send(&i2c_props, soft_reset, 2);
-		tuner_i2c_xfer_send(&i2c_props, &addr_dto_lsb, 1);
-		tuner_i2c_xfer_recv(&i2c_props, &data, 1);
+		tuner_i2c_xfer_send_recv(&i2c_props,
+					 &addr_dto_lsb, 1, &data, 1);
 		if (data == 0x7b) {
 			return 0;
 		}
-- 
1.7.1


