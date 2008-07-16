Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GFIuld027394
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 11:18:56 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GFIDQj014877
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 11:18:13 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJ8lg-0003Ld-K4
	for video4linux-list@redhat.com; Wed, 16 Jul 2008 17:18:12 +0200
Message-ID: <487E110B.2050404@hhs.nl>
Date: Wed, 16 Jul 2008 17:17:31 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------050405000300040704060806"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-sonixb-unify-ov6650-ov7630-code.patch
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
--------------050405000300040704060806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patches merges some common code between the ov6650 and ov7630 into
single code pieces.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------050405000300040704060806
Content-Type: text/plain;
 name="gspca-sonixb-unify-ov6650-ov7630-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-sonixb-unify-ov6650-ov7630-code.patch"

This patches merges some common code between the ov6650 and ov7630 into
single code pieces.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r fb3b39eaa3c0 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 16 17:13:43 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 16 17:13:52 2008 +0200
@@ -49,6 +49,7 @@
 	unsigned char fr_h_sz;		/* size of frame header */
 	char sensor;			/* Type of image sensor chip */
 	char sensor_has_gain;
+	__u8 sensor_addr;
 #define SENSOR_HV7131R 0
 #define SENSOR_OV6650 1
 #define SENSOR_OV7630 2
@@ -521,21 +522,14 @@
 	__u8 value;
 
 	switch (sd->sensor) {
-	case SENSOR_OV6650: {
-		__u8 i2cOV6650[] =
-			{0xa0, 0x60, 0x06, 0x11, 0x99, 0x04, 0x94, 0x15};
-
-		i2cOV6650[3] = sd->brightness;
-		if (i2c_w(gspca_dev, i2cOV6650) < 0)
-			 goto err;
-		break;
-	    }
+	case  SENSOR_OV6650:
 	case  SENSOR_OV7630_3:
 	case  SENSOR_OV7630: {
 		__u8 i2cOV[] =
-			{0xa0, 0x21, 0x06, 0x36, 0xbd, 0x06, 0xf6, 0x16};
+			{0xa0, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x10};
 
 		/* change reg 0x06 */
+		i2cOV[1] = sd->sensor_addr;
 		i2cOV[3] = sd->brightness;
 		if (i2c_w(gspca_dev, i2cOV) < 0)
 			goto err;
@@ -605,6 +599,7 @@
 static void setsensorgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	unsigned char gain = sd->gain;
 
 	switch (sd->sensor) {
 
@@ -612,23 +607,19 @@
 		__u8 i2c[] =
 			{0x30, 0x11, 0x02, 0x20, 0x70, 0x00, 0x00, 0x10};
 
-		i2c[4] = 255 - sd->gain;
+		i2c[4] = 255 - gain;
 		if (i2c_w(gspca_dev, i2c) < 0)
 			goto err;
 		break;
 	    }
-	case SENSOR_OV6650: {
-		__u8 i2c[] = {0xa0, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10};
 
-		i2c[3] = sd->gain >> 3;
-		if (i2c_w(gspca_dev, i2c) < 0)
-			goto err;
-		break;
-	    }
+	case SENSOR_OV6650:
+		gain >>= 1;
 	case SENSOR_OV7630_3: {
-		__u8 i2c[] = {0xa0, 0x21, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10};
+		__u8 i2c[] = {0xa0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10};
 
-		i2c[3] = sd->gain >> 2;
+		i2c[1] = sd->sensor_addr;
+		i2c[3] = gain >> 2;
 		if (i2c_w(gspca_dev, i2c) < 0)
 			goto err;
 		break;
@@ -678,9 +669,10 @@
 		reg_w(gspca_dev, 0x19, &reg, 1);
 		break;
 	    }
-	case SENSOR_OV6650: {
-		/* The ov6650 has 2 registers which both influence exposure,
-		   first there is register 11, whose low nibble sets the no fps
+	case SENSOR_OV6650:
+	case SENSOR_OV7630_3: {
+		/* The ov6650 / ov7630 have 2 registers which both influence
+		   exposure, register 11, whose low nibble sets the nr off fps
 		   according to: fps = 30 / (low_nibble + 1)
 
 		   The fps configures the maximum exposure setting, but it is
@@ -693,15 +685,15 @@
 		   The code maps our 0 - 510 ms exposure ctrl to these 2
 		   registers, trying to keep fps as high as possible.
 		*/
-		__u8 i2c[] = {0xb0, 0x60, 0x10, 0x00, 0xc0, 0x00, 0x00, 0x10};
+		__u8 i2c[] = {0xb0, 0x00, 0x10, 0x00, 0xc0, 0x00, 0x00, 0x10};
 		int reg10, reg11;
 		/* ov6645 datasheet says reg10_max is 9a, but that uses
 		   tline * 2 * reg10 as formula for calculating texpo, the
 		   ov6650 probably uses the same formula as the 7730 which uses
 		   tline * 4 * reg10, which explains why the reg10max we've
 		   found experimentally for the ov6650 is exactly half that of
-		   the ov6645. */
-		const int reg10_max = 0x4d;
+		   the ov6645. The ov7630 datasheet says the max is 0x41. */
+		const int reg10_max = (sd->sensor == SENSOR_OV6650)? 0x4d:0x41;
 
 		reg11 = (60 * sd->exposure + 999) / 1000;
 		if (reg11 < 1)
@@ -723,34 +715,7 @@
 			reg10 = reg10_max;
 
 		/* Write reg 10 and reg11 low nibble */
-		i2c[3] = reg10;
-		i2c[4] |= reg11 - 1;
-		if (i2c_w(gspca_dev, i2c) < 0)
-			PDEBUG(D_ERR, "i2c error exposure");
-		break;
-	    }
-	case SENSOR_OV7630_3: {
-		__u8 i2c[] = {0xb0, 0x21, 0x10, 0x00, 0xc0, 0x00, 0x00, 0x10};
-		int reg10, reg11;
-		/* No clear idea why, but setting reg10 above this value
-		   results in no change */
-		const int reg10_max = 0x4d;
-
-		reg11 = (60 * sd->exposure + 999) / 1000;
-		if (reg11 < 1)
-			reg11 = 1;
-		else if (reg11 > 16)
-			reg11 = 16;
-
-		/* frame exposure time in ms = 1000 * reg11 / 30    ->
-		reg10 = sd->exposure * 2 * reg10_max / (1000 * reg11 / 30) */
-		reg10 = (sd->exposure * 60 * reg10_max) / (1000 * reg11);
-		if (reg10 < 1) /* 0 is a valid value, but is very _black_ */
-			reg10 = 1;
-		else if (reg10 > reg10_max)
-			reg10 = reg10_max;
-
-		/* Write reg 10 and reg11 low nibble */
+		i2c[1] = sd->sensor_addr;
 		i2c[3] = reg10;
 		i2c[4] |= reg11 - 1;
 		if (i2c_w(gspca_dev, i2c) < 0)
@@ -848,6 +813,7 @@
 		case 0x6011:			/* SN9C101 - SN9C101G */
 			sd->sensor = SENSOR_OV6650;
 			sd->sensor_has_gain = 1;
+			sd->sensor_addr = 0x60;
 			sd->sd_desc.nctrls = 4;
 			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;
@@ -856,9 +822,11 @@
 		case 0x602c:			/* SN9C102 */
 		case 0x602e:			/* SN9C102 */
 			sd->sensor = SENSOR_OV7630;
+			sd->sensor_addr = 0x21;
 			break;
 		case 0x60b0:			/* SN9C103 */
 			sd->sensor = SENSOR_OV7630_3;
+			sd->sensor_addr = 0x21;
 			sd->fr_h_sz = 18;	/* size of frame header */
 			sd->sensor_has_gain = 1;
 			sd->sd_desc.nctrls = 4;

--------------050405000300040704060806
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050405000300040704060806--
