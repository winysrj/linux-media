Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:44531 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbeENKDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 06:03:24 -0400
Date: Mon, 14 May 2018 12:03:17 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 12/14] media: ov772x: avoid accessing registers under
 power saving mode
Message-ID: <20180514100317.GH5956@w540>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-13-git-send-email-akinobu.mita@gmail.com>
 <20180514090646.GD5956@w540>
 <20180514094918.2xot5l2frkckfequ@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9s922KAXlWjPfK/Q"
Content-Disposition: inline
In-Reply-To: <20180514094918.2xot5l2frkckfequ@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9s922KAXlWjPfK/Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
   thanks for the clarification, please ignore my comment then.

Thanks
   j

On Mon, May 14, 2018 at 12:49:19PM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Mon, May 14, 2018 at 11:06:46AM +0200, jacopo mondi wrote:
> > Hi Akinobu,
> >
> >    a small nit below
> >
> > On Sun, May 06, 2018 at 11:19:27PM +0900, Akinobu Mita wrote:
> > > The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
> > > and the s_frame_interval() in subdev video ops could be called when the
> > > device is under power saving mode.  These callbacks for ov772x driver
> > > cause updating H/W registers that will fail under power saving mode.
> > >
> > > This avoids it by not apply any changes to H/W if the device is not powered
> > > up.  Instead the changes will be restored right after power-up.
> > >
> > > Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > > * v5
> > > - No changes
> > >
> > >  drivers/media/i2c/ov772x.c | 79 +++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 64 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> > > index 9292a18..262a7e5 100644
> > > --- a/drivers/media/i2c/ov772x.c
> > > +++ b/drivers/media/i2c/ov772x.c
> > > @@ -741,19 +741,30 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
> > >  	struct ov772x_priv *priv = to_ov772x(sd);
> > >  	struct v4l2_fract *tpf = &ival->interval;
> > >  	unsigned int fps;
> > > -	int ret;
> > > +	int ret = 0;
> > >
> > >  	fps = ov772x_select_fps(priv, tpf);
> > >
> > > -	ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> > > -	if (ret)
> > > -		return ret;
> > > +	mutex_lock(&priv->lock);
> > > +	/*
> > > +	 * If the device is not powered up by the host driver do
> > > +	 * not apply any changes to H/W at this time. Instead
> > > +	 * the frame rate will be restored right after power-up.
> > > +	 */
> > > +	if (priv->power_count > 0) {
> > > +		ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
> > > +		if (ret)
> > > +			goto error;
> > > +	}
> > >
> > >  	tpf->numerator = 1;
> > >  	tpf->denominator = fps;
> > >  	priv->fps = fps;
> > >
> > > -	return 0;
> > > +error:
> > > +	mutex_unlock(&priv->lock);
> > > +
> > > +	return ret;
> > >  }
> > >
> > >  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> > > @@ -765,6 +776,16 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> > >  	int ret = 0;
> > >  	u8 val;
> > >
> > > +	/* v4l2_ctrl_lock() locks our own mutex */
> > > +
> > > +	/*
> > > +	 * If the device is not powered up by the host driver do
> > > +	 * not apply any controls to H/W at this time. Instead
> > > +	 * the controls will be restored right after power-up.
> > > +	 */
> > > +	if (priv->power_count == 0)
> > > +		return 0;
> > > +
> > >  	switch (ctrl->id) {
> > >  	case V4L2_CID_VFLIP:
> > >  		val = ctrl->val ? VFLIP_IMG : 0x00;
> > > @@ -885,6 +906,10 @@ static int ov772x_power_off(struct ov772x_priv *priv)
> > >  	return 0;
> > >  }
> > >
> > > +static int ov772x_set_params(struct ov772x_priv *priv,
> > > +			     const struct ov772x_color_format *cfmt,
> > > +			     const struct ov772x_win_size *win);
> > > +
> > >  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
> > >  {
> > >  	struct ov772x_priv *priv = to_ov772x(sd);
> > > @@ -895,8 +920,20 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
> > >  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> > >  	 * update the power state.
> > >  	 */
> > > -	if (priv->power_count == !on)
> > > -		ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
> > > +	if (priv->power_count == !on) {
> > > +		if (on) {
> > > +			ret = ov772x_power_on(priv);
> > > +			/*
> > > +			 * Restore the format, the frame rate, and
> > > +			 * the controls
> > > +			 */
> > > +			if (!ret)
> > > +				ret = ov772x_set_params(priv, priv->cfmt,
> > > +							priv->win);
> > > +		} else {
> > > +			ret = ov772x_power_off(priv);
> > > +		}
> > > +	}
> > >
> > >  	if (!ret) {
> > >  		/* Update the power count. */
> > > @@ -1163,7 +1200,7 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
> > >  	struct v4l2_mbus_framefmt *mf = &format->format;
> > >  	const struct ov772x_color_format *cfmt;
> > >  	const struct ov772x_win_size *win;
> > > -	int ret;
> > > +	int ret = 0;
> > >
> > >  	if (format->pad)
> > >  		return -EINVAL;
> > > @@ -1184,14 +1221,24 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
> > >  		return 0;
> > >  	}
> > >
> > > -	ret = ov772x_set_params(priv, cfmt, win);
> > > -	if (ret < 0)
> > > -		return ret;
> > > -
> > > +	mutex_lock(&priv->lock);
> > > +	/*
> > > +	 * If the device is not powered up by the host driver do
> > > +	 * not apply any changes to H/W at this time. Instead
> > > +	 * the format will be restored right after power-up.
> > > +	 */
> > > +	if (priv->power_count > 0) {
> > > +		ret = ov772x_set_params(priv, cfmt, win);
> > > +		if (ret < 0)
> > > +			goto error;
> > > +	}
> > >  	priv->win = win;
> > >  	priv->cfmt = cfmt;
> > >
> > > -	return 0;
> > > +error:
> > > +	mutex_unlock(&priv->lock);
> > > +
> > > +	return ret;
> > >  }
> > >
> > >  static int ov772x_video_probe(struct ov772x_priv *priv)
> > > @@ -1201,7 +1248,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
> > >  	const char         *devname;
> > >  	int		    ret;
> > >
> > > -	ret = ov772x_s_power(&priv->subdev, 1);
> > > +	ret = ov772x_power_on(priv);
> > >  	if (ret < 0)
> > >  		return ret;
> > >
> > > @@ -1241,7 +1288,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
> > >  	ret = v4l2_ctrl_handler_setup(&priv->hdl);
> > >
> > >  done:
> > > -	ov772x_s_power(&priv->subdev, 0);
> > > +	ov772x_power_off(priv);
> > >
> > >  	return ret;
> > >  }
> > > @@ -1340,6 +1387,8 @@ static int ov772x_probe(struct i2c_client *client,
> > >
> > >  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
> > >  	v4l2_ctrl_handler_init(&priv->hdl, 3);
> > > +	/* Use our mutex for the controls */
> > > +	priv->hdl.lock = &priv->lock;
> >
> > Isn't this unrelated?
>
> AFAICT not, since the access to power count is serialised using the
> driver's mutex. The power count is used in the s_ctrl callback as well.
>
> >
> > Apart from that,
> >
> > Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >
> > Thanks
> >   j
> >
> >
> > >  	priv->vflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> > >  					     V4L2_CID_VFLIP, 0, 1, 1, 0);
> > >  	priv->hflip_ctrl = v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
> > > --
> > > 2.7.4
> > >
>
>
>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com

--9s922KAXlWjPfK/Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+V7lAAoJEHI0Bo8WoVY82UwP/0A5/KvZwFHMoZySjUQIkku1
QKyUW1Ee4v04zQmM2PTuu2o1an39GsgsAdvB/i8qHK6BhiMFIvwYnW+EmCjT+emO
tdbUqIAtP3osGC5u/iukbzTU7ppUsnopfHQjSC8CcTEWzGJ2chDmYT1KKpvTRQUX
1ZO20SrTHA/PQtZcmSbZwPLVAX1Washxas7IKEEPaxyeKHsd7JJJmuMMIkFR1L7k
vP2rxvdgzyCLx9fR5buLd8SHIWJN5qIojM0dMzibsZzpqCKfpK8sDJY5xp+fAcq+
WQbJEAH65+qDwNMcBvdzZ5Bccv6v+Z4PJsPGaxbq0zGE9+nMZFxrd0Q8t0glS0Qs
orOILa7xuA9EuWo/6MOPqrK+UIHv4nzLgLvFEO0WRj1IDh5crhZ1G19EcPeqoruk
Ccd2uY+gx4eFY//2W/3vKOxdFM9EkY1x9hhX1cAhWHt9KS2DOR9rTH2Nm5bmw4fF
7vnSxqpli+AVA4ZNOxJ/IgkYgOExlkRNQC8ot3YZA4ORyBzcE2ndgwOhmCoRRjlX
vy7X8uVv9PpB8lhUYN7ZeuSB9vJES4/IjrUu6vuS+s+UK0mOIL9tuB1cNdxNj1p/
+IyMOu9BqrY78+lCXnAzAB5XjD4KfBa3liEQN2mvcHpyZJtDzfRaRlOzGFdbyn/r
PmrqFHe617/Pmb5tu6ik
=EGmj
-----END PGP SIGNATURE-----

--9s922KAXlWjPfK/Q--
