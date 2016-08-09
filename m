Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:61643 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932802AbcHIN7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2016 09:59:16 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [PATCH v3 0/4] Add MT8173 MDP Driver 
Date: Tue, 9 Aug 2016 21:58:53 +0800
Message-ID: <1470751137-12403-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes in v3:
- Modify device ndoe as structured one.
- Fix conflict in dts on Linux 4.8-rc1

Changes in v2:
- Add section to describe blocks function in dts-bindings
- Remove the assignment of device_caps in querycap()
- Remove format's name assignment
- Copy colorspace-related parameters from OUTPUT to CAPTURE
- Use m2m helper functions
- Fix DMA allocation failure
- Initialize lazily vpu instance in streamon()

==============
 Introduction
==============

The purpose of this series is to add the driver for Media Data Path HW embedded in the Mediatek's MT8173 SoC.
MDP is used for scaling and color space conversion.

It could convert V4L2_PIX_FMT_MT21 to V4L2_PIX_FMT_NV12M or V4L2_PIX_FMT_YUV420M.

NV12M/YUV420M/MT21 -> MDP -> NV12M/YUV420M

This patch series rely on MTK VPU driver in patch series "Add MT8173 Video Encoder Driver and VPU Driver"[1] and "Add MT8173 Video Decoder Driver"[2].
MDP driver rely on VPU driver to load, communicate with VPU.

Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.

[1]https://patchwork.kernel.org/patch/9002171/
[2]https://patchwork.kernel.org/patch/9141245/

==================
 Device interface
==================

In principle the driver bases on v4l2 memory-to-memory framework:
it provides a single video node and each opened file handle gets its own private context with separate buffer queues. Each context consist of 2 buffer queues: OUTPUT (for source buffers) and CAPTURE (for destination buffers).
OUTPUT and CAPTURE buffer could be MMAP or DMABUF memory type.

v4l2-compliance test output:
# v4l2-compliance -d /dev/image-proc0
v4l2-compliance SHA   : ee1ab491019f80052834d14c76bdd1c1b46f2158

Driver Info:
        Driver name   : mtk-mdp
        Card type     : soc:mdp
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

Compliance test for device /dev/image-proc0 (not using libv4l2):

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
                Standard Controls: 5 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK
                test Composing: OK
                test Scaling: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0


Minghsiu Tsai (4):
  VPU: mediatek: Add mdp support
  dt-bindings: Add a binding for Mediatek MDP
  media: Add Mediatek MDP Driver
  arm64: dts: mediatek: Add MDP for MT8173

 .../devicetree/bindings/media/mediatek-mdp.txt     |  109 ++
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   84 ++
 drivers/media/platform/Kconfig                     |   16 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-mdp/Makefile            |    9 +
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c      |  159 +++
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h      |   72 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |  294 +++++
 drivers/media/platform/mtk-mdp/mtk_mdp_core.h      |  240 ++++
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |  126 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       | 1263 ++++++++++++++++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h       |   22 +
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c      |  153 +++
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h      |   31 +
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c       |  145 +++
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h       |   41 +
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |    5 +
 17 files changed, 2771 insertions(+)
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

--
1.7.9.5

