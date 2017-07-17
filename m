Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44148 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751336AbdGQWBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:01:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pavel@ucw.cz, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/7] omap3isp: Ignore endpoints with invalid configuration
Date: Tue, 18 Jul 2017 01:01:10 +0300
Message-Id: <20170717220116.17886-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If endpoint has an invalid configuration, ignore it instead of happily
proceeding to use it nonetheless. Ignoring such an endpoint is better than
failing since there could be multiple endpoints, only some of which are
bad.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/omap3isp/isp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index db2cccb57ceb..441eba1e02eb 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2110,10 +2110,12 @@ static int isp_fwnodes_parse(struct device *dev,
 		if (!isd)
 			goto error;
 
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
+		if (isp_fwnode_parse(dev, fwnode, isd)) {
+			devm_kfree(dev, isd);
+			continue;
+		}
 
-		if (isp_fwnode_parse(dev, fwnode, isd))
-			goto error;
+		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
 
 		isd->asd.match.fwnode.fwnode =
 			fwnode_graph_get_remote_port_parent(fwnode);
-- 
2.11.0
