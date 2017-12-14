Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57386 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbdLNX2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 18:28:01 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH/RFC v2 14/15] adv748x: csi2: add get_routing support
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-15-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <23bd28e2-5949-da25-b3e6-84f6d20dd8ef@ideasonboard.com>
Date: Thu, 14 Dec 2017 23:27:57 +0000
MIME-Version: 1.0
In-Reply-To: <20171214190835.7672-15-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 14/12/17 19:08, Niklas Söderlund wrote:
> To support multiplexed streams the internal routing between the
> adv748x sink pad and its source pad needs to be described.

The adv748x has quite a few sink and source pads... I presume here you mean the
adv748x csi2 sink and source pad :D

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 291b35bef49d41fb..dbefb53f5b8c414d 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -262,10 +262,32 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
>  	return 0;
>  }
>  
> +static int adv748x_csi2_get_routing(struct v4l2_subdev *subdev,
> +				    struct v4l2_subdev_routing *routing)
> +{
> +	struct v4l2_subdev_route *r = routing->routes;
> +
> +	if (routing->num_routes < 1) {
> +		routing->num_routes = 1;
> +		return -ENOSPC;
> +	}
> +
> +	routing->num_routes = 1;
> +
> +	r->sink_pad = ADV748X_CSI2_SINK;
> +	r->sink_stream = 0;
> +	r->source_pad = ADV748X_CSI2_SOURCE;
> +	r->source_stream = 0;
> +	r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE | V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
> +
> +	return 0;
> +}
> +

So - I think this is fine - but it seems a lot of code to define a static
default route which describes a single link between it's sink pad - and its
source pad ...

I suspect this should/could be wrapped by some helpers in core for cases like
this, as it's the simple case - but as we don't currently have that I guess we
have to put this in here for now ?

Maybe we should have a helper to make this

return v4l2_subdev_single_route(subdev, routing,
                                ADV748X_CS2_SINK, 0,
                                ADV748X_CSI2_SOURCE, 0,
                  V4L2_SUBDEV_ROUTE_FL_ACTIVE | V4L2_SUBDEV_ROUTE_FL_IMMUTABLE);

Or maybe even define these static routes in a struct somehow?

>  static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
>  	.get_fmt = adv748x_csi2_get_format,
>  	.set_fmt = adv748x_csi2_set_format,
>  	.get_frame_desc = adv748x_csi2_get_frame_desc,
> +	.get_routing = adv748x_csi2_get_routing,
>  	.s_stream = adv748x_csi2_s_stream,
>  };
>  
> 
