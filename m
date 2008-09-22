Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MHin9W005432
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 13:44:49 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net
	(pne-smtpout2-sn1.fre.skanova.net [81.228.11.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MHidLc019976
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 13:44:39 -0400
Received: from [192.168.0.102] (90.224.104.93) by
	pne-smtpout2-sn1.fre.skanova.net (7.3.129)
	id 4843FAEB01945D52 for video4linux-list@redhat.com;
	Mon, 22 Sep 2008 19:44:39 +0200
Message-ID: <48D7D987.7020107@gmail.com>
Date: Mon, 22 Sep 2008 19:44:39 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------060800080908030201070101"
Subject: [PATCH][GSPCA] Remove some superflous commas
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
--------------060800080908030201070101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
The attached patch removes some superflous commas.
More gspca files could be combed for these, I just picked a couple of
files when I had some spare minutes over.

Patch should apply against current v4l-dvb hg tree.

Thanks,
Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI19mHN7qBt+4UG0ERAt+YAKCEUI9nVyzRKJ4qe4O78ApSwmLsdQCff5IJ
Jw7okc9fjoMuwDclfXubKVY=
=EdEM
-----END PGP SIGNATURE-----

--------------060800080908030201070101
Content-Type: text/x-diff;
 name="remove_superflous_commas.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_superflous_commas.patch"

diff -r b72ff7b5aa68 linux/drivers/media/video/gspca/ov519.c
--- a/linux/drivers/media/video/gspca/ov519.c	Wed Sep 17 07:49:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/ov519.c	Mon Sep 22 18:19:19 2008 +0200
@@ -92,10 +92,10 @@
 		.maximum = 255,
 		.step    = 1,
 #define BRIGHTNESS_DEF 127
-		.default_value = BRIGHTNESS_DEF,
+		.default_value = BRIGHTNESS_DEF
 	    },
 	    .set = sd_setbrightness,
-	    .get = sd_getbrightness,
+	    .get = sd_getbrightness
 	},
 	{
 	    {
@@ -106,10 +106,10 @@
 		.maximum = 255,
 		.step    = 1,
 #define CONTRAST_DEF 127
-		.default_value = CONTRAST_DEF,
+		.default_value = CONTRAST_DEF
 	    },
 	    .set = sd_setcontrast,
-	    .get = sd_getcontrast,
+	    .get = sd_getcontrast
 	},
 	{
 	    {
@@ -120,10 +120,10 @@
 		.maximum = 255,
 		.step    = 1,
 #define COLOR_DEF 127
-		.default_value = COLOR_DEF,
+		.default_value = COLOR_DEF
 	    },
 	    .set = sd_setcolors,
-	    .get = sd_getcolors,
+	    .get = sd_getcolors
 	},
 /* next controls work with ov7670 only */
 #define HFLIP_IDX 3
@@ -136,10 +136,10 @@
 		.maximum = 1,
 		.step    = 1,
 #define HFLIP_DEF 0
-		.default_value = HFLIP_DEF,
+		.default_value = HFLIP_DEF
 	    },
 	    .set = sd_sethflip,
-	    .get = sd_gethflip,
+	    .get = sd_gethflip
 	},
 #define VFLIP_IDX 4
 	{
@@ -151,10 +151,10 @@
 		.maximum = 1,
 		.step    = 1,
 #define VFLIP_DEF 0
-		.default_value = VFLIP_DEF,
+		.default_value = VFLIP_DEF
 	    },
 	    .set = sd_setvflip,
-	    .get = sd_getvflip,
+	    .get = sd_getvflip
 	},
 };
 
@@ -168,7 +168,7 @@
 		.bytesperline = 640,
 		.sizeimage = 640 * 480 * 3 / 8 + 590,
 		.colorspace = V4L2_COLORSPACE_JPEG,
-		.priv = 0},
+		.priv = 0}
 };
 static struct v4l2_pix_format sif_mode[] = {
 	{176, 144, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
@@ -180,7 +180,7 @@
 		.bytesperline = 352,
 		.sizeimage = 352 * 288 * 3 / 8 + 590,
 		.colorspace = V4L2_COLORSPACE_JPEG,
-		.priv = 0},
+		.priv = 0}
 };
 
 /* OV519 Camera interface register numbers */
@@ -341,7 +341,7 @@
 	{ 0x4b, 0x80 },
 	{ 0x4d, 0xd2 }, /* This reduces noise a bit */
 	{ 0x4e, 0xc1 },
-	{ 0x4f, 0x04 },
+	{ 0x4f, 0x04 }
 /* Do 50-53 have any effect? */
 /* Toggle 0x12[2] off and on here? */
 };
@@ -428,7 +428,7 @@
 	{ 0x3d, 0x80 },
 	{ 0x27, 0xa6 },
 	{ 0x12, 0x20 }, /* Toggle AWB */
-	{ 0x12, 0x24 },
+	{ 0x12, 0x24 }
 };
 
 /* Lawrence Glaister <lg@jfm.bc.ca> reports:
@@ -469,7 +469,7 @@
 	{ 0x12, 0x24 },
 	{ 0x11, 0x01 },
 	{ 0x0c, 0x24 },
-	{ 0x0d, 0x24 },
+	{ 0x0d, 0x24 }
 };
 
 static const struct ov_i2c_regvals norm_7620[] = {
@@ -535,13 +535,13 @@
 	{ 0x79, 0x80 },
 	{ 0x7a, 0x80 },
 	{ 0x7b, 0xe2 },
-	{ 0x7c, 0x00 },
+	{ 0x7c, 0x00 }
 };
 
 /* 7640 and 7648. The defaults should be OK for most registers. */
 static const struct ov_i2c_regvals norm_7640[] = {
 	{ 0x12, 0x80 },
-	{ 0x12, 0x14 },
+	{ 0x12, 0x14 }
 };
 
 /* 7670. Defaults taken from OmniVision provided data,
@@ -738,7 +738,7 @@
 	{ 0xc8, 0x40 },
 	{ 0x79, 0x05 },
 	{ 0xc8, 0x30 },
-	{ 0x79, 0x26 },
+	{ 0x79, 0x26 }
 };
 
 static const struct ov_i2c_regvals norm_8610[] = {
@@ -826,7 +826,7 @@
 	{ 0x88, 0x00 },
 	{ 0x89, 0x01 },
 	{ 0x12, 0x20 },
-	{ 0x12, 0x25 }, /* was 0x24, new from windrv 090403 */
+	{ 0x12, 0x25 } /* was 0x24, new from windrv 090403 */
 };
 
 static unsigned char ov7670_abs_to_sm(unsigned char v)
@@ -1308,7 +1308,7 @@
 		{ OV519_GPIO_IO_CTRL0,   0xee },
 		{ 0x51,  0x0f }, /* SetUsbInit */
 		{ 0x51,  0x00 },
-		{ 0x22,  0x00 },
+		{ 0x22,  0x00 }
 		/* windows reads 0x55 at this point*/
 	};
 
@@ -1471,7 +1471,7 @@
 		{ 0x40,	0xff }, /* I2C timeout counter */
 		{ 0x46,	0x00 }, /* I2C clock prescaler */
 		{ 0x59,	0x04 },	/* new from windrv 090403 */
-		{ 0xff,	0x00 }, /* undocumented */
+		{ 0xff,	0x00 } /* undocumented */
 		/* windows reads 0x55 at this point, why? */
 	};
 
@@ -2201,11 +2201,11 @@
 	.name = MODULE_NAME,
 	.id_table = device_table,
 	.probe = sd_probe,
-	.disconnect = gspca_disconnect,
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
 #endif
+	.disconnect = gspca_disconnect
 };
 
 /* -- module insert / remove -- */
diff -r b72ff7b5aa68 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Wed Sep 17 07:49:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Mon Sep 22 18:19:19 2008 +0200
@@ -96,7 +96,7 @@
 		.maximum = PAC207_BRIGHTNESS_MAX,
 		.step = 1,
 		.default_value = PAC207_BRIGHTNESS_DEFAULT,
-		.flags = 0,
+		.flags = 0
 	    },
 	    .set = sd_setbrightness,
 	    .get = sd_getbrightness,
@@ -111,10 +111,10 @@
 		.maximum = PAC207_EXPOSURE_MAX,
 		.step = 1,
 		.default_value = PAC207_EXPOSURE_DEFAULT,
-		.flags = 0,
+		.flags = 0
 	    },
 	    .set = sd_setexposure,
-	    .get = sd_getexposure,
+	    .get = sd_getexposure
 	},
 #define SD_AUTOGAIN 2
 	{
@@ -127,10 +127,10 @@
 		.step	= 1,
 #define AUTOGAIN_DEF 1
 		.default_value = AUTOGAIN_DEF,
-		.flags = 0,
+		.flags = 0
 	    },
 	    .set = sd_setautogain,
-	    .get = sd_getautogain,
+	    .get = sd_getautogain
 	},
 #define SD_GAIN 3
 	{
@@ -142,11 +142,11 @@
 		.maximum = PAC207_GAIN_MAX,
 		.step = 1,
 		.default_value = PAC207_GAIN_DEFAULT,
-		.flags = 0,
+		.flags = 0
 	    },
 	    .set = sd_setgain,
-	    .get = sd_getgain,
-	},
+	    .get = sd_getgain
+	}
 };
 
 static struct v4l2_pix_format sif_mode[] = {
@@ -162,7 +162,7 @@
 			   when the framerate is low) */
 		.sizeimage = (352 + 2) * 288,
 		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 0},
+		.priv = 0}
 };
 
 static const __u8 pac207_sensor_init[][8] = {
@@ -170,7 +170,7 @@
 	{0x00, 0x64, 0x64, 0x64, 0x04, 0x10, 0xf0, 0x30},
 	{0x00, 0x00, 0x00, 0x70, 0xa0, 0xf8, 0x00, 0x00},
 	{0x00, 0x00, 0x32, 0x00, 0x96, 0x00, 0xa2, 0x02},
-	{0x32, 0x00, 0x96, 0x00, 0xA2, 0x02, 0xaf, 0x00},
+	{0x32, 0x00, 0x96, 0x00, 0xA2, 0x02, 0xaf, 0x00}
 };
 
 			/* 48 reg_72 Rate Control end BalSize_4a =0x36 */
@@ -521,7 +521,7 @@
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.dq_callback = pac207_do_auto_gain,
-	.pkt_scan = sd_pkt_scan,
+	.pkt_scan = sd_pkt_scan
 };
 
 /* -- module initialisation -- */
@@ -552,11 +552,11 @@
 	.name = MODULE_NAME,
 	.id_table = device_table,
 	.probe = sd_probe,
-	.disconnect = gspca_disconnect,
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
 #endif
+	.disconnect = gspca_disconnect
 };
 
 /* -- module insert / remove -- */
diff -r b72ff7b5aa68 linux/drivers/media/video/gspca/tv8532.c
--- a/linux/drivers/media/video/gspca/tv8532.c	Wed Sep 17 07:49:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/tv8532.c	Mon Sep 22 18:19:19 2008 +0200
@@ -57,10 +57,10 @@
 	  .minimum = 1,
 	  .maximum = 0x2ff,
 	  .step = 1,
-	  .default_value = 0x18f,
+	  .default_value = 0x18f
 	  },
 	 .set = sd_setbrightness,
-	 .get = sd_getbrightness,
+	 .get = sd_getbrightness
 	 },
 #define SD_CONTRAST 1
 	{
@@ -71,10 +71,10 @@
 	  .minimum = 0,
 	  .maximum = 0xffff,
 	  .step = 1,
-	  .default_value = 0x7fff,
+	  .default_value = 0x7fff
 	  },
 	 .set = sd_setcontrast,
-	 .get = sd_getcontrast,
+	 .get = sd_getcontrast
 	 },
 };
 
@@ -88,7 +88,7 @@
 		.bytesperline = 352,
 		.sizeimage = 352 * 288,
 		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 0},
+		.priv = 0}
 };
 
 /*
@@ -615,7 +615,7 @@
 	.init = sd_init,
 	.start = sd_start,
 	.stopN = sd_stopN,
-	.pkt_scan = sd_pkt_scan,
+	.pkt_scan = sd_pkt_scan
 };
 
 /* -- module initialisation -- */
@@ -642,11 +642,11 @@
 	.name = MODULE_NAME,
 	.id_table = device_table,
 	.probe = sd_probe,
-	.disconnect = gspca_disconnect,
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
 #endif
+	.disconnect = gspca_disconnect
 };
 
 /* -- module insert / remove -- */

--------------060800080908030201070101
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060800080908030201070101--
