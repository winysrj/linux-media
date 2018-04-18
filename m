Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:36261 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbeDRMlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 08:41:49 -0400
Date: Wed, 18 Apr 2018 14:41:39 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 08/10] media: ov772x: handle nested s_power() calls
Message-ID: <20180418124119.GA3999@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-9-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-9-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:49AM +0900, Akinobu Mita wrote:
> Depending on the v4l2 driver, calling s_power() could be nested.  So the
> actual transitions between power saving mode and normal operation mode
> should only happen at the first power on and the last power off.

What do you mean with 'nested' ?

My understanding is that:
- if a sensor driver is mc compliant, it's s_power is called from
  v4l2_mc.c pipeline_pm_power_one() only when the power state changes
- if a sensor driver is not mc compliant, the s_power routine is
  called from the platform driver, and it should not happen that it is
  called twice with the same power state
- if a sensor implements subdev's internal operations open and close
  it may call it's own s_power routines from there, and it can be
  opened more that once.

My understanding is that this driver s_power routines are only called
=66rom platform drivers, and they -should- be safe.

Although, I'm not against this protection completely. Others might be,
though.

>
> This adds an s_power() nesting counter and updates the power state if the
> counter is modified from 0 to !=3D 0 or from !=3D 0 to 0.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - New patch
>
>  drivers/media/i2c/ov772x.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 4245a46..2cd6e85 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -424,6 +424,9 @@ struct ov772x_priv {
>  	/* band_filter =3D COM8[5] ? 256 - BDBASE : 0 */
>  	unsigned short                    band_filter;
>  	unsigned int			  fps;
> +	/* lock to protect power_count */
> +	struct mutex			  power_lock;
> +	int				  power_count;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_pad pad;
>  #endif
> @@ -871,9 +874,25 @@ static int ov772x_power_off(struct ov772x_priv *priv)
>  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct ov772x_priv *priv =3D to_ov772x(sd);
> +	int ret =3D 0;
> +
> +	mutex_lock(&priv->power_lock);
>
> -	return on ? ov772x_power_on(priv) :
> -		    ov772x_power_off(priv);
> +	/* If the power count is modified from 0 to !=3D 0 or from !=3D 0 to 0,
> +	 * update the power state.
> +	 */
> +	if (priv->power_count =3D=3D !on)
> +		ret =3D on ? ov772x_power_on(priv) : ov772x_power_off(priv);

Just release the mutex and return 0 if (power_count =3D=3D on)
The code will be more readable imho.

> +
> +	if (!ret) {
> +		/* Update the power count. */
> +		priv->power_count +=3D on ? 1 : -1;
> +		WARN_ON(priv->power_count < 0);
> +	}
> +
> +	mutex_unlock(&priv->power_lock);
> +
> +	return ret;
>  }
>
>  static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 he=
ight)
> @@ -1303,6 +1322,7 @@ static int ov772x_probe(struct i2c_client *client,
>  		return -ENOMEM;
>
>  	priv->info =3D client->dev.platform_data;
> +	mutex_init(&priv->power_lock);
>
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  	priv->subdev.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> @@ -1314,8 +1334,10 @@ static int ov772x_probe(struct i2c_client *client,
>  	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>  			  V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
>  	priv->subdev.ctrl_handler =3D &priv->hdl;
> -	if (priv->hdl.error)
> -		return priv->hdl.error;
> +	if (priv->hdl.error) {
> +		ret =3D priv->hdl.error;
> +		goto error_mutex_destroy;
> +	}
>
>  	priv->clk =3D clk_get(&client->dev, "xclk");
>  	if (IS_ERR(priv->clk)) {
> @@ -1363,6 +1385,8 @@ static int ov772x_probe(struct i2c_client *client,
>  	clk_put(priv->clk);
>  error_ctrl_free:
>  	v4l2_ctrl_handler_free(&priv->hdl);
> +error_mutex_destroy:
> +	mutex_destroy(&priv->power_lock);

mutex_destroy() does nothing most of the time. It won't hurt though.

Thanks
   j

>
>  	return ret;
>  }
> @@ -1377,6 +1401,7 @@ static int ov772x_remove(struct i2c_client *client)
>  		gpiod_put(priv->pwdn_gpio);
>  	v4l2_async_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
> +	mutex_destroy(&priv->power_lock);
>
>  	return 0;
>  }
> --
> 2.7.4
>

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1z0DAAoJEHI0Bo8WoVY8GMIQAJWqzG1oW0CYgH9YoqF3SNGN
gZob1B9fUJS51ERqstzW7Jdz25E++4rqqXNkcYoQCmdUIE5nm4twjoZztSmI3b0s
OqrOD4agSNypjldfvbTPNutz5cv2wSsoNg+nUh6QFDcEBQLKbj0On6/+uFBsv6IK
d6BKgQbZYgcDHmq5st7NWW4DcESHiNNfFjXI4+TJ1SLBnIyQ5iooFdWK0iWHam1h
bfUBz31uyBx4fih8/3p3ntNNDFLSzKly8kt8tZUgVednmDVjvwVoAJSmnB24e39d
ulCgjxma4CJVqFrQ9DJub1zbjViv0LheUMFKn7wVAXmyvdxzttiZT4fCnog6LfLV
E84vCJ+q9YOFEFfmcTPApRG94qCRrrubw5ljqFiip/IjuqQQI8O7SGOIhnav6pbG
F+xC2hACidEs1YwffPqxiiYXKBK1Pv88Hi0V7ju1iu6yx4dqie26b9MLBl5eRG9f
up8+Ne8axMXF2pH/n9NqqwoWH1cKt+Mtklb4+tGhnwN9znJGNH5Uuf4BfN0sH7om
KQIX5O5ud7ZvPs4oFnAH+k7DwgHhjMjtE/JFgNtRIKTw80F+Uo7KVHQP7jl4ebTw
5a7HWKu5vsNLnw7sDeOQTv8vo8ky0+Y57114B3O/KlNhTjIkMFOgzR7051hWI9Pb
8hbP/T0UQrZa6jKLSCdy
=miD7
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
