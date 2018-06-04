Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:46532 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbeFDMIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:08:14 -0400
Received: by mail-lf0-f66.google.com with SMTP id j13-v6so20355906lfb.13
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:08:14 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:08:11 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 3/8] media: v4l2-fwnode: parse 'data-enable-active'
 prop
Message-ID: <20180604120811.GD19674@bigcity.dyn.berto.se>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-29 17:05:54 +0200, Jacopo Mondi wrote:
> Parse the newly defined 'data-enable-active' property in parallel endpoint
> parsing function.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> 
> ---
> v3:
> - new patch
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 4 ++++
>  include/media/v4l2-mediabus.h         | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 3f77aa3..6105191 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -154,6 +154,10 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>  		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
>  			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
> 
> +	if (!fwnode_property_read_u32(fwnode, "data-enable-active", &v))
> +		flags |= v ? V4L2_MBUS_DATA_ENABLE_HIGH :
> +			V4L2_MBUS_DATA_ENABLE_LOW;
> +
>  	bus->flags = flags;
> 
>  }
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 4d8626c..4bbb5f3 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -45,6 +45,8 @@
>  /* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
>  #define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH		BIT(12)
>  #define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		BIT(13)
> +#define V4L2_MBUS_DATA_ENABLE_HIGH		BIT(14)
> +#define V4L2_MBUS_DATA_ENABLE_LOW		BIT(15)
> 
>  /* Serial flags */
>  /* How many lanes the client can use */
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
