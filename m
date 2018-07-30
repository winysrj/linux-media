Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:49237 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbeG3J0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 05:26:06 -0400
Date: Mon, 30 Jul 2018 09:52:19 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, mchehab+samsung@kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH] media: i2c: fix warning in Aptina MT9V111
Message-ID: <20180730075219.GF7615@w540>
References: <1532786089-15015-1-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Cgrdyab2wu3Akvjd"
Content-Disposition: inline
In-Reply-To: <1532786089-15015-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Jasmin,

On Sat, Jul 28, 2018 at 03:54:49PM +0200, Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
>
> This fixes the "'idx' may be used uninitialized in this function"
> warning.
>
> Cc:  Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>

Thanks for the patch

Acked-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

> ---
>  drivers/media/i2c/mt9v111.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
> index da8f6ab..58d5f22 100644
> --- a/drivers/media/i2c/mt9v111.c
> +++ b/drivers/media/i2c/mt9v111.c
> @@ -884,7 +884,7 @@ static int mt9v111_set_format(struct v4l2_subdev *subdev,
>  	struct v4l2_mbus_framefmt new_fmt;
>  	struct v4l2_mbus_framefmt *__fmt;
>  	unsigned int best_fit = ~0L;
> -	unsigned int idx;
> +	unsigned int idx = 0;
>  	unsigned int i;
>
>  	mutex_lock(&mt9v111->stream_mutex);
> --
> 2.7.4
>

--Cgrdyab2wu3Akvjd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbXsOzAAoJEHI0Bo8WoVY8/igQAIRZFfZIMUp4FRdXX23jn6Uw
NdWM0AvQkQEY8YKuQhe775NZPVnnmucR6YsE58YGkHLoPJDggHQ6v9/J+M49qF0X
pnYM50gl+LRsM1qUcHGjtK07iec0C/ejqfleiECk/80TFFxK4kqrS/GzGcphf+Ls
35aMQAUBHhIIf5g8u3ZZTkEzuZkguM/S2+wXypWjpulZSL4wEDseCIq+acTM67QB
hXhq4JXsO6XzGsIT3ZYCh1X9ybri4akFy5dM4koaZuRJuH7vd4iQN9Req/Em9Rm3
daUC719nuvJJq6ahqvpe7xnjWGDSjOqw+cUDo/6MZpY0aYjVICqq7Q/2M2/mMz0L
Kibh8I8cbBydpwXtkdfoG+Yn2850vbDwlxH+GPO2tIlXHBEvuaVjnsATScNCvwRm
LQYsX6Qx3BezhGzVcXlJXvtzfBOf7N9ZFXHowTmo+2Wqszt7aSh/NBz0eF2dB+cu
41UzM2heIDXNCndvvLnYvE34BDJBrZBlg+OxwHQ4xzDVXYRkwkMzFtdKGDgybIWe
FJV7IKzqwMEfGmIPWaBuoFCDetZ88s92IiCmhMH91wOawFGa1OH0rWs0BZo/8olf
eg9MO8OZ5xIcmxf93npU9fGBKmp1uIMNRvNkVHgNzp3MgltVlRfPK3qVhrepoX1F
dWyfPwuMXfjupL6eJrtK
=VF/p
-----END PGP SIGNATURE-----

--Cgrdyab2wu3Akvjd--
