Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55716 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751807AbbKJXgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 18:36:14 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: preview: Mark output buffer done first
Date: Wed, 11 Nov 2015 01:34:18 +0200
Message-Id: <1447198458-12175-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sequence number counter is incremented on each output buffer, and that
incremented value is used as the sequence number of that buffer. The input
buffer sequence numbering is based just on reading the same counter. If
the input buffer is marked done first, its sequence number ends up being
that of the output buffer - 1.

This is how the resizer works as well.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isppreview.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index cfb2debb..1478076 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1480,13 +1480,6 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 	struct isp_buffer *buffer;
 	int restart = 0;
 
-	if (prev->input == PREVIEW_INPUT_MEMORY) {
-		buffer = omap3isp_video_buffer_next(&prev->video_in);
-		if (buffer != NULL)
-			preview_set_inaddr(prev, buffer->dma);
-		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
-	}
-
 	if (prev->output & PREVIEW_OUTPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&prev->video_out);
 		if (buffer != NULL) {
@@ -1496,6 +1489,13 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 		pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
 	}
 
+	if (prev->input == PREVIEW_INPUT_MEMORY) {
+		buffer = omap3isp_video_buffer_next(&prev->video_in);
+		if (buffer != NULL)
+			preview_set_inaddr(prev, buffer->dma);
+		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
+	}
+
 	switch (prev->state) {
 	case ISP_PIPELINE_STREAM_SINGLESHOT:
 		if (isp_pipeline_ready(pipe))
-- 
2.1.4

