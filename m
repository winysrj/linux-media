Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754672AbdLOMHn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 07:07:43 -0500
Date: Fri, 15 Dec 2017 14:07:39 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 03/15] rcar-vin: use the pad and stream aware
 s_stream
Message-ID: <20171215120739.si2b27npc25zxelv@paasikivi.fi.intel.com>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171214190835.7672-4-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej,

On Thu, Dec 14, 2017 at 08:08:23PM +0100, Niklas Söderlund wrote:
> To work with multiplexed streams the pad and stream aware s_stream
> operation needs to be used.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index cf30e5fceb1d493a..8435491535060eae 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1180,7 +1180,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
>  
>  	if (!on) {
>  		media_pipeline_stop(vin->vdev.entity.pads);
> -		return v4l2_subdev_call(sd, video, s_stream, 0);
> +		return v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 0);

Have you thought of adding a wrapper for the s_stream callback?

I think you should either change all s_stream callbacks from video to pad,
or add a wrapper which then calls the video op instead of the pad op if the
pad op does not exist. Otherwise we again have two non-interoperable
classes of drivers for no good reason.

Thinking about it, I'm not all that certain changing all instances would be
that much work in the end; it should be done anyway. Devices that have a
single stream (i.e. everything right now) just don't care about the pad
number.

>  	}
>  
>  	fmt.pad = pad->index;
> @@ -1239,12 +1239,14 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
>  	if (media_pipeline_start(vin->vdev.entity.pads, pipe))
>  		return -EPIPE;
>  
> -	ret = v4l2_subdev_call(sd, video, s_stream, 1);
> +	ret = v4l2_subdev_call(sd, pad, s_stream, pad->index, 0, 1);
>  	if (ret == -ENOIOCTLCMD)
>  		ret = 0;
>  	if (ret)
>  		media_pipeline_stop(vin->vdev.entity.pads);
>  
> +	vin_dbg(vin, "pad: %u stream: 0 enable: %d\n", pad->index, on);
> +
>  	return ret;
>  }
>  
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
