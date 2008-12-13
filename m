Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBDMxBue010552
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:59:11 -0500
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBDMwuRf019490
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 17:58:57 -0500
Message-Id: <20081213225852.137962814@studenti.unina.it>
References: <20081213225653.943975535@studenti.unina.it>
Date: Sat, 13 Dec 2008 23:56:55 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Content-Disposition: inline; filename=ov534_show_sensor_ID.patch
Cc: 
Subject: [PATCH 2/2] ov534: port sccb_read_reg() and show sensor ID.
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

The original version of sccb_read_reg() is from Jim Paris.

NOTE: as it is now reading sensor ID won't work for sensors on different
i2c slave address.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -149,6 +149,20 @@
 		PDEBUG(D_ERR, "sccb_reg_write failed");
 }
 
+static u8 sccb_reg_read(struct usb_device *udev, u16 reg)
+{
+	ov534_reg_write(udev, OV534_REG_SUBADDR, reg);
+	ov534_reg_write(udev, OV534_REG_OPERATION, OV534_OP_WRITE_2);
+	if (!sccb_check_status(udev))
+		PDEBUG(D_ERR, "sccb_reg_read failed 1");
+
+	ov534_reg_write(udev, OV534_REG_OPERATION, OV534_OP_READ_2);
+	if (!sccb_check_status(udev))
+		PDEBUG(D_ERR, "sccb_reg_read failed 2");
+
+	return ov534_reg_read(udev, OV534_REG_READ);
+}
+
 static const __u8 ov534_reg_initdata[][2] = {
 	{ 0xe7, 0x3a },
 
@@ -339,6 +353,9 @@
 		ov534_reg_write(udev, ov534_reg_initdata[i][0],
 				ov534_reg_initdata[i][1]);
 
+	PDEBUG(D_PROBE, "sensor is ov%02x%02x",
+		sccb_reg_read(udev, 0x0a), sccb_reg_read(udev, 0x0b));
+
 	ov534_set_led(udev, 1);
 
 	/* Initialize sensor */

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
