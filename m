Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58678 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2KPGzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 01:55:15 -0500
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDK00A56J8Q2E10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Nov 2012 06:55:38 +0000 (GMT)
Received: from [106.116.147.108] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MDK005JFJ808P20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Nov 2012 06:55:13 +0000 (GMT)
Message-id: <50A5E350.6010209@samsung.com>
Date: Fri, 16 Nov 2012 07:55:12 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	sylvester.nawrocki@gmail.com, s.nawrocki@samsung.com
Subject: Re: [PATCH 1/1] [media] s5p-tv: Use devm_gpio_request in sii9234_drv.c
References: <1353041728-11032-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353041728-11032-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2012 05:55 AM, Sachin Kamat wrote:
> devm_gpio_request is a device managed function and will make
> error handling and cleanup a bit simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

> ---
>  drivers/media/platform/s5p-tv/sii9234_drv.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
> index 716d484..4597342 100644
> --- a/drivers/media/platform/s5p-tv/sii9234_drv.c
> +++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
> @@ -338,7 +338,7 @@ static int __devinit sii9234_probe(struct i2c_client *client,
>  	}
>  
>  	ctx->gpio_n_reset = pdata->gpio_n_reset;
> -	ret = gpio_request(ctx->gpio_n_reset, "MHL_RST");
> +	ret = devm_gpio_request(dev, ctx->gpio_n_reset, "MHL_RST");
>  	if (ret) {
>  		dev_err(dev, "failed to acquire MHL_RST gpio\n");
>  		return ret;
> @@ -370,7 +370,6 @@ fail_pm_get:
>  
>  fail_pm:
>  	pm_runtime_disable(dev);
> -	gpio_free(ctx->gpio_n_reset);
>  
>  fail:
>  	dev_err(dev, "probe failed\n");
> @@ -381,11 +380,8 @@ fail:
>  static int __devexit sii9234_remove(struct i2c_client *client)
>  {
>  	struct device *dev = &client->dev;
> -	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> -	struct sii9234_context *ctx = sd_to_context(sd);
>  
>  	pm_runtime_disable(dev);
> -	gpio_free(ctx->gpio_n_reset);
>  
>  	dev_info(dev, "remove successful\n");
>  
> 

