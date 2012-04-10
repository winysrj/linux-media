Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759641Ab2DJXCV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 19:02:21 -0400
Message-ID: <4F84BBF0.2070208@redhat.com>
Date: Tue, 10 Apr 2012 20:02:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Convert I2C drivers to dev_pm_ops
References: <1332448493-31828-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1332448493-31828-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-03-2012 17:34, Mark Brown escreveu:
> The legacy I2C PM functions have been deprecated and warning on boot
> for over a year, convert the drivers still using them to dev_pm_ops.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Em 22-03-2012 17:39, Mark Brown escreveu:
> On Thu, Mar 22, 2012 at 08:34:53PM +0000, Mark Brown wrote:
> 
>> +		.pm	= msp3400_pm_ops,
> 
> Gah, missing &s - will resend tomorrow.


It is not just the missing & at msp3400:

drivers/media/video/msp3400-driver.c:869:2: error: ‘msp3400_suspend’ undeclared here (not in a function)
drivers/media/video/msp3400-driver.c:869:2: error: ‘msp3400_resume’ undeclared here (not in a function)
drivers/media/video/msp3400-driver.c:882:3: error: initializer element is not constant
drivers/media/video/msp3400-driver.c:882:3: error: (near initialization for ‘msp_driver.driver.pm’)
drivers/media/video/msp3400-driver.c:600:12: warning: ‘msp_suspend’ defined but not used [-Wunused-function]
drivers/media/video/msp3400-driver.c:608:12: warning: ‘msp_resume’ defined but not used [-Wunused-function]
drivers/media/video/tuner-core.c:1329:3: error: initializer element is not constant
drivers/media/video/tuner-core.c:1329:3: error: (near initialization for ‘tuner_driver.driver.pm’)

Please fix and re-send it.

Thanks!
mauro

> ---
>  drivers/media/video/msp3400-driver.c |   13 +++++++++----
>  drivers/media/video/tuner-core.c     |   13 +++++++++----
>  2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
> index 82ce507..0a55317 100644
> --- a/drivers/media/video/msp3400-driver.c
> +++ b/drivers/media/video/msp3400-driver.c
> @@ -597,15 +597,17 @@ static int msp_log_status(struct v4l2_subdev *sd)
>  	return 0;
>  }
>  
> -static int msp_suspend(struct i2c_client *client, pm_message_t state)
> +static int msp_suspend(struct device *dev)
>  {
> +	struct i2c_client *client = to_i2c_client(dev);
>  	v4l_dbg(1, msp_debug, client, "suspend\n");
>  	msp_reset(client);
>  	return 0;
>  }
>  
> -static int msp_resume(struct i2c_client *client)
> +static int msp_resume(struct device *dev)
>  {
> +	struct i2c_client *client = to_i2c_client(dev);
>  	v4l_dbg(1, msp_debug, client, "resume\n");
>  	msp_wake_thread(client);
>  	return 0;
> @@ -863,6 +865,10 @@ static int msp_remove(struct i2c_client *client)
>  
>  /* ----------------------------------------------------------------------- */
>  
> +static const struct dev_pm_ops msp3400_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(msp3400_suspend, msp3400_resume)
> +};
> +
>  static const struct i2c_device_id msp_id[] = {
>  	{ "msp3400", 0 },
>  	{ }
> @@ -873,11 +879,10 @@ static struct i2c_driver msp_driver = {
>  	.driver = {
>  		.owner	= THIS_MODULE,
>  		.name	= "msp3400",
> +		.pm	= msp3400_pm_ops,
>  	},
>  	.probe		= msp_probe,
>  	.remove		= msp_remove,
> -	.suspend	= msp_suspend,
> -	.resume		= msp_resume,
>  	.id_table	= msp_id,
>  };
>  
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index a5c6397..d3de74f 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -1241,8 +1241,9 @@ static int tuner_log_status(struct v4l2_subdev *sd)
>  	return 0;
>  }
>  
> -static int tuner_suspend(struct i2c_client *c, pm_message_t state)
> +static int tuner_suspend(struct device *dev)
>  {
> +	struct i2c_client *c = to_i2c_client(dev);
>  	struct tuner *t = to_tuner(i2c_get_clientdata(c));
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>  
> @@ -1254,8 +1255,9 @@ static int tuner_suspend(struct i2c_client *c, pm_message_t state)
>  	return 0;
>  }
>  
> -static int tuner_resume(struct i2c_client *c)
> +static int tuner_resume(struct device *dev)
>  {
> +	struct i2c_client *c = to_i2c_client(dev);
>  	struct tuner *t = to_tuner(i2c_get_clientdata(c));
>  
>  	tuner_dbg("resume\n");
> @@ -1310,6 +1312,10 @@ static const struct v4l2_subdev_ops tuner_ops = {
>   * I2C structs and module init functions
>   */
>  
> +static const struct dev_pm_ops tuner_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(tuner_suspend, tuner_resume)
> +};
> +
>  static const struct i2c_device_id tuner_id[] = {
>  	{ "tuner", }, /* autodetect */
>  	{ }
> @@ -1320,12 +1326,11 @@ static struct i2c_driver tuner_driver = {
>  	.driver = {
>  		.owner	= THIS_MODULE,
>  		.name	= "tuner",
> +		.pm	= tuner_pm_ops,
>  	},
>  	.probe		= tuner_probe,
>  	.remove		= tuner_remove,
>  	.command	= tuner_command,
> -	.suspend	= tuner_suspend,
> -	.resume		= tuner_resume,
>  	.id_table	= tuner_id,
>  };
>  

