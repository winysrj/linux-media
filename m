Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2955 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2EFM2n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/17] gscpa_zc3xx: Always automatically adjust BRC as needed
Date: Sun,  6 May 2012 14:28:25 +0200
Message-Id: <a3f202dc33d76e47c6f079f4ab75916c4f2946d8.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

Always automatically adjust the Bit Rate Control setting as needed, independent
of the sensor type. BRC is needed to not run out of bandwidth with higher
quality settings independent of the sensor.

Also only automatically adjust BRC, and don't adjust the JPEG quality control
automatically, as that is not needed and leads to ugly flashes when it is
changed. Note that before this patch-set the quality was never changed
either due to the bugs in the quality handling fixed in previous patches in
this set.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/zc3xx.c |  159 +++++++++++++------------------------
 1 file changed, 53 insertions(+), 106 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index f770676..18ef68d 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -5921,22 +5921,8 @@ static void setexposure(struct gspca_dev *gspca_dev)
 static void setquality(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	s8 reg07;
-
 	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08 >> 1]);
-
-	reg07 = 0;
-	switch (sd->sensor) {
-	case SENSOR_OV7620:
-		reg07 = 0x30;
-		break;
-	case SENSOR_HV7131R:
-	case SENSOR_PAS202B:
-		return;			/* done by work queue */
-	}
 	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
-	if (reg07 != 0)
-		reg_w(gspca_dev, reg07, 0x0007);
 }
 
 /* Matches the sensor's internal frame rate to the lighting frequency.
@@ -6070,109 +6056,62 @@ static void setautogain(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, autoval, 0x0180);
 }
 
-/* update the transfer parameters */
-/* This function is executed from a work queue. */
-/* The exact use of the bridge registers 07 and 08 is not known.
- * The following algorithm has been adapted from ms-win traces */
+/*
+ * Update the transfer parameters.
+ * This function is executed from a work queue.
+ */
 static void transfer_update(struct work_struct *work)
 {
 	struct sd *sd = container_of(work, struct sd, work);
 	struct gspca_dev *gspca_dev = &sd->gspca_dev;
 	int change, good;
-	u8 reg07, qual, reg11;
+	u8 reg07, reg11;
 
-	/* synchronize with the main driver and initialize the registers */
-	mutex_lock(&gspca_dev->usb_lock);
-	reg07 = 0;					/* max */
-	qual = sd->reg08 >> 1;
-	reg_w(gspca_dev, reg07, 0x0007);
-	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
-	mutex_unlock(&gspca_dev->usb_lock);
+	/* reg07 gets set to 0 by sd_start before starting us */
+	reg07 = 0;
 
 	good = 0;
 	for (;;) {
 		msleep(100);
 
-		/* get the transfer status */
-		/* the bit 0 of the bridge register 11 indicates overflow */
 		mutex_lock(&gspca_dev->usb_lock);
 		if (!gspca_dev->present || !gspca_dev->streaming)
 			goto err;
+
+		/* Bit 0 of register 11 indicates FIFO overflow */
+		gspca_dev->usb_err = 0;
 		reg11 = reg_r(gspca_dev, 0x0011);
-		if (gspca_dev->usb_err < 0
-		 || !gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->usb_err)
 			goto err;
 
 		change = reg11 & 0x01;
 		if (change) {				/* overflow */
-			switch (reg07) {
-			case 0:				/* max */
-				reg07 = sd->sensor == SENSOR_HV7131R
-						? 0x30 : 0x32;
-				if (qual != 0) {
-					change = 3;
-					qual--;
-				}
-				break;
-			case 0x32:
-				reg07 -= 4;
-				break;
-			default:
-				reg07 -= 2;
-				break;
-			case 2:
-				change = 0;		/* already min */
-				break;
-			}
 			good = 0;
+
+			if (reg07 == 0) /* Bit Rate Control not enabled? */
+				reg07 = 0x32; /* Allow 98 bytes / unit */
+			else if (reg07 > 2)
+				reg07 -= 2; /* Decrease allowed bytes / unit */
+			else
+				change = 0;
 		} else {				/* no overflow */
-			if (reg07 != 0) {		/* if not max */
-				good++;
-				if (good >= 10) {
-					good = 0;
+			good++;
+			if (good >= 10) {
+				good = 0;
+				if (reg07) { /* BRC enabled? */
 					change = 1;
-					reg07 += 2;
-					switch (reg07) {
-					case 0x30:
-						if (sd->sensor == SENSOR_PAS202B)
-							reg07 += 2;
-						break;
-					case 0x32:
-					case 0x34:
+					if (reg07 < 0x32)
+						reg07 += 2;
+					else
 						reg07 = 0;
-						break;
-					}
-				}
-			} else {			/* reg07 max */
-				if (qual < sizeof jpeg_qual - 1) {
-					good++;
-					if (good > 10) {
-						qual++;
-						change = 2;
-					}
 				}
 			}
 		}
 		if (change) {
-			if (change & 1) {
-				reg_w(gspca_dev, reg07, 0x0007);
-				if (gspca_dev->usb_err < 0
-				 || !gspca_dev->present
-				 || !gspca_dev->streaming)
-					goto err;
-			}
-			if (change & 2) {
-				sd->reg08 = (qual << 1) | 1;
-				reg_w(gspca_dev, sd->reg08,
-						ZC3XX_R008_CLOCKSETTING);
-				if (gspca_dev->usb_err < 0
-				 || !gspca_dev->present
-				 || !gspca_dev->streaming)
-					goto err;
-				sd->ctrls[QUALITY].val = jpeg_qual[qual];
-				jpeg_set_qual(sd->jpeg_hdr,
-						jpeg_qual[qual]);
-			}
+			gspca_dev->usb_err = 0;
+			reg_w(gspca_dev, reg07, 0x0007);
+			if (gspca_dev->usb_err)
+				goto err;
 		}
 		mutex_unlock(&gspca_dev->usb_lock);
 	}
@@ -6720,14 +6659,10 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	switch (sd->sensor) {
 	case SENSOR_HV7131R:
-		gspca_dev->ctrl_dis = (1 << QUALITY);
 		break;
 	case SENSOR_OV7630C:
 		gspca_dev->ctrl_dis = (1 << LIGHTFREQ) | (1 << EXPOSURE);
 		break;
-	case SENSOR_PAS202B:
-		gspca_dev->ctrl_dis = (1 << QUALITY) | (1 << EXPOSURE);
-		break;
 	default:
 		gspca_dev->ctrl_dis = (1 << EXPOSURE);
 		break;
@@ -6742,6 +6677,13 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	return gspca_dev->usb_err;
 }
 
+static int sd_pre_start(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	gspca_dev->cam.needs_full_bandwidth = (sd->reg08 >= 4) ? 1 : 0;
+	return 0;
+}
+
 static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -6867,6 +6809,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 	setquality(gspca_dev);
+	/* Start with BRC disabled, transfer_update will enable it if needed */
+	reg_w(gspca_dev, 0x00, 0x0007);
 	setlightfreq(gspca_dev);
 
 	switch (sd->sensor) {
@@ -6904,19 +6848,14 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	setautogain(gspca_dev);
 
-	/* start the transfer update thread if needed */
-	if (gspca_dev->usb_err >= 0) {
-		switch (sd->sensor) {
-		case SENSOR_HV7131R:
-		case SENSOR_PAS202B:
-			sd->work_thread =
-				create_singlethread_workqueue(KBUILD_MODNAME);
-			queue_work(sd->work_thread, &sd->work);
-			break;
-		}
-	}
+	if (gspca_dev->usb_err < 0)
+		return gspca_dev->usb_err;
 
-	return gspca_dev->usb_err;
+	/* Start the transfer parameters update thread */
+	sd->work_thread = create_singlethread_workqueue(KBUILD_MODNAME);
+	queue_work(sd->work_thread, &sd->work);
+
+	return 0;
 }
 
 /* called on streamoff with alt 0 and on disconnect */
@@ -7019,8 +6958,15 @@ static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 	 && i == qual
 	 && val < jpeg_qual[i])
 		i--;
+
+	/* With high quality settings we need max bandwidth */
+	if (i >= 2 && gspca_dev->streaming &&
+	    !gspca_dev->cam.needs_full_bandwidth)
+		return -EBUSY;
+
 	sd->reg08 = (i << 1) | 1;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
+
 	if (gspca_dev->streaming)
 		setquality(gspca_dev);
 	return gspca_dev->usb_err;
@@ -7070,6 +7016,7 @@ static const struct sd_desc sd_desc = {
 	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
+	.isoc_init = sd_pre_start,
 	.start = sd_start,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-- 
1.7.10

