Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2HGQm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:57 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 07/11] gspca: use %*ph to print small buffers
Date: Tue,  7 Aug 2012 19:43:07 +0300
Message-Id: <1344357792-18202-7-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/sq905c.c |    7 ++-----
 drivers/media/video/gspca/sq930x.c |   10 +---------
 drivers/media/video/gspca/vc032x.c |    7 ++-----
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index 2c2f3d2..70fae69 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -228,11 +228,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	}
 	/* Note we leave out the usb id and the manufacturing date */
 	PDEBUG(D_PROBE,
-	       "SQ9050 ID string: %02x - %02x %02x %02x %02x %02x %02x",
-		gspca_dev->usb_buf[3],
-		gspca_dev->usb_buf[14], gspca_dev->usb_buf[15],
-		gspca_dev->usb_buf[16], gspca_dev->usb_buf[17],
-		gspca_dev->usb_buf[18], gspca_dev->usb_buf[19]);
+	       "SQ9050 ID string: %02x - %*ph",
+		gspca_dev->usb_buf[3], 6, gspca_dev->usb_buf + 14);
 
 	cam->cam_mode = sq905c_mode;
 	cam->nmodes = 2;
diff --git a/drivers/media/video/gspca/sq930x.c b/drivers/media/video/gspca/sq930x.c
index 3e1e486..7e8748b 100644
--- a/drivers/media/video/gspca/sq930x.c
+++ b/drivers/media/video/gspca/sq930x.c
@@ -863,15 +863,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
  * 6: c8 / c9 / ca / cf = mode webcam?, sensor? webcam?
  * 7: 00
  */
-	PDEBUG(D_PROBE, "info: %02x %02x %02x %02x %02x %02x %02x %02x",
-			gspca_dev->usb_buf[0],
-			gspca_dev->usb_buf[1],
-			gspca_dev->usb_buf[2],
-			gspca_dev->usb_buf[3],
-			gspca_dev->usb_buf[4],
-			gspca_dev->usb_buf[5],
-			gspca_dev->usb_buf[6],
-			gspca_dev->usb_buf[7]);
+	PDEBUG(D_PROBE, "info: %*ph", 8, gspca_dev->usb_buf);
 
 	bridge_init(sd);
 
diff --git a/drivers/media/video/gspca/vc032x.c b/drivers/media/video/gspca/vc032x.c
index f21fd16..e500795 100644
--- a/drivers/media/video/gspca/vc032x.c
+++ b/drivers/media/video/gspca/vc032x.c
@@ -2934,11 +2934,8 @@ static void reg_r(struct gspca_dev *gspca_dev,
 		PDEBUG(D_USBI, "GET %02x 0001 %04x %02x", req, index,
 				gspca_dev->usb_buf[0]);
 	else
-		PDEBUG(D_USBI, "GET %02x 0001 %04x %02x %02x %02x",
-				req, index,
-				gspca_dev->usb_buf[0],
-				gspca_dev->usb_buf[1],
-				gspca_dev->usb_buf[2]);
+		PDEBUG(D_USBI, "GET %02x 0001 %04x %*ph",
+				req, index, 3, gspca_dev->usb_buf);
 #endif
 }
 
-- 
1.7.10.4

