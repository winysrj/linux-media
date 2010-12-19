Return-path: <mchehab@gaivota>
Received: from spectre.t3rror.net ([188.40.142.143]:57693 "EHLO
	mail.t3rror.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754915Ab0LSMbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 07:31:43 -0500
From: Boris Cuber <me@boris64.net>
Reply-To: me@boris64.net
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: TeVii S470 dvb-s2 issues - 2nd try ,)
Date: Sun, 19 Dec 2010 13:31:25 +0100
References: <201012161429.32658.me@boris64.net> <201012181440.56078.me@boris64.net> <1292682185.2397.16.camel@morgan.silverblock.net>
In-Reply-To: <1292682185.2397.16.camel@morgan.silverblock.net>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1431295.Cyx4UVbxea";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012191331.40801.me@boris64.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--nextPart1431295.Cyx4UVbxea
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Saturday 18 December 2010 schrieben Sie:
> On Sat, 2010-12-18 at 14:40 +0100, Boris Cuber wrote:
> > Am Friday 17 December 2010 schrieben Sie:
> > > On Fri, 2010-12-17 at 12:19 +0100, Boris Cuber wrote:
> > > > Hello linux-media people!
> > > >=20
> > > > I have to problems with my dvb card ("TeVii S470"). I already
> > > > filed 2 bug reports some time ago, but no one seems to have
> > > > noticed/read them, so i'm trying it here now.
> > > > If you need a "full" dmesg, then please take a look at
> > > > https://bugzilla.kernel.org/attachment.cgi?id=3D40552
> > > >=20
> > > > 1) "TeVii S470 dvbs-2 card (cx23885) is not usable after
> > > > pm-suspend/resume" https://bugzilla.kernel.org/show_bug.cgi?id=3D16=
467
> > >=20
> > > The cx23885 driver does not implement power management.  It would
> > > likely take many, many hours of coding and testing to implement it
> > > properly.
> > >=20
> > > If you need resume/suspend, use the power management scripts on your
> > > machine to kill all the applications using the TeVii S470, and then
> > > unload the cx23885 module just before suspend.
> > >=20
> > > On resume, have the power management scripts reload the cx23885 modul=
e.
> >=20
> > Well, this doesn't work. If i did tune a channel before or used the dvb
> > card somehow for watching tv, unloading and reloading the cx23885
> > module also makes the card unuseable.
> > In dmesg there's lots of "do_IRQ: 1.161 No irq handler for vector (irq
> > -1)" messages then. This can only be fixed by rebooting the computer.
>=20
> That is s a known issue with the CX2388[578] chip and PCIe MSI.
>=20
> The CX2388[578] will not accept a different value for its "MSI Data"
> field in its PCI config space, when MSI has been enabled on the hardware
> once.
>=20
> The kernel will always try to give a different value for the "MSI Data"
> field to the CX2388[578] chip, on cx23885 module unload and reload.
>=20
> So suspend and then resume didn't reset the chip hardware?
>=20
> You can set "pci=3Dnomsi" on your kernel command line to prevent the
> cx23885 driver, and your whole system unfortunately, from using MSI.
>=20
Ah, now i got it. Simply reloading the module kills the card with that nasty
do_IRQ thing (until reboot), but
=2D> 1) unloading module 2) suspending 3) resuming 4) loading module=20
actually works. It's kinda dirty solution (with some hackish script in
/etc/pm/sleep.d/), but it works somehow.
Perhaps someday there will be a better solution (power management?).

> Regards,
> Andy
Thanks for your time,
Boris

=2D-=20
http://boris64.net 20xx ;)

--nextPart1431295.Cyx4UVbxea
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJNDfssAAoJEONrv02ePEYN7fEP/i5aOgZtTvjpc7NpNf7auxNc
GJh76SzZzoqouCpLfTBg2ps8E9MGpo4SDT8PQ4YjtYLH1/lMTPoghUjRG3CFVr2i
IY9oOCo0yPj25qBequTf7EShHso8qvYo49S7UfQtm7MpcjtwRz7j2MrDWmJGBTQR
1lzdvnCv1v+EAyX8TAq9TY9WUD7YoQKN54G+A5LZcHJcqTpddzKhUzx1783nVxSV
7Ewe27ohTt1cKGy0c4ZVZWLuqhjUAG1m+FH5iGymputggDibF6GWlbjR6CFbtxpv
x5sTu6um8UwMLeVd1G2yQbE+BAFFL+95YVzWNChevmprziwycW22afh/hwWPlm8Q
mycL1+vcdee9kM13E37qnQx0Rb3cuUKrbRCHy8TOuX6aBHpD9RBOMvY1r+Gamy3/
aV4QsQEhl9ZzC9tGb7eA2BPLuzbZvKUnFEEKKQz4OKNBl8EAGPuSBQZ13diDUuIH
PutF0RFiiZBruACRSgESRqK5BV5A/IkvLpEuwTIlnTynHsZATEvQBm4F9EIOxOJr
vkW7g2tEyTDuCZtGMoeLOdMWZH9EAYS5dcsu1YwIic1xS8sk7QAZmRe9kAGCmCab
2bHVzrmXAkJtxFHEdNdCgwrA/8bxeq785TCT8rmlM2+szFIwwHUWx0Oa229oahbw
lXqOLunzZZKQfj42VY4I
=Jqc/
-----END PGP SIGNATURE-----

--nextPart1431295.Cyx4UVbxea--
