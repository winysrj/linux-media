Return-path: <mchehab@pedra>
Received: from mx33.mail.ru ([94.100.176.47]:53868 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab0HKWWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 18:22:13 -0400
Received: from [95.53.178.138] (port=29594 helo=localhost.localdomain)
	by mx33.mail.ru with asmtp
	id 1OjJga-000HfO-00
	for linux-media@vger.kernel.org; Thu, 12 Aug 2010 02:22:12 +0400
Date: Thu, 12 Aug 2010 02:29:19 +0400
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: 2.6.35 and current v4l-dvb - error: implicit declaration of
 function 'usb_buffer_free'
Message-ID: <20100812022919.7ce6dace@bk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi

I can't compile current v4l-dvb with new 2.6.35 kernel 

arvdr:/usr/src/v4l-dvb# make
make -C /usr/src/v4l-dvb/v4l
make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/usr/src/v4l-dvb/v4l/firmware'
make[2]: Nothing to be done for `default'.
make[2]: Leaving directory `/usr/src/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.35-tux/build
make -C /lib/modules/2.6.35-tux/build SUBDIRS=/usr/src/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.35'
  CC [M]  /usr/src/v4l-dvb/v4l/au0828-video.o
/usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_uninit_isoc':
/usr/src/v4l-dvb/v4l/au0828-video.c:185: error: implicit declaration of function 'usb_buffer_free'
/usr/src/v4l-dvb/v4l/au0828-video.c: In function 'au0828_init_isoc':
/usr/src/v4l-dvb/v4l/au0828-video.c:255: error: implicit declaration of function 'usb_buffer_alloc'
/usr/src/v4l-dvb/v4l/au0828-video.c:256: warning: assignment makes pointer from integer without a cast
make[3]: *** [/usr/src/v4l-dvb/v4l/au0828-video.o] Ошибка 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.35'
make[1]: *** [default] Ошибка 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Ошибка 2


