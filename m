Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2DPN3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 2/9] omap3isp: preview: Optimize parameters setup for the common case
Date: Mon, 16 Apr 2012 15:29:47 +0200
Message-Id: <1334582994-6967-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If no parameter needs to be modified, make preview_config() and
preview_setup_hw() return immediately. This speeds up interrupt handling
in the common case.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isppreview.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index cf5014f..4e803a3 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -890,6 +890,8 @@ static int preview_config(struct isp_prev_device *prev,
 	int i, bit, rval = 0;
 
 	params = &prev->params;
+	if (cfg->update == 0)
+		return 0;
 
 	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
 		unsigned long flags;
@@ -944,6 +946,9 @@ static void preview_setup_hw(struct isp_prev_device *prev)
 	int i, bit;
 	void *param_ptr;
 
+	if (prev->update == 0)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
 		attr = &update_attrs[i];
 
-- 
1.7.3.4

