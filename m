Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdJ0Oql (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:46:41 -0400
Date: Fri, 27 Oct 2017 16:46:38 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 04/32] v4l: async: Fix notifier complete callback
 error handling
Message-ID: <20171027144637.pdcbeuvsmjy6ikq2@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-5-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hbs6e4xhtpnoixnu"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hbs6e4xhtpnoixnu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:14AM +0300, Sakari Ailus wrote:
> The notifier complete callback may return an error. This error code was
> simply returned to the caller but never handled properly.
>=20
> Move calling the complete callback function to the caller from
> v4l2_async_test_notify and undo the work that was done either in async
> sub-device or async notifier registration.
>=20
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 78 +++++++++++++++++++++++++++---=
------
>  1 file changed, 60 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index ca281438a0ae..4924481451ca 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -122,9 +122,6 @@ static int v4l2_async_test_notify(struct v4l2_async_n=
otifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
> =20
> -	if (list_empty(&notifier->waiting) && notifier->complete)
> -		return notifier->complete(notifier);
> -
>  	return 0;
>  }
> =20
> @@ -136,11 +133,27 @@ static void v4l2_async_cleanup(struct v4l2_subdev *=
sd)
>  	sd->asd =3D NULL;
>  }
> =20
> +static void v4l2_async_notifier_unbind_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, sd, sd->asd);
> +
> +		v4l2_async_cleanup(sd);
> +
> +		list_move(&sd->async_list, &subdev_list);
> +	}
> +}
> +
>  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>  				 struct v4l2_async_notifier *notifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> +	int ret;
>  	int i;
> =20
>  	if (!v4l2_dev || !notifier->num_subdevs ||
> @@ -185,19 +198,30 @@ int v4l2_async_notifier_register(struct v4l2_device=
 *v4l2_dev,
>  		}
>  	}
> =20
> +	if (list_empty(&notifier->waiting) && notifier->complete) {
> +		ret =3D notifier->complete(notifier);
> +		if (ret)
> +			goto err_complete;
> +	}
> +
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
> =20
>  	mutex_unlock(&list_lock);
> =20
>  	return 0;
> +
> +err_complete:
> +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> +
> +	mutex_unlock(&list_lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
> =20
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
> -
>  	if (!notifier->v4l2_dev)
>  		return;
> =20
> @@ -205,14 +229,7 @@ void v4l2_async_notifier_unregister(struct v4l2_asyn=
c_notifier *notifier)
> =20
>  	list_del(&notifier->list);
> =20
> -	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		if (notifier->unbind)
> -			notifier->unbind(notifier, sd, sd->asd);
> -
> -		v4l2_async_cleanup(sd);
> -
> -		list_move(&sd->async_list, &subdev_list);
> -	}
> +	v4l2_async_notifier_unbind_all_subdevs(notifier);
> =20
>  	mutex_unlock(&list_lock);
> =20
> @@ -223,6 +240,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier;
> +	int ret;
> =20
>  	/*
>  	 * No reference taken. The reference is held by the device
> @@ -238,19 +256,43 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
> =20
>  	list_for_each_entry(notifier, &notifier_list, list) {
>  		struct v4l2_async_subdev *asd =3D v4l2_async_belongs(notifier, sd);
> -		if (asd) {
> -			int ret =3D v4l2_async_test_notify(notifier, sd, asd);
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +		int ret;
> +
> +		if (!asd)
> +			continue;
> +
> +		ret =3D v4l2_async_test_notify(notifier, sd, asd);
> +		if (ret)
> +			goto err_unlock;
> +
> +		if (!list_empty(&notifier->waiting) || !notifier->complete)
> +			goto out_unlock;
> +
> +		ret =3D notifier->complete(notifier);
> +		if (ret)
> +			goto err_cleanup;
> +
> +		goto out_unlock;
>  	}
> =20
>  	/* None matched, wait for hot-plugging */
>  	list_add(&sd->async_list, &subdev_list);
> =20
> +out_unlock:
>  	mutex_unlock(&list_lock);
> =20
>  	return 0;
> +
> +err_cleanup:
> +	if (notifier->unbind)
> +		notifier->unbind(notifier, sd, sd->asd);
> +
> +	v4l2_async_cleanup(sd);
> +
> +err_unlock:
> +	mutex_unlock(&list_lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_async_register_subdev);
> =20
> --=20
> 2.11.0
>=20

--hbs6e4xhtpnoixnu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzRsoACgkQ2O7X88g7
+pqnlA/+MD+zvWrZyuAA8TlHlsipW/rdmD/exxsGmCVMtok53BCRiGUzm6z9Q1B5
r8FciJCx6AlaA2Qrm0evM0dnZM3zLO1D4vsyEFgQ7c9cTamKSuo51pQ+KZ+Jqmx+
TyoUm45B0L+sstQEzw3WAMxZCRPCjwG3wald8ay2zZCmJ6q8vLvleC3JX88NrPGP
2wAu/T6Saq6kmponTDOAIQLso1OxnFDZTLNx79UAW1BdLm80TIiHvObjMse1NVW2
CtlyhUklilT7BZr+ajQTHJuHUuJONmQyrQfP/CxVuxU3y3zmRaMBYvl0MmrNAhKS
GD3LOcUxdahKmhEnBwhRmCmVWsiUEkzazUGKKy1AogKfb+hyU+lULf/IJfgga1Oi
bsYSj6pUgpDS2z9cWHQCdJeUYxw9w3UPpzFw8UX4IeB1yvJRj1qoWGzKUF+a9AgP
sHU4+5PpdIhj7Iv7iuNo/P0qoNt+vtuS6iSPlkbJ3tQGA5ItJCXqoGoxHI9kHdo7
TuYRyDYhwwtiEpX0clZf4fk29qK2dHmF59iGBwtKq5WqIIr8nOh3QuE7sSDe+U3P
0JSEqEE8e87ij2Np6J7+jp35j5ZHecgJX/tDzBCyO15xAJlapVMx9/IO/HZZLcdK
WPRGfi6yN63IkfhRUYIDwj0cRg70A1mwFsHSZwl7SjoncLWYYtY=
=sJqc
-----END PGP SIGNATURE-----

--hbs6e4xhtpnoixnu--
