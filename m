Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43176 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752680AbeFDMNT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:13:19 -0400
Received: by mail-lf0-f66.google.com with SMTP id n15-v6so7535980lfn.10
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:13:18 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:13:16 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 5/8] media: rcar-vin: Handle data-enable polarity
Message-ID: <20180604121316.GF19674@bigcity.dyn.berto.se>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-6-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-29 17:05:56 +0200, Jacopo Mondi wrote:
> Handle data-enable signal polarity. If the polarity is not specifically
> requested to be active low, use the active high default.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> v3:
> - use new property to set the CES bit
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index d2b7002..9145b56 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -123,6 +123,7 @@
>  /* Video n Data Mode Register 2 bits */
>  #define VNDMR2_VPS		(1 << 30)
>  #define VNDMR2_HPS		(1 << 29)
> +#define VNDMR2_CES		(1 << 28)
>  #define VNDMR2_FTEV		(1 << 17)
>  #define VNDMR2_VLV(n)		((n & 0xf) << 12)
> 
> @@ -698,6 +699,10 @@ static int rvin_setup(struct rvin_dev *vin)
>  		/* Vsync Signal Polarity Select */
>  		if (!(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>  			dmr2 |= VNDMR2_VPS;
> +
> +		/* Data Enable Polarity Select */
> +		if (vin->parallel->mbus_flags & V4L2_MBUS_DATA_ENABLE_LOW)
> +			dmr2 |= VNDMR2_CES;
>  	}
> 
>  	/*
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
