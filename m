Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34462 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936063AbeFNN4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 09:56:48 -0400
Received: by mail-qk0-f196.google.com with SMTP id q70-v6so3650783qke.1
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 06:56:48 -0700 (PDT)
Message-ID: <94d0e438bf8d59932e165814e6a2c0a99f217fee.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 14 Jun 2018 09:56:44 -0400
In-Reply-To: <89dca3ae-cbbc-4b5b-1c8a-207951997839@linaro.org>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-2-tfiga@chromium.org>
         <89dca3ae-cbbc-4b5b-1c8a-207951997839@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-83vJTnL9a4aJ1xI8xWNy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-83vJTnL9a4aJ1xI8xWNy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 14 juin 2018 =C3=A0 15:34 +0300, Stanimir Varbanov a =C3=A9crit :
> Hi Tomasz,
>=20
>=20
> On 06/05/2018 01:33 PM, Tomasz Figa wrote:
> > Due to complexity of the video decoding process, the V4L2 drivers of
> > stateful decoder hardware require specific sequencies of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > decoding, seek, pause, dynamic resolution change, flush and end of
> > stream.
> >=20
> > Specifics of the above have been discussed during Media Workshops at
> > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API that
> > originated at those events was later implemented by the drivers we alre=
ady
> > have merged in mainline, such as s5p-mfc or mtk-vcodec.
> >=20
> > The only thing missing was the real specification included as a part of
> > Linux Media documentation. Fix it now and document the decoder part of
> > the Codec API.
> >=20
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-codec.rst | 771 +++++++++++++++++++++
> >  Documentation/media/uapi/v4l/v4l2.rst      |  14 +-
> >  2 files changed, 784 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation=
/media/uapi/v4l/dev-codec.rst
> > index c61e938bd8dc..0483b10c205e 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
>=20
> <snip>
>=20
> > +Initialization sequence
> > +-----------------------
> > +
> > +1. (optional) Enumerate supported OUTPUT formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the source queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   a. Required fields:
> > +
> > +      i.   type =3D OUTPUT
> > +
> > +      ii.  fmt.pix_mp.pixelformat set to a coded format
> > +
> > +      iii. fmt.pix_mp.width, fmt.pix_mp.height only if cannot be
> > +           parsed from the stream for the given coded format;
> > +           ignored otherwise;
>=20
> Can we say that if width !=3D 0 and height !=3D 0 then the user knows the
> real coded resolution? And vise versa if width/height are both zero the
> driver should parse the stream metadata?

The driver always need to parse the stream metadata, since there could
be an x,y offset too, it's not just right/bottom cropping. And then
G_SELECTION is required.

>=20
> Also what about fmt.pix_mp.plane_fmt.sizeimage, as per spec (S_FMT) this
> field should be filled with correct image size? If the coded
> width/height is zero sizeimage will be unknown. I think we have two
> options, the user fill sizeimage with bigger enough size or the driver
> has to have some default size.
>=20
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
> > +
> > +      ii. Others: per spec
> > +
> > +   .. note::
> > +
> > +      The driver must not adjust pixelformat, so if
> > +      ``V4L2_PIX_FMT_H264`` is passed but only
> > +      ``V4L2_PIX_FMT_H264_SLICE`` is supported, S_FMT will return
> > +      -EINVAL. If both are acceptable by client, calling S_FMT for
> > +      the other after one gets rejected may be required (or use
> > +      :c:func:`VIDIOC_ENUM_FMT` to discover beforehand, see Capability
> > +      enumeration).
> > +
> > +3.  (optional) Get minimum number of buffers required for OUTPUT queue
> > +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to u=
se
> > +    more buffers than minimum required by hardware/format (see
> > +    allocation).
> > +
> > +    a. Required fields:
> > +
> > +       i. id =3D ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> > +
> > +    b. Return values: per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. value: required number of OUTPUT buffers for the currently s=
et
> > +          format;
> > +
> > +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` o=
n OUTPUT
> > +    queue.
> > +
> > +    a. Required fields:
> > +
> > +       i.   count =3D n, where n > 0.
> > +
> > +       ii.  type =3D OUTPUT
> > +
> > +       iii. memory =3D as per spec
> > +
> > +    b. Return values: Per spec.
> > +
> > +    c. Return fields:
> > +
> > +       i. count: adjusted to allocated number of buffers
> > +
> > +    d. The driver must adjust count to minimum of required number of
> > +       source buffers for given format and count passed. The client
> > +       must check this value after the ioctl returns to get the
> > +       number of buffers allocated.
> > +
> > +    .. note::
> > +
> > +       Passing count =3D 1 is useful for letting the driver choose
> > +       the minimum according to the selected format/hardware
> > +       requirements.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT)`` to
> > +       get minimum number of buffers required by the driver/format,
> > +       and pass the obtained value plus the number of additional
> > +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> > +
> > +5.  Begin parsing the stream for stream metadata via :c:func:`VIDIOC_S=
TREAMON` on
> > +    OUTPUT queue. This step allows the driver to parse/decode
> > +    initial stream metadata until enough information to allocate
> > +    CAPTURE buffers is found. This is indicated by the driver by
> > +    sending a ``V4L2_EVENT_SOURCE_CHANGE`` event, which the client
> > +    must handle.
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    .. note::
> > +
> > +       Calling :c:func:`VIDIOC_REQBUFS`, :c:func:`VIDIOC_STREAMON`
> > +       or :c:func:`VIDIOC_G_FMT` on the CAPTURE queue at this time is =
not
> > +       allowed and must return EINVAL.
> > +
> > +6.  This step only applies for coded formats that contain resolution
> > +    information in the stream.
>=20
> maybe an example of such coded formats will be good to have.
>=20
> > +    Continue queuing/dequeuing bitstream buffers to/from the
> > +    OUTPUT queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`.=
 The driver
> > +    must keep processing and returning each buffer to the client
> > +    until required metadata to send a ``V4L2_EVENT_SOURCE_CHANGE``
> > +    for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION`` is
> > +    found. There is no requirement to pass enough data for this to
> > +    occur in the first buffer and the driver must be able to
> > +    process any number
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    c. If data in a buffer that triggers the event is required to deco=
de
> > +       the first frame, the driver must not return it to the client,
> > +       but must retain it for further decoding.
> > +
> > +    d. Until the resolution source event is sent to the client, callin=
g
> > +       :c:func:`VIDIOC_G_FMT` on the CAPTURE queue must return -EINVAL=
.
> > +
> > +    .. note::
> > +
> > +       No decoded frames are produced during this phase.
> > +
>=20
> <snip>
>=20
--=-83vJTnL9a4aJ1xI8xWNy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWyJ0HQAKCRBxUwItrAao
HH1IAJ0UYGVAcC+FhCtuGouvddilyv8ZjACePJ/5Lf0xPGBMr+17M3x8GxYEE/g=
=gfJ/
-----END PGP SIGNATURE-----

--=-83vJTnL9a4aJ1xI8xWNy--
