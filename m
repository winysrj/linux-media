Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55272 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752828AbeAIKNf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 05:13:35 -0500
Date: Tue, 9 Jan 2018 12:13:31 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: ov7740: add media-controller dependency
Message-ID: <20180109101330.wjj4hpjvbdiufi5f@paasikivi.fi.intel.com>
References: <20180108125322.3993808-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180108125322.3993808-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Mon, Jan 08, 2018 at 01:52:28PM +0100, Arnd Bergmann wrote:
> Without CONFIG_MEDIA_CONTROLLER, the new driver fails to build:
> 
> drivers/perf/arm_dsu_pmu.c: In function 'dsu_pmu_probe_pmu':
> drivers/perf/arm_dsu_pmu.c:661:2: error: implicit declaration of function 'bitmap_from_u32array'; did you mean 'bitmap_from_arr32'? [-Werror=implicit-function-declaration]

There seems to be a build error with this driver if Media controller is
disabled, but this is not the error message nor adding a dependency to
Media controller is a sound fix for it.

drivers/media/i2c/ov7740.c: In function ‘ov7740_probe’:
drivers/media/i2c/ov7740.c:1139:38: error: ‘struct v4l2_subdev’ has no member named ‘entity’
  media_entity_cleanup(&ov7740->subdev.entity);

I think it'd be worth adding nop variants for functions that are commonly
used by drivers that can be built with or without the Media controller.

I'll send a patch.

> 
> This adds a dependency similar to what we have for other drivers
> like this.
> 
> Fixes: 39c5c4471b8d ("media: i2c: Add the ov7740 image sensor driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/i2c/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 9f18cd296841..03cf3a1a1e06 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -667,7 +667,7 @@ config VIDEO_OV7670
>  
>  config VIDEO_OV7740
>  	tristate "OmniVision OV7740 sensor support"
> -	depends on I2C && VIDEO_V4L2
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>  	depends on MEDIA_CAMERA_SUPPORT
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
