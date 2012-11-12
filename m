Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41464 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2KLNd7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 08:33:59 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 0/2] omap_vout: remove cpu_is_* uses
Date: Mon, 12 Nov 2012 15:33:38 +0200
Message-ID: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch removes use of cpu_is_* funcs from omap_vout, and uses omapdss's
version instead. The other patch removes an unneeded plat/dma.h include.

These are based on current omapdss master branch, which has the omapdss version
code. The omapdss version code is queued for v3.8. I'm not sure which is the
best way to handle these patches due to the dependency to omapdss. The easiest
option is to merge these for 3.9.

There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last OMAP
dependency in the omap_vout driver. I'm not going to touch that, as it doesn't
look as trivial as this cpu_is_* removal, and I don't have much knowledge of
the omap_vout driver.

Compiled, but not tested.

 Tomi

Tomi Valkeinen (2):
  [media] omap_vout: use omapdss's version instead of cpu_is_*
  [media] omap_vout: remove extra include

 drivers/media/platform/omap/omap_vout.c    |    4 +--
 drivers/media/platform/omap/omap_voutlib.c |   38 ++++++++++++++++++++--------
 drivers/media/platform/omap/omap_voutlib.h |    3 +++
 3 files changed, 32 insertions(+), 13 deletions(-)

-- 
1.7.10.4

