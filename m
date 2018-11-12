Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52510 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbeKMC0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 21:26:22 -0500
Message-ID: <3240ae26669480fa33c2e4d44e608cccdbfd5626.camel@bootlin.com>
Subject: Re: [RFC PATCHv2 0/5] vb2/cedrus: add tag support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, tfiga@chromium.org
Date: Mon, 12 Nov 2018 17:32:11 +0100
In-Reply-To: <20181112083305.22618-1-hverkuil@xs4all.nl>
References: <20181112083305.22618-1-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+LdCll7/GYEzSROVMsO1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+LdCll7/GYEzSROVMsO1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-11-12 at 09:33 +0100, Hans Verkuil wrote:
> As was discussed here (among other places):
>=20
> https://lkml.org/lkml/2018/10/19/440
>=20
> using capture queue buffer indices to refer to reference frames is
> not a good idea. A better idea is to use a 'tag' (thanks to Alexandre
> for the excellent name; it's much better than 'cookie') where the=20
> application can assign a u64 tag to an output buffer, which is then=20
> copied to the capture buffer(s) derived from the output buffer.
>=20
> A u64 is chosen since this allows userspace to also use pointers to
> internal structures as 'tag'.

As I mentionned in the dedicated patch, this approach is troublesome on
32-bit platforms. Do we really need this equivalency?

> The first two patches add core tag support, the next two patches
> add tag support to vim2m and vicodec, and the final patch (compile
> tested only!) adds support to the cedrus driver.
>=20
> I also removed the 'pad' fields from the mpeg2 control structs (it
> should never been added in the first place) and aligned the structs
> to a u32 boundary (u64 for the tag values).
>=20
> The cedrus code now also copies the timestamps (didn't happen before)
> but the sequence counter is still not set, that's something that should
> still be added.
>=20
> Note: if no buffer is found for a certain tag, then the dma address
> is just set to 0. That happened before as well with invalid buffer
> indices. This should be checked in the driver!

Thanks for making these changes!

> Also missing in this series are documentation updates, which is why
> it is marked RFC.
>=20
> I would very much appreciate it if someone can test the cedrus driver
> with these changes. If it works, then I can prepare a real patch series
> for 4.20. It would be really good if the API is as stable as we can make
> it before 4.20 is released.

I just had a go at testing the patches on cedrus with minimal userspace
adaptation to deal with the tags and everything looks good!

I only set the tag when queing each OUTPUT buffer and the driver
properly matched the CAPTURE reference buffer.

I think we should make it clear in the stateless spec that multiple
OUTPUT buffers can be allowed for the same tag, but that a single
CAPTURE buffer should be used. Otherwise, the hardware can't use
different partly-decoded buffers as references (and the tag API doesn't
allow that either, since a single buffer index is returned for a tag).

What do you think?

Cheers,

Paul

> Regards,
>=20
>         Hans
>=20
> Changes since v1:
>=20
> - cookie -> tag
> - renamed v4l2_tag to v4l2_buffer_tag
> - dropped spurious 'to' in the commit log of patch 1
>=20
> Hans Verkuil (5):
>   videodev2.h: add tag support
>   vb2: add tag support
>   vim2m: add tag support
>   vicodec: add tag support
>   cedrus: add tag support
>=20
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 43 ++++++++++++++++---
>  drivers/media/platform/vicodec/vicodec-core.c |  3 ++
>  drivers/media/platform/vim2m.c                |  3 ++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
>  drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++--
>  .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 +++++
>  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++-----
>  include/media/videobuf2-v4l2.h                | 18 ++++++++
>  include/uapi/linux/v4l2-controls.h            | 14 +++---
>  include/uapi/linux/videodev2.h                | 37 +++++++++++++++-
>  10 files changed, 127 insertions(+), 39 deletions(-)
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-+LdCll7/GYEzSROVMsO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvpqwsACgkQ3cLmz3+f
v9G/2Af9ETCByOHHFkN8K+CLJ163wXK09QUoUYPnCVR03BYgnImDcBoyRGdNLogE
eZ6G5+MO6Z55FC4FFe46vsnprRO4GOrOjz8/8mmtOtbQkI0PyEcsXtPOAn5by7CI
YrIABhjesSIaWXJ5lMM/lrX1oWr2rFM03QOd96c3t2dBqj/GaQjo3MrLSli5HWNH
IdQMX6rjPsxJ312AQH1O69leELBxp+r8e/i+c3AQ50IQhe9h/JCDChWOohe+PEAd
UTmJyPnsfOS+LS+eCGJo9Kf3Gjqi84ZkSBbpYuXO6cErX1zrD0agsUvAf6lCyp26
EjKKSz/p0bN9ma17sVvLptuMzN8DpQ==
=ckjK
-----END PGP SIGNATURE-----

--=-+LdCll7/GYEzSROVMsO1--
