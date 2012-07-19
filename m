Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:11907 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2GSMAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:53 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 3/6] v4l2-mem2mem: support events in v4l2_m2m_poll.
Date: Thu, 19 Jul 2012 14:00:21 +0200
Message-Id: <3c54845122c69b570236a6e2200b2697202b85e8.1342699069.git.hans.verkuil@cisco.com>
In-Reply-To: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
References: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
References: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_poll didn't support events, but that's essential if you want to
be able to use control events for example.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-mem2mem.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
index 975d0fa..97b4831 100644
--- a/drivers/media/video/v4l2-mem2mem.c
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -19,6 +19,9 @@
 
 #include <media/videobuf2-core.h>
 #include <media/v4l2-mem2mem.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 MODULE_DESCRIPTION("Mem to mem device framework for videobuf");
 MODULE_AUTHOR("Pawel Osciak, <pawel@osciak.com>");
@@ -407,11 +410,24 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
 unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			   struct poll_table_struct *wait)
 {
+	struct video_device *vfd = video_devdata(file);
+	unsigned long req_events = poll_requested_events(wait);
 	struct vb2_queue *src_q, *dst_q;
 	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
 	unsigned int rc = 0;
 	unsigned long flags;
 
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		if (v4l2_event_pending(fh))
+			rc = POLLPRI;
+		else if (req_events & POLLPRI)
+			poll_wait(file, &fh->wait, wait);
+		if (!(req_events & (POLLOUT | POLLWRNORM | POLLIN | POLLRDNORM)))
+			return rc;
+	}
+
 	src_q = v4l2_m2m_get_src_vq(m2m_ctx);
 	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
 
@@ -422,7 +438,7 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	 */
 	if ((!src_q->streaming || list_empty(&src_q->queued_list))
 		&& (!dst_q->streaming || list_empty(&dst_q->queued_list))) {
-		rc = POLLERR;
+		rc |= POLLERR;
 		goto end;
 	}
 
-- 
1.7.10

