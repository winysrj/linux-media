Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46824 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754667AbbE1XTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 19:19:06 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: Fix sub-device power management code
Date: Fri, 29 May 2015 02:17:47 +0300
Message-Id: <1432855083-25969-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The power management code was reworked a little due to interface changes in
the MC. Due to those changes the power management broke a bit, fix it so the
functionality is reverted to old behaviour.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Fixes: 813f5c0ac5cc [media] media: Change media device link_notify behaviour
Cc: stable@vger.kernel.org # since v3.10
---
 drivers/media/platform/omap3isp/isp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index a038c05..3e6b97b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -829,14 +829,14 @@ static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
 	int ret;
 
 	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
-	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
+	    !(flags & MEDIA_LNK_FL_ENABLED)) {
 		/* Powering off entities is assumed to never fail. */
 		isp_pipeline_pm_power(source, -sink_use);
 		isp_pipeline_pm_power(sink, -source_use);
 		return 0;
 	}
 
-	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
 		(flags & MEDIA_LNK_FL_ENABLED)) {
 
 		ret = isp_pipeline_pm_power(source, sink_use);
-- 
2.1.4

