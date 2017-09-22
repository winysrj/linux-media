Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56632 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752520AbdIVP46 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 11:56:58 -0400
To: linux-media@vger.kernel.org, Brian Johnson <brijohn@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] sn9c20x: Use common error handling code in sd_init()
Message-ID: <6c54a84f-bf74-3e4f-eba4-6618dd9e388b@users.sourceforge.net>
Date: Fri, 22 Sep 2017 17:56:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 22 Sep 2017 17:45:33 +0200

Add jump targets so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/sn9c20x.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index c605f78d6186..282bbd77d815 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1788,10 +1788,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
 		value = bridge_init[i][1];
 		reg_w(gspca_dev, bridge_init[i][0], &value, 1);
-		if (gspca_dev->usb_err < 0) {
-			pr_err("Device initialization failed\n");
-			return gspca_dev->usb_err;
-		}
+		if (gspca_dev->usb_err < 0)
+			goto report_failure;
 	}
 
 	if (sd->flags & LED_REVERSE)
@@ -1800,10 +1798,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		reg_w1(gspca_dev, 0x1006, 0x20);
 
 	reg_w(gspca_dev, 0x10c0, i2c_init, 9);
-	if (gspca_dev->usb_err < 0) {
-		pr_err("Device initialization failed\n");
-		return gspca_dev->usb_err;
-	}
+	if (gspca_dev->usb_err < 0)
+		goto report_failure;
 
 	switch (sd->sensor) {
 	case SENSOR_OV9650:
@@ -1869,6 +1865,11 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		pr_err("Unsupported sensor\n");
 		gspca_dev->usb_err = -ENODEV;
 	}
+	goto exit;
+
+report_failure:
+	pr_err("Device initialization failed\n");
+exit:
 	return gspca_dev->usb_err;
 }
 
-- 
2.14.1
