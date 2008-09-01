Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81I48u3011067
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 14:04:08 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81I3NbF012802
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 14:03:24 -0400
Message-ID: <48BC3123.8040403@hhs.nl>
Date: Mon, 01 Sep 2008 20:14:59 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------040209000400020109040808"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Patch: gspca-spca561-rev12a.patch
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
--------------040209000400020109040808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

After seeing your pull request and seeing the comment on you not being sure if 
the header size change was correct for both revisions I've done some testing 
with my 2 spca561 based cams, resulting in the following patch:

-Make raw bayer header size change from 20 to 16 affect rev072a only, my 2
  rev012a cams both have a header size of 20
-While testing this I also tested the new exposure setting (good work on
  finding the register JF), and after quite a bit of testing have found out the
  exact meaning of the register, this patch modifies setexposure to control
  the exposure over a much wider range.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------040209000400020109040808
Content-Type: text/plain;
 name="gspca-spca561-rev12a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-spca561-rev12a.patch"

-Make raw bayer header size change from 20 to 16 affect rev072a only, my 2
 rev012a cams both have a header size of 20
-While testing this I also tested the new exposure setting (good work on
 finding the register JF), and after quite a bit of testing have found out the
 exact meaning of the register, this patch modifies setexposure to control
 the exposure over a much wider range.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 01f8914508b4 linux/drivers/media/video/gspca/spca561.c
--- a/linux/drivers/media/video/gspca/spca561.c	Sun Aug 31 19:25:43 2008 +0200
+++ b/linux/drivers/media/video/gspca/spca561.c	Mon Sep 01 20:08:36 2008 +0200
@@ -38,9 +38,9 @@
 #define CONTRAST_MAX 0x3fff
 
 	__u16 exposure;			/* rev12a only */
-#define EXPOSURE_MIN 0
+#define EXPOSURE_MIN 1
 #define EXPOSURE_DEF 200
-#define EXPOSURE_MAX 762
+#define EXPOSURE_MAX (4095 - 900) /* see set_exposure */
 
 	__u8 brightness;		/* rev72a only */
 #define BRIGHTNESS_MIN 0
@@ -662,9 +662,31 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int expo;
+	int clock_divider;
 	__u8 data[2];
-
-	expo = sd->exposure + 0x20a8;	/* from test */
+	
+	/* Register 0x8309 controls exposure for the spca561,
+	   the basic exposure setting goes from 1-2047, where 1 is completely
+	   dark and 2047 is very bright. It not only influences exposure but
+	   also the framerate (to allow for longer exposure) from 1 - 300 it
+	   only raises the exposure time then from 300 - 600 it halves the
+	   framerate to be able to further raise the exposure time and for every
+	   300 more it halves the framerate again. This allows for a maximum
+	   exposure time of circa 0.2 - 0.25 seconds (30 / (2000/3000) fps).
+	   Sometimes this is not enough, the 1-2047 uses bits 0-10, bits 11-12
+	   configure a divider for the base framerate which us used at the
+	   exposure setting of 1-300. These bits configure the base framerate
+	   according to the following formula: fps = 60 / (value + 2) */
+	if (sd->exposure < 2048) {
+		expo = sd->exposure;
+		clock_divider = 0;
+	} else {
+		/* Add 900 to make the 0 setting of the second part of the
+		   exposure equal to the 2047 setting of the first part. */
+		expo = (sd->exposure - 2048) + 900;
+		clock_divider = 3;
+	}
+	expo |= clock_divider << 11;
 	data[0] = expo;
 	data[1] = expo >> 8;
 	reg_w_buf(gspca_dev, 0x8309, data, 2);
@@ -694,23 +716,11 @@
 static void sd_start_12a(struct gspca_dev *gspca_dev)
 {
 	struct usb_device *dev = gspca_dev->dev;
-	int Clck;
+	int Clck = 0x8a; /* lower 0x8X values lead to fps > 30 */
 	__u8 Reg8307[] = { 0xaa, 0x00 };
 	int mode;
 
 	mode = gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv;
-	switch (mode) {
-	case 0:
-	case 1:
-		Clck = 0x8a;
-		break;
-	case 2:
-		Clck = 0x85;
-		break;
-	default:
-		Clck = 0x83;
-		break;
-	}
 	if (mode <= 1) {
 		/* Use compression on 320x240 and above */
 		reg_w_val(dev, 0x8500, 0x10 | mode);
@@ -728,6 +738,7 @@
 	setcontrast(gspca_dev);
 	setwhite(gspca_dev);
 	setautogain(gspca_dev);
+	setexposure(gspca_dev);
 }
 static void sd_start_72a(struct gspca_dev *gspca_dev)
 {
@@ -863,6 +874,8 @@
 			__u8 *data,		/* isoc packet */
 			int len)		/* iso packet length */
 {
+	struct sd *sd = (struct sd *) gspca_dev;
+
 	switch (data[0]) {
 	case 0:		/* start of frame */
 		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
@@ -875,14 +888,13 @@
 					frame, data, len);
 		} else {
 			/* raw bayer (with a header, which we skip) */
-#if 1
-/*fixme: is this specific to the rev012a? */
-			data += 16;
-			len -= 16;
-#else
-			data += 20;
-			len -= 20;
-#endif
+			if (sd->chip_revision == Rev012A) {
+				data += 20;
+				len -= 20;
+			} else {
+				data += 16;
+				len -= 16;
+			}
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
 						frame, data, len);
 		}

--------------040209000400020109040808
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040209000400020109040808--
