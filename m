Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40507 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaCPWlu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 18:41:50 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so547907wib.3
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 15:41:48 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Date: Sun, 16 Mar 2014 22:41:26 +0000
Message-ID: <2300906.aKyjnYIEg7@radagast>
In-Reply-To: <CAKv9HNav3DYRcX8B_N5db012-ShoGVc7rbLW1oWV-rgcwDaGmg@mail.gmail.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <CAKv9HNav3DYRcX8B_N5db012-ShoGVc7rbLW1oWV-rgcwDaGmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1834805.NHZYVrBXem"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1834805.NHZYVrBXem
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 16 March 2014 10:22:02 Antti Sepp=E4l=E4 wrote:
> On 15 March 2014 01:04, James Hogan <james@albanarts.com> wrote:
> > A recent discussion about proposed interfaces for setting up the
> > hardware wakeup filter lead to the conclusion that it could help to=
 have
> > the generic capability to encode and modulate scancodes into raw IR=

> > events so that drivers for hardware with a low level wake filter (o=
n the
> > level of pulse/space durations) can still easily implement the high=
er
> > level scancode interface that is proposed.
> >=20
> > I posted an RFC patchset showing how this could work, and Antti Sep=
p=E4l=E4
> > posted additional patches to support rc5-sz and nuvoton-cir. This
> > patchset improves the original RFC patches and combines & updates
> > Antti's patches.
> >=20
> > I'm happy these patches are a good start at tackling the problem, a=
s
> > long as Antti is happy with them and they work for him of course.
> >=20
> > Future work could include:
> >  - Encoders for more protocols.
> >  - Carrier signal events (no use unless a driver makes use of it).
> >=20
> > Patch 1 adds the new encode API.
> > Patches 2-3 adds some modulation helpers.
> > Patches 4-6 adds some raw encode implementations.
> > Patch 7 adds some rc-core support for encode based wakeup filtering=
.
> > Patch 8 adds debug loopback of encoded scancode when filter set.
> > Patch 9 (untested) adds encode based wakeup filtering to nuvoton-ci=
r.
>=20
> Hi James.
>=20
> This is looking very good. I've reviewed the series and have only
> minor comments to some of the patches which I'll post individually
> shortly.
>=20
> I've also tested the nuvoton with actual hardware with rc-5-sz and ne=
c
> encoders and both generate wakeup samples correctly and can wake the
> system.

Thanks for reviewing and testing!

> While doing my tests I also noticed that there is a small bug in the
> wakeup_protocols handling where one can enable multiple protocols wit=
h
> the + -notation. E.g. echo "+nec +rc-5" >
> /sys/class/rc/rc0/wakeup_protocols shouldn't probably succeed.

Yeh I'm in two minds about this now. It's actually a little awkward sin=
ce some=20
of the protocols have multiple variants (i.e. "rc-5" =3D RC5+RC5X), but=
 an=20
encoded message is only ever a single variant, so technically if you're=
 going=20
to draw the line for wakeup protocols it should probably be at one enab=
led=20
variant, which isn't always convenient or necessary.

Note, ATM even disallowing "+proto" and "-proto" we would already have =
to=20
guess which variant is desired from the scancode data, which in the cas=
e of=20
NEC scancodes is a bit horrid since NEC scancodes are ambiguous. This a=
ctually=20
means it's driver specific whether a filter mask of 0x0000ffff filters =
out=20
NEC32/NEC-X messages (scancode/encode driver probably will since it nee=
ds to=20
pick a variant, but software fallback won't).

Ideally there'd now be a way to specify the protocol variants exactly a=
s well=20
as whole protocols groups through this sysfs interface (and probably NE=
C=20
should have protocol bits for each variant too, which is tricky ATM sin=
ce=20
keymaps can use scancodes of multiple variants and it's hard to guarant=
ee=20
which variant was intended for each key mapping by reading it).

Adding proto_names entries for each variant is easy enough, though I'm =
not=20
sure what you'd call the one for RC_BIT_RC5 (since "rc-5" is taken to m=
ean=20
both RC5 and RC5X). We could then check that the enabled wakeup protoco=
ls fit=20
entirely within one of the proto_names entry's proto mask if we think i=
t's=20
helpful (which would allow you to specify e.g. "sony12", or "sony" (son=
y=20
12,15,20), or "sony -sony12" (sony 15,20), but not "+sony +nec").

Cheers
James
--nextPart1834805.NHZYVrBXem
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTJiijAAoJEGwLaZPeOHZ6CG8P/jaiWh7GJU3EjqzyZQKlXFQj
OMuoUvMFXhNTt+UTTUL2QUQepKc3mYccay0fzjYstSJSq2qMryuiyrOYMb6q9XXF
vwmYfce6QjS70liXOLN5QSEjzZFetqtu0gI/nyvAsSP5JCWQg7UQNNMWIKH6UR8D
jrCkuT2yGpymsf4ilyDaCmTyvqEOzZUCEKxyb9nCTrD1Ft+5jgcYzlSEhiUilsmL
hml8xqgznpAZW+gknJ1bw25tIUQ4v67X6jLnkyr9p/XBr/hk+nDFXJjvJTKhNAKk
a+5Vy3qkIFEvXARtG6yyiFO3+wXqpLCoaeMEvLbODTKLQC7ftnlIQEZxhb1bBFO6
tWl3DtN5bLcoWIRmpD9N6EYWWiVOC3l3sXK8dx5bj7Jxk4G5moDVS8RqvLSnQD1q
NDcTB9dcTeacZzVK0jPL3dAJrGsmsVmd4UsmI39l/t+7dmBqCANODwMn50NVWH/T
rctkm2Y5bKErLswTOSsF7iqZYroTjJrFeN2DM0eXN2q8Y1G6kBKFCdmpTU6t12Xu
Gnz1RiOsth3u2M4FoC3dhbYmhrfygJtFaVLntbFkkzHJDleuEw5ZbIRu5aSml0Hm
fuZH+i7Zp2DSFOpSUCSwMpIu4j+afkceM68eva5SSLCRtT24bZyfBN9U80NtY2fg
ZVSZKzmASKK7MZVFuHP0
=50TO
-----END PGP SIGNATURE-----

--nextPart1834805.NHZYVrBXem--

