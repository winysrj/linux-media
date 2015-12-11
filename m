Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:38580 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754265AbbLKJz5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 04:55:57 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Subject: [PATCH v2 0/8] Add MT8173 Video Encoder Driver and VPU Driver
Date: Fri, 11 Dec 2015 17:55:35 +0800
Message-ID: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

==============
 Introduction
==============

The purpose of this RFC is to discuss the driver for a hw video codec
embedded in the Mediatek's MT8173 SoCs. Mediatek Video Codec is able to
handle video encoding of in a range of formats.

This RFC also include VPU driver. Mediatek Video Codec driver rely on
VPU driver to load, communicate with VPU.

Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI.
MTK IOMMU and MTK SMI have not yet been merged, but we wanted to start
discussion about the driver earlier so it could be merged sooner. The
driver posted here is the initial version, so I suppose it will require
more work.

[1]http://lists.infradead.org/pipermail/linux-mediatek/2015-October/002525.html

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
  [Media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver

Tiffany Lin (6):
  arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
  [media] VPU: mediatek: support Mediatek VPU
  dt-bindings: Add a binding for Mediatek Video Encoder
  arm64: dts: mediatek: Add Video Encoder for MT8173
  [media] vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
  [media] vcodec: mediatek: Add Mediatek H264 Video Encoder Driver

 .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 +
 .../devicetree/bindings/media/mediatek-vpu.txt     |   27 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   58 +
 drivers/media/platform/Kconfig                     |   21 +
 drivers/media/platform/Makefile                    |    4 +
 drivers/media/platform/mtk-vcodec/Makefile         |   11 +
 .../media/platform/mtk-vcodec/h264_enc/Makefile    |    8 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.c    |  495 ++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.h    |  161 ++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.c   |  316 ++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.h   |   30 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  412 +++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1670 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   45 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  469 ++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  122 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  102 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   29 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   85 +
 drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  108 ++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  174 ++
 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  212 +++
 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile |    8 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.c      |  384 +++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.h      |  141 ++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c     |  221 +++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.h     |   28 +
 drivers/media/platform/mtk-vpu/Makefile            |    1 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |  859 ++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |  149 ++
 33 files changed, 6602 insertions(+)
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

