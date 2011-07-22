Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:35819 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932239Ab1GVVta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 17:49:30 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Fri, 22 Jul 2011 23:49:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201106070205.08118.jareguero@telefonica.net> <4E29A960.3090401@iki.fi> <201107222012.20711.jareguero@telefonica.net>
In-Reply-To: <201107222012.20711.jareguero@telefonica.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iBfKOZ/1B+6EArP"
Message-Id: <201107222349.22717.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_iBfKOZ/1B+6EArP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Viernes, 22 de Julio de 2011 20:12:20 Jose Alberto Reguero escribi=C3=B3:
> On Viernes, 22 de Julio de 2011 18:46:24 Antti Palosaari escribi=C3=B3:
> > On 07/22/2011 07:25 PM, Jose Alberto Reguero wrote:
> > > On Viernes, 22 de Julio de 2011 18:08:39 Antti Palosaari escribi=C3=
=B3:
> > >> On 07/22/2011 07:02 PM, Jose Alberto Reguero wrote:
> > >>> On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribi=C3=
=B3:
> > >>>> Have you had to time test these?
> > >>>>=20
> > >>>> And about I2C adapter, I don't see why changes are needed. As far =
as
> > >>>> I understand it is already working with TDA10023 and you have done
> > >>>> changes for TDA10048 support. I compared TDA10048 and TDA10023 I2C
> > >>>> functions and those are ~similar. Both uses most typical access,
> > >>>> for reg write {u8 REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.
> > >>>>=20
> > >>>> regards
> > >>>> Antti
> > >>>=20
> > >>> I just finish the testing. The changes to I2C are for the tuner
> > >>> tda827x. The MFE fork fine. I need to change the code in tda10048 a=
nd
> > >>> ttusb2. Attached is the patch for CT-3650 with your MFE patch.
> > >>=20
> > >> You still pass tda10023 fe pointer to tda10048 for I2C-gate control
> > >> which is wrong. Could you send USB sniff I can look what there really
> > >> happens. If you have raw SniffUSB2 logs I wish to check those, other
> > >> logs are welcome too if no raw SniffUSB2 available.
> > >=20
> > > Youre chnage don't work. You need to change the function i2c gate of
> > > tda1048 for the one of tda1023, but the parameter of this function mu=
st
> > > be the fe pointer of tda1023. If this is a problem, I can duplicate
> > > tda1023 i2c gate in ttusb2 code and pass it to the tda10048. It is do=
ne
> > > this way in the first patch of this thread.
> >=20
> > Yes I now see why it cannot work - since FE is given as a parameter to
> > i2c_gate_ctrl it does not see correct priv and used I2C addr is read
> > from priv. You must implement own i2c_gate_ctrl in ttusb2 driver.
> > Implement own ct3650_i2c_gate_ctrl and override tda10048 i2c_gate_ctrl
> > using that. Then call tda10023 i2c_gate_ctrl but instead of tda10048 FE
> > use td10023 FE. Something like
> >=20
> > static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
> > {
> >=20
> > 	return adap->mfe[0]->ops.i2c_gate_ctrl(POINTER_TO_TDA10023_FE, enable);
> >=20
> > }
> >=20
> > /* tuner is behind TDA10023 I2C-gate */
> > adap->mfe[1]->ops.i2c_gate_ctrl =3D ct3650_i2c_gate_ctrl;
> >=20
> >=20
> > Could you still send USB logs? I don't see it correct behaviour you need
> > to change I2C-adaper when same tuner is used for DVB-T because it was
> > already working in DVB-C mode.
> >=20
> > regards
> > Antti
>=20
> Thanks, I try to implement that. I attach a processed log. It prints the
> first line of a usb command and the first line of the returned byes. If
> you want the full log I can upload it where you want.
>=20
> Jose Alberto

New version with Antti's sugestion.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_iBfKOZ/1B+6EArP
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-5.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-01-10 16:24:45.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-07-22 22:15:20.483271578 +0200
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
+	int i, read1, read2;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -91,27 +92,33 @@
 		warn("more than 2 i2c messages at a time is not handled yet. TODO.");
 
 	for (i = 0; i < num; i++) {
-		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);
+		read1 = i+1 < num && (msg[i+1].flags & I2C_M_RD);
+		read2 = msg[i].flags & I2C_M_RD;
 
-		obuf[0] = (msg[i].addr << 1) | read;
+		obuf[0] = (msg[i].addr << 1) | (read1 | read2);
 		obuf[1] = msg[i].len;
 
 		/* read request */
-		if (read)
+		if (read1)
 			obuf[2] = msg[i+1].len;
+		else if (read2)
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
-			i++;
+		if (read1 || read2) {
+			if (read1) {
+				memcpy(msg[i+1].buf, &ibuf[3], msg[i+1].len);
+				i++;
+			} else if (read2)
+				memcpy(msg[i].buf, &ibuf[3], msg[i].len);
 		}
 	}
 
@@ -190,6 +197,21 @@
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
+};
+
+static struct tda827x_config tda827x_config = {
+	.config = 0,
+};
+
 static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev,0,3) < 0)
@@ -203,23 +225,60 @@
 	return 0;
 }
 
+static int ct3650_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+
+        return adap->mfe[0]->ops.i2c_gate_ctrl(adap->mfe[0], enable);
+}
+
 static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
 		err("set interface to alts=3 failed");
-	if ((adap->fe = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
-		deb_info("TDA10023 attach failed\n");
-		return -ENODEV;
+
+	if (adap->mfe[0] == NULL) {
+		/* FE 0 DVB-C */
+		adap->mfe[0] = dvb_attach(tda10023_attach,
+			&tda10023_config, &adap->dev->i2c_adap, 0x48);
+
+		if (adap->mfe[0] == NULL) {
+			deb_info("TDA10023 attach failed\n");
+			return -ENODEV;
+		}
+	} else {
+		adap->mfe[1] = dvb_attach(tda10048_attach,
+			&tda10048_config, &adap->dev->i2c_adap);
+
+		if (adap->mfe[1] == NULL) {
+			deb_info("TDA10048 attach failed\n");
+			return -ENODEV;
+		}
+
+		/* tuner is behind TDA10023 I2C-gate */
+		adap->mfe[1]->ops.i2c_gate_ctrl = ct3650_i2c_gate_ctrl;
+
 	}
+
 	return 0;
 }
 
 static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
 {
-	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
+	struct dvb_frontend *fe;
+
+	/* MFE: select correct FE to attach tuner since that's called twice */
+	if (adap->mfe[1] == NULL)
+		fe = adap->mfe[0];
+	else
+		fe = adap->mfe[1];
+
+	/* attach tuner */
+	if (dvb_attach(tda827x_attach, fe, 0x61, &adap->dev->i2c_adap, &tda827x_config) == NULL) {
 		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
 		return -ENODEV;
 	}
+
 	return 0;
 }
 
@@ -383,8 +442,7 @@
 	.num_adapters = 1,
 	.adapter = {
 		{
-			.streaming_ctrl   = NULL,
-
+			.num_frontends    = 2,
 			.frontend_attach  = ttusb2_frontend_tda10023_attach,
 			.tuner_attach = ttusb2_tuner_tda827x_attach,
 
diff -ur linux/drivers/media/dvb/frontends/tda10048.c linux.new/drivers/media/dvb/frontends/tda10048.c
--- linux/drivers/media/dvb/frontends/tda10048.c	2010-10-25 01:34:58.000000000 +0200
+++ linux.new/drivers/media/dvb/frontends/tda10048.c	2011-07-22 22:35:32.014271650 +0200
@@ -214,6 +214,8 @@
 	{ TDA10048_CLK_16000, TDA10048_IF_3800,  10, 3, 0 },
 	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
 	{ TDA10048_CLK_16000, TDA10048_IF_4300,  10, 3, 0 },
+	{ TDA10048_CLK_16000, TDA10048_IF_4500,   5, 3, 0 },
+	{ TDA10048_CLK_16000, TDA10048_IF_5000,   5, 3, 0 },
 	{ TDA10048_CLK_16000, TDA10048_IF_36130, 10, 3, 0 },
 };
 
@@ -478,6 +480,11 @@
 	dprintk(1, "- pll_nfactor = %d\n", state->pll_nfactor);
 	dprintk(1, "- pll_pfactor = %d\n", state->pll_pfactor);
 
+	/* Set the  pll registers */
+	tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
+	tda10048_writereg(state, TDA10048_CONF_PLL2, (u8)(state->pll_mfactor));
+	tda10048_writereg(state, TDA10048_CONF_PLL3, tda10048_readreg(state, TDA10048_CONF_PLL3) | ((u8)(state->pll_nfactor) | 0x40));
+
 	/* Calculate the sample frequency */
 	state->sample_freq = state->xtal_hz * (state->pll_mfactor + 45);
 	state->sample_freq /= (state->pll_nfactor + 1);
@@ -1123,7 +1130,7 @@
 	/* setup the state and clone the config */
 	memcpy(&state->config, config, sizeof(*config));
 	state->i2c = i2c;
-	state->fwloaded = 0;
+	state->fwloaded = config->no_firmware;
 	state->bandwidth = BANDWIDTH_8_MHZ;
 
 	/* check if the demod is present */
diff -ur linux/drivers/media/dvb/frontends/tda10048.h linux.new/drivers/media/dvb/frontends/tda10048.h
--- linux/drivers/media/dvb/frontends/tda10048.h	2010-07-03 23:22:08.000000000 +0200
+++ linux.new/drivers/media/dvb/frontends/tda10048.h	2011-07-22 22:15:33.841271580 +0200
@@ -51,6 +51,7 @@
 #define TDA10048_IF_4300  4300
 #define TDA10048_IF_4500  4500
 #define TDA10048_IF_4750  4750
+#define TDA10048_IF_5000  5000
 #define TDA10048_IF_36130 36130
 	u16 dtv6_if_freq_khz;
 	u16 dtv7_if_freq_khz;
@@ -62,6 +63,8 @@
 
 	/* Disable I2C gate access */
 	u8 disable_gate_access;
+
+	bool no_firmware;
 };
 

--Boundary-00=_iBfKOZ/1B+6EArP--
