Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:47244 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0KSNXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:23:16 -0500
From: David Cohen <david.cohen@nokia.com>
To: lane@brooks.nu
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	David Cohen <david.cohen@nokia.com>
Subject: [omap3isp][PATCH] omap3isp: does not allow pipeline with multiple video outputs yet
Date: Fri, 19 Nov 2010 15:23:54 +0200
Message-Id: <1290173034-11257-1-git-send-email-david.cohen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

OMAP3 ISP driver does not support pipeline with multiple video outputs yet.
Driver must return -EBUSY in this case.

Signed-off-by: David Cohen <david.cohen@nokia.com>
---
 drivers/media/video/isp/ispccdc.c    |   26 ++++++++++++++++++++------
 drivers/media/video/isp/ispcsi2.c    |   19 +++++++++++++++----
 drivers/media/video/isp/isppreview.c |   19 +++++++++++++++----
 3 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index a4c6444..a19795c 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -2016,30 +2016,44 @@ static int ccdc_link_setup(struct media_entity *entity,
 
 		break;
 
+	/*
+	 * This driver currently does not support pipeline with multiples
+	 * video outputs. It must return -EBUSY while it's not implemented.
+	 */
+
 	case CCDC_PAD_SOURCE_VP | (MEDIA_ENTITY_TYPE_SUBDEV << 16):
 		/* Write to preview engine, histogram and H3A. When none of
 		 * those links are active, the video port can be disabled.
 		 */
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (ccdc->output & ~CCDC_OUTPUT_PREVIEW)
+				return -EBUSY;
 			ccdc->output |= CCDC_OUTPUT_PREVIEW;
-		else
+		} else {
 			ccdc->output &= ~CCDC_OUTPUT_PREVIEW;
+		}
 		break;
 
 	case CCDC_PAD_SOURCE_OF | (MEDIA_ENTITY_TYPE_NODE << 16):
 		/* Write to memory */
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (ccdc->output & ~CCDC_OUTPUT_MEMORY)
+				return -EBUSY;
 			ccdc->output |= CCDC_OUTPUT_MEMORY;
-		else
+		} else {
 			ccdc->output &= ~CCDC_OUTPUT_MEMORY;
+		}
 		break;
 
 	case CCDC_PAD_SOURCE_OF | (MEDIA_ENTITY_TYPE_SUBDEV << 16):
 		/* Write to resizer */
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (ccdc->output & ~CCDC_OUTPUT_RESIZER)
+				return -EBUSY;
 			ccdc->output |= CCDC_OUTPUT_RESIZER;
-		else
+		} else {
 			ccdc->output &= ~CCDC_OUTPUT_RESIZER;
+		}
 		break;
 
 	default:
diff --git a/drivers/media/video/isp/ispcsi2.c b/drivers/media/video/isp/ispcsi2.c
index 65c777a..8052b38 100644
--- a/drivers/media/video/isp/ispcsi2.c
+++ b/drivers/media/video/isp/ispcsi2.c
@@ -1088,19 +1088,30 @@ static int csi2_link_setup(struct media_entity *entity,
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct isp_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
 
+	/*
+	 * This driver currently does not support pipeline with multiples
+	 * video outputs. It must return -EBUSY while it's not implemented.
+	 */
+
 	switch (local->index | (remote->entity->type << 16)) {
 	case CSI2_PAD_SOURCE | (MEDIA_ENTITY_TYPE_NODE << 16):
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
+				return -EBUSY;
 			csi2->output |= CSI2_OUTPUT_MEMORY;
-		else
+		} else {
 			csi2->output &= ~CSI2_OUTPUT_MEMORY;
+		}
 		break;
 
 	case CSI2_PAD_SOURCE | (MEDIA_ENTITY_TYPE_SUBDEV << 16):
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
+				return -EBUSY;
 			csi2->output |= CSI2_OUTPUT_CCDC;
-		else
+		} else {
 			csi2->output &= ~CSI2_OUTPUT_CCDC;
+		}
 		break;
 
 	default:
diff --git a/drivers/media/video/isp/isppreview.c b/drivers/media/video/isp/isppreview.c
index 6274b44..39d4da4 100644
--- a/drivers/media/video/isp/isppreview.c
+++ b/drivers/media/video/isp/isppreview.c
@@ -2026,20 +2026,31 @@ static int preview_link_setup(struct media_entity *entity,
 		}
 		break;
 
+	/*
+	 * This driver currently does not support pipeline with multiples
+	 * video outputs. It must return -EBUSY while it's not implemented.
+	 */
+
 	case PREV_PAD_SOURCE | (MEDIA_ENTITY_TYPE_NODE << 16):
 		/* write to memory */
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (prev->output & ~PREVIEW_OUTPUT_MEMORY)
+				return -EBUSY;
 			prev->output |= PREVIEW_OUTPUT_MEMORY;
-		else
+		} else {
 			prev->output &= ~PREVIEW_OUTPUT_MEMORY;
+		}
 		break;
 
 	case PREV_PAD_SOURCE | (MEDIA_ENTITY_TYPE_SUBDEV << 16):
 		/* write to resizer */
-		if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+			if (prev->output & ~PREVIEW_OUTPUT_RESIZER)
+				return -EBUSY;
 			prev->output |= PREVIEW_OUTPUT_RESIZER;
-		else
+		} else {
 			prev->output &= ~PREVIEW_OUTPUT_RESIZER;
+		}
 		break;
 
 	default:
-- 
1.7.2.3

