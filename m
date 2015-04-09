Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43268 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbbDIG0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 02:26:05 -0400
Message-ID: <55261B75.1070400@xs4all.nl>
Date: Thu, 09 Apr 2015 08:25:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [git:media_tree/master] [media] Add device tree support to adp1653
 flash driver
References: <E1Yg11T-00074E-Hx@www.linuxtv.org>
In-Reply-To: <E1Yg11T-00074E-Hx@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

This driver doesn't compile:

On 04/08/2015 10:46 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> 
> Subject: [media] Add device tree support to adp1653 flash driver
> Author:  Pavel Machek <pavel@ucw.cz>
> Date:    Fri Mar 13 17:48:40 2015 -0300
> 
> Nokia N900 is switching to device tree, make sure we can use flash
> there, too.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
>  .../devicetree/bindings/media/i2c/adp1653.txt      |   37 ++++++++
>  drivers/media/i2c/adp1653.c                        |   90 ++++++++++++++++++--
>  2 files changed, 118 insertions(+), 9 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=b6100f10bdc2019a65297d2597c388de2f7dd653
> 
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 873fe19..0341009 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -306,9 +309,17 @@ adp1653_init_device(struct adp1653_flash *flash)
>  static int
>  __adp1653_set_power(struct adp1653_flash *flash, int on)
>  {
> -	int ret;
> +	int ret = 0;
> +
> +	if (flash->platform_data->power) {
> +		ret = flash->platform_data->power(&flash->subdev, on);
> +	} else {
> +		gpio_set_value(flash->platform_data->power_gpio, on);

The power_gpio field is not found in struct adp1653_platform_data.

Can you fix this?

I'm also getting this warning:

adp1653.c:433:6: warning: unused variable 'gpio' [-Wunused-variable]
  int gpio;
      ^

Please fix that as well.

Strange, this patch seems to have been merged without anyone compiling it first.

Regards,

	Hans

> +		if (on)
> +			/* Some delay is apparently required. */
> +			udelay(20);
> +	}
>  
> -	ret = flash->platform_data->power(&flash->subdev, on);
>  	if (ret < 0)
>  		return ret;
>  

