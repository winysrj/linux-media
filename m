Return-path: <mchehab@localhost>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35402 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1GGMVY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jul 2011 08:21:24 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p67CLN3o022111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:23 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p67CLN7u000477
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:23 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p67CLNoq007534
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:23 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, Amber Jain <amber@ti.com>
Subject: [PATCH v2 0/3] V4L2: OMAP: VOUT: Extend V4L2 support for OMAP4
Date: Thu, 7 Jul 2011 17:51:15 +0530
Message-ID: <1310041278-8810-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch set addresses following:
- Extend omap vout isr for secondary LCD over DPI panel.
- Extend omap vout isr for HDMI interface.
- DMA map and unmap the V4L2 buffers in qbuf and dqbuf so that they are
  properly flushed into memory before DMA starts. If this not done we were
  seeing artifacts on OMAP4.
- Minor cleanup to remove unnecessary code.

Changes from v1:
- Split the patch-set into two so as to separate out NV12 color-format support
  for OMAP4.
- Fixed review comments.

Amber Jain (3):
  V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
  V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
  V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.

 drivers/media/video/omap/omap_vout.c |   61 +++++++++++++++++++++++++--------
 1 files changed, 46 insertions(+), 15 deletions(-)

