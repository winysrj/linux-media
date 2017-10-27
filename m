Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdJ0OuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:50:25 -0400
Date: Fri, 27 Oct 2017 16:50:19 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 17/32] v4l: async: Prepare for async sub-device
 notifiers
Message-ID: <20171027145019.wl2nqmh6pzcx2bej@earth>
References: <20171026075342.5760-18-sakari.ailus@linux.intel.com>
 <20171027082629.27648-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e5zaz3623q6ibkrr"
Content-Disposition: inline
In-Reply-To: <20171027082629.27648-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--e5zaz3623q6ibkrr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 27, 2017 at 11:26:29AM +0300, Sakari Ailus wrote:
> Refactor the V4L2 async framework a little in preparation for async
> sub-device notifiers. This avoids making some structural changes in the
> patch actually implementing sub-device notifiers, making that patch easier
> to review.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 69 ++++++++++++++++++++++++++----=
------
>  1 file changed, 50 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 1b536d68cedf..6265717769d2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -125,12 +125,13 @@ static struct v4l2_async_subdev *v4l2_async_find_ma=
tch(
>  }
> =20
>  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_device *v4l2_dev,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
>  	int ret;
> =20
> -	ret =3D v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> +	ret =3D v4l2_device_register_subdev(v4l2_dev, sd);
>  	if (ret < 0)
>  		return ret;
> =20
> @@ -151,6 +152,29 @@ static int v4l2_async_match_notify(struct v4l2_async=
_notifier *notifier,
>  	return 0;
>  }
> =20
> +/* Test all async sub-devices in a notifier for a match. */
> +static int v4l2_async_notifier_try_all_subdevs(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_device *v4l2_dev =3D notifier->v4l2_dev;
> +	struct v4l2_subdev *sd, *tmp;
> +
> +	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +		struct v4l2_async_subdev *asd;
> +		int ret;
> +
> +		asd =3D v4l2_async_find_match(notifier, sd);
> +		if (!asd)
> +			continue;
> +
> +		ret =3D v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  {
>  	v4l2_device_unregister_subdev(sd);
> @@ -172,18 +196,15 @@ static void v4l2_async_notifier_unbind_all_subdevs(
>  	}
>  }
> =20
> -int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> -				 struct v4l2_async_notifier *notifier)
> +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *no=
tifier)
>  {
> -	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
>  	int ret;
>  	int i;
> =20
> -	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
> +	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
> =20
> -	notifier->v4l2_dev =3D v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> =20
> @@ -216,18 +237,10 @@ int v4l2_async_notifier_register(struct v4l2_device=
 *v4l2_dev,
> =20
>  	mutex_lock(&list_lock);
> =20
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
> -		asd =3D v4l2_async_find_match(notifier, sd);
> -		if (!asd)
> -			continue;
> -
> -		ret =3D v4l2_async_match_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +	ret =3D v4l2_async_notifier_try_all_subdevs(notifier);
> +	if (ret) {
> +		mutex_unlock(&list_lock);
> +		return ret;
>  	}
> =20
>  	if (list_empty(&notifier->waiting)) {
> @@ -250,6 +263,23 @@ int v4l2_async_notifier_register(struct v4l2_device =
*v4l2_dev,
> =20
>  	return ret;
>  }
> +
> +int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> +				 struct v4l2_async_notifier *notifier)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!v4l2_dev))
> +		return -EINVAL;
> +
> +	notifier->v4l2_dev =3D v4l2_dev;
> +
> +	ret =3D __v4l2_async_notifier_register(notifier);
> +	if (ret)
> +		notifier->v4l2_dev =3D NULL;
> +
> +	return ret;
> +}
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
> =20
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> @@ -324,7 +354,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  		if (!asd)
>  			continue;
> =20
> -		ret =3D v4l2_async_match_notify(notifier, sd, asd);
> +		ret =3D v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
> +					      asd);
>  		if (ret)
>  			goto err_unlock;
> =20
> --=20
> 2.11.0
>=20

--e5zaz3623q6ibkrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzR6sACgkQ2O7X88g7
+poL7hAAiNf4PNyyl7pTa39p93wDb5KGifIz809w+XuaWB+8ZGd7Tsjt6jQESWJB
bvKh51tkQ4lifMXFcbMFcm7d8Ygfw1w838nMsml9EwELjAjqyLLQ5KbzCSRu5dgr
N6jvYXh/mHWSq15ZzQ25TBB1pHpgVwCK1tgKlx/XxNxW5llsPRrugWYPdISH227K
UizcGJ0elufaZaXIYlyJRx0uAjMksGL6DWzJivp/ddKk8rZMQSD3Xx1at5h+04LQ
jR1ih5BhPVYJT0eZjB7KqP2OwucP+5h6/Lf6gke0c0T7D7NlyzEDS80iiBBaIS2F
WyrmM8dLsH+FlYuIqT7RpkPAaMPsyKOe2AYzQZqZcH2DR57M3iEH5lOW6LQkodvH
io8dlLgeQArMY/8b4p47Qv684qhVdAcP56n3lHTCWeaTu76olyaXRi7XRLMKVpe0
BvDbJDnENUunChKeMcyJ4iqqEHsxG4AY0G6WzLk07aH/NPGa4U3bGoyE93/Htu0Q
lR4vpNeBcoTg1hYV5ELjOi7pCLDVYOLxNe6yIi6ofLmgdi2YNL1fOigoYYoMAGKu
RmVTQViiELauG1gD8beLkPLdv1uJcJAaC8b4dnU1yiLQTS1HwZNhsGZ1bSakCnex
vNe1YDAMw9QvVJMqvoO0DgeDMGNpE8AhORl6XNOJqjpw3aB+mVQ=
=jORW
-----END PGP SIGNATURE-----

--e5zaz3623q6ibkrr--
