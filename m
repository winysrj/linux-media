Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44739 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbKIO55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 09:57:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Remove useless rval assignment in smiapp_get_pdata()
Date: Mon, 09 Nov 2015 16:58:08 +0200
Message-ID: <3935818.GkOUHKLxx2@avalon>
In-Reply-To: <1428705767-3241-1-git-send-email-sakari.ailus@iki.fi>
References: <1428705767-3241-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 11 April 2015 01:42:47 Sakari Ailus wrote:
> The value is not used after the assignment.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 636ebd6..4b1e112 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -3032,10 +3032,8 @@ static struct smiapp_platform_data
> *smiapp_get_pdata(struct device *dev) pdata->op_sys_clock = devm_kcalloc(
>  		dev, bus_cfg->nr_of_link_frequencies + 1 /* guardian */,
>  		sizeof(*pdata->op_sys_clock), GFP_KERNEL);
> -	if (!pdata->op_sys_clock) {
> -		rval = -ENOMEM;
> +	if (!pdata->op_sys_clock)
>  		goto out_err;
> -	}
> 
>  	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
>  		pdata->op_sys_clock[i] = bus_cfg->link_frequencies[i];

-- 
Regards,

Laurent Pinchart

