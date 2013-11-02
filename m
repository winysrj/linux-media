Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 00/29] Fix errors/warnings with allmodconfig/allyesconfig on non-x86 archs
Date: Sat,  2 Nov 2013 11:31:08 -0200
Message-Id: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

This version 2 series contain the fixes for all errors, including the
dynamic static allocation.

The only changes on the first 11 patches are at the comments, that
got improved, and a few cosmetic changes to make checkpatch.pl happy.

Mauro Carvalho Chehab (29):
  tda9887: remove an warning when compiling for alpha
  radio-shark: remove a warning when CONFIG_PM is not defined
  zoran: don't build it on alpha
  cx18: struct i2c_client is too big for stack
  tef6862: fix warning on avr32 arch
  iguanair: shut up a gcc warning on avr32 arch
  platform drivers: Fix build on cris and frv archs
  cx18: disable compilation on frv arch
  radio-si470x-i2c: fix a warning on ia64
  rc: Fir warnings on m68k arch
  uvc/lirc_serial: Fix some warnings on parisc arch
  s5h1420: Don't use dynamic static allocation
  dvb-frontends: Don't use dynamic static allocation
  dvb-frontends: Don't use dynamic static allocation
  stb0899_drv: Don't use dynamic static allocation
  stv0367: Don't use dynamic static allocation
  stv090x: Don't use dynamic static allocation
  av7110_hw: Don't use dynamic static allocation
  tuners: Don't use dynamic static allocation
  tuner-xc2028: Don't use dynamic static allocation
  cimax2: Don't use dynamic static allocation
  v4l2-async: Don't use dynamic static allocation
  cxusb: Don't use dynamic static allocation
  dibusb-common: Don't use dynamic static allocation
  dw2102: Don't use dynamic static allocation
  af9015: Don't use dynamic static allocation
  af9035: Don't use dynamic static allocation
  mxl111sf: Don't use dynamic static allocation
  lirc_zilog: Don't use dynamic static allocation

 drivers/media/dvb-frontends/af9013.c          |  9 ++-
 drivers/media/dvb-frontends/af9033.c          | 18 +++++-
 drivers/media/dvb-frontends/bcm3510.c         | 12 +++-
 drivers/media/dvb-frontends/cxd2820r_core.c   | 18 +++++-
 drivers/media/dvb-frontends/itd1000.c         | 10 ++-
 drivers/media/dvb-frontends/mt312.c           |  8 ++-
 drivers/media/dvb-frontends/nxt200x.c         |  8 ++-
 drivers/media/dvb-frontends/rtl2830.c         |  9 ++-
 drivers/media/dvb-frontends/rtl2832.c         |  9 ++-
 drivers/media/dvb-frontends/s5h1420.c         |  9 ++-
 drivers/media/dvb-frontends/stb0899_drv.c     |  9 ++-
 drivers/media/dvb-frontends/stb6100.c         |  9 ++-
 drivers/media/dvb-frontends/stv0367.c         | 10 ++-
 drivers/media/dvb-frontends/stv090x.c         |  9 ++-
 drivers/media/dvb-frontends/stv6110.c         |  9 ++-
 drivers/media/dvb-frontends/stv6110x.c        |  9 ++-
 drivers/media/dvb-frontends/tda10071.c        | 18 +++++-
 drivers/media/dvb-frontends/tda18271c2dd.c    | 11 +++-
 drivers/media/dvb-frontends/zl10039.c         |  9 ++-
 drivers/media/pci/cx18/Kconfig                |  1 +
 drivers/media/pci/cx18/cx18-driver.c          | 20 +++---
 drivers/media/pci/cx23885/cimax2.c            |  9 ++-
 drivers/media/pci/ttpci/av7110_hw.c           | 11 +++-
 drivers/media/pci/zoran/Kconfig               |  1 +
 drivers/media/platform/Kconfig                |  2 +
 drivers/media/platform/soc_camera/Kconfig     |  1 +
 drivers/media/radio/radio-shark.c             |  2 +
 drivers/media/radio/radio-shark2.c            |  2 +
 drivers/media/radio/si470x/radio-si470x-i2c.c |  4 +-
 drivers/media/radio/tef6862.c                 | 20 +++---
 drivers/media/rc/fintek-cir.h                 |  4 +-
 drivers/media/rc/iguanair.c                   |  1 +
 drivers/media/rc/nuvoton-cir.h                |  4 +-
 drivers/media/tuners/e4000.c                  | 18 +++++-
 drivers/media/tuners/fc2580.c                 | 18 +++++-
 drivers/media/tuners/tda18212.c               | 18 +++++-
 drivers/media/tuners/tda18218.c               | 18 +++++-
 drivers/media/tuners/tda9887.c                |  4 +-
 drivers/media/tuners/tuner-xc2028.c           |  5 +-
 drivers/media/usb/dvb-usb-v2/af9015.c         |  3 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         | 26 +++++++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  7 ++-
 drivers/media/usb/dvb-usb/cxusb.c             | 38 ++++++++++--
 drivers/media/usb/dvb-usb/dibusb-common.c     |  7 ++-
 drivers/media/usb/dvb-usb/dw2102.c            | 87 ++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_video.c             |  3 +-
 drivers/media/v4l2-core/v4l2-async.c          |  5 +-
 drivers/staging/media/lirc/lirc_serial.c      |  9 ++-
 drivers/staging/media/lirc/lirc_zilog.c       |  9 ++-
 49 files changed, 473 insertions(+), 87 deletions(-)

-- 
1.8.3.1

