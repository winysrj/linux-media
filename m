Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37313 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbdK0PUy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 10:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <1511795153.25007.451.camel@linux.intel.com>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-7-arnd@arndb.de>
 <1511795153.25007.451.camel@linux.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Nov 2017 16:20:53 +0100
Message-ID: <CAK8P3a3G4C5Q69ugDHgC2Hy=3xpXt=cviWWnZ6zSV9iWtY+y=g@mail.gmail.com>
Subject: Re: [Y2038] [PATCH 7/8] [media] staging: atomisp: convert timestamps
 to ktime_t
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 4:05 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2017-11-27 at 14:19 +0100, Arnd Bergmann wrote:
>> timespec overflows in 2038 on 32-bit architectures, and the
>> getnstimeofday() suffers from possible time jumps, so the
>> timestamps here are better done using ktime_get(), which has
>> neither of those problems.
>>
>> In case of ov2680, we don't seem to use the timestamp at
>> all, so I just remove it.
>>
>
>> +     ktime_t timedelay = ns_to_ktime(
>>               min((u32)abs(dev->number_of_steps) *
>> DELAY_PER_STEP_NS,
>> -             (u32)DELAY_MAX_PER_STEP_NS),
>> -     };
>> +                 (u32)DELAY_MAX_PER_STEP_NS));
>
> Since you are touching this, it might make sense to convert to
>
> min_t(u32, ...)
>
> ...and locate lines something like:
>
> ktime_t timeday = ns_to_ktime(min_t(u32,
>      param1,
>      param2));
>
> From my pov will make readability better.

Yes, good idea. Re-sending the patch now. Thanks for taking a look,

      Arnd
