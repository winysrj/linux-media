Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47023 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbeBROwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 09:52:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: rc: no need to announce major number
Date: Sun, 18 Feb 2018 14:52:05 +0000
Message-Id: <20180218145206.20800-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit a60d64b15c20 ("media: lirc: lirc interface should not be
a raw decoder"), the message in the documentation is incorrect as the
module name is rc_core, not lirc_dev. Since the message is not useful,
just make the message debug and remove it from the documentation.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-dev-intro.rst | 1 -
 drivers/media/rc/lirc_dev.c                    | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index 3a74fec66d69..698e4f80270e 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -18,7 +18,6 @@ Example dmesg output upon a driver registering w/LIRC:
 .. code-block:: none
 
     $ dmesg |grep lirc_dev
-    lirc_dev: IR Remote Control driver registered, major 248
     rc rc0: lirc_dev: driver mceusb registered at minor = 0
 
 What you should see for a chardev:
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index da3b5c095a59..24e9fbb80e81 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -804,8 +804,8 @@ int __init lirc_dev_init(void)
 		return retval;
 	}
 
-	pr_info("IR Remote Control driver registered, major %d\n",
-						MAJOR(lirc_base_dev));
+	pr_debug("IR Remote Control driver registered, major %d\n",
+		 MAJOR(lirc_base_dev));
 
 	return 0;
 }
-- 
2.14.3
