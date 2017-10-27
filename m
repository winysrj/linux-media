Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751270AbdJ0OsV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:48:21 -0400
Date: Fri, 27 Oct 2017 16:48:18 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 14/32] v4l: async: Introduce helpers for calling
 async ops callbacks
Message-ID: <20171027144818.dwtcxuyrb5ci7rqv@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-15-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bgznnm2zym343hx2"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-15-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bgznnm2zym343hx2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:24AM +0300, Sakari Ailus wrote:
> Add three helper functions to call async operations callbacks. Besides
> simplifying callbacks, this allows async notifiers to have no ops set,
> i.e. it can be left NULL.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 56 +++++++++++++++++++++++++-----=
------
>  1 file changed, 39 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 9d6fc5f25619..e170682dae78 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -25,6 +25,34 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
> =20
> +static int v4l2_async_notifier_call_bound(struct v4l2_async_notifier *n,
> +					  struct v4l2_subdev *subdev,
> +					  struct v4l2_async_subdev *asd)
> +{
> +	if (!n->ops || !n->ops->bound)
> +		return 0;
> +
> +	return n->ops->bound(n, subdev, asd);
> +}
> +
> +static void v4l2_async_notifier_call_unbind(struct v4l2_async_notifier *=
n,
> +					    struct v4l2_subdev *subdev,
> +					    struct v4l2_async_subdev *asd)
> +{
> +	if (!n->ops || !n->ops->unbind)
> +		return;
> +
> +	n->ops->unbind(n, subdev, asd);
> +}
> +
> +static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier =
*n)
> +{
> +	if (!n->ops || !n->ops->complete)
> +		return 0;
> +
> +	return n->ops->complete(n);
> +}
> +
>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *=
asd)
>  {
>  #if IS_ENABLED(CONFIG_I2C)
> @@ -102,16 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_asyn=
c_notifier *notifier,
>  {
>  	int ret;
> =20
> -	if (notifier->ops->bound) {
> -		ret =3D notifier->ops->bound(notifier, sd, asd);
> -		if (ret < 0)
> -			return ret;
> -	}
> +	ret =3D v4l2_async_notifier_call_bound(notifier, sd, asd);
> +	if (ret < 0)
> +		return ret;
> =20
>  	ret =3D v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0) {
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, asd);
>  		return ret;
>  	}
> =20
> @@ -140,8 +165,7 @@ static void v4l2_async_notifier_unbind_all_subdevs(
>  	struct v4l2_subdev *sd, *tmp;
> =20
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, sd->asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  		v4l2_async_cleanup(sd);
> =20
>  		list_move(&sd->async_list, &subdev_list);
> @@ -198,8 +222,8 @@ int v4l2_async_notifier_register(struct v4l2_device *=
v4l2_dev,
>  		}
>  	}
> =20
> -	if (list_empty(&notifier->waiting) && notifier->ops->complete) {
> -		ret =3D notifier->ops->complete(notifier);
> +	if (list_empty(&notifier->waiting)) {
> +		ret =3D v4l2_async_notifier_call_complete(notifier);
>  		if (ret)
>  			goto err_complete;
>  	}
> @@ -296,10 +320,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
>  		if (ret)
>  			goto err_unlock;
> =20
> -		if (!list_empty(&notifier->waiting) || !notifier->ops->complete)
> +		if (!list_empty(&notifier->waiting))
>  			goto out_unlock;
> =20
> -		ret =3D notifier->ops->complete(notifier);
> +		ret =3D v4l2_async_notifier_call_complete(notifier);
>  		if (ret)
>  			goto err_cleanup;
> =20
> @@ -315,8 +339,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	return 0;
> =20
>  err_cleanup:
> -	if (notifier->ops->unbind)
> -		notifier->ops->unbind(notifier, sd, sd->asd);
> +	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	v4l2_async_cleanup(sd);
> =20
>  err_unlock:
> @@ -335,8 +358,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev =
*sd)
> =20
>  		list_add(&sd->asd->list, &notifier->waiting);
> =20
> -		if (notifier->ops->unbind)
> -			notifier->ops->unbind(notifier, sd, sd->asd);
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	}
> =20
>  	v4l2_async_cleanup(sd);
> --=20
> 2.11.0
>=20

--bgznnm2zym343hx2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzRzIACgkQ2O7X88g7
+pqh9RAAjX/Wy6TXNZb1P9Y7gE3gR+JMwLF3piPXgBxQ+mHg16axTnI5DMiegEnJ
NXZrLTy7ML5x7lfbDU9YaxrPSuqaZsu4P3i5zNRDmniWsF/LNolh4ivjMJVLD6Nz
pJFnGgbM3jDuF4+IjzOgRRp1usMb/z5NMtOran6gHWHDWXFH+ArchH4XuoQ4BHUe
jGF2g1/GKGs4DzCyyEJi5hckt7fa0CxrtfU5Kh0fEYoKP0NLdbnjJtsMr/TlSg+x
tFIx2oe55Tpvn4EfJGXnsm+Igzk5mGeQHN94doNuSmE9fZ71ThnakFzRjbE5aGFh
fyN6S9HLw5xPEOUeszDkOPit7VJSTE2kYO25qidWCBIl5y1CBuF9Uk6oCvc7tZAW
36duZt/lPH8X379r2vTdl+VxfypjOKnghTULFXxMnay3dyGaHcG4UEQMJZGhu2WG
wD7TeO9omnqk03+lZoUii2PRzkeYUnRgxY6Q0yPK1FcR7VOiLFciJ7adAxFX3am8
OdoX4cQxj4Unv/Ymqm/ADdokZ7vWknPYVajp3bXLUoo95eO8iaVduIrsh4XLKc7h
IXI5bMgv4qpQSq9OphQr3cYUoDSCiumvL2IfoSgDlUPdg8KdRXRuOAYm3WfAFdlu
V8dgKNYF7iKNMQkzS625pn3rB8e5wu8hGBQXL9GP+qMl5fpcTuc=
=HijD
-----END PGP SIGNATURE-----

--bgznnm2zym343hx2--
