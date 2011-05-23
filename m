Return-path: <mchehab@pedra>
Received: from mailfe05.c2i.net ([212.247.154.130]:60556 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754445Ab1EWLmJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:42:09 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] The dbg, warn and info macros are already defined by the USB stack. Rename these macros to avoid macro redefinition warnings. Refactor lineshift in printouts.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:40:56 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Ifk2NJGTJ5Be114"
Message-Id: <201105231340.56580.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Ifk2NJGTJ5Be114
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_Ifk2NJGTJ5Be114
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0010.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0010.patch"

=46rom c05334a4162912164d9e8d2d551f1bc2a5fdce82 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:40:00 +0200
Subject: [PATCH] The dbg, warn and info macros are already defined by the U=
SB stack. Rename these macros to avoid macro redefinition warnings. Refacto=
r lineshift in printouts.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/itd1000.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb/fron=
tends/itd1000.c
index f7a40a1..aa9ccb8 100644
=2D-- a/drivers/media/dvb/frontends/itd1000.c
+++ b/drivers/media/dvb/frontends/itd1000.c
@@ -35,21 +35,18 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
=20
=2D#define deb(args...)  do { \
+#define itd_dbg(args...)  do { \
 	if (debug) { \
 		printk(KERN_DEBUG   "ITD1000: " args);\
=2D		printk("\n"); \
 	} \
 } while (0)
=20
=2D#define warn(args...) do { \
+#define itd_warn(args...) do { \
 	printk(KERN_WARNING "ITD1000: " args); \
=2D	printk("\n"); \
 } while (0)
=20
=2D#define info(args...) do { \
+#define itd_info(args...) do { \
 	printk(KERN_INFO    "ITD1000: " args); \
=2D	printk("\n"); \
 } while (0)
=20
 /* don't write more than one byte with flexcop behind */
@@ -62,7 +59,7 @@ static int itd1000_write_regs(struct itd1000_state *state=
, u8 reg, u8 v[], u8 le
 	buf[0] =3D reg;
 	memcpy(&buf[1], v, len);
=20
=2D	/* deb("wr %02x: %02x", reg, v[0]); */
+	/* itd_dbg("wr %02x: %02x\n", reg, v[0]); */
=20
 	if (i2c_transfer(state->i2c, &msg, 1) !=3D 1) {
 		printk(KERN_WARNING "itd1000 I2C write failed\n");
@@ -83,7 +80,7 @@ static int itd1000_read_reg(struct itd1000_state *state, =
u8 reg)
 	itd1000_write_regs(state, (reg - 1) & 0xff, &state->shadow[(reg - 1) & 0x=
ff], 1);
=20
 	if (i2c_transfer(state->i2c, msg, 2) !=3D 2) {
=2D		warn("itd1000 I2C read failed");
+		itd_warn("itd1000 I2C read failed\n");
 		return -EREMOTEIO;
 	}
 	return val;
@@ -127,14 +124,14 @@ static void itd1000_set_lpf_bw(struct itd1000_state *=
state, u32 symbol_rate)
 	u8 bbgvmin =3D itd1000_read_reg(state, BBGVMIN) & 0xf0;
 	u8 bw      =3D itd1000_read_reg(state, BW)      & 0xf0;
=20
=2D	deb("symbol_rate =3D %d", symbol_rate);
+	itd_dbg("symbol_rate =3D %d\n", symbol_rate);
=20
 	/* not sure what is that ? - starting to download the table */
 	itd1000_write_reg(state, CON1, con1 | (1 << 1));
=20
 	for (i =3D 0; i < ARRAY_SIZE(itd1000_lpf_pga); i++)
 		if (symbol_rate < itd1000_lpf_pga[i].symbol_rate) {
=2D			deb("symrate: index: %d pgaext: %x, bbgvmin: %x", i, itd1000_lpf_pga[=
i].pgaext, itd1000_lpf_pga[i].bbgvmin);
+			itd_dbg("symrate: index: %d pgaext: %x, bbgvmin: %x\n", i, itd1000_lpf_=
pga[i].pgaext, itd1000_lpf_pga[i].bbgvmin);
 			itd1000_write_reg(state, PLLFH,   pllfh | (itd1000_lpf_pga[i].pgaext <<=
 4));
 			itd1000_write_reg(state, BBGVMIN, bbgvmin | (itd1000_lpf_pga[i].bbgvmin=
));
 			itd1000_write_reg(state, BW,      bw | (i & 0x0f));
@@ -182,7 +179,7 @@ static void itd1000_set_vco(struct itd1000_state *state=
, u32 freq_khz)
=20
 			adcout =3D itd1000_read_reg(state, PLLLOCK) & 0x0f;
=20
=2D			deb("VCO: %dkHz: %d -> ADCOUT: %d %02x", freq_khz, itd1000_vcorg[i].v=
corg, adcout, vco_chp1_i2c);
+			itd_dbg("VCO: %dkHz: %d -> ADCOUT: %d %02x\n", freq_khz, itd1000_vcorg[=
i].vcorg, adcout, vco_chp1_i2c);
=20
 			if (adcout > 13) {
 				if (!(itd1000_vcorg[i].vcorg =3D=3D 7 || itd1000_vcorg[i].vcorg =3D=3D=
 15))
@@ -232,7 +229,7 @@ static void itd1000_set_lo(struct itd1000_state *state,=
 u32 freq_khz)
 	pllf =3D (u32) tmp;
=20
 	state->frequency =3D ((plln * 1000) + (pllf * 1000)/1048576) * 2*FREF;
=2D	deb("frequency: %dkHz (wanted) %dkHz (set), PLLF =3D %d, PLLN =3D %d", =
freq_khz, state->frequency, pllf, plln);
+	itd_dbg("frequency: %dkHz (wanted) %dkHz (set), PLLF =3D %d, PLLN =3D %d\=
n", freq_khz, state->frequency, pllf, plln);
=20
 	itd1000_write_reg(state, PLLNH, 0x80); /* PLLNH */;
 	itd1000_write_reg(state, PLLNL, plln & 0xff);
@@ -242,7 +239,7 @@ static void itd1000_set_lo(struct itd1000_state *state,=
 u32 freq_khz)
=20
 	for (i =3D 0; i < ARRAY_SIZE(itd1000_fre_values); i++) {
 		if (freq_khz <=3D itd1000_fre_values[i].freq) {
=2D			deb("fre_values: %d", i);
+			itd_dbg("fre_values: %d\n", i);
 			itd1000_write_reg(state, RFTR, itd1000_fre_values[i].values[0]);
 			for (j =3D 0; j < 9; j++)
 				itd1000_write_reg(state, RFST1+j, itd1000_fre_values[i].values[j+1]);
@@ -382,7 +379,7 @@ struct dvb_frontend *itd1000_attach(struct dvb_frontend=
 *fe, struct i2c_adapter
 		kfree(state);
 		return NULL;
 	}
=2D	info("successfully identified (ID: %d)", i);
+	itd_info("successfully identified (ID: %d)\n", i);
=20
 	memset(state->shadow, 0xff, sizeof(state->shadow));
 	for (i =3D 0x65; i < 0x9c; i++)
=2D-=20
1.7.1.1


--Boundary-00=_Ifk2NJGTJ5Be114--
