Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:45343 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752079AbeENJKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 05:10:32 -0400
Date: Mon, 14 May 2018 11:10:27 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 13/14] media: ov772x: make set_fmt() and
 s_frame_interval() return -EBUSY while streaming
Message-ID: <20180514091027.GE5956@w540>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-14-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
Content-Disposition: inline
In-Reply-To: <1525616369-8843-14-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,
   thanks for the patch

On Sun, May 06, 2018 at 11:19:28PM +0900, Akinobu Mita wrote:
> The ov772x driver is going to offer a V4L2 sub-device interface, so
> changing the output data format and the frame interval on this sub-device
> can be made anytime.  However, these requests are preferred to fail while
> the video stream on the device is active.
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
> * v5:
> - Make s_frame_interval() return -EBUSY while streaming
>
>  drivers/media/i2c/ov772x.c | 43 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 262a7e5..4b479f9 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -424,9 +424,10 @@ struct ov772x_priv {
>  	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>  	struct v4l2_ctrl		 *band_filter_ctrl;
>  	unsigned int			  fps;
> -	/* lock to protect power_count */
> +	/* lock to protect power_count and streaming */
>  	struct mutex			  lock;
>  	int				  power_count;
> +	int				  streaming;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_pad pad;
>  #endif
> @@ -603,18 +604,28 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(sd);
> +	int ret = 0;
>
> -	if (!enable) {
> -		ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, SOFT_SLEEP_MODE);
> -		return 0;
> -	}
> +	mutex_lock(&priv->lock);
>
> -	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
> +	if (priv->streaming == enable)
> +		goto done;
>
> -	dev_dbg(&client->dev, "format %d, win %s\n",
> -		priv->cfmt->code, priv->win->name);
> +	ret = ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE,
> +			      enable ? 0 : SOFT_SLEEP_MODE);
> +	if (ret)
> +		goto done;
>
> -	return 0;
> +	if (enable) {
> +		dev_dbg(&client->dev, "format %d, win %s\n",
> +			priv->cfmt->code, priv->win->name);
> +	}
> +	priv->streaming = enable;
> +
> +done:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
>  }
>
>  static unsigned int ov772x_select_fps(struct ov772x_priv *priv,
> @@ -743,9 +754,15 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
>  	unsigned int fps;
>  	int ret = 0;
>
> +	mutex_lock(&priv->lock);
> +
> +	if (priv->streaming) {
> +		ret = -EBUSY;
> +		goto error;
> +	}
> +
>  	fps = ov772x_select_fps(priv, tpf);
>
> -	mutex_lock(&priv->lock);
>  	/*
>  	 * If the device is not powered up by the host driver do
>  	 * not apply any changes to H/W at this time. Instead
> @@ -1222,6 +1239,12 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  	}
>
>  	mutex_lock(&priv->lock);
> +
> +	if (priv->streaming) {
> +		ret = -EBUSY;
> +		goto error;
> +	}
> +
>  	/*
>  	 * If the device is not powered up by the host driver do
>  	 * not apply any changes to H/W at this time. Instead
> --
> 2.7.4
>

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+VKDAAoJEHI0Bo8WoVY8lOcQAKShBrFmwoTBBJCShMCcQ1Ql
nd9Fs3b7ZmjOUJSDJ3h5Q5xHcehQU9OFxFWJ2p5QR4o0IAn+CvFNt8SNkHmZPF5a
zUvg9RSy4EPnWNGJHNrp3vfBMb4JvZZBvt/IMunXwmL9gA49SyXcWTezAxFIfmtq
szu6XuyJ4DdC7DGZx0GMVrnj9ay8NP3BQPVtw23eXaGiwfwUnqf++7/mHqGq35H8
H3jI+EwZdFOFliQgwja7iJVnOTGcD8gi7Ea51c685iErBBS34ugNlUG0nYIbCTkc
dfAkIQcdf8zJFlvJ0zaWpBEGlaLp7hSBl54qGRMh4cmoubNSPnQB6S2lUavfFHNW
qtW7si/jTyJ02L6tvWFiwrR8DpH+bIFaj2zIkJpi36do4ZZ7o9hJzGTh5yFtaBUO
2L+a2021xAo1Loaf8DvTA19RLKd9Rq0Dqxqv1NBZbhi5swr9ZuV8hz5hZL5CtBq3
Rbk+o5M6+K+kAQ7Gxjjcv6oVp3dozKj2WmFyJOH+nOlZJjhOqAjyX7OXWRvIiJMo
YB5mgQ/ivE2EsecvfmqKYBCKp2aiLfP+772tXYZmFsAT4mDrIY5U0dRUOK+8zjRS
eNZLZZt0jWUGGwxB31hM0HSJPosuVzHEJqWZKa3LwbpSN3VJ0aSKudEw3/jbjgJJ
HGCmz68PvxinQlhjgJuJ
=Tx1l
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
