Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57371 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754125AbdLNXQN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 18:16:13 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH/RFC v2 13/15] adv748x: csi2: only allow formats on sink
 pads
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
 <20171214190835.7672-14-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <e365c00d-701d-4586-4013-e4f3ff58d85a@ideasonboard.com>
Date: Thu, 14 Dec 2017 23:16:08 +0000
MIME-Version: 1.0
In-Reply-To: <20171214190835.7672-14-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 14/12/17 19:08, Niklas Söderlund wrote:
> The driver is now pad and stream aware, only allow to get/set format on
> sink pads.

Ok - I can see the patch is doing this ...

> Also record a different format for each sink pad since it's
> no longer true that they are all the same

But I can't see how the patch is doing this ^ ?

What have I missed?

--
Kieran

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> index 39f993282dd3bb5c..291b35bef49d41fb 100644
> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -176,6 +176,9 @@ static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
>  	struct adv748x_state *state = tx->state;
>  	struct v4l2_mbus_framefmt *mbusformat;
>  
> +	if (sdformat->pad != ADV748X_CSI2_SINK)
> +		return -EINVAL;
> +
>  	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>  						 sdformat->which);
>  	if (!mbusformat)
> @@ -199,6 +202,9 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
>  	struct v4l2_mbus_framefmt *mbusformat;
>  	int ret = 0;
>  
> +	if (sdformat->pad != ADV748X_CSI2_SINK)
> +		return -EINVAL;
> +
>  	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>  						 sdformat->which);
>  	if (!mbusformat)
> 
