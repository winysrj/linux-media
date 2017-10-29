Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2XAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:00:20 -0400
Date: Mon, 30 Oct 2017 00:00:17 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 25/32] v4l: fwnode: Add convenience function for
 parsing common external refs
Message-ID: <20171029230017.srqoc7ojn7umux53@earth>
References: <20171026075342.5760-26-sakari.ailus@linux.intel.com>
 <20171026150327.8247-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a7hcamohr46kjiyn"
Content-Disposition: inline
In-Reply-To: <20171026150327.8247-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--a7hcamohr46kjiyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 06:03:27PM +0300, Sakari Ailus wrote:
> Add v4l2_fwnode_parse_reference_sensor_common for parsing common
> sensor properties that refer to adjacent devices such as flash or lens
> driver chips.
>=20
> As this is an association only, there's little a regular driver needs to
> know about these devices as such.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewd-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
> since v16:
>=20
> - use const char * const *props for string arrays with property names.
>=20
>  drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++=
++++++
>  include/media/v4l2-async.h            |  3 ++-
>  include/media/v4l2-fwnode.h           | 21 +++++++++++++++++++++
>  3 files changed, 58 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index f8cd88f791c4..39387dc6cadd 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -865,6 +865,41 @@ static int v4l2_fwnode_reference_parse_int_props(
>  	return ret;
>  }
> =20
> +int v4l2_async_notifier_parse_fwnode_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier)
> +{
> +	static const char * const led_props[] =3D { "led" };
> +	static const struct {
> +		const char *name;
> +		const char * const *props;
> +		unsigned int nprops;
> +	} props[] =3D {
> +		{ "flash-leds", led_props, ARRAY_SIZE(led_props) },
> +		{ "lens-focus", NULL, 0 },
> +	};
> +	unsigned int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(props); i++) {
> +		int ret;
> +
> +		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
> +			ret =3D v4l2_fwnode_reference_parse_int_props(
> +				dev, notifier, props[i].name,
> +				props[i].props, props[i].nprops);
> +		else
> +			ret =3D v4l2_fwnode_reference_parse(
> +				dev, notifier, props[i].name);
> +		if (ret && ret !=3D -ENOENT) {
> +			dev_warn(dev, "parsing property \"%s\" failed (%d)\n",
> +				 props[i].name, ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 17c4ac7c73e8..8d8cfc3f3100 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -156,7 +156,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async=
_notifier *notifier);
>   * Release memory resources related to a notifier, including the async
>   * sub-devices allocated for the purposes of the notifier but not the no=
tifier
>   * itself. The user is responsible for calling this function to clean up=
 the
> - * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints.
> + * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints or
> + * @v4l2_fwnode_reference_parse_sensor_common.
>   *
>   * There is no harm from calling v4l2_async_notifier_cleanup in other
>   * cases as long as its memory has been zeroed after it has been
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 105cfeee44ef..ca50108dfd8f 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -319,4 +319,25 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_po=
rt(
>  			      struct v4l2_fwnode_endpoint *vep,
>  			      struct v4l2_async_subdev *asd));
> =20
> +/**
> + * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> + *					       sensors for async sub-devices
> + * @dev: the device node the properties of which are parsed for referenc=
es
> + * @notifier: the async notifier where the async subdevs will be added
> + *
> + * Parse common sensor properties for remote devices related to the
> + * sensor and set up async sub-devices for them.
> + *
> + * Any notifier populated using this function must be released with a ca=
ll to
> + * v4l2_async_notifier_release() after it has been unregistered and the =
async
> + * sub-devices are no longer in use, even in the case the function retur=
ned an
> + * error.
> + *
> + * Return: 0 on success
> + *	   -ENOMEM if memory allocation failed
> + *	   -EINVAL if property parsing failed
> + */
> +int v4l2_async_notifier_parse_fwnode_sensor_common(
> +	struct device *dev, struct v4l2_async_notifier *notifier);
> +
>  #endif /* _V4L2_FWNODE_H */
> --=20
> 2.11.0
>=20

--a7hcamohr46kjiyn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XYAACgkQ2O7X88g7
+prx4A/+MeDwza++rUwUa7QPstiYbM9c4ScdPrsQK+2Pd4NmC/bDsaWnKO2lW1Ox
CdpSQSua8hbgsrcc27q3JVOWBXnPi3Bl0ZR9y+jxtHJxFT8dbGYKUAiHDnC9+A4s
/Ox3+QkH/zNjFc3l7GNpv5YJsgL0PFlvBVjkcGYKoELU2gVosbcM661tFojLHfwN
pUJV/i5sGmtejgk63Wq51Jc6mUCiazf1hF/pKeYj2OMMSRHjmFe1aiQH0IJh5/Be
nPBASUySrKJVyMpVlWue1v2r/r/HKMPWDvU5Jd3g9qymoJevF8VeG0bWww8VJe3r
JW3PebVbtUjN0QPgtU/9cX3kiqe+yABeJiSVQlkYp0MFiwl5GIiQ85T2sNsBEp+Z
pHfDmC9PSeS+eLU6WqXhwe2q2lNNEYWuFs5uYEqss8uSdIQk0DJpr1/4YSgTP7p1
cAfgyeuwLW2kHmsV/JCcplLJ3CZTntrSyv9Gq2tpsSztCUXFN19zw/doWw2QLb2P
xQR0qVXJAqosBMxY1YHfSyrye+9o+6hX91CFnylsEjmj6GLr7Ruo0SqO0oxM+svZ
MVSpBkn9LJKAhrw3i/DAUj7ZgxYLJVX4WzuolB0r4oSMeC6aig6bAcAt+2LdVVpT
MpRGWETG2ZSnYAUFIgkFish0ozOZWzcgByZJryvvxkTRLIulq/s=
=5L6U
-----END PGP SIGNATURE-----

--a7hcamohr46kjiyn--
