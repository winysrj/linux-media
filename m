Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UElNG6022728
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 10:47:23 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UElBI0012795
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 10:47:11 -0400
Message-ID: <48B9601D.8060304@hhs.nl>
Date: Sat, 30 Aug 2008 16:58:37 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------000906090001050207000003"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Patch: gspca-sonixb-make-tested-cams-default-to-gspca.patch
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
--------------000906090001050207000003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch makes gspca claim the USB-ID for sn9c101/2 cams with a TAS5110C1B
sensor even if both gspca and sn9c102 are enabled, as these cams are much
better supported under gspca (and extensively tested with gspca).

It also removes an usb-id from sn9c102 for one more unsupported bridge
sensor combo.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------000906090001050207000003
Content-Type: text/plain;
	name="gspca-sonixb-make-tested-cams-default-to-gspca.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="gspca-sonixb-make-tested-cams-default-to-gspca.patch"

This patch makes gspca claim the USB-ID for sn9c101/2 cams with a TAS5110C1B
sensor even if both gspca and sn9c102 are enabled, as these cams are much
better supported under gspca (and extensively tested with gspca).

It also removes an usb-id from sn9c102 for one more unsupported bridge
sensor combo.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 41902288c7da linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Sat Aug 30 16:33:21 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Sat Aug 30 16:53:21 2008 +0200
@@ -1231,10 +1231,10 @@
 
 
 static __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x0c45, 0x6001), SB(TAS5110, 102)}, /* TAS5110C1B */
+	{USB_DEVICE(0x0c45, 0x6005), SB(TAS5110, 101)}, /* TAS5110C1B */
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
-	{USB_DEVICE(0x0c45, 0x6001), SB(TAS5110, 102)},
-	{USB_DEVICE(0x0c45, 0x6005), SB(TAS5110, 101)},
-	{USB_DEVICE(0x0c45, 0x6007), SB(TAS5110, 101)},
+	{USB_DEVICE(0x0c45, 0x6007), SB(TAS5110, 101)}, /* TAS5110D */
 	{USB_DEVICE(0x0c45, 0x6009), SB(PAS106, 101)},
 	{USB_DEVICE(0x0c45, 0x600d), SB(PAS106, 101)},
 #endif
diff -r 41902288c7da linux/drivers/media/video/sn9c102/sn9c102_devtable.h
--- a/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Sat Aug 30 16:33:21 2008 +0200
+++ b/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Sat Aug 30 16:53:21 2008 +0200
@@ -40,8 +40,10 @@
 
 static const struct usb_device_id sn9c102_id_table[] = {
 	/* SN9C101 and SN9C102 */
+#if !defined CONFIG_USB_GSPCA && !defined CONFIG_USB_GSPCA_MODULE
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6001, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6005, BRIDGE_SN9C102), },
+#endif
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6007, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6009, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x600d, BRIDGE_SN9C102), },
@@ -72,7 +74,7 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60a3, BRIDGE_SN9C103), },
 /*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a8, BRIDGE_SN9C103), }, PAS106 */
 /*	{ SN9C102_USB_DEVICE(0x0c45, 0x60aa, BRIDGE_SN9C103), }, TAS5130 */
-	{ SN9C102_USB_DEVICE(0x0c45, 0x60ab, BRIDGE_SN9C103), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60ab, BRIDGE_SN9C103), }, TAS5130 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60ac, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60ae, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60af, BRIDGE_SN9C103), },

--------------000906090001050207000003
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------000906090001050207000003--
