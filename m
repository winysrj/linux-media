Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51190 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbbJ2E0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 00:26:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jh1009.sung@samsung.com
Subject: [PATCH 0/2] vb2: modify VIDIOC_CREATE_BUFS format handling
Date: Thu, 29 Oct 2015 05:24:24 +0100
Message-Id: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the Seoul media workshop earlier this week we decided to change the
way the VIDIOC_CREATE_BUFS ioctl handles the format field.

The spec specified that this field was validated by the driver, but the
reality is that that never happened. Instead drivers would just take the
sizeimage field and use that as the new buffer size with little or no
other validation taking place.

This patch series changes the documentation and code so the vb2 framework
would extract the requested number of planes and plane sizes from the
format field and pass that on to the core. The only thing drivers need
to validate is whether the number of planes and plane sizes are valid.

This greatly simplifies the code and how the ioctl is to be used. Drivers
are now also consistent in how they handle this ioctl.

For the vb2 core this means that the void pointer is now dropped. Instead,
drivers will check the *num_planes field: if it is 0, then it should ignore
any requested sizes, otherwise it contains the requested number of planes
and the sizes array contains the requested size per plane.

I expect that this is also much more useful for DVB where you want to specify
the size as well.

Regards,

        Hans


Hans Verkuil (2):
  vb2: drop v4l2_format argument from queue_setup
  DocBook media: update VIDIOC_CREATE_BUFS documentation

 .../DocBook/media/v4l/vidioc-create-bufs.xml       | 30 ++++++-------
 Documentation/video4linux/v4l2-pci-skeleton.c      | 10 ++---
 drivers/input/touchscreen/sur40.c                  | 11 +++--
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 12 ++---
 drivers/media/pci/cx23885/cx23885-417.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c          | 12 ++---
 drivers/media/pci/cx88/cx88-blackbird.c            |  2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |  2 +-
 drivers/media/pci/cx88/cx88-video.c                |  2 +-
 drivers/media/pci/dt3155/dt3155.c                  | 11 +++--
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  1 -
 drivers/media/pci/saa7134/saa7134-ts.c             |  2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
 drivers/media/pci/saa7134/saa7134.h                |  2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |  1 -
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
 drivers/media/pci/tw68/tw68-video.c                | 20 ++++-----
 drivers/media/platform/am437x/am437x-vpfe.c        | 17 ++++----
 drivers/media/platform/blackfin/bfin_capture.c     | 12 +++--
 drivers/media/platform/coda/coda-common.c          |  2 +-
 drivers/media/platform/davinci/vpbe_display.c      | 13 +++---
 drivers/media/platform/davinci/vpif_capture.c      | 17 ++++----
 drivers/media/platform/davinci/vpif_display.c      | 13 +++---
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  1 -
 drivers/media/platform/exynos4-is/fimc-capture.c   | 31 +++++++------
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 31 ++++++-------
 drivers/media/platform/exynos4-is/fimc-lite.c      | 31 ++++++-------
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/m2m-deinterlace.c           |  1 -
 drivers/media/platform/marvell-ccic/mcam-core.c    | 13 +++---
 drivers/media/platform/mx2_emmaprp.c               |  1 -
 drivers/media/platform/omap3isp/ispvideo.c         |  1 -
 drivers/media/platform/rcar_jpu.c                  | 25 ++++++-----
 drivers/media/platform/s3c-camif/camif-capture.c   | 33 +++++---------
 drivers/media/platform/s5p-g2d/g2d.c               |  2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  1 -
 drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
 drivers/media/platform/sh_veu.c                    | 31 ++++---------
 drivers/media/platform/sh_vou.c                    | 11 +++--
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  6 ---
 drivers/media/platform/soc_camera/mx3_camera.c     | 38 +++-------------
 drivers/media/platform/soc_camera/rcar_vin.c       | 40 +++--------------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 37 +++-------------
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 10 ++---
 drivers/media/platform/ti-vpe/vpe.c                |  1 -
 drivers/media/platform/vim2m.c                     | 13 ++----
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       | 22 +++-------
 drivers/media/platform/vivid/vivid-vid-out.c       | 19 ++------
 drivers/media/platform/vsp1/vsp1_video.c           | 51 +++++-----------------
 drivers/media/platform/xilinx/xilinx-dma.c         | 12 +++--
 drivers/media/usb/airspy/airspy.c                  |  2 +-
 drivers/media/usb/au0828/au0828-vbi.c              | 14 ++----
 drivers/media/usb/au0828/au0828-video.c            | 12 ++---
 drivers/media/usb/em28xx/em28xx-vbi.c              | 20 ++++-----
 drivers/media/usb/em28xx/em28xx-video.c            | 19 ++------
 drivers/media/usb/go7007/go7007-v4l2.c             |  1 -
 drivers/media/usb/hackrf/hackrf.c                  |  2 +-
 drivers/media/usb/msi2500/msi2500.c                |  1 -
 drivers/media/usb/pwc/pwc-if.c                     |  2 +-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  9 ++--
 drivers/media/usb/uvc/uvc_queue.c                  | 14 +++---
 drivers/media/v4l2-core/videobuf2-core.c           | 23 +++++++---
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 48 +++++++++++++++++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  1 -
 drivers/usb/gadget/function/uvc_queue.c            |  2 +-
 include/media/videobuf2-core.h                     | 40 +++++++++--------
 82 files changed, 370 insertions(+), 535 deletions(-)

-- 
2.1.4

