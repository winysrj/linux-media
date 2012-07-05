Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2GERpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 13:45:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi,
	Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Subject: [PATCH] omap3isp: preview: Fix output size computation depending on input format
Date: Thu,  5 Jul 2012 19:45:34 +0200
Message-Id: <1341510334-9791-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The preview engine crops 4 columns and 4 lines when CFA is enabled.
Commit b2da46e52fe7871cba36e1a435844502c0eccf39 ("omap3isp: preview: Add
support for greyscale input") inverted the condition by mistake, fix
this.

Reported-by: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This is a v3.5 regression, I'll send a pull request in the next couple of
days.

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 8a4935e..a48a747 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1102,7 +1102,7 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
+	if (format->code != V4L2_MBUS_FMT_Y10_1X10) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
-- 
Regards,

Laurent Pinchart

