Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:46495 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZDBPa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 11:30:28 -0400
Received: by ti-out-0910.google.com with SMTP id i7so568253tid.23
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 08:30:26 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/9] V4L/DVB: usbvision: remove unused #include <version.h>
Date: Thu,  2 Apr 2009 23:30:19 +0800
Message-Id: <1238686219-1192-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <version.h> in 
drivers/media/video/usbvision/usbvision-i2c.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/usbvision/usbvision-i2c.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-i2c.c b/drivers/media/video/usbvision/usbvision-i2c.c
index dd2f8f2..3d82bb5 100644
--- a/drivers/media/video/usbvision/usbvision-i2c.c
+++ b/drivers/media/video/usbvision/usbvision-i2c.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-- 
1.6.0.4

