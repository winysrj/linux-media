Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8U0O1up000830
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:24:02 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8U0Nop4009692
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 20:23:51 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1710713fga.7
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 17:23:50 -0700 (PDT)
Message-ID: <30353c3d0809291723i26eb15c1rea55369750d932c9@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:23:43 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: v4l <video4linux-list@redhat.com>,
	"Jaime Velasco Juan" <jsagarribay@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [PATCH 1/3] stkwebcam: fix crash on close after disconnect
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

>From 8d65eca383fffb30259be3a33539ec36b5196c4e Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Mon, 29 Sep 2008 19:59:11 -0400
Subject: [PATCH] stkwebcam: fix crash on close after disconnect


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/video/stk-webcam.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 8dda568..3198549 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -576,7 +576,7 @@ static void stk_clean_iso(struct stk_camera *dev)

 		urb = dev->isobufs[i].urb;
 		if (urb) {
-			if (atomic_read(&dev->urbs_used))
+			if (atomic_read(&dev->urbs_used) && is_present(dev))
 				usb_kill_urb(urb);
 			usb_free_urb(urb);
 		}
@@ -718,19 +718,15 @@ static int v4l_stk_release(struct inode *inode,
struct file *fp)
 		return -ENODEV;
 	}

-	if (dev->owner != fp) {
-		usb_autopm_put_interface(dev->interface);
-		kref_put(&dev->kref, stk_camera_cleanup);
-		return 0;
+	if (dev->owner == fp) {
+		stk_stop_stream(dev);
+		stk_free_buffers(dev);
+		dev->owner = NULL;
 	}

-	stk_stop_stream(dev);
-
-	stk_free_buffers(dev);
-
-	dev->owner = NULL;
+	if(is_present(dev))
+		usb_autopm_put_interface(dev->interface);

-	usb_autopm_put_interface(dev->interface);
 	kref_put(&dev->kref, stk_camera_cleanup);

 	return 0;
-- 
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
