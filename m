Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36387 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbdCaThq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 15:37:46 -0400
Received: by mail-qk0-f195.google.com with SMTP id r140so518730qke.3
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 12:37:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d26eed5e-4aa5-dd26-3282-49933a5591d5@xs4all.nl>
References: <CAHBUmZMCxEGsVZEY2NWpcDtWqne8BfWH5-s5V79Hys56MBeZog@mail.gmail.com>
 <d26eed5e-4aa5-dd26-3282-49933a5591d5@xs4all.nl>
From: Nigel Terry <nigel@nigelterry.net>
Date: Fri, 31 Mar 2017 15:37:45 -0400
Message-ID: <CAHBUmZMBdNUQo5dJCRdNEV=oW+PD46wpn=Pim8wDaFvCbkoZdQ@mail.gmail.com>
Subject: Re: build_media compilation issues
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solved.

Between Centos 3.10.0-378.el7.x86_64 and 3.10.0-514.10.2.el7.x86_64,
the kernel patch to change wait_on_bit
https://github.com/torvalds/linux/commit/743162013d40ca612b4cb53d3a200dff2d9ab26e
was added to Centos7.

Thus the backport v3.16_wait_on_bit.patch is not required. Without
that, it builds just fine.

Nigel

On Thu, Mar 30, 2017 at 3:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 30/03/17 00:23, Nigel Terry wrote:
>> I'm trying to use build_media to build the media drivers, specifically
>> usb/em28xx, for Centos7. I'm getting compile errors, see below. Can
>> anyone help me?
>
> I'll try to take a look at this on Friday or Monday.
>
> Regards,
>
>         Hans
>
>>
>> Kernel:
>> $ uname -a
>> Linux mythpbx.lan 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05
>> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Errors:
>> ...
>>   CC [M]  /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
>> 'dvb_usb_start_feed':
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: warning:
>> passing argument 3 of 'wait_on_bit' makes integer from pointer without
>> a cast [enabled by default]
>>   wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
>> TASK_UNINTERRUPTIBLE);
>>   ^
>> In file included from include/linux/kobject.h:27:0,
>>                  from include/linux/device.h:17,
>>                  from include/linux/input.h:22,
>>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>>                  from <command-line>:0:
>> include/linux/wait.h:1044:1: note: expected 'unsigned int' but
>> argument is of type 'int (*)(void *)'
>>  wait_on_bit(void *word, int bit, unsigned mode)
>>  ^
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: error:
>> too many arguments to function 'wait_on_bit'
>>   wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
>> TASK_UNINTERRUPTIBLE);
>>   ^
>> In file included from include/linux/kobject.h:27:0,
>>                  from include/linux/device.h:17,
>>                  from include/linux/input.h:22,
>>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>>                  from <command-line>:0:
>> include/linux/wait.h:1044:1: note: declared here
>>  wait_on_bit(void *word, int bit, unsigned mode)
>>  ^
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
>> 'dvb_usb_fe_sleep':
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: warning:
>> passing argument 3 of 'wait_on_bit' makes integer from pointer without
>> a cast [enabled by default]
>>      wait_schedule, TASK_UNINTERRUPTIBLE);
>>      ^
>> In file included from include/linux/kobject.h:27:0,
>>                  from include/linux/device.h:17,
>>                  from include/linux/input.h:22,
>>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>>                  from <command-line>:0:
>> include/linux/wait.h:1044:1: note: expected 'unsigned int' but
>> argument is of type 'int (*)(void *)'
>>  wait_on_bit(void *word, int bit, unsigned mode)
>>  ^
>> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: error:
>> too many arguments to function 'wait_on_bit'
>>      wait_schedule, TASK_UNINTERRUPTIBLE);
>>      ^
>> In file included from include/linux/kobject.h:27:0,
>>                  from include/linux/device.h:17,
>>                  from include/linux/input.h:22,
>>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>>                  from <command-line>:0:
>> include/linux/wait.h:1044:1: note: declared here
>>  wait_on_bit(void *word, int bit, unsigned mode)
>>  ^
>> make[3]: *** [/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o] Error 1
>> make[2]: *** [_module_/home/mythtv/buildmedia/media_build/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/kernels/3.10.0-514.10.2.el7.x86_64'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/home/mythtv/buildmedia/media_build/v4l'
>> make: *** [all] Error 2
>> build failed at ./build line 491.
>>
>
