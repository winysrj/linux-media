Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:52417 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDOQqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 12:46:00 -0400
Message-ID: <534D6241.5060903@sca-uk.com>
Date: Tue, 15 Apr 2014 17:45:53 +0100
From: Steve Cookson - IT <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl>
In-Reply-To: <534BEA8A.2040604@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi Hans,
On 14/04/14 15:02, Hans Verkuil wrote:

 > I'd appreciate it if you can test this with a proper video feed.

Well, I've been installing the patch today.  I finished the compilation 
script and the card is not detected.  Here's what I did:

It's been a bit hard-going because my ISP has been on a go-slow and 
everything has taken much longer than it should.

1    I did a fresh build of linux tv.  Deleted ~/linuxtv/media_build and 
then typed:
2    user$ git clone git://linuxtv.org/media_build.git
3    user$ cd media_build
4    user$./build --main-git

     This seemed to be fine.

5    tried to apply the patch (patch -p1 cx23885) but had issues (only 
the main ...card.c was updated and ....h and ...video.c were not 
updated).  As it was only one line each, I applied the updates manually.
6    user$ cd media
7    user$ sudo -s
8    root$ make -C ../v4l  (it scrolled up quickly, but completed with 
no apparent errors
9    root$ make -C ../ install
10    root$ make -C .. rmmod (had a number of errors because of stk1160 
so unplugged EasyCap and re-ran, lots of errors - see below)
11    tried to modprobe cx23885, but got "invalid agrgument"
12    tried to reboot, but ls /dev/video* showed nothing.

Following are the errors from make -C .. rmmo.

The ImpactVCB-e card is installed.  Should I unplug it before doing 
point 11?

Thanks

Steve

PS There is some Portuguese in here, sorry.  It should be fairly self 
explanitory, Entrando is entering, saindo is exiting and diretório is 
err... directory.

make -C .. rmmod
make: Entrando no diretório `/home/image/linuxtv/media_build'
make -C /home/image/linuxtv/media_build/v4l rmmod
make[1]: Entrando no diretório `/home/image/linuxtv/media_build/v4l'
scripts/rmmod.pl unload
found 582 modules
/sbin/rmmod videodev
Pulseaudio is running with UUID(s): 1000
Error: Module videodev is in use by: cx2341x v4l2_common
/sbin/rmmod videobuf_dvb
/sbin/rmmod videobuf_dma_sg
/sbin/rmmod videobuf_core
/sbin/rmmod v4l2_common
Error: Module v4l2_common is in use by: cx2341x
/sbin/rmmod tveeprom
/sbin/rmmod altera_ci
/sbin/rmmod cx2341x
/sbin/rmmod btcx_risc
/sbin/rmmod dvb_core
/sbin/rmmod tda18271
/sbin/rmmod cx2341x
Error: Module cx2341x is not currently loaded
/sbin/rmmod v4l2_common
/sbin/rmmod altera_ci
Error: Module altera_ci is not currently loaded
/sbin/rmmod videodev
/sbin/rmmod videobuf_dma_sg
Error: Module videobuf_dma_sg is not currently loaded
/sbin/rmmod videobuf_dvb
Error: Module videobuf_dvb is not currently loaded
/sbin/rmmod media
/sbin/rmmod btcx_risc
Error: Module btcx_risc is not currently loaded
/sbin/rmmod tda18271
Error: Module tda18271 is not currently loaded
/sbin/rmmod dvb_core
Error: Module dvb_core is not currently loaded
/sbin/rmmod videobuf_core
Error: Module videobuf_core is not currently loaded
/sbin/rmmod tveeprom
Error: Module tveeprom is not currently loaded
/sbin/rmmod altera_stapl
/sbin/rmmod rc_core
/sbin/rmmod videodev
Error: Module videodev is not currently loaded
/sbin/rmmod v4l2_common
Error: Module v4l2_common is not currently loaded
/sbin/rmmod cx2341x
Error: Module cx2341x is not currently loaded
/sbin/rmmod altera_ci
Error: Module altera_ci is not currently loaded
/sbin/rmmod videobuf_dma_sg
Error: Module videobuf_dma_sg is not currently loaded
/sbin/rmmod videobuf_dvb
Error: Module videobuf_dvb is not currently loaded
/sbin/rmmod btcx_risc
Error: Module btcx_risc is not currently loaded
/sbin/rmmod tda18271
Error: Module tda18271 is not currently loaded
/sbin/rmmod dvb_core
Error: Module dvb_core is not currently loaded
/sbin/rmmod videobuf_core
Error: Module videobuf_core is not currently loaded
/sbin/rmmod tveeprom
Error: Module tveeprom is not currently loaded
Couldn't unload: tveeprom videobuf_core dvb_core tda18271 btcx_risc 
videobuf_dvb videobuf_dma_sg altera_ci cx2341x v4l2_common videodev
make[1]: Saindo do diretório `/home/image/linuxtv/media_build/v4l'
make: Saindo do diretório `/home/image/linuxtv/media_build'

root@image-H61M-DS2:~/linuxtv/media_build/media# modprobe cx23885
ERROR: could not insert 'cx23885': Invalid argument

