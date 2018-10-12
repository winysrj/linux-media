Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:36964 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbeJMDe3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 23:34:29 -0400
Message-ID: <2878c8fa36f6e775079f53ba79518a53e1ea6bc5.camel@paulk.fr>
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
From: Paul Kocialkowski <contact@paulk.fr>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Fri, 12 Oct 2018 22:00:37 +0200
In-Reply-To: <CAAFQd5Bir0uMsaJPHdgQDvcYHpxZ4sUSn10OPpRXcnn-THUx2A@mail.gmail.com>
References: <20180905220011.16612-1-ezequiel@collabora.com>
         <20180905220011.16612-6-ezequiel@collabora.com>
         <e7126e89d8984eb93216ec75c83ce1fc5afc437d.camel@paulk.fr>
         <CAAFQd5Bir0uMsaJPHdgQDvcYHpxZ4sUSn10OPpRXcnn-THUx2A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KT2J0RnSouw8PFjMAmWn"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-KT2J0RnSouw8PFjMAmWn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 19 septembre 2018 =C3=A0 13:28 +0900, Tomasz Figa a =C3=A9crit =
:
> On Thu, Sep 13, 2018 at 9:15 PM Paul Kocialkowski <contact@paulk.fr> wrot=
e:
> > Hi,
> >=20
> > On Wed, 2018-09-05 at 19:00 -0300, Ezequiel Garcia wrote:
> > > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > >=20
> > > Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
> > > configure the JPEG quantization tables.
> > >=20
> > > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  .../media/uapi/v4l/extended-controls.rst      | 31 +++++++++++++++++=
++
> > >  .../media/videodev2.h.rst.exceptions          |  1 +
> > >  drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
> > >  include/uapi/linux/v4l2-controls.h            | 12 +++++++
> > >  include/uapi/linux/videodev2.h                |  1 +
> > >  5 files changed, 55 insertions(+)
> > >=20
> > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Doc=
umentation/media/uapi/v4l/extended-controls.rst
> > > index 9f7312bf3365..1335d27d30f3 100644
> > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > @@ -3354,7 +3354,38 @@ JPEG Control IDs
> > >      Specify which JPEG markers are included in compressed stream. Th=
is
> > >      control is valid only for encoders.
> > >=20
> > > +.. _jpeg-quant-tables-control:
> >=20
> > I just had a look at how the Allwinner VPU handles JPEG decoding and it
> > seems to require the following information (in addition to
> > quantization):
>=20
> I assume the hardware doesn't have the ability to parse those from the
> stream and so they need to be parsed by user space and given to the
> driver?

That's correct, we are also dealing with a stateless decoder here. It's
actually the same hardware engine that's used for MPEG2 decoding, only
configured differently.

So we will need to introduce a pixfmt for compressed JPEG data without
headers, reuse JPEG controls that apply and perhaps introduce new ones
too if needed.

I am also wondering about how MJPEG support should fit into this. As
far as I understood, it shouldn't be very different from JPEG so we
might want to have common controls for both.

> > * Horizontal and vertical sampling factors for each Y/U/V component:
> >=20
> > The number of components and sampling factors are coded separately in
> > the bitstream, but it's probably easier to use the already-existing
> > V4L2_CID_JPEG_CHROMA_SUBSAMPLING control for specifying that.
> >=20
> > However, this is potentially very much related to the destination
> > format. If we decide that this format should match the format resulting
> > from decompression, we don't need to specify it through an external
> > control. On the other hand, it's possible that the VPU has format
> > conversion block integrated in its pipeline so it would also make sense
> > to consider the destination format as independent.
>=20
> +1 for keeping it separate.

Just like for the stateless decoding API, it would make sense to expect
userspace to set those before enumerating CAPTURE formats in order to
determine what the hardware can output.

> > * Custom Huffman tables (DC and AC), both for luma and chroma
> >=20
> > It seems that there is a default table when no Huffman table is provide=
d
> > in the bitstream (I'm not too sure how standard that is, just started
> > learning about JPEG). We probably need a specific control for that.
>=20
> What happens if there is one in the bitstream? Would the hardware pick
> it automatically?

In our case, this part of the bitstream wouldn't be sent to the
hardware anyway.

> I think it might make sense to just have a general control for Huffman
> table, which would be always provided by the user space, regardless of
> whether it's parsed from the stream or default, so that drivers don't
> have to care and could just always use it.

For MPEG-2 support (and probably also H.265), we have considered the
quantization tables optional and kept a default value in the driver.
That's because said tables are not supported in all profiles, so they
are de-facto optional. I think it's fair to consider that userspace
does not need to implement more than what is needed for decoding. This
makes our interface closer to the data obtained from the bitstream.

However, having one copy of the default table per driver is far from
optimal. I would suggest moving it to common v4l2 functions instead,
but keeping it in kernel space.

What do you think?

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-KT2J0RnSouw8PFjMAmWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlvA/WUACgkQhP3B6o/u
lQydHA//XaEr+l8FVt0vIpDNVROQv0rx++IPIY48JC20j9Lfj/rDyjaziKBVxt/R
y7A/cSbRK4bkEYAhGbG/H2I0hcpoLTH9oHxFh53KX7p2ri0+SGzICilgH7PgSkTH
YXvTZrT7sDelq+Q3t+soAoFjK/J2gNl1Ee0H80pgo4XktumMm+QTHO2HoTmw6EsS
7pIlQoayRC5j+ugOf8d21Rd7KoJm6AIxFV2SWSWnQH75JEbkwEUYhnU3jiIImEQK
JNdY3y2Ur1Lwyi7YrRH4fkF2DzST72/GUBVfZ2tM34EgAInrZhdxvyXbVy/AXO70
01ctNZI5Wu580EC7UlbTRBQeNdGAXC8MFeJwqWGdGuOpJDuhY9PD70v0IOXXFFfP
EBsM5zfPKxYB3zyRNyfbe8JWCZrQlSe46YRb9+xVek/VyiHXXXbySrAf82nQ1THE
Z75Bf70lIUnHtegpikLNcuNXAkDd6tV1FKdG2C5KPFnqymrPNwP1tp7VbFJ849Qy
FuUA/51U1ohnxQgK5lv9meWCyEilO6Nm8KTp/Mo5uBeoy7gfcSTIuISMr7mWvl6l
Tbm13bbd/Xlc6ODK4mH1ewJVSo8XtnKoTrEluwjcm35NEtQ+/8X8y4pY/zWs7lWY
gccjQKV00ppjT7sxV0dX4/KS/Ok+2pkL3icd3w+F1JTabQU+wsw=
=j1HJ
-----END PGP SIGNATURE-----

--=-KT2J0RnSouw8PFjMAmWn--
