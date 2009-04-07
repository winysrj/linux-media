Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:51228 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbZDGWuB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 18:50:01 -0400
Received: by ti-out-0910.google.com with SMTP id i7so2566237tid.23
        for <linux-media@vger.kernel.org>; Tue, 07 Apr 2009 15:50:00 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] V4L/DVB: cx231xx: remove unused #include <linux/version.h>'s
Date: Wed,  8 Apr 2009 06:49:46 +0800
Message-Id: <1239144586-1792-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>'s in
  drivers/media/video/cx231xx/cx231xx-avcore.c
  drivers/media/video/cx231xx/cx231xx-vbi.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-avcore.c |    1 -
 drivers/media/video/cx231xx/cx231xx-vbi.c    |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 1be3881..6a94640 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -29,7 +29,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/video/cx231xx/cx231xx-vbi.c
index 9418052..e97b802 100644
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -26,7 +26,6 @@
 #include <linux/bitmap.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 
-- 
1.6.0.4

