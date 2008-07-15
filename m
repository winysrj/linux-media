Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6F985vZ015402
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 05:08:05 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6F977oD017655
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 05:07:08 -0400
Message-ID: <487C6A7A.3000400@hhs.nl>
Date: Tue, 15 Jul 2008 11:14:34 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------010804020209040108030608"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-sonixb-ov6650-better-exposure.patch
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
--------------010804020209040108030608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

After much investigation I'm happy to submit the "perfect" exposure patch for
ov6650 (probably translatable to other ovxxxx sensors), the ov6650 has 2
different registers which control exposure by using these both the exposure
can be configured from 0 to 500ms in small increments. This patch implements
this for details see the comments in the patch.

Being able to set the exposure below 33 ms (30 fps default exposure) allows
for proper use of ov6650 based cams in full daylight, yeah!

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------010804020209040108030608
Content-Type: text/x-patch;
 name="gspca-sonixb-ov6650-beteer-exposure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-sonixb-ov6650-beteer-exposure.patch"

After much investigation I'm happy to submit the "perfect" exposure patch for
ov6650 (probably translatable to other ovxxxx sensors), the ov6650 has 2
different registers which control exposure by using these both the exposure
can be configured from 0 to 500ms in small increments. This patch implements
this for details see the comments in the patch.

Being able to set the exposure below 33 ms (30 fps default exposure) allows
for proper use of ov6650 based cams in full daylight.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r fa6e3138e75c linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Mon Jul 14 18:53:03 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Tue Jul 15 11:06:40 2008 +0200
@@ -121,8 +121,8 @@
 			.id = V4L2_CID_EXPOSURE,
 			.type = V4L2_CTRL_TYPE_INTEGER,
 			.name = "Exposure",
-#define EXPOSURE_DEF 0
-#define EXPOSURE_KNEE 176 /* 10 fps */
+#define EXPOSURE_DEF  16 /*  32 ms / 30 fps */
+#define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
 			.minimum = 0,
 			.maximum = 255,
 			.step = 1,
@@ -637,8 +637,6 @@
 static void setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	/* translate 0 - 255 to a number of fps in a 30 - 1 scale */
-	int fps = 30 - sd->exposure * 29 / 255;
 
 	switch (sd->sensor) {
 	case SENSOR_TAS5110: {
@@ -647,19 +645,53 @@
 		/* register 19's high nibble contains the sn9c10x clock divider
 		   The high nibble configures the no fps according to the
 		   formula: 60 / high_nibble. With a maximum of 30 fps */
-		reg = 60 / fps;
-		if (reg > 15)
+		reg = 120 * sd->exposure / 1000;
+		if (reg < 2)
+			reg = 2;
+		else if (reg > 15)
 			reg = 15;
 		reg = (reg << 4) | 0x0b;
 		reg_w(gspca_dev, 0x19, &reg, 1);
 		break;
 	    }
 	case SENSOR_OV6650: {
-		__u8 i2c[] = {0xa0, 0x60, 0x11, 0xc0, 0x00, 0x00, 0x00, 0x10};
-		i2c[3] = 30 / fps - 1;
-		if (i2c[3] > 15)
-			i2c[3] = 15;
-		i2c[3] |= 0xc0;
+		/* The ov6650 has 2 registers which both influence exposure,
+		   first there is register 11, whose low nibble sets the no fps
+		   according to: fps = 30 / (low_nibble + 1)
+
+		   The fps configures the maximum exposure setting, but it is 
+		   possible to use less exposure then what the fps maximum
+		   allows by setting register 10. register 10 configures the
+		   actual exposure as quotient of the full exposure, with 0
+ 		   being no exposure at all (not very usefull) and reg10_max
+ 		   being max exposure possible at that framerate.
+
+		   The code maps our 0 - 510 ms exposure ctrl to these 2
+		   registers, trying to keep fps as high as possible.
+		*/ 
+		__u8 i2c[] = {0xb0, 0x60, 0x10, 0x00, 0xc0, 0x00, 0x00, 0x10};
+		int reg10, reg11;
+		/* No clear idea why, but setting reg10 above this value
+		   results in no change */
+		const int reg10_max = 0x4d;
+
+		reg11 = (60 * sd->exposure + 999) / 1000;
+		if (reg11 < 1)
+			reg11 = 1;
+		else if (reg11 > 16)
+			reg11 = 16;
+
+		/* frame exposure time in ms = 1000 * reg11 / 30    ->
+		reg10 = sd->exposure * 2 * reg10_max / (1000 * reg11 / 30) */
+		reg10 = (sd->exposure * 60 * reg10_max) / (1000 * reg11);
+		if (reg10 < 1) /* 0 is a valid value, but is very _black_ */
+			reg10 = 1;
+		else if (reg10 > reg10_max)
+			reg10 = reg10_max;
+
+		/* Write reg 10 and reg11 low nibble */
+		i2c[3] = reg10;
+		i2c[4] |= reg11 - 1;
 		if (i2c_w(gspca_dev, i2c) < 0)
 			PDEBUG(D_ERR, "i2c error exposure");
 		break;

--------------010804020209040108030608
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------010804020209040108030608--
