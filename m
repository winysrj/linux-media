Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:46424 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965029AbeBMO7y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 09:59:54 -0500
Received: by mail-qk0-f195.google.com with SMTP id g129so8227633qkb.13
        for <linux-media@vger.kernel.org>; Tue, 13 Feb 2018 06:59:54 -0800 (PST)
From: Antonio Cardace <anto.cardace@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        Antonio Cardace <anto.cardace@gmail.com>
Subject: [PATCH v2] gspca: dtcs033: use %*ph to print small buffer
Date: Tue, 13 Feb 2018 14:59:39 +0000
Message-Id: <20180213145939.17061-1-anto.cardace@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use %*ph format to print small buffer as hex string.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Antonio Cardace <anto.cardace@gmail.com>
---
- don't do independent changes in one patch
---
 drivers/media/usb/gspca/dtcs033.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
index cdf27cf0112a..041d3c0e907d 100644
--- a/drivers/media/usb/gspca/dtcs033.c
+++ b/drivers/media/usb/gspca/dtcs033.c
@@ -76,12 +76,10 @@ static int reg_reqs(struct gspca_dev *gspca_dev,
 		} else if (preq->bRequestType & USB_DIR_IN) {
 
 			gspca_dbg(gspca_dev, D_STREAM,
-				  "USB IN (%d) returned[%d] %02X %02X %02X %s\n",
+				  "USB IN (%d) returned[%d] %3ph %s\n",
 				  i,
 				  preq->wLength,
-				  gspca_dev->usb_buf[0],
-				  gspca_dev->usb_buf[1],
-				  gspca_dev->usb_buf[2],
+				  gspca_dev->usb_buf,
 				  preq->wLength > 3 ? "...\n" : "\n");
 		}
 
-- 
2.15.1.354.g95ec6b1b3
