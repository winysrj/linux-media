Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:56962 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755300AbeDCMEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 08:04:54 -0400
From: "winton.liu" <18502523564@163.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "winton.liu" <18502523564@163.com>
Subject: [PATCH] media: gspca: fix Kconfig help info
Date: Tue,  3 Apr 2018 20:04:45 +0800
Message-Id: <1522757085-3099-1-git-send-email-18502523564@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation/video4linux/gspca.txt is missing.
It has moved to Documentation/media/v4l-drivers/gspca-cardlist.rst

Signed-off-by: winton.liu <18502523564@163.com>
---
 drivers/media/usb/gspca/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index d214a21..bc9a439 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -7,7 +7,7 @@ menuconfig USB_GSPCA
 	  Say Y here if you want to enable selecting webcams based
 	  on the GSPCA framework.
 
-	  See <file:Documentation/video4linux/gspca.txt> for more info.
+	  See <file:Documentation/media/v4l-drivers/gspca-cardlist.rst> for more info.
 
 	  This driver uses the Video For Linux API. You must say Y or M to
 	  "Video For Linux" to use this driver.
-- 
2.7.4
