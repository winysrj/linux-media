Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43090 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbeHAWzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 18:55:05 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/3] Add Rockchip VPU JPEG encoder
Date: Wed,  1 Aug 2018 18:07:11 -0300
Message-Id: <20180801210714.1620-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for JPEG encoding via the VPU block
present in Rockchip platforms. Currently, support for RK3288
and RK3399 is included.

The hardware produces a Raw JPEG format (i.e. works as a
JPEG accelerator). It requires quantization tables provided
by the application, and uses standard huffman tables,
as recommended by the JPEG specification.

In order to support this, the series introduces a new pixel format,
and a new pair of controls, V4L2_CID_JPEG_{LUMA,CHROMA}_QUANTIZATION
allowing userspace to specify the quantization tables.

Userspace is then responsible to add the required headers
and tables to the produced raw payload, to produce a JPEG image.

Compliance
==========

# v4l2-compliance -d 0 -s

Ezequiel Garcia (1):
  media: add Rockchip VPU driver

Shunqian Zheng (2):
  media: Add JPEG_RAW format
  media: Add controls for jpeg quantization tables

 .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
 drivers/media/platform/Kconfig                |  12 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/rockchip/vpu/Makefile  |   8 +
 .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 127 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 156 ++++
 .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 ++++++++++
 .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 127 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 165 ++++
 .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 ++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu.h      | 270 +++++++
 .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 416 ++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 763 ++++++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
 .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++
 drivers/media/v4l2-core/v4l2-ctrls.c          |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 include/uapi/linux/v4l2-controls.h            |   3 +
 include/uapi/linux/videodev2.h                |   1 +
 19 files changed, 3194 insertions(+)
 create mode 100644 drivers/media/platform/rockchip/vpu/Makefile
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h

-- 
2.18.0.rc2
