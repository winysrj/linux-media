Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:53992 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964960AbcJVRgT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 13:36:19 -0400
Reply-To: <ps00de@yahoo.de>
From: <ps00de@yahoo.de>
To: "'Mauro Carvalho Chehab'" <mchehab@s-opensource.com>,
        <ps00de@yahoo.de>
Cc: <linux-media@vger.kernel.org>
References: <000901d22a39$9de21e70$d9a65b50$@yahoo.de> <20161019171419.3343cdd5@vento.lan>
In-Reply-To: <20161019171419.3343cdd5@vento.lan>
Subject: AW: em28xx WinTV dualHD in Raspbian
Date: Sat, 22 Oct 2016 19:36:13 +0200
Message-ID: <009201d22c8a$c93b9580$5bb2c080$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I gave up and compiled an 4.7 Kernel (Option 3) - now it works out of the
box.

Hopefully some driver expert can get the second tuner working, that would be
awesome

Thanks,
Patrick

-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] Im Auftrag von Mauro Carvalho
Chehab
Gesendet: Mittwoch, 19. Oktober 2016 21:14
An: ps00de@yahoo.de
Cc: linux-media@vger.kernel.org
Betreff: Re: em28xx WinTV dualHD in Raspbian

Em Wed, 19 Oct 2016 20:50:09 +0200
<ps00de@yahoo.de> escreveu:

> > Based on this log:
> > 
> > Oct 18 23:08:01 mediapi kernel: [ 7590.369200] em28xx_dvb: disagrees 
> > about version of symbol dvb_dmxdev_init Oct 18 23:08:01 mediapi 
> > kernel: [ 7590.369228] em28xx_dvb: Unknown symbol dvb_dmxdev_init 
> > (err -22)
> > 
> > it seems you messed the modules install or you have the V4L2 stack
compiled builtin with a different version.   
> 
> How to fix this?
> 
> - I reinstalled the current firmware and kernel on the raspberry.
> - I installed the headers with sudo apt-get install 
> raspberrypi-kernel-headers
> - Then I have cloned, build and installed the modules:
> 
> git clone git://linuxtv.org/media_build.git cd media_build ./build 
> sudo make install
> 
> But the same errors appear again.

There are 3 options:

1) If the V4L core is builtin on your Kernel [1], then you'll need recompile
the Kernel yourself and be sure that V4L will be disabled. Then, you can
build V4L2 using the media_build tree.
You'll likely need to fix the DRM driver dependencies through, by modifying
the Kernel source code (actually, some Kconfig file).

2) To use the em28xx driver that came at the RPi Kernel, instead of using
media_build.git. You'll also need to recompile the RPi proprietary Kernel
from its sources;

3) use the upstream Kernel. If I remember correctly, the VC4 driver (needed
for GPU support) was added on Kernel 4.7. If you're not using a camera
sensor connected to your RPi, the VC4 driver should be enough for your
needs.

[1] If you're using the RPi proprietary Kernel, I bet you have the
V4L2 core built in. I remember I found the same issue last year, while
playing with RPi proprietary Kernel - part of their GPU driver was depending
on CONFIG_MEDIA - I think - for no good reason. I used to have a patch
fixing it somewhere, but I was unable to find it.

> 
> Thanks,
> Patrick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



Thanks,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

