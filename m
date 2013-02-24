Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52834 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305Ab3BXRCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 12:02:44 -0500
Message-ID: <1361725352.27602.87.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Yasi <joe.yasi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 24 Feb 2013 17:02:32 +0000
In-Reply-To: <CADzA9okDiHo3reO9+xmEXgvvwSsOQM2U69zpw=AwgkmEXGREPw@mail.gmail.com>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
	 <1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
	 <20130224092216.3627110f@redhat.com>
	 <CADzA9okDiHo3reO9+xmEXgvvwSsOQM2U69zpw=AwgkmEXGREPw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mS5rhWc5aKPtyprQxS1e"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-mS5rhWc5aKPtyprQxS1e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-02-24 at 11:36 -0500, Joseph Yasi wrote:
> On Sun, Feb 24, 2013 at 7:22 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Sun, 24 Feb 2013 03:16:35 +0000
> > Ben Hutchings <ben@decadent.org.uk> escreveu:
[...]
> >> For now, I think we should delete the current version.
> >
> > That seems to be the only approach left, if neither Conexant or Hauppau=
ge
> > could help solving this dilema.
>=20
> I agree with removing it from the tree for now. The card doesn't work
> with the current firmware encoder firmware in tree, and it's annoying
> to have the working version extracted from the driver overwritten
> everything a new linux-firmware package is pushed to the Ubuntu
> repositories.

Done.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-mS5rhWc5aKPtyprQxS1e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSpHqOe/yOyVhhEJAQouPw//T8Vzh6y38kfjNE1cr/+ufWO63JfrRgmq
3ApwjQvMHKPDY9bFIfKSYfE4uim7491iCUZ14OGHvhTMCawUYKVm7eGTd2Z4Nn+J
xic+LRl35sxAlJiDhuvfKkU6yXdwEtJJabpoXtatM5bSKQs+1tqPIudQp9ANPtSB
dmMggOpEVqnxZnj6v7vNPMYryfdA8mVGhRhTE1RNphzUMFrbiAby2MIZSp8RmSfY
iBmfsha3EbYpUK+BLY/61ycIifSuUxoPwNoQnGkaPjY+96a90t6h+zYX/qkRVDv0
xG7yqRyeNpfZ6X24ti5vgLJwn6L5GeJStAGnJ+v/HjD4Id7uvonGRbtC1vP6/kuR
yUxLX+rkcMobYXF6aZO7ShlVEGdYXUNHOAeVW/QJQlTI6RbwTV4dGOHBc5Oam9dV
UL9UK4SCOCHvqKRrmhar45WA81Z3uY+B+LFeZ1oE6b5FypEnvFtVUF7k88QF1Siz
iHh2JHsGNUTbN0YDRuF1Y2t5P+eybATZ6DovANgLxi5J+tyRDj88WbAXAWG7dpbS
NsMPfloSxTO31VuFFHmZoj3YYLLTSb2xL6EbyCXXBW4Z8xpKDTyrA/qv0MJAQsUu
+HiAETLXt0M5CgfvgwXUcbWM+K45sHpmrOZs+6F1JmpCWEuefN1EEDP79vZn7t0w
aPDVeHnHVLs=
=LF/I
-----END PGP SIGNATURE-----

--=-mS5rhWc5aKPtyprQxS1e--
