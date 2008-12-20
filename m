Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK39FkB026842
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:15 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK392H4011435
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:03 -0500
Received: by nf-out-0910.google.com with SMTP id d3so179692nfc.21
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:09:02 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:09:17 +0300
Message-Id: <1229742557.10297.109.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 1/5] dsbr100: place dev_warn instead of printk
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

Remove printk and place dev_warn here.

---
diff -r 16be154a760e linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Fri Dec 19 14:25:30 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Fri Dec 19 14:34:18 2008 +0300
@@ -498,7 +498,8 @@
 	retval = dsbr100_setfreq(radio, radio->curfreq);
 
 	if (retval == -1)
-		printk(KERN_WARNING KBUILD_MODNAME ": Set frequency failed\n");
+		dev_warn(&radio->usbdev->dev,
+			"set frequency failed\n");
 
 	unlock_kernel();
 	return 0;


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
