Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:58952 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729105AbeKVXN7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 18:13:59 -0500
Subject: Re: [PATCH] media: video-i2c: don't use msleep for 1ms - 20ms
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1542727660-14117-1-git-send-email-akinobu.mita@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e2f8fcf-ffef-4136-5866-f1a6d55f3961@xs4all.nl>
Date: Thu, 22 Nov 2018 13:34:46 +0100
MIME-Version: 1.0
In-Reply-To: <1542727660-14117-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2018 04:27 PM, Akinobu Mita wrote:
> Documentation/timers/timers-howto.txt says:
> 
> "msleep(1~20) may not do what the caller intends, and will often sleep
> longer (~20 ms actual sleep for any value given in the 1~20ms range)."
> 
> So replace msleep(2) by usleep_range(2000, 3000).

Please just repost patch 6/6 with this change merged in.

Thanks!

	Hans

> 
> Reported-by: Hans Verkuil <hansverk@cisco.com>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> This fixes "[PATCH v4 6/6] media: video-i2c: support runtime PM" in the
> patchset "[PATCH v4 0/6] media: video-i2c: support changing frame interval
> and runtime PM".
> 
>  drivers/media/i2c/video-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index 0c82131..77080d7 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -155,7 +155,7 @@ static int amg88xx_set_power_on(struct video_i2c_data *data)
>  	if (ret)
>  		return ret;
>  
> -	msleep(2);
> +	usleep_range(2000, 3000);
>  
>  	ret = regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_FLAG);
>  	if (ret)
> 
