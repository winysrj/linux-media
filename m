Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33239 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbZKENpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 08:45:43 -0500
Received: by bwz27 with SMTP id 27so10126383bwz.21
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 05:45:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0911050532j1a63fe2fs3f8d15498a87830c@mail.gmail.com>
References: <ad6681df0911050532j1a63fe2fs3f8d15498a87830c@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Thu, 5 Nov 2009 14:45:27 +0100
Message-ID: <ad6681df0911050545n77736609m284816ac6b71ac17@mail.gmail.com>
Subject: Problems using Terratec Cinergy USB T XS with kernel 2.6.31
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I have some problems with Terratec Cinergy USB T XS and kernel 2.6.31:
the device is correctly detected but its tuner is not initialized and
no /dev/dvb device are created on the system.
Also the previous versions of kernel have the same problem, and I
learn by em28xx mailing list that the kernel version of the driver
used for this device doesn't contain the right device's firmware. So
the only way to make this device to work with linux kernel was to use
em28xx-new branch of the driver, containing the missing firmware.
Now this device is declared as supported on linuxtv but the firmware
problem is not solved (in /var/log/messages I found that the driver
looks for xc3028-v27.fw like before, and this firmware is still not
contained in /lib/firmware, I needed to download it like before), but
now also em28xx-new cannot be compiled on 2.6.31 kernel version.
Below the error received compiling the driver:

/usr/local/src/em28xx-new_old/
em28xx-video.c:411: error: �VIDIOC_INT_S_VIDEO_ROUTING� undeclared
(first use in this function)
/usr/local/src/em28xx-new_old/em28xx-video.c:411: error: (Each
undeclared identifier is reported only once
/usr/local/src/em28xx-new_old/em28xx-video.c:411: error: for each
function it appears in.)
/usr/local/src/em28xx-new_old/em28xx-video.c: In function �video_mux�:
/usr/local/src/em28xx-new_old/em28xx-video.c:456: error:
�VIDIOC_INT_S_VIDEO_ROUTING� undeclared (first use in this function)
/usr/local/src/em28xx-new_old/em28xx-video.c:463: error:
�VIDIOC_INT_I2S_CLOCK_FREQ� undeclared (first use in this function)
/usr/local/src/em28xx-new_old/em28xx-video.c: In function �em28xx_v4l2_open�:
/usr/local/src/em28xx-new_old/em28xx-video.c:733: error:
�VIDIOC_INT_S_AUDIO_ROUTING� undeclared (first use in this function)
/usr/local/src/em28xx-new_old/em28xx-video.c: In function
�em28xx_video_do_ioctl�:
/usr/local/src/em28xx-new_old/em28xx-video.c:2458: error: �struct
device� has no member named �bus_id�
/usr/local/src/em28xx-new_old/em28xx-video.c:2870: warning: passing
argument 6 of �em28xx_do_ioctl� from incompatible pointer type
/usr/local/src/em28xx-new_old/em28xx-video.c:1921: note: expected
�v4l2_kioctl� but argument is of type �int (*)(struct file *, unsigned
int,� void *)�
/usr/local/src/em28xx-new_old/em28xx-video.c: In function �em28xx_v4l2_ioctl�:
/usr/local/src/em28xx-new_old/em28xx-video.c:2908: warning: passing
argument 4 of �video_usercopy� from incompatible pointer type
include/media/v4l2-ioctl.h:298: note: expected �v4l2_kioctl� but
argument is of type �int (*)(struct inode *, struct file *, unsigned
int,� void *)�
/usr/local/src/em28xx-new_old/em28xx-video.c: In function �em28xx_init_dev�:
/usr/local/src/em28xx-new_old/em28xx-video.c:3204: warning: assignment
from incompatible pointer type
/usr/local/src/em28xx-new_old/em28xx-video.c:3291: warning: assignment
from incompatible pointer type
/usr/local/src/em28xx-new_old/em28xx-video.c:3330: warning: assignment
from incompatible pointer type
make[3]: *** [/usr/local/src/em28xx-new_old/em28xx-video.o] Errore 1
make[2]: *** [_module_/usr/local/src/em28xx-new_old] Errore 2
make[2]: uscita dalla directory «/usr/src/linux-headers-2.6.31-14-generic»
make[1]: *** [default] Errore 2
make[1]: uscita dalla directory «/usr/local/src/em28xx-new_old»

Is there a way to make this device to work on newer kernel version
using official kernel driver, or em28xx-new version?

Thanks a lot in advance.

Best regards,

Valerio Bontempi
