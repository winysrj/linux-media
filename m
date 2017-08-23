Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:56571 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbdHWNa5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 09:30:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: omap3isp: fix uninitialized variable use
Date: Wed, 23 Aug 2017 15:30:19 +0200
Message-Id: <20170823133044.686146-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A debug printk statement was copied incorrectly into the new
csi1 parser code and causes a warning there:

drivers/media/platform/omap3isp/isp.c: In function 'isp_probe':
include/linux/dynamic_debug.h:134:3: error: 'i' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Since there is only one lane, the index is never set. This
changes the debug print to always print a zero instead,
keeping the original format of the message.

Fixes: 9211434bad30 ("media: omap3isp: Parse CSI1 configuration from the device tree")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 83aea08b832d..30c825bf80d9 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			buscfg->bus.ccp2.lanecfg.data[0].pol =
 				vep.bus.mipi_csi1.lane_polarity[1];
 
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			dev_dbg(dev, "data lane 0 polarity %u, pos %u\n",
 				buscfg->bus.ccp2.lanecfg.data[0].pol,
 				buscfg->bus.ccp2.lanecfg.data[0].pos);
 
-- 
2.9.0
