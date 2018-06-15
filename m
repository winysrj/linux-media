Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35850 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTHu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:07:50 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 00/17] v4l2 core: push ioctl lock down to ioctl handler
Date: Fri, 15 Jun 2018 16:07:20 -0300
Message-Id: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fourth spin of the series posted by Hans:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg131363.html

There aren't any changes from v3, aside from rebasing
and re-ordering the patches as requested by Hans.

See v3 cover letter for more details.

Series was tested with tw686x, gspca sonixj and UVC devices.
Build tested with the 0-day kbuild test robot.

Changelog
---------

v4:
Rebased on top of today's next.

v3:
Reduce changes in patches 6 and 7 for omap3isp and omap4iss
drivers, as suggested by Hans.

v2:
Add the required driver modifications, fixing all
drivers so they define a proper vb2_queue lock.

Ezequiel Garcia (13):
  sta2x11: Add video_device and vb2_queue locks
  omap4iss: Add vb2_queue lock
  omap3isp: Add vb2_queue lock
  mtk-mdp: Add locks for capture and output vb2_queues
  s5p-g2d: Implement wait_prepare and wait_finish
  staging: bcm2835-camera: Provide lock for vb2_queue
  venus: Add video_device and vb2_queue locks
  davinci_vpfe: Add video_device and vb2_queue locks
  mx_emmaprp: Implement wait_prepare and wait_finish
  m2m-deinterlace: Implement wait_prepare and wait_finish
  stk1160: Set the vb2_queue lock before calling vb2_queue_init
  dvb-core: Provide lock for vb2_queue
  media: Remove wait_{prepare, finish}

Hans Verkuil (4):
  v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
  videobuf2-core: require q->lock
  videobuf2: assume q->lock is always set
  v4l2-ioctl.c: assume queue->lock is always set

 Documentation/media/kapi/v4l2-dev.rst         |  7 +--
 drivers/input/rmi4/rmi_f54.c                  |  2 -
 drivers/input/touchscreen/atmel_mxt_ts.c      |  2 -
 drivers/input/touchscreen/sur40.c             |  2 -
 .../media/common/videobuf2/videobuf2-core.c   | 22 +++----
 .../media/common/videobuf2/videobuf2-v4l2.c   | 41 +++---------
 drivers/media/dvb-core/dvb_vb2.c              | 20 +-----
 drivers/media/dvb-frontends/rtl2832_sdr.c     |  2 -
 drivers/media/i2c/video-i2c.c                 |  2 -
 drivers/media/pci/cobalt/cobalt-v4l2.c        |  2 -
 drivers/media/pci/cx23885/cx23885-417.c       |  2 -
 drivers/media/pci/cx23885/cx23885-dvb.c       |  2 -
 drivers/media/pci/cx23885/cx23885-vbi.c       |  2 -
 drivers/media/pci/cx23885/cx23885-video.c     |  2 -
 drivers/media/pci/cx25821/cx25821-video.c     |  2 -
 drivers/media/pci/cx88/cx88-blackbird.c       |  2 -
 drivers/media/pci/cx88/cx88-dvb.c             |  2 -
 drivers/media/pci/cx88/cx88-vbi.c             |  2 -
 drivers/media/pci/cx88/cx88-video.c           |  2 -
 drivers/media/pci/dt3155/dt3155.c             |  2 -
 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |  2 -
 drivers/media/pci/saa7134/saa7134-empress.c   |  2 -
 drivers/media/pci/saa7134/saa7134-ts.c        |  2 -
 drivers/media/pci/saa7134/saa7134-vbi.c       |  2 -
 drivers/media/pci/saa7134/saa7134-video.c     |  2 -
 .../media/pci/solo6x10/solo6x10-v4l2-enc.c    |  2 -
 drivers/media/pci/solo6x10/solo6x10-v4l2.c    |  2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c       |  4 ++
 drivers/media/pci/tw5864/tw5864-video.c       |  2 -
 drivers/media/pci/tw68/tw68-video.c           |  2 -
 drivers/media/pci/tw686x/tw686x-video.c       |  2 -
 drivers/media/platform/am437x/am437x-vpfe.c   |  2 -
 drivers/media/platform/atmel/atmel-isc.c      |  2 -
 drivers/media/platform/atmel/atmel-isi.c      |  2 -
 drivers/media/platform/coda/coda-common.c     |  2 -
 drivers/media/platform/davinci/vpbe_display.c |  2 -
 drivers/media/platform/davinci/vpif_capture.c |  2 -
 drivers/media/platform/davinci/vpif_display.c |  2 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |  2 -
 .../media/platform/exynos4-is/fimc-capture.c  |  2 -
 .../platform/exynos4-is/fimc-isp-video.c      |  2 -
 drivers/media/platform/exynos4-is/fimc-lite.c |  2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c  |  2 -
 drivers/media/platform/m2m-deinterlace.c      |  2 +
 .../media/platform/marvell-ccic/mcam-core.c   |  4 --
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   |  2 -
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 18 +-----
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      |  2 -
 .../platform/mtk-vcodec/mtk_vcodec_enc.c      |  2 -
 drivers/media/platform/mx2_emmaprp.c          |  2 +
 drivers/media/platform/omap3isp/ispvideo.c    | 63 +++----------------
 drivers/media/platform/omap3isp/ispvideo.h    |  1 -
 drivers/media/platform/pxa_camera.c           |  2 -
 .../platform/qcom/camss-8x16/camss-video.c    |  2 -
 drivers/media/platform/qcom/venus/core.h      |  4 +-
 drivers/media/platform/qcom/venus/helpers.c   | 16 ++---
 drivers/media/platform/qcom/venus/vdec.c      | 23 +++----
 drivers/media/platform/qcom/venus/venc.c      | 17 +++--
 drivers/media/platform/rcar-vin/rcar-dma.c    |  2 -
 drivers/media/platform/rcar_drif.c            |  2 -
 drivers/media/platform/rcar_fdp1.c            |  2 -
 drivers/media/platform/rcar_jpu.c             |  2 -
 drivers/media/platform/renesas-ceu.c          |  2 -
 drivers/media/platform/rockchip/rga/rga-buf.c |  2 -
 .../media/platform/s3c-camif/camif-capture.c  |  2 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |  2 -
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |  2 -
 drivers/media/platform/sh_veu.c               |  2 -
 drivers/media/platform/sh_vou.c               |  2 -
 .../soc_camera/sh_mobile_ceu_camera.c         |  2 -
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c |  2 -
 drivers/media/platform/sti/delta/delta-v4l2.c |  4 --
 drivers/media/platform/sti/hva/hva-v4l2.c     |  2 -
 drivers/media/platform/stm32/stm32-dcmi.c     |  2 -
 drivers/media/platform/ti-vpe/cal.c           |  2 -
 drivers/media/platform/ti-vpe/vpe.c           |  2 -
 drivers/media/platform/vim2m.c                |  2 -
 drivers/media/platform/vimc/vimc-capture.c    |  6 --
 drivers/media/platform/vivid/vivid-sdr-cap.c  |  2 -
 drivers/media/platform/vivid/vivid-vbi-cap.c  |  2 -
 drivers/media/platform/vivid/vivid-vbi-out.c  |  2 -
 drivers/media/platform/vivid/vivid-vid-cap.c  |  2 -
 drivers/media/platform/vivid/vivid-vid-out.c  |  2 -
 drivers/media/platform/vsp1/vsp1_histo.c      |  2 -
 drivers/media/platform/vsp1/vsp1_video.c      |  2 -
 drivers/media/platform/xilinx/xilinx-dma.c    |  2 -
 drivers/media/usb/airspy/airspy.c             |  2 -
 drivers/media/usb/au0828/au0828-vbi.c         |  2 -
 drivers/media/usb/au0828/au0828-video.c       |  2 -
 drivers/media/usb/em28xx/em28xx-vbi.c         |  2 -
 drivers/media/usb/em28xx/em28xx-video.c       |  2 -
 drivers/media/usb/go7007/go7007-v4l2.c        |  2 -
 drivers/media/usb/gspca/gspca.c               |  2 -
 drivers/media/usb/hackrf/hackrf.c             |  2 -
 drivers/media/usb/msi2500/msi2500.c           |  2 -
 drivers/media/usb/pwc/pwc-if.c                |  2 -
 drivers/media/usb/s2255/s2255drv.c            |  2 -
 drivers/media/usb/stk1160/stk1160-v4l.c       |  4 +-
 drivers/media/usb/usbtv/usbtv-video.c         |  2 -
 drivers/media/usb/uvc/uvc_queue.c             |  4 --
 drivers/media/v4l2-core/v4l2-ioctl.c          | 62 ++++++++++++++++--
 .../staging/media/davinci_vpfe/vpfe_video.c   |  4 +-
 .../staging/media/davinci_vpfe/vpfe_video.h   |  2 +-
 drivers/staging/media/imx/imx-media-capture.c |  2 -
 drivers/staging/media/omap4iss/iss_video.c    | 13 +---
 .../bcm2835-camera/bcm2835-camera.c           | 22 +------
 drivers/usb/gadget/function/uvc_queue.c       |  2 -
 include/media/videobuf2-core.h                |  2 -
 include/media/videobuf2-v4l2.h                | 18 ------
 samples/v4l/v4l2-pci-skeleton.c               |  7 ---
 111 files changed, 131 insertions(+), 429 deletions(-)

-- 
2.17.1
