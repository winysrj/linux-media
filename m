Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:17071 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZCNVZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 17:25:25 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LicQU-0002ms-0j
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sat, 14 Mar 2009 23:33:54 +0100
Date: Sat, 14 Mar 2009 22:25:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] Update remaining references to old video4linux list
Message-ID: <20090314222514.7a2b44f6@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video4linux-list@redhat.com list is deprecated, point the users to
the new linux-media list instead.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/Documentation/video4linux/bttv/README  |    4 ++--
 linux/drivers/media/radio/radio-si470x.c     |    4 ++--
 linux/drivers/media/video/bt8xx/bttv-cards.c |    2 +-
 v4l/scripts/make_kconfig.pl                  |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- v4l-dvb.orig/linux/Documentation/video4linux/bttv/README	2009-03-01 16:09:08.000000000 +0100
+++ v4l-dvb/linux/Documentation/video4linux/bttv/README	2009-03-14 22:13:43.000000000 +0100
@@ -63,8 +63,8 @@ If you have some knowledge and spare tim
 yourself (patches very welcome of course...)  You know: The linux
 slogan is "Do it yourself".
 
-There is a mailing list: video4linux-list@redhat.com.
-https://listman.redhat.com/mailman/listinfo/video4linux-list
+There is a mailing list: linux-media@vger.kernel.org.
+http://vger.kernel.org/vger-lists.html#linux-media
 
 If you have trouble with some specific TV card, try to ask there
 instead of mailing me directly.  The chance that someone with the
--- v4l-dvb.orig/linux/drivers/media/radio/radio-si470x.c	2009-03-04 09:52:51.000000000 +0100
+++ v4l-dvb/linux/drivers/media/radio/radio-si470x.c	2009-03-14 22:12:55.000000000 +0100
@@ -1713,8 +1713,8 @@ static int si470x_usb_driver_probe(struc
 		printk(KERN_WARNING DRIVER_NAME
 			": If you have some trouble using this driver,\n");
 		printk(KERN_WARNING DRIVER_NAME
-			": please report to V4L ML at "
-			"video4linux-list@redhat.com\n");
+			": please report to linux-media ML at "
+			"linux-media@vger.kernel.org\n");
 	}
 
 	/* set initial frequency */
--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-cards.c	2009-03-13 09:59:49.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-cards.c	2009-03-14 22:13:08.000000000 +0100
@@ -2953,7 +2953,7 @@ void __devinit bttv_idcard(struct bttv *
 			       btv->c.nr, btv->cardid & 0xffff,
 			       (btv->cardid >> 16) & 0xffff);
 			printk(KERN_DEBUG "please mail id, board name and "
-			       "the correct card= insmod option to video4linux-list@redhat.com\n");
+			       "the correct card= insmod option to linux-media@vger.kernel.org\n");
 		}
 	}
 
--- v4l-dvb.orig/v4l/scripts/make_kconfig.pl	2009-03-14 19:57:47.000000000 +0100
+++ v4l-dvb/v4l/scripts/make_kconfig.pl	2009-03-14 22:14:28.000000000 +0100
@@ -576,8 +576,8 @@ config VIDEO_KERNEL_VERSION
 	  requiring a newer kernel is that no one has tested them with an
 	  older one yet.
 
-	   If the driver works, please post a report at V4L mailing list:
-			video4linux-list\@redhat.com.
+	  If the driver works, please post a report at linux-media mailing
+	  list: linux-media\@vger.kernel.org.
 
 	  Unless you know what you are doing, you should answer N.
 


-- 
Jean Delvare
