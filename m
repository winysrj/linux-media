Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46355 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2C1MAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 08:00:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2 3/4] omap3isp: preview: Remove averager parameter update flag
Date: Wed, 28 Mar 2012 14:00:00 +0200
Message-Id: <1332936001-32603-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The flag isn't used, remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 0968660..67723c7 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -66,8 +66,7 @@
 
 #define PREV_CONTRAST			(1 << 17)
 #define PREV_BRIGHTNESS			(1 << 18)
-#define PREV_AVERAGER			(1 << 19)
-#define PREV_FEATURES_END		(1 << 20)
+#define PREV_FEATURES_END		(1 << 19)
 
 enum preview_input_entity {
 	PREVIEW_INPUT_NONE,
-- 
1.7.3.4

