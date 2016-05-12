Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:35617 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754AbcELLYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 07:24:48 -0400
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
Subject: [PATCH v2 0/9] Add MT8173 Video Decoder Driver
Date: Thu, 12 May 2016 19:24:01 +0800
Message-ID: <1463052250-38262-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

==============
 Introduction
==============

The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
Mediatek Video Codec is able to handle video decoding of in a range of formats.

This patch series add Mediatek block format V4L2_PIX_FMT_MT21, the decoder driver will decoded bitstream to
V4L2_PIX_FMT_MT21 format.

This patch series rely on MTK VPU driver in patch series "Add MT8173 Video Encoder Driver and VPU Driver"[1]
and patch "CHROMIUM: v4l: Add V4L2_PIX_FMT_VP9 definition"[2] for VP9 support.
Mediatek Video Decoder driver rely on VPU driver to load, communicate with VPU.

Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.

[1]https://patchwork.linuxtv.org/patch/33734/
[2]https://chromium-review.googlesource.com/#/c/245241/

==================
 Device interface
==================

In principle the driver bases on v4l2 memory-to-memory framework:
it provides a single video node and each opened file handle gets its own private context with separate
buffer queues. Each context consist of 2 buffer queues: OUTPUT (for source buffers, i.e. bitstream)
and CAPTURE (for destination buffers, i.e. decoded video frames).
OUTPUT and CAPTURE buffer could be MMAP or DMABUF memory type.
VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS return V4L2_CID_MIN_BUFFERS_FOR_CAPTURE only when dirver in MTK_STATE_HEADER
state, or it will return EAGAIN.
Driver do not support subscribe event for control 'User Controls' for now.
And it default support export DMABUF for other display drivers.

Change in v2:
1. Add documentation for V4L2_PIX_FMT_MT21
2. Remove DRM_FORMAT_MT21
3. Refine code according to review comments

v4l2-compliance test output:
localhost Encode # ./v4l2-compliance -d /dev/video0
Driver Info:
        Driver name   : mtk-vcodec-dec
        Card type     : platform:mt8173
        Bus info      : platform:mt8173
        Driver version: 4.4.0
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
                test VIDIOC_QUERYCTRL/MENU: OK
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(357): g_ctrl returned an error (11)
                test VIDIOC_G/S_CTRL: FAIL
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(579): g_ext_ctrls returned an error (11)
                test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(721): subscribe event for control 'User Controls' failed
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 2 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-formats.cpp(405): expected EINVAL, but got 11 when getting format for buftype 9
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(500): q.has_expbuf(node)
                test VIDIOC_EXPBUF: FAIL


Total: 38, Succeeded: 33, Failed: 5, Warnings: 0


Andrew-CT Chen (1):
  WIP: media: VPU: Add decoder driver

Tiffany Lin (8):
  [media] : v4l: add Mediatek compressed video block format
  [media] DocBook/v4l: Add compressed video formats used on MT8173
    codec driver
  WIP: media: devicetree: bindings: Document Mediatek Video Decoder
  WIP: media: Add Mediatek V4L2 Video Decoder Driver
  WIP: media: Add Mediatek H264 Video Decode Driver
  WIP: media: Add Mediatek VP8 Video Decoder Driver
  WIP: media: Add Mediatek VP9 Video Decoder Driver
  WIP: arm64: dts: mt8173: Add node for Mediatek Video Decoder

 Documentation/DocBook/media/v4l/pixfmt.xml         |    6 +
 .../devicetree/bindings/media/mediatek-vcodec.txt  |   50 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   38 +
 drivers/media/platform/mtk-vcodec/Makefile         |   15 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1336 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |   81 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  440 +++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  154 +++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   28 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   81 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |    2 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   10 +-
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |  504 ++++++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |  632 +++++++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |  947 ++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_base.h  |   56 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |  123 ++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |   93 ++
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |  103 ++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  168 +++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   96 ++
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   12 +
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |   27 +
 include/uapi/linux/videodev2.h                     |    1 +
 24 files changed, 4982 insertions(+), 21 deletions(-)
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

