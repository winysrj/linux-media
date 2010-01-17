Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0AQNyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 08:54:54 -0500
Message-ID: <4B5316A3.6010501@redhat.com>
Date: Sun, 17 Jan 2010 11:54:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.33] V4L/DVB fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following fixes:

   - cx25821: fix double unlock in medusa_video_init()
   - dib8000: fix compilation if !DVB_DIB8000
   - feature-removal-schedule: Add v4l1 drivers obsoleted by gspca sub drivers
   - gspca core: Set the current frame pointer when first qbuf.
   - gspca subdriver fixes:
	- 5k4aa: Add vflip quirk for the Amilo Xi 2428
	- ov534: Fix a compilation warning
	- sn9c20x: Fix test of unsigned
	- stv06xx-vv6410: Ensure register STV_SCAN_RATE is zero
	- sunplus: Fix bridge exchanges
	- vc032x: Fix a possible crash with the vc0321 bridge.
   - ir-keytable: use the right header
   - lgdt3305: make one-bit bitfields unsigned
   - MAINTAINERS: Andy Walls is the new ivtv maintainer and the ivtv list is moderated
   - mx1_camera: don't check platform_get_irq's return value against zero
   - rj54n1cb0c: remove compiler warning
   - saa7134: DVB-T regression fix
   - sh_mobile_ceu: don't check platform_get_irq's return value against zero
   - tda8290: add autodetection support for TDA8295c2 and fix FM radio
   - uvcvideo: fix alt setting for isoc mode, controls backlists and an oops due to a race condition

Cheers,
Mauro.

---

 Documentation/feature-removal-schedule.txt         |   49 ++++++++++++++++++++
 MAINTAINERS                                        |    7 +--
 drivers/media/IR/ir-keytable.c                     |    2 +-
 drivers/media/common/tuners/tda8290.c              |   12 +++--
 drivers/media/dvb/frontends/dib8000.h              |    2 +-
 drivers/media/dvb/frontends/lgdt3305.h             |    6 +-
 drivers/media/video/gspca/gspca.c                  |    2 +
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |    6 ++
 drivers/media/video/gspca/ov534.c                  |    2 +-
 drivers/media/video/gspca/sn9c20x.c                |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    1 +
 drivers/media/video/gspca/sunplus.c                |   26 +++++-----
 drivers/media/video/gspca/vc032x.c                 |    4 ++
 drivers/media/video/mx1_camera.c                   |    2 +-
 drivers/media/video/rj54n1cb0c.c                   |    2 +-
 drivers/media/video/saa7134/saa7134-core.c         |   13 -----
 drivers/media/video/saa7134/saa7134-ts.c           |   13 +++++
 drivers/media/video/sh_mobile_ceu_camera.c         |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |    2 +-
 drivers/media/video/uvc/uvc_queue.c                |   13 ++++--
 drivers/media/video/uvc/uvc_video.c                |   45 +++++++++++-------
 drivers/media/video/uvc/uvcvideo.h                 |    5 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |    4 +-
 23 files changed, 151 insertions(+), 71 deletions(-)

Dan Carpenter (1):
      V4L/DVB (13955): cx25821: fix double unlock in medusa_video_init()

Dmitri Belimov (1):
      V4L/DVB (13966): DVB-T regression fix for saa7134 cards

Erik Andren (1):
      V4L/DVB (13880): gspca - m5602-s5k4aa: Add vflip quirk for the Amilo Xi 2428

Erik Andrén (1):
      V4L/DVB (13882): gspca - stv06xx-vv6410: Ensure register STV_SCAN_RATE is zero

Hans Verkuil (1):
      MAINTAINERS: Andy Walls is the new ivtv maintainer

Hans de Goede (1):
      feature-removal-schedule: Add v4l1 drivers obsoleted by gspca sub drivers

Jean-Francois Moine (4):
      V4L/DVB (13816): gspca - main: Set the current frame pointer when first qbuf.
      V4L/DVB (13622): gspca - ov534: Fix a compilation warning.
      V4L/DVB (13875): gspca - vc032x: Fix a possible crash with the vc0321 bridge.
      V4L/DVB (13900): gspca - sunplus: Fix bridge exchanges.

Jiri Slaby (1):
      MAINTAINERS: ivtv-devel is moderated

Laurent Pinchart (3):
      V4L/DVB (13826): uvcvideo: Fix controls blacklisting
      V4L/DVB (13829): uvcvideo: Fix alternate setting selection in isochronous mode
      V4L/DVB (13831): uvcvideo: Fix oops caused by a race condition in buffer dequeuing

Mauro Carvalho Chehab (2):
      V4L/DVB (13834): dib8000: fix compilation if !DVB_DIB8000
      V4L/DVB (13858): ir-keytable: use the right header

Michael Krufky (2):
      V4L/DVB (13887): tda8290: add autodetection support for TDA8295c2
      V4L/DVB (13934): tda8290: Fix FM radio easy programming standard selection for TDA8295

Márton Németh (1):
      V4L/DVB (13941): rj54n1cb0c: remove compiler warning

Nemeth Marton (1):
      V4L/DVB (13820): lgdt3305: make one-bit bitfields unsigned

Roel Kluin (1):
      V4L/DVB (13868): gspca - sn9c20x: Fix test of unsigned.

Uwe Kleine-König (2):
      V4L/DVB mx1_camera: don't check platform_get_irq's return value against zero
      V4L/DVB sh_mobile_ceu: don't check platform_get_irq's return value against zero

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
