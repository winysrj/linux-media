Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45745 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbeEVPgf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 11:36:35 -0400
Received: by mail-wr0-f193.google.com with SMTP id w3-v6so13287390wrl.12
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 08:36:34 -0700 (PDT)
Date: Tue, 22 May 2018 17:36:32 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 3/4] media: rcar-vin: Handle CLOCKENB pin polarity
Message-ID: <20180522153632.GE5115@bigcity.dyn.berto.se>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526923663-8179-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-21 19:27:42 +0200, Jacopo Mondi wrote:
> Handle CLOCKENB pin polarity, or use HSYNC in its place if polarity is
> not specified and we're running on parallel data bus with explicit
> synchronism signals.
> 
> While at there, simplify the media bus handling flags logic, inspecting
> flags only if the system is running on parallel media bus type and ignore
> flags when on CSI-2. Also change comments style to remove un-necessary
> camel case and add a full stop at the end of sentences.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 34 ++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 17f291f..ffd3d62 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -123,6 +123,8 @@
>  /* Video n Data Mode Register 2 bits */
>  #define VNDMR2_VPS		(1 << 30)
>  #define VNDMR2_HPS		(1 << 29)
> +#define VNDMR2_CES		(1 << 28)
> +#define VNDMR2_CHS		(1 << 23)
>  #define VNDMR2_FTEV		(1 << 17)
>  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
>  
> @@ -684,21 +686,35 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	}
>  
> -	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> +	/* Enable VSYNC field toggle mode after one VSYNC input. */
>  	if (vin->info->model == RCAR_GEN3)
>  		dmr2 = VNDMR2_FTEV;
>  	else
>  		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
>  
> -	/* Hsync Signal Polarity Select */
> -	if (!vin->is_csi &&
> -	    !(vin->parallel->mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> -		dmr2 |= VNDMR2_HPS;
> +	/* Synchronism signal polarities: only for parallel data bus. */
> +	if (!vin->is_csi) {
> +		/* Hsync signal polarity select. */
> +		if (!(vin->parallel->mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +			dmr2 |= VNDMR2_HPS;
>  
> -	/* Vsync Signal Polarity Select */
> -	if (!vin->is_csi &&
> -	    !(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> -		dmr2 |= VNDMR2_VPS;
> +		/* Vsync signal polarity select. */
> +		if (!(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +			dmr2 |= VNDMR2_VPS;
> +
> +		/*
> +		 * Data enable signal polarity select.
> +		 * Use HSYNC as data-enable if not specified and running
> +		 * with explicit synchronizations; otherwise default 'high'
> +		 * is selected.
> +		 */
> +		if (vin->parallel->mbus_flags & V4L2_MBUS_DATA_ACTIVE_LOW)
> +			dmr2 |= VNDMR2_CES;
> +		else if (!(vin->parallel->mbus_flags &
> +			 V4L2_MBUS_DATA_ACTIVE_HIGH) &&
> +			 vin->parallel->mbus_type == V4L2_MBUS_PARALLEL)
> +			dmr2 |= VNDMR2_CHS;

As I stated in v1, I think this expression is more complex then is relly
needed here. Would not something like this be much more readable?

        /* Clock Enable signal polarity select. */
	if (vin->parallel->mbus_flags & V4L2_MBUS_DATA_ACTIVE_LOW)
                dmr2 |= VNDMR2_CES;

        /* Use HSYNC as clock enable if VIn_CLKENB is not available. */
        if (!(vin->parallel->mbus_flags & (V4L2_MBUS_DATA_ACTIVE_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH)))
                dmr2 |= VNDMR2_CHS;


> +	}
>  
>  	/*
>  	 * Output format
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
