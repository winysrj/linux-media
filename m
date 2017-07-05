Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42004 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752261AbdGEXAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 7/8] omap3isp: Check for valid port in endpoints
Date: Thu,  6 Jul 2017 02:00:18 +0300
Message-Id: <20170705230019.5461-8-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that we do have a valid port in an endpoint, return an error if not.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 2d45bf471c82..0676be725d7c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2081,7 +2081,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 	default:
 		dev_warn(dev, "%s: invalid interface %u\n",
 			 to_of_node(fwnode)->full_name, vep.base.port);
-		break;
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.11.0
