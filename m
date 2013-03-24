Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1492 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3CXKfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 06:35:00 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2OAYuwg013827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 11:34:59 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D60E511E018E
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 11:34:55 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] v4l2: add const to argument of write-only s_register ioctl.
Date: Sun, 24 Mar 2013 11:34:57 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303241134.57497.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's identical to:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/62324

except it's rebased and as requested by Mauro the cx18 and ivtv changes have
been split off to their own patches.

I did not change the volatile part, changing that is a completely separate
issue and it's still not clear to me whether I can safely remove volatile.
If someone knows a reliable source that tells me that volatile is really
not needed in combination with __iomem, then I can make another patch removing
that, but then I will need to do some testing as well.

Regards,

	Hans

The following changes since commit 27d5a87cf4b44cbcbd0f4706a433e4a68d496236:

  [media] v4l2-ioctl: add precision when printing names (2013-03-24 07:13:54 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git const2

for you to fetch changes up to bdc960ffda5c9517e5171b4063e5d4f83eb5a9b5:

  v4l2-ioctl: simplify debug code. (2013-03-24 11:30:32 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2: add const to argument of write-only s_register ioctl.
      cx18: add const to argument of write-only s_register ioctl.
      ivtv: add const to argument of write-only s_register ioctl.
      v4l2-ioctl: simplify debug code.

 drivers/media/dvb-frontends/au8522_decoder.c    |    2 +-
 drivers/media/i2c/ad9389b.c                     |    2 +-
 drivers/media/i2c/adv7183.c                     |    2 +-
 drivers/media/i2c/adv7604.c                     |    2 +-
 drivers/media/i2c/ak881x.c                      |    2 +-
 drivers/media/i2c/cs5345.c                      |    2 +-
 drivers/media/i2c/cx25840/cx25840-core.c        |    2 +-
 drivers/media/i2c/m52790.c                      |    2 +-
 drivers/media/i2c/mt9m032.c                     |    2 +-
 drivers/media/i2c/mt9v011.c                     |    2 +-
 drivers/media/i2c/ov7670.c                      |    2 +-
 drivers/media/i2c/saa7115.c                     |    2 +-
 drivers/media/i2c/saa7127.c                     |    2 +-
 drivers/media/i2c/saa717x.c                     |    2 +-
 drivers/media/i2c/soc_camera/mt9m001.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c          |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c          |    2 +-
 drivers/media/i2c/soc_camera/ov2640.c           |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c           |    2 +-
 drivers/media/i2c/soc_camera/ov6650.c           |    2 +-
 drivers/media/i2c/soc_camera/ov772x.c           |    2 +-
 drivers/media/i2c/soc_camera/ov9640.c           |    2 +-
 drivers/media/i2c/soc_camera/ov9740.c           |    2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c       |    2 +-
 drivers/media/i2c/soc_camera/tw9910.c           |    2 +-
 drivers/media/i2c/ths7303.c                     |    2 +-
 drivers/media/i2c/tvp5150.c                     |    2 +-
 drivers/media/i2c/tvp7002.c                     |    2 +-
 drivers/media/i2c/upd64031a.c                   |    2 +-
 drivers/media/i2c/upd64083.c                    |    2 +-
 drivers/media/i2c/vs6624.c                      |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c           |    5 ++---
 drivers/media/pci/cx18/cx18-av-core.c           |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c             |   36 ++++++++++++++----------------------
 drivers/media/pci/cx23885/cx23885-ioctl.c       |    9 +++------
 drivers/media/pci/cx23885/cx23885-ioctl.h       |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c       |    2 +-
 drivers/media/pci/cx25821/cx25821-video.h       |    2 +-
 drivers/media/pci/cx88/cx88-video.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c             |   51 ++++++++++++++++++++++++++-------------------------
 drivers/media/pci/saa7134/saa7134-video.c       |    2 +-
 drivers/media/pci/saa7146/mxb.c                 |    3 +--
 drivers/media/pci/saa7164/saa7164-encoder.c     |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c  |    2 +-
 drivers/media/platform/davinci/vpbe_display.c   |    2 +-
 drivers/media/platform/davinci/vpif_capture.c   |    3 ++-
 drivers/media/platform/davinci/vpif_display.c   |    3 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c |    2 +-
 drivers/media/platform/sh_vou.c                 |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c  |    2 +-
 drivers/media/usb/au0828/au0828-video.c         |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c       |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h             |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c         |    2 +-
 drivers/media/usb/gspca/gspca.c                 |    2 +-
 drivers/media/usb/gspca/gspca.h                 |    8 +++++---
 drivers/media/usb/gspca/pac7302.c               |    2 +-
 drivers/media/usb/gspca/sn9c20x.c               |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h         |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c        |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c         |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c   |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |   17 +++--------------
 include/media/v4l2-ioctl.h                      |    2 +-
 include/media/v4l2-subdev.h                     |    2 +-
 69 files changed, 118 insertions(+), 137 deletions(-)
