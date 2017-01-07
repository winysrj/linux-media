Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33854 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbdAGDDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 22:03:06 -0500
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Derek Robson <robsonde@gmail.com>
Subject: [PATCH] Staging: media: lirc: style fix, using octal file permissions
Date: Sat,  7 Jan 2017 16:02:55 +1300
Message-Id: <20170107030255.19042-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change file permissions to octal style.
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 1e650fba4a92..6c8a4a15278e 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -182,7 +182,7 @@ MODULE_DESCRIPTION(MOD_DESC);
 MODULE_VERSION(MOD_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
-module_param(debug, int, S_IRUGO | S_IWUSR);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
 
 static void free_imon_context(struct imon_context *context)
-- 
2.11.0

