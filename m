Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54211 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaCPVSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 17:18:36 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so3955241wgh.12
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 14:18:34 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
Date: Sun, 16 Mar 2014 21:18:18 +0000
Message-ID: <8310082.IFEfXeL82D@radagast>
In-Reply-To: <CAKv9HNZipt2RWn1mf_X8Rt+udb-jmDLMDJThRJjYUmkovyCTzA@mail.gmail.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <3611058.9Umk0NSF20@radagast> <CAKv9HNZipt2RWn1mf_X8Rt+udb-jmDLMDJThRJjYUmkovyCTzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1467220.XGyDQCnH8r"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1467220.XGyDQCnH8r
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 16 March 2014 14:14:58 Antti Sepp=E4l=E4 wrote:
> Hi James.
>=20
> On 16 March 2014 13:50, James Hogan <james@albanarts.com> wrote:
> > Hi Antti,
> >=20
> > On Sunday 16 March 2014 10:34:31 Antti Sepp=E4l=E4 wrote:
> >> > +
> >> > +       /* all important bits of scancode should be set in mask =
*/
> >> > +       if (~scancode->mask & 0x2fff)
> >>=20
> >> Do we want to be so restrictive here? In my opinion it's quite nic=
e to
> >> be able to encode also the toggle bit if needed. Therefore a check=

> >> against 0x3fff would be a better choice.
> >>=20
> >> I think the ability to encode toggle bit might also be nice to hav=
e
> >> for rc-5(x) also.
> >=20
> > I don't believe the toggle bit is encoded in the scancode though, s=
o I'm
> > not sure it makes sense to treat it like that. I'm not an expert on=
 RC-5
> > like protocols or the use of the toggle bit though.
>=20
> Well I'm not an expert either but at least streamzap tends to have th=
e
> toggle bit enabled quite often when sending ir pulses.
>=20
> When decoding the toggle is always removed from the scancode but when=

> encoding it would be useful to have the possibility to encode it in.
> This is because setting the toggle bit into wakeup makes it easier to=

> wake the system with nuvoton hw as it is difficult to press the remot=
e
> key short time enough (less than around 112ms) to generate a pulse
> without the toggle bit set.

Fair enough. So changing the minimum rc5-sz masks to 0x3fff sounds reas=
onable=20
to allow toggle to be controlled.

Just to clarify though, so you mean that the remote uses toggle=3D1 fir=
st (and=20
in repeat codes) unless you press it a second time (new keypress) withi=
n a=20
short amount of time?
I.e. like this?
Press=09message toggle=3D1
=09=09repeat toggle=3D1
=09=09repeat toggle=3D1
unpress
Press=09message toggle=3D!last_toggle only if within X ms, 1 otherwise

Sounds like for RC-5/RC-5X toggle should probably be taken from 0x00002=
000,=20
0x00200000 of scancode respectively (just above "system" in both cases)=
.

Cheers
James
--nextPart1467220.XGyDQCnH8r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTJhUiAAoJEGwLaZPeOHZ657gP/3100ZdzVg6STHlXvo5O4Yny
oz0FyiKVxr2y60k87bSlyxaOSZWyqkYqR6l8jAKKI8JKOSiURc3XN+NrJo6CF4ti
S7yz7wrfgR6pWO7ciWGZ7dZytcibV906Eqdx1y9AosNhosBK3BubpaYsgkk3QZEV
3lyPx0MnFkGY6BExf+ZYC81J47ZC0jWe4u/fE5rvEyjsKDgdZFj1AmYrxLWc8jrU
awTXGyjAr7u/nDvrQzmAE3XnsGqEtynT+jnjFji6pWJuuqgLy2fmvtR6Oy5sDIGO
0z1pWm8S6d6gte1SYepcbuqslaKwiFZ1QXpYkxJF563i7nM3WVFPuZsQTAh7q36n
55vrYb0EaC1UHaIXE8C+1S7K/5j/Iw11nLjQksl/Jdn2xSxlzPQXG2RY3AfP6Lk/
f9Wx69buIIQniDTf6qCbsYlqS7ZnnR5e56HvFEP4cbC+NQAuQTxbCYeyniYnL2Qz
fTL4M0Ey36/7ru98WM4nazL+MSr4dMOgNg0TyDf9qsQCroFSoNcFCb6EaGbrjcyZ
HZBgk1M/qT07AiGX6apWgu3Yjp0sHHmCulNM+yLyoHtCQPL009Mz/dtRYvu0lxRs
eTH8KJ0baESF2vPs+XbjHS+MH/W99oYuTSn8R2X8QoYRohek73FB7v4kgnTUG9hH
hyjCnMs5tbaOmO+obW0D
=Xk/Y
-----END PGP SIGNATURE-----

--nextPart1467220.XGyDQCnH8r--

