Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36406 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbdLOJeg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 04:34:36 -0500
MIME-Version: 1.0
In-Reply-To: <20171214151040.3143ac33@vento.lan>
References: <20171211120518.3746850-1-arnd@arndb.de> <20171214151040.3143ac33@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 15 Dec 2017 10:34:35 +0100
Message-ID: <CAK8P3a2m6FSoc_NZChbCHcuJ2RpK9UK++_CV3aHt8CXG-Cg0Cw@mail.gmail.com>
Subject: Re: [PATCH] em28xx: split up em28xx_dvb_init to reduce stack size
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kevin Cheng <kcheng@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 14, 2017 at 6:10 PM, Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
> Em Mon, 11 Dec 2017 13:05:02 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:
>
>> With CONFIG_KASAN, the init function uses a large amount of kernel stack:
>>
>> drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_init.part.4':
>> drivers/media/usb/em28xx/em28xx-dvb.c:2061:1: error: the frame size of 3232 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
>>
>> Using gcc-7 with -fsanitize-address-use-after-scope makes this even worse:
>>
>> drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_init':
>> drivers/media/usb/em28xx/em28xx-dvb.c:2069:1: error: the frame size of 4280 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
>>
>> By splitting out each part of the switch/case statement that has its own local
>> variables into a separate function, no single one of them uses more than 500 bytes,
>> and with a noinline_for_stack annotation we can ensure that they are not merged
>> back together.
>
> The right fix here is really to find a way to simplify the new method
> of binding I2C devices by using some ancillary routines.
>
> I'll keep this patch on my queue for now, but my plan is to try to solve
> this issue instead of applying it, maybe on the next weeks (as the
> volume of patches reduce due to end of year vacations and Seasons).

That's ok, thanks. We have a workaround in linux-mm that partially solves this
problem to the point where the stack size goes down to 1600 bytes with KASAN,
that by itself would be sufficient to let us enable CONFIG_FRAME_WARN
again for 64-bit platforms with the default 2048 byte warning limit. I reposted
that patch mostly since I want to lower the frame sizes further so we can
reduce the warning limit to 1280 bytes for 64-bit architectures in the future.
There around 10 patches needed for that, and they mostly seem to address
actual issues, so I'd like them to get addressed eventually and set the limit
low enough that the warnings we get on 64-bit are more useful again.

However, could you please revisit two other patches:

https://patchwork.linuxtv.org/patch/45716/ dvb-frontends: fix i2c
access helpers for KASAN
https://patchwork.linuxtv.org/patch/45709/ r820t: fix r820t_write_reg for KASAN

These are currently the ones I'm most interested in getting merged
into v4.15 and LTS kernels for the stack size reduction, since they
are blocking the patch that enables CONFIG_FRAME_WARN for
allmodconfig.

Thanks,

       Arnd
