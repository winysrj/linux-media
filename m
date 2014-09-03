Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaICU2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:28:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/46] Several static analizer fixes
Date: Wed,  3 Sep 2014 17:27:58 -0300
Message-Id: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several small issues reported by static analyzers.
Let's fix some of them on this patch series. One of this patch
is a real bug (dmxdev one, at patch 01/46).

The other ones are just code cleanups.

The main goal is to be able to run a static analyzer test more
frequently, so we want to have a cleaner report.

Mauro Carvalho Chehab (46):
  [media] dmxdev: don't use before checking file->private_data
  [media] marvel-ccic: don't initialize static vars with 0
  [media] soc_camera: use kmemdup()
  [media] vivid-vid-out: use memdup_user()
  [media] s5k5baf: remove an uneeded semicolon
  [media] bttv-driver: remove an uneeded semicolon
  [media] soc_camera: remove uneeded semicolons
  [media] stv0900_core: don't allocate a temporary var
  [media] em28xx: use true/false for boolean vars
  [media] tuner-core: use true/false for boolean vars
  [media] af9013: use true/false for boolean vars
  [media] cxd2820r: use true/false for boolean vars
  [media] m88ds3103: use true/false for boolean vars
  [media] af9013: use true/false for boolean vars
  [media] tda10071: use true/false for boolean vars
  [media] smiapp-core: use true/false for boolean vars
  [media] ov9740: use true/false for boolean vars
  [media] omap3isp: use true/false for boolean vars
  [media] ti-vpe: use true/false for boolean vars
  [media] vivid-tpg: use true/false for boolean vars
  [media] radio: use true/false for boolean vars
  [media] ene_ir: use true/false for boolean vars
  [media] au0828-dvb: use true/false for boolean vars
  [media] lmedm04: use true/false for boolean vars
  [media] af9005: use true/false for boolean vars
  [media] msi2500: simplify boolean tests
  [media] drxk_hard: simplify test logic
  [media] lm3560: simplify boolean tests
  [media] lm3560: simplify a boolean test
  [media] omap: simplify test logic
  [media] via-camera: simplify boolean tests
  [media] e4000: simplify boolean tests
  [media] s5p-tv: Simplify the return logic
  [media] siano: just return 0 instead of using a var
  [media] stv0367: just return 0 instead of using a var
  [media] media-devnode: just return 0 instead of using a var
  [media] bt8xx: just return 0 instead of using a var
  [media] saa7164: just return 0 instead of using a var
  [media] davinci: just return 0 instead of using a var
  [media] marvel-ccic: just return 0 instead of using a var
  [media] fintek-cir: just return 0 instead of using a var
  [media] ite-cir: just return 0 instead of using a var
  [media] nuvoton-cir: just return 0 instead of using a var
  [media] mt2060: just return 0 instead of using a var
  [media] mxl5005s: just return 0 instead of using a var
  [media] cx231xx: just return 0 instead of using a var

 drivers/media/common/siano/smscoreapi.c            |  4 +--
 drivers/media/dvb-core/dmxdev.c                    |  3 +-
 drivers/media/dvb-frontends/af9013.c               | 24 +++++++--------
 drivers/media/dvb-frontends/cxd2820r_c.c           |  4 +--
 drivers/media/dvb-frontends/cxd2820r_core.c        |  4 +--
 drivers/media/dvb-frontends/cxd2820r_t.c           |  4 +--
 drivers/media/dvb-frontends/drxk_hard.c            | 34 +++++++++++-----------
 drivers/media/dvb-frontends/m88ds3103.c            | 12 ++++----
 drivers/media/dvb-frontends/rtl2832.c              |  2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/dvb-frontends/stv0367.c              |  4 +--
 drivers/media/dvb-frontends/stv0900_core.c         |  7 ++---
 drivers/media/dvb-frontends/tda10071.c             |  2 +-
 drivers/media/i2c/lm3560.c                         |  4 +--
 drivers/media/i2c/s5k5baf.c                        |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  8 ++---
 drivers/media/i2c/soc_camera/ov9740.c              |  4 +--
 drivers/media/media-devnode.c                      |  3 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  5 ++--
 drivers/media/pci/bt8xx/dst_ca.c                   |  4 +--
 drivers/media/pci/saa7164/saa7164-api.c            |  3 +-
 drivers/media/pci/zoran/zoran_device.c             |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |  3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  2 +-
 drivers/media/platform/omap/omap_vout.c            |  8 ++---
 drivers/media/platform/omap/omap_vout_vrfb.c       | 10 +++----
 drivers/media/platform/omap3isp/ispccdc.c          |  2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |  2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  4 +--
 drivers/media/platform/ti-vpe/vpe.c                |  4 +--
 drivers/media/platform/via-camera.c                |  2 +-
 drivers/media/platform/vivid/vivid-tpg.c           |  4 +--
 drivers/media/platform/vivid/vivid-vid-out.c       | 10 ++-----
 drivers/media/radio/radio-gemtek.c                 |  2 +-
 drivers/media/radio/radio-sf16fmi.c                |  4 +--
 drivers/media/radio/si470x/radio-si470x-common.c   |  4 +--
 drivers/media/rc/ene_ir.c                          |  2 +-
 drivers/media/rc/fintek-cir.c                      |  6 ++--
 drivers/media/rc/ite-cir.c                         |  3 +-
 drivers/media/rc/nuvoton-cir.c                     |  6 ++--
 drivers/media/tuners/e4000.c                       |  4 +--
 drivers/media/tuners/mt2060.c                      |  3 +-
 drivers/media/tuners/mxl5005s.c                    |  3 +-
 drivers/media/usb/au0828/au0828-dvb.c              |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |  4 +--
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c            |  6 ++--
 drivers/media/usb/em28xx/em28xx-video.c            |  4 +--
 drivers/media/usb/msi2500/msi2500.c                |  2 +-
 drivers/media/v4l2-core/tuner-core.c               |  2 +-
 56 files changed, 117 insertions(+), 147 deletions(-)

-- 
1.9.3

