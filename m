Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45151 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeENJLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 05:11:45 -0400
Date: Mon, 14 May 2018 11:11:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 14/14] media: ov772x: create subdevice device node
Message-ID: <20180514091104.GF5956@w540>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-15-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <1525616369-8843-15-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,
   thanks for the patch.

On Sun, May 06, 2018 at 11:19:29PM +0900, Akinobu Mita wrote:
> Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so that the
> subdevice device node is created.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j

> ---
> * v5
> - No changes
>
>  drivers/media/i2c/ov772x.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 4b479f9..f7f4fe6 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1409,6 +1409,7 @@ static int ov772x_probe(struct i2c_client *client,
>  	mutex_init(&priv->lock);
>
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
> +	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
>  	/* Use our mutex for the controls */
>  	priv->hdl.lock = &priv->lock;
> --
> 2.7.4
>

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+VKoAAoJEHI0Bo8WoVY8PPQQAK7rWEbq0k10QMdJoOSnMKNv
SvyoZp3oHkIF19yeNSA9LtZoLjGvWemJJOiX7IRhIo68c/QbXx9ZePme8yU563/H
oMS1HhfRqjYFKPNIcIlzbEz3sdixIbAo5p76WxZ1iOw8WK2dBGQj5U6u7TpZM/X7
7KAuzOS01l/haipyqMYzfboBsIVh4oPEBtx4GrXKvOxNkbiie8of7h6wwBTaUNEF
KRuAJcc6CIOxdL8W5nalNZtrNK1LFNqx8EfAtR1dHzJXc9wEDHtXeMYmpHDOZFi+
gfMrl1PzlDopKMDxbkzhJtQdjfZ8lL6S8lljowg0pR4vEAQf5YqgInfXzyuKqdL0
LjkdQYGa5dSqNqcwhyVaPkvEaANTTptWHs8qWKep1y4+7CmBrroqcRhC7zQ4VBVm
qD4CNKFwPKPs1QoPhwjc1iFAJmlnOuyM/3DO3yaiZpz6RqYQlUDJxr/UAIxOrNXg
f0RxtgimO79r3ba/Cx6IYPRvW2Z59kvjsND1m6yiAD9qJ2mkIeDmj/mGqxWsy6Z5
KGlusjOWRFkW8oXKCqvNOr/dsfAE2TaqpugD9rDM43E3rfnMd++ONc9XvGZDlquv
15Sgd4Bc27I2StG3HXJ54R5ndRFrZiTbKCqSvyL4ORG99b7pJeAtvvtC+PSdXqkc
YgMCZ3QR8Yc+vcBzOtDc
=W1KH
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
