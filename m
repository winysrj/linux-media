Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47699 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaCPLvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 07:51:20 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so1110912wib.8
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 04:51:19 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
Date: Sun, 16 Mar 2014 11:50:58 +0000
Message-ID: <3611058.9Umk0NSF20@radagast>
In-Reply-To: <CAKv9HNYgfoAnTHfivgo8tov4nkSZHZ2+qJ=1BJzXUHXDmDSm2w@mail.gmail.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com> <1394838259-14260-7-git-send-email-james@albanarts.com> <CAKv9HNYgfoAnTHfivgo8tov4nkSZHZ2+qJ=1BJzXUHXDmDSm2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2643478.EziVktpIlE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2643478.EziVktpIlE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Antti,

On Sunday 16 March 2014 10:34:31 Antti Sepp=E4l=E4 wrote:
> > +/**
> > + * ir_rc5_sz_encode() - Encode a scancode as a stream of raw event=
s
> > + *
> > + * @protocols: allowed protocols
> > + * @scancode:  scancode filter describing scancode (helps distingu=
ish
> > between + *             protocol subtypes when scancode is ambiguou=
s)
> > + * @events:    array of raw ir events to write into
> > + * @max:       maximum size of @events
> > + *
> > + * Returns:    The number of events written.
> > + *             -ENOBUFS if there isn't enough space in the array t=
o fit
> > the + *             encoding. In this case all @max events will hav=
e been
> > written. + *             -EINVAL if the scancode is ambiguous or in=
valid.
> > + */
> > +static int ir_rc5_sz_encode(u64 protocols,
> > +                           const struct rc_scancode_filter *scanco=
de,
> > +                           struct ir_raw_event *events, unsigned i=
nt max)
> > +{
> > +       int ret;
> > +       struct ir_raw_event *e =3D events;
> > +
> > +       /* all important bits of scancode should be set in mask */
> > +       if (~scancode->mask & 0x2fff)
>=20
> Do we want to be so restrictive here? In my opinion it's quite nice t=
o
> be able to encode also the toggle bit if needed. Therefore a check
> against 0x3fff would be a better choice.
>=20
> I think the ability to encode toggle bit might also be nice to have
> for rc-5(x) also.
>=20

I don't believe the toggle bit is encoded in the scancode though, so I'=
m not=20
sure it makes sense to treat it like that. I'm not an expert on RC-5 li=
ke=20
protocols or the use of the toggle bit though.

> > +               return -EINVAL;
> > +       /* extra bits in mask should be zero in data */
> > +       if (scancode->mask & scancode->data & ~0x2fff)
> > +               return -EINVAL;
> > +
> > +       /* RC5-SZ scancode is raw enough for Manchester as it is */=

> > +       ret =3D ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
> > RC5_SZ_NBITS, +                                   scancode->data &
> > 0x2fff);
>=20
> I'm not sure that the & 0x2fff is necessary. It has the ill effect of=

> eventually writing something else to hardware while still committing
> the filter as unmodified original value. This will result in
> difference between what sysfs states was written when read back and
> what was actually written.
>=20
> I think checks above are good enough to restrict the values and as
> little modification as possible of the data should be done after that=
.

I suspect it was the toggle bit I was thinking about, e.g.
echo 0x3fff > wakeup_filter
echo 0x2fff > wakeup_filter_mask

I had assumed shouldn't be able to affect the toggle bit (it's not set =
in=20
mask).

Cheers
James
--nextPart2643478.EziVktpIlE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTJZAqAAoJEGwLaZPeOHZ6mzMP/3NCU2s53AByUSo6DjvwcquA
1ARnSu1Y4G7AZJXw67C0+3Q3glISdKQUTytYhCT2dwedqDuk+XFlj23MI6E54YjR
UHTlyXAtfPW4w1FZ2tk1Rykt7c395K8EMav2802MPSspDFKkXWZbDkdFrmS3PMzV
E/4b/a6jL57C1CpAsGlwiIRMIcGKxypjwFO4L0I5oGsIwF8YRPF/nOTwvdT+HqwS
9kCR1LpSaoo85JklJD0OucDppVpG6Z0p6RGPVPeK4qTHPfCrRJHQoAFtZA/uWR0X
Mo/U8NKzspDdUDJCruw3WURtvDbjJf9LP2aOqj33pRYXm9BMviYGHM6UuZtHYfqp
o86HDXP9DFe5Mplt5ifcGJRmdw00zEq/odfkzzlkQcla2q68/+UkzXiPoNcBs7Ho
uZkMtFsbhlTQu2J9CH9V2y5ijJ2eJP9fIWla8b6PGM6SLOS9ffp+VG6k1hOcJfuO
+N3k2x7NpXx3UbMni4sjudo7+rRw6pjBXItw8T5eWT31BT8K/lUy2KRNpPsSz3hQ
65BCRIqWgjfsWClLl7CkLmOoWrJlnPa2vLGsvjF5CxGKLq9DtNW1DRL6meKgVygU
IkdMc+dAAw7yC0eTgd457JUI2EiE4tFQCyxRuKfM3UVyFZgk8olFVUV0Qa6UrO1k
BZYUuaf4U87x2Uggx0XJ
=KdbJ
-----END PGP SIGNATURE-----

--nextPart2643478.EziVktpIlE--

