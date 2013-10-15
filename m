Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3192 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263Ab3JOOqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 10:46:39 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r9FEkZEu001301
	for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 16:46:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0577D2A04EA
	for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 16:46:31 +0200 (CEST)
Message-ID: <525D5546.4040401@xs4all.nl>
Date: Tue, 15 Oct 2013 16:46:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.13] Fixes for 3.13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of little fixes/cleanups for 3.13.

Regards,

	Hans

The following changes since commit 4699b5f34a09e6fcc006567876b0c3d35a188c62:

  [media] cx24117: prevent mutex to be stuck on locked state if FE init fails (2013-10-14 06:38:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.13c

for you to fetch changes up to 3adeac2c34cc28e05d0ec52f38f009dcce278555:

  v4l2-fh: Include linux/videodev2.h for enum v4l2_priority definition (2013-10-15 16:37:55 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      cx231xx: fix double free and leaks on failure path in cx231xx_usb_probe()

Frank Schaefer (3):
      v4l2-ctrls: fix typo in header file media/v4l2-ctrls.h
      em28xx: fix and unify the coding style of the GPIO register write sequences
      em28xx: fix error path in em28xx_start_analog_streaming()

Hans Verkuil (14):
      hdpvr: fix sparse warnings
      pvrusb2: fix sparse warning
      timblogiw: fix two sparse warnings
      tuner-xs2028.c: fix sparse warnings
      fmdrv_common: fix sparse warning
      radio-keene: fix sparse warning
      cx231xx: fix sparse warnings
      tlg2300: fix sparse warning
      cx25821: fix sparse warnings
      cxd2820r_core: fix sparse warnings
      drxd_hard: fix sparse warnings
      drxk_hard: fix sparse warnings
      az6027: fix sparse warnings
      siano: fix sparse warnings

Jingoo Han (1):
      saa7146: remove unnecessary pci_set_drvdata()

Joe Perches (1):
      media: Remove unnecessary semicolons

Krzysztof Hałasa (1):
      SOLO6x10: Fix video frame type (I/P/B).

Lad, Prabhakar (1):
      v4l: tuner-core: fix typo

Laurent Pinchart (2):
      v4l2-fh: Include linux/fs.h for struct file definition
      v4l2-fh: Include linux/videodev2.h for enum v4l2_priority definition

Michael Opdenacker (8):
      radio-si4713: remove deprecated IRQF_DISABLED
      saa7146: remove deprecated IRQF_DISABLED
      cx18: remove deprecated IRQF_DISABLED
      misc drivers: remove deprecated IRQF_DISABLED
      zoran: remove deprecated IRQF_DISABLED
      ivtv: remove deprecated IRQF_DISABLED
      ir-rx51: remove deprecated IRQF_DISABLED
      winbond-cir: remove deprecated IRQF_DISABLED

Sachin Kamat (12):
      pci: cx88-alsa: Use module_pci_driver
      pci: cx88-mpeg: Use module_pci_driver
      pci: cx88-video: Use module_pci_driver
      pci: flexcop: Remove redundant pci_set_drvdata
      pci: cx88: Remove redundant pci_set_drvdata
      pci: dm1105: Remove redundant pci_set_drvdata
      pci: mantis: Remove redundant pci_set_drvdata
      pci: pluto2: Remove redundant pci_set_drvdata
      pci: pt1: Remove redundant pci_set_drvdata
      pci: saa7164: Remove redundant pci_set_drvdata
      pci: bt878: Remove redundant pci_set_drvdata
      pci: ngene: Remove redundant pci_set_drvdata

Sylwester Nawrocki (1):
      v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function's return type

 drivers/media/common/b2c2/flexcop-sram.c           |   6 ++--
 drivers/media/common/saa7146/saa7146_core.c        |   4 +--
 drivers/media/common/siano/smscoreapi.c            |   4 +--
 drivers/media/common/siano/smsdvb-main.c           |   8 +++---
 drivers/media/dvb-frontends/cx24110.c              |   2 +-
 drivers/media/dvb-frontends/cx24123.c              |   2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |   4 +--
 drivers/media/dvb-frontends/drxd_hard.c            |   8 +++---
 drivers/media/dvb-frontends/drxk_hard.c            |   4 +--
 drivers/media/dvb-frontends/tda8083.c              |   4 +--
 drivers/media/i2c/soc_camera/ov9640.c              |   2 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   2 --
 drivers/media/pci/bt8xx/bt878.c                    |   4 +--
 drivers/media/pci/bt8xx/bttv-driver.c              |   2 +-
 drivers/media/pci/cx18/cx18-driver.c               |   3 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   2 +-
 drivers/media/pci/cx25821/cx25821-cards.c          |   2 --
 drivers/media/pci/cx25821/cx25821-medusa-video.c   |  18 ++++++------
 drivers/media/pci/cx25821/cx25821-medusa-video.h   |   6 ----
 drivers/media/pci/cx25821/cx25821-video-upstream.c |   8 +++---
 drivers/media/pci/cx88/cx88-alsa.c                 |  29 ++-----------------
 drivers/media/pci/cx88/cx88-mpeg.c                 |  17 ++----------
 drivers/media/pci/cx88/cx88-video.c                |  18 ++----------
 drivers/media/pci/dm1105/dm1105.c                  |   2 --
 drivers/media/pci/ivtv/ivtv-driver.c               |   2 +-
 drivers/media/pci/mantis/mantis_pci.c              |   2 --
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/pci/ngene/ngene-core.c               |   2 --
 drivers/media/pci/pluto2/pluto2.c                  |   2 --
 drivers/media/pci/pt1/pt1.c                        |   2 --
 drivers/media/pci/saa7134/saa7134-alsa.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   3 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |   2 +-
 drivers/media/platform/timblogiw.c                 |   4 +--
 drivers/media/radio/radio-keene.c                  |   2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   2 +-
 drivers/media/radio/si4713-i2c.c                   |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   2 +-
 drivers/media/rc/ir-rx51.c                         |   3 +-
 drivers/media/rc/winbond-cir.c                     |   2 +-
 drivers/media/tuners/tuner-xc2028.c                |   4 +--
 drivers/media/usb/cx231xx/cx231xx-cards.c          | 110 ++++++++++++++++++++++++++++++++++++++-----------------------------------
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |   4 +--
 drivers/media/usb/dvb-usb/az6027.c                 |   4 +--
 drivers/media/usb/em28xx/em28xx-cards.c            | 102 +++++++++++++++++++++++++++++++++----------------------------------
 drivers/media/usb/em28xx/em28xx-dvb.c              |  16 +++++------
 drivers/media/usb/em28xx/em28xx-video.c            |   7 +++--
 drivers/media/usb/hdpvr/hdpvr-core.c               |  11 ++++----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/media/usb/tlg2300/pd-main.c                |   2 +-
 drivers/media/v4l2-core/tuner-core.c               |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   8 +++---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   1 +
 include/media/v4l2-common.h                        |   2 +-
 include/media/v4l2-ctrls.h                         |   2 +-
 include/media/v4l2-fh.h                            |   2 ++
 63 files changed, 210 insertions(+), 280 deletions(-)
