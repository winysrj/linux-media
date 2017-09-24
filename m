Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:55568 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSHh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 14:07:37 -0400
Subject: [PATCH 3/4] [media] omap3isp: Use common error handling code in
 isp_video_open()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Message-ID: <a3bcee14-f5d2-8648-a925-3dfd393e8f55@users.sourceforge.net>
Date: Sun, 24 Sep 2017 20:07:31 +0200
MIME-Version: 1.0
In-Reply-To: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 19:30:52 +0200

* Adjust jump targets so that a bit of exception handling can be better
  reused at the end of this function.

  This issue was detected by using the Coccinelle software.

* Delete a repeated check (for the variable "ret") which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap3isp/ispvideo.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 7b9bd684337a..d4118466fc8a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1315,14 +1315,12 @@ static int isp_video_open(struct file *file)
 	/* If this is the first user, initialise the pipeline. */
 	if (omap3isp_get(video->isp) == NULL) {
 		ret = -EBUSY;
-		goto done;
+		goto delete_fh;
 	}
 
 	ret = v4l2_pipeline_pm_use(&video->video.entity, 1);
-	if (ret < 0) {
-		omap3isp_put(video->isp);
-		goto done;
-	}
+	if (ret < 0)
+		goto put_isp;
 
 	queue = &handle->queue;
 	queue->type = video->type;
@@ -1335,10 +1333,8 @@ static int isp_video_open(struct file *file)
 	queue->dev = video->isp->dev;
 
 	ret = vb2_queue_init(&handle->queue);
-	if (ret < 0) {
-		omap3isp_put(video->isp);
-		goto done;
-	}
+	if (ret < 0)
+		goto put_isp;
 
 	memset(&handle->format, 0, sizeof(handle->format));
 	handle->format.type = video->type;
@@ -1346,14 +1342,15 @@ static int isp_video_open(struct file *file)
 
 	handle->video = video;
 	file->private_data = &handle->vfh;
+	goto exit;
 
-done:
-	if (ret < 0) {
-		v4l2_fh_del(&handle->vfh);
-		v4l2_fh_exit(&handle->vfh);
-		kfree(handle);
-	}
-
+put_isp:
+	omap3isp_put(video->isp);
+delete_fh:
+	v4l2_fh_del(&handle->vfh);
+	v4l2_fh_exit(&handle->vfh);
+	kfree(handle);
+exit:
 	return ret;
 }
 
-- 
2.14.1
