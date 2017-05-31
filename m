Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39842 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdEaT6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 15:58:24 -0400
Date: Wed, 31 May 2017 21:58:21 +0200
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
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
Message-ID: <20170531195821.GA16962@amd>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +/* min/typical/max system clock (xclk) frequencies */
> +#define OV5640_XCLK_MIN  6000000
> +#define OV5640_XCLK_MAX 24000000
> +
> +/*
> + * FIXME: there is no subdev API to set the MIPI CSI-2
> + * virtual channel yet, so this is hardcoded for now.
> + */
> +#define OV5640_MIPI_VC	1

Can the FIXME be fixed?

> +/*
> + * image size under 1280 * 960 are SUBSAMPLING

-> Image

> + * image size upper 1280 * 960 are SCALING

above?

> +/*
> + * FIXME: all of these register tables are likely filled with
> + * entries that set the register to their power-on default values,
> + * and which are otherwise not touched by this driver. Those entries
> + * should be identified and removed to speed register load time
> + * over i2c.
> + */

load->loading? Can the FIXME be fixed?

> +	/* Auto/manual exposure */
> +	ctrls->auto_exp =3D v4l2_ctrl_new_std_menu(hdl, ops,
> +						 V4L2_CID_EXPOSURE_AUTO,
> +						 V4L2_EXPOSURE_MANUAL, 0,
> +						 V4L2_EXPOSURE_AUTO);
> +	ctrls->exposure =3D v4l2_ctrl_new_std(hdl, ops,
> +					    V4L2_CID_EXPOSURE_ABSOLUTE,
> +					    0, 65535, 1, 0);

Is exposure_absolute supposed to be in microseconds...?


> +	/* Auto/manual gain */
> +	ctrls->auto_gain =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
> +					     0, 1, 1, 1);
> +	ctrls->gain =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
> +					0, 1023, 1, 0);
> +
> +	ctrls->saturation =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
> +					      0, 255, 1, 64);
> +	ctrls->hue =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HUE,
> +				       0, 359, 1, 0);
> +	ctrls->contrast =3D v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST,
> +					    0, 255, 1, 0);
> +	ctrls->test_pattern =3D
> +		v4l2_ctrl_new_std_menu_items(hdl, ops, V4L2_CID_TEST_PATTERN,
> +					     ARRAY_SIZE(test_pattern_menu) - 1,
> +					     0, 0, test_pattern_menu);
> +

It is good to see sensor that has autogain/etc. I'm emulating them in
v4l-utils, and hardware that supports it is a good argument.=20

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkvIF0ACgkQMOfwapXb+vIQOgCgsTO+wMPGS8nZdQDl/v500f6b
WWEAn05F9/nPXBiTR4tjYn7SprknFjM2
=9cZc
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
