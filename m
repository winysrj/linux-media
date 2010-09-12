Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28457 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0ILRpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 13:45:35 -0400
Subject: [PATCH v2 2/3] gspca_cpia1: Restore QX3 illuminators' state on
 resume
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 13:45:18 -0400
Message-ID: <1284313518.2027.31.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Turn the lights of the QX3 on (or off) as needed when resuming and at module
load.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

diff -r f09faf8dd85d -r 5e576066eeaf linux/drivers/media/video/gspca/cpia1.c
--- a/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 12:43:45 2010 -0400
+++ b/linux/drivers/media/video/gspca/cpia1.c	Sun Sep 12 12:47:00 2010 -0400
@@ -1756,6 +1756,10 @@
 	if (ret)
 		return ret;
 
+	/* Ensure the QX3 illuminators' states are restored upon resume */
+	if (sd->params.qx3.qx3_detected)
+		command_setlights(gspca_dev);
+
 	sd_stopN(gspca_dev);
 
 	PDEBUG(D_PROBE, "CPIA Version:             %d.%02d (%d.%d)",







