Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37974 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752275AbeEGMrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:47:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Subject: [PATCH 1/2] omap3isp: Remove useless NULL check in omap3isp_stat_config
Date: Mon,  7 May 2018 15:47:22 +0300
Message-Id: <20180507124723.2153-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180507124723.2153-1-sakari.ailus@linux.intel.com>
References: <20180507124723.2153-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver checked whether the second argument (the new
configuration) to the ISP statistics is NULL. This is the pointer to the
user-given argument and is never NULL. Remove the check.

Reported-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 529cd8fb29b1..34a91125da36 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -542,12 +542,6 @@ int omap3isp_stat_config(struct ispstat *stat, void *new_conf)
 	struct ispstat_generic_config *user_cfg = new_conf;
 	u32 buf_size = user_cfg->buf_size;
 
-	if (!new_conf) {
-		dev_dbg(stat->isp->dev, "%s: configuration is NULL\n",
-			stat->subdev.name);
-		return -EINVAL;
-	}
-
 	mutex_lock(&stat->ioctl_lock);
 
 	dev_dbg(stat->isp->dev,
-- 
2.11.0
