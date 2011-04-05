Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1DEH5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:14 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 01CA735B6C
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/14] omap3isp: Fix trivial typos
Date: Tue,  5 Apr 2011 09:57:27 +0200
Message-Id: <1301990256-6963-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Michael Jones <michael.jones@matrix-vision.de>

It doesn't get more trivial than these.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3isp/isp.c        |    4 ++--
 drivers/media/video/omap3isp/ispccdc.c    |    4 ++--
 drivers/media/video/omap3isp/isppreview.c |    2 +-
 drivers/media/video/omap3isp/ispqueue.c   |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 1a9963bd..7d68b10 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -715,7 +715,7 @@ static int isp_pipeline_link_notify(struct media_pad *source,
  * Walk the entities chain starting at the pipeline output video node and start
  * all modules in the chain in the given mode.
  *
- * Return 0 if successfull, or the return value of the failed video::s_stream
+ * Return 0 if successful, or the return value of the failed video::s_stream
  * operation otherwise.
  */
 static int isp_pipeline_enable(struct isp_pipeline *pipe,
@@ -883,7 +883,7 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
  * Set the pipeline to the given stream state. Pipelines can be started in
  * single-shot or continuous mode.
  *
- * Return 0 if successfull, or the return value of the failed video::s_stream
+ * Return 0 if successful, or the return value of the failed video::s_stream
  * operation otherwise.
  */
 int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 5ff9d14..fd811ea 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1338,7 +1338,7 @@ static int ccdc_sbl_wait_idle(struct isp_ccdc_device *ccdc,
  * @ccdc: Pointer to ISP CCDC device.
  * @event: Pointing which event trigger handler
  *
- * Return 1 when the event and stopping request combination is satisfyied,
+ * Return 1 when the event and stopping request combination is satisfied,
  * zero otherwise.
  */
 static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
@@ -1618,7 +1618,7 @@ static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 
 	ccdc_set_outaddr(ccdc, buffer->isp_addr);
 
-	/* We now have a buffer queued on the output, restart the pipeline in
+	/* We now have a buffer queued on the output, restart the pipeline
 	 * on the next CCDC interrupt if running in continuous mode (or when
 	 * starting the stream).
 	 */
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index baf9374..6af0f23 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -755,7 +755,7 @@ static struct preview_update update_attrs[] = {
  * @configs - pointer to update config structure.
  * @config - return pointer to appropriate structure field.
  * @bit - for which feature to return pointers.
- * Return size of coresponding prev_params member
+ * Return size of corresponding prev_params member
  */
 static u32
 __preview_get_ptrs(struct prev_params *params, void **param,
diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/video/omap3isp/ispqueue.c
index 8fddc58..c91e56a 100644
--- a/drivers/media/video/omap3isp/ispqueue.c
+++ b/drivers/media/video/omap3isp/ispqueue.c
@@ -408,8 +408,8 @@ done:
  * isp_video_buffer_prepare_vm_flags - Get VMA flags for a userspace address
  *
  * This function locates the VMAs for the buffer's userspace address and checks
- * that their flags match. The onlflag that we need to care for at the moment is
- * VM_PFNMAP.
+ * that their flags match. The only flag that we need to care for at the moment
+ * is VM_PFNMAP.
  *
  * The buffer vm_flags field is set to the first VMA flags.
  *
-- 
1.7.3.4

