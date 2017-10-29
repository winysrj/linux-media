Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2WZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:25:58 -0400
Date: Sun, 29 Oct 2017 23:25:55 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 19/32] v4l: async: Ensure only unique fwnodes are
 registered to notifiers
Message-ID: <20171029222555.obyxxq4w4wjyn4f2@earth>
References: <20171026075342.5760-20-sakari.ailus@linux.intel.com>
 <20171027105309.8766-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="76r6aiufwecwce3n"
Content-Disposition: inline
In-Reply-To: <20171027105309.8766-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--76r6aiufwecwce3n
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 27, 2017 at 01:53:09PM +0300, Sakari Ailus wrote:
> While registering a notifier, check that each newly added fwnode is
> unique, and return an error if it is not. Also check that a newly added
> notifier does not have the same fwnodes twice.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 89 ++++++++++++++++++++++++++++++=
++----
>  1 file changed, 81 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index ed539c4fd5dc..a33a68e5417b 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -308,8 +308,71 @@ static void v4l2_async_notifier_unbind_all_subdevs(
>  	notifier->parent =3D NULL;
>  }
> =20
> +/* See if an fwnode can be found in a notifier's lists. */
> +static bool __v4l2_async_notifier_fwnode_has_async_subdev(
> +	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
> +{
> +	struct v4l2_async_subdev *asd;
> +	struct v4l2_subdev *sd;
> +
> +	list_for_each_entry(asd, &notifier->waiting, list) {
> +		if (asd->match_type !=3D V4L2_ASYNC_MATCH_FWNODE)
> +			continue;
> +
> +		if (asd->match.fwnode.fwnode =3D=3D fwnode)
> +			return true;
> +	}
> +
> +	list_for_each_entry(sd, &notifier->done, async_list) {
> +		if (WARN_ON(!sd->asd))
> +			continue;
> +
> +		if (sd->asd->match_type !=3D V4L2_ASYNC_MATCH_FWNODE)
> +			continue;
> +
> +		if (sd->asd->match.fwnode.fwnode =3D=3D fwnode)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Find out whether an async sub-device was set up for an fwnode already=
 or
> + * whether it exists in a given notifier before @this_index.
> + */
> +static bool v4l2_async_notifier_fwnode_has_async_subdev(
> +	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode,
> +	unsigned int this_index)
> +{
> +	unsigned int j;
> +
> +	lockdep_assert_held(&list_lock);
> +
> +	/* Check that an fwnode is not being added more than once. */
> +	for (j =3D 0; j < this_index; j++) {
> +		struct v4l2_async_subdev *asd =3D notifier->subdevs[this_index];
> +		struct v4l2_async_subdev *other_asd =3D notifier->subdevs[j];
> +
> +		if (other_asd->match_type =3D=3D V4L2_ASYNC_MATCH_FWNODE &&
> +		    asd->match.fwnode.fwnode =3D=3D
> +		    other_asd->match.fwnode.fwnode)
> +			return true;
> +	}
> +
> +	/* Check than an fwnode did not exist in other notifiers. */
> +	list_for_each_entry(notifier, &notifier_list, list)
> +		if (__v4l2_async_notifier_fwnode_has_async_subdev(
> +			    notifier, fwnode))
> +			return true;
> +
> +	return false;
> +}
> +
>  static int __v4l2_async_notifier_register(struct v4l2_async_notifier *no=
tifier)
>  {
> +	struct device *dev =3D
> +		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
>  	struct v4l2_async_subdev *asd;
>  	int ret;
>  	int i;
> @@ -320,6 +383,8 @@ static int __v4l2_async_notifier_register(struct v4l2=
_async_notifier *notifier)
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> =20
> +	mutex_lock(&list_lock);
> +
>  	for (i =3D 0; i < notifier->num_subdevs; i++) {
>  		asd =3D notifier->subdevs[i];
> =20
> @@ -327,33 +392,41 @@ static int __v4l2_async_notifier_register(struct v4=
l2_async_notifier *notifier)
>  		case V4L2_ASYNC_MATCH_CUSTOM:
>  		case V4L2_ASYNC_MATCH_DEVNAME:
>  		case V4L2_ASYNC_MATCH_I2C:
> +			break;
>  		case V4L2_ASYNC_MATCH_FWNODE:
> +			if (v4l2_async_notifier_fwnode_has_async_subdev(
> +				    notifier, asd->match.fwnode.fwnode, i)) {
> +				dev_err(dev,
> +					"fwnode has already been registered or in notifier's subdev list\n"=
);
> +				ret =3D -EEXIST;
> +				goto out_unlock;
> +			}
>  			break;
>  		default:
> -			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> -				"Invalid match type %u on %p\n",
> +			dev_err(dev, "Invalid match type %u on %p\n",
>  				asd->match_type, asd);
> -			return -EINVAL;
> +			ret =3D -EINVAL;
> +			goto out_unlock;
>  		}
>  		list_add_tail(&asd->list, &notifier->waiting);
>  	}
> =20
> -	mutex_lock(&list_lock);
> -
>  	ret =3D v4l2_async_notifier_try_all_subdevs(notifier);
> -	if (ret)
> +	if (ret < 0)
>  		goto err_unbind;

the error path does no unlock?

>  	ret =3D v4l2_async_notifier_try_complete(notifier);
> -	if (ret)
> +	if (ret < 0)
>  		goto err_unbind;

dito

> +	ret =3D 0;
> =20
>  	/* Keep also completed notifiers on the list */
>  	list_add(&notifier->list, &notifier_list);
> =20
> +out_unlock:
>  	mutex_unlock(&list_lock);
> =20
> -	return 0;
> +	return ret;
> =20
>  err_unbind:
>  	/*

Otherwise:

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

--76r6aiufwecwce3n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2VXMACgkQ2O7X88g7
+prsShAAhMxgKiDzPNyN9AFe7z87NP+VDfzHzYrN7AI3I+isCGi/ZlLkwyrPMVix
qBk4xv4ffHp9PqNZuvqIF5aJhcAmb1dXDj7SvigzK4SIGgy4vKbKHK4Thv3Z8WKi
1QZmzCE02xRmn8mryAfxk9eYKBozNObapBC1103Oa4VoymEPfDmPVsE7hVrHoFRo
MxVqQ0X5q0EIolMc9S2n3JmBOmUXnnt/+GzNxTBqarkE8U03qNjl6o+Fkw0X54RM
RHD2PdaSNaijF5SsrPZypG1wPt9C14wsPhNUYCutPBd0zdLwYHlFgDxiPR19XDIN
pJJZchm4t7WM1ahs4mHfFieKMGRTOL4sNb7YgwBCZCCdUeugvMx8Xdx0GZUypRHo
IBDquP4JCp9+g+LfFvxjFAF94eeEjimCzpQJDfe6JE1M/Z/6gJsn0veOIxnQEDs2
Y9QBPS3PlW4sQc3Mxz+RFGEw/yi+7NKOFUwTAbMuo5Gdn77DIFUX+87+zvFM8n6C
eLlcI0mPrQx1ALEdgeD0hM6IRhaOJhhTU3bxkJS2M9CqHTP8QE5RjCxTbsnIjAbc
aiM6a794K9H/N8fAYifAfJma0amKJO7lR/J+zkIBHgtwSjZJBWb4/cf4br/uV96F
hvMe2xb0RTfNvH/warWKQITyX6fDyr0SgRcUkMPzNtFQREMr5Ew=
=KUw2
-----END PGP SIGNATURE-----

--76r6aiufwecwce3n--
