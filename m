Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48707 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKIen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:34:43 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 00/14] v4l: ti-vpe: Some VPE fixes and enhancements
Date: Tue, 11 Mar 2014 14:03:39 +0530
Message-ID: <1394526833-24805-1-git-send-email-archit@ti.com>
In-Reply-To: <1393922965-15967-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
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

Changes in v3:

- improvements in selection API patch.
- querycap fixes for v4l2 compliance.
- v4l2_buffer 'field' and flags' fixes for compliance.
- fixes in try_fmt vpe_open for compliance.
- rename a IOMEM resource for better DT compatibility.

Changes in v2:

- selection API used instead of older cropping API.
- Typo fix.
- Some changes in patch 6/7 to support composing on the capture side of VPE.


Archit Taneja (14):
  v4l: ti-vpe: Make sure in job_ready that we have the needed number of
    dst_bufs
  v4l: ti-vpe: register video device only when firmware is loaded
  v4l: ti-vpe: Use video_device_release_empty
  v4l: ti-vpe: Allow DMABUF buffer type support
  v4l: ti-vpe: Allow usage of smaller images
  v4l: ti-vpe: Fix some params in VPE data descriptors
  v4l: ti-vpe: Add selection API in VPE driver
  v4l: ti-vpe: Rename csc memory resource name
  v4l: ti-vpe: report correct capabilities in querycap
  v4l: ti-vpe: Use correct bus_info name for the device in querycap
  v4l: ti-vpe: Fix initial configuration queue data
  v4l: ti-vpe: zero out reserved fields in try_fmt
  v4l: ti-vpe: Set correct field parameter for output and capture
    buffers
  v4l: ti-vpe: retain v4l2_buffer flags for captured buffers

 drivers/media/platform/ti-vpe/csc.c   |   2 +-
 drivers/media/platform/ti-vpe/vpdma.c |  68 ++++++---
 drivers/media/platform/ti-vpe/vpdma.h |  17 ++-
 drivers/media/platform/ti-vpe/vpe.c   | 263 ++++++++++++++++++++++++++++------
 4 files changed, 281 insertions(+), 69 deletions(-)

-- 
1.8.3.2

