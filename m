Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51247 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751298AbdGQNqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 09:46:48 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Bunch of trivial patches
Message-ID: <0c7d9af0-0738-f885-683c-2db671373af2@xs4all.nl>
Date: Mon, 17 Jul 2017 15:46:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some trivial patches for 4.14.

Feel free to cherry-pick from this series if needed.

Regards,

	Hans

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14a

for you to fetch changes up to 919f88499b254089f92a453918c10cd2a2b3aa61:

  vimc: set id_table for platform drivers (2017-07-17 14:57:35 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      platform: video-mux: fix Kconfig dependency

Arvind Yadav (3):
      media: vb2 dma-contig: Constify dma_buf_ops structures.
      media: vb2 vmalloc: Constify dma_buf_ops structures.
      media: vb2 dma-sg: Constify dma_buf_ops structures.

Bhumika Goyal (2):
      media/platform: add const to v4l2_file_operations structures
      cx23885: add const to v4l2_file_operations structure

Colin Ian King (4):
      media: i2c: m5mols: fix spelling mistake: "Machanics" -> "Mechanics"
      media/i2c/saa717x: fix spelling mistake: "implementd" -> "implemented"
      solo6x10: make const array saa7128_regs_ntsc static
      fc001[23]: make const gain table arrays static

Gustavo A. R. Silva (10):
      tuners: remove unnecessary static in simple_dvb_configure()
      stm32-dcmi: constify vb2_ops structure
      st-delta: constify vb2_ops structures
      pxa_camera: constify vb2_ops structure
      rcar_fdp1: constify vb2_ops structure
      atmel-isc: constify vb2_ops structure
      davinci: vpif_display: constify vb2_ops structure
      davinci: vpif_capture: constify vb2_ops structure
      mtk-mdp: constify vb2_ops structure
      mediatek: constify vb2_ops structure

Javier Martinez Canillas (1):
      vimc: set id_table for platform drivers

Kevin Hilman (1):
      davinci: vpif_capture: fix potential NULL deref

 drivers/media/i2c/m5mols/m5mols_core.c          |  2 +-
 drivers/media/i2c/saa717x.c                     |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c         |  2 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c      |  2 +-
 drivers/media/platform/Kconfig                  |  2 +-
 drivers/media/platform/atmel/atmel-isc.c        |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c  |  2 +-
 drivers/media/platform/davinci/vpbe_display.c   |  2 +-
 drivers/media/platform/davinci/vpif_capture.c   | 12 +++++++-----
 drivers/media/platform/davinci/vpif_display.c   |  2 +-
 drivers/media/platform/fsl-viu.c                |  2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |  2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c    |  2 +-
 drivers/media/platform/pxa_camera.c             |  2 +-
 drivers/media/platform/rcar_fdp1.c              |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c  |  2 +-
 drivers/media/platform/sti/delta/delta-v4l2.c   |  4 ++--
 drivers/media/platform/stm32/stm32-dcmi.c       |  2 +-
 drivers/media/platform/vimc/vimc-capture.c      | 15 ++++++++-------
 drivers/media/platform/vimc/vimc-debayer.c      | 15 ++++++++-------
 drivers/media/platform/vimc/vimc-scaler.c       | 15 ++++++++-------
 drivers/media/platform/vimc/vimc-sensor.c       | 15 ++++++++-------
 drivers/media/tuners/fc0012.c                   |  2 +-
 drivers/media/tuners/fc0013.c                   |  2 +-
 drivers/media/tuners/tuner-simple.c             |  2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c  |  2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c      |  2 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c     |  2 +-
 28 files changed, 63 insertions(+), 57 deletions(-)
