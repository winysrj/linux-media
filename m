Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55888 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaEIMQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:16:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] smiapp: Use better regulator name for the Device tree
Date: Fri, 09 May 2014 14:16:47 +0200
Message-ID: <1688439.tqIRKfgIXZ@avalon>
In-Reply-To: <1399163517-5220-2-git-send-email-sakari.ailus@iki.fi>
References: <1399163517-5220-1-git-send-email-sakari.ailus@iki.fi> <1399163517-5220-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Sunday 04 May 2014 03:31:55 Sakari Ailus wrote:
> Rename "VANA" regulator as "vana".
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 8741cae..c1d6d1d 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2355,7 +2355,7 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev) unsigned int i;
>  	int rval;
> 
> -	sensor->vana = devm_regulator_get(&client->dev, "VANA");
> +	sensor->vana = devm_regulator_get(&client->dev, "vana");
>  	if (IS_ERR(sensor->vana)) {
>  		dev_err(&client->dev, "could not get regulator for vana\n");
>  		return -ENODEV;

-- 
Regards,

Laurent Pinchart

