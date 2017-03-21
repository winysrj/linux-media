Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35451 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756354AbdCUEM1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 00:12:27 -0400
Subject: Re: [PATCH v5 38/39] media: imx: csi: fix crop rectangle reset in
 sink set_fmt
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-39-git-send-email-steve_longerbeam@mentor.com>
 <20170319152233.GW21222@n2100.armlinux.org.uk>
 <327d67d9-68c1-7f74-0c0f-f6aee1c4b546@gmail.com>
 <1490010926.2917.59.camel@pengutronix.de>
 <20170320120855.GH21222@n2100.armlinux.org.uk>
 <1490018451.2917.86.camel@pengutronix.de>
 <20170320141705.GL21222@n2100.armlinux.org.uk>
 <1490030604.2917.103.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <2a6ae11b-d0b4-82ca-c6d4-cc82ddbf9f54@gmail.com>
Date: Mon, 20 Mar 2017 21:03:21 -0700
MIME-Version: 1.0
In-Reply-To: <1490030604.2917.103.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/20/2017 10:23 AM, Philipp Zabel wrote:
> Hi Steve, Russell,
>
> On Mon, 2017-03-20 at 14:17 +0000, Russell King - ARM Linux wrote:
>> On Mon, Mar 20, 2017 at 03:00:51PM +0100, Philipp Zabel wrote:
>>> On Mon, 2017-03-20 at 12:08 +0000, Russell King - ARM Linux wrote:
>>>> The same document says:
>>>>
>>>>   Scaling support is optional. When supported by a subdev, the crop
>>>>   rectangle on the subdev's sink pad is scaled to the size configured
>>>>   using the
>>>>   :ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` IOCTL
>>>>   using ``V4L2_SEL_TGT_COMPOSE`` selection target on the same pad. If the
>>>>   subdev supports scaling but not composing, the top and left values are
>>>>   not used and must always be set to zero.
>>>
>>> Right, this sentence does imply that when scaling is supported, there
>>> must be a sink compose rectangle, even when composing is not.
>>>
>>> I have previously set up scaling like this:
>>>
>>> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080@1/60]"
>>> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/960x540@1/30]"
>>>
>>> Does this mean, it should work like this instead?
>>>
>>> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080@1/60]"
>>> media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY2X8/1920x1080@1/60,compose:(0,0)/960x540]"
>>> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/960x540@1/30]"
>>>
>>> I suppose setting the source pad format should not be allowed to modify
>>> the sink compose rectangle.
>>
>> That is what I believe having read these documents several times, but
>> we need v4l2 people to confirm.
>
> What do you think of this:
>
> ----------8<----------
> From 2830aebc404bdfc9d7fc1ec94e5282d0b668e8f6 Mon Sep 17 00:00:00 2001
> From: Philipp Zabel <p.zabel@pengutronix.de>
> Date: Mon, 20 Mar 2017 17:10:21 +0100
> Subject: [PATCH] media: imx: csi: add sink selection rectangles
>
> Move the crop rectangle to the sink pad and add a sink compose rectangle
> to configure scaling. Also propagate rectangles from sink pad to crop
> rectangle, to compose rectangle, and to the source pads both in ACTIVE
> and TRY variants of set_fmt/selection, and initialize the default crop
> and compose rectangles.
>

I haven't had a chance to look at this patch in detail yet, but on
first glance it looks good to me. I'll try to find the time tomorrow
to incorporate it and then fixup Russell's subsequent patches for
the enum frame sizes/intervals.

Steve

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 216 +++++++++++++++++++++---------
>  1 file changed, 152 insertions(+), 64 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 560da3abdd70b..b026a5d602ddf 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -79,6 +79,7 @@ struct csi_priv {
>  	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
>  	struct v4l2_fract frame_interval;
>  	struct v4l2_rect crop;
> +	struct v4l2_rect compose;
>  	const struct csi_skip_desc *skip[CSI_NUM_PADS - 1];
>
>  	/* active vb2 buffers to send to video dev sink */
> @@ -574,8 +575,8 @@ static int csi_setup(struct csi_priv *priv)
>  	ipu_csi_set_window(priv->csi, &priv->crop);
>
>  	ipu_csi_set_downsize(priv->csi,
> -			     priv->crop.width == 2 * outfmt->width,
> -			     priv->crop.height == 2 * outfmt->height);
> +			     priv->crop.width == 2 * priv->compose.width,
> +			     priv->crop.height == 2 * priv->compose.height);
>
>  	ipu_csi_init_interface(priv->csi, &sensor_mbus_cfg, &if_fmt);
>
> @@ -1001,6 +1002,27 @@ __csi_get_fmt(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
>  		return &priv->format_mbus[pad];
>  }
>
> +static struct v4l2_rect *
> +__csi_get_crop(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
> +	       enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_crop(&priv->sd, cfg, CSI_SINK_PAD);
> +	else
> +		return &priv->crop;
> +}
> +
> +static struct v4l2_rect *
> +__csi_get_compose(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
> +		  enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_compose(&priv->sd, cfg,
> +						   CSI_SINK_PAD);
> +	else
> +		return &priv->compose;
> +}
> +
>  static void csi_try_crop(struct csi_priv *priv,
>  			 struct v4l2_rect *crop,
>  			 struct v4l2_subdev_pad_config *cfg,
> @@ -1159,6 +1181,7 @@ static void csi_try_fmt(struct csi_priv *priv,
>  			struct v4l2_subdev_pad_config *cfg,
>  			struct v4l2_subdev_format *sdformat,
>  			struct v4l2_rect *crop,
> +			struct v4l2_rect *compose,
>  			const struct imx_media_pixfmt **cc)
>  {
>  	const struct imx_media_pixfmt *incc;
> @@ -1173,15 +1196,8 @@ static void csi_try_fmt(struct csi_priv *priv,
>  		incc = imx_media_find_mbus_format(infmt->code,
>  						  CS_SEL_ANY, true);
>
> -		if (sdformat->format.width < priv->crop.width * 3 / 4)
> -			sdformat->format.width = priv->crop.width / 2;
> -		else
> -			sdformat->format.width = priv->crop.width;
> -
> -		if (sdformat->format.height < priv->crop.height * 3 / 4)
> -			sdformat->format.height = priv->crop.height / 2;
> -		else
> -			sdformat->format.height = priv->crop.height;
> +		sdformat->format.width = compose->width;
> +		sdformat->format.height = compose->height;
>
>  		if (incc->bayer) {
>  			sdformat->format.code = infmt->code;
> @@ -1217,11 +1233,17 @@ static void csi_try_fmt(struct csi_priv *priv,
>  		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
>  				      W_ALIGN, &sdformat->format.height,
>  				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
> +
> +		/* Reset crop and compose rectangles */
>  		crop->left = 0;
>  		crop->top = 0;
>  		crop->width = sdformat->format.width;
>  		crop->height = sdformat->format.height;
>  		csi_try_crop(priv, crop, cfg, &sdformat->format, sensor);
> +		compose->left = 0;
> +		compose->top = 0;
> +		compose->width = crop->width;
> +		compose->height = crop->height;
>
>  		*cc = imx_media_find_mbus_format(sdformat->format.code,
>  						 CS_SEL_ANY, true);
> @@ -1245,7 +1267,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
>  	const struct imx_media_pixfmt *cc;
>  	struct imx_media_subdev *sensor;
>  	struct v4l2_pix_format vdev_fmt;
> -	struct v4l2_rect crop;
> +	struct v4l2_mbus_framefmt *fmt;
> +	struct v4l2_rect *crop, *compose;
>  	int ret = 0;
>
>  	if (sdformat->pad >= CSI_NUM_PADS)
> @@ -1264,37 +1287,42 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
>  		goto out;
>  	}
>
> -	csi_try_fmt(priv, sensor, cfg, sdformat, &crop, &cc);
> +	crop = __csi_get_crop(priv, cfg, sdformat->which);
> +	compose = __csi_get_compose(priv, cfg, sdformat->which);
>
> -	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> -		cfg->try_fmt = sdformat->format;
> -		goto out;
> -	}
> +	csi_try_fmt(priv, sensor, cfg, sdformat, crop, compose, &cc);
>
> -	priv->format_mbus[sdformat->pad] = sdformat->format;
> -	priv->cc[sdformat->pad] = cc;
> +	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
> +	*fmt = sdformat->format;
>
>  	if (sdformat->pad == CSI_SINK_PAD) {
>  		int pad;
>
> -		/* reset the crop window */
> -		priv->crop = crop;
> -
>  		/* propagate format to source pads */
>  		for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
>  			const struct imx_media_pixfmt *outcc;
>  			struct v4l2_subdev_format format;
> +			struct v4l2_mbus_framefmt *outfmt;
>
>  			format.pad = pad;
> -			format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +			format.which = sdformat->which;
>  			format.format = sdformat->format;
> -			csi_try_fmt(priv, sensor, cfg, &format, &crop, &outcc);
> +			csi_try_fmt(priv, sensor, cfg, &format, NULL, compose,
> +				    &outcc);
>
> -			priv->format_mbus[pad] = format.format;
> -			priv->cc[pad] = outcc;
> +			outfmt = __csi_get_fmt(priv, cfg, pad, sdformat->which);
> +			*outfmt = format.format;
> +
> +			if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +				priv->cc[pad] = outcc;
>  		}
>  	}
>
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
> +		goto out;
> +
> +	priv->cc[sdformat->pad] = cc;
> +
>  	/* propagate IDMAC output pad format to capture device */
>  	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
>  				      &priv->format_mbus[CSI_SRC_PAD_IDMAC],
> @@ -1314,18 +1342,17 @@ static int csi_get_selection(struct v4l2_subdev *sd,
>  {
>  	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>  	struct v4l2_mbus_framefmt *infmt;
> +	struct v4l2_rect *crop, *compose;
>  	int ret = 0;
>
> -	if (sel->pad >= CSI_NUM_PADS || sel->pad == CSI_SINK_PAD)
> +	if (sel->pad != CSI_SINK_PAD)
>  		return -EINVAL;
>
>  	mutex_lock(&priv->lock);
>
>  	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
> -	if (!infmt) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	crop = __csi_get_crop(priv, cfg, sel->which);
> +	compose = __csi_get_compose(priv, cfg, sel->which);
>
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
> @@ -1335,36 +1362,54 @@ static int csi_get_selection(struct v4l2_subdev *sd,
>  		sel->r.height = infmt->height;
>  		break;
>  	case V4L2_SEL_TGT_CROP:
> -		if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> -			struct v4l2_rect *try_crop =
> -				v4l2_subdev_get_try_crop(&priv->sd,
> -							 cfg, sel->pad);
> -			sel->r = *try_crop;
> -		} else {
> -			sel->r = priv->crop;
> -		}
> +		sel->r = *crop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		sel->r.width = crop->width;
> +		sel->r.height = crop->height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		sel->r = *compose;
>  		break;
>  	default:
>  		ret = -EINVAL;
>  	}
>
> -out:
>  	mutex_unlock(&priv->lock);
>  	return ret;
>  }
>
> +static int csi_set_scale(u32 *compose, u32 crop, u32 flags)
> +{
> +	if ((flags & (V4L2_SEL_FLAG_LE | V4L2_SEL_FLAG_GE)) ==
> +		     (V4L2_SEL_FLAG_LE | V4L2_SEL_FLAG_GE) &&
> +	    *compose != crop && *compose != crop / 2)
> +		return -ERANGE;
> +
> +	if (*compose <= crop / 2 ||
> +	    (*compose < crop * 3 / 4 && !(flags & V4L2_SEL_FLAG_GE)) ||
> +	    (*compose < crop && (flags & V4L2_SEL_FLAG_LE)))
> +		*compose = crop / 2;
> +	else
> +		*compose = crop;
> +
> +	return 0;
> +}
> +
>  static int csi_set_selection(struct v4l2_subdev *sd,
>  			     struct v4l2_subdev_pad_config *cfg,
>  			     struct v4l2_subdev_selection *sel)
>  {
>  	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>  	struct v4l2_mbus_framefmt *infmt;
> +	struct v4l2_rect *crop, *compose;
>  	struct imx_media_subdev *sensor;
> +	int pad;
>  	int ret = 0;
>
> -	if (sel->pad >= CSI_NUM_PADS ||
> -	    sel->pad == CSI_SINK_PAD ||
> -	    sel->target != V4L2_SEL_TGT_CROP)
> +	if (sel->pad != CSI_SINK_PAD)
>  		return -EINVAL;
>
>  	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
> @@ -1380,31 +1425,68 @@ static int csi_set_selection(struct v4l2_subdev *sd,
>  		goto out;
>  	}
>
> -	/*
> -	 * Modifying the crop rectangle always changes the format on the source
> -	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
> -	 * rectangle.
> -	 */
> -	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
> -		sel->r = priv->crop;
> -		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
> -			cfg->try_crop = sel->r;
> +	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
> +	crop = __csi_get_crop(priv, cfg, sel->which);
> +	compose = __csi_get_compose(priv, cfg, sel->which);
> +
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		/*
> +		 * Modifying the crop rectangle always changes the format on
> +		 * the source pads. If the KEEP_CONFIG flag is set, just return
> +		 * the current crop rectangle.
> +		 */
> +		if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
> +			sel->r = priv->crop;
> +			if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
> +				*crop = sel->r;
> +			goto out;
> +		}
> +
> +		csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
> +
> +		*crop = sel->r;
> +
> +		/* Reset scaling to 1:1 */
> +		compose->width = crop->width;
> +		compose->height = crop->height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		/*
> +		 * Modifying the compose rectangle always changes the format on
> +		 * the source pads. If the KEEP_CONFIG flag is set, just return
> +		 * the current compose rectangle.
> +		 */
> +		if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
> +			sel->r = priv->compose;
> +			if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
> +				*compose = sel->r;
> +			goto out;
> +		}
> +
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		ret = csi_set_scale(&sel->r.width, crop->width, sel->flags);
> +		if (ret)
> +			goto out;
> +		ret = csi_set_scale(&sel->r.height, crop->height, sel->flags);
> +		if (ret)
> +			goto out;
> +
> +		*compose = sel->r;
> +		break;
> +	default:
> +		ret = -EINVAL;
>  		goto out;
>  	}
>
> -	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
> -	csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
> -
> -	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> -		cfg->try_crop = sel->r;
> -	} else {
> -		struct v4l2_mbus_framefmt *outfmt =
> -			&priv->format_mbus[sel->pad];
> +	/* Reset source pads to sink compose rectangle */
> +	for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
> +		struct v4l2_mbus_framefmt *outfmt;
>
> -		priv->crop = sel->r;
> -		/* Update the source format */
> -		outfmt->width = sel->r.width;
> -		outfmt->height = sel->r.height;
> +		outfmt = __csi_get_fmt(priv, cfg, pad, sel->which);
> +		outfmt->width = compose->width;
> +		outfmt->height = compose->height;
>  	}
>
>  out:
> @@ -1467,6 +1549,12 @@ static int csi_registered(struct v4l2_subdev *sd)
>  			priv->skip[i - 1] = &csi_skip[0];
>  	}
>
> +	/* init default crop and compose rectangle sizes */
> +	priv->crop.width = 640;
> +	priv->crop.height = 480;
> +	priv->compose.width = 640;
> +	priv->compose.height = 480;
> +
>  	/* init default frame interval */
>  	priv->frame_interval.numerator = 1;
>  	priv->frame_interval.denominator = 30;
>
