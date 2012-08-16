Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60526 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754671Ab2HPQ5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 12:57:01 -0400
Date: Thu, 16 Aug 2012 19:56:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH] smiapp: Use devm_kzalloc() in smiapp-core.c file
Message-ID: <20120816165656.GB29636@valkosipuli.retiisi.org.uk>
References: <1345116570-27335-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345116570-27335-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch.

On Thu, Aug 16, 2012 at 04:59:30PM +0530, Sachin Kamat wrote:
> devm_kzalloc is a device managed function and makes code a bit
> smaller and cleaner.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> This patch is based on Mauro's re-organized tree
> (media_tree staging/for_v3.7) and is compile tested.
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 1cf914d..7d4280e 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2801,12 +2801,11 @@ static int smiapp_probe(struct i2c_client *client,
>  			const struct i2c_device_id *devid)
>  {
>  	struct smiapp_sensor *sensor;
> -	int rval;
>  
>  	if (client->dev.platform_data == NULL)
>  		return -ENODEV;
>  
> -	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
> +	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
>  	if (sensor == NULL)
>  		return -ENOMEM;
>  

I think the same should be done to sensor->nvm. Would you like to change the
patch to incorporate the change? I'm fine doing that as well.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
