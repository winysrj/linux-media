Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42334 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbeKTTqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 14:46:24 -0500
Date: Tue, 20 Nov 2018 07:18:10 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: stakanov <stakanov@eclipso.eu>
Cc: linux-media@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181120071810.7c8583b3@coco.lan>
In-Reply-To: <3267610.1jAA2Txdp3@roadrunner.suse>
References: <s5hbm6l5cdi.wl-tiwai@suse.de>
        <1837109.xExTbI5ikD@roadrunner.suse>
        <20181119215841.0a3abd37@coco.lan>
        <3267610.1jAA2Txdp3@roadrunner.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 20 Nov 2018 09:07:57 +0100
stakanov <stakanov@eclipso.eu> escreveu:

> In data marted=C3=AC 20 novembre 2018 00:58:41 CET, Mauro Carvalho Chehab=
 ha=20
> scritto:
> > Em Tue, 20 Nov 2018 00:19:54 +0100
> >=20
> > stakanov <stakanov@eclipso.eu> escreveu: =20
> > > In data marted=C3=AC 20 novembre 2018 00:08:45 CET, Mauro Carvalho Ch=
ehab ha
> > >=20
> > > scritto: =20
> > > >  uname -a
> > > >   =20
> > > > > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT M=
on
> > > > > Nov 19
> > > > > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux =20
> > > =20
> > >  uname -a
> > >   =20
> > > > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon=
 Nov
> > > > 19
> > > > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux =20
> > >=20
> > > from https://download.opensuse.org/repositories/home:/tiwai:/bsc11163=
74/
> > > standard/x86_64/
> > >=20
> > > So I booted this one, should be the right one.
> > > sudo dmesg | grep -i b2c2   should give these additional messages?
> > >=20
> > > If Takashi is still around, he could confirm. =20
> >=20
> > Well, if the patch got applied, you should  now be getting messages sim=
ilar
> > (but not identical) to:
> >=20
> > 	dvb_frontend_get_frequency_limits: frequencies: tuner: 9150000...21500=
00,
> > frontend: 9150000...2150000 dvb_pll_attach: delsys: 5, frequency range:
> > 9150000..2150000
> >  =20
> > > _________________________________________________________________
> > > ________________________________________________________
> > > Ihre E-Mail-Postf=C3=A4cher sicher & zentral an einem Ort. Jetzt wech=
seln und
> > > alte E-Mail-Adresse mitnehmen! https://www.eclipso.de =20
> > Thanks,
> > Mauro =20
>=20
>=20
> My bad.=20
> With just dmesg:
>=20
> [   89.399887] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [   95.020149] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [   95.152049] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [   95.152058] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1880000 out of range (950000..2150)
> [   98.356539] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [   98.480372] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [   98.480381] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1587500 out of range (950000..2150)
> [  100.016823] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [  100.140619] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [  100.140629] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1353500 out of range (950000..2150)
> [  105.361166] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [  105.492972] dvb_frontend_get_frequency_limits: frequencies: tuner:=20
> 950000...2150000, frontend: 950000000...2150000000
> [  105.492977] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0=20
> frequency 1944750 out of range (950000..2150)
>=20
>=20
> Which is, I guess the info you need?

Yes, partially. Clearly, the problem is coming from the tuner, with is
not reporting the frequency in Hz, but I was hoping to see another
message from the tuner driver, in order for me to be sure about what's
happening there.

Didn't you get any message that starts with "dvb_pll_attach"?

The thing with Flexcop is that there are several variations, each one
with a different tuner driver.

Anyway, I guess I found the trouble: it is trying to use the DVB
cache to check the delivery system too early (at attach time).

I suspect that the enclosed patch will fix the issue. Could you please
test it?

Thanks!
Mauro


diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-fron=
tends/dvb-pll.c
index 6d4b2eec67b4..390ecc915096 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -80,8 +80,8 @@ struct dvb_pll_desc {
=20
 static const struct dvb_pll_desc dvb_pll_thomson_dtt7579 =3D {
 	.name  =3D "Thomson dtt7579",
-	.min   =3D 177000000,
-	.max   =3D 858000000,
+	.min   =3D 177 * MHz,
+	.max   =3D 858 * MHz,
 	.iffreq=3D 36166667,
 	.sleepdata =3D (u8[]){ 2, 0xb4, 0x03 },
 	.count =3D 4,
@@ -102,8 +102,8 @@ static void thomson_dtt759x_bw(struct dvb_frontend *fe,=
 u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_thomson_dtt759x =3D {
 	.name  =3D "Thomson dtt759x",
-	.min   =3D 177000000,
-	.max   =3D 896000000,
+	.min   =3D 177 * MHz,
+	.max   =3D 896 * MHz,
 	.set   =3D thomson_dtt759x_bw,
 	.iffreq=3D 36166667,
 	.sleepdata =3D (u8[]){ 2, 0x84, 0x03 },
@@ -126,8 +126,8 @@ static void thomson_dtt7520x_bw(struct dvb_frontend *fe=
, u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_thomson_dtt7520x =3D {
 	.name  =3D "Thomson dtt7520x",
-	.min   =3D 185000000,
-	.max   =3D 900000000,
+	.min   =3D 185 * MHz,
+	.max   =3D 900 * MHz,
 	.set   =3D thomson_dtt7520x_bw,
 	.iffreq =3D 36166667,
 	.count =3D 7,
@@ -144,8 +144,8 @@ static const struct dvb_pll_desc dvb_pll_thomson_dtt752=
0x =3D {
=20
 static const struct dvb_pll_desc dvb_pll_lg_z201 =3D {
 	.name  =3D "LG z201",
-	.min   =3D 174000000,
-	.max   =3D 862000000,
+	.min   =3D 174 * MHz,
+	.max   =3D 862 * MHz,
 	.iffreq=3D 36166667,
 	.sleepdata =3D (u8[]){ 2, 0xbc, 0x03 },
 	.count =3D 5,
@@ -160,8 +160,8 @@ static const struct dvb_pll_desc dvb_pll_lg_z201 =3D {
=20
 static const struct dvb_pll_desc dvb_pll_unknown_1 =3D {
 	.name  =3D "unknown 1", /* used by dntv live dvb-t */
-	.min   =3D 174000000,
-	.max   =3D 862000000,
+	.min   =3D 174 * MHz,
+	.max   =3D 862 * MHz,
 	.iffreq=3D 36166667,
 	.count =3D 9,
 	.entries =3D {
@@ -182,8 +182,8 @@ static const struct dvb_pll_desc dvb_pll_unknown_1 =3D {
  */
 static const struct dvb_pll_desc dvb_pll_tua6010xs =3D {
 	.name  =3D "Infineon TUA6010XS",
-	.min   =3D  44250000,
-	.max   =3D 858000000,
+	.min   =3D 44250 * kHz,
+	.max   =3D 858 * MHz,
 	.iffreq=3D 36125000,
 	.count =3D 3,
 	.entries =3D {
@@ -196,8 +196,8 @@ static const struct dvb_pll_desc dvb_pll_tua6010xs =3D {
 /* Panasonic env57h1xd5 (some Philips PLL ?) */
 static const struct dvb_pll_desc dvb_pll_env57h1xd5 =3D {
 	.name  =3D "Panasonic ENV57H1XD5",
-	.min   =3D  44250000,
-	.max   =3D 858000000,
+	.min   =3D 44250 * kHz,
+	.max   =3D 858 * MHz,
 	.iffreq=3D 36125000,
 	.count =3D 4,
 	.entries =3D {
@@ -220,8 +220,8 @@ static void tda665x_bw(struct dvb_frontend *fe, u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_tda665x =3D {
 	.name  =3D "Philips TDA6650/TDA6651",
-	.min   =3D  44250000,
-	.max   =3D 858000000,
+	.min   =3D 44250 * kHz,
+	.max   =3D 858 * MHz,
 	.set   =3D tda665x_bw,
 	.iffreq=3D 36166667,
 	.initdata =3D (u8[]){ 4, 0x0b, 0xf5, 0x85, 0xab },
@@ -254,8 +254,8 @@ static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_tua6034 =3D {
 	.name  =3D "Infineon TUA6034",
-	.min   =3D  44250000,
-	.max   =3D 858000000,
+	.min   =3D 44250 * kHz,
+	.max   =3D 858 * MHz,
 	.iffreq=3D 36166667,
 	.count =3D 3,
 	.set   =3D tua6034_bw,
@@ -278,8 +278,8 @@ static void tded4_bw(struct dvb_frontend *fe, u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_tded4 =3D {
 	.name =3D "ALPS TDED4",
-	.min =3D 47000000,
-	.max =3D 863000000,
+	.min =3D  47 * MHz,
+	.max =3D 863 * MHz,
 	.iffreq=3D 36166667,
 	.set   =3D tded4_bw,
 	.count =3D 4,
@@ -296,8 +296,8 @@ static const struct dvb_pll_desc dvb_pll_tded4 =3D {
  */
 static const struct dvb_pll_desc dvb_pll_tdhu2 =3D {
 	.name =3D "ALPS TDHU2",
-	.min =3D 54000000,
-	.max =3D 864000000,
+	.min =3D  54 * MHz,
+	.max =3D 864 * MHz,
 	.iffreq=3D 44000000,
 	.count =3D 4,
 	.entries =3D {
@@ -313,8 +313,8 @@ static const struct dvb_pll_desc dvb_pll_tdhu2 =3D {
  */
 static const struct dvb_pll_desc dvb_pll_samsung_tbmv =3D {
 	.name =3D "Samsung TBMV30111IN / TBMV30712IN1",
-	.min =3D 54000000,
-	.max =3D 860000000,
+	.min =3D  54 * MHz,
+	.max =3D 860 * MHz,
 	.iffreq=3D 44000000,
 	.count =3D 6,
 	.entries =3D {
@@ -332,8 +332,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbmv =
=3D {
  */
 static const struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 =3D {
 	.name  =3D "Philips SD1878",
-	.min   =3D  950000,
-	.max   =3D 2150000,
+	.min   =3D  950 * MHz,
+	.max   =3D 2150 * MHz,
 	.iffreq=3D 249, /* zero-IF, offset 249 is to round up */
 	.count =3D 4,
 	.entries =3D {
@@ -398,8 +398,8 @@ static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
=20
 static const struct dvb_pll_desc dvb_pll_opera1 =3D {
 	.name  =3D "Opera Tuner",
-	.min   =3D  900000,
-	.max   =3D 2250000,
+	.min   =3D  900 * MHz,
+	.max   =3D 2250 * MHz,
 	.initdata =3D (u8[]){ 4, 0x08, 0xe5, 0xe1, 0x00 },
 	.initdata2 =3D (u8[]){ 4, 0x08, 0xe5, 0xe5, 0x00 },
 	.iffreq=3D 0,
@@ -445,8 +445,8 @@ static void samsung_dtos403ih102a_set(struct dvb_fronte=
nd *fe, u8 *buf)
 /* unknown pll used in Samsung DTOS403IH102A DVB-C tuner */
 static const struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a =3D {
 	.name   =3D "Samsung DTOS403IH102A",
-	.min    =3D  44250000,
-	.max    =3D 858000000,
+	.min    =3D 44250 * kHz,
+	.max    =3D 858 * MHz,
 	.iffreq =3D  36125000,
 	.count  =3D 8,
 	.set    =3D samsung_dtos403ih102a_set,
@@ -465,8 +465,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_dtos40=
3ih102a =3D {
 /* Samsung TDTC9251DH0 DVB-T NIM, as used on AirStar 2 */
 static const struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 =3D {
 	.name	=3D "Samsung TDTC9251DH0",
-	.min	=3D  48000000,
-	.max	=3D 863000000,
+	.min	=3D  48 * MHz,
+	.max	=3D 863 * MHz,
 	.iffreq	=3D  36166667,
 	.count	=3D 3,
 	.entries =3D {
@@ -479,8 +479,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tdtc92=
51dh0 =3D {
 /* Samsung TBDU18132 DVB-S NIM with TSA5059 PLL, used in SkyStar2 DVB-S 2.=
3 */
 static const struct dvb_pll_desc dvb_pll_samsung_tbdu18132 =3D {
 	.name =3D "Samsung TBDU18132",
-	.min	=3D  950000,
-	.max	=3D 2150000, /* guesses */
+	.min	=3D  950 * MHz,
+	.max	=3D 2150 * MHz, /* guesses */
 	.iffreq =3D 0,
 	.count =3D 2,
 	.entries =3D {
@@ -500,8 +500,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbdu18=
132 =3D {
 /* Samsung TBMU24112 DVB-S NIM with SL1935 zero-IF tuner */
 static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 =3D {
 	.name =3D "Samsung TBMU24112",
-	.min	=3D  950000,
-	.max	=3D 2150000, /* guesses */
+	.min	=3D  950 * MHz,
+	.max	=3D 2150 * MHz, /* guesses */
 	.iffreq =3D 0,
 	.count =3D 2,
 	.entries =3D {
@@ -521,8 +521,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbmu24=
112 =3D {
  * 822 - 862   1  *  0   0   1   0   0   0   0x88 */
 static const struct dvb_pll_desc dvb_pll_alps_tdee4 =3D {
 	.name =3D "ALPS TDEE4",
-	.min	=3D  47000000,
-	.max	=3D 862000000,
+	.min	=3D  47 * MHz,
+	.max	=3D 862 * MHz,
 	.iffreq	=3D  36125000,
 	.count =3D 4,
 	.entries =3D {
@@ -537,8 +537,8 @@ static const struct dvb_pll_desc dvb_pll_alps_tdee4 =3D=
 {
 /* CP cur. 50uA, AGC takeover: 103dBuV, PORT3 on */
 static const struct dvb_pll_desc dvb_pll_tua6034_friio =3D {
 	.name   =3D "Infineon TUA6034 ISDB-T (Friio)",
-	.min    =3D  90000000,
-	.max    =3D 770000000,
+	.min    =3D  90 * MHz,
+	.max    =3D 770 * MHz,
 	.iffreq =3D  57000000,
 	.initdata =3D (u8[]){ 4, 0x9a, 0x50, 0xb2, 0x08 },
 	.sleepdata =3D (u8[]){ 4, 0x9a, 0x70, 0xb3, 0x0b },
@@ -553,8 +553,8 @@ static const struct dvb_pll_desc dvb_pll_tua6034_friio =
=3D {
 /* Philips TDA6651 ISDB-T, used in Earthsoft PT1 */
 static const struct dvb_pll_desc dvb_pll_tda665x_earth_pt1 =3D {
 	.name   =3D "Philips TDA6651 ISDB-T (EarthSoft PT1)",
-	.min    =3D  90000000,
-	.max    =3D 770000000,
+	.min    =3D  90 * MHz,
+	.max    =3D 770 * MHz,
 	.iffreq =3D  57000000,
 	.initdata =3D (u8[]){ 5, 0x0e, 0x7f, 0xc1, 0x80, 0x80 },
 	.count =3D 10,
@@ -845,18 +845,11 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_fronte=
nd *fe, int pll_addr,
=20
 	strncpy(fe->ops.tuner_ops.info.name, desc->name,
 		sizeof(fe->ops.tuner_ops.info.name));
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-	case SYS_DVBS2:
-	case SYS_TURBO:
-	case SYS_ISDBS:
-		fe->ops.tuner_ops.info.frequency_min_hz =3D desc->min * kHz;
-		fe->ops.tuner_ops.info.frequency_max_hz =3D desc->max * kHz;
-		break;
-	default:
-		fe->ops.tuner_ops.info.frequency_min_hz =3D desc->min;
-		fe->ops.tuner_ops.info.frequency_max_hz =3D desc->max;
-	}
+
+	fe->ops.tuner_ops.info.frequency_min_hz =3D desc->min;
+	fe->ops.tuner_ops.info.frequency_max_hz =3D desc->max;
+printk("%s: delsys: %d, frequency range: %u..%u\n",
+       __func__, c->delivery_system, fe->ops.tuner_ops.info.frequency_min_=
hz, fe->ops.tuner_ops.info.frequency_max_hz);
=20
 	if (!desc->initdata)
 		fe->ops.tuner_ops.init =3D NULL;
