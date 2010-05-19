Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51630 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab0ESP5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:57:36 -0400
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheesh@lab1.dmlab>
Subject: [PATCH 7/7] Patch MMAP buffer bufsize support upto 1080p resolution on capture driver DM365
Date: Wed, 19 May 2010 10:56:51 -0500
Message-ID: <1274284611-13432-7-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274284611-13432-6-git-send-email-asheeshb@ti.com>
References: <1274284611-13432-1-git-send-email-asheeshb@ti.com>
 <1274284611-13432-2-git-send-email-asheeshb@ti.com>
 <1274284611-13432-3-git-send-email-asheeshb@ti.com>
 <1274284611-13432-4-git-send-email-asheeshb@ti.com>
 <1274284611-13432-5-git-send-email-asheeshb@ti.com>
 <1274284611-13432-6-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheesh@lab1.dmlab>

---
 drivers/media/video/davinci/vpfe_capture.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index aeee5bb..112184d 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -80,12 +80,13 @@
 
 #include "ccdc_hw_device.h"
 
+#define HD_IMAGE_SIZE		(1920 * 1080 * 2)
 #define PAL_IMAGE_SIZE		(720 * 576 * 2)
 #define SECOND_IMAGE_SIZE_MAX	(640 * 480 * 2)
 
 static int debug;
 static u32 numbuffers = 3;
-static u32 bufsize = PAL_IMAGE_SIZE + SECOND_IMAGE_SIZE_MAX;
+static u32 bufsize = HD_IMAGE_SIZE + SECOND_IMAGE_SIZE_MAX;
 static int interface;
 static u32 cont_bufoffset = 0;
 static u32 cont_bufsize = 0;
@@ -109,7 +110,7 @@ module_param(cont_bufsize, uint, S_IRUGO);
  */
 MODULE_PARM_DESC(interface, "interface 0-1 (default:0)");
 MODULE_PARM_DESC(numbuffers, "buffer count (default:3)");
-MODULE_PARM_DESC(bufsize, "buffer size in bytes, (default:1443840 bytes)");
+MODULE_PARM_DESC(bufsize, "buffer size in bytes, (default:4147200 bytes)");
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 MODULE_PARM_DESC(cont_bufoffset,"Capture buffer offset(default 0)");
 MODULE_PARM_DESC(cont_bufsize,"Capture buffer size(default 0)");
@@ -141,8 +142,8 @@ struct ccdc_config {
 static struct vpfe_config_params config_params = {
 	.min_numbuffers = 3,
 	.numbuffers = 3,
-	.min_bufsize = 720 * 480 * 2,
-	.device_bufsize = 720 * 576 * 2,
+	.min_bufsize = 1280 * 720 * 2,
+	.device_bufsize = 1920* 1080 * 2,
 };
 
 /* ccdc device registered */
-- 
1.6.3.3

