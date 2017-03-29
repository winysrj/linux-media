Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36760 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933140AbdC2WXJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 18:23:09 -0400
Received: by mail-qt0-f194.google.com with SMTP id n37so3943682qtb.3
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 15:23:08 -0700 (PDT)
MIME-Version: 1.0
From: Nigel Terry <nigel@nigelterry.net>
Date: Wed, 29 Mar 2017 18:23:07 -0400
Message-ID: <CAHBUmZMCxEGsVZEY2NWpcDtWqne8BfWH5-s5V79Hys56MBeZog@mail.gmail.com>
Subject: build_media compilation issues
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to use build_media to build the media drivers, specifically
usb/em28xx, for Centos7. I'm getting compile errors, see below. Can
anyone help me?

Kernel:
$ uname -a
Linux mythpbx.lan 3.10.0-514.10.2.el7.x86_64 #1 SMP Fri Mar 3 00:04:05
UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

Errors:
...
  CC [M]  /home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
'dvb_usb_start_feed':
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: warning:
passing argument 3 of 'wait_on_bit' makes integer from pointer without
a cast [enabled by default]
  wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
TASK_UNINTERRUPTIBLE);
  ^
In file included from include/linux/kobject.h:27:0,
                 from include/linux/device.h:17,
                 from include/linux/input.h:22,
                 from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
                 from <command-line>:0:
include/linux/wait.h:1044:1: note: expected 'unsigned int' but
argument is of type 'int (*)(void *)'
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:274:2: error:
too many arguments to function 'wait_on_bit'
  wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
TASK_UNINTERRUPTIBLE);
  ^
In file included from include/linux/kobject.h:27:0,
                 from include/linux/device.h:17,
                 from include/linux/input.h:22,
                 from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
                 from <command-line>:0:
include/linux/wait.h:1044:1: note: declared here
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c: In function
'dvb_usb_fe_sleep':
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: warning:
passing argument 3 of 'wait_on_bit' makes integer from pointer without
a cast [enabled by default]
     wait_schedule, TASK_UNINTERRUPTIBLE);
     ^
In file included from include/linux/kobject.h:27:0,
                 from include/linux/device.h:17,
                 from include/linux/input.h:22,
                 from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
                 from <command-line>:0:
include/linux/wait.h:1044:1: note: expected 'unsigned int' but
argument is of type 'int (*)(void *)'
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.c:623:5: error:
too many arguments to function 'wait_on_bit'
     wait_schedule, TASK_UNINTERRUPTIBLE);
     ^
In file included from include/linux/kobject.h:27:0,
                 from include/linux/device.h:17,
                 from include/linux/input.h:22,
                 from /home/mythtv/buildmedia/media_build/v4l/compat.h:10,
                 from <command-line>:0:
include/linux/wait.h:1044:1: note: declared here
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
make[3]: *** [/home/mythtv/buildmedia/media_build/v4l/dvb_usb_core.o] Error 1
make[2]: *** [_module_/home/mythtv/buildmedia/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/3.10.0-514.10.2.el7.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/mythtv/buildmedia/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 491.
