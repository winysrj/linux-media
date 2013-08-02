Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57529 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3HBOEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 10:04:52 -0400
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <dagriego@biglakesoftware.com>,
	<dale@farnsworth.org>, <pawel@osciak.com>,
	<m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 0/6] v4l: VPE mem to mem driver
Date: Fri, 2 Aug 2013 19:33:37 +0530
Message-ID: <1375452223-30524-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VPE:
VPE(Video Processing Engine) is an IP found on DRA7xx, and in some past TI
multimedia SoCs which don't have baseport support in the mainline kernel.

VPE is a memory to memory block used for performing de-interlacing, scaling and
color conversion on input buffers. It's primarily used to de-interlace decoded
DVD/Blu Ray video buffers, and provide the content to progressive display or do
some other post processing. VPE can also be used for other tasks like fast
color space conversion, scaling and chrominance up/down sampling. The scaler in
particular is based on a polyphase filter and supports 32 phases and 5/7 taps.

VPE's De-interlacer IP:
The De-interlacer module performs a combination of spatial and temporal
interlacing, it determines the weight-age by keeping a track of the change in
motion between fields by maintaining and updating a motion vector buffer in
the RAM. The de-interlacer needs the current field and the 2 previous fields
(along with the motion vector info)to generate a progressive frame. It operates
on YUV422 data.

VPDMA:
All the DMAs are done through a dedicated DMA IP called VPDMA(Video Port Direct
Memory Access). This DMA IP is specialized for transferring video buffers, the
input and output data ports of VPDMA are configured via descriptor lists loaded
to the VPDMA list manager. VPDMA is also used to load MMRs of the various VPE
sub blocks.

VPDMA is advanced enough to support multiple clients like a system DMA,
however, the way it's integrated in the SoC is such that it can be used only by
the VPE IP. The same IP is also used on DRA7x in another block called VIP
(full form) used to capture camera sensor content. It's again dedicated to the
VIP block, and therefore doesn't have multiple clients. These factors made us
consider writing the VPDMA block as a library, providing functions to
VPE(and VIP in the future) to add descriptors and start DMA. It might have
made sense to make it a dmaengine driver if there were multiple clients using
VPDMA.

VPE and VPDMA look something like this:

   -----------		         ---
  |    MVin   |---------------->|   |
  |	      |			|   |
  |   Mvout   |<----------------|   |    ---	
  |	      |	   ---------    |   |   |   |
  |	f     |-->| CHR_US1 |-->| D |   | S |	     ------
  | (YUV in)  |    ---------    | E |-->| C |------>|CHR_DS|----
  | 	      |	   ---------    | I |   |   |   |    ------     |
  |   f - 1   |-->| CHR_US2 |-->|   |   |   |   |		|
  | (YUV in)  |	   ---------	|   |    ---    |    -----	|
  | 	      |	   ---------    |   |		 -->| CSC |--   |
  |   f - 2   |-->| CHR_US3 |-->|   |		     -----   |  |
  | (YUV in)  |	   ---------    |   |			     |  |
  |  	      |			 ---			     |  |
  |	      |						     |	|					  
  | (YUV out) |<---------------------------------------------	|
  |	      |							|
  | (RGB out) |<------------------------------------------------
   -----------
     VPDMA			      VPE

f, f - 1, and f - 2 are input ports fetching 3 consecutive fields for the
de-interlacer. MVin and MVout are ports which fetch the current motion vector
and output the updated motion vector respectively. There are 2 output ports,
one for YUV output and the other for RGB output if the color space
converter(CSC) is used. The inputs can be YUV packed or semiplanar formats. The
chrominance upsampler(CHR_USx) is used when the input format is NV12, the
chrominance downsampler(CHR_DS) is used if the the output content needs to be
NV12 format. The scaler(SC) can be used to scale the de-interlaced content if
needed.

This series adds VPE as a mem to mem v4l2 driver, and VPDMA as a helper
library. For now, only the de-interlacer is configured, the scaler and color
space converter are bypassed.

These patches were tested over the patch series which provides initial baseport
support for DRA7XX:

http://marc.info/?l=linux-omap&m=137518359422774&w=2

Archit Taneja (6):
  v4l: ti-vpe: Create a vpdma helper library
  v4l: ti-vpe: Add helpers for creating VPDMA descriptors
  v4l: ti-vpe: Add VPE mem to mem driver
  v4l: ti-vpe: Add de-interlacer support in VPE
  arm: dra7xx: hwmod data: add VPE hwmod data and ocp_if info
  experimental: arm: dts: dra7xx: Add a DT node for VPE

 arch/arm/boot/dts/dra7.dtsi                |   11 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c  |   42 +
 drivers/media/platform/Kconfig             |   10 +
 drivers/media/platform/Makefile            |    2 +
 drivers/media/platform/ti-vpe/vpdma.c      |  858 ++++++++++++
 drivers/media/platform/ti-vpe/vpdma.h      |  202 +++
 drivers/media/platform/ti-vpe/vpdma_priv.h |  814 +++++++++++
 drivers/media/platform/ti-vpe/vpe.c        | 2065 ++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h   |  496 +++++++
 9 files changed, 4500 insertions(+)
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h

-- 
1.8.1.2

