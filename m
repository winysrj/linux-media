Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:40335 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753883AbeDRMzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 08:55:43 -0400
Date: Wed, 18 Apr 2018 14:55:36 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 10/10] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180418125536.GB3999@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:51AM +0900, Akinobu Mita wrote:
> The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> and the s_frame_interval() in subdev video ops could be called when the
> device is under power saving mode.  These callbacks for ov772x driver
> cause updating H/W registers that will fail under power saving mode.
>

I might be wrong, but if the sensor is powered off, you should not
receive any subdev_pad_ops function call if sensor is powered off.

For this driver that's up to the platform driver to handle this
correctly, have you found any case where it is necessary to handle
this in the sensor driver? Have I mis-interpreted the use case of this
patch?


> This avoids it by not apply any changes to H/W if the device is not powered
> up.  Instead the changes will be restored right after power-up.
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
>  drivers/media/i2c/ov772x.c | 77 +++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 62 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 1297a21..c44728f 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -741,19 +741,29 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
>  	struct ov772x_priv *priv = to_ov772x(sd);
>  	struct v4l2_fract *tpf = &ival->interval;
>  	unsigned int fps;
> -	int ret;
> +	int ret = 0;
>
>  	fps = ov772x_select_fps(priv, tpf);
>
> -	ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> -	if (ret)
> -		return ret;
> +	mutex_lock(&priv->power_lock);
> +	/*
> +	 * If the device is not powered up by the host driver do
> +	 * not apply any changes to H/W at this time. Instead
> +	 * the frame rate will be restored right after power-up.
> +	 */
> +	if (priv->power_count > 0) {
> +		ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> +		if (ret)
> +			goto error;
> +	}
>
>  	tpf->numerator = 1;
>  	tpf->denominator = fps;
>  	priv->fps = fps;
> +error:
> +	mutex_unlock(&priv->power_lock);
>
> -	return 0;
> +	return ret;
>  }
>
>  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -765,6 +775,16 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>  	int ret = 0;
>  	u8 val;
>
> +	/* v4l2_ctrl_lock() locks our own mutex */
> +
> +	/*
> +	 * If the device is not powered up by the host driver do
> +	 * not apply any controls to H/W at this time. Instead
> +	 * the controls will be restored right after power-up.
> +	 */
> +	if (priv->power_count == 0)
> +		return 0;
> +
>  	switch (ctrl->id) {
>  	case V4L2_CID_VFLIP:
>  		val = ctrl->val ? VFLIP_IMG : 0x00;
> @@ -888,6 +908,10 @@ static int ov772x_power_off(struct ov772x_priv *priv)
>  	return 0;
>  }
>
> +static int ov772x_set_params(struct ov772x_priv *priv,
> +			     const struct ov772x_color_format *cfmt,
> +			     const struct ov772x_win_size *win);
> +
>  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>  {
>  	struct ov772x_priv *priv = to_ov772x(sd);
> @@ -898,8 +922,20 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
>  	 * update the power state.
>  	 */
> -	if (priv->power_count == !on)
> -		ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
> +	if (priv->power_count == !on) {
> +		if (on) {
> +			ret = ov772x_power_on(priv);
> +			/* Restore the controls */
> +			if (!ret)
> +				ret = ov772x_set_params(priv, priv->cfmt,
> +							priv->win);
> +			/* Restore the format and the frame rate */
> +			if (!ret)
> +				ret = __v4l2_ctrl_handler_setup(&priv->hdl);

frame interval is not listed in the sensor control list, it won't be
restored if I'm not wrong...

Thanks
   j

> +		} else {
> +			ret = ov772x_power_off(priv);
> +		}
> +	}
>
>  	if (!ret) {
>  		/* Update the power count. */
> @@ -1163,7 +1199,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	const struct ov772x_color_format *cfmt;
>  	const struct ov772x_win_size *win;
> -	int ret;
> +	int ret = 0;
>
>  	if (format->pad)
>  		return -EINVAL;
> @@ -1184,14 +1220,23 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  		return 0;
>  	}
>
> -	ret = ov772x_set_params(priv, cfmt, win);
> -	if (ret < 0)
> -		return ret;
> -
> +	mutex_lock(&priv->power_lock);
> +	/*
> +	 * If the device is not powered up by the host driver do
> +	 * not apply any changes to H/W at this time. Instead
> +	 * the format will be restored right after power-up.
> +	 */
> +	if (priv->power_count > 0) {
> +		ret = ov772x_set_params(priv, cfmt, win);
> +		if (ret < 0)
> +			goto error;
> +	}
>  	priv->win = win;
>  	priv->cfmt = cfmt;
> +error:
> +	mutex_unlock(&priv->power_lock);
>
> -	return 0;
> +	return ret;
>  }
>
>  static int ov772x_video_probe(struct ov772x_priv *priv)
> @@ -1201,7 +1246,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  	const char         *devname;
>  	int		    ret;
>
> -	ret = ov772x_s_power(&priv->subdev, 1);
> +	ret = ov772x_power_on(priv);
>  	if (ret < 0)
>  		return ret;
>
> @@ -1241,7 +1286,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  	ret = v4l2_ctrl_handler_setup(&priv->hdl);
>
>  done:
> -	ov772x_s_power(&priv->subdev, 0);
> +	ov772x_power_off(priv);
>
>  	return ret;
>  }
> @@ -1341,6 +1386,8 @@ static int ov772x_probe(struct i2c_client *client,
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
> +	/* Use our mutex for the controls */
> +	priv->hdl.lock = &priv->power_lock;
>  	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>  			  V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> --
> 2.7.4
>

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa10BIAAoJEHI0Bo8WoVY8dCEP/0qnLy0VuhL7kQf5a/APkVTV
Cfc1P4hL2ayIvinIkovRZQM8a/E7SPy1IkMaErTkVUWe1iLILgzzTiyGqYryqXQk
mRnxG9zioVI8DivNOO23HLpthVJ5YFJFQ/7tnZ+07tF3umkM7S8OprVJBcb750JA
Ap9GGb5dq+qNryaV/IaKt+3IKuICQ8OfeXgnSSYsDWPM6zg6tGegb1395MxJY5b5
gup5xeKG2jlFRzteY1pgkt/WCfopw4yPzYQP7pBGPZgTYZod44QZgNEt0kFGQN/W
DgHHxl/MT+2TLNrsTtpyMTSwNAxYQY+4VQgOvnUFEG4FF/rYhmCvEMCG1wWgPmrI
MsX7/kdloIOCzc/wRV1JjQnqYvWXzoettAlkBGwUXi2zg/fMxCUxuEBkaSmq4irL
cLpwEbVA08tBVQCLsBcElAy3K6+GQSpEJaNtuYPSUc6sEfaltI9ChCK/jv+2IWTp
H8j/OqV1r53mCtITe1r5PPb2MpoypNcuvN9ardG7TBsCRDpUlLMLkylQbnS7DK/A
rgfUM4dvJ+5KnX5nyQecG3a9/x67fvhfa4lx0r2GUBVbTeFU5cDrapppEXjSIFy3
xADkOcybNmtwQXEmm9uHsAiGLuIa5jTmYxMz38yC1PgiIvVk/dZt14SVpVfICQcP
fnELtyaGExq1lRyruQp4
=4IJk
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
