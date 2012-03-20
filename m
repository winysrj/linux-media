Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49850 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2CTQhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 12:37:36 -0400
Date: Tue, 20 Mar 2012 17:37:24 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: gennarone@gmail.com
Cc: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] Basic AF9035/AF9033 driver
Message-ID: <20120320173724.4d3f2f0f@milhouse>
In-Reply-To: <4F68B001.1050809@gmail.com>
References: <201202222321.43972.hfvogt@gmx.net>
	<4F67CF24.8050601@redhat.com>
	<20120320140411.58b5808b@milhouse>
	<4F68B001.1050809@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=6UdQPWNWsUidNnt0rDQg9q"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/=6UdQPWNWsUidNnt0rDQg9q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Mar 2012 17:27:45 +0100
Gianluca Gennari <gennarone@gmail.com> wrote:

> Hi Michael,
>=20
> Il 20/03/2012 14:04, Michael B=C3=BCsch ha scritto:
> > Thank you for working on a af903x driver.
> >=20
> > I tried to test the driver on a debian 3.2 kernel, after applying a sma=
ll fix:
> > It should be CONFIG_DVB_USB_AF903X here.
>=20
> this issue is fixed in version "1.02" of the driver, posted by Hans a
> few days ago.

I can only find the post from Feb 22th, which includes this glitch.
Can you point me to the newer post in the list archives?

> > So I'm wondering how big the differences between the fc0011 and fc0012 =
are.
> > Can the 0011 be implemented in the 0012 driver, or does it require a se=
parate driver?
> > Please give me a few hints, to I can work on implementing support for t=
hat tuner.
>=20
> I have no idea about the real differences between the two tuner models,
> but here you can find an old "leaked" af9035 driver with support for
> several tuners, including fc0011 and fc0012:
>=20
> https://bitbucket.org/voltagex/af9035/src
>
> (look under the "api" subdir for the tuners).

Yeah I know about that "thing". It makes my eyes bleed, though.

But the author of this document pointed me to this:
http://linuxtv.org/wiki/index.php/Fitipower
That seems pretty useful, in addition to the existing crap driver.

> The driver is not working with recent kernels, but probably you can
> extract the information needed to implement a proper kernel driver for
> fc0011, using the fc0012 driver written by Hans as a reference.

Yeah after looking at things it seems best to have a separate module.
I already started to put the boilerplate code together and I'm currently
putting the various device specific bits in place.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/=6UdQPWNWsUidNnt0rDQg9q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPaLJEAAoJEPUyvh2QjYsOot0QALnBK5SOPSWq2gGIEgyg4zlV
dMdmjdpUcm1i4ffoyqn/eALNcOM+WGTEdObfaz3BPKniCFHufYv++qdT9zC53iH7
Pb9IZXsXAU8aS00qhfV0kSTJY0A/C3Q9VwWzNK6uGbgy0JTdxBoU+qaqC0etjiWq
wGG4eALyOchH0sI2TskR7iz7oXIxXg62JwdYWjHMHCbZ0Qw6vh05mkMMLt9bzipQ
GwYMaaFwEQ7lBZvn7UdQbhftVeR+HtNGjSUOns2lT5GMX4N3u3FDOq+VZb0wnQ3Z
nZJjCTbqJ9XXPcqMgeiYsvASzkQuaqDcdNuzib6la/usW3zTgZ9WTpXXvxE9O9jo
9KYLJRXdL6RxWGkPBRnc0MftlDatrzS4QUNYV6EdEdEP7OyXK+bM2/1quTANv85b
ySDajKX9sVaCaO2dylt+4jqEtSpKKhMHNmNlVoM9AwpZc804U00MHGg8aQ3loL2c
UhhdG/CwQowzZhjdJjsc9k3yJfPN/8oq4pZLL6UxXXVa4+FcDdIiBB6SyDe5qz0y
pRCdQtroGvGLGditG/cLnkmL+XQ3mPj6qNEzGI/mgkYTN2QVqXtnOgAv+z4ezCwU
hRDTWbUWZMgR4334m7uBQWTOHDs9R36Lrn5ExalMUxvbS+HDZONAcO1ueXWrdb9B
5oeM7/qjnu1m8htcnEGH
=FTHt
-----END PGP SIGNATURE-----

--Sig_/=6UdQPWNWsUidNnt0rDQg9q--
