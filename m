Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR9co1Z030999
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:38:50 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR9cbGB009902
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:38:37 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081125235249.d45b50f4.ospite@studenti.unina.it>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
Content-Type: multipart/mixed; boundary="=-0El3OZtRtdo7wKxGoUEi"
Date: Thu, 27 Nov 2008 10:23:04 +0100
Message-Id: <1227777784.1752.20.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
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


--=-0El3OZtRtdo7wKxGoUEi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Tue, 2008-11-25 at 23:52 +0100, Antonio Ospite wrote:
> Print only frame_rate actually used.

Hello Antonio,

This may be simplified as in the attached patch (the frame_rate in the
sd structure was not used).

The patch also includes removing the bulk_size setting at streamon time:
the value is already used at this time, and also, there is only one
resolution.

I found a real problem: for USB read and write, you have a 16-bits
variable in/from which you read/write only one byte. This will fail with
big-endian machines. Anyway, it is safer to use the usb_buf from the
gspca structure.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--=-0El3OZtRtdo7wKxGoUEi
Content-Disposition: attachment; filename=ov534.patch
Content-Type: text/x-patch; name=ov534.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -r 3e0ba0a8e47f linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Wed Nov 26 20:17:13 2008 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Thu Nov 27 10:15:08 2008 +0100
@@ -48,7 +48,6 @@
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
-	__u8 frame_rate;
 };
 
 /* V4L2 controls supported by the driver */
@@ -59,7 +58,7 @@
 	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
 	 .bytesperline = 640 * 2,
 	 .sizeimage = 640 * 480 * 2,
-	 .colorspace = V4L2_COLORSPACE_JPEG,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
 	 .priv = 0},
 };
 
@@ -359,14 +358,13 @@
 static int sd_init(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *)gspca_dev;
+	int fr;
+
 	ov534_setup(gspca_dev->dev);
 
-	if (frame_rate > 0)
-		sd->frame_rate = frame_rate;
+	fr = frame_rate;
 
-	PDEBUG(D_PROBE, "frame_rate = %d", sd->frame_rate);
-
-	switch (sd->frame_rate) {
+	switch (fr) {
 	case 50:
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
 		sccb_check_status(gspca_dev->dev);
@@ -381,8 +379,9 @@
 		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
-	case 30:
+/*	case 30: */
 	default:
+		fr = 30;
 		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
 		sccb_check_status(gspca_dev->dev);
 		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
@@ -396,18 +395,15 @@
 		sccb_check_status(gspca_dev->dev);
 		ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
 		break;
-	};
+	}
+
+	PDEBUG(D_PROBE, "frame_rate: %d", fr);
 
 	return 0;
 }
 
 static int sd_start(struct gspca_dev *gspca_dev)
 {
-	PDEBUG(D_PROBE, "width = %d, height = %d",
-	       gspca_dev->width, gspca_dev->height);
-
-	gspca_dev->cam.bulk_size = gspca_dev->width * gspca_dev->height * 2;
-
 	/* start streaming data */
 	ov534_set_led(gspca_dev->dev, 1);
 	ov534_reg_write(gspca_dev->dev, 0xe0, 0x00);
@@ -433,7 +429,6 @@
 	int framesize = gspca_dev->cam.bulk_size;
 
 	if (len == framesize - 4) {
-		frame =
 		    gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);
 		frame =
 		    gspca_frame_add(gspca_dev, LAST_PACKET, frame, last_pixel,

--=-0El3OZtRtdo7wKxGoUEi
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-0El3OZtRtdo7wKxGoUEi--
