Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8GEqIg021475
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:52 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8GE23R030942
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:35 -0500
Received: by ey-out-2122.google.com with SMTP id 4so444057eyf.39
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 08:14:34 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:14:31 +0300
Message-Id: <1228752871.1809.94.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH 2/2] radio-mr800: disable autosuspend support
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

Because this device doesn't provide any powermanagment capabilities(may
be they exist but unknown to me yet, so they are not implemented), we
should turn them off.
Patch sets support_autosuspend equal to 0. 

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r bc48582f8776 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Dec 08 17:42:20 2008 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Dec 08 17:45:34 2008 +0300
@@ -169,7 +169,7 @@
 	.reset_resume		= usb_amradio_resume,
 #endif
 	.id_table		= usb_amradio_device_table,
-	.supports_autosuspend	= 1,
+	.supports_autosuspend	= 0,
 };
 
 /* switch on radio. Send 8 bytes to device. */


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
