Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34236 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1IPJ7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 05:59:01 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 0/5] [media]: OMAP_VOUT: Misc fixes and cleanup patches for 3.2
Date: Fri, 16 Sep 2011 15:30:28 +0530
Message-ID: <1316167233-1437-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set includes patches which do the following:
- Fix crash if a we call dssdev->driver->update for a disabled panel.
- Fix the issue of not being able to request for a buffer which is larger than
  what we did the last time.
- Fix a small bug in omap_vout_isr()
- Remove some redundant code in omap_vout_isr()
- Add basic support for DSI panels

Note:
The patch "OMAP_VOUT: Fix check in reqbuf & mmap for buf_size allocation" had
been posted in the past, but wasn't commented on. So copied it here again.

These patches are based on Tomi's master branch(which is based on 3.1-rc6), and
a patches which affects omap_vout and has been posted recently on linux-media
(see "OMAPDSS/OMAP_VOUT: Fix incorrect OMAP3-alpha compatibility setting"). This
tree can be used as reference:

git@gitorious.org:~boddob/linux-omap-dss2/archit-dss2-clone.git 'for_omap_vout'

Archit Taneja (5):
  OMAP_VOUT: Fix check in reqbuf & mmap for buf_size allocation
  OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
  OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
  OMAP_VOUT: Add support for DSI panels
  OMAP_VOUT: Don't trigger updates in omap_vout_probe

 drivers/media/video/omap/omap_vout.c |  199 +++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 100 deletions(-)

