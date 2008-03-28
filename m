Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094021.647427486@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:48 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline; filename=simplify-videobuf_waiton-logic.patch
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>
Subject: [patch 4/9] videobuf: Simplify videobuf_waiton logic and possibly
	avoid missed wakeup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Possible missed wakeup- use kernel helpers for wait queues
  http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg27983.html

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |   37 ++++++++++++------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

Index: v4l-dvb/linux/drivers/media/video/videobuf-core.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/videobuf-core.c
+++ v4l-dvb/linux/drivers/media/video/videobuf-core.c
@@ -65,32 +65,25 @@ void *videobuf_alloc(struct videobuf_que
 	return vb;
 }
 
+#define WAITON_CONDITION (vb->state != VIDEOBUF_ACTIVE &&\
+				vb->state != VIDEOBUF_QUEUED)
 int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr)
 {
-	int retval = 0;
-	DECLARE_WAITQUEUE(wait, current);
-
 	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
-	add_wait_queue(&vb->done, &wait);
-	while (vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) {
-		if (non_blocking) {
-			retval = -EAGAIN;
-			break;
-		}
-		set_current_state(intr  ? TASK_INTERRUPTIBLE
-					: TASK_UNINTERRUPTIBLE);
-		if (vb->state == VIDEOBUF_ACTIVE ||
-		    vb->state == VIDEOBUF_QUEUED)
-			schedule();
-		set_current_state(TASK_RUNNING);
-		if (intr && signal_pending(current)) {
-			dprintk(1, "buffer waiton: -EINTR\n");
-			retval = -EINTR;
-			break;
-		}
+
+	if (non_blocking) {
+		if (WAITON_CONDITION)
+			return 0;
+		else
+			return -EAGAIN;
 	}
-	remove_wait_queue(&vb->done, &wait);
-	return retval;
+
+	if (intr)
+		return wait_event_interruptible(vb->done, WAITON_CONDITION);
+	else
+		wait_event(vb->done, WAITON_CONDITION);
+
+	return 0;
 }
 
 int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
