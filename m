Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:56470 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751203AbcKGG5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 01:57:51 -0500
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>
Subject: [PATCH v4 0/3] Add Mediatek JPEG Decoder
Date: Mon, 7 Nov 2016 14:57:16 +0800
Message-ID: <1478501839-2775-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches provide a v4l2 driver to control Mediatek JPEG decoder
for decoding JPEG image and Motion JPEG bitstream.

changes since v3:
- Revise DT binding documentation
- Revise compatible string

changes since v2:
- Revise DT binding documentation 

changes since v1:
- Rebase for v4.9-rc1.
- Update Compliance test version and result
- Remove redundant path in Makefile
- Fix potential build error without CONFIG_PM_RUNTIME and CONFIG_PM_SLEEP
- Fix warnings from patch check and smatch check

* Dependency
The patch "arm: dts: mt2701: Add node for JPEG decoder" depends on: 
  CCF "Add clock support for Mediatek MT2701"[1]
  iommu and smi "Add the dtsi node of iommu and smi for mt2701"[2]

[1] http://lists.infradead.org/pipermail/linux-mediatek/2016-October/007271.html
[2] https://patchwork.kernel.org/patch/9164013/

* Compliance test
v4l2-compliance SHA   : 4ad7174b908a36c4f315e3fe2efa7e2f8a6f375a

Driver Info:
        Driver name   : mtk-jpeg decode
        Card type     : mtk-jpeg decoder
        Bus info      : platform:15004000.jpegdec
        Driver version: 4.9.0
        Capabilities  : 0x84204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format

Compliance test for device /dev/video3 (not using libv4l2):

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
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
                test VIDIOC_QUERYCTRL: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

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

Rick Chang (3):
  dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
  vcodec: mediatek: Add Mediatek JPEG Decoder Driver
  arm: dts: mt2701: Add node for Mediatek JPEG Decoder

 .../bindings/media/mediatek-jpeg-codec.txt         |   35 +
 arch/arm/boot/dts/mt2701.dtsi                      |   14 +
 drivers/media/platform/Kconfig                     |   15 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-jpeg/Makefile           |    2 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 1271 ++++++++++++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h    |  141 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c      |  417 +++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h      |   91 ++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c   |  160 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h   |   25 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h     |   58 +
 12 files changed, 2231 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-codec.txt
 create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h

-- 
1.9.1

