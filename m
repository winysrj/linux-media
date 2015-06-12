Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44768 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbbFLXHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 19:07:40 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v1.1 1/1] omap3isp: Fix sub-device power management code
Date: Sat, 13 Jun 2015 02:06:23 +0300
Message-Id: <1434150390-25898-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1434096127.3f3fQLryEJ@avalon>
References: <1434096127.3f3fQLryEJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 813f5c0ac5cc ("media: Change media device link_notify behaviour")
modified the media controller link setup notification API and updated the
OMAP3 ISP driver accordingly. As a side effect it introduced a bug by
turning power on after setting the link instead of before. This results in
sub-devices not being powered down in some cases when they should be. Fix
it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Fixes: 813f5c0ac5cc [media] media: Change media device link_notify behaviour
Cc: stable@vger.kernel.org # since v3.10
---
Hi Laurent,

I amended the commit message a bit. Let me know if you're ok with it.

 drivers/media/platform/omap3isp/isp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6bcab28..ce0556c 100644
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

