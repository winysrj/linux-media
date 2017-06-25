Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56439 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMcW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:22 -0400
Subject: [PATCH 13/19] lirc_dev: remove the BUFLEN define
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:20 +0200
Message-ID: <149839394084.28811.5942756570190479247.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The define is only used in the lirc_zilog driver and once in lirc_dev.

In lirc_dev it rather serves to make the limits on d->code_length less clear,
so move the define to lirc_zilog.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c             |    5 ++---
 drivers/staging/media/lirc/lirc_zilog.c |    3 +++
 include/media/lirc_dev.h                |    2 --
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index d107ed6b634b..80944c2f7e91 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -145,9 +145,8 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EINVAL;
 	}
 
-	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
-		dev_err(d->dev, "code length must be less than %d bits\n",
-								BUFLEN * 8);
+	if (d->code_length < 1 || d->code_length > 128) {
+		dev_err(d->dev, "invalid code_length!\n");
 		return -EBADRQC;
 	}
 
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index a8aefd033ad9..f54b66de4a27 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -64,6 +64,9 @@
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
 
+/* LIRC buffer size */
+#define BUFLEN            16
+
 struct IR;
 
 struct IR_rx {
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 3f8edabfef88..21aac9494678 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -9,8 +9,6 @@
 #ifndef _LINUX_LIRC_DEV_H
 #define _LINUX_LIRC_DEV_H
 
-#define BUFLEN            16
-
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
