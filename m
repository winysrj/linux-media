Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2GMLhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 1/6] omap3isp: preview: Fix contrast and brightness handling
Date: Fri, 13 Jul 2012 13:37:33 +0200
Message-Id: <1342179458-1037-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit bac387efbb88cf0e8df6f46a38387897cea464ee ("omap3isp: preview:
Simplify configuration parameters access") added three fields to the
preview_update structure, but failed to properly update the related
initializers. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 99d5cc4..a06af90 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -888,12 +888,12 @@ static const struct preview_update update_attrs[] = {
 		preview_config_contrast,
 		NULL,
 		offsetof(struct prev_params, contrast),
-		0, true,
+		0, 0, true,
 	}, /* OMAP3ISP_PREV_BRIGHTNESS */ {
 		preview_config_brightness,
 		NULL,
 		offsetof(struct prev_params, brightness),
-		0, true,
+		0, 0, true,
 	},
 };
 
-- 
1.7.8.6

