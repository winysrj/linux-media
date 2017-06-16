Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37938 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752686AbdFPMmp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:42:45 -0400
Date: Fri, 16 Jun 2017 14:42:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170616124242.GA8145@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
>=20
> Additionally, for the async sub-device registration to work, the notifier
> containing matching fwnodes will need to be registered. This is natural to
> perform in a sensor driver as well.
>=20
> This does not yet address providing the user space with information on how
> to associate the sensor, lens or EEPROM devices but the kernel now has the
> necessary information to do that.

Do I understand it correctly that basically every sensor driver (in my
case et8ek8) needs to get this kind of support? I2c leds are cheap,
and may be asociated with pretty much any sensor, AFAICT.

This is quite a lot of boilerplate for that. Would it make sense to
provide helper function at least for this?

Thanks,
								Pavel

> -static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
> +static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev,
> +						   struct smiapp_sensor *sensor)
>  {
> +	static const char *props[] =3D { "flash", "lens", "eeprom" };
>  	struct smiapp_hwconfig *hwcfg;
>  	struct v4l2_fwnode_endpoint *bus_cfg;
>  	struct fwnode_handle *ep;
>  	struct fwnode_handle *fwnode =3D dev_fwnode(dev);
> -	int i;
> +	unsigned int i;
>  	int rval;
> =20
>  	if (!fwnode)
> @@ -2849,6 +2878,45 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig=
(struct device *dev)
> =20
>  	v4l2_fwnode_endpoint_free(bus_cfg);
>  	fwnode_handle_put(ep);
> +
> +	sensor->notifier.subdevs =3D
> +		devm_kcalloc(dev, SMIAPP_MAX_ASYNC_SUBDEVS,
> +			     sizeof(struct v4l2_async_subdev *), GFP_KERNEL);
> +	if (!sensor->notifier.subdevs)
> +		goto out_err;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(props); i++) {
> +		struct device_node *node;
> +		unsigned int j =3D 0;
> +
> +		while ((node =3D of_parse_phandle(dev->of_node, props[i], j++))) {
> +			struct v4l2_async_subdev **asd =3D
> +				 &sensor->notifier.subdevs[
> +					 sensor->notifier.num_subdevs];
> +
> +			if (WARN_ON(sensor->notifier.num_subdevs >=3D
> +				    SMIAPP_MAX_ASYNC_SUBDEVS)) {
> +				of_node_put(node);
> +				goto out;
> +			}
> +
> +			*asd =3D devm_kzalloc(
> +				dev, sizeof(struct v4l2_async_subdev),
> +				GFP_KERNEL);
> +			if (!*asd) {
> +				of_node_put(node);
> +				goto out_err;
> +			}
> +
> +			(*asd)->match.fwnode.fwnode =3D of_fwnode_handle(node);
> +			(*asd)->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +			sensor->notifier.num_subdevs++;
> +
> +			of_node_put(node);
> +		}
> +	}
> +
> +out:
>  	return hwcfg;
> =20
>  out_err:

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllD0kEACgkQMOfwapXb+vLPjgCeKSua+0xHhBsizNmqtQ026IX4
XC0AoJXD2aYhc8PNgi+vthA2RNOpEoKW
=y/5V
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
