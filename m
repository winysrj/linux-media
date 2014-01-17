Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.218]:33803 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbaAQThy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 14:37:54 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH] [media] omap3isp: preview: Fix the crop margins
Date: Fri, 17 Jan 2014 20:37:38 +0100
Message-Id: <1389987458-7174-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 3fdfedaaa "[media] omap3isp: preview: Lower the crop margins"
accidentally changed the previewer's cropping, causing the previewer
to miss four pixels on each line, thus corrupting the final image.
Restored the removed setting.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isppreview.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index cd8831a..e2e4610 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1079,6 +1079,7 @@ static void preview_config_input_format(struct isp_prev_device *prev,
  */
 static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 {
+	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
 	struct isp_device *isp = to_isp_device(prev);
 	unsigned int sph = prev->crop.left;
 	unsigned int eph = prev->crop.left + prev->crop.width - 1;
@@ -1086,6 +1087,14 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
+	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
+	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
+		sph -= 2;
+		eph += 2;
+		slv -= 2;
+		elv += 2;
+	}
+
 	features = (prev->params.params[0].features & active)
 		 | (prev->params.params[1].features & ~active);
 
-- 
1.8.1.2

