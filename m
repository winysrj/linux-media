Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4738 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1BGHtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 02:49:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] Remove se401, usbvideo, dabusb and firedtv-1394, fix for empress driver
Date: Mon, 7 Feb 2011 08:48:51 +0100
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Deti Fliegl <deti@fliegl.de>,
	Martin Dauskardt <martin.dauskardt@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102070848.51729.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series removes the last V4L1 drivers (Yay!), the obsolete dabusb driver
and the ieee1394-stack part of the firedtv driver (the IEEE1394 stack was
removed in 2.6.37).

The firedtv changes have been tested and reviewed by Stefan.

I also added a fix for the saa7134-empress driver that was reported by Martin.

Regards,

        Hans

The following changes since commit ffd14aab03dbb8bb1bac5284603835f94d833bd6:
  Devin Heitmueller (1):
        [media] au0828: fix VBI handling when in V4L2 streaming mode

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git v4l1b

Hans Verkuil (5):
      se401/usbvideo: remove last V4L1 drivers
      dabusb: remove obsolete driver
      v4l: removal of old, obsolete ioctls.
      firedtv: remove obsolete ieee1394 backend code
      saa7134-empress: add missing MPEG controls

 Documentation/feature-removal-schedule.txt    |   36 -
 drivers/media/dvb/Kconfig                     |    2 +-
 drivers/media/dvb/firewire/Kconfig            |    8 +-
 drivers/media/dvb/firewire/Makefile           |    5 +-
 drivers/media/dvb/firewire/firedtv-1394.c     |  300 ----
 drivers/media/dvb/firewire/firedtv-dvb.c      |    5 -
 drivers/media/dvb/firewire/firedtv.h          |   14 -
 drivers/media/video/saa7134/saa7134-empress.c |    4 +
 drivers/media/video/v4l2-common.c             |    1 -
 drivers/media/video/v4l2-compat-ioctl32.c     |   15 -
 drivers/media/video/v4l2-ioctl.c              |   38 -
 drivers/staging/Kconfig                       |    6 -
 drivers/staging/Makefile                      |    3 -
 drivers/staging/dabusb/Kconfig                |   14 -
 drivers/staging/dabusb/Makefile               |    2 -
 drivers/staging/dabusb/TODO                   |    5 -
 drivers/staging/dabusb/dabusb.c               |  914 ----------
 drivers/staging/dabusb/dabusb.h               |   85 -
 drivers/staging/easycap/easycap_ioctl.c       |    5 -
 drivers/staging/se401/Kconfig                 |   13 -
 drivers/staging/se401/Makefile                |    1 -
 drivers/staging/se401/TODO                    |    5 -
 drivers/staging/se401/se401.c                 | 1492 -----------------
 drivers/staging/se401/se401.h                 |  236 ---
 drivers/staging/se401/videodev.h              |  318 ----
 drivers/staging/usbvideo/Kconfig              |   15 -
 drivers/staging/usbvideo/Makefile             |    2 -
 drivers/staging/usbvideo/TODO                 |    5 -
 drivers/staging/usbvideo/usbvideo.c           | 2230 -------------------------
 drivers/staging/usbvideo/usbvideo.h           |  395 -----
 drivers/staging/usbvideo/vicam.c              |  952 -----------
 drivers/staging/usbvideo/videodev.h           |  318 ----
 include/linux/videodev2.h                     |   10 -
 33 files changed, 7 insertions(+), 7447 deletions(-)
 delete mode 100644 drivers/media/dvb/firewire/firedtv-1394.c
 delete mode 100644 drivers/staging/dabusb/Kconfig
 delete mode 100644 drivers/staging/dabusb/Makefile
 delete mode 100644 drivers/staging/dabusb/TODO
 delete mode 100644 drivers/staging/dabusb/dabusb.c
 delete mode 100644 drivers/staging/dabusb/dabusb.h
 delete mode 100644 drivers/staging/se401/Kconfig
 delete mode 100644 drivers/staging/se401/Makefile
 delete mode 100644 drivers/staging/se401/TODO
 delete mode 100644 drivers/staging/se401/se401.c
 delete mode 100644 drivers/staging/se401/se401.h
 delete mode 100644 drivers/staging/se401/videodev.h
 delete mode 100644 drivers/staging/usbvideo/Kconfig
 delete mode 100644 drivers/staging/usbvideo/Makefile
 delete mode 100644 drivers/staging/usbvideo/TODO
 delete mode 100644 drivers/staging/usbvideo/usbvideo.c
 delete mode 100644 drivers/staging/usbvideo/usbvideo.h
 delete mode 100644 drivers/staging/usbvideo/vicam.c
 delete mode 100644 drivers/staging/usbvideo/videodev.h

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
