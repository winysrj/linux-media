Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47308 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFWXx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:53:58 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 00/23] Renesas VSP1: alpha support and miscellaneous fixes
Date: Tue, 24 Jun 2014 01:54:06 +0200
Message-Id: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds alpha support to the Renesas VSP1 driver. The feature is
split in two parts, support for the alpha component in capture and output
buffers, and support for premultiplied colors. Each part requires extensions
to the V4L API.

The first two patches add new pixel formats for alpha and non-alpha RGB, and
extend usage of the ALPHA_COMPONENT control to output devices. They have
already been posted separately, for the rationale please see
https://www.mail-archive.com/linux-media@vger.kernel.org/msg75449.html.

The next two patches add a premultiplied alpha flag to the V4L format API.
This requires extending the v4l2_pix_format structure first (patch 03/18).

Patch 05/23 fixes a stream condition in videobuf2. It could be merged
separately.

Patches 06/23 to 16/23 perform general cleanups and fixes to the VSP1 driver.
Please see individual patches for details. Patch 06/23, in particular, fixes
a bug introduced in v3.16-rc1, so I'll resubmit it separately for v3.16.

Patch 17/23 switches from the old RGB formats to the new XRGB formats. Patch
18/23 then adds support for ARGB formats, and patch 19/23 support for the
alpha component control. Patch 20/23 and 21/23 add support for premultiplied
colors, and patch 22/23 makes the blending unit background color configurable.

Patch 23/23 finally fixes scaler (UDS) configuration when the alpha layer
needs to be scaled.

I While I'd of course like to see the VSP1 patches getting reviewed, I expect
most of the discussions to concentrate on the first four patches. Several
rounds will likely be needed, and I'd like to get the series in v3.17, so
let's get started.

Changes since v1:

- Fixed a typo in 15/23
- Added 05/23 to 07/23 and 23/23

Laurent Pinchart (23):
  v4l: Add ARGB and XRGB pixel formats
  DocBook: media: Document ALPHA_COMPONENT control usage on output
    devices
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

 Documentation/DocBook/media/Makefile               |   2 +-
 Documentation/DocBook/media/v4l/controls.xml       |  17 +-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 ++++++++++++++++++++-
 Documentation/DocBook/media/v4l/pixfmt.xml         |  53 ++-
 Documentation/DocBook/media/v4l/v4l2.xml           |   8 +
 .../DocBook/media/v4l/vidioc-querycap.xml          |   6 +
 drivers/media/parport/bw-qcam.c                    |   2 -
 drivers/media/pci/cx18/cx18-ioctl.c                |   1 -
 drivers/media/pci/cx25821/cx25821-video.c          |   3 -
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   3 -
 drivers/media/pci/meye/meye.c                      |   2 -
 drivers/media/pci/saa7134/saa7134-empress.c        |   3 -
 drivers/media/pci/saa7134/saa7134-video.c          |   2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   1 -
 drivers/media/platform/coda.c                      |   2 -
 drivers/media/platform/davinci/vpif_display.c      |   1 -
 drivers/media/platform/mem2mem_testdev.c           |   1 -
 drivers/media/platform/omap/omap_vout.c            |   2 -
 drivers/media/platform/sh_veu.c                    |   2 -
 drivers/media/platform/vino.c                      |   5 -
 drivers/media/platform/vivi.c                      |   1 -
 drivers/media/platform/vsp1/vsp1.h                 |  14 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |  85 ++++-
 drivers/media/platform/vsp1/vsp1_bru.h             |   9 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  22 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |  42 +++
 drivers/media/platform/vsp1/vsp1_entity.h          |  10 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   2 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |  72 +++-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   2 +
 drivers/media/platform/vsp1/vsp1_sru.c             | 107 ++++--
 drivers/media/platform/vsp1/vsp1_sru.h             |   1 -
 drivers/media/platform/vsp1/vsp1_uds.c             |  65 ++--
 drivers/media/platform/vsp1/vsp1_uds.h             |   6 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 217 ++++++++---
 drivers/media/platform/vsp1/vsp1_video.h           |  10 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |  72 +++-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 -
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 -
 drivers/media/usb/gspca/gspca.c                    |   8 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   1 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |   2 -
 drivers/media/usb/tlg2300/pd-video.c               |   1 -
 drivers/media/usb/tm6000/tm6000-video.c            |   2 -
 drivers/media/usb/zr364xx/zr364xx.c                |   3 -
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  66 +++-
 drivers/media/v4l2-core/videobuf2-core.c           |   4 +-
 include/uapi/linux/videodev2.h                     |  31 +-
 49 files changed, 1139 insertions(+), 270 deletions(-)

-- 
Regards,

Laurent Pinchart

