Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3ICMbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Sep 2013 08:31:53 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] gspca: print small buffers via %*ph
Date: Tue,  3 Sep 2013 15:31:37 +0300
Message-Id: <1378211497-16482-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of passing each byte through stack let's use %*ph specifier to do this
job better.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/usb/gspca/sonixb.c      |  5 +----
 drivers/media/usb/gspca/xirlink_cit.c | 12 ++++--------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
index d7ff3b9..5e5613e 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -513,10 +513,7 @@ static void i2c_w(struct gspca_dev *gspca_dev, const u8 *buf)
 		if (gspca_dev->usb_buf[0] & 0x04) {
 			if (gspca_dev->usb_buf[0] & 0x08) {
 				dev_err(gspca_dev->v4l2_dev.dev,
-					"i2c error writing %02x %02x %02x %02x"
-					" %02x %02x %02x %02x\n",
-					buf[0], buf[1], buf[2], buf[3],
-					buf[4], buf[5], buf[6], buf[7]);
+					"i2c error writing %8ph\n", buf);
 				gspca_dev->usb_err = -EIO;
 			}
 			return;
diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index 7eaf64e..3beb351 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -2864,20 +2864,16 @@ static u8 *cit_find_sof(struct gspca_dev *gspca_dev, u8 *data, int len)
 				if (data[i] == 0xff) {
 					if (i >= 4)
 						PDEBUG(D_FRAM,
-						       "header found at offset: %d: %02x %02x 00 %02x %02x %02x\n",
+						       "header found at offset: %d: %02x %02x 00 %3ph\n",
 						       i - 1,
 						       data[i - 4],
 						       data[i - 3],
-						       data[i],
-						       data[i + 1],
-						       data[i + 2]);
+						       &data[i]);
 					else
 						PDEBUG(D_FRAM,
-						       "header found at offset: %d: 00 %02x %02x %02x\n",
+						       "header found at offset: %d: 00 %3ph\n",
 						       i - 1,
-						       data[i],
-						       data[i + 1],
-						       data[i + 2]);
+						       &data[i]);
 					return data + i + (sd->sof_len - 1);
 				}
 				break;
-- 
1.8.4.rc3

