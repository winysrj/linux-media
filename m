Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52796 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbZJaXQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:16:31 -0400
Message-ID: <4AECC54C.3020108@freemail.hu>
Date: Sun, 01 Nov 2009 00:16:28 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 17/21] gspca pac7302/pac7311: separate format descriptors
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate supported format descriptors and supported resolutions.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN q/drivers/media/video/gspca/pac7311.c r/drivers/media/video/gspca/pac7311.c
--- q/drivers/media/video/gspca/pac7311.c	2009-10-31 08:26:17.000000000 +0100
+++ r/drivers/media/video/gspca/pac7311.c	2009-10-31 09:07:56.000000000 +0100
@@ -349,7 +349,15 @@ static struct ctrl pac7311_sd_ctrls[] =
 	},
 };

-static const struct v4l2_pix_format vga_mode[] = {
+static const struct v4l2_pix_format pac7302_vga_mode[] = {
+	{640, 480, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480 * 3 / 8 + 590,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0},
+};
+
+static const struct v4l2_pix_format pac7311_vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
 		.bytesperline = 160,
 		.sizeimage = 160 * 120 * 3 / 8 + 590,
@@ -642,8 +650,8 @@ static int pac7302_sd_config(struct gspc
 	cam = &gspca_dev->cam;

 	PDEBUG(D_CONF, "Find Sensor PAC7302");
-	cam->cam_mode = &vga_mode[2];	/* only 640x480 */
-	cam->nmodes = 1;
+	cam->cam_mode = pac7302_vga_mode;	/* only 640x480 */
+	cam->nmodes = ARRAY_SIZE(pac7302_vga_mode);

 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
@@ -666,8 +674,8 @@ static int pac7311_sd_config(struct gspc
 	cam = &gspca_dev->cam;

 	PDEBUG(D_CONF, "Find Sensor PAC7311");
-	cam->cam_mode = vga_mode;
-	cam->nmodes = ARRAY_SIZE(vga_mode);
+	cam->cam_mode = pac7311_vga_mode;
+	cam->nmodes = ARRAY_SIZE(pac7311_vga_mode);

 	sd->contrast = CONTRAST_DEF;
 	sd->gain = GAIN_DEF;
