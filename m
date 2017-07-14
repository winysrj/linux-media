Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34861 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753557AbdGNKWC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 06:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <1500026123.4457.66.camel@perches.com>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714093129.1366900-4-arnd@arndb.de>
 <1500026123.4457.66.camel@perches.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Jul 2017 12:22:00 +0200
Message-ID: <CAK8P3a0sZToC-7XTio8u6gWey0QVp3D7JHbHSCXgDEg3YQ-XFA@mail.gmail.com>
Subject: Re: [PATCH 13/14] iopoll: avoid -Wint-in-bool-context warning
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 11:55 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-07-14 at 11:31 +0200, Arnd Bergmann wrote:
>> When we pass the result of a multiplication as the timeout, we
>> can get a warning:
>>
>> drivers/mmc/host/bcm2835.c:596:149: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
>> drivers/mfd/arizona-core.c:247:195: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
>>
>> This is easy to avoid by comparing the timeout to zero instead,
>> making it a boolean expression.
>
> Perhaps this is better as != 0 if the multiply is signed.

I thought about that, but decided that as a negative timeout_us already
gives us rather random behavior (ktime_add_us() takes an unsigned
argument), the '>' comparison gives a more well-defined result by
ignoring the timeout.

         Arnd
