Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69DW859011004
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 09:32:08 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69DVgCe004375
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 09:31:43 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KGZlm-0003iA-Cp
	for video4linux-list@redhat.com; Wed, 09 Jul 2008 15:31:42 +0200
Message-ID: <4874BD98.4020309@hhs.nl>
Date: Wed, 09 Jul 2008 15:31:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------080802030209060402010301"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-sn9c102-autoexposure.patch
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
--------------080802030209060402010301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch adds exposure control and autoexposure for sn9c102 cams which use
a tas5110 or a ov6650 image sensor.

It also renames the contrast control to gain, as that is what it is.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------080802030209060402010301
Content-Type: text/plain;
 name="gspca-sn9c102-autoexposure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sn9c102-autoexposure.patch"

This patch adds exposure control and autoexposure for sn9c102 cams which use
a tas5110 or a ov6650 image sensor.

It also renames the contrast control to gain, as that is what it is.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r f69de2a58412 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Wed Jul 09 09:49:21 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Wed Jul 09 13:14:35 2008 +0200
@@ -1835,6 +1835,9 @@
 	   desired lumination fast (with the risc of a slight overshoot) */
 	steps = abs(desired_avg_lum - avg_lum) / deadzone;
 
+	PDEBUG(D_FRAM, "autogain: lum: %d, desired: %d, steps: %d\n",
+		avg_lum, desired_avg_lum, steps);
+
 	for (i = 0; i < steps; i++) {
 		if (avg_lum > desired_avg_lum) {
 			if (gain > gain_knee)
diff -r f69de2a58412 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 09 09:49:21 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Wed Jul 09 13:14:35 2008 +0200
@@ -35,8 +35,15 @@
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
+	struct sd_desc sd_desc;		/* our nctrls differ dependend upon the
+					   sensor, so we use a per cam copy */
+	atomic_t avg_lum;
+
 	unsigned char brightness;
-	unsigned char contrast;
+	unsigned char gain;
+	unsigned char exposure;
+	unsigned char autogain;
+	unsigned char autogain_ignore_frames;
 
 	unsigned char fr_h_sz;		/* size of frame header */
 	char sensor;			/* Type of image sensor chip */
@@ -59,11 +66,24 @@
 
 #define SYS_CLK 0x04
 
+/* We calculate the autogain at the end of the transfer of a frame, at this
+   moment a frame with the old settings is being transmitted, and a frame is
+   being captured with the old settings. So if we adjust the autogain we must
+   ignore atleast the 2 next frames for the new settings to come into effect
+   before doing any other adjustments */
+#define AUTOGAIN_IGNORE_FRAMES 3
+#define AUTOGAIN_DEADZONE 500
+#define DESIRED_AVG_LUM 7000
+
 /* V4L2 controls supported by the driver */
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 
 static struct ctrl sd_ctrls[] = {
 #define SD_BRIGHTNESS 0
@@ -75,24 +95,59 @@
 		.minimum = 0,
 		.maximum = 255,
 		.step    = 1,
-		.default_value = 127,
+#define BRIGHTNESS_DEF 127
+		.default_value = BRIGHTNESS_DEF,
 	    },
 	    .set = sd_setbrightness,
 	    .get = sd_getbrightness,
 	},
-#define SD_CONTRAST 1
+#define SD_GAIN 1
 	{
 	    {
-		.id      = V4L2_CID_CONTRAST,
+		.id      = V4L2_CID_GAIN,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Contrast",
+		.name    = "Gain",
 		.minimum = 0,
 		.maximum = 255,
 		.step    = 1,
-		.default_value = 127,
+#define GAIN_DEF 127
+#define GAIN_KNEE 200
+		.default_value = GAIN_DEF,
 	    },
-	    .set = sd_setcontrast,
-	    .get = sd_getcontrast,
+	    .set = sd_setgain,
+	    .get = sd_getgain,
+	},
+#define SD_EXPOSURE 2
+	{
+		{
+			.id = V4L2_CID_EXPOSURE,
+			.type = V4L2_CTRL_TYPE_INTEGER,
+			.name = "Exposure",
+#define EXPOSURE_DEF 0
+#define EXPOSURE_KNEE 176 /* 10 fps */
+			.minimum = 0,
+			.maximum = 255,
+			.step = 1,
+			.default_value = EXPOSURE_DEF,
+			.flags = 0,
+		},
+		.set = sd_setexposure,
+		.get = sd_getexposure,
+	},
+#define SD_AUTOGAIN 3
+	{
+		{
+			.id = V4L2_CID_AUTOGAIN,
+			.type = V4L2_CTRL_TYPE_BOOLEAN,
+			.name = "Automatic Gain (and Exposure)",
+			.minimum = 0,
+			.maximum = 1,
+			.step = 1,
+			.default_value = 1,
+			.flags = 0,
+		},
+		.set = sd_setautogain,
+		.get = sd_getautogain,
 	},
 };
 
@@ -161,8 +216,12 @@
 	/* Bright, contrast, etc are set througth SCBB interface.
 	 * AVCAP on win2 do not send any data on this 	controls. */
 	/* Anyway, some registers appears to alter bright and constrat */
+	
+	/* Reset sensor */
 	{0xa0, 0x60, 0x12, 0x80, 0x00, 0x00, 0x00, 0x10},
+	/* Set clock register 0x11 low nibble is clock divider */
 	{0xd0, 0x60, 0x11, 0xc0, 0x1b, 0x18, 0xc1, 0x10},
+	/* Next some unknown stuff */
 	{0xb0, 0x60, 0x15, 0x00, 0x02, 0x18, 0xc1, 0x10},
 /*	{0xa0, 0x60, 0x1b, 0x01, 0x02, 0x18, 0xc1, 0x10},
 		 * THIS SET GREEN SCREEN
@@ -171,31 +230,36 @@
 	{0xd0, 0x60, 0x26, 0x01, 0x14, 0xd8, 0xa4, 0x10}, /* format out? */
 	{0xd0, 0x60, 0x26, 0x01, 0x14, 0xd8, 0xa4, 0x10},
 	{0xa0, 0x60, 0x30, 0x3d, 0x0A, 0xd8, 0xa4, 0x10},
-	{0xb0, 0x60, 0x60, 0x66, 0x68, 0xd8, 0xa4, 0x10},
+	/* Disable autobright ? */
+	{0xb0, 0x60, 0x60, 0x66, 0x68, 0xd8, 0xa4, 0x10}, 
+	/* Some more unknown stuff */
 	{0xa0, 0x60, 0x68, 0x04, 0x68, 0xd8, 0xa4, 0x10},
 	{0xd0, 0x60, 0x17, 0x24, 0xd6, 0x04, 0x94, 0x10}, /* Clipreg */
-	{0xa0, 0x60, 0x10, 0x5d, 0x99, 0x04, 0x94, 0x16},
+	{0xa0, 0x60, 0x10, 0x57, 0x99, 0x04, 0x94, 0x16},
+	/* Framerate adjust register for artificial light 50 hz flicker
+	   compensation, identical to ov6630 0x2b register, see 6630 datasheet.
+	   0x4f -> (30 fps -> 25 fps), 0x00 -> no adjustment */
+	{0xa0, 0x60, 0x2b, 0x4f, 0x99, 0x04, 0x94, 0x15},
+#if 0
+	/* HDG, don't change registers 0x2d, 0x32 & 0x33 from their reset
+	   defaults, doing so mucks up the framerate, where as the defaults
+	   seem to work good, the combinations below have been observed
+	   under windows and are kept for future reference */
 	{0xa0, 0x60, 0x2d, 0x0a, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x32, 0x00, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x33, 0x40, 0x99, 0x04, 0x94, 0x16},
-	{0xa0, 0x60, 0x11, 0xc0, 0x99, 0x04, 0x94, 0x16},
-	{0xa0, 0x60, 0x00, 0x16, 0x99, 0x04, 0x94, 0x15}, /* bright / Lumino */
-	{0xa0, 0x60, 0x2b, 0xab, 0x99, 0x04, 0x94, 0x15},
-							/* ?flicker o brillo */
 	{0xa0, 0x60, 0x2d, 0x2a, 0x99, 0x04, 0x94, 0x15},
 	{0xa0, 0x60, 0x2d, 0x2b, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x32, 0x00, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x33, 0x00, 0x99, 0x04, 0x94, 0x16},
-	{0xa0, 0x60, 0x10, 0x57, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x2d, 0x2b, 0x99, 0x04, 0x94, 0x16},
 	{0xa0, 0x60, 0x32, 0x00, 0x99, 0x04, 0x94, 0x16},
 		/* Low Light (Enabled: 0x32 0x1 | Disabled: 0x32 0x00) */
 	{0xa0, 0x60, 0x33, 0x29, 0x99, 0x04, 0x94, 0x16},
 		/* Low Ligth (Enabled: 0x33 0x13 | Disabled: 0x33 0x29) */
-/*	{0xa0, 0x60, 0x11, 0xc1, 0x99, 0x04, 0x94, 0x16}, */
-	{0xa0, 0x60, 0x00, 0x17, 0x99, 0x04, 0x94, 0x15}, /* clip? r */
-	{0xa0, 0x60, 0x00, 0x18, 0x99, 0x04, 0x94, 0x15}, /* clip? r */
+#endif
 };
+
 static const __u8 initOv7630[] = {
 	0x04, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,	/* r01 .. r08 */
 	0x21, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* r09 .. r10 */
@@ -494,19 +558,69 @@
 err:
 	PDEBUG(D_ERR, "i2c error brightness");
 }
-static void setcontrast(struct gspca_dev *gspca_dev)
+
+static void setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 gain;
 	__u8 rgb_value;
 
-	gain = sd->contrast >> 4;
+	gain = sd->gain >> 4;
+
 	/* red and blue gain */
 	rgb_value = gain << 4 | gain;
 	reg_w(gspca_dev->dev, 0x10, &rgb_value, 1);
 	/* green gain */
 	rgb_value = gain;
 	reg_w(gspca_dev->dev, 0x11, &rgb_value, 1);
+}
+
+static void setexposure(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	/* translate 0 - 255 to a number of fps in a 30 - 1 scale */
+	int fps = 30 - sd->exposure * 29 / 255;
+
+	switch(sd->sensor) {
+	case SENSOR_TAS5110: {
+		__u8 reg;
+
+		/* register 19's high nibble contains the sn9c10x clock divider
+		   The high nibble configures the no fps according to the
+		   formula: 60 / high_nibble. With a maximum of 30 fps */
+		reg = 60 / fps;
+		if (reg > 15)
+			reg = 15;
+		reg = (reg << 4) | 0x0b;
+		reg_w(gspca_dev->dev, 0x19, &reg, 1);
+		break; }
+	case SENSOR_OV6650: {
+		__u8 i2c[] = {0xa0, 0x60, 0x11, 0xc0, 0x00, 0x00, 0x00, 0x10};
+		i2c[3] = 30 / fps - 1;
+		if (i2c[3] > 15)
+			i2c[3] = 15;
+		i2c[3] |= 0xc0;
+		if (i2c_w(gspca_dev->dev, i2c) < 0)
+			PDEBUG(D_ERR, "i2c error exposure");
+		break; }
+	}
+}
+
+
+static void do_autogain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int avg_lum = atomic_read(&sd->avg_lum);
+
+	if (avg_lum == -1)
+		return;
+
+	if (sd->autogain_ignore_frames > 0)
+		sd->autogain_ignore_frames--;
+	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum,
+			sd->brightness * DESIRED_AVG_LUM / 127,
+			AUTOGAIN_DEADZONE, GAIN_KNEE, EXPOSURE_KNEE))
+		sd->autogain_ignore_frames = AUTOGAIN_IGNORE_FRAMES;
 }
 
 /* this function is called at probe time */
@@ -519,7 +633,13 @@
 	__u16 product;
 	int sif = 0;
 
+	/* nctrls depends upon the sensor, so we use a per cam copy */
+	memcpy(&sd->sd_desc, gspca_dev->sd_desc, sizeof(struct sd_desc));
+	gspca_dev->sd_desc = &sd->sd_desc;
+
 	sd->fr_h_sz = 12;		/* default size of the frame header */
+	sd->sd_desc.nctrls = 2;		/* default no ctrls */
+
 /*	vendor = id->idVendor; */
 	product = id->idProduct;
 /*	switch (vendor) { */
@@ -529,6 +649,8 @@
 		case 0x6005:			/* SN9C101 */
 		case 0x6007:			/* SN9C101 */
 			sd->sensor = SENSOR_TAS5110;
+			sd->sd_desc.nctrls = 4;
+			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;
 			break;
 		case 0x6009:			/* SN9C101 */
@@ -539,6 +661,8 @@
 			break;
 		case 0x6011:			/* SN9C101 - SN9C101G */
 			sd->sensor = SENSOR_OV6650;
+			sd->sd_desc.nctrls = 4;
+			sd->sd_desc.dq_callback = do_autogain;
 			sif = 1;
 			break;
 		case 0x6019:			/* SN9C101 */
@@ -578,8 +702,10 @@
 		cam->cam_mode = sif_mode;
 		cam->nmodes = sizeof sif_mode / sizeof sif_mode[0];
 	}
-	sd->brightness = sd_ctrls[SD_BRIGHTNESS].qctrl.default_value;
-	sd->contrast = sd_ctrls[SD_CONTRAST].qctrl.default_value;
+	sd->brightness = BRIGHTNESS_DEF;
+	sd->gain = GAIN_DEF;
+	sd->exposure = EXPOSURE_DEF;
+	sd->autogain = 1;
 	if (sd->sensor == SENSOR_OV7630_3)	/* jfm: from win trace */
 		reg_w(gspca_dev->dev, 0x01, probe_ov7630, sizeof probe_ov7630);
 	return 0;
@@ -762,8 +888,12 @@
 	reg_w(dev, 0x18, &reg17_19[1], 2);
 	msleep(20);
 
-	setcontrast(gspca_dev);
+	setgain(gspca_dev);
 	setbrightness(gspca_dev);
+	setexposure(gspca_dev);
+
+	sd->autogain_ignore_frames = 0;
+	atomic_set(&sd->avg_lum, -1);
 }
 
 static void sd_stopN(struct gspca_dev *gspca_dev)
@@ -787,8 +917,8 @@
 			unsigned char *data,		/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct sd *sd;
 	int i;
+	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (len > 6 && len < 24) {
 		for (i = 0; i < len - 6; i++) {
@@ -800,7 +930,16 @@
 			    && data[5 + i] == 0x96) {	/* start of frame */
 				frame = gspca_frame_add(gspca_dev, LAST_PACKET,
 							frame, data, 0);
-				sd = (struct sd *) gspca_dev;
+				if (i < (len - 10)) {
+					atomic_set(&sd->avg_lum, data[i + 8] +
+							(data[i + 9] << 8));
+				} else {
+					atomic_set(&sd->avg_lum, -1);
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+					PDEBUG(D_STREAM, "packet too short to "
+						"get avg brightness");
+#endif
+				}
 				data += i + sd->fr_h_sz;
 				len -= i + sd->fr_h_sz;
 				gspca_frame_add(gspca_dev, FIRST_PACKET,
@@ -831,26 +970,74 @@
 	return 0;
 }
 
-static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sd->contrast = val;
+	sd->gain = val;
 	if (gspca_dev->streaming)
-		setcontrast(gspca_dev);
+		setgain(gspca_dev);
 	return 0;
 }
 
-static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	*val = sd->contrast;
+	*val = sd->gain;
+	return 0;
+}
+
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->exposure = val;
+	if (gspca_dev->streaming)
+		setexposure(gspca_dev);
+	return 0;
+}
+
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->exposure;
+	return 0;
+}
+
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->autogain = val;
+	/* when switching to autogain set defaults to make sure
+	   we are on a valid point of the autogain gain /
+	   exposure knee graph, and give this change time to
+	   take effect before doing autogain. */
+	if (sd->autogain) {
+		sd->exposure = EXPOSURE_DEF;
+		sd->gain = GAIN_DEF;
+		if (gspca_dev->streaming) {
+			sd->autogain_ignore_frames = AUTOGAIN_IGNORE_FRAMES;
+			setexposure(gspca_dev);
+			setgain(gspca_dev);
+		}
+	}
+
+	return 0;
+}
+
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->autogain;
 	return 0;
 }
 
 /* sub-driver description */
-static struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),

--------------080802030209060402010301
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080802030209060402010301--
