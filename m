Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ONZA38031216
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:35:10 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8ONYqmL014993
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 19:34:55 -0400
Message-Id: <200809242334.m8ONYqmL014993@mx3.redhat.com>
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 25 Sep 2008 00:17:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 1/6] si470x: module_param access rights
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

Hi Mauro,

this patch mainly adds correct module_param access rights.
Also there are a lot of small coding style enhancements and some corrections of the variable references in module_param.

Best regards,
Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- a/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
+++ b/linux/drivers/media/radio/radio-si470x.c	2008-09-24 22:30:00.000000000 +0200
@@ -142,9 +142,9 @@
 /* USB Device ID List */
 static struct usb_device_id si470x_usb_driver_id_table[] = {
 	/* Silicon Labs USB FM Radio Reference Design */
-	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a,	USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
 	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
-	{ USB_DEVICE_AND_INTERFACE_INFO(0x06e1, 0xa155,	USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x06e1, 0xa155, USB_CLASS_HID, 0, 0) },
 	/* Terminating entry */
 	{ }
 };
@@ -158,7 +158,7 @@ MODULE_DEVICE_TABLE(usb, si470x_usb_driv
 
 /* Radio Nr */
 static int radio_nr = -1;
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
 /* Spacing (kHz) */
@@ -166,42 +166,42 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
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
@@ -210,7 +210,7 @@ static unsigned short max_rds_errors = 1
 /* 1 means 1-2  errors requiring correction (used by original USBRadio.exe) */
 /* 2 means 3-5  errors requiring correction */
 /* 3 means   6+ errors or errors in checkword, correction not possible */
-module_param(max_rds_errors, ushort, 0);
+module_param(max_rds_errors, ushort, 0644);
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 
 /* RDS poll frequency */
@@ -219,7 +219,7 @@ static unsigned int rds_poll_time = 40;
 /* 50 is used by radio-cadet */
 /* 75 should be okay */
 /* 80 is the usual RDS receive interval */
-module_param(rds_poll_time, uint, 0);
+module_param(rds_poll_time, uint, 0644);
 MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*");
 
 
@@ -1593,6 +1593,10 @@ done:
 	return retval;
 }
 
+
+/*
+ * si470x_ioctl_ops - video device ioctl operations
+ */
 static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
 	.vidioc_querycap	= si470x_vidioc_querycap,
 	.vidioc_g_input		= si470x_vidioc_g_input,
@@ -1609,14 +1613,15 @@ static const struct v4l2_ioctl_ops si470
 	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
 };
 
+
 /*
- * si470x_viddev_tamples - video device interface
+ * si470x_viddev_template - video device interface
  */
 static struct video_device si470x_viddev_template = {
 	.fops			= &si470x_fops,
-	.ioctl_ops 		= &si470x_ioctl_ops,
 	.name			= DRIVER_NAME,
 	.release		= video_device_release,
+	.ioctl_ops		= &si470x_ioctl_ops,
 };
 
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
