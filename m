Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29967 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab0ILRpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 13:45:41 -0400
Subject: [PATCH v2 3/3] gspca_cpia1: Disable illuminator controls if not an
 Intel Play QX3
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 13:45:21 -0400
Message-ID: <1284313521.2027.32.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The illuminator controls should only be available to the user for the Intel
Play QX3 microscope.  The implementation to inhibit the controls is intended to
be consistent with the other gspca driver implementations.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

diff -r 5e576066eeaf -r 8a9732bd1548 linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 12:47:00 2010 -0400
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 13:13:33 2010 -0400
@@ -380,6 +380,7 @@
 
 static const struct ctrl sd_ctrls[] = {
 	{
+#define BRIGHTNESS_IDX 0
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
@@ -394,6 +395,7 @@
 	    .set = sd_setbrightness,
 	    .get = sd_getbrightness,
 	},
+#define CONTRAST_IDX 1
 	{
 	    {
 		.id      = V4L2_CID_CONTRAST,
@@ -408,6 +410,7 @@
 	    .set = sd_setcontrast,
 	    .get = sd_getcontrast,
 	},
+#define SATURATION_IDX 2
 	{
 	    {
 		.id      = V4L2_CID_SATURATION,
@@ -422,6 +425,7 @@
 	    .set = sd_setsaturation,
 	    .get = sd_getsaturation,
 	},
+#define POWER_LINE_FREQUENCY_IDX 3
 	{
 		{
 			.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
@@ -436,6 +440,7 @@
 		.set = sd_setfreq,
 		.get = sd_getfreq,
 	},
+#define ILLUMINATORS_1_IDX 4
 	{
 		{
 			.id	 = V4L2_CID_ILLUMINATORS_1,
@@ -450,6 +455,7 @@
 		.set = sd_setilluminator1,
 		.get = sd_getilluminator1,
 	},
+#define ILLUMINATORS_2_IDX 5
 	{
 		{
 			.id	 = V4L2_CID_ILLUMINATORS_2,
@@ -464,6 +470,7 @@
 		.set = sd_setilluminator2,
 		.get = sd_getilluminator2,
 	},
+#define COMP_TARGET_IDX 6
 	{
 		{
 #define V4L2_CID_COMP_TARGET V4L2_CID_PRIVATE_BASE
@@ -1756,9 +1763,13 @@
 	if (ret)
 		return ret;
 
-	/* Ensure the QX3 illuminators' states are restored upon resume */
+	/* Ensure the QX3 illuminators' states are restored upon resume,
+	   or disable the illuminator controls, if this isn't a QX3 */
 	if (sd->params.qx3.qx3_detected)
 		command_setlights(gspca_dev);
+	else
+		gspca_dev->ctrl_dis |=
+			((1 << ILLUMINATORS_1_IDX) | (1 << ILLUMINATORS_2_IDX));
 
 	sd_stopN(gspca_dev);
 








