Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34795 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbbLGNu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 08:50:57 -0500
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 1DB94E0BBD
	for <linux-media@vger.kernel.org>; Mon,  7 Dec 2015 14:50:51 +0100 (CET)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] Refactoring Videobuf2 for common use
Message-ID: <56658EBA.1010700@xs4all.nl>
Date: Mon, 7 Dec 2015 14:50:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is identical to the v11 patch series, except for being rebased
to the latest master branch.

See this cover letter for all the details:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/96617

Regards,

	Hans

The following changes since commit 21312f6ddb1710750761c4b140b7367208b4f89e:

  [media] radio-bcm2048: fix code indent (2015-12-03 16:15:16 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sizeimage

for you to fetch changes up to 7946e400c4f1266cf1a884b6e3021c0bc3893e5b:

  videobuf2-core: fix plane_sizes handling in VIDIOC_CREATE_BUFS (2015-12-07 13:52:15 +0100)

----------------------------------------------------------------
Hans Verkuil (9):
      vb2: drop v4l2_format argument from queue_setup
      DocBook media: update VIDIOC_CREATE_BUFS documentation
      solo6x10: use v4l2_get_timestamp to fill in buffer timestamp
      videobuf2-core.c: update module description
      videobuf2-core: fill_user_buffer and copy_timestamp should return void
      videobuf2-core: move __setup_lengths into __vb2_queue_alloc()
      videobuf2-core: fill in q->bufs[vb->index] before buf_init()
      videobuf2-core: call __setup_offsets before buf_init()
      videobuf2-core: fix plane_sizes handling in VIDIOC_CREATE_BUFS

Junghak Sung (6):
      media: videobuf2: Move timestamp to vb2_buffer
      media: videobuf2: Add copy_timestamp to struct vb2_queue
      media: videobuf2: Separate vb2_poll()
      media: videobuf2: last_buffer_queued is set at fill_v4l2_buffer()
      media: videobuf2: Refactor vb2_fileio_data and vb2_thread
      media: videobuf2: Move vb2_fileio_data and vb2_thread to core part

 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml   |  30 ++-
 Documentation/video4linux/v4l2-pci-skeleton.c            |  11 +-
 drivers/input/touchscreen/sur40.c                        |  13 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c                |   4 +-
 drivers/media/pci/cobalt/cobalt-irq.c                    |   2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c                   |  12 +-
 drivers/media/pci/cx23885/cx23885-417.c                  |   2 +-
 drivers/media/pci/cx23885/cx23885-core.c                 |   2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                  |   2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c                  |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c                |   4 +-
 drivers/media/pci/cx25821/cx25821-video.c                |  14 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  |   2 +-
 drivers/media/pci/cx88/cx88-core.c                       |   2 +-
 drivers/media/pci/cx88/cx88-dvb.c                        |   2 +-
 drivers/media/pci/cx88/cx88-vbi.c                        |   2 +-
 drivers/media/pci/cx88/cx88-video.c                      |   2 +-
 drivers/media/pci/dt3155/dt3155.c                        |  13 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c       |   3 +-
 drivers/media/pci/saa7134/saa7134-core.c                 |   2 +-
 drivers/media/pci/saa7134/saa7134-ts.c                   |   2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c                  |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c                |   2 +-
 drivers/media/pci/saa7134/saa7134.h                      |   2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c           |   4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c               |   4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                  |   4 +-
 drivers/media/pci/tw68/tw68-video.c                      |  22 +-
 drivers/media/platform/am437x/am437x-vpfe.c              |  19 +-
 drivers/media/platform/blackfin/bfin_capture.c           |  14 +-
 drivers/media/platform/coda/coda-bit.c                   |   6 +-
 drivers/media/platform/coda/coda-common.c                |   2 +-
 drivers/media/platform/coda/coda.h                       |   2 +-
 drivers/media/platform/davinci/vpbe_display.c            |  15 +-
 drivers/media/platform/davinci/vpif_capture.c            |  19 +-
 drivers/media/platform/davinci/vpif_display.c            |  19 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |   5 +-
 drivers/media/platform/exynos4-is/fimc-capture.c         |  33 ++-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       |  33 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c            |  33 ++-
 drivers/media/platform/exynos4-is/fimc-m2m.c             |   4 +-
 drivers/media/platform/m2m-deinterlace.c                 |   3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c          |  15 +-
 drivers/media/platform/mx2_emmaprp.c                     |   3 +-
 drivers/media/platform/omap3isp/ispvideo.c               |   3 +-
 drivers/media/platform/rcar_jpu.c                        |  27 ++-
 drivers/media/platform/s3c-camif/camif-capture.c         |  35 ++--
 drivers/media/platform/s5p-g2d/g2d.c                     |   4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c                 |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             |   1 -
 drivers/media/platform/s5p-tv/mixer_video.c              |   2 +-
 drivers/media/platform/sh_veu.c                          |  33 +--
 drivers/media/platform/sh_vou.c                          |  13 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |   4 +-
 drivers/media/platform/soc_camera/mx2_camera.c           |   8 +-
 drivers/media/platform/soc_camera/mx3_camera.c           |  40 +---
 drivers/media/platform/soc_camera/rcar_vin.c             |  42 +---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  39 +---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |  14 +-
 drivers/media/platform/ti-vpe/vpe.c                      |   3 +-
 drivers/media/platform/vim2m.c                           |  15 +-
 drivers/media/platform/vivid/vivid-core.h                |   2 +-
 drivers/media/platform/vivid/vivid-ctrls.c               |  14 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c         |   6 +-
 drivers/media/platform/vivid/vivid-kthread-out.c         |   8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c             |   6 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c             |   8 +-
 drivers/media/platform/vivid/vivid-vbi-out.c             |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c             |  22 +-
 drivers/media/platform/vivid/vivid-vid-out.c             |  19 +-
 drivers/media/platform/vsp1/vsp1_video.c                 |  53 +----
 drivers/media/platform/xilinx/xilinx-dma.c               |  14 +-
 drivers/media/usb/airspy/airspy.c                        |   4 +-
 drivers/media/usb/au0828/au0828-vbi.c                    |  14 +-
 drivers/media/usb/au0828/au0828-video.c                  |  14 +-
 drivers/media/usb/em28xx/em28xx-vbi.c                    |  20 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |  21 +-
 drivers/media/usb/go7007/go7007-driver.c                 |   2 +-
 drivers/media/usb/go7007/go7007-v4l2.c                   |   1 -
 drivers/media/usb/hackrf/hackrf.c                        |   6 +-
 drivers/media/usb/msi2500/msi2500.c                      |   1 -
 drivers/media/usb/pwc/pwc-if.c                           |   5 +-
 drivers/media/usb/s2255/s2255drv.c                       |   4 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                  |   2 +-
 drivers/media/usb/stk1160/stk1160-video.c                |   2 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |  11 +-
 drivers/media/usb/uvc/uvc_queue.c                        |  14 +-
 drivers/media/usb/uvc/uvc_video.c                        |  15 +-
 drivers/media/v4l2-core/videobuf2-core.c                 | 924 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/v4l2-core/videobuf2-internal.h             | 161 ---------------
 drivers/media/v4l2-core/videobuf2-v4l2.c                 | 701 +++++++--------------------------------------------------------
 drivers/staging/media/davinci_vpfe/vpfe_video.c          |   4 +-
 drivers/staging/media/omap4iss/iss_video.c               |   3 +-
 drivers/usb/gadget/function/uvc_queue.c                  |   4 +-
 include/media/videobuf2-core.h                           | 108 ++++++++--
 include/media/videobuf2-v4l2.h                           |  40 +---
 include/trace/events/v4l2.h                              |   4 +-
 include/trace/events/vb2.h                               |   7 +-
 100 files changed, 1384 insertions(+), 1549 deletions(-)
 delete mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
