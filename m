Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYbK9027852
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:37 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAY4mj018492
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:20 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175182fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:20 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <3ac2b9752844e2635575.1206699515@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:35 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 4 of 9] videobuf: Simplify videobuf_waiton logic and possibly
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699278 25200
# Node ID 3ac2b9752844e2635575e50594d50cea665ca09b
# Parent  05ec6ba3e9c3c42cf397ca71b8aefe9573d28c6a
videobuf: Simplify videobuf_waiton logic and possibly avoid missed wakeup

Possible missed wakeup- use kernel helpers for wait queues
  http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg27983.html

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |   37 ++++++++++++------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/linux/drivers/media/video/videobuf-core.c b/linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c
+++ b/linux/drivers/media/video/videobuf-core.c
@@ -65,32 +65,25 @@ void *videobuf_alloc(struct videobuf_que
 	return vb;
 }
 
+#define WAITON_CONDITION (vb->state != VIDEOBUF_ACTIVE &&\
+				vb->state != VIDEOBUF_QUEUED)
 int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr)
 {
-	int retval = 0;
-	DECLARE_WAITQUEUE(wait, current);
+	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
 
-	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);
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
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
