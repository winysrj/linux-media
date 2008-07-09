Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69DUnms009872
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 09:30:49 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69DUYMD003497
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 09:30:35 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KGZkd-0003fn-MO
	for video4linux-list@redhat.com; Wed, 09 Jul 2008 15:30:31 +0200
Received: from [145.52.8.13] (port=34622 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KGZkd-0003fi-Cn
	for video4linux-list@redhat.com; Wed, 09 Jul 2008 15:30:31 +0200
Received: from [145.52.123.106] (HELO localhost.localdomain)
	by hhs.nl (CommuniGate Pro SMTP 4.3.6)
	with ESMTP id 89295182 for video4linux-list@redhat.com;
	Wed, 09 Jul 2008 15:30:31 +0200
Message-ID: <4874BD52.60601@hhs.nl>
Date: Wed, 09 Jul 2008 15:29:54 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------050109070001050709040608"
Subject: PATCH: gspca-general-autogain_n_exposure-knee-algp.patch
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
--------------050109070001050709040608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Make the knee auto gain and exposure algorithm, described here:
http://ytse.tricolour.net/docs/LowLightOptimization.html

And currently used in the pac207 generic (iow not pac207 specific) and move it
to gspca.c . This is a preperation patch for adding exposure setting and auto
gain and exposure to the sn9c10x driver (for selective sensors for now).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------050109070001050709040608
Content-Type: text/plain;
	name="gspca-general-autogain_n_exposure-knee-algp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-general-autogain_n_exposure-knee-algp.patch"

Make the knee auto gain and exposure algorithm, described here:
http://ytse.tricolour.net/docs/LowLightOptimization.html

And currently used in the pac207 generic (iow not pac207 specific) and move it
to gspca.c . This is a preperation patch for adding exposure setting and auto
gain and exposure to the sn9c10x driver (for selective sensors for now).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 5065159a99d4 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Sun Jul 06 09:27:19 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Mon Jul 07 09:15:54 2008 +0200
@@ -1894,6 +1894,91 @@
 }
 EXPORT_SYMBOL(gspca_disconnect);
 
+/* -- cam driver utility functions -- */
+
+/* auto gain and exposure algorithm based on the knee algorithm described here:
+   http://ytse.tricolour.net/docs/LowLightOptimization.html
+
+   Returns 0 if no changes were made, 1 if the gain and or exposure settings
+   where changed. */
+int gspca_auto_gain_n_exposure(struct gspca_dev *gspca_dev, int avg_lum,
+	int desired_avg_lum, int deadzone, int gain_knee, int exposure_knee)
+{
+	int i, steps, gain, orig_gain, exposure, orig_exposure, autogain;
+	const struct ctrl *gain_ctrl = NULL;
+	const struct ctrl *exposure_ctrl = NULL;
+	const struct ctrl *autogain_ctrl = NULL;
+	int retval = 0;
+
+	for (i = 0; i < gspca_dev->sd_desc->nctrls; i++) {
+		if (gspca_dev->sd_desc->ctrls[i].qctrl.id == V4L2_CID_GAIN)
+			gain_ctrl = &gspca_dev->sd_desc->ctrls[i];
+		if (gspca_dev->sd_desc->ctrls[i].qctrl.id == V4L2_CID_EXPOSURE)
+			exposure_ctrl = &gspca_dev->sd_desc->ctrls[i];
+		if (gspca_dev->sd_desc->ctrls[i].qctrl.id == V4L2_CID_AUTOGAIN)
+			autogain_ctrl = &gspca_dev->sd_desc->ctrls[i];
+	}
+	if (!gain_ctrl || !exposure_ctrl || !autogain_ctrl) {
+		PDEBUG(D_ERR, "Error: gspca_auto_gain_n_exposure called "
+			"on cam without (auto)gain/exposure");
+		return 0;
+	}
+
+	if (gain_ctrl->get(gspca_dev, &gain) ||
+			exposure_ctrl->get(gspca_dev, &exposure) ||
+			autogain_ctrl->get(gspca_dev, &autogain) || !autogain)
+		return 0;
+
+	orig_gain = gain;
+	orig_exposure = exposure;
+
+	/* If we are of a multiple of deadzone, do multiple steps to reach the
+	   desired lumination fast (with the risc of a slight overshoot) */
+	steps = abs(desired_avg_lum - avg_lum) / deadzone;
+
+	for (i = 0; i < steps; i++) {
+		if (avg_lum > desired_avg_lum) {
+			if (gain > gain_knee)
+				gain--;
+			else if (exposure > exposure_knee)
+				exposure--;
+			else if (gain > gain_ctrl->qctrl.default_value)
+				gain--;
+			else if (exposure > exposure_ctrl->qctrl.minimum)
+				exposure--;
+			else if (gain > gain_ctrl->qctrl.minimum)
+				gain--;
+			else
+				break;
+		} else {
+			if (gain < gain_ctrl->qctrl.default_value)
+				gain++;
+			else if (exposure < exposure_knee)
+				exposure++;
+			else if (gain < gain_knee)
+				gain++;
+			else if (exposure < exposure_ctrl->qctrl.maximum)
+				exposure++;
+			else if (gain < gain_ctrl->qctrl.maximum)
+				gain++;
+			else
+				break;
+		}
+	}
+
+	if (gain != orig_gain) {
+		gain_ctrl->set(gspca_dev, gain);
+		retval = 1;
+	}
+	if (exposure != orig_exposure) {
+		exposure_ctrl->set(gspca_dev, exposure);
+		retval = 1;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
+
 /* -- module insert / remove -- */
 static int __init gspca_init(void)
 {
diff -r 5065159a99d4 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Sun Jul 06 09:27:19 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.h	Mon Jul 07 09:15:54 2008 +0200
@@ -172,4 +172,6 @@
 				    struct gspca_frame *frame,
 				    const __u8 *data,
 				    int len);
+int gspca_auto_gain_n_exposure(struct gspca_dev *gspca_dev, int avg_lum,
+	int desired_avg_lum, int deadzone, int gain_knee, int exposure_knee);
 #endif /* GSPCAV2_H */
diff -r 5065159a99d4 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Sun Jul 06 09:27:19 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Mon Jul 07 09:15:54 2008 +0200
@@ -357,70 +357,20 @@
 {
 }
 
-/* auto gain and exposure algorithm based on the knee algorithm described here:
- * <http://ytse.tricolour.net/docs/LowLightOptimization.html> */
 static void pac207_do_auto_gain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int i, steps, desired_avg_lum;
-	int orig_gain = sd->gain;
-	int orig_exposure = sd->exposure;
 	int avg_lum = atomic_read(&sd->avg_lum);
 
-	if (!sd->autogain || avg_lum == -1)
+	if (avg_lum == -1)
 		return;
 
-	if (sd->autogain_ignore_frames > 0) {
+	if (sd->autogain_ignore_frames > 0)
 		sd->autogain_ignore_frames--;
-		return;
-	}
-
-	/* correct desired lumination for the configured brightness */
-	desired_avg_lum = 100 + sd->brightness / 2;
-
-	/* If we are of a multiple of deadzone, do multiple step to reach the
-	   desired lumination fast (with the risc of a slight overshoot) */
-	steps = abs(desired_avg_lum - avg_lum) / PAC207_AUTOGAIN_DEADZONE;
-
-	for (i = 0; i < steps; i++) {
-		if (avg_lum > desired_avg_lum) {
-			if (sd->gain > PAC207_GAIN_KNEE)
-				sd->gain--;
-			else if (sd->exposure > PAC207_EXPOSURE_KNEE)
-				sd->exposure--;
-			else if (sd->gain > PAC207_GAIN_DEFAULT)
-				sd->gain--;
-			else if (sd->exposure > PAC207_EXPOSURE_MIN)
-				sd->exposure--;
-			else if (sd->gain > PAC207_GAIN_MIN)
-				sd->gain--;
-			else
-				break;
-		} else {
-			if (sd->gain < PAC207_GAIN_DEFAULT)
-				sd->gain++;
-			else if (sd->exposure < PAC207_EXPOSURE_KNEE)
-				sd->exposure++;
-			else if (sd->gain < PAC207_GAIN_KNEE)
-				sd->gain++;
-			else if (sd->exposure < PAC207_EXPOSURE_MAX)
-				sd->exposure++;
-			else if (sd->gain < PAC207_GAIN_MAX)
-				sd->gain++;
-			else
-				break;
-		}
-	}
-
-	if (sd->exposure != orig_exposure || sd->gain != orig_gain) {
-		if (sd->exposure != orig_exposure)
-			pac207_write_reg(gspca_dev, 0x0002, sd->exposure);
-		if (sd->gain != orig_gain)
-			pac207_write_reg(gspca_dev, 0x000e, sd->gain);
-		pac207_write_reg(gspca_dev, 0x13, 0x01); /* load reg to sen */
-		pac207_write_reg(gspca_dev, 0x1c, 0x01); /* not documented */
+	else if (gspca_auto_gain_n_exposure(gspca_dev, avg_lum,
+			100 + sd->brightness / 2, PAC207_AUTOGAIN_DEADZONE,
+			PAC207_GAIN_KNEE, PAC207_EXPOSURE_KNEE))
 		sd->autogain_ignore_frames = PAC207_AUTOGAIN_IGNORE_FRAMES;
-	}
 }
 
 static unsigned char *pac207_find_sof(struct gspca_dev *gspca_dev,
@@ -546,10 +496,6 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	/* don't allow mucking with exposure when using autogain */
-	if (sd->autogain)
-		return -EINVAL;
-
 	sd->exposure = val;
 	if (gspca_dev->streaming)
 		setexposure(gspca_dev);
@@ -567,10 +513,6 @@
 static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-
-	/* don't allow mucking with gain when using autogain */
-	if (sd->autogain)
-		return -EINVAL;
 
 	sd->gain = val;
 	if (gspca_dev->streaming)


--------------050109070001050709040608
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050109070001050709040608--
