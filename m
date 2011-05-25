Return-path: <mchehab@pedra>
Received: from www.youplala.net ([88.191.51.216]:33459 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1EYGvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 02:51:45 -0400
Received: from [192.168.1.70] (host86-154-134-160.range86-154.btcentralplus.com [86.154.134.160])
	by mail.youplala.net (Postfix) with ESMTPSA id 4534FD880B3
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 08:43:19 +0200 (CEST)
Subject: build errors on kinect and rc-main - 2.6.38
From: Nicolas WILL <nico@youplala.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 07:43:08 +0100
Message-ID: <1306305788.2390.4.camel@porites>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm trying to build the media tree using the automatic script and end-up
with at least two errors not allowing me to move forward positively.

Ubuntu 11.04 x86_64 2.6.38-8-generic

First one is on Kinect (don't need it, I can disable the build):

  CC [M]  /home/nico/src/media_build/v4l/kinect.o
/home/nico/src/media_build/v4l/kinect.c:38:19: error: 'D_ERR' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:38:27: error: 'D_PROBE' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:38:37: error: 'D_CONF' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:38:46: error: 'D_STREAM' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:38:57: error: 'D_FRAM' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:38:66: error: 'D_PACK' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:39:2: error: 'D_USBI' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:39:11: error: 'D_USBO' undeclared here (not in a function)
/home/nico/src/media_build/v4l/kinect.c:39:20: error: 'D_V4L2' undeclared here (not in a function)
make[3]: *** [/home/nico/src/media_build/v4l/kinect.o] Error 1
make[2]: *** [_module_/home/nico/src/media_build/v4l] Error 2


The second one is on rc-main (I probably need that!):

  CC [M]  /home/nico/src/media_build/v4l/rc-main.o
/home/nico/src/media_build/v4l/rc-main.c: In function 'rc_allocate_device':
/home/nico/src/media_build/v4l/rc-main.c:993:29: warning: assignment from incompatible pointer type
/home/nico/src/media_build/v4l/rc-main.c:994:29: warning: assignment from incompatible pointer type
  CC [M]  /home/nico/src/media_build/v4l/ir-raw.o
  CC [M]  /home/nico/src/media_build/v4l/mipi-csis.o
/home/nico/src/media_build/v4l/mipi-csis.c:29:28: fatal error: plat/mipi_csis.h: No such file or directory
compilation terminated.


Thanks for looking into it!

Nico

