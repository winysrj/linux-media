Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:38091 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbeEKLKk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 07:10:40 -0400
Received: by mail-lf0-f66.google.com with SMTP id z142-v6so7361215lff.5
        for <linux-media@vger.kernel.org>; Fri, 11 May 2018 04:10:39 -0700 (PDT)
Date: Fri, 11 May 2018 13:10:37 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] media: rcar-vin: Do not use crop if not configured
Message-ID: <20180511111037.GD18974@bigcity.dyn.berto.se>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526032781-14319-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-11 11:59:40 +0200, Jacopo Mondi wrote:
> The crop_scale routine uses the crop rectangle memebers to configure the
> VIN clipping rectangle. When crop is not configured all its fields are
> 0s, and setting the clipping rectangle vertical and horizontal extensions
> to (0 - 1) causes the registers to be written with an incorrect
> 0xffffffff value.

This is an interesting find and a clear bug in my code. But I can't see 
how crop ever could be 0. When s_fmt is called it always resets the crop 
and compose width's to the requested format size.

I'm curious how you found this bug, I tried to reproduce it but could 
not. This is indeed something we should fix! But I think the proper fix 
is not allowing crop to be 0 and not treating the symptom in 
rvin_crop_scale_comp().

> 
> Fix this by using the actual format width and height when no crop
> rectangle has been programmed.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index b41ba9a..ea7a120 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -579,22 +579,25 @@ static void rvin_crop_scale_comp_gen2(struct rvin_dev *vin)
>  
>  void rvin_crop_scale_comp(struct rvin_dev *vin)
>  {
> -	/* Set Start/End Pixel/Line Pre-Clip */
> +	u32 width = vin->crop.width ? vin->crop.left + vin->crop.width :
> +				      vin->format.width;
> +	u32 height = vin->crop.height ? vin->crop.top + vin->crop.height :
> +					vin->format.height;
> +
> +	/* Set Start/End Pixel/Line Pre-Clip if crop is configured. */
>  	rvin_write(vin, vin->crop.left, VNSPPRC_REG);
> -	rvin_write(vin, vin->crop.left + vin->crop.width - 1, VNEPPRC_REG);
> +	rvin_write(vin, width - 1, VNEPPRC_REG);
>  
>  	switch (vin->format.field) {
>  	case V4L2_FIELD_INTERLACED:
>  	case V4L2_FIELD_INTERLACED_TB:
>  	case V4L2_FIELD_INTERLACED_BT:
>  		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> -		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> -			   VNELPRC_REG);
> +		rvin_write(vin, height / 2 - 1, VNELPRC_REG);
>  		break;
>  	default:
>  		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> -		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> -			   VNELPRC_REG);
> +		rvin_write(vin, height - 1, VNELPRC_REG);
>  		break;
>  	}
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
