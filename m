Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2818 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3A3SBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 13:01:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] vb2_poll: don't return POLLERR when testing for event only
Date: Wed, 30 Jan 2013 19:01:25 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, s.nawrocki@samsung.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301301901.25102.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found this while testing the vb2 conversion of bw-qcam. Without this change
select() will always return when polling for events only.

If you only poll for events, then vb2_poll will return 'res | POLLERR' if
no streaming is in progress. That's not right, it's perfectly valid to
poll just for events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

---
 drivers/media/v4l2-core/videobuf2-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d09be38..db1235d 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1965,6 +1965,11 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 			poll_wait(file, &fh->wait, wait);
 	}
 
+	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLOUT | POLLWRNORM)))
+		return res;
+
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
-- 
1.7.10.4

