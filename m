Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2Wxf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:53:35 -0400
Date: Sun, 29 Oct 2017 23:53:31 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 23/32] v4l: fwnode: Add a helper function for parsing
 generic references
Message-ID: <20171029225331.2nepypjszl7eu27u@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-24-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yhowj2hc7rkvwzyu"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-24-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yhowj2hc7rkvwzyu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:33AM +0300, Sakari Ailus wrote:
> Add function v4l2_fwnode_reference_parse() for parsing them as async
> sub-devices. This can be done on e.g. flash or lens async sub-devices that
> are not part of but are associated with a sensor.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-fwnode.c | 69 +++++++++++++++++++++++++++++=
++++++
>  1 file changed, 69 insertions(+)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index 65bdcd59744a..edd2e8d983a1 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -509,6 +509,75 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_po=
rt(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
> =20
> +/*
> + * v4l2_fwnode_reference_parse - parse references for async sub-devices
> + * @dev: the device node the properties of which are parsed for referenc=
es
> + * @notifier: the async notifier where the async subdevs will be added
> + * @prop: the name of the property
> + *
> + * Return: 0 on success
> + *	   -ENOENT if no entries were found
> + *	   -ENOMEM if memory allocation failed
> + *	   -EINVAL if property parsing failed
> + */
> +static int v4l2_fwnode_reference_parse(
> +	struct device *dev, struct v4l2_async_notifier *notifier,
> +	const char *prop)
> +{
> +	struct fwnode_reference_args args;
> +	unsigned int index;
> +	int ret;
> +
> +	for (index =3D 0;
> +	     !(ret =3D fwnode_property_get_reference_args(
> +		       dev_fwnode(dev), prop, NULL, 0, index, &args));
> +	     index++)
> +		fwnode_handle_put(args.fwnode);
> +
> +	if (!index)
> +		return -ENOENT;
> +
> +	/*
> +	 * Note that right now both -ENODATA and -ENOENT may signal
> +	 * out-of-bounds access. Return the error in cases other than that.
> +	 */
> +	if (ret !=3D -ENOENT && ret !=3D -ENODATA)
> +		return ret;
> +
> +	ret =3D v4l2_async_notifier_realloc(notifier,
> +					  notifier->num_subdevs + index);
> +	if (ret)
> +		return ret;
> +
> +	for (index =3D 0; !fwnode_property_get_reference_args(
> +		     dev_fwnode(dev), prop, NULL, 0, index, &args);
> +	     index++) {
> +		struct v4l2_async_subdev *asd;
> +
> +		if (WARN_ON(notifier->num_subdevs >=3D notifier->max_subdevs)) {
> +			ret =3D -EINVAL;
> +			goto error;
> +		}
> +
> +		asd =3D kzalloc(sizeof(*asd), GFP_KERNEL);
> +		if (!asd) {
> +			ret =3D -ENOMEM;
> +			goto error;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] =3D asd;
> +		asd->match.fwnode.fwnode =3D args.fwnode;
> +		asd->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +		notifier->num_subdevs++;
> +	}
> +
> +	return 0;
> +
> +error:
> +	fwnode_handle_put(args.fwnode);
> +	return ret;
> +}
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> --=20
> 2.11.0
>=20

--yhowj2hc7rkvwzyu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2W+YACgkQ2O7X88g7
+pp1mRAAkFTPeEz/bOaqdoLY4nYzJxAigU4/lBqdy6fYNvHFQqMFlLfi1z72zp3w
PnwhHZOa79b7ukVqXRLN0NHsqIVTRE6kyD3d5seKkk+zmDadNeHZcXHh+X83Xal5
k4WvTG1AImd64qguMYd7rf2w82SERbQ6jy3jzxqY2dcy7eS9LT+gJdqta0hp7GDE
6ab+ktzDkGDYix9om7KI/zWYi38ZhY0U2kxTPjMYPyxqL5SKPXFAfgpoeYQALilh
Dks9EiJfNp8MDFERmgiEyqFJoCBbpcnoFxi977GZIUsWZXzv2mrlZoykYql0o3v6
CddEpz4R6m6kFrTNfL3wQmQUXObjVcu+drTou9a49Mlb9pSW4JVDuL8HGI9XLDe7
7megquYpdVKwlpl7/iUy9MGb71910o4rJYyxqrW9eNXNCfkJ+GS6rW7y9YS8/+aR
hE1UA0VZb1b3pk0qCanmKf6FIM4yllzlHQz481Ze5R6TCIDPJ0CHkd2dnvT8qQRr
EoDjGzXdTLaV6PK8zZZL5OaSO0Jd8rHjjrlF9kVaogMBhyjrRxv+aG6jUXFfRHWR
rR/atTG8u/igp2KvkL+1uT8SoMqYPMzAgLBYctvQVbXnOPR+xSM042NChZaBybLG
6Ss2X2fUgpICWTH+4fD5O50vsl0vEe6IDJCi+NT94CV/FC3bxdc=
=VwzH
-----END PGP SIGNATURE-----

--yhowj2hc7rkvwzyu--
