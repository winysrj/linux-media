Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50324 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEDIAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:00:25 -0400
Message-ID: <18af23e5efe2cdef5ed4b51c6dbf1ddeef8ffd5f.camel@bootlin.com>
Subject: Re: [PATCH v2 06/10] media: v4l: Add definition for Allwinner's
 MB32-tiled NV12 format
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 04 May 2018 09:58:41 +0200
In-Reply-To: <198e991c-1052-5bfb-f397-0e7d388b3c00@xs4all.nl>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-2-paul.kocialkowski@bootlin.com>
         <198e991c-1052-5bfb-f397-0e7d388b3c00@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pjmmlWeTN8CeAiJmte1x"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pjmmlWeTN8CeAiJmte1x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-04-20 at 15:59 +0200, Hans Verkuil wrote:
> On 04/19/18 17:45, Paul Kocialkowski wrote:
> > This introduces support for Allwinner's MB32-tiled NV12 format,
> > where
> > each plane is divided into macroblocks of 32x32 pixels. Hence, the
> > size
> > of each plane has to be aligned to 32 bytes. The pixels inside each
> > macroblock are coded as they would be if the macroblock was a single
> > plane, line after line.
> >=20
> > The MB32-tiled NV12 format is used by the video engine on Allwinner
> > platforms: it is the default format for decoded frames (and the only
> > one
> > available in the oldest supported platforms).
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  include/uapi/linux/videodev2.h | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h
> > index 4b8336f7bcf0..43993a116e2b 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -669,6 +669,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /*
> > Depth data 16-bit */
> >  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /*
> > Mediatek compressed block mode  */
> >  #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /*
> > Intel Planar Greyscale 10-bit and Depth 16-bit */
> > +#define V4L2_PIX_FMT_MB32_NV12 v4l2_fourcc('M', 'N', '1', '2') /*
> > Allwinner NV12 in 32x32 macroblocks */
> > =20
> >  /* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6
> > bits unused */
> >  #define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3',
> > 'b') /* IPU3 packed 10-bit BGGR bayer */
> >=20
>=20
> Add an entry for this to v4l_fill_fmtdesc() in v4l2-ioctl.c.
>=20
> It also needs to be documented in the spec.

Noted, I will look in that direction for the future versions.

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-pjmmlWeTN8CeAiJmte1x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsErEACgkQ3cLmz3+f
v9Eo6ggAoR88fJeRrCVgfkKekIdhUwc2A3nqbtb8cf5+rhbpEJMDIQ4RR04kSmZM
Zis03s0N/UZI58R4tUacf5O39UmdZAtszhzMXlSMzRenkyasLlByzxZZh/YltkP6
lwonoIfYLzJ7ZvXJBQAJhNyn3VMORNvC399xGQoMI89TiEBzypJf/+9+pbWxVoNj
0l+++VoyywDTRdjOG2YQeJRPe52lkEKXXs4Gn9qx9rdMgIzj5aMnOQf1Q8HutidQ
5OMDBxXZQImnTS3yfr0Su8Jw1ER3z1ZKGK3SX01IFVgNcx60pGqACZ1YFbj+G/Jr
Jf1OLlJDi6PZ5pKpZpxx9Qa0o6HONA==
=DzS/
-----END PGP SIGNATURE-----

--=-pjmmlWeTN8CeAiJmte1x--
