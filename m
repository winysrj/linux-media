Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58621 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbeHWLIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:08:48 -0400
Message-ID: <3e87ebaccb123dbff8923c7d0235b50cf09a6d07.camel@bootlin.com>
Subject: Re: [PATCH v7 0/8] Cedrus driver for the Allwinner Video Engine,
 using media requests
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Thu, 23 Aug 2018 09:40:17 +0200
In-Reply-To: <828bf3b9f5f2edc2f05b7982ccc5d9777f1a19e3.camel@collabora.com>
References: <20180809090435.17248-1-paul.kocialkowski@bootlin.com>
         <828bf3b9f5f2edc2f05b7982ccc5d9777f1a19e3.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GrXxzMTgca7Nqq3ohf9F"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GrXxzMTgca7Nqq3ohf9F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ezequiel,

On Wed, 2018-08-22 at 14:25 -0300, Ezequiel Garcia wrote:
> Hey Paul,
>=20
> On Thu, 2018-08-09 at 11:04 +0200, Paul Kocialkowski wrote:
> > This is the seventh iteration of the updated Cedrus driver,
> > that supports the Video Engine found on most Allwinner SoCs, starting
> > with the A10. It was tested on the A13, A20, A33 and H3.
> >=20
> > The initial version of this driver[0] was originally written and
> > submitted by Florent Revest using a previous version of the request API
> > that is necessary to provide coherency between controls and the buffers
> > they apply to.
> >=20
> > The driver was adapted to use the latest version of the media request
> > API[1], as submitted by Hans Verkuil. Media request API support is a
> > hard requirement for the Cedrus driver.
> >=20
> > The driver itself currently only supports MPEG2 and more codecs will be
> > added eventually. The default output frame format provided by the Video
> > Engine is a multi-planar tiled YUV format (based on NV12). A specific
> > format is introduced in the V4L2 API to describe it. Starting with the
> > A33, the Video Engine can also output untiled YUV formats.
> >=20
> > This implementation is based on the significant work that was conducted
> > by various members of the linux-sunxi community for understanding and
> > documenting the Video Engine's innards.
> >=20
> > In addition to the media requests API, the following series are require=
d
> > for Cedrus:
> > * vicodec: the Virtual Codec driver
> > * allwinner: a64: add SRAM controller / system control
> > * SRAM patches from the Cedrus VPU driver series version 5
> >=20
> > Changes since v6:
> > * Reworked MPEG2 controls to stick closer to the bitstream;
> > * Updated controls documentation accordingly and added requested fixes;
> > * Renamed tiled format to V4L2_PIX_FMT_SUNXI_TILED_NV12;
> > * Added various minor driver fixes based on Hans' feedback;
> > * Fixed dst frame alignment based on Jernej's feedback and tests;
> > * Removed set bits for the disabled secondary output.
> >=20
> > Changes since v5:
> > * Added MPEG2 quantization matrices definitions and support;
> > * Cleaned up registers definitions;
> > * Moved the driver to staging as requested;
> >=20
>=20
> I tried to find the reason for moving this driver to staging,
> but couldn't find it in the discussion.
>=20
> If there's a legitimate reason, shouldn't you add a TODO file?

Ah, sorry this wasn't made explicit in the log.

The driver was moved to staging because we want to keep the ability to
rework the controls used by the driver, which were not deemed stable
yet. So since the controls are in a staging state, so is the driver
using them. So this probably applies to your driver as well.

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-GrXxzMTgca7Nqq3ohf9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt+ZOEACgkQ3cLmz3+f
v9GqsAf/di/FkWsISTdZ4XAdBfNs5C43qoWM0d4TRPuRVd6Wy2k8jLAZYSxxp/Qn
rs3wUYohLXqZN+A1sFzci4ULhFHHdN6RaInOcqR47yo0r4wVLdN+lIVcQj5AJ9U+
eqvoPFzSZHNx6eofXJiVSOVdi+/Vt9Om4TGQQvF8+QAsKNS1ty5nmQwpQFUeTNm+
f1U+KtCSkiM+Ss/fHITivmdjLVOflmDuWybolx01VlGfDYK4/uT6zGavGeVWkLMi
hH5wkKgjNqOP5EkZOiiMqLN+9Q6yD7r5Jp4h72SF9GIM6Xe2mykTfSiNXSG61Q4e
1srcKv6yeWZLQsVBbcQaGvMZHYQqQA==
=xe58
-----END PGP SIGNATURE-----

--=-GrXxzMTgca7Nqq3ohf9F--
