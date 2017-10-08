Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45848 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVxo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 17:53:44 -0400
Date: Sun, 8 Oct 2017 23:53:39 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v15 06/32] v4l: async: Use more intuitive names for
 internal functions
Message-ID: <20171008215338.bo3sw4a35zty4usc@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-7-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q7metamltqphlxij"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-7-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q7metamltqphlxij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:25AM +0300, Sakari Ailus wrote:
> Rename internal functions to make the names of the functions better
> describe what they do.
>=20
> 	Old name			New name
> 	v4l2_async_test_notify	v4l2_async_match_notify
> 	v4l2_async_belongs	v4l2_async_find_match
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index cde2cf2ab4b0..8b84fea50c2a 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -60,8 +60,8 @@ static LIST_HEAD(subdev_list);
>  static LIST_HEAD(notifier_list);
>  static DEFINE_MUTEX(list_lock);
> =20
> -static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_no=
tifier *notifier,
> -						    struct v4l2_subdev *sd)
> +static struct v4l2_async_subdev *v4l2_async_find_match(
> +	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
>  {
>  	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
>  	struct v4l2_async_subdev *asd;
> @@ -95,9 +95,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(str=
uct v4l2_async_notifier *
>  	return NULL;
>  }
> =20
> -static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
> -				  struct v4l2_subdev *sd,
> -				  struct v4l2_async_subdev *asd)
> +static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *sd,
> +				   struct v4l2_async_subdev *asd)
>  {
>  	int ret;
> =20
> @@ -187,11 +187,11 @@ int v4l2_async_notifier_register(struct v4l2_device=
 *v4l2_dev,
>  	list_for_each_entry_safe(sd, tmp, &subdev_list, async_list) {
>  		int ret;
> =20
> -		asd =3D v4l2_async_belongs(notifier, sd);
> +		asd =3D v4l2_async_find_match(notifier, sd);
>  		if (!asd)
>  			continue;
> =20
> -		ret =3D v4l2_async_test_notify(notifier, sd, asd);
> +		ret =3D v4l2_async_match_notify(notifier, sd, asd);
>  		if (ret < 0) {
>  			mutex_unlock(&list_lock);
>  			return ret;
> @@ -255,13 +255,14 @@ int v4l2_async_register_subdev(struct v4l2_subdev *=
sd)
>  	INIT_LIST_HEAD(&sd->async_list);
> =20
>  	list_for_each_entry(notifier, &notifier_list, list) {
> -		struct v4l2_async_subdev *asd =3D v4l2_async_belongs(notifier, sd);
> +		struct v4l2_async_subdev *asd =3D v4l2_async_find_match(notifier,
> +								      sd);
>  		int ret;
> =20
>  		if (!asd)
>  			continue;
> =20
> -		ret =3D v4l2_async_test_notify(notifier, sd, asd);
> +		ret =3D v4l2_async_match_notify(notifier, sd, asd);
>  		if (ret)
>  			goto err_unlock;
> =20
> --=20
> 2.11.0
>=20

--q7metamltqphlxij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnanmIACgkQ2O7X88g7
+pqy6w/8CkXI1Hcr1gzKNqvQfacs4rmogwIQLcDFEPvmXc1vMSlh31n1zgx+mlsv
4jlwgSPSHtrCdaGhypmhRBFBMDN+IgdFMuekmgz+MwsF7vB/xlF+95KgciqaVkEo
IKjXcqIsOwYUPalHCxQ8ky7ep2DE17lIYuoQ5JH/P5nIzoDqiH7/yp1KJVHw+bJF
cVtWB9RBGt0xUBvJzmikEAQDKYzusfGvAVGWevVOiKJtzL+Jv/eQPHHiq30PUeWy
PbNI7AhIFz7OmDa8DJWtmQKmwOPSi2tPZ+I5DRzKQvO+2LX87xz+v3wRoc0/P1ap
0C2IJwvB0DLJhx/cw7WXr2Dh/YV7v2ID3ff4AUUWoPWgoSxQisIAlykXHAU23TZt
+SWvwedBK4wrF1Hc9WSgy6AFjyrt2jPY/456ax6+RL1S9VnQGRaz4GAKCDq5ZDit
h0N1cqCu9LCb9uVh/JqtexyGCWm7fMyDyGO5axgbcrX21c0U2fPgtS+vWmjLGgqM
tRw2hKh0aL8S5nfFQQqYn130qcHfCwgWzYnd9CvnxFa/D1orDjoN5iFrUtz1xdya
uEdWKHVb+HYlditfyneLce9LvdXG2vMidEpi7yYem8LWTwvbBJt0o9/7U6e8WFgq
zJJhXtWAn7fwV+xWwzztoY+U/8W1nkbkRQOzT0E/Vt9s4x/HQkc=
=DQDw
-----END PGP SIGNATURE-----

--q7metamltqphlxij--
