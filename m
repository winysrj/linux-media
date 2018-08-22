Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40494 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbeHVQcE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 12:32:04 -0400
Message-ID: <53987ca7a536a21b2eb49626d777a9bf894d6910.camel@bootlin.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, tfiga@chromium.org,
        posciak@chromium.org, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date: Wed, 22 Aug 2018 15:07:00 +0200
In-Reply-To: <d8a30e78e6a33db10360995d800f2c0d19acc500.camel@collabora.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-2-maxime.ripard@bootlin.com>
         <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
         <d8a30e78e6a33db10360995d800f2c0d19acc500.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-A2FPvdq+CdJ6c1wLZbuM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A2FPvdq+CdJ6c1wLZbuM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-08-21 at 13:07 -0400, Nicolas Dufresne wrote:
> Le mardi 21 ao=C3=BBt 2018 =C3=A0 13:58 -0300, Ezequiel Garcia a =C3=A9cr=
it :
> > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > From: Pawel Osciak <posciak@chromium.org>
> > >=20
> > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >=20
> >=20
> > [..]
> > > diff --git a/include/uapi/linux/videodev2.h
> > > b/include/uapi/linux/videodev2.h
> > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > --- a/include/uapi/linux/videodev2.h
> > > +++ b/include/uapi/linux/videodev2.h
> > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /*
> > > H264 with start codes */
> > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /*
> > > H264 without start codes */
> > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /*
> > > H264 MVC */
> > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*
> > > H264 parsed slices */
> >=20
> > As pointed out by Tomasz, the Rockchip VPU driver expects start codes
> > [1], so the userspace
> > should be aware of it. Perhaps we could document this pixel format
> > better as:
> >=20
> > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*
> > H264 parsed slices with start codes */
> >=20
> > And introduce another pixel format:
> >=20
> > #define V4L2_PIX_FMT_H264_SLICE_NO_SC v4l2_fourcc(TODO) /* H264
> > parsed slices without start codes */
> >=20
> > For cedrus to use, as it seems it doesn't need start codes.
>=20
> I must admit that this RK requirement is a bit weird for slice data.
> Though, userspace wise, always adding start-code would be compatible,
> as the driver can just offset to remove it.

This would mean that the stateless API no longer takes parsed bitstream
data but effectively the full bitstream, which defeats the purpose of
the _SLICE pixel formats.

> Another option, because I'm not fan of adding dedicated formats for
> this, the RK driver could use data_offset (in mplane v4l2 buffers),
> just write a start code there. I like this solution because I would not
> be surprise if some drivers requires in fact an HW specific header,
> that the driver can generate as needed.

I like this idea, because it implies that the driver should deal with
the specificities of the hardware, instead of making the blurrying the
lines of stateless API for covering these cases.

> >=20
> > How does it sound?=20
> >=20
> > [1]=20
> > https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_slice_video_de=
code_accelerator.cc?rcl=3D63129434aeacf0f54bbae96814f10cf64e3e6c35&l=3D2438
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-A2FPvdq+CdJ6c1wLZbuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt9X/QACgkQ3cLmz3+f
v9HWTQf/VosR/T7wRR3U38EiPUbE69LToSesw1I3LNpuJQunMVr1kYONx8+lmjP9
O8Z91A8OIBlQ8MCFXJq/WnagK6e00sqzcSbbFnHQxRCXdBzGxB0iYI9hShJYXQCu
uVKWMKkSFG/CN7NQ4rG6WT5+w56DlthVB/yuD2TO1veRCAvObXz3WeFp30UxIMT0
KZzzn08tHv4eH8Ib+vgog+QCANppc0QdTlVaDt2Tg8gNUM2bo4FH8GbvUdwaYIDW
doRawf/Xa6PZhlBMDL6S0Z9Sci+3EHlN7oCjiAm/yy5Bq9Sdz2jTsdMEtAU2b71i
E6NJ3g34PGG3uxgHehX4+8pRS/sLow==
=VmnC
-----END PGP SIGNATURE-----

--=-A2FPvdq+CdJ6c1wLZbuM--
