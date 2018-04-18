Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41125 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeDRL2Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:28:24 -0400
Date: Wed, 18 Apr 2018 13:28:14 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 04/10] media: ov772x: add media controller support
Message-ID: <20180418112814.GA20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:45AM +0900, Akinobu Mita wrote:
> Create a source pad and set the media controller type to the sensor.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Not strictly on this patch, but I'm a bit confused on the difference
between CONFIG_MEDIA_CONTROLLER and CONFIG_VIDEO_V4L2_SUBDEV_API...
Doesn't media controller support mandate implementing subdev APIs as
well?

Thanks
   j
> ---
> * v2
> - Move video_probe() before the entity initialization and remove the #ifdef
>   around the media_entity_cleanup()
>
>  drivers/media/i2c/ov772x.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 188f2f1..0ae2a4f 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -424,6 +424,9 @@ struct ov772x_priv {
>  	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>  	unsigned short                    band_filter;
>  	unsigned int			  fps;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_pad pad;
> +#endif
>  };
>
>  /*
> @@ -1318,16 +1321,26 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto error_gpio_put;
>
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
> +	if (ret < 0)
> +		goto error_gpio_put;
> +#endif
> +
>  	priv->cfmt = &ov772x_cfmts[0];
>  	priv->win = &ov772x_win_sizes[0];
>  	priv->fps = 15;
>
>  	ret = v4l2_async_register_subdev(&priv->subdev);
>  	if (ret)
> -		goto error_gpio_put;
> +		goto error_entity_cleanup;
>
>  	return 0;
>
> +error_entity_cleanup:
> +	media_entity_cleanup(&priv->subdev.entity);
>  error_gpio_put:
>  	if (priv->pwdn_gpio)
>  		gpiod_put(priv->pwdn_gpio);
> @@ -1343,6 +1356,7 @@ static int ov772x_remove(struct i2c_client *client)
>  {
>  	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
>
> +	media_entity_cleanup(&priv->subdev.entity);
>  	clk_put(priv->clk);
>  	if (priv->pwdn_gpio)
>  		gpiod_put(priv->pwdn_gpio);
> --
> 2.7.4
>

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1yvOAAoJEHI0Bo8WoVY8l/AP/jgDR7SrcDw1/bSHlphQtXF/
HNw+ofW9LFE0F6mzJ1A+v7lEF+duIN03D1qQiFpC43zkkF96Si3HsbL7tgFDvk15
Yb/668976Y7U9cRoIUCbNrjbMpeHNTx2Aqtxuv9li9m+JsOzQS35gQw+eTuheXFW
+duZn/4mHw+I8g8XzPBlCpVRLUW6mRRTghlRphz3/V3BiC/fK7Lp9P3pyzmM+/J1
h/32pvm5CEA4naUMOe+vchB9yeXiF9rlIq+KGwBnTFaphfZhGZ2ki7OCm+tUHZHF
lpsp6ZWz02clWycc84MOToXLb0V4o32ygy5F+byHTx+Uk3DX5dPuZUIcMZnOmkN2
Oy5ZlsmEBwrLpL6E6iNzHJFjEAnkH9uqL231x/ArHqQYKf29h3P5zYUiQ94eGra2
ehidBdGUOQOrON7jGgmfeqBLe5tXA2mlHFMDHs/+FCqvc1qujJMKjWiojHn17HyI
sD97a/5fIiX+b/mJN63Trzv7iXrT0duIJSjhDo911zrSAP6tuGWpd8Kh9U0DKz4X
1LViKvhyZQxLakElpQJ+MIb8FlmyzfqU8zRvmpUE4wmb0WLKpVsLgHdSCKQoq98l
l6+nP2e1pCSjLMLqcKPjDU0C/1zCSAnPG8UeaUqSHWG74mlfYRcYIncvA866StPT
1SA1uLMPIogDIOGU5m5E
=Fj2b
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
