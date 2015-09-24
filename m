Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39833 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbbIXJF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2015 05:05:28 -0400
Received: from [10.0.1.32] (unknown [176.61.120.147])
	by tschai.lan (Postfix) with ESMTPSA id 316AF2A00AF
	for <linux-media@vger.kernel.org>; Thu, 24 Sep 2015 11:03:58 +0200 (CEST)
Message-ID: <5603BCD2.7090103@xs4all.nl>
Date: Thu, 24 Sep 2015 10:05:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.4] Merge part 1 of the vb2 split-up series
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As requested by Mauro, here is the pull request that merges patches 1-4
of Junghak's patch series that splits up the vb2 code. Patches 2-4 are
squashed together and it includes the two fixup patches Junghak posted that
fix compilation errors.

Regards,

	Hans

The following changes since commit 9ddf9071ea17b83954358b2dac42b34e5857a9af:

  Merge tag 'v4.3-rc1' into patchwork (2015-09-13 11:10:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.4d

for you to fetch changes up to bfb074ffaec76830674f0826df834ae9e239afa4:

  media: videobuf2: Restructure vb2_buffer (2015-09-24 10:55:43 +0200)

----------------------------------------------------------------
Junghak Sung (2):
      media: videobuf2: Replace videobuf2-core with videobuf2-v4l2
      media: videobuf2: Restructure vb2_buffer

 drivers/input/touchscreen/sur40.c                  |  17 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  21 +-
 drivers/media/pci/cobalt/cobalt-driver.h           |   6 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |   7 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  20 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  11 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  24 +--
 drivers/media/pci/cx23885/cx23885-dvb.c            |   9 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  16 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  27 +--
 drivers/media/pci/cx23885/cx23885.h                |   2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |  21 +-
 drivers/media/pci/cx25821/cx25821.h                |   3 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |  13 +-
 drivers/media/pci/cx88/cx88-core.c                 |   8 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  11 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  14 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |  17 +-
 drivers/media/pci/cx88/cx88-video.c                |  19 +-
 drivers/media/pci/cx88/cx88.h                      |   2 +-
 drivers/media/pci/dt3155/dt3155.c                  |  17 +-
 drivers/media/pci/dt3155/dt3155.h                  |   3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  19 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  14 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |  14 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  10 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  21 +-
 drivers/media/pci/saa7134/saa7134.h                |   2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  46 +++--
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  19 +-
 drivers/media/pci/solo6x10/solo6x10.h              |   4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  26 +--
 drivers/media/pci/tw68/tw68-video.c                |  19 +-
 drivers/media/pci/tw68/tw68.h                      |   3 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |  35 ++--
 drivers/media/platform/am437x/am437x-vpfe.h        |   3 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  34 ++--
 drivers/media/platform/coda/coda-bit.c             | 135 ++++++-------
 drivers/media/platform/coda/coda-common.c          |  23 +--
 drivers/media/platform/coda/coda-jpeg.c            |   6 +-
 drivers/media/platform/coda/coda.h                 |   8 +-
 drivers/media/platform/coda/trace.h                |  18 +-
 drivers/media/platform/davinci/vpbe_display.c      |  31 +--
 drivers/media/platform/davinci/vpif_capture.c      |  30 +--
 drivers/media/platform/davinci/vpif_capture.h      |   2 +-
 drivers/media/platform/davinci/vpif_display.c      |  39 ++--
 drivers/media/platform/davinci/vpif_display.h      |   2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  23 +--
 drivers/media/platform/exynos4-is/fimc-capture.c   |  24 +--
 drivers/media/platform/exynos4-is/fimc-core.c      |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |   4 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  15 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  17 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |   4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  21 +-
 drivers/media/platform/m2m-deinterlace.c           |  23 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  43 ++--
 drivers/media/platform/marvell-ccic/mcam-core.h    |   2 +-
 drivers/media/platform/mx2_emmaprp.c               |  15 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  25 +--
 drivers/media/platform/omap3isp/ispvideo.h         |   4 +-
 drivers/media/platform/rcar_jpu.c                  |  61 +++---
 drivers/media/platform/s3c-camif/camif-capture.c   |  17 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   2 +-
 drivers/media/platform/s3c-camif/camif-core.h      |   4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  17 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  32 +--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  80 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  60 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  46 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  33 ++--
 drivers/media/platform/s5p-tv/mixer.h              |   4 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |   2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |  11 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |   5 +-
 drivers/media/platform/sh_veu.c                    |  19 +-
 drivers/media/platform/sh_vou.c                    |  26 +--
 drivers/media/platform/soc_camera/atmel-isi.c      |  26 +--
 drivers/media/platform/soc_camera/mx2_camera.c     |  21 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |  27 +--
 drivers/media/platform/soc_camera/rcar_vin.c       |  45 +++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  57 +++---
 drivers/media/platform/soc_camera/soc_camera.c     |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  23 +--
 drivers/media/platform/ti-vpe/vpe.c                |  42 ++--
 drivers/media/platform/vim2m.c                     |  52 ++---
 drivers/media/platform/vivid/vivid-core.h          |   4 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  73 +++----
 drivers/media/platform/vivid/vivid-kthread-out.c   |  34 ++--
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  44 +++--
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  45 +++--
 drivers/media/platform/vivid/vivid-vbi-out.c       |  18 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  15 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |  15 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  20 +-
 drivers/media/platform/vsp1/vsp1_video.h           |   8 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  26 +--
 drivers/media/platform/xilinx/xilinx-dma.h         |   2 +-
 drivers/media/usb/airspy/airspy.c                  |  24 ++-
 drivers/media/usb/au0828/au0828-vbi.c              |   7 +-
 drivers/media/usb/au0828/au0828-video.c            |  45 +++--
 drivers/media/usb/au0828/au0828.h                  |   3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   7 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  34 ++--
 drivers/media/usb/em28xx/em28xx.h                  |   3 +-
 drivers/media/usb/go7007/go7007-driver.c           |  29 +--
 drivers/media/usb/go7007/go7007-priv.h             |   4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |  20 +-
 drivers/media/usb/hackrf/hackrf.c                  |  22 ++-
 drivers/media/usb/msi2500/msi2500.c                |  17 +-
 drivers/media/usb/pwc/pwc-if.c                     |  33 ++--
 drivers/media/usb/pwc/pwc-uncompress.c             |   6 +-
 drivers/media/usb/pwc/pwc.h                        |   4 +-
 drivers/media/usb/s2255/s2255drv.c                 |  27 +--
 drivers/media/usb/stk1160/stk1160-v4l.c            |  15 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  12 +-
 drivers/media/usb/stk1160/stk1160.h                |   4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  21 +-
 drivers/media/usb/usbtv/usbtv.h                    |   3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  26 +--
 drivers/media/usb/uvc/uvc_video.c                  |  20 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   6 +-
 drivers/media/v4l2-core/Makefile                   |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  10 +-
 drivers/media/v4l2-core/v4l2-trace.c               |   2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 217 ++++++++++++---------
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   2 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |   2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  31 +++
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  43 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |   3 +-
 drivers/staging/media/omap4iss/iss_video.c         |  23 ++-
 drivers/staging/media/omap4iss/iss_video.h         |   6 +-
 drivers/usb/gadget/function/uvc_queue.c            |  26 +--
 drivers/usb/gadget/function/uvc_queue.h            |   4 +-
 include/media/davinci/vpbe_display.h               |   3 +-
 include/media/soc_camera.h                         |   2 +-
 include/media/v4l2-mem2mem.h                       |  11 +-
 include/media/videobuf2-core.h                     |  68 ++++---
 include/media/videobuf2-dma-contig.h               |   2 +-
 include/media/videobuf2-dma-sg.h                   |   2 +-
 include/media/videobuf2-memops.h                   |   2 +-
 include/media/videobuf2-v4l2.h                     |  45 +++++
 include/media/videobuf2-vmalloc.h                  |   2 +-
 include/trace/events/v4l2.h                        |  35 ++--
 157 files changed, 1753 insertions(+), 1322 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
 create mode 100644 include/media/videobuf2-v4l2.h
