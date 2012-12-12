Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36651 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2LLJFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 04:05:18 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so403167pad.19
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2012 01:05:17 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, mchehab@redhat.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 1/1] gspca: Use module_usb_driver macro
Date: Wed, 12 Dec 2012 14:28:12 +0530
Message-Id: <1355302692-28475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_usb_driver eliminates a lot of boilerplate by replacing
module_init() and module_exit() calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested with linux-next
---
 drivers/media/usb/gspca/jl2005bcd.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
index 62ba80d..fdaeeb1 100644
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -536,20 +536,4 @@ static struct usb_driver sd_driver = {
 #endif
 };
 
-/* -- module insert / remove -- */
-static int __init sd_mod_init(void)
-{
-	int ret;
-
-	ret = usb_register(&sd_driver);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
-static void __exit sd_mod_exit(void)
-{
-	usb_deregister(&sd_driver);
-}
-
-module_init(sd_mod_init);
-module_exit(sd_mod_exit);
+module_usb_driver(sd_driver);
-- 
1.7.4.1

