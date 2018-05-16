Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:40719 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeEPV6t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 17:58:49 -0400
Received: by mail-lf0-f67.google.com with SMTP id i11-v6so442217lfb.7
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 14:58:49 -0700 (PDT)
Date: Wed, 16 May 2018 23:58:47 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/6] media: rcar-vin: Handle data-active property
Message-ID: <20180516215847.GD17948@bigcity.dyn.berto.se>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-16 18:32:29 +0200, Jacopo Mondi wrote:
> The data-active property has to be specified when running with embedded
> synchronization. The VIN peripheral can use HSYNC in place of CLOCKENB
> when the CLOCKENB pin is not connected, this requires explicit
> synchronization to be in use.

Is this really the intent of the data-active property? I read the 
video-interfaces.txt document as such as if no hsync-active, 
vsync-active and data-active we should use the embedded synchronization 
else set the polarity for the requested pins. What am I not 
understanding here?

> 
> Now that the driver supports 'data-active' property, it makes not sense
> to zero the mbus configuration flags when running with implicit synch
> (V4L2_MBUS_BT656).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3072e1..075d08f 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -531,15 +531,21 @@ static int rvin_digital_parse_v4l2(struct device *dev,
>  		return -ENOTCONN;
>  
>  	vin->mbus_cfg.type = vep->bus_type;
> +	vin->mbus_cfg.flags = vep->bus.parallel.flags;
>  
>  	switch (vin->mbus_cfg.type) {
>  	case V4L2_MBUS_PARALLEL:
>  		vin_dbg(vin, "Found PARALLEL media bus\n");
> -		vin->mbus_cfg.flags = vep->bus.parallel.flags;
>  		break;
>  	case V4L2_MBUS_BT656:
>  		vin_dbg(vin, "Found BT656 media bus\n");
> -		vin->mbus_cfg.flags = 0;
> +
> +		if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
> +		    !(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
> +			vin_err(vin,
> +				"Missing data enable signal polarity property\n");

I fear this can't be an error as that would break backward comp ability 
with existing dtb's.

> +			return -EINVAL;
> +		}
>  		break;
>  	default:
>  		vin_err(vin, "Unknown media bus type\n");
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
