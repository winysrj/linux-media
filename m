Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7O9QkHh017896
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 05:26:46 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7O9QXJr013527
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 05:26:33 -0400
Message-ID: <48B12BD3.1060401@hhs.nl>
Date: Sun, 24 Aug 2008 11:37:23 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------070101060000050504010400"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-sonixb-use-disable_ctrls.patch
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
--------------070101060000050504010400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi JF,

We sorta agreed that I would be maintaining the sonixb (and pac207) driver, and 
would feed patches to Mauro through my own tree, but given the amount of 
changes still going on in gspca I prefer to keep sending patches through you 
for now, esp. as this patch depends upon changes in your tree.

* Now that we have it use gspca_dev->ctrl_dis in sonixb instead of the previous
   hack were we put a modifiable copy of our const sd_desc in our sd struct and
   change nctrls there.

* In the ov6650 / 7650 exposure code clamp reg 11 before (instead of after)
   using it to calculate reg 10.

* Now that we can disable per ctrl, disable brightness (instead of ignoring it)
   for the TAS5110

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------070101060000050504010400
Content-Type: text/plain;
 name="gspca-sonixb-use-disable_ctrls.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-use-disable_ctrls.patch"

* Now that we have it use gspca_dev->ctrl_dis in sonixb instead of the previous
  hack were we put a modifiable copy of our const sd_desc in our sd struct and
  change nctrls there.

* In the ov6650 / 7650 exposure code clamp reg 11 before (instead of after)
  using it to calculate reg 10.

* Now that we can disable per ctrl, disable brightness (instead of ignoring it)
  for the TAS5110

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
--- a/linux/drivers/media/video/gspca/sonixb.c	Sat Aug 23 12:56:49 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Sun Aug 24 10:16:29 2008 +0200
@@ -31,9 +31,6 @@
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
-
-	struct sd_desc sd_desc;		/* our nctrls differ dependend upon the
-					   sensor, so we use a per cam copy */
 	atomic_t avg_lum;
 
 	unsigned char gain;
@@ -60,9 +57,8 @@
 
 /* flags used in the device id table */
 #define F_GAIN 0x01		/* has gain */
-#define F_AUTO 0x02		/* has autogain */
-#define F_SIF  0x04		/* sif or vga */
-#define F_H18  0x08		/* long (18 b) or short (12 b) frame header */
+#define F_SIF  0x02		/* sif or vga */
+#define F_H18  0x04		/* long (18 b) or short (12 b) frame header */
 
 #define COMP2 0x8f
 #define COMP 0xc7		/* 0x87 //0x07 */
@@ -95,6 +91,7 @@
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);
 
 static struct ctrl sd_ctrls[] = {
+#define BRIGHTNESS_IDX 0
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
@@ -109,6 +106,7 @@
 	    .set = sd_setbrightness,
 	    .get = sd_getbrightness,
 	},
+#define GAIN_IDX 1
 	{
 	    {
 		.id      = V4L2_CID_GAIN,
@@ -124,6 +122,7 @@
 	    .set = sd_setgain,
 	    .get = sd_getgain,
 	},
+#define EXPOSURE_IDX 2
 	{
 		{
 			.id = V4L2_CID_EXPOSURE,
@@ -140,6 +139,7 @@
 		.set = sd_setexposure,
 		.get = sd_getexposure,
 	},
+#define AUTOGAIN_IDX 3
 	{
 		{
 			.id = V4L2_CID_AUTOGAIN,
@@ -155,6 +155,7 @@
 		.set = sd_setautogain,
 		.get = sd_getautogain,
 	},
+#define FREQ_IDX 4
 	{
 		{
 			.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
@@ -578,9 +579,6 @@
 			goto err;
 		break;
 	    }
-	case SENSOR_TAS5110:
-		/* FIXME figure out howto control brightness on TAS5110 */
-		break;
 	}
 	return;
 err:
@@ -698,6 +696,11 @@
 		else if (reg11 > 16)
 			reg11 = 16;
 
+		/* In 640x480, if the reg11 has less than 3, the image is
+		   unstable (not enough bandwidth). */
+		if (gspca_dev->width == 640 && reg11 < 3)
+			reg11 = 3;
+
 		/* frame exposure time in ms = 1000 * reg11 / 30    ->
 		reg10 = sd->exposure * 2 * reg10_max / (1000 * reg11 / 30) */
 		reg10 = (sd->exposure * 60 * reg10_max) / (1000 * reg11);
@@ -710,11 +713,6 @@
 			reg10 = 10;
 		else if (reg10 > reg10_max)
 			reg10 = reg10_max;
-
-		/* In 640x480, if the reg11 has less than 3, the image is
-		   unstable (not enough bandwidth). */
-		if (gspca_dev->width == 640 && reg11 < 3)
-			reg11 = 3;
 
 		/* Write reg 10 and reg11 low nibble */
 		i2c[1] = sd->sensor_addr;
@@ -792,23 +790,17 @@
 	struct cam *cam;
 	int sif = 0;
 
-	/* nctrls depends upon the sensor, so we use a per cam copy */
-	memcpy(&sd->sd_desc, gspca_dev->sd_desc, sizeof(struct sd_desc));
-	gspca_dev->sd_desc = &sd->sd_desc;
-
 	/* copy the webcam info from the device id */
 	sd->sensor = (id->driver_info >> 24) & 0xff;
 	if (id->driver_info & (F_GAIN << 16))
 		sd->sensor_has_gain = 1;
-	if (id->driver_info & (F_AUTO << 16))
-		sd->sd_desc.dq_callback = do_autogain;
 	if (id->driver_info & (F_SIF << 16))
 		sif = 1;
 	if (id->driver_info & (F_H18 << 16))
 		sd->fr_h_sz = 18;		/* size of frame header */
 	else
 		sd->fr_h_sz = 12;
-	sd->sd_desc.nctrls = (id->driver_info >> 8) & 0xff;
+	gspca_dev->ctrl_dis = (id->driver_info >> 8) & 0xff;
 	sd->sensor_addr = id->driver_info & 0xff;
 
 	cam = &gspca_dev->cam;
@@ -823,7 +815,10 @@
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
-	sd->autogain = AUTOGAIN_DEF;
+	if (gspca_dev->ctrl_dis & (1 << AUTOGAIN_IDX))
+		sd->autogain = 0; /* Disable do_autogain callback */
+	else
+		sd->autogain = AUTOGAIN_DEF;
 	sd->freq = FREQ_DEF;
 
 	return 0;
@@ -1202,50 +1197,55 @@
 	.close = sd_close,
 	.pkt_scan = sd_pkt_scan,
 	.querymenu = sd_querymenu,
+	.dq_callback = do_autogain,
 };
 
 /* -- module initialisation -- */
-#define SFCI(sensor, flags, nctrls, i2c_addr) \
+#define SFCI(sensor, flags, disable_ctrls, i2c_addr) \
 	.driver_info = (SENSOR_ ## sensor << 24) \
 			| ((flags) << 16) \
-			| ((nctrls) << 8) \
+			| ((disable_ctrls) << 8) \
 			| (i2c_addr)
+#define NO_EXPO ((1 << EXPOSURE_IDX) | (1 << AUTOGAIN_IDX))
+#define NO_FREQ (1 << FREQ_IDX)
+#define NO_BRIGHTNESS (1 << BRIGHTNESS_IDX)
+
 static __devinitdata struct usb_device_id device_table[] = {
 #ifndef CONFIG_USB_SN9C102
 	{USB_DEVICE(0x0c45, 0x6001),			/* SN9C102 */
-			SFCI(TAS5110, F_GAIN|F_AUTO|F_SIF, 4, 0)},
+			SFCI(TAS5110, F_GAIN|F_SIF, NO_BRIGHTNESS|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6005),			/* SN9C101 */
-			SFCI(TAS5110, F_GAIN|F_AUTO|F_SIF, 4, 0)},
+			SFCI(TAS5110, F_GAIN|F_SIF, NO_BRIGHTNESS|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6007),			/* SN9C101 */
-			SFCI(TAS5110, F_GAIN|F_AUTO|F_SIF, 4, 0)},
+			SFCI(TAS5110, F_GAIN|F_SIF, NO_BRIGHTNESS|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6009),			/* SN9C101 */
-			SFCI(PAS106, F_SIF, 2, 0)},
+			SFCI(PAS106, F_SIF, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x600d),			/* SN9C101 */
-			SFCI(PAS106, F_SIF, 2, 0)},
+			SFCI(PAS106, F_SIF, NO_EXPO|NO_FREQ, 0)},
 #endif
 	{USB_DEVICE(0x0c45, 0x6011),		/* SN9C101 - SN9C101G */
-			SFCI(OV6650, F_GAIN|F_AUTO|F_SIF, 5, 0x60)},
+			SFCI(OV6650, F_GAIN|F_SIF, 0, 0x60)},
 #ifndef CONFIG_USB_SN9C102
 	{USB_DEVICE(0x0c45, 0x6019),			/* SN9C101 */
-			SFCI(OV7630, F_GAIN|F_AUTO, 5, 0x21)},
+			SFCI(OV7630, F_GAIN, 0, 0x21)},
 	{USB_DEVICE(0x0c45, 0x6024),			/* SN9C102 */
-			SFCI(TAS5130CXX, 0, 2, 0)},
+			SFCI(TAS5130CXX, 0, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6025),			/* SN9C102 */
-			SFCI(TAS5130CXX, 0, 2, 0)},
+			SFCI(TAS5130CXX, 0, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6028),			/* SN9C102 */
-			SFCI(PAS202, 0, 2, 0)},
+			SFCI(PAS202, 0, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x6029),			/* SN9C101 */
-			SFCI(PAS106, F_SIF, 2, 0)},
+			SFCI(PAS106, F_SIF, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x602c),			/* SN9C102 */
-			SFCI(OV7630, F_GAIN|F_AUTO, 5, 0x21)},
+			SFCI(OV7630, F_GAIN, 0, 0x21)},
 	{USB_DEVICE(0x0c45, 0x602d),			/* SN9C102 */
-			SFCI(HV7131R, 0, 2, 0)},
+			SFCI(HV7131R, 0, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x602e),			/* SN9C102 */
-			SFCI(OV7630, F_GAIN|F_AUTO, 5, 0x21)},
+			SFCI(OV7630, F_GAIN, 0, 0x21)},
 	{USB_DEVICE(0x0c45, 0x60af),			/* SN9C103 */
-			SFCI(PAS202, F_H18, 2, 0)},
+			SFCI(PAS202, F_H18, NO_EXPO|NO_FREQ, 0)},
 	{USB_DEVICE(0x0c45, 0x60b0),			/* SN9C103 */
-			SFCI(OV7630, F_GAIN|F_AUTO|F_H18, 5, 0x21)},
+			SFCI(OV7630, F_GAIN|F_H18, 0, 0x21)},
 #endif
 	{}
 };

--------------070101060000050504010400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070101060000050504010400--
