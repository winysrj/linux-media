Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35675 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab3JBNot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 09:44:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: [RFC v2 3/4] v4l: vb2: Return POLLERR when polling for events and none are subscribed
Date: Wed,  2 Oct 2013 16:45:15 +0300
Message-Id: <1380721516-488-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current implementation allowed polling for events even if none were
subscribed. This may be troublesome in multi-threaded applications where the
thread handling the subscription is different from the one that handles the
events.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 79acf5e..c5dc903 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2011,6 +2011,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
 		if (v4l2_event_pending(fh))
 			res = POLLPRI;
+
+		if (!v4l2_event_has_subscribed(fh))
+			return POLLERR | POLLPRI;
 	}
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
-- 
1.8.3.2

