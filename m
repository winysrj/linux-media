Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:10223 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3JNM2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 08:28:47 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUN00AXYRZTXS40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Oct 2013 08:28:45 -0400 (EDT)
Date: Mon, 14 Oct 2013 09:28:39 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR v3.13] Various fixes
Message-id: <20131014092839.6049ee6a@samsung.com>
In-reply-to: <524E9A77.7090205@xs4all.nl>
References: <524E9A77.7090205@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Oct 2013 12:37:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Just a bunch of various fixes. Most notably the solo fixes for big-endian systems:
> these fixes were removed when I did the large sync to the Bluecherry code base for the
> solo driver. Many thanks to Krzysztof for doing this work again.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit d10e8280c4c2513d3e7350c27d8e6f0fa03a5f71:
> 
>   [media] cx24117: use hybrid_tuner_request/release_state to share state between multiple instances (2013-10-03 07:40:12 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.13
> 
> for you to fetch changes up to fffc9c8a324c7b43db9e359ae4710176fa66f432:
> 
>   radio-sf16fmr2: Remove redundant dev_set_drvdata (2013-10-04 12:32:42 +0200)
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       snd_tea575x: precedence bug in fmr2_tea575x_get_pins()
> 
> Krzysztof Hałasa (4):
>       SOLO6x10: don't do DMA from stack in solo_dma_vin_region().
>       SOLO6x10: Remove unused #define SOLO_DEFAULT_GOP
>       SOLO6x10: Fix video encoding on big-endian systems.
>       SOLO6x10: Fix video headers on certain hardware.
> 
> Michael Opdenacker (1):
>       davinci: remove deprecated IRQF_DISABLED
> 
> Sachin Kamat (1):
>       radio-sf16fmr2: Remove redundant dev_set_drvdata
> 
> Sylwester Nawrocki (1):
>       v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function prototype

This patch is wrong or incomplete, as it calls hundreds of warnings (see below).
I'll just drop it:

$ make ARCH=i386 CONFIG_DEBUG_SECTION_MISMATCH=y W=1 M=drivers/staging/media

  WARNING: Symbol version dump /devel/v4l/patchwork/Module.symvers
           is missing; modules will have no dependencies and modversions.

In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/go7007/s2250-board.c:24:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/msi3101/sdr-msi3101.c:44:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/staging/media/go7007/go7007-driver.c:35:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/go7007/go7007-priv.h:24,
                 from drivers/staging/media/go7007/go7007-fw.c:37:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/go7007/go7007-priv.h:24,
                 from drivers/staging/media/go7007/snd-go7007.c:36:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-p2m.c:29:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-i2c.c:35:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-tw28.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-gpio.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/staging/media/dt3155v4l/dt3155v4l.c:29:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-enc.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/go7007/go7007-priv.h:24,
                 from drivers/staging/media/go7007/go7007-usb.c:33:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-disp.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-core.c:35:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/go7007/go7007-priv.h:24,
                 from drivers/staging/media/go7007/go7007-i2c.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/staging/media/solo6x10/solo6x10-v4l2.c:31:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:31:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/staging/media/go7007/go7007-v4l2.c:33:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-eeprom.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/staging/media/solo6x10/solo6x10.h:40,
                 from drivers/staging/media/solo6x10/solo6x10-g723.c:38:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
  Building modules, stage 2.
  MODPOST 0 modules
$ make ARCH=i386 CONFIG_DEBUG_SECTION_MISMATCH=y W=1 M=drivers/media

  WARNING: Symbol version dump /devel/v4l/patchwork/Module.symvers
           is missing; modules will have no dependencies and modversions.

In file included from drivers/media/common/cx2341x.c:31:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/parport/w9966.c:62:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/radio/radio-isa.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/parport/pms.c:38:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/parport/c-qcam.c:40:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/parport/bw-qcam.c:77:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/vivi.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/tuners/tuner-simple.c:11:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/v4l2-core/tuner-core.c:31:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/i2c/msp3400-driver.c:57:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/common/tveeprom.c:42:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/via-camera.c:18:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/timblogiw.c:32:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/saa7146_vv.h:4:0,
                 from drivers/media/common/saa7146/saa7146_i2c.c:3:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/cx23885/cx23885.h:27,
                 from drivers/media/pci/cx23885/cx23885-cards.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/cx18/cx18-alsa-main.c:32:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/hdpvr/hdpvr-control.c:22:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/v4l2-core/v4l2-dev.c:30:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/au0828/au0828-core.c:25:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/cpia2/cpia2.h:37:0,
                 from drivers/media/usb/cpia2/cpia2_v4l.c:44:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/cx25821/cx25821.h:34:0,
                 from drivers/media/pci/cx25821/cx25821-core.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/stkwebcam/stk-webcam.c:36:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/tm6000/tm6000-cards.c:27:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/v4l2-core/v4l2-ioctl.c:23:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/vsp1/vsp1.h:22,
                 from drivers/media/platform/vsp1/vsp1_drv.c:22:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/saa7146_vv.h:4:0,
                 from drivers/media/pci/saa7146/mxb.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/pwc/pwc.h:37:0,
                 from drivers/media/usb/pwc/pwc-if.c:73:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/meye/meye.c:35:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/sh_veu.c:26:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/usbvision/usbvision-core.c:41:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/hdpvr/hdpvr-core.c:27:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/bt8xx/bttvp.h:38:0,
                 from drivers/media/pci/bt8xx/bttv-cards.c:42:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/s2255/s2255drv.c:49:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/ivtv/ivtv-alsa-main.c:32:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/em28xx/em28xx.h:35,
                 from drivers/media/usb/em28xx/em28xx-video.c:40:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/saa7134/saa6752hs.c:36:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/bt8xx/bttvp.h:38:0,
                 from drivers/media/pci/bt8xx/bttv-driver.c:49:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/cx88/cx88.h:28,
                 from drivers/media/pci/cx88/cx88-video.c:40:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/ivtv/ivtv-alsa-pcm.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/sn9c102/sn9c102.h:26:0,
                 from drivers/media/usb/sn9c102/sn9c102_core.c:42:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/mem2mem_testdev.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h:41,
                 from drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c:25:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/v4l2-core/v4l2-device.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/usbtv/usbtv.c:38:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/marvell-ccic/cafe-driver.c:29:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/sta2x11/sta2x11_vip.c:40:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/dvb-frontends/au8522_priv.h:31,
                 from drivers/media/dvb-frontends/au8522_common.c:27:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from include/media/soc_camera.h:24,
                 from drivers/media/platform/soc_camera/soc_camera.c:32:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/au0828/au0828.h:30,
                 from drivers/media/usb/au0828/au0828-i2c.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/em28xx/em28xx-audio.c:46:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stk1160/stk1160.h:27,
                 from drivers/media/usb/stk1160/stk1160-core.c:39:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stk1160/stk1160-v4l.c:29:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/zoran/zoran.h:34,
                 from drivers/media/pci/zoran/zoran_procfs.c:49:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/saa7164/saa7164.h:64:0,
                 from drivers/media/pci/saa7164/saa7164-cards.c:27:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/cx231xx/cx231xx-audio.c:39:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/tlg2300/pd-common.h:12,
                 from drivers/media/usb/tlg2300/pd-video.c:13:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/gspca/gspca.h:8:0,
                 from drivers/media/usb/gspca/benq.c:25:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/saa7164/saa7164.h:64:0,
                 from drivers/media/pci/saa7164/saa7164-core.c:36:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/au0828/au0828.h:30,
                 from drivers/media/usb/au0828/au0828-cards.c:22:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/em28xx/em28xx.h:35,
                 from drivers/media/usb/em28xx/em28xx-input.c:31:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from include/media/saa7146.h:15,
                 from drivers/media/pci/ttpci/budget.h:16,
                 from drivers/media/pci/ttpci/budget-core.c:38:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/gspca/gspca.h:8:0,
                 from drivers/media/usb/gspca/cpia1.c:34:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/saa7146_vv.h:4:0,
                 from drivers/media/common/saa7146/saa7146_fops.c:3:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/hdpvr/hdpvr-video.c:26:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/radio/radio-rtrack2.c:23:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/gspca/gspca.h:8:0,
                 from drivers/media/usb/gspca/conex.c:26:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/i2c/msp3400-kthreads.c:28:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from include/media/saa7146.h:15,
                 from drivers/media/common/saa7146/saa7146_core.c:23:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/uvc/uvc_driver.c:26:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/zr364xx/zr364xx.c:38:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h:41,
                 from drivers/media/usb/pvrusb2/pvrusb2-audio.h:25,
                 from drivers/media/usb/pvrusb2/pvrusb2-audio.c:22:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/platform/m2m-deinterlace.c:20:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/radio/radio-aztech.c:25:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/cx18/cx18-alsa-pcm.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/zoran/zoran_device.c:40:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stk1160/stk1160.h:27,
                 from drivers/media/usb/stk1160/stk1160-video.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/hdpvr/hdpvr.h:18,
                 from drivers/media/usb/hdpvr/hdpvr-i2c.c:22:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/au0828/au0828-dvb.c:27:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/pci/cx23885/cx23885.h:27,
                 from drivers/media/pci/cx23885/cx23885-video.c:34:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from drivers/media/platform/vsp1/vsp1_entity.c:18:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stk1160/stk1160.h:27,
                 from drivers/media/usb/stk1160/stk1160-i2c.c:27:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/cpia2/cpia2.h:37:0,
                 from drivers/media/usb/cpia2/cpia2_usb.c:36:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/cpia2/cpia2.h:37:0,
                 from drivers/media/usb/cpia2/cpia2_core.c:32:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stk1160/stk1160.h:27,
                 from drivers/media/usb/stk1160/stk1160-ac97.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/saa7146_vv.h:4:0,
                 from drivers/media/pci/saa7146/hexium_orion.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h:41,
                 from drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h:35,
                 from drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c:30:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/ivtv/ivtv-driver.h:61:0,
                 from drivers/media/pci/ivtv/ivtv-routing.c:21:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/ivtv/ivtv-driver.h:61:0,
                 from drivers/media/pci/ivtv/ivtv-controls.c:21:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/gspca/gspca.h:8:0,
                 from drivers/media/usb/gspca/etoms.c:25:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/ivtv/ivtv-driver.h:61:0,
                 from drivers/media/pci/ivtv/ivtv-cards.c:21:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/pci/saa7134/saa7134.h:36:0,
                 from drivers/media/pci/saa7134/saa7134-cards.c:29:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/stkwebcam/stk-webcam.h:26,
                 from drivers/media/usb/stkwebcam/stk-sensor.c:48:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/tuners/tda9887.c:9:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/tm6000/tm6000.h:24:0,
                 from drivers/media/usb/tm6000/tm6000-core.c:28:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from drivers/media/usb/au0828/au0828-video.c:36:0:
include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);
                   ^
In file included from include/media/v4l2-subdev.h:28:0,
                 from include/media/v4l2-device.h:25,
                 from drivers/media/usb/em28xx/em28xx.h:35,
                 from drivers/media/usb/em28xx/em28xx-i2c.c:30:

...

-- 

Cheers,
Mauro
