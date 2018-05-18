Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33338 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbeERSxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:53:36 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC PATCH v2 00/20] v4l2 core: push ioctl lock down to ioctl handler
Date: Fri, 18 May 2018 15:51:48 -0300
Message-Id: <20180518185208.17722-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's a second spin of the series posted by Hans:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg131363.html

This v2 adds the required driver modifications, fixing all
drivers so they define a proper vb2_queue lock.

A only exception to this is netup_unidvb. It isn't really obvious
to me how this driver should lock its vb2_queue. Neither it is
clear how its vb2_queue is used by the driver in the first place.

Abylay, perhaps you can take a look at it?

Why?
----

While working on the DMA fence API (aka expliciy sync framework)
and the Request API it became clear that the core ioctl scheme
was done at a too-high level.

Being able to actually look at the struct passed as the ioctl
argument would help a lot in decide what lock(s) to take.

This patch series pushes the lock down into v4l2-ioctl.c, after
video_usercopy() was called.

This series seems to improve overall quality of drivers:
in practice, drivers choosing to do their own locking, end up
introducing races and/or not setting wait_prepare/wait_finish
despite being possible to do so.

Patch journal
-------------

The first patch is for the only driver that does not set
unlocked_ioctl to video_ioctl2: pvrusb2. It actually does
call it in its own unlocked_ioctl function.

The second patch pushes the lock down.

The third patch adds support for mem2mem devices by selecting
the correct queue lock (capture vs output): this was never
possible before.

Patches 4 to 16 add the now mandatory vb2_queue lock and then
sets wait_prepare and wait_finish hooks.

Patches 17 to 19 require that queue->lock is always set. This
means wait_prepare and wait_finish is now unused.

The last patch removes the now unused wait_prepare and wait_finish.

This patchset is currently based on top of the gspca vb2
conversion series, hoping it would get merged sooner than this.

Ezequiel Garcia (14):
  usbtv: Implement wait_prepare and wait_finish
  sta2x11: Add video_device and vb2_queue locks
  omap4iss: Add video_device and vb2_queue locks
  omap3isp: Add video_device and vb2_queue locks
  mtk-mdp: Add locks for capture and output vb2_queues
  s5p-g2d: Implement wait_prepare and wait_finish
  staging: bcm2835-camera: Provide lock for vb2_queue
  dvb-core: Provide lock for vb2_queue
  venus: Add video_device and vb2_queue locks
  davinci_vpfe: Add video_device and vb2_queue locks
  mx_emmaprp: Implement wait_prepare and wait_finish
  m2m-deinterlace: Implement wait_prepare and wait_finish
  stk1160: Set the vb2_queue lock before calling vb2_queue_init
  media: Remove wait_{prepare, finish}

Hans Verkuil (6):
  pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
  v4l2-core: push taking ioctl mutex down to ioctl handler.
  v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
  videobuf2-core: require q->lock
  videobuf2: assume q->lock is always set
  v4l2-ioctl.c: assume queue->lock is always set

 Documentation/media/kapi/v4l2-dev.rst              |  7 +-
 drivers/input/rmi4/rmi_f54.c                       |  2 -
 drivers/input/touchscreen/atmel_mxt_ts.c           |  2 -
 drivers/input/touchscreen/sur40.c                  |  2 -
 drivers/media/common/videobuf2/videobuf2-core.c    | 22 +++---
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 41 ++--------
 drivers/media/dvb-core/dvb_vb2.c                   | 20 +----
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 -
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  2 -
 drivers/media/pci/cx23885/cx23885-417.c            |  2 -
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 -
 drivers/media/pci/cx23885/cx23885-vbi.c            |  2 -
 drivers/media/pci/cx23885/cx23885-video.c          |  2 -
 drivers/media/pci/cx25821/cx25821-video.c          |  2 -
 drivers/media/pci/cx88/cx88-blackbird.c            |  2 -
 drivers/media/pci/cx88/cx88-dvb.c                  |  2 -
 drivers/media/pci/cx88/cx88-vbi.c                  |  2 -
 drivers/media/pci/cx88/cx88-video.c                |  2 -
 drivers/media/pci/dt3155/dt3155.c                  |  2 -
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  2 -
 drivers/media/pci/saa7134/saa7134-empress.c        |  2 -
 drivers/media/pci/saa7134/saa7134-ts.c             |  2 -
 drivers/media/pci/saa7134/saa7134-vbi.c            |  2 -
 drivers/media/pci/saa7134/saa7134-video.c          |  2 -
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  2 -
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  4 +
 drivers/media/pci/tw5864/tw5864-video.c            |  2 -
 drivers/media/pci/tw68/tw68-video.c                |  2 -
 drivers/media/pci/tw686x/tw686x-video.c            |  2 -
 drivers/media/platform/am437x/am437x-vpfe.c        |  2 -
 drivers/media/platform/atmel/atmel-isc.c           |  2 -
 drivers/media/platform/atmel/atmel-isi.c           |  2 -
 drivers/media/platform/coda/coda-common.c          |  2 -
 drivers/media/platform/davinci/vpbe_display.c      |  2 -
 drivers/media/platform/davinci/vpif_capture.c      |  2 -
 drivers/media/platform/davinci/vpif_display.c      |  2 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  2 -
 drivers/media/platform/exynos4-is/fimc-capture.c   |  2 -
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 -
 drivers/media/platform/exynos4-is/fimc-lite.c      |  2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 -
 drivers/media/platform/m2m-deinterlace.c           |  2 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |  4 -
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |  2 -
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       | 18 +----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  2 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |  2 -
 drivers/media/platform/mx2_emmaprp.c               |  2 +
 drivers/media/platform/omap3isp/ispvideo.c         | 92 +++-------------------
 drivers/media/platform/omap3isp/ispvideo.h         |  3 +-
 drivers/media/platform/pxa_camera.c                |  2 -
 .../media/platform/qcom/camss-8x16/camss-video.c   |  2 -
 drivers/media/platform/qcom/venus/core.h           |  4 +-
 drivers/media/platform/qcom/venus/helpers.c        | 16 ++--
 drivers/media/platform/qcom/venus/vdec.c           | 23 ++----
 drivers/media/platform/qcom/venus/venc.c           | 17 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c         |  2 -
 drivers/media/platform/rcar_drif.c                 |  2 -
 drivers/media/platform/rcar_fdp1.c                 |  2 -
 drivers/media/platform/rcar_jpu.c                  |  2 -
 drivers/media/platform/renesas-ceu.c               |  2 -
 drivers/media/platform/rockchip/rga/rga-buf.c      |  2 -
 drivers/media/platform/s3c-camif/camif-capture.c   |  2 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  2 -
 drivers/media/platform/sh_veu.c                    |  2 -
 drivers/media/platform/sh_vou.c                    |  2 -
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  2 -
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  2 -
 drivers/media/platform/sti/delta/delta-v4l2.c      |  4 -
 drivers/media/platform/sti/hva/hva-v4l2.c          |  2 -
 drivers/media/platform/stm32/stm32-dcmi.c          |  2 -
 drivers/media/platform/ti-vpe/cal.c                |  2 -
 drivers/media/platform/ti-vpe/vpe.c                |  2 -
 drivers/media/platform/vim2m.c                     |  2 -
 drivers/media/platform/vimc/vimc-capture.c         |  6 --
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 -
 drivers/media/platform/vivid/vivid-vid-cap.c       |  2 -
 drivers/media/platform/vivid/vivid-vid-out.c       |  2 -
 drivers/media/platform/vsp1/vsp1_histo.c           |  2 -
 drivers/media/platform/vsp1/vsp1_video.c           |  2 -
 drivers/media/platform/xilinx/xilinx-dma.c         |  2 -
 drivers/media/usb/airspy/airspy.c                  |  2 -
 drivers/media/usb/au0828/au0828-vbi.c              |  2 -
 drivers/media/usb/au0828/au0828-video.c            |  2 -
 drivers/media/usb/em28xx/em28xx-vbi.c              |  2 -
 drivers/media/usb/em28xx/em28xx-video.c            |  2 -
 drivers/media/usb/go7007/go7007-v4l2.c             |  2 -
 drivers/media/usb/gspca/gspca.c                    |  2 -
 drivers/media/usb/hackrf/hackrf.c                  |  2 -
 drivers/media/usb/msi2500/msi2500.c                |  2 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 83 ++++++++-----------
 drivers/media/usb/pwc/pwc-if.c                     |  2 -
 drivers/media/usb/s2255/s2255drv.c                 |  2 -
 drivers/media/usb/stk1160/stk1160-v4l.c            |  4 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  4 -
 drivers/media/v4l2-core/v4l2-dev.c                 |  6 --
 drivers/media/v4l2-core/v4l2-ioctl.c               | 75 ++++++++++++++++--
 drivers/media/v4l2-core/v4l2-subdev.c              | 17 +++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  4 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  2 +-
 drivers/staging/media/imx/imx-media-capture.c      |  2 -
 drivers/staging/media/omap4iss/iss_video.c         | 30 ++-----
 drivers/staging/media/omap4iss/iss_video.h         |  2 +-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  | 22 +-----
 drivers/usb/gadget/function/uvc_queue.c            |  2 -
 include/media/v4l2-dev.h                           |  9 ---
 include/media/v4l2-ioctl.h                         | 12 ---
 include/media/videobuf2-core.h                     |  2 -
 include/media/videobuf2-v4l2.h                     | 18 -----
 samples/v4l/v4l2-pci-skeleton.c                    |  7 --
 115 files changed, 200 insertions(+), 546 deletions(-)

-- 
2.16.3
