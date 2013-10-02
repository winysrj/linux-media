Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab3JBNos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 09:44:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: [RFC v2 2/4] v4l: vb2: Only poll for events if the user is interested in them
Date: Wed,  2 Oct 2013 16:45:14 +0300
Message-Id: <1380721516-488-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also poll_wait() before checking the events since otherwise it's possible to
go to sleep and not getting woken up if the event arrives between the two
operations.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 594c75e..79acf5e 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2003,13 +2003,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	unsigned int res = 0;
 	unsigned long flags;
 
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
+	    req_events & POLLPRI) {
 		struct v4l2_fh *fh = file->private_data;
 
+		poll_wait(file, &fh->wait, wait);
+
 		if (v4l2_event_pending(fh))
 			res = POLLPRI;
-		else if (req_events & POLLPRI)
-			poll_wait(file, &fh->wait, wait);
 	}
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
-- 
1.8.3.2

