Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:32890 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbeJDTeC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 15:34:02 -0400
Message-ID: <7bd6883f43f3ffa1803975236eb18b5e63d3455a.camel@paulk.fr>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2018 14:41:16 +0200
In-Reply-To: <20181004081119.102575-1-acourbot@chromium.org>
References: <20181004081119.102575-1-acourbot@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-XFlIZIV3Xqx2G6LAfA6k"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-XFlIZIV3Xqx2G6LAfA6k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

Thanks for submitting this second version of the RFC, it is very
appreciated! I will try to provide useful feedback here and hopefully
be more reactive than during v1 review!

Most of it looks good to me, but there is a specific point I'd like to
keep discussing.

Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9crit=
 :
> This patch documents the protocol that user-space should follow when
> communicating with stateless video decoders. It is based on the
> following references:
>=20
> * The current protocol used by Chromium (converted from config store to
>   request API)
>=20
> * The submitted Cedrus VPU driver
>=20
> As such, some things may not be entirely consistent with the current
> state of drivers, so it would be great if all stakeholders could point
> out these inconsistencies. :)
>=20
> This patch is supposed to be applied on top of the Request API V18 as
> well as the memory-to-memory video decoder interface series by Tomasz
> Figa.
>=20
> Changes since V1:
>=20
> * Applied fixes received as feedback,
> * Moved controls descriptions to the extended controls file,
> * Document reference frame management and referencing (need Hans' feedbac=
k on
>   that).
>=20
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  .../media/uapi/v4l/dev-stateless-decoder.rst  | 348 ++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst      |   1 +
>  .../media/uapi/v4l/extended-controls.rst      |  25 ++
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  54 ++-
>  4 files changed, 424 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rs=
t
>=20
> diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Doc=
umentation/media/uapi/v4l/dev-stateless-decoder.rst
> new file mode 100644
> index 000000000000..e54246df18d0
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> @@ -0,0 +1,348 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _stateless_decoder:
> +
> +**************************************************
> +Memory-to-memory Stateless Video Decoder Interface
> +**************************************************
> +
> +A stateless decoder is a decoder that works without retaining any kind o=
f state
> +between processing frames. This means that each frame is decoded indepen=
dently
> +of any previous and future frames, and that the client is responsible fo=
r
> +maintaining the decoding state and providing it to the driver. This is i=
n
> +contrast to the stateful video decoder interface, where the hardware mai=
ntains
> +the decoding state and all the client has to do is to provide the raw en=
coded
> +stream.
> +
> +This section describes how user-space ("the client") is expected to comm=
unicate
> +with such decoders in order to successfully decode an encoded stream. Co=
mpared
> +to stateful codecs, the driver/client sequence is simpler, but the cost =
of this
> +simplicity is extra complexity in the client which must maintain a consi=
stent
> +decoding state.
> +
> +Querying capabilities
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +1. To enumerate the set of coded formats supported by the driver, the cl=
ient
> +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> +
> +   * The driver must always return the full set of supported ``OUTPUT`` =
formats,
> +     irrespective of the format currently set on the ``CAPTURE`` queue.
> +
> +2. To enumerate the set of supported raw formats, the client calls
> +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> +
> +   * The driver must return only the formats supported for the format cu=
rrently
> +     active on the ``OUTPUT`` queue.
> +
> +   * Depending on the currently set ``OUTPUT`` format, the set of suppor=
ted raw
> +     formats may depend on the value of some controls (e.g. H264 or VP9
> +     profile). The client is responsible for making sure that these cont=
rols
> +     are set to the desired value before querying the ``CAPTURE`` queue.

I still think we have a problem when enumerating CAPTURE formats, that
providing the profile/level information does not help solving.

=46rom previous emails on v1 (to which I failed to react to), it seems
that the consensus was to set the profile/level indication beforehand
to reduce the subset of possible formats and return that as enumerated
possible formats.

However, it does not really solve the issue here, given the following
distinct cases:

1. The VPU can only output the format for the decoded frame and that
format is not known until the first buffer metadata is passed.
Everything that is reported as supported at this point should be
understood as supported formats for the decoded bitstreams, but
userspace would have to pick the one matching the decoded format of the
bitstream to decode. I don't really see the point of trying to reduce
that list by providing the profile/level.

2. The VPU has some format conversion block in its pipeline and can
actually provide a range of different formats for CAPTURE buffers,
independently from the format of the decoded bitstream.

Either way, I think (correct me if I'm wrong) that players do know the
format from the decoded bitstream here, so enumeration only makes sense
for case 2.

Something we could do is to not enumerate any format for case 1., which
we would specify as an indication that only the decoded bitstream
format must be set. Then in case 2., we would enumerate the possible
formats.

For case 1., having the driver expose the supported profiles ensures
that any format in a supported profile is valid although not
enumerated.

Alternatively, we could go with a control that indicates whether the
driver supports a format decorrelated from the decoded bitstream format
and still enumerate all formats in case 1., with the implication that
only the right one must be picked by userspace. Here again, I don't see
the point of reducing the list by setting the profile/level.

So my goal here is to clearly enable userspace to distinguish between
the two situations.

What do you think?

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-XFlIZIV3Xqx2G6LAfA6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlu2CmwACgkQhP3B6o/u
lQyL1xAAkl8xJCVJpSpqFMRj//CKVLJC4TX8GuLWFl301j87kaoEwFPQTFQ31e+g
RfOfe6o1PauIl8e58PYBjFF6uUYZMOm0a2xRgARhXqcUPnq5C4jNuqJe/MaGSROx
ZscrPNmrEw9bkSRj1coafVy1dLAYoAocGvDYI9EHFoqd/2DXdPLgEOyK4LGt05Tl
SmXQoUeMURemaRuGz9lUXqoEF3s45wZPY1YNqy341tVDFcYBuRDm2XzZodZvEGqK
E24xvsUHXx8FbR1Vu06np4kTNLfU8Q7nnJDoJksRzBmTZo3+lAsbYd/CJvU+1XlH
vj12sVNRRrQaMnyrGEpqdFdqcofw6aeeSLmSW4sRP4SwzAJLOA7bQzK/gnKmfOlW
zf+2jNmoOFUDsO+xScDNoS27Pulo6PUrr0uPJnOg6f1v/ChpZel3kbzb/JFuBOD9
XZWyeykM65pAESUBleCIFKTebP2Vg90u2LrN7sx0gP8Vl0MrdRD7O6xTRzMhkBgj
8nZfsJlLpSH2NBJdXSkt09lIYrIEpUuCOUA4zqX9n07eVd3qUTuPgQmEZh7DF1EG
OKVq0KjILTsuFZabBP+v+4N/kcYqD077Deznc2E+ewC1oYgyOJR6WuAFaUyL3SI/
YBGoiq+xQbVcoUttF4oYhMgxJSdSkcKFDOARKMgMNd5AA6a2xhs=
=BirM
-----END PGP SIGNATURE-----

--=-XFlIZIV3Xqx2G6LAfA6k--
