Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60547 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316AbZJaXNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:13:24 -0400
Message-ID: <4AECC494.7050402@freemail.hu>
Date: Sun, 01 Nov 2009 00:13:24 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 01/21] gspca pac7302/pac7311: add prefix for sensor specific
 functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

There are some functions which are already sensor specific. Mark them
with pac7302_ or pac7311_ prefix

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN a/drivers/media/video/gspca/pac7311.c b/drivers/media/video/gspca/pac7311.c
--- a/drivers/media/video/gspca/pac7311.c	2009-10-30 16:12:05.000000000 +0100
+++ b/drivers/media/video/gspca/pac7311.c	2009-10-30 17:09:52.000000000 +0100
@@ -543,7 +543,7 @@ static int sd_config(struct gspca_dev *g
 }

 /* This function is used by pac7302 only */
-static void setbrightcont(struct gspca_dev *gspca_dev)
+static void pac7302_setbrightcont(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
@@ -570,7 +570,7 @@ static void setbrightcont(struct gspca_d
 }

 /* This function is used by pac7311 only */
-static void setcontrast(struct gspca_dev *gspca_dev)
+static void pac7311_setcontrast(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -581,7 +581,7 @@ static void setcontrast(struct gspca_dev
 }

 /* This function is used by pac7302 only */
-static void setcolors(struct gspca_dev *gspca_dev)
+static void pac7302_setcolors(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
@@ -700,11 +700,11 @@ static int sd_start(struct gspca_dev *gs

 	if (sd->sensor == SENSOR_PAC7302) {
 		reg_w_var(gspca_dev, start_7302);
-		setbrightcont(gspca_dev);
-		setcolors(gspca_dev);
+		pac7302_setbrightcont(gspca_dev);
+		pac7302_setcolors(gspca_dev);
 	} else {
 		reg_w_var(gspca_dev, start_7311);
-		setcontrast(gspca_dev);
+		pac7311_setcontrast(gspca_dev);
 	}
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
@@ -923,7 +923,7 @@ static int sd_setbrightness(struct gspca

 	sd->brightness = val;
 	if (gspca_dev->streaming)
-		setbrightcont(gspca_dev);
+		pac7302_setbrightcont(gspca_dev);
 	return 0;
 }

@@ -942,9 +942,9 @@ static int sd_setcontrast(struct gspca_d
 	sd->contrast = val;
 	if (gspca_dev->streaming) {
 		if (sd->sensor == SENSOR_PAC7302)
-			setbrightcont(gspca_dev);
+			pac7302_setbrightcont(gspca_dev);
 		else
-			setcontrast(gspca_dev);
+			pac7311_setcontrast(gspca_dev);
 	}
 	return 0;
 }
@@ -963,7 +963,7 @@ static int sd_setcolors(struct gspca_dev

 	sd->colors = val;
 	if (gspca_dev->streaming)
-		setcolors(gspca_dev);
+		pac7302_setcolors(gspca_dev);
 	return 0;
 }

