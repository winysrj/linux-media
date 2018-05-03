Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36303 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeECT50 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 15:57:26 -0400
Date: Thu, 3 May 2018 21:57:21 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 08/14] media: ov772x: support device tree probing
Message-ID: <20180503195721.GD19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-9-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <1525021993-17789-9-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Akinobu,
    a very minor thing, please consider this only if you have to
resend.

On Mon, Apr 30, 2018 at 02:13:07AM +0900, Akinobu Mita wrote:
> The ov772x driver currently only supports legacy platform data probe.
> This change enables device tree probing.
>
> Note that the platform data probe can select auto or manual edge control
> mode, but the device tree probling can only select auto edge control mode
> for now.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v4
> - No changes
>
>  drivers/media/i2c/ov772x.c | 64 ++++++++++++++++++++++++++++++++--------------
>  1 file changed, 45 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index f939e28..621149a 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -749,13 +749,13 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_VFLIP:
>  		val = ctrl->val ? VFLIP_IMG : 0x00;
>  		priv->flag_vflip = ctrl->val;
> -		if (priv->info->flags & OV772X_FLAG_VFLIP)
> +		if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
>  			val ^= VFLIP_IMG;
>  		return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
>  	case V4L2_CID_HFLIP:
>  		val = ctrl->val ? HFLIP_IMG : 0x00;
>  		priv->flag_hflip = ctrl->val;
> -		if (priv->info->flags & OV772X_FLAG_HFLIP)
> +		if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
>  			val ^= HFLIP_IMG;
>  		return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
>  	case V4L2_CID_BAND_STOP_FILTER:
> @@ -914,19 +914,14 @@ static void ov772x_select_params(const struct v4l2_mbus_framefmt *mf,
>  	*win = ov772x_select_win(mf->width, mf->height);
>  }
>
> -static int ov772x_set_params(struct ov772x_priv *priv,
> -			     const struct ov772x_color_format *cfmt,
> -			     const struct ov772x_win_size *win)
> +static int ov772x_edgectrl(struct ov772x_priv *priv)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> -	struct v4l2_fract tpf;
>  	int ret;
> -	u8  val;
>
> -	/* Reset hardware. */
> -	ov772x_reset(client);
> +	if (!priv->info)
> +		return 0;
>
> -	/* Edge Ctrl. */
>  	if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
>  		/*
>  		 * Manual Edge Control Mode.
> @@ -937,19 +932,19 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>
>  		ret = ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
>  		if (ret < 0)
> -			goto ov772x_set_fmt_error;
> +			return ret;
>
>  		ret = ov772x_mask_set(client,
>  				      EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
>  				      priv->info->edgectrl.threshold);
>  		if (ret < 0)
> -			goto ov772x_set_fmt_error;
> +			return ret;
>
>  		ret = ov772x_mask_set(client,
>  				      EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
>  				      priv->info->edgectrl.strength);
>  		if (ret < 0)
> -			goto ov772x_set_fmt_error;
> +			return ret;
>
>  	} else if (priv->info->edgectrl.upper > priv->info->edgectrl.lower) {
>  		/*
> @@ -961,15 +956,35 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>  				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
>  				      priv->info->edgectrl.upper);
>  		if (ret < 0)
> -			goto ov772x_set_fmt_error;
> +			return ret;
>
>  		ret = ov772x_mask_set(client,
>  				      EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
>  				      priv->info->edgectrl.lower);
>  		if (ret < 0)
> -			goto ov772x_set_fmt_error;
> +			return ret;
>  	}
>
> +	return 0;
> +}
> +
> +static int ov772x_set_params(struct ov772x_priv *priv,
> +			     const struct ov772x_color_format *cfmt,
> +			     const struct ov772x_win_size *win)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	struct v4l2_fract tpf;
> +	int ret;
> +	u8  val;
> +
> +	/* Reset hardware. */
> +	ov772x_reset(client);
> +
> +	/* Edge Ctrl. */
> +	ret =  ov772x_edgectrl(priv);

You have two spaces before 'ov772x_edgectrl(priv)'

Thanks
   j


> +	if (ret < 0)
> +		return ret;
> +
>  	/* Format and window size. */
>  	ret = ov772x_write(client, HSTART, win->rect.left >> 2);
>  	if (ret < 0)
> @@ -1020,9 +1035,9 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>
>  	/* Set COM3. */
>  	val = cfmt->com3;
> -	if (priv->info->flags & OV772X_FLAG_VFLIP)
> +	if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
>  		val |= VFLIP_IMG;
> -	if (priv->info->flags & OV772X_FLAG_HFLIP)
> +	if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
>  		val |= HFLIP_IMG;
>  	if (priv->flag_vflip)
>  		val ^= VFLIP_IMG;
> @@ -1271,8 +1286,9 @@ static int ov772x_probe(struct i2c_client *client,
>  	struct i2c_adapter	*adapter = client->adapter;
>  	int			ret;
>
> -	if (!client->dev.platform_data) {
> -		dev_err(&client->dev, "Missing ov772x platform data\n");
> +	if (!client->dev.of_node && !client->dev.platform_data) {
> +		dev_err(&client->dev,
> +			"Missing ov772x platform data for non-DT device\n");
>  		return -EINVAL;
>  	}
>
> @@ -1370,9 +1386,19 @@ static const struct i2c_device_id ov772x_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov772x_id);
>
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ov772x_of_match[] = {
> +	{ .compatible = "ovti,ov7725", },
> +	{ .compatible = "ovti,ov7720", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, ov772x_of_match);
> +#endif
> +
>  static struct i2c_driver ov772x_i2c_driver = {
>  	.driver = {
>  		.name = "ov772x",
> +		.of_match_table = of_match_ptr(ov772x_of_match),
>  	},
>  	.probe    = ov772x_probe,
>  	.remove   = ov772x_remove,
> --
> 2.7.4
>

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa62mhAAoJEHI0Bo8WoVY8nywP/1ymphzxTjbhc0iZlSrhIdLE
G9wz3EkzG3C+B7I/uhni3j9XqWSS5vqawkwEnunt7Ib+wbRJWyR1xVWTdgrAoV75
TusydcscdFAFGJFO2QFoGGWwai2tOwPOBWaj9WpfkM+Uq+3ghVtZ8fHWFqbKdajf
P/uJDfdsMsFepqcRAxBl2Omq2VS/kS1Bt7jb8H1tAy/aP0iBgEWqS64q8rnGEB4W
I+T+TE4SyNtT9ZXx7MVC+cs0zmBSVyqbNuw/vvu6hf/zq508dAwcXCoSqtYjGTXa
hENM6TAKM/yl5Pdb7ozCS+OCObPOTnj9Gl6hdSsuRD43MO448duoNr9Z+K4ZCafw
GAwsINS++4KX1BsUxuYrOqi1Mharl2CUDdVC84x9bq0zTupZpr8HwvAwBz3rQfol
o6gVIyGQ7hJSDFvlPdFqJv3ZxgbjSZQRl8heOyRdCbAmFQhuEZu20QLb3LG09G4t
QMsmewcSb0Z/uL1uv/Ge0a0XdtP9VcKSZNsy/0CtepNhQRhlShKNa0s4i4EUv7Kx
OM84Ozb6zFZpTGjiQ29S1RrExR9R6OHtMCu5EsvcZJf142Bl6KOH8c/VE3XsYmcE
SbUeA81Yzn8dxwjtkEZlv/jvg07HjZDzfvcc5nxjf8glnRZlGfXQGmbNhN2C1/s2
8Iou5tNMGHdpgFvF4EHm
=0NIW
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
