Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50143 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbZDAVBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 17:01:08 -0400
Received: by fxm2 with SMTP id 2so229823fxm.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 14:01:04 -0700 (PDT)
Subject: [RFC] BKL in open functions in drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Alessio Igor Bogani <abogani@texware.it>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 01:00:56 +0400
Message-Id: <1238619656.3986.88.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Few days ago Alessio Igor Bogani<abogani@texware.it> sent me patch
that removes BKLs like lock/unlock_kernel() in open call and place mutex
there in media/radio/radio-mr800.c.
This patch broke the driver, so we figured out new approah. We added one
more mutex lock that was used in open call. The patch is below: 

diff -r ffa5df73ebeb linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c Fri Mar 13 00:43:34 2009
+0000
+++ b/linux/drivers/media/radio/radio-mr800.c	Thu Apr 02 00:40:56 2009
+0400
@@ -163,6 +163,7 @@
 
 	unsigned char *buffer;
 	struct mutex lock;	/* buffer locking */
+	struct mutex open;
 	int curfreq;
 	int stereo;
 	int users;
@@ -570,7 +571,7 @@
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-	lock_kernel();
+	mutex_lock(&radio->open);
 
 	radio->users = 1;
 	radio->muted = 1;
@@ -580,7 +581,7 @@
 		amradio_dev_warn(&radio->videodev->dev,
 			"radio did not start up properly\n");
 		radio->users = 0;
-		unlock_kernel();
+		mutex_unlock(&radio->open);
 		return -EIO;
 	}
 
@@ -594,7 +595,7 @@
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
 
-	unlock_kernel();
+	mutex_unlock(&radio->open);
 	return 0;
 }
 
@@ -735,6 +736,7 @@
 	radio->stereo = -1;
 
 	mutex_init(&radio->lock);
+	mutex_init(&radio->open);
 
 	video_set_drvdata(radio->videodev, radio);
 	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
radio_nr);

I tested such approach using stress tool that tries to open /dev/radio0
few hundred times. Looks fine. 

So, questions are:

1) What for is lock/unlock_kernel() used in open?
2) Can it be replaced by mutex, for example?

Please, comments, exaplanations are more than welcome.

Thanks,
-- 
best regards, Klimov Alexey

