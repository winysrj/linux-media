Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m657oSlg005811
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 03:50:28 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m657oGpG020458
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 03:50:16 -0400
Received: by ik-out-1112.google.com with SMTP id c30so744142ika.3
	for <video4linux-list@redhat.com>; Sat, 05 Jul 2008 00:50:15 -0700 (PDT)
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: v4l-dvb-maintainer@linuxtv.org
Date: Sat,  5 Jul 2008 08:50:29 +0100
Message-Id: <1215244229-4946-1-git-send-email-jsagarribay@gmail.com>
Cc: beyribey@gmail.com, video4linux-list@redhat.com
Subject: [PATCH] stkwebcam: Always reuse last queued buffer
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

Mauro, if it isn't too late, please apply to 2.6.26

 drivers/media/video/stk-webcam.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index b12c60c..1eb4d72 100644
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
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
