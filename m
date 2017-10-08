Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45830 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdJHVw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 17:52:29 -0400
Date: Sun, 8 Oct 2017 23:52:25 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v15 05/32] v4l: async: Correctly serialise async
 sub-device unregistration
Message-ID: <20171008215225.jzro7ye4usv23qwn@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-6-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hyba3uxdcftsevnc"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-6-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hyba3uxdcftsevnc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:24AM +0300, Sakari Ailus wrote:
> The check whether an async sub-device is bound to a notifier was performed
> without list_lock held, making it possible for another process to
> unbind the async sub-device before the sub-device unregistration function
> proceeds to take the lock.
>=20
> Fix this by first acquiring the lock and then proceeding with the check.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 4924481451ca..cde2cf2ab4b0 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -298,20 +298,16 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
> =20
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
> -	struct v4l2_async_notifier *notifier =3D sd->notifier;
> -
> -	if (!sd->asd) {
> -		if (!list_empty(&sd->async_list))
> -			v4l2_async_cleanup(sd);
> -		return;
> -	}
> -
>  	mutex_lock(&list_lock);
> =20
> -	list_add(&sd->asd->list, &notifier->waiting);
> +	if (sd->asd) {
> +		struct v4l2_async_notifier *notifier =3D sd->notifier;
> =20
> -	if (notifier->unbind)
> -		notifier->unbind(notifier, sd, sd->asd);
> +		list_add(&sd->asd->list, &notifier->waiting);
> +
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, sd, sd->asd);
> +	}
> =20
>  	v4l2_async_cleanup(sd);
> =20
> --=20
> 2.11.0
>=20

--hyba3uxdcftsevnc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnanhkACgkQ2O7X88g7
+prAdA//Urd5/ue2rPAqWxRW8RsFsNanNXhQos2Dkc52wRd8YnCENXM0q/YQR0Eg
l9nHemT/L3tPKPWNEjwrOYigd1//Eji+F2uE1WL8URO2Sbzu2r4TtSAHAGVblw+b
Obkehx0wyF/3Ytu2QQcRk8KW6vvg/4tDjWWFrx9EOEan/OTJWCTw6KnPrI81Pspk
7x4Jt1DV+qPTTZ5mheyMWb8Cz73jF7IuunKteOCEvOi+gtdyn6fss3T45i1eh4C0
K0scAhOmOXRFZZqfbSlWWp7Dh4N8T+lIWDDuRKkCYSX2394bzNeST1AKtwWrPN7h
PY+KOxU4uXjYQXs/h1wsCia5Pg+fqEL3lGTjLoBx7mWacX4EFJpEaz6vFdw8HR9B
7S5T4sAmYrEwUowgT1nwKt7LOUbc1stjyt3SeILUvJIpRojusD/whnBXvjaHbke8
fat0X8mOTj59CpBKtHdEcuhQxd/Q1o5a9bcjE+GnVptnscYoXYVuUUlHWM7ACAhF
N7r6Qt/bPW1r4C5a8dWt2vSxmpbdwBLCaKZv+xMbGEPJYaqbcH/7M33bQH4KPoFj
com+m9fSpifNOicJIexv1UAZvdTecXKTf6G7DNAfK/ifUj0zaWiHsyRaQyr62mDm
uAoQgqcSo4FCkE4RL/ojo2OGJzKxFMkrQCytMbqgRBkpV09s7ME=
=C7cx
-----END PGP SIGNATURE-----

--hyba3uxdcftsevnc--
