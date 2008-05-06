Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m46CxeEc024453
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 08:59:40 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m46CxSLu007836
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 08:59:29 -0400
Message-ID: <365592.144287319-sendEmail@carolinen>
From: "hbmeier@hni.uni-paderborn.de" <hbmeier@hni.uni-paderborn.de>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 6 May 2008 13:00:55 +0000 (GMT)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----MIME delimiter for sendEmail-713268.902692111"
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: [PATCH] Add x_skip_left to soc_camera_device
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

This is a multi-part message in MIME format. To properly display this message you need a MIME-Version 1.0 compliant Email program.

------MIME delimiter for sendEmail-713268.902692111
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Add x_skip_left to soc_camera_device and use it as "Beginning-of-Line
Pixel Clock Wait Count" in pxa_camera driver

Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
---
diff -r ead7cbcb4e49 linux/drivers/media/video/mt9m001.c
--- a/linux/drivers/media/video/mt9m001.c	Tue May 06 07:50:51 2008 -0300
+++ b/linux/drivers/media/video/mt9m001.c	Tue May 06 13:56:27 2008 +0200
@@ -649,18 +649,19 @@ static int mt9m001_probe(struct i2c_clie
 
 	/* Second stage probe - when a capture adapter is there */
 	icd = &mt9m001->icd;
-	icd->ops	= &mt9m001_ops;
-	icd->control	= &client->dev;
-	icd->x_min	= 20;
-	icd->y_min	= 12;
-	icd->x_current	= 20;
-	icd->y_current	= 12;
-	icd->width_min	= 48;
-	icd->width_max	= 1280;
-	icd->height_min	= 32;
-	icd->height_max	= 1024;
-	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
+	icd->ops = &mt9m001_ops;
+	icd->control = &client->dev;
+	icd->x_min = 20;
+	icd->y_min = 12;
+	icd->x_current = 20;
+	icd->y_current = 12;
+	icd->width_min = 48;
+	icd->width_max = 1280;
+	icd->height_min = 32;
+	icd->height_max = 1024;
+	icd->x_skip_left = 0;
+	icd->y_skip_top = 1;
+	icd->iface = icl->bus_id;
 	/* Default datawidth - this is the only width this camera (normally)
 	 * supports. It is only with extra logic that it can support
 	 * other widths. Therefore it seems to be a sensible default. */
diff -r ead7cbcb4e49 linux/drivers/media/video/mt9v022.c
--- a/linux/drivers/media/video/mt9v022.c	Tue May 06 07:50:51 2008 -0300
+++ b/linux/drivers/media/video/mt9v022.c	Tue May 06 13:56:26 2008 +0200
@@ -774,18 +774,19 @@ static int mt9v022_probe(struct i2c_clie
 	i2c_set_clientdata(client, mt9v022);
 
 	icd = &mt9v022->icd;
-	icd->ops	= &mt9v022_ops;
-	icd->control	= &client->dev;
-	icd->x_min	= 1;
-	icd->y_min	= 4;
-	icd->x_current	= 1;
-	icd->y_current	= 4;
-	icd->width_min	= 48;
-	icd->width_max	= 752;
-	icd->height_min	= 32;
-	icd->height_max	= 480;
-	icd->y_skip_top	= 1;
-	icd->iface	= icl->bus_id;
+	icd->ops = &mt9v022_ops;
+	icd->control = &client->dev;
+	icd->x_min = 1;
+	icd->y_min = 4;
+	icd->x_current = 1;
+	icd->y_current = 4;
+	icd->width_min = 48;
+	icd->width_max = 752;
+	icd->height_min = 32;
+	icd->height_max = 480;
+	icd->x_skip_left = 0;
+	icd->y_skip_top = 1;
+	icd->iface = icl->bus_id;
 	/* Default datawidth - this is the only width this camera (normally)
 	 * supports. It is only with extra logic that it can support
 	 * other widths. Therefore it seems to be a sensible default. */
diff -r ead7cbcb4e49 linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c	Tue May 06 07:50:51 2008 -0300
+++ b/linux/drivers/media/video/pxa_camera.c	Tue May 06 13:51:28 2008 +0200
@@ -883,7 +883,7 @@ static int pxa_camera_set_bus_param(stru
 	}
 
 	CICR1 = cicr1;
-	CICR2 = 0;
+	CICR2 = CICR2_BLW_VAL(min((unsigned short)255, icd->x_skip_left));
 	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
 		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
 	CICR4 = mclk_get_divisor(pcdev) | cicr4;
diff -r ead7cbcb4e49 linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h	Tue May 06 07:50:51 2008 -0300
+++ b/linux/include/media/soc_camera.h	Tue May 06 13:51:28 2008 +0200
@@ -29,6 +29,7 @@ struct soc_camera_device {
 	unsigned short width_max;
 	unsigned short height_min;
 	unsigned short height_max;
+	unsigned short x_skip_left;	/* Pixel to skip at the left */
 	unsigned short y_skip_top;	/* Lines to skip at the top */
 	unsigned short gain;
 	unsigned short exposure;


------MIME delimiter for sendEmail-713268.902692111
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------MIME delimiter for sendEmail-713268.902692111--
