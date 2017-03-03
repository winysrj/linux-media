Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34303 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdCCPD5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 10:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <125a8ea6-35d7-9d37-3841-eebb37fce515@virtuozzo.com>
References: <20170302163834.2273519-1-arnd@arndb.de> <20170302163834.2273519-27-arnd@arndb.de>
 <125a8ea6-35d7-9d37-3841-eebb37fce515@virtuozzo.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 3 Mar 2017 16:03:23 +0100
Message-ID: <CAK8P3a1=NyWKehX8pbTG_DGha4xx3NypyAAUYJvGb9kMBEpXmw@mail.gmail.com>
Subject: Re: [PATCH 26/26] kasan: rework Kconfig settings
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: kasan-dev <kasan-dev@googlegroups.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-build-reports@lists.linaro.org,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 3, 2017 at 3:51 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>
>
> On 03/02/2017 07:38 PM, Arnd Bergmann wrote:
>
>>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 97d62c2da6c2..27c838c40a36 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -216,10 +216,9 @@ config ENABLE_MUST_CHECK
>>  config FRAME_WARN
>>       int "Warn for stack frames larger than (needs gcc 4.4)"
>>       range 0 8192
>> -     default 0 if KASAN
>> -     default 2048 if GCC_PLUGIN_LATENT_ENTROPY
>> +     default 3072 if KASAN_EXTRA
>>       default 1024 if !64BIT
>> -     default 2048 if 64BIT
>> +     default 1280 if 64BIT
>
> This looks unrelated. Also, it means that now we have 1280 with KASAN=y && KASAN_EXTRA=n.
> Judging from changelog I assume that this hunk slipped here from the follow up series.

Right, this slipped in by accident, I've already fixed it up locally.

>>       help
>>         Tell gcc to warn at build time for stack frames larger than this.
>>         Setting this too low will cause a lot of warnings.
>> @@ -499,7 +498,7 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
>>
>>  config DEBUG_SLAB
>>       bool "Debug slab memory allocations"
>> -     depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
>> +     depends on DEBUG_KERNEL && SLAB && !KMEMCHECK && !KASAN
>>       help
>>         Say Y here to have the kernel do limited verification on memory
>>         allocation as well as poisoning memory on free to catch use of freed
>> @@ -511,7 +510,7 @@ config DEBUG_SLAB_LEAK
>>
>>  config SLUB_DEBUG_ON
>>       bool "SLUB debugging on by default"
>> -     depends on SLUB && SLUB_DEBUG && !KMEMCHECK
>> +     depends on SLUB && SLUB_DEBUG && !KMEMCHECK && !KASAN
>
> Why? SLUB_DEBUG_ON works with KASAN.

Ok, will fix. I wrongly guessed that kmemcheck and kasan had the
same reason for the two dependencies here.

    Arnd
