Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36976 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaCQWen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 18:34:43 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so5133291wes.39
        for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 15:34:41 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Date: Mon, 17 Mar 2014 22:34:25 +0000
Message-ID: <1894298.cUReo31JQU@radagast>
In-Reply-To: <CAKv9HNbwftG5-mz6uLKH68AuHOK-PgDB4AZa0qHEWCXKL_+q+A@mail.gmail.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <2300906.aKyjnYIEg7@radagast> <CAKv9HNbwftG5-mz6uLKH68AuHOK-PgDB4AZa0qHEWCXKL_+q+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2813516.L4OhfK5FRi"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2813516.L4OhfK5FRi
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Monday 17 March 2014 19:01:51 Antti Sepp=E4l=E4 wrote:
> On 17 March 2014 00:41, James Hogan <james@albanarts.com> wrote:
> > Yeh I'm in two minds about this now. It's actually a little awkward=
 since
> > some of the protocols have multiple variants (i.e. "rc-5" =3D RC5+R=
C5X),
> > but an encoded message is only ever a single variant, so technicall=
y if
> > you're going to draw the line for wakeup protocols it should probab=
ly be
> > at one enabled variant, which isn't always convenient or necessary.=

>=20
> I'd very much prefer to have the selector as it currently is -
> protocol groups instead of variants which would keep it consistent
> with decoding protocol selection.

Yeh, I'll submit a patch to fix wakeup-protocols to disallow multiple g=
roups=20
of protocols from being enabled at the same time.

> > Note, ATM even disallowing "+proto" and "-proto" we would already h=
ave to
> > guess which variant is desired from the scancode data, which in the=
 case
> > of
> > NEC scancodes is a bit horrid since NEC scancodes are ambiguous. Th=
is
> > actually means it's driver specific whether a filter mask of 0x0000=
ffff
> > filters out NEC32/NEC-X messages (scancode/encode driver probably w=
ill
> > since it needs to pick a variant, but software fallback won't).
>=20
> How common is it that NEC codes are really ambiguous? Or that a wrong=

> variant is selected for encoding? A quick look suggests that the
> length of the scancode will be good enough way to determine which
> variant is used for NEC, RC-5(X) and RC-6(A).

When I tried filtering for my TV remote it didn't work. It turned out t=
o be=20
because the extended nec scancode has the address bytes in the wrong or=
der so=20
that the bits are discontinuous compared to the raw data. The remote us=
es=20
extended NEC but has zero in the lower byte of the address, which=20
unfortunately goes in bits 23:16 of the scancode above the other byte o=
f the=20
address, so it looks as if it's using normal NEC (16bit scancodes). Thi=
s is=20
why I ended up making img-ir use the mask too in the decision.

It's ambiguous the other way too (which is probably a strong point agai=
nst=20
having actual protocol bits for each NEC variant, since they only diffe=
r in=20
how the scancode is constructed). E.g. the Tivo keymap is 32-bit NEC, b=
ut has=20
extended NEC scancodes where the bytes of the command are complements (=
i.e.=20
the extended NEC command checksum passes). This makes it hard to filter=
 on at=20
the scancode level (the drivers will probably get it right for the hard=
ware=20
filters, but the software filter will likely get it wrong in those corn=
er=20
cases since it knows nothing of NEC).

There's multiple ways the NEC scancode formats could be improved=20
(incompatibly!) to reduce the problems, but none are perfect.

E.g. one possibility is to scrap the NEC and extended NEC scancodes and=
 just=20
use 32-bit NEC scancodes format throughout:
0x[16-bit-address][16-bit-command]

which encodes scancodes for extended NEC like this:
0x[16-bit-address][~8-bit-command][8-bit-command]

and normal NEC like this:
0x[~8-bit-address][8-bit-address][~8-bit-command][8-bit-command]

Thanks
James
--nextPart2813516.L4OhfK5FRi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTJ3h5AAoJEGwLaZPeOHZ6XDEQAKNc6xiOcbnBiwfSh59fEBm1
IbAAK1NtcAX36nnSdlkf2uoL0B1FP7zk0xwTtjJCy4e/M0TZFkSW6Yo8kx0HFItP
JroieIhQAhfQuq8gdZgGSekQv1KEYplTNGXFyFo9vj0VlIzKFdh4ZmHO3G/t1oDU
n2MFSuvf1KjBxS5+0zCqSR8z53T+WCHBnllmDI/vF3nEhkYS6GEfvtlR0Y2QtmUh
C/d4dVHPU740vW5UQ/rHkj4MpoekvVzbZ8m5Ee7WMGyfitbVaefA9wUQUTan4jqn
92pGM7iBbHKJtWdpq/LC1kKAjF7kw5rrLJZAD3IqQBwUp+62pfoNLErjxZIY+3sr
cMhyBxRkD9oNJHsEcJF1cle3UVKSb5p1AgDXOpqruiEqb+/GLwwVgOoJgf03ipD+
0BC6Los41w+C0DTNWdNnDm67suVMR24kAQmO/DH+JO2tgxDWkTVTgJw5w+GAHys+
UhOCo2VOQAGuAIohDDUZXI8w3ONS0HGWffvUYsFwsEeJ8kbauitwwf8y4OrDcr+h
BT4wnGK3e8PxpbjMVTc2pTrVSFGLLPDtJDK+6vCusJZHcUXzRCDrlcBW1AMLIy1c
1bXRHfqjUg92OD2SBxC9atVlVfpLaDzN3+L4Qy+SOLR+k8fC1KH1YmmzDyzoswIJ
+r/mnwdRS3kxcMdp3Wig
=bpd4
-----END PGP SIGNATURE-----

--nextPart2813516.L4OhfK5FRi--

