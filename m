Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40811 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728886AbeHVQqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 12:46:14 -0400
Message-ID: <2ce0778a85616ea71d9ca493372b645b5858dc81.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Wed, 22 Aug 2018 15:21:04 +0200
In-Reply-To: <CAHStOZ5aU5N5UssqqSTU8YRN7nmGCX7H0eGO0GeB=AN0YK53dQ@mail.gmail.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <CAHStOZ5aU5N5UssqqSTU8YRN7nmGCX7H0eGO0GeB=AN0YK53dQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-U8C4YbhnA6XBhEnA/gvz"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-U8C4YbhnA6XBhEnA/gvz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

[...]

On Wed, 2018-08-15 at 14:51 +0200, Maxime Jourdan wrote:
> Hi Paul, I think we need to go deeper than just exposing the supported
> profiles/levels and also include a way to query the CAPTURE pixel
> formats that are supported for each profile.
>=20
> Maybe HEVC Main produces yuv420p but HEVC Main10 gives you
> yuv420p10le. Maybe H.264 HiP produces NV12 but H.264 Hi422P produces
> YUYV while also supporting down-sampling to NV12.

Well, I think we're looking at this backwards. Userspace certainly known
what destination format is relevant for the video, so it shouldn't have
to query the driver about it except to check that the format is indeed
supported.

> I don't know the specifics of each platform and the only example I can
> think of is the Amlogic HEVC decoder that can produce NV12 for Main,
> but only outputs a compressed proprietary format for Main10.
>=20
> I unfortunately don't have an idea about how to implement that, but
> I'll think about it.

On the first generations of Allwinner platforms, we also have a vendor-
specific format as output, that we expose with a dedicated format.
There's no particular interfacing issue with that. Only that userspace
has to be aware of the format and how to deal with it.

Cheers,

Paul

> > Cheers,
> >=20
> > Paul
> >=20
> > --
> > Paul Kocialkowski, Bootlin (formerly Free Electrons)
> > Embedded Linux and kernel engineering
> > https://bootlin.com
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-U8C4YbhnA6XBhEnA/gvz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt9Y0AACgkQ3cLmz3+f
v9GouAf/ae550kJA16HvjRNQwThjd+ygeGWYLmD61fK4Xd0pS8HuObsAmfUJaeJF
+IAuiDk/PqdQA24+IN2A50jrczsbXSN7O9IX2wN+zZL86i0lxbFry50oTT9xfs43
gRtXKhA1JUtWE/Dbc6fPve/dzABspMVblw3p2aUtvaAbJvh4ZkB9DkbReRNkrAji
axOSExJab/+KfRXSJlQyOyz8vxvAxjYzCbxVOwpNh/PQHktqVBeoIcREF0r9TxLq
Ous6NF9YSNTv+MmNjwJmNoxaW4BbXTzuex1nAjCwN+yu+0B9ULzx/BbRDLgOU8pv
OBT2OU5TZyXUjIa1uZBEOh+HRqikMQ==
=IAEE
-----END PGP SIGNATURE-----

--=-U8C4YbhnA6XBhEnA/gvz--
