Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47495 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757885AbZLIUrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 15:47:41 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 3/3] radio-si470x: support PM functions
Date: Wed, 9 Dec 2009 21:47:32 +0100
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
References: <4B17B5B9.6070409@samsung.com>
In-Reply-To: <4B17B5B9.6070409@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912092147.32915.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the same here. I'm unable to test it, but it compiles cleanly.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

Am Donnerstag 03 Dezember 2009 13:57:29 schrieb Joonyoung Shim:
> This patch is to support PM of the si470x i2c driver.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/media/radio/si470x/radio-si470x-i2c.c |   40 +++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
> index 77532e6..4c6e586 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -486,6 +486,44 @@ static __devexit int si470x_i2c_remove(struct i2c_client *client)
>  }
>  
>  
> +#ifdef CONFIG_PM
> +/*
> + * si470x_i2c_suspend - suspend the device
> + */
> +static int si470x_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct si470x_device *radio = i2c_get_clientdata(client);
> +
> +	/* power down */
> +	radio->registers[POWERCFG] |= POWERCFG_DISABLE;
> +	if (si470x_set_register(radio, POWERCFG) < 0)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * si470x_i2c_resume - resume the device
> + */
> +static int si470x_i2c_resume(struct i2c_client *client)
> +{
> +	struct si470x_device *radio = i2c_get_clientdata(client);
> +
> +	/* power up : need 110ms */
> +	radio->registers[POWERCFG] |= POWERCFG_ENABLE;
> +	if (si470x_set_register(radio, POWERCFG) < 0)
> +		return -EIO;
> +	msleep(110);
> +
> +	return 0;
> +}
> +#else
> +#define si470x_i2c_suspend	NULL
> +#define si470x_i2c_resume	NULL
> +#endif
> +
> +
>  /*
>   * si470x_i2c_driver - i2c driver interface
>   */
> @@ -496,6 +534,8 @@ static struct i2c_driver si470x_i2c_driver = {
>  	},
>  	.probe			= si470x_i2c_probe,
>  	.remove			= __devexit_p(si470x_i2c_remove),
> +	.suspend		= si470x_i2c_suspend,
> +	.resume			= si470x_i2c_resume,
>  	.id_table		= si470x_i2c_id,
>  };
>  
> 
