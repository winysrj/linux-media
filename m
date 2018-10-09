Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:35400 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbeJJBGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 21:06:34 -0400
Message-ID: <21f6b66ea646c6e24e5801023557e8b5db3831d6.camel@paulk.fr>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 09 Oct 2018 19:48:09 +0200
In-Reply-To: <CAAFQd5A4t1F9kqepJ+11GJj7zJWKTp-bD1aCNL0N1w9Qeqtmuw@mail.gmail.com>
References: <20181004081119.102575-1-acourbot@chromium.org>
         <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
         <CAAFQd5A4t1F9kqepJ+11GJj7zJWKTp-bD1aCNL0N1w9Qeqtmuw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NJuvIF4jZV9m01lN8MZm"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-NJuvIF4jZV9m01lN8MZm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 09 octobre 2018 =C3=A0 16:30 +0900, Tomasz Figa a =C3=A9crit :
> On Thu, Oct 4, 2018 at 9:46 PM Paul Kocialkowski <contact@paulk.fr> wrote=
:
> >=20
> > Hi,
> >=20
> > Here are a few minor suggestion about H.264 controls.
> >=20
> > Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9=
crit :
> > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Doc=
umentation/media/uapi/v4l/extended-controls.rst
> > > index a9252225b63e..9d06d853d4ff 100644
> > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > @@ -810,6 +810,31 @@ enum v4l2_mpeg_video_bitrate_mode -
> > >      otherwise the decoder expects a single frame in per buffer.
> > >      Applicable to the decoder, all codecs.
> > >=20
> > > +.. _v4l2-mpeg-h264:
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_SPS``
> > > +    Instance of struct v4l2_ctrl_h264_sps, containing the SPS of to =
use with
> > > +    the next queued frame. Applicable to the H.264 stateless decoder=
.
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_PPS``
> > > +    Instance of struct v4l2_ctrl_h264_pps, containing the PPS of to =
use with
> > > +    the next queued frame. Applicable to the H.264 stateless decoder=
.
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX``
> >=20
> > For consistency with MPEG-2 and upcoming JPEG, I think we should call
> > this "H264_QUANTIZATION".
>=20
> I'd rather stay consistent with H.264 specification, which uses the
> wording as defined in Alex's patch. Otherwise it would be difficult to
> correlate between the controls and the specification, which is
> something that the userspace developer would definitely need to
> understand how to properly parse the stream and obtain the decoding
> parameters.

Okay, I agree this makes more sense than trying to keep the names
consistent across codecs.

> >=20
> > > +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the=
 scaling
> > > +    matrix to use when decoding the next queued frame. Applicable to=
 the H.264
> > > +    stateless decoder.
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``
> >=20
> > Ditto with "H264_SLICE_PARAMS".
> >=20
>=20
> It doesn't seem to be related to the spec in this case and "params"
> sounds better indeed.

Cheers,

Paul

--=-NJuvIF4jZV9m01lN8MZm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlu86dkACgkQhP3B6o/u
lQwvgw/+NzUyPZU/e3+Obp5UTRuXVtUTm/zTLzu9q6MRD4VMlAlrs4IEMDwEWk7/
oBIaNWSTF2cz//wPpfz6RqnqHHK9BsKVOBYi13o1SGUFRZPK2g50H1iloSNvfwRT
kZ8gZgDOM4UGyly9zwv749pJHoWjcXFzXU+2kFdhdcbpjxJfEVKS9CmgUJH/ZptG
aixn6UXkToZ24Hm/QazAQcPk4G4gqJHB5tE6AP/QhrgntS3U+JWcPayStSx1zaJp
UHxDqGjLxHMbw0g7haK7WngsOBbi+v9AQJeFaoHDI/P7VhJd18AirFnuEYr90CjA
OfAo2MPK900abYmtgm2IRTGO98G5zAwlZ0GlX5TVo0mdIGKeo6oZZGEnsYMhaX3D
LWR6EY4UBhZT0M6XlK1P+85AHknzw6kcorFtNrD3GRIx4BGL8f4o/gnxD1Fx/yo0
W/t5ywwgw52M8YOt4ZRNIxuWOUiewzRS79sWNPTHEELTDs8lna2ONUxFIh3CL7w8
MuVCcQvpCX9vAjRkVAAOdXjZxM11aOfduvKvZIvukDNpSgumqq8W4v3ZHib4TF9s
rBN/6L/NRoLqX+SupzL4egAfNHSg/OKBDzR3b9BOgbyKAEa0cFPyQXHl+TXx2eld
qfiO1UUbGCJcSgLP+4KVut6AUX6sZe3BzhBV0gJMu+9o21EfeL0=
=62QB
-----END PGP SIGNATURE-----

--=-NJuvIF4jZV9m01lN8MZm--
