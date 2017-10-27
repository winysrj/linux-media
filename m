Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbdJ0OtE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:49:04 -0400
Date: Fri, 27 Oct 2017 16:49:01 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 15/32] v4l: async: Register sub-devices before
 calling bound callback
Message-ID: <20171027144901.ac45mvnhtvvn4mgg@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-16-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ua6a5kw7zdmowy4i"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-16-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ua6a5kw7zdmowy4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:25AM +0300, Sakari Ailus wrote:
> Register the sub-device before calling the notifier's bound callback.
> Doing this the other way around is problematic as the struct v4l2_device
> has not assigned for the sub-device yet and may be required by the bound
> callback.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index e170682dae78..46db85685894 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -130,13 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_asyn=
c_notifier *notifier,
>  {
>  	int ret;
> =20
> -	ret =3D v4l2_async_notifier_call_bound(notifier, sd, asd);
> +	ret =3D v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>  	if (ret < 0)
>  		return ret;
> =20
> -	ret =3D v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> +	ret =3D v4l2_async_notifier_call_bound(notifier, sd, asd);
>  	if (ret < 0) {
> -		v4l2_async_notifier_call_unbind(notifier, sd, asd);
> +		v4l2_device_unregister_subdev(sd);
>  		return ret;
>  	}
> =20
> --=20
> 2.11.0
>=20

--ua6a5kw7zdmowy4i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzR1wACgkQ2O7X88g7
+prdnw/+N3KA+1wakuE51jx3r7XxC127Ig5gq8FEsJO4n9sbYqvraIKOQv88yxfE
8DReASbNOAdZjjv6JF2uzZrzXuk6BaFJufknDE29M0s6CyPlO5jvwFgRv0rZq7fY
LZi7GeYe7QSJU+bSanC80Q5YQQbd/677F59BXQANBUHcqP4gOe3UFlN4KUJ2fY/6
95NieR77iD12CtP/TkoFxxjPy/6ykf4DyxgpUFoH4Z5UWRRpp83dvgRu0WIXA/vp
v50f9SMSJ50OJF2RAFnn9vGluWx7tGGKRWGdvJjaslq88K1pX4vB/HG4C9Y6mtN9
AqN9U4HNJlZoQ3m6ejoIaAaKp3d5qx7af0Y+UyWQ173f6cX9Ci4OOi0KqBaBNzJD
q7cO5XNyiBTJrw+8NpTQmMSySI2renmbjRtmz7WP+nle9KAwnVm44fYlGqdL4hEg
6XTlzc709n0CcUZ+5NEOj1TKmuRJ6sYwV/7BB2w1nMtRq85nQisHEOkDURQ8eMEM
SiOnZLkfUNx50jUKeK0+Yhrq2uCmhJhOEBx9VbeOd3QugIFPk4H+R9WwNpwMFIZH
a0MGOZ42SU3q+QNMYW9SOXU0KIqx/6bdbN9A0Lha69pcCFFslykhlgWt3gbx8H/6
KQD5trPNmXbqGG/+K/z7PdsThfFSBAqUS3/4jCkJU9JWV1W0SDs=
=akMn
-----END PGP SIGNATURE-----

--ua6a5kw7zdmowy4i--
