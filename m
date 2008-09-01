Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81IH1pD014124
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 14:17:01 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81IGmwN020310
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 14:16:49 -0400
Message-ID: <48BC3447.1060804@hhs.nl>
Date: Mon, 01 Sep 2008 20:28:23 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: multipart/mixed; boundary="------------070804040601070202060609"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: Priority=high: luca-drivers-parent-fix.patch
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

This is a multi-part message in MIME format.
--------------070804040601070202060609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mauro,

I didn't know through which tree to send this as Luca's drivers are 
unmaintained so I'm sending this directly to you. I would like to see this make 
2.6.27 as without this any cams using Luca's drivers do not work out of the box 
(they require a manual chmod to allow non root access after plugging them in).

###

While doing some testing using Luca Risolia's sonix driver I noticed that
the video device did not get ACL's set to allow access by locally logged in
users, nor does it show up as a video device in lshal, causing cheese to not
see it.

This turns out to be caused by all of Luca Risolia's drivers not setting
the parent member of the video_device struct. This patch fixes this.

Priority: high

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------070804040601070202060609
Content-Type: text/plain;
 name="luca-drivers-parent-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="luca-drivers-parent-fix.patch"

While doing some testing using Luca Risolia's sonix driver I noticed that
the video device did not get ACL's set to allow access by locally logged in
users, nor does it show up as a video device in lshal, causing cheese to not
see it.

This turns out to be caused by all of Luca Risolia's drivers not setting
the parent member of the video_device struct. This patch fixes this.

Priority: high

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 01f8914508b4 linux/drivers/media/video/et61x251/et61x251_core.c
--- a/linux/drivers/media/video/et61x251/et61x251_core.c	Sun Aug 31 19:25:43 2008 +0200
+++ b/linux/drivers/media/video/et61x251/et61x251_core.c	Mon Sep 01 20:20:14 2008 +0200
@@ -2592,6 +2592,7 @@
 	cam->v4ldev->fops = &et61x251_fops;
 	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
+	cam->v4ldev->parent = &udev->dev;
 	video_set_drvdata(cam->v4ldev, cam);
 
 	init_completion(&cam->probe);
diff -r 01f8914508b4 linux/drivers/media/video/sn9c102/sn9c102_core.c
--- a/linux/drivers/media/video/sn9c102/sn9c102_core.c	Sun Aug 31 19:25:43 2008 +0200
+++ b/linux/drivers/media/video/sn9c102/sn9c102_core.c	Mon Sep 01 20:20:14 2008 +0200
@@ -3316,6 +3316,7 @@
 	cam->v4ldev->fops = &sn9c102_fops;
 	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
+	cam->v4ldev->parent = &udev->dev;
 
 	init_completion(&cam->probe);
 
diff -r 01f8914508b4 linux/drivers/media/video/zc0301/zc0301_core.c
--- a/linux/drivers/media/video/zc0301/zc0301_core.c	Sun Aug 31 19:25:43 2008 +0200
+++ b/linux/drivers/media/video/zc0301/zc0301_core.c	Mon Sep 01 20:20:14 2008 +0200
@@ -1992,6 +1992,7 @@
 	cam->v4ldev->fops = &zc0301_fops;
 	cam->v4ldev->minor = video_nr[dev_nr];
 	cam->v4ldev->release = video_device_release;
+	cam->v4ldev->parent = &udev->dev;
 	video_set_drvdata(cam->v4ldev, cam);
 
 	init_completion(&cam->probe);

--------------070804040601070202060609
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070804040601070202060609--
