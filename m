Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38169 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaCCHeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 02:34:10 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 0/7] v4l: ti-vpe: Some VPE fixes and enhancements
Date: Mon, 3 Mar 2014 13:03:21 +0530
Message-ID: <1393832008-22174-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set mainly consists of minor fixes for the VPE driver. These fixes
ensure the following:

- The VPE module can be inserted and removed successively.
- Make sure that smaller resolutions like qcif work correctly.
- Prevent race condition between firmware loading and an open call to the v4l2
  device.
- Prevent the possibility of output m2m queue not having sufficient 'ready'
  buffers.
- Some VPDMA data descriptor fields weren't understood correctly before. They
  are now used correctly.

The rest of the patches add some minor features like DMA buf support and
cropping.

Reference branch:

git@github.com:boddob/linux.git vpe_for_315

Archit Taneja (7):
  v4l: ti-vpe: Make sure in job_ready that we have the needed number of
    dst_bufs
  v4l: ti-vpe: register video device only when firmware is loaded
  v4l: ti-vpe: Use video_device_release_empty
  v4l: ti-vpe: Allow DMABUF buffer type support
  v4l: ti-vpe: Allow usage of smaller images
  v4l: ti-vpe: Fix some params in VPE data descriptors
  v4l: ti-vpe: Add crop support in VPE driver

 drivers/media/platform/ti-vpe/vpdma.c |  58 ++++++++---
 drivers/media/platform/ti-vpe/vpdma.h |  16 +--
 drivers/media/platform/ti-vpe/vpe.c   | 180 +++++++++++++++++++++++++++-------
 3 files changed, 198 insertions(+), 56 deletions(-)

-- 
1.8.3.2

