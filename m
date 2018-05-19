Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35286 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbeESJdX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 05:33:23 -0400
Received: by mail-lf0-f68.google.com with SMTP id y72-v6so17402026lfd.2
        for <linux-media@vger.kernel.org>; Sat, 19 May 2018 02:33:22 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] media: rcar-vin: Rename _rcar_info to rcar_info
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526654445-10702-9-git-send-email-jacopo+renesas@jmondi.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <9a9c15a3-732c-dbb5-32c3-67cdf11b8430@cogentembedded.com>
Date: Sat, 19 May 2018 12:33:19 +0300
MIME-Version: 1.0
In-Reply-To: <1526654445-10702-9-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 5/18/2018 5:40 PM, Jacopo Mondi wrote:

> Remove trailing underscore to align all rcar_group_route structure

    Leading, not trailing (judging on the patch).

> declarations.
>  Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>   drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index dcebb42..b740f41 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1060,7 +1060,7 @@ static const struct rvin_info rcar_info_r8a7796 = {
>   	.routes = rcar_info_r8a7796_routes,
>   };
>   
> -static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
> +static const struct rvin_group_route rcar_info_r8a77970_routes[] = {
>   	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
>   	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
>   	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
> @@ -1076,7 +1076,7 @@ static const struct rvin_info rcar_info_r8a77970 = {
>   	.use_mc = true,
>   	.max_width = 4096,
>   	.max_height = 4096,
> -	.routes = _rcar_info_r8a77970_routes,
> +	.routes = rcar_info_r8a77970_routes,
>   };
>   
>   static const struct of_device_id rvin_of_id_table[] = {

MBR, Sergei
