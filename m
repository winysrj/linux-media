Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41438 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab0ILBvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 21:51:31 -0400
Subject: [PATCH 2/3] gspca_cpia1: Disable illuminator controls if not an
 Intel Play QX3
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 21:51:16 -0400
Message-ID: <1284256276.2030.19.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

gspca_cpia1: Disable illuminator controls if not an Intel Play QX3

The illuminator controls should only be available to the user for the Intel
Play QX3 microscope.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

diff -r d165649ca8a0 -r 32d5c323c541 linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 14:15:26 2010 -0400
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:15:03 2010 -0400
@@ -1743,6 +1743,22 @@
 	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 }
 
+static void sd_disable_qx3_ctrls(struct gspca_dev *gspca_dev)
+{
+	int i, n;
+	__u32 id;
+
+	n = ARRAY_SIZE(sd_ctrls);
+	for (i = 0; i < n; i++) {
+		id = sd_ctrls[i].qctrl.id;
+
+		if (id == V4L2_CID_ILLUMINATORS_1 ||
+		    id == V4L2_CID_ILLUMINATORS_2) {
+			gspca_dev->ctrl_dis |= (1 << i);
+		}
+	}
+}
+
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -1758,6 +1774,9 @@
 
 	sd_stopN(gspca_dev);
 
+	if (!sd->params.qx3.qx3_detected)
+		sd_disable_qx3_ctrls(gspca_dev);
+
 	PDEBUG(D_PROBE, "CPIA Version:             %d.%02d (%d.%d)",
 			sd->params.version.firmwareVersion,
 			sd->params.version.firmwareRevision,




