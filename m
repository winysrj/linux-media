Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53937 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934761AbeEWWnD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 18:43:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id a67-v6so12970106wmf.3
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 15:43:03 -0700 (PDT)
Date: Thu, 24 May 2018 00:43:01 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/9] media: rcar-vin: Remove two empty lines
Message-ID: <20180523224301.GG5115@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-18 16:40:38 +0200, Jacopo Mondi wrote:
> Remove un-necessary empty lines.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 6b80f98..1aadd90 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -707,11 +707,9 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
>  		return -EINVAL;
>  
>  	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
> -
>  		vin_dbg(vin, "OF device %pOF disabled, ignoring\n",
>  			to_of_node(asd->match.fwnode));
>  		return -ENOTCONN;
> -
>  	}
>  
>  	if (vin->group->csi[vep->base.id].fwnode) {
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
