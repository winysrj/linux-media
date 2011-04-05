Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1DEH5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:17 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CCF2F35B73
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:12 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/14] omap3isp: Don't increment node entity use count when poweron fails
Date: Tue,  5 Apr 2011 09:57:36 +0200
Message-Id: <1301990256-6963-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When open a device node, all entities part of the same pipeline are
powered on. If one of the entities fails to be powered on, the open
operations fails. In that case the device node entity use count must not
be incremented.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 8190511..f4edbf0 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -663,6 +663,8 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 
 	/* Apply power change to connected non-nodes. */
 	ret = isp_pipeline_pm_power(entity, change);
+	if (ret < 0)
+		entity->use_count -= change;
 
 	mutex_unlock(&entity->parent->graph_mutex);
 
-- 
1.7.3.4

