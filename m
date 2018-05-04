Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50174 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbeEDH6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 03:58:52 -0400
Message-ID: <35411894a87b65865eb8b43e5f50829db336a323.camel@bootlin.com>
Subject: Re: [PATCH v2 07/10] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 04 May 2018 09:57:20 +0200
In-Reply-To: <20180424091328.jsqp36nxekuj23am@paasikivi.fi.intel.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-3-paul.kocialkowski@bootlin.com>
         <20180424091328.jsqp36nxekuj23am@paasikivi.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hmK8lEk1M6anlVahez65"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-hmK8lEk1M6anlVahez65
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-04-24 at 12:13 +0300, Sakari Ailus wrote:
> Hi Paul
>=20
> On Thu, Apr 19, 2018 at 05:45:33PM +0200, Paul Kocialkowski wrote:
> > This introduces the Sunxi-Cedrus VPU driver that supports the VPU
> > found
> > in Allwinner SoCs, also known as Video Engine. It is implemented
> > through
> > a v4l2 m2m decoder device and a media device (used for media
> > requests).
> > So far, it only supports MPEG2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data
> > that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for Allwinner VPU.
>=20
> No code review yet, but DT bindings precede the driver. Please also
> add the appropriate MAINTAINERS entries.

Thanks for the indication, will do in the next version(s).

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-hmK8lEk1M6anlVahez65
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsEmAACgkQ3cLmz3+f
v9GZRgf+MJxEg75FOlbtwuNiPD3ZFm/aKpQpLJ+V9jDJN52TNqMfJA0vsgQASfz0
zEE3NDQic84Mo4pQDk96k633Ddki11Ak6fSCNZgTtAxPjy/lIqADe0cZp9k5twAk
o825TTXDTYcxygHD9bq4QSC674kPryxFSrX4/N7kZrFP+HQQxlBHxMMNsbH6aAzz
qxpfRaYtcHUFM8kVnEcW9ksHqQAWhBYKRoUhPF/Q81ld0F4WMBKL4dIP0xivhW42
8W23mSz3QHLILciUdPpxSVFiL2R1FuOkE7GXxZfjqK84OW/dncD7uh8aIALAEe2z
A1JSPcrj1hC2axf3OoaLNNXI9JhccA==
=CeZX
-----END PGP SIGNATURE-----

--=-hmK8lEk1M6anlVahez65--
