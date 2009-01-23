Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36770 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759616AbZAWQ7Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 11:59:25 -0500
Subject: Re: [hg:v4l-dvb] Merge from master v4l-dvb repo
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <E1LQ7g8-00078n-SU@www.linuxtv.org>
References: <E1LQ7g8-00078n-SU@www.linuxtv.org>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 11:59:09 -0500
Message-Id: <1232729949.3907.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-01-22 at 23:05 +0100, Patch added by Andy Walls wrote:
> The patch number 10282 was added via Andy Walls <awalls@radix.net>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>

No objection per se, just a concern:

This was a "make pull" I unwittingly did on my ~awalls/v4l-dvb repo that
I mentioned.  Hopefully hg is smart enough not to have this merge back
to the main v4l-dvb repo and cause unintentional reverts.

Rgards,
Andy


> ------
> 
> Merge from master v4l-dvb repo
> 
> 
> ---
> 
>  README.patches                                           |   38 
>  linux/Documentation/video4linux/v4lgrab.c                |   25 
>  linux/arch/arm/mach-pxa/devices.c                        |  112 +
>  linux/arch/arm/mach-pxa/pcm990-baseboard.c               |   10 
>  linux/drivers/media/common/tuners/tda8290.c              |    6 
>  linux/drivers/media/common/tuners/tuner-simple.c         |    9 
>  linux/drivers/media/dvb/dm1105/Kconfig                   |    1 
>  linux/drivers/media/dvb/dvb-core/dvb_frontend.c          |   26 
>  linux/drivers/media/dvb/dvb-core/dvbdev.c                |    8 
>  linux/drivers/media/dvb/dvb-usb/anysee.c                 |    2 
>  linux/drivers/media/dvb/dvb-usb/dib0700_devices.c        |   18 
>  linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    2 
>  linux/drivers/media/dvb/frontends/cx24116.c              |    2 
>  linux/drivers/media/dvb/frontends/lgdt3304.c             |   10 
>  linux/drivers/media/dvb/frontends/s921_module.c          |    2 
>  linux/drivers/media/dvb/frontends/stb0899_algo.c         |    7 
>  linux/drivers/media/dvb/frontends/stb0899_drv.c          |    6 
>  linux/drivers/media/dvb/siano/sms-cards.c                |   23 
>  linux/drivers/media/dvb/ttpci/budget-ci.c                |    4 
>  linux/drivers/media/video/bt8xx/bttv-driver.c            |    1 
>  linux/drivers/media/video/cafe_ccic.c                    |    1 
>  linux/drivers/media/video/cs5345.c                       |    1 
>  linux/drivers/media/video/cx23885/cx23885-417.c          |    3 
>  linux/drivers/media/video/cx23885/cx23885-video.c        |    5 
>  linux/drivers/media/video/cx25840/cx25840-core.c         |    2 
>  linux/drivers/media/video/cx88/Kconfig                   |    5 
>  linux/drivers/media/video/cx88/Makefile                  |    3 
>  linux/drivers/media/video/cx88/cx88-dvb.c                |   90 +
>  linux/drivers/media/video/cx88/cx88-i2c.c                |   28 
>  linux/drivers/media/video/cx88/cx88-mpeg.c               |   30 
>  linux/drivers/media/video/cx88/cx88.h                    |    6 
>  linux/drivers/media/video/em28xx/em28xx-cards.c          |    5 
>  linux/drivers/media/video/em28xx/em28xx-core.c           |   11 
>  linux/drivers/media/video/em28xx/em28xx-input.c          |    2 
>  linux/drivers/media/video/em28xx/em28xx-video.c          |   59 
>  linux/drivers/media/video/em28xx/em28xx.h                |   21 
>  linux/drivers/media/video/gspca/m5602/m5602_s5k83a.c     |    2 
>  linux/drivers/media/video/ivtv/ivtv-driver.c             |    4 
>  linux/drivers/media/video/ov7670.c                       |    1 
>  linux/drivers/media/video/ovcamchip/ovcamchip_core.c     |    1 
>  linux/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   12 
>  linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   25 
>  linux/drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    6 
>  linux/drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   12 
>  linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    2 
>  linux/drivers/media/video/pwc/pwc-if.c                   |    1 
>  linux/drivers/media/video/pxa_camera.c                   |    6 
>  linux/drivers/media/video/pxa_camera.h                   |   95 +
>  linux/drivers/media/video/saa7127.c                      |   68 
>  linux/drivers/media/video/saa7134/saa7134-core.c         |    4 
>  linux/drivers/media/video/saa717x.c                      |    1 
>  linux/drivers/media/video/tveeprom.c                     |    3 
>  linux/drivers/media/video/tvp514x.c                      |    2 
>  linux/drivers/media/video/upd64031a.c                    |    1 
>  linux/drivers/media/video/upd64083.c                     |    1 
>  linux/drivers/media/video/usbvideo/ibmcam.c              |    2 
>  linux/drivers/media/video/usbvideo/konicawc.c            |    2 
>  linux/drivers/media/video/usbvideo/ultracam.c            |    2 
>  linux/drivers/media/video/usbvision/usbvision-video.c    |    3 
>  linux/drivers/media/video/uvc/uvc_ctrl.c                 |    7 
>  linux/drivers/media/video/uvc/uvc_driver.c               |   55 
>  linux/drivers/media/video/uvc/uvc_isight.c               |    2 
>  linux/drivers/media/video/uvc/uvc_queue.c                |   31 
>  linux/drivers/media/video/uvc/uvc_status.c               |    3 
>  linux/drivers/media/video/uvc/uvc_v4l2.c                 |   10 
>  linux/drivers/media/video/uvc/uvc_video.c                |   31 
>  linux/drivers/media/video/uvc/uvcvideo.h                 |  236 +--
>  linux/drivers/media/video/v4l1-compat.c                  |    6 
>  linux/drivers/media/video/v4l2-device.c                  |    4 
>  linux/drivers/media/video/v4l2-subdev.c                  |   10 
>  linux/drivers/media/video/videobuf-dma-sg.c              |    3 
>  linux/drivers/media/video/vivi.c                         |  192 ++
>  linux/drivers/media/video/w9968cf.c                      |    1 
>  linux/drivers/media/video/zoran/zoran.h                  |   12 
>  linux/drivers/media/video/zoran/zoran_card.c             |  682 ++++------
>  linux/drivers/media/video/zoran/zoran_card.h             |    2 
>  linux/drivers/media/video/zoran/zoran_driver.c           |  111 -
>  linux/drivers/media/video/zr364xx.c                      |    1 
>  linux/firmware/Makefile                                  |   21 
>  linux/include/media/v4l2-device.h                        |    8 
>  linux/include/media/v4l2-subdev.h                        |    3 
>  v4l/compat.h                                             |   22 
>  v4l/scripts/hg-pull-req.pl                               |    6 
>  v4l/scripts/make_config_compat.pl                        |   20 
>  v4l/versions.txt                                         |    8 
>  85 files changed, 1358 insertions(+), 969 deletions(-)
> 
> <diff discarded since it is too big>
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/262c623d8a28662aca0ce273dbad873d6f69d965
> 

