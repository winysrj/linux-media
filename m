Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45107 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1HQLff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 07:35:35 -0400
Date: Wed, 17 Aug 2011 14:35:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] adp1653: set media entity type
Message-ID: <20110817113531.GI7436@valkosipuli.localdomain>
References: <20110811071900.GC5926@valkosipuli.localdomain>
 <bdfa2fa007fe799206043c874017fb3b412f7f32.1313062441.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdfa2fa007fe799206043c874017fb3b412f7f32.1313062441.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2011 at 02:35:04PM +0300, Andy Shevchenko wrote:
> The type of a media entity is default for this driver. This patch makes it
> explicitly defined as MEDIA_ENT_T_V4L2_SUBDEV_FLASH.

Thanks again for the patch, Andy!

Applied to my tree in linuxtv.org; the branch is called
media-for-3.2-adp1653-1.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/media/video/adp1653.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 7f2e710..0fd9579 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -438,6 +438,8 @@ static int adp1653_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto free_and_quit;
>  
> +	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
>  	return 0;
>  
>  free_and_quit:
> -- 
> 1.7.5.4
> 

-- 
Sakari Ailus
sakari.ailus@iki.fi
