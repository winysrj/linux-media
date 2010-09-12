Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42286 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442Ab0ILBvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 21:51:36 -0400
Subject: [PATCH 3/3] gspca_cpia1: Restore QX3 illuminators' state on resume
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 21:51:21 -0400
Message-ID: <1284256281.2030.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

gspca_cpia1: Restore QX3 illuminators' state on resume

Turn the lights of the QX3 on (or off) as needed when resuming and at module
load.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

diff -r 32d5c323c541 -r c2e7fb2d768e linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:15:03 2010 -0400
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sat Sep 11 21:32:35 2010 -0400
@@ -1772,6 +1772,10 @@
 	if (ret)
 		return ret;
 
+	/* Ensure the QX3 illuminators' states are restored upon resume */
+	if (sd->params.qx3.qx3_detected)
+		command_setlights(gspca_dev);
+
 	sd_stopN(gspca_dev);
 
 	if (!sd->params.qx3.qx3_detected)



