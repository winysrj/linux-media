Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41321 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758715AbdEAQEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:50 -0400
Subject: [PATCH 14/16] lirc_dev: cleanup includes
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:47 +0200
Message-ID: <149365468723.12922.7216057583221400867.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove superfluous includes and defines.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 7db7d4c57991..4ba6c7e2d41b 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -15,20 +15,11 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/sched/signal.h>
-#include <linux/errno.h>
 #include <linux/ioctl.h>
-#include <linux/fs.h>
 #include <linux/poll.h>
-#include <linux/completion.h>
 #include <linux/mutex.h>
-#include <linux/wait.h>
-#include <linux/unistd.h>
-#include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
@@ -37,7 +28,6 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-#define IRCTL_DEV_NAME	"BaseRemoteCtl"
 #define LOGHEAD		"lirc_dev (%s[%d]): "
 
 static dev_t lirc_base_dev;
@@ -545,7 +535,7 @@ static int __init lirc_dev_init(void)
 	}
 
 	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
-				     IRCTL_DEV_NAME);
+				     "BaseRemoteCtl");
 	if (retval) {
 		class_destroy(lirc_class);
 		pr_err("alloc_chrdev_region failed\n");
