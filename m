Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34017 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753016AbcK2RfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 12:35:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stern@rowland.harvard.edu, linux-media@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2.1 1/2] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Tue, 29 Nov 2016 19:35:17 +0200
Message-ID: <1930557.lG90R1cLyV@avalon>
In-Reply-To: <1480440533-32685-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479594266-3034-2-git-send-email-sakari.ailus@linux.intel.com> <1480440533-32685-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 29 Nov 2016 19:28:53 Sakari Ailus wrote:
> Power on the sensor when the module is loaded and power it off when it is
> removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Alan and Laurent,
> 
> I hope this should be good then. I'm only enabling runtime PM at the end
> of probe() when all is well, which reduces need for error handling.
> 
> Regards,
> Sakari
> 
>  drivers/media/i2c/smiapp/smiapp-core.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 59872b3..683a3e0 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2741,8 +2741,6 @@ static const struct v4l2_subdev_internal_ops
> smiapp_internal_ops = { * I2C Driver
>   */
> 
> -#ifdef CONFIG_PM
> -
>  static int smiapp_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> @@ -2783,13 +2781,6 @@ static int smiapp_resume(struct device *dev)
>  	return rval;
>  }
> 
> -#else
> -
> -#define smiapp_suspend	NULL
> -#define smiapp_resume	NULL
> -
> -#endif /* CONFIG_PM */
> -
>  static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  {
>  	struct smiapp_hwconfig *hwcfg;
> @@ -2913,13 +2904,9 @@ static int smiapp_probe(struct i2c_client *client,
>  	if (IS_ERR(sensor->xshutdown))
>  		return PTR_ERR(sensor->xshutdown);
> 
> -	pm_runtime_enable(&client->dev);
> -
> -	rval = pm_runtime_get_sync(&client->dev);
> -	if (rval < 0) {
> -		rval = -ENODEV;
> -		goto out_power_off;
> -	}
> +	rval = smiapp_power_on(&client->dev);
> +	if (rval < 0)
> +		return rval;
> 
>  	rval = smiapp_identify_module(sensor);
>  	if (rval) {
> @@ -3100,6 +3087,9 @@ static int smiapp_probe(struct i2c_client *client,
>  	if (rval < 0)
>  		goto out_media_entity_cleanup;
> 
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_enable(&client->dev);
>  	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
>  	pm_runtime_use_autosuspend(&client->dev);
>  	pm_runtime_put_autosuspend(&client->dev);

This looks better to me, although these 6 lines really call for a new helper 
function.

However, I still believe a helper that calls the runtime PM handlers directly 
when CONFIG_PM=n and rely on runtime PM when CONFIG_PM=y would be the cleanest 
solution from a driver point of view.

> @@ -3113,8 +3103,7 @@ static int smiapp_probe(struct i2c_client *client,
>  	smiapp_cleanup(sensor);
> 
>  out_power_off:
> -	pm_runtime_put(&client->dev);
> -	pm_runtime_disable(&client->dev);
> +	smiapp_power_off(&client->dev);
> 
>  	return rval;
>  }
> @@ -3127,8 +3116,9 @@ static int smiapp_remove(struct i2c_client *client)
> 
>  	v4l2_async_unregister_subdev(subdev);
> 
> -	pm_runtime_suspend(&client->dev);
>  	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +	smiapp_power_off(&client->dev);

The device could be powered off already.

> 
>  	for (i = 0; i < sensor->ssds_used; i++) {
>  		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);

-- 
Regards,

Laurent Pinchart

