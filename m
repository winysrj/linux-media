Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:33495 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2AWJMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:12:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel Schroll <schroll.daniel@gmx.de>
Subject: Re: problems with building newest media_build.git commit 17f42a807d5d6e7e783f0498916411a5e595edb6
Date: Mon, 23 Jan 2012 10:11:55 +0100
Cc: linux-media@vger.kernel.org
References: <CAC+ttRoSojO3LYRQVgmrbLKn9dQ-AMa8FJ1KVn6skx06-dtxeg@mail.gmail.com> <CAC+ttRpdZ5-mH_xUDtoMXAPefXM9CKqWsFkv=dsiA6aMxex+aQ@mail.gmail.com>
In-Reply-To: <CAC+ttRpdZ5-mH_xUDtoMXAPefXM9CKqWsFkv=dsiA6aMxex+aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231011.55090.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 January 2012 01:18:05 Daniel Schroll wrote:
> Hi all,
> 
> I am trying to build the last driver-set in order to get my dvbc
> USB-Stick "Terratec Cinergy HTC Stick HD" running.
> 
> output of lsusb
> Bus 001 Device 009: ID 0ccd:00b2 TerraTec Electronic GmbH
> 
> I followed the instructions on
> 
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_
> Device_Drivers#Building.2FCompiling_the_Modules
> 
> the build-process of the commit
> 17f42a807d5d6e7e783f0498916411a5e595edb6 ended in errors:
> 
> 
> 
>  CC [M]  /home/user/Downloads/git/media_build/v4l/saa7134-dvb.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx88xx.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx8800.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx8802.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx88-alsa.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx88-blackbird.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx88-dvb.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx88-vp3054-i2c.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/em28xx.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/em28xx-alsa.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/em28xx-dvb.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/poseidon.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx231xx.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx231xx-alsa.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx231xx-dvb.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cx25821.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/cx25821-alsa.o
> /home/user/Downloads/git/media_build/v4l/cx25821-alsa.c:23:0: warning:
> "pr_fmt" redefined [enabled by default]
> include/linux/printk.h:152:0: note: this is the location of the
> previous definition
>  LD [M]  /home/user/Downloads/git/media_build/v4l/usbvision.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/pvrusb2.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/cpia2.o
>  LD [M]  /home/user/Downloads/git/media_build/v4l/tm6000.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/tm6000-alsa.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/tm6000-dvb.o
>  CC [M]  /home/user/Downloads/git/media_build/v4l/mxb.o
> /home/user/Downloads/git/media_build/v4l/mxb.c:24:0: warning: "pr_fmt"
> redefined [enabled by default]
> include/linux/printk.h:152:0: note: this is the location of the
> previous definition
>  CC [M]  /home/user/Downloads/git/media_build/v4l/hexium_orion.o
> /home/user/Downloads/git/media_build/v4l/hexium_orion.c:24:0: warning:
> "pr_fmt" redefined [enabled by default]
> include/linux/printk.h:152:0: note: this is the location of the
> previous definition
>  CC [M]  /home/user/Downloads/git/media_build/v4l/hexium_gemini.o
> /home/user/Downloads/git/media_build/v4l/hexium_gemini.c:24:0:
> warning: "pr_fmt" redefined [enabled by default]
> include/linux/printk.h:152:0: note: this is the location of the
> previous definition
>  CC [M]  /home/user/Downloads/git/media_build/v4l/timblogiw.o
> /home/user/Downloads/git/media_build/v4l/timblogiw.c: In function
> 'buffer_queue':
> /home/user/Downloads/git/media_build/v4l/timblogiw.c:568:22: error:
> 'DMA_DEV_TO_MEM' undeclared (first use in this function)
> /home/user/Downloads/git/media_build/v4l/timblogiw.c:568:22: note:
> each undeclared identifier is reported only once for each function it
> appears in
> make[3]: *** [/home/user/Downloads/git/media_build/v4l/timblogiw.o] Error 1
> make[2]: *** [_module_/home/user/Downloads/git/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-3.0.0-15-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/user/Downloads/git/media_build/v4l'
> make: *** [all] Error 2
> build failed at ./build line 383.
> 
> 
> 
> 
> I tried to build the previous commit
> (25c307ca24b03caff9e289daf179a1a5629c798d), too, but it resulted in
> the same errors.
> 
> My System:
> 
> Intel Atom D525 CPU (ASUS S1-AT5NM10E)
> Ubuntu 11.10 with 3.0.0-15-generic x86_64 Kernel
> 
> Hope, that no important informations are missing.

Fixed in the latest media_build. Thanks for the report.

Regards,

	Hans
