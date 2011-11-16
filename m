Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1KPUGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:06:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/4] omap3isp: preview: Rename max output sizes defines
Date: Wed, 16 Nov 2011 21:06:43 +0100
Message-Id: <1321474006-24589-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum preview engine output size depends on the ISP revision, not
the OMAP revision. Rename the macros accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index ccb876f..28a1232 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -116,11 +116,11 @@ static struct omap3isp_prev_csc flr_prev_csc = {
 #define PREV_MIN_IN_HEIGHT	8
 #define PREV_MAX_IN_HEIGHT	16384
 
-#define PREV_MIN_OUT_WIDTH	0
-#define PREV_MIN_OUT_HEIGHT	0
-#define PREV_MAX_OUT_WIDTH	1280
-#define PREV_MAX_OUT_WIDTH_ES2	3300
-#define PREV_MAX_OUT_WIDTH_3630	4096
+#define PREV_MIN_OUT_WIDTH		0
+#define PREV_MIN_OUT_HEIGHT		0
+#define PREV_MAX_OUT_WIDTH_REV_1	1280
+#define PREV_MAX_OUT_WIDTH_REV_2	3300
+#define PREV_MAX_OUT_WIDTH_REV_15	4096
 
 /*
  * Coeficient Tables for the submodules in Preview.
@@ -1306,14 +1306,14 @@ static unsigned int preview_max_out_width(struct isp_prev_device *prev)
 
 	switch (isp->revision) {
 	case ISP_REVISION_1_0:
-		return PREV_MAX_OUT_WIDTH;
+		return PREV_MAX_OUT_WIDTH_REV_1;
 
 	case ISP_REVISION_2_0:
 	default:
-		return PREV_MAX_OUT_WIDTH_ES2;
+		return PREV_MAX_OUT_WIDTH_REV_2;
 
 	case ISP_REVISION_15_0:
-		return PREV_MAX_OUT_WIDTH_3630;
+		return PREV_MAX_OUT_WIDTH_REV_15;
 	}
 }
 
-- 
1.7.3.4

