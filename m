Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47649 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbeENJGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 05:06:51 -0400
Date: Mon, 14 May 2018 11:06:46 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 12/14] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180514090646.GD5956@w540>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-13-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <1525616369-8843-13-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

   a small nit below

On Sun, May 06, 2018 at 11:19:27PM +0900, Akinobu Mita wrote:
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
> * v5
> - No changes
>
>  drivers/media/i2c/ov772x.c | 79 +++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 64 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 9292a18..262a7e5 100644
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

Isn't this unrelated?

Apart from that,

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
  j


>  	priv->vflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>  					     V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	priv->hflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> --
> 2.7.4
>

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+VGmAAoJEHI0Bo8WoVY8oJEQAKcboDX1rRBSkzZOuud7gHlC
BodHQSJRTAVVSMPm1sjHXfvSOMnr+yepZ38ToXtvZg8Klqtullt574N7LAvH6Moh
4V42f8z33oJaAiyXTunb3ciw9a4PvSDNi/cWBKCswEx5nmAgYVuEd+0Q9tK9Bbw/
pLga4Er9Ydy0Y9dSMhfp/AKKccHz56SXHMrWWZQBRSVh4PFAX8sD5Vh9fXJjHTrL
T7sBxmzaadRRjmeGbIR+SeMrD8O+UW76vXSLjHi2DtHPM5u3rBFIPnH4mLMO/PxB
DV4Dyz1kGcMT13z5Rvs0qfiznv6ssWY7rIKCm95P/MeTH1DXp/P+sYvEnLk7tZ9J
bYWUgLasslambCdbw4ZGQ+Omk6FDMdP1KQnPgVVMNhO4HZFaTfw0mvIxD0Jollcb
GtfG1Q28gWthcsWIgmNXNqV2xOTCt3cBi4y2cOQ0weL68334xlbuKSWfpcquFTbw
FyqNPCKqUlHp5ZW6WKac3tO7ZJlJppbkxSLq8wQxunsdfvBuv8jZuy1xk66AuRmJ
PgHtuz5y7LOD+ztNhwMKajzRZzHlyTxFqDZyrss3SaAoUlQA9qOVKYMI0EegUhXn
oItLCI2Um51g/l2AKoEGqao2eXPQALwZtG5T95Dd6yO+yPUJKymaugGH277pa4hp
mfRyHqA2goaY/sK+DrQc
=zzUZ
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
