Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36487 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdBLGkA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 01:40:00 -0500
Received: by mail-pg0-f67.google.com with SMTP id 75so6595497pgf.3
        for <linux-media@vger.kernel.org>; Sat, 11 Feb 2017 22:40:00 -0800 (PST)
From: Chetan Sethi <cpsethi369@gmail.com>
To: jarod@wilsonet.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Chetan Sethi <cpsethi369@gmail.com>
Subject: [PATCH] staging: media: lirc: coding style fix use octal instead of symbolic permission
Date: Sun, 12 Feb 2017 15:39:42 +0900
Message-Id: <1486881582-21101-1-git-send-email-cpsethi369@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the lirc_sir.c file that fixes coding style warning
found by checkpatch.pl

Signed-off-by: Chetan Sethi <cpsethi369@gmail.com>
---
 drivers/staging/media/lirc/lirc_sir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index c75ae43..426753e 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -826,14 +826,14 @@ MODULE_AUTHOR("Milan Pikula");
 #endif
 MODULE_LICENSE("GPL");
 
-module_param(io, int, S_IRUGO);
+module_param(io, int, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
-module_param(irq, int, S_IRUGO);
+module_param(irq, int, 0444);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
-module_param(threshold, int, S_IRUGO);
+module_param(threshold, int, 0444);
 MODULE_PARM_DESC(threshold, "space detection threshold (3)");
 
-module_param(debug, bool, S_IRUGO | S_IWUSR);
+module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Enable debugging messages");
-- 
2.7.4
