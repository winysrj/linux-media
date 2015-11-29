Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39768 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448AbbK2TWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:45 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 17/22] staging: v4l: omap4iss: Fix sub-device power management code
Date: Sun, 29 Nov 2015 21:20:18 +0200
Message-Id: <1448824823-10372-18-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same bug was present in the omap4iss driver as was in the omap3isp
driver. The code got copied to the omap4iss driver while broken. Fix the
omap4iss driver as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/omap4iss/iss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 076ddd4..c097fd5 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -533,14 +533,14 @@ static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 	int ret;
 
 	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
-	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
+	    !(flags & MEDIA_LNK_FL_ENABLED)) {
 		/* Powering off entities is assumed to never fail. */
 		iss_pipeline_pm_power(source, -sink_use);
 		iss_pipeline_pm_power(sink, -source_use);
 		return 0;
 	}
 
-	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
 		(flags & MEDIA_LNK_FL_ENABLED)) {
 		ret = iss_pipeline_pm_power(source, sink_use);
 		if (ret < 0)
-- 
2.1.4

