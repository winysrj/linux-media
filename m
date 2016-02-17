Return-path: <linux-media-owner@vger.kernel.org>
Received: from sg-smtp01.263.net ([54.255.195.220]:55489 "EHLO
	sg-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161799AbcBQVxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 16:53:12 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: tfiga@chromium.org, posciak@chromium.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH v2 0/4] Add Rockchip VP8 Video Decoder Driver
Date: Wed, 17 Feb 2016 18:41:13 +0800
Message-Id: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of this series is to add Rockchip VPU driver for
hw video codec in Rockchip's RK3229 and RK3288 SOCs. Rockchip
Video VPU Driver is able to handle video decoding of in a
range of formats(Now only support VP8, and more formats will
be supported in future).

The VPU driver depends on Request API[1] and RK IOMMU[2].

[1]http://www.spinics.net/lists/linux-media/msg95733.html
[2]http://www.gossamer-threads.com/lists/linux/kernel/2347458

Since VP8 headers and controls for the V4L2 API and framework
and the changes to videobuf2 were authored and written by
Pawel Osciak <posciak@chromium.org> and Tomasz Figa <tfiga@chromium.org>.
These parts are 'NOT FOR REVIEW' and will be submitted by
themselves. But these patches are very important for Rockchip VPU
Driver, I cherrypick them from Chromium OS Tree[3] and use
for reference here.

[3]https://chromium.googlesource.com/chromiumos/third_party/kernel


Changes in v2:
- add [NOT FOR REVIEW] tag for patches from Chromium OS Tree(Tomasz)
- update copyright message
- list all the related signed-off names
- make commit message more readable(Enric)
- fix format error of commit message(Tomasz)

Jung Zhao (1):
  media: vcodec: rockchip: Add Rockchip VP8 decoder driver

Pawel Osciak (2):
  [NOT FOR REVIEW] v4l: Add private compound control type.
  [NOT FOR REVIEW] v4l: Add VP8 low-level decoder API controls.

Tomasz Figa (1):
  [NOT FOR REVIEW] videobuf2-dc: Let drivers specify DMA attrs

 drivers/media/platform/Kconfig                     |   11 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rockchip-vpu/Makefile       |    7 +
 .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
 .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594 ++++++++++++++++++++
 drivers/media/platform/rockchip-vpu/rockchip_vpu.c |  803 ++++++++++
 .../platform/rockchip-vpu/rockchip_vpu_common.h    |  439 ++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 1007 +++++++++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |   33 +
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |  295 ++++
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  100 ++
 drivers/media/v4l2-core/v4l2-ctrls.c               |   13 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   33 +-
 include/media/v4l2-ctrls.h                         |    2 +
 include/media/videobuf2-dma-contig.h               |   11 +-
 include/uapi/linux/v4l2-controls.h                 |   94 ++
 include/uapi/linux/videodev2.h                     |    5 +
 18 files changed, 5235 insertions(+), 12 deletions(-)
 create mode 100644 drivers/media/platform/rockchip-vpu/Makefile
 create mode 100644 drivers/media/platform/rockchip-vpu/rkvpu_hw_vp8d.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vp8d_regs.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_common.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_dec.h
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip-vpu/rockchip_vpu_hw.h

-- 
1.9.1

