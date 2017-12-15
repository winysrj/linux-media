Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:56349 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756497AbdLOOPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:15:41 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 40D6048633E
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 15:15:40 +0100 (CET)
Date: Fri, 15 Dec 2017 15:15:31 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 07/15] rcar-csi2: use frame description
 information to configure CSI-2 bus
Message-ID: <20171215141531.GC3375@w540>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-8-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171214190835.7672-8-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,
   thanks for the patch!

On Thu, Dec 14, 2017 at 08:08:27PM +0100, Niklas Söderlund wrote:
> The driver now have access to frame descriptor information, use it. Only
> enable the virtual channels which are described in the frame descriptor
> and calculate the link based on all enabled streams.
>
> With multiplexed stream support it's now possible to have different
> formats on the different source pads. Make source formats independent
> off each other and disallowing a format on the multiplexed sink.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 112 ++++++++++++++--------------
>  1 file changed, 58 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index 6b607b2e31e26063..2dd7d03d622d5510 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -296,24 +296,22 @@ static const struct phtw_testdin_data testdin_data_v3m_e3[] = {
>  #define CSI0CLKFREQRANGE(n)		((n & 0x3f) << 16)
>
>  struct rcar_csi2_format {
> -	unsigned int code;
>  	unsigned int datatype;
>  	unsigned int bpp;
>  };
>
>  static const struct rcar_csi2_format rcar_csi2_formats[] = {
> -	{ .code = MEDIA_BUS_FMT_RGB888_1X24,	.datatype = 0x24, .bpp = 24 },
> -	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,	.datatype = 0x1e, .bpp = 16 },
> -	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,	.datatype = 0x1e, .bpp = 16 },
> -	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,	.datatype = 0x1e, .bpp = 16 },
> +	{ .datatype = 0x1e, .bpp = 16 },
> +	{ .datatype = 0x24, .bpp = 24 },
>  };
>
> -static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int code)
> +static const struct rcar_csi2_format
> +*rcar_csi2_datatype_to_fmt(unsigned int datatype)
>  {
>  	unsigned int i;
>
>  	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> -		if (rcar_csi2_formats[i].code == code)
> +		if (rcar_csi2_formats[i].datatype == datatype)
>  			return rcar_csi2_formats + i;
>
>  	return NULL;
> @@ -355,7 +353,7 @@ struct rcar_csi2 {
>  	struct v4l2_async_notifier notifier;
>  	struct v4l2_async_subdev remote;
>
> -	struct v4l2_mbus_framefmt mf;
> +	struct v4l2_mbus_framefmt mf[4];
>
>  	struct mutex lock;
>  	int stream_count[4];
> @@ -411,25 +409,14 @@ static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
>  	return -ETIMEDOUT;
>  }
>
> -static int rcar_csi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> +static int rcar_csi2_calc_mbps(struct rcar_csi2 *priv,
> +			       struct v4l2_subdev *source,
> +			       struct v4l2_mbus_frame_desc *fd)
>  {
> -	struct media_pad *pad, *source_pad;
> -	struct v4l2_subdev *source = NULL;
>  	struct v4l2_ctrl *ctrl;
> +	unsigned int i, bpp = 0;
>  	u64 mbps;
>
> -	/* Get remote subdevice */
> -	pad = &priv->subdev.entity.pads[RCAR_CSI2_SINK];
> -	source_pad = media_entity_remote_pad(pad);
> -	if (!source_pad) {
> -		dev_err(priv->dev, "Could not find remote source pad\n");
> -		return -ENODEV;
> -	}
> -	source = media_entity_to_v4l2_subdev(source_pad->entity);
> -
> -	dev_dbg(priv->dev, "Using source %s pad: %u\n", source->name,
> -		source_pad->index);
> -
>  	/* Read the pixel rate control from remote */
>  	ctrl = v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
>  	if (!ctrl) {
> @@ -438,6 +425,21 @@ static int rcar_csi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
>  		return -EINVAL;
>  	}
>
> +	/* Calculate total bpp */
> +	for (i = 0; i < fd->num_entries; i++) {
> +		const struct rcar_csi2_format *format;
> +
> +		format = rcar_csi2_datatype_to_fmt(
> +					fd->entry[i].bus.csi2.data_type);
> +		if (!format) {
> +			dev_err(priv->dev, "Unknown data type: %d\n",
> +				fd->entry[i].bus.csi2.data_type);
> +			return -EINVAL;
> +		}
> +
> +		bpp += format->bpp;
> +	}
> +
>  	/* Calculate the phypll */
>  	mbps = v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
>  	do_div(mbps, priv->lanes * 1000000);
> @@ -489,39 +491,33 @@ static int rcar_csi2_set_phtw(struct rcar_csi2 *priv, unsigned int mbps)
>  	return 0;
>  }
>
> -static int rcar_csi2_start(struct rcar_csi2 *priv)
> +static int rcar_csi2_start(struct rcar_csi2 *priv, struct v4l2_subdev *source,
> +			   struct v4l2_mbus_frame_desc *fd)

I'm not sure I got this right, but with the new s_stream pad
operation, and with rcar-csi2 endpoints connected to differenct VIN
instances, is it possible for "rcar_csi2_s_stream()" to be called on
the same rcar-csi2 instance from different VIN instances?

In that case you are calling "rcar_csi2_start()" the first time only from
"rcar_csi2_s_stream()":

	for (i = 0; i < 4; i++)
		count += priv->stream_count[i];

	if (enable && count == 0) {
		pm_runtime_get_sync(priv->dev);

		ret = rcar_csi2_start(priv, nextsd, &fd);

and the consequentially VCDT register never gets updated to accommodate
new routes.

Thanks
   j

>  {
> -	const struct rcar_csi2_format *format;
> -	u32 phycnt, tmp;
> -	u32 vcdt = 0, vcdt2 = 0;
> +	u32 phycnt, vcdt = 0, vcdt2 = 0;
>  	unsigned int i;
>  	int mbps, ret;
>
> -	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> -		priv->mf.width, priv->mf.height,
> -		priv->mf.field == V4L2_FIELD_NONE ? 'p' : 'i');
> -
> -	/* Code is validated in set_ftm */
> -	format = rcar_csi2_code_to_fmt(priv->mf.code);
> +	for (i = 0; i < fd->num_entries; i++) {
> +		struct v4l2_mbus_frame_desc_entry *entry = &fd->entry[i];
> +		u32 tmp;
>
> -	/*
> -	 * Enable all Virtual Channels
> -	 *
> -	 * NOTE: It's not possible to get individual datatype for each
> -	 *       source virtual channel. Once this is possible in V4L2
> -	 *       it should be used here.
> -	 */
> -	for (i = 0; i < 4; i++) {
> -		tmp = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> -			VCDT_SEL_DT(format->datatype);
> +		tmp = VCDT_SEL_VC(entry->bus.csi2.channel) | VCDT_VCDTN_EN |
> +			VCDT_SEL_DTN_ON |
> +			VCDT_SEL_DT(entry->bus.csi2.data_type);
>
>  		/* Store in correct reg and offset */
> -		if (i < 2)
> -			vcdt |= tmp << ((i % 2) * 16);
> +		if (entry->bus.csi2.channel < 2)
> +			vcdt |= tmp << ((entry->bus.csi2.channel % 2) * 16);
>  		else
> -			vcdt2 |= tmp << ((i % 2) * 16);
> +			vcdt2 |= tmp << ((entry->bus.csi2.channel % 2) * 16);
> +
> +		dev_dbg(priv->dev, "VC%d datatype: 0x%x\n",
> +			entry->bus.csi2.channel, entry->bus.csi2.data_type);
>  	}
>
> +	dev_dbg(priv->dev, "VCDT: 0x%08x VCDT2: 0x%08x\n", vcdt, vcdt2);
> +
>  	switch (priv->lanes) {
>  	case 1:
>  		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> @@ -537,7 +533,7 @@ static int rcar_csi2_start(struct rcar_csi2 *priv)
>  		return -EINVAL;
>  	}
>
> -	mbps = rcar_csi2_calc_mbps(priv, format->bpp);
> +	mbps = rcar_csi2_calc_mbps(priv, source, fd);
>  	if (mbps < 0)
>  		return mbps;
>
> @@ -686,7 +682,7 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
>  	if (enable && count == 0) {
>  		pm_runtime_get_sync(priv->dev);
>
> -		ret = rcar_csi2_start(priv);
> +		ret = rcar_csi2_start(priv, nextsd, &fd);
>  		if (ret) {
>  			pm_runtime_put(priv->dev);
>  			goto out;
> @@ -720,14 +716,16 @@ static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
>  {
>  	struct rcar_csi2 *priv = sd_to_csi2(sd);
>  	struct v4l2_mbus_framefmt *framefmt;
> +	int vc;
>
> -	if (!rcar_csi2_code_to_fmt(format->format.code))
> -		return -EINVAL;
> +	vc = rcar_csi2_pad_to_vc(format->pad);
> +	if (vc < 0)
> +		return vc;
>
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> -		priv->mf = format->format;
> +		priv->mf[vc] = format->format;
>  	} else {
> -		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>  		*framefmt = format->format;
>  	}
>
> @@ -739,11 +737,17 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
>  				    struct v4l2_subdev_format *format)
>  {
>  	struct rcar_csi2 *priv = sd_to_csi2(sd);
> +	int vc;
> +
> +	vc = rcar_csi2_pad_to_vc(format->pad);
> +	if (vc < 0)
> +		return vc;
>
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -		format->format = priv->mf;
> +		format->format = priv->mf[vc];
>  	else
> -		format->format = *v4l2_subdev_get_try_format(sd, cfg, 0);
> +		format->format = *v4l2_subdev_get_try_format(sd, cfg,
> +							     format->pad);
>
>  	return 0;
>  }
> --
> 2.15.1
>
