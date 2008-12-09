Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9Lwq6H018920
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:58:52 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9LwdV5028775
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:58:39 -0500
Date: Tue, 9 Dec 2008 16:58:37 -0500
From: Jim Paris <jim@jtan.com>
To: Jean-Francois Moine <moinejf@free.fr>
Message-ID: <20081209215837.GA24743@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: gspca: fix vidioc_s_jpegcomp locking
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

This locking looked wrong.

-jim

--

gspca: fix vidioc_s_jpegcomp locking

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r b50857fea6df linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:20:31 2008 -0500
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:55:39 2008 -0500
@@ -1320,10 +1320,10 @@
 	struct gspca_dev *gspca_dev = priv;
 	int ret;
 
+	if (!gspca_dev->sd_desc->set_jcomp)
+		return -EINVAL;
 	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 		return -ERESTARTSYS;
-	if (!gspca_dev->sd_desc->set_jcomp)
-		return -EINVAL;
 	ret = gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
 	mutex_unlock(&gspca_dev->usb_lock);
 	return ret;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
