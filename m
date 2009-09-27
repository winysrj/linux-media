Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:48612 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZI0DQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 23:16:09 -0400
Received: by pxi32 with SMTP id 32so2724249pxi.4
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 20:16:13 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 1/4] V4L/DVB: DaVinci: remove unused #include <linux/version.h>
Date: Sun, 27 Sep 2009 11:16:10 +0800
Message-Id: <1254021370-2684-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/video/davinci/vpfe_capture.c
  drivers/media/video/davinci/vpif_capture.c
  drivers/media/video/davinci/vpif_display.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    1 -
 drivers/media/video/davinci/vpif_capture.c |    1 -
 drivers/media/video/davinci/vpif_display.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 402ce43..5c08ae2 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -70,7 +70,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <linux/io.h>
 #include <media/davinci/vpfe_capture.h>
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index d947ee5..5b494c5 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -33,7 +33,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index c015da8..1f232eb 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -29,7 +29,6 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/version.h>
 
 #include <asm/irq.h>
 #include <asm/page.h>
-- 
1.6.1.3

