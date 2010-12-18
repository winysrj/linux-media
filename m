Return-path: <mchehab@gaivota>
Received: from spectre.t3rror.net ([188.40.142.143]:37913 "EHLO
	mail.t3rror.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192Ab0LRNk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 08:40:58 -0500
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: TeVii S470 dvb-s2 issues - 2nd try ,)
Date: Sat, 18 Dec 2010 14:40:52 +0100
References: <201012161429.32658.me@boris64.net> <201012171219.29473.me@boris64.net> <1292591576.2077.19.camel@morgan.silverblock.net>
In-Reply-To: <1292591576.2077.19.camel@morgan.silverblock.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3089562.XEI6VkZ2dq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012181440.56078.me@boris64.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--nextPart3089562.XEI6VkZ2dq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Friday 17 December 2010 schrieben Sie:
> On Fri, 2010-12-17 at 12:19 +0100, Boris Cuber wrote:
> > Hello linux-media people!
> >=20
> > I have to problems with my dvb card ("TeVii S470"). I already
> > filed 2 bug reports some time ago, but no one seems to have
> > noticed/read them, so i'm trying it here now.
> > If you need a "full" dmesg, then please take a look at
> > https://bugzilla.kernel.org/attachment.cgi?id=3D40552
> >=20
> > 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after
> > pm-suspend/resume" https://bugzilla.kernel.org/show_bug.cgi?id=3D16467
>=20
> The cx23885 driver does not implement power management.  It would likely
> take many, many hours of coding and testing to implement it properly.
>=20
> If you need resume/suspend, use the power management scripts on your
> machine to kill all the applications using the TeVii S470, and then
> unload the cx23885 module just before suspend.
>=20
> On resume, have the power management scripts reload the cx23885 module.
>
Well, this doesn't work. If i did tune a channel before or used the dvb card
somehow for watching tv, unloading and reloading the cx23885
module also makes the card unuseable.
In dmesg there's lots of "do_IRQ: 1.161 No irq handler for vector (irq -1)"
messages then. This can only be fixed by rebooting the computer.

[/dmesg]
Dec 18 14:33:09 localhost kernel: [  943.911488] cx23885 driver version 0.0=
=2E2=20
loaded                                                                     =
  =20
Dec 18 14:33:09 localhost kernel: [  943.911525] cx23885 0000:04:00.0: PCI =
INT=20
A -> GSI 16 (level, low) -> IRQ 16                                         =
 =20
Dec 18 14:33:09 localhost kernel: [  943.911949] CORE cx23885[0]: subsystem=
:=20
d470:9022, board: TeVii S470 [card=3D15,autodetected]                      =
     =20
Dec 18 14:33:09 localhost kernel: [  944.039513] cx23885_dvb_register()=20
allocating 1 frontend(s)                                                   =
        =20
Dec 18 14:33:09 localhost kernel: [  944.039515] cx23885[0]: cx23885 based =
dvb=20
card                                                                       =
 =20
Dec 18 14:33:09 localhost kernel: [  944.041022] DS3000 chip version: 0.192=
=20
attached.                                                                  =
    =20
Dec 18 14:33:09 localhost kernel: [  944.041025] DVB: registering new adapt=
er=20
(cx23885[0])                                                               =
  =20
Dec 18 14:33:09 localhost kernel: [  944.041027] DVB: registering adapter 0=
=20
frontend 0 (Montage Technology DS3000/TS2020)...                           =
    =20
Dec 18 14:33:09 localhost kernel: [  944.069473] TeVii S470 MAC=3D=20
00:18:bd:5b:2d:bc                                                          =
               =20
Dec 18 14:33:09 localhost kernel: [  944.069479] cx23885_dev_checkrevision(=
)=20
Hardware revision =3D 0xb0                                                 =
     =20
Dec 18 14:33:09 localhost kernel: [  944.069487] cx23885[0]/0: found at=20
0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000                =
        =20
Dec 18 14:33:09 localhost kernel: [  944.069496] cx23885 0000:04:00.0: sett=
ing=20
latency timer to 64                                                        =
 =20
Dec 18 14:33:09 localhost kernel: [  944.069572] cx23885 0000:04:00.0: irq =
42=20
for MSI/MSI-X =20
Dec 18 14:33:09 localhost kernel: [  944.069496] cx23885 0000:04:00.0: sett=
ing=20
latency timer to 64                                                        =
 =20
Dec 18 14:33:09 localhost kernel: [  944.069572] cx23885 0000:04:00.0: irq =
42=20
for MSI/MSI-X                                                              =
  =20
Dec 18 14:33:14 localhost kernel: [  948.624193] do_IRQ: 1.161 No irq handl=
er=20
for vector (irq -1)                                                        =
  =20
Dec 18 14:33:15 localhost kernel: [  949.604243] do_IRQ: 1.161 No irq handl=
er=20
for vector (irq -1)                                                        =
  =20
Dec 18 14:33:16 localhost kernel: [  950.606246] do_IRQ: 2.161 No irq handl=
er=20
for vector (irq -1)                                                        =
  =20
=2E..
[/dmesg]


> > 2) "cx23885: ds3000_writereg: writereg error on =3Dkernel-2.6.36-rc with
> > TeVii" S470 dvb-s2 card
> > -> https://bugzilla.kernel.org/show_bug.cgi?id=3D18832
> >=20
> > These error messages show up in dmesg while switching channels in
> > mplayer/kaffeine.
> > [dmesg output]
> > [  919.789976] ds3000_writereg: writereg error(err =3D=3D -6, reg =3D=
=3D 0x03,
> > value =3D=3D 0x11)
>=20
> They look like I2C bus errors; error -6 is ENXIO, which is probably
> coming from cx23885-i2c.c.
>=20
> The device handled by the ds3000 driver is not responding properly to
> the CX23885.  It could be that some other device on that I2C bus is hung
> up or the ds3000 device itself.  Maybe some GPIO settings are set wrong?
>=20
> The cx23885 module supports an i2c_probe and i2c_debug module option
> that will turn on some messages related to i2c.
>=20
>=20
> I really have no other advice, except that if you do a git bisect
> process, you may find the commit(s) that caused the problem.
>=20
> Regards,
> Andy
>=20
> > Are these issues known? If so, are there any fixes yet? When will these
> > get into mainline? Could somebody point me into the right direction.
> > Can i help somehow to debug these problems?
> >=20
> > Thank you in advance.
> >=20
> > Regards,
> >=20
> > 	Boris Cuber
> >=20
> > PS: Thank Emanuel for helping me out with this mail ,)


=2D-=20
http://boris64.net 20xx ;)

--nextPart3089562.XEI6VkZ2dq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJNDLnoAAoJEONrv02ePEYNTEwQAM23+E1VAZbAGBeYkc159MdW
+XccDqXDlF7mdDkX2dMzofNEF9GYcTxLuxm1y42UuMkhTepDeyTAZYsm5K6OSAoW
a/7YxivND4pEoN2G7wsTIEl2efaBdQ6eAd63Jk4/ZMPk33yjCAJPQfH2ufa7NTPX
hp02q5/Q8sv7DEOpGcMrSDGwKl0qHnnoW4F1SjsVYqAwrArkRbgRUvi9ZxQW323Z
VH3R5WdaFtk8jBXJgbktpdSJsI3GZSmND4pjn+bjuDOZxRcSy4eC1qzDlaCVYY+h
zsDtKYmNJwjMg+DicN0CYGXOK8jXXR/BwyM1tT9bZuITNn1B6MrR4YLmhrudXroW
A/W/kHrC+VCSr3MBcFOiXB5Ur6CfiQbHDWK6t5CuEZdKghYrHOWNG6z7lVJpRNb/
hFSszQ64yLUc29ZHEPruJ6YVElOnemFfkrOwtxeAr2NAMIYjHTuIVnY2AfWycnzS
oJiTf2e58//Z+7MgrgirKo0o9Gop/OCBwuphbx67zI6IbVK5TvDjMClXG57dqEE1
Kn5/jlmK13FUtRM0IqSHY6Xx0Ttl5mMLmh5Qs1bXtEyQmZsQZa9pFknIE1k46obM
77rB76GhD8i8VV5exgSDoeQ1W+/HtYXP0xcl74VGoVA3Uc3sm1XAClBkLa70UZUd
q/k52leEGER8/+C+mE2m
=vDuA
-----END PGP SIGNATURE-----

--nextPart3089562.XEI6VkZ2dq--
