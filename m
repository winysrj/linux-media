Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:60439 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbcFQWrC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 18:47:02 -0400
Subject: Re: [PATCH 12/12] leds: Only descend into leds directory when
 CONFIG_NEW_LEDS is set
To: Jacek Anaszewski <j.anaszewski@samsung.com>
References: <20160613200211.14790-1-afd@ti.com>
 <20160613200211.14790-13-afd@ti.com> <5760FA52.7010806@samsung.com>
CC: Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, <linux-pwm@vger.kernel.org>,
	<lguest@lists.ozlabs.org>, <linux-wireless@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-leds@vger.kernel.org>,
	<linux-media@vger.kernel.org>
From: "Andrew F. Davis" <afd@ti.com>
Message-ID: <57647DBD.2010406@ti.com>
Date: Fri, 17 Jun 2016 17:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <5760FA52.7010806@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 01:48 AM, Jacek Anaszewski wrote:
> Hi Andrew,
> 
> Thanks for the patch.
> 
> Please address the issue [1] raised by test bot and resubmit.
> 
> Thanks,
> Jacek Anaszewski
> 
> [1] https://lkml.org/lkml/2016/6/13/1091
> 

It looks like some systems use 'gpio_led_register_device' to make an
in-memory copy of their LED device table so the original can be removed
as .init.rodata. This doesn't necessarily depend on the LED subsystem
but it kind of seems useless when the rest of the subsystem is disabled.

One solution could be to use a dummy 'gpio_led_register_device' when the
subsystem is not enabled. Another is just to remove the five or so uses
of 'gpio_led_register_device' and have those systems register LED device
tables like other systems do.

If nether of these are acceptable then this patch can be dropped from
this series for now.

Thanks,
Andrew

> On 06/13/2016 10:02 PM, Andrew F. Davis wrote:
>> When CONFIG_NEW_LEDS is not set make will still descend into the leds
>> directory but nothing will be built. This produces unneeded build
>> artifacts and messages in addition to slowing the build. Fix this here.
>>
>> Signed-off-by: Andrew F. Davis <afd@ti.com>
>> ---
>>   drivers/Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 567e32c..fa514d5 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -127,7 +127,7 @@ obj-$(CONFIG_CPU_FREQ)        += cpufreq/
>>   obj-$(CONFIG_CPU_IDLE)        += cpuidle/
>>   obj-$(CONFIG_MMC)        += mmc/
>>   obj-$(CONFIG_MEMSTICK)        += memstick/
>> -obj-y                += leds/
>> +obj-$(CONFIG_NEW_LEDS)        += leds/
>>   obj-$(CONFIG_INFINIBAND)    += infiniband/
>>   obj-$(CONFIG_SGI_SN)        += sn/
>>   obj-y                += firmware/
>>
> 
> 
