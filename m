Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LLslLx005316
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:54:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LLsEW3031826
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:54:14 -0400
Date: Tue, 21 Oct 2008 19:54:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081021195400.45c513b8@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.28] V4L/DVB updates and fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

Most of this series are fixes at drivers:
   - cx18: memory leak, warnings, returned error codes;
   - pvrusb2: deadlock and keep MPEG PTSs from drifting away;
   - dsbr100: Correct bus_info string and CodingStyle;
   - radio-mr800: Add BKL for usb_amradio_open();
   - dsbr100: Add frequency check;
   - s5h1411: several demod locking fixes and some cleanups. Also save 
     some energy when not in use;
   - ivtv: use unlocked_ioctl and avoid led flashing when loading;
   - ivtvfb: FB_BLANK_POWERDOWN turns off video output;
   - cx88: fix compilation breakage and some memory leaks;
   - use video_device.num instead of minor in video%d at several drivers;

There is also a few internal API improvements and fixes:
   - A few additions at v4l2-int-if, in order to support some OMAP devices;
   - videobuf: split unregister bus to avoid memory leaks on errors.

There's also a trivial, but bigger patch that removes an unused "inode"
parameter that used to be present on several calls inside v4l1-compat module.
This simplified the KABI for v4l_compat_translate_ioctl() and video_ioctl2.

Cheers,
Mauro.

---

 drivers/media/common/saa7146_fops.c             |    4 +-
 drivers/media/common/saa7146_video.c            |   12 +-
 drivers/media/dvb/frontends/s5h1411.c           |   84 ++++++---
 drivers/media/dvb/frontends/s5h1411.h           |    2 +-
 drivers/media/radio/dsbr100.c                   |   62 ++++---
 drivers/media/radio/radio-mr800.c               |    5 +
 drivers/media/video/arv.c                       |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c         |    6 +-
 drivers/media/video/c-qcam.c                    |    2 +-
 drivers/media/video/cafe_ccic.c                 |    4 +-
 drivers/media/video/cpia.c                      |    6 +-
 drivers/media/video/cpia2/cpia2_v4l.c           |    2 +-
 drivers/media/video/cx18/cx18-driver.c          |   11 +-
 drivers/media/video/cx18/cx18-io.h              |    4 +-
 drivers/media/video/cx18/cx18-streams.c         |   36 +++--
 drivers/media/video/cx23885/cx23885-417.c       |    2 +-
 drivers/media/video/cx23885/cx23885-video.c     |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c       |    2 +-
 drivers/media/video/cx88/cx88-cards.c           |    4 +-
 drivers/media/video/cx88/cx88-dvb.c             |   11 +-
 drivers/media/video/cx88/cx88-i2c.c             |    2 +
 drivers/media/video/cx88/cx88-mpeg.c            |   15 +-
 drivers/media/video/cx88/cx88-video.c           |    6 +-
 drivers/media/video/em28xx/em28xx-video.c       |    2 +-
 drivers/media/video/et61x251/et61x251_core.c    |   24 ++--
 drivers/media/video/ivtv/ivtv-driver.c          |   12 ++
 drivers/media/video/ivtv/ivtv-i2c.c             |    1 +
 drivers/media/video/ivtv/ivtv-ioctl.c           |   13 +-
 drivers/media/video/ivtv/ivtv-ioctl.h           |    3 +-
 drivers/media/video/ivtv/ivtv-streams.c         |    4 +-
 drivers/media/video/ivtv/ivtvfb.c               |    6 +
 drivers/media/video/pvrusb2/pvrusb2-encoder.c   |    4 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c       |    6 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |   17 ++-
 drivers/media/video/pwc/pwc-if.c                |    2 +-
 drivers/media/video/saa7134/saa7134-core.c      |    6 +-
 drivers/media/video/saa7134/saa7134-empress.c   |    2 +-
 drivers/media/video/se401.c                     |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c      |   24 ++--
 drivers/media/video/stk-webcam.c                |    4 +-
 drivers/media/video/stv680.c                    |    3 +-
 drivers/media/video/usbvideo/usbvideo.c         |    2 +-
 drivers/media/video/usbvideo/vicam.c            |    3 +-
 drivers/media/video/usbvision/usbvision-i2c.c   |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |   12 +-
 drivers/media/video/uvc/uvc_v4l2.c              |   12 +-
 drivers/media/video/v4l1-compat.c               |  221 ++++++++++-------------
 drivers/media/video/v4l2-int-device.c           |    5 +-
 drivers/media/video/v4l2-ioctl.c                |   19 ++-
 drivers/media/video/videobuf-dvb.c              |   52 +++---
 drivers/media/video/vivi.c                      |    6 +-
 drivers/media/video/w9968cf.c                   |   16 +-
 drivers/media/video/zc0301/zc0301_core.c        |   24 ++--
 drivers/media/video/zr364xx.c                   |    2 +-
 include/linux/videodev2.h                       |    7 +
 include/media/v4l2-int-device.h                 |   28 +++-
 include/media/v4l2-ioctl.h                      |   24 ++-
 include/media/videobuf-dvb.h                    |    1 +
 58 files changed, 495 insertions(+), 362 deletions(-)

Alexey Klimov (4):
      V4L/DVB (9303): dsbr100: Correct bus_info string
      V4L/DVB (9304): dsbr100: CodingStyle issue
      V4L/DVB (9305): radio-mr800: Add BKL for usb_amradio_open()
      V4L/DVB (9306): dsbr100: Add frequency check

Andy Walls (3):
      V4L/DVB (9297): cx18: Fix memory leak on card initialization failure
      V4L/DVB (9298): cx18: Add __iomem address space qualifier to cx18_log_*_retries() argument
      V4L/DVB (9299): cx18: Don't mask many real init error codes by mapping them to ENOMEM

Boris Dores (1):
      V4L/DVB (9301): pvrusb2: Keep MPEG PTSs from drifting away

Darron Broad (4):
      V4L/DVB (9332): cx88: initial fix for analogue only compilation
      V4L/DVB (9334): cx88: dvb_remove debug output
      V4L/DVB (9335): videobuf: split unregister bus creating self-contained frontend de-allocator
      V4L/DVB (9336): cx88: always de-alloc frontends on fault condition

Devin Heitmueller (3):
      V4L/DVB (9314): s5h1411: Perform s5h1411 soft reset after tuning
      V4L/DVB (9315): s5h1411: Skip reconfiguring demod modulation if already at the desired modulation
      V4L/DVB (9316): s5h1411: Power down s5h1411 when not in use

Hans Verkuil (3):
      V4L/DVB (9324): v4l2: add video_ioctl2_unlocked for unlocked_ioctl support.
      V4L/DVB (9325): ivtv: switch to unlocked_ioctl.
      V4L/DVB (9327): v4l: use video_device.num instead of minor in video%d

Ian Armstrong (1):
      V4L/DVB (9328): ivtvfb: FB_BLANK_POWERDOWN turns off video output

Martin Dauskardt (1):
      V4L/DVB (9326): ivtv: avoid green flashing when loading ivtv

Mauro Carvalho Chehab (3):
      V4L/DVB (9330): Get rid of inode parameter at v4l_compat_translate_ioctl()
      V4L/DVB (9331): Remove unused inode parameter from video_ioctl2
      V4L/DVB (9333): cx88: Not all boards that requires cx88-mpeg has frontends

Mike Isely (1):
      V4L/DVB (9300): pvrusb2: Fix deadlock problem

Sakari Ailus (4):
      V4L/DVB (9318): v4l2-int-if: Add command to get slave private data.
      V4L/DVB (9321): v4l2-int-if: Define new power state changes
      V4L/DVB (9322): v4l2-int-if: Export more interfaces to modules
      V4L/DVB (9323): v4l2-int-if: Add enum_framesizes and enum_frameintervals ioctls.

Sameer Venkatraman (1):
      V4L/DVB (9319): v4l2-int-if: Add cropcap, g_crop and s_crop commands.

Sergio Aguirre (1):
      V4L/DVB (9320): v4l2: Add 10-bit RAW Bayer formats

Steven Toth (6):
      V4L/DVB (9308): s5h1411: Improvements to the default registers
      V4L/DVB (9309): s5h1411: I/F related bugfix for 3.25 and remove spurious define
      V4L/DVB (9310): s5h1411: read_status() locking detection fixes.
      V4L/DVB (9311): s5h1411: bugfix: Setting serial or parallel mode could destroy bits
      V4L/DVB (9312): s5h1411: Remove meaningless code
      V4L/DVB (9313): s5h1411: Add the #define for an existing supporting I/F

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
