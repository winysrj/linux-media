Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34970 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847AbcAZJEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:04:21 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, mchehab@osg.samsung.com, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, herman.chen@rock-chips.com,
	alpha.lin@rock-chips.com, zhaojun <jung.zhao@rock-chips.com>,
	Antti Palosaari <crope@iki.fi>, linux-api@vger.kernel.org,
	Benoit Parrot <bparrot@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-kernel@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH v1 0/3] Add VP8 deocder for rk3229 & rk3288
Date: Tue, 26 Jan 2016 17:04:03 +0800
Message-Id: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: zhaojun <jung.zhao@rock-chips.com>


====================
Introduction
====================

The purpose of this series is to add the driver for vp8
decoder on rk3229 & rk3288 platform, and will support
more formats in the future.

The driver uses v4l2 framework and RK IOMMU.
RK IOMMU has not yet been merged.



zhaojun (3):
  media: v4l: Add VP8 format support in V4L2 framework
  media: VPU: support Rockchip VPU
  media: vcodec: rockchip: Add Rockchip VP8 decoder driver

 drivers/media/platform/rockchip-vpu/Makefile       |    7 +
 .../media/platform/rockchip-vpu/rkvpu_hw_vp8d.c    |  798 ++++++++++
 .../platform/rockchip-vpu/rockchip_vp8d_regs.h     | 1594 ++++++++++++++++++++
 drivers/media/platform/rockchip-vpu/rockchip_vpu.c |  799 ++++++++++
 .../platform/rockchip-vpu/rockchip_vpu_common.h    |  439 ++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.c | 1007 +++++++++++++
 .../media/platform/rockchip-vpu/rockchip_vpu_dec.h |   33 +
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.c  |  295 ++++
 .../media/platform/rockchip-vpu/rockchip_vpu_hw.h  |  100 ++
 drivers/media/v4l2-core/v4l2-ctrls.c               |   17 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   51 +-
 include/media/v4l2-ctrls.h                         |    2 +
 include/media/videobuf2-dma-contig.h               |   11 +-
 include/uapi/linux/v4l2-controls.h                 |   98 ++
 include/uapi/linux/videodev2.h                     |    5 +
 16 files changed, 5238 insertions(+), 21 deletions(-)
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

