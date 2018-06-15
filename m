Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45468 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755651AbeFOJf3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 05:35:29 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes/enhancements
Message-ID: <6aab9900-9c19-080b-4edf-59f45c7677f4@xs4all.nl>
Date: Fri, 15 Jun 2018 11:35:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A fair number of stm32-dcmi fixes/improvements, and the remainder is all over
the place.

Regards,

	Hans

The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19c

for you to fetch changes up to 6939cdcd6bc4d026f2a245b9a589aff06b634fa3:

  Revert "[media] tvp5150: fix pad format frame height" (2018-06-15 10:46:04 +0200)

----------------------------------------------------------------
Alexandre Courbot (1):
      media: venus: keep resolution when adjusting format

Anton Leontiev (6):
      vim2m: Remove surplus name initialization
      ti-vpe: Remove surplus name initialization
      s5p-g2d: Remove surplus name initialization
      mx2: Remove surplus name initialization
      m2m-deinterlace: Remove surplus name initialization
      rga: Remove surplus name initialization

Colin Ian King (2):
      media: bt8xx: bttv: fix spelling mistake: "culpit" -> "culprit"
      cx18: remove redundant zero check on retval

Corentin Labbe (1):
      media: cx25821: remove cx25821-audio-upstream.c and cx25821-video-upstream.c

Ezequiel Garcia (5):
      mem2mem: Remove excessive try_run call
      rockchip/rga: Fix broken .start_streaming
      rockchip/rga: Remove unrequired wait in .job_abort
      mem2mem: Remove unused v4l2_m2m_ops .lock/.unlock
      rcar_vpu: Drop unneeded job_ready

Hugues Fruchet (8):
      media: stm32-dcmi: increase max width/height to 2592
      media: stm32-dcmi: code cleanup
      media: stm32-dcmi: do not fall into error on buffer starvation
      media: stm32-dcmi: return buffer in error state on dma error
      media: stm32-dcmi: clarify state logic on buffer starvation
      media: stm32-dcmi: revisit buffer list management
      media: stm32-dcmi: revisit stop streaming ops
      media: stm32-dcmi: add power saving support

Javier Martinez Canillas (1):
      Revert "[media] tvp5150: fix pad format frame height"

Nicholas Mc Guire (3):
      media: stm32-dcmi: drop unnecessary while(1) loop
      media: stm32-dcmi: add mandatory of_node_put() in success path
      media: stm32-dcmi: simplify of_node_put usage

Steve Longerbeam (1):
      media: i2c: adv748x: csi2: set entity function to video interface bridge

Zhouyang Jia (2):
      media: cx88: add error handling for snd_ctl_add
      media: tm6000: add error handling for dvb_register_adapter

 drivers/media/i2c/adv748x/adv748x-csi2.c           |   2 +-
 drivers/media/i2c/tvp5150.c                        |   2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   2 +-
 drivers/media/pci/cx18/cx18-driver.c               |   2 -
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 679 ----------------------------------------------------
 drivers/media/pci/cx25821/cx25821-audio-upstream.h |  58 -----
 drivers/media/pci/cx25821/cx25821-video-upstream.c | 673 ---------------------------------------------------
 drivers/media/pci/cx25821/cx25821-video-upstream.h | 135 -----------
 drivers/media/pci/cx25821/cx25821.h                |  12 -
 drivers/media/pci/cx88/cx88-alsa.c                 |   7 +-
 drivers/media/platform/coda/coda-common.c          |  26 +-
 drivers/media/platform/m2m-deinterlace.c           |  21 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  18 --
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |  16 --
 drivers/media/platform/mx2_emmaprp.c               |  17 --
 drivers/media/platform/qcom/venus/vdec.c           |   2 -
 drivers/media/platform/qcom/venus/venc.c           |   2 -
 drivers/media/platform/rcar_jpu.c                  |   6 -
 drivers/media/platform/rockchip/rga/rga-buf.c      |  45 ++--
 drivers/media/platform/rockchip/rga/rga.c          |  14 +-
 drivers/media/platform/rockchip/rga/rga.h          |   2 -
 drivers/media/platform/s5p-g2d/g2d.c               |   1 -
 drivers/media/platform/sti/delta/delta-v4l2.c      |  18 --
 drivers/media/platform/stm32/stm32-dcmi.c          | 259 ++++++++++----------
 drivers/media/platform/ti-vpe/vpe.c                |  20 --
 drivers/media/platform/vim2m.c                     |   1 -
 drivers/media/usb/tm6000/tm6000-dvb.c              |   5 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   1 -
 include/media/v4l2-mem2mem.h                       |   6 -
 29 files changed, 175 insertions(+), 1877 deletions(-)
 delete mode 100644 drivers/media/pci/cx25821/cx25821-audio-upstream.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-audio-upstream.h
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream.h
