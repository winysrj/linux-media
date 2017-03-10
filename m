Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58898 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdCJXc1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 18:32:27 -0500
Date: Sat, 11 Mar 2017 00:32:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 22/39] media: Add userspace header file for i.MX
Message-ID: <20170310233223.GD6540@amd>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-23-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Content-Disposition: inline
In-Reply-To: <1489121599-23206-23-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> diff --git a/include/uapi/media/Kbuild b/include/uapi/media/Kbuild
> index aafaa5a..fa78958 100644
> --- a/include/uapi/media/Kbuild
> +++ b/include/uapi/media/Kbuild
> @@ -1 +1,2 @@
>  # UAPI Header export list
> +header-y +=3D imx.h
> diff --git a/include/uapi/media/imx.h b/include/uapi/media/imx.h
> new file mode 100644
> index 0000000..f573de4
> --- /dev/null
> +++ b/include/uapi/media/imx.h
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (c) 2014-2015 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by =
the
> + * Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version
> + */
> +
> +#ifndef __UAPI_MEDIA_IMX_H__
> +#define __UAPI_MEDIA_IMX_H__
> +
> +enum imx_ctrl_id {
> +	V4L2_CID_IMX_FIM_ENABLE =3D (V4L2_CID_USER_IMX_BASE + 0),
> +	V4L2_CID_IMX_FIM_NUM,
> +	V4L2_CID_IMX_FIM_TOLERANCE_MIN,
> +	V4L2_CID_IMX_FIM_TOLERANCE_MAX,
> +	V4L2_CID_IMX_FIM_NUM_SKIP,
> +};
> +

Should this #include something so that if userland includes it, it
will not get compile error?

Should there be some documentation of userland API?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljDN4cACgkQMOfwapXb+vJ/xQCgjTZD9Q1WUd1lCNyLHB1cw5G/
M/0AoJ8HYtrzVS2KkBgWcN12g/SFLAdq
=8WnM
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--
