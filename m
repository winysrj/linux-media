Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33118 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751914AbcISIRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 04:17:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id EC5D0180105
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2016 10:17:40 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] MediaTek video decoder and MDP drivers (v2)
Message-ID: <3e77f3f5-3aaa-9f83-a6c9-6de18e7612e4@xs4all.nl>
Date: Mon, 19 Sep 2016 10:17:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This adds the mediatek video decoder and MDP driver.

This patch series depends on a bunch of fixes that are currently pending for 4.8:

a21cb70 vcodec:mediatek: Refine VP8 encoder driver
84b313f vcodec:mediatek: Refine H264 encoder driver
55673f3 vcodec:mediatek: change H264 profile default to profile high
b321ac9 vcodec:mediatek: Add timestamp and timecode copy for V4L2 Encoder
b44d7f7 vcodec:mediatek: Fix visible_height larger than coded_height issue in s_fmt_out
d7500e9 vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
c9487c9 vcodec:mediatek:code refine for v4l2 Encoder driver

After these fixes the video decoder is added, then support for the opaque MT21C format
is added and finally the MDP driver is added that can handle the MT21C format.

Regards,

	Hans

Changes since v1:

Added these patches:
    mtk-mdp: fix double mutex_unlock
    pixfmt-reserved.rst: Improve MT21C documentation
    media: mtk-mdp: fix build error
    media: mtk-mdp: fix build warning in arch x86

These fix the two items remaining that I mentioned in the first pull request
and a smatch error (double unlock).

The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git mtkdec

for you to fetch changes up to 0cb0ca4bebb950ccb76afe06590eb4bcbe5c6143:

  mtk-mdp: fix double mutex_unlock (2016-09-19 10:01:17 +0200)

----------------------------------------------------------------
Andrew-CT Chen (1):
      VPU: mediatek: Add decode support

Colin Ian King (1):
      VPU: mediatek: fix null pointer dereference on pdev

Hans Verkuil (2):
      pixfmt-reserved.rst: Improve MT21C documentation
      mtk-mdp: fix double mutex_unlock

Julia Lawall (1):
      vcodec: mediatek: fix odd_ptr_err.cocci warnings

Minghsiu Tsai (8):
      VPU: mediatek: Add mdp support
      dt-bindings: Add a binding for Mediatek MDP
      media: Add Mediatek MDP Driver
      arm64: dts: mediatek: Add MDP for MT8173
      media: mtk-mdp: support pixelformat V4L2_PIX_FMT_MT21C
      media: mtk-mdp: add Maintainers entry for Mediatek MDP driver
      media: mtk-mdp: fix build warning in arch x86
      media: mtk-mdp: fix build error

Tiffany Lin (18):
      vcodec:mediatek:code refine for v4l2 Encoder driver
      vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
      vcodec:mediatek: Fix visible_height larger than coded_height issue in s_fmt_out
      vcodec:mediatek: Add timestamp and timecode copy for V4L2 Encoder
      vcodec:mediatek: change H264 profile default to profile high
      vcodec:mediatek: Refine H264 encoder driver
      vcodec:mediatek: Refine VP8 encoder driver
      dt-bindings: Add a binding for Mediatek Video Decoder
      vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver
      vcodec: mediatek: Add Mediatek H264 Video Decoder Drive
      vcodec: mediatek: Add Mediatek VP8 Video Decoder Driver
      Add documentation for V4L2_PIX_FMT_VP9.
      vcodec: mediatek: Add Mediatek VP9 Video Decoder Driver
      vcodec: mediatek: add Maintainers entry for Mediatek MT8173 vcodec drivers
      v4l: add Mediatek compressed video block format
      docs-rst: Add compressed video formats used on MT8173 codec driver
      vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
      arm64: dts: mediatek: Add Video Decoder for MT8173

Wu-Cheng Li (2):
      videodev2.h: add V4L2_PIX_FMT_VP9 format.
      v4l2-ioctl: add VP9 format description.

 Documentation/devicetree/bindings/media/mediatek-mdp.txt    |  109 +++
 Documentation/devicetree/bindings/media/mediatek-vcodec.txt |   57 +-
 Documentation/media/uapi/v4l/pixfmt-013.rst                 |    8 +
 Documentation/media/uapi/v4l/pixfmt-reserved.rst            |   10 +
 MAINTAINERS                                                 |   18 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                    |  128 ++++
 drivers/media/platform/Kconfig                              |   17 +
 drivers/media/platform/Makefile                             |    2 +
 drivers/media/platform/mtk-mdp/Makefile                     |    9 +
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c               |  159 +++++
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h               |   72 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c               |  294 ++++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_core.h               |  260 +++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h                |  126 ++++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                | 1279 ++++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h                |   22 +
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c               |  156 +++++
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h               |   31 +
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c                |  145 ++++
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h                |   41 ++
 drivers/media/platform/mtk-vcodec/Makefile                  |   15 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c          | 1447 +++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h          |   88 +++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c      |  394 +++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c       |  204 ++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h       |   28 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h          |   61 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c          |   42 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c      |    2 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c         |    3 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h         |    1 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c         |   33 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h         |    5 +
 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c       |  507 ++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c        |  634 +++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c        |  967 ++++++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_base.h           |   56 ++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c             |  122 ++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h             |  101 +++
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h            |  103 +++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c             |  170 +++++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h             |   96 +++
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c       |   16 +-
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c        |   16 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c                    |   19 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.h                    |   32 +
 drivers/media/v4l2-core/v4l2-ioctl.c                        |    2 +
 include/uapi/linux/videodev2.h                              |    2 +
 48 files changed, 8052 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
 create mode 100644 drivers/media/platform/mtk-mdp/Makefile
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
