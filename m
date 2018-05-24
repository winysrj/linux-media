Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40265 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968590AbeEXKi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:38:56 -0400
Received: by mail-wm0-f66.google.com with SMTP id j5-v6so3803059wme.5
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 03:38:55 -0700 (PDT)
Date: Thu, 24 May 2018 12:38:53 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 8/9] media: rcar-vin: Rename _rcar_info to rcar_info
Message-ID: <20180524103853.GH31036@bigcity.dyn.berto.se>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-9-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526654445-10702-9-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-18 16:40:44 +0200, Jacopo Mondi wrote:
> Remove trailing underscore to align all rcar_group_route structure
> declarations.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

With Sergei's comment addressed:

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index dcebb42..b740f41 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1060,7 +1060,7 @@ static const struct rvin_info rcar_info_r8a7796 = {
>  	.routes = rcar_info_r8a7796_routes,
>  };
>  
> -static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
> +static const struct rvin_group_route rcar_info_r8a77970_routes[] = {
>  	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
>  	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
>  	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
> @@ -1076,7 +1076,7 @@ static const struct rvin_info rcar_info_r8a77970 = {
>  	.use_mc = true,
>  	.max_width = 4096,
>  	.max_height = 4096,
> -	.routes = _rcar_info_r8a77970_routes,
> +	.routes = rcar_info_r8a77970_routes,
>  };
>  
>  static const struct of_device_id rvin_of_id_table[] = {
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
