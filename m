Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1KPKhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 05:37:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 6/9] as3645a: free resources in case of error properly
Date: Wed, 16 Nov 2011 11:37:52 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com> <cover.1321379276.git.andriy.shevchenko@linux.intel.com> <20ff3c96498a0e9e0a1c1d09690fbbf6a59bee15.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <20ff3c96498a0e9e0a1c1d09690fbbf6a59bee15.1321379276.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111161137.54083.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch.

On Tuesday 15 November 2011 18:49:58 Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/media/video/as3645a.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index 541f8bc..9aebaa2 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -800,11 +800,13 @@ static int as3645a_probe(struct i2c_client *client,
>  	flash->subdev.internal_ops = &as3645a_internal_ops;
>  	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
> +	ret = as3645a_init_controls(flash);
> +	if (ret < 0)
> +		goto free_and_quit;
> +
>  	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> -	if (ret < 0) {
> -		kfree(flash);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto free_and_quit;
> 
>  	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> 
> @@ -812,13 +814,12 @@ static int as3645a_probe(struct i2c_client *client,
> 
>  	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> 
> -	ret = as3645a_init_controls(flash);
> -	if (ret < 0) {
> -		kfree(flash);
> -		return ret;
> -	}
> -

Would you mind if I replace this code below

>  	return 0;
> +
> +free_and_quit:
> +	v4l2_ctrl_handler_free(&flash->ctrls);
> +	kfree(flash);
> +	return ret;

with

done:
	if (ret < 0) {
		v4l2_ctrl_handler_free(&flash->ctrls);
		kfree(flash);
	}

	return ret;

>  }
> 
>  static int __exit as3645a_remove(struct i2c_client *client)
> @@ -828,7 +829,7 @@ static int __exit as3645a_remove(struct i2c_client
> *client)
> 
>  	v4l2_device_unregister_subdev(subdev);
>  	v4l2_ctrl_handler_free(&flash->ctrls);
> -
> +	media_entity_cleanup(&flash->subdev.entity);
>  	kfree(flash);
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
