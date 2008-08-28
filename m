Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SA6VOf029992
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 06:06:31 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7SA53uL014360
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 06:05:25 -0400
Message-ID: <48B67AEE.2030302@hhs.nl>
Date: Thu, 28 Aug 2008 12:16:14 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------030703030607070605040804"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-usb-ids.patch
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
--------------030703030607070605040804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

<now with attachment, sorry>

Hi,

USB-id shuffle:
-remove USB-id's from zc0301 for cams for which zc0301.c does not support
  the sensor
-remove USB-id's from sn9c102 for cams where sn9c102 does not support the
  bridge sensor combination
-no longer make inclusion of usb id's removed from zc0301 and sn9c102
  conditional in gspca
-fix conditional inclusion of USB-id's in gspca to also work when the
  conflicting drivers are build as a module
-add a number of USB-id's to gspca from various windows .inf files:
0c45:608f from generic sonix sn9c103 inf file (+ ov7630 which we support)
041e:4022 from creative webcam nx pro, same as already supported 041e:401e
0ac8:0301 from generic zc0301 driver which supports many sensors
10fd:804d from typhoon webshot driver (also FlyCAM-USB 300 plus)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------030703030607070605040804
Content-Type: text/plain;
 name="gspca-usb-ids.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-usb-ids.patch"

USB-id shuffle:
-remove USB-id's from zc0301 for cams for which zc0301.c does not support
 the sensor
-remove USB-id's from sn9c102 for cams where sn9c102 does not support the
 bridge sensor combination
-no longer make inclusion of usb id's removed from zc0301 and sn9c102
 conditional in gspca
-fix conditional inclusion of USB-id's in gspca to also work when the
 conflicting drivers are build as a module
-add a number of USB-id's to gspca from various windows .inf files:
0c45:608f from generic sonix sn9c103 inf file (+ ov7630 which we support)
041e:4022 from creative webcam nx pro, same as already supported 041e:401e
0ac8:0301 from generic zc0301 driver which supports many sensors
10fd:804d from typhoon webshot driver (also FlyCAM-USB 300 plus)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 5a6318322fe1 linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/gspca/etoms.c	Thu Aug 28 11:48:04 2008 +0200
@@ -903,7 +903,7 @@
 /* -- module initialisation -- */
 static __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x102c, 0x6151), .driver_info = SENSOR_PAS106},
-#ifndef CONFIG_USB_ET61X251
+#if !defined CONFIG_USB_ET61X251 && !defined CONFIG_USB_ET61X251_MODULE
 	{USB_DEVICE(0x102c, 0x6251), .driver_info = SENSOR_TAS5130CXX},
 #endif
 	{}
diff -r 5a6318322fe1 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Thu Aug 28 11:48:04 2008 +0200
@@ -1186,7 +1186,7 @@
 #define NO_BRIGHTNESS (1 << BRIGHTNESS_IDX)
 
 static __devinitdata struct usb_device_id device_table[] = {
-#ifndef CONFIG_USB_SN9C102
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0c45, 0x6001),			/* SN9C102 */
 			SFCI(TAS5110, F_GAIN|F_SIF, NO_BRIGHTNESS|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6005),			/* SN9C101 */
@@ -1200,7 +1200,7 @@
 #endif
 	{USB_DEVICE(0x0c45, 0x6011),		/* SN9C101 - SN9C101G */
 			SFCI(OV6650, F_GAIN|F_SIF, 0, 0x60)},
-#ifndef CONFIG_USB_SN9C102
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0c45, 0x6019),			/* SN9C101 */
 			SFCI(OV7630, F_GAIN, 0, 0x21)},
 	{USB_DEVICE(0x0c45, 0x6024),			/* SN9C102 */
@@ -1213,10 +1213,14 @@
 			SFCI(PAS106, F_SIF, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x602c),			/* SN9C102 */
 			SFCI(OV7630, F_GAIN, 0, 0x21)},
+#endif
 	{USB_DEVICE(0x0c45, 0x602d),			/* SN9C102 */
 			SFCI(HV7131R, 0, NO_EXPO|NO_FREQ, 0)},
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0c45, 0x602e),			/* SN9C102 */
 			SFCI(OV7630, F_GAIN, 0, 0x21)},
+	{USB_DEVICE(0x0c45, 0x608f),			/* SN9C103 */
+			SFCI(OV7630, F_GAIN|F_H18, 0, 0x21)},
 	{USB_DEVICE(0x0c45, 0x60af),			/* SN9C103 */
 			SFCI(PAS202, F_H18, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x60b0),			/* SN9C103 */
diff -r 5a6318322fe1 linux/drivers/media/video/gspca/sonixj.c
--- a/linux/drivers/media/video/gspca/sonixj.c	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixj.c	Thu Aug 28 11:48:04 2008 +0200
@@ -1605,7 +1605,7 @@
 			| (SENSOR_ ## sensor << 8) \
 			| (i2c_addr)
 static const __devinitdata struct usb_device_id device_table[] = {
-#ifndef CONFIG_USB_SN9C102
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0458, 0x7025), BSI(SN9C120, MI0360, 0x5d)},
 	{USB_DEVICE(0x045e, 0x00f5), BSI(SN9C105, OV7660, 0x21)},
 	{USB_DEVICE(0x045e, 0x00f7), BSI(SN9C105, OV7660, 0x21)},
@@ -1638,9 +1638,11 @@
 	{USB_DEVICE(0x0c45, 0x612c), BSI(SN9C110, MO4000, 0x21)},
 	{USB_DEVICE(0x0c45, 0x612e), BSI(SN9C110, OV7630, 0x21)},
 /*	{USB_DEVICE(0x0c45, 0x612f), BSI(SN9C110, ICM105C, 0x??)}, */
-#ifndef CONFIG_USB_SN9C102
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0c45, 0x6130), BSI(SN9C120, MI0360, 0x5d)},
+#endif
 	{USB_DEVICE(0x0c45, 0x6138), BSI(SN9C120, MO4000, 0x21)},
+#if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 /*	{USB_DEVICE(0x0c45, 0x613a), BSI(SN9C120, OV7648, 0x??)}, */
 	{USB_DEVICE(0x0c45, 0x613b), BSI(SN9C120, OV7660, 0x21)},
 	{USB_DEVICE(0x0c45, 0x613c), BSI(SN9C120, HV7131R, 0x11)},
diff -r 5a6318322fe1 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Aug 28 11:48:04 2008 +0200
@@ -7513,26 +7513,21 @@
 
 static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x041e, 0x041e)},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x041e, 0x4017)},
 	{USB_DEVICE(0x041e, 0x401c), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x041e, 0x401e)},
 	{USB_DEVICE(0x041e, 0x401f)},
-#endif
+	{USB_DEVICE(0x041e, 0x4022)},
 	{USB_DEVICE(0x041e, 0x4029)},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x041e, 0x4034), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x041e, 0x4035), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x041e, 0x4036)},
 	{USB_DEVICE(0x041e, 0x403a)},
-#endif
 	{USB_DEVICE(0x041e, 0x4051), .driver_info = SENSOR_TAS5130C_VF0250},
 	{USB_DEVICE(0x041e, 0x4053), .driver_info = SENSOR_TAS5130C_VF0250},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0458, 0x7007)},
 	{USB_DEVICE(0x0458, 0x700c)},
 	{USB_DEVICE(0x0458, 0x700f)},
-#endif
 	{USB_DEVICE(0x0461, 0x0a00)},
 	{USB_DEVICE(0x046d, 0x08a0)},
 	{USB_DEVICE(0x046d, 0x08a1)},
@@ -7544,7 +7539,7 @@
 	{USB_DEVICE(0x046d, 0x08aa)},
 	{USB_DEVICE(0x046d, 0x08ac)},
 	{USB_DEVICE(0x046d, 0x08ad)},
-#ifndef CONFIG_USB_ZC0301
+#if !defined CONFIG_USB_ZC0301 && !defined CONFIG_USB_ZC0301_MODULE
 	{USB_DEVICE(0x046d, 0x08ae)},
 #endif
 	{USB_DEVICE(0x046d, 0x08af)},
@@ -7559,22 +7554,20 @@
 	{USB_DEVICE(0x0471, 0x032d), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x0471, 0x032e), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x055f, 0xc005)},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x055f, 0xd003)},
 	{USB_DEVICE(0x055f, 0xd004)},
-#endif
 	{USB_DEVICE(0x0698, 0x2003)},
+	{USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
 	{USB_DEVICE(0x0ac8, 0x0302)},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0ac8, 0x301b)},
+#if !defined CONFIG_USB_ZC0301 && !defined CONFIG_USB_ZC0301_MODULE
 	{USB_DEVICE(0x0ac8, 0x303b)},
 #endif
 	{USB_DEVICE(0x0ac8, 0x305b), .driver_info = SENSOR_TAS5130C_VF0250},
-#ifndef CONFIG_USB_ZC0301
 	{USB_DEVICE(0x0ac8, 0x307b)},
 	{USB_DEVICE(0x10fd, 0x0128)},
+	{USB_DEVICE(0x10fd, 0x804d)},
 	{USB_DEVICE(0x10fd, 0x8050)},
-#endif
 	{}			/* end of entry */
 };
 #undef DVNAME
diff -r 5a6318322fe1 linux/drivers/media/video/sn9c102/sn9c102_devtable.h
--- a/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/sn9c102/sn9c102_devtable.h	Thu Aug 28 11:48:04 2008 +0200
@@ -45,6 +45,7 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6007, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6009, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x600d, BRIDGE_SN9C102), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6011, BRIDGE_SN9C102), }, OV6650 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6019, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6024, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6025, BRIDGE_SN9C102), },
@@ -53,24 +54,24 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602a, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602b, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602c, BRIDGE_SN9C102), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x602d, BRIDGE_SN9C102), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x602d, BRIDGE_SN9C102), }, HV7131R */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x602e, BRIDGE_SN9C102), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6030, BRIDGE_SN9C102), },
 	/* SN9C103 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6080, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6082, BRIDGE_SN9C103), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x6083, BRIDGE_SN9C103), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6083, BRIDGE_SN9C103), }, HY7131D/E */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6088, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x608a, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x608b, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x608c, BRIDGE_SN9C103), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x608e, BRIDGE_SN9C103), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x608e, BRIDGE_SN9C103), }, CISVF10 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x608f, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60a0, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60a2, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60a3, BRIDGE_SN9C103), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x60a8, BRIDGE_SN9C103), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x60aa, BRIDGE_SN9C103), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60a8, BRIDGE_SN9C103), }, PAS106 */
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x60aa, BRIDGE_SN9C103), }, TAS5130 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60ab, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60ac, BRIDGE_SN9C103), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x60ae, BRIDGE_SN9C103), },
@@ -105,7 +106,7 @@
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6108, BRIDGE_SN9C120), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x610f, BRIDGE_SN9C120), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x6130, BRIDGE_SN9C120), },
-	{ SN9C102_USB_DEVICE(0x0c45, 0x6138, BRIDGE_SN9C120), },
+/*	{ SN9C102_USB_DEVICE(0x0c45, 0x6138, BRIDGE_SN9C120), }, MO8000 */
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613a, BRIDGE_SN9C120), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613b, BRIDGE_SN9C120), },
 	{ SN9C102_USB_DEVICE(0x0c45, 0x613c, BRIDGE_SN9C120), },
diff -r 5a6318322fe1 linux/drivers/media/video/zc0301/zc0301_sensor.h
--- a/linux/drivers/media/video/zc0301/zc0301_sensor.h	Wed Aug 27 16:38:13 2008 +0200
+++ b/linux/drivers/media/video/zc0301/zc0301_sensor.h	Thu Aug 28 11:48:04 2008 +0200
@@ -61,27 +61,8 @@
 
 #define ZC0301_ID_TABLE                                                       \
 static const struct usb_device_id zc0301_id_table[] =  {                      \
-	{ ZC0301_USB_DEVICE(0x041e, 0x4017, 0xff), }, /* ICM105 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x401c, 0xff), }, /* PAS106 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x401e, 0xff), }, /* HV7131 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x401f, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x041e, 0x4022, 0xff), },                         \
-	{ ZC0301_USB_DEVICE(0x041e, 0x4034, 0xff), }, /* PAS106 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x4035, 0xff), }, /* PAS106 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x4036, 0xff), }, /* HV7131 */            \
-	{ ZC0301_USB_DEVICE(0x041e, 0x403a, 0xff), }, /* HV7131 */            \
-	{ ZC0301_USB_DEVICE(0x0458, 0x7007, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x0458, 0x700c, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x0458, 0x700f, 0xff), }, /* TAS5130 */           \
 	{ ZC0301_USB_DEVICE(0x046d, 0x08ae, 0xff), }, /* PAS202 */            \
-	{ ZC0301_USB_DEVICE(0x055f, 0xd003, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x055f, 0xd004, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x0ac8, 0x0301, 0xff), },                         \
-	{ ZC0301_USB_DEVICE(0x0ac8, 0x301b, 0xff), }, /* PB-0330/HV7131 */    \
 	{ ZC0301_USB_DEVICE(0x0ac8, 0x303b, 0xff), }, /* PB-0330 */           \
-	{ ZC0301_USB_DEVICE(0x10fd, 0x0128, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x10fd, 0x8050, 0xff), }, /* TAS5130 */           \
-	{ ZC0301_USB_DEVICE(0x10fd, 0x804e, 0xff), }, /* TAS5130 */           \
 	{ }                                                                   \
 };
 

--------------030703030607070605040804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030703030607070605040804--
