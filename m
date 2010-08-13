Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35232 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab0HMMxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 08:53:43 -0400
Received: by ywh1 with SMTP id 1so910135ywh.19
        for <linux-media@vger.kernel.org>; Fri, 13 Aug 2010 05:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008131338.11647.liplianin@me.by>
References: <20100812022919.7ce6dace@bk.ru>
	<AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
	<201008131338.11647.liplianin@me.by>
Date: Fri, 13 Aug 2010 09:53:43 -0300
Message-ID: <AANLkTikC6+UETp7GBnzrqAEQhGoDsgrh3hmi0TyP374Q@mail.gmail.com>
Subject: Re: 2.6.35 and current v4l-dvb - error: implicit declaration of
 function 'usb_buffer_free'
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

2010/8/13 Igor M. Liplianin <liplianin@me.by>:
> ÷ ÓÏÏÂÝÅÎÉÉ ÏÔ 13 Á×ÇÕÓÔÁ 2010 05:19:49 Á×ÔÏÒ Douglas Schilling Landgraf ÎÁÐÉÓÁÌ:
>> Hello,
>>
>> 2010/8/11 Goga777 <goga777@bk.ru>:
>> > Hi
>> >
>> > I can't compile current v4l-dvb with new 2.6.35 kernel
>> >
>> > arvdr:/usr/src/v4l-dvb# make
>> > make -C /usr/src/v4l-dvb/v4l
>> > make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
>> > creating symbolic links...
>> > make -C firmware prep
>> > make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
>> > make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
>> > make -C firmware
>> > make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
>> > make[2]: Nothing to be done for `default'.
>> > make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
>> > Kernel build directory is /lib/modules/2.6.35-tux/build
>> > make -C /lib/modules/2.6.35-tux/build SUBDIRS=/usr/src/v4l-dvb/v4l
>> > šmodules make[2]: Entering directory `/usr/src/linux-2.6.35'
>> > šCC [M] š/usr/src/v4l-dvb/v4l/au0828-video.o
>> > /usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
>> > /usr/src/v4l-dvb/v4l/au0828-video.c:185: error: implicit declaration of
>> > function 'usb_buffer_free' /usr/src/v4l-dvb/v4l/au0828-video.c: In
>> > function 'au0828_init_isoc': /usr/src/v4l-dvb/v4l/au0828-video.c:255:
>> > error: implicit declaration of function 'usb_buffer_alloc'
>> > /usr/src/v4l-dvb/v4l/au0828-video.c:256: warning: assignment makes
>> > pointer from integer without a cast make[3]: ***
>> > [/usr/src/v4l-dvb/v4l/au0828-video.o] ïÛÉÂËÁ 1
>> > make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
>> > make[2]: Leaving directory `/usr/src/linux-2.6.35'
>> > make[1]: *** [default] ïÛÉÂËÁ 2
>> > make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
>> > make: *** [all] ïÛÉÂËÁ 2
>>
>> Both functions were renamed in upstream, backport created and
>> commited, please try again.
>>
>> Cheers
>> Douglas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Is it better other way round, to rename all appearances of functions and define a macro?
> Like this:
>
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
> #define usb_alloc_coherent(a, b, c, d) usb_buffer_alloc(a, b, c, d)
> #define usb_free_coherent(a, b, c, d) usb_buffer_free(a, b, c, d)
> #endif
>
> In the end it will be more similar in code to the last kernel :)

Yes, agreed but all drivers must be renamed with the new function name first.
Otherwise, it will keep breaking. Thanks for looking it.

Cheers
Douglas
