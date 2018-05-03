Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:51875 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeECVDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 17:03:40 -0400
Date: Thu, 3 May 2018 23:03:33 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 12/14] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180503210333.GF19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-13-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5CUMAwwhRxlRszMD"
Content-Disposition: inline
In-Reply-To: <1525021993-17789-13-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5CUMAwwhRxlRszMD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,
  let me see if I got this right...

On Mon, Apr 30, 2018 at 02:13:11AM +0900, Akinobu Mita wrote:
> The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> and the s_frame_interval() in subdev video ops could be called when the
> device is under power saving mode.  These callbacks for ov772x driver
> cause updating H/W registers that will fail under power saving mode.
>
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
> * v4
> - No changes
>
>  drivers/media/i2c/ov772x.c | 79 +++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 64 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 3e6ca98..bd37169 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -741,19 +741,30 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
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
> +	mutex_lock(&priv->lock);
> +	/*
> +	 * If the device is not powered up by the host driver do
> +	 * not apply any changes to H/W at this time. Instead
> +	 * the frame rate will be restored right after power-up.
> +	 */
> +	if (priv->power_count > 0) {

If I'm not wrong this is not protected when the device is
streaming.

Since Hans' series frame control is called by g/s_parm (until a new
ioctl is not introduced) and I've looked at the call stack and it
seems to me it does not check for active streaming[1]. I -think-
this is even worse when this is called on the subdev, as there is
no shared notion of active streaming. Am I wrong?

If you have to check for active streaming here (I see some other
drivers doing that, eg ov5640), then I see two ways, or you just
return -EBUSY, or you save the desired FPS for later, but then it gets
messy as you won't be able to just restore paramters at power_on()
time, but you would need to do that also at start streaming time.

My opinion is that you should check for streaming active (as you're
doing for the set_fmt() function in [13/14], do you agree?

[1] This calls for a device wise 'streaming' state handler. Maybe it's
there but I failed to find checks for that.

> +		ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> +		if (ret)
> +			goto error;
> +	}
>
>  	tpf->numerator = 1;
>  	tpf->denominator = fps;
>  	priv->fps = fps;
>
> -	return 0;
> +error:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
>  }
>
>  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -765,6 +776,16 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
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
> @@ -885,6 +906,10 @@ static int ov772x_power_off(struct ov772x_priv *priv)
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
> @@ -895,8 +920,20 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
>  	 * update the power state.
>  	 */
> -	if (priv->power_count == !on)
> -		ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
> +	if (priv->power_count == !on) {
> +		if (on) {
> +			ret = ov772x_power_on(priv);
> +			/*
> +			 * Restore the format, the frame rate, and
> +			 * the controls
> +			 */
> +			if (!ret)
> +				ret = ov772x_set_params(priv, priv->cfmt,
> +							priv->win);
> +		} else {
> +			ret = ov772x_power_off(priv);
> +		}
> +	}
>
>  	if (!ret) {
>  		/* Update the power count. */
> @@ -1163,7 +1200,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  	struct v4l2_mbus_framefmt *mf = &format->format;
>  	const struct ov772x_color_format *cfmt;
>  	const struct ov772x_win_size *win;
> -	int ret;
> +	int ret = 0;
>
>  	if (format->pad)
>  		return -EINVAL;
> @@ -1184,14 +1221,24 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  		return 0;
>  	}
>
> -	ret = ov772x_set_params(priv, cfmt, win);
> -	if (ret < 0)
> -		return ret;
> -
> +	mutex_lock(&priv->lock);
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
>
> -	return 0;
> +error:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
>  }
>
>  static int ov772x_video_probe(struct ov772x_priv *priv)
> @@ -1201,7 +1248,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  	const char         *devname;
>  	int		    ret;
>
> -	ret = ov772x_s_power(&priv->subdev, 1);
> +	ret = ov772x_power_on(priv);
>  	if (ret < 0)
>  		return ret;
>
> @@ -1241,7 +1288,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
>  	ret = v4l2_ctrl_handler_setup(&priv->hdl);
>
>  done:
> -	ov772x_s_power(&priv->subdev, 0);
> +	ov772x_power_off(priv);
>
>  	return ret;
>  }
> @@ -1340,6 +1387,8 @@ static int ov772x_probe(struct i2c_client *client,
>
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
> +	/* Use our mutex for the controls */
> +	priv->hdl.lock = &priv->lock;

This is unrelated and should probably go in the previous patch (which
I would move before the one where you split s_frame_interval up, for
clearness)

Thanks
   j

>  	priv->vflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>  					     V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	priv->hflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> --
> 2.7.4
>

--5CUMAwwhRxlRszMD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa63klAAoJEHI0Bo8WoVY8P44P/iYQR8B0IZM3S5ES5YUTlkaQ
U6qMoKrO8lzesLCE/2PKAvXu0O+PJXU2PKLUtkt/9yY+QcZnbaeNqBPESl78eTnv
oKKltDE27nEFykahBvapE8yz5JC5Kyj5zxmxnSMw5CTatLv22MkBOd2eBLNexUzH
pfvAtRKbIWjZX69gN5kf6sXM701sNDL4l0KN26McZrh+SrRKDs/FeNnbEighojDC
FxjOYlpGqWT/VYd2yftVhgFje2pOTrAmxoawNBAXIDWn9j/iVUOPNU7tz6DMe0u1
KB/aiW9ernBVqYMHYsrRSywyPCf+WAJR3GMrgCuOCz2b50vLcC32+fzYnDqa7BfU
pDyBDmMomy4L3hkUUH4mcTb8igAI04GFLSdfgjbVTj7h8PlE8JmfcsIvxXZntPdG
LJltBzgx1dIpCH45JKn8jH0E55cz2YYfTzphFbuOzI4CfA4gcgDkU86vhhANQw7L
s2qbYYb3KDh+6akC7aNXBbiWmJZposkWP0A9RvekiLoh+8bMf3KoYv8ae+/oqvb1
zSX/e5DAum9U8rDvYOLhATFrUl5plkl5l3kamBfnrmdZA6UrF+8AP8eOrk8aiztP
jNbi86NSrSB7AkHgT5C5vXyKth0ULhBYZQv6amOt0GZuvH98B3xEmFmWjmsn493K
x/DR41+nRWVoXXAyb7ll
=NWgu
-----END PGP SIGNATURE-----

--5CUMAwwhRxlRszMD--
