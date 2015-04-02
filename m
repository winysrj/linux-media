Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33568 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbbDBLfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 07:35:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 1/3] cx18: add support for control events
Date: Thu,  2 Apr 2015 13:34:29 +0200
Message-Id: <1427974471-24804-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
References: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l2-compliance failed due to missing control event support in cx18.
Add this to the driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-fileops.c | 25 +++++++++++++++++--------
 drivers/media/pci/cx18/cx18-ioctl.c   |  3 +++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index d245445..df83740 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -34,6 +34,7 @@
 #include "cx18-controls.h"
 #include "cx18-ioctl.h"
 #include "cx18-cards.h"
+#include <media/v4l2-event.h>
 
 /* This function tries to claim the stream for a specific file descriptor.
    If no one else is using this stream then the stream is claimed and
@@ -609,13 +610,16 @@ ssize_t cx18_v4l2_read(struct file *filp, char __user *buf, size_t count,
 
 unsigned int cx18_v4l2_enc_poll(struct file *filp, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct cx18_open_id *id = file2id(filp);
 	struct cx18 *cx = id->cx;
 	struct cx18_stream *s = &cx->streams[id->type];
 	int eof = test_bit(CX18_F_S_STREAMOFF, &s->s_flags);
+	unsigned res = 0;
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(CX18_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(CX18_F_S_STREAMING, &s->s_flags) &&
+			(req_events & (POLLIN | POLLRDNORM))) {
 		int rc;
 
 		mutex_lock(&cx->serialize_lock);
@@ -632,21 +636,26 @@ unsigned int cx18_v4l2_enc_poll(struct file *filp, poll_table *wait)
 	if ((s->vb_type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
 		(id->type == CX18_ENC_STREAM_TYPE_YUV)) {
 		int videobuf_poll = videobuf_poll_stream(filp, &s->vbuf_q, wait);
+
+		if (v4l2_event_pending(&id->fh))
+			res |= POLLPRI;
                 if (eof && videobuf_poll == POLLERR)
-                        return POLLHUP;
-                else
-                        return videobuf_poll;
+			return res | POLLHUP;
+		return res | videobuf_poll;
 	}
 
 	/* add stream's waitq to the poll list */
 	CX18_DEBUG_HI_FILE("Encoder poll\n");
-	poll_wait(filp, &s->waitq, wait);
+	if (v4l2_event_pending(&id->fh))
+		res |= POLLPRI;
+	else
+		poll_wait(filp, &s->waitq, wait);
 
 	if (atomic_read(&s->q_full.depth))
-		return POLLIN | POLLRDNORM;
+		return res | POLLIN | POLLRDNORM;
 	if (eof)
-		return POLLHUP;
-	return 0;
+		return res | POLLHUP;
+	return res;
 }
 
 int cx18_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 0230b0f..6f8324d 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -39,6 +39,7 @@
 #include "cx18-cards.h"
 #include "cx18-av-core.h"
 #include <media/tveeprom.h>
+#include <media/v4l2-event.h>
 
 u16 cx18_service2vbi(int type)
 {
@@ -1117,6 +1118,8 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_querybuf                = cx18_querybuf,
 	.vidioc_qbuf                    = cx18_qbuf,
 	.vidioc_dqbuf                   = cx18_dqbuf,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 void cx18_set_funcs(struct video_device *vdev)
-- 
2.1.4

