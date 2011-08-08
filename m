Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:61590 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725Ab1HHKfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 06:35:48 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Mon, 8 Aug 2011 12:35:35 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Guy Martin <gmsoft@tuxicoman.be>
References: <201106070205.08118.jareguero@telefonica.net> <201107282125.02695.jareguero@telefonica.net> <201108022121.14355.jareguero@telefonica.net>
In-Reply-To: <201108022121.14355.jareguero@telefonica.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3v7POZ41Mjup5mo"
Message-Id: <201108081235.35950.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_3v7POZ41Mjup5mo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Martes, 2 de Agosto de 2011 21:21:13 Jose Alberto Reguero escribi=C3=B3:
> On Jueves, 28 de Julio de 2011 21:25:01 Jose Alberto Reguero escribi=C3=
=B3:
> > On Mi=C3=A9rcoles, 27 de Julio de 2011 21:22:26 Antti Palosaari escribi=
=C3=B3:
> > > On 07/24/2011 12:45 AM, Jose Alberto Reguero wrote:
> > > > Read without write work as with write. Attached updated patch.
> > > >=20
> > > > ttusb2-6.diff
> > > >=20
> > > > -		read =3D i+1<  num&&  (msg[i+1].flags&  I2C_M_RD);
> > > > +		write_read =3D i+1<  num&&  (msg[i+1].flags&  I2C_M_RD);
> > > > +		read =3D msg[i].flags&  I2C_M_RD;
> > >=20
> > > ttusb2 I2C-adapter seems to be fine for my eyes now. No more writing
> > > any random bytes in case of single read. Good!
> > >=20
> > > > +	.dtv6_if_freq_khz =3D TDA10048_IF_4000,
> > > > +	.dtv7_if_freq_khz =3D TDA10048_IF_4500,
> > > > +	.dtv8_if_freq_khz =3D TDA10048_IF_5000,
> > > > +	.clk_freq_khz     =3D TDA10048_CLK_16000,
> > > >=20
> > > >=20
> > > > +static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enabl=
e)
> > >=20
> > > cosmetic issue rename to ttusb2_ct3650_i2c_gate_ctrl
> > >=20
> > > >   	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
> > > >=20
> > > > +	{ TDA10048_CLK_16000, TDA10048_IF_4500,   5, 3, 0 },
> > > > +	{ TDA10048_CLK_16000, TDA10048_IF_5000,   5, 3, 0 },
> > > >=20
> > > > +	/* Set the  pll registers */
> > > > +	tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
> > > > +	tda10048_writereg(state, TDA10048_CONF_PLL2, (u8)(state-
> > >
> > >pll_mfactor));
> > >
> > > > +	tda10048_writereg(state, TDA10048_CONF_PLL3,
> > > > tda10048_readreg(state, TDA10048_CONF_PLL3) |
> > > > ((u8)(state->pll_nfactor) | 0x40));
> > >=20
> > > This if only issue can have effect to functionality and I want double
> > > check. I see few things.
> > >=20
> > > 1) clock (and PLL) settings should be done generally only once at
> > > .init() and probably .sleep() in case of needed for sleep. Something
> > > like start clock in init, stop clock in sleep. It is usually very fir=
st
> > > thing to set before other. Now it is in wrong place - .set_frontend().
> > >=20
> > > 2) Those clock settings seem somehow weird. As you set different PLL M
> > > divider for 6 MHz bandwidth than others. Have you looked those are
> > > really correct? I suspect there could be some other Xtal than 16MHz a=
nd
> > > thus those are wrong. Which Xtals there is inside device used? There =
is
> > > most likely 3 Xtals, one for each chip. It is metal box nearest to
> > > chip.
> >=20
> > I left 6MHz like it was before in the driver. I try to do other way,
> > allowing to put different PLL in config that the default ones of the
> > driver and initialize it in init.
> >=20
> > Jose Alberto
>=20
> Attached new version of the patch. Adding tda827x lna and doing tda10048
> pll in other way.
>=20
> Jose Alberto

Another version, without tda827x lna. It don't improve anything.

Jose Alberto

>=20
> > > Ran checkpatch.pl also to find out style issues before send patch.
> > >=20
> > > I have send new version, hopefully final, of MFE. It changes array na=
me
> > > from adap->mfe to adap-fe. You should also update that.
> > >=20
> > >=20
> > > regards
> > > Antti
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Boundary-00=_3v7POZ41Mjup5mo
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-8.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-08-01 05:45:24.000000000 +0200
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-08-08 12:22:59.624061045 +0200
@@ -30,6 +30,7 @@
 #include "tda826x.h"
 #include "tda10086.h"
 #include "tda1002x.h"
+#include "tda10048.h"
 #include "tda827x.h"
 #include "lnbp21.h"
 
@@ -82,7 +83,7 @@
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	static u8 obuf[60], ibuf[60];
-	int i,read;
+	int i, write_read, read;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -91,28 +92,35 @@
 		warn("more than 2 i2c messages at a time is not handled yet. TODO.");
 
 	for (i = 0; i < num; i++) {
-		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
+		write_read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
+		read = msg[i].flags & I2C_M_RD;
 
-		obuf[0] = (msg[i].addr << 1) | read;
-		obuf[1] = msg[i].len;
+		obuf[0] = (msg[i].addr << 1) | (write_read | read);
+		if (read)
+			obuf[1] = 0;
+		else
+			obuf[1] = msg[i].len;
 
 		/* read request */
-		if (read)
+		if (write_read)
 			obuf[2] = msg[i+1].len;
+		else if (read)
+			obuf[2] = msg[i].len;
 		else
 			obuf[2] = 0;
 
-		memcpy(&obuf[3],msg[i].buf,msg[i].len);
+		memcpy(&obuf[3], msg[i].buf, msg[i].len);
 
 		if (ttusb2_msg(d, CMD_I2C_XFER, obuf, msg[i].len+3, ibuf, obuf[2] + 3) < 0) {
 			err("i2c transfer failed.");
 			break;
 		}
 
-		if (read) {
-			memcpy(msg[i+1].buf,&ibuf[3],msg[i+1].len);
+		if (write_read) {
+			memcpy(msg[i+1].buf, &ibuf[3], msg[i+1].len);
 			i++;
-		}
+		} else if (read)
+			memcpy(msg[i].buf, &ibuf[3], msg[i].len);
 	}
 
 	mutex_unlock(&d->i2c_mutex);
@@ -190,6 +198,25 @@
 	.deltaf = 0xa511,
 };
 
+static struct tda10048_config tda10048_config = {
+	.demod_address    = 0x10 >> 1,
+	.output_mode      = TDA10048_PARALLEL_OUTPUT,
+	.inversion        = TDA10048_INVERSION_ON,
+	.dtv6_if_freq_khz = TDA10048_IF_4000,
+	.dtv7_if_freq_khz = TDA10048_IF_4500,
+	.dtv8_if_freq_khz = TDA10048_IF_5000,
+	.clk_freq_khz     = TDA10048_CLK_16000,
+	.no_firmware      = 1,
+	.set_pll          = true ,
+	.pll_m            = 5,
+	.pll_n            = 3,
+	.pll_p            = 0,
+};
+
+static struct tda827x_config tda827x_config = {
+	.config = 0,
+};
+
 static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
@@ -203,20 +230,56 @@
 	return 0;
 }
 
+static int ttusb2_ct3650_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+
+	return adap->fe[0]->ops.i2c_gate_ctrl(adap->fe[0], enable);
+}
+
 static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
 		err("set interface to alts=3 failed");
-	if ((adap->fe[0] = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
-		deb_info("TDA10023 attach failed\n");
-		return -ENODEV;
+
+	if (adap->fe[0] == NULL) {
+		/* FE 0 DVB-C */
+		adap->fe[0] = dvb_attach(tda10023_attach,
+			&tda10023_config, &adap->dev->i2c_adap, 0x48);
+
+		if (adap->fe[0] == NULL) {
+			deb_info("TDA10023 attach failed\n");
+			return -ENODEV;
+		}
+	} else {
+		adap->fe[1] = dvb_attach(tda10048_attach,
+			&tda10048_config, &adap->dev->i2c_adap);
+
+		if (adap->fe[1] == NULL) {
+			deb_info("TDA10048 attach failed\n");
+			return -ENODEV;
+		}
+
+		/* tuner is behind TDA10023 I2C-gate */
+		adap->fe[1]->ops.i2c_gate_ctrl = ttusb2_ct3650_i2c_gate_ctrl;
+
 	}
+
 	return 0;
 }
 
 static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
 {
-	if (dvb_attach(tda827x_attach, adap->fe[0], 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
+	struct dvb_frontend *fe;
+
+	/* MFE: select correct FE to attach tuner since that's called twice */
+	if (adap->fe[1] == NULL)
+		fe = adap->fe[0];
+	else
+		fe = adap->fe[1];
+
+	/* attach tuner */
+	if (dvb_attach(tda827x_attach, fe, 0x61, &adap->dev->i2c_adap, &tda827x_config) == NULL) {
 		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
 		return -ENODEV;
 	}
@@ -385,6 +448,7 @@
 		{
 			.streaming_ctrl   = NULL,
 
+			.num_frontends    = 2,
 			.frontend_attach  = ttusb2_frontend_tda10023_attach,
 			.tuner_attach = ttusb2_tuner_tda827x_attach,
 
diff -ur linux/drivers/media/dvb/frontends/tda10048.c linux.new/drivers/media/dvb/frontends/tda10048.c
--- linux/drivers/media/dvb/frontends/tda10048.c	2010-10-25 01:34:58.000000000 +0200
+++ linux.new/drivers/media/dvb/frontends/tda10048.c	2011-08-07 22:23:01.574897364 +0200
@@ -206,15 +206,16 @@
 static struct pll_tab {
 	u32	clk_freq_khz;
 	u32	if_freq_khz;
-	u8	m, n, p;
 } pll_tab[] = {
-	{ TDA10048_CLK_4000,  TDA10048_IF_36130, 10, 0, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_3300,  10, 3, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_3500,  10, 3, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_3800,  10, 3, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_4300,  10, 3, 0 },
-	{ TDA10048_CLK_16000, TDA10048_IF_36130, 10, 3, 0 },
+	{ TDA10048_CLK_4000,  TDA10048_IF_36130 },
+	{ TDA10048_CLK_16000, TDA10048_IF_3300 },
+	{ TDA10048_CLK_16000, TDA10048_IF_3500 },
+	{ TDA10048_CLK_16000, TDA10048_IF_3800 },
+	{ TDA10048_CLK_16000, TDA10048_IF_4000 },
+	{ TDA10048_CLK_16000, TDA10048_IF_4300 },
+	{ TDA10048_CLK_16000, TDA10048_IF_4500 },
+	{ TDA10048_CLK_16000, TDA10048_IF_5000 },
+	{ TDA10048_CLK_16000, TDA10048_IF_36130 },
 };
 
 static int tda10048_writereg(struct tda10048_state *state, u8 reg, u8 data)
@@ -460,9 +461,6 @@
 
 			state->freq_if_hz = pll_tab[i].if_freq_khz * 1000;
 			state->xtal_hz = pll_tab[i].clk_freq_khz * 1000;
-			state->pll_mfactor = pll_tab[i].m;
-			state->pll_nfactor = pll_tab[i].n;
-			state->pll_pfactor = pll_tab[i].p;
 			break;
 		}
 	}
@@ -781,6 +779,10 @@
 
 	dprintk(1, "%s()\n", __func__);
 
+	/* PLL */
+	init_tab[4].data = (u8)(state->pll_mfactor);
+	init_tab[5].data = (u8)(state->pll_nfactor) | 0x40;
+
 	/* Apply register defaults */
 	for (i = 0; i < ARRAY_SIZE(init_tab); i++)
 		tda10048_writereg(state, init_tab[i].reg, init_tab[i].data);
@@ -1123,7 +1125,7 @@
 	/* setup the state and clone the config */
 	memcpy(&state->config, config, sizeof(*config));
 	state->i2c = i2c;
-	state->fwloaded = 0;
+	state->fwloaded = config->no_firmware;
 	state->bandwidth = BANDWIDTH_8_MHZ;
 
 	/* check if the demod is present */
@@ -1135,6 +1137,17 @@
 		sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 
+	/* set pll */
+	if (config->set_pll) {
+		state->pll_mfactor = config->pll_m;
+		state->pll_nfactor = config->pll_n;
+		state->pll_pfactor = config->pll_p;
+	} else {
+		state->pll_mfactor = 10;
+		state->pll_nfactor = 3;
+		state->pll_pfactor = 0;
+	}
+
 	/* Establish any defaults the the user didn't pass */
 	tda10048_establish_defaults(&state->frontend);
 
diff -ur linux/drivers/media/dvb/frontends/tda10048.h linux.new/drivers/media/dvb/frontends/tda10048.h
--- linux/drivers/media/dvb/frontends/tda10048.h	2010-07-03 23:22:08.000000000 +0200
+++ linux.new/drivers/media/dvb/frontends/tda10048.h	2011-08-01 12:11:16.091956357 +0200
@@ -51,6 +51,7 @@
 #define TDA10048_IF_4300  4300
 #define TDA10048_IF_4500  4500
 #define TDA10048_IF_4750  4750
+#define TDA10048_IF_5000  5000
 #define TDA10048_IF_36130 36130
 	u16 dtv6_if_freq_khz;
 	u16 dtv7_if_freq_khz;
@@ -62,6 +63,13 @@
 
 	/* Disable I2C gate access */
 	u8 disable_gate_access;
+
+	bool no_firmware;
+
+	bool set_pll;
+	u8 pll_m;
+	u8 pll_p;
+	u8 pll_n;
 };
 
 #if defined(CONFIG_DVB_TDA10048) || \

--Boundary-00=_3v7POZ41Mjup5mo--
