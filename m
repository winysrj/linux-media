Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55103 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1HRJWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 05:22:05 -0400
Date: Thu, 18 Aug 2011 12:21:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] adp1653: make ->power() method optional
Message-ID: <20110818092158.GA8872@valkosipuli.localdomain>
References: <aa45d92c4ec78b36b28eb721ef58f3a5512900a3.1313657559.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa45d92c4ec78b36b28eb721ef58f3a5512900a3.1313657559.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 18, 2011 at 11:53:03AM +0300, Andy Shevchenko wrote:
> The ->power() could be absent or not used on some platforms. This patch makes
> its presence optional.

Hi Andy,

Thanks for the patch!

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/adp1653.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 0fd9579..65f6f3f 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -309,6 +309,9 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
>  {
>  	int ret;
>  
> +	if (flash->platform_data->power == NULL)
> +		return 0;
> +
>  	ret = flash->platform_data->power(&flash->subdev, on);
>  	if (ret < 0)
>  		return ret;
> -- 
> 1.7.5.4
> 

How about doing this in adp1653_set_power() instead of
__adp1653_set_power()? At least I don't see any ill effects from this.
There's no need to keep track of the power state (flash->power_count) if
there isn't one. :-)

-- 
Sakari Ailus
sakari.ailus@iki.fi
