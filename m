Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54037 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932710AbeGJMHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 08:07:39 -0400
Date: Tue, 10 Jul 2018 14:07:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
Message-ID: <20180710120737.GC6884@amd>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
 <20180622155217.29302-17-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20180622155217.29302-17-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add a single imx-media mem2mem video device that uses the IPU IC PP
> (image converter post processing) task for scaling and colorspace
> conversion.
> On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
>=20
> The hardware only supports writing to destination buffers up to
> 1024x1024 pixels in a single pass, so the mem2mem video device is
> limited to this resolution. After fixing the tiling code it should
> be possible to extend this to arbitrary sizes by rendering multiple
> tiles per frame.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * i.MX IPUv3 mem2mem Scaler/CSC driver
> + *
> + * Copyright (C) 2011 Pengutronix, Sascha Hauer
> + * Copyright (C) 2018 Pengutronix, Philipp Zabel
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */

Point of SPDX is that the last 4 lines can be removed...and if you
want GPL-2.0+ as you state (and I like that), you should also say so
in SPDX.

Thanks,

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltEoYkACgkQMOfwapXb+vIFKwCfcyw8wKhkNyeadVlZ+J0JOU/G
AEUAoMP5zrwQHFn86s2/nfBaARLb7cyv
=0Ndp
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
