Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62794 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2CPRuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 13:50:55 -0400
Received: by gghe5 with SMTP id e5so4452467ggh.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 10:50:55 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: jarod@redhat.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH v3] media: rc: Pospone ir raw decoders loading until really needed
Date: Fri, 16 Mar 2012 15:00:56 -0300
Message-Id: <1331920856-3371-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This changes rc_core to not load the IR decoders at load time,
postponing it to load only if a RC_DRIVER_IR_RAW device is registered
via rc_register_device.
We use a static boolean variable, to ensure decoders modules
are only loaded once.
Tested with rc-loopback device only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
v3: Fix scope of static bool: now it is local to relevant function.
v2: Fix broken logic in v1.
    Also, put raw_init as static instead of inside rc_dev
    struct to ensure loading is only tried the first time.
---
 drivers/media/rc/rc-main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f6a930b..6e16b09 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1029,6 +1029,7 @@ EXPORT_SYMBOL_GPL(rc_free_device);
 
 int rc_register_device(struct rc_dev *dev)
 {
+	static bool raw_init = false; /* raw decoders loaded? */
 	static atomic_t devno = ATOMIC_INIT(0);
 	struct rc_map *rc_map;
 	const char *path;
@@ -1103,6 +1104,12 @@ int rc_register_device(struct rc_dev *dev)
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
@@ -1176,8 +1183,6 @@ static int __init rc_core_init(void)
 		return rc;
 	}
 
-	/* Initialize/load the decoders/keymap code that will be used */
-	ir_raw_init();
 	rc_map_register(&empty_map);
 
 	return 0;
-- 
1.7.3.4

