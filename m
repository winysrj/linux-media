Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPBGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 21:06:17 -0400
Date: Wed, 15 Sep 2010 21:56:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/8] Removal of BKL part 1
Message-ID: <20100915215643.42c697e6@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series remove direct calls for BKL on some V4L drivers. It also uses
.unlocked_ioctl for some of those drivers.

This is a work in progress, as I'm doing the conversion manually. We still need to 
touch on the drivers bellow, just due to explicit call to BKL:

	drivers/media/video/tlg2300/pd-main.c
	drivers/media/video/se401.c
	drivers/media/video/zoran/zoran_driver.c
	drivers/media/video/cx23885/cx23885-417.c
	drivers/media/video/cx23885/cx23885-video.c
	drivers/media/video/usbvideo/vicam.c
	drivers/media/video/usbvision/usbvision-video.c
	drivers/media/video/dabusb.c
	drivers/media/video/pwc/pwc-if.c
	drivers/media/video/v4l2-dev.c
	drivers/media/video/stk-webcam.c

Probably, there are more drivers still using .ioctl, instead of .unsigned_ioctl.

The patches here were not tested yet. Help is needed to test them and to review
the patch series.

Mauro Carvalho Chehab (8):
  V4L/DVB: radio-si470x: remove the BKL lock used internally at the
    driver
  V4L/DVB: radio-si470x: use unlocked ioctl
  V4L/DVB: bttv-driver: document functions using mutex_lock
  V4L/DVB: bttv: fix driver lock and remove explicit calls to BKL
  V4L/DVB: bttv: use unlocked ioctl
  V4L/DVB: cx88: Remove BKL
  V4L/DVB: Deprecate cpia driver (used for parallel port webcams)
  V4L/DVB: Deprecate stradis driver

 Documentation/feature-removal-schedule.txt       |   17 +-
 drivers/media/radio/si470x/radio-si470x-common.c |   27 +-
 drivers/media/radio/si470x/radio-si470x-usb.c    |   17 +-
 drivers/media/radio/si470x/radio-si470x.h        |    2 -
 drivers/media/video/Kconfig                      |   48 -
 drivers/media/video/Makefile                     |    4 -
 drivers/media/video/bt8xx/bttv-driver.c          |  269 +-
 drivers/media/video/cpia.c                       | 4032 ----------------------
 drivers/media/video/cpia.h                       |  432 ---
 drivers/media/video/cpia_pp.c                    |  869 -----
 drivers/media/video/cpia_usb.c                   |  640 ----
 drivers/media/video/cx88/cx88-blackbird.c        |   14 +-
 drivers/media/video/cx88/cx88-video.c            |   17 +-
 drivers/media/video/stradis.c                    | 2213 ------------
 drivers/staging/Kconfig                          |    2 +
 drivers/staging/Makefile                         |    1 +
 drivers/staging/cpia/Kconfig                     |   39 +
 drivers/staging/cpia/Makefile                    |    5 +
 drivers/staging/cpia/TODO                        |    8 +
 drivers/staging/cpia/cpia.c                      | 4032 ++++++++++++++++++++++
 drivers/staging/cpia/cpia.h                      |  432 +++
 drivers/staging/cpia/cpia_pp.c                   |  869 +++++
 drivers/staging/cpia/cpia_usb.c                  |  640 ++++
 drivers/staging/stradis/Kconfig                  |    7 +
 drivers/staging/stradis/Makefile                 |    3 +
 drivers/staging/stradis/TODO                     |    6 +
 drivers/staging/stradis/stradis.c                | 2213 ++++++++++++
 27 files changed, 8496 insertions(+), 8362 deletions(-)
 delete mode 100644 drivers/media/video/cpia.c
 delete mode 100644 drivers/media/video/cpia.h
 delete mode 100644 drivers/media/video/cpia_pp.c
 delete mode 100644 drivers/media/video/cpia_usb.c
 delete mode 100644 drivers/media/video/stradis.c
 create mode 100644 drivers/staging/cpia/Kconfig
 create mode 100644 drivers/staging/cpia/Makefile
 create mode 100644 drivers/staging/cpia/TODO
 create mode 100644 drivers/staging/cpia/cpia.c
 create mode 100644 drivers/staging/cpia/cpia.h
 create mode 100644 drivers/staging/cpia/cpia_pp.c
 create mode 100644 drivers/staging/cpia/cpia_usb.c
 create mode 100644 drivers/staging/stradis/Kconfig
 create mode 100644 drivers/staging/stradis/Makefile
 create mode 100644 drivers/staging/stradis/TODO
 create mode 100644 drivers/staging/stradis/stradis.c

