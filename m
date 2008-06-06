Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56LX9uS009012
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 17:33:09 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m56LWvRO020403
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 17:32:57 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Date: Fri, 6 Jun 2008 23:32:49 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806062332.49552.tobias.lorenz@gmx.net>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] si470x: correction of module_param access rights and
	descriptions
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

Hi,

the driver defined the access rights within module_param always with 0, instead of 0444 or 0644.
Also some MODULE_PARAM_DESC erroneous referenced to the radio_nr variable.

This patch provides corrections for these two issues.

Bye,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff 0_mercurial/drivers/media/radio/radio-si470x.c 1_module_params/drivers/media/radio/radio-si470x.c
--- 0_mercurial/drivers/media/radio/radio-si470x.c	2008-06-06 21:18:39.000000000 +0200
+++ 1_module_params/drivers/media/radio/radio-si470x.c	2008-06-06 21:36:03.000000000 +0200
@@ -159,7 +159,7 @@ MODULE_DEVICE_TABLE(usb, si470x_usb_driv
 
 /* Radio Nr */
 static int radio_nr = -1;
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
 /* Spacing (kHz) */
@@ -167,42 +167,42 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
 /* 1: 100 kHz (Europe, Japan) */
 /* 2:  50 kHz */
 static unsigned short space = 2;
-module_param(space, ushort, 0);
-MODULE_PARM_DESC(radio_nr, "Spacing: 0=200kHz 1=100kHz *2=50kHz*");
+module_param(space, ushort, 0444);
+MODULE_PARM_DESC(space, "Spacing: 0=200kHz 1=100kHz *2=50kHz*");
 
 /* Bottom of Band (MHz) */
 /* 0: 87.5 - 108 MHz (USA, Europe)*/
 /* 1: 76   - 108 MHz (Japan wide band) */
 /* 2: 76   -  90 MHz (Japan) */
 static unsigned short band = 1;
-module_param(band, ushort, 0);
-MODULE_PARM_DESC(radio_nr, "Band: 0=87.5..108MHz *1=76..108MHz* 2=76..90MHz");
+module_param(band, ushort, 0444);
+MODULE_PARM_DESC(band, "Band: 0=87.5..108MHz *1=76..108MHz* 2=76..90MHz");
 
 /* De-emphasis */
 /* 0: 75 us (USA) */
 /* 1: 50 us (Europe, Australia, Japan) */
 static unsigned short de = 1;
-module_param(de, ushort, 0);
-MODULE_PARM_DESC(radio_nr, "De-emphasis: 0=75us *1=50us*");
+module_param(de, ushort, 0444);
+MODULE_PARM_DESC(de, "De-emphasis: 0=75us *1=50us*");
 
 /* USB timeout */
 static unsigned int usb_timeout = 500;
-module_param(usb_timeout, uint, 0);
+module_param(usb_timeout, uint, 0644);
 MODULE_PARM_DESC(usb_timeout, "USB timeout (ms): *500*");
 
 /* Tune timeout */
 static unsigned int tune_timeout = 3000;
-module_param(tune_timeout, uint, 0);
+module_param(tune_timeout, uint, 0644);
 MODULE_PARM_DESC(tune_timeout, "Tune timeout: *3000*");
 
 /* Seek timeout */
 static unsigned int seek_timeout = 5000;
-module_param(seek_timeout, uint, 0);
+module_param(seek_timeout, uint, 0644);
 MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
 
 /* RDS buffer blocks */
 static unsigned int rds_buf = 100;
-module_param(rds_buf, uint, 0);
+module_param(rds_buf, uint, 0444);
 MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
 
 /* RDS maximum block errors */
@@ -211,7 +211,7 @@ static unsigned short max_rds_errors = 1
 /* 1 means 1-2  errors requiring correction (used by original USBRadio.exe) */
 /* 2 means 3-5  errors requiring correction */
 /* 3 means   6+ errors or errors in checkword, correction not possible */
-module_param(max_rds_errors, ushort, 0);
+module_param(max_rds_errors, ushort, 0644);
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 
 /* RDS poll frequency */
@@ -220,7 +220,7 @@ static unsigned int rds_poll_time = 40;
 /* 50 is used by radio-cadet */
 /* 75 should be okay */
 /* 80 is the usual RDS receive interval */
-module_param(rds_poll_time, uint, 0);
+module_param(rds_poll_time, uint, 0644);
 MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*");
 
 
@@ -1598,7 +1598,7 @@ done:
 
 
 /*
- * si470x_viddev_tamples - video device interface
+ * si470x_viddev_template - video device interface
  */
 static struct video_device si470x_viddev_template = {
 	.fops			= &si470x_fops,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
