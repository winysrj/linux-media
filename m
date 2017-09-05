Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6434 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752017AbdIEUSN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 16:18:13 -0400
Subject: Re: [PATCH] media: leds: as3645a: add V4L2_FLASH_LED_CLASS
 depdendency
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20170905071345.3807685-1-arnd@arndb.de>
 <ffbecf66-df9d-d8cf-8820-a119c76d8145@gmail.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <737270d1-98df-a207-7137-cdf2cce950c8@linux.intel.com>
Date: Tue, 5 Sep 2017 23:18:07 +0300
MIME-Version: 1.0
In-Reply-To: <ffbecf66-df9d-d8cf-8820-a119c76d8145@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek and Arnd,

Thanks for fixing this plus the ack! I chatted with Mauro, and as the 
patches are still only in mediatree, we'll apply this there, possibly 
with a minor spelling fix to the subject (depdendency -> dependency).

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=as3645a-fix2>

Cc linux-media.

Jacek Anaszewski wrote:
> Hi Arnd,
>
> Thanks for the patch.
>
> On 09/05/2017 09:13 AM, Arnd Bergmann wrote:
>> We get a link error when V4L2_FLASH_LED_CLASS=m and AS3645A is built-in:
>>
>> drivers/leds/leds-as3645a.o: In function `as3645a_v4l2_setup':
>> leds-as3645a.c:(.text+0x258): undefined reference to `v4l2_flash_init'
>> leds-as3645a.c:(.text+0x284): undefined reference to `v4l2_flash_indicator_init'
>> leds-as3645a.c:(.text+0x2a4): undefined reference to `v4l2_flash_release'
>> drivers/leds/leds-as3645a.o: In function `as3645a_remove':
>> leds-as3645a.c:(.text+0x784): undefined reference to `v4l2_flash_release'
>>
>> This adds the same Kconfig dependency that the other V4L2 flash
>> drivers in drivers/leds use, to avoid that broken configuration.
>>
>> Fixes: a56ba8fbcb55 ("media: leds: as3645a: Add LED flash class driver")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/leds/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> The patch that caused the problem is currently in the v4l git tree,
>> rather than the leds tree. Please merge this through an appropriate
>> path, either v4l or led, depending on the timing.
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 0bf022bcb6ac..52ea34e337cd 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -61,6 +61,7 @@ config LEDS_AAT1290
>>  config LEDS_AS3645A
>>  	tristate "AS3645A LED flash controller support"
>>  	depends on I2C && LEDS_CLASS_FLASH
>> +	depends on V4L2_FLASH_LED_CLASS || !V4L2_FLASH_LED_CLASS
>>  	help
>>  	  Enable LED flash class support for AS3645A LED flash
>>  	  controller. V4L2 flash API is provided as well if
>>
>
> Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
