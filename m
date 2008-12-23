Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNJuplk007236
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 14:56:52 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBNJu8II017370
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 14:56:15 -0500
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id B13CD3EA245
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 20:56:07 +0100 (CET)
Received: from [192.168.0.13] (lns-bzn-45-82-65-165-118.adsl.proxad.net
	[82.65.165.118])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 1A4783EA20F
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 20:56:06 +0100 (CET)
From: Jean-Francois Moine <moinejf@free.fr>
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 23 Dec 2008 20:54:38 +0100
Message-Id: <1230062078.1699.56.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] Wrong returned value of __video_ioctl2()
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

This patch suppresses the warning on setting the dev_fops unlocked_ioctl
function to __video_ioctl2.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

diff -r c7b89ff3a3df linux/drivers/media/video/v4l2-ioctl.c
--- a/linux/drivers/media/video/v4l2-ioctl.c	Tue Dec 23 19:57:17 2008 +0100
+++ b/linux/drivers/media/video/v4l2-ioctl.c	Tue Dec 23 20:42:08 2008 +0100
@@ -1853,7 +1853,7 @@
 	return ret;
 }
 
-int __video_ioctl2(struct file *file,
+long __video_ioctl2(struct file *file,
 	       unsigned int cmd, unsigned long arg)
 {
 	char	sbuf[128];
diff -r c7b89ff3a3df linux/include/media/v4l2-ioctl.h
--- a/linux/include/media/v4l2-ioctl.h	Tue Dec 23 19:57:17 2008 +0100
+++ b/linux/include/media/v4l2-ioctl.h	Tue Dec 23 20:42:08 2008 +0100
@@ -297,7 +297,7 @@
 /* Standard handlers for V4L ioctl's */
 
 /* This prototype is used on fops.unlocked_ioctl */
-extern int __video_ioctl2(struct file *file,
+extern long __video_ioctl2(struct file *file,
 			unsigned int cmd, unsigned long arg);
 
 /* This prototype is used on fops.ioctl

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
