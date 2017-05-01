Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41317 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756827AbdEAQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:46 -0400
Subject: [PATCH 11/16] lirc_dev: remove unused module parameter
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:31 +0200
Message-ID: <149365467192.12922.5242194857280280274.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "debug" parameter isn't actually used anywhere.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 34bd3f8bf30d..57d21201ff93 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -36,8 +36,6 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-static bool debug;
-
 #define IRCTL_DEV_NAME	"BaseRemoteCtl"
 #define NOPLUG		-1
 #define LOGHEAD		"lirc_dev (%s[%d]): "
@@ -625,6 +623,3 @@ module_exit(lirc_dev_exit);
 MODULE_DESCRIPTION("LIRC base driver module");
 MODULE_AUTHOR("Artur Lipowski");
 MODULE_LICENSE("GPL");
-
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Enable debugging messages");
