Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HAj2q4024727
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 06:45:02 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HAinTm013486
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 06:44:50 -0400
Message-ID: <487F246B.8050407@hhs.nl>
Date: Thu, 17 Jul 2008 12:52:27 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------060304050008090100010409"
Cc: video4linux-list@redhat.com
Subject: Patch: sn9c102-remove-unsupported-usb-ids.patch
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
--------------060304050008090100010409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The sn9c102 driver claims to support usb-ID 0x0c45:0x6011, which is
a sn9c102 with ov6650 sensor, but the sn9c102 driver does not support the
ov6650 sensor (tested). Also the sn9c102 driver claims to support usb-ID
0x0c45:0x603f, which is a sn9c102 with CISVF10 sensor, but the sn9c102
driver does not support the CISVF10 sensor (not tested).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------060304050008090100010409
Content-Type: text/x-patch;
 name="sn9c102-remove-unsupported-usb-ids.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="sn9c102-remove-unsupported-usb-ids.patch"

The sn9c102 driver claims to support usb-ID 0x0c45:0x6011, which is
a sn9c102 with ov6650 sensor, but the sn9c102 driver does not support the
ov6650 sensor (tested). Also the sn9c102 driver claims to support usb-ID
0x0c45:0x603f, which is a sn9c102 with CISVF10 sensor, but the sn9c102
driver does not support the CISVF10 sensor (not tested).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 9b5083e51248 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Jul 17 11:50:20 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Thu Jul 17 12:49:00 2008 +0200
@@ -1277,7 +1277,9 @@
 	{USB_DEVICE(0x0c45, 0x6007), DVNM("Sonix sn9c101 + Tas5110D")},
 	{USB_DEVICE(0x0c45, 0x6009), DVNM("spcaCam@120")},
 	{USB_DEVICE(0x0c45, 0x600d), DVNM("spcaCam@120")},
+#endif
 	{USB_DEVICE(0x0c45, 0x6011), DVNM("MAX Webcam Microdia")},
+#ifndef CONFIG_USB_SN9C102
 	{USB_DEVICE(0x0c45, 0x6019), DVNM("Generic Sonix OV7630")},
 	{USB_DEVICE(0x0c45, 0x6024), DVNM("Generic Sonix Tas5130c")},
 	{USB_DEVICE(0x0c45, 0x6025), DVNM("Xcam Shanga")},
diff -r 9b5083e51248 linux/drivers/media/video/sn9c102/sn9c102_devtable.h
--- a/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Thu Jul 17 11:50:20 2008 +0200
+++ b/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Thu Jul 17 12:49:00 2008 +0200
@@ -44,7 +44,6 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6005, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6007, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6009, BRIDGE_SN9C102), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x6011, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x600d, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6019, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6024, BRIDGE_SN9C102), },
@@ -57,7 +56,6 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602d, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602e, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6030, BRIDGE_SN9C102), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x603f, BRIDGE_SN9C102), },
 	/* SN9C103 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6080, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6082, BRIDGE_SN9C103), },

--------------060304050008090100010409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060304050008090100010409--
