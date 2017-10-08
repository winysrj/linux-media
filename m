Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbdJHVu7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Oct 2017 17:50:59 -0400
Date: Sun, 8 Oct 2017 23:50:54 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v15 03/32] v4l: async: fix unbind error in
 v4l2_async_notifier_unregister()
Message-ID: <20171008215053.x6hpt5snpnuisfvg@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oqounlxpfbcpvowj"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oqounlxpfbcpvowj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:22AM +0300, Sakari Ailus wrote:
> From: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> The call to v4l2_async_cleanup() will set sd->asd to NULL so passing it to
> notifier->unbind() have no effect and leaves the notifier confused. Call
> the unbind() callback prior to cleaning up the subdevice to avoid this.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 21c748bf3a7b..ca281438a0ae 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -206,11 +206,11 @@ void v4l2_async_notifier_unregister(struct v4l2_asy=
nc_notifier *notifier)
>  	list_del(&notifier->list);
> =20
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		v4l2_async_cleanup(sd);
> -
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, sd->asd);
> =20
> +		v4l2_async_cleanup(sd);
> +
>  		list_move(&sd->async_list, &subdev_list);
>  	}
> =20
> @@ -268,11 +268,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subde=
v *sd)
> =20
>  	list_add(&sd->asd->list, &notifier->waiting);
> =20
> -	v4l2_async_cleanup(sd);
> -
>  	if (notifier->unbind)
>  		notifier->unbind(notifier, sd, sd->asd);
> =20
> +	v4l2_async_cleanup(sd);
> +
>  	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> --=20
> 2.11.0
>=20

--oqounlxpfbcpvowj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnanb0ACgkQ2O7X88g7
+priwA//Y0r/6gWVUnIaO7nxBVUhgyLouWxGuwEXJV7J6nqzEptNBeSuhFVRcgmy
W+T7tcwTL4xIWBSHq+npsNtBg2/Hw9Vn7hJWuP7DEHO0ryDk5d1+70OM5Ez/30c9
WfkRFmWO8JIp5MSG3Qnq1xAxQHgQxxvUVkiGa6+ie34vwPCFGad5OrgWylQVDKKr
tHMW+Lqp/UIT2jNwN28LxQUU5CVUh+CHtCSBTE4mPD+hMOw1plZEwj/dV/0iGq8L
DhtpIaK1xKOjGjXvIquVDJW8cE4cWzREqzoQ9AxsCcLZv4YjTTofz/Azqk2Sx9/E
xWC951LrqBsMf2So0XofnLqUNXt3ZnuoUaAvp7fJc1bg3hMJxbEhHoMVqWqLTBCL
3c+eQy2L0UHKhdtD8sV/BSUP05eX5HcjhQZZjrhI4PwXL9kYSzZYDpBeI7XH9t1e
u8BflQw1Gubj3OCEyvoFp61bfNUKIh1xzUxg1AVmmQ5bjCtET5IDSyHBTcvJyeMy
sIWMHrXxYppD8t7KKS0JwlN7Ni6qPbCvBIxsmHvEQybjuxU2vV9E7M6GpbOFC3vT
Tws8rKPGEUaYDR2UY1chEF5jShfoRyMUukuMKGaZTwfMA/rPRo2QCJ5wXyQnmQAK
3d0aRESW3YgLT67ilfa/zgD0vMXelUzywIkJjYzWdigD/kuI4VY=
=FGqn
-----END PGP SIGNATURE-----

--oqounlxpfbcpvowj--
