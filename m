Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17096 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaC1Pa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 11:30:28 -0400
Message-id: <5335958B.80107@samsung.com>
Date: Fri, 28 Mar 2014 16:30:19 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com, Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC 1/8] leds: Add sysfs and kernel internal API for flash
 LEDs
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-2-git-send-email-j.anaszewski@samsung.com>
 <20140323231833.GA2054@valkosipuli.retiisi.org.uk>
In-reply-to: <20140323231833.GA2054@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 03/24/2014 12:18 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> Thanks for the patchset. It's very nice in general. I have a few comments
> below.

[...]

>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index 0287ab2..1bf0ab3 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -17,6 +17,14 @@
>>   #include <linux/rwsem.h>
>>   #include <linux/timer.h>
>>   #include <linux/workqueue.h>
>> +#include <linux/mutex.h>
>
> mutex.h should be earlier in the list of included files.
>
>> +#include <media/v4l2-device.h>
>> +
>> +#define LED_FAULT_OVER_VOLTAGE		(1 << 0)
>> +#define LED_FAULT_TIMEOUT		(1 << 1)
>> +#define LED_FAULT_OVER_TEMPERATURE	(1 << 2)
>> +#define LED_FAULT_SHORT_CIRCUIT		(1 << 3)
>> +#define LED_FAULT_OVER_CURRENT		(1 << 4)
>
> This patch went in to the media-tree some time ago. I wonder if the relevant
> bits should be added here now as well.
>
> commit 935aa6b2e8a911e81baecec0537dd7e478dc8c91
> Author: Daniel Jeong <gshark.jeong@gmail.com>
> Date:   Mon Mar 3 06:52:08 2014 -0300
>
>      [media] v4l2-controls.h: Add addtional Flash fault bits
>
>      Three Flash fault are added. V4L2_FLASH_FAULT_UNDER_VOLTAGE for the case low
>      voltage below the min. limit. V4L2_FLASH_FAULT_INPUT_VOLTAGE for the case
>      falling input voltage and chip adjust flash current not occur under voltage
>      event. V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE for the case the temperature
>      exceed the maximun limit
>
>      Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
>      Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>      Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

As it will not cause a build break and any runtime problems, even if
the patch is not merged, I added these bits to my implementation.

BTW I have doubts about V4L2_FLASH_FAULT_INDICATOR and 
V4L2_CID_FLASH_INDICATOR_INTENSITY control. I did not take them
into account in my implementation because it is not clear for
me how an indicator led is related to a torch led. There is
a control for setting indicator intensity but there is not
one for enabling it. Could you shed some light on this issue?

Regards,
Jacek Anaszewski

