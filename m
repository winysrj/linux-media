Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43332 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeHUU2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 16:28:49 -0400
Message-ID: <d8a30e78e6a33db10360995d800f2c0d19acc500.camel@collabora.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, tfiga@chromium.org,
        posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date: Tue, 21 Aug 2018 13:07:43 -0400
In-Reply-To: <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-2-maxime.ripard@bootlin.com>
         <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-JHf4DZXGm3W7m8srBwS1"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-JHf4DZXGm3W7m8srBwS1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 21 ao=C3=BBt 2018 =C3=A0 13:58 -0300, Ezequiel Garcia a =C3=A9crit=
 :
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > From: Pawel Osciak <posciak@chromium.org>
> >=20
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >=20
>=20
> [..]
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h
> > index 242a6bfa1440..4b4a1b25a0db 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /*
> > H264 with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /*
> > H264 without start codes */
> >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /*
> > H264 MVC */
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*
> > H264 parsed slices */
>=20
> As pointed out by Tomasz, the Rockchip VPU driver expects start codes
> [1], so the userspace
> should be aware of it. Perhaps we could document this pixel format
> better as:
>=20
> #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*
> H264 parsed slices with start codes */
>=20
> And introduce another pixel format:
>=20
> #define V4L2_PIX_FMT_H264_SLICE_NO_SC v4l2_fourcc(TODO) /* H264
> parsed slices without start codes */
>=20
> For cedrus to use, as it seems it doesn't need start codes.

I must admit that this RK requirement is a bit weird for slice data.
Though, userspace wise, always adding start-code would be compatible,
as the driver can just offset to remove it.

Another option, because I'm not fan of adding dedicated formats for
this, the RK driver could use data_offset (in mplane v4l2 buffers),
just write a start code there. I like this solution because I would not
be surprise if some drivers requires in fact an HW specific header,
that the driver can generate as needed.

>=20
> How does it sound?=20
>=20
> [1]=20
> https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_slice_video_deco=
de_accelerator.cc?rcl=3D63129434aeacf0f54bbae96814f10cf64e3e6c35&l=3D2438

--=-JHf4DZXGm3W7m8srBwS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW3xG3wAKCRBxUwItrAao
HCfYAKC96oyPYQzefz0KyRZBp9iAELzjFwCfc3/GRoMdiWflJ81In3QADs5pCJE=
=22Gp
-----END PGP SIGNATURE-----

--=-JHf4DZXGm3W7m8srBwS1--
