Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:59532 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcKRQJI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 11:09:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Fri, 18 Nov 2016 17:09:01 +0100
Message-ID: <3365592.8lQdWk1zFY@wuerfel>
In-Reply-To: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 18, 2016 3:50:16 PM CET Sakari Ailus wrote:
> Power on the sensor when the module is loaded and power it off when it is
> removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Arnd and others,
> 
> The patch is tested with CONFIG_PM set, as the system does I was testing
> on did not boot with CONFIG_PM disabled. I'm not really too worried about
> this though, the patch is very simple.
> 


>  static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
>  {
>  	struct smiapp_hwconfig *hwcfg;
> @@ -2915,7 +2906,11 @@ static int smiapp_probe(struct i2c_client *client,
>  
>  	pm_runtime_enable(&client->dev);
>  
> +#ifdef CONFIG_PM
>  	rval = pm_runtime_get_sync(&client->dev);
> +#else
> +	rval = smiapp_power_on(&client->dev);
> +#endif
>  	if (rval < 0) {
>  		rval = -ENODEV;
>  		goto out_power_off;

I would suggest writing this as

	if (IS_ENABLED(CONFIG_PM))
		rval = pm_runtime_get_sync(&client->dev);
	else
		rval = smiapp_power_on(&client->dev);

though that is a purely cosmetic change.

I think you are missing one other warning: with CONFIG_PM=y and
CONFIG_PM_SLEEP=n, the smiapp_suspend/smiapp_resume functions
are now unused and need to be marked as __maybe_unused.

	Arnd
