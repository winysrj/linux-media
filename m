Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3KmKkP024165
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:20 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Km6dD010694
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:06 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <893107a5df87228bb676.1228337221@hypnosis.jim>
In-Reply-To: <patchbomb.1228337219@hypnosis.jim>
Date: Wed, 03 Dec 2008 15:47:01 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Cc: 
Subject: [PATCH 2 of 4] ov534: initialization cleanup
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

# HG changeset patch
# User jim@jtan.com
# Date 1228334814 18000
# Node ID 893107a5df87228bb6766f26226fcef8069e3fc8
# Parent  fa4fcbdb237a065c4033bd51be28fa9da9016cef
ov534: initialization cleanup

Clean up bridge and sensor chip initialization by putting initial
register values in arrays rather than open-coding calls to
*_reg_write.

Also remove ov534_reg_verify_write, as the verify step doesn't appear
necessary.

The order of some writes was rearranged and some duplicate writes were
removed, but the camera behavior is unchanged.

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r fa4fcbdb237a -r 893107a5df87 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:05:04 2008 -0500
+++ b/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:06:54 2008 -0500
@@ -94,19 +94,6 @@
 	return data;
 }
 
-static void ov534_reg_verify_write(struct usb_device *udev, u16 reg, u16 val)
-{
-	u16 data;
-
-	ov534_reg_write(udev, reg, val);
-	data = ov534_reg_read(udev, reg);
-	if (data != val) {
-		PDEBUG(D_ERR | D_USBO,
-		       "unexpected result from read: 0x%04x != 0x%04x", val,
-		       data);
-	}
-}
-
 /* Two bits control LED: 0x21 bit 7 and 0x23 bit 7.
  * (direction and output)? */
 static void ov534_set_led(struct usb_device *udev, int status)
@@ -162,174 +149,168 @@
 		PDEBUG(D_ERR, "sccb_reg_write failed");
 }
 
+static const __u8 ov534_reg_initdata[][2] = {
+	{ 0xe7, 0x3a },
+
+	{ OV534_REG_ADDRESS, 0x42 }, /* select OV772x sensor */
+
+	{ 0xc2, 0x0c },
+	{ 0x88, 0xf8 },
+	{ 0xc3, 0x69 },
+	{ 0x89, 0xff },
+	{ 0x76, 0x03 },
+	{ 0x92, 0x01 },
+	{ 0x93, 0x18 },
+	{ 0x94, 0x10 },
+	{ 0x95, 0x10 },
+	{ 0xe2, 0x00 },
+	{ 0xe7, 0x3e },
+
+	{ 0x1c, 0x0a },
+	{ 0x1d, 0x22 },
+	{ 0x1d, 0x06 },
+
+	{ 0x96, 0x00 },
+
+	{ 0x97, 0x20 },
+	{ 0x97, 0x20 },
+	{ 0x97, 0x20 },
+	{ 0x97, 0x0a },
+	{ 0x97, 0x3f },
+	{ 0x97, 0x4a },
+	{ 0x97, 0x20 },
+	{ 0x97, 0x15 },
+	{ 0x97, 0x0b },
+
+	{ 0x8e, 0x40 },
+	{ 0x1f, 0x81 },
+	{ 0x34, 0x05 },
+	{ 0xe3, 0x04 },
+	{ 0x88, 0x00 },
+	{ 0x89, 0x00 },
+	{ 0x76, 0x00 },
+	{ 0xe7, 0x2e },
+	{ 0x31, 0xf9 },
+	{ 0x25, 0x42 },
+	{ 0x21, 0xf0 },
+
+	{ 0x1c, 0x00 },
+	{ 0x1d, 0x40 },
+	{ 0x1d, 0x02 },
+	{ 0x1d, 0x00 },
+	{ 0x1d, 0x02 },
+	{ 0x1d, 0x57 },
+	{ 0x1d, 0xff },
+
+	{ 0x8d, 0x1c },
+	{ 0x8e, 0x80 },
+	{ 0xe5, 0x04 },
+
+	{ 0xc0, 0x50 },
+	{ 0xc1, 0x3c },
+	{ 0xc2, 0x0c },
+};
+
+static const __u8 ov772x_reg_initdata[][2] = {
+	{ 0x12, 0x80 },
+	{ 0x11, 0x01 },
+
+	{ 0x3d, 0x03 },
+	{ 0x17, 0x26 },
+	{ 0x18, 0xa0 },
+	{ 0x19, 0x07 },
+	{ 0x1a, 0xf0 },
+	{ 0x32, 0x00 },
+	{ 0x29, 0xa0 },
+	{ 0x2c, 0xf0 },
+	{ 0x65, 0x20 },
+	{ 0x11, 0x01 },
+	{ 0x42, 0x7f },
+	{ 0x63, 0xe0 },
+	{ 0x64, 0xff },
+	{ 0x66, 0x00 },
+	{ 0x13, 0xf0 },
+	{ 0x0d, 0x41 },
+	{ 0x0f, 0xc5 },
+	{ 0x14, 0x11 },
+
+	{ 0x22, 0x7f },
+	{ 0x23, 0x03 },
+	{ 0x24, 0x40 },
+	{ 0x25, 0x30 },
+	{ 0x26, 0xa1 },
+	{ 0x2a, 0x00 },
+	{ 0x2b, 0x00 },
+	{ 0x6b, 0xaa },
+	{ 0x13, 0xff },
+
+	{ 0x90, 0x05 },
+	{ 0x91, 0x01 },
+	{ 0x92, 0x03 },
+	{ 0x93, 0x00 },
+	{ 0x94, 0x60 },
+	{ 0x95, 0x3c },
+	{ 0x96, 0x24 },
+	{ 0x97, 0x1e },
+	{ 0x98, 0x62 },
+	{ 0x99, 0x80 },
+	{ 0x9a, 0x1e },
+	{ 0x9b, 0x08 },
+	{ 0x9c, 0x20 },
+	{ 0x9e, 0x81 },
+
+	{ 0xa6, 0x04 },
+	{ 0x7e, 0x0c },
+	{ 0x7f, 0x16 },
+	{ 0x80, 0x2a },
+	{ 0x81, 0x4e },
+	{ 0x82, 0x61 },
+	{ 0x83, 0x6f },
+	{ 0x84, 0x7b },
+	{ 0x85, 0x86 },
+	{ 0x86, 0x8e },
+	{ 0x87, 0x97 },
+	{ 0x88, 0xa4 },
+	{ 0x89, 0xaf },
+	{ 0x8a, 0xc5 },
+	{ 0x8b, 0xd7 },
+	{ 0x8c, 0xe8 },
+	{ 0x8d, 0x20 },
+
+	{ 0x0c, 0x90 },
+
+	{ 0x2b, 0x00 },
+	{ 0x22, 0x7f },
+	{ 0x23, 0x03 },
+	{ 0x11, 0x01 },
+	{ 0x0c, 0xd0 },
+	{ 0x64, 0xff },
+	{ 0x0d, 0x41 },
+
+	{ 0x14, 0x41 },
+	{ 0x0e, 0xcd },
+	{ 0xac, 0xbf },
+	{ 0x8e, 0x00 },
+	{ 0x0c, 0xd0 }
+};
+
+
 /* setup method */
 static void ov534_setup(struct usb_device *udev)
 {
-	ov534_reg_verify_write(udev, 0xe7, 0x3a);
+	int i;
 
-	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
-	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
-	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x60);
-	ov534_reg_write(udev, OV534_REG_ADDRESS, 0x42);
-
-	ov534_reg_verify_write(udev, 0xc2, 0x0c);
-	ov534_reg_verify_write(udev, 0x88, 0xf8);
-	ov534_reg_verify_write(udev, 0xc3, 0x69);
-	ov534_reg_verify_write(udev, 0x89, 0xff);
-	ov534_reg_verify_write(udev, 0x76, 0x03);
-	ov534_reg_verify_write(udev, 0x92, 0x01);
-	ov534_reg_verify_write(udev, 0x93, 0x18);
-	ov534_reg_verify_write(udev, 0x94, 0x10);
-	ov534_reg_verify_write(udev, 0x95, 0x10);
-	ov534_reg_verify_write(udev, 0xe2, 0x00);
-	ov534_reg_verify_write(udev, 0xe7, 0x3e);
-
-	ov534_reg_write(udev, 0x1c, 0x0a);
-	ov534_reg_write(udev, 0x1d, 0x22);
-	ov534_reg_write(udev, 0x1d, 0x06);
-
-	ov534_reg_verify_write(udev, 0x96, 0x00);
-
-	ov534_reg_write(udev, 0x97, 0x20);
-	ov534_reg_write(udev, 0x97, 0x20);
-	ov534_reg_write(udev, 0x97, 0x20);
-	ov534_reg_write(udev, 0x97, 0x0a);
-	ov534_reg_write(udev, 0x97, 0x3f);
-	ov534_reg_write(udev, 0x97, 0x4a);
-	ov534_reg_write(udev, 0x97, 0x20);
-	ov534_reg_write(udev, 0x97, 0x15);
-	ov534_reg_write(udev, 0x97, 0x0b);
-
-	ov534_reg_verify_write(udev, 0x8e, 0x40);
-	ov534_reg_verify_write(udev, 0x1f, 0x81);
-	ov534_reg_verify_write(udev, 0x34, 0x05);
-	ov534_reg_verify_write(udev, 0xe3, 0x04);
-	ov534_reg_verify_write(udev, 0x88, 0x00);
-	ov534_reg_verify_write(udev, 0x89, 0x00);
-	ov534_reg_verify_write(udev, 0x76, 0x00);
-	ov534_reg_verify_write(udev, 0xe7, 0x2e);
-	ov534_reg_verify_write(udev, 0x31, 0xf9);
-	ov534_reg_verify_write(udev, 0x25, 0x42);
-	ov534_reg_verify_write(udev, 0x21, 0xf0);
-
-	ov534_reg_write(udev, 0x1c, 0x00);
-	ov534_reg_write(udev, 0x1d, 0x40);
-	ov534_reg_write(udev, 0x1d, 0x02);
-	ov534_reg_write(udev, 0x1d, 0x00);
-	ov534_reg_write(udev, 0x1d, 0x02);
-	ov534_reg_write(udev, 0x1d, 0x57);
-	ov534_reg_write(udev, 0x1d, 0xff);
-
-	ov534_reg_verify_write(udev, 0x8d, 0x1c);
-	ov534_reg_verify_write(udev, 0x8e, 0x80);
-	ov534_reg_verify_write(udev, 0xe5, 0x04);
+	/* Initialize bridge chip */
+	for (i = 0; i < ARRAY_SIZE(ov534_reg_initdata); i++)
+		ov534_reg_write(udev, ov534_reg_initdata[i][0],
+				ov534_reg_initdata[i][1]);
 
 	ov534_set_led(udev, 1);
 
-	sccb_reg_write(udev, 0x12, 0x80);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x11, 0x01);
-
-	ov534_set_led(udev, 0);
-
-	sccb_reg_write(udev, 0x3d, 0x03);
-	sccb_reg_write(udev, 0x17, 0x26);
-	sccb_reg_write(udev, 0x18, 0xa0);
-	sccb_reg_write(udev, 0x19, 0x07);
-	sccb_reg_write(udev, 0x1a, 0xf0);
-	sccb_reg_write(udev, 0x32, 0x00);
-	sccb_reg_write(udev, 0x29, 0xa0);
-	sccb_reg_write(udev, 0x2c, 0xf0);
-	sccb_reg_write(udev, 0x65, 0x20);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x42, 0x7f);
-	sccb_reg_write(udev, 0x63, 0xe0);
-	sccb_reg_write(udev, 0x64, 0xff);
-	sccb_reg_write(udev, 0x66, 0x00);
-	sccb_reg_write(udev, 0x13, 0xf0);
-	sccb_reg_write(udev, 0x0d, 0x41);
-	sccb_reg_write(udev, 0x0f, 0xc5);
-	sccb_reg_write(udev, 0x14, 0x11);
-
-	ov534_set_led(udev, 1);
-
-	sccb_reg_write(udev, 0x22, 0x7f);
-	sccb_reg_write(udev, 0x23, 0x03);
-	sccb_reg_write(udev, 0x24, 0x40);
-	sccb_reg_write(udev, 0x25, 0x30);
-	sccb_reg_write(udev, 0x26, 0xa1);
-	sccb_reg_write(udev, 0x2a, 0x00);
-	sccb_reg_write(udev, 0x2b, 0x00);
-	sccb_reg_write(udev, 0x6b, 0xaa);
-	sccb_reg_write(udev, 0x13, 0xff);
-
-	ov534_set_led(udev, 0);
-
-	sccb_reg_write(udev, 0x90, 0x05);
-	sccb_reg_write(udev, 0x91, 0x01);
-	sccb_reg_write(udev, 0x92, 0x03);
-	sccb_reg_write(udev, 0x93, 0x00);
-	sccb_reg_write(udev, 0x94, 0x60);
-	sccb_reg_write(udev, 0x95, 0x3c);
-	sccb_reg_write(udev, 0x96, 0x24);
-	sccb_reg_write(udev, 0x97, 0x1e);
-	sccb_reg_write(udev, 0x98, 0x62);
-	sccb_reg_write(udev, 0x99, 0x80);
-	sccb_reg_write(udev, 0x9a, 0x1e);
-	sccb_reg_write(udev, 0x9b, 0x08);
-	sccb_reg_write(udev, 0x9c, 0x20);
-	sccb_reg_write(udev, 0x9e, 0x81);
-
-	ov534_set_led(udev, 1);
-
-	sccb_reg_write(udev, 0xa6, 0x04);
-	sccb_reg_write(udev, 0x7e, 0x0c);
-	sccb_reg_write(udev, 0x7f, 0x16);
-	sccb_reg_write(udev, 0x80, 0x2a);
-	sccb_reg_write(udev, 0x81, 0x4e);
-	sccb_reg_write(udev, 0x82, 0x61);
-	sccb_reg_write(udev, 0x83, 0x6f);
-	sccb_reg_write(udev, 0x84, 0x7b);
-	sccb_reg_write(udev, 0x85, 0x86);
-	sccb_reg_write(udev, 0x86, 0x8e);
-	sccb_reg_write(udev, 0x87, 0x97);
-	sccb_reg_write(udev, 0x88, 0xa4);
-	sccb_reg_write(udev, 0x89, 0xaf);
-	sccb_reg_write(udev, 0x8a, 0xc5);
-	sccb_reg_write(udev, 0x8b, 0xd7);
-	sccb_reg_write(udev, 0x8c, 0xe8);
-	sccb_reg_write(udev, 0x8d, 0x20);
-
-	sccb_reg_write(udev, 0x0c, 0x90);
-
-	ov534_reg_verify_write(udev, 0xc0, 0x50);
-	ov534_reg_verify_write(udev, 0xc1, 0x3c);
-	ov534_reg_verify_write(udev, 0xc2, 0x0c);
-
-	ov534_set_led(udev, 1);
-
-	sccb_reg_write(udev, 0x2b, 0x00);
-	sccb_reg_write(udev, 0x22, 0x7f);
-	sccb_reg_write(udev, 0x23, 0x03);
-	sccb_reg_write(udev, 0x11, 0x01);
-	sccb_reg_write(udev, 0x0c, 0xd0);
-	sccb_reg_write(udev, 0x64, 0xff);
-	sccb_reg_write(udev, 0x0d, 0x41);
-
-	sccb_reg_write(udev, 0x14, 0x41);
-	sccb_reg_write(udev, 0x0e, 0xcd);
-	sccb_reg_write(udev, 0xac, 0xbf);
-	sccb_reg_write(udev, 0x8e, 0x00);
-	sccb_reg_write(udev, 0x0c, 0xd0);
+	/* Initialize sensor */
+	for (i = 0; i < ARRAY_SIZE(ov772x_reg_initdata); i++)
+		sccb_reg_write(udev, ov772x_reg_initdata[i][0],
+			       ov772x_reg_initdata[i][1]);
 
 	ov534_reg_write(udev, 0xe0, 0x09);
 	ov534_set_led(udev, 0);
@@ -370,23 +351,23 @@
 	case 50:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 40:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
-		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
 	case 30:
 	default:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
-		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
 		break;
 	case 15:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
 	};
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
