Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55514 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbeAII7O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 03:59:14 -0500
Subject: Re: [PATCH] media: i2c: ov7740: add media-controller dependency
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20180108125322.3993808-1-arnd@arndb.de>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <77115583-f54e-54b4-e0db-6019bab14099@Microchip.com>
Date: Tue, 9 Jan 2018 16:59:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180108125322.3993808-1-arnd@arndb.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Arnd,


On 2018/1/8 20:52, Arnd Bergmann wrote:
> Without CONFIG_MEDIA_CONTROLLER, the new driver fails to build:
>
> drivers/perf/arm_dsu_pmu.c: In function 'dsu_pmu_probe_pmu':
> drivers/perf/arm_dsu_pmu.c:661:2: error: implicit declaration of function 'bitmap_from_u32array'; did you mean 'bitmap_from_arr32'? [-Werror=implicit-function-declaration]
>
> This adds a dependency similar to what we have for other drivers
> like this.
>
> Fixes: 39c5c4471b8d ("media: i2c: Add the ov7740 image sensor driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
Indeed.
Thank you for your fix.

Acked-by: Wenyou Yang <wenyou.yang@microchip.com>

>   drivers/media/i2c/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 9f18cd296841..03cf3a1a1e06 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -667,7 +667,7 @@ config VIDEO_OV7670
>   
>   config VIDEO_OV7740
>   	tristate "OmniVision OV7740 sensor support"
> -	depends on I2C && VIDEO_V4L2
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>   	depends on MEDIA_CAMERA_SUPPORT
>   	---help---
>   	  This is a Video4Linux2 sensor-level driver for the OmniVision

Best Regards,
Wenyou Yang
