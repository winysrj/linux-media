Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37675 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753666AbeDRLsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:48:38 -0400
Date: Wed, 18 Apr 2018 13:48:33 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 07/10] media: ov772x: support device tree probing
Message-ID: <20180418114833.GD20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-8-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-8-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:48AM +0900, Akinobu Mita wrote:
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
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Add missing NULL checks for priv->info
> - Leave the check for the missing platform data if legacy platform data
>   probe is used.
>
>  drivers/media/i2c/ov772x.c | 61 ++++++++++++++++++++++++++++++++--------------
>  1 file changed, 43 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 88d1418a..4245a46 100644
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
> +	if (ret < 0)
> +		goto ov772x_set_fmt_error;

You should return ret here, jumping to the ov772x_set_fmt_error label
will only reset the sensor twice and return.

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
> @@ -1271,7 +1286,7 @@ static int ov772x_probe(struct i2c_client *client,
>  	struct i2c_adapter	*adapter = client->adapter;
>  	int			ret;
>
> -	if (!client->dev.platform_data) {
> +	if (!client->dev.of_node && !client->dev.platform_data) {
>  		dev_err(&client->dev, "Missing ov772x platform data\n");

Update the error message as well.

Apart from that:
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
   j

>  		return -EINVAL;
>  	}
> @@ -1372,9 +1387,19 @@ static const struct i2c_device_id ov772x_id[] = {
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

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1zCRAAoJEHI0Bo8WoVY8MBAQAKSXJ6SEt3YFNQNDrcUSOLx2
FOQdOnGXRDQODk9RM3fn3OTQrHUxXOl+v8X29hRkAfvzZ7GhcAJa8NpqaVDv2sPT
wK7GVL2iOBMC5YGYgtEYT25PDmFBJ6kZoS8i+lILSe8ipPuc7Uh+MrnBiLmAHoGv
3COU4a64ij5vaxwYx94JZJD+Pf3fMCZS3jKSbm1BnGYLLGtKJNC/MNCpYNJpyd1x
rYqKCGMGzTA5zQu95yTxmRp1207izC8CdydMHxIgAHzpeKsrtRHfIPfogho73672
wqEqiO9nddkBgy3a9MoLriGaEKiwya7fJJw7A1nBlgL6/KeVqhF2dgaUqbylOVyt
7Ae81SoJzokbt0aZai5HqXJx6ygtSfN/rPT+nn/PyqCmmMq1c9LdOnmbRyHQRYPY
qCMk+o8uk45g/AIVRT6n9pVNF2/z5h8nadTZ35y+mMtaM/Pr5mnzBy+DyTnThftM
3UK+GBnFnn2vURTEuhzDB/SD8CVZH5L6B+t+a0ulskzXCwphBsL5QA5cpTlxCy65
amrmrFAhRhklMy3JdTQBZjkhWPVlT3vzBMmQgIorrMulauFvtfv7r9yobjp1d5rC
TGZBQwKUObYkM3XxkIdeiUBxg7vNkSH9ohuzTh4WcJ+gbhjJqYRcs+uHu6LHQz9R
f94sLN9VD93YzvA8/7GA
=AdWW
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
