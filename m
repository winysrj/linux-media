Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3HUIaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:30:11 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MRV0060NGUV2670@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Aug 2013 09:30:09 +0100 (BST)
Message-id: <52147A8F.6010601@samsung.com>
Date: Wed, 21 Aug 2013 10:30:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2] mt9v032: Use the common clock framework
References: <1376047457-11512-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1376047457-11512-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/09/2013 01:24 PM, Laurent Pinchart wrote:
> Configure the device external clock using the common clock framework
> instead of a board code callback function.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks for the patch.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/i2c/mt9v032.c | 17 +++++++++++------
>  include/media/mt9v032.h     |  4 ----
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> Changes since v1:
> 
> - Set the pixel clock rate with clk_set_rate()
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 60c6f67..2c50eff 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -12,6 +12,7 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
> @@ -135,6 +136,8 @@ struct mt9v032 {
>  	struct mutex power_lock;
>  	int power_count;
>  
> +	struct clk *clk;
> +
>  	struct mt9v032_platform_data *pdata;
>  
>  	u32 sysclk;
> @@ -219,10 +222,9 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>  	int ret;
>  
> -	if (mt9v032->pdata->set_clock) {
> -		mt9v032->pdata->set_clock(&mt9v032->subdev, mt9v032->sysclk);
> -		udelay(1);
> -	}
> +	clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> +	clk_prepare_enable(mt9v032->clk);
> +	udelay(1);
>  
>  	/* Reset the chip and stop data read out */
>  	ret = mt9v032_write(client, MT9V032_RESET, 1);
> @@ -238,8 +240,7 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  
>  static void mt9v032_power_off(struct mt9v032 *mt9v032)
>  {
> -	if (mt9v032->pdata->set_clock)
> -		mt9v032->pdata->set_clock(&mt9v032->subdev, 0);
> +	clk_disable_unprepare(mt9v032->clk);
>  }
>  
>  static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
> @@ -748,6 +749,10 @@ static int mt9v032_probe(struct i2c_client *client,
>  	if (!mt9v032)
>  		return -ENOMEM;
>  
> +	mt9v032->clk = devm_clk_get(&client->dev, NULL);
> +	if (IS_ERR(mt9v032->clk))
> +		return PTR_ERR(mt9v032->clk);
> +
>  	mutex_init(&mt9v032->power_lock);
>  	mt9v032->pdata = pdata;
>  
> diff --git a/include/media/mt9v032.h b/include/media/mt9v032.h
> index 78fd39e..12175a6 100644
> --- a/include/media/mt9v032.h
> +++ b/include/media/mt9v032.h
> @@ -1,13 +1,9 @@
>  #ifndef _MEDIA_MT9V032_H
>  #define _MEDIA_MT9V032_H
>  
> -struct v4l2_subdev;
> -
>  struct mt9v032_platform_data {
>  	unsigned int clk_pol:1;
>  
> -	void (*set_clock)(struct v4l2_subdev *subdev, unsigned int rate);
> -
>  	const s64 *link_freqs;
>  	s64 link_def_freq;
>  };
> 

Regards,
-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
