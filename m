Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49408 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2L2L5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 06:57:14 -0500
Received: by mail-ea0-f180.google.com with SMTP id f13so4530095eai.11
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 03:57:12 -0800 (PST)
Message-ID: <1356780864.2762.8.camel@canaries64>
Subject: [PATCH] lmedm04: correct I2C values to 7 bit addressing.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 29 Dec 2012 11:34:24 +0000
In-Reply-To: <20121228220426.0330ce40@infradead.org>
References: <1541475.yBqmJOQMfq@useri>
	 <20121227193338.4e14c1d6@infradead.org> <13048798.3Y05dB7H81@useri>
	 <20121228220426.0330ce40@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-12-28 at 22:04 -0200, Mauro Carvalho Chehab wrote:
> Em Sat, 29 Dec 2012 01:06:29 +0300
> "Igor M. Liplianin" <liplianin@me.by> escreveu:
> 
> > On 27 Ð´ÐµÐºÐ°Ð±Ñ€Ñ_ 2012 19:33:38 Mauro Carvalho Chehab wrote:
> > > Hi Igor,
> > Hi Mauro,
> > 
> > > 
> > > Em Mon, 24 Dec 2012 11:23:56 +0300
> > > 
> > > "Igor M. Liplianin" <liplianin@me.by> escreveu:
> > > > The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:
> > > >   [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)
> > > > 
> > > > are available in the git repository at:
> > > >   git://git.linuxtv.org/liplianin/media_tree.git ts2020_v3.9
> > > > 
> > > > for you to fetch changes up to 2ff52e6f487c2ee841f3df9709d1b4e4416a1b15:
> > > >   ts2020: separate from m88rs2000 (2012-12-24 01:26:12 +0300)
> > > > 
> 
> Applied, thanks.
Hi all,

The separation the lmedm04 fails on the ts2020 portion because the correct
I2C addressing.

So, it's time to correct the addressing in the remainder of lmedm04.

Tested all tuners.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index b5e1f73..f30c58c 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -627,8 +627,8 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		gate = 5;
 
 	for (i = 0; i < num; i++) {
-		read_o = 1 & (msg[i].flags & I2C_M_RD);
-		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
+		read_o = msg[i].flags & I2C_M_RD;
+		read = i + 1 < num && msg[i + 1].flags & I2C_M_RD;
 		read |= read_o;
 		gate = (msg[i].addr == st->i2c_tuner_addr)
 			? (read)	? st->i2c_tuner_gate_r
@@ -641,7 +641,8 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		else
 			obuf[1] = msg[i].len + read + 1;
 
-		obuf[2] = msg[i].addr;
+		obuf[2] = msg[i].addr << 1;
+
 		if (read) {
 			if (read_o)
 				len = 3;
@@ -895,27 +896,27 @@ static int lme2510_kill_urb(struct usb_data_stream *stream)
 }
 
 static struct tda10086_config tda10086_config = {
-	.demod_address = 0x1c,
+	.demod_address = 0x0e,
 	.invert = 0,
 	.diseqc_tone = 1,
 	.xtal_freq = TDA10086_XTAL_16M,
 };
 
 static struct stv0288_config lme_config = {
-	.demod_address = 0xd0,
+	.demod_address = 0x68,
 	.min_delay_ms = 15,
 	.inittab = s7395_inittab,
 };
 
 static struct ix2505v_config lme_tuner = {
-	.tuner_address = 0xc0,
+	.tuner_address = 0x60,
 	.min_delay_ms = 100,
 	.tuner_gain = 0x0,
 	.tuner_chargepump = 0x3,
 };
 
 static struct stv0299_config sharp_z0194_config = {
-	.demod_address = 0xd0,
+	.demod_address = 0x68,
 	.inittab = sharp_z0194a_inittab,
 	.mclk = 88000000UL,
 	.invert = 0,
@@ -944,7 +945,7 @@ static int dm04_rs2000_set_ts_param(struct dvb_frontend *fe,
 }
 
 static struct m88rs2000_config m88rs2000_config = {
-	.demod_addr = 0xd0,
+	.demod_addr = 0x68,
 	.set_ts_params = dm04_rs2000_set_ts_param,
 };
 
@@ -1054,7 +1055,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			info("TUN Found Frontend TDA10086");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 4;
-			st->i2c_tuner_addr = 0xc0;
+			st->i2c_tuner_addr = 0x60;
 			st->tuner_config = TUNER_LG;
 			if (st->dvb_usb_lme2510_firmware != TUNER_LG) {
 				st->dvb_usb_lme2510_firmware = TUNER_LG;
@@ -1070,7 +1071,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			info("FE Found Stv0299");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 5;
-			st->i2c_tuner_addr = 0xc0;
+			st->i2c_tuner_addr = 0x60;
 			st->tuner_config = TUNER_S0194;
 			if (st->dvb_usb_lme2510_firmware != TUNER_S0194) {
 				st->dvb_usb_lme2510_firmware = TUNER_S0194;
@@ -1087,7 +1088,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			info("FE Found Stv0288");
 			st->i2c_tuner_gate_w = 4;
 			st->i2c_tuner_gate_r = 5;
-			st->i2c_tuner_addr = 0xc0;
+			st->i2c_tuner_addr = 0x60;
 			st->tuner_config = TUNER_S7395;
 			if (st->dvb_usb_lme2510_firmware != TUNER_S7395) {
 				st->dvb_usb_lme2510_firmware = TUNER_S7395;
@@ -1106,7 +1107,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 					&d->i2c_adap);
 			st->i2c_tuner_gate_w = 5;
 			st->i2c_tuner_gate_r = 5;
-			st->i2c_tuner_addr = 0xc0;
+			st->i2c_tuner_addr = 0x60;
 			st->tuner_config = TUNER_RS2000;
 			st->fe_set_voltage =
 				adap->fe[0]->ops.set_voltage;
@@ -1151,7 +1152,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 
 	switch (st->tuner_config) {
 	case TUNER_LG:
-		if (dvb_attach(tda826x_attach, adap->fe[0], 0xc0,
+		if (dvb_attach(tda826x_attach, adap->fe[0], 0x60,
 			&d->i2c_adap, 1))
 			ret = st->tuner_config;
 		break;
@@ -1161,7 +1162,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 			ret = st->tuner_config;
 		break;
 	case TUNER_S0194:
-		if (dvb_attach(dvb_pll_attach , adap->fe[0], 0xc0,
+		if (dvb_attach(dvb_pll_attach , adap->fe[0], 0x60,
 			&d->i2c_adap, DVB_PLL_OPERA1))
 			ret = st->tuner_config;
 		break;
-- 
1.8.0




