Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53114 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbcDONED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 09:04:03 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6B938180436
	for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 15:03:56 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 00/12] vb2: replace allocation context by device pointer
Date: Fri, 15 Apr 2016 15:03:44 +0200
Message-Id: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The opaque allocation context that allocators use and drivers have to fill
in is really nothing more than a device pointer wrapped in an kmalloc()ed
struct.

This patch series adds a new 'struct device *dev' field that contains the
default device pointer to use if the driver doesn't set alloc_ctxs. This
simplifies many drivers since there are only two Samsung drivers that need
different devices for different planes. All others use the same device for
everything.

So instead of having to allocate a context (and free it, which not all
drivers did) you just set a dev pointer once.

The last patch removes the allocation context code altogether and replaces
it with proper struct device pointers instead of the untyped void pointer.

Note: one idea I toyed with was to have an array of devs instead of a
single dev field in vb2_queue, but that was actually awkward to use.

A single dev turned out to be much easier to use.

Regards,

        Hans

Changes since v1:
- rebased against latest linuxtv master
- add dma_attrs field to vb2_queue to specify non-standard DMA attributes
  for both dma-contig. This feature was added to v4.6.

Hans Verkuil (12):
  vb2: add a dev field to use for the default allocation context
  v4l2-pci-skeleton: set q->dev instead of allocating a context
  sur40: set q->dev instead of allocating a context
  media/pci: convert drivers to use the new vb2_queue dev field
  staging/media: convert drivers to use the new vb2_queue dev field
  media/platform: convert drivers to use the new vb2_queue dev field
  media/platform: convert drivers to use the new vb2_queue dev field
  media/platform: convert drivers to use the new vb2_queue dev field
  media/.../soc-camera: convert drivers to use the new vb2_queue dev
    field
  media/platform: convert drivers to use the new vb2_queue dev field
  media/platform: convert drivers to use the new vb2_queue dev field
  vb2: replace void *alloc_ctxs by struct device *alloc_devs

 Documentation/video4linux/v4l2-pci-skeleton.c      | 17 ++------
 drivers/input/touchscreen/sur40.c                  | 15 +------
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |  9 ----
 drivers/media/pci/cobalt/cobalt-driver.h           |  1 -
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  4 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  3 +-
 drivers/media/pci/cx23885/cx23885-core.c           | 10 +----
 drivers/media/pci/cx23885/cx23885-dvb.c            |  4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  3 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  5 ++-
 drivers/media/pci/cx23885/cx23885.h                |  1 -
 drivers/media/pci/cx25821/cx25821-core.c           | 10 +----
 drivers/media/pci/cx25821/cx25821-video.c          |  5 +--
 drivers/media/pci/cx25821/cx25821.h                |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c            |  4 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  4 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 | 10 +----
 drivers/media/pci/cx88/cx88-vbi.c                  |  3 +-
 drivers/media/pci/cx88/cx88-video.c                | 13 ++----
 drivers/media/pci/cx88/cx88.h                      |  2 -
 drivers/media/pci/dt3155/dt3155.c                  | 15 ++-----
 drivers/media/pci/dt3155/dt3155.h                  |  2 -
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
 drivers/media/pci/saa7134/saa7134-core.c           | 22 ++++------
 drivers/media/pci/saa7134/saa7134-ts.c             |  3 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  3 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  5 ++-
 drivers/media/pci/saa7134/saa7134.h                |  3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     | 13 +-----
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         | 12 +-----
 drivers/media/pci/solo6x10/solo6x10.h              |  2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c            | 20 ++-------
 drivers/media/pci/tw68/tw68-core.c                 | 15 ++-----
 drivers/media/pci/tw68/tw68-video.c                |  4 +-
 drivers/media/pci/tw68/tw68.h                      |  1 -
 drivers/media/platform/am437x/am437x-vpfe.c        | 14 ++-----
 drivers/media/platform/am437x/am437x-vpfe.h        |  2 -
 drivers/media/platform/blackfin/bfin_capture.c     | 17 ++------
 drivers/media/platform/coda/coda-common.c          | 18 ++------
 drivers/media/platform/coda/coda.h                 |  1 -
 drivers/media/platform/davinci/vpbe_display.c      | 14 +------
 drivers/media/platform/davinci/vpif_capture.c      | 15 ++-----
 drivers/media/platform/davinci/vpif_capture.h      |  2 -
 drivers/media/platform/davinci/vpif_display.c      | 15 ++-----
 drivers/media/platform/davinci/vpif_display.h      |  2 -
 drivers/media/platform/exynos-gsc/gsc-core.c       | 11 +----
 drivers/media/platform/exynos-gsc/gsc-core.h       |  2 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  8 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c   |  9 ++--
 drivers/media/platform/exynos4-is/fimc-core.c      | 11 -----
 drivers/media/platform/exynos4-is/fimc-core.h      |  3 --
 drivers/media/platform/exynos4-is/fimc-is.c        | 13 +-----
 drivers/media/platform/exynos4-is/fimc-is.h        |  2 -
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 11 ++---
 drivers/media/platform/exynos4-is/fimc-isp.h       |  2 -
 drivers/media/platform/exynos4-is/fimc-lite.c      | 21 ++--------
 drivers/media/platform/exynos4-is/fimc-lite.h      |  2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  8 ++--
 drivers/media/platform/m2m-deinterlace.c           | 17 ++------
 drivers/media/platform/marvell-ccic/mcam-core.c    | 26 +-----------
 drivers/media/platform/marvell-ccic/mcam-core.h    |  2 -
 drivers/media/platform/mx2_emmaprp.c               | 19 ++-------
 drivers/media/platform/omap3isp/ispvideo.c         | 14 ++-----
 drivers/media/platform/omap3isp/ispvideo.h         |  1 -
 drivers/media/platform/rcar_jpu.c                  | 24 +++--------
 drivers/media/platform/s3c-camif/camif-capture.c   |  5 +--
 drivers/media/platform/s3c-camif/camif-core.c      | 11 +----
 drivers/media/platform/s3c-camif/camif-core.h      |  2 -
 drivers/media/platform/s5p-g2d/g2d.c               | 16 ++-----
 drivers/media/platform/s5p-g2d/g2d.h               |  1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 20 +++------
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 19 +--------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 12 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 16 +++----
 drivers/media/platform/s5p-tv/mixer.h              |  2 -
 drivers/media/platform/s5p-tv/mixer_video.c        | 18 ++------
 drivers/media/platform/sh_veu.c                    | 19 ++-------
 drivers/media/platform/sh_vou.c                    | 16 ++-----
 drivers/media/platform/soc_camera/atmel-isi.c      | 15 +------
 drivers/media/platform/soc_camera/rcar_vin.c       | 14 +------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 17 ++------
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 18 ++------
 drivers/media/platform/sti/bdisp/bdisp.h           |  2 -
 drivers/media/platform/ti-vpe/cal.c                | 17 +-------
 drivers/media/platform/ti-vpe/vpe.c                | 22 +++-------
 drivers/media/platform/vim2m.c                     |  7 +---
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  7 +---
 drivers/media/platform/vivid/vivid-vid-out.c       |  7 +---
 drivers/media/platform/vsp1/vsp1_video.c           | 22 +++-------
 drivers/media/platform/vsp1/vsp1_video.h           |  1 -
 drivers/media/platform/xilinx/xilinx-dma.c         | 13 +-----
 drivers/media/platform/xilinx/xilinx-dma.h         |  2 -
 drivers/media/usb/airspy/airspy.c                  |  2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |  2 +-
 drivers/media/usb/au0828/au0828-video.c            |  2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |  2 +-
 drivers/media/usb/hackrf/hackrf.c                  |  2 +-
 drivers/media/usb/msi2500/msi2500.c                |  2 +-
 drivers/media/usb/pwc/pwc-if.c                     |  2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 28 +++++++------
 drivers/media/v4l2-core/videobuf2-dma-contig.c     | 49 ++++------------------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         | 45 ++++----------------
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |  9 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 14 ++-----
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  2 -
 drivers/staging/media/mx2/mx2_camera.c             | 19 ++-------
 drivers/staging/media/mx3/mx3_camera.c             | 18 ++------
 drivers/staging/media/omap4iss/iss_video.c         | 12 +-----
 drivers/staging/media/omap4iss/iss_video.h         |  1 -
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 include/media/davinci/vpbe_display.h               |  2 -
 include/media/videobuf2-core.h                     | 24 ++++++-----
 include/media/videobuf2-dma-contig.h               | 10 -----
 include/media/videobuf2-dma-sg.h                   |  3 --
 126 files changed, 255 insertions(+), 894 deletions(-)

-- 
2.8.0.rc3

