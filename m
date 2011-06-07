Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:55055 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1FGOro (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:47:44 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57ElhVK013461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:43 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p57ElhQL022418
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:47:43 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>, Amber Jain <amber@ti.com>
Subject: [PATCH 0/6] V4L2: OMAP: VOUT: Extend V4L2 support for OMAP4  
Date: Tue, 7 Jun 2011 20:17:32 +0530
Message-ID: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch set addresses following:
- Extend omap vout isr for secondary LCD over DPI panel.
- Extend omap vout isr for HDMI interface.
- DMA map and unmap the V4L2 buffers in qbuf and dqbuf so that they are
  properly flushed into memory before DMA starts. If this not done we were
  seeing artifacts on OMAP4.
- Adapt to V4L2 multiplanar API's.
- Add support for NV12 format to omap vout on OMAP4.
- Minor cleanup to remove unnecessary code.


Can be tested using v4l2 streaming over:
https://gitorious.org/~amber/linux-omap-dss2/amber-omap-dss2/commits/v4l2-multi-planar

Amber Jain (6):
  V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
  V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
  V4L2: OMAP: VOUT: Adapt to Multiplanar APIs
  V4L2: OMAP: VOUT: Modifications to support 1-plane Multiplanar for
    RGB/YUYV formats
  V4L2: OMAP: VOUT: Changes for NV12 format support for OMAP4
  V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.

 drivers/media/video/omap/omap_vout.c    |  305 +++++++++++++++++++++----------
 drivers/media/video/omap/omap_voutdef.h |    4 +
 drivers/media/video/omap/omap_voutlib.c |   36 ++--
 drivers/media/video/omap/omap_voutlib.h |    6 +-
 4 files changed, 236 insertions(+), 115 deletions(-)

