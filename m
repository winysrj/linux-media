Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51200 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbbCROgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 10:36:09 -0400
Message-id: <55098D55.6050101@samsung.com>
Date: Wed, 18 Mar 2015 15:36:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, cooloney@gmail.com
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v13 10/13] Documentation: leds: Add description of
 v4l2-flash sub-device
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
 <1426175114-14876-11-git-send-email-j.anaszewski@samsung.com>
 <20150318123957.GH11954@valkosipuli.retiisi.org.uk>
In-reply-to: <20150318123957.GH11954@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/18/2015 01:39 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Mar 12, 2015 at 04:45:11PM +0100, Jacek Anaszewski wrote:
>> This patch extends LED Flash class documention by
>> the description of interactions with v4l2-flash sub-device.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   Documentation/leds/leds-class-flash.txt |   13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
>> index 19bb673..8623413 100644
>> --- a/Documentation/leds/leds-class-flash.txt
>> +++ b/Documentation/leds/leds-class-flash.txt
>> @@ -20,3 +20,16 @@ Following sysfs attributes are exposed for controlling flash LED devices:
>>   	- max_flash_timeout
>>   	- flash_strobe
>>   	- flash_fault
>> +
>> +A LED subsystem driver can be controlled also from the level of VideoForLinux2
>> +subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
>> +be defined in the kernel config. The driver must call the v4l2_flash_init
>> +function to get registered in the V4L2 subsystem. On remove the
>> +v4l2_flash_release function has to be called (see <media/v4l2-flash.h>).
>> +
>> +After proper initialization a V4L2 Flash sub-device is created. The sub-device
>> +exposes a number of V4L2 controls, which allow for controlling a LED Flash class
>
> Over 80 characters per line.

This line has exactly 80 characters, probably you checked the
length in the patch, which includes leading '+' character.

>
> With this fixed,
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Probably I inadvertently changed the Acked-by email.
Bryan, please apply the patch with:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>
>> +device with use of its internal kernel API.
>> +Opening the V4L2 Flash sub-device makes the LED subsystem sysfs interface
>> +unavailable. The interface is re-enabled after the V4L2 Flash sub-device
>> +is closed.
>


-- 
Best Regards,
Jacek Anaszewski
