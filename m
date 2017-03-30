Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34201 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932651AbdC3H3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:29:18 -0400
Subject: Re: build_media compilation issues
To: Nigel Terry <nigel@nigelterry.net>, linux-media@vger.kernel.org
References: <CAHBUmZMCxEGsVZEY2NWpcDtWqne8BfWH5-s5V79Hys56MBeZog@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d26eed5e-4aa5-dd26-3282-49933a5591d5@xs4all.nl>
Date: Thu, 30 Mar 2017 09:29:13 +0200
MIME-Version: 1.0
In-Reply-To: <CAHBUmZMCxEGsVZEY2NWpcDtWqne8BfWH5-s5V79Hys56MBeZog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/03/17 00:23, Nigel Terry wrote:
> I'm trying to use build_media to build the media drivers, specifically
> usb/em28xx, for Centos7. I'm getting compile errors, see below. Can
> anyone help me?

I'll try to take a look at this on Friday or Monday.

Regards,

	Hans

> 
> Kernel:
> $ uname -a
> Linux mythpbx.lan 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05
> UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> Errors:
> ...
>   CC [M]  /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
> 'dvb_usb_start_feed':
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: warning:
> passing argument 3 of 'wait_on_bit' makes integer from pointer without
> a cast [enabled by default]
>   wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
> TASK_UNINTERRUPTIBLE);
>   ^
> In file included from include/linux/kobject.h:27:0,
>                  from include/linux/device.h:17,
>                  from include/linux/input.h:22,
>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>                  from <command-line>:0:
> include/linux/wait.h:1044:1: note: expected 'unsigned int' but
> argument is of type 'int (*)(void *)'
>  wait_on_bit(void *word, int bit, unsigned mode)
>  ^
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: error:
> too many arguments to function 'wait_on_bit'
>   wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
> TASK_UNINTERRUPTIBLE);
>   ^
> In file included from include/linux/kobject.h:27:0,
>                  from include/linux/device.h:17,
>                  from include/linux/input.h:22,
>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>                  from <command-line>:0:
> include/linux/wait.h:1044:1: note: declared here
>  wait_on_bit(void *word, int bit, unsigned mode)
>  ^
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
> 'dvb_usb_fe_sleep':
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: warning:
> passing argument 3 of 'wait_on_bit' makes integer from pointer without
> a cast [enabled by default]
>      wait_schedule, TASK_UNINTERRUPTIBLE);
>      ^
> In file included from include/linux/kobject.h:27:0,
>                  from include/linux/device.h:17,
>                  from include/linux/input.h:22,
>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>                  from <command-line>:0:
> include/linux/wait.h:1044:1: note: expected 'unsigned int' but
> argument is of type 'int (*)(void *)'
>  wait_on_bit(void *word, int bit, unsigned mode)
>  ^
> /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: error:
> too many arguments to function 'wait_on_bit'
>      wait_schedule, TASK_UNINTERRUPTIBLE);
>      ^
> In file included from include/linux/kobject.h:27:0,
>                  from include/linux/device.h:17,
>                  from include/linux/input.h:22,
>                  from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
>                  from <command-line>:0:
> include/linux/wait.h:1044:1: note: declared here
>  wait_on_bit(void *word, int bit, unsigned mode)
>  ^
> make[3]: *** [/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o] Error 1
> make[2]: *** [_module_/home/mythtv/buildmedia/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/3.10.0-514.10.2.el7.x86_64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/mythtv/buildmedia/media_build/v4l'
> make: *** [all] Error 2
> build failed at ./build line 491.
> 
