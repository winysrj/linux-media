Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934468Ab0HMOIl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 10:08:41 -0400
Message-ID: <4C6551F7.8010506@redhat.com>
Date: Fri, 13 Aug 2010 11:08:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
CC: "Igor M. Liplianin" <liplianin@me.by>, Goga777 <goga777@bk.ru>,
	linux-media@vger.kernel.org
Subject: Re: 2.6.35 and current v4l-dvb - error: implicit declaration of function
 'usb_buffer_free'
References: <20100812022919.7ce6dace@bk.ru>	<AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>	<201008131338.11647.liplianin@me.by> <AANLkTikC6+UETp7GBnzrqAEQhGoDsgrh3hmi0TyP374Q@mail.gmail.com>
In-Reply-To: <AANLkTikC6+UETp7GBnzrqAEQhGoDsgrh3hmi0TyP374Q@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 13-08-2010 09:53, Douglas Schilling Landgraf escreveu:
> Hello,
> 
> 2010/8/13 Igor M. Liplianin <liplianin@me.by>:
>> В сообщении от 13 августа 2010 05:19:49 автор Douglas Schilling Landgraf написал:
>>> Hello,
>>>
>>> 2010/8/11 Goga777 <goga777@bk.ru>:
>>>> Hi
>>>>
>>>> I can't compile current v4l-dvb with new 2.6.35 kernel
>>>>
>>>> arvdr:/usr/src/v4l-dvb# make
>>>> make -C /usr/src/v4l-dvb/v4l
>>>> make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
>>>> creating symbolic links...
>>>> make -C firmware prep
>>>> make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
>>>> make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
>>>> make -C firmware
>>>> make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
>>>> make[2]: Nothing to be done for `default'.
>>>> make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
>>>> Kernel build directory is /lib/modules/2.6.35-tux/build
>>>> make -C /lib/modules/2.6.35-tux/build SUBDIRS=/usr/src/v4l-dvb/v4l
>>>>  modules make[2]: Entering directory `/usr/src/linux-2.6.35'
>>>>  CC [M]  /usr/src/v4l-dvb/v4l/au0828-video.o
>>>> /usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
>>>> /usr/src/v4l-dvb/v4l/au0828-video.c:185: error: implicit declaration of
>>>> function 'usb_buffer_free' /usr/src/v4l-dvb/v4l/au0828-video.c: In
>>>> function 'au0828_init_isoc': /usr/src/v4l-dvb/v4l/au0828-video.c:255:
>>>> error: implicit declaration of function 'usb_buffer_alloc'
>>>> /usr/src/v4l-dvb/v4l/au0828-video.c:256: warning: assignment makes
>>>> pointer from integer without a cast make[3]: ***
>>>> [/usr/src/v4l-dvb/v4l/au0828-video.o] Ошибка 1
>>>> make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
>>>> make[2]: Leaving directory `/usr/src/linux-2.6.35'
>>>> make[1]: *** [default] Ошибка 2
>>>> make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
>>>> make: *** [all] Ошибка 2
>>>
>>> Both functions were renamed in upstream, backport created and
>>> commited, please try again.
>>>
>>> Cheers
>>> Douglas
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Is it better other way round, to rename all appearances of functions and define a macro?
>> Like this:
>>
>> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
>> #define usb_alloc_coherent(a, b, c, d) usb_buffer_alloc(a, b, c, d)
>> #define usb_free_coherent(a, b, c, d) usb_buffer_free(a, b, c, d)
>> #endif
>>
>> In the end it will be more similar in code to the last kernel :)
> 
> Yes, agreed but all drivers must be renamed with the new function name first.
> Otherwise, it will keep breaking. Thanks for looking it.

That's the reason why I used to first backport all upstream patches, and then work
on a fix. An upstream patchset already did such change.

> 
> Cheers
> Douglas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

