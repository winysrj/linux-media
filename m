Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752578AbdBNQH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 11:07:29 -0500
Date: Tue, 14 Feb 2017 17:07:21 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: sakari.ailus@iki.fi, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 06/13] v4l2-async: per notifier locking
Message-ID: <20170214160720.xamqwoqo7rnb2nxi@earth>
References: <20170214133956.GA8530@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bcdwpg2ifusfddct"
Content-Disposition: inline
In-Reply-To: <20170214133956.GA8530@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bcdwpg2ifusfddct
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 14, 2017 at 02:39:56PM +0100, Pavel Machek wrote:
> From: Sebastian Reichel <sre@kernel.org>
>=20
> Without this, camera support breaks boot on N900.

That's kind of vague. I just checked my original patch and it looks
like I did not bother to write a proper patch description. I suggest
to make this

"Fix v4l2-async locking, so that v4l2_async_notifiers can be used
recursively. This is important for sensors, that are only reachable
by the image signal processor through some intermediate device."

You should probably move move this patch directly before the
video-bus-switch patch, since its a preparation for it.

Also this is missing my SoB:

Signed-off-by: Sebastian Reichel <sre@kernel.org>

> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 54 ++++++++++++++++++------------=
------
>  include/media/v4l2-async.h           |  2 ++
>  2 files changed, 29 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 96cc733..26492a2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -57,7 +57,6 @@ static bool match_custom(struct v4l2_subdev *sd, struct=
 v4l2_async_subdev *asd)
> =20
>  static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
> -static DEFINE_MUTEX(list_lock);
> =20
>  static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_no=
tifier *notifier,
>  						    struct v4l2_subdev *sd)
> @@ -102,12 +101,15 @@ static int v4l2_async_test_notify(struct v4l2_async=
_notifier *notifier,
> =20
>  	if (notifier->bound) {
>  		ret =3D notifier->bound(notifier, sd, asd);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			dev_warn(notifier->v4l2_dev->dev, "subdev bound failed\n");
>  			return ret;
> +		}
>  	}
> =20
>  	ret =3D v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0) {
> +		dev_warn(notifier->v4l2_dev->dev, "subdev register failed\n");
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, asd);
>  		return ret;
> @@ -141,7 +143,7 @@ int v4l2_async_notifier_register(struct v4l2_device *=
v4l2_dev,
>  {
>  	struct v4l2_subdev *sd, *tmp;
>  	struct v4l2_async_subdev *asd;
> -	int i;
> +	int ret =3D 0, i;
> =20
>  	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>  		return -EINVAL;
> @@ -149,6 +151,7 @@ int v4l2_async_notifier_register(struct v4l2_device *=
v4l2_dev,
>  	notifier->v4l2_dev =3D v4l2_dev;
>  	INIT_LIST_HEAD(&notifier->waiting);
>  	INIT_LIST_HEAD(&notifier->done);
> +	mutex_init(&notifier->lock);
> =20
>  	for (i =3D 0; i < notifier->num_subdevs; i++) {
>  		asd =3D notifier->subdevs[i];
> @@ -168,28 +171,22 @@ int v4l2_async_notifier_register(struct v4l2_device=
 *v4l2_dev,
>  		list_add_tail(&asd->list, &notifier->waiting);
>  	}
> =20
> -	mutex_lock(&list_lock);
> +	/* Keep also completed notifiers on the list */
> +	list_add(&notifier->list, &notifier_list);
> +	mutex_lock(&notifier->lock);
> =20
>  	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
> -		int ret;
> -
>  		asd =3D v4l2_async_belongs(notifier, sd);
>  		if (!asd)
>  			continue;
> =20
>  		ret =3D v4l2_async_test_notify(notifier, sd, asd);
> -		if (ret < 0) {
> -			mutex_unlock(&list_lock);
> -			return ret;
> -		}
> +		if (ret < 0)
> +			break;
>  	}
> +	mutex_unlock(&notifier->lock);
> =20
> -	/* Keep also completed notifiers on the list */
> -	list_add(&notifier->list, &notifier_list);
> -
> -	mutex_unlock(&list_lock);
> -
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_register);
> =20
> @@ -210,7 +207,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async=
_notifier *notifier)
>  			"Failed to allocate device cache!\n");
>  	}
> =20
> -	mutex_lock(&list_lock);
> +	mutex_lock(&notifier->lock);
> =20
>  	list_del(&notifier->list);
> =20
> @@ -237,7 +234,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async=
_notifier *notifier)
>  			put_device(d);
>  	}
> =20
> -	mutex_unlock(&list_lock);
> +	mutex_unlock(&notifier->lock);
> =20
>  	/*
>  	 * Call device_attach() to reprobe devices
> @@ -262,6 +259,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async=
_notifier *notifier)
>  	}
>  	kfree(dev);
> =20
> +	mutex_destroy(&notifier->lock);
>  	notifier->v4l2_dev =3D NULL;
> =20
>  	/*
> @@ -274,6 +272,7 @@ EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier;
> +	struct v4l2_async_notifier *tmp;
> =20
>  	/*
>  	 * No reference taken. The reference is held by the device
> @@ -283,24 +282,25 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
>  	if (!sd->of_node && sd->dev)
>  		sd->of_node =3D sd->dev->of_node;
> =20
> -	mutex_lock(&list_lock);
> -
>  	INIT_LIST_HEAD(&sd->async_list);
> =20
> -	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd =3D v4l2_async_belongs(notifier, sd);
> +	list_for_each_entry_safe(notifier, tmp, &notifier_list, list) {
> +		struct v4l2_async_subdev *asd;
> +
> +		/* TODO: FIXME: if this is called by ->bound() we will also iterate ov=
er the locked notifier */
> +		mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
> +		asd =3D v4l2_async_belongs(notifier, sd);
>  		if (asd) {
>  			int ret =3D v4l2_async_test_notify(notifier, sd, asd);
> -			mutex_unlock(&list_lock);
> +			mutex_unlock(&notifier->lock);
>  			return ret;
>  		}
> +		mutex_unlock(&notifier->lock);
>  	}
> =20
>  	/* None matched, wait for hot-plugging */
>  	list_add(&sd->async_list, &subdev_list);
> =20
> -	mutex_unlock(&list_lock);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_async_register_subdev);
> @@ -315,7 +315,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev =
*sd)
>  		return;
>  	}
> =20
> -	mutex_lock(&list_lock);
> +	mutex_lock_nested(&notifier->lock, SINGLE_DEPTH_NESTING);
> =20
>  	list_add(&sd->asd->list, &notifier->waiting);
> =20
> @@ -324,6 +324,6 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev =
*sd)
>  	if (notifier->unbind)
>  		notifier->unbind(notifier, sd, sd->asd);
> =20
> -	mutex_unlock(&list_lock);
> +	mutex_unlock(&notifier->lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 8e2a236..690a81f 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -84,6 +84,7 @@ struct v4l2_async_subdev {
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> + * @lock:       lock hold when the notifier is being processed
>   * @bound:	a subdevice driver has successfully probed one of subdevices
>   * @complete:	all subdevices have been probed successfully
>   * @unbind:	a subdevice is leaving
> @@ -95,6 +96,7 @@ struct v4l2_async_notifier {
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
> +	struct mutex lock;
>  	int (*bound)(struct v4l2_async_notifier *notifier,
>  		     struct v4l2_subdev *subdev,
>  		     struct v4l2_async_subdev *asd);
> --=20
> 2.1.4
>=20
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html



--bcdwpg2ifusfddct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlijKzMACgkQ2O7X88g7
+ppNrA/+K5b8PEJ9OWOSGjlVnnmCToBCKaX8SzdQDJJlc/aUGNP6uyVh3us+Dv3q
sWzS8ZGPsiGaDuBG/RwBZyjc8pJvovV5A4+fA0eY1sIy/0sTtmE4ade6QG3mcbmp
Gm/uUNGq4J12IrBbzf4TWRkHkQ+pp+setJjwH2ATqocBBKSezTb4tTh8QUxVUWmA
MnkvX6/QxcRK/PYil5G/Jbw7SSvdJbARf11XQkiTKX2lNtHU/34PaFJtT8ggd7/l
sz8jHXwNZGwjs7ziljVz43V4VZOxyfs09iLWS/aljd9XDrRIBfjxaEDrqdHaOu8C
631jaf9SrHZxo+yjGx8cx6xcemlxo2G6yfoTwKLzWS5C8JUlkounjw9c8CCrGIbQ
gZnjkY1MFWT/2fLsuYaAqsJYSyxBjaouXRWhIfYt1hQojyjokb14H8bRjr+5HuxZ
EZsEgcsieACLaf9tMx1k+nt4TrbqW84+ayhg/cCbLstN8la24Rv5iXB4q9FN2ffP
59aXlif0f5Cun+zPUD3qXd/BqnIigdWBS/1J6CmsTkbx6YaONNQzwqmHp4x8+X/e
m2WnLGNFVQUuz365umcROFEw122AAFEcr4EmJqmyfzNz0Z2shRtXxp0zLSZAmyhN
w22veDzb55Zkmnn2HdvP3NthkBKN77wleg+dmODlm8jRi6SSJG0=
=2iZn
-----END PGP SIGNATURE-----

--bcdwpg2ifusfddct--
