Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52118 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2DPN3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 4/9] omap3isp: preview: Remove unused isptables_update structure definition
Date: Mon, 16 Apr 2012 15:29:49 +0200
Message-Id: <1334582994-6967-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.h |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.h b/drivers/media/video/omap3isp/isppreview.h
index 67723c7..b7f979a 100644
--- a/drivers/media/video/omap3isp/isppreview.h
+++ b/drivers/media/video/omap3isp/isppreview.h
@@ -121,26 +121,6 @@ struct prev_params {
 	u8 brightness;
 };
 
-/*
- * struct isptables_update - Structure for Table Configuration.
- * @update: Specifies which tables should be updated.
- * @flag: Specifies which tables should be enabled.
- * @nf: Pointer to structure for Noise Filter
- * @lsc: Pointer to LSC gain table. (currently not used)
- * @gamma: Pointer to gamma correction tables.
- * @cfa: Pointer to color filter array configuration.
- * @wbal: Pointer to colour and digital gain configuration.
- */
-struct isptables_update {
-	u32 update;
-	u32 flag;
-	struct omap3isp_prev_nf *nf;
-	u32 *lsc;
-	struct omap3isp_prev_gtables *gamma;
-	struct omap3isp_prev_cfa *cfa;
-	struct omap3isp_prev_wbal *wbal;
-};
-
 /* Sink and source previewer pads */
 #define PREV_PAD_SINK			0
 #define PREV_PAD_SOURCE			1
-- 
1.7.3.4

