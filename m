Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TBkv8F008039
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 07:46:58 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TBkgtB001774
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 07:46:43 -0400
Message-ID: <48B7E447.8070804@hhs.nl>
Date: Fri, 29 Aug 2008 13:57:59 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------030907010307000906060903"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: patch: gspca-sonixb-rawmode.patch
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
--------------030907010307000906060903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

2 changes in this patch:
1) Lower the hstart setting for all sensor by 1 so that we generate
    (compressed) BGGR data just like sn9c102 does (instead of GBRG data)
2) Add support for raw bayer output in the lowest resolutions (not enough
    bandwidth for higher resolutions), this should work with all sensors but
    to be sure only enable it for sensors where it has been tested.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

p.s.

I'll do a new libv4l release matching the bayer order change right after this mail.

--------------030907010307000906060903
Content-Type: text/plain;
 name="gspca-sonixb-raw-mode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-raw-mode.patch"

2 changes in this patch:
1) Lower the hstart setting for all sensor by 1 so that we generate
   (compressed) BGGR data just like sn9c102 does (instead of GBRG data)
2) Add support for raw bayer output in the lowest resolutions (not enough
   bandwidth for higher resolutions), this should work with all sensors but
   to be sure only enable it for sensors where it has been tested.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 909e94b16eb9 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Aug 28 22:46:05 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Fri Aug 29 13:39:23 2008 +0200
@@ -74,6 +74,10 @@
 /* sensor_data flags */
 #define F_GAIN 0x01		/* has gain */
 #define F_SIF  0x02		/* sif or vga */
+#define F_RAW  0x04		/* sensor tested ok with raw bayer mode */
+
+/* priv field of struct v4l2_pix_format flags (do not use low nibble!) */
+#define MODE_RAW 0x10		/* raw bayer mode */
 
 /* ctrl_dis helper macros */
 #define NO_EXPO ((1 << EXPOSURE_IDX) | (1 << AUTOGAIN_IDX))
@@ -205,6 +209,11 @@
 };
 
 static struct v4l2_pix_format vga_mode[] = {
+	{160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 160,
+		.sizeimage = 160 * 120,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 2 | MODE_RAW},
 	{160, 120, V4L2_PIX_FMT_SN9C10X, V4L2_FIELD_NONE,
 		.bytesperline = 160,
 		.sizeimage = 160 * 120 * 5 / 4,
@@ -222,6 +231,11 @@
 		.priv = 0},
 };
 static struct v4l2_pix_format sif_mode[] = {
+	{176, 144, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 176,
+		.sizeimage = 176 * 144,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 1 | MODE_RAW},
 	{176, 144, V4L2_PIX_FMT_SN9C10X, V4L2_FIELD_NONE,
 		.bytesperline = 176,
 		.sizeimage = 176 * 144 * 5 / 4,
@@ -237,7 +251,7 @@
 static const __u8 initHv7131[] = {
 	0x46, 0x77, 0x00, 0x04, 0x00, 0x00, 0x00, 0x80, 0x11, 0x00, 0x00, 0x00,
 	0x00, 0x00,
-	0x00, 0x00, 0x00, 0x03, 0x01, 0x00,	/* shift from 0x02 0x01 0x00 */
+	0x00, 0x00, 0x00, 0x02, 0x01, 0x00,
 	0x28, 0x1e, 0x60, 0x8a, 0x20,
 	0x1d, 0x10, 0x02, 0x03, 0x0f, 0x0c
 };
@@ -252,13 +266,13 @@
 #if 1
 	0x44, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
 	0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x02, 0x01, 0x0a, 0x16, 0x12, 0x68, 0x8b,
+	0x00, 0x01, 0x01, 0x0a, 0x16, 0x12, 0x68, 0x8b,
 	0x10, 0x1d, 0x10, 0x00, 0x06, 0x1f, 0x00
 #else
 /* old version? */
 	0x64, 0x44, 0x28, 0x00, 0x00, 0x00, 0x00, 0x10,
 	0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x02, 0x01, 0x0a, 0x14, 0x0f, 0x68, 0x8b,
+	0x00, 0x01, 0x01, 0x0a, 0x14, 0x0f, 0x68, 0x8b,
 	0x10, 0x1d, 0x10, 0x01, 0x01, 0x07, 0x06
 #endif
 };
@@ -316,15 +330,12 @@
 static const __u8 initOv7630[] = {
 	0x04, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,	/* r01 .. r08 */
 	0x21, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* r09 .. r10 */
-#if 1
-	0x00, 0x02, 0x01, 0x0a,				/* r11 .. r14 */
+	0x00, 0x01, 0x01, 0x0a,				/* r11 .. r14 */
 	0x28, 0x1e,			/* H & V sizes     r15 .. r16 */
 	0x68, COMP2, MCK_INIT1,				/* r17 .. r19 */
+#if 1
 	0x1d, 0x10, 0x02, 0x03, 0x0f, 0x0c		/* r1a .. r1f */
 #else /* jfm from win */
-	0x00, 0x01, 0x01, 0x0a,				/* r11 .. r14 */
-	0x16, 0x12,			/* H & V sizes     r15 .. r16 */
-	0x68, COMP2, MCK_INIT1,				/* r17 .. r19 */
 	0x1d, 0x10, 0x06, 0x01, 0x00, 0x03		/* r1a .. r1f */
 #endif
 };
@@ -367,7 +378,7 @@
 static const __u8 initPas106[] = {
 	0x04, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x81, 0x40, 0x00, 0x00, 0x00,
 	0x00, 0x00,
-	0x00, 0x00, 0x00, 0x05, 0x01, 0x00,
+	0x00, 0x00, 0x00, 0x04, 0x01, 0x00,
 	0x16, 0x12, 0x24, COMP1, MCK_INIT1,
 	0x18, 0x10, 0x04, 0x03, 0x11, 0x0c
 };
@@ -417,7 +428,7 @@
 static const __u8 initPas202[] = {
 	0x44, 0x44, 0x21, 0x30, 0x00, 0x00, 0x00, 0x80, 0x40, 0x00, 0x00, 0x00,
 	0x00, 0x00,
-	0x00, 0x00, 0x00, 0x07, 0x03, 0x0a,	/* 6 */
+	0x00, 0x00, 0x00, 0x06, 0x03, 0x0a,
 	0x28, 0x1e, 0x28, 0x89, 0x20,
 	0x00, 0x00, 0x02, 0x03, 0x0f, 0x0c
 };
@@ -448,7 +459,7 @@
 static const __u8 initTas5110[] = {
 	0x44, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x11, 0x00, 0x00, 0x00,
 	0x00, 0x00,
-	0x00, 0x01, 0x00, 0x46, 0x09, 0x0a,	/* shift from 0x45 0x09 0x0a */
+	0x00, 0x01, 0x00, 0x45, 0x09, 0x0a,
 	0x16, 0x12, 0x60, 0x86, 0x2b,
 	0x14, 0x0a, 0x02, 0x02, 0x09, 0x07
 };
@@ -461,7 +472,7 @@
 static const __u8 initTas5130[] = {
 	0x04, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x11, 0x00, 0x00, 0x00,
 	0x00, 0x00,
-	0x00, 0x01, 0x00, 0x69, 0x0c, 0x0a,
+	0x00, 0x01, 0x00, 0x68, 0x0c, 0x0a,
 	0x28, 0x1e, 0x60, COMP, MCK_INIT,
 	0x18, 0x10, 0x04, 0x03, 0x11, 0x0c
 };
@@ -475,14 +486,15 @@
 
 struct sensor_data sensor_data[] = {
 SENS(initHv7131, NULL, hv7131_sensor_init, NULL, NULL, 0, NO_EXPO|NO_FREQ, 0),
-SENS(initOv6650, NULL, ov6650_sensor_init, NULL, NULL, F_GAIN|F_SIF, 0, 0x60),
+SENS(initOv6650, NULL, ov6650_sensor_init, NULL, NULL, F_GAIN|F_SIF|F_RAW, 0,
+	0x60),
 SENS(initOv7630, initOv7630_3, ov7630_sensor_init, NULL, ov7630_sensor_init_3,
 	F_GAIN, 0, 0x21),
 SENS(initPas106, NULL, pas106_sensor_init, NULL, NULL, F_SIF, NO_EXPO|NO_FREQ,
 	0),
-SENS(initPas202, initPas202, pas202_sensor_init, NULL, NULL, 0,
+SENS(initPas202, initPas202, pas202_sensor_init, NULL, NULL, F_RAW,
 	NO_EXPO|NO_FREQ, 0),
-SENS(initTas5110, NULL, tas5110_sensor_init, NULL, NULL, F_GAIN|F_SIF,
+SENS(initTas5110, NULL, tas5110_sensor_init, NULL, NULL, F_GAIN|F_SIF|F_RAW,
 	NO_BRIGHTNESS|NO_FREQ, 0),
 SENS(initTas5130, NULL, tas5130_sensor_init, NULL, NULL, 0, NO_EXPO|NO_FREQ,
 	0),
@@ -852,6 +864,10 @@
 		cam->cam_mode = sif_mode;
 		cam->nmodes = ARRAY_SIZE(sif_mode);
 	}
+	if (!(sensor_data[sd->sensor].flags & F_RAW)) {
+		cam->cam_mode++;
+		cam->nmodes--;
+	}
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
@@ -900,6 +916,9 @@
 		reg17_19[2] = mode ? 0x23 : 0x43;
 		break;
 	}
+	/* Disable compression when the raw bayer format has been selected */
+	if (gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv & MODE_RAW)
+		reg17_19[1] &= ~0x80;
 
 	/* reg 0x01 bit 2 video transfert on */
 	reg_w(gspca_dev, 0x01, &sn9c10x[0x01 - 1], 1);
@@ -962,6 +981,7 @@
 {
 	int i;
 	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam = &gspca_dev->cam;
 
 	/* frames start with:
 	 *	ff ff 00 c4 c4 96	synchro
@@ -1015,6 +1035,17 @@
 			}
 		}
 	}
+
+	if (cam->cam_mode[gspca_dev->curr_mode].priv & MODE_RAW) {
+		/* In raw mode we sometimes get some garbage after the frame
+		   ignore this */
+		int used = frame->data_end - frame->data;
+		int size = cam->cam_mode[gspca_dev->curr_mode].sizeimage;
+
+		if (used + len > size)
+			len = size - used;
+	}
+
 	gspca_frame_add(gspca_dev, INTER_PACKET,
 			frame, data, len);
 }

--------------030907010307000906060903
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030907010307000906060903--
