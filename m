Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FLHGTX014386
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 17:17:16 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FLH4PR012101
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 17:17:04 -0400
Message-ID: <487D1591.6070407@hhs.nl>
Date: Tue, 15 Jul 2008 23:24:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------090504060404090600040306"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-sonixb-ov6650-lightfreq.patch
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
--------------090504060404090600040306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Add support for configuring (v4l2 ctrl) the powerline frequency of the
ov6650 sensor.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

p.s.

I'm almost done with trying to get the best out of the ov6650 sensor, I 
promise, all thats left todo now is add support for contrast, hue and 
saturation v4l2 ctrl's and I plan todo that in one patch.

--------------090504060404090600040306
Content-Type: text/x-patch;
 name="gspca-sonixb-ov6650-lightfreq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-ov6650-lightfreq.patch"

Add support for configuring (v4l2 ctrl) the powerline frequency of the
ov6650 sensor.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 2022d9f2fb55 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Tue Jul 15 11:17:05 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Tue Jul 15 23:16:54 2008 +0200
@@ -44,6 +44,7 @@
 	unsigned char brightness;
 	unsigned char autogain;
 	unsigned char autogain_ignore_frames;
+	unsigned char freq; /* light freq filter setting */
 
 	unsigned char fr_h_sz;		/* size of frame header */
 	char sensor;			/* Type of image sensor chip */
@@ -85,6 +86,8 @@
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);
 
 static struct ctrl sd_ctrls[] = {
 	{
@@ -146,6 +149,20 @@
 		},
 		.set = sd_setautogain,
 		.get = sd_getautogain,
+	},
+	{
+		{
+			.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
+			.type    = V4L2_CTRL_TYPE_MENU,
+			.name    = "Light frequency filter",
+			.minimum = 0,
+			.maximum = 2,	/* 0: 0, 1: 50Hz, 2:60Hz */
+			.step    = 1,
+#define FREQ_DEF 0
+			.default_value = FREQ_DEF,
+		},
+		.set = sd_setfreq,
+		.get = sd_getfreq,
 	},
 };
 
@@ -233,11 +250,6 @@
 	/* Some more unknown stuff */
 	{0xa0, 0x60, 0x68, 0x04, 0x68, 0xd8, 0xa4, 0x10},
 	{0xd0, 0x60, 0x17, 0x24, 0xd6, 0x04, 0x94, 0x10}, /* Clipreg */
-	{0xa0, 0x60, 0x10, 0x57, 0x99, 0x04, 0x94, 0x16},
-	/* Framerate adjust register for artificial light 50 hz flicker
-	   compensation, identical to ov6630 0x2b register, see 6630 datasheet.
-	   0x4f -> (30 fps -> 25 fps), 0x00 -> no adjustment */
-	{0xa0, 0x60, 0x2b, 0x4f, 0x99, 0x04, 0x94, 0x15},
 #if 0
 	/* HDG, don't change registers 0x2d, 0x32 & 0x33 from their reset
 	   defaults, doing so mucks up the framerate, where as the defaults
@@ -671,8 +683,12 @@
 		*/
 		__u8 i2c[] = {0xb0, 0x60, 0x10, 0x00, 0xc0, 0x00, 0x00, 0x10};
 		int reg10, reg11;
-		/* No clear idea why, but setting reg10 above this value
-		   results in no change */
+		/* ov6645 datasheet says reg10_max is 9a, but that uses
+		   tline * 2 * reg10 as formula for calculating texpo, the
+		   ov6650 probably uses the same formula as the 7730 which uses
+		   tline * 4 * reg10, which explains why the reg10max we've
+		   found experimentally for the ov6650 is exactly half that of
+		   the ov6645. */
 		const int reg10_max = 0x4d;
 
 		reg11 = (60 * sd->exposure + 999) / 1000;
@@ -694,6 +710,33 @@
 		i2c[4] |= reg11 - 1;
 		if (i2c_w(gspca_dev, i2c) < 0)
 			PDEBUG(D_ERR, "i2c error exposure");
+		break;
+	    }
+	}
+}
+
+static void setfreq(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	switch (sd->sensor) {
+	case SENSOR_OV6650: {
+		/* Framerate adjust register for artificial light 50 hz flicker
+		   compensation, identical to ov6630 0x2b register, see ov6630
+		   datasheet.
+		   0x4f -> (30 fps -> 25 fps), 0x00 -> no adjustment */
+		__u8 i2c[] = {0xa0, 0x60, 0x2b, 0x00, 0x00, 0x00, 0x00, 0x10};
+		switch (sd->freq) {
+			case 0: /* no filter*/
+			case 2: /* 60 hz */
+				i2c[3] = 0;
+				break;
+			case 1: /* 50 hz */  
+				i2c[3] = 0x4f;
+				break;
+		}
+		if (i2c_w(gspca_dev, i2c) < 0)
+			PDEBUG(D_ERR, "i2c error setfreq");
 		break;
 	    }
 	}
@@ -804,6 +847,7 @@
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
+	sd->freq = FREQ_DEF;
 	if (sd->sensor == SENSOR_OV7630_3)	/* jfm: from win trace */
 		reg_w(gspca_dev, 0x01, probe_ov7630, sizeof probe_ov7630);
 	return 0;
@@ -989,6 +1033,7 @@
 	setgain(gspca_dev);
 	setbrightness(gspca_dev);
 	setexposure(gspca_dev);
+	setfreq(gspca_dev);
 
 	sd->autogain_ignore_frames = 0;
 	atomic_set(&sd->avg_lum, -1);
@@ -1134,6 +1179,45 @@
 	return 0;
 }
 
+static int sd_setfreq(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->freq = val;
+	if (gspca_dev->streaming)
+		setfreq(gspca_dev);
+	return 0;
+}
+
+static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->freq;
+	return 0;
+}
+
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (menu->index) {
+		case 0:		/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
+			strcpy((char *) menu->name, "NoFliker");
+			return 0;
+		case 1:		/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
+			strcpy((char *) menu->name, "50 Hz");
+			return 0;
+		case 2:		/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
+			strcpy((char *) menu->name, "60 Hz");
+			return 0;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -1146,6 +1230,7 @@
 	.stop0 = sd_stop0,
 	.close = sd_close,
 	.pkt_scan = sd_pkt_scan,
+	.querymenu = sd_querymenu,
 };
 
 /* -- module initialisation -- */

--------------090504060404090600040306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090504060404090600040306--
