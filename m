Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:40113 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbeCIRt2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:49:28 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 00/13] V4L2 Explicit Synchronization
Date: Fri,  9 Mar 2018 14:49:07 -0300
Message-Id: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

So v8 is finally out addressing the comments from the previous version[1].
For more info see v5 cover letter[2]. The most important points I address
here is the handling of fences that signal with error to follow Hans
suggestion. I also added V4L2_CAP_FENCES to all vb2 drivers and marked all
codec and cobalt as unordered. More specific changelog are noted on the
patches itself.

The first 3 patches are just clean ups in preparation to add the new cap flag
and can go upstream earlier. Then there are patches to add unordered info,
the actual fences implementation and later the V4L2_CAP_FENCES flag.
The last patch contains the Documentation.

You can find the code at:

https://gitlab.collabora.com/padovan/linux/tree/v4l2-fences

The test tools I've been using are:
https://gitlab.collabora.com/padovan/drm-v4l2-test
https://gitlab.collabora.com/padovan/v4l2-fences-test

Please review,

Gustavo

[1] https://lkml.org/lkml/2018/1/10/644
[2] https://lkml.org/lkml/2017/11/15/550

Gustavo Padovan (13):
  [media] xilinx: regroup caps on querycap
  [media] hackrf: group device capabilities
  [media] omap3isp: group device capabilities
  [media] vb2: add is_unordered callback for drivers
  [media] v4l: add 'unordered' flag to format description ioctl
  [media] cobalt: add .is_unordered() for cobalt
  [media] vb2: mark codec drivers as unordered
  [media] vb2: add explicit fence user API
  [media] vb2: add in-fence support to QBUF
  [media] vb2: add out-fence support to QBUF
  [media] v4l: introduce the fences capability
  [media] v4l: Add V4L2_CAP_FENCES to drivers
  [media] v4l: Document explicit synchronization behavior

 Documentation/media/uapi/v4l/buffer.rst            |  45 +++-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   7 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  55 +++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  12 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   3 +
 drivers/media/common/videobuf2/videobuf2-core.c    | 289 ++++++++++++++++++---
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |  58 ++++-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   4 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   3 +-
 drivers/media/pci/cx88/cx88-video.c                |   3 +-
 drivers/media/pci/dt3155/dt3155.c                  |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   2 +
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   3 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   3 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   2 +-
 drivers/media/pci/tw68/tw68-video.c                |   3 +-
 drivers/media/pci/tw686x/tw686x-video.c            |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   3 +-
 drivers/media/platform/coda/coda-common.c          |   4 +-
 drivers/media/platform/davinci/vpbe_display.c      |   3 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   3 +-
 drivers/media/platform/davinci/vpif_capture.c      |   3 +-
 drivers/media/platform/davinci/vpif_display.c      |   3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   4 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   4 +-
 drivers/media/platform/m2m-deinterlace.c           |   4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   1 +
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   1 +
 drivers/media/platform/mx2_emmaprp.c               |   4 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   9 +-
 drivers/media/platform/pxa_camera.c                |   3 +-
 drivers/media/platform/qcom/venus/vdec.c           |   1 +
 drivers/media/platform/qcom/venus/venc.c           |   1 +
 drivers/media/platform/rcar_fdp1.c                 |   1 +
 drivers/media/platform/rcar_jpu.c                  |   4 +-
 drivers/media/platform/rockchip/rga/rga-buf.c      |   1 +
 drivers/media/platform/s3c-camif/camif-capture.c   |   3 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   4 +-
 drivers/media/platform/sh_veu.c                    |   4 +-
 drivers/media/platform/sh_vou.c                    |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   4 +-
 drivers/media/platform/ti-vpe/cal.c                |   2 +-
 drivers/media/platform/ti-vpe/vpe.c                |   4 +-
 drivers/media/platform/vim2m.c                     |   4 +-
 drivers/media/platform/vivid/vivid-core.c          |   2 +-
 drivers/media/platform/vsp1/vsp1_histo.c           |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   7 +-
 drivers/media/usb/airspy/airspy.c                  |   2 +-
 drivers/media/usb/au0828/au0828-video.c            |   3 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   1 +
 drivers/media/usb/go7007/go7007-v4l2.c             |   2 +-
 drivers/media/usb/hackrf/hackrf.c                  |  12 +-
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |   2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   3 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   3 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   1 +
 drivers/media/v4l2-core/Kconfig                    |  33 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 include/media/videobuf2-core.h                     |  45 +++-
 include/media/videobuf2-v4l2.h                     |  10 +
 include/uapi/linux/videodev2.h                     |   9 +-
 75 files changed, 650 insertions(+), 105 deletions(-)

-- 
2.14.3
