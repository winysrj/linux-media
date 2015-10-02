Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60688 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbJBKKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 06:10:55 -0400
Message-id: <560E582B.2050304@samsung.com>
Date: Fri, 02 Oct 2015 12:10:51 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] v4l2-flash-led-class: Add missing VIDEO_V4L2 Kconfig
 dependency
References: <1443777555-6710-1-git-send-email-j.anaszewski@samsung.com>
 <20151002094141.GG26916@valkosipuli.retiisi.org.uk>
In-reply-to: <20151002094141.GG26916@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/02/2015 11:41 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Oct 02, 2015 at 11:19:15AM +0200, Jacek Anaszewski wrote:
>> Fixes the following randconfig problem:
>>
>> drivers/built-in.o: In function `v4l2_flash_release':
>> (.text+0x12204f): undefined reference to `v4l2_async_unregister_subdev'
>> drivers/built-in.o: In function `v4l2_flash_release':
>> (.text+0x122057): undefined reference to `v4l2_ctrl_handler_free'
>> drivers/built-in.o: In function `v4l2_flash_close':
>> v4l2-flash-led-class.c:(.text+0x12208f): undefined reference to `v4l2_fh_is_singular'
>> v4l2-flash-led-class.c:(.text+0x1220c8): undefined reference to `__v4l2_ctrl_s_ctrl'
>> drivers/built-in.o: In function `v4l2_flash_open':
>> v4l2-flash-led-class.c:(.text+0x12227f): undefined reference to `v4l2_fh_is_singular'
>> drivers/built-in.o: In function `v4l2_flash_init_controls':
>> v4l2-flash-led-class.c:(.text+0x12274e): undefined reference to `v4l2_ctrl_handler_init_class'
>> v4l2-flash-led-class.c:(.text+0x122797): undefined reference to `v4l2_ctrl_new_std_menu'
>> v4l2-flash-led-class.c:(.text+0x1227e0): undefined reference to `v4l2_ctrl_new_std'
>> v4l2-flash-led-class.c:(.text+0x122826): undefined reference to `v4l2_ctrl_handler_setup'
>> v4l2-flash-led-class.c:(.text+0x122839): undefined reference to `v4l2_ctrl_handler_free'
>> drivers/built-in.o: In function `v4l2_flash_init':
>> (.text+0x1228e2): undefined reference to `v4l2_subdev_init'
>> drivers/built-in.o: In function `v4l2_flash_init':
>> (.text+0x12293b): undefined reference to `v4l2_async_register_subdev'
>> drivers/built-in.o: In function `v4l2_flash_init':
>> (.text+0x122949): undefined reference to `v4l2_ctrl_handler_free'
>> drivers/built-in.o:(.rodata+0x20ef8): undefined reference to `v4l2_subdev_queryctrl'
>> drivers/built-in.o:(.rodata+0x20f10): undefined reference to `v4l2_subdev_querymenu'
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/v4l2-core/Kconfig |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
>> index 82876a6..9beece0 100644
>> --- a/drivers/media/v4l2-core/Kconfig
>> +++ b/drivers/media/v4l2-core/Kconfig
>> @@ -47,7 +47,7 @@ config V4L2_MEM2MEM_DEV
>>   # Used by LED subsystem flash drivers
>>   config V4L2_FLASH_LED_CLASS
>>   	tristate "V4L2 flash API for LED flash class devices"
>> -	depends on VIDEO_V4L2_SUBDEV_API
>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>   	depends on LEDS_CLASS_FLASH
>>   	---help---
>>   	  Say Y here to enable V4L2 flash API support for LED flash
>
> Hmm. I wonder if VIDEO_V4L2_SUBDEV_API itself should depend on VIDEO_V4L2.
>
> That'd be logical, I don't think VIDEO_V4L2_SUBDEV_API could be meaningfully
> used with VIDEO_V4L2 disabled. The API implementation is in v4l2-subdev.c
> which itself depends on VIDEO_V4L2.
>
> Oddly enough, VIDEO_V4L2_SUBDEV_API is currently defined in
> drivers/media/Kconfig, it should probably be in
> drivers/media/v4l2-core/Kconfig instead.
>

Since I don't see any Makefile referring to this symbol, it seems that
moving it to drivers/media/v4l2-core/Kconfig and adding VIDEO_V4L2
dependency should be non-problematic operation. I can submit relevant
patch if everyone agrees.

-- 
Best Regards,
Jacek Anaszewski
