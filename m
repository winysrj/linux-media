Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9NLtZS028045
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:55 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9NLfVd008979
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:41 -0500
Received: from hypnosis.jim.sh (BUCKET.MIT.EDU [18.90.1.139])
	by psychosis.jim.sh (8.14.3/8.14.3/Debian-5) with SMTP id
	mB9NLcPQ029536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=OK)
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:40 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <c3eafdd5ba7cb667ed30.1228864539@hypnosis.jim>
In-Reply-To: <patchbomb.1228864538@hypnosis.jim>
Date: Tue, 09 Dec 2008 18:15:39 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Subject: [PATCH 1 of 2] gspca: allow subdrivers to handle v4l2_streamparm
	requests
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
# User jim@jtan.com
# Date 1228860341 18000
# Node ID c3eafdd5ba7cb667ed301e7feed6b02b57f1aa7a
# Parent  51458dbe1fdab9f2463a49772fb8be39eabe520c
gspca: allow subdrivers to handle v4l2_streamparm requests

Add get_streamparm and set_streamparm operations so subdrivers can
get/set stream parameters such as framerate.

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r 51458dbe1fda -r c3eafdd5ba7c linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:55:39 2008 -0500
+++ b/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 17:05:41 2008 -0500
@@ -1337,6 +1337,16 @@
 	memset(parm, 0, sizeof *parm);
 	parm->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	parm->parm.capture.readbuffers = gspca_dev->nbufread;
+
+	if (gspca_dev->sd_desc->get_streamparm) {
+		int ret;
+		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+			return -ERESTARTSYS;
+		ret = gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
+		mutex_unlock(&gspca_dev->usb_lock);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1351,6 +1361,16 @@
 		parm->parm.capture.readbuffers = gspca_dev->nbufread;
 	else
 		gspca_dev->nbufread = n;
+
+	if (gspca_dev->sd_desc->set_streamparm) {
+		int ret;
+		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
+			return -ERESTARTSYS;
+		ret = gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
+		mutex_unlock(&gspca_dev->usb_lock);
+		return ret;
+	}
+
 	return 0;
 }
 
diff -r 51458dbe1fda -r c3eafdd5ba7c linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Tue Dec 09 16:55:39 2008 -0500
+++ b/linux/drivers/media/video/gspca/gspca.h	Tue Dec 09 17:05:41 2008 -0500
@@ -74,6 +74,8 @@
 typedef int (*cam_cf_op) (struct gspca_dev *, const struct usb_device_id *);
 typedef int (*cam_jpg_op) (struct gspca_dev *,
 				struct v4l2_jpegcompression *);
+typedef int (*cam_streamparm_op) (struct gspca_dev *, 
+				  struct v4l2_streamparm *);
 typedef int (*cam_qmnu_op) (struct gspca_dev *,
 			struct v4l2_querymenu *);
 typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
@@ -106,6 +108,8 @@
 	cam_jpg_op get_jcomp;
 	cam_jpg_op set_jcomp;
 	cam_qmnu_op querymenu;
+	cam_streamparm_op get_streamparm;
+	cam_streamparm_op set_streamparm;
 };
 
 /* packet types when moving from iso buf to frame buf */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
