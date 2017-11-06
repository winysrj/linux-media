Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60049 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752109AbdKFKkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 05:40:22 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] media: rc: include <uapi/linux/lirc.h> rather than <media/lirc.h>
Date: Mon,  6 Nov 2017 10:40:17 +0000
Message-Id: <40b946f38a63673f3d9b267725481cc9cefb29d1.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
In-Reply-To: <cover.1509964131.git.sean@mess.org>
References: <cover.1509964131.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes the need for include/media/lirc.h, which just includes
the uapi file.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 2 +-
 include/media/lirc.h        | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)
 delete mode 100644 include/media/lirc.h

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 5c0e6a3ea3d4..24e0c56c9892 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -26,7 +26,7 @@
 #include <linux/wait.h>
 
 #include "rc-core-priv.h"
-#include <media/lirc.h>
+#include <uapi/linux/lirc.h>
 
 #define LOGHEAD		"lirc_dev (%s[%d]): "
 #define LIRCBUF_SIZE	256
diff --git a/include/media/lirc.h b/include/media/lirc.h
deleted file mode 100644
index 554988c860c1..000000000000
--- a/include/media/lirc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <uapi/linux/lirc.h>
-- 
2.13.6
