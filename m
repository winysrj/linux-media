Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48301 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751299AbdCYMC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:58 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/8] [media] staging: sir: remove unnecessary messages
Date: Sat, 25 Mar 2017 12:02:23 +0000
Message-Id: <6551179282c1336c80b47db119c127a0f4ae214d.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to warn when kmalloc fails.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 9b09c25..c9ca86f 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -63,8 +63,6 @@ static struct platform_device *sir_ir_dev;
 
 static DEFINE_SPINLOCK(hardware_lock);
 
-static bool debug;
-
 /* SECTION: Prototypes */
 
 /* Communication with user-space */
@@ -374,7 +372,6 @@ static int init_sir_ir(void)
 	if (retval < 0)
 		return retval;
 	init_hardware();
-	pr_info("Installed.\n");
 	return 0;
 }
 
@@ -407,24 +404,18 @@ static int __init sir_ir_init(void)
 	int retval;
 
 	retval = platform_driver_register(&sir_ir_driver);
-	if (retval) {
-		pr_err("Platform driver register failed!\n");
-		return -ENODEV;
-	}
+	if (retval)
+		return retval;
 
 	sir_ir_dev = platform_device_alloc("sir_ir", 0);
 	if (!sir_ir_dev) {
-		pr_err("Platform device alloc failed!\n");
 		retval = -ENOMEM;
 		goto pdev_alloc_fail;
 	}
 
 	retval = platform_device_add(sir_ir_dev);
-	if (retval) {
-		pr_err("Platform device add failed!\n");
-		retval = -ENODEV;
+	if (retval)
 		goto pdev_add_fail;
-	}
 
 	return 0;
 
@@ -441,7 +432,6 @@ static void __exit sir_ir_exit(void)
 	drop_port();
 	platform_device_unregister(sir_ir_dev);
 	platform_driver_unregister(&sir_ir_driver);
-	pr_info("Uninstalled.\n");
 }
 
 module_init(sir_ir_init);
@@ -459,6 +449,3 @@ MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
 module_param(threshold, int, 0444);
 MODULE_PARM_DESC(threshold, "space detection threshold (3)");
-
-module_param(debug, bool, 0644);
-MODULE_PARM_DESC(debug, "Enable debugging messages");
-- 
2.9.3
