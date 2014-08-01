Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59959 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaHANzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 4/8] omap3isp: ccdc: Simplify ccdc_lsc_is_configured()
Date: Fri,  1 Aug 2014 15:46:30 +0200
Message-Id: <1406900794-9871-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a local variable to avoid the duplicate spin_unlock_irqrestore()
call.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index cd62d29..6a62cb7 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -481,14 +481,13 @@ done:
 static inline int ccdc_lsc_is_configured(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
-	if (ccdc->lsc.active) {
-		spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
-		return 1;
-	}
+	ret = ccdc->lsc.active != NULL;
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
-	return 0;
+
+	return ret;
 }
 
 static int ccdc_lsc_enable(struct isp_ccdc_device *ccdc)
-- 
1.8.5.5

