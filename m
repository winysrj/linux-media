Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6A7xaOq010800
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 03:59:36 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6A7xNjd020412
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 03:59:23 -0400
Message-ID: <4875C300.1010307@hhs.nl>
Date: Thu, 10 Jul 2008 10:06:24 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------040202080203040309050908"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-sn9c102-sensor-gain.patch
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
--------------040202080203040309050908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

<oops, resend with patch attached>

Hi,

Currently the sn9c102 gain control, only controls the digital gain in the
sn9c102, but most sensors have an analog gain in the sensor, allowing for a
much wider sensitivity range.

This patch adds support for the sensor gain for the tas5110 and ov6650 sensors.
Note that both gains are controlled with a single v4l2 ctrl, as they are both
gain. The ctrl now hs a range of 0-511, raising it one step at a time, will
first raise the sensor gain 1 one its 0-255 scale and then the next step will
raise the bridge gain on its 0-255 scale. Note that the bridge really has a
0-15 scale, so it only gets raised once every 32 steps
(of the full 0-511 scale).

This patch combined with the configurable exposure and autoexposure patch,
makes my 2 sn9c102 cams work well in a wide variety of lighting conditions.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------040202080203040309050908
Content-Type: text/x-patch;
 name="gspca-sn9c102-sensor-gain.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sn9c102-sensor-gain.patch"

Currently the sn9c102 gain control, only controls the digital gain in the
sn9c102, but most sensors have an analog gain in the sensor, allowing for a
much wider sensitivity range.

This patch adds support for the sensor gain for the tas5110 and ov6650 sensors.
Note that both gains are controlled with a single v4l2 ctrl, as they are both
gain. The ctrl now hs a range of 0-511, raising it one step at a time, will
first raise the sensor gain 1 one its 0-255 scale and then the next step will
raise the bridge gain on its 0-255 scale. Note that the bridge really has a
0-15 scale, so it only gets raised once every 32 steps
(of the full 0-511 scale).

This patch combined with the configurable exposure and autoexposure patch,
makes my 2 sn9c102 cams work well in a wide variety of lighting conditions.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

--- gspca/linux/drivers/media/video/gspca/sonixb.c	2008-07-09 22:42:11.000000000 +0200
+++ gspca.new/linux/drivers/media/video/gspca/sonixb.c	2008-07-09 21:21:44.000000000 +0200
@@ -39,14 +39,15 @@
 					   sensor, so we use a per cam copy */
 	atomic_t avg_lum;
 
+	unsigned short gain;
+	unsigned short exposure;
 	unsigned char brightness;
-	unsigned char gain;
-	unsigned char exposure;
 	unsigned char autogain;
 	unsigned char autogain_ignore_frames;
 
 	unsigned char fr_h_sz;		/* size of frame header */
 	char sensor;			/* Type of image sensor chip */
+	char sensor_has_gain;
 #define SENSOR_HV7131R 0
 #define SENSOR_OV6650 1
 #define SENSOR_OV7630 2
@@ -108,10 +109,10 @@
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Gain",
 		.minimum = 0,
-		.maximum = 255,
+		.maximum = 511,
 		.step    = 1,
-#define GAIN_DEF 127
-#define GAIN_KNEE 200
+#define GAIN_DEF 255
+#define GAIN_KNEE 400
 		.default_value = GAIN_DEF,
 	    },
 	    .set = sd_setgain,
@@ -124,9 +125,9 @@
 			.type = V4L2_CTRL_TYPE_INTEGER,
 			.name = "Exposure",
 #define EXPOSURE_DEF 0
-#define EXPOSURE_KNEE 176 /* 10 fps */
+#define EXPOSURE_KNEE 353 /* 10 fps */
 			.minimum = 0,
-			.maximum = 255,
+			.maximum = 511,
 			.step = 1,
 			.default_value = EXPOSURE_DEF,
 			.flags = 0,
@@ -541,8 +542,7 @@
 			goto err;
 		break;
 	    }
-	case SENSOR_TAS5130CXX:
-	case SENSOR_TAS5110: {
+	case SENSOR_TAS5130CXX: {
 		__u8 i2c[] =
 			{0x30, 0x11, 0x02, 0x20, 0x70, 0x00, 0x00, 0x10};
 
@@ -553,19 +553,54 @@
 			goto err;
 		break;
 	    }
+	case SENSOR_TAS5110:
+		/* FIXME figure out howto control brightness on TAS5110 */
+		break;
 	}
 	return;
 err:
 	PDEBUG(D_ERR, "i2c error brightness");
 }
 
+static void setsensorgain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	unsigned short gain;
+
+	gain = (sd->gain + 1) >> 1;
+	if (gain > 255)
+		gain = 255;
+
+	switch(sd->sensor) {
+
+	case SENSOR_TAS5110: {
+		__u8 i2c[] =
+			{0x30, 0x11, 0x02, 0x20, 0x70, 0x00, 0x00, 0x10};
+
+		i2c[4] = 255 - gain;
+		if (i2c_w(gspca_dev->dev, i2c) < 0)
+			goto err;
+		break; }
+
+	case SENSOR_OV6650: {
+		__u8 i2c[] = {0xa0, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10};
+		i2c[3] = gain;
+		if (i2c_w(gspca_dev->dev, i2c) < 0)
+			goto err;
+		break; }
+	}
+	return;
+err:
+	PDEBUG(D_ERR, "i2c error gain");
+}
+
 static void setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 gain;
 	__u8 rgb_value;
 
-	gain = sd->gain >> 4;
+	gain = sd->gain >> 5;
 
 	/* red and blue gain */
 	rgb_value = gain << 4 | gain;
@@ -573,13 +608,16 @@
 	/* green gain */
 	rgb_value = gain;
 	reg_w(gspca_dev->dev, 0x11, &rgb_value, 1);
+
+	if (sd->sensor_has_gain)
+		setsensorgain(gspca_dev);
 }
 
 static void setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	/* translate 0 - 255 to a number of fps in a 30 - 1 scale */
-	int fps = 30 - sd->exposure * 29 / 255;
+	int fps = 30 - sd->exposure * 29 / 511;
 
 	switch(sd->sensor) {
 	case SENSOR_TAS5110: {
@@ -649,6 +687,7 @@
 		case 0x6005:			/* SN9C101 */
 		case 0x6007:			/* SN9C101 */
 			sd->sensor = SENSOR_TAS5110;
+			sd->sensor_has_gain = 1;
 			sd->sd_desc.nctrls = 4;
 			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;
@@ -661,6 +700,7 @@
 			break;
 		case 0x6011:			/* SN9C101 - SN9C101G */
 			sd->sensor = SENSOR_OV6650;
+			sd->sensor_has_gain = 1; 
 			sd->sd_desc.nctrls = 4;
 			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;

--------------040202080203040309050908
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040202080203040309050908--
