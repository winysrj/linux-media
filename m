Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59958 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaHANzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 2/8] omap3isp: ccdc: Only complete buffer when all fields are captured
Date: Fri,  1 Aug 2014 15:46:28 +0200
Message-Id: <1406900794-9871-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking that the captured field corresponds to the last required field
depending on the requested field order before completing the buffer
isn't enough. When the first field at stream start corresponds to the
last required field, this would result in returning an interlaced buffer
containing a single field.

Fix this by keeping track of the fields captured in the buffer, and make
sure that both fields are present for alternate field orders.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 78 ++++++++++++++++++++-----------
 drivers/media/platform/omap3isp/ispccdc.h |  7 +++
 2 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index ecc37f2..56c3129 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1134,6 +1134,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	u32 ccdc_pattern;
 
 	ccdc->bt656 = false;
+	ccdc->fields = 0;
 
 	pad = media_entity_remote_pad(&ccdc->pads[CCDC_PAD_SINK]);
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
@@ -1529,12 +1530,59 @@ done:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 }
 
+/*
+ * Check whether the CCDC has captured all fields necessary to complete the
+ * buffer.
+ */
+static bool ccdc_has_all_fields(struct isp_ccdc_device *ccdc)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
+	struct isp_device *isp = to_isp_device(ccdc);
+	enum v4l2_field of_field = ccdc->formats[CCDC_PAD_SOURCE_OF].field;
+	enum v4l2_field field;
+
+	/* When the input is progressive fields don't matter. */
+	if (of_field == V4L2_FIELD_NONE)
+		return true;
+
+	/* Read the current field identifier. */
+	field = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE)
+	      & ISPCCDC_SYN_MODE_FLDSTAT
+	      ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
+
+	/* When capturing fields in alternate order just store the current field
+	 * identifier in the pipeline.
+	 */
+	if (of_field == V4L2_FIELD_ALTERNATE) {
+		pipe->field = field;
+		return true;
+	}
+
+	/* The format is interlaced. Make sure we've captured both fields. */
+	ccdc->fields |= field == V4L2_FIELD_BOTTOM
+		      ? CCDC_FIELD_BOTTOM : CCDC_FIELD_TOP;
+
+	if (ccdc->fields != CCDC_FIELD_BOTH)
+		return false;
+
+	/* Verify that the field just captured corresponds to the last field
+	 * needed based on the desired field order.
+	 */
+	if ((of_field == V4L2_FIELD_INTERLACED_TB && field == V4L2_FIELD_TOP) ||
+	    (of_field == V4L2_FIELD_INTERLACED_BT && field == V4L2_FIELD_BOTTOM))
+		return false;
+
+	/* The buffer can be completed, reset the fields for the next buffer. */
+	ccdc->fields = 0;
+
+	return true;
+}
+
 static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 {
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccdc);
 	struct isp_buffer *buffer;
-	enum v4l2_field field;
 
 	/* The CCDC generates VD0 interrupts even when disabled (the datasheet
 	 * doesn't explicitly state if that's supposed to happen or not, so it
@@ -1554,11 +1602,6 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 1;
 	}
 
-	/* Read the current field identifier. */
-	field = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE)
-	      & ISPCCDC_SYN_MODE_FLDSTAT
-	      ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
-
 	/* Wait for the CCDC to become idle. */
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
@@ -1567,27 +1610,8 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 0;
 	}
 
-	switch (ccdc->formats[CCDC_PAD_SOURCE_OF].field) {
-	case V4L2_FIELD_ALTERNATE:
-		/* When capturing fields in alternate order store the current
-		 * field identifier in the pipeline.
-		 */
-		pipe->field = field;
-		break;
-
-	case V4L2_FIELD_INTERLACED_TB:
-		/* When interleaving fields only complete the buffer after
-		 * capturing the second field.
-		 */
-		if (field == V4L2_FIELD_TOP)
-			return 1;
-		break;
-
-	case V4L2_FIELD_INTERLACED_BT:
-		if (field == V4L2_FIELD_BOTTOM)
-			return 1;
-		break;
-	}
+	if (!ccdc_has_all_fields(ccdc))
+		return 1;
 
 	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
 	if (buffer != NULL)
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index c325b89..731ecc7 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -93,6 +93,10 @@ struct ispccdc_lsc {
 #define CCDC_PAD_SOURCE_VP		2
 #define CCDC_PADS_NUM			3
 
+#define CCDC_FIELD_TOP			1
+#define CCDC_FIELD_BOTTOM		2
+#define CCDC_FIELD_BOTH			3
+
 /*
  * struct isp_ccdc_device - Structure for the CCDC module to store its own
  *			    information
@@ -114,6 +118,7 @@ struct ispccdc_lsc {
  * @update: Bitmask of controls to update during the next interrupt
  * @shadow_update: Controls update in progress by userspace
  * @bt656: Whether the input interface uses BT.656 synchronization
+ * @fields: The fields (CCDC_FIELD_*) stored in the current buffer
  * @underrun: A buffer underrun occurred and a new buffer has been queued
  * @state: Streaming state
  * @lock: Serializes shadow_update with interrupt handler
@@ -143,6 +148,8 @@ struct isp_ccdc_device {
 	unsigned int shadow_update;
 
 	bool bt656;
+	unsigned int fields;
+
 	unsigned int underrun:1;
 	enum isp_pipeline_stream_state state;
 	spinlock_t lock;
-- 
1.8.5.5

