Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47310 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbeHVRRO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 13:17:14 -0400
Message-ID: <fa15feb80ff62f39dabfad9ec939d484fbf48148.camel@collabora.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Pawel Osciak <posciak@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com, groeck@chromium.org
Date: Wed, 22 Aug 2018 09:52:06 -0400
In-Reply-To: <CAAFQd5B68ArBgSj-Oso8=MzSrvVGB=h+MVO12qqgACmBrZtRkw@mail.gmail.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-2-maxime.ripard@bootlin.com>
         <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
         <d8a30e78e6a33db10360995d800f2c0d19acc500.camel@collabora.com>
         <53987ca7a536a21b2eb49626d777a9bf894d6910.camel@bootlin.com>
         <CAAFQd5B68ArBgSj-Oso8=MzSrvVGB=h+MVO12qqgACmBrZtRkw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-mXXHg5cHZr39YGSzelcq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-mXXHg5cHZr39YGSzelcq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 22 ao=C3=BBt 2018 =C3=A0 22:38 +0900, Tomasz Figa a =C3=A9crit =
:
> On Wed, Aug 22, 2018 at 10:07 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >=20
> > Hi,
> >=20
> > On Tue, 2018-08-21 at 13:07 -0400, Nicolas Dufresne wrote:
> > > Le mardi 21 ao=C3=BBt 2018 =C3=A0 13:58 -0300, Ezequiel Garcia a =C3=
=A9crit :
> > > > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > > > From: Pawel Osciak <posciak@chromium.org>
> > > > >=20
> > > > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > > ---
> > > > >=20
> > > >=20
> > > > [..]
> > > > > diff --git a/include/uapi/linux/videodev2.h
> > > > > b/include/uapi/linux/videodev2.h
> > > > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > > > --- a/include/uapi/linux/videodev2.h
> > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > > > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /*
> > > > > H264 with start codes */
> > > > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') =
/*
> > > > > H264 without start codes */
> > > > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /*
> > > > > H264 MVC */
> > > > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') =
/*
> > > > > H264 parsed slices */
> > > >=20
> > > > As pointed out by Tomasz, the Rockchip VPU driver expects start cod=
es
> > > > [1], so the userspace
> > > > should be aware of it. Perhaps we could document this pixel format
> > > > better as:
> > > >=20
> > > > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*
> > > > H264 parsed slices with start codes */
> > > >=20
> > > > And introduce another pixel format:
> > > >=20
> > > > #define V4L2_PIX_FMT_H264_SLICE_NO_SC v4l2_fourcc(TODO) /* H264
> > > > parsed slices without start codes */
> > > >=20
> > > > For cedrus to use, as it seems it doesn't need start codes.
> > >=20
> > > I must admit that this RK requirement is a bit weird for slice data.
> > > Though, userspace wise, always adding start-code would be compatible,
> > > as the driver can just offset to remove it.
> >=20
> > This would mean that the stateless API no longer takes parsed bitstream
> > data but effectively the full bitstream, which defeats the purpose of
> > the _SLICE pixel formats.
> >=20
>=20
> Not entirely. One of the purposes of the _SLICE pixel format was to
> specify it in a way that adds a requirement of providing the required
> controls by the client.

Slice is also a bitstream alignment requirement. In the default _H264
format we pass an complete AU, while in _SLICE we will pass single NAL
(along with the tables through controls of course). Though, H264 does
not only support start codes, it also supports AVC headers (as stored
in ISOMP4). That makes the sentence "passing the full bitstream" quite
ambiguous, as whatever we require, userspace may endup having to
replace that part of the NAL.

>=20
> > > Another option, because I'm not fan of adding dedicated formats for
> > > this, the RK driver could use data_offset (in mplane v4l2 buffers),
> > > just write a start code there. I like this solution because I would n=
ot
> > > be surprise if some drivers requires in fact an HW specific header,
> > > that the driver can generate as needed.
> >=20
> > I like this idea, because it implies that the driver should deal with
> > the specificities of the hardware, instead of making the blurrying the
> > lines of stateless API for covering these cases.
>=20
> The spec says
>=20
> "Offset in bytes to video data in the plane. Drivers must set this
> field when type refers to a capture stream, applications when it
> refers to an output stream."
>=20
> which would mean that user space would have to know to reserve some
> bytes at the beginning for the driver to add the start code there. (Or
> the driver memmove()ing the data forward when the buffer is queued,
> assuming that there is enough space in the buffer, but it should
> normally be the case.)
>=20
> Sounds like a pixel format with full bitstream data and some offsets
> to particular parts inside given inside a control might be the most
> flexible and cleanest solution.

Yeah, that comment was miss-informed. But it's simpler then that, the
prefix can be added internally to the driver, there is no need to
communicate this prefix to userspace.

Again, if you go the pixel format way, you'll need to resolve the large
ambiguity of saying "the full bitstream data". While dealing with a
prefix in the driver, is just about writing couple of bytes, and then
you can support HW that wants start-codes, AVC/AVC3 headers or HW
specific headers. I've seen a totally custom header on Panasonic HW
accelerator on some smart TV.

The other important aspect, is that VAAPI won't provide any headers,
just the raw NAL. So you'd be forcing userspace to handle a HW specific
requirement, which is trivial to adapt.

>=20
> Best regards,
> Tomasz

--=-mXXHg5cHZr39YGSzelcq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW31qhgAKCRBxUwItrAao
HGQ1AKCCHAj8XOPI0HcrM97NoWx1Ej/CMQCeKOwWlYKO27Y0vUemXxbrcBjPrKU=
=i54t
-----END PGP SIGNATURE-----

--=-mXXHg5cHZr39YGSzelcq--
