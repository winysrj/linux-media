Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094021.513463447@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:47 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline; filename=wakeup-on-queue-cancel.patch
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>
Subject: [patch 3/9] videobuf: Wakeup queues after changing the state to
	ERROR
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

The waitqueues must be woken up every time state changes.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |    1 +
 1 file changed, 1 insertion(+)

Index: v4l-dvb/linux/drivers/media/video/videobuf-core.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/videobuf-core.c
+++ v4l-dvb/linux/drivers/media/video/videobuf-core.c
@@ -207,6 +207,7 @@ void videobuf_queue_cancel(struct videob
 		if (q->bufs[i]->state == VIDEOBUF_QUEUED) {
 			list_del(&q->bufs[i]->queue);
 			q->bufs[i]->state = VIDEOBUF_ERROR;
+			wake_up_all(&q->bufs[i]->done);
 		}
 	}
 	spin_unlock_irqrestore(q->irqlock, flags);

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
