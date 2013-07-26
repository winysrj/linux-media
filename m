Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43849 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab3GZNLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 09:11:13 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so1112279bkc.6
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 06:11:12 -0700 (PDT)
Message-ID: <51F2756C.70507@gmail.com>
Date: Fri, 26 Jul 2013 15:11:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] mt9v032: Use the common clock framework
References: <1373021725-14006-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1373021725-14006-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/05/2013 12:55 PM, Laurent Pinchart wrote:
> Configure the device external clock using the common clock framework
> instead of a board code callback function.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/i2c/mt9v032.c | 16 ++++++++++------
>   include/media/mt9v032.h     |  4 ----
>   2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 60c6f67..7b30640 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -12,6 +12,7 @@
>    * published by the Free Software Foundation.
>    */
>
> +#include<linux/clk.h>
>   #include<linux/delay.h>
>   #include<linux/i2c.h>
>   #include<linux/log2.h>
> @@ -135,6 +136,8 @@ struct mt9v032 {
>   	struct mutex power_lock;
>   	int power_count;
>
> +	struct clk *clk;
> +
>   	struct mt9v032_platform_data *pdata;
>
>   	u32 sysclk;
> @@ -219,10 +222,8 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>   	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>   	int ret;
>
> -	if (mt9v032->pdata->set_clock) {
> -		mt9v032->pdata->set_clock(&mt9v032->subdev, mt9v032->sysclk);
> -		udelay(1);
> -	}
> +	clk_prepare_enable(mt9v032->clk);
> +	udelay(1);
>
>   	/* Reset the chip and stop data read out */
>   	ret = mt9v032_write(client, MT9V032_RESET, 1);
> @@ -238,8 +239,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>
>   static void mt9v032_power_off(struct mt9v032 *mt9v032)
>   {
> -	if (mt9v032->pdata->set_clock)
> -		mt9v032->pdata->set_clock(&mt9v032->subdev, 0);
> +	clk_disable_unprepare(mt9v032->clk);
>   }
>
>   static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
> @@ -748,6 +748,10 @@ static int mt9v032_probe(struct i2c_client *client,
>   	if (!mt9v032)
>   		return -ENOMEM;
>
> +	mt9v032->clk = devm_clk_get(&client->dev, NULL);
> +	if (IS_ERR(mt9v032->clk))
> +		return PTR_ERR(mt9v032->clk);
> +
>   	mutex_init(&mt9v032->power_lock);
>   	mt9v032->pdata = pdata;
>
> diff --git a/include/media/mt9v032.h b/include/media/mt9v032.h
> index 78fd39e..12175a6 100644
> --- a/include/media/mt9v032.h
> +++ b/include/media/mt9v032.h
> @@ -1,13 +1,9 @@
>   #ifndef _MEDIA_MT9V032_H
>   #define _MEDIA_MT9V032_H
>
> -struct v4l2_subdev;
> -
>   struct mt9v032_platform_data {
>   	unsigned int clk_pol:1;
>
> -	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int rate);
> -
>   	const s64 *link_freqs;
>   	s64 link_def_freq;
>   };

Is there clk_put() somewhere in this patch ? I would expect it somewhere
around driver remove() callback, but can't see it. :-/

Regards,
Sylwester
