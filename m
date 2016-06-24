Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/19] Fix new warnings detected by GCC 6.1
Date: Fri, 24 Jun 2016 12:31:41 -0300
Message-Id: <cover.1466782238.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After upgrading to Fedora 24, new warnings started to popup. Fix them.

Mauro Carvalho Chehab (19):
  usbvision: remove some unused vars
  exynos4-is: remove some unused vars
  cx18: use macros instead of static const vars
  m5602_core: move skeletons to the .c file
  m5602_s5k4aa: move skeletons to the .c file
  m5602_mt9m111: move skeletons to the .c file
  m5602_ov9650: move skeletons to the .c file
  m5602_s5k83a: move skeletons to the .c file
  m5602_po1030: move skeletons to the .c file
  m5602_ov7660: move skeletons to the .c file
  cx25821-alsa: shutup a Gcc 6.1 warning
  drxj: comment out the unused nicam_presc_table_val table
  dib0090: comment out the unused tables
  r820t: comment out two ancillary tables
  zr36016: remove some unused tables
  vivid: remove some unused vars
  em28xx-dvb: remove some left over
  adv7842: comment out a table useful for debug
  bdisp: move the V/H filter spec to bdisp-hw.c

 drivers/media/dvb-frontends/dib0090.c           |   6 +
 drivers/media/dvb-frontends/drx39xyj/drxj.c     |   3 +
 drivers/media/i2c/adv7842.c                     |   3 +
 drivers/media/pci/cx18/cx18-driver.c            |   2 +-
 drivers/media/pci/cx18/cx18-driver.h            |   6 +-
 drivers/media/pci/cx18/cx18-ioctl.c             |   2 +-
 drivers/media/pci/cx18/cx18-streams.c           |  12 +-
 drivers/media/pci/cx18/cx18-vbi.c               |   6 +-
 drivers/media/pci/cx25821/cx25821-alsa.c        |   2 +-
 drivers/media/pci/zoran/zr36016.c               |   4 -
 drivers/media/platform/exynos4-is/mipi-csis.c   |  17 --
 drivers/media/platform/sti/bdisp/bdisp-filter.h | 304 -----------------------
 drivers/media/platform/sti/bdisp/bdisp-hw.c     | 305 ++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-sdr-cap.c    |   2 -
 drivers/media/platform/vivid/vivid-vid-cap.c    |   3 +-
 drivers/media/radio/radio-aztech.c              |   1 -
 drivers/media/tuners/r820t.c                    |  29 +--
 drivers/media/usb/em28xx/em28xx-dvb.c           |  11 -
 drivers/media/usb/gspca/m5602/m5602_bridge.h    |  15 --
 drivers/media/usb/gspca/m5602/m5602_core.c      |  15 ++
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c   | 144 +++++++++++
 drivers/media/usb/gspca/m5602/m5602_mt9m111.h   | 144 -----------
 drivers/media/usb/gspca/m5602/m5602_ov7660.c    | 153 ++++++++++++
 drivers/media/usb/gspca/m5602/m5602_ov7660.h    | 153 ------------
 drivers/media/usb/gspca/m5602/m5602_ov9650.c    | 152 ++++++++++++
 drivers/media/usb/gspca/m5602/m5602_ov9650.h    | 150 ------------
 drivers/media/usb/gspca/m5602/m5602_po1030.c    | 104 ++++++++
 drivers/media/usb/gspca/m5602/m5602_po1030.h    | 104 --------
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c    | 199 ++++++++++++++++
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.h    | 197 ---------------
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c    | 124 ++++++++++
 drivers/media/usb/gspca/m5602/m5602_s5k83a.h    | 124 ----------
 drivers/media/usb/usbvision/usbvision-core.c    |   5 -
 33 files changed, 1239 insertions(+), 1262 deletions(-)

-- 
2.7.4


