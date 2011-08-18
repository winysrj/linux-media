Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1HRLc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 07:32:29 -0400
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
In-Reply-To: <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
References: <20110818092158.GA8872@valkosipuli.localdomain>
	 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Aug 2011 14:32:02 +0300
Message-ID: <1313667122.25065.8.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-08-18 at 14:22 +0300, Andy Shevchenko wrote: 
> The ->power() could be absent or not used on some platforms. This patch makes
> its presence optional.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/adp1653.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 0fd9579..f830313 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -329,6 +329,11 @@ adp1653_set_power(struct v4l2_subdev *subdev, int on)
>  	struct adp1653_flash *flash = to_adp1653_flash(subdev);
>  	int ret = 0;
>  
> +	/* There is no need to switch power in case of absence ->power()
> +	 * method. */
> +	if (flash->platform_data->power == NULL)
> +		return 0;
> +
>  	mutex_lock(&flash->power_lock);
>  
>  	/* If the power count is modified from 0 to != 0 or from != 0 to 0,

He-h, I guess you are not going to apply this one.
The patch breaks init logic of the device. If we have no ->power(), we
still need to bring the device to the known state. I have no good idea
how to do this.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
