Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4078 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab3CHJH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 04:07:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] tvp7002/davinci/blackfin legacy cleanups
Date: Fri, 8 Mar 2013 10:06:19 +0100
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, uclinux-dist-devel@blackfin.uclinux.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303081006.19787.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series cleans up some legacy code:

- remove the references to the obsolete DV_PRESET API from the tvp7002 and
  davinci drivers. They were already converted to the DV_TIMINGS API, but
  some remnants of the old API remained.
- convert one more driver to the control framework (trivial exercise in this
  case).
- remove some (broken) uses of current_norm from davinci drivers.
- fix a dm644x_ccdc compiler warning and fix a number of typos.
- replace the obsolete use of V4L2_IN/OUT_CAP_CUSTOM_TIMINGS in the blackfin
  driver.

After this series the only user of the DV_PRESET API is the s5p-tv driver for
which patches are in the works.

Note that this patch series is identical to the review patch series posted on
Monday:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/61341

Regards,

	Hans

The following changes since commit 457ba4ce4f435d0b4dd82a0acc6c796e541a2ea7:

  [media] bttv: move fini_bttv_i2c() from bttv-input.c to bttv-i2c.c (2013-03-05 17:11:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git davinci

for you to fetch changes up to 319e3780787955abf6d617150eaa1caac3881e25:

  blackfin: replace V4L2_IN/OUT_CAP_CUSTOM_TIMINGS by DV_TIMINGS (2013-03-08 09:55:51 +0100)

----------------------------------------------------------------
Hans Verkuil (12):
      tvp7002: replace 'preset' by 'timings' in various structs/variables.
      tvp7002: use dv_timings structs instead of presets.
      tvp7002: remove dv_preset support.
      davinci_vpfe: fix copy-paste errors in several comments.
      davinci: remove VPBE_ENC_DV_PRESET and rename VPBE_ENC_CUSTOM_TIMINGS
      davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS by V4L2_OUT_CAP_DV_TIMINGS
      davinci/vpfe_capture: convert to the control framework.
      davinci/vpbe_display: remove deprecated current_norm.
      davinci/vpfe_capture: remove current_norm
      davinci/dm644x_ccdc: fix compiler warning
      davinci: more gama -> gamma typo fixes.
      blackfin: replace V4L2_IN/OUT_CAP_CUSTOM_TIMINGS by DV_TIMINGS

 arch/arm/mach-davinci/board-dm644x-evm.c          |    4 +-
 arch/arm/mach-davinci/board-dm646x-evm.c          |    2 +-
 arch/arm/mach-davinci/dm644x.c                    |    2 +-
 arch/blackfin/mach-bf609/boards/ezkit.c           |    8 +--
 drivers/media/i2c/tvp7002.c                       |  182 +++++++++++++++++------------------------------------------------
 drivers/media/platform/blackfin/bfin_capture.c    |    4 +-
 drivers/media/platform/davinci/dm355_ccdc.c       |   10 ++--
 drivers/media/platform/davinci/dm355_ccdc_regs.h  |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c      |   13 +++--
 drivers/media/platform/davinci/dm644x_ccdc_regs.h |    2 +-
 drivers/media/platform/davinci/isif.c             |    2 +-
 drivers/media/platform/davinci/isif_regs.h        |    4 +-
 drivers/media/platform/davinci/vpbe.c             |    8 +--
 drivers/media/platform/davinci/vpbe_display.c     |   12 +----
 drivers/media/platform/davinci/vpbe_venc.c        |    8 +--
 drivers/media/platform/davinci/vpfe_capture.c     |   48 +++--------------
 drivers/staging/media/davinci_vpfe/vpfe_video.c   |   12 ++---
 include/media/davinci/dm355_ccdc.h                |    6 +--
 include/media/davinci/dm644x_ccdc.h               |   24 ++++++---
 include/media/davinci/vpbe_types.h                |    3 +-
 20 files changed, 119 insertions(+), 237 deletions(-)
