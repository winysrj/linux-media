Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:58070 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1033088AbeBOPPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 10:15:47 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Various fixes/improvements
Message-ID: <9aa06912-c387-fc97-f7cf-a661dc930715@xs4all.nl>
Date: Thu, 15 Feb 2018 16:15:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes/improvements all over the place.

Finally had time to clean out most of the random patches in my queue :-)

Regards,

	Hans

The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17a

for you to fetch changes up to 262f1f7863999b92165ab1bb9fe0f148cfc826fb:

  media: i2c: adv748x: fix HDMI field heights (2018-02-15 16:04:12 +0100)

----------------------------------------------------------------
Alexandre Courbot (2):
      v4l: vidioc-prepare-buf.rst: fix link to VIDIOC_QBUF
      media: v4l2_fh.h: add missing kconfig.h include

Antonio Cardace (2):
      em28xx: use %*phC to print small buffers
      gspca: dtcs033: use %*ph to print small buffer

Arnd Bergmann (1):
      media: au0828: fix VIDEO_V4L2 dependency

Benjamin Gaignard (1):
      media: platform: stm32: Adopt SPDX identifier

Christopher Díaz Riveros (1):
      media: s2255drv: Remove unneeded if else blocks

Colin Ian King (1):
      media: cx25821: prevent out-of-bounds read on array card

Corentin Labbe (2):
      media: cx18: remove unused cx18-alsa-mixer
      media: ivtv: remove ivtv-alsa-mixer

Gustavo A. R. Silva (9):
      venus: hfi: use true for boolean values
      staging: imx-media-vdic: fix inconsistent IS_ERR and PTR_ERR
      rtl2832: use 64-bit arithmetic instead of 32-bit in rtl2832_set_frontend
      dvb-frontends: ves1820: use 64-bit arithmetic instead of 32-bit
      i2c: max2175: use 64-bit arithmetic instead of 32-bit
      pci: cx88-input: use 64-bit arithmetic instead of 32-bit
      rockchip/rga: use 64-bit arithmetic instead of 32-bit
      platform: sh_veu: use 64-bit arithmetic instead of 32-bit
      platform: vivid-cec: use 64-bit arithmetic instead of 32-bit

Gustavo Padovan (1):
      buffer.rst: fix link text of VIDIOC_QBUF

Hans Verkuil (4):
      vivid: fix incorrect capabilities for radio
      v4l2-ctrls.h: fix wrong copy-and-paste comment
      cec: improve debugging
      vivid: check if the cec_adapter is valid

Ian Douglas Scott (1):
      media: usbtv: Add USB ID 1f71:3306 to the UTV007 driver

Kieran Bingham (2):
      v4l: doc: Clarify v4l2_mbus_fmt height definition
      media: i2c: adv748x: fix HDMI field heights

Masami Hiramatsu (1):
      media: vb2: Fix videobuf2 to map correct area

Niklas Söderlund (1):
      v4l2-dev.h: fix symbol collision in media_entity_to_video_device()

Oliver Neukum (1):
      media: usbtv: prevent double free in error case

Philipp Zabel (4):
      media: dt-bindings: coda: Add compatible for CodaHx4 on i.MX51
      media: coda: Add i.MX51 (CodaHx4) support
      media: imx: allow to build with COMPILE_TEST
      media: coda: bump maximum number of internal framebuffers to 19

Sakari Ailus (1):
      vb2: core: Finish buffers at the end of the stream

Shuah Khan (1):
      media: v4l2-core: v4l2-mc: Add SPDX license identifier

Tomasz Figa (1):
      media: mtk-vcodec: Always signal source change event on format change

Wei Yongjun (2):
      media: atmel-isc: Make local symbol fmt_configs_list static
      media: rcar_drif: fix error return code in rcar_drif_alloc_dmachannels()

Xiongfeng Wang (1):
      media: media-device: use strlcpy() instead of strncpy()

 Documentation/devicetree/bindings/media/coda.txt    |   5 +-
 Documentation/media/uapi/v4l/buffer.rst             |   2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst     |   8 ++-
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst |   2 +-
 drivers/media/cec/cec-adap.c                        |  32 +++++-----
 drivers/media/common/videobuf2/videobuf2-core.c     |   9 +++
 drivers/media/common/videobuf2/videobuf2-vmalloc.c  |   2 +-
 drivers/media/dvb-frontends/rtl2832.c               |   4 +-
 drivers/media/dvb-frontends/ves1820.c               |   2 +-
 drivers/media/i2c/adv748x/adv748x-hdmi.c            |   3 +
 drivers/media/i2c/max2175.c                         |   2 +-
 drivers/media/media-device.c                        |   2 +-
 drivers/media/pci/cx18/cx18-alsa-main.c             |   1 -
 drivers/media/pci/cx18/cx18-alsa-mixer.c            | 170 ---------------------------------------------------
 drivers/media/pci/cx18/cx18-alsa-mixer.h            |  18 ------
 drivers/media/pci/cx25821/cx25821-core.c            |   7 ++-
 drivers/media/pci/cx88/cx88-input.c                 |   4 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c             |  11 +---
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c            | 165 -------------------------------------------------
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h            |  18 ------
 drivers/media/platform/atmel/atmel-isc.c            |   2 +-
 drivers/media/platform/coda/coda-bit.c              |  46 ++++++++++----
 drivers/media/platform/coda/coda-common.c           |  44 +++++++++++--
 drivers/media/platform/coda/coda.h                  |   3 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c  |   2 +
 drivers/media/platform/qcom/venus/hfi_msgs.c        |   4 +-
 drivers/media/platform/rcar_drif.c                  |   3 +-
 drivers/media/platform/rockchip/rga/rga-buf.c       |   3 +-
 drivers/media/platform/sh_veu.c                     |   4 +-
 drivers/media/platform/stm32/stm32-cec.c            |   5 +-
 drivers/media/platform/stm32/stm32-dcmi.c           |   2 +-
 drivers/media/platform/vivid/vivid-cec.c            |  11 +++-
 drivers/media/platform/vivid/vivid-ctrls.c          |   2 +
 drivers/media/platform/vivid/vivid-vid-common.c     |   3 +-
 drivers/media/usb/au0828/Kconfig                    |   5 +-
 drivers/media/usb/em28xx/em28xx-i2c.c               |   8 +--
 drivers/media/usb/gspca/dtcs033.c                   |   6 +-
 drivers/media/usb/s2255/s2255drv.c                  |   8 ---
 drivers/media/usb/usbtv/usbtv-core.c                |   3 +
 drivers/media/v4l2-core/v4l2-mc.c                   |  12 +---
 drivers/staging/media/imx/Kconfig                   |   3 +-
 drivers/staging/media/imx/imx-media-vdic.c          |   2 +-
 include/media/v4l2-ctrls.h                          |   4 +-
 include/media/v4l2-dev.h                            |   6 +-
 include/media/v4l2-fh.h                             |   1 +
 include/uapi/linux/v4l2-mediabus.h                  |   4 +-
 46 files changed, 180 insertions(+), 483 deletions(-)
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.c
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.h
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.c
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.h
