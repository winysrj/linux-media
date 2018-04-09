Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:48297 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbeDIIcp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 04:32:45 -0400
Date: Mon, 9 Apr 2018 10:32:37 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH 4/6] media: ov772x: add media controller support
Message-ID: <20180409083237.GW20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-5-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EH85xkKza2NXtwkF"
Content-Disposition: inline
In-Reply-To: <1523116090-13101-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EH85xkKza2NXtwkF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Sun, Apr 08, 2018 at 12:48:08AM +0900, Akinobu Mita wrote:
> Create a source pad and set the media controller type to the sensor.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/ov772x.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 4bb81ff..5e91fa1 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -425,6 +425,9 @@ struct ov772x_priv {
>  	unsigned short                    band_filter;
>  	unsigned int			  fps;
>  	int (*reg_read)(struct i2c_client *client, u8 addr);
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_pad pad;
> +#endif
>  };
>
>  /*
> @@ -1328,9 +1331,17 @@ static int ov772x_probe(struct i2c_client *client,
>  		goto error_clk_put;
>  	}
>
> -	ret = ov772x_video_probe(priv);
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
>  	if (ret < 0)
>  		goto error_gpio_put;
> +#endif
> +
> +	ret = ov772x_video_probe(priv);
> +	if (ret < 0)
> +		goto error_entity_cleanup;

If you remove the #ifdef around the media_entity_cleanup() below, I
suggest moving video_probe() before the entity intialization so you
don't have to #ifdef around the error_gpio_put: label, which otherwise
the compiler complains for being defined but not used.

>
>  	priv->cfmt = &ov772x_cfmts[0];
>  	priv->win = &ov772x_win_sizes[0];
> @@ -1338,11 +1349,15 @@ static int ov772x_probe(struct i2c_client *client,
>
>  	ret = v4l2_async_register_subdev(&priv->subdev);
>  	if (ret)
> -		goto error_gpio_put;
> +		goto error_entity_cleanup;
>
>  	return 0;
>
> +error_entity_cleanup:
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	media_entity_cleanup(&priv->subdev.entity);

media_entity_cleanup() resolves to a nop if CONFIG_MEDIA_CONTROLLER is
not defined

>  error_gpio_put:
> +#endif
>  	if (priv->pwdn_gpio)
>  		gpiod_put(priv->pwdn_gpio);
>  error_clk_put:
> @@ -1357,6 +1372,9 @@ static int ov772x_remove(struct i2c_client *client)
>  {
>  	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
>
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	media_entity_cleanup(&priv->subdev.entity);

ditto

Thanks
   j

> +#endif
>  	clk_put(priv->clk);
>  	if (priv->pwdn_gpio)
>  		gpiod_put(priv->pwdn_gpio);
> --
> 2.7.4
>

--EH85xkKza2NXtwkF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJayyUlAAoJEHI0Bo8WoVY8jlcQAKBwJqYXY24CA3lxLRxy7hn9
/CVMT4rj17gecGljaDiQMB02KHPweoNuxOoCghryS2PbXPhkEIGYsUuFuLn6fPwl
RPRby07JKKNFwLqiyykz33eaESP8xkd3YDaW00LFOJhcSlKxQ21sQ6xl337YtHft
VoFGrGQSeJ+MIFsBRmS0WkRj8RE2vGfGUAavMxdkIPOlZiWCqQvN/T946skNZfOu
iTfCL5LbmOghx39oSemmE52nK8Bq7EHgrU+/l4M0flnYUklXV561i2bJbp0581Bw
3L/8nkQjfVsRp9bNYRFGPDrNzkdosW7tX/DD+Tzkv3kNVOUDmT2nH2Y6k6ytGZjY
er0I03vjEq6P22iSDra9OOzdnUh+sw/50GMi8dhN9QMAku6hwEgcdbWom8dxSli+
EFn4nrS2gMo02ZcFNxMe3VyGKBeU3NsE/NkKPtQuogzGLJ72y2E7ps7aSxWUZ5Mh
ftBUwKkY4tOKOEnYVX4fzfEgAss6fm6PwVLD5wos4FT+UrEXIGLhyXCPNdGD+u3i
Wzud++yYRpFXIkahDdEcDU6HdZWuof+8/6/u0eCye8dsYQ8G5Dlh41SM9fgUwQsl
I/D9n3Oc9ulaaxAJ8WsnXuvBB4GqykkWvw1O5AVJAO1XFqlUwyc79Hi5PrCrpFFJ
Y7e8JmtQGPqi0lC+AQ7h
=22ri
-----END PGP SIGNATURE-----

--EH85xkKza2NXtwkF--
