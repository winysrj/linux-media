Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7O9aIRB019355
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 05:36:18 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7O9a6kn017621
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 05:36:06 -0400
Message-ID: <48B12E11.5000500@hhs.nl>
Date: Sun, 24 Aug 2008 11:46:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------070007070608080002030305"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-sonixb-led-off.patch
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
--------------070007070608080002030305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

* Turn the led of the cam off after plugging in the cam
* Move the probe code from open to config, so that if the probe fails
   we never register

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------070007070608080002030305
Content-Type: text/plain;
 name="gspca-sonixb-led-off.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-led-off.patch"

* Turn the led of the cam off after plugging in the cam
* Move the probe code from open to config, so that if the probe fails
  we never register

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r a392efb75b57 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Sun Aug 24 11:37:43 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Sun Aug 24 11:40:27 2008 +0200
@@ -789,6 +789,11 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam;
 	int sif = 0;
+	const __u8 stop = 0x09; /* Disable stream turn of LED */
+
+	reg_r(gspca_dev, 0x00);
+	if (gspca_dev->usb_buf[0] != 0x10)
+		return -ENODEV;
 
 	/* copy the webcam info from the device id */
 	sd->sensor = (id->driver_info >> 24) & 0xff;
@@ -821,15 +826,15 @@
 		sd->autogain = AUTOGAIN_DEF;
 	sd->freq = FREQ_DEF;
 
+	/* Disable stream turn of LED */
+	reg_w(gspca_dev, 0x01, &stop, 1);
+
 	return 0;
 }
 
 /* this function is called at open time */
 static int sd_open(struct gspca_dev *gspca_dev)
 {
-	reg_r(gspca_dev, 0x00);
-	if (gspca_dev->usb_buf[0] != 0x10)
-		return -ENODEV;
 	return 0;
 }
 

--------------070007070608080002030305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070007070608080002030305--
