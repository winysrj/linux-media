Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:4261 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZKCNpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2009 08:45:45 -0500
Date: Tue, 3 Nov 2009 14:45:36 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  image shifted (was: Failed to configure
 for format 50323234)
Message-Id: <20091103144536.1c487f79.ospite@studenti.unina.it>
In-Reply-To: <4AC992EA.2070905@hni.uni-paderborn.de>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0910030116270.12093@axis700.grange>
	<20091003161328.36419315.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0910040024070.5857@axis700.grange>
	<20091004171924.7579b589.ospite@studenti.unina.it>
	<4AC992EA.2070905@hni.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Nov_2009_14_45_36_+0100_P7og/J5APh7/oEqC"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Tue__3_Nov_2009_14_45_36_+0100_P7og/J5APh7/oEqC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Oct 2009 08:32:10 +0200
Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de> wrote:

> Antonio Ospite schrieb:
> > On Sun, 4 Oct 2009 00:31:24 +0200 (CEST)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> >
> >>> Anyways your patch works, but the picture is now shifted, see:
> >>> http://people.openezx.org/ao2/a780-pxa-camera-mt9m111-shifted.jpg
> >>>
> >>> Is this because of the new cropping code?
> >>>      =20
> >> Hm, it shouldn't be. Does it look always like this - reproducible? Wha=
t=20
> >> program are you using? What about other geometry configurations? Have =
you=20
> >> ever seen this with previous kernel versions? New cropping - neither=20
> >> mplayer nor gstreamer use cropping normally. This seems more like a HS=
YNC=20
> >> problem to me. Double-check platform data? Is it mioa701 or some custo=
m=20
> >> board?
> >>

Platform data: if I set SOCAM_HSYNC_ACTIVE_HIGH the result is even
"wronger", with or without SOCAM_HSYNC_ACTIVE_LOW I get the same
result, now reproducible, see below.

>
> Only for your information. Maybe it helps to reproduce the error.
>=20
> I have the same problem with my own ov9655 driver on a pxa platform=20
> since I update to kernel 2.6.30
> and add crop support. Every  first open of the camera after system reset=
=20
> the image looks like yours.
> If I use the camera the next time without changing the resolution=20
> everything is OK. Only during the
> first open the resolution of the camera is changed  and function fmt set=
=20
> in the ov9655 driver is called
> twice. I use the camera with my one program and it doesn't use crop.

Thanks Stefan, now I can reproduce the problem.
1. Boot the system
2. Capture an image with capture-example from v4l2-apps.

Then I have the shift as in the picture above on the *first* device
open, if I open the device again and capture a second time, without
rebooting, the picture is fine.

I'll let you know if I find more clues of what is causing this
behavior.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__3_Nov_2009_14_45_36_+0100_P7og/J5APh7/oEqC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrwNAAACgkQ5xr2akVTsAHq2ACgpE73WYXzdAEkcRwm9JfeDxf7
ks0An06ZJbWZPQrZD0Af38oigyoT+dm9
=9d8r
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Nov_2009_14_45_36_+0100_P7og/J5APh7/oEqC--
