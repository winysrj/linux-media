Return-path: <mchehab@pedra>
Received: from gateway04.websitewelcome.com ([69.93.154.2]:58093 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751262Ab0JGQjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 12:39:46 -0400
Subject: Re: [PATCH 03/16] go7007: Add MODULE_DEVICE_TABLE to the go7007
 I2C modules
From: Pete Eberlein <pete@sensoray.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1285337654-5044-4-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1285337654-5044-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:33:06 -0700
Message-ID: <1286469186.2477.9.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Pete Eberlein <pete@sensoray.com>

On Fri, 2010-09-24 at 16:14 +0200, Laurent Pinchart wrote:
> The device table is required to load modules based on modaliases.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/staging/go7007/wis-ov7640.c     |    1 +
>  drivers/staging/go7007/wis-saa7113.c    |    1 +
>  drivers/staging/go7007/wis-saa7115.c    |    1 +
>  drivers/staging/go7007/wis-sony-tuner.c |    1 +
>  drivers/staging/go7007/wis-tw2804.c     |    1 +
>  drivers/staging/go7007/wis-tw9903.c     |    1 +
>  drivers/staging/go7007/wis-uda1342.c    |    1 +
>  7 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/go7007/wis-ov7640.c b/drivers/staging/go7007/wis-ov7640.c
> index 4f0cbdd..6bc9470 100644
> --- a/drivers/staging/go7007/wis-ov7640.c
> +++ b/drivers/staging/go7007/wis-ov7640.c
> @@ -81,6 +81,7 @@ static const struct i2c_device_id wis_ov7640_id[] = {
>  	{ "wis_ov7640", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_ov7640_id);
>  
>  static struct i2c_driver wis_ov7640_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-saa7113.c b/drivers/staging/go7007/wis-saa7113.c
> index 72f5c1f..05e0e10 100644
> --- a/drivers/staging/go7007/wis-saa7113.c
> +++ b/drivers/staging/go7007/wis-saa7113.c
> @@ -308,6 +308,7 @@ static const struct i2c_device_id wis_saa7113_id[] = {
>  	{ "wis_saa7113", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_saa7113_id);
>  
>  static struct i2c_driver wis_saa7113_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-saa7115.c b/drivers/staging/go7007/wis-saa7115.c
> index cd950b6..46cff59 100644
> --- a/drivers/staging/go7007/wis-saa7115.c
> +++ b/drivers/staging/go7007/wis-saa7115.c
> @@ -441,6 +441,7 @@ static const struct i2c_device_id wis_saa7115_id[] = {
>  	{ "wis_saa7115", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_saa7115_id);
>  
>  static struct i2c_driver wis_saa7115_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/go7007/wis-sony-tuner.c
> index 981c9b3..8f1b7d4 100644
> --- a/drivers/staging/go7007/wis-sony-tuner.c
> +++ b/drivers/staging/go7007/wis-sony-tuner.c
> @@ -692,6 +692,7 @@ static const struct i2c_device_id wis_sony_tuner_id[] = {
>  	{ "wis_sony_tuner", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_sony_tuner_id);
>  
>  static struct i2c_driver wis_sony_tuner_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-tw2804.c b/drivers/staging/go7007/wis-tw2804.c
> index ee28a99..5b218c5 100644
> --- a/drivers/staging/go7007/wis-tw2804.c
> +++ b/drivers/staging/go7007/wis-tw2804.c
> @@ -331,6 +331,7 @@ static const struct i2c_device_id wis_tw2804_id[] = {
>  	{ "wis_tw2804", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_tw2804_id);
>  
>  static struct i2c_driver wis_tw2804_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-tw9903.c b/drivers/staging/go7007/wis-tw9903.c
> index 80d4726..9230f4a 100644
> --- a/drivers/staging/go7007/wis-tw9903.c
> +++ b/drivers/staging/go7007/wis-tw9903.c
> @@ -313,6 +313,7 @@ static const struct i2c_device_id wis_tw9903_id[] = {
>  	{ "wis_tw9903", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_tw9903_id);
>  
>  static struct i2c_driver wis_tw9903_driver = {
>  	.driver = {
> diff --git a/drivers/staging/go7007/wis-uda1342.c b/drivers/staging/go7007/wis-uda1342.c
> index 5c4eb49..0127be2 100644
> --- a/drivers/staging/go7007/wis-uda1342.c
> +++ b/drivers/staging/go7007/wis-uda1342.c
> @@ -86,6 +86,7 @@ static const struct i2c_device_id wis_uda1342_id[] = {
>  	{ "wis_uda1342", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, wis_uda1342_id);
>  
>  static struct i2c_driver wis_uda1342_driver = {
>  	.driver = {


