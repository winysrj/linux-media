Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36945 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763599AbdDSNXm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 09:23:42 -0400
Date: Wed, 19 Apr 2017 15:23:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170419132339.GA31747@amd>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> As warned by kbuild test robot:
> 	warning: (VIDEO_EM28XX_V4L2) selects VIDEO_OV2640 which has unmet direct=
 dependencies (MEDIA_SUPPORT && VIDEO_V4L2 && I2C && GPIOLIB && MEDIA_CAMER=
A_SUPPORT)
>=20
> The em28xx driver can use ov2640, but it doesn't depend
> (or use) the GPIOLIB in order to power off/on the sensor.
>=20
> So, as we want to allow both usages with and without
> GPIOLIB, make its dependency optional.

Umm. The driver will not work too well with sensor powered off, no?
Will this result in some tricky-to-debug situations?

>  config VIDEO_OV2640
>  	tristate "OmniVision OV2640 sensor support"
> -	depends on VIDEO_V4L2 && I2C && GPIOLIB
> +	depends on VIDEO_V4L2 && I2C
>  	depends on MEDIA_CAMERA_SUPPORT
>  	help
>  	  This is a Video4Linux2 sensor-level driver for the
>  	OmniVision

Better solution would be for VIDEO_EM28XX_V4L2 to depend on GPIOLIB,
too, no? If not, should there be BUG_ON(priv->pwdn_gpio);
BUG_ON(priv->resetb_gpio);?


> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index d55ca37dc12f..9c00ed3543f8 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -743,13 +743,16 @@ static int ov2640_s_power(struct v4l2_subdev *sd, i=
nt on)
>  	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
>  	struct ov2640_priv *priv =3D to_ov2640(client);
> =20
> -	gpiod_direction_output(priv->pwdn_gpio, !on);
> +#ifdef CONFIG_GPIOLIB
> +	if (priv->pwdn_gpio)
> +		gpiod_direction_output(priv->pwdn_gpio, !on);
>  	if (on && priv->resetb_gpio) {
>  		/* Active the resetb pin to perform a reset pulse */
>  		gpiod_direction_output(priv->resetb_gpio, 1);
>  		usleep_range(3000, 5000);
>  		gpiod_direction_output(priv->resetb_gpio, 0);
>  	}
> +#endif
>  	return 0;
>  }

What is going on there? Should that be

              gpiod_direction_output(priv->resetb_gpio, 1);
              usleep_range(3000, 5000);
              gpiod_set_value(priv->resetb_gpio, 0);

for readability's sake?

								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj3ZNsACgkQMOfwapXb+vJnzgCePMIQNKGCkwz01xv0q3IQLCh1
kuwAoIBeNkxJxEys3xEJze/48iZMe2L6
=3PHO
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
