Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:62080 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab0DHL5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 07:57:32 -0400
Received: by qyk9 with SMTP id 9so2342082qyk.1
        for <linux-media@vger.kernel.org>; Thu, 08 Apr 2010 04:57:01 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 06/16] V4L/DVB: vpif: remove unused #include <linux/version.h>
Date: Thu,  8 Apr 2010 19:49:26 +0800
Message-Id: <1270727366-3848-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/video/davinci/vpif_capture.c
  drivers/media/video/davinci/vpif_display.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/davinci/vpif_capture.c |    1 -
 drivers/media/video/davinci/vpif_display.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 2e5a7fb..f74b551 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 13c3a1b..f8cd5e5 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 
 #include <asm/irq.h>
-- 
1.6.1.3

