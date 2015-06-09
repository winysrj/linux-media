Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35166 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbFIK4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 06:56:40 -0400
Received: by labko7 with SMTP id ko7so9276661lab.2
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2015 03:56:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGyWP-67SzQsg1DF8qsKJzmK3SsKqPsdB8aM9VBDq37nYA@mail.gmail.com>
References: <CAB0z4Noe_pGszj5oOz+xfKWy4-icWTJOkE=dQ9ymzjgebBA1aA@mail.gmail.com>
	<CAAZRmGyWP-67SzQsg1DF8qsKJzmK3SsKqPsdB8aM9VBDq37nYA@mail.gmail.com>
Date: Tue, 9 Jun 2015 12:56:39 +0200
Message-ID: <CAB0z4Nr9=f34S9rjxbZsBXrxs6XmqMRtuScKKv6COfL4XW11Dg@mail.gmail.com>
Subject: Re: Unable to compile v4l-dvb in ubuntu 14.04
From: CIJOML CIJOMLovic <cijoml@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Olli,

I think tar.bz2 generated fromhttp://linuxtv.org/hg/v4l-dvb are
current snaphots from git. Or Am I wrong?
But back to my problem YES I have kernel 3.16.0-38 and also headers
3.16.0-38. I also realized that compiler claims 3.6.0, but it is
wrong. I don't have such kernel.

Thank you for fix

Michal

2015-06-09 12:08 GMT+02:00 Olli Salonen <olli.salonen@iki.fi>:
> Hi,
>
> Do you have a specific reason for not using the media_build? You're
> getting the following warning:
>
> WARNING: You're using an obsolete driver! You shouldn't be using it!
>      If you want anything new, you can use:
>         http://git.linuxtv.org/media_build.git.
>      The tree is still here just to preserve the development history.
>      You've been warned.
>
> Also, check the kernel and linux-header versions you have installed.
> Is it 3.16 or 3.6?
>
> Cheers,
> -olli
>
> On 8 June 2015 at 18:06, CIJOML CIJOMLovic <cijoml@gmail.com> wrote:
>> Hello,
>>
>> I am trying to compile v4l git with no success. I have kernel and
>> headers installed.
>> Is problem at my side or in source?
>>
>> Thank you for help or solving the problem:
>>
>> root@Latitude-E5550:/usr/src/v4l-dvb-3724e93f7af5# make
>> make -C /usr/src/v4l-dvb-3724e93f7af5/v4l
>> make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> No version yet, using 3.16.0-38-generic
>> make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> scripts/make_makefile.pl
>> Updating/Creating .config
>> Preparing to compile for kernel version 3.6.0
>>
>> ***WARNING:*** You do not have the full kernel sources installed.
>> This does not prevent you from building the v4l-dvb tree if you have the
>> kernel headers, but the full kernel source may be required in order to use
>> make menuconfig / xconfig / qconfig.
>>
>> If you are experiencing problems building the v4l-dvb tree, please try
>> building against a vanilla kernel before reporting a bug.
>>
>> Vanilla kernels are available at http://kernel.org.
>> On most distros, this will compile a newly downloaded kernel:
>>
>> cp /boot/config-`uname -r` <your kernel dir>/.config
>> cd <your kernel dir>
>> make all modules_install install
>>
>> Please see your distro's web site for instructions to build a new kernel.
>>
>> WARNING: You're using an obsolete driver! You shouldn't be using it!
>>      If you want anything new, you can use:
>>         http://git.linuxtv.org/media_build.git.
>>      The tree is still here just to preserve the development history.
>>      You've been warned.
>> Created default (all yes) .config file
>> ./scripts/make_myconfig.pl
>> make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> make[1]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> perl scripts/make_config_compat.pl /lib/modules/3.6.0-38-generic/build
>> ./.myconfig ./config-compat.h
>> creating symbolic links...
>> ln -sf . oss
>> make -C firmware prep
>> make[2]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
>> make[2]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
>> make -C firmware
>> make[2]: Entering directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
>>   CC  ihex2fw
>> Generating vicam/firmware.fw
>> Generating dabusb/firmware.fw
>> Generating dabusb/bitstream.bin
>> Generating ttusb-budget/dspbootcode.bin
>> Generating cpia2/stv0672_vp4.bin
>> Generating av7110/bootcode.bin
>> make[2]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l/firmware'
>> Kernel build directory is /lib/modules/3.6.0-38-generic/build
>> make -C /lib/modules/3.6.0-38-generic/build
>> SUBDIRS=/usr/src/v4l-dvb-3724e93f7af5/v4l CFLAGS="-I../linux/include
>> -D__KERNEL__ -I/include -DEXPORT_SYMTAB" modules
>> make[2]: Entering directory `/usr/src/linux-headers-3.16.0-38-generic'
>>   CC [M]  /usr/src/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o
>> In file included from <command-line>:0:0:
>> /usr/src/v4l-dvb-3724e93f7af5/v4l/config-compat.h:1235:1: fatal error:
>> include/linux/version.h: No such file or directory
>>  #endif
>>  ^
>> compilation terminated.
>> make[3]: *** [/usr/src/v4l-dvb-3724e93f7af5/v4l/tuner-xc2028.o] Error 1
>> make[2]: *** [_module_/usr/src/v4l-dvb-3724e93f7af5/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-headers-3.16.0-38-generic'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/usr/src/v4l-dvb-3724e93f7af5/v4l'
>> make: *** [all] Error 2
>>
>>
>> Best regards
>>
>> Michal
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
