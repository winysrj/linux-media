Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42607 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752173AbdHNNJz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 09:09:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] constify patches
Message-ID: <6cc23f7c-d2c1-9344-ebb8-1ae3cd88061e@xs4all.nl>
Date: Mon, 14 Aug 2017 15:09:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14g

for you to fetch changes up to 4dc5ba647aa4ee895fc4b905cace9e9a15fa037b:

  pxa_camera: constify v4l2_clk_ops structure (2017-08-14 14:58:42 +0200)

----------------------------------------------------------------
Arvind Yadav (2):
      usb: constify usb_device_id
      radio: constify usb_device_id

Bhumika Goyal (3):
      usb: make snd_pcm_hardware const
      pci: make snd_pcm_hardware const
      tuners: make snd_pcm_hardware const

Julia Lawall (21):
      v4l2-pci-skeleton: constify vb2_ops structures
      media: davinci: vpbe: constify vb2_ops structures
      staging: media: davinci_vpfe: constify vb2_ops structures
      media: blackfin: bfin_capture: constify vb2_ops structures
      media: imx: capture: constify vb2_ops structures
      st-delta: constify v4l2_m2m_ops structures
      media: ti-vpe: vpe: constify v4l2_m2m_ops structures
      s5p-g2d: constify v4l2_m2m_ops structures
      V4L2: platform: rcar_jpu: constify v4l2_m2m_ops structures
      vcodec: mediatek: constify v4l2_m2m_ops structures
      exynos-gsc: constify v4l2_m2m_ops structures
      bdisp: constify v4l2_m2m_ops structures
      m2m-deinterlace: constify v4l2_m2m_ops structures
      media: mx2-emmaprp: constify v4l2_m2m_ops structures
      vim2m: constify v4l2_m2m_ops structures
      exynos4-is: constify v4l2_m2m_ops structures
      mtk-mdp: constify v4l2_m2m_ops structures
      vimc: constify video_subdev structures
      exynos4-is: constify video_subdev structures
      v4l2: av7110_v4l: constify v4l2_audio structure
      pxa_camera: constify v4l2_clk_ops structure

 drivers/media/pci/cobalt/cobalt-alsa-pcm.c        | 4 ++--
 drivers/media/pci/cx18/cx18-alsa-pcm.c            | 2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c          | 2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c          | 2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c            | 2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c          | 2 +-
 drivers/media/pci/ttpci/av7110_v4l.c              | 2 +-
 drivers/media/platform/blackfin/bfin_capture.c    | 2 +-
 drivers/media/platform/davinci/vpbe_display.c     | 2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c       | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c      | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     | 2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c      | 2 +-
 drivers/media/platform/m2m-deinterlace.c          | 2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c   | 2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c      | 2 +-
 drivers/media/platform/mx2_emmaprp.c              | 2 +-
 drivers/media/platform/pxa_camera.c               | 2 +-
 drivers/media/platform/rcar_jpu.c                 | 2 +-
 drivers/media/platform/s5p-g2d/g2d.c              | 2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c     | 2 +-
 drivers/media/platform/sti/delta/delta-v4l2.c     | 2 +-
 drivers/media/platform/ti-vpe/vpe.c               | 2 +-
 drivers/media/platform/vim2m.c                    | 2 +-
 drivers/media/platform/vimc/vimc-debayer.c        | 2 +-
 drivers/media/platform/vimc/vimc-scaler.c         | 2 +-
 drivers/media/platform/vimc/vimc-sensor.c         | 2 +-
 drivers/media/radio/dsbr100.c                     | 2 +-
 drivers/media/radio/radio-keene.c                 | 2 +-
 drivers/media/radio/radio-ma901.c                 | 2 +-
 drivers/media/radio/radio-mr800.c                 | 2 +-
 drivers/media/radio/radio-raremono.c              | 2 +-
 drivers/media/radio/radio-shark.c                 | 2 +-
 drivers/media/radio/radio-shark2.c                | 2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c     | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c     | 2 +-
 drivers/media/tuners/tda18271-maps.c              | 4 ++--
 drivers/media/usb/airspy/airspy.c                 | 2 +-
 drivers/media/usb/as102/as102_usb_drv.c           | 2 +-
 drivers/media/usb/b2c2/flexcop-usb.c              | 2 +-
 drivers/media/usb/cpia2/cpia2_usb.c               | 2 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c         | 2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c             | 2 +-
 drivers/media/usb/em28xx/em28xx-audio.c           | 2 +-
 drivers/media/usb/go7007/snd-go7007.c             | 2 +-
 drivers/media/usb/hackrf/hackrf.c                 | 2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c              | 2 +-
 drivers/media/usb/msi2500/msi2500.c               | 2 +-
 drivers/media/usb/s2255/s2255drv.c                | 2 +-
 drivers/media/usb/stk1160/stk1160-core.c          | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c          | 2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c            | 2 +-
 drivers/media/usb/tm6000/tm6000-cards.c           | 2 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c           | 2 +-
 drivers/media/usb/usbtv/usbtv-audio.c             | 2 +-
 drivers/media/usb/usbtv/usbtv-core.c              | 2 +-
 drivers/media/usb/uvc/uvc_driver.c                | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c               | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c   | 2 +-
 drivers/staging/media/imx/imx-media-capture.c     | 4 ++--
 samples/v4l/v4l2-pci-skeleton.c                   | 2 +-
 62 files changed, 65 insertions(+), 65 deletions(-)
