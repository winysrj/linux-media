Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56436 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMcU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:20 -0400
Subject: [PATCH 12/19] lirc_dev: introduce lirc_allocate_device and
 lirc_free_device
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:15 +0200
Message-ID: <149839393575.28811.11742425812585187743.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce two new functions so that the API for lirc_dev matches that
of the rc-core and input subsystems.

This means that lirc_dev structs are managed using the usual four functions:
lirc_allocate_device
lirc_free_device
lirc_register_device
lirc_unregister_device

The functions are pretty simplistic at this point, later patches will put
more flesh on the bones of both.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |    2 +-
 drivers/media/rc/lirc_dev.c      |   13 +++++++++++++
 include/media/lirc_dev.h         |    9 ++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 2349630ed383..f276c4f56fb5 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -347,7 +347,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	int rc = -ENOMEM;
 	unsigned long features = 0;
 
-	ldev = kzalloc(sizeof(struct lirc_dev), GFP_KERNEL);
+	ldev = lirc_allocate_device();
 	if (!ldev)
 		return rc;
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 1c2f1a07bdaa..d107ed6b634b 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -101,6 +101,19 @@ static int lirc_allocate_buffer(struct irctl *ir)
 	return err;
 }
 
+struct lirc_dev *
+lirc_allocate_device(void)
+{
+	return kzalloc(sizeof(struct lirc_dev), GFP_KERNEL);
+}
+EXPORT_SYMBOL(lirc_allocate_device);
+
+void lirc_free_device(struct lirc_dev *d)
+{
+	kfree(d);
+}
+EXPORT_SYMBOL(lirc_free_device);
+
 int lirc_register_device(struct lirc_dev *d)
 {
 	struct irctl *ir;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 567959e9524f..3f8edabfef88 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -150,11 +150,10 @@ struct lirc_dev {
 	struct irctl *irctl;
 };
 
-/* following functions can be called ONLY from user context
- *
- * returns negative value on error or zero
- * contents of the structure pointed by p is copied
- */
+extern struct lirc_dev *lirc_allocate_device(void);
+
+extern void lirc_free_device(struct lirc_dev *d);
+
 extern int lirc_register_device(struct lirc_dev *d);
 
 extern void lirc_unregister_device(struct lirc_dev *d);
