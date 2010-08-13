Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761255Ab0HMCTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 22:19:50 -0400
Received: by gyg10 with SMTP id 10so689030gyg.19
        for <linux-media@vger.kernel.org>; Thu, 12 Aug 2010 19:19:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100812022919.7ce6dace@bk.ru>
References: <20100812022919.7ce6dace@bk.ru>
Date: Thu, 12 Aug 2010 23:19:49 -0300
Message-ID: <AANLkTi=m7YinFKg8pdYCuVTfQyNAvEM7dkVF8WLkOEAb@mail.gmail.com>
Subject: Re: 2.6.35 and current v4l-dvb - error: implicit declaration of
 function 'usb_buffer_free'
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Goga777 <goga777@bk.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

2010/8/11 Goga777 <goga777@bk.ru>:
> Hi
>
> I can't compile current v4l-dvb with new 2.6.35 kernel
>
> arvdr:/usr/src/v4l-dvb# make
> make -C /usr/src/v4l-dvb/v4l
> make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
> creating symbolic links...
> make -C firmware prep
> make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
> make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
> make -C firmware
> make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
> make[2]: Nothing to be done for `default'.
> make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
> Kernel build directory is /lib/modules/2.6.35-tux/build
> make -C /lib/modules/2.6.35-tux/build SUBDIRS=/usr/src/v4l-dvb/v4l šmodules
> make[2]: Entering directory `/usr/src/linux-2.6.35'
> šCC [M] š/usr/src/v4l-dvb/v4l/au0828-video.o
> /usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
> /usr/src/v4l-dvb/v4l/au0828-video.c:185: error: implicit declaration of function 'usb_buffer_free'
> /usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_init_isoc':
> /usr/src/v4l-dvb/v4l/au0828-video.c:255: error: implicit declaration of function 'usb_buffer_alloc'
> /usr/src/v4l-dvb/v4l/au0828-video.c:256: warning: assignment makes pointer from integer without a cast
> make[3]: *** [/usr/src/v4l-dvb/v4l/au0828-video.o] ïÛÉÂËÁ 1
> make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.35'
> make[1]: *** [default] ïÛÉÂËÁ 2
> make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
> make: *** [all] ïÛÉÂËÁ 2
>

Both functions were renamed in upstream, backport created and
commited, please try again.

Cheers
Douglas
