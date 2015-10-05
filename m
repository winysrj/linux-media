Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34249 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbJEMKs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 08:10:48 -0400
MIME-Version: 1.0
In-Reply-To: <20151005110923.GA16831@wfg-t540p.sh.intel.com>
References: <CAK3bHNWkeakZP0cEi+U=GjmPa0jN9qWC4seyS6+ih8inzvmbXQ@mail.gmail.com>
	<20151005110923.GA16831@wfg-t540p.sh.intel.com>
Date: Mon, 5 Oct 2015 15:10:46 +0300
Message-ID: <CAPAsAGzSEEEogyzpNOfXAEiv8=kt8CLVDvyJKBmgYLeEVKopEA@mail.gmail.com>
Subject: Re: [kbuild-all] drivers/media/dvb-frontends/cxd2841er.c:2393:1:
 warning: the frame size of 2992 bytes is larger than 2048 bytes
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Abylay Ospan <aospan@netup.ru>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-10-05 14:09 GMT+03:00 Fengguang Wu <fengguang.wu@intel.com>:
> Hi Abylay,
>
>> cause of this 'Kernel Address sanitizer (KASan)' is enabled in your
>> config. With gcc-4.9 kasan was disabled in compile time because of:
>> "scripts/Makefile.kasan:23: CONFIG_KASAN: compiler does not support
>> all options. Trying minimal configuration"
>>
>> but with gcc-5 it's enabled.
>>
>> and
>> objdump -d drivers/media/dvb-frontends/cxd2841er.o
>>
>> shows that KASan adds some instructions to 'cxd2841er_sleep_tc' which
>> writes necessary data to -fasan-shadow-offset=0xdffffc0000000000:
>>     1476:       48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>> ...
>>     14d3:       c7 00 f1 f1 f1 f1       movl   $0xf1f1f1f1,(%rax)
>>     14d9:       c7 40 04 01 f4 f4 f4    movl   $0xf4f4f401,0x4(%rax)
>>     14e0:       c7 40 08 f2 f2 f2 f2    movl   $0xf2f2f2f2,0x8(%rax)
>>     14e7:       c7 40 0c 01 f4 f4 f4    movl   $0xf4f4f401,0xc(%rax)
>> ...
>>
>> and function will grow and we get '-Wframe-larger-than=2048' warnings.
>>
>> So, this warning looks normal  (until they less than 8K I think) for
>> configurations with KASan enabled.
>>
>> I can suggest:
>> * ignore this warning if KASan enabled
>
> Yes I can easily teach the kbuild robot to ignore this warning when
> KASan enabled. Thanks for the explanations!
>
>> * Increase -Wframe-larger-than=2048 to -Wframe-larger-than=8192 if
>> KASan enabled ( CONFIG_FRAME_WARN=8192 in kernel .config)
>
> Would it be possible to auto increase the threshold (in below Kconfig) when
> KASan is enabled, so that all other developers/testers won't get the warnings,
> too?
>

Makes sense, although 8K is too much, I think. 6K probably enough.

> lib/Kconfig.debug
>
> config FRAME_WARN
>         int "Warn for stack frames larger than (needs gcc 4.4)"
>         range 0 8192
>         default 1024 if !64BIT
>         default 2048 if 64BIT
>
> Thanks,
> Fengguang
>
