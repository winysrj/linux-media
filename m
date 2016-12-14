Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:61992 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752752AbcLNILz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 03:11:55 -0500
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>
Subject: [PATCH v9 0/4] Add Mediatek JPEG Decoder
Date: Wed, 14 Dec 2016 16:04:46 +0800
Message-ID: <1481702690-10476-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches provide a v4l2 driver to control Mediatek JPEG decoder
for decoding JPEG image and Motion JPEG bitstream.

changes since v8:
- Fix state error in first bit stream when capture buffer has been stream on.
  This will trigger device run inadvertently.

changes since v7:
- Update MAINTAINERS

changes since v6:
- fix kbuild test fail
- Add patch for MAINTAINERS

changes since v5:
- remove redundant name from struct mtk_jpeg_fmt
- Set state of all buffers to VB2_BUF_STATE_QUEUED if fail in start streaming
- Remove VB2_USERPTR
- Add check for buffer index

changes since v4:
- Change file name of binding documentation
- Revise DT binding documentation
- Revise compatible string

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

Rick Chang (4):
  dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
  vcodec: mediatek: Add Mediatek JPEG Decoder Driver
  arm: dts: mt2701: Add node for Mediatek JPEG Decoder
  vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver

 .../bindings/media/mediatek-jpeg-decoder.txt       |   37 +
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/mt2701.dtsi                      |   14 +
 drivers/media/platform/Kconfig                     |   15 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-jpeg/Makefile           |    2 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 1306 ++++++++++++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h    |  139 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c      |  417 +++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h      |   91 ++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c   |  160 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h   |   25 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h     |   58 +
 13 files changed, 2273 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
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

