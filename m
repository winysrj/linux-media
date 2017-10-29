Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2XCq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:02:46 -0400
Date: Mon, 30 Oct 2017 00:02:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 26/32] v4l: fwnode: Add a convenience function for
 registering sensors
Message-ID: <20171029230243.wctmoy7wxlrb3txl@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-27-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fje3tushfz2q6bqb"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-27-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fje3tushfz2q6bqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:36AM +0300, Sakari Ailus wrote:
> Add a convenience function for parsing firmware for information on related
> devices using v4l2_async_notifier_parse_fwnode_sensor_common() registering
> the notifier and finally the async sub-device itself.
>=20
> This should be useful for sensor drivers that do not have device specific
> requirements related to firmware information parsing or the async
> framework.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c  | 19 ++++++++++++----
>  drivers/media/v4l2-core/v4l2-fwnode.c | 41 +++++++++++++++++++++++++++++=
++++++
>  include/media/v4l2-async.h            | 22 +++++++++++++++++++
>  include/media/v4l2-subdev.h           |  3 +++
>  4 files changed, 81 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index b4e88eef195f..e81a72b8d46e 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -474,19 +474,25 @@ int v4l2_async_subdev_notifier_register(struct v4l2=
_subdev *sd,
>  }
>  EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
> =20
> -void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +static void __v4l2_async_notifier_unregister(
> +	struct v4l2_async_notifier *notifier)
>  {
> -	if (!notifier->v4l2_dev && !notifier->sd)
> +	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
>  		return;
> =20
> -	mutex_lock(&list_lock);
> -
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
> =20
>  	notifier->sd =3D NULL;
>  	notifier->v4l2_dev =3D NULL;
> =20
>  	list_del(&notifier->list);
> +}
> +
> +void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> +{
> +	mutex_lock(&list_lock);
> +
> +	__v4l2_async_notifier_unregister(notifier);
> =20
>  	mutex_unlock(&list_lock);
>  }
> @@ -596,6 +602,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev=
 *sd)
>  {
>  	mutex_lock(&list_lock);
> =20
> +	__v4l2_async_notifier_unregister(sd->subdev_notifier);
> +	v4l2_async_notifier_cleanup(sd->subdev_notifier);
> +	kfree(sd->subdev_notifier);
> +	sd->subdev_notifier =3D NULL;
> +
>  	if (sd->asd) {
>  		struct v4l2_async_notifier *notifier =3D sd->notifier;
> =20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index 1234bd1a2f49..82af608fd626 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -29,6 +29,7 @@
> =20
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> =20
>  enum v4l2_fwnode_bus_type {
>  	V4L2_FWNODE_BUS_TYPE_GUESS =3D 0,
> @@ -900,6 +901,46 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
> =20
> +int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_notifier *notifier;
> +	int ret;
> +
> +	if (WARN_ON(!sd->dev))
> +		return -ENODEV;
> +
> +	notifier =3D kzalloc(sizeof(*notifier), GFP_KERNEL);
> +	if (!notifier)
> +		return -ENOMEM;
> +
> +	ret =3D v4l2_async_notifier_parse_fwnode_sensor_common(sd->dev,
> +							     notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret =3D v4l2_async_subdev_notifier_register(sd, notifier);
> +	if (ret < 0)
> +		goto out_cleanup;
> +
> +	ret =3D v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto out_unregister;
> +
> +	sd->subdev_notifier =3D notifier;
> +
> +	return 0;
> +
> +out_unregister:
> +	v4l2_async_notifier_unregister(notifier);
> +
> +out_cleanup:
> +	v4l2_async_notifier_cleanup(notifier);
> +	kfree(notifier);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 8d8cfc3f3100..6152434cbe82 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -174,6 +174,28 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_n=
otifier *notifier);
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd);
> =20
>  /**
> + * v4l2_async_register_subdev_sensor_common - registers a sensor sub-dev=
ice to
> + *					      the asynchronous sub-device
> + *					      framework and parse set up common
> + *					      sensor related devices
> + *
> + * @sd: pointer to struct &v4l2_subdev
> + *
> + * This function is just like v4l2_async_register_subdev() with the exce=
ption
> + * that calling it will also parse firmware interfaces for remote refere=
nces
> + * using v4l2_async_notifier_parse_fwnode_sensor_common() and registers =
the
> + * async sub-devices. The sub-device is similarly unregistered by calling
> + * v4l2_async_unregister_subdev().
> + *
> + * While registered, the subdev module is marked as in-use.
> + *
> + * An error is returned if the module is no longer loaded on any attempts
> + * to register it.
> + */
> +int __must_check v4l2_async_register_subdev_sensor_common(
> +	struct v4l2_subdev *sd);
> +
> +/**
>   * v4l2_async_unregister_subdev - unregisters a sub-device to the asynch=
ronous
>   * 	subdevice framework
>   *
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index e83872078376..ec399c770301 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -793,6 +793,8 @@ struct v4l2_subdev_platform_data {
>   *	list.
>   * @asd: Pointer to respective &struct v4l2_async_subdev.
>   * @notifier: Pointer to the managing notifier.
> + * @subdev_notifier: A sub-device notifier implicitly registered for the=
 sub-
> + *		     device using v4l2_device_register_sensor_subdev().
>   * @pdata: common part of subdevice platform data
>   *
>   * Each instance of a subdev driver should create this struct, either
> @@ -823,6 +825,7 @@ struct v4l2_subdev {
>  	struct list_head async_list;
>  	struct v4l2_async_subdev *asd;
>  	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier *subdev_notifier;
>  	struct v4l2_subdev_platform_data *pdata;
>  };
> =20
> --=20
> 2.11.0
>=20

--fje3tushfz2q6bqb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XhMACgkQ2O7X88g7
+ppfKhAApJ4x3+hB0VLVOkzfGw7MGtKiDupgCfwgjbT3SRqPbsgESqgRfhGsFd+Y
rWa154IIjZ0LcJSrcov900bGSct3dWEAoIlX6h2M2Gy6SEBc7s9zsGyQeLsiJQnP
iKT9if4NWs+NzBtBMSPdkZ7bvA/3t4OugJFDz4IgnuQI/nvSBW/xyHn7PcH+i7l4
last/D64RP+6XmjRn/4G/qQjUs2uI+Ep6EqnsNpn2NvXzFZPd61y09jFh4842Fbd
EAwuygnOwG7BYXxFueldMsz/coRNTTpxkwYjCOTZ77wvGwl1gwMXvm7+cbbMyzPR
LEh53IOV2Hwaq1ViUnLAmT1BAWtYJDz03UrJ4qz1Ba74+k31xgoSl2PWdVHkghKS
bg5I4gLMeBPQVAmiacLVKT9qp/RidP0abfl3xt5Dd/YX7SGOs4dpuOc4/K0Rqvcc
JP524XzTU31hdAkNavjwYzECEV8WTZF0zYNtZ4hIwt0/DH/KOf4XWwxWE+ohy+Pz
e+E9rnMZ85BZIYIRgS7a118kzJl7WJaVlbhWZhCUmNgdZFpLg141ENNQ15i4cE2B
PEMOwvGfvCSp1q1hbENPiqzcywyGcfFDt0OT1l7i44qxSUjMxMoMml+8Cu1dt+HT
QhOwrwRwSM0gz2MUoTwbqGeFRSZgG+9A9VZDkAcfEByq0hr7Axk=
=Dxlq
-----END PGP SIGNATURE-----

--fje3tushfz2q6bqb--
