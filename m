Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42794 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbeBLSgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 13:36:07 -0500
Received: by mail-wr0-f193.google.com with SMTP id k9so2432919wre.9
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 10:36:07 -0800 (PST)
From: Antonio Cardace <anto.cardace@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        Antonio Cardace <anto.cardace@gmail.com>
Subject: [PATCH] gspca: dtcs033: use %*ph to print small buffer
Date: Mon, 12 Feb 2018 18:35:25 +0000
Message-Id: <20180212183525.26413-1-anto.cardace@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use %*ph format to print small buffer as hex string.

Remove newline at the end of the format string as it would be duplicated
by the one supplied as last argument.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Antonio Cardace <anto.cardace@gmail.com>
---
 drivers/media/usb/gspca/dtcs033.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
index cdf27cf0112a..7654c8c08eda 100644
--- a/drivers/media/usb/gspca/dtcs033.c
+++ b/drivers/media/usb/gspca/dtcs033.c
@@ -76,12 +76,10 @@ static int reg_reqs(struct gspca_dev *gspca_dev,
 		} else if (preq->bRequestType & USB_DIR_IN) {
 
 			gspca_dbg(gspca_dev, D_STREAM,
-				  "USB IN (%d) returned[%d] %02X %02X %02X %s\n",
+				  "USB IN (%d) returned[%d] %3ph %s",
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
