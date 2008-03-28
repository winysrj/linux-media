Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYcoH027881
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:38 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAYF8u018585
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:15 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175260fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:15 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <05ec6ba3e9c3c42cf397.1206699514@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:34 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 3 of 9] videobuf: Wakeup queues after changing the state to
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699277 25200
# Node ID 05ec6ba3e9c3c42cf397ca71b8aefe9573d28c6a
# Parent  d9780aaf14ad2fca7eeaa79f3a8476e5f551ed25
videobuf: Wakeup queues after changing the state to ERROR

The waitqueues must be woken up every time state changes.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/linux/drivers/media/video/videobuf-core.c b/linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c
+++ b/linux/drivers/media/video/videobuf-core.c
@@ -207,6 +207,7 @@ void videobuf_queue_cancel(struct videob
 		if (q->bufs[i]->state == VIDEOBUF_QUEUED) {
 			list_del(&q->bufs[i]->queue);
 			q->bufs[i]->state = VIDEOBUF_ERROR;
+			wake_up_all(&q->bufs[i]->done);
 		}
 	}
 	spin_unlock_irqrestore(q->irqlock, flags);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
