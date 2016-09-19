Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932163AbcISU7s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:59:48 -0400
Date: Mon, 19 Sep 2016 22:59:28 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 07/17] smiapp: Always initialise the sensor in probe
Message-ID: <20160919205925.myramm47julqwcxb@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-8-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yzdsty7ivvwf5d4e"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-8-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yzdsty7ivvwf5d4e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:21PM +0300, Sakari Ailus wrote:
> Initialise the sensor in probe. The reason why it wasn't previously done
> in case of platform data was that the probe() of the driver that provided
> the clock through the set_xclk() callback would need to finish before the
> probe() function of the smiapp driver. The set_xclk() callback no longer
> exists.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 53 ++++++++++++----------------=
------
>  1 file changed, 19 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index 5d251b4..13322f3 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2530,8 +2530,19 @@ static int smiapp_register_subdev(struct smiapp_se=
nsor *sensor,
>  	return 0;
>  }
> =20
> -static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
> +static void smiapp_cleanup(struct smiapp_sensor *sensor)
> +{
> +	struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->src->sd);
> +
> +	device_remove_file(&client->dev, &dev_attr_nvm);
> +	device_remove_file(&client->dev, &dev_attr_ident);
> +
> +	smiapp_free_controls(sensor);
> +}
> +
> +static int smiapp_registered(struct v4l2_subdev *subdev)
>  {
> +	struct smiapp_sensor *sensor =3D to_smiapp_sensor(subdev);
>  	int rval;
> =20
>  	if (sensor->scaler) {
> @@ -2540,23 +2551,18 @@ static int smiapp_register_subdevs(struct smiapp_=
sensor *sensor)
>  			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
>  			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>  		if (rval < 0)
> -			return rval;
> +			goto out_err;
>  	}
> =20
>  	return smiapp_register_subdev(
>  		sensor, sensor->pixel_array, sensor->binner,
>  		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
>  		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);

I guess you should also handle errors from the second
smiapp_register_subdev call?

> -}
> =20
> -static void smiapp_cleanup(struct smiapp_sensor *sensor)
> -{
> -	struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->src->sd);
> -
> -	device_remove_file(&client->dev, &dev_attr_nvm);
> -	device_remove_file(&client->dev, &dev_attr_ident);
> +out_err:
> +	smiapp_cleanup(sensor);
> =20
> -	smiapp_free_controls(sensor);
> +	return rval;
>  }

-- Sebastian

--yzdsty7ivvwf5d4e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FGqAAoJENju1/PIO/qaHEcP/i26u656m7ZjXFbPYoRtvGjk
WZOK5Ja3ml6OS4u8v9LQv67jUB1sv7TgY0tZ62RJ+smtwqZJApnGcPq/4li09zLd
C9x1pkErQ8CHwZimtek8IvDvEBFcuaYBASIhmvdRROX6mW/0QGcpfRmkoXMjd+5B
q8rYqwYR8wOjzCgF0xfM3du0byUXnnCp8GPKjjz8c8cFFz9wPf/n6OP83NcuXt74
SczFg5bViNn/7qRRwgYrmogwz58htSplO58q66FdKBXdZ+mmyZeu0guyxw5qBZ8n
SoHGohRVv9S53T8zssvvOYQEeLek21qxSW62RT3mGEBX8pMF7IBVAeul0YwopOII
2eQCyPjJ7E0pcAHfAYYc3JZsPpIXnRSDqx3pjMMpYyGussOJc1myhb2mR5GqSe8l
eCDEhkRySRg+tGGX/67qJmWuadT+P6oyyfNSFzcAKDZ5RSdgbudldJxmYkWIYvGx
aT0WVUGK2ReoY5uwNc+8ADWi1bI3REt/8hFBV7O0Jvm4fy9uNJX2GrJ0HVM2DbzD
T2cZSzvqVzVB057XQDil2Z5xFfxjVUH8xlSmkU3PEb/dFXPQSsmHTvc/0aZrtyBr
23/5dvSDOm6HGRNXpwezRaPF4axfFmxDl45L2AHrWqRL6xoXcqGezTKgrgYsFo/k
TI5CfZ93teiL0lT1Jh/l
=hrbu
-----END PGP SIGNATURE-----

--yzdsty7ivvwf5d4e--
