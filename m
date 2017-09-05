Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40766 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751670AbdIENF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 09:05:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v8 10/21] omap3isp: Print the name of the entity where no source pads could be found
Date: Tue,  5 Sep 2017 16:05:42 +0300
Message-Id: <20170905130553.1332-11-sakari.ailus@linux.intel.com>
In-Reply-To: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If no source pads are found in an entity, print the name of the entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 3b1a9cd0e591..9a694924e46e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1669,8 +1669,8 @@ static int isp_link_entity(
 			break;
 	}
 	if (i == entity->num_pads) {
-		dev_err(isp->dev, "%s: no source pad in external entity\n",
-			__func__);
+		dev_err(isp->dev, "%s: no source pad in external entity %s\n",
+			__func__, entity->name);
 		return -EINVAL;
 	}
 
-- 
2.11.0
