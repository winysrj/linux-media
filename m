Return-path: <linux-media-owner@vger.kernel.org>
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:20234
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbeENXOv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 19:14:51 -0400
Subject: Re: [PATCH 1/7] i2c: i2c-gpio: move header to platform_data
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sergey Lapin <slapin@ossfans.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mips@linux-mips.org, linux-media@vger.kernel.org
References: <20180419200015.15095-1-wsa@the-dreams.de>
 <20180419200015.15095-2-wsa@the-dreams.de>
 <20180514213719.o6ceftp2quem3s7f@ninjato>
From: Greg Ungerer <gerg@uclinux.org>
Message-ID: <40bb677a-e6e1-7906-28fe-9e74cdfbefd7@uclinux.org>
Date: Tue, 15 May 2018 09:03:08 +1000
MIME-Version: 1.0
In-Reply-To: <20180514213719.o6ceftp2quem3s7f@ninjato>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Wolfram,

On 15/05/18 07:37, Wolfram Sang wrote:
>>   arch/arm/mach-ks8695/board-acs5k.c               | 2 +-
>>   arch/arm/mach-sa1100/simpad.c                    | 2 +-
>>   arch/mips/alchemy/board-gpr.c                    | 2 +-
> 
> Those still need acks...
> 
>> diff --git a/arch/arm/mach-ks8695/board-acs5k.c b/arch/arm/mach-ks8695/board-acs5k.c
>> index 937eb1d47e7b..ef835d82cdb9 100644
>> --- a/arch/arm/mach-ks8695/board-acs5k.c
>> +++ b/arch/arm/mach-ks8695/board-acs5k.c
>> @@ -19,7 +19,7 @@
>>   #include <linux/gpio/machine.h>
>>   #include <linux/i2c.h>
>>   #include <linux/i2c-algo-bit.h>
>> -#include <linux/i2c-gpio.h>
>> +#include <linux/platform_data/i2c-gpio.h>
>>   #include <linux/platform_data/pca953x.h>
>>   
>>   #include <linux/mtd/mtd.h>
> 
> ...
> 
>> diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
>> index ace010479eb6..49a61e6f3c5f 100644
>> --- a/arch/arm/mach-sa1100/simpad.c
>> +++ b/arch/arm/mach-sa1100/simpad.c
>> @@ -37,7 +37,7 @@
>>   #include <linux/input.h>
>>   #include <linux/gpio_keys.h>
>>   #include <linux/leds.h>
>> -#include <linux/i2c-gpio.h>
>> +#include <linux/platform_data/i2c-gpio.h>
>>   
>>   #include "generic.h"
>>   
>> diff --git a/arch/mips/alchemy/board-gpr.c b/arch/mips/alchemy/board-gpr.c
>> index 4e79dbd54a33..fa75d75b5ba9 100644
>> --- a/arch/mips/alchemy/board-gpr.c
>> +++ b/arch/mips/alchemy/board-gpr.c
>> @@ -29,7 +29,7 @@
>>   #include <linux/leds.h>
>>   #include <linux/gpio.h>
>>   #include <linux/i2c.h>
>> -#include <linux/i2c-gpio.h>
>> +#include <linux/platform_data/i2c-gpio.h>
>>   #include <linux/gpio/machine.h>
>>   #include <asm/bootinfo.h>
>>   #include <asm/idle.h>
> 
> ... and this was the shortened diff for those.
> 
> Greg, Russell, Ralf, James? Is it okay if I take this via my tree?

Yes, I have no problem with that for the ks8695 part.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Thanks
Greg


> Thanks,
> 
>     Wolfram
> 
