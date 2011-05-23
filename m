Return-path: <mchehab@pedra>
Received: from mailfe02.c2i.net ([212.247.154.34]:46600 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271Ab1EWLo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:44:27 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] The info and err macros are already defined by the USB stack. Rename these macros to avoid macro redefinition warnings.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:43:15 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Thk2N2SOVZ4W3cU"
Message-Id: <201105231343.15083.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Thk2N2SOVZ4W3cU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_Thk2N2SOVZ4W3cU
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0011.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0011.patch"

=46rom 49bc5e480f51a9b756f1f7f1503d237e8a1ba939 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:42:40 +0200
Subject: [PATCH] The info and err macros are already defined by the USB sta=
ck. Rename these macros to avoid macro redefinition warnings.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/cx24113.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24113.c b/drivers/media/dvb/fron=
tends/cx24113.c
index e9ee555..c341d57 100644
=2D-- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -31,8 +31,8 @@
=20
 static int debug;
=20
=2D#define info(args...) do { printk(KERN_INFO "CX24113: " args); } while (=
0)
=2D#define err(args...)  do { printk(KERN_ERR  "CX24113: " args); } while (=
0)
+#define cx_info(args...) do { printk(KERN_INFO "CX24113: " args); } while =
(0)
+#define cx_err(args...)  do { printk(KERN_ERR  "CX24113: " args); } while =
(0)
=20
 #define dprintk(args...) \
 	do { \
@@ -341,7 +341,7 @@ static void cx24113_calc_pll_nf(struct cx24113_state *s=
tate, u16 *n, s32 *f)
 	} while (N < 6 && R < 3);
=20
 	if (N < 6) {
=2D		err("strange frequency: N < 6\n");
+		cx_err("strange frequency: N < 6\n");
 		return;
 	}
 	F =3D freq_hz;
@@ -563,7 +563,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend=
 *fe,
 		kzalloc(sizeof(struct cx24113_state), GFP_KERNEL);
 	int rc;
 	if (state =3D=3D NULL) {
=2D		err("Unable to kzalloc\n");
+		cx_err("Unable to kzalloc\n");
 		goto error;
 	}
=20
@@ -571,7 +571,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend=
 *fe,
 	state->config =3D config;
 	state->i2c =3D i2c;
=20
=2D	info("trying to detect myself\n");
+	cx_info("trying to detect myself\n");
=20
 	/* making a dummy read, because of some expected troubles
 	 * after power on */
@@ -579,24 +579,24 @@ struct dvb_frontend *cx24113_attach(struct dvb_fronte=
nd *fe,
=20
 	rc =3D cx24113_readreg(state, 0x00);
 	if (rc < 0) {
=2D		info("CX24113 not found.\n");
+		cx_info("CX24113 not found.\n");
 		goto error;
 	}
 	state->rev =3D rc;
=20
 	switch (rc) {
 	case 0x43:
=2D		info("detected CX24113 variant\n");
+		cx_info("detected CX24113 variant\n");
 		break;
 	case REV_CX24113:
=2D		info("successfully detected\n");
+		cx_info("successfully detected\n");
 		break;
 	default:
=2D		err("unsupported device id: %x\n", state->rev);
+		cx_err("unsupported device id: %x\n", state->rev);
 		goto error;
 	}
 	state->ver =3D cx24113_readreg(state, 0x01);
=2D	info("version: %x\n", state->ver);
+	cx_info("version: %x\n", state->ver);
=20
 	/* create dvb_frontend */
 	memcpy(&fe->ops.tuner_ops, &cx24113_tuner_ops,
=2D-=20
1.7.1.1


--Boundary-00=_Thk2N2SOVZ4W3cU--
