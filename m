Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52969 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbeDRLes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:34:48 -0400
Date: Wed, 18 Apr 2018 13:34:42 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 05/10] media: ov772x: use generic names for reset and
 powerdown gpios
Message-ID: <20180418113442.GB20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-6-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-6-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:46AM +0900, Akinobu Mita wrote:
> The ov772x driver uses "rstb-gpios" and "pwdn-gpios" for reset and
> powerdown pins.  However, using generic names for thse gpios is preferred.

nit: 'these gpios'

> ("reset-gpios" and "powerdown-gpios" respectively)
>
> There is only one mainline user for these gpios, so rename to generic
> names.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Bindings update should come first.
Not a big deal.

Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

> ---
> * v2
> - New patch
>
>  arch/sh/boards/mach-migor/setup.c | 5 +++--
>  drivers/media/i2c/ov772x.c        | 8 ++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
> index 271dfc2..73b9ee4 100644
> --- a/arch/sh/boards/mach-migor/setup.c
> +++ b/arch/sh/boards/mach-migor/setup.c
> @@ -351,8 +351,9 @@ static struct platform_device migor_ceu_device = {
>  static struct gpiod_lookup_table ov7725_gpios = {
>  	.dev_id		= "0-0021",
>  	.table		= {
> -		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "pwdn", GPIO_ACTIVE_HIGH),
> -		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "powerdown",
> +			    GPIO_ACTIVE_HIGH),
> +		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "reset", GPIO_ACTIVE_LOW),
>  	},
>  };
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 0ae2a4f..88d1418a 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -837,10 +837,10 @@ static int ov772x_power_on(struct ov772x_priv *priv)
>  	 * available to handle this cleanly, request the GPIO temporarily
>  	 * to avoid conflicts.
>  	 */
> -	priv->rstb_gpio = gpiod_get_optional(&client->dev, "rstb",
> +	priv->rstb_gpio = gpiod_get_optional(&client->dev, "reset",
>  					     GPIOD_OUT_LOW);
>  	if (IS_ERR(priv->rstb_gpio)) {
> -		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
> +		dev_info(&client->dev, "Unable to get GPIO \"reset\"");
>  		return PTR_ERR(priv->rstb_gpio);
>  	}
>
> @@ -1309,10 +1309,10 @@ static int ov772x_probe(struct i2c_client *client,
>  		goto error_ctrl_free;
>  	}
>
> -	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "pwdn",
> +	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "powerdown",
>  					     GPIOD_OUT_LOW);
>  	if (IS_ERR(priv->pwdn_gpio)) {
> -		dev_info(&client->dev, "Unable to get GPIO \"pwdn\"");
> +		dev_info(&client->dev, "Unable to get GPIO \"powerdown\"");
>  		ret = PTR_ERR(priv->pwdn_gpio);
>  		goto error_clk_put;
>  	}
> --
> 2.7.4
>

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1y1SAAoJEHI0Bo8WoVY8SCIP/12HbzFFnFfVlQrnEchTO2js
q001fvtPwmnInfQiVLpeSyYaZZSBUm7RYkCghXXczYUiiEu/iubbW5rAh7o1nya5
n1mDPgvxrmee6NgNxLPyDLL50rhZOY3CbkVCVzvosekjOWva1DktBI6UzUBiuikf
vqXAKrTz+mXBiUbEnoLtXX18RGxOlI+I5KEY6RwgIIq83jx7Bhu/Kgux6dlk2fsQ
orJhTB9qXH6mbjeqRjqXDDuYhcxCrE0tDKdnwhhEngwPGP+osF6kBDTFj15AVbSu
f0qslnEoHFKkfdi0+WkyXqRn5dz7u1oWCGaZoLpLqJhB+OXSdfAWf2djns1dFCj9
omAag0viQRjoylMmkMyO7FFQOrProj69CUqXRx2zlityLrjD3lt2aFUrX/7iuqGF
FiPC/QamHnsGaSiSt6yF02+6Ql2TUmskp7+p844Hl85mvDcATS2q77TN+xmED7Ly
pX+iAxfeRLWXx+OvNQgr+YUADwmUj6z5NlCjR6H2ofPrWaZTy/jEvTkjTYsz7ujQ
Fxf2cHqVbcovjsDD2clCGO8RsWaQ+X4Zju16L/hvbdcTZziAW6j8rQ0axWEePD7U
Db3kEIFQWTcc2RFppZiLhMGFHfeL+X4yC0kZ4hM3NW37Ff1RlkKrDf3babhRc4jA
4EvbkRJ+kXlBzk0duhMp
=0o3G
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
