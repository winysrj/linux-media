Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34529 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdCYTPY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 15:15:24 -0400
Received: by mail-qt0-f172.google.com with SMTP id n21so13312222qta.1
        for <linux-media@vger.kernel.org>; Sat, 25 Mar 2017 12:15:17 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] media: stk1160: Add Kconfig help on snd-usb-audio requirement
Date: Sat, 25 Mar 2017 16:14:15 -0300
Message-Id: <20170325191415.4661-1-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Kconfig currently makes no reference to the snd-usb-audio
driver, which supports audio capture for this type of devices.
Just in case, let's make sure the requirement is mentioned
in the description.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/usb/stk1160/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 22dff4f3b921..f1271295944e 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -6,7 +6,10 @@ config VIDEO_STK1160_COMMON
 	  This is a video4linux driver for STK1160 based video capture devices.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called stk1160
+	  module will be called stk1160.
+
+	  This driver only provides support for video capture. For audio capture,
+	  you need to select the snd-usb-audio driver (i.e. CONFIG_SND_USB_AUDIO).
 
 config VIDEO_STK1160
 	tristate
-- 
2.11.0
