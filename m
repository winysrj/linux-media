Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3380 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0LYLJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 06:09:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] V4L1 removal patches for 2.6.38
Date: Sat, 25 Dec 2010 12:08:51 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012251208.51865.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

This patch series removes almost all V4L1 code except for two drivers that
are not yet converted. These are moved to staging and marked for removal in
2.6.39.

- Removes V4L1 compatibility layer. V4L1 compatibility is now fully handled
  by libv4l1.
- Removes deprecated drivers: ibmcam/ultracam, konicawc, stradis, cpia
- Deprecate se401 and usbvideo (vicam), moving them to staging
- Update docs
- Update feature-removal-schedule: the last V4L1 drivers and the V4L1 API are
  scheduled for removal in 2.6.39.

This patch series removes almost 17000 lines of code :-)

Regards,

	Hans

The following changes since commit 884d09f0d9f2eb6848c71fd024c250816f835572:
  Sam Doshi (1):
        [media] drivers:media:dvb: add USB PIDs for Elgato EyeTV Sat

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git v4l1

Hans Verkuil (10):
      V4L: remove V4L1 compatibility mode.
      zoran: remove V4L1 compat code and zoran custom ioctls
      videobuf-dma-sg: remove obsolete comments.
      documentation: update some files to reflect the V4L1 compat removal.
      usbvideo: remove deprecated drivers.
      usbvideo: deprecate the vicam driver
      se401: deprecate driver, move to staging.
      cpia, stradis: remove deprecated V4L1 drivers
      feature-removal: update V4L1 removal status.
      stk-webcam: remove V4L1 compatibility code, replace with V4L2 controls.

 Documentation/feature-removal-schedule.txt         |   24 +-
 Documentation/video4linux/README.cpia              |  191 -
 Documentation/video4linux/Zoran                    |   74 +-
 Documentation/video4linux/bttv/Cards               |    4 -
 Documentation/video4linux/meye.txt                 |   10 +-
 Documentation/video4linux/videobuf                 |    7 +-
 MAINTAINERS                                        |    6 -
 drivers/media/Kconfig                              |   15 -
 drivers/media/common/saa7146_video.c               |   32 -
 drivers/media/video/Kconfig                        |   13 -
 drivers/media/video/Makefile                       |    9 -
 drivers/media/video/au0828/au0828-video.c          |   12 -
 drivers/media/video/bt8xx/bttv-driver.c            |   28 -
 drivers/media/video/cpia2/cpia2_v4l.c              |   38 -
 drivers/media/video/cx231xx/cx231xx-video.c        |   12 -
 drivers/media/video/cx23885/cx23885-video.c        |   32 -
 drivers/media/video/cx88/cx88-video.c              |   12 -
 drivers/media/video/em28xx/em28xx-video.c          |   16 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    4 +-
 drivers/media/video/pwc/pwc-v4l.c                  |   17 -
 drivers/media/video/s2255drv.c                     |   12 -
 drivers/media/video/saa7134/saa7134-video.c        |   11 -
 drivers/media/video/stk-webcam.c                   |  148 +-
 drivers/media/video/usbvideo/Kconfig               |   45 -
 drivers/media/video/usbvideo/Makefile              |    4 -
 drivers/media/video/usbvideo/ibmcam.c              | 3977 -------------------
 drivers/media/video/usbvideo/konicawc.c            |  992 -----
 drivers/media/video/usbvideo/ultracam.c            |  685 ----
 drivers/media/video/usbvision/usbvision-video.c    |    3 -
 drivers/media/video/uvc/uvc_v4l2.c                 |    7 +-
 drivers/media/video/v4l1-compat.c                  | 1277 -------
 drivers/media/video/v4l2-compat-ioctl32.c          |  325 --
 drivers/media/video/v4l2-ioctl.c                   |   86 -
 drivers/media/video/via-camera.c                   |   13 -
 drivers/media/video/videobuf-core.c                |   30 -
 drivers/media/video/videobuf-dma-sg.c              |   31 -
 drivers/media/video/vivi.c                         |   12 -
 drivers/media/video/zoran/zoran.h                  |  107 -
 drivers/media/video/zoran/zoran_card.c             |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |  321 --
 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    4 +-
 drivers/staging/cpia/Kconfig                       |   39 -
 drivers/staging/cpia/Makefile                      |    5 -
 drivers/staging/cpia/TODO                          |    8 -
 drivers/staging/cpia/cpia.c                        | 4028 --------------------
 drivers/staging/cpia/cpia.h                        |  432 ---
 drivers/staging/cpia/cpia_pp.c                     |  869 -----
 drivers/staging/cpia/cpia_usb.c                    |  640 ----
 drivers/staging/cx25821/cx25821-video.c            |   31 -
 drivers/staging/cx25821/cx25821-video.h            |    6 -
 drivers/staging/dt3155v4l/dt3155v4l.c              |    3 -
 drivers/staging/se401/Kconfig                      |   13 +
 drivers/staging/se401/Makefile                     |    1 +
 drivers/{media/video => staging/se401}/se401.c     |    0
 drivers/{media/video => staging/se401}/se401.h     |    0
 drivers/staging/stradis/Kconfig                    |    7 -
 drivers/staging/stradis/Makefile                   |    3 -
 drivers/staging/stradis/TODO                       |    6 -
 drivers/staging/stradis/stradis.c                  | 2222 -----------
 drivers/staging/tm6000/tm6000-video.c              |   12 -
 drivers/staging/usbvideo/Kconfig                   |   15 +
 drivers/staging/usbvideo/Makefile                  |    2 +
 .../{media/video => staging}/usbvideo/usbvideo.c   |    0
 .../{media/video => staging}/usbvideo/usbvideo.h   |    0
 drivers/{media/video => staging}/usbvideo/vicam.c  |    0
 include/linux/videodev.h                           |   22 +-
 include/media/v4l2-ioctl.h                         |   22 +-
 include/media/videobuf-core.h                      |    8 -
 69 files changed, 92 insertions(+), 16954 deletions(-)
 delete mode 100644 Documentation/video4linux/README.cpia
 delete mode 100644 drivers/media/video/usbvideo/Kconfig
 delete mode 100644 drivers/media/video/usbvideo/Makefile
 delete mode 100644 drivers/media/video/usbvideo/ibmcam.c
 delete mode 100644 drivers/media/video/usbvideo/konicawc.c
 delete mode 100644 drivers/media/video/usbvideo/ultracam.c
 delete mode 100644 drivers/media/video/v4l1-compat.c
 delete mode 100644 drivers/staging/cpia/Kconfig
 delete mode 100644 drivers/staging/cpia/Makefile
 delete mode 100644 drivers/staging/cpia/TODO
 delete mode 100644 drivers/staging/cpia/cpia.c
 delete mode 100644 drivers/staging/cpia/cpia.h
 delete mode 100644 drivers/staging/cpia/cpia_pp.c
 delete mode 100644 drivers/staging/cpia/cpia_usb.c
 create mode 100644 drivers/staging/se401/Kconfig
 create mode 100644 drivers/staging/se401/Makefile
 rename drivers/{media/video => staging/se401}/se401.c (100%)
 rename drivers/{media/video => staging/se401}/se401.h (100%)
 delete mode 100644 drivers/staging/stradis/Kconfig
 delete mode 100644 drivers/staging/stradis/Makefile
 delete mode 100644 drivers/staging/stradis/TODO
 delete mode 100644 drivers/staging/stradis/stradis.c
 create mode 100644 drivers/staging/usbvideo/Kconfig
 create mode 100644 drivers/staging/usbvideo/Makefile
 rename drivers/{media/video => staging}/usbvideo/usbvideo.c (100%)
 rename drivers/{media/video => staging}/usbvideo/usbvideo.h (100%)
 rename drivers/{media/video => staging}/usbvideo/vicam.c (100%)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
