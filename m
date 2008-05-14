Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EEnpaV014943
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 10:49:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EEnRUq029991
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 10:49:27 -0400
Date: Wed, 14 May 2008 11:49:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080514114910.4bcfd220@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes for 2.6.26
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

   - Lots of Kbuild fixes, thanks to Ingo Molnar for his help of getting those;
   - tuner_symbol_probe(): don't do symbol_put() if symbol_request() failed;
   - Fix error DVB register error logix at saa7134, cx88 and em28xx;
   - Fix miscelaneous errors at the drivers: tuner, tea5767, cx23885, tda18271, 
     ivtv, cx18, mt9v022, mt312, saa7134, dvb_ca_en50221 and xc5000;
   - Adds newer USB/PCI IDs at em28xx, cx23885;
   - Adds missing information about some audio/video decoders at tveeprom;
   - Add MAINTAINERS for the new driver cx18;
   - A few trivial namespace cleanups at the newer drivers;
   - Add mxl5505s driver for MaxiLinear 5505 chipsets.

Most changes are trivial. The biggest change is due to the addition of a new 
driver for MaxiLinear mxl5505s tuner, that is meant to work together with the 
new cx18 driver to support some new devices based on both drivers.

PS.: There are yet a number of other Kconfig potential breakages at V4L/DVB. I'm 
currently working on fixing those issues. Basically, what users do is to select 
I2C, DVB and V4L as module. This works fine, but more complex scenarios where
you mix 'M' and 'Y' inside the subsystem generally cause compilation breakage.
Those scenarios are more theorical, since there's not much practical sense on
having a DVB driver foo as module, and V4L driver bar as in-kernel. However,
the better is to not allow compilation of the scenarios that don't work.

The main trouble at drivers/media Kbuild is that several rules there assumed that
"select" would check the "depends on" dependencies of the selected drivers.
However, this feature doesn't exist at the current Kbuild implementation. Even
if implemented, I suspect that this will generate circular dependency errors on
some cases.

I'm currently checking those rules and running some tests to fix the remaining 
issues.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.cx23885    |    2 +-
 Documentation/video4linux/CARDLIST.em28xx     |    2 +-
 MAINTAINERS                                   |    9 +
 drivers/media/Kconfig                         |    3 +-
 drivers/media/common/tuners/Kconfig           |   50 +-
 drivers/media/common/tuners/Makefile          |    1 +
 drivers/media/common/tuners/mxl5005s.c        | 4110 +++++++++++++++++++++++++
 drivers/media/common/tuners/mxl5005s.h        |  131 +
 drivers/media/common/tuners/tda18271-common.c |   24 +-
 drivers/media/common/tuners/tda18271-fe.c     |  168 +-
 drivers/media/common/tuners/tda18271-priv.h   |    9 +
 drivers/media/common/tuners/tea5767.c         |    6 +-
 drivers/media/common/tuners/xc5000.c          |    9 +-
 drivers/media/common/tuners/xc5000.h          |   22 +-
 drivers/media/common/tuners/xc5000_priv.h     |    2 +
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c     |    2 +-
 drivers/media/dvb/bt8xx/Kconfig               |    1 +
 drivers/media/dvb/cinergyT2/Kconfig           |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c   |   28 +-
 drivers/media/dvb/dvb-usb/Kconfig             |    1 +
 drivers/media/dvb/frontends/Kconfig           |   18 +-
 drivers/media/dvb/frontends/itd1000.c         |    2 +-
 drivers/media/dvb/frontends/mt312.c           |    9 +-
 drivers/media/dvb/frontends/mt312.h           |    4 +-
 drivers/media/dvb/ttpci/Kconfig               |    2 +
 drivers/media/dvb/ttusb-dec/Kconfig           |    1 +
 drivers/media/video/Kconfig                   |   10 +-
 drivers/media/video/Makefile                  |    2 +-
 drivers/media/video/au0828/Kconfig            |    3 +-
 drivers/media/video/au0828/au0828-dvb.c       |    6 +-
 drivers/media/video/bt8xx/Kconfig             |    3 +-
 drivers/media/video/cx18/Kconfig              |    5 +-
 drivers/media/video/cx18/cx18-cards.c         |   25 +-
 drivers/media/video/cx18/cx18-cards.h         |    5 +-
 drivers/media/video/cx18/cx18-driver.c        |   29 +-
 drivers/media/video/cx18/cx18-driver.h        |    3 -
 drivers/media/video/cx18/cx18-dvb.c           |   40 +-
 drivers/media/video/cx18/cx18-fileops.c       |    6 +-
 drivers/media/video/cx18/cx18-fileops.h       |    9 -
 drivers/media/video/cx18/cx18-gpio.c          |   47 +-
 drivers/media/video/cx18/cx18-i2c.c           |    1 +
 drivers/media/video/cx18/cx18-queue.c         |   22 +-
 drivers/media/video/cx18/cx18-queue.h         |    4 -
 drivers/media/video/cx18/cx18-streams.c       |   13 +-
 drivers/media/video/cx18/cx18-streams.h       |    2 +-
 drivers/media/video/cx23885/Kconfig           |    6 +-
 drivers/media/video/cx23885/cx23885-cards.c   |   36 +-
 drivers/media/video/cx23885/cx23885-dvb.c     |    7 +-
 drivers/media/video/cx25840/Kconfig           |    1 +
 drivers/media/video/cx88/Kconfig              |    6 +-
 drivers/media/video/cx88/cx88-dvb.c           |  253 +-
 drivers/media/video/em28xx/Kconfig            |    3 +-
 drivers/media/video/em28xx/em28xx-cards.c     |    8 +-
 drivers/media/video/em28xx/em28xx-dvb.c       |    1 -
 drivers/media/video/ivtv/Kconfig              |    4 +-
 drivers/media/video/ivtv/ivtv-controls.c      |    4 +-
 drivers/media/video/ivtv/ivtv-driver.c        |    8 +-
 drivers/media/video/ivtv/ivtv-fileops.c       |    2 +
 drivers/media/video/ivtv/ivtv-ioctl.c         |   16 +-
 drivers/media/video/ivtv/ivtv-ioctl.h         |    6 +-
 drivers/media/video/ivtv/ivtv-queue.c         |   12 +-
 drivers/media/video/ivtv/ivtv-streams.c       |   13 +-
 drivers/media/video/ivtv/ivtv-streams.h       |    2 +-
 drivers/media/video/ivtv/ivtv-vbi.c           |    3 +-
 drivers/media/video/ivtv/ivtv-yuv.c           |    2 +-
 drivers/media/video/ivtv/ivtvfb.c             |    6 +-
 drivers/media/video/mt9m001.c                 |    5 +-
 drivers/media/video/mt9v022.c                 |    7 +-
 drivers/media/video/pvrusb2/Kconfig           |    4 +-
 drivers/media/video/saa7134/Kconfig           |    3 +-
 drivers/media/video/saa7134/saa7134-core.c    |    6 -
 drivers/media/video/saa7134/saa7134-dvb.c     |  140 +-
 drivers/media/video/stk-webcam.c              |    7 +
 drivers/media/video/tuner-core.c              |   38 +-
 drivers/media/video/tveeprom.c                |   10 +-
 drivers/media/video/usbvision/Kconfig         |    2 +-
 76 files changed, 4976 insertions(+), 498 deletions(-)
 create mode 100644 drivers/media/common/tuners/mxl5005s.c
 create mode 100644 drivers/media/common/tuners/mxl5005s.h

Adrian Bunk (2):
      V4L/DVB (7856): cx18/: possible cleanups
      V4L/DVB (7857): make itd1000_fre_values[] static const

Andrew Morton (1):
      V4L/DVB (7800): tuner_symbol_probe(): don't do symbol_put() if symbol_request() failed

Andy Walls (1):
      V4L/DVB (7891): cx18/ivtv: fix open() kernel oops

Guennadi Liakhovetski (2):
      V4L/DVB (7810): soc_camera: mt9v022 and mt9m001 depend on I2C
      V4L/DVB (7859): mt9v022: fix a copy-paste error in comment

Hans Verkuil (8):
      V4L/DVB (7852): ivtv: prefix ivtv external functions with ivtv_
      V4L/DVB (7853): ivtv/cx18: fix compile warnings
      V4L/DVB (7854): cx18/ivtv: improve and fix out-of-memory handling
      V4L/DVB (7860a): Add MAINTAINERS for cx18
      V4L/DVB (7887): cx18: fix Compro H900 analog support.
      V4L/DVB (7888): cx18: minor card definition updates.
      V4L/DVB (7889): cx18: improve HVR-1600 detection.
      V4L/DVB (7890): cx18: removed bogus and confusing conditional

Hartmut Hackmann (2):
      V4L/DVB (7880): saa7134: remove explicit GPIO initialization
      V4L/DVB (7881): saa7134: fixed a compile warning in saa7134-core.c

Ingo Molnar (3):
      V4L/DVB (7834): build fix for drivers/media/video/au0828
      V4L/DVB (7836): cinergyT2 build fix
      V4L/DVB (7858): video: build fix for drivers/media/video/mt9v022.c

Matthias Schwarzott (1):
      V4L/DVB (7861): mt312: Prefix functions only with mt312_, Add zl10313 to kconfig description

Mauro Carvalho Chehab (15):
      V4L/DVB (7801): saa7134: detach frontend, if tuner or Diseqc attach fails
      V4L/DVB (7802): tuner: Failures at tuner_attach were producing OOPS
      V4L/DVB (7804): tea5767: Fix error logic
      V4L/DVB (7805): saa7134: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7806): em28xx: dvb_unregister_frontend() shouldn't be called, if not registered yet
      V4L/DVB (7807): cx88: Fix error handling, when dvb_attach() fails
      V4L/DVB (7813): Fix compilation, when V4L1_COMPAT is disabled
      V4L/DVB (7846): Re-creates VIDEO_TUNER
      V4L/DVB (7847): Simplifies Kconfig rules
      V4L/DVB (7848): Fix dependencies for tuner-xc2028 and em28xx-dvb
      V4L/DVB (7849): cx88: fix Kconfig depencencies for FW_LOADER
      V4L/DVB (7851): Fix FW_LOADER depencency at v4l/dvb
      V4L/DVB (7898): Fix VIDEO_MEDIA Kconfig logic
      V4L/DVB (7899): Fixes a few remaining Kbuild issues at common/tuners
      V4L/DVB (7900): pvrusb: Fix Kconfig if DVB=m V4L_core=y

Michael Krufky (16):
      V4L/DVB (7808): cx23885: fix kbuild dependencies
      V4L/DVB (7823): em28xx: add additional usb subids for Hauppauge HVR-950
      V4L/DVB (7827): cx23885: add missing subsystem ID for Hauppauge HVR-1200 OEM
      V4L/DVB (7828): cx23885: update model matrix for Hauppauge WinTV HVR-1200 & WinTV HVR-1700
      V4L/DVB (7829): cx23885: remove remaining references to dvb-pll
      V4L/DVB (7832): xc5000: MEDIA_TUNER_XC5000 must select FW_LOADER
      V4L/DVB (7837): tda18271: fix error handling in init and sleep paths
      V4L/DVB (7838): tda18271: fix error handling in tda18271c2_rf_cal_init path
      V4L/DVB (7839): tda18271: abort rf band calibration loop on errors
      V4L/DVB (7840): tda18271: make tda18271_set_standby_mode less verbose for basic debug
      V4L/DVB (7841): tda18271: fix error handling in tda18271_channel_configuration
      V4L/DVB (7842): tda18271: fix error handling in tda18271c2_rf_tracking_filters_correction
      V4L/DVB (7843): tda18271: fix error handling in tda18271c1_rf_tracking_filter_calibration
      V4L/DVB (7844): tda18271: add tda_fail macro to log error cases
      V4L/DVB (7893): xc5000: bug-fix: allow multiple devices in a single system
      V4L/DVB (7895): tveeprom: update Hauppauge analog audio and video decoders

Randy Dunlap (1):
      V4L/DVB (7835): multimedia/video: fix au0828 Kconfig

Robert Schedel (1):
      V4L/DVB (7830): dvb_ca_en50221: Fix High CPU load in 'top' due to budget_av slot polling

Steven Toth (17):
      V4L/DVB (7862): Add mxl5505s driver for MaxiLinear 5505 chipsets
      V4L/DVB (7864): mxl5005s: Cleanup #1
      V4L/DVB (7865): mxl5005s: Cleanup #2
      V4L/DVB (7866): mxl5005s: Cleanup #3
      V4L/DVB (7867): mxl5005s: Cleanup #4
      V4L/DVB (7868): mxl5005s: Cleanup #5
      V4L/DVB(7869): mxl5005s: Cleanup #6
      V4L/DVB (7870): mxl5005s: Basic digital support.
      V4L/DVB(7871): mxl5005s: Re-org code and update copyrights
      V4L/DVB(7872): mxl5005s: checkpatch.pl compliance
      V4L/DVB(7873): mxl5005s: Fix header includes.
      V4L/DVB(7874): mxl5005s: Fix function statics
      V4L/DVB(7875): mxl5005s: Remove redundant functions
      V4L/DVB(7876): mxl5005s: Remove incorrect copyright holders
      V4L/DVB(7877): mxl5005s: Ensure debug is off
      V4L/DVB(7878): mxl55005s: Makefile and Kconfig additions
      V4L/DVB(7879): Adding cx18 Support for mxl5005s

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
