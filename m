Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2JI0Q1L026777
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 14:00:26 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2JHxhTg009015
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 13:59:45 -0400
Received: by py-out-1112.google.com with SMTP id a29so719017pyi.0
	for <video4linux-list@redhat.com>; Wed, 19 Mar 2008 10:59:43 -0700 (PDT)
Date: Wed, 19 Mar 2008 18:00:27 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Message-ID: <20080319180027.GA22812@singular.sob>
References: <200803191044.20611.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803191044.20611.toralf.foerster@gmx.de>
Cc: video4linux-list@redhat.com
Subject: [PATCH] stkwebcam: depend on VIDEO_V4L1_COMPAT
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

This should fix build failure reported by Toralf Förster:

El mié. 19 de mar. de 2008, a las 10:44:20 +0100, Toralf Förster escribió:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CC [M]  drivers/media/video/stk-webcam.o
> drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
> drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
> drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
> drivers/media/video/stk-webcam.c:348: error: implicit declaration of function 'video_device_remove_file'
> drivers/media/video/stk-webcam.c: At top level:
[...]

Regards.

Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>

---

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 37072a2..544630e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -823,7 +823,7 @@ config USB_ZR364XX
 
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
-	depends on VIDEO_V4L2 && EXPERIMENTAL
+	depends on VIDEO_V4L2 && VIDEO_V4L1_COMPAT && EXPERIMENTAL
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
