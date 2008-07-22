Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MFSXsf021398
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 11:28:33 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MFSML2015708
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 11:28:22 -0400
Received: by nf-out-0910.google.com with SMTP id d3so688821nfc.21
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 08:28:21 -0700 (PDT)
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: mchehab@infradead.org
Date: Tue, 22 Jul 2008 16:28:36 +0100
Message-Id: <1216740516-4223-1-git-send-email-jsagarribay@gmail.com>
Cc: video4linux-list@redhat.com
Subject: [PATCH resend] stkwebcam: Always reuse last queued buffer
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

This change keeps the video stream going on when the application
is slow queuing buffers, instead of spamming dmesg and hanging.

Fixes a problem with aMSN reported by Samed Beyribey <beyribey@gmail.com>

Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
---

Hi, this is the third time I send this patch, is there any problem with it?

Regards,
Jaime

 drivers/media/video/stk-webcam.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index f308c38..fce5d63 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -442,18 +442,19 @@ static void stk_isoc_handler(struct urb *urb)
 				fb->v4lbuf.bytesused = 0;
 				fill = fb->buffer;
 			} else if (fb->v4lbuf.bytesused == dev->frame_size) {
-				list_move_tail(dev->sio_avail.next,
-					&dev->sio_full);
-				wake_up(&dev->wait_frame);
-				if (list_empty(&dev->sio_avail)) {
-					(void) (printk_ratelimit() &&
-					STK_ERROR("No buffer available\n"));
-					goto resubmit;
+				if (list_is_singular(&dev->sio_avail)) {
+					/* Always reuse the last buffer */
+					fb->v4lbuf.bytesused = 0;
+					fill = fb->buffer;
+				} else {
+					list_move_tail(dev->sio_avail.next,
+						&dev->sio_full);
+					wake_up(&dev->wait_frame);
+					fb = list_first_entry(&dev->sio_avail,
+						struct stk_sio_buffer, list);
+					fb->v4lbuf.bytesused = 0;
+					fill = fb->buffer;
 				}
-				fb = list_first_entry(&dev->sio_avail,
-					struct stk_sio_buffer, list);
-				fb->v4lbuf.bytesused = 0;
-				fill = fb->buffer;
 			}
 		} else {
 			framelen -= 4;
-- 
1.5.6.2

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
