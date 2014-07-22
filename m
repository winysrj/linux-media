Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:48837 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaGVDgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 23:36:51 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N93009CRGPDYZ70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 23:36:49 -0400 (EDT)
Date: Tue, 22 Jul 2014 00:36:44 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [GIT PULL FOR v3.17] Various fixes and moving solo6x10/go7007 to
 mainline
Message-id: <20140722003644.54c3c783.m.chehab@samsung.com>
In-reply-to: <53CD1EE9.3080402@xs4all.nl>
References: <53CD1EE9.3080402@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Jul 2014 16:08:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Here is a set of various fixes: two important ones in v4l2-ioctl and one
> in vb2. Also some DocBook fixes, a few VBI defines added and documented,
> a davinci bugfix (reported by the new gcc-4.9 compiler I'm now using for the
> daily build) and last but not least the move of the solo6x10 and go7007 out
> of staging into the mainline.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 0ca1ba2aac5f6b26672099b13040c5b40db93486:
> 
>   [media] zoran: remove duplicate ZR050_MO_COMP define (2014-07-17 20:07:57 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.17d
> 
> for you to fetch changes up to f50a1bf86405d8377b245145d3e2d1ef5ced6e32:
> 
>   media: davinci: vpif: fix array out of bound warnings (2014-07-21 16:01:32 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (12):
>       vb2: fix bytesused == 0 handling
>       DocBook media: fix incorrect note about packed RGB and colorspace
>       go7007: update the README, fix checkpatch warnings
>       go7007: move out of staging into drivers/media/usb.
>       solo6x10: a few checkpatch fixes
>       solo6x10: move out of staging into drivers/media/pci.
>       videodev2.h: add defines for the VBI field start lines
>       DocBook media: document new VBI defines
>       v4l2-ctrls: fix corner case in round-to-range code
>       DocBook media typo
>       v4l2-ioctl: set V4L2_CAP_EXT_PIX_FORMAT for device_caps
>       v4l2-ioctl: don't set PRIV_MAGIC unconditionally in g_fmt()
> 
> Prabhakar Lad (1):
>       media: davinci: vpif: fix array out of bound warnings
> 
>  Documentation/DocBook/media/v4l/dev-raw-vbi.xml                   | 12 ++++++---
>  Documentation/DocBook/media/v4l/dev-sliced-vbi.xml                |  9 ++++++-
>  Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml             |  3 ---
>  Documentation/DocBook/media/v4l/vidioc-queryctrl.xml              |  2 +-
>  drivers/media/pci/Kconfig                                         |  1 +
>  drivers/media/pci/Makefile                                        |  1 +
>  drivers/{staging/media => media/pci}/solo6x10/Kconfig             |  2 +-
>  drivers/{staging/media => media/pci}/solo6x10/Makefile            |  2 +-
>  drivers/{staging/media => media/pci}/solo6x10/TODO                |  0

This should be removed, after everything there is done.

>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c     |  6 +----
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c   |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c      |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c      |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h  |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c      |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c     |  5 +---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h     |  4 ---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c |  7 +++---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c     |  8 +++---
>  drivers/{staging/media => media/pci}/solo6x10/solo6x10.h          |  4 ---
>  drivers/media/platform/davinci/vpif_capture.c                     |  2 +-
>  drivers/media/platform/davinci/vpif_display.c                     |  2 +-
>  drivers/media/usb/Kconfig                                         |  1 +
>  drivers/media/usb/Makefile                                        |  1 +
>  drivers/{staging/media => media/usb}/go7007/Kconfig               |  0
>  drivers/{staging/media => media/usb}/go7007/Makefile              |  0
>  drivers/{staging/media => media/usb}/go7007/README                |  1 -

It seems you forgot this there too.

>  drivers/{staging/media => media/usb}/go7007/go7007-driver.c       |  6 +----
>  drivers/{staging/media => media/usb}/go7007/go7007-fw.c           |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007-i2c.c          |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007-loader.c       |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007-priv.h         |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007-usb.c          |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c         |  4 ---
>  drivers/{staging/media => media/usb}/go7007/go7007.txt            |  0
>  drivers/{staging/media => media/usb}/go7007/s2250-board.c         |  9 +++----
>  drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c      | 34 +++++++++++---------------

This driver is not being used, as you forgot to handle it. See README.

I tried to apply the patch there, but the issue is harder, as it tries to
call some functions that don't exist at saa7134.

Please fix it before moving the driver out of staging.

>  drivers/{staging/media => media/usb}/go7007/snd-go7007.c          |  4 ---
>  drivers/media/v4l2-core/v4l2-ctrls.c                              | 17 ++++++++++---
>  drivers/media/v4l2-core/v4l2-ioctl.c                              | 29 +++++++++++++++++-----
>  drivers/media/v4l2-core/videobuf2-core.c                          | 78 +++++++++++++++++++++++++++++------------------------------
>  drivers/staging/media/Kconfig                                     |  4 ---
>  drivers/staging/media/Makefile                                    |  2 --
>  include/uapi/linux/videodev2.h                                    |  6 +++++
>  49 files changed, 134 insertions(+), 192 deletions(-)
>  rename drivers/{staging/media => media/pci}/solo6x10/Kconfig (96%)
>  rename drivers/{staging/media => media/pci}/solo6x10/Makefile (82%)
>  rename drivers/{staging/media => media/pci}/solo6x10/TODO (100%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c (98%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c (97%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c (94%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c (97%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c (98%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c (92%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c (97%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h (97%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h (93%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c (97%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h (99%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c (99%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h (91%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c (99%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c (98%)
>  rename drivers/{staging/media => media/pci}/solo6x10/solo6x10.h (98%)
>  rename drivers/{staging/media => media/usb}/go7007/Kconfig (100%)
>  rename drivers/{staging/media => media/usb}/go7007/Makefile (100%)
>  rename drivers/{staging/media => media/usb}/go7007/README (99%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-driver.c (98%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-fw.c (99%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-i2c.c (96%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-loader.c (94%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-priv.h (97%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-usb.c (99%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c (99%)
>  rename drivers/{staging/media => media/usb}/go7007/go7007.txt (100%)
>  rename drivers/{staging/media => media/usb}/go7007/s2250-board.c (98%)
>  rename drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c (93%)
>  rename drivers/{staging/media => media/usb}/go7007/snd-go7007.c (97%)

I'll apply the patches that don't depend on the rename.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
