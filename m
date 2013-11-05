Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3KENDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:50 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 00/29] Fix errors/warnings with allmodconfig/allyesconfig on non-x86 archs
Date: Tue,  5 Nov 2013 08:01:13 -0200
Message-Id: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be sure that we're not introducing compilation regressions on media, I'm now
using ktest to check for errors/warnings.

My current setup is cross-building on several architectures:
        alpha,  arm, avr32, cris (64), frv, i386, ia64, m32r, m68k, mips, openrisc, parisc, s390, sh, sparc, sparc64, uml, x86_64

I tried to enable a few other archs:
        blackfin, cris (32), powerpc (32, 64), tile, xtensa

but they fail to compile with allyesconfig due to non-media related issues.

I'm still unsure about how often I'll be doing it, I intend to run it at least
by the end of the subsystem merge window (by -rc6 or -rc7), and fix the
issues found there.

V3: contains fixes for the feedbacks received:
        - I2C client driver now	returns	-EINVAL;
        - I2C adapter drivers now returns -EOPNOSUPP;
	- a macro was added for the buffers;
	- check for failure on allocation at v4l2-async was added;
	- Used iguanair code from Sean, instead of my code;
	- Most buffer sizes changed to 64 bytes, to match max URB
	  control size.

Mauro Carvalho Chehab (28):
  [media] tda9887: remove an warning when compiling for alpha
  [media] radio-shark: remove a warning when CONFIG_PM is not defined
  [media] zoran: don't build it on alpha
  [media] cx18: struct i2c_client is too big for stack
  [media] tef6862: fix warning on avr32 arch
  [media] platform drivers: Fix build on frv arch
  [media] radio-si470x-i2c: fix a warning on ia64
  [media] rc: Fir warnings on m68k arch
  [media] uvc/lirc_serial: Fix some warnings on parisc arch
  [media] s5h1420: Don't use dynamic static allocation
  [media] dvb-frontends: Don't use dynamic static allocation
  [media] dvb-frontends: Don't use dynamic static allocation
  [media] stb0899_drv: Don't use dynamic static allocation
  [media] stv0367: Don't use dynamic static allocation
  [media] stv090x: Don't use dynamic static allocation
  [media] av7110_hw: Don't use dynamic static allocation
  [media] tuners: Don't use dynamic static allocation
  [media] tuner-xc2028: Don't use dynamic static allocation
  [media] cimax2: Don't use dynamic static allocation
  [media] v4l2-async: Don't use dynamic static allocation
  [media] cxusb: Don't use dynamic static allocation
  [media] dibusb-common: Don't use dynamic static allocation
  [media] dw2102: Don't use dynamic static allocation
  [media] af9015: Don't use dynamic static allocation
  [media] af9035: Don't use dynamic static allocation
  [media] mxl111sf: Don't use dynamic static allocation
  [media] lirc_zilog: Don't use dynamic static allocation
  [media] cx18: disable compilation on frv arch

Sean Young (1):
  [media] iguanair: simplify calculation of carrier delay cycles

 drivers/media/dvb-frontends/af9013.c          | 12 +++-
 drivers/media/dvb-frontends/af9033.c          | 21 ++++++-
 drivers/media/dvb-frontends/bcm3510.c         | 15 ++++-
 drivers/media/dvb-frontends/cxd2820r_core.c   | 21 ++++++-
 drivers/media/dvb-frontends/itd1000.c         | 13 +++-
 drivers/media/dvb-frontends/mt312.c           | 10 ++-
 drivers/media/dvb-frontends/nxt200x.c         | 11 +++-
 drivers/media/dvb-frontends/rtl2830.c         | 12 +++-
 drivers/media/dvb-frontends/rtl2832.c         | 12 +++-
 drivers/media/dvb-frontends/s5h1420.c         |  9 ++-
 drivers/media/dvb-frontends/stb0899_drv.c     | 12 +++-
 drivers/media/dvb-frontends/stb6100.c         | 11 +++-
 drivers/media/dvb-frontends/stv0367.c         | 13 +++-
 drivers/media/dvb-frontends/stv090x.c         | 12 +++-
 drivers/media/dvb-frontends/stv6110.c         | 12 +++-
 drivers/media/dvb-frontends/stv6110x.c        | 13 +++-
 drivers/media/dvb-frontends/tda10071.c        | 21 ++++++-
 drivers/media/dvb-frontends/tda18271c2dd.c    | 14 ++++-
 drivers/media/dvb-frontends/zl10039.c         | 12 +++-
 drivers/media/pci/cx18/Kconfig                |  1 +
 drivers/media/pci/cx18/cx18-driver.c          | 20 +++---
 drivers/media/pci/cx23885/cimax2.c            | 13 +++-
 drivers/media/pci/ttpci/av7110_hw.c           | 19 +++++-
 drivers/media/pci/zoran/Kconfig               |  1 +
 drivers/media/platform/soc_camera/rcar_vin.c  |  1 +
 drivers/media/radio/radio-shark.c             |  2 +
 drivers/media/radio/radio-shark2.c            |  2 +
 drivers/media/radio/si470x/radio-si470x-i2c.c |  4 +-
 drivers/media/radio/tef6862.c                 | 20 +++---
 drivers/media/rc/fintek-cir.h                 |  4 +-
 drivers/media/rc/iguanair.c                   | 22 ++-----
 drivers/media/rc/nuvoton-cir.h                |  4 +-
 drivers/media/tuners/e4000.c                  | 21 ++++++-
 drivers/media/tuners/fc2580.c                 | 21 ++++++-
 drivers/media/tuners/tda18212.c               | 21 ++++++-
 drivers/media/tuners/tda18218.c               | 21 ++++++-
 drivers/media/tuners/tda9887.c                |  4 +-
 drivers/media/tuners/tuner-xc2028.c           |  8 ++-
 drivers/media/usb/dvb-usb-v2/af9015.c         |  3 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         | 29 ++++++++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       | 10 ++-
 drivers/media/usb/dvb-usb/cxusb.c             | 41 ++++++++++--
 drivers/media/usb/dvb-usb/dibusb-common.c     | 10 ++-
 drivers/media/usb/dvb-usb/dw2102.c            | 90 ++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_video.c             |  3 +-
 drivers/media/v4l2-core/v4l2-async.c          | 31 ++++++++-
 drivers/staging/media/lirc/lirc_serial.c      |  9 ++-
 drivers/staging/media/lirc/lirc_zilog.c       | 12 +++-
 48 files changed, 598 insertions(+), 105 deletions(-)

-- 
1.8.3.1

