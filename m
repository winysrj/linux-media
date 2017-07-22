Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37452 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdGVShA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 14:37:00 -0400
Received: by mail-pf0-f194.google.com with SMTP id d18so7252064pfe.4
        for <linux-media@vger.kernel.org>; Sat, 22 Jul 2017 11:36:59 -0700 (PDT)
Subject: Re: [PATCH] [media] ov5640: Remove unneeded gpiod NULL check
To: Fabio Estevam <festevam@gmail.com>, hans.verkuil@cisco.com
Cc: mchehab@s-opensource.com, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
References: <1500518480-3568-1-git-send-email-festevam@gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5f3d3df7-f193-8b52-c255-8bdc41c0ca3e@gmail.com>
Date: Sat, 22 Jul 2017 11:36:55 -0700
MIME-Version: 1.0
In-Reply-To: <1500518480-3568-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

On 07/19/2017 07:41 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> The gpiod API checks for NULL descriptors, so there is no need to
> duplicate the check in the driver.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
>   drivers/media/i2c/ov5640.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 1f5b483..39a2269 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1524,8 +1524,7 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
>   
>   static void ov5640_power(struct ov5640_dev *sensor, bool enable)
>   {
> -	if (sensor->pwdn_gpio)
> -		gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
> +	gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
>   }
>   
>   static void ov5640_reset(struct ov5640_dev *sensor)
> 
