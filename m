Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53830 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161453Ab2COUnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 16:43:47 -0400
Received: by yenl12 with SMTP id l12so3500109yen.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 13:43:46 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: jarod@redhat.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH v2] media: rc: Pospone ir raw decoders loading until really needed
Date: Thu, 15 Mar 2012 17:53:49 -0300
Message-Id: <1331844829-1166-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This changes rc_core to not load the IR decoders at load time,
postponing it to load only if a RC_DRIVER_IR_RAW device is 
registered via rc_register_device.
We use a static boolean variable, to ensure decoders modules
are only loaded once.
Tested with rc-loopback device only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
v2: Fix broken logic in v1. 
    Also, put raw_init as static instead of inside rc_dev
    struct to ensure loading is only tried the first time.
---
 drivers/media/rc/rc-main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f6a930b..d366d53 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -32,6 +32,9 @@
 static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
+/* Used to load raw decoders modules only if needed */
+static bool raw_init;
+
 static struct rc_map_list *seek_rc_map(const char *name)
 {
 	struct rc_map_list *map = NULL;
@@ -1103,6 +1106,12 @@ int rc_register_device(struct rc_dev *dev)
 	kfree(path);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		/* Load raw decoders, if they aren't already */
+		if (!raw_init) {
+			IR_dprintk(1, "Loading raw decoders\n");
+			ir_raw_init();
+			raw_init = true;
+		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
 			goto out_input;
@@ -1176,8 +1185,6 @@ static int __init rc_core_init(void)
 		return rc;
 	}
 
-	/* Initialize/load the decoders/keymap code that will be used */
-	ir_raw_init();
 	rc_map_register(&empty_map);
 
 	return 0;
-- 
1.7.3.4

