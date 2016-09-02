Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:1051 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752693AbcIBMUP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 08:20:15 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
        <Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v5 0/9] Add MT8173 Video Decoder Driver
Date: Fri, 2 Sep 2016 20:19:51 +0800
Message-ID: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

==============
 Introduction
==============

The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
Mediatek Video Codec is able to handle video decoding and encoding of in a range of formats.

This patch series rely on MTK VPU driver that have been merged in v4.8-rc1.
Mediatek Video Decoder driver rely on VPU driver to load, communicate with VPU.

Internally the driver uses videobuf2 framework, and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.

[1]https://chromium-review.googlesource.com/#/c/245241/

==================
 Device interface
==================

In principle the driver bases on v4l2 memory-to-memory framework:
it provides a single video node and each opened file handle gets its own private context with separate buffer queues. Each context consist of 2 buffer 
queues: OUTPUT (for source buffers, i.e. bitstream) and CAPTURE (for destination buffers, i.e. decoded video frames).
OUTPUT and CAPTURE buffer could be MMAP or DMABUF memory type.

Change in v5:
1. Merge wucheng's V4L2_PIX_FMT_VP9 series to this series
   V4L: add VP9 format documentation
   v4l2-ioctl: add VP9 format description.
   videodev2.h: add V4L2_PIX_FMT_VP9 format.
2. Remove V4L2_PIX_FMT_MT21C to another series

Change in v4:
1.Change V4L2_PIX_FMT_MT21 to v4l2_PIX_FMT_MT21C
2.Fix g/s_selection implementation
3.Refine code according to review comments and pass V4l2-compliance test

-/bin/sh: v4l2: not found
# v4l2-compliance -d /dev/video0
v4l2-compliance SHA   : fc45cdc502065bc1dfb4ef9ceb9a822bb9877bce

Driver Info:
        Driver name   : mtk-vcodec-dec
        Card type     : platform:mt8173
        Bus info      : platform:mt8173
        Driver version: 4.8.0
        Capabilities  : 0x84204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 2 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0


Change in v3:
1. Refine vdec hw clock setting
2. Refine vp9 codec driver
3. Refine v4l2 codec driver

Change in v2:
1. Add documentation for V4L2_PIX_FMT_MT21 2. Remove DRM_FORMAT_MT21 2. Refine code according to review comments


Andrew-CT Chen (1):
  VPU: mediatek: Add decode support

Tiffany Lin (10):
  dt-bindings: Add a binding for Mediatek Video Decoder
  vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver
  vcodec: mediatek: Add Mediatek H264 Video Decoder Drive
  vcodec: mediatek: Add Mediatek VP8 Video Decoder Driver
  Add documentation for V4L2_PIX_FMT_VP9.
  vcodec: mediatek: Add Mediatek VP9 Video Decoder Driver
  v4l: add Mediatek compressed video block format
  docs-rst: Add compressed video formats used on MT8173 codec driver
  vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
  arm64: dts: mediatek: Add Video Decoder for MT8173

Wu-Cheng Li (2):
  videodev2.h: add V4L2_PIX_FMT_VP9 format.
  v4l2-ioctl: add VP9 format description.

 .../devicetree/bindings/media/mediatek-vcodec.txt  |   57 +-
 Documentation/media/uapi/v4l/pixfmt-013.rst        |    8 +
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    6 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   44 +
 drivers/media/platform/mtk-vcodec/Makefile         |   15 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1448 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |   88 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  394 ++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  205 +++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   28 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   62 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    8 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |    3 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   33 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |    5 +
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |  506 +++++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |  633 +++++++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |  967 +++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_base.h  |   56 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |  122 ++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  101 ++
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |  103 ++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  168 +++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   96 ++
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   12 +
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |   27 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/videodev2.h                     |    2 +
 28 files changed, 5173 insertions(+), 26 deletions(-)
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

-- 
1.7.9.5

