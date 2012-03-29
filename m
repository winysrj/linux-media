Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33714 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab2C2SNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 14:13:23 -0400
Received: by iagz16 with SMTP id z16so3335858iag.19
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2012 11:13:22 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1257)
Subject: Compilation problem : too few arguments to function 'kmap_atomic
From: =?iso-8859-1?Q?Lo=EFc_Bertron?= <loic.bertron@gmail.com>
In-Reply-To: <20120329174427.D1F6E15D201A8@alastor.dyndns.org>
Date: Thu, 29 Mar 2012 14:13:20 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <E9BA201A-4F44-4E01-8553-0977724C79B1@gmail.com>
References: <20120329174427.D1F6E15D201A8@alastor.dyndns.org>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm running into an issue when compiling the last version of media_build : 

/usr/src/linux-headers-2.6.32-5-common/include/linux/kernel.h:366:1: warning: this is the location of the previous definition
  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-control.o
  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-core.o
  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-video.o
  CC [M]  /home/toto/sources/media_build/v4l/hdpvr-i2c.o
  CC [M]  /home/toto/sources/media_build/v4l/hopper_cards.o
  CC [M]  /home/toto/sources/media_build/v4l/hopper_vp3028.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-routing.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-cards.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-controls.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-driver.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-fileops.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-firmware.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-gpio.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-i2c.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-ioctl.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-irq.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-mailbox.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-queue.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-streams.o
  CC [M]  /home/toto/sources/media_build/v4l/ivtv-udma.o
/home/toto/sources/media_build/v4l/ivtv-udma.c: In function 'ivtv_udma_fill_sg_list':
/home/toto/sources/media_build/v4l/ivtv-udma.c:60: error: too few arguments to function 'kmap_atomic'
/home/toto/sources/media_build/v4l/ivtv-udma.c:62:21: error: macro "kunmap_atomic" requires 2 arguments, but only 1 given 
/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error: 'kunmap_atomic' undeclared (first use in this function)
/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error: (Each undeclared identifier is reported only once
/home/toto/sources/media_build/v4l/ivtv-udma.c:62: error: for each function it appears in.)
make[5]: *** [/home/toto/sources/media_build/v4l/ivtv-udma.o] Error 1
make[4]: *** [_module_/home/toto/sources/media_build/v4l] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-5-amd64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/toto/sources/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 410.

After searching a bit on Google, I found someone with the same issue than me who post it today : http://pastebin.com/zgqN7LRE

Any idea ? 