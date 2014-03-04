Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56304 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaCDIuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 03:50:10 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 0/7] v4l: ti-vpe: Some VPE fixes and enhancements
Date: Tue, 4 Mar 2014 14:19:18 +0530
Message-ID: <1393922965-15967-1-git-send-email-archit@ti.com>
In-Reply-To: <1393832008-22174-1-git-send-email-archit@ti.com>
References: <1393832008-22174-1-git-send-email-archit@ti.com>
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
cropping/composing.

Reference branch:

git@github.com:boddob/linux.git vpe_for_315

Changes in v2:

- selection API used instead of older cropping API.
- Typo fix.
- Some changes in patch 6/7 to support composing on the capture side of VPE.

Archit Taneja (7):
  v4l: ti-vpe: Make sure in job_ready that we have the needed number of
    dst_bufs
  v4l: ti-vpe: register video device only when firmware is loaded
  v4l: ti-vpe: Use video_device_release_empty
  v4l: ti-vpe: Allow DMABUF buffer type support
  v4l: ti-vpe: Allow usage of smaller images
  v4l: ti-vpe: Fix some params in VPE data descriptors
  v4l: ti-vpe: Add selection API in VPE driver

 drivers/media/platform/ti-vpe/vpdma.c |  68 +++++++---
 drivers/media/platform/ti-vpe/vpdma.h |  17 +--
 drivers/media/platform/ti-vpe/vpe.c   | 228 +++++++++++++++++++++++++++++-----
 3 files changed, 255 insertions(+), 58 deletions(-)

-- 
1.8.3.2

