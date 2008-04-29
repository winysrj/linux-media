Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TLqGlf003173
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 17:52:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TLpjHi005405
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 17:51:45 -0400
Date: Tue, 29 Apr 2008 18:50:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080429185009.716c3284@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates and fixes for 2.6.26
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - Fixes on mtm001, mtv022, pvrusb2, ivtv, cx88 and saa7134;
   - new board additions on saa7134 and ivtv;
   - load tuners only when needed;
   - reorganization of tuner drivers that are shared between DVB and V4L;
   - Addition of a new driver for Conexant CX23418 MPEG encoder chip (cx18).

Notice: the diffstat is very big, due to the "mv" operations.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.saa7134         |    3 +-
 Documentation/video4linux/cx18.txt                 |   34 +
 drivers/media/Kconfig                              |  172 +---
 drivers/media/Makefile                             |   10 +-
 drivers/media/common/tuners/Kconfig                |  146 +++
 drivers/media/common/tuners/Makefile               |   25 +
 .../{dvb/frontends => common/tuners}/mt2060.c      |    0 
 .../{dvb/frontends => common/tuners}/mt2060.h      |    4 +-
 .../{dvb/frontends => common/tuners}/mt2060_priv.h |    0 
 drivers/media/{video => common/tuners}/mt20xx.c    |    0 
 drivers/media/{video => common/tuners}/mt20xx.h    |    2 +-
 .../{dvb/frontends => common/tuners}/mt2131.c      |    0 
 .../{dvb/frontends => common/tuners}/mt2131.h      |    4 +-
 .../{dvb/frontends => common/tuners}/mt2131_priv.h |    0 
 .../{dvb/frontends => common/tuners}/mt2266.c      |    0 
 .../{dvb/frontends => common/tuners}/mt2266.h      |    4 +-
 .../{dvb/frontends => common/tuners}/qt1010.c      |    0 
 .../{dvb/frontends => common/tuners}/qt1010.h      |    4 +-
 .../{dvb/frontends => common/tuners}/qt1010_priv.h |    0 
 .../frontends => common/tuners}/tda18271-common.c  |    0 
 .../{dvb/frontends => common/tuners}/tda18271-fe.c |    0 
 .../tuners/tda18271-maps.c}                        |    0 
 .../frontends => common/tuners}/tda18271-priv.h    |    0 
 .../{dvb/frontends => common/tuners}/tda18271.h    |    2 +-
 .../{dvb/frontends => common/tuners}/tda827x.c     |    0 
 .../{dvb/frontends => common/tuners}/tda827x.h     |    4 +-
 drivers/media/{video => common/tuners}/tda8290.c   |    8 +-
 drivers/media/{video => common/tuners}/tda8290.h   |    2 +-
 drivers/media/{video => common/tuners}/tda9887.c   |    0 
 drivers/media/{video => common/tuners}/tda9887.h   |    2 +-
 drivers/media/{video => common/tuners}/tea5761.c   |    0 
 drivers/media/{video => common/tuners}/tea5761.h   |    2 +-
 drivers/media/{video => common/tuners}/tea5767.c   |    0 
 drivers/media/{video => common/tuners}/tea5767.h   |    2 +-
 drivers/media/{video => common/tuners}/tuner-i2c.h |    0 
 .../media/{video => common/tuners}/tuner-simple.c  |    0 
 .../media/{video => common/tuners}/tuner-simple.h  |    2 +-
 .../media/{video => common/tuners}/tuner-types.c   |    0 
 .../{video => common/tuners}/tuner-xc2028-types.h  |    0 
 .../media/{video => common/tuners}/tuner-xc2028.c  |    0 
 .../media/{video => common/tuners}/tuner-xc2028.h  |    2 +-
 .../{dvb/frontends => common/tuners}/xc5000.c      |    0 
 .../{dvb/frontends => common/tuners}/xc5000.h      |    6 +-
 .../{dvb/frontends => common/tuners}/xc5000_priv.h |    0 
 drivers/media/dvb/Kconfig                          |    4 +-
 drivers/media/dvb/b2c2/Kconfig                     |    2 +-
 drivers/media/dvb/b2c2/Makefile                    |    2 +-
 drivers/media/dvb/bt8xx/Kconfig                    |    2 +-
 drivers/media/dvb/bt8xx/Makefile                   |    2 +-
 drivers/media/dvb/bt8xx/dst.c                      |    2 +-
 drivers/media/dvb/dvb-core/Kconfig                 |   34 -
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.h                |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |   26 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    2 +-
 drivers/media/dvb/frontends/Kconfig                |  121 +--
 drivers/media/dvb/frontends/Makefile               |   11 +-
 drivers/media/dvb/frontends/s5h1420.c              |    2 +-
 drivers/media/video/Kconfig                        |   50 +-
 drivers/media/video/Makefile                       |   14 +-
 drivers/media/video/au0828/Kconfig                 |    2 +-
 drivers/media/video/au0828/Makefile                |    2 +-
 drivers/media/video/bt8xx/Kconfig                  |    2 +-
 drivers/media/video/bt8xx/Makefile                 |    1 +
 drivers/media/video/cx18/Kconfig                   |   20 +
 drivers/media/video/cx18/Makefile                  |   11 +
 drivers/media/video/cx18/cx18-audio.c              |   73 ++
 .../xc5000_priv.h => video/cx18/cx18-audio.h}      |   28 +-
 drivers/media/video/cx18/cx18-av-audio.c           |  361 ++++++++
 drivers/media/video/cx18/cx18-av-core.c            |  879 ++++++++++++++++++
 drivers/media/video/cx18/cx18-av-core.h            |  318 +++++++
 drivers/media/video/cx18/cx18-av-firmware.c        |  120 +++
 drivers/media/video/cx18/cx18-av-vbi.c             |  413 +++++++++
 drivers/media/video/cx18/cx18-cards.c              |  277 ++++++
 drivers/media/video/cx18/cx18-cards.h              |  170 ++++
 drivers/media/video/cx18/cx18-controls.c           |  306 ++++++
 .../xc5000_priv.h => video/cx18/cx18-controls.h}   |   30 +-
 drivers/media/video/cx18/cx18-driver.c             |  971 ++++++++++++++++++++
 drivers/media/video/cx18/cx18-driver.h             |  500 ++++++++++
 drivers/media/video/cx18/cx18-dvb.c                |  288 ++++++
 .../xc5000_priv.h => video/cx18/cx18-dvb.h}        |   21 +-
 drivers/media/video/cx18/cx18-fileops.c            |  711 ++++++++++++++
 drivers/media/video/cx18/cx18-fileops.h            |   45 +
 drivers/media/video/cx18/cx18-firmware.c           |  373 ++++++++
 .../xc5000_priv.h => video/cx18/cx18-firmware.h}   |   27 +-
 drivers/media/video/cx18/cx18-gpio.c               |   74 ++
 .../xc5000_priv.h => video/cx18/cx18-gpio.h}       |   26 +-
 drivers/media/video/cx18/cx18-i2c.c                |  431 +++++++++
 drivers/media/video/cx18/cx18-i2c.h                |   33 +
 drivers/media/video/cx18/cx18-ioctl.c              |  851 +++++++++++++++++
 .../xc5000_priv.h => video/cx18/cx18-ioctl.h}      |   32 +-
 drivers/media/video/cx18/cx18-irq.c                |  179 ++++
 drivers/media/video/cx18/cx18-irq.h                |   37 +
 drivers/media/video/cx18/cx18-mailbox.c            |  372 ++++++++
 drivers/media/video/cx18/cx18-mailbox.h            |   73 ++
 drivers/media/video/cx18/cx18-queue.c              |  282 ++++++
 drivers/media/video/cx18/cx18-queue.h              |   59 ++
 drivers/media/video/cx18/cx18-scb.c                |  121 +++
 drivers/media/video/cx18/cx18-scb.h                |  285 ++++++
 drivers/media/video/cx18/cx18-streams.c            |  566 ++++++++++++
 .../xc5000_priv.h => video/cx18/cx18-streams.h}    |   31 +-
 drivers/media/video/cx18/cx18-vbi.c                |  208 +++++
 .../xc5000_priv.h => video/cx18/cx18-vbi.h}        |   28 +-
 .../xc5000_priv.h => video/cx18/cx18-version.h}    |   28 +-
 drivers/media/video/cx18/cx18-video.c              |   45 +
 .../xc5000_priv.h => video/cx18/cx18-video.h}      |   24 +-
 drivers/media/video/cx18/cx23418.h                 |  458 +++++++++
 drivers/media/video/cx23885/Kconfig                |   12 +-
 drivers/media/video/cx23885/Makefile               |    1 +
 drivers/media/video/cx88/Kconfig                   |    4 +-
 drivers/media/video/cx88/Makefile                  |    1 +
 drivers/media/video/cx88/cx88-cards.c              |   50 +-
 drivers/media/video/cx88/cx88-i2c.c                |   32 +-
 drivers/media/video/em28xx/Kconfig                 |    2 +-
 drivers/media/video/em28xx/Makefile                |    1 +
 drivers/media/video/ivtv/Kconfig                   |    2 +-
 drivers/media/video/ivtv/Makefile                  |    1 +
 drivers/media/video/ivtv/ivtv-cards.c              |   98 ++-
 drivers/media/video/ivtv/ivtv-cards.h              |    5 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   43 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |    9 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    3 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   42 +-
 drivers/media/video/ivtv/ivtv-irq.c                |    4 +-
 drivers/media/video/ivtv/ivtv-version.h            |    2 +-
 drivers/media/video/ivtv/ivtvfb.c                  |    2 +-
 drivers/media/video/mt9m001.c                      |    2 +-
 drivers/media/video/mt9v022.c                      |    2 +-
 drivers/media/video/pvrusb2/Kconfig                |   55 +-
 drivers/media/video/pvrusb2/Makefile               |    1 +
 drivers/media/video/pvrusb2/pvrusb2-debug.h        |    1 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    8 -
 drivers/media/video/pvrusb2/pvrusb2-dvb.c          |   42 +-
 drivers/media/video/saa7134/Kconfig                |    6 +-
 drivers/media/video/saa7134/Makefile               |    1 +
 drivers/media/video/saa7134/saa7134-cards.c        |  260 ++++--
 drivers/media/video/saa7134/saa7134-i2c.c          |   42 -
 drivers/media/video/saa7134/saa7134-input.c        |    1 +
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/tuner-core.c                   |  124 ++-
 drivers/media/video/usbvision/Kconfig              |    2 +-
 drivers/media/video/usbvision/Makefile             |    1 +
 include/media/v4l2-chip-ident.h                    |    1 +
 143 files changed, 10890 insertions(+), 884 deletions(-)
 create mode 100644 Documentation/video4linux/cx18.txt
 create mode 100644 drivers/media/common/tuners/Kconfig
 create mode 100644 drivers/media/common/tuners/Makefile
 rename drivers/media/{dvb/frontends => common/tuners}/mt2060.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2060.h (90%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2060_priv.h (100%)
 rename drivers/media/{video => common/tuners}/mt20xx.c (100%)
 rename drivers/media/{video => common/tuners}/mt20xx.h (91%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2131.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2131.h (91%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2131_priv.h (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2266.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/mt2266.h (88%)
 rename drivers/media/{dvb/frontends => common/tuners}/qt1010.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/qt1010.h (91%)
 rename drivers/media/{dvb/frontends => common/tuners}/qt1010_priv.h (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda18271-common.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda18271-fe.c (100%)
 rename drivers/media/{dvb/frontends/tda18271-tables.c => common/tuners/tda18271-maps.c} (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda18271-priv.h (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda18271.h (96%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda827x.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/tda827x.h (93%)
 rename drivers/media/{video => common/tuners}/tda8290.c (99%)
 rename drivers/media/{video => common/tuners}/tda8290.h (94%)
 rename drivers/media/{video => common/tuners}/tda9887.c (100%)
 rename drivers/media/{video => common/tuners}/tda9887.h (92%)
 rename drivers/media/{video => common/tuners}/tea5761.c (100%)
 rename drivers/media/{video => common/tuners}/tea5761.h (93%)
 rename drivers/media/{video => common/tuners}/tea5767.c (100%)
 rename drivers/media/{video => common/tuners}/tea5767.h (94%)
 rename drivers/media/{video => common/tuners}/tuner-i2c.h (100%)
 rename drivers/media/{video => common/tuners}/tuner-simple.c (100%)
 rename drivers/media/{video => common/tuners}/tuner-simple.h (92%)
 rename drivers/media/{video => common/tuners}/tuner-types.c (100%)
 rename drivers/media/{video => common/tuners}/tuner-xc2028-types.h (100%)
 rename drivers/media/{video => common/tuners}/tuner-xc2028.c (100%)
 rename drivers/media/{video => common/tuners}/tuner-xc2028.h (93%)
 rename drivers/media/{dvb/frontends => common/tuners}/xc5000.c (100%)
 rename drivers/media/{dvb/frontends => common/tuners}/xc5000.h (92%)
 copy drivers/media/{dvb/frontends => common/tuners}/xc5000_priv.h (100%)
 delete mode 100644 drivers/media/dvb/dvb-core/Kconfig
 create mode 100644 drivers/media/video/cx18/Kconfig
 create mode 100644 drivers/media/video/cx18/Makefile
 create mode 100644 drivers/media/video/cx18/cx18-audio.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-audio.h} (62%)
 create mode 100644 drivers/media/video/cx18/cx18-av-audio.c
 create mode 100644 drivers/media/video/cx18/cx18-av-core.c
 create mode 100644 drivers/media/video/cx18/cx18-av-core.h
 create mode 100644 drivers/media/video/cx18/cx18-av-firmware.c
 create mode 100644 drivers/media/video/cx18/cx18-av-vbi.c
 create mode 100644 drivers/media/video/cx18/cx18-cards.c
 create mode 100644 drivers/media/video/cx18/cx18-cards.h
 create mode 100644 drivers/media/video/cx18/cx18-controls.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-controls.h} (62%)
 create mode 100644 drivers/media/video/cx18/cx18-driver.c
 create mode 100644 drivers/media/video/cx18/cx18-driver.h
 create mode 100644 drivers/media/video/cx18/cx18-dvb.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-dvb.h} (68%)
 create mode 100644 drivers/media/video/cx18/cx18-fileops.c
 create mode 100644 drivers/media/video/cx18/cx18-fileops.h
 create mode 100644 drivers/media/video/cx18/cx18-firmware.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-firmware.h} (62%)
 create mode 100644 drivers/media/video/cx18/cx18-gpio.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-gpio.h} (62%)
 create mode 100644 drivers/media/video/cx18/cx18-i2c.c
 create mode 100644 drivers/media/video/cx18/cx18-i2c.h
 create mode 100644 drivers/media/video/cx18/cx18-ioctl.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-ioctl.h} (54%)
 create mode 100644 drivers/media/video/cx18/cx18-irq.c
 create mode 100644 drivers/media/video/cx18/cx18-irq.h
 create mode 100644 drivers/media/video/cx18/cx18-mailbox.c
 create mode 100644 drivers/media/video/cx18/cx18-mailbox.h
 create mode 100644 drivers/media/video/cx18/cx18-queue.c
 create mode 100644 drivers/media/video/cx18/cx18-queue.h
 create mode 100644 drivers/media/video/cx18/cx18-scb.c
 create mode 100644 drivers/media/video/cx18/cx18-scb.h
 create mode 100644 drivers/media/video/cx18/cx18-streams.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-streams.h} (53%)
 create mode 100644 drivers/media/video/cx18/cx18-vbi.c
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-vbi.h} (62%)
 copy drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-version.h} (50%)
 create mode 100644 drivers/media/video/cx18/cx18-video.c
 rename drivers/media/{dvb/frontends/xc5000_priv.h => video/cx18/cx18-video.h} (62%)
 create mode 100644 drivers/media/video/cx18/cx23418.h

Adrian Bunk (1):
      V4L/DVB (7785): [2.6 patch] make mt9{m001,v022}_controls[] static

Andrew Morton (1):
      V4L/DVB (7783): drivers/media/dvb/frontends/s5h1420.c: printk fix

Hans Verkuil (10):
      V4L/DVB (7754): ivtv: change initialization order to fix an oops when device registration failed
      V4L/DVB (7755): ivtv: add support for card comments and detected but unsupported cards
      V4L/DVB (7756): ivtv: use strlcpy instead of strcpy
      V4L/DVB (7757): ivtv: add autodetect for the AVermedia M104 card
      V4L/DVB (7758): ivtv: fix oops when itv->speed == 0 and VIDEO_CMD_PLAY is called
      V4L/DVB (7759): ivtv: increase version number to 1.2.1
      V4L/DVB (7761): ivtv: increase the DMA timeout from 100 to 300 ms
      V4L/DVB (7762): ivtv: fix tuner detection for PAL-N/Nc
      V4L/DVB (7763): ivtv: add tuner support for the AverMedia M116
      V4L/DVB (7786): cx18: new driver for the Conexant CX23418 MPEG encoder chip

Igor Kuznetsov (2):
      V4L/DVB (7765): Add support for Beholder BeholdTV H6
      V4L/DVB (7766): saa7134: add another PCI ID for Beholder M6

Mauro Carvalho Chehab (9):
      V4L/DVB (7749): cx88: fix tuner setup
      V4L/DVB (7752): tuner-core: add a missing \n after a debug printk
      V4L/DVB (7753): saa7134: fix tuner setup
      V4L/DVB(7767): Move tuners to common/tuners
      V4L/DVB (7768): reorganize some DVB-S Kconfig items
      V4L/DVB (7769): Move other terrestrial tuners to common/tuners
      Fix V4L/DVB core help messages
      Rename common tuner Kconfig names to use the same
      V4L-DVB(7789a): cx18: fix symbol conflict with ivtv driver

Michael Krufky (4):
      V4L/DVB (7779): pvrusb2-dvb: quiet down noise in kernel log for feed debug
      V4L/DVB (7780): pvrusb2: always enable support for OnAir Creator / HDTV USB2
      V4L/DVB (7781): pvrusb2-dvb: include dvb support by default and update Kconfig help text
      V4L/DVB (7789): tuner: remove static dependencies on analog tuner sub-modules

Mike Isely (1):
      V4L/DVB (7782): pvrusb2: Driver is no longer experimental

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
