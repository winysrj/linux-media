Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49624 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754471AbeBUPQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:16:53 -0500
Date: Wed, 21 Feb 2018 16:16:44 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 07/11] media: i2c: ov772x: Support frame interval
 handling
Message-ID: <20180221151644.GI7203@w540>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519059584-30844-8-git-send-email-jacopo+renesas@jmondi.org>
 <f154f229-6977-4d3e-38b9-6d1669adbf91@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f154f229-6977-4d3e-38b9-6d1669adbf91@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Feb 21, 2018 at 01:12:14PM +0100, Hans Verkuil wrote:

[snip]

> > +static int ov772x_g_frame_interval(struct v4l2_subdev *sd,
> > +				   struct v4l2_subdev_frame_interval *ival)
> > +{
> > +	struct ov772x_priv *priv = to_ov772x(sd);
> > +	struct v4l2_fract *tpf = &ival->interval;
> > +
> > +	memset(ival->reserved, 0, sizeof(ival->reserved));
>
> This memset...
>
> > +	tpf->numerator = 1;
> > +	tpf->denominator = priv->fps;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
> > +				   struct v4l2_subdev_frame_interval *ival)
> > +{
> > +	struct ov772x_priv *priv = to_ov772x(sd);
> > +	struct v4l2_fract *tpf = &ival->interval;
> > +
> > +	memset(ival->reserved, 0, sizeof(ival->reserved));
>
> ... and this memset can be dropped. The core code will memset this for you.
>
>

I see! Ok, I'll drop them in v10

> > +
> > +	return ov772x_set_frame_rate(priv, tpf, priv->cfmt, priv->win);
> > +}
> > +
> >  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
> >  {
> >  	struct ov772x_priv *priv = container_of(ctrl->handler,
> > @@ -757,6 +905,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
> >  			     const struct ov772x_win_size *win)
> >  {
> >  	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> > +	struct v4l2_fract tpf;
> >  	int ret;
> >  	u8  val;
> >
> > @@ -885,6 +1034,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
> >  	if (ret < 0)
> >  		goto ov772x_set_fmt_error;
> >
> > +	/* COM4, CLKRC: Set pixel clock and framerate. */
> > +	tpf.numerator = 1;
> > +	tpf.denominator = priv->fps;
> > +	ret = ov772x_set_frame_rate(priv, &tpf, cfmt, win);
> > +	if (ret < 0)
> > +		goto ov772x_set_fmt_error;
> > +
> >  	/*
> >  	 * set COM8
> >  	 */
> > @@ -1043,6 +1199,24 @@ static const struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
> >  	.s_power	= ov772x_s_power,
> >  };
> >
> > +static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
> > +				      struct v4l2_subdev_pad_config *cfg,
> > +				      struct v4l2_subdev_frame_interval_enum *fie)
> > +{
> > +	if (fie->pad || fie->index >= OV772X_N_FRAME_INTERVALS)
> > +		return -EINVAL;
> > +
> > +	if (fie->width != VGA_WIDTH && fie->width != QVGA_WIDTH)
> > +		return -EINVAL;
> > +	if (fie->height != VGA_HEIGHT && fie->height != QVGA_HEIGHT)
> > +		return -EINVAL;
> > +
> > +	fie->interval.numerator = 1;
> > +	fie->interval.denominator = ov772x_frame_intervals[fie->index];
> > +
> > +	return 0;
> > +}
> > +
> >  static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
> >  		struct v4l2_subdev_pad_config *cfg,
> >  		struct v4l2_subdev_mbus_code_enum *code)
> > @@ -1055,14 +1229,17 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
> >  }
> >
> >  static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
> > -	.s_stream	= ov772x_s_stream,
> > +	.s_stream		= ov772x_s_stream,
> > +	.s_frame_interval	= ov772x_s_frame_interval,
> > +	.g_frame_interval	= ov772x_g_frame_interval,
> >  };
> >
> >  static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
> > -	.enum_mbus_code = ov772x_enum_mbus_code,
> > -	.get_selection	= ov772x_get_selection,
> > -	.get_fmt	= ov772x_get_fmt,
> > -	.set_fmt	= ov772x_set_fmt,
> > +	.enum_frame_interval	= ov772x_enum_frame_interval,
> > +	.enum_mbus_code		= ov772x_enum_mbus_code,
> > +	.get_selection		= ov772x_get_selection,
> > +	.get_fmt		= ov772x_get_fmt,
> > +	.set_fmt		= ov772x_set_fmt,
>
> Shouldn't these last four ops be added in the previous patch?
> They don't have anything to do with the frame interval support.
>

If you look closely you'll notice I have just re-aligned them, since I
was at there to add enum_frame_interval operation

> Anyway, after taking care of the memsets and these four ops you can add
> my:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks
   j
