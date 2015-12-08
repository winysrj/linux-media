Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34878 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbLHTgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 14:36:23 -0500
Received: by wmuu63 with SMTP id u63so194204328wmu.0
        for <linux-media@vger.kernel.org>; Tue, 08 Dec 2015 11:36:22 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 2/2] media: rc: improve lirc module detection
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5667312A.5030809@gmail.com>
Date: Tue, 8 Dec 2015 20:36:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve detection whether lirc codec is loaded and avoid dependency
on config symbols and having to check for a specific module.

This also fixes the bug that the current check checks for module
lirc_dev instead of ir_lirc_codec (which depends on lirc_dev).
If the ir_lirc_codec module is unloaded the check would still
return OK.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2: export an accessor instead of the variable
---
drivers/media/rc/ir-lirc-codec.c |  4 ++++
 drivers/media/rc/rc-main.c       | 24 ++++++++++--------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index a32659f..1f72bef 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -22,6 +22,8 @@
 
 #define LIRCBUF_SIZE 256
 
+extern void ir_raw_set_lirc_available(bool avail);
+
 /**
  * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
  *		      lircd userspace daemon for decoding.
@@ -398,6 +400,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 
 	dev->raw->lirc.drv = drv;
 	dev->raw->lirc.dev = dev;
+	ir_raw_set_lirc_available(true);
 	return 0;
 
 lirc_register_failed:
@@ -413,6 +416,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
+	ir_raw_set_lirc_available(false);
 	lirc_unregister_driver(lirc->drv->minor);
 	lirc_buffer_free(lirc->drv->rbuf);
 	kfree(lirc->drv);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1042fa3..600e9e9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -829,22 +829,18 @@ struct rc_filter_attribute {
 		.mask = (_mask),					\
 	}
 
-static bool lirc_is_present(void)
+static atomic_t lirc_available = ATOMIC_INIT(0);
+
+static inline bool lirc_is_present(void)
 {
-#if defined(CONFIG_LIRC_MODULE)
-	struct module *lirc;
-
-	mutex_lock(&module_mutex);
-	lirc = find_module("lirc_dev");
-	mutex_unlock(&module_mutex);
-
-	return lirc ? true : false;
-#elif defined(CONFIG_LIRC)
-	return true;
-#else
-	return false;
-#endif
+	return atomic_read(&lirc_available) != 0;
+}
+
+void ir_raw_set_lirc_available(bool avail)
+{
+	atomic_set(&lirc_available, avail);
 }
+EXPORT_SYMBOL(ir_raw_set_lirc_available);
 
 /**
  * show_protocols() - shows the current/wakeup IR protocol(s)
-- 
2.6.3


