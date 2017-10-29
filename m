Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2WTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:19:24 -0400
Date: Sun, 29 Oct 2017 23:19:20 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 18/32] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20171029221920.cea3d65tmbvusnn7@earth>
References: <20171026075342.5760-19-sakari.ailus@linux.intel.com>
 <20171027082709.27725-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aft32s52x6ab2ctf"
Content-Disposition: inline
In-Reply-To: <20171027082709.27725-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aft32s52x6ab2ctf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 27, 2017 at 11:27:09AM +0300, Sakari Ailus wrote:
> Registering a notifier has required the knowledge of struct v4l2_device
> for the reason that sub-devices generally are registered to the
> v4l2_device (as well as the media device, also available through
> v4l2_device).
>=20
> This information is not available for sub-device drivers at probe time.
>=20
> What this patch does is that it allows registering notifiers without
> having v4l2_device around. Instead the sub-device pointer is stored in the
> notifier. Once the sub-device of the driver that registered the notifier
> is registered, the notifier will gain the knowledge of the v4l2_device,
> and the binding of async sub-devices from the sub-device driver's notifier
> may proceed.
>=20
> The complete callback of the root notifier will be called only when the
> v4l2_device is available and no notifier has pending sub-devices to bind.
> No complete callbacks are supported for sub-device notifiers.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 212 ++++++++++++++++++++++++++++-=
------
>  include/media/v4l2-async.h           |  19 +++-
>  2 files changed, 189 insertions(+), 42 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 6265717769d2..ed539c4fd5dc 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -124,11 +124,87 @@ static struct v4l2_async_subdev *v4l2_async_find_ma=
tch(
>  	return NULL;
>  }
> =20
> +/* Find the sub-device notifier registered by a sub-device driver. */
> +static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
> +	struct v4l2_subdev *sd)
> +{
> +	struct v4l2_async_notifier *n;
> +
> +	list_for_each_entry(n, &notifier_list, list)
> +		if (n->sd =3D=3D sd)
> +			return n;
> +
> +	return NULL;
> +}
> +
> +/* Get v4l2_device related to the notifier if one can be found. */
> +static struct v4l2_device *v4l2_async_notifier_find_v4l2_dev(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	while (notifier->parent)
> +		notifier =3D notifier->parent;
> +
> +	return notifier->v4l2_dev;
> +}
> +
> +/*
> + * Return true if all child sub-device notifiers are complete, false oth=
erwise.
> + */
> +static bool v4l2_async_notifier_can_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd;
> +
> +	if (!list_empty(&notifier->waiting))
> +		return false;
> +
> +	list_for_each_entry(sd, &notifier->done, async_list) {
> +		struct v4l2_async_notifier *subdev_notifier =3D
> +			v4l2_async_find_subdev_notifier(sd);
> +
> +		if (subdev_notifier &&
> +		    !v4l2_async_notifier_can_complete(subdev_notifier))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Complete the master notifier if possible. This is done when all async
> + * sub-devices have been bound; v4l2_device is also available then.
> + */
> +static int v4l2_async_notifier_try_complete(
> +	struct v4l2_async_notifier *notifier)
> +{
> +	/* Quick check whether there are still more sub-devices here. */
> +	if (!list_empty(&notifier->waiting))
> +		return 0;
> +
> +	/* Check the entire notifier tree; find the root notifier first. */
> +	while (notifier->parent)
> +		notifier =3D notifier->parent;
> +
> +	/* This is root if it has v4l2_dev. */
> +	if (!notifier->v4l2_dev)
> +		return 0;
> +
> +	/* Is everything ready? */
> +	if (!v4l2_async_notifier_can_complete(notifier))
> +		return 0;
> +
> +	return v4l2_async_notifier_call_complete(notifier);
> +}
> +
> +static int v4l2_async_notifier_try_all_subdevs(
> +	struct v4l2_async_notifier *notifier);
> +
>  static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_device *v4l2_dev,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	int ret;
> =20
>  	ret =3D v4l2_device_register_subdev(v4l2_dev, sd);
> @@ -149,17 +225,36 @@ static int v4l2_async_match_notify(struct v4l2_asyn=
c_notifier *notifier,
>  	/* Move from the global subdevice list to notifier's done */
>  	list_move(&sd->async_list, &notifier->done);
> =20
> -	return 0;
> +	/*
> +	 * See if the sub-device has a notifier. If not, return here.
> +	 */
> +	subdev_notifier =3D v4l2_async_find_subdev_notifier(sd);
> +	if (!subdev_notifier || subdev_notifier->parent)
> +		return 0;
> +
> +	/*
> +	 * Proceed with checking for the sub-device notifier's async
> +	 * sub-devices, and return the result. The error will be handled by the
> +	 * caller.
> +	 */
> +	subdev_notifier->parent =3D notifier;
> +
> +	return v4l2_async_notifier_try_all_subdevs(subdev_notifier);
>  }
> =20
>  /* Test all async sub-devices in a notifier for a match. */
>  static int v4l2_async_notifier_try_all_subdevs(
>  	struct v4l2_async_notifier *notifier)
>  {
> -	struct v4l2_device *v4l2_dev =3D notifier->v4l2_dev;
> -	struct v4l2_subdev *sd, *tmp;
> +	struct v4l2_device *v4l2_dev =3D
> +		v4l2_async_notifier_find_v4l2_dev(notifier);
> +	struct v4l2_subdev *sd;
> +
> +	if (!v4l2_dev)
> +		return 0;
> =20
> -	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> +again:
> +	list_for_each_entry(sd, &subdev_list, async_list) {
>  		struct v4l2_async_subdev *asd;
>  		int ret;
> =20
> @@ -170,6 +265,14 @@ static int v4l2_async_notifier_try_all_subdevs(
>  		ret =3D v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
>  		if (ret < 0)
>  			return ret;
> +
> +		/*
> +		 * v4l2_async_match_notify() may lead to registering a
> +		 * new notifier and thus changing the async subdevs
> +		 * list. In order to proceed safely from here, restart
> +		 * parsing the list from the beginning.
> +		 */
> +		goto again;
>  	}
> =20
>  	return 0;
> @@ -183,17 +286,26 @@ static void v4l2_async_cleanup(struct v4l2_subdev *=
sd)
>  	sd->asd =3D NULL;
>  }
> =20
> +/* Unbind all sub-devices in the notifier tree. */
>  static void v4l2_async_notifier_unbind_all_subdevs(
>  	struct v4l2_async_notifier *notifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
> =20
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		struct v4l2_async_notifier *subdev_notifier =3D
> +			v4l2_async_find_subdev_notifier(sd);
> +
> +		if (subdev_notifier)
> +			v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> +
>  		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  		v4l2_async_cleanup(sd);
> =20
>  		list_move(&sd->async_list, &subdev_list);
>  	}
> +
> +	notifier->parent =3D NULL;
>  }
> =20
>  static int __v4l2_async_notifier_register(struct v4l2_async_notifier *no=
tifier)
> @@ -208,15 +320,6 @@ static int __v4l2_async_notifier_register(struct v4l=
2_async_notifier *notifier)
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> =20
> -	if (!notifier->num_subdevs) {
> -		int ret;
> -
> -		ret =3D v4l2_async_notifier_call_complete(notifier);
> -		notifier->v4l2_dev =3D NULL;
> -
> -		return ret;
> -	}
> -
>  	for (i =3D 0; i < notifier->num_subdevs; i++) {
>  		asd =3D notifier->subdevs[i];
> =20
> @@ -238,16 +341,12 @@ static int __v4l2_async_notifier_register(struct v4=
l2_async_notifier *notifier)
>  	mutex_lock(&list_lock);
> =20
>  	ret =3D v4l2_async_notifier_try_all_subdevs(notifier);
> -	if (ret) {
> -		mutex_unlock(&list_lock);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_unbind;
> =20
> -	if (list_empty(&notifier->waiting)) {
> -		ret =3D v4l2_async_notifier_call_complete(notifier);
> -		if (ret)
> -			goto err_complete;
> -	}
> +	ret =3D v4l2_async_notifier_try_complete(notifier);
> +	if (ret)
> +		goto err_unbind;
> =20
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
> @@ -256,7 +355,10 @@ static int __v4l2_async_notifier_register(struct v4l=
2_async_notifier *notifier)
> =20
>  	return 0;
> =20
> -err_complete:
> +err_unbind:
> +	/*
> +	 * On failure, unbind all sub-devices registered through this notifier.
> +	 */
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
> =20
>  	mutex_unlock(&list_lock);
> @@ -269,7 +371,7 @@ int v4l2_async_notifier_register(struct v4l2_device *=
v4l2_dev,
>  {
>  	int ret;
> =20
> -	if (WARN_ON(!v4l2_dev))
> +	if (WARN_ON(!v4l2_dev || notifier->sd))
>  		return -EINVAL;
> =20
>  	notifier->v4l2_dev =3D v4l2_dev;
> @@ -282,20 +384,39 @@ int v4l2_async_notifier_register(struct v4l2_device=
 *v4l2_dev,
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
> =20
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!sd || notifier->v4l2_dev))
> +		return -EINVAL;
> +
> +	notifier->sd =3D sd;
> +
> +	ret =3D __v4l2_async_notifier_register(notifier);
> +	if (ret)
> +		notifier->sd =3D NULL;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
> +
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
> -	if (!notifier->v4l2_dev)
> +	if (!notifier->v4l2_dev && !notifier->sd)
>  		return;
> =20
>  	mutex_lock(&list_lock);
> =20
> -	list_del(&notifier->list);
> -
>  	v4l2_async_notifier_unbind_all_subdevs(notifier);
> =20
> -	mutex_unlock(&list_lock);
> -
> +	notifier->sd =3D NULL;
>  	notifier->v4l2_dev =3D NULL;
> +
> +	list_del(&notifier->list);
> +
> +	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> =20
> @@ -331,6 +452,7 @@ EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
> =20
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
> +	struct v4l2_async_notifier *subdev_notifier;
>  	struct v4l2_async_notifier *notifier;
>  	int ret;
> =20
> @@ -347,24 +469,26 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
>  	INIT_LIST_HEAD(&sd->async_list);
> =20
>  	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd =3D v4l2_async_find_match(notifier,
> -								      sd);
> +		struct v4l2_device *v4l2_dev =3D
> +			v4l2_async_notifier_find_v4l2_dev(notifier);
> +		struct v4l2_async_subdev *asd;
>  		int ret;
> =20
> +		if (!v4l2_dev)
> +			continue;
> +
> +		asd =3D v4l2_async_find_match(notifier, sd);
>  		if (!asd)
>  			continue;
> =20
>  		ret =3D v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
>  					      asd);
>  		if (ret)
> -			goto err_unlock;
> -
> -		if (!list_empty(&notifier->waiting))
> -			goto out_unlock;
> +			goto err_unbind;
> =20
> -		ret =3D v4l2_async_notifier_call_complete(notifier);
> +		ret =3D v4l2_async_notifier_try_complete(notifier);
>  		if (ret)
> -			goto err_cleanup;
> +			goto err_unbind;
> =20
>  		goto out_unlock;
>  	}
> @@ -377,11 +501,19 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
> =20
>  	return 0;
> =20
> -err_cleanup:
> -	v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
> +err_unbind:
> +	/*
> +	 * Complete failed. Unbind the sub-devices bound through registering
> +	 * this async sub-device.
> +	 */
> +	subdev_notifier =3D v4l2_async_find_subdev_notifier(sd);
> +	if (subdev_notifier)
> +		v4l2_async_notifier_unbind_all_subdevs(subdev_notifier);
> +
> +	if (sd->asd)
> +		v4l2_async_notifier_call_unbind(notifier, sd, sd->asd);
>  	v4l2_async_cleanup(sd);
> =20
> -err_unlock:
>  	mutex_unlock(&list_lock);
> =20
>  	return ret;
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 68606afb5ef9..17c4ac7c73e8 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -82,7 +82,8 @@ struct v4l2_async_subdev {
>  /**
>   * struct v4l2_async_notifier_operations - Asynchronous V4L2 notifier op=
erations
>   * @bound:	a subdevice driver has successfully probed one of the subdevi=
ces
> - * @complete:	all subdevices have been probed successfully
> + * @complete:	All subdevices have been probed successfully. The complete
> + *		callback is only executed for the root notifier.
>   * @unbind:	a subdevice is leaving
>   */
>  struct v4l2_async_notifier_operations {
> @@ -102,7 +103,9 @@ struct v4l2_async_notifier_operations {
>   * @num_subdevs: number of subdevices used in the subdevs array
>   * @max_subdevs: number of subdevices allocated in the subdevs array
>   * @subdevs:	array of pointers to subdevice descriptors
> - * @v4l2_dev:	pointer to struct v4l2_device
> + * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
> + * @sd:		sub-device that registered the notifier, NULL otherwise
> + * @parent:	parent notifier
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> @@ -113,6 +116,8 @@ struct v4l2_async_notifier {
>  	unsigned int max_subdevs;
>  	struct v4l2_async_subdev **subdevs;
>  	struct v4l2_device *v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	struct v4l2_async_notifier *parent;
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> @@ -128,6 +133,16 @@ int v4l2_async_notifier_register(struct v4l2_device =
*v4l2_dev,
>  				 struct v4l2_async_notifier *notifier);
> =20
>  /**
> + * v4l2_async_subdev_notifier_register - registers a subdevice asynchron=
ous
> + *					 notifier for a sub-device
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @notifier: pointer to &struct v4l2_async_notifier
> + */
> +int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
> +					struct v4l2_async_notifier *notifier);
> +
> +/**
>   * v4l2_async_notifier_unregister - unregisters a subdevice asynchronous=
 notifier
>   *
>   * @notifier: pointer to &struct v4l2_async_notifier
> --=20
> 2.11.0
>=20

--aft32s52x6ab2ctf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2U+UACgkQ2O7X88g7
+po7Xg/+PyX7Luw7Z+C9TTcXay8/GlnfPcQBqYp0XlMfwGjPecjJBGpY1gekzvYU
m6EpR2yQ/iebfcB9MEQuLQq68iYc9UEA5emA8D7zDosofFdGJz+4tKznDFCguIPc
dUj04GVBl1FTx0ZNdDQ5pkRnDMPY5XsJ1tcWrm9hVlIfTgf8n63ie0TZIo9B2jkI
afRyy+DEthi85B+WAPHRPKG7pX0J9h7yubnaSVqbjzqVFL8GI46NoBC8GGhDdv7B
UAeZHXBEBEU3LsoXE7RioV1CY4qzxRetpYA97oHz+VrifX1Ste+isO1GVGf2OyPn
PbyfLpf4EtY6ixQqh7PmCIoyh1xPmq2S1GiOMwXyDMW4KWXlyRZYanaX4WVcNxgT
lyRjXeU1+hxPjKbmxmo3cricC1djE9elL66UkiZrWYQqxx0wuhOSdF26WFAnVXYt
HfHtj2dJQsoJXoVDikcO927eIXxwYNvUdQSlkuIvSvBP/YTvtTHlLh9MBjIWBSsX
fH/RY9+5zKu1x798SeOE26BxzZ2qeRtEJCZlcItN3IzgnDfji+fw9M20Sdi+tgt1
pSSp58lfXmBb+0Ve5+LQ+KGt/zZyojGHfT2G0TeGK3Xg8E9XvFnGH9HEB2n7wSRa
Ms43/bgwEESFrC9P13xu7Jq8NFYYuUI0Ao9PLCmP5KVpQwKOKc8=
=+bFo
-----END PGP SIGNATURE-----

--aft32s52x6ab2ctf--
