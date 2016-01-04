Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:42370 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbcADKMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2016 05:12:47 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, <eddie.huang@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v3 0/8] Add MT8173 Video Encoder Driver and VPU Driver
Date: Mon, 4 Jan 2016 18:11:48 +0800
Message-ID: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

==============
 Introduction
==============

The purpose of this series is to add the driver for video codec hw
embedded in the Mediatek's MT8173 SoCs. Mediatek Video Codec is able to
handle video encoding of in a range of formats.

This RFC also include VPU driver. Mediatek Video Codec driver rely on
VPU driver to load, communicate with VPU.

Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI.
MTK IOMMU and MTK SMI[1] have not yet been merged, but we wanted to start
discussion about the driver earlier so it could be merged sooner. The
driver posted here is the initial version, so I suppose it will require
more work.

[1]https://patchwork.kernel.org/patch/7880291/

==================
 Device interface
==================

In principle the driver bases on memory-to-memory framework:
it provides a single video node and each opened file handle gets its own
private context with separate buffer queues. Each context consist of 2
buffer queues: OUTPUT (for source buffers, i.e. raw video frames)
and CAPTURE (for destination buffers, i.e. encoded video frames).

The process of encoding video data from stream is a bit more complicated
than typical memory-to-memory processing. We base on memory-to-memory
framework and add the complicated part in our vb2 and v4l2 callback 
functionss. So we can base on well done m2m memory-to-memory framework, 
reduce duplicate code and make our driver code simple.

==============================
 VPU (Video Processor Unit)
==============================
The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
It is able to handle video decoding/encoding of in a range of formats.
The driver provides with VPU firmware download, memory management and
the communication interface between CPU and VPU.
For VPU initialization, it will create virtual memory for CPU access and
IOMMU address for vcodec hw device access. When a decode/encode instance
opens a device node, vpu driver will download vpu firmware to the device.
A decode/encode instant will decode/encode a frame using VPU 
interface to interrupt vpu to handle decoding/encoding jobs.

Please have a look at the code and comments will be very much appreciated.

Change in v3:
1.Refine code to pass v4l2-compliance test, now it still has 2 issues
2.Refine code according to latest MTK IOMMU patches[1]
3.Remove MFC51 specific CIDs and add MTK specific CIDs for for keyframe and
  skip I-frame
4.Refine code according to review comments

Below is the v1.6 version v4l2-compliance report for the mt8173 encoder driver.
Now there are still 2 test fail in v1.6.
For VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF, we directly use v4l2_m2m_ioctl_* functions,
but it still fail. It pass in kernel 3.18 but fail in kernel 4.4.
We will try v1.8 in next version.
VIDIOC_EXPBUF is becuase we support all three memory types VB2_DMABUF, VB2_MMAP and
VB2_USERPTR. VIDIOC_EXPBUF only allowed when only VB2_MMAP supported.
localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1
Driver Info:
        Driver name   : mtk-vcodec-en
        Card type     : platform:mt817
        Bus info      : platform:mt817
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

Compliance test for device /dev/video1 (not using libv4l2):

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
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 11 Private Controls: 2

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(266): vp->length == 0
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(335): buf.check(Unqueued, i)
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(420): testQueryBuf(node, i, q.g_buffers())
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
                fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(500): q.has_expbuf(node)
                test VIDIOC_EXPBUF: FAIL


Total: 38, Succeeded: 36, Failed: 2, Warnings: 0


Change in v2:
Vcodec Part
1.Remove common and include directory in mtk-vcodec
2.Refine vb2ops_venc_start_streaming and vb2ops_venc_stop_streaming and state machine
3.Remove venc_if_init and venc_if_deinit
4.Refine debug message
5.Refine lab and vpu decription in mediatek-vcodec.txt

VPU Part
1. Modify VPU Kconfig
2. Move encoder header files to other patch sets
3. Remove marcos for extended virtual/iova address
4. Change register and variable names
5. Add a reference counter for VPU watchdog
6. Remove one busy waiting in function vpu_ipi_send
7. Operate VPU clock in VPU driver (not called by encoder drivers)
8. Refine memory mapping, firmware download and extended memory allocation/free functions
9. Release more allocated resources in driver remove function


Andrew-CT Chen (2):
  dt-bindings: Add a binding for Mediatek Video Processor
  media: vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver

Tiffany Lin (6):
  media: VPU: mediatek: support Mediatek VPU
  arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
  dt-bindings: Add a binding for Mediatek Video Encoder
  media: vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
  media: vcodec: mediatek: Add Mediatek H264 Video Encoder Driver
  arm64: dts: mediatek: Add Video Encoder for MT8173

 .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 +
 .../devicetree/bindings/media/mediatek-vpu.txt     |   27 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   48 +
 drivers/media/platform/Kconfig                     |   20 +
 drivers/media/platform/Makefile                    |    4 +
 drivers/media/platform/mtk-vcodec/Makefile         |   11 +
 .../media/platform/mtk-vcodec/h264_enc/Makefile    |    6 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.c    |  530 ++++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.h    |  165 +++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.c   |  310 +++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.h   |   30 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  391 ++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1433 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   46 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  454 +++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  122 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  102 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   29 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   85 ++
 drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  106 ++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  175 +++
 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  212 +++
 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile |    6 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.c      |  419 ++++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.h      |  145 ++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c     |  221 +++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h     |   28 +
 drivers/media/platform/mtk-vpu/Makefile            |    1 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |  941 +++++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |  182 +++
 include/uapi/linux/v4l2-controls.h                 |    4 +
 34 files changed, 6505 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h
 create mode 100644 drivers/media/platform/mtk-vpu/Makefile
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h

-- 
1.7.9.5

