Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40260 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbeHVQ2D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 12:28:03 -0400
Message-ID: <e6324ea983d34403199044ae30e932cd728c8ad4.camel@bootlin.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
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
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com, groeck@chromium.org
Date: Wed, 22 Aug 2018 15:03:00 +0200
In-Reply-To: <CAAFQd5ANvKF2+GEXQTnRsdYVzJTtBOhv7nFahV=2W-9_QXwY4g@mail.gmail.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-2-maxime.ripard@bootlin.com>
         <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
         <20180822091557.gtnlgoebyv6yttzf@flea>
         <CAAFQd5ANvKF2+GEXQTnRsdYVzJTtBOhv7nFahV=2W-9_QXwY4g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5Ntf9UxAehgezPWvBr41"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-5Ntf9UxAehgezPWvBr41
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-08-22 at 18:54 +0900, Tomasz Figa wrote:
> On Wed, Aug 22, 2018 at 6:16 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> >=20
> > Hi,
> >=20
> > On Tue, Aug 21, 2018 at 01:58:38PM -0300, Ezequiel Garcia wrote:
> > > On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > > > From: Pawel Osciak <posciak@chromium.org>
> > > >=20
> > > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > > > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > > > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > > > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > > > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > > ---
> > > >=20
> > >=20
> > > [..]
> > > > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/vi=
deodev2.h
> > > > index 242a6bfa1440..4b4a1b25a0db 100644
> > > > --- a/include/uapi/linux/videodev2.h
> > > > +++ b/include/uapi/linux/videodev2.h
> > > > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> > > >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H=
264 with start codes */
> > > >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /*=
 H264 without start codes */
> > > >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H=
264 MVC */
> > > > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /*=
 H264 parsed slices */
> > >=20
> > > As pointed out by Tomasz, the Rockchip VPU driver expects start codes=
 [1], so the userspace
> > > should be aware of it. Perhaps we could document this pixel format be=
tter as:
> > >=20
> > > #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H2=
64 parsed slices with start codes */
> >=20
> > I'm not sure this is something we want to do at that point. libva
> > doesn't give the start code, so this is only going to make the life of
> > the sane controllers more difficult. And if you need to have the start
> > code and parse it, then you're not so stateless anymore.
>=20
> I might not remember correctly, but Rockchip decoder does some slice
> parsing on its own (despite not doing any higher level parsing).
> Probably that's why it needs those start codes.

The VPU found on Allwinner platforms also provides a mechanism to parse
the bitstream data via a dedicated interface through the VPU registers.
It is used in libvdpau-sunxi but not in our driver, because we don't
want to be doing bitstream parsing in the kernel.

It would be good to know if this is just a feature of the Rockchip VPU
hardware that can be skipped (like on Allwinner) or if it's a hard
requirement in its decoding pipeline. Also, maybe it only concerns the
slice header? It is already part of the slice data (provided by VAAPI)
for H.264/H.265 and an offset is provided to the beginning of the coded
video data.

> I wonder if libva is the best reference here. It's been designed
> almost entirely by Intel for Intel video hardware. We want something
> that could work with a wide range of devices and avoid something like
> a need to create a semi-stateless API few months later. In fact,
> hardware from another vendor, we're working with, also does parsing of
> slice headers internally. Moreover, we have some weird
> kind-of-stateful decoders, which cannot fully deal with bitstream on
> its own, e.g. cannot parse formats, cannot handle resolution changes,
> need H264 bitstream NALUs split into separate buffers, etc.
>=20
> As I suggested some time ago, having the full bitstream in the buffer,
> with offsets of particular units included in respective controls,
> would be the most scalable thing. If really needed, we could add flags
> telling the driver that particular units are present, so one's
> implementation of libva could put only raw slice data in the buffers.
> But perhaps it's libva which needs some amendment?

If the raw bitstream is needed, I think it would make more sense to use
the already-existing formats for stateful VPUs along with the controls
for stateless ones instead of having the full bitstream in the
V4L2_PIX_FMT_*_SLICE formats.

I would also be tempted to say that reconstructing the needed parts of
the bitstream in-driver for these half-way VPUs would be a better
approach than blurrying the line between how (and what) data should be
passed for stateful and stateless VPUs at the API level. Stateless
should only cover what's in the slice NAL unit RBSP, which excludes the
start code detection bytes. It is no longer parsed data otherwise.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-5Ntf9UxAehgezPWvBr41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt9XwQACgkQ3cLmz3+f
v9ETmAf/RAEqpd8KEta6a87yUq4T6ONHgfrWLC/OeBYEV6TcuAyXKszJ3PQER1LA
giSYj3OykDypAsJhbBzgrtJxXal++8If6iWRKGs2seVMtIfvl15vaGGKHaBkKWeK
qjbDN6tFaBnrvSHYDyPa3SfppaxYqIvJ2o0+IYsTuwyMTnZc9LiHAQnNASlEaYJG
qtx+Eaho9vruBQzXafMW0XaAuc+6ddpFPxDyyELOoTvbkaecfPYG3Fsb3CZhWI8x
UY/Mdy8cSHAfW3QgF5235J4YBKzO1pAGd7h1+0fmItB8FfX/rxckPpasmaRAtHBE
/cAASPu8KQaUO5w2MBHfbSKqOF2i+Q==
=CkwI
-----END PGP SIGNATURE-----

--=-5Ntf9UxAehgezPWvBr41--
