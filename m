Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45516 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751434AbdIOOSD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:18:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v13 09/25] omap3isp: Print the name of the entity where no source pads could be found
Date: Fri, 15 Sep 2017 17:17:08 +0300
Message-Id: <20170915141724.23124-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If no source pads are found in an entity, print the name of the entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
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
