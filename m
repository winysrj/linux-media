Return-path: <linux-media-owner@vger.kernel.org>
Received: from s250.sam-solutions.net ([217.21.49.219]:49798 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3BFOzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 09:55:46 -0500
Message-ID: <511268BE.3020508@sam-solutions.net>
Date: Wed, 6 Feb 2013 17:29:18 +0300
From: Andrei Andreyanau <a.andreyanau@sam-solutions.net>
Reply-To: a.andreyanau@sam-solutions.net
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] [media] mt9v022 driver: send valid HORIZONTAL_BLANKING values
 to mt9v024 soc camera
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the issue that appears when mt9v024 camera is used with the
mt9v022 soc camera driver. The minimum total row time is 690 columns
(horizontal width + horizontal blanking). The minimum horizontal
blanking is 61. Thus, when the window width is set below 627, horizontal blanking must
be increased. For the mt9v024 camera the values above are correct and
for the mt9v022 camera the correct values are in the existing kernel driver.

Signed-off-by: Andrei Andreyanau <a.andreyanau@sam-solutions.net>
--- linux/drivers/media/i2c/soc_camera/mt9v022.c.orig	2013-02-06 15:43:35.522079869 +0300
+++ linux/drivers/media/i2c/soc_camera/mt9v022.c	2013-02-06 14:53:44.000000000 +0300
@@ -275,6 +275,7 @@ static int mt9v022_s_crop(struct v4l2_su
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	struct v4l2_rect rect = a->c;
+	int min_row, min_blank;
 	int ret;

 	/* Bayer format - even size lengths */
@@ -310,13 +311,21 @@ static int mt9v022_s_crop(struct v4l2_su
 		ret = reg_write(client, MT9V022_COLUMN_START, rect.left);
 	if (!ret)
 		ret = reg_write(client, MT9V022_ROW_START, rect.top);
+	/*
+	 * mt9v022: min total row time is 660 columns, min blanking is 43
+	 * mt9v024: min total row time is 690 columns, min blanking is 61
+	 */
+	if (is_mt9v024(mt9v022->chip_version)) {
+		min_row = 690;
+		min_blank = 61;
+	} else {
+		min_row = 660;
+		min_blank = 43;
+	}
 	if (!ret)
-		/*
-		 * Default 94, Phytec driver says:
-		 * "width + horizontal blank >= 660"
-		 */
 		ret = v4l2_ctrl_s_ctrl(mt9v022->hblank,
-				rect.width > 660 - 43 ? 43 : 660 - rect.width);
+				rect.width > min_row - min_blank ?
+				min_blank : min_row - rect.width);
 	if (!ret)
 		ret = v4l2_ctrl_s_ctrl(mt9v022->vblank, 45);
 	if (!ret)
