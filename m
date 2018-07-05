Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:41327 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753429AbeGENdV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 09:33:21 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 12/34] media: camss: vfe: Get line pointer as container of video_out
Date: Thu,  5 Jul 2018 16:32:43 +0300
Message-Id: <1530797585-8555-13-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
References: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify getting of the line pointer by using the container_of
macro instead of traversing media controller links.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 38 +++------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 51ad3f8..77167f1 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -2038,26 +2038,6 @@ static void vfe_put(struct vfe_device *vfe)
 }
 
 /*
- * vfe_video_pad_to_line - Get pointer to VFE line by media pad
- * @pad: Media pad
- *
- * Return pointer to vfe line structure
- */
-static struct vfe_line *vfe_video_pad_to_line(struct media_pad *pad)
-{
-	struct media_pad *vfe_pad;
-	struct v4l2_subdev *subdev;
-
-	vfe_pad = media_entity_remote_pad(pad);
-	if (vfe_pad == NULL)
-		return NULL;
-
-	subdev = media_entity_to_v4l2_subdev(vfe_pad->entity);
-
-	return container_of(subdev, struct vfe_line, subdev);
-}
-
-/*
  * vfe_queue_buffer - Add empty buffer
  * @vid: Video device structure
  * @buf: Buffer to be enqueued
@@ -2070,16 +2050,11 @@ static struct vfe_line *vfe_video_pad_to_line(struct media_pad *pad)
 static int vfe_queue_buffer(struct camss_video *vid,
 			    struct camss_buffer *buf)
 {
-	struct vfe_device *vfe = &vid->camss->vfe;
-	struct vfe_line *line;
+	struct vfe_line *line = container_of(vid, struct vfe_line, video_out);
+	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
 
-	line = vfe_video_pad_to_line(&vid->pad);
-	if (!line) {
-		dev_err(to_device(vfe), "Can not queue buffer\n");
-		return -1;
-	}
 	output = &line->output;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
@@ -2104,16 +2079,11 @@ static int vfe_queue_buffer(struct camss_video *vid,
 static int vfe_flush_buffers(struct camss_video *vid,
 			     enum vb2_buffer_state state)
 {
-	struct vfe_device *vfe = &vid->camss->vfe;
-	struct vfe_line *line;
+	struct vfe_line *line = container_of(vid, struct vfe_line, video_out);
+	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output;
 	unsigned long flags;
 
-	line = vfe_video_pad_to_line(&vid->pad);
-	if (!line) {
-		dev_err(to_device(vfe),	"Can not flush buffers\n");
-		return -1;
-	}
 	output = &line->output;
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
-- 
2.7.4
