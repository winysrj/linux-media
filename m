Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40438 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbeDSO5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:57:20 -0400
Message-ID: <e26c30b31aa8a5ae9692dc050b08d2bca85d4536.camel@bootlin.com>
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
Date: Thu, 19 Apr 2018 16:56:05 +0200
In-Reply-To: <a9cc2e3b-585a-b238-4187-e3c874013d2a@iki.fi>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-3-paul.kocialkowski@bootlin.com>
         <a9cc2e3b-585a-b238-4187-e3c874013d2a@iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-g3Z6ANf+IGQOvuuMrD+p"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-g3Z6ANf+IGQOvuuMrD+p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-03-12 at 20:29 +0000, Joonas Kylm=C3=A4l=C3=A4 wrote:
> Paul Kocialkowski:
> > diff --git a/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> > b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> > new file mode 100644
> > index 000000000000..88624035e0e3
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi-cedrus/sunxi_cedrus.c
> > @@ -0,0 +1,313 @@
> > +/*
> > + * Sunxi Cedrus codec driver
> > + *
> > + * Copyright (C) 2016 Florent Revest
> > + * Florent Revest <florent.revest@free-electrons.com>
> > + *
> > + * Based on vim2m
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
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
> > +#include "sunxi_cedrus_common.h"
> > +
> > +#include <linux/clk.h>
> > +#include <linux/module.h>
> > +#include <linux/delay.h>
> > +#include <linux/fs.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/of.h>
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> > +#include <media/videobuf2-dma-contig.h>
>=20
> I think that the definitions
>=20
> #include <linux/clk.h>
> #include <linux/delay.h>
> #include <linux/fs.h>
> #include <linux/sched.h>
> #include <linux/slab.h>
> #include <linux/videodev2.h>
>=20
> are not used directly in the sunxi_cedrus.c file. Therefore they
> should be removed.

Thanks for the review, this will be done in v2.

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-g3Z6ANf+IGQOvuuMrD+p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrYrgUACgkQ3cLmz3+f
v9E/2wf/YjU0oWpwWBmey5xWwP7D4QnN2xXU7lTHzGNrzNeVayz5oY+oyHO76Gxw
No/1oYVhExYX5aD4D2MXx9leJuzulc2NpNF2J7dut/lRJgdUdeRqjJpd24MclL+T
M126jX6i9SV7ImAzANajenJhQOe40DTLcWu5LL4L4zt6Djj+r1KRdztncTQEV55m
2LYx6C3p1JW/qDYJaXhSRU09sKyB2f81+6GLO+yz4Cp4j1FYoy35tW7xRZYzPvZ/
irJI67+ApZ7EUJ1Yx1Bf5Yt1nzGwWcXR3CSAS+ZK4KADdui4oalQbBS0OmEOnkG9
Th93avgs532b7BYZhr9ZU5YSvmEL+g==
=b9ts
-----END PGP SIGNATURE-----

--=-g3Z6ANf+IGQOvuuMrD+p--
