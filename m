Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55174 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0ESQop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:45 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGijOm026362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:45 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGii9S005463
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGiiUa013208
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 7/7] Support upto 1080p resolution for MMAP buffers DM365 capture
Date: Wed, 19 May 2010 11:44:38 -0500
Message-ID: <1274287478-14661-8-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-7-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
 <1274287478-14661-3-git-send-email-asheeshb@ti.com>
 <1274287478-14661-4-git-send-email-asheeshb@ti.com>
 <1274287478-14661-5-git-send-email-asheeshb@ti.com>
 <1274287478-14661-6-git-send-email-asheeshb@ti.com>
 <1274287478-14661-7-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

---
 drivers/media/video/davinci/vpfe_capture.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index c6eadba..f7f4041 100644
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

