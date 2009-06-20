Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:37840 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZFTLQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 07:16:46 -0400
Received: by pxi40 with SMTP id 40so468974pxi.33
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 04:16:49 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/4] V4L/DVB: remove unused #include <linux/version.h>
Date: Sat, 20 Jun 2009 19:16:37 +0800
Message-Id: <1245496597-1608-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>'s in
drivers/media/video/adv7343.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/adv7343.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/adv7343.c b/drivers/media/video/adv7343.c
index 30f5caf..df26f2f 100644
--- a/drivers/media/video/adv7343.c
+++ b/drivers/media/video/adv7343.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 #include <linux/videodev2.h>
 #include <linux/uaccess.h>
-#include <linux/version.h>
 
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
-- 
1.6.1.2

