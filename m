Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34829 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdBKAmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 19:42:53 -0500
From: Derek Robson <robsonde@gmail.com>
To: jarod@wilsonet.com, mchehab@kernel.org, gregkh@linuxfoundation.org,
        namrataashettar@gmail.com, wsa-dev@sang-engineering.com,
        elise.lennion@gmail.com, robsonde@gmail.com,
        shailendra.v@samsung.com, sean@mess.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: lirc - style fix
Date: Sat, 11 Feb 2017 13:42:38 +1300
Message-Id: <20170211004238.5779-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed permissions to octal across whole driver
Found by checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 2 +-
 drivers/staging/media/lirc/lirc_sir.c   | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index b0c176e14b6b..ac69fe1e2d44 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -158,7 +158,7 @@ static int debug;
 MODULE_AUTHOR(MOD_AUTHOR);
 MODULE_DESCRIPTION(MOD_DESC);
 MODULE_LICENSE("GPL");
-module_param(debug, int, S_IRUGO | S_IWUSR);
+module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes (default: no)");
 
 static void delete_context(struct sasem_context *context)
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index c75ae43095ba..426753edac1c 100644
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
2.11.1

