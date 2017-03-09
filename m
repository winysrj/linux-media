Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46761 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754086AbdCIOBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 09:01:22 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Miscellaneous fixes
Message-ID: <4f2ed1f0-9b8a-fc7d-cb7f-4387d56acede@xs4all.nl>
Date: Thu, 9 Mar 2017 15:00:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All small stuff.

Regards,

	Hans

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12c

for you to fetch changes up to 2ce2b17a058d6c48f752257a6aa88574822c1f71:

  solo6x10: release vb2 buffers in solo_stop_streaming() (2017-03-09 14:59:00 +0100)

----------------------------------------------------------------
Anton Sviridenko (1):
      solo6x10: release vb2 buffers in solo_stop_streaming()

Bartosz Golaszewski (3):
      media: vpif: use a configurable i2c_adapter_id for vpif display
      media: dt-bindings: vpif: fix whitespace errors
      media: dt-bindings: vpif: extend the example with an output port

Fengguang Wu (1):
      vcodec: mediatek: fix platform_no_drv_owner.cocci warnings

Frank Schaefer (2):
      em28xx: reduce stack usage in sensor probing functions
      em28xx: simplify ID-reading from Micron sensors

Javier Martinez Canillas (2):
      si4713: Add OF device ID table
      soc-camera: ov5642: Add OF device ID table

Laurent Pinchart (1):
      v4l: soc-camera: Remove videobuf1 support

Randy Dunlap (1):
      media/platform/mtk-jpeg: add slab.h to fix build errors

Sakari Ailus (1):
      docs-rst: media: Push CEC documentation under CEC section

Wei Yongjun (1):
      mtk-vcodec: remove redundant return value check of platform_get_resource()

Wu-Cheng Li (1):
      mtk-vcodec: check the vp9 decoder buffer index from VPU.

 Documentation/devicetree/bindings/media/ti,da850-vpif.txt |  50 ++++++++++++++++------
 Documentation/media/kapi/cec-core.rst                     |   7 +--
 arch/arm/mach-davinci/board-da850-evm.c                   |   1 +
 drivers/media/i2c/soc_camera/ov5642.c                     |   9 ++++
 drivers/media/pci/solo6x10/solo6x10-v4l2.c                |  11 +++++
 drivers/media/platform/davinci/vpif_display.c             |   2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c           |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c        |  33 ++++++++++++---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h        |   2 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c    |   5 ---
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c      |  26 ++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h           |   2 +
 drivers/media/platform/soc_camera/Kconfig                 |   1 -
 drivers/media/platform/soc_camera/soc_camera.c            | 103 +++++++++------------------------------------
 drivers/media/radio/si4713/si4713.c                       |   9 ++++
 drivers/media/usb/em28xx/em28xx-camera.c                  |  58 ++++++++-----------------
 include/media/davinci/vpif_types.h                        |   1 +
 include/media/soc_camera.h                                |  14 +-----
 18 files changed, 166 insertions(+), 170 deletions(-)
