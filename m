Return-path: <mchehab@pedra>
Received: from mailfe01.c2i.net ([212.247.154.2]:51740 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751116Ab1EWK7W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 06:59:22 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] The info and err macros are already defined by the USB stack. Rename these macros to avoid macro redefinition warnings.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:58:07 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/2j2NFSzRbAXRyf"
Message-Id: <201105231258.07403.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_/2j2NFSzRbAXRyf
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_/2j2NFSzRbAXRyf
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="dvb-usb-0003.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvb-usb-0003.patch"

=46rom 83b2408914b9c02600c8288459ed869037efd1dd Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:54:21 +0200
Subject: [PATCH] The info and err macros are already defined by the USB sta=
ck. Rename these macros to avoid macro redefinition warnings.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/cx24123.c        |   34 +++++++++++++---------=
=2D---
 drivers/media/dvb/frontends/dib3000mb.c      |   12 ++++----
 drivers/media/dvb/frontends/dib3000mb_priv.h |   10 +++----
 3 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/fron=
tends/cx24123.c
index b1dd8ac..b73fb90 100644
=2D-- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -41,8 +41,8 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
=20
=2D#define info(args...) do { printk(KERN_INFO "CX24123: " args); } while (=
0)
=2D#define err(args...)  do { printk(KERN_ERR  "CX24123: " args); } while (=
0)
+#define cx_info(args...) do { printk(KERN_INFO "CX24123: " args); } while =
(0)
+#define cx_err(args...)  do { printk(KERN_ERR  "CX24123: " args); } while =
(0)
=20
 #define dprintk(args...) \
 	do { \
@@ -274,7 +274,7 @@ static int cx24123_i2c_readreg(struct cx24123_state *st=
ate, u8 i2c_addr, u8 reg)
 	ret =3D i2c_transfer(state->i2c, msg, 2);
=20
 	if (ret !=3D 2) {
=2D		err("%s: reg=3D0x%x (error=3D%d)\n", __func__, reg, ret);
+		cx_err("%s: reg=3D0x%x (error=3D%d)\n", __func__, reg, ret);
 		return ret;
 	}
=20
@@ -620,7 +620,7 @@ static int cx24123_pll_writereg(struct dvb_frontend *fe,
 	cx24123_writereg(state, 0x22, (data >> 16) & 0xff);
 	while ((cx24123_readreg(state, 0x20) & 0x40) =3D=3D 0) {
 		if (time_after(jiffies, timeout)) {
=2D			err("%s:  demodulator is not responding, "\
+			cx_err("%s:  demodulator is not responding, "\
 				"possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
@@ -632,7 +632,7 @@ static int cx24123_pll_writereg(struct dvb_frontend *fe,
 	cx24123_writereg(state, 0x22, (data >> 8) & 0xff);
 	while ((cx24123_readreg(state, 0x20) & 0x40) =3D=3D 0) {
 		if (time_after(jiffies, timeout)) {
=2D			err("%s:  demodulator is not responding, "\
+			cx_err("%s:  demodulator is not responding, "\
 				"possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
@@ -645,7 +645,7 @@ static int cx24123_pll_writereg(struct dvb_frontend *fe,
 	cx24123_writereg(state, 0x22, (data) & 0xff);
 	while ((cx24123_readreg(state, 0x20) & 0x80)) {
 		if (time_after(jiffies, timeout)) {
=2D			err("%s:  demodulator is not responding," \
+			cx_err("%s:  demodulator is not responding," \
 				"possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
@@ -668,7 +668,7 @@ static int cx24123_pll_tune(struct dvb_frontend *fe,
 	dprintk("frequency=3D%i\n", p->frequency);
=20
 	if (cx24123_pll_calculate(fe, p) !=3D 0) {
=2D		err("%s: cx24123_pll_calcutate failed\n", __func__);
+		cx_err("%s: cx24123_pll_calcutate failed\n", __func__);
 		return -EINVAL;
 	}
=20
@@ -765,7 +765,7 @@ static void cx24123_wait_for_diseqc(struct cx24123_stat=
e *state)
 	unsigned long timeout =3D jiffies + msecs_to_jiffies(200);
 	while (!(cx24123_readreg(state, 0x29) & 0x40)) {
 		if (time_after(jiffies, timeout)) {
=2D			err("%s: diseqc queue not ready, " \
+			cx_err("%s: diseqc queue not ready, " \
 				"command may be lost.\n", __func__);
 			break;
 		}
@@ -947,7 +947,7 @@ static int cx24123_set_frontend(struct dvb_frontend *fe,
 	else if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe, p);
 	else
=2D		err("it seems I don't have a tuner...");
+		cx_err("it seems I don't have a tuner...");
=20
 	/* Enable automatic acquisition and reset cycle */
 	cx24123_writereg(state, 0x03, (cx24123_readreg(state, 0x03) | 0x07));
@@ -968,11 +968,11 @@ static int cx24123_get_frontend(struct dvb_frontend *=
fe,
 	dprintk("\n");
=20
 	if (cx24123_get_inversion(state, &p->inversion) !=3D 0) {
=2D		err("%s: Failed to get inversion status\n", __func__);
+		cx_err("%s: Failed to get inversion status\n", __func__);
 		return -EREMOTEIO;
 	}
 	if (cx24123_get_fec(state, &p->u.qpsk.fec_inner) !=3D 0) {
=2D		err("%s: Failed to get fec status\n", __func__);
+		cx_err("%s: Failed to get fec status\n", __func__);
 		return -EREMOTEIO;
 	}
 	p->frequency =3D state->currentfreq;
@@ -999,7 +999,7 @@ static int cx24123_set_tone(struct dvb_frontend *fe, fe=
_sec_tone_mode_t tone)
 		dprintk("setting tone off\n");
 		return cx24123_writereg(state, 0x29, val & 0xef);
 	default:
=2D		err("CASE reached default with tone=3D%d\n", tone);
+		cx_err("CASE reached default with tone=3D%d\n", tone);
 		return -EINVAL;
 	}
=20
@@ -1075,7 +1075,7 @@ struct dvb_frontend *cx24123_attach(const struct cx24=
123_config *config,
=20
 	dprintk("\n");
 	if (state =3D=3D NULL) {
=2D		err("Unable to kzalloc\n");
+		cx_err("Unable to kzalloc\n");
 		goto error;
 	}
=20
@@ -1087,13 +1087,13 @@ struct dvb_frontend *cx24123_attach(const struct cx=
24123_config *config,
 	state->demod_rev =3D cx24123_readreg(state, 0x00);
 	switch (state->demod_rev) {
 	case 0xe1:
=2D		info("detected CX24123C\n");
+		cx_info("detected CX24123C\n");
 		break;
 	case 0xd1:
=2D		info("detected CX24123\n");
+		cx_info("detected CX24123\n");
 		break;
 	default:
=2D		err("wrong demod revision: %x\n", state->demod_rev);
+		cx_err("wrong demod revision: %x\n", state->demod_rev);
 		goto error;
 	}
=20
@@ -1112,7 +1112,7 @@ struct dvb_frontend *cx24123_attach(const struct cx24=
123_config *config,
 	state->tuner_i2c_adapter.algo_data =3D NULL;
 	i2c_set_adapdata(&state->tuner_i2c_adapter, state);
 	if (i2c_add_adapter(&state->tuner_i2c_adapter) < 0) {
=2D		err("tuner i2c bus could not be initialized\n");
+		cx_err("tuner i2c bus could not be initialized\n");
 		goto error;
 	}
=20
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/fr=
ontends/dib3000mb.c
index e80c597..b0a795a 100644
=2D-- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -147,7 +147,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* =
fe,
 			case BANDWIDTH_AUTO:
 				return -EOPNOTSUPP;
 			default:
=2D				err("unknown bandwidth value.");
+				dib_err("unknown bandwidth value.");
 				return -EINVAL;
 		}
 	}
@@ -505,7 +505,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* =
fe,
 			ofdm->constellation =3D QAM_64;
 			break;
 		default:
=2D			err("Unexpected constellation returned by TPS (%d)", tps_val);
+			dib_err("Unexpected constellation returned by TPS (%d)", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
@@ -532,7 +532,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* =
fe,
 				ofdm->hierarchy_information =3D HIERARCHY_4;
 				break;
 			default:
=2D				err("Unexpected ALPHA value returned by TPS (%d)", tps_val);
+				dib_err("Unexpected ALPHA value returned by TPS (%d)", tps_val);
 				break;
 		}
 		deb_getf("TPS: %d\n", tps_val);
@@ -569,7 +569,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* =
fe,
 			*cr =3D FEC_7_8;
 			break;
 		default:
=2D			err("Unexpected FEC returned by TPS (%d)", tps_val);
+			dib_err("Unexpected FEC returned by TPS (%d)", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n",tps_val);
@@ -592,7 +592,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* =
fe,
 			ofdm->guard_interval =3D GUARD_INTERVAL_1_4;
 			break;
 		default:
=2D			err("Unexpected Guard Time returned by TPS (%d)", tps_val);
+			dib_err("Unexpected Guard Time returned by TPS (%d)", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
@@ -607,7 +607,7 @@ static int dib3000mb_get_frontend(struct dvb_frontend* =
fe,
 			ofdm->transmission_mode =3D TRANSMISSION_MODE_8K;
 			break;
 		default:
=2D			err("unexpected transmission mode return by TPS (%d)", tps_val);
+			dib_err("unexpected transmission mode return by TPS (%d)", tps_val);
 			break;
 	}
 	deb_getf("TPS: %d\n", tps_val);
diff --git a/drivers/media/dvb/frontends/dib3000mb_priv.h b/drivers/media/d=
vb/frontends/dib3000mb_priv.h
index 16c5265..c9c36ce 100644
=2D-- a/drivers/media/dvb/frontends/dib3000mb_priv.h
+++ b/drivers/media/dvb/frontends/dib3000mb_priv.h
@@ -13,20 +13,18 @@
 #ifndef __DIB3000MB_PRIV_H_INCLUDED__
 #define __DIB3000MB_PRIV_H_INCLUDED__
=20
=2D/* info and err, taken from usb.h, if there is anything available like b=
y default. */
=2D#define err(format, arg...)  printk(KERN_ERR     "dib3000: " format "\n"=
 , ## arg)
=2D#define info(format, arg...) printk(KERN_INFO    "dib3000: " format "\n"=
 , ## arg)
=2D#define warn(format, arg...) printk(KERN_WARNING "dib3000: " format "\n"=
 , ## arg)
+/* dib_err - error printout wrapper */
+#define dib_err(format, arg...) printk(KERN_ERR     "dib3000: " format "\n=
" , ## arg)
=20
 /* handy shortcuts */
 #define rd(reg) dib3000_read_reg(state,reg)
=20
 #define wr(reg,val) if (dib3000_write_reg(state,reg,val)) \
=2D	{ err("while sending 0x%04x to 0x%04x.",val,reg); return -EREMOTEIO; }
+	{ dib_err("while sending 0x%04x to 0x%04x.",val,reg); return -EREMOTEIO; }
=20
 #define wr_foreach(a,v) { int i; \
 	if (sizeof(a) !=3D sizeof(v)) \
=2D		err("sizeof: %zu %zu is different",sizeof(a),sizeof(v));\
+		dib_err("sizeof: %zu %zu is different",sizeof(a),sizeof(v));\
 	for (i=3D0; i < sizeof(a)/sizeof(u16); i++) \
 		wr(a[i],v[i]); \
 	}
=2D-=20
1.7.1.1


--Boundary-00=_/2j2NFSzRbAXRyf--
