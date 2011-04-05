Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1DEH5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:15 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9AB0235B6F
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:11 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/14] omap3isp: isp: Reset the ISP when the pipeline can't be stopped
Date: Tue,  5 Apr 2011 09:57:30 +0200
Message-Id: <1301990256-6963-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When a failure to stop a module in the pipeline is detected, the only
way to recover is to reset the ISP. However, as other users can be using
a different pipeline with other modules, the ISP can't be reset
synchronously with the error detection.

Mark the ISP as needing a reset when a failure to stop a pipeline is
detected, and reset the ISP when the last user releases the last
reference to the ISP.

Modify the omap3isp_pipeline_set_stream() function to record the new ISP
pipeline state only when no error occurs, except when stopping the
pipeline in which case the pipeline is still marked as stopped.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isp.c |   14 ++++++++++++--
 drivers/media/video/omap3isp/isp.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 7d68b10..f380f09 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -872,6 +872,9 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		}
 	}
 
+	if (failure < 0)
+		isp->needs_reset = true;
+
 	return failure;
 }
 
@@ -884,7 +887,8 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
  * single-shot or continuous mode.
  *
  * Return 0 if successful, or the return value of the failed video::s_stream
- * operation otherwise.
+ * operation otherwise. The pipeline state is not updated when the operation
+ * fails, except when stopping the pipeline.
  */
 int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 				 enum isp_pipeline_stream_state state)
@@ -895,7 +899,9 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 		ret = isp_pipeline_disable(pipe);
 	else
 		ret = isp_pipeline_enable(pipe, state);
-	pipe->stream_state = state;
+
+	if (ret == 0 || state == ISP_PIPELINE_STREAM_STOPPED)
+		pipe->stream_state = state;
 
 	return ret;
 }
@@ -1481,6 +1487,10 @@ void omap3isp_put(struct isp_device *isp)
 	if (--isp->ref_count == 0) {
 		isp_disable_interrupts(isp);
 		isp_save_ctx(isp);
+		if (isp->needs_reset) {
+			isp_reset(isp);
+			isp->needs_reset = false;
+		}
 		isp_disable_clocks(isp);
 	}
 	mutex_unlock(&isp->isp_mutex);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index cf5214e..5f87645 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -262,6 +262,7 @@ struct isp_device {
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
+	bool needs_reset;
 	int has_context;
 	int ref_count;
 	unsigned int autoidle;
-- 
1.7.3.4

