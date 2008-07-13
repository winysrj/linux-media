Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DJZqPj014864
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 15:35:52 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DJZdHT009984
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 15:35:40 -0400
Message-ID: <487A5AC1.7020203@hhs.nl>
Date: Sun, 13 Jul 2008 21:42:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------060007000206030805080003"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-sonixb-ov6650-gain.patch
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
--------------060007000206030805080003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch contains the following changes:
1) It turns out that the ov6650 gain only has 5 significant bits, not 8
    (oops)
2) Make the auto exposure code slightly less nervous (make deadzone larger,
    standardize gain and exposure settings to 0-255 range instead of the
    strange 0-511 I used before)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------060007000206030805080003
Content-Type: text/x-patch;
 name="gspca-sonixb-ov6650-gain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-ov6650-gain.patch"

This patch contains the following changes: 
1) It turns out that the ov6650 gain only has 5 significant bits, not 8
   (oops)
2) Make the auto exposure code slightly less nervous (make deadzone larger,
   standardize gain and exposure settings to 0-255 range instead of the
   strange 0-511 I used before)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 8db437b06853 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Jul 10 10:41:35 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Sun Jul 13 21:38:05 2008 +0200
@@ -39,8 +39,8 @@
 					   sensor, so we use a per cam copy */
 	atomic_t avg_lum;
 
-	unsigned short gain;
-	unsigned short exposure;
+	unsigned char gain;
+	unsigned char exposure;
 	unsigned char brightness;
 	unsigned char autogain;
 	unsigned char autogain_ignore_frames;
@@ -73,7 +73,7 @@
    ignore atleast the 2 next frames for the new settings to come into effect
    before doing any other adjustments */
 #define AUTOGAIN_IGNORE_FRAMES 3
-#define AUTOGAIN_DEADZONE 500
+#define AUTOGAIN_DEADZONE 1000
 #define DESIRED_AVG_LUM 7000
 
 /* V4L2 controls supported by the driver */
@@ -109,10 +109,10 @@
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Gain",
 		.minimum = 0,
-		.maximum = 511,
+		.maximum = 255,
 		.step    = 1,
-#define GAIN_DEF 255
-#define GAIN_KNEE 400
+#define GAIN_DEF 127
+#define GAIN_KNEE 200
 		.default_value = GAIN_DEF,
 	    },
 	    .set = sd_setgain,
@@ -125,9 +125,9 @@
 			.type = V4L2_CTRL_TYPE_INTEGER,
 			.name = "Exposure",
 #define EXPOSURE_DEF 0
-#define EXPOSURE_KNEE 353 /* 10 fps */
+#define EXPOSURE_KNEE 176 /* 10 fps */
 			.minimum = 0,
-			.maximum = 511,
+			.maximum = 255,
 			.step = 1,
 			.default_value = EXPOSURE_DEF,
 			.flags = 0,
@@ -565,11 +565,6 @@
 static void setsensorgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	unsigned short gain;
-
-	gain = (sd->gain + 1) >> 1;
-	if (gain > 255)
-		gain = 255;
 
 	switch(sd->sensor) {
 
@@ -577,14 +572,14 @@
 		__u8 i2c[] =
 			{0x30, 0x11, 0x02, 0x20, 0x70, 0x00, 0x00, 0x10};
 
-		i2c[4] = 255 - gain;
+		i2c[4] = 255 - sd->gain;
 		if (i2c_w(gspca_dev->dev, i2c) < 0)
 			goto err;
 		break; }
 
 	case SENSOR_OV6650: {
 		__u8 i2c[] = {0xa0, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10};
-		i2c[3] = gain;
+		i2c[3] = sd->gain >> 3;
 		if (i2c_w(gspca_dev->dev, i2c) < 0)
 			goto err;
 		break; }
@@ -600,7 +595,7 @@
 	__u8 gain;
 	__u8 rgb_value;
 
-	gain = sd->gain >> 5;
+	gain = sd->gain >> 4;
 
 	/* red and blue gain */
 	rgb_value = gain << 4 | gain;
@@ -617,7 +612,7 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	/* translate 0 - 255 to a number of fps in a 30 - 1 scale */
-	int fps = 30 - sd->exposure * 29 / 511;
+	int fps = 30 - sd->exposure * 29 / 255;
 
 	switch(sd->sensor) {
 	case SENSOR_TAS5110: {

--------------060007000206030805080003
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060007000206030805080003--
