Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49032 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751330Ab2BEUch (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 15:32:37 -0500
Message-ID: <4F2EE762.1030801@xenotime.net>
Date: Sun, 05 Feb 2012 12:32:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Manjunatha Halli <x0130808@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] Re: linux-next: Tree for Feb 2 (media/radio/wl128x)
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au> <4F2AD0E4.6020801@xenotime.net> <4F2AC5F8.1000901@ti.com> <4F2AD89E.70805@xenotime.net> <4F2AD3E9.1070804@ti.com>
In-Reply-To: <4F2AD3E9.1070804@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2012 10:20 AM, Manjunatha Halli wrote:
> On 02/02/2012 12:40 PM, Randy Dunlap wrote:
>> On 02/02/2012 09:20 AM, Manjunatha Halli wrote:
>>> Hi Randy Dunlap,
>>>
>>> In config file you are missing the CONFIG_TI_ST config which builds the TI's shared transport driver upon which the FM driver works.
>>>
>>> Please select this config in drivers/misc/ti-st/Kconfig which will solve the problem.
>> Wrong answer.
>>
>> The problem seems to be that GPIOLIB is not enabled, but wl128x Kconfig says:
>>
>> config RADIO_WL128X
>>     tristate "Texas Instruments WL128x FM Radio"
>>     depends on VIDEO_V4L2&&  RFKILL
>>     select TI_ST if NET&&  GPIOLIB
>>
>> so TI_ST is not selected here.
>>
>> The Kconfig files should handle this properly.
>>
>> Here is one possible fix for you to consider.
>>
>> ---
>> From: Randy Dunlap<rdunlap@xenotime.net>
>>
>> Fix build errors when GPIOLIB is not enabled.
>> Fix wl128x Kconfig to depend on GPIOLIB since TI_ST also
>> depends on GPIOLIB.
>>
>> (.text+0xe6d60): undefined reference to `st_register'
>> (.text+0xe7016): undefined reference to `st_unregister'
>> (.text+0xe70ce): undefined reference to `st_unregister'
>>
>> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
>> Cc: Manjunatha Halli<manjunatha_halli@ti.com>
>> ---
>>   drivers/media/radio/wl128x/Kconfig |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- linux-next-20120202.orig/drivers/media/radio/wl128x/Kconfig
>> +++ linux-next-20120202/drivers/media/radio/wl128x/Kconfig
>> @@ -4,8 +4,8 @@
>>   menu "Texas Instruments WL128x FM driver (ST based)"
>>   config RADIO_WL128X
>>       tristate "Texas Instruments WL128x FM Radio"
>> -    depends on VIDEO_V4L2&&  RFKILL
>> -    select TI_ST if NET&&  GPIOLIB
>> +    depends on VIDEO_V4L2&&  RFKILL&&  GPIOLIB
>> +    select TI_ST if NET
>>       help
>>       Choose Y here if you have this FM radio chip.
>>
>>
>>> Regards
>>> Manju
>>>
>>> On 02/02/2012 12:07 PM, Randy Dunlap wrote:
>>>> On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20120201:
>>>> drivers/built-in.o: In function `fmc_prepare':
>>>> (.text+0xe6d60): undefined reference to `st_register'
>>>> drivers/built-in.o: In function `fmc_prepare':
>>>> (.text+0xe7016): undefined reference to `st_unregister'
>>>> drivers/built-in.o: In function `fmc_release':
>>>> (.text+0xe70ce): undefined reference to `st_unregister'
>>>>
>>>>
>>>> Full randconfig file is attached.
>>
> 
> This solutions seems fine for me...
> 
> My only concern is since TI_ST is already have GPIOLIB in its dependency list is it OK to have the same thing in FM driver also?.

Sure, it's OK.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
