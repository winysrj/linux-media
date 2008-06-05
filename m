Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55LEgAU032266
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:14:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m55LET3d027501
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:14:30 -0400
Date: Thu, 5 Jun 2008 18:14:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080605181410.76410526@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.26] V4L/DVB fixes
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

Hi Linus,

This is another series of fixes for V4L/DVB. This series is a little bigger,
since I got some days in vacation, and, after that, it took me some time to
process tons of emails and merge requests.

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For several fixes (most are trivial ones):
   - Fix compat32 for ivtv and cx18;
   - several fixes on the newer cx18 and au0828 drivers;
   - several Kbuild fixes;
   - fix several returned error codes (-EINVAL, instead of EINVAL);
   - zoran: use correct type for CPU flags;
   - the new mxl5005s driver: some unused static vars were defined;
   - Fix the wrong removal of v4l2_video_std_fps prototype declaration;
   - tuner-simple: fix tuner_warn() induced kernel oops in simple_tuner_attach();
   - tuner-xc2028 were broken on some devices;
   - restore an API change that broke an userspace app;
   - several endianness annotations, alignments, endianness and race fixes;
   - saa7134_empress callback fixes;
   - tda18271_calc_rf_cal must return the return value of tda18271_lookup_map;
   - Fix entry for PowerColor RA 330 and make it run with firmware version 2.7;
   - tda827x: fix NULL pointer in tda827xa_lna_gain;
   - dib0070: fix dib0070_attach when !CONFIG_DVB_TUNER_DIB0070.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.cx88           |    2 +-
 Documentation/video4linux/cx18.txt                |    4 +-
 drivers/media/Makefile                            |    7 +--
 drivers/media/common/tuners/Kconfig               |    1 +
 drivers/media/common/tuners/mxl5005s.c            |    4 +-
 drivers/media/common/tuners/tda18271-common.c     |    4 +-
 drivers/media/common/tuners/tda827x.c             |    4 +-
 drivers/media/common/tuners/tea5761.c             |    2 +-
 drivers/media/common/tuners/tuner-i2c.h           |    8 ++
 drivers/media/common/tuners/tuner-simple.c        |    6 +-
 drivers/media/common/tuners/tuner-xc2028.c        |   87 ++++++++++-----------
 drivers/media/dvb/b2c2/flexcop-usb.c              |    2 +-
 drivers/media/dvb/cinergyT2/cinergyT2.c           |   46 ++++++-----
 drivers/media/dvb/dvb-core/dvb_net.c              |   12 ++--
 drivers/media/dvb/dvb-usb/Kconfig                 |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c       |   21 +++---
 drivers/media/dvb/dvb-usb/dvb-usb-firmware.c      |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                |   10 +-
 drivers/media/dvb/dvb-usb/m920x.c                 |    7 +-
 drivers/media/dvb/frontends/dib0070.h             |   15 ++++-
 drivers/media/dvb/frontends/dib7000p.h            |   15 ++++-
 drivers/media/dvb/frontends/or51132.c             |    6 +-
 drivers/media/dvb/ttpci/av7110.c                  |    9 +-
 drivers/media/dvb/ttpci/av7110_av.c               |   34 +++++++--
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/dvb/ttusb-dec/Kconfig               |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |   25 +++---
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c          |   10 +-
 drivers/media/video/au0828/Kconfig                |    2 +-
 drivers/media/video/au0828/au0828-dvb.c           |    6 --
 drivers/media/video/bt8xx/bttv-cards.c            |    5 +-
 drivers/media/video/bt8xx/bttv-risc.c             |    8 +-
 drivers/media/video/btcx-risc.c                   |    2 +-
 drivers/media/video/btcx-risc.h                   |    4 +-
 drivers/media/video/cx18/cx18-av-core.c           |   81 +++++++++++---------
 drivers/media/video/cx18/cx18-cards.c             |    4 +-
 drivers/media/video/cx18/cx18-controls.c          |    6 +-
 drivers/media/video/cx18/cx18-driver.c            |   26 +++----
 drivers/media/video/cx18/cx18-driver.h            |    9 ++-
 drivers/media/video/cx18/cx18-fileops.c           |   13 ++--
 drivers/media/video/cx18/cx18-gpio.c              |   33 ++++----
 drivers/media/video/cx18/cx18-ioctl.c             |   12 ++--
 drivers/media/video/cx18/cx18-irq.c               |   12 ++-
 drivers/media/video/cx18/cx18-mailbox.c           |    8 +-
 drivers/media/video/cx18/cx18-streams.c           |   37 +++++----
 drivers/media/video/cx23885/cx23885-core.c        |    8 +-
 drivers/media/video/cx88/cx88-cards.c             |   13 +++-
 drivers/media/video/cx88/cx88-core.c              |    8 +-
 drivers/media/video/em28xx/em28xx-video.c         |    8 +-
 drivers/media/video/ivtv/ivtv-driver.h            |   10 ++-
 drivers/media/video/ivtv/ivtv-fileops.c           |    2 +-
 drivers/media/video/ivtv/ivtv-irq.c               |    8 +-
 drivers/media/video/ivtv/ivtv-queue.c             |    2 +-
 drivers/media/video/ivtv/ivtv-streams.c           |   30 ++++----
 drivers/media/video/ivtv/ivtv-version.h           |    4 +-
 drivers/media/video/ivtv/ivtv-yuv.c               |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.h               |    2 +-
 drivers/media/video/saa7134/saa7134-empress.c     |    3 +-
 drivers/media/video/tuner-core.c                  |   40 +++++-----
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 drivers/media/video/zoran.h                       |    4 +-
 drivers/media/video/zoran_device.c                |    2 +-
 drivers/media/video/zoran_driver.c                |   10 +-
 include/linux/videodev2.h                         |    6 +-
 include/media/v4l2-dev.h                          |    1 -
 65 files changed, 434 insertions(+), 348 deletions(-)

Adrian Bunk (2):
      V4L/DVB (7906): tuners/mxl5005s.c: don't define variables for enums
      V4L/DVB (7908): always enter drivers/media/video/

Al Viro (17):
      V4L/DVB (7956): cinergyT2: endianness annotations, endianness and race fixes
      V4L/DVB (7957): fix the roothole in av7110_av.c
      V4L/DVB (7958): fix unaligned access in av7110.c
      V4L/DVB (7959): endianness fix in flexcop-usb.c
      V4L/DVB (7960): net: endianness annotations
      V4L/DVB (7961): fix endianness bug in dib0700_devices.c
      V4L/DVB (7962): ttusb endianness annotations and fixes
      V4L/DVB (7963): ivtv: trivial annotations
      V4L/DVB (7964): cx18 iomem annotations
      V4L/DVB (7965): annotate bcx_riscmem
      V4L/DVB (7966): cx18: direct dereferencing of iomem
      V4L/DVB (7967): bt8xx: unaligned access
      V4L/DVB (7968): zoran: endianness annotations
      V4L/DVB (7969): m920x: unaligned access
      V4L/DVB (7970): mix trivial endianness annotations
      V4L/DVB (7971): usb: unaligned
      V4L/DVB (7972): or51132.c: unaligned

Andrew Morton (1):
      V4L/DVB (7901): zoran: use correct type for CPU flags

Andy Walls (1):
      V4L/DVB (7922): tuner-simple: fix tuner_warn() induced kernel oops in simple_tuner_attach()

Daniel Gimpelevich (1):
      V4L/DVB (7990): Fix entry for PowerColor RA 330 and make it run with firmware version 2.7

David Woodhouse (1):
      V4L/DVB (7166): [v4l] Add new user class controls and deprecate others

Dmitri Belimov (1):
      V4L/DVB (7975): saa7134_empress

Guennadi Liakhovetski (1):
      V4L/DVB (7911): Remove v4l2_video_std_fps prototype declaration

Hans Verkuil (9):
      V4L/DVB (7885): ivtv/cx18: add compat_ioctl entries
      V4L/DVB (7925): cx18: ensure that the xceive pin is always asserted on init.
      V4L/DVB (7928): cx18: fix audio registers 808 and 80c
      V4L/DVB (7930): ivtv: bump version to 1.3.0.
      V4L/DVB (7931): cx18: allow for simultaneous digital and analog capture
      V4L/DVB (7932): cx18: mark Compro H900 as fully supported.
      V4L/DVB (7934): cx18: move gpio_dir/val statics to the cx18 struct.
      V4L/DVB (7977): cx18: fix init order and remove duplicate open_on_first_use.
      V4L/DVB (7978): cx18: explicitly test for XC2028 tuner

Ingo Molnar (2):
      V4L/DVB (7910): usb: input layer dependency fixes
      V4L/DVB (7974): fix MEDIA_TUNER && FW_LOADER build error

Marcin Slusarz (4):
      V4L/DVB (7902): fix handling of tea5761_autodetection return value
      V4L/DVB (7903): gp8psk_power_ctrl should return negative errors
      V4L/DVB (7904): v4l/tuner-core: consistent handling of return values
      V4L/DVB (7905): check_v4l2 should return -EINVAL on error

Michael Krufky (7):
      V4L/DVB (7916): dib7000p: fix dib7000p_attach when !CONFIG_DVB_DIB7000P
      V4L/DVB (7918): au0828: remove irrelevent analog tuner standby code
      V4L/DVB (7919): VIDEO_AU0828 does not depend on VIDEO_DEV
      V4L/DVB (7943): tuner: add macro, hybrid_tuner_report_instance_count
      V4L/DVB (7944): tuner-xc2028: use hybrid_tuner_request_state
      V4L/DVB (7983): tda18271_calc_rf_cal must return the return value of tda18271_lookup_map
      V4L/DVB (8001): dib0070: fix dib0070_attach when !CONFIG_DVB_TUNER_DIB0070

Sigmund Augdal (1):
      V4L/DVB (8000): tda827x: fix NULL pointer in tda827xa_lna_gain

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
