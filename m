Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33758 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761445Ab0HMKig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 06:38:36 -0400
Received: by ewy23 with SMTP id 23so1128189ewy.19
        for <linux-media@vger.kernel.org>; Fri, 13 Aug 2010 03:38:35 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Goga777 <goga777@bk.ru>, linux-media@vger.kernel.org
Subject: Re: 2.6.35 and current v4l-dvb - error: implicit declaration of function 'usb_buffer_free'
Date: Fri, 13 Aug 2010 13:38:11 +0300
References: <20100812022919.7ce6dace@bk.ru> <AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
In-Reply-To: <AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008131338.11647.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

В сообщении от 13 августа 2010 05:19:49 автор Douglas Schilling Landgraf написал:
> Hello,
> 
> 2010/8/11 Goga777 <goga777@bk.ru>:
> > Hi
> > 
> > I can't compile current v4l-dvb with new 2.6.35 kernel
> > 
> > arvdr:/usr/src/v4l-dvb# make
> > make -C /usr/src/v4l-dvb/v4l
> > make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
> > creating symbolic links...
> > make -C firmware prep
> > make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
> > make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
> > make -C firmware
> > make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
> > make[2]: Nothing to be done for `default'.
> > make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
> > Kernel build directory is /lib/modules/2.6.35-tux/build
> > make -C /lib/modules/2.6.35-tux/build SUBDIRS=/usr/src/v4l-dvb/v4l
> >  modules make[2]: Entering directory `/usr/src/linux-2.6.35'
> >  CC [M]  /usr/src/v4l-dvb/v4l/au0828-video.o
> > /usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
> > /usr/src/v4l-dvb/v4l/au0828-video.c:185: error: implicit declaration of
> > function 'usb_buffer_free' /usr/src/v4l-dvb/v4l/au0828-video.c: In
> > function 'au0828_init_isoc': /usr/src/v4l-dvb/v4l/au0828-video.c:255:
> > error: implicit declaration of function 'usb_buffer_alloc'
> > /usr/src/v4l-dvb/v4l/au0828-video.c:256: warning: assignment makes
> > pointer from integer without a cast make[3]: ***
> > [/usr/src/v4l-dvb/v4l/au0828-video.o] Ошибка 1
> > make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-2.6.35'
> > make[1]: *** [default] Ошибка 2
> > make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
> > make: *** [all] Ошибка 2
> 
> Both functions were renamed in upstream, backport created and
> commited, please try again.
> 
> Cheers
> Douglas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Is it better other way round, to rename all appearances of functions and define a macro?
Like this:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
#define usb_alloc_coherent(a, b, c, d) usb_buffer_alloc(a, b, c, d)
#define usb_free_coherent(a, b, c, d) usb_buffer_free(a, b, c, d)
#endif

In the end it will be more similar in code to the last kernel :)

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
