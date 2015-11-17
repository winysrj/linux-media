Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53395 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751734AbbKQMzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:16 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
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
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 0/8] Add MT8173 Video Encoder Driver and VPU Driver
Date: Tue, 17 Nov 2015 20:54:37 +0800
Message-ID: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
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

Andrew-CT Chen (3):
  dt-bindings: Add a binding for Mediatek Video Processor Unit
  arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
  media: platform: mtk-vpu: Support Mediatek VPU

Daniel Hsiao (1):
  media: platform: mtk-vcodec: Add Mediatek VP8 Video Encoder Driver

Tiffany Lin (4):
  dt-bindings: Add a binding for Mediatek Video Encoder
  arm64: dts: mediatek: Add Video Encoder for MT8173
  media: platform: mtk-vcodec: Add Mediatek V4L2 Video Encoder Driver
  media: platform: mtk-vcodec: Add Mediatek H264 Video Encoder Driver

 .../devicetree/bindings/media/mediatek-vcodec.txt  |   58 +
 .../devicetree/bindings/media/mediatek-vpu.txt     |   27 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   58 +
 drivers/media/platform/Kconfig                     |   19 +
 drivers/media/platform/Makefile                    |    5 +
 drivers/media/platform/mtk-vcodec/Kconfig          |    5 +
 drivers/media/platform/mtk-vcodec/Makefile         |   12 +
 drivers/media/platform/mtk-vcodec/common/Makefile  |   12 +
 .../media/platform/mtk-vcodec/common/venc_drv_if.c |  159 ++
 .../media/platform/mtk-vcodec/h264_enc/Makefile    |    9 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.c    |  529 ++++++
 .../platform/mtk-vcodec/h264_enc/venc_h264_if.h    |   53 +
 .../platform/mtk-vcodec/h264_enc/venc_h264_vpu.c   |  341 ++++
 .../platform/mtk-vcodec/include/venc_drv_base.h    |   68 +
 .../platform/mtk-vcodec/include/venc_drv_if.h      |  187 +++
 .../platform/mtk-vcodec/include/venc_ipi_msg.h     |  212 +++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  441 +++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1773 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   28 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  535 ++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  122 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  110 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   30 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   66 +
 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile |    9 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.c      |  371 ++++
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_if.h      |   48 +
 .../platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c     |  245 +++
 drivers/media/platform/mtk-vpu/Makefile            |    1 +
 .../platform/mtk-vpu/h264_enc/venc_h264_vpu.h      |  127 ++
 .../media/platform/mtk-vpu/include/venc_ipi_msg.h  |  212 +++
 drivers/media/platform/mtk-vpu/mtk_vpu_core.c      |  823 +++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu_core.h      |  161 ++
 .../media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h  |  119 ++
 36 files changed, 7107 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
 create mode 100644 drivers/media/platform/mtk-vcodec/Kconfig
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/common/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/h264_enc/venc_h264_vpu.c
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_ipi_msg.h
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
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vp8_enc/venc_vp8_vpu.c
 create mode 100644 drivers/media/platform/mtk-vpu/Makefile
 create mode 100644 drivers/media/platform/mtk-vpu/h264_enc/venc_h264_vpu.h
 create mode 100644 drivers/media/platform/mtk-vpu/include/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu_core.c
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu_core.h
 create mode 100644 drivers/media/platform/mtk-vpu/vp8_enc/venc_vp8_vpu.h

-- 
1.7.9.5

