Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45796 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 17:50:06 -0400
Date: Sun, 8 Oct 2017 23:50:01 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v15 01/32] v4l: async: Remove re-probing support
Message-ID: <20171008215001.tj6smio6tl6nc3dv@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t7ugy67mn7wthl5n"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--t7ugy67mn7wthl5n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:20AM +0300, Sakari Ailus wrote:
> Remove V4L2 async re-probing support. The re-probing support has been
> there to support cases where the sub-devices require resources provided by
> the main driver's hardware to function, such as clocks.
>=20
> Reprobing has allowed unbinding and again binding the main driver without
> explicilty unbinding the sub-device drivers. This is certainly not a
> common need, and the responsibility will be the user's going forward.
>=20
> An alternative could have been to introduce notifier specific locks.
> Considering the complexity of the re-probing and that it isn't really a
> solution to a problem but a workaround, remove re-probing instead.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 54 +-----------------------------=
------
>  1 file changed, 1 insertion(+), 53 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index d741a8e0fdac..60a1a50b9537 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -198,78 +198,26 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
> -	unsigned int notif_n_subdev =3D notifier->num_subdevs;
> -	unsigned int n_subdev =3D min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> -	struct device **dev;
> -	int i =3D 0;
> =20
>  	if (!notifier->v4l2_dev)
>  		return;
> =20
> -	dev =3D kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
> -	if (!dev) {
> -		dev_err(notifier->v4l2_dev->dev,
> -			"Failed to allocate device cache!\n");
> -	}
> -
>  	mutex_lock(&list_lock);
> =20
>  	list_del(&notifier->list);
> =20
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		struct device *d;
> -
> -		d =3D get_device(sd->dev);
> -
>  		v4l2_async_cleanup(sd);
> =20
> -		/* If we handled USB devices, we'd have to lock the parent too */
> -		device_release_driver(d);
> -
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, sd->asd);
> =20
> -		/*
> -		 * Store device at the device cache, in order to call
> -		 * put_device() on the final step
> -		 */
> -		if (dev)
> -			dev[i++] =3D d;
> -		else
> -			put_device(d);
> +		list_move(&sd->async_list, &subdev_list);
>  	}
> =20
>  	mutex_unlock(&list_lock);
> =20
> -	/*
> -	 * Call device_attach() to reprobe devices
> -	 *
> -	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> -	 * executed.
> -	 */
> -	while (i--) {
> -		struct device *d =3D dev[i];
> -
> -		if (d && device_attach(d) < 0) {
> -			const char *name =3D "(none)";
> -			int lock =3D device_trylock(d);
> -
> -			if (lock && d->driver)
> -				name =3D d->driver->name;
> -			dev_err(d, "Failed to re-probe to %s\n", name);
> -			if (lock)
> -				device_unlock(d);
> -		}
> -		put_device(d);
> -	}
> -	kvfree(dev);
> -
>  	notifier->v4l2_dev =3D NULL;
> -
> -	/*
> -	 * Don't care about the waiting list, it is initialised and populated
> -	 * upon notifier registration.
> -	 */
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
> =20
> --=20
> 2.11.0
>=20

--t7ugy67mn7wthl5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnanYcACgkQ2O7X88g7
+prkMw/+KNZml2HdiOH9gTFs3jmq8kzzQEUYdrRA3T07fEdub5XQ9EtzbGNj/enF
9bnPV/XWCrd9gttQnfUMQWA279IMB1KVk7ZHHDi0twXg1grdFdBuCJNIWatmCghk
ud82iVwDwjL+0d92Z9M5phihgyfQRSsCe+ApdAXY/jIJI0KuoaVr+Ux6ul6c/JPR
7t5wh+g6SIKGDMLxAbP+AC2nY44BGhxfVbf4HlFsNGBuzlZwaqrti2L+O3nFdURr
KrZWeht0ZToVk2lZTLF+tZnAm8Vhj9lUvUToCZDgINYVv32kx7zON8R/VZCMY8pE
JxJhw+4OHdBM7W4foKdL/e7thJZv9YhbUWGlzvuVKPxMfRLG/pewcf+f+fz5GsQV
bYzvZwL9zREKFCILikpHPYR7+gdIzr5Qbh25e0WaPXc8TrZnztw4XaiFqTL3la4K
9/7TOGZDW6KQQYwwklI1z0E77zUuAxm7NTVqO21ouwBOcp4RFID5gt5zjJmT875p
40zQEZW652r+E0VptDqEaiYBjXtbgQ4Iokno2Wrtyf38IBlw+2yKpAjO6oxkR63b
D3LHcdWtwAeWAxG2tiewE12sFfa7UUCU/bZ8q4AioJyygLmbsKH/i+K8/23Z1OKI
We5X1xTKa7Ffpvfm1UiRXIPUE14CwqviOhJntTN1vh7Z64T3sV8=
=wWyw
-----END PGP SIGNATURE-----

--t7ugy67mn7wthl5n--
