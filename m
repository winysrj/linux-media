Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:48306 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755268AbdLONVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 08:21:10 -0500
Date: Fri, 15 Dec 2017 15:19:36 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 06/15] rcar-csi2: use frame description
 information when propagating .s_stream()
Message-ID: <20171215131936.2gs3inus5dpkd6cl@paasikivi.fi.intel.com>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-7-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171214190835.7672-7-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, Dec 14, 2017 at 08:08:26PM +0100, Niklas Söderlund wrote:
> Use the frame description from the remote subdevice of the rcar-csi2's
> sink pad to get the remote pad and stream pad needed to propagate the
> .s_stream() operation.
> 
> The CSI-2 virtual channel which should be acted upon can be determined
> by looking at which of the rcar-csi2 source pad the .s_stream() was
> called on. This is because the rcar-csi2 acts as a demultiplexer for the
> CSI-2 link on the one sink pad and outputs each virtual channel on a
> distinct and known source pad.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 58 ++++++++++++++++++++---------
>  1 file changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index e0f56cc3d25179a9..6b607b2e31e26063 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -614,20 +614,31 @@ static void rcar_csi2_stop(struct rcar_csi2 *priv)
>  	rcar_csi2_reset(priv);
>  }
>  
> -static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
> +static int rcar_csi2_get_source_info(struct rcar_csi2 *priv,
> +				     struct v4l2_subdev **subdev,

I wonder if using struct media_pad for this would be cleaner.

> +				     unsigned int *pad,
> +				     struct v4l2_mbus_frame_desc *fd)
>  {
> -	struct media_pad *pad;
> +	struct media_pad *remote_pad;
>  
> -	pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
> -	if (!pad) {
> -		dev_err(priv->dev, "Could not find remote pad\n");
> +	/* Get source subdevice and pad */
> +	remote_pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
> +	if (!remote_pad) {
> +		dev_err(priv->dev, "Could not find remote source pad\n");
>  		return -ENODEV;
>  	}
> +	*subdev = media_entity_to_v4l2_subdev(remote_pad->entity);
> +	*pad = remote_pad->index;
>  
> -	*sd = media_entity_to_v4l2_subdev(pad->entity);
> -	if (!*sd) {
> -		dev_err(priv->dev, "Could not find remote subdevice\n");
> -		return -ENODEV;
> +	/* Get frame descriptor */
> +	if (v4l2_subdev_call(*subdev, pad, get_frame_desc, *pad, fd)) {
> +		dev_err(priv->dev, "Could not read frame desc\n");
> +		return -EINVAL;
> +	}
> +
> +	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
> +		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
> +		return -EINVAL;

I think this should also work with drivers that do not support frame
descriptors.

Alternatively support could be added for all drivers. In practice this
would mean having a few bus specific implementations of get_frame_desc op
that would dig the information from the frame format.

Perhaps the former option would make sense here, for now.

>  	}
>  
>  	return 0;
> @@ -637,9 +648,10 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
>  			      unsigned int stream, int enable)
>  {
>  	struct rcar_csi2 *priv = sd_to_csi2(sd);
> +	struct v4l2_mbus_frame_desc fd;
>  	struct v4l2_subdev *nextsd;
> -	unsigned int i, count = 0;
> -	int ret, vc;
> +	unsigned int i, rpad, count = 0;
> +	int ret, vc, rstream = -1;
>  
>  	/* Only allow stream control on source pads and valid vc */
>  	vc = rcar_csi2_pad_to_vc(pad);
> @@ -650,11 +662,23 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
>  	if (stream != 0)
>  		return -EINVAL;
>  
> -	mutex_lock(&priv->lock);
> -
> -	ret = rcar_csi2_sd_info(priv, &nextsd);
> +	/* Get information about multiplexed link */
> +	ret = rcar_csi2_get_source_info(priv, &nextsd, &rpad, &fd);
>  	if (ret)
> -		goto out;
> +		return ret;
> +
> +	/* Get stream on multiplexed link */
> +	for (i = 0; i < fd.num_entries; i++)
> +		if (fd.entry[i].bus.csi2.channel == vc)
> +			rstream = fd.entry[i].stream;

Virtual channel does not equate to the stream. You'll need the data type,
too.

You should actually obtain this from the configured routes instead.

How does this work btw. if you have several streams on the same virtual
channel that only have different data types?

> +
> +	if (rstream < 0) {
> +		dev_err(priv->dev, "Could not find stream for vc %u\n", vc);
> +		return -EINVAL;
> +	}
> +
> +	/* Start or stop the requested stream */
> +	mutex_lock(&priv->lock);
>  
>  	for (i = 0; i < 4; i++)
>  		count += priv->stream_count[i];
> @@ -673,14 +697,14 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
>  	}
>  
>  	if (enable && priv->stream_count[vc] == 0) {
> -		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
> +		ret = v4l2_subdev_call(nextsd, pad, s_stream, rpad, rstream, 1);
>  		if (ret) {
>  			rcar_csi2_stop(priv);
>  			pm_runtime_put(priv->dev);
>  			goto out;
>  		}
>  	} else if (!enable && priv->stream_count[vc] == 1) {
> -		ret = v4l2_subdev_call(nextsd, video, s_stream, 0);
> +		ret = v4l2_subdev_call(nextsd, pad, s_stream, rpad, rstream, 0);
>  	}
>  
>  	priv->stream_count[vc] += enable ? 1 : -1;
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
