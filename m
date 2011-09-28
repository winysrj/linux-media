Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33534 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab1I1Os5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 10:48:57 -0400
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<sumit.semwal@ti.com>, <linux-media@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 0/5] OMAP_VOUT: Misc fixes and cleanup patches for 3.2
Date: Wed, 28 Sep 2011 20:19:23 +0530
Message-ID: <1317221368-3301-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set includes patches which do the following:
- Fix crash if number of displays registered by DSS2 is more than 4.
- Fix the issue of not being able to request for a buffer which is larger than
  what we did the last time.
- Fix a small bug in omap_vout_isr()
- Remove some redundant code in omap_vout_isr()
- Add basic support for DSI panels

Changes in v4:
- Fix issue in "OMAP_VOUT: Fix check in reqbuf for buf_size allocation", improve
  commit message
- Remove patch "OMAP_VOUT: Don't trigger updates in omap_vout_probe", replace
  with "OMAP_VOUT: Increase MAX_DISPLAYS to a larger value"

Archit Taneja (5):
  OMAP_VOUT: Fix check in reqbuf for buf_size allocation
  OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
  OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
  OMAP_VOUT: Add support for DSI panels
  OMAP_VOUT: Increase MAX_DISPLAYS to a larger value

 drivers/media/video/omap/omap_vout.c    |  187 ++++++++++++++++---------------
 drivers/media/video/omap/omap_voutdef.h |    2 +-
 2 files changed, 97 insertions(+), 92 deletions(-)

