Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40842 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbcEDHkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 03:40:09 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Add support for MT8173 video encoder
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
Message-ID: <5729A753.7090402@xs4all.nl>
Date: Wed, 4 May 2016 09:40:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From the cover letter of the patch series (https://lkml.org/lkml/2016/5/3/279):

The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
Mediatek Video Codec is able to handle video encoding of in a range of formats.

This patch series also include VPU driver. Mediatek Video Codec driver rely on VPU driver to load,
communicate with VPU.

Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
This patch series need [PATCH v15 8/8] memory: mtk-smi: export mtk_smi_larb_get/put[1] to build as module

[1]http://lists.infradead.org/pipermail/linux-mediatek/2016-April/005173.html

Mauro, please note this dependency, so if this is in time to get merged for 4.7, then
the pull request for this has to wait until that mtk-smi patch is merged first.

Regards,

	Hans


The following changes since commit 68af062b5f38510dc96635314461c6bbe1dbf2fe:

  Merge tag 'v4.6-rc6' into patchwork (2016-05-02 07:48:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git mtenc

for you to fetch changes up to 7aebdc45d79743eedddbfd2a7d488ff1f6ee93b9:

  arm64: dts: mediatek: Add Video Encoder for MT8173 (2016-05-04 09:33:50 +0200)

----------------------------------------------------------------
Andrew-CT Chen (3):
      dt-bindings: Add a binding for Mediatek Video Processor
      VPU: mediatek: support Mediatek VPU
      arm64: dts: mediatek: Add node for Mediatek Video Processor Unit

Tiffany Lin (5):
      dt-bindings: Add a binding for Mediatek Video Encoder
      vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver
      vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
      vcodec: mediatek: Add Mediatek H264 Video Encoder Driver
      arm64: dts: mediatek: Add Video Encoder for MT8173

 Documentation/devicetree/bindings/media/mediatek-vcodec.txt |   59 +++
 Documentation/devicetree/bindings/media/mediatek-vpu.txt    |   31 ++
 arch/arm64/boot/dts/mediatek/mt8173.dtsi                    |   62 +++
 drivers/media/platform/Kconfig                              |   30 ++
 drivers/media/platform/Makefile                             |    4 +
 drivers/media/platform/mtk-vcodec/Makefile                  |   19 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h          |  338 ++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c          | 1288 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h          |   58 +++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c      |  454 ++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c       |  137 +++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h       |   26 ++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c         |   54 +++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h         |   27 ++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c         |   94 +++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h         |   87 +++++
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c       |  679 ++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c        |  481 +++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/venc_drv_base.h           |   62 +++
 drivers/media/platform/mtk-vcodec/venc_drv_if.c             |  113 ++++++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h             |  163 ++++++++
 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h            |  210 ++++++++++
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c             |  237 ++++++++++++
 drivers/media/platform/mtk-vcodec/venc_vpu_if.h             |   61 +++
 drivers/media/platform/mtk-vpu/Makefile                     |    3 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c                    |  950 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu.h                    |  162 ++++++++
 27 files changed, 5889 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.h
 create mode 100644 drivers/media/platform/mtk-vpu/Makefile
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
