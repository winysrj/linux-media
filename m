Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27401 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0ILRpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 13:45:31 -0400
Subject: [PATCH v2 1/3] gspca_cpia1: Add basic v4l2 illuminator controls
 for the Intel Play QX3
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 13:45:14 -0400
Message-ID: <1284313514.2027.30.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

gspca_cpia1: Add basic v4l2 illuminator controls for the Intel Play QX3

This patch add basic V4L2 controls for the illuminators on the Intel
Play QX3 microscope.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Hans de Goede <hdegoede@redhat.com>

diff -r 6e0befab696a -r d165649ca8a0 linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Fri Sep 03 00:28:05 2010 -0300
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 14:15:26 2010 -0400
@@ -373,6 +373,10 @@
 static int sd_getfreq(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcomptarget(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcomptarget(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setilluminator1(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getilluminator1(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setilluminator2(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getilluminator2(struct gspca_dev *gspca_dev, __s32 *val);
 
 static const struct ctrl sd_ctrls[] = {
 	{
@@ -434,6 +438,34 @@
 	},
 	{
 		{
+			.id	 = V4L2_CID_ILLUMINATORS_1,
+			.type    = V4L2_CTRL_TYPE_BOOLEAN,
+			.name    = "Illuminator 1",
+			.minimum = 0,
+			.maximum = 1,
+			.step    = 1,
+#define ILLUMINATORS_1_DEF 0
+			.default_value = ILLUMINATORS_1_DEF,
+		},
+		.set = sd_setilluminator1,
+		.get = sd_getilluminator1,
+	},
+	{
+		{
+			.id	 = V4L2_CID_ILLUMINATORS_2,
+			.type    = V4L2_CTRL_TYPE_BOOLEAN,
+			.name    = "Illuminator 2",
+			.minimum = 0,
+			.maximum = 1,
+			.step    = 1,
+#define ILLUMINATORS_2_DEF 0
+			.default_value = ILLUMINATORS_2_DEF,
+		},
+		.set = sd_setilluminator2,
+		.get = sd_getilluminator2,
+	},
+	{
+		{
 #define V4L2_CID_COMP_TARGET V4L2_CID_PRIVATE_BASE
 			.id	 = V4L2_CID_COMP_TARGET,
 			.type    = V4L2_CTRL_TYPE_MENU,
@@ -1059,7 +1091,6 @@
 			  0, sd->params.streamStartLine, 0, 0);
 }
 
-#if 0 /* Currently unused */ /* keep */
 static int command_setlights(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -1079,7 +1110,6 @@
 	return do_command(gspca_dev, CPIA_COMMAND_WriteMCPort, 2, 0,
 			  p1 | p2 | 0xE0, 0);
 }
-#endif
 
 static int set_flicker(struct gspca_dev *gspca_dev, int on, int apply)
 {
@@ -1932,6 +1962,72 @@
 	return 0;
 }
 
+static int sd_setilluminator(struct gspca_dev *gspca_dev, __s32 val, int n)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	if (!sd->params.qx3.qx3_detected)
+		return -EINVAL;
+
+	switch (n) {
+	case 1:
+		sd->params.qx3.bottomlight = val ? 1 : 0;
+		break;
+	case 2:
+		sd->params.qx3.toplight = val ? 1 : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = command_setlights(gspca_dev);
+	if (ret && ret != -EINVAL)
+		ret = -EBUSY;
+
+	return ret;
+}
+
+static int sd_setilluminator1(struct gspca_dev *gspca_dev, __s32 val)
+{
+	return sd_setilluminator(gspca_dev, val, 1);
+}
+
+static int sd_setilluminator2(struct gspca_dev *gspca_dev, __s32 val)
+{
+	return sd_setilluminator(gspca_dev, val, 2);
+}
+
+static int sd_getilluminator(struct gspca_dev *gspca_dev, __s32 *val, int n)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (!sd->params.qx3.qx3_detected)
+		return -EINVAL;
+
+	switch (n) {
+	case 1:
+		*val = sd->params.qx3.bottomlight;
+		break;
+	case 2:
+		*val = sd->params.qx3.toplight;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int sd_getilluminator1(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	return sd_getilluminator(gspca_dev, val, 1);
+}
+
+static int sd_getilluminator2(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	return sd_getilluminator(gspca_dev, val, 2);
+}
+
 static int sd_querymenu(struct gspca_dev *gspca_dev,
 			struct v4l2_querymenu *menu)
 {






