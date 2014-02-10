Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:39844 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBJUvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 15:51:49 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so4565416wes.24
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 12:51:48 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
Date: Mon, 10 Feb 2014 20:50:53 +0000
Message-ID: <2457095.pZsX4lrjVF@radagast>
In-Reply-To: <CAKv9HNZj2Jr4GnHXAtvqfaVsmQFVUxBmZZT-rBePoHB0X8ShiA@mail.gmail.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com> <52F8AA42.2020409@imgtec.com> <CAKv9HNZj2Jr4GnHXAtvqfaVsmQFVUxBmZZT-rBePoHB0X8ShiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5206858.E7JalZ8tkC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart5206858.E7JalZ8tkC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Antti,

On Monday 10 February 2014 22:09:33 Antti Sepp=E4l=E4 wrote:
> >> +static int ir_rc5_sz_encode(u64 protocols,
> >> +                         const struct rc_scancode_filter *scancod=
e,
> >> +                         struct ir_raw_event *events, unsigned in=
t max)
> >> +{
> >> +     int ret;
> >> +     struct ir_raw_event *e =3D events;
> >=20
> > Probably worth checking scancode->mask =3D=3D 0xfff too?
>=20
> I guess so. However if I'm not mistaken this makes all wakeup_filter
> writes fail in user space if wakeup_filter_mask is not set. Is that
> intended?

Good point, although looking at your patch 3, mask=3D=3D0 is already pe=
rmitted=20
silently by the driver, which I think would make it okay.

I guess to be safe userland would have to do:
wakeup_filter_mask =3D 0
wakeup_filter =3D $value
wakeup_filter_mask =3D 0xfff

which doesn't sound unreasonable in the absence of a way to update them=
=20
atomically (sysfs files doing more than one thing is frowned upon I bel=
ieve).

> >> +     /* RC5-SZ scancode is raw enough for manchester as it is */
> >> +     ret =3D ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
> >> RC5_SZ_NBITS, +                                 scancode->data);
> >> +     if (ret < 0)
> >> +             return ret;
> >=20
> > I suspect it needs some more space at the end too, to be sure that =
no
> > more bits afterwards are accepted.
>=20
> I'm sorry but I'm not sure I completely understood what you meant
> here. For RC-5-SZ the entire scancode gets encoded and nothing more.
> Do you mean that the encoder should append some ir silence to the end=

> result to make sure the ir sample has ended?

Yeh something like that. Certainly the raw decoders I've looked at expe=
ct a=20
certain amount of space at the end to avoid decoding part of a longer p=
rotocol=20
(it's in the pulse distance helper as the trailer space timing). Simila=
rly the=20
IMG hardware decoder has register fields for the free-time to require a=
t the=20
end of the message.

In fact it becomes a bit awkward for the raw IR driver for the IMG hard=
ware=20
which uses edge interrupts, as it has to have a timeout to emit a final=
 repeat=20
event after 150ms of inactivity, in order for the raw decoders to accep=
t it=20
(unless you hold the button down in which case the repeat code edges re=
sult in=20
the long space).

Cheers
James
--nextPart5206858.E7JalZ8tkC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJS+TvhAAoJEKHZs+irPybfmZQQAIDFlDSXXydX1hqtBzExEg4p
whZ6AA6bk5mfaS0IWE3clgyjVSd2FxMQspEk2LmPQxYylO61H5cy4tPCV+v4qvPY
RoSKpcUuoyJpMBA3lhDeMMhJEsDbLvYCSjePkDImCEMqOmvLV7Vfbi+OqA3MHQ2E
6EUunRY0SfVGFRfOTJtF1erXT9RaI6cZ7uEbBSEixrdBHOPteuPlW0c5hX9iKedp
Gl/hiX13cDiCiLfh+B9TEGc4BKRu6KHkQkS0RfMj02bABDdWMSN72KP2iuPn2toa
3iJtG0VqSchvME6xtE8+M7jd87RrAVRKQj+nVEg0Of8SHyZFeqY5fMNxmKBI4VlU
L/c6RRde2d6KL0FBbKGFPvRSjFqttBf9Jg0dfaneJuObo9fL7EQSncszW0jloOBJ
bo8hI0Urz19MNqiEkPZqVFn8vB7Eily7Rm4Jv25KlYqqkDPLyaxNUGQ+PvlwS04f
0y5e+UiasUra1ogn+Gh+HFbv/VtfAFnN0s6p3GGnigXps2+MWo3qwqAK8im5l8hA
VIGSzO56LGZkCdEWeiTxD3Nkfrvj7Lv4SoeBnbZrIXycEbErgPex/HzecYMn26vg
kelHt+mcC6/nm4W8R3ibr/YXTb3SGOf9W1/GubKSNMxqes+AThhLo3HDBHZj0o01
OBfF/Zhve27qWA0t6fGs
=qSN5
-----END PGP SIGNATURE-----

--nextPart5206858.E7JalZ8tkC--

