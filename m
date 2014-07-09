Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38294 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGIJ3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 05:29:30 -0400
Received: from avalon.localnet (unknown [91.178.202.111])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 175EB359F9
	for <linux-media@vger.kernel.org>; Wed,  9 Jul 2014 11:28:33 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] VSP1 transparency support
Date: Wed, 09 Jul 2014 11:30:31 +0200
Message-ID: <13641888.9oDx3NLO1G@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/fbdev.git vsp1/upstream

for you to fetch changes up to b44f3aa857f13c75ead85e6f2597024b259eabcc:

  v4l: vsp1: uds: Fix scaling of alpha layer (2014-07-09 11:23:46 +0200)

----------------------------------------------------------------
Laurent Pinchart (23):
      v4l: Add ARGB and XRGB pixel formats
      DocBook: media: Document ALPHA_COMPONENT control usage on output devices
      v4l: Support extending the v4l2_pix_format structure
      v4l: Add premultiplied alpha flag for pixel formats
      v4l: vb2: Fix stream start and buffer completion race
      v4l: vsp1: Fix routing cleanup when stopping the stream
      v4l: vsp1: Release buffers at stream stop
      v4l: vsp1: Fix pipeline stop timeout
      v4l: vsp1: Fix typos
      v4l: vsp1: Cleanup video nodes at removal time
      v4l: vsp1: Propagate vsp1_device_get errors to the callers
      v4l: vsp1: Setup control handler automatically at stream on time
      v4l: vsp1: sru: Fix the intensity control default value
      v4l: vsp1: sru: Make the intensity controllable during streaming
      v4l: vsp1: wpf: Simplify cast to pipeline structure
      v4l: vsp1: wpf: Clear RPF to WPF association at stream off time
      v4l: vsp1: Switch to XRGB formats
      v4l: vsp1: Add alpha channel support to the memory ports
      v4l: vsp1: Add V4L2_CID_ALPHA_COMPONENT control support
      v4l: vsp1: bru: Support premultiplied alpha at the BRU inputs
      v4l: vsp1: bru: Support non-premultiplied colors at the BRU output
      v4l: vsp1: bru: Make the background color configurable
      v4l: vsp1: uds: Fix scaling of alpha layer

 Documentation/DocBook/media/Makefile                  |   2 +-
 Documentation/DocBook/media/v4l/controls.xml          |  17 +-
 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 415 
++++++++++++++++++++++++--
 Documentation/DocBook/media/v4l/pixfmt.xml            |  56 +++-
 Documentation/DocBook/media/v4l/v4l2.xml              |   8 +
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml     |  12 +-
 Documentation/DocBook/media/v4l/vidioc-querycap.xml   |   6 +
 drivers/media/parport/bw-qcam.c                       |   2 -
 drivers/media/pci/cx18/cx18-ioctl.c                   |   1 -
 drivers/media/pci/cx25821/cx25821-video.c             |   3 -
 drivers/media/pci/ivtv/ivtv-ioctl.c                   |   3 -
 drivers/media/pci/meye/meye.c                         |   2 -
 drivers/media/pci/saa7134/saa7134-empress.c           |   3 -
 drivers/media/pci/saa7134/saa7134-video.c             |   2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c               |   1 -
 drivers/media/platform/coda.c                         |   2 -
 drivers/media/platform/davinci/vpif_display.c         |   1 -
 drivers/media/platform/mem2mem_testdev.c              |   1 -
 drivers/media/platform/omap/omap_vout.c               |   2 -
 drivers/media/platform/sh_veu.c                       |   2 -
 drivers/media/platform/vino.c                         |   5 -
 drivers/media/platform/vivi.c                         |   1 -
 drivers/media/platform/vsp1/vsp1.h                    |  14 +-
 drivers/media/platform/vsp1/vsp1_bru.c                |  85 +++++-
 drivers/media/platform/vsp1/vsp1_bru.h                |   9 +-
 drivers/media/platform/vsp1/vsp1_drv.c                |  22 +-
 drivers/media/platform/vsp1/vsp1_entity.c             |  42 +++
 drivers/media/platform/vsp1/vsp1_entity.h             |  10 +
 drivers/media/platform/vsp1/vsp1_regs.h               |   2 +
 drivers/media/platform/vsp1/vsp1_rpf.c                |  72 ++++-
 drivers/media/platform/vsp1/vsp1_rwpf.h               |   2 +
 drivers/media/platform/vsp1/vsp1_sru.c                | 107 ++++---
 drivers/media/platform/vsp1/vsp1_sru.h                |   1 -
 drivers/media/platform/vsp1/vsp1_uds.c                |  63 ++--
 drivers/media/platform/vsp1/vsp1_uds.h                |   6 +-
 drivers/media/platform/vsp1/vsp1_video.c              | 217 ++++++++++----
 drivers/media/platform/vsp1/vsp1_video.h              |  10 +-
 drivers/media/platform/vsp1/vsp1_wpf.c                |  72 ++++-
 drivers/media/usb/cx231xx/cx231xx-417.c               |   2 -
 drivers/media/usb/cx231xx/cx231xx-video.c             |   2 -
 drivers/media/usb/gspca/gspca.c                       |   8 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                 |   1 -
 drivers/media/usb/stkwebcam/stk-webcam.c              |   2 -
 drivers/media/usb/tlg2300/pd-video.c                  |   1 -
 drivers/media/usb/tm6000/tm6000-video.c               |   2 -
 drivers/media/usb/zr364xx/zr364xx.c                   |   3 -
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |  19 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                  |  70 ++++-
 drivers/media/v4l2-core/videobuf2-core.c              |   4 +-
 include/uapi/linux/videodev2.h                        |  31 +-
 50 files changed, 1148 insertions(+), 278 deletions(-)

-- 
Regards,

Laurent Pinchart

