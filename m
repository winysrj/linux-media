Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57063 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3DVMph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:45:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 23/24] V4L2: mt9p031: add struct v4l2_subdev_platform_data to platform data
Date: Mon, 22 Apr 2013 14:45:45 +0200
Message-ID: <71930525.vsO5URbCVS@avalon>
In-Reply-To: <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 18 April 2013 23:35:44 Guennadi Liakhovetski wrote:
> Adding struct v4l2_subdev_platform_data to mt9p031's platform data allows
> the driver to use generic functions to manage sensor power supplies.

The mt9p031 driver now handles its regulators explicitly, please see

commit 97f212767a4d0fbddbf4786ccedacb47fc210548
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Tue May 8 10:10:36 2012 -0300

    [media] mt9p031: Add support for regulators
    
    Enable the regulators when powering the sensor up, and disable them when
    powering it down.
    The regulators are mandatory. Boards that don't allow controlling the
    sensor power lines must provide fixed voltage regulators.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/i2c/mt9p031.c |    1 +
>  include/media/mt9p031.h     |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 70f4525..ca2cc6e 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -1048,6 +1048,7 @@ static int mt9p031_probe(struct i2c_client *client,
>  		goto done;
> 
>  	mt9p031->subdev.dev = &client->dev;
> +	mt9p031->subdev.pdata = &pdata->sd_pdata;
>  	ret = v4l2_async_register_subdev(&mt9p031->subdev);
> 
>  done:
> diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
> index 0c97b19..7bf7b53 100644
> --- a/include/media/mt9p031.h
> +++ b/include/media/mt9p031.h
> @@ -1,6 +1,8 @@
>  #ifndef MT9P031_H
>  #define MT9P031_H
> 
> +#include <media/v4l2-subdev.h>
> +
>  struct v4l2_subdev;
> 
>  /*
> @@ -15,6 +17,7 @@ struct mt9p031_platform_data {
>  	int reset;
>  	int ext_freq;
>  	int target_freq;
> +	struct v4l2_subdev_platform_data sd_pdata;
>  };
> 
>  #endif
-- 
Regards,

Laurent Pinchart

