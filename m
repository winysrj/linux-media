Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:42522 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZDBPdw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 11:33:52 -0400
Received: by ti-out-0910.google.com with SMTP id i7so569717tid.23
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 08:33:49 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/9] V4L/DVB: zr364xx: remove unused #include <version.h>
Date: Thu,  2 Apr 2009 23:30:26 +0800
Message-Id: <1238686226-1568-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <version.h> in drivers/media/video/zr364xx.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/zr364xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 221409f..ac169c9 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -26,7 +26,6 @@
  */
 
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/usb.h>
-- 
1.6.0.4

