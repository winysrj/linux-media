Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3KAWmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:42:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/11] Fix errors/warnings with allmodconfig/allyesconfig on non-x86 archs
Date: Fri,  1 Nov 2013 17:39:19 -0200
Message-Id: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
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

This series contain the fixes for most complains.

I didn't fix, however, the issues pointed on s390 arch:

        /devel/v4l/ktest-build/drivers/media/dvb-frontends/af9013.c:77:1: warning: 'af9013_wr_regs_i2c' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/af9033.c:188:1: warning: 'af9033_wr_reg_val_tab' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/af9033.c:68:1: warning: 'af9033_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/bcm3510.c:230:1: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/cxd2820r_core.c:51:1: warning: 'cxd2820r_wr_regs_i2c.isra.0' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/cxd2820r_core.c:84:1: warning: 'cxd2820r_rd_regs_i2c.isra.1' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/itd1000.c:69:1: warning: 'itd1000_write_regs.constprop.0' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/mt312.c:126:1: warning: 'mt312_write' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/nxt200x.c:111:1: warning: 'nxt200x_writebytes' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/rtl2830.c:56:1: warning: 'rtl2830_wr' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/rtl2832.c:187:1: warning: 'rtl2832_wr' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/s5h1420.c:851:1: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stb0899_drv.c:540:1: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stb6100.c:216:1: warning: 'stb6100_write_reg_range.constprop.3' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stv0367.c:791:1: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stv090x.c:750:1: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stv6110.c:98:1: warning: 'stv6110_write_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/stv6110x.c:85:1: warning: 'stv6110x_write_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/tda10071.c:52:1: warning: 'tda10071_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/tda10071.c:84:1: warning: 'tda10071_rd_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/tda18271c2dd.c:147:1: warning: 'WriteRegs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/dvb-frontends/zl10039.c:119:1: warning: 'zl10039_write' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/pci/cx23885/cimax2.c:149:1: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/pci/ttpci/av7110_hw.c:510:1: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/e4000.c:50:1: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/e4000.c:83:1: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/fc2580.c:66:1: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/fc2580.c:98:1: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/tda18212.c:57:1: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/tda18212.c:90:1: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/tda18218.c:60:1: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/tda18218.c:92:1: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/tuners/tuner-xc2028.c:651:1: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/cxusb.c:209:1: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/cxusb.c:69:1: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/dibusb-common.c:124:1: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/dw2102.c:368:1: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/dw2102.c:449:1: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/dw2102.c:512:1: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb/dw2102.c:621:1: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb-v2/af9015.c:433:1: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb-v2/af9035.c:142:1: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb-v2/af9035.c:305:1: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]
        /devel/v4l/ktest-build/drivers/staging/media/lirc/lirc_zilog.c:967:1: warning: 'read' uses dynamic stack allocation [enabled by default]

Those warnings are all related to dynamic static allocation, like:
	int function_foo(int size)
	{
		char buf[size];
		...
	}


The risk of doing it is that the Kernel stack is very small. Allocing a large
amount of data at stack is risky, as it could cause stack overflows.

So, this kind of struct should be used only when the code is very carefully
reviewed, and the size doesn't come from userspace.

Also, by using dynamic stack allocation, the gcc check for the max stack size
doesn't work. So, I'll likely send a new series addressing them.

My goal is to not have even a single warning/error reported by ktest.

For now, please review the following series, as it would be good to have
at lease a second pair of eyes on them, as they are compile-tested only.

Thanks!
Mauro.

Mauro Carvalho Chehab (11):
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

 drivers/media/pci/cx18/Kconfig                |  1 +
 drivers/media/pci/cx18/cx18-driver.c          | 20 ++++++++++++--------
 drivers/media/pci/zoran/Kconfig               |  1 +
 drivers/media/platform/Kconfig                |  2 ++
 drivers/media/platform/soc_camera/Kconfig     |  1 +
 drivers/media/radio/radio-shark.c             |  2 ++
 drivers/media/radio/radio-shark2.c            |  2 ++
 drivers/media/radio/si470x/radio-si470x-i2c.c |  4 ++--
 drivers/media/radio/tef6862.c                 | 20 ++++++++++----------
 drivers/media/rc/fintek-cir.h                 |  4 ++--
 drivers/media/rc/iguanair.c                   |  1 +
 drivers/media/rc/nuvoton-cir.h                |  4 ++--
 drivers/media/tuners/tda9887.c                |  4 ++--
 drivers/media/usb/uvc/uvc_video.c             |  2 +-
 drivers/staging/media/lirc/lirc_serial.c      |  9 ++++++---
 15 files changed, 47 insertions(+), 30 deletions(-)

-- 
1.8.3.1

