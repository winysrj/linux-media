Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33049 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeEPWLG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 18:11:06 -0400
Received: by mail-lf0-f67.google.com with SMTP id h9-v6so5766032lfi.0
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 15:11:05 -0700 (PDT)
Date: Thu, 17 May 2018 00:11:03 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/6] media: rcar-vin: Handle CLOCKENB pin polarity
Message-ID: <20180516221103.GE17948@bigcity.dyn.berto.se>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526488352-898-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

I'm happy that you dig into this as it clearly needs doing!

On 2018-05-16 18:32:30 +0200, Jacopo Mondi wrote:
> Handle CLOCKENB pin polarity, or use HSYNC in its place if polarity is
> not specified.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index ac07f99..7a84eae 100644
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
> @@ -691,6 +693,15 @@ static int rvin_setup(struct rvin_dev *vin)
>  		dmr2 |= VNDMR2_VPS;
>  
>  	/*
> +	 * Clock-enable active level select.
> +	 * Use HSYNC as enable if not specified
> +	 */
> +	if (vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)
> +		dmr2 |= VNDMR2_CES;
> +	else if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH))
> +		dmr2 |= VNDMR2_CHS;

After studying the datasheet for a while I'm getting more and more 
convinced this should be (with context leftout in this patch context) 
something like this:

	/* Hsync Signal Polarity Select */
	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
	        dmr2 |= VNDMR2_HPS;

	/* Vsync Signal Polarity Select */
	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
	        dmr2 |= VNDMR2_VPS;

	/* Clock Enable Signal Polarity Select */
	if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW))
	        dmr2 |= VNDMR2_CES;

	/* Use HSYNC as clock enable if VIn_CLKENB is not available. */
	if (!(vin->mbus_cfg.flags & (V4L2_MBUS_DATA_ACTIVE_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH)))
		dmr2 |= VNDMR2_CHS;

Or am I misunderstanding something?

> +
> +	/*
>  	 * Output format
>  	 */
>  	switch (vin->format.pixelformat) {
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
