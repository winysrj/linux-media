Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56673 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbbJLMpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 08:45:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6057C2A0095
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2015 14:43:13 +0200 (CEST)
Message-ID: <561BAAE1.3030608@xs4all.nl>
Date: Mon, 12 Oct 2015 14:43:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.4] Split the vb2 code into a v4l2 and core part
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit efe98010b80ec4516b2779e1b4e4a8ce16bf89fe:

  [media] DocBook: Fix remaining issues with VB2 core documentation (2015-10-05 09:12:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2-split

for you to fetch changes up to d9b227c16a31f9cd9296376e7cf39f2e460bf3ce:

  media: videobuf2: Move v4l2-specific stuff to videobuf2-v4l2 (2015-10-12 14:37:23 +0200)

----------------------------------------------------------------
Junghak Sung (4):
      media: videobuf2: Change queue_setup argument
      media: videobuf2: Replace v4l2-specific data with vb2 data.
      media: videobuf2: Prepare to divide videobuf2
      media: videobuf2: Move v4l2-specific stuff to videobuf2-v4l2

 Documentation/video4linux/v4l2-pci-skeleton.c            |    4 +-
 drivers/input/touchscreen/sur40.c                        |    3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c                |    2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c                   |    4 +-
 drivers/media/pci/cx23885/cx23885-417.c                  |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                  |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c                  |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c                |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c                |    3 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                        |    2 +-
 drivers/media/pci/cx88/cx88-vbi.c                        |    2 +-
 drivers/media/pci/cx88/cx88-video.c                      |    2 +-
 drivers/media/pci/dt3155/dt3155.c                        |    3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c       |    2 +-
 drivers/media/pci/saa7134/saa7134-ts.c                   |    2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c                  |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c                |    2 +-
 drivers/media/pci/saa7134/saa7134.h                      |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c           |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c               |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                  |    2 +-
 drivers/media/pci/tw68/tw68-video.c                      |    3 +-
 drivers/media/platform/am437x/am437x-vpfe.c              |    3 +-
 drivers/media/platform/blackfin/bfin_capture.c           |    3 +-
 drivers/media/platform/coda/coda-common.c                |    3 +-
 drivers/media/platform/davinci/vpbe_display.c            |    3 +-
 drivers/media/platform/davinci/vpif_capture.c            |    3 +-
 drivers/media/platform/davinci/vpif_display.c            |    3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c         |    3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       |    3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            |    3 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c             |    2 +-
 drivers/media/platform/m2m-deinterlace.c                 |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c          |    3 +-
 drivers/media/platform/mx2_emmaprp.c                     |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c               |    2 +-
 drivers/media/platform/rcar_jpu.c                        |    3 +-
 drivers/media/platform/s3c-camif/camif-capture.c         |    3 +-
 drivers/media/platform/s5p-g2d/g2d.c                     |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c              |    2 +-
 drivers/media/platform/sh_veu.c                          |    3 +-
 drivers/media/platform/sh_vou.c                          |    3 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c           |    3 +-
 drivers/media/platform/soc_camera/mx3_camera.c           |    3 +-
 drivers/media/platform/soc_camera/rcar_vin.c             |    3 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |    6 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            |    3 +-
 drivers/media/platform/ti-vpe/vpe.c                      |    2 +-
 drivers/media/platform/vim2m.c                           |    3 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c             |    2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c             |    7 +-
 drivers/media/platform/vivid/vivid-vbi-out.c             |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c             |    3 +-
 drivers/media/platform/vivid/vivid-vid-out.c             |    3 +-
 drivers/media/platform/vsp1/vsp1_video.c                 |    3 +-
 drivers/media/platform/xilinx/xilinx-dma.c               |    3 +-
 drivers/media/usb/airspy/airspy.c                        |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c                    |    3 +-
 drivers/media/usb/au0828/au0828-video.c                  |    3 +-
 drivers/media/usb/em28xx/em28xx-vbi.c                    |    3 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |    3 +-
 drivers/media/usb/go7007/go7007-v4l2.c                   |    2 +-
 drivers/media/usb/hackrf/hackrf.c                        |    2 +-
 drivers/media/usb/msi2500/msi2500.c                      |    2 +-
 drivers/media/usb/pwc/pwc-if.c                           |    2 +-
 drivers/media/usb/s2255/s2255drv.c                       |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                  |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                        |    3 +-
 drivers/media/v4l2-core/Makefile                         |    2 +-
 drivers/media/v4l2-core/v4l2-trace.c                     |    8 +-
 drivers/media/v4l2-core/vb2-trace.c                      |    9 +
 drivers/media/v4l2-core/videobuf2-core.c                 | 1961 ++++++------------------------------------------------
 drivers/media/v4l2-core/videobuf2-internal.h             |  161 +++++
 drivers/media/v4l2-core/videobuf2-v4l2.c                 | 1630 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_video.c          |    2 +-
 drivers/staging/media/omap4iss/iss_video.c               |    2 +-
 drivers/usb/gadget/function/uvc_queue.c                  |    2 +-
 include/media/videobuf2-core.h                           |  153 ++---
 include/media/videobuf2-dvb.h                            |    8 +-
 include/media/videobuf2-v4l2.h                           |  104 +++
 include/trace/events/v4l2.h                              |   33 +-
 include/trace/events/vb2.h                               |   65 ++
 89 files changed, 2369 insertions(+), 1967 deletions(-)
 create mode 100644 drivers/media/v4l2-core/vb2-trace.c
 create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
 create mode 100644 include/trace/events/vb2.h
