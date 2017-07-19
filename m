Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32889 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbdGSL7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 07:59:37 -0400
Date: Wed, 19 Jul 2017 13:59:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/2] staging: greybus: light: Don't leak memory for no
 gain
Message-ID: <20170719115934.GA23510@amd>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20170718184107.10598-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Memory for struct v4l2_flash_config is allocated in
> gb_lights_light_v4l2_register() for no gain and yet the allocated memory =
is
> leaked; the struct isn't used outside the function. Fix this.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>


> diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/li=
ght.c
> index 129ceed39829..b25c117ec41a 100644
> --- a/drivers/staging/greybus/light.c
> +++ b/drivers/staging/greybus/light.c
> @@ -534,25 +534,21 @@ static int gb_lights_light_v4l2_register(struct gb_=
light *light)
>  {
>  	struct gb_connection *connection =3D get_conn_from_light(light);
>  	struct device *dev =3D &connection->bundle->dev;
> -	struct v4l2_flash_config *sd_cfg;
> +	struct v4l2_flash_config sd_cfg =3D { 0 };
>  	struct led_classdev_flash *fled;
>  	struct led_classdev *iled =3D NULL;
>  	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
>  	int ret =3D 0;
=2E...
>  	light->v4l2_flash =3D v4l2_flash_init(dev, NULL, fled, iled,
> -					    &v4l2_flash_ops, sd_cfg);
> +					    &v4l2_flash_ops, &sd_cfg);
>  	if (IS_ERR_OR_NULL(light->v4l2_flash)) {
>  		ret =3D PTR_ERR(light->v4l2_flash);
>  		goto out_free;

Acked-by: Pavel Machek <pavel@ucw.cz>

struct v4l2_flash *v4l2_flash_init(
        struct device *dev, struct fwnode_handle *fwn,
	       struct led_classdev_flash *fled_cdev,
	       	      struct led_classdev_flash *iled_cdev,
		      	     const struct v4l2_flash_ops *ops,
			     	   struct v4l2_flash_config *config)
				  =20
This function saves "ops" argument, but is careful to copy from
"config" argument. Perhaps that's worth a comment?

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllvSaYACgkQMOfwapXb+vLWKgCeOOYrQ3l96G1YbqRcWz2HRUsZ
U8sAnjhKGKAH2+gibflUkqsxqEB1Gpat
=JDPY
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
