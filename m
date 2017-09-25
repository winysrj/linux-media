Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49416 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754261AbdIYWZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 09/28] omap3isp: Print the name of the entity where no source pads could be found
Date: Tue, 26 Sep 2017 01:25:20 +0300
Message-Id: <20170925222540.371-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
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
index 4afd7ba4fad6..35687c9707e0 100644
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
