Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49314 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752341AbdIVRGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 13:06:16 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] spca500: Use common error handling code in
 spca500_synch310()
Message-ID: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net>
Date: Fri, 22 Sep 2017 19:06:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 22 Sep 2017 18:45:07 +0200

Adjust a jump target so that a bit of exception handling can be better
reused at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/spca500.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/gspca/spca500.c b/drivers/media/usb/gspca/spca500.c
index da2d9027914c..1f224f5e5b19 100644
--- a/drivers/media/usb/gspca/spca500.c
+++ b/drivers/media/usb/gspca/spca500.c
@@ -501,7 +501,6 @@ static int spca500_full_reset(struct gspca_dev *gspca_dev)
 static int spca500_synch310(struct gspca_dev *gspca_dev)
 {
-	if (usb_set_interface(gspca_dev->dev, gspca_dev->iface, 0) < 0) {
-		PERR("Set packet size: set interface error");
-		goto error;
-	}
+	if (usb_set_interface(gspca_dev->dev, gspca_dev->iface, 0) < 0)
+		goto report_failure;
+
 	spca500_ping310(gspca_dev);
@@ -514,12 +513,12 @@ static int spca500_synch310(struct gspca_dev *gspca_dev)
 	/* Windoze use pipe with altsetting 6 why 7 here */
-	if (usb_set_interface(gspca_dev->dev,
-				gspca_dev->iface,
-				gspca_dev->alt) < 0) {
-		PERR("Set packet size: set interface error");
-		goto error;
-	}
+	if (usb_set_interface(gspca_dev->dev, gspca_dev->iface, gspca_dev->alt)
+	    < 0)
+		goto report_failure;
+
 	return 0;
-error:
+
+report_failure:
+	PERR("Set packet size: set interface error");
 	return -EBUSY;
 }
 
-- 
2.14.1
