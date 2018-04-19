Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40482 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753684AbeDSO5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:57:43 -0400
Message-ID: <79645e203d414109f885a8fc032588c27a0b8af9.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH 5/9] media: platform: Add Sunxi Cedrus
 decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Joonas =?ISO-8859-1?Q?Kylm=E4l=E4?= <joonas.kylmala@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Date: Thu, 19 Apr 2018 16:56:28 +0200
In-Reply-To: <a133f4f9-8b99-323f-5e57-c2c6966d3ecb@iki.fi>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
         <a133f4f9-8b99-323f-5e57-c2c6966d3ecb@iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-3Ks6QjVRPVo48BWtjOBC"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-3Ks6QjVRPVo48BWtjOBC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-03-12 at 17:15 +0000, Joonas Kylm=C3=A4l=C3=A4 wrote:
> Paul Kocialkowski:
> > diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h=
=20
> > b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h
> > new file mode 100644
> > index 000000000000..7384daa94737
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus_regs.h
> > @@ -0,0 +1,170 @@
> > +/*
> > + * Sunxi Cedrus codec driver
> > + *
> > + * Copyright (C) 2016 Florent Revest
> > + * Florent Revest <florent.revest@free-electrons.com>
> > + *
> > + * Based on Cedrus
> > + *
> > + * Copyright (c) 2013 Jens Kuske <jenskuske@gmail.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef SUNXI_CEDRUS_REGS_H
> > +#define SUNXI_CEDRUS_REGS_H
> > +
> > +/*
> > + * For more information consult http://linux-sunxi.org/VE_Register_
> > guide
> > + */
> > +
> > +/* Special registers values */
> > +
> > +/* VE_CTRL:
> > + * The first 3 bits indicate the engine (0 for MPEG, 1 for H264, b
> > for AVC...)
> > + * The 16th and 17th bits indicate the memory type (3 for DDR3 32
> > bits)
> > + * The 20th bit is unknown but needed
> > + */
> > +#define VE_CTRL_MPEG		0x130000
> > +#define VE_CTRL_H264		0x130001
> > +#define VE_CTRL_AVC		0x13000b
> > +#define VE_CTRL_REINIT		0x130007
> > +
> > +/* VE_MPEG_CTRL:
> > + * The bit 3 (0x8) is used to enable IRQs
> > + * The other bits are unknown but needed
> > + */
> > +#define VE_MPEG_CTRL_MPEG2	0x800001b8
> > +#define VE_MPEG_CTRL_MPEG4	(0x80084118 | BIT(7))
> > +#define VE_MPEG_CTRL_MPEG4_P	(VE_MPEG_CTRL_MPEG4 | BIT(12))
> > +
> > +/* VE_MPEG_VLD_ADDR:
> > + * The bits 27 to 4 are used for the address
> > + * The bits 31 to 28 (0x7) are used to select the MPEG or JPEG
> > engine
> > + */
> > +#define VE_MPEG_VLD_ADDR_VAL(x)	((x & 0x0ffffff0) | (x >>
> > 28) | (0x7 << 28))
> > +
> > +/* VE_MPEG_TRIGGER:
> > + * The first three bits are used to trigger the engine
> > + * The bits 24 to 26 are used to select the input format (1 for
> > MPEG1, 2 for=20
>=20
> Trailing whitespace.

Will fix in v2, thanks!

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-3Ks6QjVRPVo48BWtjOBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrYrhwACgkQ3cLmz3+f
v9FCaQf+KO0JZ4Nhrm6W+bvAQKNypYri/FApVT/a2YoVHywPIPbJMLEaUyFF9ZKj
ToUqGkt5u+hPnPYc4neecl8ESr37bsfNIBaAwUStGu1TeZLQFt9EtQZ1SUnZ6Pn8
6V0FaswOINFkGehtOON6x96TQ0ujj2OdV+vtacTP6Jb3h59hYHp+bKOyyg6UBuPP
ebaNpza4LIsxu3BejHF8LQFiufUuVWLqwxuJWF40c0K4j1GCBDXRR9EG2GTRZaqV
wm2eNRTR7N2ybjjEK2oclUhp6Hl/m0Q43qvW2nyQgSc+0RGl0adb4C+sd8Gb9P0U
ew5F5lX1p7e7yIGUyLWvBonqfDvCOg==
=ZYR4
-----END PGP SIGNATURE-----

--=-3Ks6QjVRPVo48BWtjOBC--
