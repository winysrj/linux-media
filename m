Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55863 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbbBPKta (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 05:49:30 -0500
Message-ID: <54E1CB23.3050206@xs4all.nl>
Date: Mon, 16 Feb 2015 11:49:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jurgen Kramer <gtmkramer@xs4all.nl>
Subject: [PATCH for v3.20] vb2: fix 'UNBALANCED' warnings when calling vb2_thread_stop()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stopping the vb2 thread (as used by several DVB devices) can result
in an 'UNBALANCED' warning such as this:

vb2: counters for queue ffff880407ee9828: UNBALANCED!
vb2:     setup: 1 start_streaming: 1 stop_streaming: 1
vb2:     wait_prepare: 249333 wait_finish: 249334

This is due to a race condition between stopping the thread and
calling vb2_internal_streamoff(). While I have not been able to deduce
the exact mechanism how this race condition can produce this warning,
I can see that the way the stream is stopped is likely to lead to a
race somewhere.

This patch simplifies how this is done by first ensuring that the
thread is completely stopped before cleaning up the vb2 queue. It
does that by setting threadio->stop to true, followed by a call to
vb2_queue_error() which will wake up the thread. The thread sees that
'stop' is true and it will exit.

The call to kthread_stop() waits until the thread has exited, and only
then is the queue cleaned up by calling __vb2_cleanup_fileio().

This is a much cleaner sequence and the warning has now disappeared.

Reported-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Tested-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v3.18 and up
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bc08a82..cc16e76 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3230,18 +3230,13 @@ int vb2_thread_stop(struct vb2_queue *q)
 
 	if (threadio == NULL)
 		return 0;
-	call_void_qop(q, wait_finish, q);
 	threadio->stop = true;
-	vb2_internal_streamoff(q, q->type);
-	call_void_qop(q, wait_prepare, q);
+	/* Wake up all pending sleeps in the thread */
+	vb2_queue_error(q);
 	err = kthread_stop(threadio->thread);
-	q->fileio = NULL;
-	fileio->req.count = 0;
-	vb2_reqbufs(q, &fileio->req);
-	kfree(fileio);
+	__vb2_cleanup_fileio(q);
 	threadio->thread = NULL;
 	kfree(threadio);
-	q->fileio = NULL;
 	q->threadio = NULL;
 	return err;
 }
-- 
2.1.4

