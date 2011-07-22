Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm5.telefonica.net ([213.4.138.21]:9649 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751617Ab1GVQCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:02:47 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Fri, 22 Jul 2011 18:02:33 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201106070205.08118.jareguero@telefonica.net> <4E260E4A.2020707@iki.fi> <4E295FE5.7040905@iki.fi>
In-Reply-To: <4E295FE5.7040905@iki.fi>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_a8ZKOZAON7ZUOEZ"
Message-Id: <201107221802.34505.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_a8ZKOZAON7ZUOEZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribi=C3=B3:
> Have you had to time test these?
>=20
> And about I2C adapter, I don't see why changes are needed. As far as I
> understand it is already working with TDA10023 and you have done changes
> for TDA10048 support. I compared TDA10048 and TDA10023 I2C functions and
> those are ~similar. Both uses most typical access, for reg write {u8
> REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.
>=20
> regards
> Antti
=20
I just finish the testing. The changes to I2C are for the tuner tda827x. Th=
e=20
MFE fork fine. I need to change the code in tda10048 and ttusb2. Attached i=
s=20
the patch for CT-3650 with your MFE patch.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto


>=20
> On 07/20/2011 02:07 AM, Antti Palosaari wrote:
> > On 07/19/2011 11:25 AM, Jose Alberto Reguero wrote:
> >> On Martes, 19 de Julio de 2011 01:44:54 Antti Palosaari escribi=C3=B3:
> >>> On 07/19/2011 02:00 AM, Jose Alberto Reguero wrote:
> >>>> On Lunes, 18 de Julio de 2011 22:28:41 Antti Palosaari escribi=C3=B3:
> >>>>=20
> >>>> There are two problems:
> >>>>=20
> >>>> First, the two frontends (tda10048 and tda10023) use tda10023 i2c ga=
te
> >>>> to talk with the tuner.
> >>>=20
> >>> Very easy to implement correctly. Attach tda10023 first and after that
> >>> tda10048. Override tda10048 .i2c_gate_ctrl() with tda10023
> >>> .i2c_gate_ctrl() immediately after tda10048 attach inside ttusb2.c. N=
ow
> >>> you have both demods (FEs) .i2c_gate_ctrl() which will control
> >>> physically tda10023 I2C-gate as tuner is behind it.
> >>=20
> >> I try that, but don't work. I get an oops. Because the i2c gate
> >> function of
> >> the tda10023 driver use:
> >>=20
> >> struct tda10023_state* state =3D fe->demodulator_priv;
> >>=20
> >> to get the i2c adress. When called from tda10048, don't work.
> >>=20
> >> Jose Alberto
> >>=20
> >>>> The second is that with dvb-usb, there is only one frontend, and if
> >>>> you wake up the second frontend, the adapter is not wake up. That can
> >>>> be avoided the way I do in the patch, or mantaining the adapter
> >>>> alwais on.
> >>>=20
> >>> I think that could be also avoided similarly overriding demod callbac=
ks
> >>> and adding some more logic inside ttusb2.c.
> >>>=20
> >>> Proper fix that later problem is surely correct MFE support for
> >>> DVB-USB-framework. I am now looking for it, lets see how difficult it
> >>> will be.
> >=20
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> >=20
> > Test attached patches and try to fix if they are not working. Most
> > likely not working since I don't have HW to test... I tested MFE parts
> > using Anysee, so it should be working. I changed rather much your ttusb2
> > and tda10048 patches, size reduced something like 50% or more. Still
> > ttusb2 I2C-adapter changes made looks rather complex. Try to double
> > check if those can be done easier. There is many drivers to look example
> > from.
> >=20
> > DVB USB MFE is something like RFC. I know FE exclusive lock is missing,
> > no need to mention that :) But other comments are welcome! I left three
> > old "unneeded" pointers to struct dvb_usb_adapter to reduce changing all
> > the drivers.
> >=20
> >=20
> > regards
> > Antti

--Boundary-00=_a8ZKOZAON7ZUOEZ
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-4.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-01-10 16:24:45.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-07-22 14:48:10.526000638 +0200
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
@@ -207,19 +229,48 @@
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
+		/* FE 1 DVB-T */
+		tda10048_config.fe = adap->mfe[0];
+
+		adap->mfe[1] = dvb_attach(tda10048_attach,
+			&tda10048_config, &adap->dev->i2c_adap);
+
+		if (adap->mfe[1] == NULL) {
+			deb_info("TDA10048 attach failed\n");
+			return -ENODEV;
+		}
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
 
@@ -383,8 +434,7 @@
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
+++ linux.new/drivers/media/dvb/frontends/tda10048.c	2011-07-22 12:55:35.979000236 +0200
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
@@ -707,15 +714,16 @@
 	struct tda10048_config *config = &state->config;
 	dprintk(1, "%s(%d)\n", __func__, enable);
 
-	if (config->disable_gate_access)
-		return 0;
-
-	if (enable)
-		return tda10048_writereg(state, TDA10048_CONF_C4_1,
-			tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
-	else
-		return tda10048_writereg(state, TDA10048_CONF_C4_1,
-			tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
+	if (config->fe && config->fe->ops.i2c_gate_ctrl) {
+		return config->fe->ops.i2c_gate_ctrl(config->fe, enable);
+	} else {
+		if (enable)
+			return tda10048_writereg(state, TDA10048_CONF_C4_1,
+				tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
+		else
+			return tda10048_writereg(state, TDA10048_CONF_C4_1,
+				tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
+	}
 }
 
 static int tda10048_output_mode(struct dvb_frontend *fe, int serial)
@@ -1123,7 +1131,7 @@
 	/* setup the state and clone the config */
 	memcpy(&state->config, config, sizeof(*config));
 	state->i2c = i2c;
-	state->fwloaded = 0;
+	state->fwloaded = config->no_firmware;
 	state->bandwidth = BANDWIDTH_8_MHZ;
 
 	/* check if the demod is present */
diff -ur linux/drivers/media/dvb/frontends/tda10048.h linux.new/drivers/media/dvb/frontends/tda10048.h
--- linux/drivers/media/dvb/frontends/tda10048.h	2010-07-03 23:22:08.000000000 +0200
+++ linux.new/drivers/media/dvb/frontends/tda10048.h	2011-07-22 12:53:50.904000229 +0200
@@ -51,6 +51,7 @@
 #define TDA10048_IF_4300  4300
 #define TDA10048_IF_4500  4500
 #define TDA10048_IF_4750  4750
+#define TDA10048_IF_5000  5000
 #define TDA10048_IF_36130 36130
 	u16 dtv6_if_freq_khz;
 	u16 dtv7_if_freq_khz;
@@ -62,6 +63,10 @@
 
 	/* Disable I2C gate access */
 	u8 disable_gate_access;
+
+	bool no_firmware;
+
+	struct dvb_frontend *fe;
 };
 
 #if defined(CONFIG_DVB_TDA10048) || \

--Boundary-00=_a8ZKOZAON7ZUOEZ--
