Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50999 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbcGAOwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 10:52:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0FEE8180106
	for <linux-media@vger.kernel.org>; Fri,  1 Jul 2016 16:51:58 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] vb2: replace allocation context by device pointer
Message-ID: <97e80c64-fc29-a953-1c1c-ca89a22bf740@xs4all.nl>
Date: Fri, 1 Jul 2016 16:51:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request is a rebased version of the patch v5 series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg98729.html

together with the tw686x fix (needed due to the rebase):

https://patchwork.linuxtv.org/patch/34965/

(note: the subject and commit log as posted on the list is a bit garbled, but that is fixed in
this pull request).

See the cover letter (first link above) of the patch series for the details.

It greatly simplifies drivers: 663 lines were removed.

Regards,

	Hans

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git context3

for you to fetch changes up to 78a40101e916b4c265f763d63eff8daa0e3b2932:

  vb2: replace void *alloc_ctxs by struct device *alloc_devs (2016-07-01 11:51:12 +0200)

----------------------------------------------------------------
Hans Verkuil (14):
      vb2: move dma_attrs to vb2_queue
      vb2: add a dev field to use for the default allocation context
      v4l2-pci-skeleton: set q->dev instead of allocating a context
      sur40: set q->dev instead of allocating a context
      media/pci: convert drivers to use the new vb2_queue dev field
      media/pci/tw686x: convert driver to use the new vb2_queue dev field
      staging/media: convert drivers to use the new vb2_queue dev field
      media/platform: convert drivers to use the new vb2_queue dev field
      media/platform: convert drivers to use the new vb2_queue dev field
      media/platform: convert drivers to use the new vb2_queue dev field
      media/.../soc-camera: convert drivers to use the new vb2_queue dev field
      media/platform: convert drivers to use the new vb2_queue dev field
      media/platform: convert drivers to use the new vb2_queue dev field
      vb2: replace void *alloc_ctxs by struct device *alloc_devs

 drivers/input/touchscreen/sur40.c                        | 15 ++------------
 drivers/media/dvb-frontends/rtl2832_sdr.c                |  2 +-
 drivers/media/pci/cobalt/cobalt-driver.c                 |  9 --------
 drivers/media/pci/cobalt/cobalt-driver.h                 |  1 -
 drivers/media/pci/cobalt/cobalt-v4l2.c                   |  4 ++--
 drivers/media/pci/cx23885/cx23885-417.c                  |  3 +--
 drivers/media/pci/cx23885/cx23885-core.c                 | 10 +--------
 drivers/media/pci/cx23885/cx23885-dvb.c                  |  4 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c                  |  3 +--
 drivers/media/pci/cx23885/cx23885-video.c                |  5 +++--
 drivers/media/pci/cx23885/cx23885.h                      |  1 -
 drivers/media/pci/cx25821/cx25821-core.c                 | 10 +--------
 drivers/media/pci/cx25821/cx25821-video.c                |  5 ++---
 drivers/media/pci/cx25821/cx25821.h                      |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c                  |  4 ++--
 drivers/media/pci/cx88/cx88-dvb.c                        |  4 ++--
 drivers/media/pci/cx88/cx88-mpeg.c                       | 10 +--------
 drivers/media/pci/cx88/cx88-vbi.c                        |  3 +--
 drivers/media/pci/cx88/cx88-video.c                      | 13 +++---------
 drivers/media/pci/cx88/cx88.h                            |  2 --
 drivers/media/pci/dt3155/dt3155.c                        | 15 +++-----------
 drivers/media/pci/dt3155/dt3155.h                        |  2 --
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c       |  2 +-
 drivers/media/pci/saa7134/saa7134-core.c                 | 22 +++++++-------------
 drivers/media/pci/saa7134/saa7134-ts.c                   |  3 +--
 drivers/media/pci/saa7134/saa7134-vbi.c                  |  3 +--
 drivers/media/pci/saa7134/saa7134-video.c                |  5 +++--
 drivers/media/pci/saa7134/saa7134.h                      |  3 +--
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c           | 13 ++----------
 drivers/media/pci/solo6x10/solo6x10-v4l2.c               | 12 ++---------
 drivers/media/pci/solo6x10/solo6x10.h                    |  2 --
 drivers/media/pci/sta2x11/sta2x11_vip.c                  | 20 +++---------------
 drivers/media/pci/tw68/tw68-core.c                       | 15 +++-----------
 drivers/media/pci/tw68/tw68-video.c                      |  4 ++--
 drivers/media/pci/tw68/tw68.h                            |  1 -
 drivers/media/pci/tw686x/tw686x-video.c                  | 36 ++------------------------------
 drivers/media/pci/tw686x/tw686x.h                        |  3 ---
 drivers/media/platform/am437x/am437x-vpfe.c              | 14 +++----------
 drivers/media/platform/am437x/am437x-vpfe.h              |  2 --
 drivers/media/platform/blackfin/bfin_capture.c           | 17 +++------------
 drivers/media/platform/coda/coda-common.c                | 18 +++-------------
 drivers/media/platform/coda/coda.h                       |  1 -
 drivers/media/platform/davinci/vpbe_display.c            | 14 ++-----------
 drivers/media/platform/davinci/vpif_capture.c            | 15 +++-----------
 drivers/media/platform/davinci/vpif_capture.h            |  2 --
 drivers/media/platform/davinci/vpif_display.c            | 15 +++-----------
 drivers/media/platform/davinci/vpif_display.h            |  2 --
 drivers/media/platform/exynos-gsc/gsc-core.c             | 10 +--------
 drivers/media/platform/exynos-gsc/gsc-core.h             |  2 --
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |  8 ++++----
 drivers/media/platform/exynos4-is/fimc-capture.c         |  9 +++-----
 drivers/media/platform/exynos4-is/fimc-core.c            | 10 ---------
 drivers/media/platform/exynos4-is/fimc-core.h            |  3 ---
 drivers/media/platform/exynos4-is/fimc-is.c              | 13 +-----------
 drivers/media/platform/exynos4-is/fimc-is.h              |  2 --
 drivers/media/platform/exynos4-is/fimc-isp-video.c       | 11 ++++------
 drivers/media/platform/exynos4-is/fimc-isp.h             |  2 --
 drivers/media/platform/exynos4-is/fimc-lite.c            | 20 ++++--------------
 drivers/media/platform/exynos4-is/fimc-lite.h            |  2 --
 drivers/media/platform/exynos4-is/fimc-m2m.c             |  8 ++++----
 drivers/media/platform/m2m-deinterlace.c                 | 17 +++------------
 drivers/media/platform/marvell-ccic/mcam-core.c          | 26 ++---------------------
 drivers/media/platform/marvell-ccic/mcam-core.h          |  2 --
 drivers/media/platform/mx2_emmaprp.c                     | 19 ++++-------------
 drivers/media/platform/omap3isp/ispvideo.c               | 14 +++----------
 drivers/media/platform/omap3isp/ispvideo.h               |  1 -
 drivers/media/platform/rcar-vin/rcar-dma.c               | 13 ++----------
 drivers/media/platform/rcar-vin/rcar-vin.h               |  2 --
 drivers/media/platform/rcar_jpu.c                        | 24 +++++-----------------
 drivers/media/platform/s3c-camif/camif-capture.c         |  5 ++---
 drivers/media/platform/s3c-camif/camif-core.c            | 11 +---------
 drivers/media/platform/s3c-camif/camif-core.h            |  2 --
 drivers/media/platform/s5p-g2d/g2d.c                     | 15 ++++----------
 drivers/media/platform/s5p-g2d/g2d.h                     |  1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c              | 19 +++++------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h              |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc.c                 | 18 +---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h          |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             | 12 +++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             | 16 ++++++---------
 drivers/media/platform/s5p-tv/mixer.h                    |  2 --
 drivers/media/platform/s5p-tv/mixer_video.c              | 17 +++------------
 drivers/media/platform/sh_veu.c                          | 19 ++++-------------
 drivers/media/platform/sh_vou.c                          | 16 +++------------
 drivers/media/platform/soc_camera/atmel-isi.c            | 15 ++------------
 drivers/media/platform/soc_camera/rcar_vin.c             | 14 ++-----------
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 17 +++------------
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c            | 18 ++++------------
 drivers/media/platform/sti/bdisp/bdisp.h                 |  2 --
 drivers/media/platform/ti-vpe/cal.c                      | 17 ++-------------
 drivers/media/platform/ti-vpe/vpe.c                      | 22 +++++---------------
 drivers/media/platform/vim2m.c                           |  7 +------
 drivers/media/platform/vivid/vivid-sdr-cap.c             |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c             |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c             |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c             |  7 +------
 drivers/media/platform/vivid/vivid-vid-out.c             |  7 +------
 drivers/media/platform/vsp1/vsp1_video.c                 | 22 +++++---------------
 drivers/media/platform/vsp1/vsp1_video.h                 |  1 -
 drivers/media/platform/xilinx/xilinx-dma.c               | 13 ++----------
 drivers/media/platform/xilinx/xilinx-dma.h               |  2 --
 drivers/media/usb/airspy/airspy.c                        |  2 +-
 drivers/media/usb/au0828/au0828-vbi.c                    |  2 +-
 drivers/media/usb/au0828/au0828-video.c                  |  2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c                    |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |  2 +-
 drivers/media/usb/go7007/go7007-v4l2.c                   |  2 +-
 drivers/media/usb/hackrf/hackrf.c                        |  2 +-
 drivers/media/usb/msi2500/msi2500.c                      |  2 +-
 drivers/media/usb/pwc/pwc-if.c                           |  2 +-
 drivers/media/usb/s2255/s2255drv.c                       |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                  |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |  2 +-
 drivers/media/usb/uvc/uvc_queue.c                        |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c                 | 28 +++++++++++++------------
 drivers/media/v4l2-core/videobuf2-dma-contig.c           | 49 ++++++++------------------------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c               | 45 ++++++++--------------------------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c              |  9 ++++----
 drivers/staging/media/davinci_vpfe/vpfe_video.c          | 14 +++----------
 drivers/staging/media/davinci_vpfe/vpfe_video.h          |  2 --
 drivers/staging/media/omap4iss/iss_video.c               | 12 ++---------
 drivers/staging/media/omap4iss/iss_video.h               |  1 -
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c        | 12 ++---------
 drivers/staging/media/tw686x-kh/tw686x-kh.h              |  1 -
 drivers/usb/gadget/function/uvc_queue.c                  |  2 +-
 include/media/davinci/vpbe_display.h                     |  2 --
 include/media/videobuf2-core.h                           | 24 +++++++++++++---------
 include/media/videobuf2-dma-contig.h                     |  9 --------
 include/media/videobuf2-dma-sg.h                         |  3 ---
 samples/v4l/v4l2-pci-skeleton.c                          | 17 +++------------
 130 files changed, 254 insertions(+), 917 deletions(-)
