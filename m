Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK39RGb026904
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:27 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK38dLw011331
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:13 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so1312232ewy.3
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:09:13 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:09:28 +0300
Message-Id: <1229742568.10297.115.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 3/5] dsbr100: dev_err insted of dev_warn
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

We should use dev_err here.

---
diff -r 5fad9278bd8e linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 02:33:51 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 02:48:48 2008 +0300
@@ -670,7 +670,7 @@
 	video_set_drvdata(&radio->videodev, radio);
 	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
 	if (retval < 0) {
-		dev_warn(&intf->dev, "Could not register video device\n");
+		dev_err(&intf->dev, "couldn't register video device\n");
 		kfree(radio->transfer_buffer);
 		kfree(radio);
 		return -EIO;

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
