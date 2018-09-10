Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:49102 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbeIJOld (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:41:33 -0400
Message-ID: <2409ba6607e85acf3dbbaed394487fa8e92d93df.camel@paulk.fr>
Subject: Re: [PATCH v9 2/9] media: v4l: Add definitions for MPEG-2 slice
 format and metadata
From: Paul Kocialkowski <contact@paulk.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 10 Sep 2018 11:47:47 +0200
In-Reply-To: <9a7fd34d-50e3-4db6-4752-9e62bb160655@xs4all.nl>
References: <20180906222442.14825-1-contact@paulk.fr>
         <20180906222442.14825-3-contact@paulk.fr>
         <9a7fd34d-50e3-4db6-4752-9e62bb160655@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YrlIFe9eOeQdIb272dAH"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-YrlIFe9eOeQdIb272dAH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 10 septembre 2018 =C3=A0 11:41 +0200, Hans Verkuil a =C3=A9crit :
> On 09/07/2018 12:24 AM, Paul Kocialkowski wrote:
> > From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
> > Stateless video decoding engines require both the MPEG-2 slices and
> > associated metadata from the video stream in order to decode frames.
> >=20
> > This introduces definitions for a new pixel format, describing buffers
> > with MPEG-2 slice data, as well as control structure sfor passing the
> > frame metadata to drivers.
> >=20
> > This is based on work from both Florent Revest and Hugues Fruchet.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  .../media/uapi/v4l/extended-controls.rst      | 176 ++++++++++++++++++
> >  .../media/uapi/v4l/pixfmt-compressed.rst      |  16 ++
> >  .../media/uapi/v4l/vidioc-queryctrl.rst       |  14 +-
> >  .../media/videodev2.h.rst.exceptions          |   2 +
> >  drivers/media/v4l2-core/v4l2-ctrls.c          |  63 +++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
> >  include/media/v4l2-ctrls.h                    |  18 +-
> >  include/uapi/linux/v4l2-controls.h            |  65 +++++++
> >  include/uapi/linux/videodev2.h                |   5 +
> >  9 files changed, 351 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index 9f7312bf3365..f1951236266a 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -1497,6 +1497,182 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_t=
ype -
> > =20
> > =20
> > =20
> > +.. _v4l2-mpeg-mpeg2:
> > +
> > +``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS (struct)``
> > +    Specifies the slice parameters (as extracted from the bitstream) f=
or the
> > +    associated MPEG-2 slice data. This includes the necessary paramete=
rs for
> > +    configuring a stateless hardware decoding pipeline for MPEG-2.
> > +    The bitstream parameters are defined according to :ref:`mpeg2part2=
`.
> > +
> > +.. c:type:: v4l2_ctrl_mpeg2_slice_params
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``bit_size``
> > +      - Size (in bits) of the current slice data.
> > +    * - __u32
> > +      - ``data_bit_offset``
> > +      - Offset (in bits) to the video data in the current slice data.
> > +    * - struct :c:type:`v4l2_mpeg2_sequence`
> > +      - ``sequence``
> > +      - Structure with MPEG-2 sequence metadata, merging relevant fiel=
ds from
> > +	the sequence header and sequence extension parts of the bitstream.
> > +    * - struct :c:type:`v4l2_mpeg2_picture`
> > +      - ``picture``
> > +      - Structure with MPEG-2 picture metadata, merging relevant field=
s from
> > +	the picture header and picture coding extension parts of the bitstrea=
m.
> > +    * - __u8
> > +      - ``quantiser_scale_code``
> > +      - Code used to determine the quantization scale to use for the I=
DCT.
> > +    * - __u8
> > +      - ``backward_ref_index``
> > +      - Index for the V4L2 buffer to use as backward reference, used w=
ith
> > +	B-coded and P-coded frames.
> > +    * - __u8
> > +      - ``forward_ref_index``
> > +      - Index for the V4L2 buffer to use as forward reference, used wi=
th
> > +	P-coded frames.
>=20
> Should this be "B-coded frames"?

Oops, that's right, B-coded frames.

Should I make a follow-up patch for that (maybe gathered with other
changes if required)?

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-YrlIFe9eOeQdIb272dAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluWPcMACgkQhP3B6o/u
lQxIEQ//eGI0dpOkNfiLbEpqBwBGb9xGo3qAOTvktnFFLyHDrVW9UcCl+Lxsrpw5
wR1MxxbeejkVmb897/Y+AyfTPhxo5mg6DzD7/tWY3ooT4d74v3DySO7UW+5M6fc3
3UMu9NGUOCWew02TtXowXMm7OFa0KO4JJofdkItpIGT57YynoriYqVTSlYrWhGQa
6PtbOlUfJg0Fz7PloHvyEeXU4swP1Oz4xzjPoxLz+pu43SR7PFiO6vvVwvf6R2FB
IX9ahPFqARtWyli9296l6bRk7ha5/3Q5oP/PmF8c9n8+bwiymQZxC2M97Hdm+uEx
LCVFUELUcWLcV0EUIw3RsDnwdTkUZGvSr/r+YXIiqAoBlZBzwd7HjGht4xqhuNGX
KisNN9zYD7yoJ7wl3RyiUskfwgqxPRYrxL0fsmPji4VKhgFSmrLHXQ/kwlH8hNiK
Ek9mbq0QtVn64cOIt75PPGZjP8/D5f+w3JKgyoRYofC5DNaQhaOgygBnTs9QqMcZ
puKwiiZz1NtUX5hk1JgO6xCpoCcim2qDR6eeBEFVKU3rCdbNBtenMQX3L/DwE/PB
ct0THCwIhnB8oOoHS5u8jI8D3HTfJkXj1FqxS+EkamcJvJHrtzvewJarA6/b6aB3
XND21Hg8S4OuwSKIQ9lUcz2E08RZJGAlpvjxQc605EFAlbo4QZk=
=ZnXS
-----END PGP SIGNATURE-----

--=-YrlIFe9eOeQdIb272dAH--
