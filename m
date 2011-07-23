Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:15165 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297Ab1GWVpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 17:45:20 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
Date: Sat, 23 Jul 2011 23:45:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Guy Martin <gmsoft@tuxicoman.be>
References: <201106070205.08118.jareguero@telefonica.net> <201107231741.53794.jareguero@telefonica.net> <4E2B092F.5040107@iki.fi>
In-Reply-To: <4E2B092F.5040107@iki.fi>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eD0KO78Uoqj+O5g"
Message-Id: <201107232345.03173.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_eD0KO78Uoqj+O5g
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On S=C3=A1bado, 23 de Julio de 2011 19:47:27 Antti Palosaari escribi=C3=B3:
> On 07/23/2011 06:41 PM, Jose Alberto Reguero wrote:
> > On S=C3=A1bado, 23 de Julio de 2011 12:37:53 Antti Palosaari escribi=C3=
=B3:
> >> On 07/23/2011 01:21 PM, Jose Alberto Reguero wrote:
> >>> On S=C3=A1bado, 23 de Julio de 2011 11:42:58 Antti Palosaari escribi=
=C3=B3:
> >>>> On 07/23/2011 11:26 AM, Jose Alberto Reguero wrote:
> >>>>> The problem is in i2c read in tda827x_probe_version. Without the fix
> >>>>> sometimes, when changing the code the tuner is detected as  tda827xo
> >>>>> instead of tda827xa. That is because the variable where i2c read
> >>>>> should store the value is initialized, and sometimes it works.
> >>>>=20
> >>>> struct i2c_msg msg =3D { .addr =3D priv->i2c_addr, .flags =3D I2C_M_=
RD,
> >>>>=20
> >>>> 			       .buf =3D&data, .len =3D 1 };
> >>>>=20
> >>>> rc =3D tuner_transfer(fe,&msg, 1);
> >>>>=20
> >>>> :-( Could you read what I write. It is a little bit annoying to find
> >>>> :out
> >>>>=20
> >>>> everything for you. You just answer every time something like it does
> >>>> not work and I should always find out what's problem.
> >>>>=20
> >>>> As I pointed out read will never work since I2C adapter supports only
> >>>> read done in WRITE+READ combination. Driver uses read which is single
> >>>> READ without write.
> >>>>=20
> >>>> You should implement new read. You can look example from af9015 or
> >>>> other drivers using tda827x
> >>>>=20
> >>>> This have been never worked thus I Cc Guy Martin who have added DVB-C
> >>>> support for that device.
> >>>>=20
> >>>>=20
> >>>> regards
> >>>> Antti
> >>>=20
> >>> I don't understand you. I think that you don' see the fix, but the old
> >>> code. Old code:
> >>>=20
> >>> read =3D i+1<    num&&    (msg[i+1].flags&    I2C_M_RD);
> >>>=20
> >>> Fix:
> >>>=20
> >>> read1 =3D i+1<   num&&   (msg[i+1].flags&   I2C_M_RD); for the tda100=
23
> >>> and tda10048 read2 =3D msg[i].flags&   I2C_M_RD; for the tda827x
> >>>=20
> >>> Jose Alberto
> >>=20
> >> First of all I must apologize of blaming you about that I2C adapter,
> >> sorry, I should going to shame now. It was me who doesn't read your
> >> changes as should :/
> >>=20
> >> Your changes are logically OK and implements correctly single reading =
as
> >> needed. Some comments still;
> >> * consider renaming read1 and read2 for example write_read and read
> >> * obuf[1] contains WRITE len. your code sets that now as READ len.
> >> Probably it should be 0 always in single write since no bytes written.
> >> * remove useless checks from end of the "if (foo) if (foo)";
> >> if (read1 || read2) {
> >>=20
> >> 	if (read1) {
> >>=20
> >> [...]
> >>=20
> >> 	} else if (read2)
> >>=20
> >> If you store some variables at the beginning, olen, ilen, obuf, ibuf,
> >> you can increase i++ for write+read and rest of the code in function c=
an
> >> be same (no more if read or write + read). But maybe it is safe to keep
> >> closer original than change such much.
> >>=20
> >>=20
> >> regards
> >> Antti
> >=20
> > There are a second i2c read, but less important.It is in:
> >=20
> > tda827xa_set_params
> >=20
> > ............
> >=20
> >          buf[0] =3D 0xa0;
> >          buf[1] =3D 0x40;
> >          msg.len =3D 2;
> >          rc =3D tuner_transfer(fe,&msg, 1);
> >          if (rc<  0)
> >         =20
> >                  goto err;
> >         =20
> >          msleep(11);
> >          msg.flags =3D I2C_M_RD;
> >          rc =3D tuner_transfer(fe,&msg, 1);
> >          if (rc<  0)
> >         =20
> >                  goto err;
> >         =20
> >          msg.flags =3D 0;
> >         =20
> >          buf[1]>>=3D 4;
> >=20
> > ............
> > I supposed that buf[0] is the register to read and they read the value =
in
> > buf[1]. The code now seem to work ok but perhaps is wrong.
>=20
> This one is as translated to "normal" C we usually use;
> write_reg(0xa0, 0x40); // write one reg
> read_regs(2); // read 2 regs
>=20
> example from the sniff
>   AA B0 31 05 C2 02 00 A0 40                        =C2=AA=C2=B01.=C3=82.=
=2E @
>   55 B0 31 03 C2 02 00 4A 44 08 00 00 00 71 AC EC   U=C2=B01.=C3=82..JD..=
=2E.q=C2=AC=C3=AC
>   AA B1 31 05 C2 02 00 30 11                        =C2=AA=C2=B11.=C3=82.=
=2E0.
>   55 B1 31 03 C2 02 00 4A 44 08 00 00 00 71 AC EC   U=C2=B11.=C3=82..JD..=
=2E.q=C2=AC=C3=AC
>=20
>=20
> AA USB direction to device
> B1 USB msg seq
> 31 USB cmd
> 05 USB data len (4+5=3D9, 4=3Dhdr len, 5=3Ddata len, 9=3Dtotal)
> C2 I2C addr (addr << 1)
> 02 I2C write len
> 00 I2C read len
> 30 I2C data [0]
> 11 I2C data [1]
>=20
> So it seems actually to write 30 11 and then read 4a 44 as reply. But if
> you read driver code it does not write "30 11" instead just reads. Maybe
> buggy I2C adap implementation or buggy tuner driver (Linux driver or
> driver where sniff taken). Try to read without write and with write and
> compare if there is any difference.
>=20
>=20
> regards
> Antti

Read without write work as with write. Attached updated patch.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_eD0KO78Uoqj+O5g
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ttusb2-6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ttusb2-6.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
--- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-01-10 16:24:45.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-07-23 23:12:29.341385243 +0200
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
@@ -190,6 +198,21 @@
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
@@ -203,23 +226,60 @@
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
 
@@ -383,8 +443,7 @@
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
 
 #if defined(CONFIG_DVB_TDA10048) || \

--Boundary-00=_eD0KO78Uoqj+O5g--
