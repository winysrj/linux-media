Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1665 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1BEMxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 07:53:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] Remove se401, usbvideo, dabusb and firedtv-1394
Date: Sat, 5 Feb 2011 13:53:11 +0100
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Deti Fliegl <deti@fliegl.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051353.11695.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series removes the last V4L1 drivers (Yay!), the obsolete dabusb driver
and the ieee1394-stack part of the firedtv driver (the IEEE1394 stack was
removed in 2.6.37).

Stefan, I went ahead with this since after further research I discovered that
this driver hasn't been compiled at all since 2.6.37! The Kconfig had a
dependency on IEEE1394, so when that config was removed, the driver no longer
appeared in the config.

I removed any remaining reference to IEEE1394 and changed the Kconfig dependency
to FIREWIRE. At least it compiles again :-)

Regards,

	Hans


The following changes since commit ffd14aab03dbb8bb1bac5284603835f94d833bd6:
  Devin Heitmueller (1):
        [media] au0828: fix VBI handling when in V4L2 streaming mode

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git v4l1

Hans Verkuil (3):
      se401/usbvideo: remove last V4L1 drivers
      dabusb: remove obsolete driver
      firedtv: remove dependency on the deleted ieee1394 stack.

 Documentation/feature-removal-schedule.txt |   15 -
 drivers/media/dvb/Kconfig                  |    2 +-
 drivers/media/dvb/firewire/Kconfig         |    8 +-
 drivers/media/dvb/firewire/Makefile        |    2 -
 drivers/media/dvb/firewire/firedtv-1394.c  |  300 ----
 drivers/media/dvb/firewire/firedtv-dvb.c   |    5 -
 drivers/media/dvb/firewire/firedtv.h       |   14 -
 drivers/staging/Kconfig                    |    6 -
 drivers/staging/Makefile                   |    3 -
 drivers/staging/dabusb/Kconfig             |   14 -
 drivers/staging/dabusb/Makefile            |    2 -
 drivers/staging/dabusb/TODO                |    5 -
 drivers/staging/dabusb/dabusb.c            |  914 ------------
 drivers/staging/dabusb/dabusb.h            |   85 --
 drivers/staging/se401/Kconfig              |   13 -
 drivers/staging/se401/Makefile             |    1 -
 drivers/staging/se401/TODO                 |    5 -
 drivers/staging/se401/se401.c              | 1492 -------------------
 drivers/staging/se401/se401.h              |  236 ---
 drivers/staging/se401/videodev.h           |  318 ----
 drivers/staging/usbvideo/Kconfig           |   15 -
 drivers/staging/usbvideo/Makefile          |    2 -
 drivers/staging/usbvideo/TODO              |    5 -
 drivers/staging/usbvideo/usbvideo.c        | 2230 ----------------------------
 drivers/staging/usbvideo/usbvideo.h        |  395 -----
 drivers/staging/usbvideo/vicam.c           |  952 ------------
 drivers/staging/usbvideo/videodev.h        |  318 ----
 27 files changed, 2 insertions(+), 7355 deletions(-)
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
