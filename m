Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9NLvJD028064
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:58 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9NLh0M009005
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:44 -0500
Received: from hypnosis.jim.sh (BUCKET.MIT.EDU [18.90.1.139])
	by psychosis.jim.sh (8.14.3/8.14.3/Debian-5) with SMTP id
	mB9NLf0R029539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=OK)
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 18:21:42 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <95986d276e158e35aae7.1228864540@hypnosis.jim>
In-Reply-To: <patchbomb.1228864538@hypnosis.jim>
Date: Tue, 09 Dec 2008 18:15:40 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Subject: [PATCH 2 of 2] gspca: ov534: add framerate support
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

# HG changeset patch
# User jim@jtan.com
# Date 1228864404 18000
# Node ID 95986d276e158e35aae7b8640d9a411f781ca108
# Parent  c3eafdd5ba7cb667ed301e7feed6b02b57f1aa7a
gspca: ov534: add framerate support

Add support for getting and setting framerate via v4l2 controls,
rather than setting a fixed value at module insertion.

This allows, for example, luvcview to change the framerate:
  luvcview -i 30
  luvcview -i 50

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r c3eafdd5ba7c -r 95986d276e15 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Tue Dec 09 17:05:41 2008 -0500
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Dec 09 18:13:24 2008 -0500
@@ -43,14 +43,12 @@
 MODULE_DESCRIPTION("GSPCA/OV534 USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-/* global parameters */
-static int frame_rate;
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 	__u32 last_fid;
 	__u32 last_pts;
+	int frame_rate;
 };
 
 /* V4L2 controls supported by the driver */
@@ -296,6 +294,40 @@
 	{ 0x0c, 0xd0 }
 };
 
+/* set framerate */
+static void ov534_set_frame_rate(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int fr = sd->frame_rate;
+
+	switch (fr) {
+	case 50:
+		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
+		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
+		break;
+	case 40:
+		sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
+		sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
+		break;
+/*	case 30: */
+	default:
+		fr = 30;
+		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
+		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
+		break;
+	case 15:
+		sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
+		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
+		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
+		break;
+	}
+
+	sd->frame_rate = fr;
+	PDEBUG(D_PROBE, "frame_rate: %d", fr);
+}
 
 /* setup method */
 static void ov534_setup(struct usb_device *udev)
@@ -339,38 +371,8 @@
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	int fr;
-
 	ov534_setup(gspca_dev->dev);
-
-	fr = frame_rate;
-
-	switch (fr) {
-	case 50:
-		sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
-		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
-		break;
-	case 40:
-		sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
-		sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
-		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
-		break;
-/*	case 30: */
-	default:
-		fr = 30;
-		sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
-		sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
-		ov534_reg_write(gspca_dev->dev, 0xe5, 0x02);
-		break;
-	case 15:
-		sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
-		sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
-		ov534_reg_write(gspca_dev->dev, 0xe5, 0x04);
-		break;
-	}
-
-	PDEBUG(D_PROBE, "frame_rate: %d", fr);
+	ov534_set_frame_rate(gspca_dev);
 
 	return 0;
 }
@@ -477,6 +479,46 @@
 	goto scan_next;
 }
 
+/* get stream parameters (framerate) */
+int sd_get_streamparm(struct gspca_dev *gspca_dev,
+		      struct v4l2_streamparm *parm)
+{
+	struct v4l2_captureparm *cp = &parm->parm.capture;
+	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	
+	cp->capability |= V4L2_CAP_TIMEPERFRAME;
+	tpf->numerator = 1;
+	tpf->denominator = sd->frame_rate;
+
+	return 0;
+}
+
+/* set stream parameters (framerate) */
+int sd_set_streamparm(struct gspca_dev *gspca_dev,
+		      struct v4l2_streamparm *parm)
+{
+	struct v4l2_captureparm *cp = &parm->parm.capture;
+	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	/* Set requested framerate */
+	sd->frame_rate = tpf->denominator / tpf->numerator;
+	ov534_set_frame_rate(gspca_dev);
+
+	/* Return the actual framerate */
+	tpf->numerator = 1;
+	tpf->denominator = sd->frame_rate;
+
+	return 0;
+}
+
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name     = MODULE_NAME,
@@ -487,6 +529,8 @@
 	.start    = sd_start,
 	.stopN    = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
+	.get_streamparm = sd_get_streamparm,
+	.set_streamparm = sd_set_streamparm,
 };
 
 /* -- module initialisation -- */
@@ -534,6 +578,3 @@
 
 module_init(sd_mod_init);
 module_exit(sd_mod_exit);
-
-module_param(frame_rate, int, 0644);
-MODULE_PARM_DESC(frame_rate, "Frame rate (15, 30, 40, 50)");

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
