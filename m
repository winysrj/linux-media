Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4318 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3KKOf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 09:35:27 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id rABEZNEF011933
	for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 15:35:25 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B90762A1F80
	for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 15:35:19 +0100 (CET)
Message-ID: <5280EB27.1030804@xs4all.nl>
Date: Mon, 11 Nov 2013 15:35:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Patches for 3.14.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14a

for you to fetch changes up to 604f2fe58dae50a0bc1bd3ad7f8c4660ea48a329:

  media: marvell-ccic: use devm to release clk (2013-11-11 15:28:38 +0100)

----------------------------------------------------------------
Georg Kaindl (1):
      usbtv: Add support for PAL video source.

Jonathan McCrohan (1):
      media_tree: Fix spelling errors

Libin Yang (2):
      marvell-ccic: drop resource free in driver remove
      media: marvell-ccic: use devm to release clk

Ricardo Ribalda (2):
      em28xx-video: Swap release order to avoid lock nesting
      ths7303: Declare as static a private function

 drivers/media/common/siano/smscoreapi.h          |   4 +-
 drivers/media/common/siano/smsdvb.h              |   2 +-
 drivers/media/dvb-core/dvb_demux.c               |   2 +-
 drivers/media/dvb-frontends/dib8000.c            |   4 +-
 drivers/media/dvb-frontends/drxk_hard.c          |  18 ++++----
 drivers/media/i2c/Kconfig                        |   2 +-
 drivers/media/i2c/adv7183.c                      |   2 +-
 drivers/media/i2c/adv7183_regs.h                 |   6 +--
 drivers/media/i2c/adv7604.c                      |   2 +-
 drivers/media/i2c/adv7842.c                      |   2 +-
 drivers/media/i2c/ir-kbd-i2c.c                   |   2 +-
 drivers/media/i2c/m5mols/m5mols_controls.c       |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c         |   4 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h              |   2 +-
 drivers/media/i2c/saa7115.c                      |   2 +-
 drivers/media/i2c/soc_camera/ov5642.c            |   2 +-
 drivers/media/i2c/ths7303.c                      |   3 +-
 drivers/media/pci/cx18/cx18-driver.h             |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c          |   2 +-
 drivers/media/pci/pluto2/pluto2.c                |   2 +-
 drivers/media/platform/coda.c                    |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.c    |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c    |   2 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c |  46 ++++----------------
 drivers/media/platform/omap3isp/isp.c            |   2 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h        |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c         |  12 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer.h            |   2 +-
 drivers/media/platform/s5p-tv/mixer_video.c      |   4 +-
 drivers/media/platform/soc_camera/omap1_camera.c |   2 +-
 drivers/media/platform/vivi.c                    |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c           |   2 +-
 drivers/media/radio/radio-si476x.c               |   4 +-
 drivers/media/rc/imon.c                          |   2 +-
 drivers/media/rc/redrat3.c                       |   2 +-
 drivers/media/tuners/mt2063.c                    |   4 +-
 drivers/media/tuners/tuner-xc2028-types.h        |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c          |   2 +-
 drivers/media/usb/gspca/gl860/gl860.c            |   2 +-
 drivers/media/usb/gspca/pac207.c                 |   2 +-
 drivers/media/usb/gspca/pac7302.c                |   2 +-
 drivers/media/usb/gspca/stv0680.c                |   2 +-
 drivers/media/usb/gspca/zc3xx.c                  |   2 +-
 drivers/media/usb/pwc/pwc-if.c                   |   2 +-
 drivers/media/usb/usbtv/usbtv.c                  | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 drivers/media/usb/uvc/uvc_video.c                |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             |   2 +-
 49 files changed, 215 insertions(+), 146 deletions(-)
